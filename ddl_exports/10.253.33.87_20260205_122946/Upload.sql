-- DDL Export
-- Server: 10.253.33.87
-- Database: Upload
-- Exported: 2026-02-05T12:29:51.806982

USE Upload;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_split
-- --------------------------------------------------
create FUNCTION [dbo].[fn_split](  
@delimited NVARCHAR(MAX),  
@delimiter NVARCHAR(100)  
) RETURNS @table TABLE (id INT IDENTITY(1,1), [value] NVARCHAR(MAX))  
AS  
BEGIN  
DECLARE @xml XML  
SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'  
INSERT INTO @table([value])  
SELECT r.value('.','Nvarchar(MAX)') as item  
FROM @xml.nodes('/t') as records(r)  
RETURN  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.fnSplitStringAsTable
-- --------------------------------------------------

CREATE FUNCTION [dbo].[fnSplitStringAsTable] 
(
    @inputString varchar(MAX),
    @delimiter char(1) = ','
)
RETURNS 
@Result TABLE 
(
    Value varchar(MAX)
)
AS
BEGIN
    DECLARE @chIndex int
    DECLARE @item varchar(100)

    -- While there are more delimiters...
    WHILE CHARINDEX(@delimiter, @inputString, 0) <> 0
        BEGIN
            -- Get the index of the first delimiter.
            SET @chIndex = CHARINDEX(@delimiter, @inputString, 0)

            -- Get all of the characters prior to the delimiter and insert the string into the table.
            SELECT @item = SUBSTRING(@inputString, 1, @chIndex - 1)

            IF LEN(@item) > 0
                BEGIN
                    INSERT INTO @Result(Value)
                    VALUES (@item)
                END

            -- Get the remainder of the string.
            SELECT @inputString = SUBSTRING(@inputString, @chIndex + 1, LEN(@inputString))
        END

    -- If there are still characters remaining in the string, insert them into the table.
    IF LEN(@inputString) > 0
        BEGIN
            INSERT INTO @Result(Value)
            VALUES (@inputString)
        END

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
-- PROCEDURE dbo.fileupload
-- --------------------------------------------------
--truncate table fileuploads_BK01
--truncate table fileuploads
--truncate table fileuploads_MG11

--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

CREATE proc [dbo].[fileupload]  
(  
 @fname varchar(200),
 @Segment varchar(50)
)  
as  

declare @filecount as int
declare @lastDate as datetime--,@filename varchar(20)

select @filecount= count(upload_dt) from fileuploads where 
segment=@Segment 
and
upload_dt in 
(
select upload_dt from fileuploads where segment
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 

)

set @lastdate = ( select upload_dt from fileuploads where segment
=@Segment 
 and
upload_dt in 
(
select upload_dt from fileuploads where segment 
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 
) )

declare @text varchar(max),@data varchar(max)
if(@Segment='NCDEX BK01')
begin
--declare @text varchar(max),@data varchar(max)
select @text=
coalesce(@text,'')+
replace([Transaction Recieved Date],' ','')+ Convert(char(1),',')+isnull([Transaction Code],' ') +Convert(char(1),',')
+replace([Transaction No.],' ','')+Convert(char(1),',')+replace([Description],' ','')+Convert(char(1),',')
+replace([Debit Amount],' ','')+Convert(char(1),',')+replace([Credit Amount],' ','')
+ char(10)
from fileuploads_BK01  
set @data= 'Transaction Recieved Date,Transaction Code,Transaction No.,Description,Debit Amount,Credit Amount' +char(10) + @text 
print @Segment
print @data
exec save_abl_details 'NCDEX_BK01','NCDEX_BK01',0

end
else if(@Segment='NCDEX MG11')
begin
print @Segment
select @text= coalesce(@text,'')+data +char(10) from fileuploads_MG11
set @data=@text
--print @data
exec save_ncdex_details 'NCDEX_A1'
end	
else
print 'Else'
--end

if (@filecount<>0)  
begin   
print 'I'
update fileuploads set data=@data ,filename=@fname, upload_dt=getdate() where segment=@segment and upload_dt = @lastdate
end  
else  
begin  
print 'U'
insert into fileuploads values(@data,getdate(),@fname,@segment)  
end  

--truncate table fileuploads 
--truncate table fileuploads_BK01
--truncate table fileuploads_MG11
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fileupload_Bkp02042019
-- --------------------------------------------------
--truncate table fileuploads_BK01
--truncate table fileuploads
--truncate table fileuploads_MG11

--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

CREATE proc [dbo].[fileupload_Bkp02042019]  
(  
 @fname varchar(200),
 @Segment varchar(50)
)  
as  

declare @filecount as int
declare @lastDate as datetime--,@filename varchar(20)

select @filecount= count(upload_dt) from fileuploads where 
segment=@Segment 
and
upload_dt in 
(
select upload_dt from fileuploads where segment
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 

)

set @lastdate = ( select upload_dt from fileuploads where segment
=@Segment 
 and
upload_dt in 
(
select upload_dt from fileuploads where segment 
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 
) )

declare @text varchar(max),@data varchar(max)
if(@Segment='NCDEX BK01')
begin
--declare @text varchar(max),@data varchar(max)
select @text=
coalesce(@text,'')+
replace([Transaction Recieved Date],' ','')+ Convert(char(1),',')+isnull([Transaction Code],' ') +Convert(char(1),',')
+replace([Transaction No.],' ','')+Convert(char(1),',')+replace([Description],' ','')+Convert(char(1),',')
+replace([Debit Amount],' ','')+Convert(char(1),',')+replace([Credit Amount],' ','')
+ char(10)
from fileuploads_BK01  
set @data= 'Transaction Recieved Date,Transaction Code,Transaction No.,Description,Debit Amount,Credit Amount' +char(10) + @text 
print @Segment
print @data
exec save_abl_details 'NCDEX_BK01','NCDEX_BK01',0

end
else if(@Segment='NCDEX MG11')
begin
print @Segment
select @text= coalesce(@text,'')+data +char(10) from fileuploads_MG11
set @data=@text
--print @data
exec save_ncdex_details 'NCDEX_A1'
end	
else
print 'Else'
--end

if (@filecount<>0)  
begin   
print 'I'
update fileuploads set data=@data ,filename=@fname, upload_dt=getdate() where segment=@segment and upload_dt = @lastdate
end  
else  
begin  
print 'U'
insert into fileuploads values(@data,getdate(),@fname,@segment)  
end  

--truncate table fileuploads 
--truncate table fileuploads_BK01
--truncate table fileuploads_MG11
  
return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fileupload_NCDEXBK01
-- --------------------------------------------------
--truncate table fileuploads_BK01
--truncate table fileuploads
--truncate table fileuploads_MG11

--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

CREATE proc [dbo].[fileupload_NCDEXBK01]  
(  
 @fname varchar(200),
 @Segment varchar(50)
)  
as  

declare @filecount as int
declare @lastDate as datetime

select @filecount= count(upload_dt) from fileuploads where 
segment=@Segment 
and
upload_dt in 
(
select upload_dt from fileuploads where segment
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4)
)

set @lastdate = ( select upload_dt from fileuploads where segment
=@Segment 
 and
upload_dt in 
(
select upload_dt from fileuploads where segment 
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
 like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4) 
) )

declare @text varchar(max),@data varchar(max)

select @text=
coalesce(@text,'')+
replace([Transaction Recieved Date],' ','')+ Convert(char(1),',')+isnull([Transaction Code],' ') +Convert(char(1),',')
+replace([Transaction No.],' ','')+Convert(char(1),',')+replace([Description],' ','')+Convert(char(1),',')
+replace([Debit Amount],' ','')+Convert(char(1),',')+replace([Credit Amount],' ','')
+ char(10)
from fileuploads_BK01  
set @data= 'Transaction Recieved Date,Transaction Code,Transaction No.,Description,Debit Amount,Credit Amount' +char(10) + @text 
--print @Segment
--print @data

if (@filecount<>0)  
begin   
print 'I'
update fileuploads set data=@data ,filename=@fname, upload_dt=getdate() where segment=@segment and upload_dt = @lastdate

--select @data, @fname,@segment,@lastdate
update [INTRANET].ROE.DBO.fileuploads set data=@data ,filename=@fname, upload_dt=getdate() where segment=@segment and upload_dt = @lastdate

exec save_abl_details @Segment,@Segment,0

end  
else  
begin  
print 'U'
insert into fileuploads values(@data,getdate(),@fname,@segment) 

insert into [INTRANET].ROE.DBO.fileuploads
select * from fileuploads where segment=@segment and cast(upload_dt as date) = cast(getdate() as date)

exec save_abl_details @Segment,@Segment,0 

end  

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fileupload_NCDEXMG11
-- --------------------------------------------------
--truncate table fileuploads_BK01
--truncate table fileuploads
--truncate table fileuploads_MG11
--truncate table ff_other_values
--exec fileupload  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'

--exec fileupload_NCDEXMG11  'NCDEX_BK01_00220_29032019', 'NCDEX BK01'
CREATE proc [dbo].[fileupload_NCDEXMG11]  
(  
 @fname varchar(200),
 @Segment varchar(50)
)  
as  

declare @filecount as int
declare @lastDate as datetime--,@filename varchar(20)

select @filecount= count(upload_dt) from fileuploads where 
segment=@Segment 
and
upload_dt in 
(
select upload_dt from fileuploads where segment
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4))

set @lastdate = ( select upload_dt from fileuploads where segment
=@Segment 
 and
upload_dt in 
(
select upload_dt from fileuploads where segment 
=@Segment
and 
substring(convert(varchar(30),upload_dt),0,charindex(convert(varchar(5),datepart(yyyy,upload_dt)),upload_dt)+4) 
like substring(convert(varchar(30),getdate()),0,charindex(convert(varchar(5),datepart(yyyy,getdate())),getdate())+4)))

declare @text varchar(max),@data varchar(max)
select @text= coalesce(@text,'')+data +char(10) from fileuploads_MG11
set @data=@text
--print @data
--exec save_ncdex_details 'NCDEX_A1'

if (@filecount<>0)  
begin   
print 'I'
update fileuploads set data=@data ,filename=@fname, upload_dt=getdate() where segment=@segment and upload_dt = @lastdate

--select @data, @fname,@segment,@lastdate
update [INTRANET].ROE.DBO.fileuploads set data=@data ,filename=@fname, upload_dt=getdate() where segment=@segment and upload_dt = @lastdate

exec save_ncdex_details @Segment

end  
else  
begin  
print 'U'
insert into fileuploads values(@data,getdate(),@fname,@segment)  

insert into [INTRANET].ROE.DBO.fileuploads
select * from fileuploads where segment=@segment and cast(upload_dt as date) = cast(getdate() as date)

exec save_ncdex_details @Segment

end  

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetEmployees
-- --------------------------------------------------
CREATE PROCEDURE GetEmployees
      @EmployeeIds VARCHAR(100)
AS
BEGIN
      SELECT FirstName, LastName
      FROM Employees
      WHERE EmployeeId IN(
            SELECT CAST(Item AS INTEGER)
            FROM dbo.SplitString(@EmployeeIds, ',')
      )
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetUploadPath
-- --------------------------------------------------

create proc GetUploadPath
@Srno as int
as
select uploadserver from global_upload where upd_srno = @Srno

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MTF_BSE_FileUpload
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[MTF_BSE_FileUpload]                              
@filename AS VARCHAR(50)                                    
--, @ErrorCode as int OUTPUT                                    
AS                                    
BEGIN TRY                                                           
 INSERT INTO General.dbo.MTF_BSE_REVERSEFILE                                  
 SELECT *,'',CONVERT(VARCHAR(11), GETDATE())                                  
 FROM MTF_BSE_REVERSEFILE 
 
 declare @File_date date,@HodlingDate date
 select @File_date=max([date]) from MTF_BSE_REVERSEFILE
 
 select @HodlingDate=cast(getdate() as date)
 
 if(@File_date=@HodlingDate)  
 begin                              
	 UPDATE  [squareoff].DBO.mtf_holding                             
	 SET ActualSqOffQty = b.qty  ,AvgRate=CONVERT(DECIMAL(15,2),CONVERT(DECIMAL(15, 2),B.rate)/100)                           
	 FROM             
	 (                            
	 SELECT A.cltcode,A.Scripname,A.qty ,A.rate,A.scripcode,[date]                                   
	 FROM                             
	 (                            
	 SELECT RTRIM(LTRIM(clientcode)) AS CltCode,ltrim(rtrim(Scripname)) as Scripname ,                                
	 sum(qty) as qty,(CONVERT(DECIMAL(10,2),avg(rate))) as rate ,scripcode , convert(varchar(11),[date],103) as [date]                        
	 FROM MTF_BSE_REVERSEFILE group by clientcode ,SCRIPNAME,convert(varchar(11),[date],103),scripcode                      
	 ) A                                  
	 GROUP BY cltcode,A.qty ,A.rate,A.scripcode,convert(varchar(11),[date],103),Scripname                             
	 ) B                                  
	 WHERE  [squareoff].DBO.mtf_holding.Party_code = B.cltcode and   [squareoff].DBO.mtf_holding.scrip_cd=B.scripcode                   
	 --and convert(varchar(11),b.[date],103)= convert(varchar(11), [squareoff].DBO.mtf_holding.processDate,103)      
	              
	 UPDATE  [squareoff].DBO.mtf_data                          
	 SET Actual_Cash_Square_Off_Done =(case when Actual_Cash_Square_Off_Done>0.00 then Actual_Cash_Square_Off_Done +B.Total else B.Total end)                               
	 FROM (SELECT cltcode,SUM(total) Total,convert(varchar(11),[date],103) as [date]                                   
	 FROM (SELECT RTRIM(LTRIM(clientcode)) AS CltCode,                                  
	 (qty * CONVERT(DECIMAL(15,2),CONVERT(DECIMAL(15, 2),rate)/100))AS Total ,[date]                                 
	 FROM MTF_BSE_REVERSEFILE ) A                                  
	 GROUP BY cltcode,convert(varchar(11),[date],103)) B                                  
	 WHERE  [squareoff].DBO.MTF_data.Party_code= B.cltcode                                   
	 and  [squareoff].DBO.MTF_data.NoofDays>=5 and processdate=(select max(processdate) from  [squareoff].DBO.mtf_data with (nolock))                     
	 --and convert(varchar(11),b.[date],103)= convert(varchar(11), [squareoff].DBO.MTF_data.processdate,103)                            
 end

--select * from  general.dbo.VMSS_data_combine where Actual_Cash_Square_Off_Done>0 and processdate='sep 09 2015' order by processdate  desc                                                   
END TRY                                   
BEGIN CATCH                                   
TRUNCATE TABLE MTF_BSE_REVERSEFILE                                    
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.MTF_NSE_FileUpload
-- --------------------------------------------------
                            
  
                            
  
CREATE  PROCEDURE [dbo].[MTF_NSE_FileUpload]                                
  
@filename AS VARCHAR(50)                                
  
--,@ErrorCode AS int OUTPUT                                
  
AS                                
  
BEGIN TRY                                
  
                              
  
INSERT INTO General.dbo.MTF_NSE_REVERSEFILE                                 
  
SELECT *,'',CONVERT(VARCHAR(11),GETDATE()) FROM MTF_NSE_REVERSEFILE                                
  
                          


declare @File_date date,@HodlingDate date
select @File_date=max([date]) from MTF_BSE_REVERSEFILE
 
select @HodlingDate=cast(getdate() as date)
 
if(@File_date=@HodlingDate)  
begin                          
	UPDATE  [squareoff].DBO.mtf_holding                               
	  
	SET ActualSqOffQty = b.Trade_Qty  ,AvgRate=B.rate                        
	  
	FROM                                
	  
	(SELECT Cltcode,A.Security_Symbol,A.Trade_Qty,A.rate,Trade_entry_Dt_Time                            
	  
	FROM                                
	  
	(            
	  
	SELECT                                
	  
	RTRIM(LTRIM(client_ac)) AS CltCode, ltrim(rtrim(Security_Symbol)) as Security_Symbol,                               
	  
	sum(Trade_Qty) as Trade_Qty,(CONVERT(DECIMAL(8,2),avg(Trade_Price))) as rate ,convert(varchar(11),Trade_entry_Dt_Time,103) as  Trade_entry_Dt_Time                            
	  
	FROM mtf_NSE_REVERSEFILE  group by client_ac,Security_Symbol,convert(varchar(11),Trade_entry_Dt_Time,103)            
	  
	) A                                
	  
	group by Cltcode,A.Trade_Qty,A.rate,convert(varchar(11),Trade_entry_Dt_Time,103),Security_Symbol            
	  
	) B                                
	  
	WHERE [squareoff].DBO.mtf_holding.party_code= B.Cltcode  and B.Security_Symbol=[squareoff].DBO.mtf_holding.scrip_cd                              
	  
	--and  general.dbo.Tbl_NBFC_Excess_ShortageSqOff.squareoffaction=7                        
	  
	--and convert(varchar(11),b.Trade_entry_Dt_Time,103)= convert(varchar(11), [squareoff].DBO.mtf_holding.processDate,103)                               
	
	                    
	  
	UPDATE  [squareoff].DBO.mtf_data                      
	  
	SET Actual_Cash_Square_Off_Done =(case when Actual_Cash_Square_Off_Done>0.00 then Actual_Cash_Square_Off_Done +B.Total else B.Total end)                              
	  
	FROM (SELECT cltcode,SUM(total) Total,Trade_entry_Dt_Time                               
	  
	FROM (SELECT RTRIM(LTRIM(client_ac)) AS CltCode,                        
	  
	(Trade_Qty*CONVERT(DECIMAL(15,2), Trade_Price)) AS Total                              
	  
	 ,convert(varchar(11),Trade_entry_Dt_Time,103) as  Trade_entry_Dt_Time                                 
	  
	FROM mtf_NSE_REVERSEFILE) A                              
	  
	GROUP BY cltcode,convert(varchar(11),A.Trade_entry_Dt_Time,103) ) B                              
	  
	WHERE [squareoff].DBO.mtf_data.Party_code= B.cltcode                               
	  
	and [squareoff].DBO.mtf_data.NoofDays>=5 and processdate=(select max(processdate) from  [squareoff].DBO.mtf_data with (nolock))             
	  
	--and convert(varchar(11),b.Trade_entry_Dt_Time,103)= convert(varchar(11),[squareoff].DBO.mtf_data.processdate,103)                        
end  
                             
  
END TRY                                
  
BEGIN CATCH                                
  
TRUNCATE TABLE mtf_NSE_REVERSEFILE                                
  
                              
  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileAutoUploadprocess
-- --------------------------------------------------
CREATE procedure [dbo].[proc_FileAutoUploadprocess] (@mode varchar(10)= null)  
as  
begin try  
      
    if(isnull(@mode,'')<>'process')  
    return;  
      
 if exists (select * from tbl_Fileprocess where cast(processDate as date) = CAST(GETDATE() as date))  
 begin   
  print 'Already Executed'  
 end  
 else  
 begin  
 print '25'
  insert into tbl_FileprocessHist (ProcessDate, FileId, ProcessStartAt, FileName, FileRowCount, ProcessEndAt, ProcessStatus, histDate)  
  select ProcessDate, FileId, ProcessStartAt, FileName, FileRowCount, ProcessEndAt, ProcessStatus, GETDATE() from tbl_Fileprocess  
  truncate table tbl_Fileprocess  
  insert into tbl_Fileprocess (ProcessDate, FileId, ProcessStatus)  
  select CAST(GETDATE() as date), Upd_Srno, 0  
  from tbl_AutomationUpladFile  
 end  
 if exists ( select * from tbl_Fileprocess where isnull(FileRowCount, 0) = 0 and cast(processDate as date) = CAST(GETDATE() as date))  
 begin  
  update a set ProcessStatus = 0 from tbl_Fileprocess a where isnull(FileRowCount, 0) = 0  
  declare @Fileid int = 0  
  while (1 = 1)  
  begin   
  
   Label1: 
  set @Fileid =(select top 1 Fileid from tbl_Fileprocess where isnull(FileRowCount, 0) = 0 and cast(processDate as date) = CAST(GETDATE() as date) and ProcessStatus <= 3)  
   if (isnull(@Fileid, 0) = 0)  
   begin  
    break  
   end  
   else  
   begin  
   print 'proc_FileUploadAutomation'
			begin try
			exec proc_FileUploadAutomation @Fileid  
			end try
			begin catch
			goto Label1;
			end catch 
   end  
  end  
  print 'process completed successfully'  
 end  
 exec proc_SendFileStatusOnMail  
end try  
begin catch  
 exec proc_SendFileStatusOnMail  
end catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileAutoUploadprocess_comm
-- --------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
--proc_FileAutoUploadprocess_comm 'process'  
CREATE procedure proc_FileAutoUploadprocess_comm (@mode varchar(10)= null)    
as    
begin try    
        
    if(isnull(@mode,'')<>'process')    
    return;   
 --print 'p'   
        
 if exists (select * from  tbl_Fileprocess_comm where cast(processDate as date) = CAST(GETDATE() as date))    
 begin     
  print 'Already Executed'    
  --return;  
 end    
 else    
 begin    
  insert into tbl_FileprocessHist_comm (ProcessDate, FileId, ProcessStartAt, FileName, FileRowCount, ProcessEndAt, ProcessStatus, histDate)    
  select ProcessDate, FileId, ProcessStartAt, FileName, FileRowCount, ProcessEndAt, ProcessStatus, GETDATE() from tbl_Fileprocess_comm    
  truncate table tbl_Fileprocess_comm    
  insert into tbl_Fileprocess_comm (ProcessDate, FileId, ProcessStatus)    
  select CAST(GETDATE() as date), Upd_Srno, 0    
  from tbl_AutomationFileUpload where upd_srno<>5   
 end    
 if exists ( select * from tbl_Fileprocess_comm where isnull(FileRowCount, 0) = 0 and cast(processDate as date) = CAST(GETDATE() as date))    
 begin    
  update a set ProcessStatus = 0 from tbl_Fileprocess_comm a where isnull(FileRowCount, 0) = 0    
  declare @Fileid int = 0    
  while (1 = 1)    
  begin     
    
   Label1:   
  set @Fileid =(select top 1 Fileid from tbl_Fileprocess_comm where isnull(FileRowCount, 0) = 0 and cast(processDate as date) = CAST(GETDATE() as date) and ProcessStatus <= 3)    
   if (isnull(@Fileid, 0) = 0)    
   begin    
    break    
   end    
   else    
   begin    
   begin try  
   exec proc_FileUploadAutomation_All @Fileid    
   end try  
   begin catch  
   goto Label1;  
   end catch   
   end    
  end    
  print 'process completed successfully'    
 end    
 exec proc_SendFileStatusOnMail_comm    
end try    
begin catch   
print 'Error'   
 exec proc_SendFileStatusOnMail_comm    
end catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileAutoUploadprocess_exposure
-- --------------------------------------------------
CREATE procedure [dbo].[proc_FileAutoUploadprocess_exposure] (@mode varchar(10)= null)  
as  
begin try    
 
 if(isnull(@mode,'')<>'process')  
 return;  
      
 --if exists (select * from tbl_Fileprocess_exposure where cast(processDate as date) = CAST(GETDATE() as date))  
 --begin   
 -- print 'Already Executed'  
 --end  
 --else  
 --begin  
 --print '25'
  insert into tbl_FileprocessHist (ProcessDate, FileId, ProcessStartAt, FileName, FileRowCount, ProcessEndAt, ProcessStatus, histDate)  
  select ProcessDate, FileId, ProcessStartAt, FileName, FileRowCount, ProcessEndAt, ProcessStatus, GETDATE() from tbl_Fileprocess  
  
  truncate table tbl_Fileprocess_exposure  
  insert into tbl_Fileprocess_exposure (ProcessDate, FileId, ProcessStatus)  
  select CAST(GETDATE() as date), Upd_Srno, 0  
  from tbl_AutomationUpladFile_exposure where  (Upd_Srno<=107 or Upd_Srno=117) and Upd_Srno<>104
 --end  
 if exists ( select * from tbl_Fileprocess_exposure where isnull(FileRowCount, 0) = 0 and cast(processDate as date) = CAST(GETDATE() as date))  
 begin  
  update a set ProcessStatus = 0 from tbl_Fileprocess_exposure a where isnull(FileRowCount, 0) = 0  
  declare @Fileid int = 0  
  while (1 = 1)  
  begin   
  
   Label1: 
  set @Fileid =(select top 1 Fileid from tbl_Fileprocess_exposure where isnull(FileRowCount, 0) = 0 and cast(processDate as date) = CAST(GETDATE() as date) and ProcessStatus <= 3)  
   if (isnull(@Fileid, 0) = 0)  
   begin  
    break  
   end  
   else  
   begin  
   print 'proc_FileUploadAutomation'
			begin try
			exec proc_FileUploadAutomation_exposure @Fileid
			
			insert into tbl_fileupload_test
			select @Fileid,'proc_FileUploadAutomation',getdate()

			end try
			begin catch
			goto Label1;
			end catch 
   end  
  end  
  print 'process completed successfully'  
 end  
 exec general.dbo.usp_equity_exposure_mailer
 --exec general.dbo.usp_currency_exposure_mailer
 exec general.dbo.usp_commodity_exposure_mailer 

end try  
begin catch  
 return
end catch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation
-- --------------------------------------------------
 --[proc_FileUploadAutomation] 26
CREATE proc [dbo].[proc_FileUploadAutomation](@upldsrno int)                              
as                              
begin                              
                             
Declare @Query varchar(max)=null;                    
Declare @Error int=0;                  
Declare @Count int=0;                   
                  
Declare @mUpd_TempTable varchar(100)=null;                              
Declare @mUpd_deli varchar(5)=null;                              
Declare @mUpd_FirstRow varchar(5)=null;                              
Declare @mUpd_FinSP varchar(50)=null;                              
Declare @FileLocation varchar(100)=null;                              
Declare @FileName varchar(1000)=null;                              
Declare @FileExtenstion varchar(10)=null;                              
Declare @FileSize numeric(18,2)=null                              
      
                              
select                                
@upldsrno=Upd_Srno ,                              
@mUpd_TempTable=Upd_TempTable,                              
@mUpd_deli=Upd_deli,                              
@mUpd_FirstRow=Upd_FirstRow,                              
@mUpd_FinSP=Upd_FinSP ,                              
@FileName=FileN ,                            
@FileExtenstion=Upd_Extension                              
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                               
                  
-- to get fileName                    
Declare  @tbl as  table (FileN varchar(200))                    
Insert into @tbl  execute('select '+ @FileName)                      
select  @FileName=FileN  from @tbl                     
                    
                    
if @upldsrno=101      
begin      
set @FileName= (select 'DerivativesMargin'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),2)       
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE())as a)      
end  


set @FileLocation ='H:\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                     
print @FileLocation                      
            
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess a  where fileid =@upldsrno                            
                            
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)   

if @upldsrno=108  
begin  
	set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',ROWTERMINATOR = ''0x0A'',KeepNULLS)';                  
	print @Query                              
	execute (@Query)                  
end  

if @upldsrno<>108  
begin                              
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                  
print @Query                              
execute (@Query)                  
end 

set @Error =@@ERROR                   
set @Count=1;                  
if(@Error<>0)                          
GOTO HANDLEERROR; 
                                   
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                               
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                              
                             
                              
set @Query ='update tbl_Fileprocess set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                            
print @Query                            
execute (@Query);                            
                  
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                              
print @Query                              
execute (@Query)                          
set @Error=@@ERROR                    
               
set @Count =2                      
if(@Error<>0)                          
GOTO HANDLEERROR;                            
                  
SET @Count =3;-- to default update                  
                  
HANDLEERROR:                  
IF @Count = 1                    
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                  
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                        
IF @Count = 2                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                  
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                        
IF @Count = 3         
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess a  where fileid =cast(@upldsrno as int)                   
            
            
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)             
            
                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_07062019
-- --------------------------------------------------
  
  
create proc [dbo].[proc_FileUploadAutomation_07062019](@upldsrno int)                            
as                            
begin                            
                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                  
                  
if @upldsrno=101    
begin    
set @FileName= (select 'DerivativesMargin'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),2)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE())as a)    
end                  
    
                  
set @FileLocation ='\\196.1.115.182\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
                  
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess a  where fileid =@upldsrno                          
                          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                          
                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)                
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
                  
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)           
          
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_All
-- --------------------------------------------------
--tbl_AutomationFileUpload
--proc_FileUploadAutomation_All
-- proc_FileAutoUploadprocess_comm 'Process'
-- truncate table fileuploads_BK01
-- truncate table fileuploads_MG11
 --fileuploads_BK01
--ContractFile_MCX
--ContractFile_NCDEX
--MCDX_Bhav_Copy
--NCDEX_Bhav_Copy
--ff_other_values order by datemodified desc
--proc_FileUploadAutomation_All 2

CREATE proc [dbo].[proc_FileUploadAutomation_All](@upldsrno int)                            
as                            
begin                            
--begin try 
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null;
declare @FileTitle varchar(50)=null;
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension,
@FileTitle=upd_Title                            
from tbl_AutomationFileUpload   where Upd_Srno=@upldsrno      

--set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''' + ', '''+ @FileTitle+'''';            
--print @Query

--Getting File Name
if @upldsrno>2    
begin
--set @FileName=@FileName +  REPLACE(CONVERT(varchar(10),DATEADD(DAY, 
--CASE DATENAME(WEEKDAY, GETDATE()) 
--WHEN 'Sunday' THEN -2 
--WHEN 'Monday' THEN -3 
--ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())),105),'-','') 
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                      
end 
--print @FileName
                  
if @upldsrno=6    
begin
--declare @FileName varchar(200) 
set @FileName= (select 'NCDEX_BK01_00220_'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),4)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE()-1)as a)    
--print @FileName
end
                  
set @FileLocation ='H:\Commodity\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                  
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,[FileName]=@FileName  from tbl_Fileprocess_comm a  where fileid =@upldsrno                          

set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)  
 
if @upldsrno=2  
begin   
declare @SQL varchar(max)=null; 
declare @date as varchar(11) =convert(datetime,getdate(),103)      
SET @SQL ='BULK INSERT temp_ncdex_bhav_copy FROM '''+@FileLocation+''' WITH (FIELDTERMINATOR = '','', FirstRow=2,KeepNULLS);              
drop table NCDEX_Bhav_Copy;              
select *,tdate='''+ @date +'''into NCDEX_Bhav_Copy from temp_ncdex_bhav_copy;
truncate table temp_ncdex_bhav_copy'             
print @SQL                    
exec (@SQL) 
end                        

if @upldsrno<>2 
begin                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',ROWTERMINATOR = ''0x0A'',KeepNULLS)';                
print @Query                            
execute (@Query)                
end
                    
insert into tbl_upload_info_comm (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                                                      
                            
set @Query ='update tbl_Fileprocess_comm set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);            

if(@upldsrno=6 or @upldsrno=7)
begin
set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''' + ', '''+ @FileTitle+'''';         
print @Query                            
execute (@Query)                        
end
else
begin
set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''';            
print @Query                            
execute (@Query) 
end
/*
set @Error=@@ERROR   
set @Count=2;
if(@Error<>0)                        
GOTO HANDLEERROR;   

SET @Count =3;-- to default update                
GOTO HANDLEERROR;
             
HANDLEERROR:                
IF @Count = 1  
Select 'Step 1'                
--INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
--select GETDATE(),'proc_FileUploadAutomation_All',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2 
Select 'Step 2'                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation_All',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3 
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_comm a  where fileid =cast(@upldsrno as int)                          
end 
--select * from general.dbo.EODBODDetail_Error where ErrObject='proc_FileUploadAutomation' order by errtime desc
*/
--end try                     
--begin catch                                                                            
-- insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                            
-- select GETDATE(),'proc_FileUploadAutomation_All',ERROR_LINE(),ERROR_MESSAGE()                                                                                                                   
-- DECLARE @ErrorMessage NVARCHAR(4000);                                                                            
-- SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                            
-- RAISERROR (@ErrorMessage , 16, 1);                                                                  
-- end catch; 

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_All_bkup_16102023
-- --------------------------------------------------

--tbl_AutomationFileUpload
--proc_FileUploadAutomation_All
-- proc_FileAutoUploadprocess_comm 'Process'
-- truncate table fileuploads_BK01
-- truncate table fileuploads_MG11
 --fileuploads_BK01
--ContractFile_MCX
--ContractFile_NCDEX
--MCDX_Bhav_Copy
--NCDEX_Bhav_Copy
--ff_other_values order by datemodified desc
--proc_FileUploadAutomation_All 7

CREATE proc [dbo].[proc_FileUploadAutomation_All_bkup_16102023](@upldsrno int)                            
as                            
begin                            
begin try 
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null;
declare @FileTitle varchar(50)=null;
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension,
@FileTitle=upd_Title                            
from tbl_AutomationFileUpload   where Upd_Srno=@upldsrno      

--set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''' + ', '''+ @FileTitle+'''';            
--print @Query

--Getting File Name
if @upldsrno>2    
begin
--set @FileName=@FileName +  REPLACE(CONVERT(varchar(10),DATEADD(DAY, 
--CASE DATENAME(WEEKDAY, GETDATE()) 
--WHEN 'Sunday' THEN -2 
--WHEN 'Monday' THEN -3 
--ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())),105),'-','') 
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                      
end 
--print @FileName
                  
if @upldsrno=6    
begin
--declare @FileName varchar(200) 
set @FileName= (select 'NCDEX_BK01_00220_'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),4)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE()-1)as a)    
--print @FileName
end
                  
set @FileLocation ='\\196.1.115.182\h\Commodity\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                  
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,[FileName]=@FileName  from tbl_Fileprocess_comm a  where fileid =@upldsrno                          

set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)  
 
if @upldsrno=2  
begin   
declare @SQL varchar(max)=null; 
declare @date as varchar(11) =convert(datetime,getdate(),103)      
SET @SQL ='BULK INSERT temp_ncdex_bhav_copy FROM '''+@FileLocation+''' WITH (FIELDTERMINATOR = '','', FirstRow=2,KeepNULLS);              
drop table NCDEX_Bhav_Copy;              
select *,tdate='''+ @date +'''into NCDEX_Bhav_Copy from temp_ncdex_bhav_copy;
truncate table temp_ncdex_bhav_copy'             
print @SQL                    
exec (@SQL) 
end                        

if @upldsrno<>2 
begin                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)                
end
/*               
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                                  
*/                        
insert into tbl_upload_info_comm (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                                                      
                            
set @Query ='update tbl_Fileprocess_comm set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);            

if(@upldsrno=6 or @upldsrno=7)
begin
set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''' + ', '''+ @FileTitle+'''';         
print @Query                            
execute (@Query)                        
end
else
begin
set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''';            
print @Query                            
execute (@Query) 
end
/*
set @Error=@@ERROR   
set @Count=2;
if(@Error<>0)                        
GOTO HANDLEERROR;   

SET @Count =3;-- to default update                
GOTO HANDLEERROR;
             
HANDLEERROR:                
IF @Count = 1  
Select 'Step 1'                
--INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
--select GETDATE(),'proc_FileUploadAutomation_All',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2 
Select 'Step 2'                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation_All',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3 
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_comm a  where fileid =cast(@upldsrno as int)                          
end 
--select * from general.dbo.EODBODDetail_Error where ErrObject='proc_FileUploadAutomation' order by errtime desc
*/
end try                     
begin catch                                                                            
 insert into general.dbo.EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)                                                                            
 select GETDATE(),'proc_FileUploadAutomation_All',ERROR_LINE(),ERROR_MESSAGE()                                                                                                                   
 DECLARE @ErrorMessage NVARCHAR(4000);                                                                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                                            
 RAISERROR (@ErrorMessage , 16, 1);                                                                  
 end catch; 

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_All_bkup15052019
-- --------------------------------------------------
--tbl_AutomationFileUpload
--proc_FileUploadAutomation_All
-- proc_FileAutoUploadprocess_comm 'Process'
-- truncate table fileuploads_BK01
-- truncate table fileuploads_MG11
 --fileuploads_BK01
--ContractFile_MCX
--ContractFile_NCDEX
--MCDX_Bhav_Copy
--NCDEX_Bhav_Copy
--ff_other_values order by datemodified desc
--proc_FileUploadAutomation_All 7

create proc [dbo].[proc_FileUploadAutomation_All_bkup15052019](@upldsrno int)                            
as                            
begin                            

Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null;
declare @FileTitle varchar(50)=null;
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension,
@FileTitle=upd_Title                            
from tbl_AutomationFileUpload   where Upd_Srno=@upldsrno      

--set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''' + ', '''+ @FileTitle+'''';            
--print @Query

--Getting File Name
if @upldsrno>2    
begin
--set @FileName=@FileName +  REPLACE(CONVERT(varchar(10),DATEADD(DAY, 
--CASE DATENAME(WEEKDAY, GETDATE()) 
--WHEN 'Sunday' THEN -2 
--WHEN 'Monday' THEN -3 
--ELSE -1 END, DATEDIFF(DAY, 0, GETDATE())),105),'-','') 
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                      
end 
--print @FileName
                  
if @upldsrno=6    
begin
--declare @FileName varchar(200) 
set @FileName= (select 'NCDEX_BK01_00220_'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),4)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE()-1)as a)    
--print @FileName
end
                  
set @FileLocation ='\\196.1.115.182\h\Commodity\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                  
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,[FileName]=@FileName  from tbl_Fileprocess_comm a  where fileid =@upldsrno                          

set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)  
 
if @upldsrno=2  
begin   
declare @SQL varchar(max)=null; 
declare @date as varchar(11) =convert(datetime,getdate(),103)      
SET @SQL ='BULK INSERT temp_ncdex_bhav_copy FROM '''+@FileLocation+''' WITH (FIELDTERMINATOR = '','', FirstRow=2,KeepNULLS);              
drop table NCDEX_Bhav_Copy;              
select *,tdate='''+ @date +'''into NCDEX_Bhav_Copy from temp_ncdex_bhav_copy;
truncate table temp_ncdex_bhav_copy'             
print @SQL                    
exec (@SQL) 
end                        

if @upldsrno<>2 
begin                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)                
end
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                                  
                           
insert into tbl_upload_info_comm (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                                                      
                            
set @Query ='update tbl_Fileprocess_comm set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);            

if(@upldsrno=6 or @upldsrno=7)
begin
set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''' + ', '''+ @FileTitle+'''';         
print @Query                            
execute (@Query)                        
end
else
begin
set @Query ='exec '+@mUpd_FinSP +'  '''+@Filename+'''';            
print @Query                            
execute (@Query) 
end

set @Error=@@ERROR   
set @Count=2;
if(@Error<>0)                        
GOTO HANDLEERROR;   

SET @Count =3;-- to default update                
GOTO HANDLEERROR;
             
HANDLEERROR:                
IF @Count = 1  
Select 'Step 1'                
--INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
--select GETDATE(),'proc_FileUploadAutomation_All',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2 
Select 'Step 2'                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation_All',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3 
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_comm a  where fileid =cast(@upldsrno as int)                          
end 
--select * from general.dbo.EODBODDetail_Error where ErrObject='proc_FileUploadAutomation' order by errtime desc

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_back_07062019
-- --------------------------------------------------

  
  
CREATE proc [dbo].[proc_FileUploadAutomation_back_07062019](@upldsrno int)                            
as                            
begin                            
  
  
--Declare  @upldsrno int 
--set @upldsrno=3                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   

if @upldsrno=3
begin 
	set @FileLocation ='\\196.1.115.182\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion)); 
    truncate table tbl_data
	set @Query='bulk insert tbl_data from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',ROWTERMINATOR = ''NORMAL'',TABLOCK)';                
	print @Query                            
	execute (@Query) 
	UPDATE tbl_data SET DATA='NORMAL'+DATA
	declare @file2 varchar(500),@SQL as varchar(max)
	--set   @file2=SUBSTRING(REPLACE(CONVERT(varchar(10),GETDATE(),105),'-',''),1,4)+RIGHT(CONVERT(VARCHAR(4),YEAR(GETDATE())),1)+'000'                
    SET @SQL = ''                              
	SET @SQL = ' bcp " SELECT * FROM [196.1.115.182].upload.dbo.tbl_data where data is not NULL'                              
	SET @SQL = @SQL + ' " queryout H:\EXCHANGEFILES\' + ltrim(rtrim(@FileName+@FileExtenstion)) + ' -c -Sintranet -Uinhouse -Pinh6014 '                                 
	SET @SQL = '''' + @SQL + ''''                              
	SET @SQL = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @SQL                              
  
    PRINT @SQL                              
	EXEC (@SQL)   
  end 
                   
                  
if @upldsrno=101    
begin    
set @FileName= (select 'DerivativesMargin'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),2)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE())as a)    
end                  
    
                  
set @FileLocation ='\\196.1.115.182\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
                  
--Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess a  where fileid =@upldsrno                          
                          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                          
                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)                
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
                  
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_bkup_03062019
-- --------------------------------------------------
  
  
create proc [dbo].[proc_FileUploadAutomation_bkup_03062019](@upldsrno int)                            
as                            
begin                            
                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                  
                  
if @upldsrno=101    
begin    
set @FileName= (select 'DerivativesMargin'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),2)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE())as a)    
end                  
    
                  
set @FileLocation ='\\196.1.115.182\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
                  
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess a  where fileid =@upldsrno                          
                          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                          
                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)                
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
                  
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)           
          
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_exposure
-- --------------------------------------------------
    --[proc_FileUploadAutomation_exposure] 104
CREATE proc [dbo].[proc_FileUploadAutomation_exposure](@upldsrno int)                              
as                              
begin                              
                             
Declare @Query varchar(max)=null;                    
Declare @Error int=0;                  
Declare @Count int=0;                   
                  
Declare @mUpd_TempTable varchar(100)=null;                              
Declare @mUpd_deli varchar(5)=null;                              
Declare @mUpd_FirstRow varchar(5)=null;                              
Declare @mUpd_FinSP varchar(50)=null;                              
Declare @FileLocation varchar(100)=null;                              
Declare @FileName varchar(1000)=null;                              
Declare @FileExtenstion varchar(10)=null;                              
Declare @FileSize numeric(18,2)=null                              
      
                              
select                                
@upldsrno=Upd_Srno ,                              
@mUpd_TempTable=Upd_TempTable,                              
@mUpd_deli=Upd_deli,                              
@mUpd_FirstRow=Upd_FirstRow,                              
@mUpd_FinSP=Upd_FinSP ,                              
@FileName=FileN ,                            
@FileExtenstion=Upd_Extension                              
from tbl_AutomationUpladFile_exposure   where Upd_Srno=@upldsrno                               
                  
-- to get fileName                    
Declare  @tbl as  table (FileN varchar(200))                    
Insert into @tbl  execute('select '+ @FileName)                      
select  @FileName=FileN  from @tbl                     
                    
              
set @FileLocation ='\\INHOUSELIVEAPP2-FS.angelone.in\\nrms\Exposure file\'+ltrim(rtrim(@FileName+@FileExtenstion));                     
print @FileLocation                      
                           
            
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess_exposure a  where fileid =@upldsrno                            
                            
      
                        
if(@upldsrno=110)  
begin    
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''')';                  
print @Query                              
execute (@Query)    
end        
else if(@upldsrno=104)  
begin    
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',ROWTERMINATOR = ''0x0A'',FIELDTERMINATOR = '''+@mUpd_deli+''')';                  
print @Query                              
execute (@Query)    
end         
else   
begin   
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                  
print @Query                              
execute (@Query)  
end          
                  
set @Error =@@ERROR                   
set @Count=1;                  
if(@Error<>0)                          
GOTO HANDLEERROR;                     
                    
                             
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                               
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                              
                             
                              
set @Query ='update tbl_Fileprocess_exposure set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                            
print @Query                            
execute (@Query);                            
                  
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                              
print @Query                              
execute (@Query)                          
set @Error=@@ERROR                    
               
set @Count =2                      
if(@Error<>0)                          
GOTO HANDLEERROR;                            
                  
SET @Count =3;-- to default update                  
                  
HANDLEERROR:                  
IF @Count = 1                    
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                  
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                        
IF @Count = 2                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                  
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                        
IF @Count = 3         
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_exposure a  where fileid =cast(@upldsrno as int)                   
            
            
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)             
            
                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_exposure_bkuppublic01092022
-- --------------------------------------------------
    
CREATE proc [dbo].[proc_FileUploadAutomation_exposure_bkuppublic01092022](@upldsrno int)                              
as                              
begin                              
                             
Declare @Query varchar(max)=null;                    
Declare @Error int=0;                  
Declare @Count int=0;                   
                  
Declare @mUpd_TempTable varchar(100)=null;                              
Declare @mUpd_deli varchar(5)=null;                              
Declare @mUpd_FirstRow varchar(5)=null;                              
Declare @mUpd_FinSP varchar(50)=null;                              
Declare @FileLocation varchar(100)=null;                              
Declare @FileName varchar(1000)=null;                              
Declare @FileExtenstion varchar(10)=null;                              
Declare @FileSize numeric(18,2)=null                              
      
                              
select                                
@upldsrno=Upd_Srno ,                              
@mUpd_TempTable=Upd_TempTable,                              
@mUpd_deli=Upd_deli,                              
@mUpd_FirstRow=Upd_FirstRow,                              
@mUpd_FinSP=Upd_FinSP ,                              
@FileName=FileN ,                            
@FileExtenstion=Upd_Extension                              
from tbl_AutomationUpladFile_exposure   where Upd_Srno=@upldsrno                               
                  
-- to get fileName                    
Declare  @tbl as  table (FileN varchar(200))                    
Insert into @tbl  execute('select '+ @FileName)                      
select  @FileName=FileN  from @tbl                     
                    
              
set @FileLocation ='\\172.29.19.16\Public\Exposure File\'+ltrim(rtrim(@FileName+@FileExtenstion));                     
print @FileLocation                      
                           
            
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess_exposure a  where fileid =@upldsrno                            
                            
      
                        
if(@upldsrno=110)  
begin    
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''')';                  
print @Query                              
execute (@Query)    
end         
else   
begin   
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                  
print @Query                              
execute (@Query)  
end          
                  
set @Error =@@ERROR                   
set @Count=1;                  
if(@Error<>0)                          
GOTO HANDLEERROR;                     
                    
                             
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                               
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                              
                             
                              
set @Query ='update tbl_Fileprocess_exposure set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                            
print @Query                            
execute (@Query);                            
                  
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                              
print @Query                              
execute (@Query)            
set @Error=@@ERROR                    
               
set @Count =2                      
if(@Error<>0)                          
GOTO HANDLEERROR;                            
                  
SET @Count =3;-- to default update                  
                  
HANDLEERROR:                  
IF @Count = 1                    
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                  
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                        
IF @Count = 2                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                  
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                        
IF @Count = 3         
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_exposure a  where fileid =cast(@upldsrno as int)                   
            
            
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                            
print @Query                            
execute (@Query)             
            
                  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_exposure_commonfold
-- --------------------------------------------------
  
create proc [dbo].[proc_FileUploadAutomation_exposure_commonfold](@upldsrno int)                            
as                            
begin                            
                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile_exposure   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                  
            
set @FileLocation ='\\172.29.19.16\Common_Folder\Abha Jaiswal\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
          
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess_exposure a  where fileid =@upldsrno                          
                          
    
                      
if(@upldsrno=110)
begin  
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                        
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''')';                
print @Query                            
execute (@Query)  
end       
else 
begin 
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                        
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)
end        
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess_exposure set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
             
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_exposure a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)           
          
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_exposure_mindgate
-- --------------------------------------------------
  
create proc [dbo].[proc_FileUploadAutomation_exposure_mindgate](@upldsrno int)                            
as                            
begin                            
                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile_exposure   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                  
            
set @FileLocation ='H:\MindGate\Exposure File\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
          
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess_exposure a  where fileid =@upldsrno                          
                          
    
                      
if(@upldsrno=110)
begin  
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                        
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''')';                
print @Query                            
execute (@Query)  
end       
else 
begin 
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                        
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)
end        
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess_exposure set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
             
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_exposure a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)           
          
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_exposure_public
-- --------------------------------------------------
  
create proc [dbo].[proc_FileUploadAutomation_exposure_public](@upldsrno int)                            
as                            
begin                            
                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile_exposure   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   
                  
            
set @FileLocation ='\\172.29.19.16\Public\Exposure File\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
          
Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess_exposure a  where fileid =@upldsrno                          
                          
    
                      
if(@upldsrno=110)
begin  
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                        
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''')';                
print @Query                            
execute (@Query)  
end       
else 
begin 
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                        
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)
end        
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess_exposure set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
             
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess_exposure a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)           
          
                
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_newNseFO
-- --------------------------------------------------
  
  
CREATE proc [dbo].[proc_FileUploadAutomation_newNseFO](@upldsrno int)                            
as                            
begin                            
  
  
--Declare  @upldsrno int 
--set @upldsrno=3                           
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   

if @upldsrno=3
begin 
	set @FileLocation ='\\CSOKYC-6\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion)); 
    truncate table tbl_data
	set @Query='bulk insert tbl_data from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',ROWTERMINATOR = ''NORMAL'',TABLOCK)';                
	print @Query                            
	execute (@Query) 
	UPDATE tbl_data SET DATA='NORMAL'+DATA
	declare @file2 varchar(500),@SQL as varchar(max)
	--set   @file2=SUBSTRING(REPLACE(CONVERT(varchar(10),GETDATE(),105),'-',''),1,4)+RIGHT(CONVERT(VARCHAR(4),YEAR(GETDATE())),1)+'000'                
    SET @SQL = ''                              
	SET @SQL = ' bcp " SELECT * FROM [CSOKYC-6].upload.dbo.tbl_data where data is not NULL'                              
	SET @SQL = @SQL + ' " queryout H:\EXCHANGEFILES\' + ltrim(rtrim(@FileName+@FileExtenstion)) + ' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '                                 
	SET @SQL = '''' + @SQL + ''''                              
	SET @SQL = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @SQL                              
  
    PRINT @SQL                              
	EXEC (@SQL)   
  end 
                   
                  
if @upldsrno=101    
begin    
set @FileName= (select 'DerivativesMargin'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),2)     
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE())as a)    
end                  
    
                  
set @FileLocation ='\\CSOKYC-6\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                         
                  
--Update a set ProcessStartAt=GETDATE(),ProcessStatus=ProcessStatus+1,FileName=@FileName  from tbl_Fileprocess a  where fileid =@upldsrno                          
                          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                          
                          
set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';                
print @Query                            
execute (@Query)                
                
set @Error =@@ERROR                 
set @Count=1;                
if(@Error<>0)                        
GOTO HANDLEERROR;                   
                  
                           
insert into tbl_upload_info (Updinfo_RptSrno,Updinfo_filename,Updinfo_filesize,Updinfo_fileType,Updinfo_datetime,Updinfo_by)                             
values(@upldsrno,@FileName,@FileSize,@FileExtenstion,getdate(),'System')                            
                           
                            
set @Query ='update tbl_Fileprocess set FileRowCount = (select COUNT(0) from '+Quotename(@mUpd_TempTable)+')   where fileid  ='+convert(varchar(5),@upldsrno) +''                          
print @Query                          
execute (@Query);                          
                
set @Query ='exec  '+@mUpd_FinSP +'  '''+@Filename+'''';                            
print @Query                            
execute (@Query)                        
set @Error=@@ERROR                  
                  
set @Count =2                    
if(@Error<>0)                        
GOTO HANDLEERROR;                          
                
SET @Count =3;-- to default update                
                
HANDLEERROR:                
IF @Count = 1                  
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',1,  'Error Occured While Bulk Insert file STEP 1 Please check if file exists ='+@Filename                                                      
IF @Count = 2                
INsert into general.dbo.EODBODDetail_Error (ErrTime ,ErrObject,ErrLine ,ErrMessage)                
select GETDATE(),'proc_FileUploadAutomation',2, 'Error Occured While Uploading file STEP 2='+@Filename                                                      
IF @Count = 3       
Update a set ProcessEndAt=GETDATE() from tbl_Fileprocess a  where fileid =cast(@upldsrno as int)                 
          
          
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                          
print @Query                          
execute (@Query)                          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_FileUploadAutomation_TEST
-- --------------------------------------------------
CREATE proc [dbo].[proc_FileUploadAutomation_TEST](@upldsrno int)                          
as                          
begin                          
                         
Declare @Query varchar(max)=null;                
Declare @Error int=0;              
Declare @Count int=0;               
              
Declare @mUpd_TempTable varchar(100)=null;                          
Declare @mUpd_deli varchar(5)=null;                          
Declare @mUpd_FirstRow varchar(5)=null;                          
Declare @mUpd_FinSP varchar(50)=null;                          
Declare @FileLocation varchar(100)=null;                          
Declare @FileName varchar(1000)=null;                          
Declare @FileExtenstion varchar(10)=null;                          
Declare @FileSize numeric(18,2)=null                          
  
                          
select                            
@upldsrno=Upd_Srno ,                          
@mUpd_TempTable=Upd_TempTable,                          
@mUpd_deli=Upd_deli,                          
@mUpd_FirstRow=Upd_FirstRow,                          
@mUpd_FinSP=Upd_FinSP ,                          
@FileName=FileN ,                        
@FileExtenstion=Upd_Extension                          
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                           
              
-- to get fileName                
Declare  @tbl as  table (FileN varchar(200))                
Insert into @tbl  execute('select '+ @FileName)                  
select  @FileName=FileN  from @tbl                 
                
                
if @upldsrno=101  
begin  
set @FileName= (select 'DerivativesMargin'+replace(LEFT(CONVERT(VARCHAR(10),date,105),5),'-','')+RIGHT(CONVERT(varchar(4),YEAR(date)),2)   
from (select date = cast(min(start_date)as date) from general.dbo.bo_sett_mst with (nolock) where start_date>GETDATE())as a)  
end                
  
                
set @FileLocation ='\\CSOKYC-6\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                 
print @FileLocation                  
                       
      
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                        
print @Query                        
execute (@Query)                        
                        
--set @Query='bulk insert '+@mUpd_TempTable+' from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',KeepNULLS)';              
--print @Query                          
--execute (@Query)              
              
 
                                    
              
set @Query ='exec  '+@mUpd_FinSP +' '''+@Filename+'''';                           
print @Query                          
                     

        
set @Query='truncate table '+Quotename(@mUpd_TempTable)+' ';                        
print @Query                        
--execute (@Query)         
        
              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_SendFileStatusOnMail
-- --------------------------------------------------
CREATE procedure [dbo].[proc_SendFileStatusOnMail]    

as    

begin 

 exec upload.dbo.upd_CP_Combine  
 
 DECLARE @SQL AS VARCHAR(MAX), @HTML_OUTPUT AS VARCHAR(MAX)      

 /*SENDING COUNTS*/          

 SET @HTML_OUTPUT = ''      

 EXEC general.DBO.[DBA_ConvertQueryInHTML] 'select * from upload.dbo.File_UploadStatus where Process<>''Upload CP files for MCXSX.'' ',@HTML_OUTPUT OUTPUT      

 set @HTML_OUTPUT=  '<b>Dear Team</br><br/>Please find status of Uploaded file <br/><br/> <br/> <br/></b>'+ @HTML_OUTPUT    

    

 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL         

 @RECIPIENTS ='abha.1jaiswal@angelbroking.com;vijay.mali@angelbroking.com;vishal@angelbroking.com;vishal.kanani@angelbroking.com;updationteam@angelbroking.com',                                        

 @COPY_RECIPIENTS = 'csorm@angelbroking.com;',                                        

 --@blind_copy_recipients='mgs.abha@angelbroking.com;',                              

 @PROFILE_NAME = 'AngelBroking',                                        

 @BODY_FORMAT ='HTML',                                        

 @SUBJECT = 'NRMS File Upload Automation' ,                                                                    

 @BODY =@HTML_OUTPUT  
 
exec general.dbo.Upd_BSENSE_CP_Data     

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_SendFileStatusOnMail_comm
-- --------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
CREATE procedure proc_SendFileStatusOnMail_comm        
as        
begin        
 DECLARE @SQL AS VARCHAR(MAX), @HTML_OUTPUT AS VARCHAR(MAX)          
 /*SENDING COUNTS*/              
 SET @HTML_OUTPUT = ''          
 EXEC general.DBO.[DBA_ConvertQueryInHTML] 'select * from upload.dbo.File_UploadStatus_comm',@HTML_OUTPUT OUTPUT          
 set @HTML_OUTPUT=  '<b>Dear Team</br><br/>Please find status of Commodity Uploaded file <br/><br/> <br/> <br/></b>'+ @HTML_OUTPUT        
        
 EXEC INTRANET.MSDB.DBO.SP_SEND_DBMAIL             
 @RECIPIENTS ='vijay.mali@angelbroking.com',                                            
 @COPY_RECIPIENTS = 'siva.kopparapu@angelbroking.com;updationteam@angelbroking.com',                                            
 --@blind_copy_recipients='mgs.abha@angelbroking.com;',                                  
 @PROFILE_NAME = 'AngelBroking',                                            
 @BODY_FORMAT ='HTML',                                            
 @SUBJECT = 'Inhouse (Commodity) File Upload Automation' ,                                                                        
 @BODY =@HTML_OUTPUT          
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------

  -- exec rebuild_index2 'AdventureWorksDW'
CREATE procedure [dbo].[rebuild_index]
@database varchar(100)
as
declare @db_id  int
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
DECLARE @MAXROWID int;
DECLARE @MINROWID int;
DECLARE @CURRROWID int; 
DECLARE @ID int;    
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function    
-- and convert object and index IDs to names.    
Create table #work_to_do(id bigint primary key identity(1,1),objectid int,indexid int,partitionnum bigint,frag float )  

insert into #work_to_do(objectid,indexid,partitionnum,frag)
 select
object_id AS objectid,    
index_id AS indexid,    
partition_number AS partitionnum,    
avg_fragmentation_in_percent AS frag    
 FROM sys.dm_db_index_physical_stats (@db_id, NULL, NULL , NULL, 'LIMITED')    
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0; 

  
   --select @ID =ID from #work_to_do 
  
  SELECT @MINROWID=MIN(ID),@MAXROWID=MAX(ID) FROM #work_to_do WITH(NOLOCK) ; 

  SET @CURRROWID=@MINROWID;  

WHILE (@CURRROWID<=@MAXROWID)
   BEGIN 
 
    SELECT  @objectid=objectid , @indexid=indexid  , @partitionnum=partitionnum , @frag=frag 
     FROM #work_to_do WHERE ID=@CURRROWID 
     set @CURRROWID=@CURRROWID+1   


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
select N'Executed: ' + @command; 
end

      
-- Drop the temporary table.    
DROP TABLE #work_to_do;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.restricted_scrip
-- --------------------------------------------------
CREATE procedure restricted_scrip
(  
@filename as varchar(35)
)  
as

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Restricted_Scrip_Upload
-- --------------------------------------------------
-- =============================================
-- Author: Sushant Nagarkar
-- Create date: 16 Jul 2013
-- Description: For Processing Restricted Scrip Upload facility
-- =============================================
CREATE PROCEDURE [dbo].[Restricted_Scrip_Upload]
@filename AS VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;

---Temp_restricted_code -- Intermediate table
---restricted_code -- Main table
---Hist_restricted_code -- History table

-- for taking back up
INSERT INTO GENERAL.dbo.Hist_restricted_code
SELECT [BSE Code],[ISIN No],[NSE Symbol],[CO_NAME],[New Category],[Block Status],GETDATE()
FROM GENERAL.dbo.restricted_code

-- for Clearing Main /Original Table
TRUNCATE TABLE GENERAL.dbo.restricted_code

-- for Inseting New Data to
INSERT INTO GENERAL.dbo.restricted_code ([BSE Code],[ISIN No],[NSE Symbol],[CO_NAME],[New Category],[Block Status])
SELECT [BSE Code],[ISIN No],[NSE Symbol],[CO_NAME],[New Category],[Block Status] FROM Temp_restricted_code

-- for Clearing Intermediate Table
TRUNCATE TABLE Temp_restricted_code

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_abl_details
-- --------------------------------------------------
--exec save_abl_details 'NCDEX_BK01','NCDEX_BK01',0
---save_abl_details
--truncate table ff_other_values
--exec save_abl_details 'NCDEX BK01','NCDEX BK01',0
CREATE proc [dbo].[save_abl_details]        
(       
@type varchar(20),
@type1 varchar(20),  
@opt numeric    
)    
as    

declare @val numeric(25,2),@val1 numeric(25,2),@cnt integer,@maxRow int  
print'Hi'
if(Object_Id(N'tmp_fileuploads_BK01')is not null)
drop table tmp_fileuploads_BK01 
select row_number() over (order by [Transaction Recieved Date] desc) as row_no ,* 
into tmp_fileuploads_BK01 
from fileuploads_BK01
set @maxRow=(select max(row_no) from tmp_fileuploads_BK01)
select @val= [Credit Amount]-[Debit Amount] from tmp_fileuploads_BK01 where row_no=@maxRow
set @val1=@val

drop table tmp_fileuploads_BK01

declare @rdate datetime=cast(getdate() as date)
set @cnt=(select count(TYPE) from ff_other_values  
 where datemodified=@rdate+' 00:00:00.000' and type=@type)    

if @cnt > 0    
begin    
		update ff_other_values set  value= @val  where datemodified=@rdate+' 00:00:00.000' and type=@type  

		--Select @val,@type,@rdate
		update INTRANET.ROE.DBO.ff_other_values set  value= @val where type=@type and dateModified = @rdate+' 00:00:00.000'
end   
else    
begin    
		insert into ff_other_values values (@type,@val,@rdate) 
		
		insert into INTRANET.ROE.DBO.ff_other_values
		select * from ff_other_values where type=@type and dateModified = @rdate+' 00:00:00.000'
end    

---------------------Inserting Data in Intranet Server-----------------------   
 --insert into Intranet.ROE.DBO.ff_other_values
 --select * from general.DBO.ff_other_values where type=@type
 ---------------------End Here------

GO

-- --------------------------------------------------
-- PROCEDURE dbo.save_ncdex_details
-- --------------------------------------------------
--save_ncdex_details 'NCDEX MG11'

CREATE proc [dbo].[save_ncdex_details]  
(
	@Segment varchar(10)
)    
as 
--declare @Segment varchar(20)='NCDEX MG11' 
declare @rdate datetime=convert(varchar(10),getdate(),120),@type varchar(10)='NCDEX_A1',@type1 varchar(10)='NCDEX_A2',@type2 varchar(10)='NCDEX_A3',@type3 varchar(10)='NCDEX_A4',
@type4 varchar(10)='NCDEX_A5',@type5 varchar(10)='NCDEX_A6',@type6 varchar(10)='NCDEX_B7',@type7 varchar(10)='NCDEX_B8',@type8 varchar(10)='NCDEX_B9';

declare @val numeric(25,2),@val1 numeric(25,2),@val2 numeric(25,2),@val3 numeric(25,2),@val4 numeric(25,2),@val5 numeric(25,2),  @val6 numeric(25,2),
@val7 numeric(25,2),@val8 numeric(25,2),@cnt integer  

DECLARE @FirstPosition int,  @SecondPosition int
declare @FirstChar varchar(50)='1.Total Cash Capital',@SecondChar varchar(50)='2.Total Non-Cash Capital',@ThirdChar varchar(50)='3.Total Capital (A1 + A2)',
@FourthChar varchar(50)='4.Cash Component Required ()',@FifthChar varchar(50)='5.Effective Deposits [ Min (A1/A4, A3)]',
@SixChar varchar(50)='6.Non-usable Non-cash Capital (A3 - A5)',@SevenChar varchar(50)='7.Minimum Liquid Net Worth',
@EightChar varchar(50)='8.Initial Margin Amount',@NineChar varchar(50)='9.MTM Value',@TenChar varchar(50)='10.Effective Deposits Required For'

select @FirstPosition = CHARINDEX(@FirstChar,data) + LEN(@FirstChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@SecondChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
Select @FirstPosition,@SecondPosition
set @val=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate)
--print @val

select @FirstPosition = CHARINDEX(@SecondChar,data) + LEN(@SecondChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@ThirdChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val1=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate)
--print @val1

select @FirstPosition = CHARINDEX(@ThirdChar,data) + LEN(@ThirdChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@FourthChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val2=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate)
--print @val2

select @FirstPosition = CHARINDEX(@FourthChar,data) + LEN(@FourthChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@FifthChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val3=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate)
--print @val3

select @FirstPosition = CHARINDEX(@FifthChar,data) + LEN(@FifthChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@SixChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val4=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate)
--print @val4

select @FirstPosition = CHARINDEX(@SixChar,data) + LEN(@SixChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX('MARGIN INFORMATION',data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
declare @t varchar(200)
select @t= replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ') from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val5=(select cast(CHARINDEX(@t,'B')as numeric(20,2)))
--print @val5

select @FirstPosition = CHARINDEX(@SevenChar,data) + LEN(@SevenChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@EightChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val6=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate) 
--print @val6

select @FirstPosition = CHARINDEX(@EightChar,data) + LEN(@EightChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@NineChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val7=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate) 
--print @val7

select @FirstPosition = CHARINDEX(@NineChar,data) + LEN(@NineChar) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
select @SecondPosition = CHARINDEX(@TenChar,data)  from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate
set @val8=(Select cast(replace(rtrim(ltrim(SUBSTRING(data, @FirstPosition, @SecondPosition - @FirstPosition))),char(10),' ')as numeric(20,2)) from fileuploads where segment=@Segment and cast(upload_dt as date)=@rdate)
--print @val8

set @cnt=(select count(TYPE) from  ff_other_values
 where datemodified=@rdate+' 00:00:00.000' and type=@type)  
if @cnt > 0  
 begin  
 --print @rdate
 print 'Not'
update  ff_other_values set value= @val where datemodified=@rdate+' 00:00:00.000' and type=@type
update  ff_other_values set value= @val1 where datemodified=@rdate+' 00:00:00.000' and type=@type1
update  ff_other_values set value= @val2 where datemodified=@rdate+' 00:00:00.000' and type=@type2
update  ff_other_values set value= @val3 where datemodified=@rdate+' 00:00:00.000' and type=@type3
update  ff_other_values set value= @val4 where datemodified=@rdate+' 00:00:00.000' and type=@type4
update  ff_other_values set value= @val5 where datemodified=@rdate+' 00:00:00.000' and type=@type5
update  ff_other_values set value= @val6 where datemodified=@rdate+' 00:00:00.000' and type=@type6
update  ff_other_values set value= @val7 where datemodified=@rdate+' 00:00:00.000' and type=@type7
update  ff_other_values set value= @val8 where datemodified=@rdate+' 00:00:00.000' and type=@type8

--Select @val,@val1,@val2,@val3,@val4,@val5,@val6,@val7,@val8,@type,@type1,@type2,@type3,@type4,@type5,@type6,@type7,@type8,@rdate
update INTRANET.ROE.DBO.ff_other_values set  value= @val where type=@type and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val1 where type=@type1 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val2 where type=@type2 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val3 where type=@type3 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val4 where type=@type4 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val5 where type=@type5 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val6 where type=@type6 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val7 where type=@type7 and dateModified = @rdate+' 00:00:00.000'
update INTRANET.ROE.DBO.ff_other_values set  value= @val8 where type=@type8 and dateModified = @rdate+' 00:00:00.000'
 
end  
else  
 begin 
  print 'In' 

	insert into  ff_other_values values  (@type,@val,@rdate)  
	insert into  ff_other_values values   (@type1,@val1,@rdate)  
	insert into  ff_other_values values   (@type2,@val2,@rdate)  
	insert into  ff_other_values values  (@type3,@val3,@rdate)  
	insert into  ff_other_values values  (@type4,@val4,@rdate)  
	insert into  ff_other_values values  (@type5,@val5,@rdate)  
	insert into  ff_other_values values  (@type6,@val6,@rdate)  
	insert into  ff_other_values values  (@type7,@val7,@rdate)  
	insert into  ff_other_values values  (@type8,@val8,@rdate) 
	
	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type1 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type2 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type3 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type4 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type5 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type6 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type7 and dateModified = @rdate+' 00:00:00.000' 

	insert into INTRANET.ROE.DBO.ff_other_values
	select * from ff_other_values where type=@type8 and dateModified = @rdate+' 00:00:00.000' 

 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ScripUpload_BSE_Illiquid
-- --------------------------------------------------
-- ==========================================================================================
-- Author: Sushant Nagarkar
-- Create date: 16 Jul 2013
-- Description: For Processing BSE Illiquid Scrip Upload
-- ==========================================================================================
CREATE PROCEDURE [dbo].[ScripUpload_BSE_Illiquid]
@filename AS VARCHAR(50)
AS
BEGIN

---Temp_BSE_Illiquid_Scrip -- Intermediate table
---BSE_Illiquid_Scrip -- Main table
---BSE_Illiquid_Scrip_HIST -- History table

-- for taking back up
INSERT INTO History.dbo.BSE_Illiquid_Scrip_HIST
SELECT [Company Name],[BSE Scrip Code],[Group],[ISIN],[NSE Illiquid],[BSE Illiquid],[NSE Symbol],[START DATE],[END DATE],GETDATE()
FROM GENERAL.dbo.BSE_Illiquid_Scrip

-- for Clearing Main /Original Table
TRUNCATE TABLE GENERAL.dbo.BSE_Illiquid_Scrip

-- for Inseting New Data to Main /Original Table
INSERT INTO GENERAL.dbo.BSE_Illiquid_Scrip 
SELECT [Company Name],[BSE Scrip Code],[Group],LTRIM(RTRIM([ISIN])),[NSE Illiquid],[BSE Illiquid],[NSE Symbol],[START DATE],[END DATE]
FROM Temp_BSE_Illiquid_Scrip

-- for Clearing Intermediate Table
TRUNCATE TABLE Temp_BSE_Illiquid_Scrip

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ScripUpload_BSE_PCA
-- --------------------------------------------------
-- ==========================================================================================
-- Author: Sushant Nagarkar
-- Create date: 21 Aug 2013
-- Description: For Processing BSE PCA Upload
-- ==========================================================================================
CREATE PROCEDURE ScripUpload_BSE_PCA
@filename AS VARCHAR(50)
AS
BEGIN

-- FOR TAKING BACK UP
INSERT INTO HISTORY.dbo.BSE_PCA_HIST
SELECT SrNo,Scrip_Cd,Scrip_Name,Annexure,GETDATE() FROM GENERAL.dbo.BSE_PCA

-- FOR CLEARING MAIN /ORIGINAL TABLE
TRUNCATE TABLE GENERAL.dbo.BSE_PCA

-- FOR IBSETING NEW DATA TO MAIN /ORIGINAL TABLE
INSERT INTO GENERAL.dbo.BSE_PCA
SELECT SrNo,Scrip_Cd,Scrip_Name,Annexure FROM Temp_BSE_PCA

-- FOR CLEARING INTERMEDIATE TABLE
TRUNCATE TABLE Temp_BSE_PCA

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ScripUpload_NSE_Illiquid
-- --------------------------------------------------
-- ==========================================================================================
-- Author: Sushant Nagarkar
-- Create date: 10 Jul 2013
-- Description: For Processing NSE Illiquid Scrip Upload
-- ==========================================================================================
CREATE PROCEDURE [dbo].[ScripUpload_NSE_Illiquid]
@filename AS VARCHAR(50)
AS
BEGIN

---Temp_NSE_Illiquid_Scrip -- Intermediate table
---NSE_Illiquid_Scrip -- Main table
---NSE_Illiquid_Scrip_HIST -- History table

-- for taking back up
INSERT INTO History.dbo.NSE_Illiquid_Scrip_HIST
SELECT [Company Name],[BSE Scrip Code],[Group],[ISIN],[NSE Illiquid],[BSE Illiquid],[NSE Symbol],[START DATE],[END DATE],GETDATE()
FROM GENERAL.dbo.NSE_Illiquid_Scrip

-- for Clearing Main /Original Table
TRUNCATE TABLE GENERAL.dbo.NSE_Illiquid_Scrip

-- for Inseting New Data to Main /Original Table
INSERT INTO GENERAL.dbo.NSE_Illiquid_Scrip 
SELECT [Company Name],[BSE Scrip Code],[Group],LTRIM(RTRIM([ISIN])),[NSE Illiquid],[BSE Illiquid],[NSE Symbol],[START DATE],[END DATE]
FROM Temp_NSE_Illiquid_Scrip

-- for Clearing Intermediate Table
TRUNCATE TABLE Temp_NSE_Illiquid_Scrip

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ScripUpload_NSE_PCA
-- --------------------------------------------------
-- ==========================================================================================
-- Author: Sushant Nagarkar
-- Create date: 21 Aug 2013
-- Description: For Processing NSE PCA Upload
-- ==========================================================================================
CREATE PROCEDURE ScripUpload_NSE_PCA
@filename AS VARCHAR(50)
AS
BEGIN

-- FOR TAKING BACK UP
INSERT INTO HISTORY.dbo.NSE_PCA_HIST
SELECT SrNo,NseSymbol,Series,SecurityName,ISIN,Annexure,GETDATE() FROM GENERAL.dbo.NSE_PCA

-- FOR CLEARING MAIN /ORIGINAL TABLE
TRUNCATE TABLE GENERAL.dbo.NSE_PCA

-- FOR INSETING NEW DATA TO MAIN /ORIGINAL TABLE
INSERT INTO GENERAL.dbo.NSE_PCA
SELECT SrNo,NseSymbol,Series,SecurityName,ISIN,Annexure FROM Temp_NSE_PCA

-- FOR CLEARING INTERMEDIATE TABLE
TRUNCATE TABLE Temp_NSE_PCA

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ScripUpload_ScripCategory
-- --------------------------------------------------
-- ==========================================================================================
-- Author: Sushant Nagarkar
-- Create date: 16 Jul 2013
-- Description: For Processing Scrip Category Master Upload facility
-- ==========================================================================================
CREATE PROCEDURE ScripUpload_ScripCategory
@filename AS VARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;

---Temp_scripcatg -- Intermediate table
---scripcatg -- Main table
---Hist_scripcatg -- History table

-- for taking back up
INSERT INTO General.dbo.Hist_scripcatg
SELECT [POWER],EmpCost,ShHoldFunds,ISIN,Category,GETDATE() FROM GENERAL.dbo.scripcatg

-- for Clearing Main /Original Table
TRUNCATE TABLE GENERAL.dbo.scripcatg

-- for Inserting New Records To Main /Original Table
INSERT INTO GENERAL.dbo.scripcatg
SELECT DISTINCT [POWER],EmpCost,ShHoldFunds,ISIN,Category FROM Temp_scripcatg
WHERE LTRIM(RTRIM(ISIN))<>'-'

-- For Removing Junk values from database
DELETE FROM GENERAL.dbo.scripcatg WHERE LTRIM(RTRIM(ISIN))='-'

-- for Clearing Intermediate Table
TRUNCATE TABLE Temp_scripcatg

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_ExchangeFilename
-- --------------------------------------------------
CREATE procedure sp_ExchangeFilename (@filename varchar(2000),@file varchar(100) OUT)
as 
begin 
select  @filename='select '+@filename
execute(@filename)  
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
-- PROCEDURE dbo.SPGetUploadData
-- --------------------------------------------------
CREATE Proc [dbo].[SPGetUploadData]    
as    
select upd_srno as [Sr No], upd_title as [Title], upd_connection as [Connection], upd_temptable as [Temporary Table], upd_deli as [Delimeter], upd_firstrow as [First Row], upd_finSP as [Stored Procedure], upd_extension as [Extension], 
upd_info as [Informa
  
tion], added_by as [Added By], convert(varchar(11),convert(datetime,added_on),109) as [Added On]    
from tbl_upload

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SPInsertUploadData
-- --------------------------------------------------
CREATE proc SPInsertUploadData      
@SrNo int, @Title varchar(100),@conn varchar(100),@TempTable varchar(100),@Delimeter varchar(10),@FirstRow int,@StoredProc varchar(100),@Extension varchar(100),@Info varchar(200),@Addedby varchar(100),@IP varchar(100),@REMOTESERVER varchar(30)      
as      
if @SrNo = ''      
begin      
 insert into tbl_upload values(@Title,@conn,@TempTable,@Delimeter,@FirstRow,@StoredProc,@Extension,@Info,@Addedby,getdate(),@IP,@REMOTESERVER)      
      
set @SrNo=(select upd_srno from tbl_upload where added_on=getdate())      
end      
else      
begin      
 --insert into tbl_report_history select * from tbl_report where rpt_srno=@SrNo      
      
 update tbl_upload set upd_title = @Title, upd_connection=@conn, upd_temptable = @TempTable, upd_deli =@Delimeter, upd_firstrow=@FirstRow, upd_finsp = @StoredProc, upd_extension = @Extension, upd_info = @Info, added_by = @Addedby, added_on   
= getdate(), machine_ip = @IP,RemoteServer=@REMOTESERVER      
 where upd_srno=@SrNo      
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.stp_help_search
-- --------------------------------------------------
--Text
Create  PROCEDURE [dbo].[stp_help_search]
 (
	@fslike				[nvarchar](500),
	@nxtype				[tinyint]= 0,
	@fntype				[tinyint]= 0
 )
-- WITH ENCRYPTION
 AS
	BEGIN
	SET NOCOUNT ON 
			DECLARE @xtype	varchar(2)
			DECLARE @fxlike	varchar(100)
			DECLARE @charindex	NVARCHAR(2)
		
			SET @fslike =REPLACE (@fslike,'[','')
			SET @fslike =REPLACE (@fslike,']','')
			SET @fslike =REPLACE (@fslike,'','')
			
			SET @fslike =LTRIM(RTRIM(@fslike))

			SET @xtype	= case
							when @nxtype	= 0 then ''
							when @nxtype	= 1 then 'U'
							when @nxtype	= 11 then 'U'
							when @nxtype	= 2 then 'P'
							when @nxtype	= 5 then 'PK'
							when @nxtype	= 10 then 'F'
							when @nxtype	= 4 then 'D'
	
							else ''
							end;
			SET @fxlike	='stp_help'

			IF 	@fntype	= 0 and  @nxtype	<> 11
				BEGIN		-- FOR TABLES
						SELECT [name]  AS ' ' FROM sysobjects
						WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
						AND ((@xtype			= '' and [xtype] = 'U' )  OR [xtype]		=		@xtype)
						AND upper([name])			NOT LIKE '%'+ upper(@fxlike) +'%'
					ORDER BY [name] ASC
							-- FOR STP
						SELECT [name]  AS ' ' FROM sysobjects
						WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
						AND ((@xtype			= '' and [xtype] = 'P')  OR [xtype]		=		@xtype)
						AND [name]			NOT LIKE '%'+ @fxlike +'%'
						 --FOR VIEWS
						SELECT [name]  AS ' ' FROM sysobjects
						WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
						AND ((@xtype			= '' and [xtype] = 'V')  OR [xtype]		=		@xtype)
						AND [name]			NOT LIKE '%'+ @fxlike +'%'
					
					ORDER BY [name] ASC

						
				END
			ELSE
				BEGIN	
					IF @nxtype	= 11
					begin
					declare @tabname nvarchar(100), @tabdata nvarchar(500)

					create table #trper 
					(
					tabname nvarchar(100),
					tabdata nvarchar(500)
					)


					
					insert into #trper SELECT  [name], '	select * from '+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]

					declare tableselect cursor for	select * from #trper

					open  tableselect
					fetch next from tableselect into @tabname, @tabdata
						while @@fetch_status = 0
							begin
								print '	'
								print '-------------------------------------------------------------------------------------'
								print @tabname
								execute(@tabdata)
								fetch next from tableselect into @tabname, @tabdata
							end
					close tableselect
					deallocate tableselect
				
					drop table #trper
					end



				ELSE	IF @nxtype	= 2 AND @fntype <> 20
					SELECT 'GO
	sp_helptext	'+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]
				
				ELSE	IF @nxtype	= 1 AND @fntype = 20
					SELECT 'GO
	stp_help_select	'+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]

				ELSE	IF @nxtype	= 1 AND @fntype = 100
					SELECT 'GO
	stp_help_anyTableScripGenerator	'+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]

				ELSE	IF @nxtype	= 1 AND @fntype  =200
					begin
					truncate table table_Null_FinalStatus
					SELECT 'GO
	stp_help_whereclouse	'+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]
					end
				ELSE	IF @nxtype	= 1 AND @fntype = 22
					SELECT 'GO
	stp_help_PreviousDayScripMasterGenerator_stp	'+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]

				ELSE	IF @nxtype	= 2 AND @fntype = 20
					SELECT 'GO
	stp_help_stpdoc	'+ [name]	FROM sysobjects
					WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
					AND (@xtype			= ''
						OR [xtype]		=		@xtype)
					ORDER BY [name]

					ELSE
								SELECT 'GO
				sp_help	'+ [name]	FROM sysobjects
							WHERE upper([name])			LIKE '%'+ upper(@fslike) +'%'
								AND (@xtype			= ''
									OR [xtype]		=		@xtype)
								ORDER BY [name]

				END

	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_BSE_Series
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UPD_BhavCopy_BSE_Series](@filename as varchar(500))    
as                    
BEGIN TRY    
 TRUNCATE TABLE general.dbo.tbl_bse_copy    
  
 INSERT INTO general.dbo.tbl_bse_copy   
 select *,@filename,convert(varchar(11),getdate()) from tbl_bse_copy    
           
 TRUNCATE TABLE tbl_bse_copy                  
END TRY              
BEGIN CATCH              
 TRUNCATE TABLE tbl_bse_copy            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_MCX
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UPD_BhavCopy_MCX](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_MCX_NCDEX_BhavCopy  

 INSERT INTO general.dbo.tbl_MCX_NCDEX_BhavCopy 
 select *,@filename,convert(varchar(11),getdate()) from tbl_MCX_NCDEX_BhavCopy  

 update general.dbo.tbl_MCX_NCDEX_BhavCopy set option_type='Fut' where option_type in('-','XX')
         
 TRUNCATE TABLE tbl_MCX_NCDEX_BhavCopy                 
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_MCX_NCDEX_BhavCopy          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_MCX_bkup_02062022
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[UPD_BhavCopy_MCX_bkup_02062022](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_MCX_NCDEX_BhavCopy  

 INSERT INTO general.dbo.tbl_MCX_NCDEX_BhavCopy 
 select *,@filename,convert(varchar(11),getdate()) from tbl_MCX_NCDEX_BhavCopy  
         
 TRUNCATE TABLE tbl_MCX_NCDEX_BhavCopy                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_MCX_NCDEX_BhavCopy          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_NCDEX
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_BhavCopy_NCDEX](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_NCDEX_BhavCopy  

 INSERT INTO general.dbo.tbl_NCDEX_BhavCopy 
 select *,@filename,convert(varchar(11),getdate()) from tbl_NCDEX_BhavCopy  
         
 TRUNCATE TABLE tbl_NCDEX_BhavCopy                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_NCDEX_BhavCopy          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_NSE_Series
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UPD_BhavCopy_NSE_Series](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_nseseries  

 INSERT INTO general.dbo.tbl_nseseries 
 select *,@filename,convert(varchar(11),getdate()) from tbl_nseseries  
         
 TRUNCATE TABLE tbl_nseseries                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_nseseries          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_NSE_Series_bkup_14062021
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_BhavCopy_NSE_Series_bkup_14062021](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_NSEBhavCopy_Series  

 INSERT INTO general.dbo.tbl_NSEBhavCopy_Series 
 select *,@filename,convert(varchar(11),getdate()) from tbl_NSEBhavCopy_Series  
         
 TRUNCATE TABLE tbl_NSEBhavCopy_Series                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_NSEBhavCopy_Series          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_NSEFO
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[UPD_BhavCopy_NSEFO](@filename as varchar(500))      
as                      
BEGIN TRY      
 TRUNCATE TABLE general.dbo.tbl_NSEFO_Bhavcopy     
   
 INSERT INTO general.dbo.tbl_NSEFO_Bhavcopy     
 select *    
 ,@filename,convert(varchar(11),getdate())     
 from tbl_NSEFO_Bhavcopy     
   
 update general.dbo.tbl_NSEFO_Bhavcopy set  instrument='FUTIDX' where instrument='IDF'  
 update general.dbo.tbl_NSEFO_Bhavcopy set  instrument='FUTSTK' where instrument='STF'  
 update general.dbo.tbl_NSEFO_Bhavcopy set  instrument='OPTSTK' where instrument='STO'  
 update general.dbo.tbl_NSEFO_Bhavcopy set  instrument='OPTIDX' where instrument='IDO'  
 update general.dbo.tbl_NSEFO_Bhavcopy set OPTION_TYP='' where OPTION_TYP is NULL
 update general.dbo.tbl_NSEFO_Bhavcopy set STRIKE_PR='' where STRIKE_PR is NULL
             
             
 TRUNCATE TABLE tbl_NSEFO_Bhavcopy                    
END TRY                
BEGIN CATCH                
 TRUNCATE TABLE tbl_NSEFO_Bhavcopy              
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BhavCopy_NSEFO_bkup_10072024
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[UPD_BhavCopy_NSEFO_bkup_10072024](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_NSEFO_Bhavcopy  

 INSERT INTO general.dbo.tbl_NSEFO_Bhavcopy 
 select *--,@filename,convert(varchar(11),getdate()) 
 from tbl_NSEFO_Bhavcopy  
         
 TRUNCATE TABLE tbl_NSEFO_Bhavcopy                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_NSEFO_Bhavcopy          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin
-- --------------------------------------------------
CREATE   procedure [dbo].[upd_BSEVARMargin](@filename as varchar(50))                      
as                      
BEGIN TRY                      
      
insert into History.dbo.BSEVar_HIST         
select * from general.dbo.BSEVar  
        
--select * into general.dbo.BSE_VAR    from general.dbo.BSEVar    where 1=2        
--select * into BSE_VAR    from CP_BSEVAR    where 1=2         
--select * into  history.dbo.BSE_margin        from  History.dbo.BSEVar_HIST         where 1=2        
                                         
truncate table general.dbo.BSEVar       
        
        
INSERT INTO general.dbo.BSEVar (Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON        
,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)        
        
        
select [Sr.no]=(substring(data,1,5)),        
SCRIPCODE=(substring(data,6,6)),        
SCRIPNAME=(substring(data,12,12)),        
ISINCODE=(substring(data,24,12)),        
VARMARGIN=CONVERT(NVARCHAR,(CONVERT(DECIMAL(15,2),substring(data,36,7))/100.00)),        
FIVARMARGINPER=(SUBSTRING(data,43,7)),        
PROCESSON=convert(datetime,(substring(data,50,8))),        
APPLI_ON=convert(datetime,(substring(data,58,8))),        
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),        
--ELM_PERC=((substring(data,73,7)/100)),        
ELM_PERC=CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),(substring(data,73,7)))/100)),        
ELM_RATE=convert(money,(substring(data,80,7)/1000)),        
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from CP_BSEVAR (nolock)     
    
    
    
--select * into #temp from BSE_VAR where data like '%INE191H01014%'    
    
--select * from general.dbo.BSE_VAR where isincode='INE191H01014'          
      
      
select  distinct isincode=ltrim(rtrim(isincode)) ,varmargin into #CC  from general.dbo.BSEVar    --where isincode='INE191H01014'          
      
select isincode into #dd from #CC  group by isincode  having count(isincode)>1      
       
select isincode,varmargin=max(cast(varmargin as numeric(18,2))) into #todelete from general.dbo.BSEVar where isincode in(select isincode from #dd) group by isincode      
       
delete A from general.dbo.BSEVar  A inner join #todelete B on A.isincode=B.isincode and cast(A.varmargin as numeric(18,2))=cast(B.varmargin as numeric(18,2)) and A.isincode<>''    and A.isincode<>'NA'             
      
      
truncate table CP_BSEVAR        
END TRY        
BEGIN CATCH        
truncate table CP_BSEVAR        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin_09092011
-- --------------------------------------------------
CREATE procedure upd_BSEVARMargin_09092011(@filename as varchar(50))              
as           
BEGIN TRY    
  ------------------insert CP into History-----------------            
insert into History.dbo.BSEVar_HIST           
select * from general.dbo.BSEVar          
--------------------------Insert New CP -------------------          
truncate table general.dbo.BSEVar          
        
            
INSERT INTO general.dbo.BSEVar(Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON        
           ,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)        
                   
        
select [Sr.no]=(substring(data,1,5)),        
SCRIPCODE=(substring(data,6,6)),        
SCRIPNAME=(substring(data,12,12)),        
ISINCODE=(substring(data,24,12)),        
VARMARGIN=((substring(data,36,7)/100)),        
FIVARMARGINPER=(substring(data,43,7)),        
PROCESSON=convert(datetime,(substring(data,50,8))),        
APPLI_ON=convert(datetime,(substring(data,58,8))),        
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),        
ELM_PERC=((substring(data,73,7)/100)),        
ELM_RATE=convert(money,(substring(data,80,7)/1000)),        
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from CP_BSEVAR  (nolock)             
        
        
truncate table CP_BSEVAR     
END TRY    
BEGIN CATCH    
truncate table CP_BSEVAR     
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin_14102016
-- --------------------------------------------------
CREATE procedure upd_BSEVARMargin_14102016(@filename as varchar(50))  
as  
BEGIN TRY  
------------------insert CP into History-----------------  
  
insert into History.dbo.BSEVar_HIST  
select * from general.dbo.BSEVar  
  
--------------------------Insert New CP -------------------  
truncate table general.dbo.BSEVar  
  
  
INSERT INTO general.dbo.BSEVar(Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON  
,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)  
  
  
select [Sr.no]=(substring(data,1,5)),  
SCRIPCODE=(substring(data,6,6)),  
SCRIPNAME=(substring(data,12,12)),  
ISINCODE=(substring(data,24,12)),  
VARMARGIN=CONVERT(NVARCHAR,(CONVERT(DECIMAL(15,2),substring(data,36,7))/100.00)),  
FIVARMARGINPER=(SUBSTRING(data,43,7)),  
PROCESSON=convert(datetime,(substring(data,50,8))),  
APPLI_ON=convert(datetime,(substring(data,58,8))),  
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),  
--ELM_PERC=((substring(data,73,7)/100)),  
ELM_PERC=CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),(substring(data,73,7)))/100)),  
ELM_RATE=convert(money,(substring(data,80,7)/1000)),  
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from CP_BSEVAR (nolock)  
  
  
truncate table CP_BSEVAR  
END TRY  
BEGIN CATCH  
truncate table CP_BSEVAR  
--PRINT 'ERROR'  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin_16092016
-- --------------------------------------------------
CREATE procedure upd_BSEVARMargin_16092016(@filename as varchar(50))  
as  
BEGIN TRY  
------------------insert CP into History-----------------  
  
insert into History.dbo.BSEVar_HIST  
select * from general.dbo.BSEVar  
  
--------------------------Insert New CP -------------------  
truncate table general.dbo.BSEVar  
  
  
INSERT INTO general.dbo.BSEVar(Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON  
,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)  
  
  
select [Sr.no]=(substring(data,1,5)),  
SCRIPCODE=(substring(data,6,6)),  
SCRIPNAME=(substring(data,12,12)),  
ISINCODE=(substring(data,24,12)),  
VARMARGIN=CONVERT(NVARCHAR,(CONVERT(DECIMAL(15,2),substring(data,36,7))/100.00)),  
FIVARMARGINPER=(SUBSTRING(data,43,7)),  
PROCESSON=convert(datetime,(substring(data,50,8))),  
APPLI_ON=convert(datetime,(substring(data,58,8))),  
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),  
--ELM_PERC=((substring(data,73,7)/100)),  
ELM_PERC=CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),(substring(data,73,7)))/100)),  
ELM_RATE=convert(money,(substring(data,80,7)/1000)),  
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from CP_BSEVAR (nolock)  
  
  
truncate table CP_BSEVAR  
END TRY  
BEGIN CATCH  
truncate table CP_BSEVAR  
--PRINT 'ERROR'  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin_28092016
-- --------------------------------------------------
create procedure [dbo].[upd_BSEVARMargin_28092016](@filename as varchar(50))
as
BEGIN TRY
------------------insert CP into History-----------------

insert into History.dbo.BSEVar_HIST
select * from general.dbo.BSEVar

--------------------------Insert New CP -------------------
truncate table general.dbo.BSEVar


INSERT INTO general.dbo.BSEVar(Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON
,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)


select [Sr.no]=(substring(data,1,5)),
SCRIPCODE=(substring(data,6,6)),
SCRIPNAME=(substring(data,12,12)),
ISINCODE=(substring(data,24,12)),
VARMARGIN=CONVERT(NVARCHAR,(CONVERT(DECIMAL(15,2),substring(data,36,7))/100.00)),
FIVARMARGINPER=(SUBSTRING(data,43,7)),
PROCESSON=convert(datetime,(substring(data,50,8))),
APPLI_ON=convert(datetime,(substring(data,58,8))),
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),
--ELM_PERC=((substring(data,73,7)/100)),
ELM_PERC=CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),(substring(data,73,7)))/100)),
ELM_RATE=convert(money,(substring(data,80,7)/1000)),
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from CP_BSEVAR (nolock)


truncate table CP_BSEVAR
END TRY
BEGIN CATCH
truncate table CP_BSEVAR
--PRINT 'ERROR'
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin_bkup_30042021
-- --------------------------------------------------

CREATE   procedure [dbo].[upd_BSEVARMargin_bkup_30042021](@filename as varchar(50))                      
as                      
BEGIN TRY                      
      
insert into History.dbo.BSEVar_HIST         
select * from general.dbo.BSEVar  
        
--select * into general.dbo.BSE_VAR    from general.dbo.BSEVar    where 1=2        
--select * into BSE_VAR    from CP_BSEVAR    where 1=2         
--select * into  history.dbo.BSE_margin        from  History.dbo.BSEVar_HIST         where 1=2        
                                         
truncate table general.dbo.BSEVar       
        
        
INSERT INTO general.dbo.BSEVar (Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON        
,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)        
        
        
select [Sr.no]=(substring(data,1,5)),        
SCRIPCODE=(substring(data,6,6)),        
SCRIPNAME=(substring(data,12,12)),        
ISINCODE=(substring(data,24,12)),        
VARMARGIN=CONVERT(NVARCHAR,(CONVERT(DECIMAL(15,2),substring(data,36,7))/100.00)),        
FIVARMARGINPER=(SUBSTRING(data,43,7)),        
PROCESSON=convert(datetime,(substring(data,50,8))),        
APPLI_ON=convert(datetime,(substring(data,58,8))),        
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),        
--ELM_PERC=((substring(data,73,7)/100)),        
ELM_PERC=CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),(substring(data,73,7)))/100)),        
ELM_RATE=convert(money,(substring(data,80,7)/1000)),        
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from CP_BSEVAR (nolock)     
    
    
    
--select * into #temp from BSE_VAR where data like '%INE191H01014%'    
    
--select * from general.dbo.BSE_VAR where isincode='INE191H01014'          
      
      
select  distinct isincode=ltrim(rtrim(isincode)) ,varmargin into #CC  from general.dbo.BSEVar    --where isincode='INE191H01014'          
      
select isincode into #dd from #CC  group by isincode  having count(isincode)>1      
       
select isincode,varmargin=max(cast(varmargin as numeric(18,2))) into #todelete from general.dbo.BSEVar where isincode in(select isincode from #dd) group by isincode      
       
delete A from general.dbo.BSEVar  A inner join #todelete B on A.isincode=B.isincode and cast(A.varmargin as numeric(18,2))=cast(B.varmargin as numeric(18,2)) and A.isincode<>''    and A.isincode<>'NA'             
      
      
truncate table CP_BSEVAR        
END TRY        
BEGIN CATCH        
truncate table CP_BSEVAR        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_BSEVARMargin_New
-- --------------------------------------------------
CREATE procedure [dbo].[upd_BSEVARMargin_New](@filename as varchar(50))                      
as                      
BEGIN TRY                      
      
insert into History.dbo.tbl_BSEVAR_New         
select * from general.dbo.tbl_BSEVAR_New  
                                                   
truncate table general.dbo.tbl_BSEVAR_New       
INSERT INTO general.dbo.tbl_BSEVAR_New 
select *,@filename,getdate() from tbl_BSEVAR_New (nolock)     
      
--select  distinct ISIN=ltrim(rtrim(isincode)) ,VaR_Margin into #CC  from general.dbo.tbl_BSEVAR_New    --where isincode='INE191H01014'          
      
--select ISIN into #dd from #CC  group by ISIN  having count(ISIN)>1      
       
--select ISIN,varmargin=max(cast(VaR_Margin as numeric(18,2))) into #todelete from general.dbo.tbl_BSEVAR_New where ISIN in(select ISIN from #dd) group by ISIN      
       
--delete A from general.dbo.tbl_BSEVAR_New  A inner join #todelete B on A.ISIN=B.ISIN and cast(A.VaR_Margin as numeric(18,2))=cast(B.VaR_Margin as numeric(18,2)) 
--and A.ISIN<>'' and A.ISIN<>'NA'             
      
      
truncate table tbl_BSEVAR_New        
END TRY        
BEGIN CATCH        
truncate table tbl_BSEVAR_New        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_BSEVARMARGIN_TEST
-- --------------------------------------------------
CREATE   procedure [dbo].[UPD_BSEVARMARGIN_TEST](@filename as varchar(50))                      
as                      
BEGIN TRY                      
      
insert into history.dbo.BSE_margin_Test          
select * from general.dbo.BSE_VAR_Test       
        
--select * into general.dbo.BSE_VAR_Test    from general.dbo.BSEVar    where 1=2        
--select * into BSE_VAR_Test    from CP_BSEVAR    where 1=2         
--select * into  history.dbo.BSE_margin_Test        from  History.dbo.BSEVar_HIST         where 1=2        
                                         
truncate table general.dbo.BSE_VAR_Test      
        
        
INSERT INTO general.dbo.BSE_VAR_Test(Slno,SCRIPCODE,SCRIPNAME,ISINCODE,VARMARGIN,FIVARMARGINPER,PROCESSON        
,APPLI_ON,VARMARGIN_RATE,ELM_PERC,ELM_RATE,VAR_ELM_Rate,CRT_DATE)        
        
        
select [Sr.no]=(substring(data,1,5)),        
SCRIPCODE=(substring(data,6,6)),        
SCRIPNAME=(substring(data,12,12)),        
ISINCODE=(substring(data,24,12)),        
VARMARGIN=CONVERT(NVARCHAR,(CONVERT(DECIMAL(15,2),substring(data,36,7))/100.00)),        
FIVARMARGINPER=(SUBSTRING(data,43,7)),        
PROCESSON=convert(datetime,(substring(data,50,8))),        
APPLI_ON=convert(datetime,(substring(data,58,8))),        
VARMARGIN_RATE=convert(money,(substring(data,66,7)/1000)),        
--ELM_PERC=((substring(data,73,7)/100)),        
ELM_PERC=CONVERT(DECIMAL(18,2),(CONVERT(DECIMAL(18,2),(substring(data,73,7)))/100)),        
ELM_RATE=convert(money,(substring(data,80,7)/1000)),        
VAR_ELM_Rate=convert(money,(substring(data,87,7)/1000)),getdate() from BSE_VAR_Test (nolock)     
    
    
    
--select * into #temp from BSE_VAR_Test where data like '%INE191H01014%'    
    
--select * from general.dbo.BSE_VAR_Test where isincode='INE191H01014'          
      
      
select  distinct isincode=ltrim(rtrim(isincode)) ,varmargin into #CC  from general.dbo.BSE_VAR_Test     --where isincode='INE191H01014'          
      
select isincode into #dd from #CC  group by isincode  having count(isincode)>1      
       
select isincode,varmargin=max(cast(varmargin as numeric(18,2))) into #todelete from general.dbo.BSE_VAR_Test where isincode in(select isincode from #dd) group by isincode      
       
delete A from general.dbo.BSE_VAR_Test A inner join #todelete B on A.isincode=B.isincode and cast(A.varmargin as numeric(18,2))=cast(B.varmargin as numeric(18,2)) and A.isincode<>''    and A.isincode<>'NA'             
      
      
truncate table BSE_VAR_Test        
END TRY        
BEGIN CATCH        
truncate table BSE_VAR_Test        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_BSECM
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_BSECM]  

 @filename as varchar(50)  

as        

BEGIN TRY  

  

 delete a   

 from History.dbo.cp_bsecm_hist a  

 join general.dbo.cp_bsecm b  

 on a.cls_date = b.updated_on  

  

 -----------------insert CP in History data---------------    

 insert into History.dbo.cp_bsecm_hist    

 select * from general.dbo.cp_bsecm     

  

 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.cp_bsecm      

     

 update cp_bsecm set rate=rate/100      

 insert into general.dbo.cp_bsecm   

 select distinct *,@filename,convert(varchar(10),getdate(),121) from cp_bsecm 

    

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'BSECM'
  

 truncate table cp_bsecm  



END TRY  

BEGIN CATCH  

 truncate table cp_bsecm      

END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_BSX
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_BSX](@filename as varchar(50))                  
as                  
BEGIN TRY            
        -----------------insert CP in History data---------------           
insert into History.dbo.cp_bsx_hist    
select * from  general.dbo.cp_bsx   
---------------------Insert New CP-----------------------           
truncate table general.dbo.cp_bsx 
           
insert into general.dbo.cp_bsx                
select mkt_type,Instrument,        
Symbol,        
expirydate=convert(datetime,expirydate,103),        
strike_price,
option_type,  
filler,      
PREVIOUS,        
OPEN_PRICE,
HIGH_PRICE,        
LOW_PRICE,        
CLOSE_PRICE,        
total_traded_quantity,        
total_traded_val,        
open_interest,
change_in_open_interest,        
[filename]=@filename,        
updated_on=getdate()        
from cp_bsx (nolock)   

update general.dbo.cp_bsx set option_type='' where option_type is null 
 
/*To update mimansa table as suggested by manesh sir on Nov 23 2015*/  
  
/*exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NSX'  */
     
 truncate table cp_bsx            
END TRY  
BEGIN CATCH  
 truncate table cp_bsx            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_Combine
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_Combine]    
as        
BEGIN TRY
-------added to avoid duplication due to multiple times uploading in the same day.----------

delete a 
from History.dbo.Combine_Closing_File a
join general.dbo.Combine_Closing_File b
on convert(varchar(10),a.updated_on,121) = convert(varchar(10),b.updated_on,121)

-----------------insert CP in History data---------------      
insert into History.dbo.Combine_Closing_File      
select * from general.dbo.Combine_Closing_File     

---------------------Insert New CP-----------------------      
truncate table general.dbo.Combine_Closing_File        

insert into general.dbo.Combine_Closing_File 
select SCRIP_CD,SERIES,ISIN,CL_RATE,'BSE_NSE',UPLOAD_ON
from AngelNseCM.msajag.dbo.closing_mtm where cast(sysdate as date)= (select max(sysdate)  from AngelNseCM.msajag.dbo.closing_mtm)

exec general.dbo.[CSO_MAIL_CombineClosingFile]

Declare @combineCount varchar(10)
set @combineCount=(select count(1) from general.dbo.Combine_Closing_File)


 insert into  intranet.sms.dbo.sms                                                        
 select  Mobile, 'Combine Count:' +@combineCount+ '.' as txt, convert(varchar(10), getdate(), 103),                           
 ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate()))))),                                                          
'P', case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end,'T 7'                                                     
 FROM general.dbo.TBL_USEREMAILID WHERE Module='T+1'     and empname in ('VISHAL KANANI','Vishal Gohil','Navnit Shah','Abha Jaiswal')

 insert into  intranet.sms.dbo.sms                                                        
 select  8779969166, 'Combine Count:' +@combineCount + '.' as txt, convert(varchar(10), getdate(), 103),                           
 ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate()))))),                                                          
'P', case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end,'T 7'                                                     
     

 insert into  intranet.sms.dbo.sms                                                        
 select  07769852028, 'Combine Count:' +@combineCount + '.' as txt, convert(varchar(10), getdate(), 103),                           
 ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate()))))),                                                          
'P', case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end,'T 7'                                                     


end try      
begin catch      
insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)      
select GETDATE(),'upd_CP_Combine',ERROR_LINE(),ERROR_MESSAGE()      

     
DECLARE @ErrorMessage NVARCHAR(4000);      
SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());      
RAISERROR (@ErrorMessage , 16, 1);      
end catch;     

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_Combine_bkup_21122022
-- --------------------------------------------------
create procedure [dbo].[upd_CP_Combine_bkup_21122022]    
as        
BEGIN TRY
-------added to avoid duplication due to multiple times uploading in the same day.----------

delete a 
from History.dbo.Combine_Closing_File a
join general.dbo.Combine_Closing_File b
on convert(varchar(10),a.updated_on,121) = convert(varchar(10),b.updated_on,121)

-----------------insert CP in History data---------------      
insert into History.dbo.Combine_Closing_File      
select * from general.dbo.Combine_Closing_File     

---------------------Insert New CP-----------------------      
truncate table general.dbo.Combine_Closing_File        

insert into general.dbo.Combine_Closing_File 
select SCRIP_CD,SERIES,ISIN,CL_RATE,'BSE_NSE',UPLOAD_ON
from anand1.msajag.dbo.closing_mtm where cast(sysdate as date)= (select max(sysdate)  from anand1.msajag.dbo.closing_mtm)

exec general.dbo.[CSO_MAIL_CombineClosingFile]

Declare @combineCount varchar(10)
set @combineCount=(select count(1) from general.dbo.Combine_Closing_File)


 insert into  intranet.sms.dbo.sms                                                        
 select  Mobile, 'Combine Count:' +@combineCount+ '.' as txt, convert(varchar(10), getdate(), 103),                           
 ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate()))))),                                                          
'P', case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end,'T 7'                                                     
 FROM general.dbo.TBL_USEREMAILID WHERE Module='T+1'     and empname in ('VISHAL KANANI','Vishal Gohil','Navnit Shah','Abha Jaiswal')

 insert into  intranet.sms.dbo.sms                                                        
 select  8779969166, 'Combine Count:' +@combineCount + '.' as txt, convert(varchar(10), getdate(), 103),                           
 ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate()))))),                                                          
'P', case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end,'T 7'                                                     
     

 insert into  intranet.sms.dbo.sms                                                        
 select  07769852028, 'Combine Count:' +@combineCount + '.' as txt, convert(varchar(10), getdate(), 103),                           
 ltrim(rtrim(str(datepart(hh, dateadd(minute, 15, getdate()))))) +':' + ltrim(rtrim(str(datepart(minute, dateadd(minute, 15, getdate()))))),                                                          
'P', case when (datepart(hh, dateadd(minute, 15, getdate()))) >= 12 then 'PM' else 'AM' end,'T 7'                                                     


end try      
begin catch      
insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)      
select GETDATE(),'upd_CP_Combine',ERROR_LINE(),ERROR_MESSAGE()      

     
DECLARE @ErrorMessage NVARCHAR(4000);      
SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());      
RAISERROR (@ErrorMessage , 16, 1);      
end catch;     

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_MCX](@filename as varchar(50))                
as                
BEGIN TRY            
              
 truncate table general.dbo.cp_mcx                
 insert into general.dbo.cp_mcx             
 select * from cp_mcx (nolock)  
 
 update general.dbo.cp_mcx set InstType='OPTFUT' where InstType='FUO'
 update general.dbo.cp_mcx set InstType='FUTCOM' where InstType='COF'
 update general.dbo.cp_mcx set InstType='FUTIDX' where InstType='IDF'

            
  
 --/* To update mimansa table as suggested by manesh sir on Nov 20 2015*/  
  
 --exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'  
truncate table cp_mcx   
          
END TRY  
BEGIN CATCH  
 truncate table cp_mcx         
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_24122017
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_24122017](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
insert into  History.dbo.cp_mcx_hist      
select *,getdate()-2 from general.dbo.cp_mcx 

---------------------Insert New CP-----------------------      
 truncate table general.dbo.cp_mcx              
 insert into general.dbo.cp_mcx           
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,   
 cc1,
 dd,       
 PrevCls,Opening,High,Low,Cl_rate,         
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename=@filename,      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_24122017testsp
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_24122017testsp](@filename as varchar(50))              
as              
BEGIN TRY          

---------------------Insert New CP-----------------------      
 truncate table general.dbo.cp_mcx_test24122017             
 insert into general.dbo.cp_mcx_test24122017         
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,   
 cc1,
 dd,       
 PrevCls,Opening,High,Low,Cl_rate,         
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename=@filename,      
Updated_On=getdate()    
     
from cp_mcx_test24122017 (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 --exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
--truncate table cp_mcx_test24122017 
	
	      
END TRY
BEGIN CATCH
 truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_Abha_NewFormat
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_MCX_Abha_NewFormat](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
--insert into  History.dbo.cp_mcx_hist_newformat   
--select *,getdate()-2 from general.dbo.cp_mcx_newformat    
---------------------Insert New CP----------------------- 
     
 truncate table general.dbo.cp_mcx_newformat        
 insert into general.dbo.cp_mcx_newformat       
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,
 cc1,
 dd,          
 PrevCls,Opening,High,Low,Cl_rate,          
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename='',      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

-- exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
--truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 --truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_bkup_09072024
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_MCX_bkup_09072024](@filename as varchar(50))                
as                
BEGIN TRY            
        -----------------insert CP in History data---------------        
insert into  History.dbo.cp_mcx_hist        
select *,getdate()-2 from general.dbo.cp_mcx   
  
---------------------Insert New CP-----------------------        
 truncate table general.dbo.cp_mcx                
 insert into general.dbo.cp_mcx             
 select             
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),            
 MarketType,InstType,Symbol,            
 ExpiryDate=            
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)             
 else 'Jan 01 1900' end,     
 cc1,  
 dd,         
 PrevCls,Opening,High,Low,Cl_rate,           
 ---ee=convert(int,ee),            
 ee,           
 ff=convert(money,ff),            
 gg=convert(money,gg),            
 hh=convert(money,hh),            
 ii,            
 --jj=convert(money,jj),           
 jj,           
 --kk=convert(int,kk),          
 kk,            
 ll=convert(int,ll),            
 mm=convert(money,mm),        
filename=@filename,        
Updated_On=getdate()      
       
from cp_mcx (nolock)               
            
  
 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/  
  
 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'  
    
   
truncate table cp_mcx   
   
         
END TRY  
BEGIN CATCH  
 truncate table cp_mcx         
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_bkup_12102017
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_bkup_12102017](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
insert into  History.dbo.cp_mcx_hist      
select *,getdate()-2 from general.dbo.cp_mcx     
---------------------Insert New CP-----------------------      
 truncate table general.dbo.cp_mcx              
 insert into general.dbo.cp_mcx           
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,          
 PrevCls,Opening,High,Low,Cl_rate,          
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename=@filename,      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_comm
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_MCX_comm]
(@filename as varchar(50))             
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      

insert into  History.dbo.cp_mcx_hist_comm      
select *,getdate()-2 from general.dbo.cp_mcx_comm 

---------------------Insert New CP-----------------------      
 truncate table general.dbo.cp_mcx_comm              
 insert into general.dbo.cp_mcx_comm           
 select TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,   
 cc1,dd,PrevCls,Opening,High,Low,Cl_rate,         
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename=@filename,      
Updated_On=getdate()    
     
from cp_mcx_comm (nolock)             
          
 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 --exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'

truncate table cp_mcx_comm
	      
END TRY
BEGIN CATCH
 truncate table cp_mcx_comm       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_live_13102017
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_live_13102017](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
insert into  History.dbo.cp_mcx_hist      
select *,getdate()-2 from general.dbo.cp_mcx     
---------------------Insert New CP-----------------------      
 truncate table general.dbo.cp_mcx              
 insert into general.dbo.cp_mcx           
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,          
 PrevCls,Opening,High,Low,Cl_rate,          
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename=@filename,      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_livebkup13102017
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_livebkup13102017](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
insert into  History.dbo.cp_mcx_hist      
select *,getdate()-2 from general.dbo.cp_mcx     
---------------------Insert New CP-----------------------      
 truncate table general.dbo.cp_mcx              
 insert into general.dbo.cp_mcx           
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,          
 PrevCls,Opening,High,Low,Cl_rate,          
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename=@filename,      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_newformat_12102017
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_newformat_12102017](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
--insert into  History.dbo.cp_mcx_hist      
--select *,getdate()-2 from general.dbo.cp_mcx     
---------------------Insert New CP-----------------------      
-- truncate table general.dbo.cp_mcx_test_newFile

--select * into  general.dbo.cp_mcx_test_newFile from general.dbo.cp_mcx     where 1=2              
 insert into  general.dbo.cp_mcx_test_newFile      
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,          
 PrevCls,Opening,High,Low,Cl_rate,          
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename='MCX_MS20170622 New Revised',      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

-- exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
--truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 --truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCX_uat
-- --------------------------------------------------
create procedure [dbo].[upd_CP_MCX_uat](@filename as varchar(50))              
as              
BEGIN TRY          
        -----------------insert CP in History data---------------      
--insert into  History.dbo.cp_mcx_hist_newformat   
--select *,getdate()-2 from general.dbo.cp_mcx_newformat    
---------------------Insert New CP----------------------- 
     
 truncate table general.dbo.cp_mcx_newformat        
 insert into general.dbo.cp_mcx_newformat       
 select           
 TradeDate=substring(tradeDate,3,3)+' '+substring(tradeDate,1,2)+' '+substring(tradeDate,6,4),          
 MarketType,InstType,Symbol,          
 ExpiryDate=          
 case when len(ExpiryDate) > 0 then substring(ExpiryDate,3,3)+' '+substring(ExpiryDate,1,2)+' '+substring(ExpiryDate,6,4)           
 else 'Jan 01 1900' end,
 cc1,
 dd,          
 PrevCls,Opening,High,Low,Cl_rate,          
 ---ee=convert(int,ee),          
 ee,         
 ff=convert(money,ff),          
 gg=convert(money,gg),          
 hh=convert(money,hh),          
 ii,          
 --jj=convert(money,jj),         
 jj,         
 --kk=convert(int,kk),        
 kk,          
 ll=convert(int,ll),          
 mm=convert(money,mm),      
filename='',      
Updated_On=getdate()    
     
from cp_mcx (nolock)             
          

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

-- exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCX'
  
 
--truncate table cp_mcx 
	
	      
END TRY
BEGIN CATCH
 --truncate table cp_mcx       
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_MCXSX
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_MCXSX](@filename as varchar(50))
as
BEGIN TRY
	/*if exists(select * from cp_mcxsx)
	Begin*/
		-----------------insert CP in History data---------------
		insert into History.dbo.cp_mcxsx_hist
		select * from general.dbo.cp_mcxsx

		---------------------Insert New CP-----------------------

		truncate table general.dbo.cp_mcxsx                     

		insert into general.dbo.cp_mcxsx                          
		select convert(datetime,date) as date,instrument,Symbol,convert(DATETIME,expirydate,103) as expirydate,Strike_Price,Options_Type,MTM_Sett_price,currcode,getdate() as updatedon,@filename     
		from cp_mcxsx (nolock)
	 
		/*To update mimansa table as suggested by manesh sir on Nov 23 2015*/

		exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'MCD'
		                
		truncate table cp_mcxsx
	--End
   END TRY        
BEGIN CATCH        
	truncate table cp_mcxsx
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCDEX
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NCDEX](@filename as varchar(50))                  
as                 
     -----------------insert CP in History data---------------           
    
insert into History.dbo.cp_ncdex_hist                 
select aa,InstType,symbol,ExpiryDate,PrevCls,Opening,High,Low,Cl_rate,filename,Update_On,getdate()-2,Option_Type,strike_price from general.dbo.cp_ncdex            
         
---------------------Insert New CP-----------------------          
truncate table general.dbo.cp_ncdex              
BEGIN TRY    
 insert into general.dbo.cp_ncdex               
 select               
 aa=substring(data,1,2),              
 InstType=substring(data,3,6),              
 symbol=substring(data,9,10),              
 ExpiryDate=substring(data,22,3)+' '+substring(data,19,2)+' '+substring(data,26,4),              
 PrevCls=convert(money,substring(data,72,14)),              
 Opening=convert(money,substring(data,86,14)),              
 High=convert(money,substring(data,100,14)),              
 low=convert(money,substring(data,114,14)),              
 cl_rate=convert(money,substring(data,128,14)),              
 filename='',          
 Updated_On=getdate(),    
 Option_Type=substring(data,40,2),    
 srike_price= substring(data,30,7)         
 from cp_ncdx (nolock)      
     
 update general.dbo.cp_ncdex  set  Option_Type='' where option_type='FF'    
     
 /*To update mimansa table as suggested by manesh sir on Nov 23 2015*/    
    
 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NCDEX'     
             
 truncate table cp_ncdx      
END TRY    
BEGIN CATCH    
 truncate table cp_ncdx      
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCDEX_08012018
-- --------------------------------------------------
create procedure [dbo].[upd_CP_NCDEX_08012018](@filename as varchar(50))              
as             
     -----------------insert CP in History data---------------       
    
insert into History.dbo.cp_ncdex_hist             
select *,getdate()-2 from general.dbo.cp_ncdex        
     
---------------------Insert New CP-----------------------      
truncate table general.dbo.cp_ncdex          
BEGIN TRY
 insert into general.dbo.cp_ncdex           
 select           
 aa=substring(data,1,2),          
 InstType=substring(data,3,6),          
 symbol=substring(data,9,10),          
 ExpiryDate=substring(data,22,3)+' '+substring(data,19,2)+' '+substring(data,26,4),          
 PrevCls=convert(money,substring(data,72,14)),          
 Opening=convert(money,substring(data,86,14)),          
 High=convert(money,substring(data,100,14)),          
 low=convert(money,substring(data,114,14)),          
 cl_rate=convert(money,substring(data,128,14)),          
 filename=@filename,      
 Updated_On=getdate()      
 from cp_ncdx (nolock)  
	
	/*To update mimansa table as suggested by manesh sir on Nov 23 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NCDEX' 
         
 truncate table cp_ncdx  
END TRY
BEGIN CATCH
 truncate table cp_ncdx  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCDEX_comm
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NCDEX_comm](@filename as varchar(50))                
as               
     -----------------insert CP in History data---------------         
insert into History.dbo.cp_ncdex_hist_comm               
select aa,InstType,symbol,ExpiryDate,PrevCls,Opening,High,Low,Cl_rate,filename,Update_On,getdate()-2,Option_Type,strike_price from general.dbo.cp_ncdex_comm          
      
---------------------Insert New CP-----------------------        
truncate table general.dbo.cp_ncdex_comm            
BEGIN TRY  
 insert into general.dbo.cp_ncdex_comm             
 select             
 aa=substring(data,1,2),            
 InstType=substring(data,3,6),            
 symbol=substring(data,9,10),            
 ExpiryDate=substring(data,22,3)+' '+substring(data,19,2)+' '+substring(data,26,4),            
 PrevCls=convert(money,substring(data,72,14)),            
 Opening=convert(money,substring(data,86,14)),            
 High=convert(money,substring(data,100,14)),            
 low=convert(money,substring(data,114,14)),            
 cl_rate=convert(money,substring(data,128,14)),            
 filename='',        
 Updated_On=getdate(),  
 Option_Type=substring(data,40,2),  
 srike_price= substring(data,30,7)       
 from cp_ncdex_comm (nolock)    
   
 update general.dbo.cp_ncdex_comm  set  Option_Type='' where option_type='FF'  
   
 /*To update mimansa table as suggested by manesh sir on Nov 23 2015*/  
  
 --exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NCDEX'   
           
 truncate table cp_ncdex_comm    
END TRY  
BEGIN CATCH  
 truncate table cp_ncdex_comm    
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCDEX_livebkup_13012018
-- --------------------------------------------------
create procedure [dbo].[upd_CP_NCDEX_livebkup_13012018](@filename as varchar(50))              
as             
     -----------------insert CP in History data---------------       
    
insert into History.dbo.cp_ncdex_hist             
select *,getdate()-2 from general.dbo.cp_ncdex        
     
---------------------Insert New CP-----------------------  
    
truncate table general.dbo.cp_ncdex          
BEGIN TRY
 insert into general.dbo.cp_ncdex           
 select           
 aa=substring(data,1,2),          
 InstType=substring(data,3,6),          
 symbol=substring(data,9,10),          
 ExpiryDate=substring(data,22,3)+' '+substring(data,19,2)+' '+substring(data,26,4),          
 PrevCls=convert(money,substring(data,72,14)),          
 Opening=convert(money,substring(data,86,14)),          
 High=convert(money,substring(data,100,14)),          
 low=convert(money,substring(data,114,14)),          
 cl_rate=convert(money,substring(data,128,14)),          
 filename=@filename,      
 Updated_On=getdate()      
 from cp_ncdx (nolock)  
	
	/*To update mimansa table as suggested by manesh sir on Nov 23 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NCDEX' 


         
 truncate table cp_ncdx  
END TRY
BEGIN CATCH
 truncate table cp_ncdx  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCDEX_Makelive_08012018
-- --------------------------------------------------
create procedure [dbo].[upd_CP_NCDEX_Makelive_08012018](@filename as varchar(50))              
as             
     -----------------insert CP in History data---------------       


   
insert into History.dbo.cp_ncdex_hist             
select aa,InstType,symbol,ExpiryDate,PrevCls,Opening,High,Low,Cl_rate,filename,Update_On,getdate()-2,Option_Type,strike_price from general.dbo.cp_ncdex        
     
---------------------Insert New CP-----------------------      
truncate table general.dbo.cp_ncdex          
BEGIN TRY
 insert into general.dbo.cp_ncdex           
 select           
 aa=substring(data,1,2),          
 InstType=substring(data,3,6),          
 symbol=substring(data,9,10),          
 ExpiryDate=substring(data,22,3)+' '+substring(data,19,2)+' '+substring(data,26,4),          
 PrevCls=convert(money,substring(data,72,14)),          
 Opening=convert(money,substring(data,86,14)),          
 High=convert(money,substring(data,100,14)),          
 low=convert(money,substring(data,114,14)),          
 cl_rate=convert(money,substring(data,128,14)),          
 filename=@filename,      
 Updated_On=getdate(),
 Option_Type=substring(data,40,2),
 srike_price= substring(data,30,7)     
 from cp_ncdx (nolock)  
	
	/*To update mimansa table as suggested by manesh sir on Nov 23 2015*/

 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NCDEX' 
         
 truncate table cp_ncdx  
END TRY
BEGIN CATCH
 truncate table cp_ncdx  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCDEX_test
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NCDEX_test](@filename as varchar(50))                
as               
     -----------------insert CP in History data---------------         
      
--insert into History.dbo.cp_ncdex_hist               
--select *,getdate()-2 from general.dbo.cp_ncdex   
  
--select aa,InstType,symbol,ExpiryDate,PrevCls,Opening,High,Low,Cl_rate,filename,Update_On,Option_type=''  
-- into  general.dbo.cp_ncdex_test  from  general.dbo.cp_ncdex  where 1=2         
       
---------------------Insert New CP-----------------------   
alter table general.dbo.cp_ncdex_test  add  srike_price money    
  
truncate table general.dbo.cp_ncdex_test            
BEGIN TRY  
 insert into general.dbo.cp_ncdex_test             
 select             
 aa=substring(data,1,2),  
 InstType =substring(data,3,6),                  
 symbol=substring(data,9,10),            
 ExpiryDate=cast(substring(data,22,3)+' '+substring(data,19,2)+' '+substring(data,26,4) as datetime),            
 PrevCls=convert(money,substring(data,72,14)),            
 Opening=convert(money,substring(data,86,14)),            
 High=convert(money,substring(data,100,14)),            
 low=convert(money,substring(data,114,14)),            
 cl_rate=convert(money,substring(data,128,14)),   
 filename=convert(varchar(3),@filename),        
 Updated_On=getdate(),  
 Option_Type=substring(data,40,2),  
 srike_price= substring(data,30,7)       
 from cp_ncdex_test (nolock)  where substring(data,1,2)<>'01'  
   
 /*To update mimansa table as suggested by manesh sir on Nov 23 2015*/  
  
-- exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NCDEX'   
           
truncate table cp_ncdex_test    
END TRY  
BEGIN CATCH  
truncate table cp_ncdex_test    
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NCE
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NCE](@filename as varchar(50))                    
as                    
BEGIN TRY                
                  
 truncate table general.dbo.cp_nce                   
 insert into general.dbo.cp_nce               
 select * from cp_nce(nolock)      
     
 update general.dbo.cp_nce set InstType='OPTFUT' where InstType='FUO'    
 update general.dbo.cp_nce set InstType='FUTCOM' where InstType='COF'    
 update general.dbo.cp_nce set InstType='FUTIDX' where InstType='IDF'    
    
truncate table cp_nce       
              
END TRY      
BEGIN CATCH      
 truncate table cp_nce             
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NSECM
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NSECM]  



 @filename as varchar(50)  



as  



BEGIN TRY  



  



-------added to avoid duplication due to multiple times uploading in the same day----------  



delete a  



from History.dbo.cp_nsecm_hist a  



join general.dbo.cp_nsecm b  



on a.cls_date = b.updated_on  



  



-----------------insert CP in History data---------------  



insert into History.dbo.cp_nsecm_hist  



select * from general.dbo.cp_nsecm  



  



---------------------Insert New CP-----------------------  



truncate table general.dbo.cp_nsecm  



  



insert into general.dbo.cp_nsecm  



select distinct *,@filename,convert(varchar(10),getdate(),121)  



from cp_nsecm  



/*To update mimansa table as suggested by manesh sir on Nov 20 2015*/



 exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NSECM'



truncate table cp_nsecm  



  



END TRY  



BEGIN CATCH  



truncate table cp_nsecm  



END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NSECM_Manual
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NSECM_Manual](@filename as varchar(50))        
as        
BEGIN TRY

-------added to avoid duplication due to multiple times uploading in the same day.----------
delete a 
from History.dbo.cp_nsecm_hist a
join general.dbo.cp_nsecm b
on convert(varchar(10),a.cls_date,121) = convert(varchar(10),b.updated_on,121)

-----------------insert CP in History data---------------      
insert into History.dbo.cp_nsecm_hist      
select * from general.dbo.cp_nsecm     
  
---------------------Insert New CP-----------------------      
truncate table general.dbo.cp_nsecm        

insert into general.dbo.cp_nsecm 
select distinct *,@filename,getdate()
from CP_NSECM_Manual

truncate table CP_NSECM_Manual 
END TRY
BEGIN CATCH
truncate table CP_NSECM_Manual 
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NSEFO
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NSEFO]  
 @filename as varchar(50)  
as        
BEGIN TRY  
  
 --delete a   
 --from History.dbo.cp_nseFO_Hist a  
 --join general.dbo.cp_nseFO b  
 --on a.cls_date = b.update_date  
  
 --------------------insert CP into History-----------------  
 --insert into History.dbo.cp_nseFO_Hist  
 --select * from general.dbo.cp_nseFO  
  
 ------------------------Insert New CP---------------------  
 truncate table general.dbo.cp_nseFO  
  
 insert into general.dbo.cp_nseFO  
 select distinct *,@filename,convert(varchar(10),getdate(),121)  
 from cp_nseFO  
  
 -- /* To update mimansa table as suggested by manesh sir on Nov 23 2015*/  
    exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NSEFO'  
  
  
 truncate table cp_nseFO  
END TRY  
BEGIN CATCH  
 truncate table cp_nseFO  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NSEFO_newFormay
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NSEFO_newFormay]

	@filename as varchar(50)

as      

BEGIN TRY



	

	------------------------Insert New CP---------------------

	truncate table general.dbo.cp_nseFO_newformat



	insert into general.dbo.cp_nseFO_newformat

	select distinct *,@filename,convert(varchar(10),getdate(),121)

	from cp_nseFO_newformat



	 /* To update mimansa table as suggested by manesh sir on Nov 23 2015*/









	truncate table cp_nseFO

END TRY

BEGIN CATCH

	truncate table cp_nseFO

END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NSEFO_TESTdate
-- --------------------------------------------------
CREATE procedure  upd_CP_NSEFO_TESTdate  
 @filename as nvarchar(50)  
as        
begin
  
 print @filename
  
 truncate table cp_nseFOTestfile 
  
 insert into cp_nseFOTestfile 
 select distinct *,@filename,convert(varchar(10),getdate(),121)  
 from cp_nseFO  
 end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_CP_NSX
-- --------------------------------------------------
CREATE procedure [dbo].[upd_CP_NSX](@filename as varchar(50))                
as                
BEGIN TRY          
        -----------------insert CP in History data---------------         
insert into History.dbo.Cp_Nsx_Hist  
select * from  general.dbo.cp_nsx     
---------------------Insert New CP-----------------------         
 truncate table general.dbo.cp_nsx          
insert into general.dbo.cp_nsx      
      
select mkt_type,Instrument,      
Symbol,      
Contract_Date=convert(datetime,Contract_Date,103),      
aa,bb,      
PREVIOUS,      
OPEN_PRICE,HIGH_PRICE,      
LOW_PRICE,      
CLOSE_PRICE,      
TRADED_QUA,      
TRADED_VAL,      
cc,dd,      
filename=@filename,      
updated_on=getdate()      
from cp_nsx (nolock) 

/*To update mimansa table as suggested by manesh sir on Nov 23 2015*/

  exec [MIMANSA].NRMS.DBO.[USP_NRMS_SyncClosingRate] 'NSX'
   
 truncate table cp_nsx          
END TRY
BEGIN CATCH
 truncate table cp_nsx          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_CSV_Auto_Mailer
-- --------------------------------------------------




-- author:		abha jaiswal
-- create date: 27/04/2021
-- description:	csv mailer
-- =============================================
--upd_csv_auto_mailer '','',''
CREATE procedure [dbo].[Upd_CSV_Auto_Mailer]
@filename as varchar(50),      
@ipaddress as varchar(25),                          
@enteredby as varchar(15) 
as
begin
	
	truncate table general.dbo.tbl_csv_upload                                
	insert into general.dbo.tbl_csv_upload                         
	select *,@filename             
	from tbl_csv_upload with (nolock)  
	
	declare @strattach varchar(500),@msgbody varchar(5000),@sub varchar(500)   
	declare @entitytype varchar(11),@entitycode varchar(11),@query varchar(max),@title varchar(100),@sqlstatement varchar(1000) 

	truncate table  general.dbo.tbl_csv_mailerdata 
	insert into  general.dbo.tbl_csv_mailerdata 
    select replace(data,'1region','region') as data from 
	(
	select heading as data from general.dbo.csv_data_heading where rtype ='all' 
	union 
	select data from general.dbo.tbl_fetch_csv_drcr_data a where client in (select distinct party_code from general.dbo.tbl_csv_upload) 
	)a
	
	declare @var varchar(max),@strFileName1 varchar (500)                            
	
	SET @var= 'exec MASTER.DBO.XP_CMDSHELL ' + ''''      
	SET @var= @var + 'bcp "select data from  [CSOKYC-6].general.dbo.tbl_csv_mailerdata " queryout \\INHOUSELIVEAPP2-FS.angelone.in\nrms\csv_data\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv -c -t"," -SABVSNRMS.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'
	--SET @var= @var + 'bcp "select data from  [CSOKYC-6].general.dbo.tbl_csv_mailerdata " queryout \\AOPR0SVINHOUSE1\nrms\csv_data\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv -c -t"," -SABVSNRMS.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'
	--SET @var= @var + 'bcp "select data from  [196.1.115.182].general.dbo.tbl_csv_mailerdata " queryout \\196.1.115.183\nrms\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv -c -t"," -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'
   
	SET @var = @var + ''''
                                                 
	EXEC(@var) 
	print @var

	set @msgbody = ''                          
	set @msgbody = @msgbody + '                                                      
	Dear team,
 
	  <p> please find attached csv data.<br/><br/>
                                           
	  thanks & regards,<br/>                            
	  csorm                           
	   '                          
                       
	   --set @sub='square off t+7 exemption  '  + @accesscode                           
	   set @sub='csv data '                          
       set @strFileName1='\\INHOUSELIVEAPP2-FS.angelone.in\nrms\csv_data\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv'
                      
	   exec msdb.dbo.sp_send_dbmail                                                 
	   @profile_name ='square',                                                      
	   @recipients = 'vishal@angelbroking.com;miral.lad@angelbroking.com;bhagyashree.pradhan@angelbroking.com;pritesh.gangwal@angelbroking.com;b2brisk@angelbroking.com;vipul.parmar@angelbroking.com;ankita@angelbroking.com;',                 
	   @copy_recipients= 'csorm@angelbroking.com;sanjay.nadiyapara@angelbroking.com;B2crisk@angelbroking.com;csosurveillance@angelone.in;tushar.jorigal@angelone.in;chandrakant.jadhav@angelone.in',                                    
	   @file_attachments= @strFileName1,                                               
	   @body = @msgbody,                                               
	   @body_format ='html',                                                
	   @subject =@sub 

	   

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_CSV_Auto_Mailer_abha
-- --------------------------------------------------



-- author:		abha jaiswal
-- create date: 27/04/2021
-- description:	csv mailer
-- =============================================
--Upd_CSV_Auto_Mailer_abha 'Open positon -- Deepak','',''
CREATE procedure [dbo].[Upd_CSV_Auto_Mailer_abha]
@filename as varchar(50),      
@ipaddress as varchar(25),                          
@enteredby as varchar(15) 
as
begin
	
	truncate table general.dbo.tbl_csv_upload                                
	insert into general.dbo.tbl_csv_upload                         
	select *,@filename        
	from tbl_csv_upload with (nolock)  
	
	declare @strattach varchar(500),@msgbody varchar(5000),@sub varchar(500)   
	declare @entitytype varchar(11),@entitycode varchar(11),@query varchar(max),@title varchar(100),@sqlstatement varchar(1000) 

	truncate table  general.dbo.tbl_csv_mailerdata 
	insert into  general.dbo.tbl_csv_mailerdata 
    select replace(data,'1region','region') as data from 
	(
	select heading as data from general.dbo.csv_data_heading where rtype ='all' 
	union 
	select data from general.dbo.tbl_fetch_csv_drcr_data a where client in (select distinct party_code from general.dbo.tbl_csv_upload) 
	)a
	
	declare @var varchar(max),@strFileName1 varchar (500)                            
	
	SET @var= 'exec MASTER.DBO.XP_CMDSHELL ' + ''''                                         
	SET @var= @var + 'bcp "select data from  [CSOKYC-6].general.dbo.tbl_csv_mailerdata " queryout \\172.29.19.16\Public\CSVDATA\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv -c -t"," -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'   
	SET @var = @var + ''''
                                                 
	EXEC(@var) 
	print @var

	set @msgbody = ''                          
	set @msgbody = @msgbody + '                                                      
	Dear team,
 
	  <p> please find attached csv data.<br/><br/>
                                           
	  thanks & regards,<br/>                            
	  csorm                           
	   '                          
                       
	   --set @sub='square off t+7 exemption  '  + @accesscode                           
	   set @sub='csv data '                          
       set @strFileName1='\\172.29.19.16\Public\CSVDATA\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv'
                      
	   exec msdb.dbo.sp_send_dbmail                                                 
	   @profile_name ='square',                                                      
	   @recipients = 'vishal@angelbroking.com;miral.lad@angelbroking.com;bhagyashree.pradhan@angelbroking.com;',                 
	   @copy_recipients= 'csorm@angelbroking.com;sanjay.nadiyapara@angelbroking.com;B2crisk@angelbroking.com;',                                    
	   @file_attachments= @strFileName1,                                               
	   @body = @msgbody,                                               
	   @body_format ='html',                                                
	   @subject =@sub 



end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_CSV_Auto_Mailer_bkup_live_29122021
-- --------------------------------------------------




-- author:		abha jaiswal
-- create date: 27/04/2021
-- description:	csv mailer
-- =============================================
--upd_csv_auto_mailer '','',''
CREATE procedure [dbo].[Upd_CSV_Auto_Mailer_bkup_live_29122021]
@filename as varchar(50),      
@ipaddress as varchar(25),                          
@enteredby as varchar(15) 
as
begin
	
	truncate table general.dbo.tbl_csv_upload                                
	insert into general.dbo.tbl_csv_upload                         
	select *,@filename             
	from tbl_csv_upload with (nolock)  
	
	declare @strattach varchar(500),@msgbody varchar(5000),@sub varchar(500)   
	declare @entitytype varchar(11),@entitycode varchar(11),@query varchar(max),@title varchar(100),@sqlstatement varchar(1000) 

	truncate table  general.dbo.tbl_csv_mailerdata 
	insert into  general.dbo.tbl_csv_mailerdata 
    select replace(data,'1region','region') as data from 
	(
	select heading as data from general.dbo.csv_data_heading where rtype ='all' 
	union 
	select data from general.dbo.tbl_fetch_csv_drcr_data a where client in (select distinct party_code from general.dbo.tbl_csv_upload) 
	)a
	
	declare @var varchar(max),@strFileName1 varchar (500)                            
	
	SET @var= 'exec MASTER.DBO.XP_CMDSHELL ' + ''''                                         
	SET @var= @var + 'bcp "select data from  [196.1.115.182].general.dbo.tbl_csv_mailerdata " queryout H:\MindGate\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv -c -t"," -Sintranet -Uinhouse -Pinh6014'
   
	SET @var = @var + ''''
                                                 
	EXEC(@var) 
	print @var

	set @msgbody = ''                          
	set @msgbody = @msgbody + '                                                      
	Dear team,
 
	  <p> please find attached csv data.<br/><br/>
                                           
	  thanks & regards,<br/>                            
	  csorm                           
	   '                          
                       
	   --set @sub='square off t+7 exemption  '  + @accesscode                           
	   set @sub='csv data '                          
       set @strFileName1='H:\MindGate\csv_data_'+replace(convert(varchar,getdate(),103),'/','')+'.csv'
                      
	   exec msdb.dbo.sp_send_dbmail                                                 
	   @profile_name ='square',                                                      
	   @recipients = 'vishal@angelbroking.com;miral.lad@angelbroking.com;bhagyashree.pradhan@angelbroking.com;',                 
	   @copy_recipients= 'csorm@angelbroking.com;sanjay.nadiyapara@angelbroking.com;B2crisk@angelbroking.com;',                                    
	   @file_attachments= @strFileName1,                                               
	   @body = @msgbody,                                               
	   @body_format ='html',                                                
	   @subject =@sub 



end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_CTM_File
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_CTM_File](@filename as varchar(500))    
as                    
BEGIN TRY    
 TRUNCATE TABLE general.dbo.tbl_FCTM_Expiry    
  
 INSERT INTO general.dbo.tbl_FCTM_Expiry   
 select *,@filename,convert(varchar(11),getdate()) from tbl_FCTM_Expiry    
           
 TRUNCATE TABLE tbl_FCTM_Expiry                  
END TRY              
BEGIN CATCH              
 TRUNCATE TABLE tbl_FCTM_Expiry            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_curr_settprice
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_curr_settprice](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_curr_settPrice  

 INSERT INTO general.dbo.tbl_curr_settPrice 
 select *,@filename,convert(varchar(11),getdate()) from tbl_curr_settPrice  
         
 TRUNCATE TABLE tbl_curr_settPrice                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_curr_settPrice          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_Equity_Turnover
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_Equity_Turnover](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_equity_turnover  

 INSERT INTO general.dbo.tbl_equity_turnover 
 select *,@filename,convert(varchar(11),getdate()) from tbl_equity_turnover  
         
 TRUNCATE TABLE tbl_equity_turnover                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_equity_turnover          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_Exception_File
-- --------------------------------------------------

--select * from tbl_upload where upd_srno=28      
CREATE  procedure [dbo].[upd_Exception_File](@filename as varchar(50))                        
as                        
BEGIN TRY         
             
truncate table general.dbo.Tbl_All_Squareoff_Exception_File                        
insert into general.dbo.Tbl_All_Squareoff_Exception_File                 
select *,@filename                
from Tbl_All_Squareoff_Exception_File with (nolock)                
        
insert into history.dbo.Tbl_All_Squareoff_Exception_File            
select *,@filename                
from Tbl_All_Squareoff_Exception_File with (nolock)             
        
truncate table Tbl_All_Squareoff_Exception_File       
      
/*Proj Risk Exception */      
      
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                 
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS='Corporate action / branch call',                
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527'                
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   on A.party_code=B.party_code --133      
                 
UPDATE  general.dbo.SQUAREUP_CLIENT SET EXEMPTION='Y',REMARKS='Corporate action / branch call',LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527'  where party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)        
        
/*NBFC Proj Risk SquareOff Exception*/          
      
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY        
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,        
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS='172.29.30.51',        
ENTERED_BY='E02527'        
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)     
on A.party_code=B.party_code --2      
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)      
        
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC SET EXEMPTION='Y',REMARKS='Corporate action / branch call'      
WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))        
      
      
/*NBFC Margin Shortage Exception*/            
      
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST           
SELECT         
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,        
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,        
Email,Exemption='Y',Remarks='Corporate action / branch call',AMOUNT,SOURCE_TYPE,IPADDRESS='172.29.30.51',ENTERED_BY='E02527'         
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.Client_Code=B.party_code  --194       
--WHERE Client_code =@PARTY_CODE           
                
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'       
WHERE Client_Code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          

/*     
/* VMSS Exception */      
      
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                 
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,            
update_date=GETDATE(),Mobile_pager,              
Email,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
 */     
     
/*Ageing Exception*/        
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY   
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS='Corporate action / branch call' ,  
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS='172.29.30.51',   
 ENTERED_BY='E02527'    
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
        
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'  WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))     
 
/* MTF Exception */

           
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,            
update_date=GETDATE(),Mobile_pager,              
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
 

/*
/*MTF Ageing T+7 Exception*/
INSERT INTO general.dbo.MTF_AgeingT7_sqoff_client_exp_hist        
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,MTF_T7_Shortage_AfterAdj,Square_Off_Value,Square_off_day,            
update_date=GETDATE(),Mobile_pager,              
Email,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM general.dbo.MTF_AgeingT7_sqoff_client_exp  A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE MTF_AgeingT7_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
 
*/
           
END TRY          
BEGIN CATCH          
truncate table Tbl_All_Squareoff_Exception_File           
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_Exception_File_03082017
-- --------------------------------------------------
--select * from tbl_upload where upd_srno=28    
create  procedure [dbo].[upd_Exception_File_03082017](@filename as varchar(50))                      
as                      
BEGIN TRY       
           
truncate table general.dbo.Tbl_All_Squareoff_Exception_File                      
insert into general.dbo.Tbl_All_Squareoff_Exception_File               
select *,@filename              
from Tbl_All_Squareoff_Exception_File with (nolock)              
      
insert into history.dbo.Tbl_All_Squareoff_Exception_File          
select *,@filename              
from Tbl_All_Squareoff_Exception_File with (nolock)           
      
truncate table Tbl_All_Squareoff_Exception_File     
    
/*Proj Risk Exception */    
    
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY               
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS='Corporate action / branch call',              
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527'              
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   on A.party_code=B.party_code --133    
               
UPDATE  general.dbo.SQUAREUP_CLIENT SET EXEMPTION='Y',REMARKS='Corporate action / branch call',LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527'  where party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)      
      
/*NBFC Proj Risk SquareOff Exception*/        
    
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY      
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,      
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS='172.29.30.51',      
ENTERED_BY='E02527'      
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   
on A.party_code=B.party_code --2    
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)    
      
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC SET EXEMPTION='Y',REMARKS='Corporate action / branch call'    
WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))      
    
    
/*NBFC Margin Shortage Exception*/          
    
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST         
SELECT       
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,      
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,      
Email,Exemption='Y',Remarks='Corporate action / branch call',AMOUNT,SOURCE_TYPE,IPADDRESS='172.29.30.51',ENTERED_BY='E02527'       
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.Client_Code=B.party_code  --194     
--WHERE Client_code =@PARTY_CODE         
              
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'     
WHERE Client_Code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))        
    
/* VMSS Exception */    
    
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST               
SELECT             
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,          
update_date=GETDATE(),Mobile_pager,            
Email,Exception='Y',Remarks='Corporate action / branch call' ,            
AMOUNT,SOURCE_TYPE,            
IPADDRESS='172.29.30.51',               
ENTERED_BY='E02527'             
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                
--WHERE party_code =@PARTY_CODE    --732           
                    
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',            
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))        
    
 /*   
/*Ageing Exception*/      
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY 
 SELECT region,branch,sb,party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION=@EXEMPTION,REMARKS=@REMARKS,
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPADDRESS, 
 ENTERED_BY=@ENTEREDBY
 FROM SQUAREUP_CLIENT_T7_EXP
 WHERE PARTY_CODE =@PARTY_CODE 
      
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP SET EXEMPTION=@EXEMPTION,REMARKS=@REMARKS WHERE PARTY_CODE=@PARTY_CODE 
  */          
END TRY        
BEGIN CATCH        
truncate table Tbl_All_Squareoff_Exception_File         
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_Exception_File_28082017
-- --------------------------------------------------
--select * from tbl_upload where upd_srno=28      
CREATE  procedure [dbo].[upd_Exception_File_28082017](@filename as varchar(50))                        
as                        
BEGIN TRY         
             
truncate table general.dbo.Tbl_All_Squareoff_Exception_File                        
insert into general.dbo.Tbl_All_Squareoff_Exception_File                 
select *,@filename                
from Tbl_All_Squareoff_Exception_File with (nolock)                
        
insert into history.dbo.Tbl_All_Squareoff_Exception_File            
select *,@filename                
from Tbl_All_Squareoff_Exception_File with (nolock)             
        
truncate table Tbl_All_Squareoff_Exception_File       
      
/*Proj Risk Exception */      
      
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                 
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS='Corporate action / branch call',                
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527'                
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   on A.party_code=B.party_code --133      
                 
UPDATE  general.dbo.SQUAREUP_CLIENT SET EXEMPTION='Y',REMARKS='Corporate action / branch call',LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527'  where party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)        
        
/*NBFC Proj Risk SquareOff Exception*/          
      
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY        
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,        
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS='172.29.30.51',        
ENTERED_BY='E02527'        
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)     
on A.party_code=B.party_code --2      
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)      
        
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC SET EXEMPTION='Y',REMARKS='Corporate action / branch call'      
WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))        
      
      
/*NBFC Margin Shortage Exception*/            
      
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST           
SELECT         
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,        
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,        
Email,Exemption='Y',Remarks='Corporate action / branch call',AMOUNT,SOURCE_TYPE,IPADDRESS='172.29.30.51',ENTERED_BY='E02527'         
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.Client_Code=B.party_code  --194       
--WHERE Client_code =@PARTY_CODE           
                
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'       
WHERE Client_Code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
      
/* VMSS Exception */      
      
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                 
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,            
update_date=GETDATE(),Mobile_pager,              
Email,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
      
     
/*Ageing Exception*/        
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY   
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS='Corporate action / branch call' ,  
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS='172.29.30.51',   
 ENTERED_BY='E02527'    
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
        
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'  WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))     
           
END TRY          
BEGIN CATCH          
truncate table Tbl_All_Squareoff_Exception_File           
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_Exception_File_bkup_beforeprocess_09022018
-- --------------------------------------------------
  
--select * from tbl_upload where upd_srno=28        
CREATE  procedure [dbo].[upd_Exception_File_bkup_beforeprocess_09022018](@filename as varchar(50))                          
as                          
BEGIN TRY           
               
truncate table general.dbo.Tbl_All_Squareoff_Exception_File                          
insert into general.dbo.Tbl_All_Squareoff_Exception_File                   
select *,@filename                  
from Tbl_All_Squareoff_Exception_File with (nolock)                  
          
insert into history.dbo.Tbl_All_Squareoff_Exception_File              
select *,@filename                  
from Tbl_All_Squareoff_Exception_File with (nolock)               
          
truncate table Tbl_All_Squareoff_Exception_File         
        
/*Proj Risk Exception */        
        
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                   
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS='Corporate action / branch call',                  
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                  
ENTERED_BY='E02527'                  
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   on A.party_code=B.party_code --133        
                   
UPDATE  general.dbo.SQUAREUP_CLIENT SET EXEMPTION='Y',REMARKS='Corporate action / branch call',LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                  
ENTERED_BY='E02527'  where party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)          
          
/*NBFC Proj Risk SquareOff Exception*/            
        
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY          
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,          
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS='172.29.30.51',          
ENTERED_BY='E02527'          
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)       
on A.party_code=B.party_code --2        
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)        
          
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC SET EXEMPTION='Y',REMARKS='Corporate action / branch call'        
WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
        
        
/*NBFC Margin Shortage Exception*/              
        
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST             
SELECT           
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,          
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,          
Email,Exemption='Y',Remarks='Corporate action / branch call',AMOUNT,SOURCE_TYPE,IPADDRESS='172.29.30.51',ENTERED_BY='E02527'           
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.Client_Code=B.party_code  --194         
--WHERE Client_code =@PARTY_CODE             
                  
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'         
WHERE Client_Code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
  
/*       
/* VMSS Exception */        
        
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                   
SELECT                 
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,              
update_date=GETDATE(),Mobile_pager,                
Email,Exception='Y',Remarks='Corporate action / branch call' ,                
AMOUNT,SOURCE_TYPE,                
IPADDRESS='172.29.30.51',                   
ENTERED_BY='E02527'                 
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
--WHERE party_code =@PARTY_CODE    --732               
                        
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
 */       
       
/*Ageing Exception*/          
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY     
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS='Corporate action / branch call' ,    
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS='172.29.30.51',     
 ENTERED_BY='E02527'      
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
          
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'  WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))       
   
/* MTF Exception */  
  
             
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                  
SELECT                 
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,              
update_date=GETDATE(),Mobile_pager,                
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks='Corporate action / branch call' ,                
AMOUNT,SOURCE_TYPE,                
IPADDRESS='172.29.30.51',                   
ENTERED_BY='E02527'                 
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
--WHERE party_code =@PARTY_CODE    --732               
                        
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
   
  
/*  
/*MTF Ageing T+7 Exception*/  
INSERT INTO general.dbo.MTF_AgeingT7_sqoff_client_exp_hist          
SELECT                 
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,MTF_T7_Shortage_AfterAdj,Square_Off_Value,Square_off_day,              
update_date=GETDATE(),Mobile_pager,                
Email,Exception='Y',Remarks='Corporate action / branch call' ,                
AMOUNT,SOURCE_TYPE,                
IPADDRESS='172.29.30.51',                   
ENTERED_BY='E02527'                 
FROM general.dbo.MTF_AgeingT7_sqoff_client_exp  A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
--WHERE party_code =@PARTY_CODE    --732               
                        
UPDATE MTF_AgeingT7_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
   
*/  
             
END TRY            
BEGIN CATCH            
truncate table Tbl_All_Squareoff_Exception_File             
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_Exception_File_bkup14022018
-- --------------------------------------------------

--select * from tbl_upload where upd_srno=28      
create  procedure [dbo].[upd_Exception_File_bkup14022018](@filename as varchar(50))                        
as                        
BEGIN TRY         
             
truncate table general.dbo.Tbl_All_Squareoff_Exception_File                        
insert into general.dbo.Tbl_All_Squareoff_Exception_File                 
select *,@filename                
from Tbl_All_Squareoff_Exception_File with (nolock)                
        
insert into history.dbo.Tbl_All_Squareoff_Exception_File            
select *,@filename                
from Tbl_All_Squareoff_Exception_File with (nolock)             
        
truncate table Tbl_All_Squareoff_Exception_File       
      
/*Proj Risk Exception */      
      
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                 
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS='Corporate action / branch call',                
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527'                
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   on A.party_code=B.party_code --133      
                 
UPDATE  general.dbo.SQUAREUP_CLIENT SET EXEMPTION='Y',REMARKS='Corporate action / branch call',LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527'  where party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)        
        
/*NBFC Proj Risk SquareOff Exception*/          
      
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY        
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,        
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS='172.29.30.51',        
ENTERED_BY='E02527'        
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)     
on A.party_code=B.party_code --2      
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)      
        
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC SET EXEMPTION='Y',REMARKS='Corporate action / branch call'      
WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))        
      
      
/*NBFC Margin Shortage Exception*/            
      
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST           
SELECT         
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,        
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,        
Email,Exemption='Y',Remarks='Corporate action / branch call',AMOUNT,SOURCE_TYPE,IPADDRESS='172.29.30.51',ENTERED_BY='E02527'         
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.Client_Code=B.party_code  --194       
--WHERE Client_code =@PARTY_CODE           
                
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'       
WHERE Client_Code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          

/*     
/* VMSS Exception */      
      
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                 
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,            
update_date=GETDATE(),Mobile_pager,              
Email,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
 */     
     
/*Ageing Exception*/        
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY   
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS='Corporate action / branch call' ,  
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS='172.29.30.51',   
 ENTERED_BY='E02527'    
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
        
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'  WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))     
 
/* MTF Exception */

           
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,            
update_date=GETDATE(),Mobile_pager,              
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
 

/*
/*MTF Ageing T+7 Exception*/
INSERT INTO general.dbo.MTF_AgeingT7_sqoff_client_exp_hist        
SELECT               
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,MTF_T7_Shortage_AfterAdj,Square_Off_Value,Square_off_day,            
update_date=GETDATE(),Mobile_pager,              
Email,Exception='Y',Remarks='Corporate action / branch call' ,              
AMOUNT,SOURCE_TYPE,              
IPADDRESS='172.29.30.51',                 
ENTERED_BY='E02527'               
FROM general.dbo.MTF_AgeingT7_sqoff_client_exp  A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                  
--WHERE party_code =@PARTY_CODE    --732             
                      
UPDATE MTF_AgeingT7_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',              
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
 
*/
           
END TRY          
BEGIN CATCH          
truncate table Tbl_All_Squareoff_Exception_File           
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_Exception_File_MakeLive_09022018
-- --------------------------------------------------
  
--select * from tbl_upload where upd_srno=28        
CREATE procedure [dbo].[upd_Exception_File_MakeLive_09022018](@filename as varchar(50))                          
as                          
BEGIN TRY           
               
truncate table general.dbo.Tbl_All_Squareoff_Exception_File                          
insert into general.dbo.Tbl_All_Squareoff_Exception_File                   
select *,@filename                  
from Tbl_All_Squareoff_Exception_File with (nolock)                  
          
insert into history.dbo.Tbl_All_Squareoff_Exception_File              
select *,@filename                  
from Tbl_All_Squareoff_Exception_File with (nolock)               
          
truncate table Tbl_All_Squareoff_Exception_File         
        
/*Proj Risk Exception */        
        
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                   
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE=0.00,CASH_SQAUREUP,DERIV_SQAUREUP=0.00,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS='Corporate action / branch call',                  
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP=0.00,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                  
ENTERED_BY='E02527'                  
FROM  general.dbo.tbl_projrisk_t2day_data A with (nolock)    inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)   on A.party_code=B.party_code --133        
                   
UPDATE  general.dbo.tbl_projrisk_t2day_data SET EXEMPTION='Y',REMARKS='Corporate action / branch call',LASTUPDT=GETDATE(),IPADDRESS='172.29.30.51',                  
ENTERED_BY='E02527'  where party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)          
          
/*NBFC Proj Risk SquareOff Exception*/            
        
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY          
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,          
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS='172.29.30.51',          
ENTERED_BY='E02527'          
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock)       
on A.party_code=B.party_code --2        
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)        
          
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC SET EXEMPTION='Y',REMARKS='Corporate action / branch call'        
WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))          
        
        
/*NBFC Margin Shortage Exception*/              
        
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST             
SELECT           
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,          
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,          
Email,Exemption='Y',Remarks='Corporate action / branch call',AMOUNT,SOURCE_TYPE,IPADDRESS='172.29.30.51',ENTERED_BY='E02527'           
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.Client_Code=B.party_code  --194         
--WHERE Client_code =@PARTY_CODE             
                  
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'         
WHERE Client_Code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
  
/*       
/* VMSS Exception */        
        
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                   
SELECT                 
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,              
update_date=GETDATE(),Mobile_pager,                
Email,Exception='Y',Remarks='Corporate action / branch call' ,                
AMOUNT,SOURCE_TYPE,                
IPADDRESS='172.29.30.51',                   
ENTERED_BY='E02527'                 
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
--WHERE party_code =@PARTY_CODE    --732               
                        
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
 */       
       
/*Ageing Exception*/          
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY     
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS='Corporate action / branch call' ,    
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS='172.29.30.51',     
 ENTERED_BY='E02527'      
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
          
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP SET EXEMPTION='Y',REMARKS='Corporate action / branch call'  WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))       
   
/* MTF Exception */  
  
             
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                  
SELECT                 
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,              
update_date=GETDATE(),Mobile_pager,                
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks='Corporate action / branch call' ,                
AMOUNT,SOURCE_TYPE,                
IPADDRESS='172.29.30.51',                   
ENTERED_BY='E02527'                 
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
--WHERE party_code =@PARTY_CODE    --732               
                        
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
   
  
/*  
/*MTF Ageing T+7 Exception*/  
INSERT INTO general.dbo.MTF_AgeingT7_sqoff_client_exp_hist          
SELECT                 
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,MTF_T7_Shortage_AfterAdj,Square_Off_Value,Square_off_day,              
update_date=GETDATE(),Mobile_pager,                
Email,Exception='Y',Remarks='Corporate action / branch call' ,                
AMOUNT,SOURCE_TYPE,                
IPADDRESS='172.29.30.51',                   
ENTERED_BY='E02527'                 
FROM general.dbo.MTF_AgeingT7_sqoff_client_exp  A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                    
--WHERE party_code =@PARTY_CODE    --732               
                        
UPDATE MTF_AgeingT7_sqoff_client_exp SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS='172.29.30.51',                
ENTERED_BY='E02527' WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))            
   
*/  
             
END TRY            
BEGIN CATCH            
truncate table Tbl_All_Squareoff_Exception_File             
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_FoVarMargin
-- --------------------------------------------------
CREATE  procedure [dbo].[upd_FoVarMargin](@filename as varchar(50))                
as                
BEGIN TRY                
 truncate table general.dbo.fovar_margin                
insert into general.dbo.fovar_margin                
select *,getdate() as updated_on,@filename        
from fovar_margin (nolock)        

insert into history.dbo.fovar_margin    
select *,getdate() as updated_on,@filename        
from fovar_margin (nolock)


truncate table fovar_margin   
END TRY  
BEGIN CATCH  
truncate table fovar_margin   
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_fut_opt_upload
-- --------------------------------------------------
CREATE procedure [dbo].[upd_fut_opt_upload]    
@filename as varchar(50)     
as           
BEGIN TRY     
delete a     
from History.dbo.tbl_fut_opt_upload a    
join general.dbo.tbl_fut_opt_upload b    
on a.UpdateDate = b.UpdateDate  
 -----------------insert CP in History data---------------      
 insert into History.dbo.tbl_fut_opt_upload     
 select * from  general.dbo.tbl_fut_opt_upload     
 ---------------------Insert New CP-----------------------       
 truncate table general.dbo.tbl_fut_opt_upload 
        
 insert into general.dbo.tbl_fut_opt_upload     
 select distinct *,@filename,convert(varchar(10),getdate(),121) from tbl_fut_opt_upload   
 truncate table tbl_fut_opt_upload    
 --select * into History.dbo.tbl_fut_opt_upload       from general.dbo.tbl_fut_opt_upload     
END TRY      
BEGIN CATCH    
 truncate table tbl_fut_opt_upload         
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_IMargin_MCX
-- --------------------------------------------------
CREATE PROCEDURE UPD_IMargin_MCX(@filename as varchar(200))                  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.ScripIMargin_MCX  
 INSERT INTO general.dbo.ScripIMargin_MCX select *,@filename,convert(varchar(11),getdate()) from ScripIMargin_MCX          
 TRUNCATE TABLE ScripIMargin_MCX                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE ScripIMargin_MCX          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_IMargin_NCDX
-- --------------------------------------------------
CREATE PROCEDURE UPD_IMargin_NCDX(@filename as varchar(200))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.ScripIMargin_NCDX  
 INSERT INTO general.dbo.ScripIMargin_NCDX select *,@filename,convert(varchar(11),getdate()) from ScripIMargin_NCDX          
 TRUNCATE TABLE ScripIMargin_NCDX                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE ScripIMargin_NCDX          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_IMargin_NSEFO
-- --------------------------------------------------
CREATE PROCEDURE UPD_IMargin_NSEFO(@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.ScripIMargin_NSEFO  
 INSERT INTO general.dbo.ScripIMargin_NSEFO select *,@filename,convert(varchar(11),getdate()) from ScripIMargin_NSEFO          
 TRUNCATE TABLE ScripIMargin_NSEFO                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE ScripIMargin_NSEFO          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_ITM_File
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_ITM_File](@filename as varchar(500))      
as                      
BEGIN TRY      
 TRUNCATE TABLE general.dbo.tbl_ITM_File      
    
 INSERT INTO general.dbo.tbl_ITM_File     
 select *,@filename,convert(varchar(11),getdate()) from tbl_ITM_File      
             
 TRUNCATE TABLE tbl_ITM_File                    
END TRY                
BEGIN CATCH                
 TRUNCATE TABLE tbl_ITM_File              
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_JV_Clients
-- --------------------------------------------------

CREATE procedure [dbo].[upd_JV_Clients](@filename as varchar(50))                  
as                  
BEGIN TRY    
    
-----------------insert CP in History data---------------           
insert into History.dbo.Temp_SBDeposite    
select * from  general.dbo.Temp_SBDeposite
       
---------------------Insert New CP-----------------------           
truncate table general.dbo.Temp_SBDeposite            
insert into general.dbo.Temp_SBDeposite             
select client,[sb tag],getdate()       
from Temp_SBDeposite (nolock)   

 truncate table Temp_SBDeposite            
END TRY  
BEGIN CATCH  
 truncate table Temp_SBDeposite            
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_mcdx_margin
-- --------------------------------------------------

CREATE procedure [dbo].[upd_mcdx_margin](@filename as varchar(50))        
as        
BEGIN TRY  
	---------------------Insert New CP-----------------------    
	truncate table general.dbo.MCX_Margin
	insert into general.dbo.MCX_Margin select *,@filename,getdate() from temp_MCX_Margin
	truncate table temp_MCX_Margin
END TRY  
BEGIN CATCH  
	truncate table temp_MCX_Margin
END CATCH  

    -----------------insert CP in History data---------------    
insert into History.dbo.MCX_Margin select * from general.dbo.MCX_Margin

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_MCX
-- --------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--select * from sys.procedures order by create_date desc
CREATE procedure [dbo].[upd_MCX]  
 @filename as varchar(50)  
as        

BEGIN TRY  
	
 delete a   

 from History.dbo.ContractFile_MCX a  

 join general.dbo.ContractFile_MCX b  

 on a.upd_date = b.upld_date  

 -----------------insert CP in History data---------------    

 insert into History.dbo.ContractFile_MCX    

 select * from general.dbo.ContractFile_MCX     

 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.ContractFile_MCX      

 insert into general.dbo.ContractFile_MCX   

 select distinct convert(varchar(10),getdate(),121),* from ContractFile_MCX 

 ---------------------Inserting Data in MIS Server-----------------------   
 delete from  MIS.UPLOAD.DBO.ContractFile_MCX
 insert into MIS.UPLOAD.DBO.ContractFile_MCX
 select * from ContractFile_MCX

 
 insert into INTRANET.risk.dbo.Upload_block_file 
 select 'MCX',getdate(),NULL
 ---------------------End Here-----------------------   

 truncate table	ContractFile_MCX

END TRY  

BEGIN CATCH  
	 truncate table	ContractFile_MCX
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_nbfc_AppScrip
-- --------------------------------------------------
CREATE procedure [dbo].[upd_nbfc_AppScrip]  (@filename as varchar(50))
as  
  
declare @nor int  
set @nor=0  
select @nor=count(1) from temp_nbfc_appScrip (nolock)  
if @nor > 0  
begin  
 truncate table general.dbo.NBFC_ScripMaster   
 insert into general.dbo.NBFC_ScripMaster select * from temp_nbfc_appScrip  
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_nbfc_DayPosition
-- --------------------------------------------------
CREATE procedure [dbo].[upd_nbfc_DayPosition] (@filename as varchar(50))        
as          
       
declare @nor int          
set @nor=0          
select @nor=count(1) from temp_NBFC_DayPosition (nolock)          
if @nor > 0          
begin          
 truncate table general.dbo.NBFC_DayPosition      
 insert into general.dbo.NBFC_DayPosition      
 select co_Code='NBFC',Report_Date=getdate(),* from upload.dbo.temp_NBFC_DayPosition      
end          
    
truncate table upload.dbo.temp_NBFC_DayPosition      
  

delete from general.dbo.Prod_mapping where prodcode='NBFC'
insert into general.dbo.Prod_mapping select cltcode,'NBFC' from general.dbo.NBFC_DayPosition

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_NBFC_FUNDING
-- --------------------------------------------------
CREATE procedure [dbo].[upd_NBFC_FUNDING]  
@filename as varchar(50)  
as        

 BEGIN TRY  

 delete a   
 from History.dbo.Tbl_Upload_NBFC_Funding_Scrip a  join general.dbo.Tbl_Upload_NBFC_Funding_Scrip b  on a.upload_date = b.updated_on  

 -----------------insert CP in History data---------------    

 insert into History.dbo.Tbl_Upload_NBFC_Funding_Scrip 
	
	select * from general.dbo.Tbl_Upload_NBFC_Funding_Scrip
 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.Tbl_Upload_NBFC_Funding_Scrip      

 insert into general.dbo.Tbl_Upload_NBFC_Funding_Scrip   
 select distinct Company_Name,BSE_Scrip_Code,Haircut,[Group],ISIN,NSE_Symbol,[Start_Date],End_Date,convert(varchar(10),getdate(),121) from Tbl_Upload_NBFC_Funding_Scrip 

 /* To update mimansa table as suggested by manesh sir on Nov 20 2015*/

 truncate table Tbl_Upload_NBFC_Funding_Scrip  
END TRY  
BEGIN CATCH  
 truncate table Tbl_Upload_NBFC_Funding_Scrip      
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_NBFC_SqrOff_Exception
-- --------------------------------------------------
CREATE procedure [dbo].[upd_NBFC_SqrOff_Exception](@filename as varchar(50))
as
BEGIN
	BEGIN TRY
		insert into History.dbo.NBFC_SqrOff_Exception_Hist
		select DISTINCT * from general.dbo.NBFC_SqrOff_Exception

		---------------------Insert New Exception-----------------------
		truncate table general.dbo.NBFC_SqrOff_Exception

		if Not exists(select DISTINCT * from NBFC_SqrOff_Exception where isnull(remarks,'')='')
		BEGIN
			insert into general.dbo.NBFC_SqrOff_Exception 
			select  DISTINCT *,@filename,getdate() from NBFC_SqrOff_Exception
		End
		
		truncate table NBFC_SqrOff_Exception
	END TRY  
	BEGIN CATCH  
		truncate table NBFC_SqrOff_Exception
	END CATCH  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_NBFCLedger
-- --------------------------------------------------
CREATE procedure [dbo].[Upd_NBFCLedger] (@filename as varchar(50))      
as                      
SET NOCOUNT ON                      
  
declare @srno as int, @AcCode as varchar(50),@AcName as varchar(100),  
@MAcCode as varchar(50),@MAcName as varchar(100)  
  
insert into temp_NBFC_Ledger  
(AccountCode,AccountName,BookType,Date,Vno,Debit,Credit,Balance,ChequeNo,ChequeDate,Drawn,Description)  
select * from temp1_NBFC_Ledger (nolock)  
            
DECLARE BoLedger_cursor CURSOR FOR   
select Srno,AccountCode=isnull(AccountCode,''),AccountName=isnull(AccountName,'') from temp_NBFC_Ledger (nolock) order by srno            
  
OPEN BoLedger_cursor                
             
set @MAcCode=''  
set @MAcName=''    
           
FETCH NEXT FROM BoLedger_cursor                   
INTO @srno,@AcCode,@AcName    
                      
WHILE @@FETCH_STATUS = 0                      
BEGIN                      
 if @AcCode='' and @AcName=''   
   BEgin  
  update temp_NBFC_Ledger set AccountCode=@MAcCode,AccountName=@MAcName where srno=@srno   
   End  
 else if @AcCode='' and upper(@AcName)='TOTAL'   
 begin  
  update temp_NBFC_Ledger set AccountCode=@MAcCode where srno=@srno   
 end  
 else  
 Begin  
  set @MAcCode=@AcCode  
  set @MAcName=@AcName  
    end               
 FETCH NEXT FROM BoLedger_cursor                   
INTO @srno,@AcCode,@AcName    
END                      
                      
CLOSE BoLedger_cursor                      
DEALLOCATE BoLedger_cursor  
   
update temp_NBFC_Ledger set accountcode=replace(accountcode,'50304','')  
update temp_NBFC_Ledger set debit=0 where debit is null  
update temp_NBFC_Ledger set credit=0 where credit is null  
update temp_NBFC_Ledger set chequeno='' where chequeno is null  
update temp_NBFC_Ledger set drawn='' where drawn is null  
update temp_NBFC_Ledger set description='' where description is null  
  
update temp_NBFC_Ledger set vdt=convert(datetime,substring(date,4,2)+'/'+substring(date,1,2)+'/'+substring(date,7,4))  
delete from temp_NBFC_Ledger where vdt is null  
  
truncate table general.dbo.NBFC_Ledger   
insert into general.dbo.nbfc_Ledger  
select bookType,vno,vdt,lno='1',accountname,  
drcr=case when debit > 0 then 'D' else 'C' end,  
vamt=debit+credit,  
vdt,vno,refno=ChequeNo,balance,0,vdt,accountcode,'01','System',vdt,'System',0,  
description=ltrim(rtrim(isnull(description,'')))+  
(case when isnull(chequeDate,'') <> '' then '[Chq.No:'+ltrim(rtrim(chequeNo))+' dt:'+chequeDate+ ' Bk:'+ltrim(rtrim(isnull(drawn,'')))+' ]' end)  
from temp_NBFC_Ledger  
  
truncate table temp1_NBFC_Ledger   
truncate table temp_NBFC_Ledger

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_NCDEX
-- --------------------------------------------------
--select * from sys.procedures order by create_date desc
CREATE procedure [dbo].[upd_NCDEX]  
 @filename as varchar(50)  
as        

BEGIN TRY  
	
 delete a   

 from History.dbo.ContractFile_NCDEX a  

 join general.dbo.ContractFile_NCDEX b  

 on a.upd_date = b.upld_date  

 -----------------insert CP in History data---------------    

 insert into History.dbo.ContractFile_NCDEX    

 select * from general.dbo.ContractFile_NCDEX     

 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.ContractFile_NCDEX      

 insert into general.dbo.ContractFile_NCDEX   

 select distinct convert(varchar(10),getdate(),121),* from ContractFile_NCDEX 

 ---------------------Inserting Data in MIS Server-----------------------   
 delete from MIS.UPLOAD.DBO.ContractFile_NCDEX
 insert into MIS.UPLOAD.DBO.ContractFile_NCDEX
 select * from ContractFile_NCDEX

 --------------------------------------------------------"EXEC master..xp_cmdshell \\196.1.115.146\upload1\Contract\ncdex_contract.txt'"

 insert into INTRANET.risk.dbo.Upload_block_file 
 select 'NCDEX',getdate(),NULL

 ---------------------End Here-----------------------   

 truncate table	ContractFile_NCDEX

END TRY  

BEGIN CATCH  
	 truncate table	ContractFile_NCDEX
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_ncdex_ps03
-- --------------------------------------------------
CREATE procedure [dbo].[upd_ncdex_ps03]  
 @filename as varchar(50)  
as        

BEGIN TRY  
	
 delete a   

 from History.dbo.ncdex_ps03 a  

 join general.dbo.ncdex_ps03 b  

 on a.upd_date = b.upld_date  

 -----------------insert CP in History data---------------    

 insert into History.dbo.ncdex_ps03    

 select * from general.dbo.ncdex_ps03     

 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.ncdex_ps03      

 insert into general.dbo.ncdex_ps03   

 select distinct convert(varchar(10),getdate(),121),* from ncdex_ps03 

 ---------------------Inserting Data in MIS Server-----------------------   
 delete from [INTRANET].MIS.DBO.ncdex_ps03
 insert into [INTRANET].MIS.DBO.ncdex_ps03
 select * from ncdex_ps03
 ---------------------End Here-----------------------   

 truncate table	ncdex_ps03

END TRY  

BEGIN CATCH  
	 truncate table	ncdex_ps03
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NSECurr_Fut
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_NSECurr_Fut](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_NSECurr_Future  

 INSERT INTO general.dbo.tbl_NSECurr_Future 
 select *,@filename,convert(varchar(11),getdate()) from tbl_NSECurr_Future  
         
 TRUNCATE TABLE tbl_NSECurr_Future                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_NSECurr_Future          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NSECurr_Options
-- --------------------------------------------------
create PROCEDURE [dbo].[UPD_NSECurr_Options](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_NSECurr_Options  

 INSERT INTO general.dbo.tbl_NSECurr_Options 
 select *,@filename,convert(varchar(11),getdate()) from tbl_NSECurr_Options  
         
 TRUNCATE TABLE tbl_NSECurr_Options                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_NSECurr_Options          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_nsefo_BC
-- --------------------------------------------------

-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE upd_nsefo_BC
            
@filename as varchar(50)
AS
BEGIN

	------------------------Insert New CP---------------------
	truncate table general.dbo.tbl_NSEFO_BC

	insert into general.dbo.tbl_NSEFO_BC
	select distinct *
	from tbl_NSEFO_BC

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NSX_FutOption
-- --------------------------------------------------
Create PROCEDURE [dbo].[UPD_NSX_FutOption](@filename as varchar(500))  
as                  
BEGIN TRY  
 TRUNCATE TABLE general.dbo.tbl_NSX_FutOption_BhavCopy  

 INSERT INTO general.dbo.tbl_NSX_FutOption_BhavCopy 
 select *,@filename,convert(varchar(11),getdate()) from tbl_NSX_FutOption_BhavCopy  
         
 TRUNCATE TABLE tbl_NSX_FutOption_BhavCopy                
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE tbl_NSX_FutOption_BhavCopy          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_sett_curr_upload
-- --------------------------------------------------
  
CREATE procedure [dbo].[upd_sett_curr_upload]        
@filename as varchar(50)        
as              
BEGIN TRY        
 delete a         
 from History.dbo.tbl_sett_curr_upload a        
 join general.dbo.tbl_sett_curr_upload b        
 on a.UpdateDate = b.UpdateDate        
      
 -----------------insert CP in History data---------------          
      
 insert into History.dbo.tbl_sett_curr_upload        
 select * from  general.dbo.tbl_sett_curr_upload         
---------------------Insert settlement price -----------------------          
      
 truncate table general.dbo.tbl_sett_curr_upload            
 insert into general.dbo.tbl_sett_curr_upload        
 select distinct *,@filename,convert(varchar(10),getdate(),121) from tbl_sett_curr_upload       
 truncate table tbl_sett_curr_upload        
      
 --select * into History.dbo.tbl_sett_curr_upload       from general.dbo.tbl_sett_curr_upload         
      
END TRY        
      
      
      
      
      
      
      
BEGIN CATCH        
      
      
      
      
      
      
      
 truncate table tbl_sett_curr_upload            
      
      
      
      
      
      
      
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_BSECM
-- --------------------------------------------------
      
CREATE PROCEDURE UPD_SQUP_BSECM(                  
 @filename as varchar(50)            
--, @ErrorCode as int OUTPUT            
)                                    
as                  
BEGIN TRY                  
                  
 --SET @ErrorCode = 0                  
                  
 IF NOT Exists (SELECT top 1 * from general.dbo.BSE_REVERSEFILE A inner join BSE_REVERSEFILE B on A.SETTLEMENT_NO_DATE = B.SETTLEMENT_NO_DATE                  
   where PDate = convert(varchar(11),getdate()))                  
 BEGIN                  
                  
 --INSERT INTO general.dbo.BSE_REVERSEFILE select *,'',convert(varchar(11),getdate()) from BSE_REVERSEFILE                            
 INSERT INTO general.dbo.BSE_REVERSEFILE select *,@filename,convert(varchar(11),getdate()) from BSE_REVERSEFILE                            
 TRUNCATE TABLE BSE_REVERSEFILE       
                  
--update general.dbo.SquareUp_Client set Act_Cash_SquareUp =  Act_Cash_SquareUp + B.Total      
update general.dbo.SquareUp_Client set Act_Cash_SquareUp =  (case when ISNULL(Act_Cash_SquareUp,0)>0.00 then ISNULL(Act_Cash_SquareUp,0)+ B.Total else B.Total end)                  
 from                  
  (select Cltcode, sum(Total) Total                  
  from                   
   (select                   
    rtrim(ltrim(CLIENTCODE)) AS CltCode,                
    (Qty*convert(decimal(15,2),convert(decimal(15,2), RATE)/100)) As Total                   
   --from BSE_REVERSEFILE    ) A                  
   from general.dbo.BSE_REVERSEFILE        
   where PDATE = convert(varchar(11),getdate())  ) A      
  group by Cltcode) B                  
 where general.dbo.SquareUp_Client.Party_Code = B.Cltcode                  
                  
 ----------------------------------------------------------------------------------------                  
 /*Alter by Sanjay on 15 May 2011 for handling null values*/      
 update general.dbo.SquareUp_Cash set Act_SquareUp_Total =  ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),                  
  Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty,0) + ISNULL(TotalQty,0)      
 from                  
  (select Cltcode,ISIN, sum(Total) Total, Sum(Qty) TotalQty                  
  from                   
   (select                   
    rtrim(ltrim(CLIENTCODE)) AS CltCode,                  
    rtrim(ltrim(ISIN)) AS ISIN ,                
    Qty,                  
    (Qty*convert(decimal(15,2),convert(decimal(15,2), RATE)/100)) As Total                   
   --from BSE_REVERSEFILE ) A                  
   from general.dbo.BSE_REVERSEFILE       
   where PDATE = convert(varchar(11),getdate())) A      
  group by Cltcode, ISIN) B                  
 where general.dbo.SquareUp_Cash.Party_Code = B.Cltcode                  
  and general.dbo.SquareUp_Cash.Co_Code = 'BSECM'                  
  and general.dbo.SquareUp_Cash.ISIN = B.ISIN                
  --TRUNCATE TABLE BSE_REVERSEFILE                  
                 
                  
 END                  
 --ELSE                  
-- BEGIN                  
--  --SET @ErrorCode = 1                  
-- END                  
END TRY                  
BEGIN CATCH                  
 TRUNCATE TABLE BSE_REVERSEFILE                  
 --SET @ErrorCode = 2                  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_BSECM_bkp
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_BSECM_bkp(@filename as varchar(50))            
as            
BEGIN TRY      
 -----------------insert CP in History data---------------        
-- INSERT INTO History.dbo.BSE_REVERSEFILE_HIST        
-- SELECT * FROM general.dbo.BSE_REVERSEFILE         
 ---------------------Insert New CP-----------------------        
 TRUNCATE TABLE general.dbo.BSE_REVERSEFILE    
    
 INSERT INTO general.dbo.BSE_REVERSEFILE select *,@filename,getdate() from BSE_REVERSEFILE    
 TRUNCATE TABLE BSE_REVERSEFILE          
END TRY      
BEGIN CATCH      
 TRUNCATE TABLE BSE_REVERSEFILE    
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_squp_bsecm_nbfc
-- --------------------------------------------------
CREATE PROCEDURE Upd_squp_bsecm_nbfc
@filename AS VARCHAR(50)
--, @ErrorCode as int OUTPUT
AS
BEGIN TRY
--SET @ErrorCode = 0


INSERT INTO General.dbo.BSE_REVERSEFILE_NBFC
SELECT *,'',CONVERT(VARCHAR(11), GETDATE())
FROM BSE_REVERSEFILE_NBFC

UPDATE General.dbo.squareup_client_nbfc
SET act_cash_squareup = ISNUlL(B.total,0)
FROM (SELECT cltcode,SUM(total) Total
FROM (SELECT RTRIM(LTRIM(clientcode)) AS CltCode,
(qty * CONVERT(DECIMAL(15,2),CONVERT(DECIMAL(15, 2),rate)/100))AS Total
FROM BSE_REVERSEFILE_NBFC) A
GROUP BY cltcode) B
WHERE General.dbo.squareup_client_nbfc.party_code = B.cltcode

----------------------------------------------------------------------------------------
/*Alter by Sanjay on 15 May 2011 for handling null values*/

UPDATE General.dbo.squareup_cash_nbfc
SET act_squareup_total = ISNULL(act_squareup_total, 0)+ ISNULL(B.total, 0),
act_squareup_qty = ISNULL(act_squareup_qty, 0)+ ISNULL(totalqty, 0)
FROM (SELECT cltcode,isin,SUM(total) Total,SUM(qty) TotalQty
FROM (SELECT RTRIM(LTRIM(clientcode)) AS CltCode,RTRIM(LTRIM(isin)) AS ISIN,
qty,( qty * CONVERT(DECIMAL(15, 2),CONVERT(DECIMAL(15, 2),rate) /100) ) AS Total
FROM BSE_REVERSEFILE_NBFC) A
GROUP BY cltcode,isin) B
WHERE General.dbo.squareup_cash_nbfc.party_code = B.cltcode
AND General.dbo.squareup_cash_nbfc.Exchange = 'BSECM'
AND General.dbo.squareup_cash_nbfc.isin = B.isin

TRUNCATE TABLE BSE_REVERSEFILE_NBFC
--END
--ELSE
-- BEGIN
-- --SET @ErrorCode = 1
-- END
END TRY

BEGIN CATCH
TRUNCATE TABLE BSE_REVERSEFILE_NBFC
--SET @ErrorCode = 2
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_squp_bsecm_nbfc_margin_shortage
-- --------------------------------------------------

 
CREATE PROCEDURE Upd_squp_bsecm_nbfc_margin_shortage      
@filename AS VARCHAR(50)      
--, @ErrorCode as int OUTPUT      
AS      
BEGIN TRY     
   
INSERT INTO General.dbo.BSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE      
SELECT *,'',CONVERT(VARCHAR(11), GETDATE())      
FROM BSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE      
    
UPDATE  general.dbo.Tbl_NBFC_Excess_ShortageSqOff    
SET Actual_Cash_SquareOff_Done = ISNUlL(B.total,0)      
FROM (SELECT cltcode,SUM(total) Total      
FROM (SELECT RTRIM(LTRIM(clientcode)) AS CltCode,      
(qty * CONVERT(DECIMAL(15,2),CONVERT(DECIMAL(15, 2),rate)/100))AS Total      
FROM BSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE) A      
GROUP BY cltcode) B      
WHERE general.dbo.Tbl_NBFC_Excess_ShortageSqOff.Client_Code = B.cltcode      
and  general.dbo.Tbl_NBFC_Excess_ShortageSqOff.squareoffaction=7    
           
  
END TRY      
      
BEGIN CATCH      
TRUNCATE TABLE BSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE      
  
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_BSECM_T6T7
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_BSECM_T6T7
	@filename as varchar(50)
	--, @ErrorCode as int OUTPUT
as
BEGIN TRY

	--SET @ErrorCode = 0

	IF EXISTS (SELECT top 1 * from general.dbo.BSE_REVERSEFILE_T6T7 A
					--inner join NSE_REVERSEFILE_T6T7 B on A.Trade_No = B.Trade_No
					where PDate = convert(varchar(11),getdate()))
	BEGIN
		DELETE from general.dbo.BSE_REVERSEFILE_T6T7
		WHERE PDate = CONVERT(VARCHAR(11),GETDATE())
	END

	IF NOT Exists (SELECT top 1 * from general.dbo.BSE_REVERSEFILE_T6T7 A
	--inner join BSE_REVERSEFILE_T6T7 B on A.TradeNo = B.TradeNo
	where PDate = convert(varchar(11),getdate()))
	BEGIN
		INSERT INTO general.dbo.BSE_REVERSEFILE_T6T7
		select *,'',convert(varchar(11),getdate()) from BSE_REVERSEFILE_T6T7

		UPDATE general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7
		SET ACT_SqUp_BSE_QTY=0,
			ACT_SqUp_BSE_Total=0

		UPDATE general.dbo.ASB7_ACT_SQUP
		SET SQUAREUP_AMT = 0

		/* NEED TO CONFIRM */
		UPDATE ASB
		SET ASB.SQUAREUP_AMT = ISNULL(ASB.SQUAREUP_AMT, 0) + B.TOTAL
		FROM GENERAL.DBO.ASB7_ACT_SQUP ASB WITH (NOLOCK)

		INNER JOIN (
		SELECT CLTCODE, SUM(TOTAL) TOTAL
		FROM
		(
		SELECT RTRIM(LTRIM(CLIENTCODE)) AS CLTCODE,
		(QTY*CONVERT(DECIMAL(15,2), CONVERT(DECIMAL(15,2), RATE)/100)) AS TOTAL
		FROM BSE_REVERSEFILE_T6T7
		) A
		GROUP BY CLTCODE
		) B ON ASB.PARTY_CODE = B.CLTCODE

		/* NEED TO CONFIRM */

		----------------------------------------------------------------------------------------

		update general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7
		set ACT_SqUp_BSE_Total = ISNULL(ACT_SqUp_BSE_Total,0) + ISNULL(B.Total,0),
		ACT_SqUp_BSE_QTY = ISNULL(ACT_SqUp_BSE_QTY,0) + ISNULL(TotalQty,0)
		from
		(select Cltcode,ISIN, sum(Total) Total, Sum(Qty) TotalQty
		from
		(select
		rtrim(ltrim(CLIENTCODE)) AS CltCode,
		rtrim(ltrim(ISIN)) AS ISIN ,
		Qty,
		(Qty*convert(decimal(15,2),convert(decimal(15,2), RATE)/100)) As Total
		from BSE_REVERSEFILE_T6T7 ) A
		group by Cltcode, ISIN) B
		where general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.Party_Code = B.Cltcode
		and general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.EXCH = 'BSECM'
		and general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.ISIN = B.ISIN


		TRUNCATE TABLE BSE_REVERSEFILE_T6T7

	END
--ELSE
-- BEGIN
-- --SET @ErrorCode = 1
-- END
END TRY
BEGIN CATCH
TRUNCATE TABLE BSE_REVERSEFILE_T6T7
--SET @ErrorCode = 2
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_MCX
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_MCX(@FILENAME AS VARCHAR(50))    
AS    
BEGIN TRY    
 ---------------------INSERT NEW CP-----------------------    
 DELETE FROM GENERAL.DBO.MCX_REVERSEFILE WHERE CONVERT(VARCHAR(11),PDATE) = CONVERT(VARCHAR(11),GETDATE())    
   
 INSERT INTO GENERAL.DBO.MCX_REVERSEFILE SELECT *,@FILENAME,CONVERT(VARCHAR(12),GETDATE()) FROM MCX_REVERSEFILE    
   
 UPDATE TRD  
  SET ACT_SQUAREUP_QTY = ISNULL(REV.TRADE_QUANTITY,0),  
   ACT_SQUAREUP_CLOSINGPRICE = ISNULL(REV.PRICE,0),  
   ACT_SQUAREUP_TOTAL = CONVERT(INT,ISNULL(REV.TRADE_QUANTITY,0))*CONVERT(MONEY,ISNULL(REV.PRICE,0))  
  FROM GENERAL.DBO.SQUAREUP_DERIV TRD 
  LEFT OUTER JOIN MCX_REVERSEFILE REV  
 ON TRD.PARTY_CODE = LTRIM(RTRIM(REV.ACCOUNT)) AND  
  TRD.INST_TYPE = LTRIM(RTRIM(REV.INSTRUMENT_NAME)) AND  
  TRD.SYMBOL = LTRIM(RTRIM(REV.CONTRACT_CODE)) AND  
  CONVERT(varchar,TRD.EXPIRYDATE,103) = CONVERT(varchar,REV.EXPIRY_DATE,103)  
  WHERE CO_CODE = 'MCX'  
  
  UPDATE GENERAL.DBO.SQUAREUP_CLIENT SET ACT_DERIV_SQUAREUP = B.TOTAL  
  FROM  
   (SELECT PARTY_CODE, SUM(ISNULL(ACT_SQUAREUP_TOTAL,0)) TOTAL  
    FROM GENERAL.DBO.SQUAREUP_DERIV  
    GROUP BY PARTY_CODE) B  
  WHERE GENERAL.DBO.SQUAREUP_CLIENT.PARTY_CODE = B.PARTY_CODE  
   
  TRUNCATE TABLE MCX_REVERSEFILE    
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE MCX_REVERSEFILE          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_MCX_14052011
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_MCX_14052011(@filename as varchar(50))                
as                
BEGIN TRY          
 INSERT INTO general.dbo.MCX_REVERSEFILE select *,@filename,convert(varchar(11),getdate()) from MCX_REVERSEFILE        
 ----------------------------------------------------------------------------------------    
update general.dbo.SquareUp_Client set Act_Deriv_SquareUp =  Act_Deriv_SquareUp + B.Total    
from    
(
	select Cltcode, sum(Total) Total from     
	(   select rtrim(ltrim(Account)) AS CltCode,    
			(Trade_quantity*convert(decimal(15,2), ltrim(rtrim(Price)))) As Total     
			from general.dbo.MCX_REVERSEFILE where PDATE = convert(varchar(11),getdate())
		) A group by Cltcode
	) B    
where general.dbo.SquareUp_Client.Party_Code = B.Cltcode    

 ----------------------------------------------------------------------------------------    
 update  
 general.dbo.SquareUp_Deriv set 
  Act_SquareUp_Total =  ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),
  Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)
 from    
(
	select Cltcode,Symbol,  sum(Total) Total, Sum(Qty) TotalQty,
	convert(datetime,Expiry_date) as Expiry_date
	  
	   from     
	   (
			select     
			rtrim(ltrim(Account)) AS CltCode,rtrim(ltrim(Contract_Code)) AS Symbol,convert(int,Trade_quantity) AS Qty,
			Expiry_date,(Trade_quantity*convert(decimal(15,2), ltrim(rtrim(Price)))) As Total     
		   from general.dbo.MCX_REVERSEFILE where PDATE = convert(varchar(11),getdate())
		) A group by Cltcode, Symbol, convert(datetime,Expiry_date)
) B    
where 
	  general.dbo.SquareUp_Deriv.Party_Code = B.Cltcode 
  and general.dbo.SquareUp_Deriv.Co_Code = 'MCX'    

  and general.dbo.SquareUp_Deriv.Symbol = B.Symbol
  and general.dbo.SquareUp_Deriv.ExpiryDate = B.Expiry_date
  
 
 TRUNCATE TABLE MCX_REVERSEFILE              
END TRY          
BEGIN CATCH          
 TRUNCATE TABLE MCX_REVERSEFILE        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NCDEX
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_NCDEX(@filename as varchar(50))              
as              
BEGIN TRY        
 ---------------------Insert New CP-----------------------          
 INSERT INTO general.dbo.NCDEX_REVERSEFILE select *,@filename,Convert(varchar(12),getdate())  from NCDEX_REVERSEFILE    
 
 UPDATE TRD
		SET ACT_SQUAREUP_QTY = ISNULL(REV.TRADE_QUANTITY,0),
			ACT_SQUAREUP_CLOSINGPRICE = ISNULL(REV.PRICE,0),
			ACT_SQUAREUP_TOTAL = CONVERT(INT,ISNULL(REV.TRADE_QUANTITY,0))*CONVERT(MONEY,ISNULL(REV.PRICE,0))
  FROM GENERAL.DBO.SQUAREUP_DERIV TRD LEFT OUTER JOIN NCDEX_REVERSEFILE REV
	ON	TRD.PARTY_CODE = LTRIM(RTRIM(REV.ACCOUNT)) AND
		TRD.INST_TYPE = LTRIM(RTRIM(REV.INSTRUMENT_NAME)) AND
		TRD.SYMBOL = LTRIM(RTRIM(REV.Symbol)) AND
		TRD.EXPIRYDATE = REV.EXPIRY_DATE /*AND
		TRD.STRIKE_PRICE = CASE WHEN REV.INSTRUMENT_TYPE LIKE 'FUT%' THEN 0 ELSE CONVERT(MONEY,REPLACE(REV.STRIKE_PRICE,' ','')) END AND
		TRD.OPTIONTYPE = REV.OPTION_TYPE*/
  WHERE CO_CODE = 'NCDEX'

  UPDATE GENERAL.DBO.SQUAREUP_CLIENT SET ACT_DERIV_SQUAREUP = B.TOTAL
	 FROM
	  (SELECT PARTY_CODE, SUM(ISNULL(ACT_SQUAREUP_TOTAL,0)) TOTAL
	   FROM GENERAL.DBO.SQUAREUP_DERIV
	   GROUP BY PARTY_CODE) B
  WHERE GENERAL.DBO.SQUAREUP_CLIENT.PARTY_CODE = B.PARTY_CODE
 
 TRUNCATE TABLE NCDEX_REVERSEFILE    
END TRY        
BEGIN CATCH        
 TRUNCATE TABLE NCDEX_REVERSEFILE    
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NCDEX_14052011
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_NCDEX_14052011(@filename as varchar(50))                
as                
BEGIN TRY          
 INSERT INTO general.dbo.NCDEX_REVERSEFILE select *,@filename,convert(varchar(11),getdate()) from NCDEX_REVERSEFILE        
 ----------------------------------------------------------------------------------------    
update general.dbo.SquareUp_Client set Act_Deriv_SquareUp =  Act_Deriv_SquareUp + B.Total    
from    
(
	select Cltcode, sum(Total) Total from     
	(   select rtrim(ltrim(Account)) AS CltCode,    
			(Trade_quantity*convert(decimal(15,2), ltrim(rtrim(Price)))) As Total     
			from general.dbo.NCDEX_REVERSEFILE where PDATE = convert(varchar(11),getdate())
		) A group by Cltcode
	) B    
where general.dbo.SquareUp_Client.Party_Code = B.Cltcode    

 ----------------------------------------------------------------------------------------    
 update  
 general.dbo.SquareUp_Deriv set 
  Act_SquareUp_Total =  ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),    
  Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)
 from    
(
	select Cltcode,Symbol,  sum(Total) Total, Sum(Qty) TotalQty,
	convert(datetime,Expiry_date) as Expiry_date
	  
	   from     
	   (
			select     
			rtrim(ltrim(Account)) AS CltCode,rtrim(ltrim(Symbol)) AS Symbol,convert(int,Trade_quantity) AS Qty,
			Expiry_date,(Trade_quantity*convert(decimal(15,2), ltrim(rtrim(Price)))) As Total     
		   from general.dbo.NCDEX_REVERSEFILE where PDATE = convert(varchar(11),getdate())
		) A group by Cltcode, Symbol, convert(datetime,Expiry_date)
) B    
where 
	  general.dbo.SquareUp_Deriv.Party_Code = B.Cltcode 
  and general.dbo.SquareUp_Deriv.Co_Code = 'NCDEX'    

  and general.dbo.SquareUp_Deriv.Symbol = B.Symbol
  and general.dbo.SquareUp_Deriv.ExpiryDate = B.Expiry_date
  
 
 TRUNCATE TABLE NCDEX_REVERSEFILE              
END TRY          
BEGIN CATCH          
 TRUNCATE TABLE NCDEX_REVERSEFILE        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NSECM
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_NSECM(          
 @filename as varchar(50)        
--,@ErrorCode as int OUTPUT        
)                            
as          
BEGIN TRY          
          
 --SET @ErrorCode = 0          
          
 IF NOT Exists (SELECT top 1 * from general.dbo.NSE_REVERSEFILE A inner join NSE_REVERSEFILE B on A.Trade_No = B.Trade_No          
   where PDate = convert(varchar(11),getdate()))          
 BEGIN          
          
 INSERT INTO general.dbo.NSE_REVERSEFILE select *,@filename,convert(varchar(11),getdate()) from NSE_REVERSEFILE                    
 TRUNCATE TABLE NSE_REVERSEFILE            
          
 --update general.dbo.SquareUp_Client set Act_Cash_SquareUp =  Act_Cash_SquareUp + B.Total          
 update general.dbo.SquareUp_Client set Act_Cash_SquareUp = (case when ISNULL(Act_Cash_SquareUp,0)>0.00 then ISNULL(Act_Cash_SquareUp,0)+ B.Total else B.Total end)          
 from          
  (select Cltcode, sum(Total) Total          
  from           
   (select           
    rtrim(ltrim(Member_Id)) AS CltCode,          
    (Trade_Qty*convert(decimal(15,2), Trade_Price_PRO_CLI)) As Total           
   from general.dbo.NSE_REVERSEFILE          
   where PDATE = convert(varchar(11),getdate())) A          
  group by Cltcode) B          
 where general.dbo.SquareUp_Client.Party_Code = B.Cltcode          
          
 ----------------------------------------------------------------------------------------          
 /*Alter By sanjay on 15 May 2011 for ahnling null values*/      
 update general.dbo.SquareUp_Cash set Act_SquareUp_Total =  ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),          
  Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)      
 from          
  (select Cltcode,Symbol, Series, sum(Total) Total, Sum(Qty) TotalQty          
  from           
   (select           
    rtrim(ltrim(Member_Id)) AS CltCode,          
    rtrim(ltrim(Security_Symbol)) AS Symbol,          
    rtrim(ltrim(Series)) AS Series,          
    Trade_Qty AS Qty,          
    (Trade_Qty*convert(decimal(15,2), Trade_Price_PRO_CLI)) As Total           
   from general.dbo.NSE_REVERSEFILE          
   where PDATE = convert(varchar(11),getdate())) A          
  group by Cltcode, Symbol, Series) B          
 where general.dbo.SquareUp_Cash.Party_Code = B.Cltcode          
  and general.dbo.SquareUp_Cash.Co_Code = 'NSECM'          
  and general.dbo.SquareUp_Cash.Scrip_Cd = B.Symbol          
  and general.dbo.SquareUp_Cash.Series = B.Series          
          
 END          
-- ELSE          
-- BEGIN          
--  SET @ErrorCode = 1          
-- END          
END TRY          
BEGIN CATCH          
 TRUNCATE TABLE NSE_REVERSEFILE          
 --SET @ErrorCode = 2          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NSECM_NBFC
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_NSECM_NBFC
@filename AS VARCHAR(50)
--,@ErrorCode AS int OUTPUT
AS
BEGIN TRY

--SET @ErrorCode = 0

IF NOT EXISTS (SELECT TOP 1 * FROM General.dbo.NSE_REVERSEFILE_NBFC A
				INNER JOIN NSE_REVERSEFILE_NBFC B ON A.Trade_No = B.Trade_No
				WHERE PDate = CONVERT(VARCHAR(11),GETDATE()))
BEGIN

INSERT INTO General.dbo.NSE_REVERSEFILE_NBFC
SELECT *,@filename,CONVERT(VARCHAR(11),GETDATE()) FROM NSE_REVERSEFILE_NBFC

TRUNCATE TABLE NSE_REVERSEFILE_NBFC

UPDATE General.dbo.SquareUp_Client_NBFC
SET Act_Cash_SquareUp = ISNULL(B.Total,0)
FROM
(SELECT Cltcode, SUM(Total) Total
FROM
(SELECT
RTRIM(LTRIM(Member_Id)) AS CltCode,
(Trade_Qty*CONVERT(DECIMAL(15,2), Trade_Price_PRO_CLI)) AS Total
FROM General.dbo.NSE_REVERSEFILE_NBFC
WHERE PDATE = CONVERT(VARCHAR(11),GETDATE())) A
group by Cltcode) B
WHERE General.dbo.SquareUp_Client_NBFC.Party_Code = B.Cltcode

----------------------------------------------------------------------------------------
/*Alter By sanjay on 15 May 2011 for ahnling null values*/

UPDATE General.dbo.SquareUp_Cash_NBFC
SET Act_SquareUp_Total = ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),
Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)
FROM
(SELECT Cltcode,Symbol, Series, SUM(Total) Total, SUM(Qty) TotalQty
FROM
(SELECT
RTRIM(LTRIM(Member_Id)) AS CltCode,
RTRIM(LTRIM(Security_Symbol)) AS Symbol,
RTRIM(LTRIM(Series)) AS Series,
Trade_Qty AS Qty,
(Trade_Qty*CONVERT(DECIMAL(15,2), Trade_Price_PRO_CLI)) AS Total
FROM General.dbo.NSE_REVERSEFILE_NBFC
WHERE PDATE = CONVERT(VARCHAR(11),GETDATE())) A
group by Cltcode, Symbol, Series) B
WHERE General.dbo.SquareUp_Cash_NBFC.Party_Code = B.Cltcode
and General.dbo.SquareUp_Cash_NBFC.Exchange = 'NSECM'
and General.dbo.SquareUp_Cash_NBFC.Scrip_Cd = B.Symbol
and General.dbo.SquareUp_Cash_NBFC.Series = B.Series

END
-- ELSE
-- BEGIN
-- SET @ErrorCode = 1
-- END
END TRY
BEGIN CATCH
TRUNCATE TABLE NSE_REVERSEFILE_NBFC
--SET @ErrorCode = 2
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NSECM_NBFC_margin_shortage
-- --------------------------------------------------
  
  
CREATE  PROCEDURE [dbo].[UPD_SQUP_NSECM_NBFC_margin_shortage]      
@filename AS VARCHAR(50)      
--,@ErrorCode AS int OUTPUT      
AS      
BEGIN TRY      
      
--SET @ErrorCode = 0      
      
IF NOT EXISTS (SELECT TOP 1 * FROM General.dbo.NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE  A      
    INNER JOIN NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE B ON A.Trade_No = B.Trade_No      
    WHERE PDate = CONVERT(VARCHAR(11),GETDATE()))      
BEGIN      
 print 'hii'     
INSERT INTO General.dbo.NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE      
SELECT *,'',CONVERT(VARCHAR(11),GETDATE()) FROM NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE      

UPDATE general.dbo.Tbl_NBFC_Excess_ShortageSqOff       
SET Actual_Cash_SquareOff_Done = ISNULL(B.Total,0)      
FROM      
(SELECT Cltcode, SUM(Total) Total      
FROM      
(SELECT      
RTRIM(LTRIM(Member_Id)) AS CltCode,      
(Trade_Qty*CONVERT(DECIMAL(15,2), Trade_Price_PRO_CLI)) AS Total      
FROM NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE) A      
group by Cltcode) B      
WHERE general.dbo.Tbl_NBFC_Excess_ShortageSqOff.Client_Code = B.Cltcode      
and  general.dbo.Tbl_NBFC_Excess_ShortageSqOff.squareoffaction=7      
----------------------------------------------------------------------------------------      
/*Alter By sanjay on 15 May 2011 for ahnling null values*/      
/*     
UPDATE General.dbo.SquareUp_Cash_NBFC      
SET Act_SquareUp_Total = ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),      
Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)      
FROM      
(SELECT Cltcode,Symbol, Series, SUM(Total) Total, SUM(Qty) TotalQty      
FROM      
(SELECT      
RTRIM(LTRIM(Member_Id)) AS CltCode,      
RTRIM(LTRIM(Security_Symbol)) AS Symbol,      
RTRIM(LTRIM(Series)) AS Series,      
Trade_Qty AS Qty,      
(Trade_Qty*CONVERT(DECIMAL(15,2), Trade_Price_PRO_CLI)) AS Total      
FROM General.dbo.NSE_REVERSEFILE_NBFC      
WHERE PDATE = CONVERT(VARCHAR(11),GETDATE())) A      
group by Cltcode, Symbol, Series) B      
WHERE General.dbo.SquareUp_Cash_NBFC.Party_Code = B.Cltcode      
and General.dbo.SquareUp_Cash_NBFC.Exchange = 'NSECM'      
and General.dbo.SquareUp_Cash_NBFC.Scrip_Cd = B.Symbol      
and General.dbo.SquareUp_Cash_NBFC.Series = B.Series      
  */    
      
 
END      
-- ELSE      
-- BEGIN      
-- SET @ErrorCode = 1      
-- END      
END TRY      
BEGIN CATCH      
TRUNCATE TABLE NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE      
--SET @ErrorCode = 2      
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NSECM_T6T7
-- --------------------------------------------------
--UPD_SQUP_NSECM_T6T7 'NSE 17093166.TXT'
CREATE PROCEDURE UPD_SQUP_NSECM_T6T7
	@filename as varchar(50)
	--,@ErrorCode as int OUTPUT
as
BEGIN TRY

	--SET @ErrorCode = 0

	IF Exists (SELECT top 1 * from general.dbo.NSE_REVERSEFILE_T6T7 A
					--inner join NSE_REVERSEFILE_T6T7 B on A.Trade_No = B.Trade_No
					where PDate = convert(varchar(11),getdate()))
	BEGIN
		DELETE from general.dbo.NSE_REVERSEFILE_T6T7
		WHERE PDate = CONVERT(VARCHAR(11),GETDATE())
	END

	IF NOT Exists (SELECT top 1 * from general.dbo.NSE_REVERSEFILE_T6T7 A
					--inner join NSE_REVERSEFILE_T6T7 B on A.Trade_No = B.Trade_No
					where PDate = convert(varchar(11),getdate()))
	BEGIN

		INSERT INTO general.dbo.NSE_REVERSEFILE_T6T7
		select *,@filename,convert(varchar(11),getdate()) from NSE_REVERSEFILE_T6T7

		UPDATE general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7
		SET Act_SquareUp_Qty=0,
			Act_SquareUp_Total=0

		UPDATE general.dbo.ASB7_ACT_SQUP
		SET SQUAREUP_TOTAL_AMT = 0

		TRUNCATE TABLE NSE_REVERSEFILE_T6T7

		/* NEED TO CONFIRM */
		UPDATE ASB
		SET ASB.SQUAREUP_TOTAL_AMT = ISNULL(ASB.SQUAREUP_TOTAL_AMT, 0) + B.TOTAL
		FROM GENERAL.DBO.ASB7_ACT_SQUP ASB WITH (NOLOCK)
		INNER JOIN (
		SELECT CLTCODE, SUM(TOTAL) TOTAL
		FROM
		(
		SELECT RTRIM(LTRIM(MEMBER_ID)) AS CLTCODE,
		(TRADE_QTY*CONVERT(DECIMAL(15,2), TRADE_PRICE_PRO_CLI)) AS TOTAL
		FROM GENERAL.DBO.NSE_REVERSEFILE_T6T7
		WHERE PDATE = CONVERT(VARCHAR(11),GETDATE())
		) A
		GROUP BY CLTCODE
		) B ON ASB.PARTY_CODE = B.CLTCODE

		/* NEED TO CONFIRM */

		update general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7
		set Act_SquareUp_Total = ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),
		Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)
		from
		(select Cltcode,Symbol, Series, sum(Total) Total, Sum(Qty) TotalQty
		from
		(select
		rtrim(ltrim(Member_Id)) AS CltCode,
		rtrim(ltrim(Security_Symbol)) AS Symbol,
		rtrim(ltrim(Series)) AS Series,
		Trade_Qty AS Qty,
		(Trade_Qty*convert(decimal(15,2), Trade_Price_PRO_CLI)) As Total
		from general.dbo.NSE_REVERSEFILE_T6T7
		where PDATE = convert(varchar(11),getdate())) A
		group by Cltcode, Symbol, Series) B
		where general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.Party_Code = B.Cltcode
		and general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.EXCH = 'NSECM'
		and general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.Scrip_Cd = B.Symbol
		and general.dbo.ASB7_SQ_UP_FILE_GENERATE_T6T7.Series = B.Series

	END
-- ELSE
-- BEGIN
-- SET @ErrorCode = 1
-- END
END TRY
BEGIN CATCH
TRUNCATE TABLE NSE_REVERSEFILE_T6T7
--SET @ErrorCode = 2
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NSEFO
-- --------------------------------------------------
CREATE PROCEDURE UPD_SQUP_NSEFO(@filename as varchar(50))                  
as                  
BEGIN TRY            

 DELETE FROM GENERAL.DBO.NSEFO_REVERSEFILE WHERE CONVERT(VARCHAR(11),PDATE) = CONVERT(VARCHAR(11),GETDATE())    

 INSERT INTO general.dbo.NSEFO_REVERSEFILE select *,@filename,convert(varchar(11),getdate()) from NSEFO_REVERSEFILE          
 
   
 UPDATE TRD  
 SET ACT_SQUAREUP_QTY = ISNULL(REV.TRADED_QUANTITY,0),  
  ACT_SQUAREUP_CLOSINGPRICE = ISNULL(REV.PRICE,0),  
  ACT_SQUAREUP_TOTAL = CONVERT(INT,ISNULL(REV.TRADED_QUANTITY,0))*CONVERT(MONEY,ISNULL(REV.PRICE,0))  
FROM GENERAL.DBO.SQUAREUP_DERIV TRD LEFT OUTER JOIN NSEFO_REVERSEFILE REV  
ON TRD.PARTY_CODE = LTRIM(RTRIM(REV.ACCOUNT)) AND  
 TRD.INST_TYPE = LTRIM(RTRIM(REV.INSTRUMENT_TYPE)) AND  
 TRD.SYMBOL = LTRIM(RTRIM(REV.SYMBOL)) AND  
 REPLACE(CONVERT(VARCHAR,TRD.EXPIRYDATE,106),' ','') = REV.EXPIRY_DATE AND  
 TRD.STRIKE_PRICE = CASE WHEN REV.INSTRUMENT_TYPE LIKE 'FUT%' THEN 0 ELSE CONVERT(MONEY,REPLACE(REV.STRIKE_PRICE,' ','')) END AND  
 TRD.OPTIONTYPE = REV.OPTION_TYPE  
WHERE CO_CODE = 'NSEFO'  
  
  
UPDATE GENERAL.DBO.SQUAREUP_CLIENT SET ACT_DERIV_SQUAREUP = B.TOTAL  
 FROM        
  (SELECT PARTY_CODE, SUM(ISNULL(ACT_SQUAREUP_TOTAL,0)) TOTAL        
  FROM GENERAL.DBO.SQUAREUP_DERIV  
  GROUP BY PARTY_CODE) B        
 WHERE GENERAL.DBO.SQUAREUP_CLIENT.PARTY_CODE = B.PARTY_CODE        
  
 TRUNCATE TABLE NSEFO_REVERSEFILE
   
END TRY            
BEGIN CATCH            
 TRUNCATE TABLE NSEFO_REVERSEFILE          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUP_NSEFO_14052011
-- --------------------------------------------------
create PROCEDURE UPD_SQUP_NSEFO_14052011(@filename as varchar(50))                
as                
BEGIN TRY          
 INSERT INTO general.dbo.NSEFO_REVERSEFILE select *,@filename,convert(varchar(11),getdate()) from NSEFO_REVERSEFILE        
 ----------------------------------------------------------------------------------------    
update general.dbo.SquareUp_Client set Act_Deriv_SquareUp =  Act_Deriv_SquareUp + B.Total    
from    
(
	select Cltcode, sum(Total) Total from     
	(   select rtrim(ltrim(Account)) AS CltCode,    
			(Traded_Quantity*convert(decimal(15,2), ltrim(rtrim(Price)))) As Total     
			from general.dbo.NSEFO_REVERSEFILE where PDATE = convert(varchar(11),getdate())
		) A group by Cltcode
	) B    
where general.dbo.SquareUp_Client.Party_Code = B.Cltcode    

 ----------------------------------------------------------------------------------------    
 update general.dbo.SquareUp_Deriv set 
  Act_SquareUp_Total =  ISNULL(Act_SquareUp_Total,0) + ISNULL(B.Total,0),    
  Act_SquareUp_Qty = ISNULL(Act_SquareUp_Qty ,0)+ ISNULL(TotalQty,0)
 from    
(
	select Cltcode,Symbol,  sum(Total) Total, Sum(Qty) TotalQty,
	convert(datetime,Expiry_date) as Expiry_date,Strike_Price,Option_type
	  
	   from     
	   (
			select     
			rtrim(ltrim(Account)) AS CltCode,rtrim(ltrim(Symbol)) AS Symbol,convert(int,Traded_Quantity) AS Qty,
			Expiry_date,Strike_Price,Option_type,(Traded_Quantity*convert(decimal(15,2), ltrim(rtrim(Price)))) As Total     
		   from general.dbo.NSEFO_REVERSEFILE where PDATE = convert(varchar(11),getdate())
		) A group by Cltcode, Symbol, convert(datetime,Expiry_date),Strike_Price,Option_type
) B    
where 
	  general.dbo.SquareUp_Deriv.Party_Code = B.Cltcode 
  and general.dbo.SquareUp_Deriv.Co_Code = 'NSEFO'    

  and general.dbo.SquareUp_Deriv.Symbol = B.Symbol
  and general.dbo.SquareUp_Deriv.ExpiryDate = B.Expiry_date
  
  and general.dbo.SquareUp_Deriv.OptionType = B.Option_type   
  and general.dbo.SquareUp_Deriv.Strike_Price = B.Strike_Price
 
 TRUNCATE TABLE NSEFO_REVERSEFILE              
END TRY          
BEGIN CATCH          
 TRUNCATE TABLE NSEFO_REVERSEFILE        
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SQUPEXCEPTIONT6T7
-- --------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*****************************************************************************
CREATED BY :: Sushant Nagarkar
CREATED DATE :: 08 JAN 2012
PRUPOSE :: TO UPLOAD T7 SQUARE OFF EXCEPTIONS
*****************************************************************************/
CREATE PROCEDURE [dbo].[UPD_SQUPEXCEPTIONT6T7]
@FILENAME AS VARCHAR(100)
AS
--BEGIN TRY

INSERT INTO General.dbo.SQuareUp_Exception_T6T7
(AccessLevel,AccessCode,ValidFrom,ValidTo,[Status],CreateDt,CreateBy,Remarks)

SELECT X.* FROM
(SELECT 'Client' AccessLevel,Client,
	ValidFrom = (CASE WHEN CONVERT(DATETIME,ValidFrom,103) < GETDATE() THEN CONVERT(VARCHAR(11),GETDATE(),106) ELSE CONVERT(DATETIME,ValidFrom,103) END),
	ValidTo = CONVERT(DATETIME,ValidTo,103),[Status]='Y',CreateDt=GETDATE(),CreateBy='UPLOAD',Remarks
FROM SQuareUp_Exception_T6T7 WITH(NOLOCK)) X
LEFT JOIN General.dbo.SQuareUp_Exception_T6T7 Y WITH(NOLOCK)
	ON X.Client=Y.AccessCode
	AND X.ValidFrom = Y.ValidFrom
	AND X.ValidTo = Y.ValidTo
WHERE Y.AccessCode IS NULL
AND Y.ValidFrom IS NULL
AND Y.ValidTo IS NULL

INSERT INTO HISTORY.DBO.SQuareUp_Exception_T6T7
SELECT *,GETDATE() AS updated_on,@FILENAME
FROM SQuareUp_Exception_T6T7 WITH(NOLOCK)

TRUNCATE TABLE SQuareUp_Exception_T6T7

--END TRY
--BEGIN CATCH
--TRUNCATE TABLE SQuareUp_Exception_T6T7
--END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.update_NSEFO_FILE
-- --------------------------------------------------
-- =============================================
-- Author:		Abha Jaiswal
-- Create date: jun 10 2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[update_NSEFO_FILE]
@upldsrno int
as 
BEGIN
Declare @Query varchar(max)=null;                  
Declare @Error int=0;                
Declare @Count int=0;                 
                
Declare @mUpd_TempTable varchar(100)=null;                            
Declare @mUpd_deli varchar(5)=null;                            
Declare @mUpd_FirstRow varchar(5)=null;                            
Declare @mUpd_FinSP varchar(50)=null;                            
Declare @FileLocation varchar(100)=null;                            
Declare @FileName varchar(1000)=null;                            
Declare @FileExtenstion varchar(10)=null;                            
Declare @FileSize numeric(18,2)=null                            
    
                            
select                              
@upldsrno=Upd_Srno ,                            
@mUpd_TempTable=Upd_TempTable,                            
@mUpd_deli=Upd_deli,                            
@mUpd_FirstRow=Upd_FirstRow,                            
@mUpd_FinSP=Upd_FinSP ,                            
@FileName=FileN ,                          
@FileExtenstion=Upd_Extension                            
from tbl_AutomationUpladFile   where Upd_Srno=@upldsrno                             
                
-- to get fileName                  
Declare  @tbl as  table (FileN varchar(200))                  
Insert into @tbl  execute('select '+ @FileName)                    
select  @FileName=FileN  from @tbl                   

set @FileLocation ='\\CSOKYC-6\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion));                   
print @FileLocation                    
                        
	if @upldsrno=3
begin 


	set @FileLocation ='\\CSOKYC-6\h\EXCHANGEFILES\'+ltrim(rtrim(@FileName+@FileExtenstion)); 
    truncate table tbl_data
	set @Query='bulk insert tbl_data from '''+@FileLocation+''' WITH (FIRSTROW='+@mUpd_FirstRow+',FIELDTERMINATOR = '''+@mUpd_deli+''',ROWTERMINATOR = ''NORMAL'',TABLOCK)';                
	print @Query                            
	execute (@Query) 
	UPDATE tbl_data SET DATA='NORMAL'+DATA
	declare @file2 varchar(500),@SQL as varchar(max)
	--set   @file2=SUBSTRING(REPLACE(CONVERT(varchar(10),GETDATE(),105),'-',''),1,4)+RIGHT(CONVERT(VARCHAR(4),YEAR(GETDATE())),1)+'000'                
    SET @SQL = ''                              
	SET @SQL = ' bcp " SELECT * FROM [CSOKYC-6].upload.dbo.tbl_data where data is not NULL'                              
	SET @SQL = @SQL + ' " queryout H:\EXCHANGEFILES\' + ltrim(rtrim(@FileName+@FileExtenstion)) + ' -c -Sintranet -Uaolinhouse -Pe$$gnfDTVs2455GZAcc '                                 
	SET @SQL = '''' + @SQL + ''''                              
	SET @SQL = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @SQL                              
  
    PRINT @SQL                              
	EXEC (@SQL)   
  end 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_AllSquareoff_Exception
-- --------------------------------------------------

-- =============================================      
-- Author:  Abha Jaiswal      
-- Create date: 12/09/2017      
-- Description: Exception file upload       
-- =============================================      
CREATE PROCEDURE [dbo].[Upload_AllSquareoff_Exception]      
@filename as varchar(50),      
@IPaddress as varchar(25),                          
@Enteredby as varchar(15)        
AS      
BEGIN TRY           
      
truncate table general.dbo.Tbl_All_SquareOff_Exception_FileUpload                                
insert into general.dbo.Tbl_All_SquareOff_Exception_FileUpload                         
select *,@filename                        
from Tbl_All_SquareOff_Exception_FileUpload with (nolock)                        
      
--truncate table Tbl_All_SquareOff_Exception_FileUpload      
    
Update general.dbo.Tbl_All_SquareOff_Exception_FileUpload set Exception_Remarks=(case when Exception_Remarks='A' then'Request on cheque consideration'     
                                                                                      when Exception_Remarks='B' then 'Fund transfer'    
                                                                                      when Exception_Remarks='C' then 'Corporate action or Partial square off'    
                                                                                      when Exception_Remarks='D' then 'CSORM excluded codes due to some adjustments'    
                                                                                      else '' end)    
      
              
/*Proj Risk Exception */              
              
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                         
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE=0.00,CASH_SQAUREUP,DERIV_SQAUREUP=0.00,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS=B.Exception_Remarks,                        
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP=0.00,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                        
ENTERED_BY=@Enteredby                      
FROM  general.dbo.tbl_projrisk_t2day_data A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code --133              
                         
UPDATE  general.dbo.tbl_projrisk_t2day_data  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                        
ENTERED_BY=@Enteredby from  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.tbl_projrisk_t2day_data.party_code=B.party_code      
/*NBFC Proj Risk SquareOff Exception*/                  
              
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY                
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,                
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS=@IPaddress,                
ENTERED_BY=@Enteredby                
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)             
on A.party_code=B.party_code --2              
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)              
                
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks        
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.SQUAREUP_CLIENT_NBFC.party_code=B.party_code            
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
              
              
/*NBFC Margin Shortage Exception*/                    
              
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                   
SELECT                 
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,                
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,                
Email,Exemption='Y',Remarks=B.Exception_Remarks,AMOUNT,SOURCE_TYPE,IPADDRESS=@IPaddress,ENTERED_BY=@Enteredby        
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)       
on A.Client_Code=B.party_code  --194               
--WHERE Client_code =@PARTY_CODE                   
                        
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks            
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP.client_code=B.party_code      
--WHERE Client_Code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                  
        
/*             
/* VMSS Exception */              
              
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                         
SELECT                   REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,                    
update_date=GETDATE(),Mobile_pager,                      
Email,Exception='Y',Remarks='Corporate action / branch call' ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                       
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))                  
 */             
             
/*Ageing Exception*/                
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY           
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS=B.Exception_Remarks ,          
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPaddress,           
 ENTERED_BY=@Enteredby            
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP_Process2 A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                          
                
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP_Process2  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks      
 from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT_T7_EXP_Process2.party_code=B.party_code      
 --WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))             
         
/* MTF Exception */                      
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                        
SELECT                       
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,                    
update_date=GETDATE(),Mobile_pager,                      
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks=B.Exception_Remarks ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                       
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where squareoff.DBO.MTF_sqoff_client_exp.party_code=B.party_code      
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                  


/* MTF Ageing T+7 Exception */                      
INSERT INTO general.dbo.MTF_AgeingT7_sqoff_client_exp_hist                     
SELECT                       
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,MTF_T7_Shortage_AfterAdj,Square_Off_Value,square_off_day,                    
update_date=GETDATE(),Mobile_pager,                      
Email,balance,Exception='Y',Remarks=B.Exception_Remarks ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                     
FROM general.DBO.MTF_AgeingT7_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) 
on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE general.DBO.MTF_AgeingT7_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.DBO.MTF_AgeingT7_sqoff_client_exp.party_code=B.party_code      
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                           

/*Added on Dec 18 for new process*/
UPDATE general.DBO.MTF_AgeingT7_sqoff_client_exp_Process2 SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.DBO.MTF_AgeingT7_sqoff_client_exp_Process2.party_code=B.party_code      


/*Added on Mar 02 2024 for MTF 90 days new process*/
UPDATE general.DBO.tbl_MTF90Days_Exception SET Exception='Y',REMARKS=B.Exception_Remarks,upd_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.DBO.tbl_MTF90Days_Exception.party_code=B.party_code      

END TRY                  
BEGIN CATCH                  
truncate table Tbl_All_SquareOff_Exception_FileUpload                   
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_AllSquareoff_Exception_15032018
-- --------------------------------------------------
-- =============================================      
-- Author:  Abha Jaiswal      
-- Create date: 12/09/2017      
-- Description: Exception file upload       
-- =============================================      
CREATE PROCEDURE [dbo].[Upload_AllSquareoff_Exception_15032018]      
@filename as varchar(50),      
@IPaddress as varchar(25),                          
@Enteredby as varchar(15)        
AS      
BEGIN TRY           
      
truncate table general.dbo.Tbl_All_SquareOff_Exception_FileUpload                                
insert into general.dbo.Tbl_All_SquareOff_Exception_FileUpload                         
select *,@filename                        
from Tbl_All_SquareOff_Exception_FileUpload with (nolock)                        
      
--truncate table Tbl_All_SquareOff_Exception_FileUpload      
    
Update general.dbo.Tbl_All_SquareOff_Exception_FileUpload set Exception_Remarks=(case when Exception_Remarks='A' then'Request on cheque consideration'     
                                                                                      when Exception_Remarks='B' then 'Fund transfer'    
                                                                                      when Exception_Remarks='C' then 'Corporate actions'    
                                                                                      when Exception_Remarks='D' then 'CSORM excluded codes due to some adjustments'    
                                                                                      else '' end)    
      
              
/*Proj Risk Exception */              
              
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                         
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE=0.00,CASH_SQAUREUP,DERIV_SQAUREUP=0.00,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS=B.Exception_Remarks,                        
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP=0.00,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                        
ENTERED_BY=@Enteredby                      
FROM  general.dbo.tbl_projrisk_t2day_data A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code --133              
                         
UPDATE  general.dbo.tbl_projrisk_t2day_data  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                        
ENTERED_BY=@Enteredby from  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.tbl_projrisk_t2day_data.party_code=B.party_code      
/*NBFC Proj Risk SquareOff Exception*/                  
              
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY                
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,                
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS=@IPaddress,                
ENTERED_BY=@Enteredby                
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)             
on A.party_code=B.party_code --2              
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)              
                
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks        
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.SQUAREUP_CLIENT_NBFC.party_code=B.party_code            
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
              
              
/*NBFC Margin Shortage Exception*/                    
              
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                   
SELECT                 
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,                
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,                
Email,Exemption='Y',Remarks=B.Exception_Remarks,AMOUNT,SOURCE_TYPE,IPADDRESS=@IPaddress,ENTERED_BY=@Enteredby        
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)       
on A.Client_Code=B.party_code  --194               
--WHERE Client_code =@PARTY_CODE                   
                        
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks            
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP.client_code=B.party_code      
--WHERE Client_Code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                  
        
/*             
/* VMSS Exception */              
              
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                         
SELECT                   REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,                    
update_date=GETDATE(),Mobile_pager,                      
Email,Exception='Y',Remarks='Corporate action / branch call' ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                       
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))                  
 */             
             
/*Ageing Exception*/                
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY           
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS=B.Exception_Remarks ,          
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPaddress,           
 ENTERED_BY=@Enteredby            
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                          
                
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks      
 from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT_T7_EXP.party_code=B.party_code      
 --WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))             
         
/* MTF Exception */                      
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                        
SELECT                       
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,                    
update_date=GETDATE(),Mobile_pager,                      
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks=B.Exception_Remarks ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                       
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where squareoff.DBO.MTF_sqoff_client_exp.party_code=B.party_code      
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                  
         
                   
END TRY                  
BEGIN CATCH                  
truncate table Tbl_All_SquareOff_Exception_FileUpload                   
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_AllSquareoff_Exception_bkup_18122019
-- --------------------------------------------------
-- =============================================      
-- Author:  Abha Jaiswal      
-- Create date: 12/09/2017      
-- Description: Exception file upload       
-- =============================================      
create PROCEDURE [dbo].[Upload_AllSquareoff_Exception_bkup_18122019]      
@filename as varchar(50),      
@IPaddress as varchar(25),                          
@Enteredby as varchar(15)        
AS      
BEGIN TRY           
      
truncate table general.dbo.Tbl_All_SquareOff_Exception_FileUpload                                
insert into general.dbo.Tbl_All_SquareOff_Exception_FileUpload                         
select *,@filename                        
from Tbl_All_SquareOff_Exception_FileUpload with (nolock)                        
      
--truncate table Tbl_All_SquareOff_Exception_FileUpload      
    
Update general.dbo.Tbl_All_SquareOff_Exception_FileUpload set Exception_Remarks=(case when Exception_Remarks='A' then'Request on cheque consideration'     
                                                                                      when Exception_Remarks='B' then 'Fund transfer'    
                                                                                      when Exception_Remarks='C' then 'Corporate actions'    
                                                                                      when Exception_Remarks='D' then 'CSORM excluded codes due to some adjustments'    
                                                                                      else '' end)    
      
              
/*Proj Risk Exception */              
              
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                         
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE=0.00,CASH_SQAUREUP,DERIV_SQAUREUP=0.00,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS=B.Exception_Remarks,                        
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP=0.00,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                        
ENTERED_BY=@Enteredby                      
FROM  general.dbo.tbl_projrisk_t2day_data A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code --133              
                         
UPDATE  general.dbo.tbl_projrisk_t2day_data  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                        
ENTERED_BY=@Enteredby from  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.tbl_projrisk_t2day_data.party_code=B.party_code      
/*NBFC Proj Risk SquareOff Exception*/                  
              
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY                
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,                
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS=@IPaddress,                
ENTERED_BY=@Enteredby                
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)             
on A.party_code=B.party_code --2              
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)              
                
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks        
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.SQUAREUP_CLIENT_NBFC.party_code=B.party_code            
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
              
              
/*NBFC Margin Shortage Exception*/                    
              
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                   
SELECT                 
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,                
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,                
Email,Exemption='Y',Remarks=B.Exception_Remarks,AMOUNT,SOURCE_TYPE,IPADDRESS=@IPaddress,ENTERED_BY=@Enteredby        
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)       
on A.Client_Code=B.party_code  --194               
--WHERE Client_code =@PARTY_CODE                   
                        
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks            
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP.client_code=B.party_code      
--WHERE Client_Code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                  
        
/*             
/* VMSS Exception */              
              
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                         
SELECT                   REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,                    
update_date=GETDATE(),Mobile_pager,                      
Email,Exception='Y',Remarks='Corporate action / branch call' ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                       
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))                  
 */             
             
/*Ageing Exception*/                
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY           
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS=B.Exception_Remarks ,          
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPaddress,           
 ENTERED_BY=@Enteredby            
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                          
                
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks      
 from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT_T7_EXP.party_code=B.party_code      
 --WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))             
         
/* MTF Exception */                      
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                        
SELECT                       
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,                    
update_date=GETDATE(),Mobile_pager,                      
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks=B.Exception_Remarks ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                       
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where squareoff.DBO.MTF_sqoff_client_exp.party_code=B.party_code      
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                  


/* MTF Ageing T+7 Exception */                      
INSERT INTO general.dbo.MTF_AgeingT7_sqoff_client_exp_hist                     
SELECT                       
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,MTF_T7_Shortage_AfterAdj,Square_Off_Value,square_off_day,                    
update_date=GETDATE(),Mobile_pager,                      
Email,balance,Exception='Y',Remarks=B.Exception_Remarks ,                      
AMOUNT,SOURCE_TYPE,                      
IPADDRESS=@IPaddress,                         
ENTERED_BY=@Enteredby                     
FROM general.DBO.MTF_AgeingT7_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) 
on A.party_code=B.party_code                          
--WHERE party_code =@PARTY_CODE    --732                     
                              
UPDATE general.DBO.MTF_AgeingT7_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.DBO.MTF_AgeingT7_sqoff_client_exp.party_code=B.party_code      
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                           
                   
END TRY                  
BEGIN CATCH                  
truncate table Tbl_All_SquareOff_Exception_FileUpload                   
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_AllSquareoff_Exception_bkup_beforeprocess_09022018
-- --------------------------------------------------
-- =============================================    
-- Author:  Abha Jaiswal    
-- Create date: 12/09/2017    
-- Description: Exception file upload     
-- =============================================    
create PROCEDURE [dbo].[Upload_AllSquareoff_Exception_bkup_beforeprocess_09022018]    
@filename as varchar(50),    
@IPaddress as varchar(25),                        
@Enteredby as varchar(15)      
AS    
BEGIN TRY         
    
truncate table general.dbo.Tbl_All_SquareOff_Exception_FileUpload                              
insert into general.dbo.Tbl_All_SquareOff_Exception_FileUpload                       
select *,@filename                      
from Tbl_All_SquareOff_Exception_FileUpload with (nolock)                      
    
--truncate table Tbl_All_SquareOff_Exception_FileUpload    
  
Update general.dbo.Tbl_All_SquareOff_Exception_FileUpload set Exception_Remarks=(case when Exception_Remarks='A' then'Request on cheque consideration'   
                                                                                      when Exception_Remarks='B' then 'Fund transfer'  
                                                                                      when Exception_Remarks='C' then 'Corporate actions'  
                                                                                      when Exception_Remarks='D' then 'CSORM excluded codes due to some adjustments'  
                                                                                      else '' end)  
    
            
/*Proj Risk Exception */            
            
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                       
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS=B.Exception_Remarks,                      
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby                    
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)   on A.party_code=B.party_code --133            
                       
UPDATE  general.dbo.SQUAREUP_CLIENT  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby from  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT.party_code=B.party_code    
/*NBFC Proj Risk SquareOff Exception*/                
            
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY              
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,              
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS=@IPaddress,              
ENTERED_BY=@Enteredby              
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)           
on A.party_code=B.party_code --2            
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)            
              
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.SQUAREUP_CLIENT_NBFC.party_code=B.party_code          
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))              
            
            
/*NBFC Margin Shortage Exception*/                  
            
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                 
SELECT               
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,              
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,              
Email,Exemption='Y',Remarks=B.Exception_Remarks,AMOUNT,SOURCE_TYPE,IPADDRESS=@IPaddress,ENTERED_BY=@Enteredby      
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)     
on A.Client_Code=B.party_code  --194             
--WHERE Client_code =@PARTY_CODE                 
                      
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks          
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP.client_code=B.party_code    
--WHERE Client_Code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
      
/*           
/* VMSS Exception */            
            
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                       
SELECT                   REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,                  
update_date=GETDATE(),Mobile_pager,                    
Email,Exception='Y',Remarks='Corporate action / branch call' ,                    
AMOUNT,SOURCE_TYPE,                    
IPADDRESS=@IPaddress,                       
ENTERED_BY=@Enteredby                     
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                        
--WHERE party_code =@PARTY_CODE    --732                   
                            
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS=@IPaddress,                    
ENTERED_BY=@Enteredby WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))                
 */           
           
/*Ageing Exception*/              
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY         
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS=B.Exception_Remarks ,        
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPaddress,         
 ENTERED_BY=@Enteredby          
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                        
              
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks    
 from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT_T7_EXP.party_code=B.party_code    
 --WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))           
       
/* MTF Exception */                    
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                      
SELECT                     
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,                  
update_date=GETDATE(),Mobile_pager,                    
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks=B.Exception_Remarks ,                    
AMOUNT,SOURCE_TYPE,                    
IPADDRESS=@IPaddress,                       
ENTERED_BY=@Enteredby                     
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                        
--WHERE party_code =@PARTY_CODE    --732                   
                            
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                    
ENTERED_BY=@Enteredby    
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where squareoff.DBO.MTF_sqoff_client_exp.party_code=B.party_code    
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
       
                 
END TRY                
BEGIN CATCH                
truncate table Tbl_All_SquareOff_Exception_FileUpload                 
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_AllSquareoff_Exception_bkup14022018
-- --------------------------------------------------
-- =============================================    
-- Author:  Abha Jaiswal    
-- Create date: 12/09/2017    
-- Description: Exception file upload     
-- =============================================    
create PROCEDURE [dbo].[Upload_AllSquareoff_Exception_bkup14022018]    
@filename as varchar(50),    
@IPaddress as varchar(25),                        
@Enteredby as varchar(15)      
AS    
BEGIN TRY         
    
truncate table general.dbo.Tbl_All_SquareOff_Exception_FileUpload                              
insert into general.dbo.Tbl_All_SquareOff_Exception_FileUpload                       
select *,@filename                      
from Tbl_All_SquareOff_Exception_FileUpload with (nolock)                      
    
--truncate table Tbl_All_SquareOff_Exception_FileUpload    
  
Update general.dbo.Tbl_All_SquareOff_Exception_FileUpload set Exception_Remarks=(case when Exception_Remarks='A' then'Request on cheque consideration'   
                                                                                      when Exception_Remarks='B' then 'Fund transfer'  
                                                                                      when Exception_Remarks='C' then 'Corporate actions'  
                                                                                      when Exception_Remarks='D' then 'CSORM excluded codes due to some adjustments'  
                                                                                      else '' end)  
    
            
/*Proj Risk Exception */            
            
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                       
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,DERIV_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS=B.Exception_Remarks,                      
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby                    
FROM  general.dbo.SQUAREUP_CLIENT A with (nolock)    inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)   on A.party_code=B.party_code --133            
                       
UPDATE  general.dbo.SQUAREUP_CLIENT  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby from  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT.party_code=B.party_code    
/*NBFC Proj Risk SquareOff Exception*/                
            
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY              
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,              
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS=@IPaddress,              
ENTERED_BY=@Enteredby              
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)           
on A.party_code=B.party_code --2            
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)            
              
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.SQUAREUP_CLIENT_NBFC.party_code=B.party_code          
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))              
            
            
/*NBFC Margin Shortage Exception*/                  
            
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                 
SELECT               
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,              
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,              
Email,Exemption='Y',Remarks=B.Exception_Remarks,AMOUNT,SOURCE_TYPE,IPADDRESS=@IPaddress,ENTERED_BY=@Enteredby      
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)     
on A.Client_Code=B.party_code  --194             
--WHERE Client_code =@PARTY_CODE                 
                      
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks          
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP.client_code=B.party_code    
--WHERE Client_Code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
      
/*           
/* VMSS Exception */            
            
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                       
SELECT                   REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,                  
update_date=GETDATE(),Mobile_pager,                    
Email,Exception='Y',Remarks='Corporate action / branch call' ,                    
AMOUNT,SOURCE_TYPE,                    
IPADDRESS=@IPaddress,                       
ENTERED_BY=@Enteredby                     
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                        
--WHERE party_code =@PARTY_CODE    --732                   
                            
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS=@IPaddress,                    
ENTERED_BY=@Enteredby WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))                
 */           
           
/*Ageing Exception*/              
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY         
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS=B.Exception_Remarks ,        
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPaddress,         
 ENTERED_BY=@Enteredby          
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                        
              
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks    
 from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT_T7_EXP.party_code=B.party_code    
 --WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))           
       
/* MTF Exception */                    
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                      
SELECT                     
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,                  
update_date=GETDATE(),Mobile_pager,                    
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks=B.Exception_Remarks ,                    
AMOUNT,SOURCE_TYPE,                    
IPADDRESS=@IPaddress,                       
ENTERED_BY=@Enteredby                     
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                        
--WHERE party_code =@PARTY_CODE    --732                   
                            
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                    
ENTERED_BY=@Enteredby    
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where squareoff.DBO.MTF_sqoff_client_exp.party_code=B.party_code    
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
       
                 
END TRY                
BEGIN CATCH                
truncate table Tbl_All_SquareOff_Exception_FileUpload                 
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_AllSquareoff_Exception_makelive_10022018
-- --------------------------------------------------
-- =============================================    
-- Author:  Abha Jaiswal    
-- Create date: 12/09/2017    
-- Description: Exception file upload     
-- =============================================    
CREATE PROCEDURE [dbo].[Upload_AllSquareoff_Exception_makelive_10022018]    
@filename as varchar(50),    
@IPaddress as varchar(25),                        
@Enteredby as varchar(15)      
AS    
BEGIN TRY         
    
truncate table general.dbo.Tbl_All_SquareOff_Exception_FileUpload                              
insert into general.dbo.Tbl_All_SquareOff_Exception_FileUpload                       
select *,@filename                      
from Tbl_All_SquareOff_Exception_FileUpload with (nolock)                      
    
--truncate table Tbl_All_SquareOff_Exception_FileUpload    
  
Update general.dbo.Tbl_All_SquareOff_Exception_FileUpload set Exception_Remarks=(case when Exception_Remarks='A' then'Request on cheque consideration'   
                                                                                      when Exception_Remarks='B' then 'Fund transfer'  
                                                                                      when Exception_Remarks='C' then 'Corporate actions'  
                                                                                      when Exception_Remarks='D' then 'CSORM excluded codes due to some adjustments'  
                                                                                      else '' end)  
    
            
/*Proj Risk Exception */            
            
INSERT INTO general.dbo.SQUAREUP_CLIENT_HISTORY                       
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE=0.00,CASH_SQAUREUP,DERIV_SQAUREUP=0.00,SQUAREUPAVAILABLE,EXEMPTION='Y',REMARKS=B.Exception_Remarks,                      
ACT_CASH_SQUAREUP,ACT_DERIV_SQUAREUP=0.00,MOBILE_PAGER,EMAIL,UPDT,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby                    
FROM  general.dbo.tbl_projrisk_t2day_data A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code --133            
                       
UPDATE  general.dbo.tbl_projrisk_t2day_data  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks,LASTUPDT=GETDATE(),IPADDRESS=@IPaddress,                      
ENTERED_BY=@Enteredby from  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.tbl_projrisk_t2day_data.party_code=B.party_code    
/*NBFC Proj Risk SquareOff Exception*/                
            
INSERT INTO general.dbo.SQUAREUP_CLIENT_NBFC_HISTORY              
SELECT A.PARTY_CODE,NET_DEBIT,PROJ_RISK,NET_AVAILABLE,CASH_SQAUREUP,SQUAREUPAVAILABLE,EXEMPTION,REMARKS,              
ACT_CASH_SQUAREUP,MOBILE_PAGER,EMAIL,UPDT,DATETIME=GETDATE(),IPADDRESS=@IPaddress,              
ENTERED_BY=@Enteredby              
FROM general.dbo.SQUAREUP_CLIENT_NBFC A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)           
on A.party_code=B.party_code --2            
--WHERE PARTY_CODE in(select party_code from general.dbo.Tbl_All_Squareoff_Exception_File)            
              
UPDATE general.dbo.SQUAREUP_CLIENT_NBFC  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks      
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.SQUAREUP_CLIENT_NBFC.party_code=B.party_code          
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))              
            
            
/*NBFC Margin Shortage Exception*/                  
            
INSERT INTO general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                 
SELECT               
REGION,BRANCH,SB,Client_Code,CATEGORY,Client_Type,SB_CATEGORY,Margin_Shortage,Excess_Credit_Of_Other_Segments,              
Margin_Shortage_After_ExcessCredit_Adj,Square_Off_Value,SquareOffAction,update_date=GETDATE(),ActiveEx,Mobile_pager,              
Email,Exemption='Y',Remarks=B.Exception_Remarks,AMOUNT,SOURCE_TYPE,IPADDRESS=@IPaddress,ENTERED_BY=@Enteredby      
FROM general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join  general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock)     
on A.Client_Code=B.party_code  --194             
--WHERE Client_code =@PARTY_CODE                 
                      
UPDATE general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks          
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where  general.dbo.MARGIN_SHORTAGE_SQOFF_CLIENT_EXP.client_code=B.party_code    
--WHERE Client_Code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
      
/*           
/* VMSS Exception */            
            
INSERT INTO general.dbo.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP_HIST                       
SELECT                   REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,VarMarginShortFall_AftAdj,SquareOffValue,Noofdays,                  
update_date=GETDATE(),Mobile_pager,                    
Email,Exception='Y',Remarks='Corporate action / branch call' ,                    
AMOUNT,SOURCE_TYPE,                    
IPADDRESS=@IPaddress,                       
ENTERED_BY=@Enteredby                     
FROM MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP A with (nolock) inner join general.dbo.Tbl_All_Squareoff_Exception_File B with (nolock) on A.party_code=B.party_code                        
--WHERE party_code =@PARTY_CODE    --732                   
                            
UPDATE MIS.DBO.VMSS_MARGIN_SHORTAGE_SQOFF_CLIENT_EXP SET Exception='Y',REMARKS='Corporate action / branch call',update_date=GETDATE(),IPADDRESS=@IPaddress,                    
ENTERED_BY=@Enteredby WHERE party_code in (select party_code from general.dbo.Tbl_All_Squareoff_Exception_File with (nolock))                
 */           
           
/*Ageing Exception*/              
 INSERT INTO general.dbo.SQUAREUP_CLIENT_T7_EXP_HISTORY         
 SELECT region,branch,sb,A.party_code,category,cli_type,sbcat,ledger,HOLDING,[cash square off value],EXEMPTION='Y',REMARKS=B.Exception_Remarks ,        
 Bucket_007,mobile_pager,email,AMOUNT,SOURCE_TYPE,UPDT=GETDATE(),IPADDRESS=@IPaddress,         
 ENTERED_BY=@Enteredby          
 FROM General.DBO.SQUAREUP_CLIENT_T7_EXP A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                        
              
 UPDATE general.dbo.SQUAREUP_CLIENT_T7_EXP  SET EXEMPTION='Y',REMARKS=B.Exception_Remarks    
 from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where general.dbo.SQUAREUP_CLIENT_T7_EXP.party_code=B.party_code    
 --WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))           
       
/* MTF Exception */                    
INSERT INTO squareoff.dbo.MTF_sqoff_client_exp_hist                      
SELECT                     
REGION,BRANCH,SB,A.party_code,CATEGORY,cli_type,SB_CATEGORY,shortage,SquareOffValue,Noofdays,                  
update_date=GETDATE(),Mobile_pager,                    
Email,balance,holdingbhc,holdingahc,Exception='Y',Remarks=B.Exception_Remarks ,                    
AMOUNT,SOURCE_TYPE,                    
IPADDRESS=@IPaddress,                       
ENTERED_BY=@Enteredby                     
FROM squareoff.DBO.MTF_sqoff_client_exp A with (nolock) inner join general.dbo.Tbl_All_SquareOff_Exception_FileUpload B with (nolock) on A.party_code=B.party_code                        
--WHERE party_code =@PARTY_CODE    --732                   
                            
UPDATE squareoff.DBO.MTF_sqoff_client_exp SET Exception='Y',REMARKS=B.Exception_Remarks,update_date=GETDATE(),IPADDRESS=@IPaddress,                    
ENTERED_BY=@Enteredby    
from general.dbo.Tbl_All_SquareOff_Exception_FileUpload B where squareoff.DBO.MTF_sqoff_client_exp.party_code=B.party_code    
--WHERE party_code in (select party_code from general.dbo.Tbl_All_SquareOff_Exception_FileUpload with (nolock))                
       
                 
END TRY                
BEGIN CATCH                
truncate table Tbl_All_SquareOff_Exception_FileUpload                 
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_CUSASquareoff_Exception
-- --------------------------------------------------
-- =============================================
-- Author:		Abha Jaiswal
-- Create date: 15/04/2021
-- Description:	Cusa sq off exception
-- =============================================
CREATE PROCEDURE [dbo].[Upload_CUSASquareoff_Exception]
@filename as varchar(50),      
@IPaddress as varchar(25),                          
@Enteredby as varchar(15) 
AS
BEGIN

truncate table general.dbo.tbl_cusa_exception_file                                
insert into general.dbo.tbl_cusa_exception_file                         
select *,@filename                        
from tbl_cusa_exception_file with (nolock)  

INSERT INTO general.dbo.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exceptio_Hist           
SELECT A.party_code,Exception,IPADDRESS=@IPaddress,           
ENTERED_BY=@Enteredby,Upd_date            
FROM General.DBO.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exception A with (nolock) inner join general.dbo.tbl_cusa_exception_file B with (nolock) on A.party_code=B.party_code                          
                
 UPDATE general.dbo.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exception  SET Exception='Y'    
 from general.dbo.tbl_cusa_exception_file B where general.dbo.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exception.party_code=B.party_code 
    

 delete from General.DBO.tbl_CUSA_SqoffData_New where party_code in (select distinct party_code from tbl_cusa_exception_file)
 delete from General.DBO.tbl_CUSA_Combine_SMS where party_code in (select distinct party_code from tbl_cusa_exception_file)
 delete from General.DBO.tbl_NRMS_Cusa_Sqoff_Data_Version3 where party_code in (select distinct party_code from tbl_cusa_exception_file)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_CUSASquareoff_Exception_BKUP_05042022
-- --------------------------------------------------

-- =============================================
-- Author:		Abha Jaiswal
-- Create date: 15/04/2021
-- Description:	Cusa sq off exception
-- =============================================
CREATE PROCEDURE [dbo].[Upload_CUSASquareoff_Exception_BKUP_05042022]
@filename as varchar(50),      
@IPaddress as varchar(25),                          
@Enteredby as varchar(15) 
AS
BEGIN

truncate table general.dbo.tbl_cusa_exception_file                                
insert into general.dbo.tbl_cusa_exception_file                         
select *,@filename                        
from tbl_cusa_exception_file with (nolock)  

INSERT INTO general.dbo.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exceptio_Hist           
SELECT A.party_code,Exception,IPADDRESS=@IPaddress,           
ENTERED_BY=@Enteredby,Upd_date            
FROM General.DBO.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exception A with (nolock) inner join general.dbo.tbl_cusa_exception_file B with (nolock) on A.party_code=B.party_code                          
                
 UPDATE general.dbo.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exception  SET Exception='Y'    
 from general.dbo.tbl_cusa_exception_file B where general.dbo.tbl_NRMS_Cusa_Sqoff_Data_Version3_Exception.party_code=B.party_code 
    

 delete from General.DBO.tbl_NRMS_Cusa_Sqoff_Data_Version3 where party_code in (select distinct party_code from tbl_cusa_exception_file)


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upload_ProjRiskLive_Exception
-- --------------------------------------------------
-- =============================================
-- Author:		Abha Jaiswal
-- Create date: 06/04/2022
-- Description:	Pure risk sqoff off exception
-- =============================================
CREATE PROCEDURE [dbo].[Upload_ProjRiskLive_Exception]
@filename as varchar(50),      
@IPaddress as varchar(25),                          
@Enteredby as varchar(15) 
AS
BEGIN
            
 UPDATE general.dbo.tbl_projRisk_Varshortage_Exception  SET Exception='Y'    
 from tbl_projriskLiveSMS_exception B where general.dbo.tbl_projRisk_Varshortage_Exception.cltcode=B.party_code 
    
 delete from General.DBO.tbl_projRisk_Varshortage_Exception where cltcode in (select distinct party_code from tbl_projriskLiveSMS_exception)

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------

Create PROCEDURE [dbo].[usp_findInUSP]              
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
-- PRINT @STR            
  EXEC(@STR)            
    
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MarginShortfall_LD_Files
-- --------------------------------------------------
--USP_MarginShortfall_LD_Files '196.1.115.147','MarginShortfall_17012024165912.csv','E55539'  
CREATE  PROC [dbo].[USP_MarginShortfall_LD_Files] -- '196.1.115.147','MarginShortfall_27102021204211','E55539'            
(                
@SERVER AS VARCHAR(25),              
@FILENAME AS VARCHAR(100),          
@UPlOADEDBY AS VARCHAR(20)                
)                
AS                
BEGIN  
  truncate table tbl_LDmarginFiles
  
      --declare @FileName VARCHAR(50)='MarginShortfall_17012024165912.csv'  
 
  Declare @filePath2 varchar(500)='' ,@NSEFOTrade varchar(11)        
   set @filePath2 ='\\INHOUSELIVEAPP1-FS.angelone.in\D\UPLOAD1\'+@FileName+''                
      
   DECLARE @sql2 NVARCHAR(4000) = 'BULK INSERT tbl_LDmarginFiles FROM ''' + @filePath2 + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=2 )';                
   EXEC(@sql2) 

truncate table general.dbo.tbl_LDmarginFile_Upload  
insert into general.dbo.tbl_LDmarginFile_Upload  
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin ,Total_Shortfall,Var_Margin_cash,MTM_cash,                
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,       
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR,getdate(),'E00229',@FILENAME   
from tbl_LDmarginFiles     

exec intranet.risk.dbo.USP_UPLOAD_marginshortfall              

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_upload_bsense_varfile
-- --------------------------------------------------
CREATE procedure [dbo].[usp_upload_bsense_varfile]
as
begin
	Declare @Query varchar(max)=null;                  
	Declare @Error int=0;                
	Declare @Count int=0;                 
                
	Declare @mUpd_TempTable varchar(100)=null;                            
	Declare @mUpd_deli varchar(5)=null;                            
	Declare @mUpd_FirstRow varchar(5)=null;                            
	Declare @mUpd_FinSP varchar(50)=null;                            
	Declare @FileLocation varchar(100)=null;                            
	Declare @FileName varchar(1000)=null;                            
	Declare @FileExtenstion varchar(10)=null;                            
	Declare @FileSize numeric(18,2)=null  


	set @FileName='SQOFF_Segmentwise_'+REPLACE(CONVERT(varchar(10),GETDATE(),105),'-','')+'.csv'
	set @FileLocation ='\\INHOUSELIVEAPP2-FS.angelone.in\nrms\Exposure file\'+ltrim(rtrim(@FileName));                   
	print @FileLocation 

	set @Query='truncate table Tbl_Sqoff_BSENSE_ListedScrips ';                          
	print @Query                          
	execute (@Query)                        
	set @Query='bulk insert [Tbl_Sqoff_BSENSE_ListedScrips] from '''+@FileLocation+''' WITH (FIRSTROW=1,FIELDTERMINATOR ='','' ,KeepNULLS)';                
	print @Query                            
	execute (@Query)

end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall
-- --------------------------------------------------


CREATE  PROC [dbo].[USP_UPLOAD_marginshortfall] -- '196.1.115.147','MarginShortfall_27102021204211','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN    
return 0
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE tbl_LDmarginFile_Upload              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO tbl_LDmarginFile_Upload
Select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR             
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR from [Sheet1$]'' )'  


            
PRINT @SQL              
EXEC (@SQL) 

truncate table general.dbo.tbl_LDmarginFile_Upload
insert into general.dbo.tbl_LDmarginFile_Upload
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin ,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR,getdate(),'E00229',@FILENAME 
from tbl_LDmarginFile_Upload        
              
               
exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_26102021new
-- --------------------------------------------------


create  PROC [dbo].[USP_UPLOAD_marginshortfall_26102021new] -- '196.1.115.147','MarginShortfall_27012021111905','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN              
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE tbl_LDmarginFile_Upload              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO tbl_LDmarginFile_Upload_26102021
Select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,Total_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR             
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,Total_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR from [Sheet1$]'' )'  


            
PRINT @SQL              
EXEC (@SQL) 

truncate table general.dbo.tbl_LDmarginFile_Upload_26102021
insert into general.dbo.tbl_LDmarginFile_Upload_26102021
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,Total_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR,getdate(),'E00229',@FILENAME 
from tbl_LDmarginFile_Upload_26102021        
              
               
--exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_backup_13012020
-- --------------------------------------------------


CREATE PROC [dbo].[USP_UPLOAD_marginshortfall_backup_13012020]  --'196.1.115.142','abc.xls','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN              
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE temp_marginshortfall              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO temp_marginshortfall SELECT [Ro Code],[Branch Code],[Family Code],[Client Code],[Client Name],[Ledger Balance],[Collateral],[Span Margin],              
[Shortfall],[% Of Penalty],[Penalty Amount],[Span Margin1],[Shortfall1],[% Of Penalty1],[Penalty Amount1],[Span Margin2],[Shortfall2],              
[% Of Penalty2],[Penalty Amount2],GETDATE(),''e10398''              
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''select [Ro Code],[Branch Code],[Family Code],[Client Code],[Client Name],[Ledger Balance],[Collateral],[Span Margin],              
[Shortfall],[% Of Penalty],[Penalty Amount],[Span Margin1],[Shortfall1],[% Of Penalty1],[Penalty Amount1],[Span Margin2],[Shortfall2],              
[% Of Penalty2],[Penalty Amount2] from [Sheet1$]'' )'              
              
              
--PRINT @SQL              
EXEC (@SQL)              
exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_bkup_25042020
-- --------------------------------------------------


CREATE PROC [dbo].[USP_UPLOAD_marginshortfall_bkup_25042020]  --'196.1.115.142','abc.xls','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN              
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE temp_marginshortfall_new              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO temp_marginshortfall_new SELECT [Ro Code],[Branch Code],[Family Code],[Client Code],[Client Name],[Ledger Balance],[Collateral],[Var Margin],[MTM],[Span + Exp Margin],              
[Shortfall],[% Of Penalty],[Penalty Amount],[Span Margin1],[Shortfall1],[% Of Penalty1],[Penalty Amount1],[Span Margin2],[Shortfall2],              
[% Of Penalty2],[Penalty Amount2],GETDATE(),''e10398''              
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''select [Ro Code],[Branch Code],[Family Code],[Client Code],[Client Name],[Ledger Balance],[Collateral],           
[Var Margin],[MTM],[Span + Exp Margin],[Shortfall],[% Of Penalty],[Penalty Amount],[Span Margin1],[Shortfall1],[% Of Penalty1],[Penalty Amount1],[Span Margin2],[Shortfall2],              
[% Of Penalty2],[Penalty Amount2] from [Sheet1$]'' )'              
              
              
--PRINT @SQL              
EXEC (@SQL)              
exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_bkup_26102021
-- --------------------------------------------------


create PROC [dbo].[USP_UPLOAD_marginshortfall_bkup_26102021] -- '196.1.115.147','MarginShortfall_27012021111905','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN              
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE tbl_LDmarginFile_Upload              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO tbl_LDmarginFile_Upload 
Select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR             
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR from [Sheet1$]'' )'  


            
PRINT @SQL              
EXEC (@SQL) 

truncate table general.dbo.tbl_LDmarginFile_Upload
insert into general.dbo.tbl_LDmarginFile_Upload
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR,getdate(),'E00229',@FILENAME 
from tbl_LDmarginFile_Upload        
              
               
exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_LD
-- --------------------------------------------------
--[USP_UPLOAD_marginshortfall_LD] 'LD_upload_30042020.csv'
CREATE PROCEDURE [dbo].[USP_UPLOAD_marginshortfall_LD](@filename as varchar(500))  
as                  
BEGIN TRY  
 
 TRUNCATE TABLE general.dbo.tbl_LDmarginFile_Upload  

 INSERT INTO general.dbo.tbl_LDmarginFile_Upload 
 select *,convert(varchar(20),getdate()) ,'E65689',@filename from tbl_LDmarginFile_Upload 
 
 exec intranet.risk.dbo.USP_UPLOAD_marginshortfall          
 TRUNCATE TABLE tbl_LDmarginFile_Upload                
END TRY            
BEGIN CATCH  
         
 TRUNCATE TABLE tbl_LDmarginFile_Upload          
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_new
-- --------------------------------------------------


create PROC [dbo].[USP_UPLOAD_marginshortfall_new]  --'196.1.115.142','abc.xls','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN              
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE tbl_LDmarginFile_Upload              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO tbl_LDmarginFile_Upload 
Select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR,GETDATE(),''e10398''             
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR from [Sheet1$]'' )'              
              
              
--PRINT @SQL              
EXEC (@SQL)              
--exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_marginshortfall_newrms
-- --------------------------------------------------


CREATE  PROC [dbo].[USP_UPLOAD_marginshortfall_newrms] -- '196.1.115.147','MarginShortfall_27102021204211','E55539'          
(              
@SERVER AS VARCHAR(25),            
@FILENAME AS VARCHAR(100),        
@UPlOADEDBY AS VARCHAR(20)              
)              
AS              
BEGIN    
--return 0
SET NOCOUNT ON;              
DECLARE @PATH AS VARCHAR(200)              
DECLARE @SQL AS VARCHAR(8000)              
            
TRUNCATE TABLE tbl_LDmarginFile_Upload              
SET @PATH='\\'+@SERVER+'\D\UPLOAD1\'+@FILENAME        
              
SET @SQL = 'INSERT INTO tbl_LDmarginFile_Upload
Select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR             
FROM OPENROWSET(''MICROSOFT.ACE.OLEDB.12.0'',''EXCEL 8.0;DATABASE='+@PATH+''',''
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR from [Sheet1$]'' )'  


            
PRINT @SQL              
EXEC (@SQL) 

truncate table general.dbo.tbl_LDmarginFile_Upload
insert into general.dbo.tbl_LDmarginFile_Upload
select Ro_Code,Branch_Code,Family_Code,Sub_Group_Code,Client_Code,Client_Name,Ledger_Balance,Collateral,Total_Peak_Margin,TotalSpan_Exp_Equity_Margin ,Total_Shortfall,Var_Margin_cash,MTM_cash,              
Span_Exp_Margin_FO,Premium_Value_FO,MTM_Loss_FO,Span_Exp_Margin_MCX,Premium_Value_MCX,MTM_Loss_MCX,Span_Exp_Margin_Cur,Premium_Value_Cur,     
MTM_Loss_Cur,Span_Exp_Margin_NCDEX,Premium_Value_NCDEX,MTM_Loss_NCDEX,Span_Exp_Margin_MCXCUR,Premium_Value_MCXCUR,MTM_Loss_MCXCUR,getdate(),'E00229',@FILENAME 
from tbl_LDmarginFile_Upload        
              
               
exec intranet.risk.dbo.USP_UPLOAD_marginshortfall            
end              
SET NOCOUNT off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_MCDX_BhavCopy
-- --------------------------------------------------
--select * from sys.procedures order by create_date desc
CREATE procedure [dbo].[USP_UPLOAD_MCDX_BhavCopy]  
 @filename as varchar(50)  
as        

BEGIN TRY  
	
 delete a   

 from History.dbo.MCDX_Bhav_Copy a  

 join general.dbo.MCDX_Bhav_Copy b  

 on a.upd_date = b.upld_date  

 -----------------insert CP in History data---------------    

 insert into History.dbo.MCDX_Bhav_Copy    

 select * from general.dbo.MCDX_Bhav_Copy     

 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.MCDX_Bhav_Copy      

 insert into general.dbo.MCDX_Bhav_Copy   

 select distinct convert(varchar(10),getdate(),121),* from MCDX_Bhav_Copy 

 ---------------------Inserting Data in MIS Server-----------------------   

               
	insert into MIS.UPLOAD.DBO.MCDX_Bhav_Copy_Hist
	select * from MIS.UPLOAD.DBO.MCDX_Bhav_Copy          
	delete from  MIS.UPLOAD.DBO.MCDX_Bhav_Copy 
	insert into MIS.UPLOAD.DBO.MCDX_Bhav_Copy
	select * from MCDX_Bhav_Copy

 update MIS.UPLOAD.DBO.bhavcopy_upload_date set updatedate=getdate() where segment='MCDX'  

 ---------------------End Here-----------------------   
 
 truncate table	MCDX_Bhav_Copy

END TRY  

BEGIN CATCH  
	 truncate table	MCDX_Bhav_Copy
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPLOAD_NCDEX_BhavCopy
-- --------------------------------------------------
--select * from sys.procedures order by create_date desc
CREATE procedure [dbo].[USP_UPLOAD_NCDEX_BhavCopy]  
 @filename as varchar(50)  
as        

BEGIN TRY  
	
 delete a   

 from History.dbo.NCDEX_Bhav_Copy a  

 join general.dbo.NCDEX_Bhav_Copy b  

 on a.upd_date = b.upd_date  

 -----------------insert CP in History data---------------    

 insert into History.dbo.NCDEX_Bhav_Copy    

 select * from general.dbo.NCDEX_Bhav_Copy     

 ---------------------Insert New CP-----------------------    

 truncate table general.dbo.NCDEX_Bhav_Copy      

 insert into general.dbo.NCDEX_Bhav_Copy   

 select distinct convert(varchar(10),getdate(),121),* from NCDEX_Bhav_Copy 

 ---------------------Inserting Data in MIS Server-----------------------   
 --insert into MIS.UPLOAD.DBO.NCDEX_Bhav_Copy_hist    
 --select * from MIS.UPLOAD.DBO.NCDEX_Bhav_Copy
 --delete from  MIS.UPLOAD.DBO.NCDEX_Bhav_Copy 
 --insert into MIS.UPLOAD.DBO.NCDEX_Bhav_Copy
 --select * from NCDEX_Bhav_Copy
 
 --update MIS.UPLOAD.DBO.bhavcopy_upload_date set updatedate=getdate() where segment='NCDX'  

 ---------------------End Here-----------------------   

 truncate table	NCDEX_Bhav_Copy

END TRY  

BEGIN CATCH  
	 truncate table	NCDEX_Bhav_Copy
END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VMSS_BSE_FileUpload
-- --------------------------------------------------
CREATE PROCEDURE VMSS_BSE_FileUpload                          

@filename AS VARCHAR(50)                                

--, @ErrorCode as int OUTPUT                                

AS                                

BEGIN TRY                               

                            

                          

 INSERT INTO General.dbo.VMSS_BSE_REVERSEFILE                                

 SELECT *,'',CONVERT(VARCHAR(11), GETDATE())                                

 FROM VMSS_BSE_REVERSEFILE                                

   



                              

 UPDATE  [squareoff].DBO.vmss_holding                           

 SET ActualSqOffQty = b.qty  ,AvgRate=CONVERT(DECIMAL(15,2),CONVERT(DECIMAL(15, 2),B.rate)/100)      

                     

 FROM           

 (                          

 SELECT A.cltcode,A.Scripname,A.qty ,A.rate,A.scripcode,[date]                                 

 FROM                           

 (                          

 SELECT RTRIM(LTRIM(clientcode)) AS CltCode,ltrim(rtrim(Scripname)) as Scripname ,                               

 sum(qty) as qty,(CONVERT(DECIMAL(10,2),avg(rate))) as rate ,scripcode , convert(varchar(11),[date],103) as [date]                      

 FROM VMSS_BSE_REVERSEFILE group by clientcode ,SCRIPNAME,convert(varchar(11),[date],103),scripcode                    

 ) A                                

 GROUP BY cltcode,A.qty ,A.rate,A.scripcode,convert(varchar(11),[date],103),Scripname                           

 ) B                                

 WHERE  [squareoff].DBO.vmss_holding.Party_code = B.cltcode and   [squareoff].DBO.vmss_holding.scrip_cd=B.scripcode                 

  --and B.Scripname=MIS.dbo.vmss_holding.scrip_cd                       

 and convert(varchar(11),b.[date],103)= convert(varchar(11), [squareoff].DBO.vmss_holding.processDate,103)    

 

   

                  

 UPDATE  [squareoff].DBO.VMSS_data                        

 SET Actual_Cash_Square_Off_Done =(case when Actual_Cash_Square_Off_Done>0.00 then Actual_Cash_Square_Off_Done +B.Total else B.Total end)                              

 FROM (SELECT cltcode,SUM(total) Total,convert(varchar(11),[date],103) as [date]                                 

 FROM (SELECT RTRIM(LTRIM(clientcode)) AS CltCode,                                

 (qty * CONVERT(DECIMAL(15,2),CONVERT(DECIMAL(15, 2),rate)/100))AS Total ,[date]                               

 FROM VMSS_BSE_REVERSEFILE ) A                                

 GROUP BY cltcode,convert(varchar(11),[date],103)) B                                

 WHERE  [squareoff].DBO.VMSS_data.Party_code= B.cltcode                                 

    and  [squareoff].DBO.VMSS_data.NoofDays>=3                   

    and convert(varchar(11),b.[date],103)= convert(varchar(11), [squareoff].DBO.VMSS_data.updatedon,103)                          

                         

--select * from  general.dbo.VMSS_data_combine where Actual_Cash_Square_Off_Done>0 and processdate='sep 09 2015' order by processdate  desc                      

                             

END TRY                                

                                

BEGIN CATCH                                

TRUNCATE TABLE VMSS_BSE_REVERSEFILE                                

                            

END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.VMSS_NSE_FileUpload
-- --------------------------------------------------
                          

                          

CREATE  PROCEDURE [dbo].[VMSS_NSE_FileUpload]                              

@filename AS VARCHAR(50)                              

--,@ErrorCode AS int OUTPUT                              

AS                              

BEGIN TRY                              

                              

--SET @ErrorCode = 0                              

                         

--IF NOT EXISTS (SELECT TOP 1 * FROM General.dbo.VMSS_NSE_REVERSEFILE  A                              

--    INNER JOIN VMSS_NSE_REVERSEFILE B ON A.Trade_No = B.Trade_No                              

--    WHERE PDate = CONVERT(VARCHAR(11),GETDATE()))                              

--BEGIN                              

-- print 'hii'                             

INSERT INTO General.dbo.VMSS_NSE_REVERSEFILE                              

SELECT *,'',CONVERT(VARCHAR(11),GETDATE()) FROM VMSS_NSE_REVERSEFILE                              

                        

UPDATE  [squareoff].DBO.vmss_holding                             

SET ActualSqOffQty = b.Trade_Qty  ,AvgRate=B.rate                      

FROM                              

(SELECT Cltcode,A.Security_Symbol,A.Trade_Qty,A.rate,Trade_entry_Dt_Time                          

FROM                              

(          

SELECT                              

RTRIM(LTRIM(client_ac)) AS CltCode, ltrim(rtrim(Security_Symbol)) as Security_Symbol,                             

sum(Trade_Qty) as Trade_Qty,(CONVERT(DECIMAL(8,2),avg(Trade_Price))) as rate ,convert(varchar(11),Trade_entry_Dt_Time,103) as  Trade_entry_Dt_Time                          

FROM VMSS_NSE_REVERSEFILE  group by client_ac,Security_Symbol,convert(varchar(11),Trade_entry_Dt_Time,103)          

) A                              

group by Cltcode,A.Trade_Qty,A.rate,convert(varchar(11),Trade_entry_Dt_Time,103),Security_Symbol          

) B                              

WHERE [squareoff].DBO.vmss_holding.party_code= B.Cltcode  and B.Security_Symbol=[squareoff].DBO.vmss_holding.scrip_cd                            

--and  general.dbo.Tbl_NBFC_Excess_ShortageSqOff.squareoffaction=7                      

and convert(varchar(11),b.Trade_entry_Dt_Time,103)= convert(varchar(11), [squareoff].DBO.vmss_holding.processDate,103)                             

                  

                 

UPDATE  [squareoff].DBO.VMSS_data                    

SET Actual_Cash_Square_Off_Done =(case when Actual_Cash_Square_Off_Done>0.00 then Actual_Cash_Square_Off_Done +B.Total else B.Total end)                            

FROM (SELECT cltcode,SUM(total) Total,Trade_entry_Dt_Time                             

FROM (SELECT RTRIM(LTRIM(client_ac)) AS CltCode,                      

(Trade_Qty*CONVERT(DECIMAL(15,2), Trade_Price)) AS Total                            

 ,convert(varchar(11),Trade_entry_Dt_Time,103) as  Trade_entry_Dt_Time                               

FROM VMSS_NSE_REVERSEFILE) A                            

GROUP BY cltcode,convert(varchar(11),A.Trade_entry_Dt_Time,103) ) B                            

WHERE [squareoff].DBO.VMSS_data.Party_code= B.cltcode                             

and[squareoff].DBO.VMSS_data.NoofDays>=3            

and convert(varchar(11),b.Trade_entry_Dt_Time,103)= convert(varchar(11),[squareoff].DBO.VMSS_data.updatedon,103)                      

                           

END TRY                              

BEGIN CATCH                              

TRUNCATE TABLE VMSS_NSE_REVERSEFILE                              

                            

END CATCH

GO

-- --------------------------------------------------
-- TABLE dbo.abctest
-- --------------------------------------------------
CREATE TABLE [dbo].[abctest]
(
    [test] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_REVERSEFILE]
(
    [SCRIPCODE] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(10) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [OPP_MMBR_CODE] INT NULL,
    [OPP_MMBR_NAME] INT NULL,
    [TIME_1] DATETIME NULL,
    [DATE] DATETIME NULL,
    [CLIENTCODE] VARCHAR(20) NULL,
    [BUY_SELL] VARCHAR(1) NULL,
    [ORDER_TYPE] VARCHAR(15) NULL,
    [ORDERNO] VARCHAR(20) NULL,
    [INSTITUTION_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_GROUP] VARCHAR(5) NULL,
    [SETTLEMENT_NO_DATE] VARCHAR(20) NULL,
    [TIME_2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_REVERSEFILE_NBFC
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_REVERSEFILE_NBFC]
(
    [SCRIPCODE] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(10) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [OPP_MMBR_CODE] INT NULL,
    [OPP_MMBR_NAME] INT NULL,
    [TIME_1] DATETIME NULL,
    [DATE] DATETIME NULL,
    [CLIENTCODE] VARCHAR(20) NULL,
    [BUY_SELL] VARCHAR(1) NULL,
    [ORDER_TYPE] VARCHAR(15) NULL,
    [ORDERNO] VARCHAR(20) NULL,
    [INSTITUTION_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_GROUP] VARCHAR(5) NULL,
    [SETTLEMENT_NO_DATE] VARCHAR(20) NULL,
    [TIME_2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE]
(
    [SCRIPCODE] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(10) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [OPP_MMBR_CODE] INT NULL,
    [OPP_MMBR_NAME] INT NULL,
    [TIME_1] DATETIME NULL,
    [DATE] DATETIME NULL,
    [CLIENTCODE] VARCHAR(20) NULL,
    [BUY_SELL] VARCHAR(1) NULL,
    [ORDER_TYPE] VARCHAR(15) NULL,
    [ORDERNO] VARCHAR(20) NULL,
    [INSTITUTION_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_GROUP] VARCHAR(5) NULL,
    [SETTLEMENT_NO_DATE] VARCHAR(20) NULL,
    [TIME_2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_REVERSEFILE_T6T7
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_REVERSEFILE_T6T7]
(
    [SCRIPCODE] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(10) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [OPP_MMBR_CODE] INT NULL,
    [OPP_MMBR_NAME] INT NULL,
    [TIME_1] DATETIME NULL,
    [DATE] DATETIME NULL,
    [CLIENTCODE] VARCHAR(20) NULL,
    [BUY_SELL] VARCHAR(1) NULL,
    [ORDER_TYPE] VARCHAR(15) NULL,
    [ORDERNO] VARCHAR(20) NULL,
    [INSTITUTION_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_GROUP] VARCHAR(5) NULL,
    [SETTLEMENT_NO_DATE] VARCHAR(20) NULL,
    [TIME_2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSE_VAR_Test
-- --------------------------------------------------
CREATE TABLE [dbo].[BSE_VAR_Test]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSEVar
-- --------------------------------------------------
CREATE TABLE [dbo].[BSEVar]
(
    [Slno] NVARCHAR(10) NULL,
    [SCRIPCODE] NVARCHAR(20) NULL,
    [SCRIPNAME] NVARCHAR(20) NULL,
    [ISINCODE] NVARCHAR(20) NULL,
    [VARMARGIN] NVARCHAR(20) NULL,
    [FIVARMARGINPER] NVARCHAR(20) NULL,
    [PROCESSON] DATETIME NULL,
    [APPLI_ON] DATETIME NULL,
    [VARMARGIN_RATE] MONEY NULL,
    [ELM_PERC] NVARCHAR(20) NULL,
    [ELM_RATE] MONEY NULL,
    [VAR_ELM_Rate] MONEY NULL,
    [CRT_BY] NVARCHAR(20) NULL,
    [CRT_DATE] DATETIME NULL,
    [MOD_BY] NCHAR(10) NULL,
    [MOD_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Combine_Closing_File
-- --------------------------------------------------
CREATE TABLE [dbo].[Combine_Closing_File]
(
    [Security_Symbol] VARCHAR(100) NULL,
    [Security_Series] VARCHAR(100) NULL,
    [Security_ISIN] VARCHAR(100) NULL,
    [MTM_Price] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ContractFile_MCX
-- --------------------------------------------------
CREATE TABLE [dbo].[ContractFile_MCX]
(
    [C1] VARCHAR(50) NULL,
    [C2] VARCHAR(50) NULL,
    [C3] VARCHAR(50) NULL,
    [C4] VARCHAR(50) NULL,
    [C5] VARCHAR(50) NULL,
    [C6] VARCHAR(50) NULL,
    [C7] VARCHAR(50) NULL,
    [C8] VARCHAR(50) NULL,
    [C9] VARCHAR(50) NULL,
    [C10] VARCHAR(50) NULL,
    [C11] VARCHAR(50) NULL,
    [C12] VARCHAR(50) NULL,
    [C13] VARCHAR(50) NULL,
    [C14] VARCHAR(50) NULL,
    [C15] VARCHAR(50) NULL,
    [C16] VARCHAR(50) NULL,
    [C17] VARCHAR(50) NULL,
    [C18] VARCHAR(50) NULL,
    [C19] VARCHAR(50) NULL,
    [C20] VARCHAR(50) NULL,
    [C21] VARCHAR(50) NULL,
    [C22] VARCHAR(50) NULL,
    [C23] VARCHAR(50) NULL,
    [C24] VARCHAR(50) NULL,
    [C25] VARCHAR(50) NULL,
    [C26] VARCHAR(50) NULL,
    [C27] VARCHAR(50) NULL,
    [C28] VARCHAR(50) NULL,
    [C29] VARCHAR(50) NULL,
    [C30] VARCHAR(50) NULL,
    [C31] VARCHAR(50) NULL,
    [C32] VARCHAR(50) NULL,
    [C33] VARCHAR(50) NULL,
    [C34] VARCHAR(50) NULL,
    [C35] VARCHAR(50) NULL,
    [C36] VARCHAR(50) NULL,
    [C37] VARCHAR(50) NULL,
    [C38] VARCHAR(50) NULL,
    [C39] VARCHAR(50) NULL,
    [C40] VARCHAR(50) NULL,
    [C41] VARCHAR(50) NULL,
    [C42] VARCHAR(50) NULL,
    [C43] VARCHAR(50) NULL,
    [C44] VARCHAR(50) NULL,
    [C45] VARCHAR(50) NULL,
    [C46] VARCHAR(50) NULL,
    [C47] VARCHAR(50) NULL,
    [C48] VARCHAR(50) NULL,
    [C49] VARCHAR(50) NULL,
    [C50] VARCHAR(50) NULL,
    [C51] VARCHAR(50) NULL,
    [C52] VARCHAR(50) NULL,
    [C53] VARCHAR(50) NULL,
    [C54] VARCHAR(50) NULL,
    [C55] VARCHAR(50) NULL,
    [C56] VARCHAR(50) NULL,
    [C57] VARCHAR(50) NULL,
    [C58] VARCHAR(50) NULL,
    [C59] VARCHAR(50) NULL,
    [C60] VARCHAR(50) NULL,
    [C61] VARCHAR(50) NULL,
    [C62] VARCHAR(50) NULL,
    [C63] VARCHAR(50) NULL,
    [C64] VARCHAR(50) NULL,
    [C65] VARCHAR(50) NULL,
    [C66] VARCHAR(50) NULL,
    [C67] VARCHAR(50) NULL,
    [C68] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ContractFile_MCX_bkup_16102023
-- --------------------------------------------------
CREATE TABLE [dbo].[ContractFile_MCX_bkup_16102023]
(
    [C1] VARCHAR(50) NULL,
    [C2] VARCHAR(50) NULL,
    [C3] VARCHAR(50) NULL,
    [C4] VARCHAR(50) NULL,
    [C5] VARCHAR(50) NULL,
    [C6] VARCHAR(50) NULL,
    [C7] VARCHAR(50) NULL,
    [C8] VARCHAR(50) NULL,
    [C9] VARCHAR(50) NULL,
    [C10] VARCHAR(50) NULL,
    [C11] VARCHAR(50) NULL,
    [C12] VARCHAR(50) NULL,
    [C13] VARCHAR(50) NULL,
    [C14] VARCHAR(50) NULL,
    [C15] VARCHAR(50) NULL,
    [C16] VARCHAR(50) NULL,
    [C17] VARCHAR(50) NULL,
    [C18] VARCHAR(50) NULL,
    [C19] VARCHAR(50) NULL,
    [C20] VARCHAR(50) NULL,
    [C21] VARCHAR(50) NULL,
    [C22] VARCHAR(50) NULL,
    [C23] VARCHAR(50) NULL,
    [C24] VARCHAR(50) NULL,
    [C25] VARCHAR(50) NULL,
    [C26] VARCHAR(50) NULL,
    [C27] VARCHAR(50) NULL,
    [C28] VARCHAR(50) NULL,
    [C29] VARCHAR(50) NULL,
    [C30] VARCHAR(50) NULL,
    [C31] VARCHAR(50) NULL,
    [C32] VARCHAR(50) NULL,
    [C33] VARCHAR(50) NULL,
    [C34] VARCHAR(50) NULL,
    [C35] VARCHAR(50) NULL,
    [C36] VARCHAR(50) NULL,
    [C37] VARCHAR(50) NULL,
    [C38] VARCHAR(50) NULL,
    [C39] VARCHAR(50) NULL,
    [C40] VARCHAR(50) NULL,
    [C41] VARCHAR(50) NULL,
    [C42] VARCHAR(50) NULL,
    [C43] VARCHAR(50) NULL,
    [C44] VARCHAR(50) NULL,
    [C45] VARCHAR(50) NULL,
    [C46] VARCHAR(50) NULL,
    [C47] VARCHAR(50) NULL,
    [C48] VARCHAR(50) NULL,
    [C49] VARCHAR(50) NULL,
    [C50] VARCHAR(50) NULL,
    [C51] VARCHAR(50) NULL,
    [C52] VARCHAR(50) NULL,
    [C53] VARCHAR(50) NULL,
    [C54] VARCHAR(50) NULL,
    [C55] VARCHAR(50) NULL,
    [C56] VARCHAR(50) NULL,
    [C57] VARCHAR(50) NULL,
    [C58] VARCHAR(50) NULL,
    [C59] VARCHAR(50) NULL,
    [C60] VARCHAR(50) NULL,
    [C61] VARCHAR(50) NULL,
    [C62] VARCHAR(50) NULL,
    [C63] VARCHAR(50) NULL,
    [C64] VARCHAR(50) NULL,
    [C65] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ContractFile_NCDEX
-- --------------------------------------------------
CREATE TABLE [dbo].[ContractFile_NCDEX]
(
    [C1] VARCHAR(50) NULL,
    [C2] VARCHAR(50) NULL,
    [C3] VARCHAR(50) NULL,
    [C4] VARCHAR(50) NULL,
    [C5] VARCHAR(50) NULL,
    [C6] VARCHAR(50) NULL,
    [C7] VARCHAR(50) NULL,
    [C8] VARCHAR(50) NULL,
    [C9] VARCHAR(50) NULL,
    [C10] VARCHAR(50) NULL,
    [C11] VARCHAR(50) NULL,
    [C12] VARCHAR(50) NULL,
    [C13] VARCHAR(50) NULL,
    [C14] VARCHAR(50) NULL,
    [C15] VARCHAR(50) NULL,
    [C16] VARCHAR(50) NULL,
    [C17] VARCHAR(50) NULL,
    [C18] VARCHAR(50) NULL,
    [C19] VARCHAR(50) NULL,
    [C20] VARCHAR(50) NULL,
    [C21] VARCHAR(50) NULL,
    [C22] VARCHAR(50) NULL,
    [C23] VARCHAR(50) NULL,
    [C24] VARCHAR(50) NULL,
    [C25] VARCHAR(50) NULL,
    [C26] VARCHAR(50) NULL,
    [C27] VARCHAR(50) NULL,
    [C28] VARCHAR(50) NULL,
    [C29] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_bsecm
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_bsecm]
(
    [scode] VARCHAR(10) NULL,
    [rate] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_BSEVAR
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_BSEVAR]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_bsx
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_bsx]
(
    [mkt_type] VARCHAR(30) NULL,
    [instrument] VARCHAR(30) NULL,
    [symbol] VARCHAR(30) NULL,
    [expirydate] VARCHAR(30) NULL,
    [strike_price] VARCHAR(30) NULL,
    [option_type] VARCHAR(30) NULL,
    [filler] VARCHAR(10) NULL,
    [previous] VARCHAR(30) NULL,
    [open_price] VARCHAR(30) NULL,
    [high_price] VARCHAR(30) NULL,
    [low_price] VARCHAR(30) NULL,
    [close_price] VARCHAR(30) NULL,
    [total_traded_quantity] VARCHAR(30) NULL,
    [total_traded_val] VARCHAR(30) NULL,
    [open_interest] VARCHAR(30) NULL,
    [change_in_open_interest] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_bsx_10092019
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_bsx_10092019]
(
    [mkt_type] VARCHAR(30) NULL,
    [instrument] VARCHAR(30) NULL,
    [symbol] VARCHAR(30) NULL,
    [expirydate] VARCHAR(30) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(30) NULL,
    [filler] VARCHAR(10) NULL,
    [previous] MONEY NULL,
    [open_price] MONEY NULL,
    [high_price] MONEY NULL,
    [low_price] MONEY NULL,
    [close_price] MONEY NULL,
    [total_traded_quantity] INT NULL,
    [total_traded_val] MONEY NULL,
    [open_interest] MONEY NULL,
    [change_in_open_interest] MONEY NULL,
    [filename] VARCHAR(50) NULL,
    [update_on] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcx
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcx]
(
    [TradDt] VARCHAR(100) NULL,
    [BizDt] VARCHAR(100) NULL,
    [Sgmt] VARCHAR(100) NULL,
    [Src] VARCHAR(100) NULL,
    [InstType] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(100) NULL,
    [Symbol] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(100) NULL,
    [Expirydate] VARCHAR(100) NULL,
    [FininstrmActlXpryDt] VARCHAR(20) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [OptionType] VARCHAR(50) NULL,
    [FinInstrmNm] VARCHAR(50) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Cl_rate] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Value_InLACS] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd] VARCHAR(50) NULL,
    [SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL,
    [Rmks] VARCHAR(1) NULL,
    [Rsvd1] VARCHAR(50) NULL,
    [Rsvd2] VARCHAR(50) NULL,
    [Rsvd3] VARCHAR(50) NULL,
    [Rsvd4] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcx_bkup_09072024
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcx_bkup_09072024]
(
    [TradeDate] VARCHAR(15) NULL,
    [aa] VARCHAR(10) NULL,
    [MarketType] VARCHAR(10) NULL,
    [InstNo] VARCHAR(10) NULL,
    [InstType] VARCHAR(10) NULL,
    [Symbol] VARCHAR(25) NULL,
    [ExpiryDate] VARCHAR(15) NULL,
    [cc] VARCHAR(10) NULL,
    [cc1] VARCHAR(50) NULL,
    [dd] VARCHAR(30) NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [ee] VARCHAR(25) NULL,
    [ff] VARCHAR(25) NULL,
    [gg] VARCHAR(25) NULL,
    [hh] VARCHAR(25) NULL,
    [ii] VARCHAR(25) NULL,
    [jj] VARCHAR(25) NULL,
    [kk] VARCHAR(25) NULL,
    [ll] VARCHAR(25) NULL,
    [mm] VARCHAR(10) NULL,
    [nn] VARCHAR(50) NULL,
    [oo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcx_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcx_comm]
(
    [TradeDate] VARCHAR(15) NULL,
    [aa] VARCHAR(10) NULL,
    [MarketType] VARCHAR(10) NULL,
    [InstNo] VARCHAR(10) NULL,
    [InstType] VARCHAR(10) NULL,
    [Symbol] VARCHAR(25) NULL,
    [ExpiryDate] VARCHAR(15) NULL,
    [cc] VARCHAR(10) NULL,
    [cc1] VARCHAR(50) NULL,
    [dd] VARCHAR(30) NULL,
    [PrevCls] MONEY NULL,
    [Opening] MONEY NULL,
    [High] MONEY NULL,
    [Low] MONEY NULL,
    [Cl_rate] MONEY NULL,
    [ee] VARCHAR(25) NULL,
    [ff] VARCHAR(25) NULL,
    [gg] VARCHAR(25) NULL,
    [hh] VARCHAR(25) NULL,
    [ii] VARCHAR(25) NULL,
    [jj] VARCHAR(25) NULL,
    [kk] VARCHAR(25) NULL,
    [ll] VARCHAR(25) NULL,
    [mm] VARCHAR(10) NULL,
    [nn] VARCHAR(50) NULL,
    [oo] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcxsx
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcxsx]
(
    [date] VARCHAR(20) NULL,
    [Instrument] VARCHAR(50) NULL,
    [Symbol] VARCHAR(20) NULL,
    [ExpiryDate] VARCHAR(20) NULL,
    [Strike_Price] VARCHAR(20) NULL,
    [Options_Type] VARCHAR(20) NULL,
    [MTM_sett_price] MONEY NULL,
    [CurrCode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_mcxsx_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_mcxsx_hist]
(
    [Date] DATETIME NULL,
    [Instrument] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Expirydate] DATETIME NULL,
    [MTM_Sett_price] MONEY NULL,
    [Updatedon] DATETIME NULL,
    [Filename] VARCHAR(50) NULL,
    [CurrCode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdex_back
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdex_back]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdex_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdex_comm]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdex_test
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdex_test]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdx
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdx]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_ncdx_BkupAug24
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_ncdx_BkupAug24]
(
    [data] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nce
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nce]
(
    [TradDt] VARCHAR(100) NULL,
    [BizDt] VARCHAR(100) NULL,
    [Sgmt] VARCHAR(100) NULL,
    [Src] VARCHAR(100) NULL,
    [InstType] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(100) NULL,
    [Symbol] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(100) NULL,
    [Expirydate] VARCHAR(100) NULL,
    [FininstrmActlXpryDt] VARCHAR(20) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [OptionType] VARCHAR(50) NULL,
    [FinInstrmNm] VARCHAR(50) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Cl_rate] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Value_InLACS] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd] VARCHAR(50) NULL,
    [SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL,
    [Rmks] VARCHAR(100) NULL,
    [Rsvd1] VARCHAR(50) NULL,
    [Rsvd2] VARCHAR(50) NULL,
    [Rsvd3] VARCHAR(50) NULL,
    [Rsvd4] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_NSECM
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_NSECM]
(
    [mkt_type] VARCHAR(10) NULL,
    [scrip] VARCHAR(20) NULL,
    [series] VARCHAR(20) NULL,
    [ycls] MONEY NULL,
    [opn] MONEY NULL,
    [hi] MONEY NULL,
    [lo] MONEY NULL,
    [cls] MONEY NULL,
    [a] VARCHAR(50) NULL,
    [b] VARCHAR(50) NULL,
    [c] VARCHAR(50) NULL,
    [d] VARCHAR(50) NULL,
    [e] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_NSECM_manual
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_NSECM_manual]
(
    [mkt_type] VARCHAR(10) NULL,
    [scrip] VARCHAR(20) NULL,
    [series] VARCHAR(20) NULL,
    [ycls] MONEY NULL,
    [opn] MONEY NULL,
    [hi] MONEY NULL,
    [lo] MONEY NULL,
    [cls] MONEY NULL,
    [a] VARCHAR(50) NULL,
    [b] VARCHAR(50) NULL,
    [c] VARCHAR(50) NULL,
    [d] VARCHAR(50) NULL,
    [e] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nseFO
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nseFO]
(
    [T_TYPE] VARCHAR(25) NULL,
    [INST_TYPE] VARCHAR(25) NULL,
    [SYMBOL] VARCHAR(25) NULL,
    [EXP_DATE] VARCHAR(25) NULL,
    [STRIKE_PRICE] VARCHAR(25) NULL,
    [OPT_TYPE] VARCHAR(25) NULL,
    [Y_CLS] VARCHAR(25) NULL,
    [OPEN] VARCHAR(25) NULL,
    [HI] VARCHAR(25) NULL,
    [LO] VARCHAR(25) NULL,
    [CLS] VARCHAR(25) NULL,
    [AA] VARCHAR(25) NULL,
    [BB] VARCHAR(25) NULL,
    [CC] VARCHAR(25) NULL,
    [DD] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nseFO_16
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nseFO_16]
(
    [T_TYPE] VARCHAR(10) NULL,
    [INST_TYPE] VARCHAR(10) NULL,
    [SYMBOL] VARCHAR(25) NULL,
    [EXP_DATE] DATETIME NULL,
    [STRIKE_PRICE] MONEY NULL,
    [OPT_TYPE] VARCHAR(10) NULL,
    [Y_CLS] MONEY NULL,
    [OPEN] MONEY NULL,
    [HI] MONEY NULL,
    [LO] MONEY NULL,
    [CLS] MONEY NULL,
    [AA] MONEY NULL,
    [BB] MONEY NULL,
    [CC] MONEY NULL,
    [DD] MONEY NULL,
    [FNAME] VARCHAR(25) NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nseFO_newformat
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nseFO_newformat]
(
    [T_TYPE] VARCHAR(25) NULL,
    [INST_TYPE] VARCHAR(25) NULL,
    [SYMBOL] VARCHAR(25) NULL,
    [EXP_DATE] VARCHAR(25) NULL,
    [STRIKE_PRICE] VARCHAR(25) NULL,
    [OPT_TYPE] VARCHAR(25) NULL,
    [Y_CLS] VARCHAR(25) NULL,
    [OPEN] VARCHAR(25) NULL,
    [HI] VARCHAR(25) NULL,
    [LO] VARCHAR(25) NULL,
    [CLS] VARCHAR(25) NULL,
    [AA] VARCHAR(25) NULL,
    [BB] VARCHAR(25) NULL,
    [CC] VARCHAR(25) NULL,
    [DD] VARCHAR(75) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cp_nseFOTestfile
-- --------------------------------------------------
CREATE TABLE [dbo].[cp_nseFOTestfile]
(
    [T_TYPE] VARCHAR(10) NULL,
    [INST_TYPE] VARCHAR(10) NULL,
    [SYMBOL] VARCHAR(25) NULL,
    [EXP_DATE] DATETIME NULL,
    [STRIKE_PRICE] MONEY NULL,
    [OPT_TYPE] VARCHAR(10) NULL,
    [Y_CLS] MONEY NULL,
    [OPEN] MONEY NULL,
    [HI] MONEY NULL,
    [LO] MONEY NULL,
    [CLS] MONEY NULL,
    [AA] MONEY NULL,
    [BB] MONEY NULL,
    [CC] MONEY NULL,
    [DD] MONEY NULL,
    [FNAME] VARCHAR(25) NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CP_NSX
-- --------------------------------------------------
CREATE TABLE [dbo].[CP_NSX]
(
    [mkt_type] VARCHAR(20) NULL,
    [Instrument] VARCHAR(30) NULL,
    [Symbol] VARCHAR(30) NULL,
    [Contract_Date] VARCHAR(50) NULL,
    [aa] VARCHAR(50) NULL,
    [bb] VARCHAR(50) NULL,
    [PREVIOUS] MONEY NULL,
    [OPEN_PRICE] MONEY NULL,
    [HIGH_PRICE] MONEY NULL,
    [LOW_PRICE] MONEY NULL,
    [CLOSE_PRICE] MONEY NULL,
    [TRADED_QUA] INT NULL,
    [TRADED_VAL] MONEY NULL,
    [cc] VARCHAR(50) NULL,
    [dd] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Excel_Dev
-- --------------------------------------------------
CREATE TABLE [dbo].[Excel_Dev]
(
    [Client_Id] VARCHAR(100) NULL,
    [Amount] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ff_other_values
-- --------------------------------------------------
CREATE TABLE [dbo].[ff_other_values]
(
    [type] VARCHAR(100) NULL,
    [value] NUMERIC(25, 2) NULL,
    [dateModified] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fileuploads
-- --------------------------------------------------
CREATE TABLE [dbo].[fileuploads]
(
    [data] VARCHAR(MAX) NULL,
    [upload_dt] DATETIME NULL,
    [fileName] VARCHAR(100) NULL,
    [segment] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fileuploads_BK01
-- --------------------------------------------------
CREATE TABLE [dbo].[fileuploads_BK01]
(
    [Transaction Recieved Date] VARCHAR(15) NULL,
    [Transaction Code] VARCHAR(20) NULL,
    [Transaction No.] VARCHAR(20) NULL,
    [Description] VARCHAR(500) NULL,
    [Debit Amount] DECIMAL(18, 2) NULL,
    [Credit Amount] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fileuploads_MG11
-- --------------------------------------------------
CREATE TABLE [dbo].[fileuploads_MG11]
(
    [data] VARCHAR(MAX) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_FILE
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_FILE]
(
    [data] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fovar_margin
-- --------------------------------------------------
CREATE TABLE [dbo].[fovar_margin]
(
    [rec_type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [series] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL,
    [SEC_var] VARCHAR(50) NULL,
    [IDX_VAR] VARCHAR(50) NULL,
    [VAR_Margin] VARCHAR(50) NULL,
    [EX_LOSS_RATE] VARCHAR(50) NULL,
    [ADHOC_MARGIN] VARCHAR(50) NULL,
    [APP_MARGIN_RATE] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Global_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[Global_upload]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.global_upload_01032021
-- --------------------------------------------------
CREATE TABLE [dbo].[global_upload_01032021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GLOBAL_UPLOAD_08022024
-- --------------------------------------------------
CREATE TABLE [dbo].[GLOBAL_UPLOAD_08022024]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.GLOBAL_UPLOAD_23032021
-- --------------------------------------------------
CREATE TABLE [dbo].[GLOBAL_UPLOAD_23032021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.global_upload_23mar2021
-- --------------------------------------------------
CREATE TABLE [dbo].[global_upload_23mar2021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.global_upload_27012024
-- --------------------------------------------------
CREATE TABLE [dbo].[global_upload_27012024]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.global_upload_27012024_1
-- --------------------------------------------------
CREATE TABLE [dbo].[global_upload_27012024_1]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.global_upload_30jan2024
-- --------------------------------------------------
CREATE TABLE [dbo].[global_upload_30jan2024]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.global_upload_30mar2021
-- --------------------------------------------------
CREATE TABLE [dbo].[global_upload_30mar2021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [UploadServer] VARCHAR(100) NULL,
    [UploadView] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCDX_Bhav_Copy
-- --------------------------------------------------
CREATE TABLE [dbo].[MCDX_Bhav_Copy]
(
    [Date] DATETIME NULL,
    [Instrument Name] NVARCHAR(255) NULL,
    [Commodity Symbol] NVARCHAR(255) NULL,
    [Contract/Expiry Month] DATETIME NULL,
    [Option Type] NVARCHAR(255) NULL,
    [Strike Price] FLOAT NULL,
    [Open(Rs#)] FLOAT NULL,
    [High(Rs#)] FLOAT NULL,
    [Low(Rs#)] FLOAT NULL,
    [Close(Rs#)] FLOAT NULL,
    [PCP(Rs#)] FLOAT NULL,
    [Volume(In Lots)] FLOAT NULL,
    [Volume(In 000's)] NVARCHAR(255) NULL,
    [Value(In Lakhs)] FLOAT NULL,
    [OI(In Lots)] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX_REVERSEFILE]
(
    [Trade_Number] INT NULL,
    [Trade_Status] INT NULL,
    [Instrument_ID] INT NULL,
    [Instrument_Name] VARCHAR(6) NULL,
    [Contract_Code] VARCHAR(10) NULL,
    [Expiry_Date] DATETIME NULL,
    [Strike_Price] VARCHAR(10) NULL,
    [Option_Type] VARCHAR(10) NULL,
    [Reserved1] VARCHAR(15) NULL,
    [Contract_Description] VARCHAR(25) NULL,
    [Book_Type] VARCHAR(50) NULL,
    [Book_Type_Name] VARCHAR(3) NULL,
    [Market_Type] VARCHAR(10) NULL,
    [User_Id] INT NULL,
    [Branch_No] VARCHAR(10) NULL,
    [Buy_Sell_Ind] INT NULL,
    [Trade_quantity] VARCHAR(9) NULL,
    [Price] MONEY NULL,
    [Pro_Client] VARCHAR(10) NULL,
    [Account] VARCHAR(10) NULL,
    [Participant] VARCHAR(12) NULL,
    [Settler] VARCHAR(12) NULL,
    [Spread_Price] MONEY NULL,
    [Reserved5] VARCHAR(7) NULL,
    [Trade_Time] VARCHAR(20) NULL,
    [Last_Modified_Time] VARCHAR(20) NULL,
    [Order_No] VARCHAR(20) NULL,
    [Reserved7] VARCHAR(5) NULL,
    [User_Remarks] VARCHAR(50) NULL,
    [DATE_1] DATETIME NULL,
    [Market_Type_1] VARCHAR(25) NULL,
    [Segment] VARCHAR(25) NULL,
    [Client_account_number_1] VARCHAR(25) NULL,
    [Normal] VARCHAR(20) NULL,
    [Client_account_number_2] VARCHAR(25) NULL,
    [default_2] VARCHAR(10) NULL,
    [default_3] VARCHAR(10) NULL,
    [default_4] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MF_RetirementSchemes_20240509
-- --------------------------------------------------
CREATE TABLE [dbo].[MF_RetirementSchemes_20240509]
(
    [SchemeCode] VARCHAR(512) NULL,
    [RTASchemeCode] VARCHAR(512) NULL,
    [AMCSchemeCode] VARCHAR(512) NULL,
    [ISIN] VARCHAR(512) NULL,
    [AMCCode] VARCHAR(512) NULL,
    [SchemeName] VARCHAR(512) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MTF_BSE_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[MTF_BSE_REVERSEFILE]
(
    [SCRIPCODE] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(10) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [OPP_MMBR_CODE] INT NULL,
    [OPP_MMBR_NAME] INT NULL,
    [TIME_1] DATETIME NULL,
    [DATE] DATETIME NULL,
    [CLIENTCODE] VARCHAR(20) NULL,
    [BUY_SELL] VARCHAR(1) NULL,
    [ORDER_TYPE] VARCHAR(15) NULL,
    [ORDERNO] VARCHAR(20) NULL,
    [INSTITUTION_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_GROUP] VARCHAR(5) NULL,
    [SETTLEMENT_NO_DATE] VARCHAR(20) NULL,
    [TIME_2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MTF_NSE_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[MTF_NSE_REVERSEFILE]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price] MONEY NULL,
    [PRO_CLI] INT NULL,
    [Client_Ac] VARCHAR(10) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] VARCHAR(30) NULL,
    [Auction_No] INT NULL,
    [Default] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_ApprovedScrip_UploadData
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_ApprovedScrip_UploadData]
(
    [Sr.No] INT NULL,
    [Company_Name] VARCHAR(100) NULL,
    [BSE_Scrip_Code] VARCHAR(25) NULL,
    [NSE_Symbol] VARCHAR(25) NULL,
    [Scrip_Category] VARCHAR(20) NULL,
    [ISIN] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NBFC_SqrOff_Exception
-- --------------------------------------------------
CREATE TABLE [dbo].[NBFC_SqrOff_Exception]
(
    [Party_Code] VARCHAR(20) NULL,
    [Remarks] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_Bhav_Copy
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_Bhav_Copy]
(
    [TradDt] VARCHAR(11) NULL,
    [BizDt] VARCHAR(11) NULL,
    [Sgmt] VARCHAR(10) NULL,
    [Src] VARCHAR(11) NULL,
    [FinInstrmTp] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(10) NULL,
    [Underlying_Commodity] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(10) NULL,
    [ExpiryDate] VARCHAR(11) NULL,
    [FininstrmActlXpryDt] VARCHAR(11) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_Type] VARCHAR(10) NULL,
    [FinInstrmNm] VARCHAR(250) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Closing_Price] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Traded_ValueinLacs] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd_SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL,
    [tdate] VARCHAR(11) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_Bhav_Copy_bkup_08072024
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_Bhav_Copy_bkup_08072024]
(
    [Instrument_Type] VARCHAR(250) NULL,
    [Symbol] VARCHAR(250) NULL,
    [Expiry_Date] VARCHAR(250) NULL,
    [Commodity] VARCHAR(250) NULL,
    [Strike_Price] VARCHAR(250) NULL,
    [Option_Type] VARCHAR(250) NULL,
    [Delivery_Center] VARCHAR(250) NULL,
    [Price_Unit] VARCHAR(50) NULL,
    [Opening_price] VARCHAR(50) NULL,
    [High_Price] VARCHAR(50) NULL,
    [Low_Price] VARCHAR(50) NULL,
    [Closing_Price] VARCHAR(50) NULL,
    [Qty_Traded_Today] VARCHAR(50) NULL,
    [Measure] VARCHAR(50) NULL,
    [No_Of_Trades] VARCHAR(50) NULL,
    [Trade_Amt] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(200) NULL,
    [tdate] VARCHAR(11) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_Bhav_Copy_New
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_Bhav_Copy_New]
(
    [TradDt] VARCHAR(11) NULL,
    [BizDt] VARCHAR(11) NULL,
    [Sgmt] VARCHAR(10) NULL,
    [Src] VARCHAR(11) NULL,
    [FinInstrmTp] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(10) NULL,
    [Underlying_Commodity] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(10) NULL,
    [ExpiryDate] VARCHAR(11) NULL,
    [FininstrmActlXpryDt] VARCHAR(11) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_Type] VARCHAR(10) NULL,
    [FinInstrmNm] VARCHAR(250) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Closing_Price] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Traded_ValueinLacs] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd_SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL,
    [Rmks] VARCHAR(50) NULL,
    [Rsvd1] VARCHAR(50) NULL,
    [Rsvd2] VARCHAR(50) NULL,
    [Rsvd3] VARCHAR(50) NULL,
    [Rsvd4] VARCHAR(50) NULL,
    [tdate] VARCHAR(11) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncdex_ps03
-- --------------------------------------------------
CREATE TABLE [dbo].[ncdex_ps03]
(
    [Position_Date] VARCHAR(255) NULL,
    [Segment_Indicator] VARCHAR(255) NULL,
    [Settlement_Type] VARCHAR(255) NULL,
    [CM_Code] VARCHAR(255) NULL,
    [Member_Type] VARCHAR(255) NULL,
    [Trading Member_Code] VARCHAR(255) NULL,
    [Account_Type] VARCHAR(255) NULL,
    [Client_Code] VARCHAR(255) NULL,
    [Instrument_Type] VARCHAR(255) NULL,
    [Symbol] VARCHAR(255) NULL,
    [Expiry_date] VARCHAR(255) NULL,
    [Strike_Price] VARCHAR(255) NULL,
    [Option_Type] VARCHAR(255) NULL,
    [CA_Level] VARCHAR(255) NULL,
    [BF_long_quantity] INT NULL,
    [BF_Long_Value] MONEY NULL,
    [BF_Short_quantity] INT NULL,
    [BF_Short_Value] MONEY NULL,
    [DayBuyOpenQuantity] INT NULL,
    [DayBuyOpenValue] MONEY NULL,
    [DaySellOpenQuantity] INT NULL,
    [DaySellOpenValue] MONEY NULL,
    [PreExerciseAssignmentLongQuantity] VARCHAR(255) NULL,
    [PreExerciseAssignmentLongValue] VARCHAR(255) NULL,
    [PreExerciseAssignmentShortQuantity] VARCHAR(255) NULL,
    [PreExerciseAssignmentShortValue] VARCHAR(255) NULL,
    [ExercisedQuantity] VARCHAR(255) NULL,
    [AssignedQuantity] VARCHAR(255) NULL,
    [PostExerciseAssignmentLongQuantity] VARCHAR(255) NULL,
    [PostExerciseAssignmentLongValue] VARCHAR(255) NULL,
    [PostExercise AssignmentShortQuantity] VARCHAR(255) NULL,
    [PostExerciseAssignmentShortValue] VARCHAR(255) NULL,
    [SettlementPrice] VARCHAR(255) NULL,
    [NetPremium] VARCHAR(255) NULL,
    [Daily_MTM_Settlement_Value] VARCHAR(255) NULL,
    [Futures_final_Sett_value] VARCHAR(255) NULL,
    [Exercised_Assigned_Value_Calculated] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDEX_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDEX_REVERSEFILE]
(
    [Trade_Number] VARCHAR(20) NULL,
    [Trade_Status] VARCHAR(20) NULL,
    [Instrument_Name] VARCHAR(20) NULL,
    [Symbol] VARCHAR(20) NULL,
    [Expiry_date] DATETIME NOT NULL,
    [Strike_Price] VARCHAR(20) NULL,
    [Option_Type] VARCHAR(20) NULL,
    [Contract_Description] VARCHAR(40) NULL,
    [Book_Type] VARCHAR(20) NULL,
    [Book_Type_Name] VARCHAR(20) NULL,
    [Market_Type] VARCHAR(20) NULL,
    [User_Id] VARCHAR(20) NULL,
    [Branch_No] VARCHAR(20) NULL,
    [Buy_Sell_Ind] VARCHAR(20) NULL,
    [Trade_quantity] VARCHAR(20) NULL,
    [Price] VARCHAR(20) NULL,
    [Pro_Client] VARCHAR(20) NULL,
    [Account] VARCHAR(20) NULL,
    [Participant_Settler] VARCHAR(20) NULL,
    [Open_Close_Flag] VARCHAR(20) NULL,
    [Cover_Uncover_Flag] VARCHAR(20) NULL,
    [Trade_time] DATETIME NOT NULL,
    [Last_Modified_Time] DATETIME NOT NULL,
    [Order_Number] VARCHAR(20) NULL,
    [Reserved] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_REVERSEFILE]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price_PRO_CLI] MONEY NULL,
    [Client_Ac] INT NULL,
    [Member_Id] VARCHAR(30) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] VARCHAR(30) NULL,
    [Auction_No] INT NULL,
    [Default] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_REVERSEFILE_NBFC
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_REVERSEFILE_NBFC]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price_PRO_CLI] MONEY NULL,
    [Client_Ac] INT NULL,
    [Member_Id] VARCHAR(30) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] VARCHAR(30) NULL,
    [Auction_No] INT NULL,
    [Default] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_REVERSEFILE_NBFC_MARGIN_SHORTAGE]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price_PRO_CLI] MONEY NULL,
    [Client_Ac] INT NULL,
    [Member_Id] VARCHAR(30) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] VARCHAR(30) NULL,
    [Auction_No] INT NULL,
    [Default] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSE_REVERSEFILE_T6T7
-- --------------------------------------------------
CREATE TABLE [dbo].[NSE_REVERSEFILE_T6T7]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price_PRO_CLI] MONEY NULL,
    [Client_Ac] INT NULL,
    [Member_Id] VARCHAR(30) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] VARCHAR(30) NULL,
    [Auction_No] INT NULL,
    [Default] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSEFO_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[NSEFO_REVERSEFILE]
(
    [Trade_Number] VARCHAR(50) NULL,
    [Trade_Status] VARCHAR(50) NULL,
    [Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_date] VARCHAR(50) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_type] VARCHAR(50) NULL,
    [Security_name] VARCHAR(50) NULL,
    [Book_Type] VARCHAR(50) NULL,
    [Book_Type_Name] VARCHAR(50) NULL,
    [Market_Type] VARCHAR(50) NULL,
    [User_Id] VARCHAR(50) NULL,
    [Branch_No] VARCHAR(50) NULL,
    [Buy_Sell_Ind] VARCHAR(50) NULL,
    [Traded_Quantity] VARCHAR(50) NULL,
    [Price] VARCHAR(50) NULL,
    [Pro_Client] VARCHAR(50) NULL,
    [Account] VARCHAR(50) NULL,
    [Participant] VARCHAR(50) NULL,
    [Open_Close_Flag] VARCHAR(10) NULL,
    [Cover_Uncover_Flag] VARCHAR(10) NULL,
    [Activity_Time] VARCHAR(50) NULL,
    [Last_Modified_Time] VARCHAR(50) NULL,
    [Order_No] VARCHAR(50) NULL,
    [Opposite_Broker_Id] VARCHAR(50) NULL,
    [Order_Entered_Mod_Date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.restricted_scrip_uploadTemp
-- --------------------------------------------------
CREATE TABLE [dbo].[restricted_scrip_uploadTemp]
(
    [OpCode] INT NULL,
    [User] VARCHAR(50) NULL,
    [Group_Id] VARCHAR(50) NULL,
    [Deposit] NVARCHAR(50) NULL,
    [Scrip_Code] NUMERIC(18, 0) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Series] VARCHAR(50) NULL,
    [Group] VARCHAR(50) NULL,
    [Periodicity] INT NULL,
    [Instrument_Name] VARCHAR(50) NULL,
    [Expiry] VARCHAR(50) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_Type] VARCHAR(50) NULL,
    [Gross_Exposure_Multiplier] NUMERIC(18, 0) NULL,
    [Gross_Exposure_Limit] NUMERIC(18, 0) NULL,
    [Net_Exposure_Multiplier] NUMERIC(18, 0) NULL,
    [Net_Exposure] NUMERIC(18, 0) NULL,
    [Net_Sale_Multiplier] NUMERIC(18, 0) NULL,
    [Net_Sale_Limit] NUMERIC(18, 0) NULL,
    [Net_Position_Multiplier] NUMERIC(18, 0) NULL,
    [Net_Position_Limit] NVARCHAR(50) NULL,
    [TurnOver_Multiplier] NUMERIC(18, 0) NULL,
    [TurnOver_Limit] NUMERIC(18, 0) NULL,
    [Pending_Order_Multiplier] NUMERIC(18, 0) NULL,
    [Pending_Order_Limit] NUMERIC(18, 0) NULL,
    [MTM_Multiplier] NUMERIC(18, 0) NULL,
    [MTM_Limit] NUMERIC(18, 0) NULL,
    [Ini_Margin_Multiplier] NUMERIC(18, 0) NULL,
    [Ini_Margin_Limit] NUMERIC(18, 0) NULL,
    [NQ_Limit] NVARCHAR(50) NULL,
    [Max_Single_Trans_Limit] NVARCHAR(50) NULL,
    [Max_Single_Trans_Quantity] NVARCHAR(50) NULL,
    [Min_Order_Value] NUMERIC(18, 0) NULL,
    [Min_Order_Quantity] NUMERIC(18, 0) NULL,
    [Retain_Multiplier] NUMERIC(18, 0) NOT NULL,
    [Include_MTMP] NUMERIC(18, 0) NULL,
    [Include_Net_Premium] NUMERIC(18, 0) NULL,
    [GrossAndNet] NUMERIC(18, 0) NULL,
    [Include_Exp_Margin] NUMERIC(18, 0) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ScripIMargin_MCX
-- --------------------------------------------------
CREATE TABLE [dbo].[ScripIMargin_MCX]
(
    [Symbol] VARCHAR(50) NULL,
    [Expiry_Date] DATETIME NULL,
    [Price] MONEY NULL,
    [Multiplier] MONEY NULL,
    [IM] MONEY NULL,
    [SBM] MONEY NULL,
    [SSM] MONEY NULL,
    [AML] MONEY NULL,
    [AMS] MONEY NULL,
    [Tender_M] MONEY NULL,
    [TM] MONEY NULL,
    [ICV] MONEY NULL,
    [Margin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ScripIMargin_NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[ScripIMargin_NCDX]
(
    [Symbol] VARCHAR(50) NULL,
    [Expiry_Date] DATETIME NULL,
    [Price] MONEY NULL,
    [Multiplier] MONEY NULL,
    [IM] MONEY NULL,
    [EM] MONEY NULL,
    [APEM] MONEY NULL,
    [TM] MONEY NULL,
    [AML] MONEY NULL,
    [AMS] MONEY NULL,
    [SCML] MONEY NULL,
    [SCMS] MONEY NULL,
    [ICV] MONEY NULL,
    [Margin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ScripIMargin_NSEFO
-- --------------------------------------------------
CREATE TABLE [dbo].[ScripIMargin_NSEFO]
(
    [Scrip] VARCHAR(50) NULL,
    [MarketLot] MONEY NULL,
    [Margin_Perc] MONEY NULL,
    [Closing_Price] MONEY NULL,
    [Initial_Margin] MONEY NULL,
    [Add_Margin_Perc] MONEY NULL,
    [Additional_Margin] MONEY NULL,
    [Total_Margin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SQuareUp_Exception_T6T7
-- --------------------------------------------------
CREATE TABLE [dbo].[SQuareUp_Exception_T6T7]
(
    [Client] VARCHAR(10) NULL,
    [Remarks] VARCHAR(100) NULL,
    [ValidFrom] VARCHAR(10) NULL,
    [ValidTo] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_All_Squareoff_Exception_File
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_All_Squareoff_Exception_File]
(
    [Party_code] VARCHAR(20) NULL,
    [Update_date] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_All_SquareOff_Exception_FileUpload
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_All_SquareOff_Exception_FileUpload]
(
    [Party_Code] VARCHAR(20) NULL,
    [Exception_Remarks] VARCHAR(150) NULL,
    [Update_Date] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutoFileprocess
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutoFileprocess]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutoFileprocessHist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutoFileprocessHist]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL,
    [HistDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationFileUpload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationFileUpload]
(
    [Upd_Srno] BIGINT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationFileUpload_Bkp23Ap2019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationFileUpload_Bkp23Ap2019]
(
    [Upd_Srno] BIGINT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationFileUpload_bkup1802205
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationFileUpload_bkup1802205]
(
    [Upd_Srno] BIGINT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_09092019bkup
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_09092019bkup]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup_05052021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup_05052021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup_10052021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup_10052021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_BKUP_15072019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_BKUP_15072019]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup_26082019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup_26082019]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup_30042021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup_30042021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup_exposure
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup_exposure]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup_exposurefiles
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup_exposurefiles]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_bkup29112019
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_bkup29112019]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_comm]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_AutomationUpladFile_exposure
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_AutomationUpladFile_exposure]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [FileN] VARCHAR(2000) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [CreatedOn] DATETIME NOT NULL,
    [CreatedBy] VARCHAR(10) NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_bse_copy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_bse_copy]
(
    [Isin] VARCHAR(20) NULL,
    [bsecode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_bseseries
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_bseseries]
(
    [Isin] VARCHAR(20) NULL,
    [bsecode] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSEVAR_New
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSEVAR_New]
(
    [Security_Code] VARCHAR(20) NULL,
    [Security_Name] VARCHAR(200) NULL,
    [Group_Name] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [VAR_Group] VARCHAR(10) NULL,
    [Security_VaR] VARCHAR(20) NULL,
    [FILLER1] VARCHAR(20) NULL,
    [VaR_Margin] VARCHAR(20) NULL,
    [Extreme_Loss_Margin] VARCHAR(20) NULL,
    [Additional_Margin] VARCHAR(20) NULL,
    [Applicable_Margin] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_buyback_data_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_buyback_data_temp]
(
    [Party_code] VARCHAR(50) NULL,
    [Value] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ClientPureRisk_Combined
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ClientPureRisk_Combined]
(
    [Ro Code] VARCHAR(50) NULL,
    [Branch Code] VARCHAR(50) NULL,
    [Family Code] VARCHAR(50) NULL,
    [Sub Group Code] VARCHAR(50) NULL,
    [Client Code] VARCHAR(50) NULL,
    [Client Name] VARCHAR(50) NULL,
    [Ledger Balance] VARCHAR(50) NULL,
    [Holding] VARCHAR(50) NULL,
    [Blue Chip] VARCHAR(50) NULL,
    [Good] VARCHAR(50) NULL,
    [Average] VARCHAR(50) NULL,
    [Poor] VARCHAR(50) NULL,
    [Other] VARCHAR(50) NULL,
    [POA] VARCHAR(50) NULL,
    [Free POA] VARCHAR(50) NULL,
    [Today MTM] VARCHAR(50) NULL,
    [Logical MTM] VARCHAR(50) NULL,
    [Fut  MTM] VARCHAR(50) NULL,
    [Opt  MTM] VARCHAR(50) NULL,
    [MTM] VARCHAR(50) NULL,
    [Pure risk   net available] VARCHAR(50) NULL,
    [Projected Risk] VARCHAR(50) NULL,
    [Gross Exposure] VARCHAR(50) NULL,
    [Net Exposure] VARCHAR(50) NULL,
    [FO Margin] VARCHAR(50) NULL,
    [Comm Margin] VARCHAR(50) NULL,
    [Curr margin] VARCHAR(50) NULL,
    [Total Margin] VARCHAR(50) NULL,
    [Prev  Margin] VARCHAR(50) NULL,
    [Diff  Margin] VARCHAR(50) NULL,
    [Today Premium] VARCHAR(50) NULL,
    [Cash Payin   Payout] VARCHAR(50) NULL,
    [Shortsell] VARCHAR(50) NULL,
    [FO Shortfall] VARCHAR(50) NULL,
    [Blue Chip Today Stocks] VARCHAR(50) NULL,
    [Good Today Stocks] VARCHAR(50) NULL,
    [Average Today Stocks] VARCHAR(50) NULL,
    [Poor Today Stocks] VARCHAR(50) NULL,
    [Other Today Stocks] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Commodity_Expiry_SMS
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Commodity_Expiry_SMS]
(
    [party_code] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_commodity_margin
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_commodity_margin]
(
    [Symbol] VARCHAR(500) NULL,
    [Expiry_Date] VARCHAR(20) NULL,
    [TotalMargin_PerLot] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_commodity_shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_commodity_shortage]
(
    [client_code] VARCHAR(20) NULL,
    [Shortage_Amt] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_csv_mailerData
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_csv_mailerData]
(
    [data] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_CSV_Upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_CSV_Upload]
(
    [Party_code] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_curr_settPrice
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_curr_settPrice]
(
    [DATE] DATETIME NULL,
    [INSTRUMENT] NVARCHAR(255) NULL,
    [UNDERLYING] NVARCHAR(255) NULL,
    [EXPIRY DATE] DATETIME NULL,
    [CROSS CURRENCY PRICE] FLOAT NULL,
    [RBI REFERENCE RATE] FLOAT NULL,
    [MTM SETTLEMENT PRICE ] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_cusa_exception_file
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_cusa_exception_file]
(
    [party_code] VARCHAR(30) NULL,
    [Update_date] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_data
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_data]
(
    [data] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_equity_turnover
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_equity_turnover]
(
    [CO_NAME] VARCHAR(200) NULL,
    [ISIN No] VARCHAR(50) NULL,
    [BSE Code] VARCHAR(100) NULL,
    [Total] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ExchangeFileName
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ExchangeFileName]
(
    [UpLoadSrno] INT NULL,
    [SegmentDesc] VARCHAR(200) NULL,
    [SegFile] VARCHAR(100) NULL,
    [FileExtenstion] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FCTM_Expiry
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FCTM_Expiry]
(
    [Date] VARCHAR(11) NULL,
    [F] VARCHAR(1) NULL,
    [BRK] VARCHAR(10) NULL,
    [Sett] FLOAT NULL,
    [C] VARCHAR(1) NULL,
    [Code] VARCHAR(10) NULL,
    [Instrument] VARCHAR(20) NULL,
    [Scrip] VARCHAR(50) NULL,
    [Expiry date] VARCHAR(11) NULL,
    [Strike Price] FLOAT NULL,
    [Option Type] VARCHAR(10) NULL,
    [NIL] INT NULL,
    [QTY] INT NULL,
    [LTP] FLOAT NULL,
    [Status] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Fileprocess
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Fileprocess]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Fileprocess_bkup_30042021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Fileprocess_bkup_30042021]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Fileprocess_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Fileprocess_comm]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Fileprocess_exposure
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Fileprocess_exposure]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FileprocessHist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FileprocessHist]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL,
    [HistDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Fileprocesshist_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Fileprocesshist_comm]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL,
    [HistDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_FileprocessHist_exposure
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_FileprocessHist_exposure]
(
    [ProcessDate] DATETIME NULL,
    [FileId] INT NULL,
    [ProcessStartAt] DATETIME NULL,
    [FileName] VARCHAR(200) NULL,
    [FileRowCount] INT NULL,
    [ProcessEndAt] DATETIME NULL,
    [ProcessStatus] INT NULL,
    [HistDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_fileupload_test
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_fileupload_test]
(
    [Field] INT NULL,
    [processname] VARCHAR(200) NULL,
    [upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_fut_opt_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_fut_opt_upload]
(
    [Contract_Date] DATETIME NULL,
    [Contract_Instrument_Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry_Date] DATETIME NULL,
    [Strike_Price] MONEY NULL,
    [Option_Type] VARCHAR(20) NULL,
    [Corporate_Action_level] VARCHAR(10) NULL,
    [Contract_Regular_Lot] INT NULL,
    [Contract_Issue_Start_Date] DATETIME NULL,
    [Contract_Issue_Maturity_Date] DATETIME NULL,
    [Contract_Exercise_Start_Date] DATETIME NULL,
    [Contract_Exercise_End_Date] DATETIME NULL,
    [Contract_Exercise_Style] VARCHAR(20) NULL,
    [Contract_Active_Market_Type] VARCHAR(20) NULL,
    [Contract_Open_Price] MONEY NULL,
    [Contract_High_Price] MONEY NULL,
    [Contract_Low_Price] MONEY NULL,
    [Contract_Close_Price] MONEY NULL,
    [Contract_Settlement_Price] MONEY NULL,
    [Contract_Underlying_Price] MONEY NULL,
    [Contract_Underlying_Instrument_Type] VARCHAR(20) NULL,
    [Contract_Underlying_Symbol] VARCHAR(100) NULL,
    [Contract_Underlying_Series] VARCHAR(50) NULL,
    [Contract_Underlying_Expiry_Date] DATETIME NULL,
    [Contract_Underlying_Strike_Price] MONEY NULL,
    [Contract_Underlying_Option_Type] VARCHAR(50) NULL,
    [Contract_Underlying_Corporate_Action_Level] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_ITM_File
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_ITM_File]
(
    [Client Code] VARCHAR(20) NULL,
    [Scrip Code] VARCHAR(100) NULL,
    [Strike Price] FLOAT NULL,
    [O T] VARCHAR(5) NULL,
    [Net Qty] MONEY NULL,
    [LTP] MONEY NULL,
    [Applicable Delivery Margins] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LDmarginFile_Upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LDmarginFile_Upload]
(
    [Ro_Code] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(50) NULL,
    [Family_Code] VARCHAR(50) NULL,
    [Sub_Group_Code] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Client_Name] VARCHAR(50) NULL,
    [Ledger_Balance] MONEY NULL,
    [Collateral] MONEY NULL,
    [Total_Peak_Margin] MONEY NULL,
    [TotalSpan_Exp_Equity_Margin] MONEY NULL,
    [Total_Shortfall] MONEY NULL,
    [Var_Margin_cash] MONEY NULL,
    [MTM_cash] MONEY NULL,
    [Span_Exp_Margin_FO] MONEY NULL,
    [Premium_Value_FO] MONEY NULL,
    [MTM_Loss_FO] MONEY NULL,
    [Span_Exp_Margin_MCX] MONEY NULL,
    [Premium_Value_MCX] MONEY NULL,
    [MTM_Loss_MCX] MONEY NULL,
    [Span_Exp_Margin_Cur] MONEY NULL,
    [Premium_Value_Cur] MONEY NULL,
    [MTM_Loss_Cur] MONEY NULL,
    [Span_Exp_Margin_NCDEX] MONEY NULL,
    [Premium_Value_NCDEX] MONEY NULL,
    [MTM_Loss_NCDEX] MONEY NULL,
    [Span_Exp_Margin_MCXCUR] MONEY NULL,
    [Premium_Value_MCXCUR] MONEY NULL,
    [MTM_Loss_MCXCUR] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LDmarginFile_Upload_26102021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LDmarginFile_Upload_26102021]
(
    [Ro_Code] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(50) NULL,
    [Family_Code] VARCHAR(50) NULL,
    [Sub_Group_Code] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Client_Name] VARCHAR(50) NULL,
    [Ledger_Balance] MONEY NULL,
    [Collateral] MONEY NULL,
    [Total_Peak_Margin] MONEY NULL,
    [Total_Margin] MONEY NULL,
    [Total_Shortfall] MONEY NULL,
    [Var_Margin_cash] MONEY NULL,
    [MTM_cash] MONEY NULL,
    [Span_Exp_Margin_FO] MONEY NULL,
    [Premium_Value_FO] MONEY NULL,
    [MTM_Loss_FO] MONEY NULL,
    [Span_Exp_Margin_MCX] MONEY NULL,
    [Premium_Value_MCX] MONEY NULL,
    [MTM_Loss_MCX] MONEY NULL,
    [Span_Exp_Margin_Cur] MONEY NULL,
    [Premium_Value_Cur] MONEY NULL,
    [MTM_Loss_Cur] MONEY NULL,
    [Span_Exp_Margin_NCDEX] MONEY NULL,
    [Premium_Value_NCDEX] MONEY NULL,
    [MTM_Loss_NCDEX] MONEY NULL,
    [Span_Exp_Margin_MCXCUR] MONEY NULL,
    [Premium_Value_MCXCUR] MONEY NULL,
    [MTM_Loss_MCXCUR] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LDmarginFile_Upload_27102021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LDmarginFile_Upload_27102021]
(
    [Ro_Code] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(50) NULL,
    [Family_Code] VARCHAR(50) NULL,
    [Sub_Group_Code] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Client_Name] VARCHAR(50) NULL,
    [Ledger_Balance] MONEY NULL,
    [Collateral] MONEY NULL,
    [Total_Peak_Margin] MONEY NULL,
    [TotalSpan_Exp_Equity_Margin] MONEY NULL,
    [Total_Shortfall] MONEY NULL,
    [Var_Margin_cash] MONEY NULL,
    [MTM_cash] MONEY NULL,
    [Span_Exp_Margin_FO] MONEY NULL,
    [Premium_Value_FO] MONEY NULL,
    [MTM_Loss_FO] MONEY NULL,
    [Span_Exp_Margin_MCX] MONEY NULL,
    [Premium_Value_MCX] MONEY NULL,
    [MTM_Loss_MCX] MONEY NULL,
    [Span_Exp_Margin_Cur] MONEY NULL,
    [Premium_Value_Cur] MONEY NULL,
    [MTM_Loss_Cur] MONEY NULL,
    [Span_Exp_Margin_NCDEX] MONEY NULL,
    [Premium_Value_NCDEX] MONEY NULL,
    [MTM_Loss_NCDEX] MONEY NULL,
    [Span_Exp_Margin_MCXCUR] MONEY NULL,
    [Premium_Value_MCXCUR] MONEY NULL,
    [MTM_Loss_MCXCUR] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LDmarginFile_Uploadbkuplive_27oct2021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LDmarginFile_Uploadbkuplive_27oct2021]
(
    [Ro_Code] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(50) NULL,
    [Family_Code] VARCHAR(50) NULL,
    [Sub_Group_Code] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Client_Name] VARCHAR(50) NULL,
    [Ledger_Balance] MONEY NULL,
    [Collateral] MONEY NULL,
    [Total_Shortfall] MONEY NULL,
    [Var_Margin_cash] MONEY NULL,
    [MTM_cash] MONEY NULL,
    [Span_Exp_Margin_FO] MONEY NULL,
    [Premium_Value_FO] MONEY NULL,
    [MTM_Loss_FO] MONEY NULL,
    [Span_Exp_Margin_MCX] MONEY NULL,
    [Premium_Value_MCX] MONEY NULL,
    [MTM_Loss_MCX] MONEY NULL,
    [Span_Exp_Margin_Cur] MONEY NULL,
    [Premium_Value_Cur] MONEY NULL,
    [MTM_Loss_Cur] MONEY NULL,
    [Span_Exp_Margin_NCDEX] MONEY NULL,
    [Premium_Value_NCDEX] MONEY NULL,
    [MTM_Loss_NCDEX] MONEY NULL,
    [Span_Exp_Margin_MCXCUR] MONEY NULL,
    [Premium_Value_MCXCUR] MONEY NULL,
    [MTM_Loss_MCXCUR] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_LDmarginFiles
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_LDmarginFiles]
(
    [Ro_Code] VARCHAR(50) NULL,
    [Branch_Code] VARCHAR(50) NULL,
    [Family_Code] VARCHAR(50) NULL,
    [Sub_Group_Code] VARCHAR(50) NULL,
    [Client_Code] VARCHAR(50) NULL,
    [Client_Name] VARCHAR(50) NULL,
    [Ledger_Balance] VARCHAR(1000) NULL,
    [Collateral] VARCHAR(1000) NULL,
    [Total_Peak_Margin] VARCHAR(1000) NULL,
    [TotalSpan_Exp_Equity_Margin] VARCHAR(1000) NULL,
    [Total_Shortfall] VARCHAR(1000) NULL,
    [Var_Margin_cash] VARCHAR(1000) NULL,
    [MTM_cash] VARCHAR(1000) NULL,
    [Span_Exp_Margin_FO] VARCHAR(1000) NULL,
    [Premium_Value_FO] VARCHAR(1000) NULL,
    [MTM_Loss_FO] VARCHAR(1000) NULL,
    [Span_Exp_Margin_MCX] VARCHAR(1000) NULL,
    [Premium_Value_MCX] VARCHAR(1000) NULL,
    [MTM_Loss_MCX] VARCHAR(1000) NULL,
    [Span_Exp_Margin_Cur] VARCHAR(1000) NULL,
    [Premium_Value_Cur] VARCHAR(1000) NULL,
    [MTM_Loss_Cur] VARCHAR(1000) NULL,
    [Span_Exp_Margin_NCDEX] VARCHAR(1000) NULL,
    [Premium_Value_NCDEX] VARCHAR(1000) NULL,
    [MTM_Loss_NCDEX] VARCHAR(1000) NULL,
    [Span_Exp_Margin_MCXCUR] VARCHAR(1000) NULL,
    [Premium_Value_MCXCUR] VARCHAR(1000) NULL,
    [MTM_Loss_MCXCUR] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MCX_BhavCopy_bkup_14052021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MCX_BhavCopy_bkup_14052021]
(
    [Date] VARCHAR(20) NULL,
    [Instrument Name] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry Date] VARCHAR(50) NULL,
    [Option Type] VARCHAR(50) NULL,
    [Strike Price] VARCHAR(50) NULL,
    [Open] VARCHAR(50) NULL,
    [High] VARCHAR(50) NULL,
    [Low] VARCHAR(50) NULL,
    [Close] VARCHAR(50) NULL,
    [Previous Close] VARCHAR(50) NULL,
    [Volume(Lots)] VARCHAR(50) NULL,
    [Volume] VARCHAR(50) NULL,
    [Value(Lacs)] VARCHAR(50) NULL,
    [Open Interest(Lots)] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MCX_NCDEX_BhavCopy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MCX_NCDEX_BhavCopy]
(
    [Symbol] VARCHAR(100) NULL,
    [Expiry Date] VARCHAR(20) NULL,
    [option_type] VARCHAR(10) NULL,
    [stike_price] VARCHAR(20) NULL,
    [Close] VARCHAR(20) NULL,
    [Open Interest(Lots)] VARCHAR(20) NULL,
    [Seg] VARCHAR(20) NULL,
    [Value(Lacs)] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NCDEX_BhavCopy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NCDEX_BhavCopy]
(
    [Symbol] VARCHAR(100) NULL,
    [Expiry Date] VARCHAR(20) NULL,
    [Commodity] VARCHAR(100) NULL,
    [Ex-Basis Delivery Centre] VARCHAR(100) NULL,
    [Price Unit] VARCHAR(50) NULL,
    [Previous Closing Price] VARCHAR(20) NULL,
    [Opening Price] VARCHAR(20) NULL,
    [High Price] VARCHAR(20) NULL,
    [Low Price] VARCHAR(20) NULL,
    [Closing Price] VARCHAR(20) NULL,
    [Quantity Traded Today] VARCHAR(20) NULL,
    [Measure No of Trades] VARCHAR(20) NULL,
    [Traded Value in Lacs] VARCHAR(20) NULL,
    [Open Interest] VARCHAR(20) NULL,
    [LastTradedDate] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NonTradedClientPureRisk
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NonTradedClientPureRisk]
(
    [Ro Code] VARCHAR(50) NULL,
    [Branch Code] VARCHAR(50) NULL,
    [Family Code] VARCHAR(50) NULL,
    [Sub Group Code] VARCHAR(50) NULL,
    [Client Code] VARCHAR(50) NULL,
    [Client Name] VARCHAR(50) NULL,
    [Ledger Balance] VARCHAR(50) NULL,
    [Holding] VARCHAR(50) NULL,
    [POA] VARCHAR(50) NULL,
    [Free POA] VARCHAR(50) NULL,
    [MTM] VARCHAR(50) NULL,
    [Pure risk   net available] VARCHAR(50) NULL,
    [Projected Risk] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEBhavCopy_Series
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEBhavCopy_Series]
(
    [SYMBOL] VARCHAR(100) NULL,
    [SERIES] VARCHAR(100) NULL,
    [OPEN] VARCHAR(20) NULL,
    [HIGH] VARCHAR(20) NULL,
    [LOW] VARCHAR(20) NULL,
    [CLOSE] VARCHAR(20) NULL,
    [LAST] VARCHAR(20) NULL,
    [PREVCLOSE] VARCHAR(20) NULL,
    [TOTTRDQTY] VARCHAR(50) NULL,
    [TOTTRDVAL] VARCHAR(50) NULL,
    [TIMESTAMP] VARCHAR(30) NULL,
    [TOTALTRADES] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECurr_Future
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECurr_Future]
(
    [CONTRACT_D] VARCHAR(200) NULL,
    [PREVIOUS_S] VARCHAR(20) NULL,
    [OPEN_PRICE] VARCHAR(20) NULL,
    [HIGH_PRICE] VARCHAR(20) NULL,
    [LOW_PRICE] VARCHAR(20) NULL,
    [CLOSE_PRIC] VARCHAR(20) NULL,
    [SETTLEMENT] VARCHAR(20) NULL,
    [NET_CHANGE] VARCHAR(20) NULL,
    [OI_NO_CON] VARCHAR(20) NULL,
    [TRADED_QUA] VARCHAR(20) NULL,
    [TRD_NO_CON] VARCHAR(20) NULL,
    [TRADED_VAL] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSECurr_Options
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSECurr_Options]
(
    [CONTRACT_D] VARCHAR(200) NULL,
    [PREVIOUS_S] VARCHAR(20) NULL,
    [OPEN_PRICE] VARCHAR(20) NULL,
    [HIGH_PRICE] VARCHAR(20) NULL,
    [LOW_PRICE] VARCHAR(20) NULL,
    [CLOSE_PRIC] VARCHAR(20) NULL,
    [SETTLEMENT] VARCHAR(20) NULL,
    [NET_CHANGE] VARCHAR(20) NULL,
    [OI_NO_CON] VARCHAR(20) NULL,
    [TRADED_QUA] VARCHAR(20) NULL,
    [TRD_NO_CON] VARCHAR(20) NULL,
    [UNDRLNG_ST] VARCHAR(20) NULL,
    [NOTIONAL_V] VARCHAR(20) NULL,
    [PREMIUM_TR] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEFO_BC
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEFO_BC]
(
    [INSTRUMENT] VARCHAR(20) NULL,
    [SYMBOL] VARCHAR(100) NULL,
    [EXPIRY_DT] VARCHAR(20) NULL,
    [STRIKE_PR] VARCHAR(20) NULL,
    [OPTION_TYP] VARCHAR(20) NULL,
    [OPEN] VARCHAR(20) NULL,
    [HIGH] VARCHAR(20) NULL,
    [LOW] VARCHAR(20) NULL,
    [CLOSE] VARCHAR(20) NULL,
    [SETTLE_PR] VARCHAR(20) NULL,
    [CONTRACTS] VARCHAR(20) NULL,
    [VAL_INLAKH] VARCHAR(20) NULL,
    [OPEN_INT] VARCHAR(20) NULL,
    [CHG_IN_OI] VARCHAR(20) NULL,
    [TIMESTAMP] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEFO_Bhavcopy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEFO_Bhavcopy]
(
    [TradDt] VARCHAR(25) NULL,
    [BizDt] VARCHAR(25) NULL,
    [Sgmt] VARCHAR(25) NULL,
    [Src] VARCHAR(25) NULL,
    [INSTRUMENT] VARCHAR(25) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(50) NULL,
    [SYMBOL] VARCHAR(100) NULL,
    [SctySrs] VARCHAR(100) NULL,
    [EXPIRY_DT] VARCHAR(25) NULL,
    [FininstrmActlXpryDt] VARCHAR(25) NULL,
    [STRIKE_PR] VARCHAR(100) NULL,
    [OPTION_TYP] VARCHAR(25) NULL,
    [FinInstrmNm] VARCHAR(50) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [CLOSE] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SETTLE_PR] VARCHAR(50) NULL,
    [OPEN_INT] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [VAL_INLAKH] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd] VARCHAR(50) NULL,
    [SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL,
    [Rmks] VARCHAR(25) NULL,
    [Rsvd1] VARCHAR(25) NULL,
    [Rsvd2] VARCHAR(25) NULL,
    [Rsvd3] VARCHAR(25) NULL,
    [Rsvd4] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEFO_Bhavcopy_bkup_08072024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEFO_Bhavcopy_bkup_08072024]
(
    [INSTRUMENT] VARCHAR(100) NULL,
    [SYMBOL] VARCHAR(100) NULL,
    [EXPIRY_DT] VARCHAR(25) NULL,
    [STRIKE_PR] VARCHAR(100) NULL,
    [OPTION_TYP] VARCHAR(100) NULL,
    [OPEN] VARCHAR(100) NULL,
    [HIGH] VARCHAR(100) NULL,
    [LOW] VARCHAR(100) NULL,
    [CLOSE] VARCHAR(100) NULL,
    [SETTLE_PR] VARCHAR(100) NULL,
    [CONTRACTS] VARCHAR(100) NULL,
    [VAL_INLAKH] VARCHAR(100) NULL,
    [OPEN_INT] VARCHAR(100) NULL,
    [CHG_IN_OI] VARCHAR(100) NULL,
    [TIMESTAMP] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSEFO_Bhavcopy_bkup_09072024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSEFO_Bhavcopy_bkup_09072024]
(
    [INSTRUMENT] VARCHAR(100) NULL,
    [SYMBOL] VARCHAR(100) NULL,
    [EXPIRY_DT] VARCHAR(25) NULL,
    [STRIKE_PR] VARCHAR(100) NULL,
    [OPTION_TYP] VARCHAR(100) NULL,
    [OPEN] VARCHAR(100) NULL,
    [HIGH] VARCHAR(100) NULL,
    [LOW] VARCHAR(100) NULL,
    [CLOSE] VARCHAR(100) NULL,
    [SETTLE_PR] VARCHAR(100) NULL,
    [CONTRACTS] VARCHAR(100) NULL,
    [VAL_INLAKH] VARCHAR(100) NULL,
    [OPEN_INT] VARCHAR(100) NULL,
    [CHG_IN_OI] VARCHAR(100) NULL,
    [TIMESTAMP] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nseseries
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nseseries]
(
    [isin] VARCHAR(25) NULL,
    [SYMBOL] VARCHAR(200) NULL,
    [series] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSX_FutOption_BhavCopy
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSX_FutOption_BhavCopy]
(
    [TradDt] VARCHAR(20) NULL,
    [BizDt] VARCHAR(20) NULL,
    [Sgmt] VARCHAR(20) NULL,
    [Src] VARCHAR(20) NULL,
    [FinInstrmTp] VARCHAR(20) NULL,
    [FinInstrmId] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [TckrSymb] VARCHAR(200) NULL,
    [SctySrs] VARCHAR(20) NULL,
    [XpryDt] VARCHAR(20) NULL,
    [FininstrmActlXpryDt] VARCHAR(20) NULL,
    [StrkPric] VARCHAR(20) NULL,
    [OptnTp] VARCHAR(20) NULL,
    [FinInstrmNm] VARCHAR(200) NULL,
    [OpnPric] VARCHAR(20) NULL,
    [HghPric] VARCHAR(20) NULL,
    [LwPric] VARCHAR(20) NULL,
    [ClsPric] VARCHAR(20) NULL,
    [LastPric] VARCHAR(20) NULL,
    [PrvsClsgPric] VARCHAR(20) NULL,
    [UndrlygPric] VARCHAR(20) NULL,
    [SttlmPric] VARCHAR(20) NULL,
    [OpnIntrst] VARCHAR(20) NULL,
    [ChngInOpnIntrst] VARCHAR(20) NULL,
    [TtlTradgVol] VARCHAR(20) NULL,
    [TtlTrfVal] VARCHAR(20) NULL,
    [TtlNbOfTxsExctd] VARCHAR(20) NULL,
    [SsnId] VARCHAR(20) NULL,
    [NewBrdLotQty] VARCHAR(20) NULL,
    [Rmks] VARCHAR(20) NULL,
    [Rsvd1] VARCHAR(20) NULL,
    [Rsvd2] VARCHAR(20) NULL,
    [Rsvd3] VARCHAR(20) NULL,
    [Rsvd4] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_projriskLiveSMS_exception
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_projriskLiveSMS_exception]
(
    [party_code] VARCHAR(30) NULL,
    [Update_date] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sett_14072021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sett_14072021]
(
    [DATE] DATETIME NULL,
    [INSTRUMENT] NVARCHAR(255) NULL,
    [UNDERLYING] NVARCHAR(255) NULL,
    [EXPIRY DATE] DATETIME NULL,
    [MTM SETTLEMENT PRICE] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sett_curr_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sett_curr_upload]
(
    [Contract_Date] VARCHAR(100) NULL,
    [Contract_Instrument_Type] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Last Trading Date] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Corporate_Action_level] VARCHAR(100) NULL,
    [Contract_Regular_Lot] VARCHAR(100) NULL,
    [Contract_Issue_Start_Date] VARCHAR(100) NULL,
    [Contract_Issue_Maturity_Date] VARCHAR(100) NULL,
    [Contract_Exercise_End_Date] VARCHAR(100) NULL,
    [Contract_Exercise_Style] VARCHAR(100) NULL,
    [Contract_Active_Market_Type] VARCHAR(100) NULL,
    [Contract_Open_Price] VARCHAR(100) NULL,
    [Contract_High_Price] VARCHAR(100) NULL,
    [Contract_Low_Price] VARCHAR(100) NULL,
    [Contract_Close_Price] VARCHAR(100) NULL,
    [Contract_Settlement_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Instrument_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Symbol] VARCHAR(100) NULL,
    [Contract_Underlying_Series] VARCHAR(100) NULL,
    [Contract_Underlying_Expiry_Date] VARCHAR(100) NULL,
    [Contract_Underlying_Strike_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Option_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Corporate_Action_Level] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_sett_curr_upload_bkup_25022021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_sett_curr_upload_bkup_25022021]
(
    [Contract_Date] VARCHAR(100) NULL,
    [Contract_Instrument_Type] VARCHAR(100) NULL,
    [Symbol] VARCHAR(100) NULL,
    [Last Trading Date] VARCHAR(100) NULL,
    [Strike_Price] VARCHAR(100) NULL,
    [Option_Type] VARCHAR(100) NULL,
    [Corporate_Action_level] VARCHAR(100) NULL,
    [Contract_Regular_Lot] VARCHAR(100) NULL,
    [Contract_Issue_Start_Date] VARCHAR(100) NULL,
    [Contract_Issue_Maturity_Date] VARCHAR(100) NULL,
    [Contract_Exercise_End_Date] VARCHAR(100) NULL,
    [Contract_Exercise_Style] VARCHAR(100) NULL,
    [Contract_Active_Market_Type] VARCHAR(100) NULL,
    [Contract_Open_Price] VARCHAR(100) NULL,
    [Contract_High_Price] VARCHAR(100) NULL,
    [Contract_Low_Price] VARCHAR(100) NULL,
    [Contract_Close_Price] VARCHAR(100) NULL,
    [Contract_Settlement_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Instrument_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Symbol] VARCHAR(100) NULL,
    [Contract_Underlying_Series] VARCHAR(100) NULL,
    [Contract_Underlying_Expiry_Date] VARCHAR(100) NULL,
    [Contract_Underlying_Strike_Price] VARCHAR(100) NULL,
    [Contract_Underlying_Option_Type] VARCHAR(100) NULL,
    [Contract_Underlying_Corporate_Action_Level] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Sqoff_BSENSE_ListedScrips
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Sqoff_BSENSE_ListedScrips]
(
    [ISIN] VARCHAR(30) NULL,
    [NSE_Symbol] VARCHAR(200) NULL,
    [Series] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [date] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_upload]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_connection] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [Added_by] VARCHAR(50) NULL,
    [Added_on] DATETIME NULL,
    [Machine_IP] VARCHAR(50) NULL,
    [RemoteServer] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_upload_bkup_30042021
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_upload_bkup_30042021]
(
    [Upd_Srno] INT IDENTITY(1,1) NOT NULL,
    [Upd_Title] VARCHAR(100) NULL,
    [Upd_connection] VARCHAR(100) NULL,
    [Upd_TempTable] VARCHAR(100) NULL,
    [Upd_deli] VARCHAR(10) NULL,
    [Upd_FirstRow] INT NULL,
    [Upd_FinSP] VARCHAR(100) NULL,
    [Upd_Extension] VARCHAR(100) NULL,
    [Upd_info] VARCHAR(200) NULL,
    [Added_by] VARCHAR(50) NULL,
    [Added_on] DATETIME NULL,
    [Machine_IP] VARCHAR(50) NULL,
    [RemoteServer] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_upload_info
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_upload_info]
(
    [Updinfo_RptSrno] INT NULL,
    [Updinfo_filename] VARCHAR(200) NULL,
    [Updinfo_filesize] INT NULL,
    [Updinfo_fileType] VARCHAR(100) NULL,
    [Updinfo_datetime] DATETIME NULL,
    [Updinfo_by] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_upload_info_comm
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_upload_info_comm]
(
    [Updinfo_RptSrno] INT NULL,
    [Updinfo_filename] VARCHAR(200) NULL,
    [Updinfo_filesize] INT NULL,
    [Updinfo_fileType] VARCHAR(100) NULL,
    [Updinfo_datetime] DATETIME NULL,
    [Updinfo_by] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Tbl_Upload_NBFC_Funding_Scrip
-- --------------------------------------------------
CREATE TABLE [dbo].[Tbl_Upload_NBFC_Funding_Scrip]
(
    [Company_Name] VARCHAR(100) NULL,
    [BSE_Scrip_Code] VARCHAR(25) NULL,
    [Group] VARCHAR(50) NULL,
    [ISIN] VARCHAR(25) NULL,
    [NSE_Symbol] VARCHAR(25) NULL,
    [Start_Date] VARCHAR(25) NULL,
    [End_Date] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_var_eveprojrisk
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_var_eveprojrisk]
(
    [isin] VARCHAR(30) NULL,
    [valid_var] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp
-- --------------------------------------------------
CREATE TABLE [dbo].[temp]
(
    [dat] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_BSE_Illiquid_Scrip
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_BSE_Illiquid_Scrip]
(
    [Company Name] VARCHAR(100) NULL,
    [BSE Scrip Code] VARCHAR(50) NULL,
    [Group] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [NSE Illiquid] VARCHAR(50) NULL,
    [BSE Illiquid] VARCHAR(50) NULL,
    [NSE Symbol] VARCHAR(20) NULL,
    [START DATE] VARCHAR(20) NULL,
    [END DATE] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_BSE_PCA
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_BSE_PCA]
(
    [SrNo] NVARCHAR(50) NULL,
    [Scrip_Cd] NVARCHAR(50) NULL,
    [Scrip_Name] NVARCHAR(100) NULL,
    [Annexure] NVARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_marginshortfall
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_marginshortfall]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [RoCode] VARCHAR(20) NULL,
    [BranchCode] VARCHAR(20) NULL,
    [FamilyCode] VARCHAR(15) NULL,
    [ClientCode] VARCHAR(15) NULL,
    [ClientName] VARCHAR(75) NULL,
    [LedgeBalance] FLOAT NULL,
    [Collateral] FLOAT NULL,
    [FO_SpanMargin] FLOAT NULL,
    [FO_Shortfall] FLOAT NULL,
    [FO_PercOfPenalty] FLOAT NULL,
    [FO_PenaltyAmount] FLOAT NULL,
    [NSX_SpanMargin] FLOAT NULL,
    [NSX_Shortfall] FLOAT NULL,
    [NSX_PercOfPenalty] FLOAT NULL,
    [NSX_PenaltyAmount] FLOAT NULL,
    [MCDSpanMargin] FLOAT NULL,
    [MCDShortfall] FLOAT NULL,
    [MCDPercOfPenalty] FLOAT NULL,
    [MCDPenaltyAmount] FLOAT NULL,
    [UploadedDatetime] DATETIME NULL,
    [UploadedBy] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_marginshortfall_AllSegment
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_marginshortfall_AllSegment]
(
    [RoCode] VARCHAR(20) NULL,
    [BranchCode] VARCHAR(20) NULL,
    [FamilyCode] VARCHAR(20) NULL,
    [ClientCode] VARCHAR(20) NULL,
    [ClientName] VARCHAR(100) NULL,
    [LedgeBalance] FLOAT NULL,
    [Collateral] FLOAT NULL,
    [Total Shortfall] FLOAT NULL,
    [Var Margin] FLOAT NULL,
    [MTM] FLOAT NULL,
    [Span + Exp Margin] FLOAT NULL,
    [FO_Shortfall] FLOAT NULL,
    [FO_PercOfPenalty] FLOAT NULL,
    [FO_PenaltyAmount] FLOAT NULL,
    [NSX_SpanMargin] FLOAT NULL,
    [NSX_Shortfall] FLOAT NULL,
    [NSX_PercOfPenalty] FLOAT NULL,
    [NSX_PenaltyAmount] FLOAT NULL,
    [MCDSpanMargin] FLOAT NULL,
    [MCDShortfall] FLOAT NULL,
    [MCDPercOfPenalty] FLOAT NULL,
    [MCDPenaltyAmount] FLOAT NULL,
    [MCXSpanMargin] FLOAT NULL,
    [MCXShortfall] FLOAT NULL,
    [MCXPercOfPenalty] FLOAT NULL,
    [MCXPenaltyAmount] FLOAT NULL,
    [NCDXSpanMargin] FLOAT NULL,
    [NCDXShortfall] FLOAT NULL,
    [NCDXPercOfPenalty] FLOAT NULL,
    [NCDXPenaltyAmount] FLOAT NULL,
    [UploadedDatetime] DATETIME NULL,
    [UploadedBy] VARCHAR(20) NULL,
    [SrNo] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_marginshortfall_new
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_marginshortfall_new]
(
    [RoCode] VARCHAR(20) NULL,
    [BranchCode] VARCHAR(20) NULL,
    [FamilyCode] VARCHAR(20) NULL,
    [ClientCode] VARCHAR(20) NULL,
    [ClientName] VARCHAR(100) NULL,
    [LedgeBalance] FLOAT NULL,
    [Collateral] FLOAT NULL,
    [Var Margin] FLOAT NULL,
    [MTM] FLOAT NULL,
    [Span + Exp Margin] FLOAT NULL,
    [FO_Shortfall] FLOAT NULL,
    [FO_PercOfPenalty] FLOAT NULL,
    [FO_PenaltyAmount] FLOAT NULL,
    [NSX_SpanMargin] FLOAT NULL,
    [NSX_Shortfall] FLOAT NULL,
    [NSX_PercOfPenalty] FLOAT NULL,
    [NSX_PenaltyAmount] FLOAT NULL,
    [MCDSpanMargin] FLOAT NULL,
    [MCDShortfall] FLOAT NULL,
    [MCDPercOfPenalty] FLOAT NULL,
    [MCDPenaltyAmount] FLOAT NULL,
    [UploadedDatetime] DATETIME NULL,
    [UploadedBy] VARCHAR(20) NULL,
    [SrNo] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_MCDX_Margin
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_MCDX_Margin]
(
    [Symbol] VARCHAR(15) NULL,
    [ExpiryDate] DATETIME NULL,
    [Price] MONEY NULL,
    [Multiplier] INT NULL,
    [IM] MONEY NULL,
    [SBM] MONEY NULL,
    [SSM] MONEY NULL,
    [AML] MONEY NULL,
    [AMS] MONEY NULL,
    [TenderM] MONEY NULL,
    [TM] MONEY NULL,
    [ICV] MONEY NULL,
    [Margin] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_nbfc_appScrip
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_nbfc_appScrip]
(
    [Isin] VARCHAR(15) NULL,
    [SecurityName] VARCHAR(50) NULL,
    [Funding] INT NULL,
    [StartDate] DATETIME NULL,
    [Category] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_NBFC_DayPosition
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_NBFC_DayPosition]
(
    [Cltcode] VARCHAR(25) NULL,
    [CltName] VARCHAR(100) NULL,
    [UnAppMktVal] MONEY NULL,
    [AppMktVal] MONEY NULL,
    [OddLotMktVal] MONEY NULL,
    [MrgOnApp_UnApp] MONEY NULL,
    [LimitSanc] MONEY NULL,
    [LedgerBal] MONEY NULL,
    [MrgToRec] MONEY NULL,
    [MrgToPay] MONEY NULL,
    [ClientDp_Id] VARCHAR(25) NULL,
    [BrCode] VARCHAR(10) NULL,
    [SBCode] VARCHAR(10) NULL,
    [BSECM_Bal] MONEY NULL,
    [NSECM_Bal] MONEY NULL,
    [NBFC_Bal] MONEY NULL,
    [NSEFO_Bal] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_nbfC_ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_nbfC_ledger]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [AccountCode] VARCHAR(25) NULL,
    [AccountName] VARCHAR(50) NULL,
    [BookType] VARCHAR(25) NULL,
    [Date] VARCHAR(25) NULL,
    [Vno] VARCHAR(25) NULL,
    [Debit] MONEY NULL,
    [Credit] MONEY NULL,
    [Balance] MONEY NULL,
    [ChequeNo] VARCHAR(25) NULL,
    [ChequeDate] VARCHAR(25) NULL,
    [Drawn] VARCHAR(100) NULL,
    [Description] VARCHAR(200) NULL,
    [vdt] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ncdex_bhav_copy
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ncdex_bhav_copy]
(
    [TradDt] VARCHAR(11) NULL,
    [BizDt] VARCHAR(11) NULL,
    [Sgmt] VARCHAR(10) NULL,
    [Src] VARCHAR(11) NULL,
    [FinInstrmTp] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(10) NULL,
    [Underlying_Commodity] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(10) NULL,
    [ExpiryDate] VARCHAR(11) NULL,
    [FininstrmActlXpryDt] VARCHAR(11) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_Type] VARCHAR(10) NULL,
    [FinInstrmNm] VARCHAR(250) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Closing_Price] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Traded_ValueinLacs] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd_SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_ncdex_bhav_copy_new
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_ncdex_bhav_copy_new]
(
    [TradDt] VARCHAR(11) NULL,
    [BizDt] VARCHAR(11) NULL,
    [Sgmt] VARCHAR(10) NULL,
    [Src] VARCHAR(11) NULL,
    [FinInstrmTp] VARCHAR(100) NULL,
    [FinInstrmId] VARCHAR(100) NULL,
    [ISIN] VARCHAR(10) NULL,
    [Underlying_Commodity] VARCHAR(250) NULL,
    [SctySrs] VARCHAR(10) NULL,
    [ExpiryDate] VARCHAR(11) NULL,
    [FininstrmActlXpryDt] VARCHAR(20) NULL,
    [Strike_Price] VARCHAR(50) NULL,
    [Option_Type] VARCHAR(10) NULL,
    [FinInstrmNm] VARCHAR(250) NULL,
    [OpnPric] VARCHAR(50) NULL,
    [HghPric] VARCHAR(50) NULL,
    [LwPric] VARCHAR(50) NULL,
    [Closing_Price] VARCHAR(50) NULL,
    [LastPric] VARCHAR(50) NULL,
    [PrvsClsgPric] VARCHAR(50) NULL,
    [UndrlygPric] VARCHAR(50) NULL,
    [SttlmPric] VARCHAR(50) NULL,
    [Open_Interest] VARCHAR(50) NULL,
    [ChngInOpnIntrst] VARCHAR(50) NULL,
    [TtlTradgVol] VARCHAR(50) NULL,
    [Traded_ValueinLacs] VARCHAR(50) NULL,
    [TtlNbOfTxsExctd_SsnId] VARCHAR(50) NULL,
    [NewBrdLotQty] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_NSE_Illiquid_Scrip
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_NSE_Illiquid_Scrip]
(
    [Company Name] VARCHAR(100) NULL,
    [BSE Scrip Code] VARCHAR(50) NULL,
    [Group] VARCHAR(10) NULL,
    [ISIN] VARCHAR(20) NULL,
    [NSE Illiquid] VARCHAR(50) NULL,
    [BSE Illiquid] VARCHAR(50) NULL,
    [NSE Symbol] VARCHAR(20) NULL,
    [START DATE] VARCHAR(20) NULL,
    [END DATE] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_NSE_PCA
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_NSE_PCA]
(
    [SrNo] NVARCHAR(50) NULL,
    [NSESymbol] NVARCHAR(50) NULL,
    [Series] NVARCHAR(50) NULL,
    [SecurityName] NVARCHAR(100) NULL,
    [ISIN] NVARCHAR(50) NULL,
    [Annexure] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_restricted_code
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_restricted_code]
(
    [BSE Code] NVARCHAR(255) NULL,
    [ISIN No] NVARCHAR(255) NULL,
    [NSE Symbol] NVARCHAR(255) NULL,
    [CO_NAME] NVARCHAR(255) NULL,
    [New Category] NVARCHAR(255) NULL,
    [Block Status] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_SBDeposite
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_SBDeposite]
(
    [CLIENT] VARCHAR(10) NULL,
    [sb tag] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_scripcatg
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_scripcatg]
(
    [Power] MONEY NULL,
    [EmpCost] MONEY NULL,
    [ShHoldFunds] MONEY NULL,
    [ISIN] CHAR(15) NULL,
    [Category] CHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Temp_Var
-- --------------------------------------------------
CREATE TABLE [dbo].[Temp_Var]
(
    [Srno] VARCHAR(5) NULL,
    [ScripCode] VARCHAR(11) NULL,
    [ScripName] VARCHAR(23) NULL,
    [ISIN] VARCHAR(35) NULL,
    [VARPER] VARCHAR(42) NULL,
    [FIIVAR] VARCHAR(50) NULL,
    [ProcessDate] VARCHAR(58) NULL,
    [ApplicationDate] VARCHAR(66) NULL,
    [filename] VARCHAR(50) NULL,
    [Updated_On] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp1_nbfC_ledger
-- --------------------------------------------------
CREATE TABLE [dbo].[temp1_nbfC_ledger]
(
    [AccountCode] VARCHAR(25) NULL,
    [AccountName] VARCHAR(50) NULL,
    [BookType] VARCHAR(25) NULL,
    [Date] VARCHAR(25) NULL,
    [Vno] VARCHAR(25) NULL,
    [Debit] MONEY NULL,
    [Credit] MONEY NULL,
    [Balance] MONEY NULL,
    [ChequeNo] VARCHAR(25) NULL,
    [ChequeDate] VARCHAR(25) NULL,
    [Drawn] VARCHAR(100) NULL,
    [Description] VARCHAR(200) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VMSS_BSE_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[VMSS_BSE_REVERSEFILE]
(
    [SCRIPCODE] VARCHAR(10) NULL,
    [SCRIPNAME] VARCHAR(50) NULL,
    [TRADENO] VARCHAR(10) NULL,
    [RATE] INT NULL,
    [Qty] INT NULL,
    [OPP_MMBR_CODE] INT NULL,
    [OPP_MMBR_NAME] INT NULL,
    [TIME_1] DATETIME NULL,
    [DATE] DATETIME NULL,
    [CLIENTCODE] VARCHAR(20) NULL,
    [BUY_SELL] VARCHAR(1) NULL,
    [ORDER_TYPE] VARCHAR(15) NULL,
    [ORDERNO] VARCHAR(20) NULL,
    [INSTITUTION_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(20) NULL,
    [SCRIP_GROUP] VARCHAR(5) NULL,
    [SETTLEMENT_NO_DATE] VARCHAR(20) NULL,
    [TIME_2] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.VMSS_NSE_REVERSEFILE
-- --------------------------------------------------
CREATE TABLE [dbo].[VMSS_NSE_REVERSEFILE]
(
    [Trade_No] INT NULL,
    [Trade_Status] INT NULL,
    [Security_Symbol] VARCHAR(30) NULL,
    [Series] VARCHAR(5) NULL,
    [Security_Name] VARCHAR(30) NULL,
    [Instrument_Type] INT NULL,
    [Book_Type] INT NULL,
    [Market_Type] INT NULL,
    [User_Id] INT NULL,
    [Branch_Id] INT NULL,
    [Buy_Sell] INT NULL,
    [Trade_Qty] INT NULL,
    [Trade_Price] MONEY NULL,
    [PRO_CLI] INT NULL,
    [Client_Ac] VARCHAR(10) NULL,
    [Participant_Code] VARCHAR(30) NULL,
    [Auction_Part_Type] VARCHAR(30) NULL,
    [Auction_No] INT NULL,
    [Default] INT NULL,
    [Sett_Period] DATETIME NULL,
    [Trade_Entry_Dt_Time] DATETIME NULL,
    [Order_Number] VARCHAR(50) NULL,
    [Counter_Party_Id] VARCHAR(30) NULL,
    [Order_Entry_Date_Time] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.X_CN01_NSE_24022021$
-- --------------------------------------------------
CREATE TABLE [dbo].[X_CN01_NSE_24022021$]
(
    [F1] DATETIME NULL,
    [FUTCUR] NVARCHAR(255) NULL,
    [EURINR] NVARCHAR(255) NULL,
    [F4] DATETIME NULL,
    [F5] FLOAT NULL,
    [FF] NVARCHAR(255) NULL,
    [F7] FLOAT NULL,
    [F8] FLOAT NULL,
    [F9] DATETIME NULL,
    [F10] DATETIME NULL,
    [F11] NVARCHAR(255) NULL,
    [F12] NVARCHAR(255) NULL,
    [E] NVARCHAR(255) NULL,
    [N] NVARCHAR(255) NULL,
    [F15] FLOAT NULL,
    [F16] FLOAT NULL,
    [F17] FLOAT NULL,
    [F18] FLOAT NULL,
    [F19] FLOAT NULL,
    [F20] FLOAT NULL,
    [F21] NVARCHAR(255) NULL,
    [EURINR1] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.File_UploadStatus
-- --------------------------------------------------
CREATE view File_UploadStatus as    
select convert(varchar(10),b.ProcessDate,103) as ProcessDate ,a.Upd_Title as Process,    
isnull(FileRowCount,0) as UploadFileRowCount,  
ProcessStatus as NumberofAttampts   
,vw.RowNo as RowCountInMasterTable  
from tbl_AutomationUpladFile a ,  
tbl_Fileprocess b , Vw_MasterTableCount vw   
where a.Upd_Srno=b.FileId  and a.Upd_Srno =vw.Fileno

GO

-- --------------------------------------------------
-- VIEW dbo.File_UploadStatus_comm
-- --------------------------------------------------

CREATE view [dbo].[File_UploadStatus_comm] as    
select convert(varchar(10),b.ProcessDate,103) as ProcessDate ,a.Upd_Title as Process,    
isnull(FileRowCount,0) as UploadFileRowCount,  
ProcessStatus as NumberofAttampts   
,vw.RowNo as RowCountInMasterTable  
from tbl_AutomationFileUpload a ,  
tbl_Fileprocess_comm b , Vw_MasterTableCount_comm vw   
where a.Upd_Srno=b.FileId  and a.Upd_Srno =vw.Fileno

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MasterTableCount
-- --------------------------------------------------


CREATE View [dbo].[Vw_MasterTableCount]

 as 

 select a.*,b.Upd_Title,Upd_info  from ( 

  select 1 as Fileno ,COUNT(*) as RowNo  from  general.dbo.cp_bsecm   

  Union all     

  select 108,COUNT(*) as RowNo from general.dbo.tbl_NSEFO_Bhavcopy  

  Union all

  select 6,COUNT(*) as RowNo from general.dbo.cp_mcxsx  

  Union all

  select 7,COUNT(*) as RowNo from general.dbo.fovar_margin 

  Union all

  select 8,COUNT(*) as RowNo from  general.dbo.cp_nsx    

  Union all

  select 9,COUNT(*) as RowNo from  general.dbo.BSEVar 

  Union all 

  select 10,COUNT(*) as RowNo from general.dbo.cp_nsecm      

  Union all

  select 25,COUNT(*) as RowNo from  general.dbo.tbl_fut_opt_upload  

  Union all

  select 26,COUNT(*) as RowNo from  general.dbo.tbl_sett_curr_upload      

  Union all

  select 101,COUNT(*) as RowNo from  general.dbo.ScripIMargin_NSEFO 
  
  Union all
 
 select 102,COUNT(*) as RowNo from  general.dbo.cp_bsx 
 
  Union all
 
 select 103,COUNT(*) as RowNo from  general.dbo.tbl_BSEVAR_New                                

 ) as a  , tbl_AutomationUpladFile b where a.Fileno=b.Upd_Srno

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MasterTableCount_bkup_11102019
-- --------------------------------------------------
create View Vw_MasterTableCount_bkup_11102019

 as 

 select a.*,b.Upd_Title,Upd_info  from ( 

  select 1 as Fileno ,COUNT(*) as RowNo  from  general.dbo.cp_bsecm   

  Union all     

  select 3,COUNT(*) as RowNo from general.dbo.cp_nseFO  

  Union all

  select 6,COUNT(*) as RowNo from general.dbo.cp_mcxsx  

  Union all

  select 7,COUNT(*) as RowNo from general.dbo.fovar_margin 

  Union all

  select 8,COUNT(*) as RowNo from  general.dbo.cp_nsx    

  Union all

  select 9,COUNT(*) as RowNo from  general.dbo.BSEVar 

  Union all 

  select 10,COUNT(*) as RowNo from general.dbo.cp_nsecm      

  Union all

  select 25,COUNT(*) as RowNo from  general.dbo.tbl_fut_opt_upload  

  Union all

  select 26,COUNT(*) as RowNo from  general.dbo.tbl_sett_curr_upload      

  Union all

  select 101,COUNT(*) as RowNo from  general.dbo.ScripIMargin_NSEFO                                      

 ) as a  , tbl_AutomationUpladFile b where a.Fileno=b.Upd_Srno

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_MasterTableCount_comm
-- --------------------------------------------------
CREATE View Vw_MasterTableCount_comm  
  
 as   
  
 select a.*,b.Upd_Title,Upd_info  from (   
  
  select 1 as Fileno ,COUNT(*) as RowNo  from  general.dbo.ContractFile_MCX     
  
  Union all       
  
  select 4,COUNT(*) as RowNo from general.dbo.ContractFile_NCDEX    
  
  Union all  
  
  select 3,COUNT(*) as RowNo from general.dbo.MCDX_Bhav_Copy    
  
  Union all  
  
  select 2,COUNT(*) as RowNo from general.dbo.NCDEX_Bhav_Copy   
  
  Union all  
  
  select 5,COUNT(*) as RowNo from  general.dbo.ncdex_ps03   
  
  Union all  
  
  select 6,COUNT(*) as RowNo from  upload.dbo.fileuploads_BK01      
  
  Union all  
  
  select 7,COUNT(*) as RowNo from  upload.dbo.fileuploads_MG11  
  
  union all  
  
  select 8,COUNT(*) as RowNo from  general.dbo.cp_mcx   
  
  union all              
  
  select 9,COUNT(*) as RowNo from general.dbo.cp_ncdex  
  union all  
  
  select 10,COUNT(*) as RowNo from  general.dbo.cp_nce  
  
  
 ) as a  , tbl_AutomationFileUpload b where a.Fileno=b.Upd_Srno  
  
  
  
 --select 6,COUNT(*) as RowNo from fileuploads_BK01  where segment='NCDEX BK01'    
  
  
  
-- fileuploads_BK01  
  
--truncate table fileuploads_MG11

GO

