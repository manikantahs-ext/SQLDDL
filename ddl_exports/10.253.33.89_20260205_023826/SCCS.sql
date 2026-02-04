-- DDL Export
-- Server: 10.253.33.89
-- Database: SCCS
-- Exported: 2026-02-05T02:39:28.584488

USE SCCS;
GO

-- --------------------------------------------------
-- FUNCTION dbo.ADDSPACE
-- --------------------------------------------------
CREATE FUNCTION ADDSPACE(@MWORD VARCHAR(100))  
RETURNs VARCHAR(100)  
AS  
BEGIN  
DECLARE @CTR AS INT, @NWORD AS VARCHAR(100), @LCTR AS INT  
SET @CTR = 2  
SET @LCTR = 0  
SET @NWORD=@MWORD  
  
WHILE @CTR <= LEN(@MWORD)  
BEGIN  
 IF ASCII(SUBSTRING(@MWORD,@CTR,1)) BETWEEN 65 AND 90  
 BEGIN  
  SET @NWORD =SUBSTRING(@NWORD,1,@CTR-1+@LCTR)+' '+SUBSTRING(@NWORD,@CTR+@LCTR,100)  
  --PRINT @LCTR  
  SET @LCTR=@LCTR +1  
 END  
 SET @CTR=@CTR +1  
END  
RETURN(@NWORD)  
END

GO

-- --------------------------------------------------
-- FUNCTION dbo.GetDays
-- --------------------------------------------------
CREATE FUNCTION GetDays(@Start datetime, @Stop datetime)
RETURNS TABLE AS RETURN
WITH Numbers (N) AS (
SELECT 1 UNION ALL
SELECT 1 + N FROM Numbers
WHERE N < DATEDIFF(day,@Start,@Stop)+1
)
SELECT DATEADD(day,N-1,@Start) Date FROM Numbers

GO

-- --------------------------------------------------
-- INDEX dbo.BSET3Shrt_hist
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_party_Code] ON [dbo].[BSET3Shrt_hist] ([party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.BSET3Shrt_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_updateDate] ON [dbo].[BSET3Shrt_hist] ([updateDate])

GO

-- --------------------------------------------------
-- INDEX dbo.NSET3Shrt_hist
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_party_Code] ON [dbo].[NSET3Shrt_hist] ([party_Code])

GO

-- --------------------------------------------------
-- INDEX dbo.NSET3Shrt_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_updateDate] ON [dbo].[NSET3Shrt_hist] ([updateDate])

GO

-- --------------------------------------------------
-- INDEX dbo.RMS_Client_Vertical
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Client] ON [dbo].[RMS_Client_Vertical] ([Client])

GO

-- --------------------------------------------------
-- INDEX dbo.SCCS_ClientMaster
-- --------------------------------------------------
CREATE CLUSTERED INDEX [IX_Party_code] ON [dbo].[SCCS_ClientMaster] ([Party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.SCCS_Data
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_dtPty] ON [dbo].[SCCS_Data] ([Party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.SCCS_Data_hist
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_dtPty] ON [dbo].[SCCS_Data_hist] ([Update_date], [Party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.SCCS_MIS_PO
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_ps] ON [dbo].[SCCS_MIS_PO] ([party_code], [scrip_Cd])

GO

-- --------------------------------------------------
-- INDEX dbo.SCCS_SharePO
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_ptyScp] ON [dbo].[SCCS_SharePO] ([update_date], [exchange], [party_code], [scrip_cd])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sccs_CMS_online_Marked
-- --------------------------------------------------
ALTER TABLE [dbo].[sccs_CMS_online_Marked] ADD CONSTRAINT [PK_sccs_CMS_online_Marked] PRIMARY KEY ([Cltcode], [MarkedDate])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dummy1
-- --------------------------------------------------
create procedure dummy1 as 
print 'ok'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dummy2
-- --------------------------------------------------
create procedure dummy2 as 
print 'dummy2'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.dummy3
-- --------------------------------------------------
create procedure dummy3 as 
print 'dummy3'

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
-- PROCEDURE dbo.SCCS_AOFT_BO
-- --------------------------------------------------
CREATE Procedure SCCS_AOFT_BO(@bank as varchar(5))                       
as                        
                      
set Nocount On                        
                        
set transaction isolation level read uncommitted                        
                        
/*declare @mdate as datetime                        
select @mdate=max(generateddate) from ONFT_BankFile where bank='HDFC'                        
declare @mdate1 as datetime                        
select @mdate1=max(generateddate) from ONFT_BankFile where bank='ICICI'                        
--print @mdate                        
*/                     
if @bank='HDFC'                     
Begin                    
 select distinct refno,generateddate,name,drawee_loca,amt,a.cltcode,co,bank from                        
 --(select * from ONFT_BankFile where generateddate=@mdate and bank='HDFC') a                        
 (select * from sccs_ONFT_BankFile where bank='HDFC') a                        
 left outer join                        
 (select cltcode,                                                    
 drawee_loca=(case when a.drawee_loca='' then b.drawee_loca else a.drawee_loca end)                                                    
 from sccs_CMS_DraweeLocation_Combine a, intranet.cms.dbo.cmsbr b (nolock) where a.branch=b.sbtag                         
 ) b                        
 on a.cltcode=b.cltcode         
 where amt>=5.00        
 order by a.cltcode                       
END                    
if @bank='ICICI'                     
Begin                       
 select distinct refno,generateddate,name,drawee_loca,amt,a.cltcode,co,bank from                        
 --(select * from ONFT_BankFile where generateddate=@mdate1 and bank='ICICI') a                        
 (select * from sccs_ONFT_BankFile where  bank='ICICI') a                        
 left outer join                        
 (select cltcode,                                                    
 drawee_loca=(case when a.drawee_loca='' then b.drawee_loca else a.drawee_loca end)                                                    
 from sccs_CMS_DraweeLocation_Combine a, intranet.cms.dbo.cmsbr b (nolock) where a.branch=b.sbtag                         
 ) b                        
 on a.cltcode=b.cltcode         
 where amt>=5.00        
 order by a.cltcode                        
END                   
if @bank='NEFT'                     
Begin                       
 select distinct refno,generateddate,name,drawee_loca,amt,a.cltcode,co,bank='NEFT' from                        
 --(select * from ONFT_BankFile where generateddate=@mdate1 and bank='ICICI') a                        
 (select * from sccs_neft_BankFile --where  bank not in ('ICICI','HDFC')                
 )a                        
 left outer join                        
 (select cltcode,                                                    
 drawee_loca=(case when a.drawee_loca='' then b.drawee_loca else a.drawee_loca end)                                                    
 from sccs_CMS_DraweeLocation_Combine a, intranet.cms.dbo.cmsbr b (nolock) where a.branch=b.sbtag                         
 ) b                        
 on a.cltcode=b.cltcode          
 where amt>=5.00        
 order by a.cltcode                      
END                         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Bank_BO_file_last_generateda
-- --------------------------------------------------
CREATE procedure SCCS_Bank_BO_file_last_generateda(@bank as varchar(6))                    
as                    
Set Nocount On                    
                    
          
Set transaction isolation level read uncommitted                    
        
declare @gdate as datetime                    
--select @gdate=isnull(max(generateddate),'')  from ONFT_BankFile (nolock) where bank=@bank                   
select @gdate=isnull(max(generateddate),'')  from        
(        
select generateddate=max(generateddate) from SCCS_ONFT_BankFile (nolock) --where bank=@bank      
union all        
select generateddate=max(generateddate) from SCCS_ONFT_BankFile_hist (nolock) --where bank=@bank      
) a  where generatedDate is not null      
    
        
declare @ndate as datetime                    
select @ndate=isnull(max(generateddate),'')  from SCCS_NEFT_BankFile (nolock)                    
                   
if @gdate=''                     
BEGIN                    
 set @gdate=getDate()                    
END                  
                   
if @ndate=''                     
BEGIN                    
 set @ndate=getDate()                    
END                    
                     
if @bank='HDFC'                                  
BEGIN                    
 select seq=1,segment='BSECM',fname_bank='ONLINEFUNDS-HDFC-BSE'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
    ,fname_BO='ONLINEFUNDS_BSE_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'                        
 union                    
 select seq=2,segment='NSECM',fname_bank='ONLINEFUNDS-HDFC-NSE'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
   ,fname_BO='ONLINEFUNDS_NSE_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'                        
 union                    
 select seq=3,segment='NSEFO',fname_bank='ONLINEFUNDS-HDFC-FO'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                               ,fname_BO='ONLINEFUNDS_FO_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end            
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'                            
 union                    
 select seq=4,segment='MCX',fname_bank='ONLINEFUNDS-HDFC-MCX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
  ,fname_BO='ONLINEFUNDS_MCX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'                        
 union                    
 select seq=5,segment='NCDEX',fname_bank='ONLINEFUNDS-HDFC-NCDEX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                       
 ,fname_BO='ONLINEFUNDS_NCDX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'    
union                    
 select seq=6,segment='MCD',fname_bank='ONLINEFUNDS-HDFC-MCD'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
  ,fname_BO='ONLINEFUNDS_MCD_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'                        
 union                    
 select seq=7,segment='NSX',fname_bank='ONLINEFUNDS-HDFC-NSX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                       
 ,fname_BO='ONLINEFUNDS_NSX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_HDFC'                        
order by seq          
END                    
                    
if @bank='ICICI'                                  
BEGIN                    
 select seq=1,segment='BSECM',fname_bank='ONLINEFUNDS-ICICI-BSE'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
  ,fname_BO='ONLINEFUNDS_BSE_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'                    
 union                    
 select seq=2,segment='NSECM',fname_bank='ONLINEFUNDS-ICICI-NSE'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then             
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
'0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
 ,fname_BO='ONLINEFUNDS_NSE_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'                    
 union                    
 select seq=3,segment='NSEFO',fname_bank='ONLINEFUNDS-ICICI-FO'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
 ,fname_BO='ONLINEFUNDS_FO_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'                                
 union                    
 select seq=4,segment='MCX',fname_bank='ONLINEFUNDS-ICICI-MCX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                       
 ,fname_BO='ONLINEFUNDS_MCX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'                      
 union                    
 select seq=5,segment='NCDEX',fname_bank='ONLINEFUNDS-ICICI-NCDEX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                      
 ,fname_BO='ONLINEFUNDS_NCDX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'    
union                    
 select seq=6,segment='MCD',fname_bank='ONLINEFUNDS-ICICI-MCD'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                       
 ,fname_BO='ONLINEFUNDS_MCD_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end              
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'                      
 union                    
 select seq=7,segment='NSX',fname_bank='ONLINEFUNDS-ICICI-NSX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                      
 ,fname_BO='ONLINEFUNDS_NSX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_ICICI'                       
order by seq          
END          
                  
if @bank='NEFT'                                  
BEGIN                    
 select sql=1,segment='BSECM',fname_bank='RTGS-BSE'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                 
  ,fname_BO='ONLINEFUNDS_BSE_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'                    
 union                    
 select sql=2,segment='NSECM',fname_bank='RTGS-NSE'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
 ,fname_BO='ONLINEFUNDS_NSE_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'                    
 union                    
 select sql=3,segment='NSEFO',fname_bank='RTGS-FO'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                    
 ,fname_BO='ONLINEFUNDS_FO_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'                          
 union                    
 select sql=4,segment='MCX',fname_bank='RTGS-MCX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                       
 ,fname_BO='ONLINEFUNDS_MCX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'                      
 union                    
 select sql=5,segment='NCDEX',fname_bank='RTGS-NCDEX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                      
 ,fname_BO='ONLINEFUNDS_NCDX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'   
union                    
 select sql=6,segment='MCD',fname_bank='RTGS-MCD'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                       
 ,fname_BO='ONLINEFUNDS_MCD_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'                      
 union                    
 select sql=7,segment='NSX',fname_bank='RTGS-NSX'+case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))                      
 ,fname_BO='ONLINEFUNDS_NSX_BOFile'                    
    +case when len(convert(varchar(2),datepart(dd,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(dd,max(@gdate))) else convert(varchar(2),datepart(dd,max(@gdate))) end                    
 +'-'+case when len(convert(varchar(2),datepart(mm,max(@gdate))))=1 then                     
 '0'+convert(varchar(2),datepart(mm,max(@gdate))) else convert(varchar(2),datepart(mm,max(@gdate))) end                    
 +'-'+convert(varchar(4),datepart(yy,max(@gdate)))+'_NEFT'                       
order by segment          
END                    
                    
                    
Set Nocount Off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_BSEAuctionInfo
-- --------------------------------------------------
CREATE procedure [dbo].[SCCS_BSEAuctionInfo]                  
as                  
  
set nocount on  
      
      
declare @nor as int,@sett as varchar(7)                  
select @sett=max(sett_no) from AngelBSECM.bsedb_ab.dbo.settlement  with (nolock) where sett_type in ('AD','AC') and sett_no <'2010999' /*and sauda_date <= convert(varchar(11),getdate())*/      
select @nor=count(1) from AngelBSECM.account_ab.dbo.BillPosted  with (nolock) where sett_Type in ('AD','AC') and sett_no=@sett      
print @nor      
print @sett      
      
select top 0 *,marketRate=convert(money,0) into #holding from risk.dbo.holding with (nolock) where 1=2                      
  
              
insert into #holding                  
select                   
isin=space(15),                  
scrip_cd,                  
series=space(25),                  
sett_no,                  
sett_type,                  
party_code,                  
bs='S',exchange='BSE',qty=-tradeqty,                  
clsrate=convert(money,0),                  
accno='',dpid='',clid='',flag='',aben=convert(money,0),apool=convert(money,0),nben=convert(money,0),npool=convert(money,0),                  
approved=' ',scripname=space(25),party_name=space(25),pool='P',total=convert(money,0),dummy1=space(15),dummy2=space(10),nse_approved=' ',marketrate                  
from AngelBSECM.bsedb_Ab.dbo.settlement where sett_type in /* ('AD','AC') */  
(select sett_type from AngelBSECM.account_ab.dbo.BillPosted  with (nolock) where sett_Type in ('AD','AC') and sett_no=@sett and vdt >=getdate())  
and sett_no = @sett      
and sell_buy=1                  
and auctionpart in ('FC','FS','FA')   
  
  
              
insert into #holding                  
select                   
isin=space(15),                  
scrip_cd,                  
series=space(25),                  
sett_no,                  
sett_type,                  
party_code,                  
bs='S',exchange='BSE',qty=-tradeqty,                  
clsrate=convert(money,0),                  
accno='',dpid='',clid='',flag='',aben=convert(money,0),apool=convert(money,0),nben=convert(money,0),npool=convert(money,0),                  
approved=' ',scripname=space(25),party_name=space(25),pool='P',total=convert(money,0),dummy1=space(15),dummy2=space(10),nse_approved=' ',marketrate                  
from AngelBSECM.bsedb_Ab.dbo.settlement  with (nolock) where sett_type in /* ('AD','AC')*/  
(select sett_type from AngelBSECM.account_ab.dbo.BillPosted  with (nolock) where sett_Type in ('AD','AC') and sett_no=@sett and vdt >=getdate()-1 and vdt < getdate())  
and sett_no = @sett      
and sell_buy=1                  
and auctionpart in ('FC','FS','FA')   
and marketrate=0  
                  
update #holding set isin=b.isin,series=substring(b.scripName,1,25),scripname=substring(b.scripName,1,25),dummy1=b.NseSymbol,dummy2=Nseseries                  
from intranet.risk.dbo.scrip_master b  with (nolock) where b.bsecode=#holding.scrip_Cd                  
                  
update #holding set approved='*',nse_approved='*' where scrip_Cd in                   
(Select scode collate SQL_Latin1_General_CP1_CI_AS from intranet.risk.dbo.isin  with (nolock)where app='*')                   
                  
update #holding set clsrate = b.rate,total=b.rate*qty,                  
apool=(case when approved='*' then b.rate*qty else 0 end),                  
npool=(case when approved='*' then 0 else b.rate*qty end)                  
from intranet.risk.dbo.cp b with (nolock) where #holding.scrip_cd=b.scode                  
and marketrate=0                      
  
update #holding set clsrate=clsrate+(clsrate*0.120) where marketrate=0  
update #holding set clsrate=marketrate where marketrate>0  
update #holding set total=clsrate*qty  
        
insert into BSET3Shrt_hist select *,convert(varchar(11),getdate()) from BSET3Shrt
      
truncate table BSET3Shrt               
insert into BSET3Shrt select * from #holding                  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_client_upload
-- --------------------------------------------------
CREATE procedure SCCS_client_upload (@server as varchar(20),@file as varchar(25),    
@setDate as varchar(11), @nextDate as varchar(11),    
@access_to as varchar(10),@access_code as varchar(10))    
As    
    
set nocount on   
declare @str_temp as varchar(250)    
truncate table SCCS_client_bulk_temp    
    
set @str_temp='BULK INSERT SCCS_client_bulk_temp FROM ''\\'+@server+'\D$\upload1\SCCS\'+@file+'''    
   WITH (FIELDTERMINATOR = '','',KeepNULLS)'        
exec(@str_temp)    
    
truncate table SCCS_client_bulk    
    
insert into SCCS_client_bulk(party_code) select ltrim(rtrim(party_code)) from SCCS_client_bulk_temp    
    
update SCCS_client_bulk set reason ='Already Scheduled' where SCCS_client_bulk.party_code in     
(select party_code from sccs_vw_data)    
    
update SCCS_client_bulk set reason='Not Present in Client Details' where SCCS_client_bulk.party_code not in     
(select party_code from intranet.risk.dbo.client_Details with (nolock))    
    
update SCCS_clientmaster set SCCS_SettDate_Last=convert(datetime,@setDate,103),    
SCCS_SettDate_Next=convert(datetime,@nextDate,103)    
where party_code in (select party_code from SCCS_client_bulk where isnull(reason,'')='')    
    
update SCCS_client_bulk set reason='Updated Successfully' where isnull(reason,'')='' and     
party_code in (select party_code from SCCS_clientmaster where SCCS_SettDate_Last=convert(datetime,@setDate,103) )    
    
insert into sccs_clientmaster(party_code,SCCS_SettDate_Last,SCCS_SettDate_Next)     
select party_code,convert(datetime,@setDate,103),convert(datetime,@nextDate,103) from     
(select party_code from SCCS_client_bulk where isnull(reason,'')='') a    
    
update SCCS_client_bulk set reason='New Added In SCCS Client Master' where SCCS_client_bulk.party_code    
in (select party_code from SCCS_client_bulk where isnull(reason,'')='')    
    
select party_code,reason from SCCS_client_bulk  

exec SCCS_ClientMaster_Update

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_ClientMaster_Update
-- --------------------------------------------------
CREATE procedure SCCS_ClientMaster_Update        
As                    
                    
--update SCCS_ClientMaster set Exclude='N' ,Remark='Active Client'                    
                    
/* NRI and Deactivated client excluded */                    
                    
select party_Code,Cl_type,first_active_date,last_inactive_date,pan_gir_no into #clientDetail   
from intranet.risk.dbo.Client_Details c with (nolock)                    
  
select * into #temp  
from   #clientDetail where party_code not in (select party_code from SCCS_ClientMaster)  
and first_active_date<>last_inactive_date  
  
select *,date=(select convert(varchar,max(date),103)   
FROM GetDays(first_active_date,first_active_date+90)   
where DATENAME(weekday,date)='sunday')   
into #temp1  
from   #temp   
  
  
insert into SCCS_ClientMaster  
select party_code,convert(datetime,Date,103),(select max(date)  
FROM GetDays(convert(datetime,Date,103),convert(datetime,Date,103)+90)   
where DATENAME(weekday,date)='sunday'),'','','N','Auto-System Addition','N',getdate()   
from   #temp1  where party_code not in (select party_code from SCCS_ClientMaster)  
and convert(datetime,date,103)>getdate()  
  
select party_code,Date=(select convert(varchar(11),max(date),103)  
FROM GetDays(convert(datetime,getdate(),103),convert(datetime,getdate()+7,103))   
where DATENAME(weekday,date)='sunday') into #temp2  
from   #temp1   
where convert(datetime,date,103)<getdate()  
  
  
insert into SCCS_ClientMaster  
select party_code,convert(datetime,Date,103),(select max(date)  
FROM GetDays(convert(datetime,Date,103),convert(datetime,Date,103)+90)   
where DATENAME(weekday,date)='sunday'),'','','N','Auto-System Addition(CLS Client)','N',getdate()   
from   #temp2   
where party_code not in (select party_code from SCCS_ClientMaster)  
  
select  * into #old from SCCS_ClientMaster   
where sccs_settdate_last<getdate() and sccs_settdate_last<>'Jan 19 2010'  
order by sccs_settDate_last desc  
  
/*select *  from #old  
where sccs_settdate_last>'Sep 29 2010'  
  
Process to make next settlement date available  
  
insert into SCCS_ClientMaster_hist  
select *,getdate() from #old  
  
update SCCS_ClientMaster set   
sccs_settdate_last=sccs_settdate_next,  
sccs_settdate_next=(select max(date)  
FROM GetDays(sccs_settdate_next,sccs_settdate_next+90)),  
updatedOn=getdate()  
where party_code in (select party_code from #old)  
  
  
*/  
  
/*select a.* into #notprocessed from #old a  
left outer join  
(select distinct party_code from sccs_data_hist(nolock)) b  
on a.party_code=b.party_code  
where b.party_code is null and remark  
  
select distinct remark from #notprocessed  
  
select * from #notprocessed where remark='Include'  
and sccs_settDate_last='Jan 01 1900'  
  
select * from #clientDetail   
where party_code in ( select party_code from SCCS_ClientMaster where sccs_settDate_last='Jan 01 1900')  
order by first_active_date desc  
  
  
  
select  * from SCCS_ClientMaster where remark='Include'  
and sccs_settDate_last='Jan 01 1900' and party_code not in ( select party_code from #notprocessed where remark='Include'  
and sccs_settDate_last='Jan 01 1900')  
  
select * from sccs_data_hist(nolock)  
where party_code='A023'  
  
*/  
        
update SCCS_ClientMaster set Exclude='N'        
update SCCS_ClientMaster set Exclude='Y' ,Remark='NRI Client' where party_code in (select party_code from #clientDetail where cl_type='NRI')                   
update SCCS_ClientMaster set Exclude='Y' ,Remark='PIO Client' where party_code in (select party_code from #clientDetail where cl_type='PIO')                
update SCCS_ClientMaster set Exclude='Y' ,Remark='Vandha A/c' where party_code in (select party_code from intranet.risk.dbo.vanda)                
          
/*              
update SCCS_ClientMaster set Exclude='Y' ,Remark='Deactivated Client' where party_code in           
(select party_code from #clientDetail where last_inactive_date<getdate())                    
*/                    
                    
/*Sebi banned client excluded */                    
                 
select a.*,status=0,b.party_code            
into #File_a1                          
from intranet.testdb.dbo.SEBI_banned a with (NOLOCK), #clientDetail b                          
where ltrim(rtrim(pan_gir_no))=ltrim(rtrim(pan_no))                           
and pan_no <> ''                          
            
                      
/*select party_code,pan_no                     
into #sebi                    
from #File_a1                          
 where party_code not in (select distinct party_code from intranet.testdb.dbo.Block_sbe with (NOLOCK) )                        
order by status,party_code                       
*/                    
            
update SCCS_ClientMaster set Exclude='Y' ,Remark='Sebi Banned Client' where party_code in                     
(select party_code from #File_a1 )               
              
/*Legal Client exclude*/              
update SCCS_ClientMaster set Exclude='Y' ,Remark='Legal Client' where party_code in                     
(select party_code from sccs_legalBlkClt )     
    
    
/*Exclude by CSO using exclude master*/    
update SCCS_ClientMaster set Exclude='Y' ,Remark='Exclude By CSO' where party_code in                     
(select party_code from sccs_CltExMast where excludedate<=getdate() and status='A')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_CliRecThereAfter
-- --------------------------------------------------
CREATE Procedure SCCS_CliRecThereAfter(@tdate as varchar(11))  
as  
set nocount on  
  
select distinct party_code into #BeneCli from  
(  
select cltcode as party_code from sccs_cmsdata_hist with (nolock) where  updt=@tdate  
union  
select party_code from sccs_sharepo_hist with (nolock) where  update_date=@tdate+' 23:59:59' and qty_allowed > 0  
) x  
  
  
select *,ChqAmtRecThereAfter=convert(money,0)  
into #file1  
from intranet.risk.dbo.collection_client_details with (nolock)  
where party_code in ( select party_Code from #BeneCli )  
  
update #file1 set ChqAmtRecThereAfter=x.vamt from  
(select cltcode,vamt=sum(vamt) from intranet.risk.dbo.abl_cledger where vdt >=@tdate and vtyp=2   
group by cltcode) x where #file1.party_code=x.cltcode  
  
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from  
(select cltcode,vamt=sum(vamt) from intranet.risk.dbo.nse_cledger where vdt >=@tdate and vtyp=2   
group by cltcode) x where #file1.party_code=x.cltcode  
  
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from  
(select cltcode,vamt=sum(vamt) from intranet.risk.dbo.fo_cledger where vdt >=@tdate and vtyp=2   
group by cltcode) x where #file1.party_code=x.cltcode  
  
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from  
(select cltcode,vamt=sum(vamt) from intranet.risk.dbo.mcdx_cledger where vdt >=@tdate and vtyp=2   
group by cltcode) x where #file1.party_code=x.cltcode  
  
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from  
(select cltcode,vamt=sum(vamt) from intranet.risk.dbo.ncdx_cledger where vdt >=@tdate and vtyp=2   
group by cltcode) x where #file1.party_code=x.cltcode  
  
---select * from #file1 

truncate table DKM_rpt

Insert into DKM_rpt
Select * from #file1 
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_clt_shareInfo
-- --------------------------------------------------
CREATE procedure SCCS_clt_shareInfo(
@code as varchar(11),          
@access_to as varchar(10),          
@access_code as varchar(10)   )
As
select [PartyCode]=party_code,[Scrip Code]=scrip_cd,ISIN,[Ben Client Id]=Fcltid,[Ben DP Id]=fdpid,
[Bank ID]=bankid,[Client DP ID]=cltdpid,[Quantity]=qty,[Holding]=hldval,[Quantity Allowed]=qty_allowed,
[Allowed Quantity Value]=(qty_allowed*hldval)/qty 
from sccs_sharepo 
--order by party_code
where party_code=@code

select [PartyCode]='Total ',[Scrip Code]='','',[Ben Client Id]='',[Ben DP Id]='',
[Bank ID]='',[Client DP ID]='',[Quantity]=sum(qty),[Holding]=sum(hldval),[Quantity Allowed]=sum(qty_allowed),
[Allowed Quantity Value]=sum((qty_allowed*hldval)/qty)
from sccs_sharepo 
--order by party_code
where party_code=@code
group by party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Clt_SMS_Exclude_Add
-- --------------------------------------------------
Create procedure SCCS_Clt_SMS_Exclude_Add (@date as varchar(11),@clcode as varchar(10),@remark as varchar(50),@username as varchar(10))  
As   
insert into sccs_CltExMast(Party_code,Remark,ExcludeDate,Status,UploadBy,UploadDate)   
values (@clcode,@remark,convert(datetime,@date,103),'A',@username,convert(datetime,convert(varchar(11),getdate())))

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Clt_SMS_Exclude_Upload
-- --------------------------------------------------
CREATE procedure SCCS_Clt_SMS_Exclude_Upload(@server as varchar(20),@file as varchar(25),@date as varchar(11),          
@username as varchar(10),@access_to as varchar(10),@access_code as varchar(10))          
As          
          
/*declare @server as varchar(20),@file as varchar(25),@date as varchar(11),    
@username as varchar(10),@access_to as varchar(10),@access_code as varchar(10)          
          
set @server ='196.1.115.183'          
set @file ='list.txt'     
set @date ='18/10/2010'          
set @username ='E21461'          
set @access_to ='BROKER'          
set @access_code ='CSO'*/          
          
create table #exSMSRpt          
(          
party_code varchar(10),          
Remark varchar(50)          
)          
          
create table #tempsccs_CltExMast (Party_code varchar(10),Remark varchar(50) )          
          
declare @str_temp as varchar(500)                      
set @str_temp='create table #tempsccs_CltExMast (Party_code varchar(10),Remark varchar(50))          
BULK INSERT #tempsccs_CltExMast FROM ''\\'+ltrim(rtrim(@server))+'\D$\upload1\'+@file+'''                
   WITH (FIELDTERMINATOR = '','',KeepNULLS)          
select party_code,Remark from #tempsccs_CltExMast'            
                  
insert into #tempsccs_CltExMast exec(@str_temp)            
          
declare @exdate as datetime,@udate as datetime     
set @exdate=convert(datetime,@date,103)     
set @udate=convert(datetime,@date,103)           
          
if @access_to='BROKER'          
begin          
insert into #exSMSRpt           
select party_code,'Client Does not Exist' from #tempsccs_CltExMast           
where party_code not in (select party_code from intranet.risk.dbo.client_details with (nolock))          
          
insert into #exSMSRpt         
select party_code,'Remark Not Present' from #tempsccs_CltExMast         
where len(ltrim(rtrim(remark))) > 1

insert into #exSMSRpt         
select party_code,'Already excluded' from #tempsccs_CltExMast         
where party_code in (select distinct party_code from sccs_CltExMast where status='A')

delete from #tempsccs_CltExMast where party_code in (select party_code from #exSMSRpt )          
          
insert into sccs_CltExMast (Party_code,Remark,ExcludeDate,Status,UploadBy,UploadDate)    
select Party_code,Remark,@exdate,'A',@username,@udate from #tempsccs_CltExMast          
where party_Code not in (select party_code from sccs_CltExMast(nolock) where status='A')          
end           
else if @access_to='Region'          
begin          
          
insert into #exSMSRpt           
select party_code,'Does Not Belong To Region '+@access_code+'' from #tempsccs_CltExMast           
where party_code not in (select party_code from intranet.risk.dbo.client_details with (nolock)           
where region=(select distinct region from intranet.risk.dbo.REGION with (nolock) where reg_code=@access_code))          
         
insert into #exSMSRpt         
select party_code,'Remark Not Present' from #tempsccs_CltExMast         
where len(ltrim(rtrim(remark))) > 1

insert into #exSMSRpt         
select party_code,'Already excluded' from #tempsccs_CltExMast         
where party_code in (select distinct party_code from sccs_CltExMast where status='A')
 
delete from #tempsccs_CltExMast where party_code in (select party_code from #exSMSRpt )          
          
insert into sccs_CltExMast(Party_code,Remark,ExcludeDate,Status,UploadBy,UploadDate)           
select Party_code,Remark,@exdate,'A',@username,@udate from #tempsccs_CltExMast where party_code not in           
(select party_code from sccs_CltExMast(nolock) where status='S')          
          
end          
else if @access_to='BRMAST'          
begin          
          
insert into #exSMSRpt           
select party_code,'Does Not Belong To BranchMast '+@access_code+'' from #tempsccs_CltExMast           
where party_code not in (select party_code from intranet.risk.dbo.client_details with (nolock)           
where branch_cd in (select branch_cd COLLATE SQL_Latin1_General_CP1_CI_As           
from intranet.risk.dbo.branch_master with (nolock)                                 
 where brmast_cd= @access_code))          
          
insert into #exSMSRpt         
select party_code,'Remark Not Present' from #tempsccs_CltExMast         
where len(ltrim(rtrim(remark))) > 1

insert into #exSMSRpt         
select party_code,'Already excluded' from #tempsccs_CltExMast         
where party_code in (select distinct party_code from sccs_CltExMast where status='A')

delete from #tempsccs_CltExMast where party_code in (select party_code from #exSMSRpt )          
          
insert into sccs_CltExMast  (Party_code,Remark,ExcludeDate,Status,UploadBy,ploadDate)         
select Party_code,Remark,@exdate,'A',@username,@udate from #tempsccs_CltExMast where party_code not in           
(select party_code from sccs_CltExMast(nolock) where status='A')          
          
end          
else if @access_to='BRANCH'          
begin          
          
insert into #exSMSRpt           
select party_code,'Does Not Belong To Branch '+@access_code+'' from #tempsccs_CltExMast           
where party_code not in (select party_code from intranet.risk.dbo.client_details with (nolock)           
where branch_cd = @access_code)          
          
insert into #exSMSRpt         
select party_code,'Remark Not Present' from #tempsccs_CltExMast         
where len(ltrim(rtrim(remark))) > 1

insert into #exSMSRpt         
select party_code,'Already excluded' from #tempsccs_CltExMast         
where party_code in (select distinct party_code from sccs_CltExMast where status='A')

delete from #tempsccs_CltExMast where party_code in (select party_code from #exSMSRpt )          
          
insert into sccs_CltExMast  (Party_code,Remark,ExcludeDate,Status,UploadBy,UploadDate)         
select Party_code,Remark,@exdate,'A',@username,@udate from #tempsccs_CltExMast where party_code not in           
(select party_code from sccs_CltExMast(nolock) where status='A')          
end          
    
select party_code ,Remark from #exSMSRpt

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_cmsData_process
-- --------------------------------------------------
CREATE procedure SCCS_cmsData_process(@processtype as varchar(1))                          
as                          
Set nocount on                      
  
truncate table sccs_cmsdata                
                  
select Party_code,BSECM_Ledger+BSECM_deposit as BSECM_ledger,NSECM_Ledger+NSECM_Deposit as NSECM_Ledger,        
NSEFO_Ledger+NSEFO_Deposit as NSEFO_Ledger,MCDX_Ledger,NCDX_Ledger,        
MCD_Ledger+MCD_Deposit as MCD_Ledger,NSX_Ledger+NSX_Deposit as NSX_Ledger,Net_Credit,                          
Cal_Net=Net_Credit+AccrualAmt--1000                         
into #sccs_data                      
from sccs_data (nolock) where net_credit < AccrualAmt*(-1)--(-1000)                  
                        
select Party_code,BSECM_Ledger,NSECM_Ledger,NSEFO_Ledger,MCDX_Ledger,NCDX_Ledger,MCD_Ledger,NSX_Ledger,Net_Credit,                          
Cal_Net=Cal_Net                        
into #file1                          
from #sccs_data (nolock) /* where net_credit<0 */                         
                          
select Party_code,BSECM_Ledger,NSECM_Ledger,NSEFO_Ledger,MCDX_Ledger,NCDX_Ledger,MCD_Ledger,NSX_Ledger,Net_Credit,                          
Cal_Net=Cal_Net                       
into #file                          
from #sccs_data (nolock) /* where net_credit<0 */                      
                          
---BSE                                     
update #file set BSECM_Ledger=                        
case                         
when BSECM_Ledger<0 and Cal_Net<0 and BSECM_Ledger<Cal_Net then Cal_Net                                     
when BSECM_Ledger<0 and Cal_Net<0 and BSECM_Ledger>=Cal_Net then BSECM_Ledger else 0 end                            
                                    
update #file set Cal_Net=Cal_Net-BSECM_Ledger                                    
---NSE                                    
update #file set NSECM_Ledger=case when NSECM_Ledger<0 and Cal_Net<0 and NSECM_Ledger<Cal_Net then Cal_Net                                     
when  NSECM_Ledger<0 and Cal_Net<0 and NSECM_Ledger>=Cal_Net then NSECM_Ledger else 0 end                            
                                    
update #file set Cal_Net=Cal_Net-NSECM_Ledger                                    
---FO                                    
update #file set NSEFO_Ledger=case when NSEFO_Ledger<0 and Cal_Net<0 and NSEFO_Ledger<Cal_Net then Cal_Net                                     
when  NSEFO_Ledger<0 and Cal_Net<0 and NSEFO_Ledger>=Cal_Net then NSEFO_Ledger else 0 end                            
                                    
update #file set Cal_Net=Cal_Net-NSEFO_Ledger                                    
                        
---MCX                                    
update #file set MCDX_Ledger=case when MCDX_Ledger<0 and Cal_Net<0 and MCDX_Ledger<Cal_Net then Cal_Net                                     
when  MCDX_Ledger<0 and Cal_Net<0 and MCDX_Ledger>=Cal_Net then MCDX_Ledger else 0 end                            
                                    
update #file set Cal_Net=Cal_Net-MCDX_Ledger                                    
---NCDX                                    
update #file set NCDX_Ledger=case when NCDX_Ledger<0 and Cal_Net<0 and NCDX_Ledger<Cal_Net then Cal_Net                                     
when  NCDX_Ledger<0 and Cal_Net<0 and NCDX_Ledger>=Cal_Net then NCDX_Ledger else 0 end                            
                                    
update #file set Cal_Net=Cal_Net-NCDX_Ledger                                    
                                    
---MCD                                    
update #file set MCD_Ledger=case when MCD_Ledger<0 and Cal_Net<0 and MCD_Ledger<Cal_Net then Cal_Net                                     
when  MCD_Ledger<0 and Cal_Net<0 and MCD_Ledger>=Cal_Net then MCD_Ledger else 0 end                            
                                    
update #file set Cal_Net=Cal_Net-MCD_Ledger                                    
---NSX                                    
update #file set NSX_Ledger=case when NSX_Ledger<0 and Cal_Net<0 and NSX_Ledger<Cal_Net then Cal_Net                                     
when  NSX_Ledger<0 and Cal_Net<0 and NSX_Ledger>=Cal_Net then NSX_Ledger else 0 end                           
                                    
update #file set Cal_Net=Cal_Net-NSX_Ledger          
                          
insert into sccs_cmsdata(updt,cltcode,chqamt,holding,family,acdlcm_amt,acdlfo_amt,ablcm_amt,maker,                          
generated,ncdx_amt,mcdx,mcd_amt,nsx_amt)                          
select convert(datetime,convert(varchar(11),getdate())),party_Code,            
chqamt=(-1*BSECM_Ledger)+(-1*NSECM_Ledger)+(-1*NSEFO_Ledger)+(-1*MCDX_Ledger)+(-1*NCDX_Ledger)+(-1*MCD_Ledger)+(-1*NSX_Ledger),                           
0,0,(-1*NSECM_Ledger),(-1*NSEFO_Ledger),(-1*BSECM_Ledger),'system',1,0,0,                        
/* NCDX_Ledger,MCDX_Ledger */                        
(-1*MCD_Ledger),(-1*NSX_Ledger)                          
from #file                          
                          
update sccs_cmsdata set acdl_actbal=isnull(NSECM_Ledger*-1,0),abl_Actbal=isnull(BSECM_Ledger*-1,0),            
fo_actbal=isnull(NSEFO_Ledger*-1,0),ncdx_Actbal=isnull(NCDX_Ledger*-1,0),mcdx_Actbal=isnull(MCDX_Ledger*-1,0),            
mcd_Actbal=isnull(MCD_Ledger*-1,0),nsx_Actbal=isnull(NSX_Ledger*-1,0)            
from #file1 where sccs_cmsdata.cltcode=#file1.party_code and updt=convert(varchar(11),getdate())                          
            
update sccs_cmsdata set acdl_effbal=isnull(acdl_effbal,0),            
abl_effbal=isnull(abl_effbal,0),chqamt=isnull(chqamt,0),holding=isnull(holding,0),eff_fambal=isnull(eff_fambal,0),            
act_fambal=isnull(act_fambal,0),fo_effbal=isnull(fo_effbal,0),acdlcm_amt=isnull(acdlcm_amt,0),            
acdlfo_amt=isnull(acdlfo_amt,0),ablcm_amt=isnull(ablcm_amt,0),ncdx_effbal=isnull(ncdx_effbal,0),            
mcdx_effbal=isnull(mcdx_effbal,0),ncdx_amt=isnull(ncdx_amt,0),mcdx=isnull(mcdx,0),mcd_effbal=isnull(mcd_effbal,0),            
mcd_amt=isnull(mcd_amt,0),nsx_effbal=isnull(nsx_effbal,0),nsx_amt=isnull(nsx_amt,0) ,checker='system'           
            
update sccs_cmsdata set branch=branch_cd,subgroup=sub_broker,party_name=long_name                           
from intranet.risk.dbo.client_details c with (nolock) where sccs_cmsdata.cltcode=c.party_code                          
and updt=convert(varchar(11),getdate())            
    
insert into sccs_CMS_online_Marked_hist    
select * from sccs_cms_online_marked    
      
truncate table sccs_CMS_online_Marked      
insert into sccs_CMS_online_Marked      
select a.cltcode,Paymode,bank_name,accno,chqamt,getdate(),'A','N','SCCS','',getdate()      
from sccs_cmsdata a,(select * from intranet.cms.dbo.SCCS_OnlineClient) b      
where a.cltcode=b.cltcode      
      
if @processtype='F'  
begin      
 insert into sccs_cmsdata_hist select * from sccs_cmsdata      
end      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_CMSDATA_SMS
-- --------------------------------------------------
CREATE procedure SCCS_CMSDATA_SMS
as

set nocount off

SELECT TOP 0 *,party_code=space(10) into #sms FROM INTRANET.SMS.DBO.SMS
insert into #sms
select b.mobile_pager,
MSG='Dear Client, Payout of Funds/Securities due after retaining margins as per SEBI Circular dt 3/12/09 is done,. Contact your BM/RM Rgds Angel Broking.',
[DATE]=CONVERt(VARCHAR(10),UPDT,103),
[Time]=convert(varchar(2),case when datename(hh,GETDATE()) > 12 then datename(hh,GETDATE())-12 else datename(hh,GETDATE()) end )
+':'+case when len(datename(mi,GETDATE()))=1 then '0'+datename(mi,GETDATE()) else datename(mi,GETDATE()) end,
Flag='P',
PMAM=case when datepart(hh,GETDATE()) > 12 then 'PM' else 'AM' end,
Purpose='SEBI Circular Funds Payout',cltcode
from sccs_cmsdata a with (nolock) , 
(select party_Code,mobile_pager from intranet.risk.dbo.client_DEtails with (nolock) where len(mobile_pager)=10 and 
substring(mobile_pager,1,1) in ('9','8')
) b  where
a.cltcode=b.party_Code and a.checker='system'

update sccs_cmsdata set checker=checker+'_SMS' from #sms b where sccs_cmsdata.cltcode=b.party_Code

insert into INTRANET.SMS.DBO.SMS select to_no,message,date,time,flag,ampm,purpose from #sms

set nocount on

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Data_Calculation_rpt
-- --------------------------------------------------
CREATE procedure SCCS_Data_Calculation_rpt (     
@date as varchar(11),     
@EntityCode as varchar(10),     
@EntityType as varchar(10),     
@FilterEntity as varchar(10),     
@type as varchar(4),     
@rtFlag as varchar(2),     
@pFlag as varchar(2),   
@access_to as varchar(10),     
@access_code as varchar(10)     
)     
As     
--select top 5 * from SCCS_Data     
    
--declare    
--@DATE as varchar(11),     
--@EntityCode as varchar(25),    
--@EntityType as varchar(10),    
--@FilterEntity as varchar(10),    
--@type as varchar(10),    
--@rtFlag as varchar(2),     
--@access_to as varchar(10),    
--@access_code as varchar(25)    
--    
--set @DATE ='sep 04 2010'     
--set @EntityCode='%'    
--set @EntityType='BRANCH'    
--set @FilterEntity='Branch'    
--set @type='%'    
--set @rtFlag='h'    
--set @access_to ='broker'    
--set @access_code ='cso'    
     
declare @filename as varchar(500),@vwFile as varchar(1000)    
if @rtFlag='h'     
Begin     
 set @vwFile='(select t.*,[Blocked Funds],[Holding Value],[payout Value] from #temp t left outer join #vwFile v (nolock)    
 on t.party_Code=v.party_code)'    
 set @filename = ' SCCS_Vw_Data s (nolock) left outer join RMS_Client_Vertical r (nolock) on s.party_code=r.client'    
End     
else if @rtFlag='c'    
Begin     
 set @vwFile='(select t.*,[Blocked Funds],[Holding Value],[payout Value] from #temp t left outer join vw_sccs_po_summary v (nolock)    
 on t.party_Code=v.party_code)'    
 set @filename = ' SCCS_Data s (nolock) left outer join RMS_Client_Vertical r (nolock) on s.party_code=r.client'    
End     
     
declare @Source as varchar(2000),@DataFltr1 as varchar(500)    
set @Source =''     
set @DataFltr1 = ''    
     
if @type='B2B'     
BEGIN     
 set @DataFltr1 = ' Sb not in (select B2C_SB from #file1) '     
END     
ELSE if @type='B2C'    
BEGIN     
 set @DataFltr1 = ' Sb in (select B2C_SB from #file1) '     
END    
Else    
BEGIN     
 set @DataFltr1 = ' Sb like ''%'' '     
END     
     
if @access_to='SB'     
begin     
set @Source = 'select * into #tempfrom '+@filename+' where'+@DataFltr1+' and convert(datetime,convert(varchar(11),update_date))=convert(datetime,'''+@date+''')    
and '+@FilterEntity+' like '''+@EntityCode+''' and '+@access_to+' like '''+@access_code+''''     
end     
if @access_to='BROKER'     
begin     
 set @Source = 'select * into #temp from '+@filename+' where'+@DataFltr1+' and convert(datetime,convert(varchar(11),update_date))=convert(datetime,'''+@date+''')    
and '+@FilterEntity+' like '''+@EntityCode+''''     
end     
if(@access_to='BRANCH')    
begin     
 select @Source = 'select * into #temp from '+@filename+' where '+@DataFltr1+' and convert(datetime,convert(varchar(11),update_date))=convert(datetime,'''+@date+''')    
and '+@FilterEntity+' like '''+@EntityCode+''' and '+@access_to+' like '''+@access_code+''''    
end    
if(@access_to='BRMAST')     
begin    
select @Source = 'select * into #temp from '+@filename+' where '+@DataFltr1+' and convert(datetime,convert(varchar(11),update_date))=convert(datetime,'''+@date+''')    
and '+@FilterEntity+' like '''+@EntityCode+''' and'+@EntityType+' in (select branch_cd COLLATE    
SQL_Latin1_General_CP1_CI_As from intranet.risk.dbo.branch_master with (nolock)    
 where brmast_cd= '''+@access_code+''')'    
end     
if(@access_to='REGION')    
begin     
select @Source = 'select * into #temp from '+@filename+' where '+@DataFltr1+' and convert(datetime,convert(varchar(11),update_date))>=convert(datetime,'''+@date+''')    
and'+@EntityType+' in (select CODE collate SQL_Latin1_General_CP1_CI_AS from intranet.risk.dbo.REGION with (nolock)     
where REG_CODE= '''+@access_code+''')'     
end    
if(@access_to='SBMAST')     
begin     
select @Source = 'select * into #tempfrom '+@filename+' where '+@DataFltr1+'and convert(varchar(11),update_date)='''+@date+'''     
and '+@EntityType+' in (select sub_broker from intranet.risk.dbo.sb_master with (nolock) where sbmast_cd= '''+@access_code+''')'    
end    
     
     
DECLARE @FinSumm as nvarchar(max) ,@vwTbl as varchar(2000)    
    
set @vwTbl='create table #vwFile (Party_code varchar(10),[Blocked Funds] money,[Holding Value] money,[payout Value] money)    
insert into #vwFile exec vw_sccs_po_summary_hist_proc '''+@date+''''    
    
if(@rtFlag='h')    
begin    
set @source=@vwTbl+@source    
end    
   --[Unsett.Credit Var Margin]=BSECM_Var+NSECM_Var     
   --[Intraday_Cash_Margin]=intra_hghmrg_cash
set @FinSumm = @Source +' '+'select B2C_SB into #file1 from mis.remisior.dbo.b2c_sb with (nolock)     
select distinct     
Sett_date=update_date     
,ClientName = Party_name     
,ClientCode=a.party_code     
,NetFundsPO =case when net_credit<0 then net_credit else 0 end     
,NetSecPo=''<a href=''''report.aspx?reportno=395&code=''+a.party_code+'' ''''>''    
 +convert(varchar(15),convert(decimal(15,2),[payout Value]))+''</a>''    
,NetLedger=BSECM_Ledger+NSECM_Ledger+NSEFO_Ledger+MCDX_Ledger+NCDX_Ledger+MCD_Ledger+NSX_Ledger    
,Deposit= BSECM_Deposit+NSECM_Deposit+NSEFO_Deposit+MCD_Deposit+NSX_Deposit    
,Margin=NSEFO_Margin+MCD_Margin+NSX_MArgin --commodity margin    
,[Unsett Sell Del. Val]=BSECM_Var+NSECM_Var    
,[Unsettl.Debit Bill]=BSECM_USD+NSECM_USD     
,[75% of Margin Block]=Total_Marg75     
,[Intraday_FO_Margin] = intra_hghmrg_fo     
,[Last Day CM TO]=intra_hghmrg_cash     
,[Auction Debit]=BSECM_Shrtval+NSECM_ShrtVal     
,[OtherSegment Debit]=(case when mcdx_ledger+ncdx_ledger > 0 then mcdx_ledger+ncdx_ledger else 0 end)    
,[Accrual Block]=[Blocked Funds]    
,[Total Hold]=[Holding Value]    
,Region    
,Branch    
,SubBroker=sb     
,ClientType = case when SB in (select B2C_SB collate SQL_Latin1_General_CP1_CI_AS from #file1) then ''B2C'' else ''B2B'' end     
,NextSettDate=convert(varchar(11),b.sccs_settDate_next)    
from '+@vwFile+' a left outer join sccs_clientmaster b (nolock)    
on a.party_code=b.party_code     
'    
  
declare @postQry as varchar(100)  
if @pFlag='a'     
Begin     
 set @postQry=''  
End     
else if @pFlag='p'    
Begin     
 set @postQry='and net_credit>0 and convert(decimal(15,2),[payout Value])<>0'  
End     
     
   set @FinSumm=@FinSumm+@postQry  
     
--print(@FinSumm)    
    
EXECUTE sp_executesql @FinSumm     
--execute sp_execute exec(@FinSumm)    
     
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_dkm__CliRecThereAfter
-- --------------------------------------------------
CREATE Procedure SCCS_dkm__CliRecThereAfter(@tdate as varchar(11))      
as      
set nocount on      
      
Select distinct Party_code into #BeneCli   
from  dkm_sccs_mis where update_date = @tdate and ([Funds Payout] < 0 or [Payout Value] > 0)     
      
      
Select *,ChqAmtRecThereAfter = convert(money,0)      
into #file1      
from intranet.risk.dbo.collection_client_details with (nolock)      
where party_code in ( Select Party_Code from #BeneCli )      
      
update #file1 set ChqAmtRecThereAfter=x.vamt from      
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.abl_cledger where vdt >=@tdate and vtyp=2       
group by cltcode) x where #file1.party_code=x.cltcode      
      
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from      
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.nse_cledger where vdt >=@tdate and vtyp=2       
group by cltcode) x where #file1.party_code=x.cltcode      
      
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from      
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.fo_cledger where vdt >=@tdate and vtyp=2       
group by cltcode) x where #file1.party_code=x.cltcode      
      
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from      
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.mcdx_cledger where vdt >=@tdate and vtyp=2       
group by cltcode) x where #file1.party_code=x.cltcode      
      
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from      
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.ncdx_cledger where vdt >=@tdate and vtyp=2       
group by cltcode) x where #file1.party_code=x.cltcode      
      
---Select * from #file1     
    
truncate table DKM_rpt    
    
Insert into DKM_rpt    
Select * from #file1     
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_dkm_CliRecThereAfter
-- --------------------------------------------------
CREATE Procedure SCCS_dkm_CliRecThereAfter(@tdate as varchar(11))        
as        
set nocount on        
        
Select distinct Party_code into #BeneCli     
from  dkm_sccs_mis where update_date = @tdate and ([Funds Payout] < 0 or [Payout Value] > 0)       
        
        
Select *,ChqAmtRecThereAfter = convert(money,0)        
into #file1        
from intranet.risk.dbo.collection_client_details with (nolock)        
where party_code in ( Select Party_Code from #BeneCli )        
        
update #file1 set ChqAmtRecThereAfter=x.vamt from        
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.abl_cledger where vdt >=@tdate and vtyp=2         
group by cltcode) x where #file1.party_code=x.cltcode        
        
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from        
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.nse_cledger where vdt >=@tdate and vtyp=2         
group by cltcode) x where #file1.party_code=x.cltcode        
        
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from        
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.fo_cledger where vdt >=@tdate and vtyp=2         
group by cltcode) x where #file1.party_code=x.cltcode        
        
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from        
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.mcdx_cledger where vdt >=@tdate and vtyp=2         
group by cltcode) x where #file1.party_code=x.cltcode        
        
update #file1 set ChqAmtRecThereAfter=ChqAmtRecThereAfter+x.vamt from        
(Select cltcode,vamt=sum(vamt) from intranet.risk.dbo.ncdx_cledger where vdt >=@tdate and vtyp=2         
group by cltcode) x where #file1.party_code=x.cltcode        
        
---Select * from #file1       
      
truncate table DKM_rpt1      
      
Insert into DKM_rpt1      
Select * from #file1       
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_ExcludeClt_Rpt
-- --------------------------------------------------
CREATE procedure SCCS_ExcludeClt_Rpt(@EntityCode as varchar(10),@FilterEntity as varchar(10),@EntityType as varchar(10),@access_to as varchar(10),@access_code as varchar(10))          
as          
          
declare @sql as varchar(2000),@sqlFin as varchar(3500),@sqlMid as varchar(1000)          
          
set @sql='select Zone,Region,Branch,Subbroker=sb,ClientCode=party_code,Remark,                 
ExcludeDate=convert(varchar(11),ExcludeDate),ExcludedBy=convert(varchar(50),uploadby)         
into #temp        
from sccs_CltExMast a left outer join RMS_Client_Vertical b           
on a.party_code=b.client           
where status=''A'' '          
          
if @access_to='Broker'          
begin          
set @sql = @sql + 'and '+@FilterEntity+' like '''+@EntityCode+''' '          
end          
if @access_to='Region'          
begin          
set @sql = @sql + 'and '+@FilterEntity+' like '''+@EntityCode+''' and replace(region,'' '','''') in           
(select distinct replace(REGION,'' '','''') from intranet.risk.dbo.REGION with (nolock) where reg_code='''+@access_code+''')'          
end          
if @access_to='BRMAST'          
begin          
set @sql = @sql + 'and '+@FilterEntity+' like '''+@EntityCode+''' and  branch in           
(select branch_cd COLLATE SQL_Latin1_General_CP1_CI_As             
from intranet.risk.dbo.branch_master with (nolock)                                   
 where brmast_cd= '''+@access_code+''')  '          
end          
if @access_to='BRANCH'          
begin          
set @sql = @sql + 'and  '+@FilterEntity+' like '''+@EntityCode+''' and '+@access_to+' = '''+@access_code+''''          
end          
            
set @sqlMid = 'update #temp set ExcludedBy=excludedby +'' ''+ emp_name from intranet.risk.dbo.emp_info 
where emp_no=excludedby '        
        
set @sqlFin=@sql + @sqlMid + 'select * from #temp'          
exec (@sqlFin)      
--print @sqlFin

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Free1100Check
-- --------------------------------------------------
CREATE Procedure SCCS_Free1100Check      
as      
set nocount on      
      
select party_Code into #sccscli from sccs_data      
      
select a.party_code,accno,scrip_cd,series,isin,qty,total,nse_Approved into #holding from intranet.risk.dbo.holding a with (nolock) left outer join #sccscli b       
on a.party_code=b.party_code where b.party_code is null      
and a.accno <> ''      
      
update #holding set nse_approved=0      
update #holding set nse_approved=1 where scrip_cd in ( select scode from intranet.risk.dbo.icici_scp with (nolock) )                
update #holding set nse_approved=2 where scrip_cd in ( select scode from intranet.risk.dbo.HDFC_scp with (nolock) ) AND nse_approved=0      
update #holding set nse_approved=3 where scrip_cd in ( select scode from intranet.risk.dbo.kotak_scp with (nolock) ) AND nse_approved=0      
      
/* select nse_approved,value=sum(total)/10000000 from #holding WITH (NOLOCK) group by nse_approved */      
      
select * into #file from vw_sccs_po_summary      
      
SELECT party_Code,SCRIP_cD,hLDvAL,pAYOUTvAL,(hLDvAL-pAYOUTvAL) AS REVvAL,APP=0 INTO #FILE4 FROM Vw_SCCS_RawSharePODetails where FCLTID<> '15464303'      
update #FILE4 set APP=1 where scrip_cd in (select scode from intranet.risk.dbo.icici_scp with (nolock))                
update #FILE4 set APP=2 where scrip_cd in ( select scode from intranet.risk.dbo.HDFC_scp with (nolock) ) AND APP=0      
update #FILE4 set APP=3 where scrip_cd in ( select scode from intranet.risk.dbo.kotak_scp with (nolock)) AND APP=0                
      
/*      
select APP,sum([hLDvAL])/10000000 as TotalHolding,sum([pAYOUTvAL])/10000000 as TotalPayout,sum([REVvAL])/10000000 as BlockedPO,      
from #file4 group by app      
*/      
      
truncate table SCCS_1100check

insert into SCCS_1100check      
select /*sum(Value-TotalPayout) as FreeAppHoldValue */    
*,Update_date=convert(varchar(11),getdate()) from      
(select nse_approved,value=sum(total)/10000000 from #holding WITH (NOLOCK) /*where nse_approved in (1,2,3)*/ group by nse_approved) a left  outer join    
(select APP,sum([hLDvAL])/10000000 as TotalHolding,sum([pAYOUTvAL])/10000000 as TotalPayout,sum([REVvAL])/10000000 as BlockedPO      
from #file4 group by app) b      
on a.nse_Approved=b.app   order by nse_approved  
    
--select * from SCCS_1100check  
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Free1100Check_report
-- --------------------------------------------------
CREATE procedure SCCS_Free1100Check_report(@access_to as varchar(10),@access_code as varchar(10))
as
select Bank=case when nse_approved=0 then 'Non Approved' 
				when nse_approved=1 then 'ICICI Bank' 
				when nse_approved=2 then 'HDFC Bank' 
				when nse_approved=3 then 'KOTAK Bank'
				else '' end,[Total Holding]=value,[Payout Holding]=totalpayout,[Balance Hold]=value-totalpayout
				,[Approved Amount]=case when nse_approved=0 then 0 else value-totalpayout end
				into #f from SCCS_1100check
				
select * from #f

select Bank='',[Total Holding]=sum([Total Holding]),[Payout Holding]=sum([Payout Holding]),[Balance Hold]=sum([Balance Hold])
				,[Approved Amount]=sum([Approved Amount])
				from #f

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_GenerateJv
-- --------------------------------------------------
CREATE procedure SCCS_GenerateJv(@server as varchar(20),@segment as varchar(10),@date as varchar(11))          
As     
--declare @server as varchar(20),@segment as varchar(10),@date as varchar(11)
--set @server='196.1.115.183'
--set @segment='BSECM'
--set @date='14/09/2010'

Set nocount on 

select x.Fld_FromCode,x.Fld_Markamt,y.* into #x from                    
(select * from temp_tbl_SCCS_Jv (nolock) where FLD_VALIDJV = 'Y'   
/* and Fld_FromSegment = @Segment */  
/*AND Fld_JVDate >= convert(varchar(11),getdate())*/ )x                    
inner join                    
(select * from SCCS_tbl_JVControlMaster (nolock))y on x.Fld_FromSegment = y.Fld_FromSegment                     
and x.Fld_ToSegment = y.Fld_ToSegment               
          
      
--select top 0 * into tblFileSCCS from jvfile.dbo.tblFileMFSS          
          
Create table #JV                    
(                    
Fld_SrNo int identity(1,1),                    
Fld_FromCode varchar(25),                    
Fld_ControlAc varchar(25),                    
Fld_DrCr varchar(2),                    
Fld_MarkAmt money,                    
Fld_Narration varchar(100)                    
)                    
                    
insert into #JV                    
select Fld_FromCode,Fld_FromCode,'D',Fld_MarkAmt,Fld_FromNarration+' '+Fld_FromCode                    
from #x where Fld_FromSegment = @Segment                    
union all                    
select Fld_FromCode,convert(varchar,Fld_ToControlAc),'D',Fld_MarkAmt,Fld_ToNarration+' '+Fld_FromCode                    
from #x where Fld_ToSegment = @Segment                    
                    
                    
select x.Fld_SrNo,x.Fld_FromCode,y.Fld_FromControlAc,'C' as DrCr,x.Fld_MarkAmt,y.Narration into #y                     
from                    
(select * from #JV)x                    
inner join                    
(                    
select Fld_FromCode,Fld_FromControlAc=convert(varchar,Fld_FromControlAc),                    
Fld_FromNarration+' '+Fld_FromCode as Narration,Fld_MarkAmt                    
from #x where Fld_FromSegment = @Segment                    
union all                    
select Fld_FromCode,Fld_FromCode,                    
Fld_ToNarration+' '+Fld_FromCode as Narration,Fld_MarkAmt                    
from #x where Fld_ToSegment = @Segment                    
)y on x.Fld_FromCode = Y.Fld_FromCode and x.Fld_Narration = y.Narration                    
                    
truncate table dbo.tblFileSCCS                    
                    
insert into dbo.tblFileSCCS                                                                    
select  'srno,Vdate,Edate,cltcode,Drcr,Amount,Narration,branchcode'                      
                    
insert into dbo.tblFileSCCS                    
Select ltrim(rtrim(convert(varchar,Fld_SrNo)))+','+@date+','                    
+@date+','+ltrim(rtrim(Fld_ControlAc))+','+ltrim(rtrim(Fld_drcr))+','                                                                    
+ltrim(rtrim(convert(varchar,Fld_MarkAmt)))+','+ltrim(rtrim(Fld_Narration))+',ALL' from                    
(                    
select * from #jv                    
union                     
select * from #y                    
) x order by Fld_SrNo,Fld_DrCr           
          
select flddata from tblFileSCCS  (nolock)    
    
---------------------------------        
--Declare @s as varchar(1000)             
--Declare @s1 as varchar(1000)            
--Declare @file as varchar(50)          
--          
--set @file = (select 'SCCS_GeneratedJv_'+@Segment+'_'+replace(convert(varchar(11),getdate(),103),'/','')+'.csv')            
--                    
--set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Flddata FROM SCCS.dbo.tblFileSCCS(nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                                                                                                 
  
      
--set @s1= @s+''''                                      
--exec(@s1)    
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_GenerateJv_Deposit
-- --------------------------------------------------
CREATE procedure SCCS_GenerateJv_Deposit(@server as varchar(20),@segment as varchar(10),@date as varchar(11))              
As          
set nocount on             
declare @ledger as varchar(25)--,@server as varchar(20),@segment as varchar(10)        
declare @str as varchar(1000)        
        
      
if(@segment='BSECM')        
begin         
set @str='        
select Party_code,BSECM_Ledger,BSECM_Deposit          
from sccs_data (nolock)        
where BSECM_Deposit<>0'          
end        
if(@segment='NSECM')        
begin         
set @str='        
select Party_code,NSECM_Ledger,NSECM_Deposit          
from sccs_data (nolock)        
where NSECM_Deposit<>0'              
end        
if(@segment='NSEFO')        
begin         
set @str='        
select Party_code,NSEFO_Ledger,NSEFO_Deposit          
from sccs_data (nolock)        
where NSEFO_Deposit<>0'             
end        
if(@segment='MCD')        
begin         
set @str='        
select Party_code,MCD_Ledger,MCD_Deposit          
from sccs_data (nolock)        
where MCD_Deposit<>0'              
end        
if(@segment='NSX')        
begin         
set @str='        
select Party_code,NSX_Ledger,NSX_Deposit          
from sccs_data (nolock)        
where NSX_Deposit<>0'               
end        
      
        
select top 0 Party_code,Ledger=bsecm_ledger,Deposit=bsecm_deposit        
into #file        
from sccs_data        
        
insert into #file exec (@str)        

alter table #file add ID int identity(1,1)      
      
select Fld_SrNo=ID,Fld_FromCode=Party_code,Fld_drcr=DRCR,Fld_MarkAmt=Amt into #JV from       
(      
select ID,Party_code,DRCR='C',Amt=deposit*-1 from #file  where deposit<0      
union all      
select ID,Party_code='30'+Party_code,DRCR='D',Amt=deposit*-1 from #file  where deposit<0      
union all      
select ID,Party_code,DRCR='D',Amt=deposit from #file  where deposit>0      
union all      
select ID,Party_code='30'+Party_code,DRCR='C',Amt=deposit from #file  where deposit>0      
 ) a      
order by ID,DRCR      
        
truncate table dbo.tblFileSCCS_Deposit        
                        
insert into dbo.tblFileSCCS_Deposit                                                                        
select  'srno,Vdate,Edate,cltcode,Drcr,Amount,Narration,branchcode'                          
                        
insert into dbo.tblFileSCCS_deposit                       
Select ltrim(rtrim(convert(varchar,Fld_SrNo)))+','+@date+','                        
+@date+','+ltrim(rtrim(Fld_FromCode))+','+ltrim(rtrim(Fld_drcr))+','                                                                        
+ltrim(rtrim(convert(varchar,Fld_MarkAmt)))+',AMT TRF from  Deposit A/C,ALL' from                        
(                        
select Fld_SrNo,Fld_FromCode,Fld_drcr,Fld_MarkAmt=case when Fld_MarkAmt<0 then -1*Fld_MarkAmt else Fld_MarkAmt end from #jv                        
) x order by Fld_SrNo,Fld_DrCr        
              
select Flddata from tblFileSCCS_Deposit          
        
----------------------------------------------            
--Declare @s as varchar(1000)                 
--Declare @s1 as varchar(1000)                
--Declare @file as varchar(50)              
--              
--set @file = (select 'SCCS_GeneratedJv_'+@Segment+'_Deposit_'+replace(convert(varchar(11),getdate(),103),'/','')+'.csv')                
--                        
--set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Flddata FROM SCCS.dbo.tblFileSCCS_deposit(nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                                                                                         
--          
--set @s1= @s+''''                                          
--exec(@s1)        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_GenerateJv22072018
-- --------------------------------------------------
CREATE procedure SCCS_GenerateJv22072018(@server as varchar(20),@segment as varchar(10),@date as varchar(11))          
As     
--declare @server as varchar(20),@segment as varchar(10),@date as varchar(11)
--set @server='196.1.115.183'
--set @segment='BSECM'
--set @date='23/07/2018'

Set nocount on 

select x.Fld_FromCode,x.Fld_Markamt,y.* into #x from                    
(select * from temp_tbl_SCCS_Jv (nolock) where FLD_VALIDJV = 'Y'   
/* and Fld_FromSegment = @Segment */  
/*AND Fld_JVDate >= convert(varchar(11),getdate())*/ )x                    
inner join                    
(select * from SCCS_tbl_JVControlMaster (nolock))y on x.Fld_FromSegment = y.Fld_FromSegment                     
and x.Fld_ToSegment = y.Fld_ToSegment               
      
--select top 0 * into tblFileSCCS from jvfile.dbo.tblFileMFSS          
          
Create table #JV                    
(                    
Fld_SrNo int identity(1,1),                    
Fld_FromCode varchar(25),                    
Fld_ControlAc varchar(25),                    
Fld_DrCr varchar(2),                    
Fld_MarkAmt money,                    
Fld_Narration varchar(100)                    
)                    
                    
insert into #JV                    
select Fld_FromCode,Fld_FromCode,'D',Fld_MarkAmt,Fld_FromNarration+' '+Fld_FromCode                    
from #x where Fld_FromSegment = @Segment                    
union all                    
select Fld_FromCode,convert(varchar,Fld_ToControlAc),'D',Fld_MarkAmt,Fld_ToNarration+' '+Fld_FromCode                    
from #x where Fld_ToSegment = @Segment                    
                    
                    
select x.Fld_SrNo,x.Fld_FromCode,y.Fld_FromControlAc,'C' as DrCr,x.Fld_MarkAmt,y.Narration into #y                     
from                    
(select * from #JV)x                    
inner join                    
(                    
select Fld_FromCode,Fld_FromControlAc=convert(varchar,Fld_FromControlAc),                    
Fld_FromNarration+' '+Fld_FromCode as Narration,Fld_MarkAmt                    
from #x where Fld_FromSegment = @Segment                    
union all                    
select Fld_FromCode,Fld_FromCode,                    
Fld_ToNarration+' '+Fld_FromCode as Narration,Fld_MarkAmt                    
from #x where Fld_ToSegment = @Segment                    
)y on x.Fld_FromCode = Y.Fld_FromCode and x.Fld_Narration = y.Narration                    
                    
truncate table dbo.tblFileSCCS                    
                    
insert into dbo.tblFileSCCS                                                                    
select  'srno,Vdate,Edate,cltcode,Drcr,Amount,Narration,branchcode'                      
                    
insert into dbo.tblFileSCCS                    
Select ltrim(rtrim(convert(varchar,Fld_SrNo)))+','+@date+','                    
+@date+','+ltrim(rtrim(Fld_ControlAc))+','+ltrim(rtrim(Fld_drcr))+','                                                                    
+ltrim(rtrim(convert(varchar,Fld_MarkAmt)))+','+ltrim(rtrim(Fld_Narration))+',ALL' from                    
(                    
select * from #jv                    
union                     
select * from #y                    
) x order by Fld_SrNo,Fld_DrCr           
          
select flddata from tblFileSCCS  (nolock)    

Select sum(Fld_MarkAmt) As Amount from  #jv  
---------------------------------        
--Declare @s as varchar(1000)             
--Declare @s1 as varchar(1000)            
--Declare @file as varchar(50)          
--          
--set @file = (select 'SCCS_GeneratedJv_'+@Segment+'_'+replace(convert(varchar(11),getdate(),103),'/','')+'.csv')            
--                    
--set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Flddata FROM SCCS.dbo.tblFileSCCS(nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                         
  
      
--set @s1= @s+''''                                      
--exec(@s1)    
    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_GeneratePledge
-- --------------------------------------------------
CREATE procedure SCCS_GeneratePledge(@server as varchar(20))        
As
Set nocount on        

Select top 0 * into #tblFileSCCSPledgeGen from tblFileSCCS
                  
insert into dbo.#tblFileSCCSPledgeGen                  
Select ltrim(rtrim(convert(varchar,Scrip_Cd)))+','+ltrim(rtrim(isin))+','                  
+ltrim(rtrim(party_code))+','+ltrim(rtrim(Accno))+','+ltrim(rtrim(qty))+'' from                  
(                  
select * from tblSCCSPledge_data  (nolock)              
) x order by party_code,accno,qty        
        
select flddata from #tblFileSCCSPledgeGen  
  
---------------------------------      
--Declare @s as varchar(1000)           
--Declare @s1 as varchar(1000)          
--Declare @file as varchar(50)        
--        
--set @file = (select 'SCCS_GeneratedPledge_'+replace(convert(varchar(11),getdate(),103),'/','')+'.csv')          
--                  
--set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Flddata FROM SCCS.dbo.tblFileSCCSPledgeGen (nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                                                                                                 
    
--set @s1= @s+''''                                    
--exec(@s1)  
  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_GeneratePledge19072017
-- --------------------------------------------------
CREATE procedure SCCS_GeneratePledge19072017(@server as varchar(20))        
As
Set nocount on        

Select top 0 * into #tblFileSCCSPledgeGen from tblFileSCCS
                  
insert into dbo.#tblFileSCCSPledgeGen                  
Select ltrim(rtrim(convert(varchar,Scrip_Cd)))+','+ltrim(rtrim(isin))+','                  
+ltrim(rtrim(party_code))+','+ltrim(rtrim(Accno))+','+ltrim(rtrim(qty))+'' from                  
(                  
select * from tblSCCSPledge_data  (nolock)              
) x order by party_code,accno,qty        
        
select flddata from #tblFileSCCSPledgeGen  
  
---------------------------------      
--Declare @s as varchar(1000)           
--Declare @s1 as varchar(1000)          
--Declare @file as varchar(50)        
--        
--set @file = (select 'SCCS_GeneratedPledge_'+replace(convert(varchar(11),getdate(),103),'/','')+'.csv')          
--                  
--set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT Flddata FROM SCCS.dbo.tblFileSCCSPledgeGen (nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                                                                                       
          
    
--set @s1= @s+''''                                    
--exec(@s1)  
  
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sccs_init_cms_online_marked_1
-- --------------------------------------------------
create procedure sccs_init_cms_online_marked_1 (@bank as varchar(10))      
as      
insert into sccs_cms_online_marked_hist select * from sccs_cms_online_marked  where bank_name like @bank    
delete from sccs_cms_online_marked  where bank_name like @bank

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sccs_init_cms_online_marked_NEFT
-- --------------------------------------------------
CREATE procedure sccs_init_cms_online_marked_NEFT (@bank as varchar(10))        
as        
insert into sccs_cms_online_marked_hist select * from sccs_cms_online_marked  where payMode=@bank    
delete from sccs_cms_online_marked  where  payMode=@bank

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_JvProcessed_Data
-- --------------------------------------------------
CREATE procedure SCCS_JvProcessed_Data          
As         

Set nocount on 
insert into temp_tbl_SCCS_Jv_hist select * from temp_tbl_SCCS_Jv  
truncate table temp_tbl_SCCS_Jv  
  
select Party_code,BSECM_Net,NSECM_Net,NSEFO_Net,MCD_Net,NSX_Net,Net_Credit,          
Cal_Net=Net_Credit          
into #file          
from sccs_data (nolock) --where net_credit<0           
--select distinct (update_date) from sccs_data          
                 
select *,bse_nse=convert(money,0),bse_fo=convert(money,0),bse_mcd=convert(money,0),bse_nsx=convert(money,0)          
,nse_bse=convert(money,0),nse_fo=convert(money,0),nse_mcd=convert(money,0),nse_nsx=convert(money,0)          
,fo_nse=convert(money,0),fo_bse=convert(money,0),fo_mcd=convert(money,0),fo_nsx=convert(money,0)          
,mcd_nse=convert(money,0),mcd_bse=convert(money,0),mcd_fo=convert(money,0),mcd_nsx=convert(money,0)          
,nsx_nse=convert(money,0),nsx_bse=convert(money,0),nsx_mcd=convert(money,0),nsx_fo=convert(money,0)          
into #t1          
from #file          
          
---BSE           
          
update #t1        
set   bse_nse=case when BSECM_Net<0 and NSECM_Net>0 then         
case when (BSECM_Net*-1)<=NSECM_Net then BSECM_Net*-1 else NSECM_Net end      
else 0 end      
where BSECM_Net<0      
      
update #t1 set BSECM_Net=BSECM_Net+bse_nse where BSECM_Net<0      
update #t1 set NSECM_Net=NSECM_Net-bse_nse where BSECM_Net<0      
      
update #t1        
set bse_fo=case when BSECM_Net<0 and NSEFO_Net>0 then         
case when (BSECM_Net*-1)<=NSEFO_Net then BSECM_Net*-1 else NSEFO_Net end      
else 0 end      
where BSECM_Net<0      
      
update #t1 set BSECM_Net=BSECM_Net+bse_fo where BSECM_Net<0      
update #t1 set NSEFO_Net=NSEFO_Net-bse_fo where BSECM_Net<0      
      
update #t1        
set bse_mcd=case when BSECM_Net<0 and mcd_Net>0 then         
case when (BSECM_Net*-1)<=mcd_Net then BSECM_Net*-1 else mcd_Net end      
else 0 end      
where BSECM_Net<0      
      
update #t1 set BSECM_Net=BSECM_Net+bse_mcd where BSECM_Net<0      
update #t1 set mcd_Net=mcd_Net-bse_mcd where BSECM_Net<0      
      
update #t1        
set bse_nsx=case when BSECM_Net<0 and nsx_Net>0 then         
case when (BSECM_Net*-1)<=nsx_Net then BSECM_Net*-1 else nsx_Net end      
else 0 end      
where BSECM_Net<0      
      
update #t1 set BSECM_Net=BSECM_Net+bse_nsx where BSECM_Net<0      
update #t1 set nsx_Net=nsx_Net-bse_nsx where BSECM_Net<0      
      
---NSE           
          
update #t1        
set   nse_bse=case when NSECM_Net<0 and BSECM_Net>0 then         
case when (NSECM_Net*-1)<=BSECM_Net then NSECM_Net*-1 else BSECM_Net end      
else 0 end      
where NSECM_Net<0      
      
update #t1 set NSECM_Net=NSECM_Net+nse_bse where NSECM_Net<0      
update #t1 set BSECM_Net=BSECM_Net-nse_bse where NSECM_Net<0      
      
update #t1        
set nse_fo=case when NSECM_Net<0 and NSEFO_Net>0 then         
case when (NSECM_Net*-1)<=NSEFO_Net then NSECM_Net*-1 else NSEFO_Net end      
else 0 end      
where NSECM_Net<0    
      
update #t1 set NSECM_Net=NSECM_Net+nse_fo where NSECM_Net<0      
update #t1 set NSEFO_Net=NSEFO_Net-nse_fo where NSECM_Net<0      
      
update #t1        
set Nse_mcd=case when NSECM_Net<0 and mcd_Net>0 then         
case when (NSECM_Net*-1)<=mcd_Net then NSECM_Net*-1 else mcd_Net end      
else 0 end      
where NSECM_Net<0    
      
update #t1 set NSECM_Net=NSECM_Net+nse_mcd where NSECM_Net<0      
update #t1 set mcd_Net=mcd_Net-nse_mcd where NSECM_Net<0      
      
update #t1        
set nse_nsx=case when NSECM_Net<0 and nsx_Net>0 then         
case when (NSECM_Net*-1)<=nsx_Net then NSECM_Net*-1 else nsx_Net end      
else 0 end      
where NSECM_Net<0    
      
update #t1 set NSECM_Net=NSECM_Net+nse_nsx where NSECM_Net<0      
update #t1 set nsx_Net=nsx_Net-nse_nsx where NSECM_Net<0      
      
---FO           
          
update #t1        
set   fo_bse=case when NSEFO_Net<0 and BSECM_Net>0 then         
case when (NSEFO_Net*-1)<=BSECM_Net then NSEFO_Net*-1 else BSECM_Net end      
else 0 end      
where NSEFO_Net<0      
      
update #t1 set NSEFO_Net=NSEFO_Net+fo_bse where NSEFO_Net<0      
update #t1 set BSECM_Net=BSECM_Net-fo_bse where NSEFO_Net<0      
      
update #t1        
set fo_nse=case when NSEFO_Net<0 and NSECM_Net>0 then         
case when (NSEFO_Net*-1)<=NSECM_Net then NSEFO_Net*-1 else NSECM_Net end      
else 0 end      
where NSEFO_Net<0      
      
update #t1 set NSEFO_Net=NSEFO_Net+fo_nse where NSEFO_Net<0      
update #t1 set NSECM_Net=NSECM_Net-fo_nse where NSEFO_Net<0      
      
update #t1        
set fo_mcd=case when NSEFO_Net<0 and mcd_Net>0 then         
case when (NSEFO_Net*-1)<=mcd_Net then NSEFO_Net*-1 else mcd_Net end      
else 0 end      
where NSEFO_Net<0      
      
update #t1 set NSEFO_Net=NSEFO_Net+fo_mcd where NSEFO_Net<0      
update #t1 set mcd_Net=mcd_Net-fo_mcd where NSEFO_Net<0      
      
update #t1        
set fo_nsx=case when NSEFO_Net<0 and nsx_Net>0 then         
case when (NSEFO_Net*-1)<=nsx_Net then NSEFO_Net*-1 else nsx_Net end      
else 0 end     
where NSEFO_Net<0      
      
update #t1 set NSEFO_Net=NSEFO_Net+fo_nsx where NSEFO_Net<0      
update #t1 set nsx_Net=nsx_Net-fo_nsx where NSEFO_Net<0      
      
---MCD       
          
update #t1        
set   mcd_bse=case when MCD_Net<0 and BSECM_Net>0 then         
case when (MCD_Net*-1)<=BSECM_Net then MCD_Net*-1 else BSECM_Net end      
else 0 end      
where MCD_Net<0      
      
update #t1 set MCD_Net=MCD_Net+mcd_bse where MCD_Net<0      
update #t1 set BSECM_Net=BSECM_Net-mcd_bse where MCD_Net<0      
      
update #t1        
set mcd_nse=case when MCD_Net<0 and NSECM_Net>0 then         
case when (MCD_Net*-1)<=NSECM_Net then MCD_Net*-1 else NSECM_Net end      
else 0 end      
where MCD_Net<0      
      
update #t1 set MCD_Net=MCD_Net+mcd_nse where MCD_Net<0      
update #t1 set NSECM_Net=NSECM_Net-mcd_nse where MCD_Net<0      
      
update #t1        
set mcd_fo=case when MCD_Net<0 and NSEFO_Net>0 then         
case when (MCD_Net*-1)<=NSEFO_Net then MCD_Net*-1 else mcd_Net end      
else 0 end      
where MCD_Net<0      
      
update #t1 set MCD_Net=MCD_Net+mcd_fo where MCD_Net<0      
update #t1 set NSEFO_Net=NSEFO_Net-mcd_fo where MCD_Net<0      
      
update #t1        
set mcd_nsx=case when MCD_Net<0 and nsx_Net>0 then         
case when (MCD_Net*-1)<=nsx_Net then MCD_Net*-1 else nsx_Net end      
else 0 end     
where MCD_Net<0      
      
update #t1 set MCD_Net=MCD_Net+mcd_nsx where MCD_Net<0      
update #t1 set nsx_Net=nsx_Net-mcd_nsx where MCD_Net<0      
      
      
---NSX       
          
update #t1        
set   nsx_bse=case when NSX_Net<0 and BSECM_Net>0 then         
case when (NSX_Net*-1)<=BSECM_Net then NSX_Net*-1 else BSECM_Net end      
else 0 end      
where NSX_Net<0      
      
update #t1 set NSX_Net=NSX_Net+nsx_bse where NSX_Net<0      
update #t1 set BSECM_Net=BSECM_Net-nsx_bse where NSX_Net<0      
      
      
update #t1        
set nsx_nse=case when NSX_Net<0 and NSECM_Net>0 then         
case when (NSX_Net*-1)<=NSECM_Net then NSX_Net*-1 else NSECM_Net end      
else 0 end      
where NSX_Net<0      
      
update #t1 set NSX_Net=NSX_Net+nsx_nse where NSX_Net<0      
update #t1 set NSECM_Net=NSECM_Net-nsx_nse where NSX_Net<0      
      
update #t1        
set nsx_fo=case when NSX_Net<0 and NSEFO_Net>0 then         
case when (NSX_Net*-1)<=NSEFO_Net then NSX_Net*-1 else NSEFO_Net end      
else 0 end      
where NSX_Net<0      
      
update #t1 set NSX_Net=NSX_Net+nsx_fo where NSX_Net<0      
update #t1 set NSEFO_Net=NSEFO_Net-nsx_fo where NSX_Net<0      
      
update #t1        
set nsx_mcd=case when NSX_Net<0 and MCD_Net>0 then         
case when (NSX_Net*-1)<=MCD_Net then NSX_Net*-1 else MCD_Net end      
else 0 end     
where NSX_Net<0     
      
update #t1 set NSX_Net=NSX_Net+nsx_mcd where NSX_Net<0      
update #t1 set MCD_Net=MCD_Net-nsx_mcd where NSX_Net<0      
      
          
truncate table temp_tbl_SCCS_Jv          
          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'BSECM','NSECM',bse_nse,'Y',getdate()  from #t1 where  bse_nse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'BSECM','NSEFO',bse_fo,'Y',getdate()   from #t1 where  bse_fo<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'BSECM','MCD',bse_mcd,'Y',getdate()   from #t1 where  bse_mcd<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'BSECM','NSX',bse_nsx,'Y',getdate()   from #t1 where  bse_nsx<>0          
          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSECM','BSECM',nse_bse,'Y',getdate()  from #t1 where  nse_bse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSECM','NSEFO',nse_fo,'Y',getdate()   from #t1 where  nse_fo<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSECM','MCD',nse_mcd,'Y',getdate()   from #t1 where  nse_mcd<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSECM','NSX',nse_nsx,'Y',getdate()   from #t1 where  nse_nsx<>0          
          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSEFO','BSECM',fo_bse,'Y',getdate()   from #t1 where  fo_bse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSEFO','NSECM',fo_nse,'Y',getdate()   from #t1 where  fo_nse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSEFO','MCD',fo_mcd,'Y',getdate()   from #t1 where  fo_mcd<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSEFO','NSX',fo_nsx,'Y',getdate()   from #t1 where  fo_nsx<>0          
          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'MCD','BSECM',mcd_bse,'Y',getdate()   from #t1 where  mcd_bse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'MCD','NSECM',mcd_nse,'Y',getdate()   from #t1 where  mcd_nse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'MCD','NSEFO',mcd_fo,'Y',getdate()   from #t1 where  mcd_fo<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'MCD','NSX',mcd_nsx,'Y',getdate()   from #t1 where  mcd_nsx<>0          
          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSX','BSECM',nsx_bse,'Y',getdate()   from #t1 where  nsx_bse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSX','NSECM',nsx_nse,'Y',getdate()   from #t1 where  nsx_nse<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSX','NSEFO',nsx_fo,'Y',getdate()   from #t1 where  nsx_fo<>0          
insert into temp_tbl_SCCS_Jv (Fld_JVDate,Fld_FromCode,Fld_ToCode,Fld_FromSegment,Fld_ToSegment,Fld_MarkAmt,Fld_ValidJv,Fld_VerifyTime)          
select getdate(),party_code,party_code,'NSX','MCD',nsx_mcd,'Y',getdate()   from #t1 where  nsx_mcd<>0       
      
      
delete from temp_tbl_SCCS_Jv where Fld_MarkAmt<100
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_NSEAuctionInfo
-- --------------------------------------------------
CREATE procedure [dbo].[SCCS_NSEAuctionInfo]                      
as                      
  
set nocount on  
      
declare @nor as int,@sett as varchar(7)                  
select @sett=max(sett_no) from AngelNseCM.msajag.dbo.settlement where sett_type in ('A','X')     
select @nor=count(1) from AngelNseCM.account.dbo.BillPosted where sett_Type in ('A','X') and sett_no=@sett    
  
select top 0 *,marketRate=convert(money,0) into #holding from intranet.risk.dbo.holding with (nolock) where 1=2                      
  
insert into #holding                      
select                       
isin=space(15),                      
scrip_cd,                      
series,                      
sett_no,                      
sett_type,                      
party_code,                      
bs='S',exchange='NSE',qty=-tradeqty,                      
clsrate=convert(money,0),                      
accno='',dpid='',clid='',flag='',aben=convert(money,0),apool=convert(money,0),nben=convert(money,0),npool=convert(money,0),                      
approved=' ',scripname=space(25),party_name=space(25),pool='P',total=convert(money,0),dummy1=scrip_cd,dummy2=series,nse_approved=' ',marketRate  
from AngelNseCM.msajag.dbo.settlement where sett_type in   
/* ('A','X') */  
(select sett_type from AngelNseCM.account.dbo.BillPosted where sett_Type in ('A','X') and sett_no=@sett and vdt >=getdate())  
-- and sett_no in  (select sett_no from Nse_sett_mst (nolock) where sec_payout like convert(varchar(11),getdate())+'%' and sett_type='N')                      
and sett_no = @sett  
and sell_buy=1                      
and auctionpart in ('FC','FS','FA')      
  
  
insert into #holding                      
select                       
isin=space(15),                      
scrip_cd,                      
series,                      
sett_no,                      
sett_type,                      
party_code,                      
bs='S',exchange='NSE',qty=-tradeqty,                      
clsrate=convert(money,0),                      
accno='',dpid='',clid='',flag='',aben=convert(money,0),apool=convert(money,0),nben=convert(money,0),npool=convert(money,0),                      
approved=' ',scripname=space(25),party_name=space(25),pool='P',total=convert(money,0),dummy1=scrip_cd,dummy2=series,nse_approved=' ',marketRate  
from AngelNseCM.msajag.dbo.settlement where sett_type in   
/* ('A','X') */  
(select sett_type from AngelNseCM.account.dbo.BillPosted where sett_Type in ('A','X') and sett_no=@sett and vdt >=getdate()-1 and vdt < getdate())  
-- and sett_no in  (select sett_no from Nse_sett_mst (nolock) where sec_payout like convert(varchar(11),getdate())+'%' and sett_type='N')                      
and sett_no = @sett  
and sell_buy=1                      
and auctionpart in ('FC','FS','FA')      
and marketrate=0  
  
  
  
update #holding set scrip_Cd=isnull(b.bsecode,b.nsesymbol),isin=b.isin,series=substring(b.scripName,1,25),scripname=substring(b.scripName,1,25)                      
from intranet.risk.dbo.scrip_master  b with (nolock) where b.nsesymbol=#holding.dummy1 and b.nseseries=#holding.dummy2                       
  
update #holding set approved='*',nse_approved='*' where scrip_Cd in                       
(Select scode collate SQL_Latin1_General_CP1_CI_AS from intranet.risk.dbo.isin with (nolock) where app='*')                       
  
update #holding set clsrate = b.rate,total=b.rate*qty,                      
apool=(case when approved='*' then b.rate*qty else 0 end),                      
npool=(case when approved='*' then 0 else b.rate*qty end)                      
from intranet.risk.dbo.cp b with (nolock) where #holding.scrip_cd=b.scode                      
and marketrate=0                      
  
update #holding set clsrate = b.cls,total=b.cls*qty,                      
apool=(case when approved='*' then b.cls*qty else 0 end),                      
npool=(case when approved='*' then 0 else b.cls*qty end)                      
from intranet.risk.dbo.md b with (nolock) where #holding.dummy1=b.scrip and #holding.dummy2=b.series                     
and #holding.clsrate=0                      
and marketrate=0  
  
update #holding set clsrate=clsrate+(clsrate*0.120) where marketrate=0  
update #holding set clsrate=marketrate where marketrate>0  
update #holding set total=clsrate*qty  
  
insert into NSET3Shrt_hist select *,convert(varchar(11),getdate()) from NSET3Shrt

truncate table NSET3Shrt                   
insert into NSET3Shrt select * from #holding                      
  
  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_OnlineMarking1
-- --------------------------------------------------
CREATE Procedure [dbo].[SCCS_OnlineMarking1](@bank varchar(6))                                                                        
as                                                                    
set nocount on                                                              
declare @gdate as datetime                                                        
if @bank='HDFC'                                                                        
begin                                                                    
                                                          
 Set transaction isolation level read uncommitted                                                                    
 select * into #hdfc1 from (                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                        
 select --Name,                                                                    
  Refno,amt=isnull(ablcm_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ABLCM' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a,                                                                        
 (select cltcode,ablcm_amt from sccs_cmsdata (nolock) where ablcm_amt>0 and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from AngelBseCM.account_ab.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                                                     
                                                          
 union                                                                    
                                                                     
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(acdlcm_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ACDLCM' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a                                                                    
 ,                                                                     
 (select cltcode,acdlcm_amt from sccs_cmsdata (nolock) where acdlcm_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from AngelNseCM.account.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                                                     
 union                                                                    
                                                                     
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                     
  RefNo,amt=isnull(acdlfo_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ACDLFO' from             
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a                           
 ,                                                                  
 (select cltcode,acdlfo_amt from sccs_cmsdata (nolock) where acdlfo_amt>0  and generated<2) b                                                               
 where a.cltcode=b.cltcode                                                         
 ) a                         
 left outer join                                                                    
 (select longname,cltcode from angelfo.accountfo.dbo.acmast )b                          
 on a.cltcode=b.cltcode                                                                     
 union                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                   
 (                                     
 select --Name,                                                                    
  RefNo,amt=isnull(ncdx_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='NCDX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a                                                                    
 ,                                                                     
 (select cltcode,ncdx_amt from sccs_cmsdata (nolock) where ncdx_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                            
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from angelcommodity.accountncdx.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                                        
 union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                             
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(mcdx,0),a.cltcode,accno=isnull(accno,'Missing'),co='MCX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a                                                                    
 ,                                                                    
 (select cltcode,mcdx from sccs_cmsdata (nolock) where mcdx>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                        
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from angelcommodity.accountmcdx.dbo.acmast )b                                                            
 on a.cltcode=b.cltcode              
 union                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                   
 (                                     
 select --Name,                                                                    
  RefNo,amt=isnull(nsx_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='NSX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a                                       
 ,                                                                     
 (select cltcode,nsx_amt from sccs_cmsdata (nolock) where nsx_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                 
 ) a                 
left outer join                                                                    
 (select longname,cltcode from angelfo.accountcurfo.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode               
 union                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                   
 (                                     
 select --Name,                                                                    
RefNo,amt=isnull(mcd_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='MCD' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%HDFC%' and AmtMarked>0 and flag='A' and chqMark='N' and PayMode='AOFT') a                                                                    
 ,                                                                     
 (select cltcode,mcd_amt from sccs_cmsdata (nolock) where mcd_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                            
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from angelcommodity.accountmcdxcds.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode     ) a                                                                     
 left outer join                                                                    
 (select branch,city,OurAccno=accno,segment,bank from intranet.cms.dbo.CMS_online_Bank_mast with (nolock ))b                                                                        
  on a.co=b.segment and b.bank='HDFC'                                                                      
          
/*update sccs_cmsdata_Before_after_Adj_online  set generated=2  where updatedon>=convert(varchar(11),getdate())           
and updatedon<=convert(varchar(11),getdate())+' 23:59:59'          
and cltcode in (select cltcode from #hdfc1)     */      
                                                              
 update sccs_cmsdata set generated=2 where cltcode in (select cltcode from #hdfc1)                                                              
 /*update sccs_cmsdata_request set generated=2 where cltcode in (select cltcode from #hdfc1)                                                                    */      
                                              
 set @gdate=getdate()                                                        
                                                    
 insert into SCCS_ONFT_BankFile_hist select * from SCCS_ONFT_BankFile  where  bank='HDFC'                                                           
 delete from sccs_ONFT_BankFile where bank='HDFC'                                                      
                                                             
 insert into sccs_ONFT_BankFile                                                           
 select GeneratedDate=@gdate,* from #hdfc1                                                               
                                                          
 select * from #hdfc1  where amt>=5.00  order by cltcode                                                               
      
end                                            
                                                            
                                                                    
if @bank='ICICI'                                                
begin                                                                    
 Set transaction isolation level read uncommitted                              
                                               
 select * into #icici1 from (                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                            
  RefNo,amt=isnull(ablcm_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ABLCM' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                              
 ,                                                                    
 (select cltcode,ablcm_amt from sccs_cmsdata (nolock) where ablcm_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                         
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from AngelBseCM.account_ab.dbo.acmast )b                                 
 on a.cltcode=b.cltcode                                                                     
 union                                                                    
                   
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                     
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(acdlcm_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ACDLCM' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                                                                    
 ,                                                                     
 (select cltcode,acdlcm_amt from sccs_cmsdata (nolock) where acdlcm_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from AngelNseCM.account.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                                                     
 union                                                                    
                                                                     
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                           
 (                                                                    
  select --Name,                                                                    
  RefNo,amt=isnull(acdlfo_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ACDLFO' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                                                                    
 ,                               
 (select cltcode,acdlfo_amt from sccs_cmsdata (nolock) where acdlfo_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode        
 ) a                                                                    
 left outer join                                                                    
 (select longname,cltcode from angelfo.accountfo.dbo.acmast )b                
 on a.cltcode=b.cltcode                                               
 union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                
 select --Name,                                                                    
  RefNo,amt=isnull(ncdx_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='NCDX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                                                                    
 ,                                                                     
 (select cltcode,ncdx_amt from sccs_cmsdata (nolock) where ncdx_amt>0  and generated<2) b                                                          
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join                                                          
 (select longname,cltcode from angelcommodity.accountncdx.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                                                     
 union                                                  
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(mcdx,0),a.cltcode,accno=isnull(accno,'Missing'),co='MCX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                                                                    
 ,                                                                
 (select cltcode,mcdx from sccs_cmsdata (nolock) where mcdx>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join                                                                  
 (select longname,cltcode from angelcommodity.accountmcdx.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode              
union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(nsx_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='NSX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                                                                    
 ,                                                   
 (select cltcode,nsx_amt from sccs_cmsdata (nolock) where nsx_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                   ) a                                                                    
 left outer join                                                                  
 (select longname,cltcode from angelfo.accountcurfo.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode              
union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(mcd_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='MCD' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where bank_name like '%ICICI%' and AmtMarked>0 and flag='A' and isnull(chqMark,'N')='N' and PayMode='AOFT') a                                                                    
 ,                                                                
 (select cltcode,mcd_amt from sccs_cmsdata (nolock) where mcd_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                         
 left outer join                                                                  
 (select longname,cltcode from angelcommodity.accountmcdxcds.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode              
 ) a                                                                    
 left outer join                                                                    
 (select branch,city,OurAccno=accno,segment,bank from intranet.cms.dbo.CMS_online_Bank_mast with (nolock ))b                                                                        
  on a.co=b.segment and b.bank='ICICI'                                               
          
/*update sccs_cmsdata_Before_after_Adj_online  set generated=2  where updatedon>=convert(varchar(11),getdate())           
and updatedon<=convert(varchar(11),getdate())+' 23:59:59'          
and cltcode in (select cltcode from #icici1)     */      
                                                              
 update sccs_cmsdata set generated=2 where cltcode in (select cltcode from #icici1)                                                             
 /*update sccs_cmsdata_request set generated=2 where cltcode in (select cltcode from #icici1)                                                                                */      
 set @gdate=getdate()                                                        
                                                        
                                                    
 insert into SCCS_ONFT_BankFile_hist select * from SCCS_ONFT_BankFile   where bank='ICICI'                                                         
                                                    
delete from sccs_ONFT_BankFile where bank='ICICI'                                                   
insert into sccs_ONFT_BankFile                                                           
 select GeneratedDate=@gdate,* from #icici1                                                          
                                                          
 --select * from #icici1    order by cltcode                                     
                                
select a.*,email=isnull(email,'') from #icici1 a                                
left outer join                        
(select distinct party_code,email from intranet.risk.dbo.client_details with (nolock) where repatriat_bank_ac_no like 'ECN%') b                                
on a.cltcode=b.party_code                               
where amt>=5.00                             
order by cltcode                                 
--where bank='ICICI'                                
                                                   
end                                               
                                            
if @bank='NEFT'                                          
begin                                                                    
                                              
                                          
 Set transaction isolation level read uncommitted                                                
 select *,IFSC_code=space(50) into #neft from (                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
                                                          
 select --Name,                                                                    
  Refno,amt=isnull(ablcm_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ABLCM' from                                                   
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a,                                                                        
 (select cltcode,ablcm_amt from sccs_cmsdata (nolock) where ablcm_amt>0 and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                               
 left outer join                                                                    
 (select longname=ltrim(rtrim(longname)),cltcode from AngelBseCM.account_ab.dbo.acmast )b                                                              on a.cltcode=b.cltcode                                                                     
                                                          
 union                                                                    
                                                  
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(acdlcm_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ACDLCM' from                                                                 
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a                                                               
 ,                                                                     
 (select cltcode,acdlcm_amt from sccs_cmsdata (nolock) where acdlcm_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                               
 left outer join                                                                    
 (select longname=ltrim(rtrim(longname)),cltcode from AngelNseCM.account.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                       
 union                                                                    
                                                                     
 select RefNo,Name=longname,amt,a.cltcode,accno,co from             
 (                                                          
 select --Name,                                                                    
  RefNo,amt=isnull(acdlfo_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='ACDLFO' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a                                   
 ,                                                                  
 (select cltcode,acdlfo_amt from sccs_cmsdata (nolock) where acdlfo_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join           
 (select longname=ltrim(rtrim(longname)),cltcode from angelfo.accountfo.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                                                                     
 union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(ncdx_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='NCDX' from                                        
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a                               
 ,                                                                     
 (select cltcode,ncdx_amt from sccs_cmsdata (nolock) where ncdx_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                                                                    
 ) a                                                                    
 left outer join                                                                    
 (select longname=ltrim(rtrim(longname)),cltcode from angelcommodity.accountncdx.dbo.acmast )b                                                                     
 on a.cltcode=b.cltcode                          
 union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(mcdx,0),a.cltcode,accno=isnull(accno,'Missing'),co='MCX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a                                                                    
 ,                                                                    
 (select cltcode,mcdx from sccs_cmsdata (nolock) where mcdx>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                 
              
  ) a                                                                    
 left outer join              
 (select longname=ltrim(rtrim(longname)),cltcode from angelcommodity.accountmcdx.dbo.acmast )b                                                            
 on a.cltcode=b.cltcode                   
union                                                                    
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                           
  RefNo,amt=isnull(mcd_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='MCD' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a                                                                    
 ,                                                                    
 (select cltcode,mcd_amt from sccs_cmsdata (nolock) where mcd_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                 
  ) a                
                                                                   
 left outer join                                                                    
 (select longname=ltrim(rtrim(longname)),cltcode from angelcommodity.accountmcdxcds.dbo.acmast )b                                                            
 on a.cltcode=b.cltcode              
union                                                  
 select RefNo,Name=longname,amt,a.cltcode,accno,co from                                                                    
 (                                                                    
 select --Name,                                                                    
  RefNo,amt=isnull(nsx_amt,0),a.cltcode,accno=isnull(accno,'Missing'),co='NSX' from                                                                    
 (select * from Vw_Gen_CMS_online_Marked(nolock) where  PayMode='NEFT' and AmtMarked>0 and flag='A' and chqMark='N' ) a                                                                    
 ,                                                                    
 (select cltcode,nsx_amt from sccs_cmsdata (nolock) where nsx_amt>0  and generated<2) b                                                                    
 where a.cltcode=b.cltcode                 
  ) a                
                                                       
 left outer join                                                                    
 (select longname=ltrim(rtrim(longname)),cltcode from angelfo.accountcurfo.dbo.acmast )b                                                            
 on a.cltcode=b.cltcode ) a                                                                 
 /*left outer join                                                                    
 (select branch,city,OurAccno=accno,segment,bank from intranet.cms.dbo.CMS_online_Bank_mast (nolock ))b                                                                        
  on a.co=b.segment and b.bank='HDFC'                            */                                          
                                                              
/*update sccs_cmsdata_Before_after_Adj_online  set generated=2  where updatedon>=convert(varchar(11),getdate())           
and updatedon<=convert(varchar(11),getdate())+' 23:59:59'          
and cltcode in (select cltcode from #neft)     */      
                                                             
 update sccs_cmsdata set generated=2 where cltcode in (select cltcode from #neft)                                                              
 /*update sccs_cmsdata_request set generated=2 where cltcode in (select cltcode from #neft)                                                                    */      
           
          
          
 set @gdate=getdate()                                         
                    
--select top 5 * from risk.dbo.v_rtgs_client                    
                                                   
 update  #neft set IFSC_code=rtrim(ltrim(b.IFSC_code)) from    
 /*(  
select fld_party_code,Fld_bank_Acno,b.bank_name,Branch_name,IFSC_Code,MICR_Code from     
(select fld_party_code,fld_rtgs_sr_no,Fld_bank_Acno from intranet.risk.dbo.tbl_rtgs_clients with (nolock) where fld_status='A') a,    
intranet.risk.dbo.rtgs_master b with (nolock) where a.fld_rtgs_sr_no=b.sr_no    
) */ intranet.risk.dbo.v_rtgs_client b   
 where #neft.cltcode=b.fld_party_code                                      
 and #neft.accno=b.fld_bank_acno           
  
  
           
 insert into sccs_NEFT_BankFile_hist select * from SCCS_NEFT_BankFile                                               
 delete from sccs_NEFT_BankFile                                          
                      
                                                             
 insert into sccs_NEFT_BankFile                                                           
 select GeneratedDate=getdate(),RefNo=max(RefNo),Name,amt,cltcode,accno,co,branch_cd,sub_broker,party_code,l_address1,    l_address2,l_address3,l_address4,IFSC_Code  from #neft a                                          
  left outer join                                          
 (select branch_cd,sub_broker,party_code,                                  
l_address1=rtrim(ltrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(l_address1)),'/',' '),'\',''),'.',' '),'&',' '),':',''),'-',''),';',''),'–',''),'#',''),'''',''),'"',''))),                        
  
    
      
        
          
l_address2=rtrim(ltrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(l_address2)),'/',' '),'\',''),'.',' '),'&',' '),':',''),'-',''),';',''),'–',''),'#',''),'''',''),'"',''))),                         
  
    
      
        
         
l_address3=case when len(rtrim(ltrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(l_address3)),'/',' '),'\',''),'.',' '),'&',' '),':',''),'-',''),';',''),'–',''),'#',''),'''',''),'"',''))))<=1        
  
    
      
        
         
then rtrim(ltrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(l_address2)),'/',' '),'\',''),'.',' '),'&',' '),':',''),'-',''),';',''),'–',''),'#',''),'''',''),'"','')))                         
else rtrim(ltrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(l_address3)),'/',' '),'\',''),'.',' '),'&',' '),':',''),'-',''),';',''),'–',''),'#',''),'''',''),'"',''))) end,                           
  
    
      
       
l_address4=Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(ltrim(rtrim(l_city+'-'+l_zip)),'/',' '),'\',''),'.',' '),'&',' '),':',''),'.',''),';',''),'–',''),'#',''),'''',''),'"','')                          
from intranet.risk.dbo.client_details with (nolock))b                                          
on a.cltcode=b.party_code                 
group by Name,amt,cltcode,accno,co,branch_cd,sub_broker,party_code,l_address1,    l_address2,l_address3,l_address4,IFSC_Code                      
                                             
select * from sccs_NEFT_BankFile where amt>=5.00 order by cltcode                                                  
                                                       
end                       
                                         
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_PO_File_Generate
-- --------------------------------------------------
CREATE procedure SCCS_PO_File_Generate(@server as varchar(15))  
As  
  
Declare @s as varchar(1000)   
Declare @s1 as varchar(1000)  
Declare @file as varchar(50)  
  
truncate table tempGen  
insert into tempGen  
select Data=ltrim(rtrim(party_code))+','+isnull(symbol,'')+','+isnull(series,'')+','+isnull(isin,'')+','    
+convert(varchar(15),Qty_Allowed)+','+isnull(FDPid,'')+','+isnull(FCltid,'')+','+isnull(Bankid,'')+','    
+isnull(bankid+cltdpid,'')+','+rem    
from sccs_sharepo where exchange='nse' and isnull(party_code,'')<>''  and block='n' and Qty_Allowed>0   
                                       
set @file = (select 'SCCS_NSECMPO_'+replace(convert(varchar(11),getdate(),3),'/','')+'.csv')  
          
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT data FROM SCCS.dbo.tempGen(nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                                                                                                          
set @s1= @s+''''                            
exec(@s1)  
  
  
truncate table tempGen  
insert into tempGen  
select Data=ltrim(rtrim(party_code))+','+isnull(scrip_cd,'')+','+isnull(exchange,'')+','+isnull(isin,'')+','    
+convert(varchar(15),Qty_Allowed)+','+isnull(FDPid,'')+','+isnull(FCltid,'')+','+isnull(Bankid,'')+','    
+isnull(bankid+cltdpid,'')+','+rem    
from sccs_sharepo where exchange='bse' and isnull(party_code,'')<>''  and block='n' and Qty_Allowed>0   
  
set @file = (select 'SCCS_BSECMPO_'+replace(convert(varchar(11),getdate(),103),'/','')+'.csv')  
  
select convert(varchar(25),getdate(),103)  
  
set @s = 'exec MASTER.dbo.xp_cmdshell '+ '''' +'bcp  "SELECT data FROM SCCS.dbo.tempGen with (nolock)" queryout \\'+@server+'\D$\upload1\SCCS\'+@file+' -c'                                                                                                    
      
set @s1= @s+''''                            
exec(@s1)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_PO_File_Generate_BSE
-- --------------------------------------------------
CREATE procedure SCCS_PO_File_Generate_BSE(@server as varchar(15))      
As      
      
select Data=ltrim(rtrim(party_code))+','+isnull(scrip_cd,'')+','+isnull(exchange,'')+','+isnull(a.isin,'')+','      
+convert(varchar(15),Qty_Allowed)+','+isnull(FDPid,'')+','+isnull(FCltid,'')+','+isnull(Bankid,'')+','      
+isnull(bankid+cltdpid,'')+','+rem      
from sccs_sharepo a (nolock) left outer join (select distinct isin from Sccs_blk_isin) b 
on a.isin=b.isin  
where exchange='bse' and isnull(party_code,'')<>'' and block='n' and Qty_Allowed>0     
and b.isin is null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_PO_File_Generate_NSE
-- --------------------------------------------------
CREATE procedure SCCS_PO_File_Generate_NSE(@server as varchar(15))  
As  
  
select Data=ltrim(rtrim(party_code))+','+isnull(symbol,'')+','+isnull(series,'')+','+isnull(a.isin,'')+','  
+convert(varchar(15),Qty_Allowed)+','+isnull(FDPid,'')+','+isnull(FCltid,'')+','+isnull(Bankid,'')+','  
+isnull(bankid+cltdpid,'')+','+rem   
from sccs_sharepo a (nolock) left outer join (select distinct isin from Sccs_blk_isin) b
on a.isin=b.isin
where exchange='nse' and isnull(party_code,'')<>'' and block='n' and Qty_Allowed>0  
and b.isin is null

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Pro_Date_upd
-- --------------------------------------------------
CREATE procedure SCCS_Pro_Date_upd
as
truncate table SCCS_Pro_Date
insert into SCCS_Pro_Date 
select distinct convert(datetime,convert(varchar(11),update_date)) 
from  sccs_vw_data

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_Umark_pledge
-- --------------------------------------------------
create procedure SCCS_Umark_pledge
As

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_upd_client_Vertical
-- --------------------------------------------------
CREATE procedure SCCS_upd_client_Vertical  
As    
  
begin transaction  
  
 Truncate table RMS_Client_Vertical    
     
 insert into RMS_Client_Vertical (Zone,Region,RegionName,Branch,BranchName,SB,SB_Name,Client,Party_name,CliType)   
 select Zone,Region,RegionName,Branch,BranchName,SB,SB_Name,Client,Party_name,'B2B'     
 from intranet.risk.dbo.Vw_RMS_Client_Vertical1 with (nolock)   

 update RMS_Client_Vertical set Clitype='B2C' where sb in (select b2c_sb from remisior.dbo.b2c_Sb)
 
commit transaction

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCSPledge_Process
-- --------------------------------------------------
CREATE procedure SCCSPledge_Process      
As       
truncate table tblSCCSPledge_data      
      
insert into tblSCCSPledge_data      
/*  
select Scrip_Cd,isin,party_code,Accno,qty=sum(qty)       
from intranet.risk.dbo.holding with (nolock)      
where accno       
in ('1203320000000066','1203320000000051','13326100','15464303')      
and party_code in (select party_code from sccs_data (nolock))      
and flag='P'      
group by Scrip_Cd,isin,party_code,Accno  
*/  
  
select scrip_Cd,isin,party_code,Accno=fcltid,Qty=sum(qty)   
from ScCS_sharepo with (nolock)  
where fcltid  
in ('1203320000000066','1203320000000051','13326100','15464303')      
and qty_allowed > 0
group by Scrip_Cd,isin,party_code,fcltid

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_ShPayout_Credit
-- --------------------------------------------------
CREATE procedure [dbo].[USP_BSE_ShPayout_Credit](@processtype as varchar(1))
                        
as                        
                        
set nocount on                        
                        
                    
truncate table SCCS_Sharepo                    
                    
/* 51 secs */                        
select a2.party_Code,scrip_cd,dummy1 as symbol,dummy2 as series,                        
exchange,accno,Qty=sum(case when accno<>'' then qty else 0 end),                        
Amount=Sum(case when accno <> '' then Total else 0 end),                        
BSECM_ShrtVal,NSECM_ShrtVal,approved=(case when approved = '*' then 1 else 0 end),DedVal                        
into #hld_Fcr                        
from risk.dbo.holding a2 with (nolock),                          
(select party_code,DedVal=      
((BSECM_ShrtVal+NSECM_ShrtVal)*.20)+(Case when Net_Credit <= -1000 then 0 else (Net_Credit+1000)*4 end),                        
BSECM_ShrtVal,NSECM_ShrtVal from SCCS_Data with (nolock)) b2                         
where a2.party_Code=b2.party_code and a2.accno <> ''                         
group by a2.party_Code,scrip_cd,exchange,accno,BSECM_ShrtVal,NSECM_ShrtVal,dummy1,dummy2,approved,dedval                        
                        
/* Add F&O Collateral DPID: IN301549-15464303*/              
  
Select * into #focoll from AngelNseCM.msajag.dbo.collateraldetails               
where EffDate = (select max(effdate) as effdate from AngelNseCM.msajag.dbo.collateraldetails where effdate <= convert(varchar(11),getdate())+' 23:59:59')              
and Exchange = 'NSE' and Cash_Ncash = 'N' and Party_code in (Select party_code from sccs_data with (nolock))              
              
--select top 10 * from #focoll               
              
select party_code, scrip_cd=space(10), scrip_cd as symbol, series, exchange, accno='15464303', Qty, Amount,               
BSECM_ShrtVal=convert(money,0), NSECM_ShrtVal=convert(money,0), approved=3, DedVal=convert(money,0) into #focoll1 from #focoll               
              
update #focoll1 set scrip_cd=b.bsecode from               
(select nsesymbol,nseseries,bsecode=max(bsecode) from intranet.risk.dbo.scrip_master where bsecode like '5%' group by nsesymbol,nseseries)  b              
where  #focoll1.symbol=b.nsesymbol and #focoll1.series=b.nseseries              
              
              
update #focoll1 set BSECM_ShrtVal=b.BSECM_ShrtVal,NSECM_ShrtVal=b.NSECM_ShrtVal,DedVal=b.DedVal from               
(select party_code,DedVal=((BSECM_ShrtVal+NSECM_ShrtVal)*.20)+(Case when Net_Credit <= -1000 then 0 else (Net_Credit+1000)*4 end),                        
BSECM_ShrtVal,NSECM_ShrtVal from SCCS_Data with (nolock)) b               
where  #focoll1.party_Code=b.party_Code              
              
insert into #hld_Fcr select * from #focoll1              
  
/* ----------------- */                         
                        
update #hld_Fcr set approved=2 where scrip_cd in                        
(                        
select scode from intranet.risk.dbo.icici_scp with (nolock)                        
union                        
select scode from intranet.risk.dbo.hdfc_scp with (nolock)                        
union                        
select scode from intranet.risk.dbo.kotak_scp with (nolock)                        
) and approved <> 3              
                        
/*  19 secs */                        
select a.party_code,scrip_cd,exchange,isin,Qty,a.DPid as FDPid,accno as FCltid,                        
Bankid,Cltdpid=(Case when len(Cltdpid)=16 then substring(Cltdpid,9,8) ELSE substring(Cltdpid,1,8) end),'BTC' AS REM,                        
BSECM_ShrtVal,NSECM_ShrtVal,symbol,series,approved,DedVal,Amount as HldVal                        
into #Hld_Fcr1 from                         
(select a1.*,DPID=(case when b1.dpid is not null and len(Accno)=8 then b1.dpid else substring(a1.accno,1,8) end)                        
from #hld_Fcr a1 left outer join angeldemat.bsedb.dbo.deliverydp b1 with (nolock) on a1.accno=b1.dpcltno                  
where a1.exchange='BSE'  )  a,                         
(select bsecode,isin=max(isin) from intranet.risk.dbo.scrip_master with (nolock) group by bsecode ) b,                        
(select party_code,BAnkid,Cltdpid from angeldemat.bsedb.dbo.client4 with (nolock) where defdp=1) c                        
where a.scrip_Cd=b.bsecode and a.party_Code=c.party_code                        
                        
insert into #Hld_Fcr1                         
select a.party_code,scrip_cd,exchange,isin,Qty,a.DPid as FDPid,accno as FCltid,                        
Bankid,Cltdpid=(Case when len(Cltdpid)=16 then substring(Cltdpid,9,8) ELSE substring(Cltdpid,1,8) end),'BTC' AS REM,                        
BSECM_ShrtVal,NSECM_ShrtVal,symbol,series,approved,DedVal,Amount as HldVal                        
from                         
(select a1.*,DPID=(case when b1.dpid is not null and len(Accno)=8 then b1.dpid else substring(a1.accno,1,8) end)                        
from #hld_Fcr a1 left outer join angeldemat.msajag.dbo.deliverydp b1 with (nolock) on a1.accno=b1.dpcltno                        
where a1.exchange='NSE'  )  a,                         
(select bsecode,isin=max(isin) from intranet.risk.dbo.scrip_master with (nolock) group by bsecode ) b,                        
(select party_code,BAnkid,Cltdpid from angeldemat.msajag.dbo.client4 with (nolock) where defdp=1) c                        
where a.scrip_Cd=b.bsecode and a.party_Code=c.party_code                        
                        
/*  21 secs */                        
select * into #hld_Fcr2 from Fmt_Hld_Fcr2                         
create clustered index idx_ptyScp on #hld_Fcr2 (party_code,Scrip_Cd)                        
                        
insert into #Hld_Fcr2                        
select                         
a.party_code,a.scrip_cd,a.exchange,a.isin,a.Qty,a.FDPid,a.FCltid,a.Bankid,a.Cltdpid,a.REM,a.BSECM_ShrtVal,a.NSECM_ShrtVal                        
/* ,HldVal=isnull(b.rate,0)*a.qty */                        
,HldVal,Block='N',Qty_Allowed=qty,BSECM_ShrtValAftAdj=BSECM_ShrtVal,symbol,series,approved,dedval                        
from #Hld_Fcr1 a                         
/* left outer join intranet.risk.dbo.Cp b with (nolock) on a.scrip_cd=b.scode */                        
                        
                     
update #Hld_Fcr2 set block='Y' where party_Code in                        
(                        
select party_code from #Hld_Fcr2 where dedval > 0 group by party_code,dedval                        
having dedval >= sum(HldVAl)                        
)                        
                        
---------------------------------------                        
            
update #Hld_Fcr2 set symbol='' where symbol is null                    
update #Hld_Fcr2 set series='' where series is null            
                       
declare @party_Code as varchar(10),@scrip_cd as varchar(10),@Qty as int,@BSECM_ShrtVal as money,@NSECM_ShrtVal as money,@HldVal as money,@Block as varchar(1),@exchange as varchar(3),@dedval as money,@fcltid as varchar(16)                       
declare @mparty_Code as varchar(10),@ShrtVal as money,@mexchange as varchar(3),@symbol as varchar(15),@series as varchar(15)              
                        
DECLARE Shrt_cursor CURSOR FOR                                                         
SELECT party_Code,scrip_cd,Qty,BSECM_ShrtVal,NSECM_ShrtVal,HldVal,Block,exchange,dedval,Fcltid,symbol,series FROM #Hld_Fcr2 where block='N' and dedval > 0                         
ORDER BY party_code,approved desc,exchange,Fcltid,HldVal desc                        
                        
OPEN Shrt_cursor                                            
                                                        
FETCH NEXT FROM Shrt_cursor                                                         
INTO @party_Code,@scrip_cd,@Qty,@BSECM_ShrtVal,@NSECM_ShrtVal,@HldVal,@Block,@exchange,@dedval,@fcltid,@symbol,@series                         
                        
set @mparty_code=''                        
                        
WHILE @@FETCH_STATUS = 0                                         
BEGIN                         
 if (@mparty_code<>@party_code)                         
 begin                        
  set @mparty_code=@party_code                        
  /* set @ShrtVal=((@BSECM_ShrtVal+@NSECM_ShrtVal)*.20) */                        
  set @ShrtVal=@dedval                        
 end                        
                          
 if @ShrtVal < @HldVal and @ShrtVal > 0                        
 begin                        
  update #Hld_Fcr2 set Qty_Allowed=floor((@hldval-@Shrtval)/(@hldval/@qty))                       
  where party_Code=@party_Code and scrip_cd=@scrip_Cd and exchange=@exchange and fcltid=@fcltid and symbol=@symbol and series=@series              
  set @ShrtVal=@ShrtVal-@HldVal                        
  /* update #Hld_Fcr2 set BSECM_ShrtValAftAdj=@ShrtVal where party_Code=@party_Code and scrip_cd=@scrip_Cd */                        
 end                        
 else if @ShrtVal=0                        
 begin                        
  update #Hld_Fcr2 set Qty_Allowed=qty, Block='N' where party_Code=@party_Code and scrip_cd=@scrip_Cd and exchange=@exchange and fcltid=@fcltid and symbol=@symbol and series=@series                      
  /* update #Hld_Fcr2 set BSECM_ShrtValAftAdj=@ShrtVal where party_Code=@party_Code and scrip_cd=@scrip_Cd */                        
 end                        
                        
 else if @ShrtVal >= @HldVal                         
 begin                        
  update #Hld_Fcr2 set Qty_Allowed=0, Block='Y' where party_Code=@party_Code and scrip_cd=@scrip_Cd and exchange=@exchange  and fcltid=@fcltid and symbol=@symbol and series=@series                     
  set @ShrtVal=@ShrtVal-@HldVal                        
  /* update #Hld_Fcr2 set BSECM_ShrtValAftAdj=@ShrtVal where party_Code=@party_Code and scrip_cd=@scrip_Cd */                        
 end                        
                        
 FETCH NEXT FROM Shrt_cursor                                                         
 INTO @party_Code,@scrip_cd,@Qty,@BSECM_ShrtVal,@NSECM_ShrtVal,@HldVal,@Block,@exchange,@dedval,@fcltid,@symbol,@series                          
                        
END                        
                        
CLOSE Shrt_cursor                                     
DEALLOCATE Shrt_cursor                          
                        
update #Hld_Fcr2 set Qty_Allowed=0 where block='Y'                        
                  
delete from #Hld_Fcr2 where qty=0                  
                  
update #Hld_Fcr2 set symbol=b.nsesymbol, series=b.nseseries from          
intranet.risk.dbo.scrip_master b with (nolock)          
where #Hld_Fcr2.isin=b.isin and #Hld_Fcr2.symbol='' and #Hld_Fcr2.exchange='NSE'          
          
declare @tdate as datetime                        
select top 1 @tdate=update_date from sccs_Data                        
insert into SCCS_Sharepo select *,@tdate from #Hld_Fcr2                        
                
if @processtype ='F'
begin
insert into SCCS_Sharepo_hist select * from SCCS_Sharepo                    
end
                        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SCCS_MIS_PO
-- --------------------------------------------------
Create Procedure USP_SCCS_MIS_PO
as
set nocount on
select party_code,scrip_Cd,exchange,Qty=sum(Qty),Total=sum(total) into #Pledge
from intranet.risk.dbo.holding with (nolock) where flag='P'
and accno <> '' group by party_code,scrip_Cd,exchange

select party_code,scrip_Cd,exchange,Qty=sum(Qty),Total=sum(total) into #Total
from intranet.risk.dbo.holding with (nolock) --where flag='P'
where accno <> '' 
group by party_code,scrip_Cd,exchange

select a.*,Pledge_qty=isnull(b.qty,0) into #file1
from #total a left outer join #pledge b 
on a.party_Code=b.party_Code and a.scrip_Cd=b.scrip_cd and a.exchange=b.exchange

select party_code,scrip_Cd,exchange,Qty=sum(Qty_Allowed),Total=sum((HldVal/Qty)*Qty_Allowed),Approved
into #file2
from sccs_sharepo  where qty <> 0 
group by party_code,scrip_Cd,exchange,approved
having sum(qty_allowed) <> 0

select a.*,PO_Qty=isnull(b.qty,0),PO_Val=isnull(b.total,0),approved
into #file3
from #file1 a left outer join  #file2 b 
on a.party_Code=b.party_Code and a.scrip_Cd=b.scrip_cd and a.exchange=b.exchange

truncate table SCCS_MIS_PO 
insert into SCCS_MIS_PO select *,bank='' from #file3
update SCCS_MIS_PO set PO_Qty = Qty  where PO_qty > Qty
update SCCS_MIS_PO set PO_Val=(Total/qty)*PO_Qty where qty <> 0


/*
ALTER TABLE SCCS_MIS_PO ADD FLAG VARCHAR(1) 
UPDATE SCCS_MIS_PO SET FLAG='N'
UPDATE SCCS_MIS_PO SET FLAG='Y' WHERE SCRIP_CD COLLATE Latin1_General_CI_AS IN (SELECT SCODE FROM INTRANET.RISK.DBO.ISIN WHERE APP='*')
*/
UPDATE SCCS_MIS_PO SET FLAG='N' 

UPDATE SCCS_MIS_PO SET FLAG='Y' WHERE SCRIP_CD in
(
select scode from intranet.risk.dbo.icici_scp with (nolock)
union
select scode from intranet.risk.dbo.hdfc_scp with (nolock)
union
select scode from intranet.risk.dbo.kotak_scp with (nolock)
)

UPDATE SCCS_MIS_PO SET BANK='N' 

UPDATE SCCS_MIS_PO SET BANK='I' WHERE SCRIP_CD in
(
select scode from intranet.risk.dbo.icici_scp with (nolock)
)

UPDATE SCCS_MIS_PO SET BANK='H' WHERE SCRIP_CD in
(
select scode from intranet.risk.dbo.hdfc_scp with (nolock)
) and bank='N'


UPDATE SCCS_MIS_PO SET BANK='K' WHERE SCRIP_CD in
(
select scode from intranet.risk.dbo.kotak_scp with (nolock)
) and bank='N'

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SCCS_Process
-- --------------------------------------------------
CREATE Procedure [dbo].[USP_SCCS_Process] (@tdate as varchar(25),@processType as varchar(1))                                                  
as                                                  
                                        
set nocount on                                  
              
/*declare @tdate as varchar(25),@processType as varchar(1)    
set  @tdate='%'       
set @processType='A'    
*/    
if @tdate='%'            
Begin                                 
 set @tdate = convert(varchar(11),getdate())+' 23:59:59'                                     
END                              
        
        
        
/*        
declare @tdate as varchar(25),@processType as varchar(1)             
set @tdate='%'                         
        
set @processType='C' -- For clients whom settlement is going to happen in next week        
set @processType='A' -- For All clients         
set @processType='F' -- For clients whom settlement date is todays date        
*/                    
--exec SCCS_NSEAuctionInfo                    
--exec SCCS_BSEAuctionInfo                                    
                                                    
--truncate table SCCS_Data /*present below*/            
select top 0 party_code into #cli from sccs_clientmaster        
        
if @processType='C'        
Begin        
 insert into #cli        
 select party_code from sccs_clientmaster        
 where sccs_settDate_last>=convert(varchar(11),getdate())        
 and sccs_settDate_last<convert(varchar(11),getdate()+7)+' 23:59:59'        
 and exclude='N'        
End        
if @processType='F'        
Begin        
 insert into #cli        
 select party_code from sccs_clientmaster        
 where sccs_settDate_last>=convert(varchar(11),getdate())        
 and sccs_settDate_last<convert(varchar(11),getdate()+1)+' 23:59:59'        
 and exclude='N'        
End        
if @processType='A'        
Begin        
 insert into #cli        
 select party_code from sccs_clientmaster        
 where  exclude='N'        
End        
                                    
/*                                         
N O T E :                                        
----------                                        
This SP should be executed only After CMS process                                         
Estimated Time : 21 Mins as on 05/08/2010 06:00 pm                                         
                                        
*/                                         
                                        
/*                                        
declare @tdate as varchar(25)                                                  
set @tdate = 'Aug  6 2010 23:59:59'                                                  
*/                                        
                                        
/*                                        
--- Already Executed in CMS Process                                        
exec intranet.risk.dbo.client_receipt_reco                                            
exec intranet.risk.dbo.get_shortage                                            
exec intranet.risk.dbo.Usp_Calc_ShrtVal                                         
*/                                        
                    
        
if @tdate='%'            
Begin                                 
 set @tdate = convert(varchar(11),getdate())+' 23:59:59'                                     
END                              
                                       
------------------ FETCH LEDGER BALANCE                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #bsecm_led                                                  
from intranet.risk.dbo.abl_cledger a with (nolock), #cli b         
where a.cltcode=b.party_code and edt<=@tdate                                                  
group by cltcode                                                  
                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #nsecm_led                                                  
from intranet.risk.dbo.nse_cledger  a with (nolock), #cli b         
where a.cltcode=b.party_code and edt<=@tdate                                                  
group by cltcode                                                  
                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #nsefo_led                                                  
from intranet.risk.dbo.fo_cledger  a with (nolock), #cli b         
where a.cltcode=b.party_code and edt<=@tdate                                                    
group by cltcode                                                  
                                                  
                            
select clcode as cltcode,ledger=                            
case when shortage < ledgeramount*-1 then ledgeramount*-1                                              
else (case when net*-1 < 0 then                                                  
(case when  imargin-ledgeramount < 0 then imargin-ledgeramount else 0 end)                                              
else net*-1 end) end                            
into #mcdx_led from intranet.risk.dbo.mcdx_marh  a with (nolock), #cli b         
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.mcdx_marh with (nolock) where sauda_date <= @tdate)                                                  
and a.clcode=b.party_code                                               
                                                  
select clcode as cltcode,ledger=                            
case when shortage < ledgeramount*-1 then ledgeramount*-1                                              
else (case when net*-1 < 0 then                                                  
(case when  imargin-ledgeramount < 0 then imargin-ledgeramount else 0 end)                                              
else net*-1 end) end                            
into #Ncdx_led                                           
from intranet.risk.dbo.ncdx_marh  a with (nolock), #cli b                                           
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.ncdx_marh with (nolock) where sauda_date <= @tdate)                 
and a.clcode=b.party_code                            
                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #nsx_led                                                  
from intranet.risk.dbo.nsx_cledger a with (nolock), #cli b         
where a.cltcode=b.party_code and edt<=@tdate                                                   
group by cltcode                                                  
                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #mcd_led                                                  
from intranet.risk.dbo.mcd_cledger a with (nolock), #cli b         
where a.cltcode=b.party_code and edt<=@tdate                                     
group by cltcode                                                  
                                                  
---------------- Client Deposit Account                                        
                              
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #bsecm_dep                                        
from AngelBSECM.account_Ab.dbo.ledger a with (nolock), #cli b  where                                         
edt >= (select sdtcur from AngelBSECM.account_Ab.dbo.parameter with (nolock) where sdtcur <= @tdate and ldtcur>= @tdate)                                        
and edt<=@tdate and cltcode='30'+b.party_code        
group by cltcode                                                  
                                              
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #nsecm_dep                                           
from AngelNseCM.account.dbo.ledger a with (nolock), #cli b where edt<=@tdate                                         
and edt >= (select sdtcur from AngelNseCM.account.dbo.parameter with (nolock) where sdtcur <= @tdate and ldtcur>= @tdate)                                        
and cltcode='30'+b.party_code group by cltcode                       
                                        
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                      into #nsefo_dep                                                  
from angelfo.accountfo.dbo.ledger a with (nolock), #cli b where edt<=@tdate                                               
and edt >= (select sdtcur from angelfo.accountfo.dbo.parameter with (nolock) where sdtcur <= @tdate and ldtcur>= @tdate)                                        
and cltcode='30'+b.party_code group by cltcode                                                  
                                                  
                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #nsx_dep                                                  
from angelfo.accountcurfo.dbo.ledger a with (nolock), #cli b where edt<=@tdate                                                  
and edt >= (select sdtcur from angelfo.accountcurfo.dbo.parameter with (nolock) where sdtcur <= @tdate and ldtcur>= @tdate)                                        
and cltcode='30'+b.party_code                                       
group by cltcode                                                  
                                                  
select cltcode,ledger=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #mcd_dep                                                  
from angelcommodity.accountmcdxcds.dbo.ledger a with (nolock), #cli b where edt<=@tdate                                                  
and edt >= (select sdtcur from angelcommodity.accountmcdxcds.dbo.parameter with (nolock) where sdtcur <= @tdate and ldtcur>= @tdate)                                        
and cltcode='30'+b.party_code                                        
group by cltcode                                                  
                                        
/*                                                  
update #bsecm_led set #bsecm_led.ledger=#bsecm_led.ledger+b.ledger from #bsecm_dep a where #bsecm_led.cltcode=substring(ltrim(rtrim(b.cltcode)),3,10)                                        
update #nsecm_led set #nsecm_led.ledger=#nsecm_led.ledger+b.ledger from #nsecm_dep a where #nsecm_led.cltcode=substring(ltrim(rtrim(b.cltcode)),3,10)                                        
update #nsefo_led set #nsefo_led.ledger=#nsefo_led.ledger+b.ledger from #nsefo_dep a where #nsefo_led.cltcode=substring(ltrim(rtrim(b.cltcode)),3,10)                                        
update #nsx_led set #nsx_led.ledger=#nsx_led.ledger+b.ledger from #nsx_dep a where #nsx_led.cltcode=substring(ltrim(rtrim(b.cltcode)),3,10)                                        
update #mcd_led set #mcd_led.ledger=#mcd_led.ledger+b.ledger from #mcd_dep a where #mcd_led.cltcode=substring(ltrim(rtrim(b.cltcode)),3,10)                                        
*/                       
                          
------------------ FETCH DR BALANCE of Unsettlement                                                  
                          
select cltcode,US_Debit=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #bsecm_usd    
from intranet.risk.dbo.abl_cledger a with (nolock), #cli b        
where edt>@tdate and vdt<=@tdate and a.cltcode=b.party_code and drcr='D'                                                  
group by cltcode                                                  
                                                  
select cltcode,US_Debit=sum(Case when drcr='D' then vamt else -vamt end)                        
into #nsecm_usd                                                  
from intranet.risk.dbo.nse_cledger a with (nolock), #cli b        
 where edt>@tdate and vdt<=@tdate and a.cltcode=b.party_code and drcr='D'                                                  
group by cltcode                                                  
                                        
------------------ FETCH Cr BALANCE of Unsettlement                                
                          
select cltcode,vdt,US_Credit=sum(Case when drcr='D' then vamt else -vamt end)                                                  
into #bsecm_usc                                                  
from intranet.risk.dbo.abl_cledger a with (nolock), #cli b        
where edt>@tdate and vdt<=@tdate and a.cltcode=b.party_code and drcr='C'                                           
group by cltcode,vdt                                                  
                                                 
select cltcode,Vdt,US_Credit=sum(Case when drcr='D' then vamt else -vamt end)                                
into #nsecm_usc                                                  
from intranet.risk.dbo.nse_cledger a with (nolock), #cli b        
where edt>@tdate and vdt<=@tdate and a.cltcode=b.party_code and drcr='C'                                                  
group by cltcode,vdt                                                  
                                                  
------------------- Cash Var Margin of Unsettled Credit Client                                        
                                         
select party_code,VarAmt=sum(VarAmt)                                         
into #BSEVar                                         
from                                         
(select party_Code,margin_date,VarAmt=sum(Varamt+ELM) from AngelBSECM.bsedb_Ab.dbo.tbl_mg02 with (nolock)                                        
group by party_Code,margin_date                                        
) a, #bsecm_usc b with (nolock) where a.MArgin_Date=b.vdt and a.party_Code=b.cltcode                                        
group by party_Code                                                    
                                                  
                                        
select party_code,VarAmt=sum(VarAmt)                                         
into #NSEVar                                         
from                                         
(select party_Code,margin_date,VarAmt=sum(Varamt) from AngelNseCM.msajag.dbo.tbl_mg02 with (nolock)                                         
group by party_Code,margin_date ) a, #nsecm_usc b with (nolock) where a.MArgin_Date=b.vdt and a.party_Code=b.cltcode                                        
group by party_Code                                                    
                                        
---------------------------- BSE 30 days VAR                                       
                                        
declare @fdate as datetime                                        
select @fdate=convert(varchar(11),convert(datetime,@tdate)-30)+' 00:00:00'                                        
                                        
select Sauda_date,a.party_Code,PqtyTrd,Scrip_cd,isin                                        
into #file1a                                        
from AngelBSECM.bsedb_ab.dbo.cmbillvalan  a with (nolock), #cli b        
where sauda_Date >= @fdate and sauda_Date <= @tdate and a.party_code=b.party_code and PqtyTrd > 0                                        
                                        
select * into #var from [CSOKYC-6].history.dbo.bsevar_hist where processon >=@fdate and processon <=@tdate                                       
                                        
select mfdate as margin_Date,isin,bsecode as scrip_Cd,nsesymbol,varperc,rate,VarRate=(rate*varperc)/100.00 into #varfin from                                         
(select PROCESSON,isincode,convert(money,ELM_PERC)+converT(money,VARMARGIN) as Varperc from #var) a,                                     
(select * from intranet.risk.dbo.cpcumm where mfdate >=@fdate and mfdate <=@tdate) b,                                         
(select isin,bsecode,nsesymbol,nseseries from intranet.risk.dbo.scrip_master where bsecode not like '6%') c                                        
where a.PROCESSON=b.mfdate and a.isincode=c.isin and c.bsecode=b.scode                                 
                                        
                                       
select party_Code,sauda_date,VarAmt=Sum(VarAmt) into #file1b                                        
from                                       
(                                        
select a.*,VarAmt=varrate*pqtyTrd from #file1a a,                                         
#varfin b with (nolock)                                         
where a.sauda_Date=b.margin_date and a.scrip_Cd=b.scrip_Cd ) x group by party_Code,sauda_date                                        
                                        
---------------- NSE Var                                        
select Sauda_date,a.party_Code,PqtyTrd,Scrip_cd,isin                                         
into #file2a                                        
from AngelNseCM.msajag.dbo.cmbillvalan a with (nolock), #cli b         
where sauda_Date >= @fdate and sauda_Date <= @tdate and a.party_code=b.party_code and PqtyTrd > 0                                        
                                        
select party_Code,sauda_date,VarAmt=Sum(VarAmt) into #file2b from                                        
(                                        
select a.*,VarAmt=varrate*pqtyTrd from #file2a a,                                         
#varfin b with (nolock)                                         
where a.sauda_Date=b.margin_date and a.scrip_Cd=b.nsesymbol ) x group by party_Code,sauda_date                                        
                                        
                                        
select party_Code,sauda_DAte,VarAmt=sum(VarAmt)                                        
into #maxvar                                        
from                                        
(                                        
select * from #file1b                                        
union all                                        
select * from #file2b                                        
) x group by party_Code,sauda_DAte                                        
                                        
                                        
alter table #maxvar add MaxVar int default 0                                         
update #maxvar set MaxVar=0                                        
                                        
update #maxvar set maxvar=1 from                                         
(                                        
select a.* from #maxvar a with (nolock),                                        
(select party_code,Varamt=max(varamt) from #maxvar group by party_Code) b                                        
where a.partY_code=b.party_Code and a.varamt=b.varamt                                        
) x where #maxvar.party_Code=x.party_Code and #maxvar.sauda_Date=x.sauda_Date                                        
                                       
update #maxvar set maxvar=0 from                                        
(                                        
select party_code,max(sauda_date) as sauda_DAte from #maxvar where MaxVar=1 and party_Code in (select party_Code  from #maxvar where MaxVar=1 group by party_Code having count(1) > 1)                                        
group by party_Code                                        
) x where #maxvar.party_Code=x.party_Code and #maxvar.sauda_Date=x.sauda_Date                                        
                          
                          
                                        
/*                                        
select Sauda_date=convert(datetime,convert(varchar(11),sauda_date)),party_Code,PqtyTrd=(                                        
case                                         
when pqty > sqty and sqty > 0 then sqty                                         
when pqty > sqty and sqty <= 0 then pqty                                         
when pqty <= sqty and pqty > 0 then pqty                                         
when pqty <= sqty and pqty <= 0 then sqty                                         
else 0 end                                        
),symbol as scrip_cd                                 
into #file3a                                        
from angelfo.nsefo.dbo.fobillvalan where sauda_Date >= @fdate and sauda_Date <= @tdate and tradeType='BT' and inst_type like 'FUT%'                                        
*/                          
                          
                          
select sauda_date=convert(datetime,convert(varchar(11),sauda_date)),                          
a.party_code,pqty,pamt,prate,sqty,samt,srate,strike_price,inst_type,symbol,                          
Qty=(Case when pqty > sqty then sqty else pqty end),                          
Turnover=(Case when pqty > sqty then ((srate+strike_price)*sqty)+((prate+strike_price)*sqty) else ((srate+strike_price)*pqty)+((prate+strike_price)*pqty) end)                          
into #file3ax                          
from angelfo.nsefo.dbo.fobillvalan a with (nolock), #cli b        
where sauda_Date >= @fdate and sauda_Date <= @tdate and a.party_code=b.party_code and tradetype ='BT'                           
and pqty <> 0 and sqty <> 0                           
                          
select Sauda_date=convert(datetime,convert(varchar(11),sauda_date)),party_Code,PqtyTrd=(                                        
case                                         
when pqty > sqty and sqty > 0 then sqty                                         
when pqty > sqty and sqty <= 0 then pqty                                         
when pqty <= sqty and pqty > 0 then pqty                                         
when pqty <= sqty and pqty <= 0 then sqty                                         
else 0 end                                        
),symbol as scrip_cd                                         
into #file3a                                        
from #file3ax                          
                          
                              
insert into #varfin                                         
select margin_date=tdate,isin='',scrip_cd='',symbol,10,nifty,nifty*.10         
from intranet.risk.dbo.spot_nifty where tdate >=@fdate and tdate <=@tdate                                        
                                        
select party_Code,sauda_date,VarAmt=Sum(VarAmt) into #file3b                                        
from                                        
(                                        
select a.*,VarAmt=varrate*pqtyTrd from #file3a a,                                         
#varfin b with (nolock)                                         
where a.sauda_Date=b.margin_date and a.scrip_Cd=b.nsesymbol ) x group by party_Code,sauda_date                                        
                                        
select party_Code,sauda_DAte,VarAmt=sum(VarAmt) into #maxvar1 from #file3b  x group by party_Code,sauda_DAte                                        
                                        
alter table #maxvar1 add MaxVar int default 0                                         
update #maxvar1 set MaxVar=0                                        
                                        
update #maxvar1 set maxvar=1 from                                         
(                                        
select a.* from #maxvar1 a with (nolock),                                        
(select party_code,Varamt=max(varamt) from #maxvar1 group by party_Code) b                                 
where a.partY_code=b.party_Code and a.varamt=b.varamt                                        
) x where #maxvar1.party_Code=x.party_Code and #maxvar1.sauda_Date=x.sauda_Date                                        
                                        
update #maxvar1 set maxvar=0 from                                        
(                                        
select party_code,max(sauda_date) as sauda_DAte from #maxvar1 where MaxVar=1                             
and party_Code in (select party_Code  from #maxvar1 where MaxVar=1 group by party_Code having count(1) > 1)                                        
group by party_Code                                        
) x where #maxvar1.party_Code=x.party_Code and #maxvar1.sauda_Date=x.sauda_Date                                        
                                  
                                        
------------------                                                   
                                        
Create Table #NEt                                                  
(                                                  
Party_code varchar(10),                                                  
BSECM_Ledger money default 0,                       
NSECM_Ledger money default 0,                                                  
NSEFO_Ledger money default 0,                                                  
MCDX_Ledger money default 0,                             
NCDX_Ledger money default 0,                                                  
MCD_Ledger money default 0,                                                  
NSX_Ledger money default 0,                                              
BSECM_Deposit money default 0,                                                  
NSECM_Deposit money default 0,                                                  
NSEFO_Deposit money default 0,                                                  
MCD_Deposit money default 0,                     
NSX_Deposit money default 0,                                              
NSEFO_Margin money default 0,                                       
MCD_Margin money default 0,                                                  
NSX_MArgin money default 0,                                                  
NSEFO_Coll money default 0,                                                  
MCD_Coll money default 0,                                                  
NSX_Coll money default 0,                                                  
BSECM_USD money default 0,                                                  
NSECM_USD money default 0,                                                  
BSECM_Var money default 0,                                                  
NSECM_Var money default 0,                                                  
BSECM_UnRecoVal money default 0,                                              
NSECM_UnRecoVal money default 0,                                   
NSEFO_UnRecoVal money default 0,                                                  
MCD_UnRecoVal money default 0,                                                  
NSX_UnRecoVal money default 0,                                                  
UnRecoVal money default 0,                                                  
BSECM_ShrtVal money default 0,                                                  
NSECM_ShrtVal money default 0,                                                  
Net_Credit money default 0,                                                  
Total_Marg75 money default 0,                                                  
Intra_HghMrg_Cash  money default 0,                                       
Intra_HghMrg_FO  money default 0,                                                  
BSECM_Net money default 0,                                                  
NSECM_Net money default 0,                                                  
NSEFO_Net money default 0,                                                  
MCD_Net money default 0,                                                  
NSX_Net money default 0,                                                  
Final_Net  money default 0,                                                  
Update_date Datetime,                                                  
NSEFO_CashColl money default 0,                                                  
MCD_cashColl money default 0,                                                  
NSX_CashColl money default 0,                            
AccrualAmt money default 0          
)                                                  
                                      
truncate table #NEt                                                   
                                                  
insert into #NEt (party_Code,BSECM_Ledger) select cltcode,ledger from #bsecm_led                                           
                                                  
update #NEt set NSECM_Ledger=b.ledger from #nsecm_led b where #NEt.party_Code=b.cltcode                                                  
insert into #NEt (party_Code,NSECM_Ledger) select cltcode,ledger from #nsecm_led where cltcode not in (select party_Code from #net)                                                  
                                                  
update #NEt set NSEFO_Ledger=b.ledger from #nsefo_led b where #NEt.party_Code=b.cltcode                                        insert into #NEt (party_Code,NSEFO_Ledger) select cltcode,ledger from #nsefo_led     
where cltcode not in (select party_Code from #net)                                                  
    
                                         
update #NEt set MCDX_Ledger=b.ledger from #mcdx_led b where #NEt.party_Code=b.cltcode and b.ledger > 0                                                  
insert into #NEt (party_Code,MCDX_Ledger) select cltcode,ledger from #mcdx_led where cltcode not in (select party_Code from #net) and ledger > 0                                                  
                                                  
update #NEt set NCDX_Ledger=b.ledger from #ncdx_led b where #NEt.party_Code=b.cltcode and b.ledger > 0                                                  
insert into #NEt (party_Code,NCDX_Ledger) select cltcode,ledger from #ncdx_led where cltcode not in (select party_Code from #net) and ledger > 0                                                  
                                                  
update #NEt set MCD_Ledger=b.ledger from #mcd_led b where #NEt.party_Code=b.cltcode                                            
insert into #NEt (party_Code,MCD_Ledger) select cltcode,ledger from #mcd_led where cltcode not in (select party_Code from #net)                                                  
                                                  
update #NEt set NSX_Ledger=b.ledger from #nsx_led b where #NEt.party_Code=b.cltcode                                                   
insert into #NEt (party_Code,NSX_Ledger) select cltcode,ledger from #nsx_led where cltcode not in (select party_Code from #net)                                                  
                                                  
update #NEt set BSECM_Deposit=b.ledger from #bsecm_dep b where #NEt.party_Code=substring(b.cltcode,3,10)                                                  
update #NEt set NSECM_Deposit=b.ledger from #nsecm_dep b where #NEt.party_Code=substring(b.cltcode,3,10)                                        
update #NEt set NSEFO_Deposit=b.ledger from #nsefo_dep b where #NEt.party_Code=substring(b.cltcode,3,10)                                        
update #NEt set MCD_Deposit=b.ledger from #mcd_dep b where #NEt.party_Code=substring(b.cltcode,3,10)                                        
update #NEt set NSX_Deposit=b.ledger from #nsx_dep b where #NEt.party_Code=substring(b.cltcode,3,10)                                        
                                                  
delete from #net where isnumeric(substring(party_code,1,1))=1                                                  
-----------------------------                                                  
                                        
select clcode as cltcode,total,cash_coll,non_Cash into #fo from intranet.risk.dbo.fomarh with (nolock)                                                   
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.fomarh with (nolock) where sauda_date <= @tdate) and total > 0                                                  
                                  
select clcode as cltcode,total,cash_coll,non_Cash  into #mcd from intranet.risk.dbo.mcdmarh with (nolock)              
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.mcdmarh with (nolock) where sauda_date <= @tdate) and total > 0                                                  
                                                  
select clcode as cltcode,total,cash_coll,non_Cash  into #nsx from intranet.risk.dbo.fcmarh with (nolock)                                                   
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.fcmarh with (nolock) where sauda_date <= @tdate) and total > 0                                                  
                  
---------------------------------------- commo margin                  
                  
select clcode as cltcode,total,cash_coll,non_Cash into #ncdx from intranet.risk.dbo.ncdx_marh with (nolock)                                                   
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.ncdx_marh with (nolock) where sauda_date <= @tdate) and total > 0                                                  
                  
select clcode as cltcode,total,cash_coll,non_Cash into #mcdx from intranet.risk.dbo.mcdx_marh with (nolock)                                                   
where sauda_Date =(select max(sauda_date) from intranet.risk.dbo.mcdx_marh with (nolock) where sauda_date <= @tdate) and total > 0                                                  
                                                  
/*                            
update #NEt set nsefo_margin=b.total,nsefo_coll=b.cash_coll+b.non_Cash from #fo b where #NEt.party_Code=b.cltcode                                                  
update #NEt set mcd_margin=b.total,mcd_coll=b.cash_coll+b.non_Cash from #mcd b where #NEt.party_Code=b.cltcode                                                   
update #NEt set nsx_margin=b.total,nsx_coll=b.cash_coll+b.non_Cash from #nsx b where #NEt.party_Code=b.cltcode                              
*/                            
update #NEt set nsefo_margin=b.total,nsefo_coll=b.non_Cash,Nsefo_CashColl=b.cash_coll from #fo b where #NEt.party_Code=b.cltcode                                                   
update #NEt set mcd_margin=b.total,mcd_coll=b.non_Cash,mcd_CashColl=b.cash_coll from #mcd b where #NEt.party_Code=b.cltcode                                                   
update #NEt set nsx_margin=b.total,nsx_coll=b.non_Cash,nsx_CashColl=b.cash_coll from #nsx b where #NEt.party_Code=b.cltcode                                            
                  
                  
---- capturing commo margin in collateral                  
update #NEt set MCDX_Ledger=MCDX_Ledger+(b.total*.75) from #mcdx b where #NEt.party_Code=b.cltcode                                            
update #NEt set NCDX_Ledger=NCDX_Ledger+(b.total*.75) from #ncdx b where #NEt.party_Code=b.cltcode                                            
----                                                  
                  
                                                  
update #NEt set bsecm_var=b.varamt from #bsevar b where #net.party_code=b.party_code                                                  
update #NEt set nsecm_var=b.varamt from #nsevar b where #net.party_code=b.party_code                                                  
                                                  
update #NEt set bsecm_usd=b.us_debit from #bsecm_usd b where #net.party_code=b.cltcode                                                  
update #NEt set nsecm_usd=b.us_debit from #nsecm_usd b where #net.party_code=b.cltcode                                                  
                                                  
update #net set Intra_HghMrg_Cash=VarAmt from (select * from #maxvar where MaxVar=1 ) x where #net.party_code=x.party_Code                                         
update #net set Intra_HghMrg_FO=VarAmt from ( select * from #maxvar1 where MaxVar=1 ) x where #net.party_code=x.party_Code                                         
                                        
------------------------------------------------------------------------------------------------------------------------- Unreconsiled Value                                        
                                        
update #net set UnRecoVal=0,NSECM_ShrtVal =0,BSECM_ShrtVal =0                                        
                                        
update #net set UnRecoVal= UnRecoVal+b.UnrecoAmt,NSECM_UnrecoVal=b.UnrecoAmt                                       
from (select cltcode,UnrecoAmt=sum(cramt) from intranet.risk.dbo.NSECM_reco with (nolock) group by cltcode) b                                       
where #net.party_Code=b.cltcode                                                                                                          
                                        
update #net set UnRecoVal= UnRecoVal+b.UnrecoAmt,BSECM_UnrecoVal=b.UnrecoAmt                                        
from (select cltcode,UnrecoAmt=sum(cramt) from intranet.risk.dbo.BSECM_reco with (nolock) group by cltcode) b                                                           
where #net.party_Code=b.cltcode                                                                                                          
                                        
update #net set UnRecoVal= UnRecoVal+b.UnrecoAmt,NSEFO_UnrecoVal=b.UnrecoAmt                                        
from (select cltcode,UnrecoAmt=sum(cramt) from intranet.risk.dbo.NSEFO_reco with (nolock) group by cltcode) b                                                           
where #net.party_Code=b.cltcode                                                                                                          
                                        
update #net set UnRecoVal= UnRecoVal+b.UnrecoAmt,MCD_UnrecoVal=b.UnrecoAmt                                        
from (select cltcode,UnrecoAmt=sum(cramt) from intranet.risk.dbo.MCD_reco with (nolock) group by cltcode) b                                                           
where #net.party_Code=b.cltcode                                                  
                                        
update #net set UnRecoVal= UnRecoVal+b.UnrecoAmt,NSX_UnrecoVal=b.UnrecoAmt                                        
from (select cltcode,UnrecoAmt=sum(cramt) from intranet.risk.dbo.NSX_reco with (nolock) group by cltcode) b                                                   
where #net.party_Code=b.cltcode                                                                                                          
                                        
------------------------------------------------------------------------------------------------------------ Shortage Value                                        
                                        
update #net set NSECM_ShrtVal =x.Short_value from                                        
(                                        
select party_code,Short_value=sum(DedVal) from SCCS_T3_Shortage where segment='NSE' group by party_code                      
/*                      
select a.party_Code,Short_value=sum(Act_short_qty*isnull(b.cls,0)) from                                         
/* (select * from intranet.risk.dbo.CMSVerified_Cash_ShrtVal with (nolock) where seg='NSE') a */                                       
(select sett_no,Sett_type,party_code,scrip_cd,Act_short_qty=DelQty-RecQty from intranet.risk.dbo.NSECM_Shortage where sett_Type not in ('N','W')) a                          
left outer join  intranet.risk.dbo.md b with (nolock) on a.scrip_cd=b.scrip                                        
group by party_code                                        
*/                      
) x where #net.party_Code=x.party_Code                                        
                                        
update #net set BSECM_ShrtVal =x.Short_value from                                        
(                      
select party_code,Short_value=sum(DedVal) from SCCS_T3_Shortage where segment='BSE' group by party_code                      
/*                                        
select a.party_Code,Short_value=sum(Act_short_qty*isnull(b.rate,0)) from                                         
/* (select * from intranet.risk.dbo.CMSVerified_Cash_ShrtVal with (nolock) where seg='BSE') a */                                       
(select sett_no,Sett_type,party_code,scrip_cd,Act_short_qty=DelQty-RecQty from intranet.risk.dbo.BSECM_Shortage where sett_Type not in ('D','C')) a                          
left outer join  intranet.risk.dbo.cp b with (nolock) on a.scrip_cd=b.scode                                        
group by party_code                                        
*/                      
) x where #net.party_Code=x.party_Code                                         
                                         
------------------------------------------------------------------------------------------------------------ Calculate Net Credit                                        
update #Net set bsecm_net=bsecm_ledger+bsecm_usd+bsecm_var+bsecm_deposit+BSECM_UnRecoVal+BSECM_ShrtVal                                        
update #Net set nsecm_net=nsecm_ledger+nsecm_usd+nsecm_var+nsecm_deposit+NSECM_UnRecoVal+NSECM_ShrtVal                                        
                     
/*                            
update #Net set nsefo_net=(case                                                   
when nsefo_ledger >= 0 AND nsefo_margin>0  THEN nsefo_margin+nsefo_ledger                                               
when nsefo_ledger < 0 AND nsefo_margin >0  and nsefo_margin <= (nsefo_ledger*-1) THEN nsefo_margin+nsefo_ledger                                               
when nsefo_ledger < 0 AND nsefo_margin >0  and nsefo_margin > (nsefo_ledger*-1) AND nsefo_margin+nsefo_ledger-nsefo_coll < 0 THEN 0                                              
when nsefo_ledger < 0 AND nsefo_margin >0  and nsefo_margin > (nsefo_ledger*-1) AND nsefo_margin+nsefo_ledger-nsefo_coll > 0 THEN nsefo_margin+nsefo_ledger-nsefo_coll                                               
ELSE nsefo_ledger END)+nsefo_deposit+(nsefo_margin*0.75)+NSEFO_UnRecoVal                                        
*/                            
                  
update #Net set nsefo_net=(Case When nsefo_margin-nsefo_CashColl <= 0 then nsefo_ledger else nsefo_margin-nsefo_CashColl+nsefo_ledger end) +nsefo_deposit+(nsefo_margin*0.75)+NSEFO_UnRecoVal                            
                  
/*                                      
update #Net set mcd_net=                                        
(case                                                   
when MCD_ledger >= 0 AND MCD_margin>0  THEN MCD_margin+MCD_ledger                                               
when MCD_ledger < 0 AND MCD_margin >0  and MCD_margin <= (MCD_ledger*-1) THEN MCD_margin+MCD_ledger                                               
when MCD_ledger < 0 AND MCD_margin >0 and MCD_margin > (MCD_ledger*-1) AND MCD_margin+MCD_ledger-MCD_coll < 0 THEN 0                                              
when MCD_ledger < 0 AND MCD_margin >0  and MCD_margin > (MCD_ledger*-1) AND MCD_margin+MCD_ledger-MCD_coll > 0 THEN MCD_margin+MCD_ledger-MCD_coll                                               
ELSE MCD_ledger END)+mcd_deposit+(mcd_margin*0.75)+MCD_UnRecoVal                                        
*/                            
update #Net set mcd_net=(Case When MCD_margin-mcd_CashColl <= 0 then MCD_ledger else MCD_margin-mcd_CashColl+MCD_ledger end) +mcd_deposit+(mcd_margin*0.75)+MCD_UnRecoVal                              
                                        
/*                            
update #Net set nsx_net=(case                                                   
when nsx_ledger >= 0 AND nsx_margin>0  THEN nsx_margin+nsx_ledger                                               
when nsx_ledger < 0 AND nsx_margin >0  and nsx_margin <= (nsx_ledger*-1) THEN nsx_margin+nsx_ledger                                               
when nsx_ledger < 0 AND nsx_margin >0  and nsx_margin > (nsx_ledger*-1) AND nsx_margin+nsx_ledger-nsx_coll < 0 THEN 0                                              
when nsx_ledger < 0 AND nsx_margin >0  and nsx_margin > (nsx_ledger*-1) AND nsx_margin+nsx_ledger-nsx_coll > 0 THEN nsx_margin+nsx_ledger-nsx_coll                                               
ELSE nsx_ledger END)+nsx_deposit+(MCD_margin*0.75)+NSX_UnRecoVal                                        
*/                            
update #Net set nsx_net=(Case When nsx_margin-nsx_CashColl <= 0 then nsx_ledger else nsx_margin-nsx_CashColl+nsx_ledger end) +nsx_deposit+(nsx_margin*0.75)+nsx_UnRecoVal                              
                                        
/*                                        
update #NEt set net_credit=                                                   
bsecm_ledger+bsecm_usd+bsecm_var+bsecm_deposit+                                                  
nsecm_ledger+nsecm_usd+nsecm_var+nsecm_deposit+                                                            
(case                                                   
when nsefo_ledger >= 0 AND nsefo_margin>0  THEN nsefo_margin+nsefo_ledger                                               
when nsefo_ledger < 0 AND nsefo_margin >0  and nsefo_margin <= (nsefo_ledger*-1) THEN nsefo_margin+nsefo_ledger                                               
when nsefo_ledger < 0 AND nsefo_margin >0  and nsefo_margin > (nsefo_ledger*-1) AND nsefo_margin+nsefo_ledger-nsefo_coll < 0 THEN 0                                              
when nsefo_ledger < 0 AND nsefo_margin >0  and nsefo_margin > (nsefo_ledger*-1) AND nsefo_margin+nsefo_ledger-nsefo_coll > 0 THEN nsefo_margin+nsefo_ledger-nsefo_coll                                               
ELSE nsefo_ledger END                                              
)+                                                 
(case                                                   
when MCD_ledger >= 0 AND MCD_margin>0  THEN MCD_margin+MCD_ledger                                               
when MCD_ledger < 0 AND MCD_margin >0  and MCD_margin <= (MCD_ledger*-1) THEN MCD_margin+MCD_ledger                                               
when MCD_ledger < 0 AND MCD_margin >0  and MCD_margin > (MCD_ledger*-1) AND MCD_margin+MCD_ledger-MCD_coll < 0 THEN 0             
when MCD_ledger < 0 AND MCD_margin >0  and MCD_margin > (MCD_ledger*-1) AND MCD_margin+MCD_ledger-MCD_coll > 0 THEN MCD_margin+MCD_ledger-MCD_coll                                               
ELSE MCD_ledger END                                              
)+                                                  
(case                                           
when nsx_ledger >= 0 AND nsx_margin>0  THEN nsx_margin+nsx_ledger                                               
when nsx_ledger < 0 AND nsx_margin >0  and nsx_margin <= (nsx_ledger*-1) THEN nsx_margin+nsx_ledger                                               
when nsx_ledger < 0 AND nsx_margin >0  and nsx_margin > (nsx_ledger*-1) AND nsx_margin+nsx_ledger-nsx_coll < 0 THEN 0                                              
when nsx_ledger < 0 AND nsx_margin >0  and nsx_margin > (nsx_ledger*-1) AND nsx_margin+nsx_ledger-nsx_coll > 0 THEN nsx_margin+nsx_ledger-nsx_coll                                               
ELSE nsx_ledger END                                              
)+nsefo_deposit+mcd_deposit+nsx_deposit+                                                  
(case when mcdx_ledger+ncdx_ledger > 0 then mcdx_ledger+ncdx_ledger else 0 end)                                        
+((nsx_margin+MCD_margin+nsefo_margin)*0.75)                                        
+Intra_HghMrg_FO+Intra_HghMrg_Cash                                        
+UnRecoVal                                        
*/                                        
                                        
update #net set net_credit=(BSECM_Net+NSECM_Net+NSEFO_Net+MCD_Net+NSX_Net)+Intra_HghMrg_FO+Intra_HghMrg_Cash                                        
+(case when mcdx_ledger+ncdx_ledger > 0 then mcdx_ledger+ncdx_ledger else 0 end)+BSECM_ShrtVal+NSECM_ShrtVal                                        
                                        
                                        
/* delete from #net where net_credit >= 0 */                                        
          
update #NEt set update_date=@tdate                                                  
                   
/*Accrual Amount update*/                                         
update #net set AccrualAmt=penal from           
(select  party_code,penal from intranet.misc.dbo.Accrued_PenalCharges with (nolock)) a           
where #net.party_code=a.party_code          
          
                                    
truncate table SCCS_Data                                         
insert into SCCS_Data select * from #net                                                  
              
if @processType='F'              
BEGIN              
 insert into SCCS_Data_hist select * from SCCS_Data                                    
END              
  
if @processType='C'              
BEGIN              
 exec SCCS_cmsData_process 'C'  
 exec USP_BSE_ShPayout_Credit 'C'               
END                           
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.vw_sccs_po_summary_hist_proc
-- --------------------------------------------------
CREATE procedure vw_sccs_po_summary_hist_proc (@date as varchar(11))  
as  
  
--declare @date as varchar(11)  
--set @date='4 sep 2010'  
  
select q.client as party_Code,Blocked as [Blocked Funds],[Holding Value] ,[payout Value] 
from        
(        
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from         
(        
select party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],        
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)       
as Blocked  from         
(select party_Code,net_credit from SCCS_Data_hist with (nolock) where update_date = convert(datetime,@date+' 23:59:59') )a        
left outer join (select cltcode,chqamt from SCCS_cmsdata_hist with (nolock) where updt=convert(datetime,@date))b   
on a.party_Code=b.cltcode         
) x left outer join         
(select party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal) from   
(select         
party_code,exchange,scrip_cd,symbol,series,isin,FDPid,FCltid,Bankid,Cltdpid,        
HldVal,Qty as [Actual Qty],Qty_Allowed as [Payout Qty],(HldVal/Qty)*Qty_Allowed as PayoutVal,update_date        
from SCCS_Sharepo_hist with (nolock) where update_date = convert(datetime,@date+' 23:59:59') )a  
 group by party_code)        
y on x.party_Code=y.party_Code        
) p         
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client

GO

-- --------------------------------------------------
-- TABLE dbo.BSET3Shrt
-- --------------------------------------------------
CREATE TABLE [dbo].[BSET3Shrt]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(3) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(25) NULL,
    [partyname] VARCHAR(50) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [marketrate] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BSET3Shrt_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[BSET3Shrt_hist]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(3) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(25) NULL,
    [partyname] VARCHAR(50) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [marketrate] MONEY NULL,
    [updateDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.CMS_cmsdata_BackUp
-- --------------------------------------------------
CREATE TABLE [dbo].[CMS_cmsdata_BackUp]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DKM_rpt
-- --------------------------------------------------
CREATE TABLE [dbo].[DKM_rpt]
(
    [Update_date] DATETIME NULL,
    [sbtag] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_Code] VARCHAR(10) NULL,
    [TRADERNAME] VARCHAR(100) NULL,
    [ABL] FLOAT NULL,
    [ACDL] FLOAT NULL,
    [CASH_DEPOSIT] FLOAT NULL,
    [holding] FLOAT NULL,
    [appr] FLOAT NULL,
    [nonappr] FLOAT NULL,
    [NBFC] MONEY NULL,
    [nbfc_hold] MONEY NULL,
    [nbfc_hdfc] MONEY NULL,
    [FO] MONEY NULL,
    [NCDX] MONEY NULL,
    [MCDX] MONEY NULL,
    [debit] FLOAT NULL,
    [limit] MONEY NULL,
    [net_def] FLOAT NULL,
    [noofdays] INT NULL,
    [MCD] MONEY NULL,
    [NSX] MONEY NULL,
    [ChqAmtRecThereAfter] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DKM_rpt1
-- --------------------------------------------------
CREATE TABLE [dbo].[DKM_rpt1]
(
    [Update_date] DATETIME NULL,
    [sbtag] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_Code] VARCHAR(10) NULL,
    [TRADERNAME] VARCHAR(100) NULL,
    [ABL] FLOAT NULL,
    [ACDL] FLOAT NULL,
    [CASH_DEPOSIT] FLOAT NULL,
    [holding] FLOAT NULL,
    [appr] FLOAT NULL,
    [nonappr] FLOAT NULL,
    [NBFC] MONEY NULL,
    [nbfc_hold] MONEY NULL,
    [nbfc_hdfc] MONEY NULL,
    [FO] MONEY NULL,
    [NCDX] MONEY NULL,
    [MCDX] MONEY NULL,
    [debit] FLOAT NULL,
    [limit] MONEY NULL,
    [net_def] FLOAT NULL,
    [noofdays] INT NULL,
    [MCD] MONEY NULL,
    [NSX] MONEY NULL,
    [ChqAmtRecThereAfter] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.dkm_SCCS_mis
-- --------------------------------------------------
CREATE TABLE [dbo].[dkm_SCCS_mis]
(
    [update_date] DATETIME NULL,
    [region] VARCHAR(255) NULL,
    [branch] VARCHAR(10) NULL,
    [sb] VARCHAR(10) NULL,
    [party_Code] VARCHAR(10) NULL,
    [opcode] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [clitype] CHAR(3) NULL,
    [Net Credit] MONEY NULL,
    [Funds Payout] MONEY NULL,
    [Blocked Funds] MONEY NULL,
    [Payout value] FLOAT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Fmt_Hld_Fcr2
-- --------------------------------------------------
CREATE TABLE [dbo].[Fmt_Hld_Fcr2]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [isin] VARCHAR(15) NULL,
    [Qty] FLOAT NULL,
    [FDPid] VARCHAR(16) NULL,
    [FCltid] VARCHAR(20) NULL,
    [Bankid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(8) NULL,
    [REM] VARCHAR(3) NOT NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [HldVal] FLOAT NULL,
    [Block] VARCHAR(1) NOT NULL,
    [Qty_Allowed] INT NULL,
    [BSECM_ShrtValAftAdj] MONEY NULL DEFAULT ((0)),
    [symbol] VARCHAR(12) NULL,
    [series] VARCHAR(12) NULL,
    [approved] INT NULL,
    [dedval] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MIS_pldg_sccs
-- --------------------------------------------------
CREATE TABLE [dbo].[MIS_pldg_sccs]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_Cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [Qty] FLOAT NULL,
    [Total] MONEY NULL,
    [Pledge_qty] FLOAT NOT NULL,
    [PO_Qty] INT NOT NULL,
    [PO_Val] FLOAT NOT NULL,
    [FLAG] VARCHAR(1) NULL,
    [BANK] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSET3Shrt
-- --------------------------------------------------
CREATE TABLE [dbo].[NSET3Shrt]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(3) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(25) NULL,
    [partyname] VARCHAR(50) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [marketrate] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSET3Shrt_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[NSET3Shrt_hist]
(
    [isin] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [series] VARCHAR(25) NULL,
    [sett_no] VARCHAR(10) NULL,
    [sett_type] VARCHAR(5) NULL,
    [party_Code] VARCHAR(10) NULL,
    [bs] VARCHAR(1) NULL,
    [exchange] VARCHAR(3) NULL,
    [qty] FLOAT NULL,
    [clsrate] MONEY NULL,
    [accno] VARCHAR(20) NULL,
    [dpid] VARCHAR(20) NULL,
    [clid] VARCHAR(20) NULL,
    [flag] VARCHAR(10) NULL,
    [aben] MONEY NULL,
    [apool] MONEY NULL,
    [nben] MONEY NULL,
    [npool] MONEY NULL,
    [approved] VARCHAR(10) NULL,
    [scripname] VARCHAR(25) NULL,
    [partyname] VARCHAR(50) NULL,
    [pool] VARCHAR(10) NULL,
    [total] MONEY NULL,
    [DUMMY1] VARCHAR(50) NULL,
    [DUMMY2] VARCHAR(50) NULL,
    [nse_approved] VARCHAR(10) NULL,
    [marketrate] MONEY NULL,
    [updateDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_mcd
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_mcd]
(
    [party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_Client_Vertical
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_Client_Vertical]
(
    [Zone] VARCHAR(20) NULL,
    [Region] VARCHAR(255) NULL,
    [RegionName] VARCHAR(255) NULL,
    [Branch] VARCHAR(10) NULL,
    [BranchName] VARCHAR(100) NULL,
    [SB] VARCHAR(10) NULL,
    [SB_Name] VARCHAR(52) NULL,
    [Client] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [CliType] CHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_1100check
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_1100check]
(
    [nse_approved] VARCHAR(10) NULL,
    [value] MONEY NULL,
    [APP] INT NULL,
    [TotalHolding] FLOAT NULL,
    [TotalPayout] FLOAT NULL,
    [BlockedPO] FLOAT NULL,
    [Update_date] VARCHAR(11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Sccs_blk_isin
-- --------------------------------------------------
CREATE TABLE [dbo].[Sccs_blk_isin]
(
    [isin] VARCHAR(25) NULL,
    [uploadBy] VARCHAR(10) NULL,
    [ipaddr] VARCHAR(15) NULL,
    [UploadOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_client_bulk
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_client_bulk]
(
    [Party_Code] VARCHAR(15) NULL,
    [Reason] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_client_bulk_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_client_bulk_temp]
(
    [Party_Code] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_ClientMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_ClientMaster]
(
    [Party_code] VARCHAR(50) NULL,
    [SCCS_SettDate_Last] DATETIME NULL,
    [SCCS_SettDate_Next] DATETIME NULL,
    [RAA_Date] DATETIME NULL,
    [RAA_Expiry_Date] DATETIME NULL,
    [Exclude] VARCHAR(3) NULL,
    [Remark] VARCHAR(35) NULL,
    [dormant] VARCHAR(1) NULL DEFAULT 'N',
    [updatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_ClientMaster_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_ClientMaster_hist]
(
    [Party_code] VARCHAR(50) NULL,
    [SCCS_SettDate_Last] DATETIME NULL,
    [SCCS_SettDate_Next] DATETIME NULL,
    [RAA_Date] DATETIME NULL,
    [RAA_Expiry_Date] DATETIME NULL,
    [Exclude] VARCHAR(3) NULL,
    [Remark] VARCHAR(35) NULL,
    [dormant] VARCHAR(1) NULL,
    [updatedOn] DATETIME NULL,
    [HistDate] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_clientmaster_JulSep10
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_clientmaster_JulSep10]
(
    [party_code] VARCHAR(10) NOT NULL,
    [Sccs_settDate_last] DATETIME NULL,
    [next_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_ClientMaster_provisional
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_ClientMaster_provisional]
(
    [Party_code] VARCHAR(50) NULL,
    [SCCS_SettDate_Last] DATETIME NULL,
    [SCCS_SettDate_Next] DATETIME NULL,
    [RAA_Date] DATETIME NULL,
    [RAA_Expiry_Date] DATETIME NULL,
    [Exclude] VARCHAR(3) NULL,
    [Remark] VARCHAR(100) NULL,
    [dormant] VARCHAR(1) NULL,
    [updatedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_CltExMast
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_CltExMast]
(
    [Party_code] VARCHAR(10) NOT NULL,
    [Remark] VARCHAR(50) NULL,
    [ExcludeDate] DATETIME NULL,
    [Status] VARCHAR(2) NULL,
    [UploadBy] VARCHAR(10) NULL,
    [UploadDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_CMS_online_Marked
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_CMS_online_Marked]
(
    [RefNo] INT IDENTITY(1,1) NOT NULL,
    [Cltcode] VARCHAR(12) NOT NULL,
    [PayMode] VARCHAR(6) NULL,
    [Bank_Name] VARCHAR(14) NULL,
    [AccNo] VARCHAR(20) NULL,
    [AmtMarked] MONEY NULL,
    [MarkedDate] DATETIME NOT NULL,
    [flag] VARCHAR(1) NULL,
    [ChqMark] VARCHAR(1) NULL,
    [EnteredBy] VARCHAR(15) NULL,
    [LastModifiedBy] VARCHAR(15) NULL,
    [LastModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cms_online_marked_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cms_online_marked_hist]
(
    [RefNo] INT NOT NULL,
    [Cltcode] VARCHAR(12) NOT NULL,
    [PayMode] VARCHAR(6) NULL,
    [Bank_Name] VARCHAR(14) NULL,
    [AccNo] VARCHAR(20) NULL,
    [AmtMarked] MONEY NULL,
    [MarkedDate] DATETIME NOT NULL,
    [flag] VARCHAR(1) NULL,
    [ChqMark] VARCHAR(1) NULL,
    [EnteredBy] VARCHAR(15) NULL,
    [LastModifiedBy] VARCHAR(15) NULL,
    [LastModifiedOn] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_cmsdata
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_cmsdata]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_1
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_1]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_2
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_2]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_all_cltPro
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_all_cltPro]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_hist]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_MUM
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_MUM]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_cMSDATA_nonup
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_cMSDATA_nonup]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_CMSDATA_UP
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_CMSDATA_UP]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_withacc
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_withacc]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata_woacc
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata_woacc]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata1
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata1]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_cmsdata2
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_cmsdata2]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_Data
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_Data]
(
    [Party_code] VARCHAR(10) NULL,
    [BSECM_Ledger] MONEY NULL,
    [NSECM_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCDX_Ledger] MONEY NULL,
    [NCDX_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [BSECM_Deposit] MONEY NULL,
    [NSECM_Deposit] MONEY NULL,
    [NSEFO_Deposit] MONEY NULL,
    [MCD_Deposit] MONEY NULL,
    [NSX_Deposit] MONEY NULL,
    [NSEFO_Margin] MONEY NULL,
    [MCD_Margin] MONEY NULL,
    [NSX_MArgin] MONEY NULL,
    [NSEFO_Coll] MONEY NULL,
    [MCD_Coll] MONEY NULL,
    [NSX_Coll] MONEY NULL,
    [BSECM_USD] MONEY NULL,
    [NSECM_USD] MONEY NULL,
    [BSECM_Var] MONEY NULL,
    [NSECM_Var] MONEY NULL,
    [BSECM_UnRecoVal] MONEY NULL,
    [NSECM_UnRecoVal] MONEY NULL,
    [NSEFO_UnRecoVal] MONEY NULL,
    [MCD_UnRecoVal] MONEY NULL,
    [NSX_UnRecoVal] MONEY NULL,
    [UnRecoVal] MONEY NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [Net_Credit] MONEY NULL,
    [Total_Marg75] MONEY NULL,
    [Intra_HghMrg_Cash] MONEY NULL,
    [Intra_HghMrg_FO] MONEY NULL,
    [BSECM_Net] MONEY NULL,
    [NSECM_Net] MONEY NULL,
    [NSEFO_Net] MONEY NULL,
    [MCD_Net] MONEY NULL,
    [NSX_Net] MONEY NULL,
    [Final_Net] MONEY NULL,
    [Update_date] DATETIME NULL,
    [NSEFO_CashColl] MONEY NULL DEFAULT ((0)),
    [MCD_cashColl] MONEY NULL DEFAULT ((0)),
    [NSX_CashColl] MONEY NULL DEFAULT ((0)),
    [AccrualAmt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_data_all_cltPro
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_data_all_cltPro]
(
    [Party_code] VARCHAR(10) NULL,
    [BSECM_Ledger] MONEY NULL,
    [NSECM_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCDX_Ledger] MONEY NULL,
    [NCDX_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [BSECM_Deposit] MONEY NULL,
    [NSECM_Deposit] MONEY NULL,
    [NSEFO_Deposit] MONEY NULL,
    [MCD_Deposit] MONEY NULL,
    [NSX_Deposit] MONEY NULL,
    [NSEFO_Margin] MONEY NULL,
    [MCD_Margin] MONEY NULL,
    [NSX_MArgin] MONEY NULL,
    [NSEFO_Coll] MONEY NULL,
    [MCD_Coll] MONEY NULL,
    [NSX_Coll] MONEY NULL,
    [BSECM_USD] MONEY NULL,
    [NSECM_USD] MONEY NULL,
    [BSECM_Var] MONEY NULL,
    [NSECM_Var] MONEY NULL,
    [BSECM_UnRecoVal] MONEY NULL,
    [NSECM_UnRecoVal] MONEY NULL,
    [NSEFO_UnRecoVal] MONEY NULL,
    [MCD_UnRecoVal] MONEY NULL,
    [NSX_UnRecoVal] MONEY NULL,
    [UnRecoVal] MONEY NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [Net_Credit] MONEY NULL,
    [Total_Marg75] MONEY NULL,
    [Intra_HghMrg_Cash] MONEY NULL,
    [Intra_HghMrg_FO] MONEY NULL,
    [BSECM_Net] MONEY NULL,
    [NSECM_Net] MONEY NULL,
    [NSEFO_Net] MONEY NULL,
    [MCD_Net] MONEY NULL,
    [NSX_Net] MONEY NULL,
    [Final_Net] MONEY NULL,
    [Update_date] DATETIME NULL,
    [NSEFO_CashColl] MONEY NULL,
    [MCD_cashColl] MONEY NULL,
    [NSX_CashColl] MONEY NULL,
    [AccrualAmt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_Data_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_Data_hist]
(
    [Party_code] VARCHAR(10) NULL,
    [BSECM_Ledger] MONEY NULL,
    [NSECM_Ledger] MONEY NULL,
    [NSEFO_Ledger] MONEY NULL,
    [MCDX_Ledger] MONEY NULL,
    [NCDX_Ledger] MONEY NULL,
    [MCD_Ledger] MONEY NULL,
    [NSX_Ledger] MONEY NULL,
    [BSECM_Deposit] MONEY NULL,
    [NSECM_Deposit] MONEY NULL,
    [NSEFO_Deposit] MONEY NULL,
    [MCD_Deposit] MONEY NULL,
    [NSX_Deposit] MONEY NULL,
    [NSEFO_Margin] MONEY NULL,
    [MCD_Margin] MONEY NULL,
    [NSX_MArgin] MONEY NULL,
    [NSEFO_Coll] MONEY NULL,
    [MCD_Coll] MONEY NULL,
    [NSX_Coll] MONEY NULL,
    [BSECM_USD] MONEY NULL,
    [NSECM_USD] MONEY NULL,
    [BSECM_Var] MONEY NULL,
    [NSECM_Var] MONEY NULL,
    [BSECM_UnRecoVal] MONEY NULL,
    [NSECM_UnRecoVal] MONEY NULL,
    [NSEFO_UnRecoVal] MONEY NULL,
    [MCD_UnRecoVal] MONEY NULL,
    [NSX_UnRecoVal] MONEY NULL,
    [UnRecoVal] MONEY NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [Net_Credit] MONEY NULL,
    [Total_Marg75] MONEY NULL,
    [Intra_HghMrg_Cash] MONEY NULL,
    [Intra_HghMrg_FO] MONEY NULL,
    [BSECM_Net] MONEY NULL,
    [NSECM_Net] MONEY NULL,
    [NSEFO_Net] MONEY NULL,
    [MCD_Net] MONEY NULL,
    [NSX_Net] MONEY NULL,
    [Final_Net] MONEY NULL,
    [Update_date] DATETIME NULL,
    [NSEFO_CashColl] MONEY NULL DEFAULT ((0)),
    [MCD_cashColl] MONEY NULL DEFAULT ((0)),
    [NSX_CashColl] MONEY NULL DEFAULT ((0)),
    [AccrualAmt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_Jul
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_Jul]
(
    [Party_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_ledger0md
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_ledger0md]
(
    [party_code] VARCHAR(10) NULL,
    [update_date] DATETIME NULL,
    [debit] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_legalBlkClt
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_legalBlkClt]
(
    [Party_code] VARCHAR(10) NULL,
    [Uploaded_On] DATETIME NULL,
    [Uploaded_By] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_MIS_PO
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_MIS_PO]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_Cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [Qty] FLOAT NULL,
    [Total] MONEY NULL,
    [Pledge_qty] FLOAT NOT NULL,
    [PO_Qty] INT NOT NULL,
    [PO_Val] FLOAT NOT NULL,
    [FLAG] VARCHAR(1) NULL,
    [Bank] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_NEFT_BankFile
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_NEFT_BankFile]
(
    [GeneratedDate] DATETIME NOT NULL,
    [RefNo] INT NOT NULL,
    [Name] CHAR(100) NULL,
    [amt] MONEY NOT NULL,
    [cltcode] VARCHAR(12) NULL,
    [accno] VARCHAR(20) NULL,
    [co] VARCHAR(6) NOT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(12) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_address4] VARCHAR(51) NULL,
    [IFSC_Code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_NEFT_BankFile_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_NEFT_BankFile_hist]
(
    [GeneratedDate] DATETIME NOT NULL,
    [RefNo] INT NOT NULL,
    [Name] CHAR(100) NULL,
    [amt] MONEY NOT NULL,
    [cltcode] VARCHAR(12) NULL,
    [accno] VARCHAR(20) NULL,
    [co] VARCHAR(6) NOT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [party_code] VARCHAR(12) NULL,
    [l_address1] VARCHAR(40) NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_address4] VARCHAR(51) NULL,
    [IFSC_Code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_ONFT_BankFile
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_ONFT_BankFile]
(
    [GeneratedDate] DATETIME NOT NULL,
    [RefNo] INT NOT NULL,
    [Name] VARCHAR(100) NULL,
    [amt] MONEY NOT NULL,
    [cltcode] VARCHAR(10) NULL,
    [accno] VARCHAR(16) NOT NULL,
    [co] VARCHAR(6) NOT NULL,
    [branch] VARCHAR(8) NULL,
    [city] VARCHAR(25) NULL,
    [OurAccno] VARCHAR(15) NULL,
    [segment] VARCHAR(8) NULL,
    [bank] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_ONFT_BankFile_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_ONFT_BankFile_hist]
(
    [GeneratedDate] DATETIME NOT NULL,
    [RefNo] INT NOT NULL,
    [Name] VARCHAR(100) NULL,
    [amt] MONEY NOT NULL,
    [cltcode] VARCHAR(10) NULL,
    [accno] VARCHAR(16) NOT NULL,
    [co] VARCHAR(6) NOT NULL,
    [branch] VARCHAR(8) NULL,
    [city] VARCHAR(25) NULL,
    [OurAccno] VARCHAR(15) NULL,
    [segment] VARCHAR(8) NULL,
    [bank] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_Pro_Date
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_Pro_Date]
(
    [Date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_process_status
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_process_status]
(
    [srno] INT NULL,
    [SUB_SRNO] INT NULL,
    [server] VARCHAR(25) NULL,
    [db] VARCHAR(50) NULL,
    [type] VARCHAR(10) NULL,
    [query] VARCHAR(200) NULL,
    [parameter] VARCHAR(3) NULL,
    [status] INT NULL,
    [PRO_DESC] VARCHAR(200) NULL,
    [START_TIME] DATETIME NULL,
    [END_TIME] DATETIME NULL,
    [UpdateBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_process_status1
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_process_status1]
(
    [srno] INT NULL,
    [SUB_SRNO] INT NULL,
    [server] VARCHAR(25) NULL,
    [db] VARCHAR(50) NULL,
    [type] VARCHAR(10) NULL,
    [query] VARCHAR(200) NULL,
    [status] INT NULL,
    [PRO_DESC] VARCHAR(200) NULL,
    [START_TIME] DATETIME NULL,
    [END_TIME] DATETIME NULL,
    [UpdateBy] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_SharePO
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_SharePO]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [isin] VARCHAR(15) NULL,
    [Qty] FLOAT NULL,
    [FDPid] VARCHAR(16) NULL,
    [FCltid] VARCHAR(20) NULL,
    [Bankid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(8) NULL,
    [REM] VARCHAR(3) NOT NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [HldVal] FLOAT NULL,
    [Block] VARCHAR(1) NOT NULL,
    [Qty_Allowed] INT NULL,
    [BSECM_ShrtValAftAdj] MONEY NULL,
    [symbol] VARCHAR(12) NULL,
    [series] VARCHAR(12) NULL,
    [approved] INT NULL,
    [dedval] MONEY NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_Sharepo_all_cltPro
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_Sharepo_all_cltPro]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [isin] VARCHAR(15) NULL,
    [Qty] FLOAT NULL,
    [FDPid] VARCHAR(16) NULL,
    [FCltid] VARCHAR(20) NULL,
    [Bankid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(8) NULL,
    [REM] VARCHAR(3) NOT NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [HldVal] FLOAT NULL,
    [Block] VARCHAR(1) NOT NULL,
    [Qty_Allowed] INT NULL,
    [BSECM_ShrtValAftAdj] MONEY NULL,
    [symbol] VARCHAR(12) NULL,
    [series] VARCHAR(12) NULL,
    [approved] INT NULL,
    [dedval] MONEY NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sccs_sharePO_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[sccs_sharePO_hist]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [isin] VARCHAR(15) NULL,
    [Qty] FLOAT NULL,
    [FDPid] VARCHAR(16) NULL,
    [FCltid] VARCHAR(20) NULL,
    [Bankid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(8) NULL,
    [REM] VARCHAR(3) NOT NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [HldVal] FLOAT NULL,
    [Block] VARCHAR(1) NOT NULL,
    [Qty_Allowed] INT NULL,
    [BSECM_ShrtValAftAdj] MONEY NULL,
    [symbol] VARCHAR(12) NULL,
    [series] VARCHAR(12) NULL,
    [approved] INT NULL,
    [dedval] MONEY NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_tbl_JVControlMaster
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_tbl_JVControlMaster]
(
    [Fld_SrNo] INT IDENTITY(1,1) NOT NULL,
    [Fld_FromSegment] VARCHAR(10) NULL,
    [Fld_ToSegment] VARCHAR(10) NULL,
    [Fld_FromControlAc] INT NULL,
    [Fld_ToControlAc] INT NULL,
    [Fld_FromNarration] VARCHAR(50) NULL,
    [Fld_ToNarration] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NRI_CLmst
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NRI_CLmst]
(
    [Party_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_SCCS_legal
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_SCCS_legal]
(
    [Party_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_SCCS_MISrpt
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_SCCS_MISrpt]
(
    [Party_code] VARCHAR(50) NULL,
    [SCCS_dt] VARCHAR(11) NULL,
    [Chqamt] MONEY NOT NULL,
    [PO_Val] FLOAT NOT NULL,
    [comb_Last_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblFileSCCS
-- --------------------------------------------------
CREATE TABLE [dbo].[tblFileSCCS]
(
    [FldData] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblFileSCCS_Deposit
-- --------------------------------------------------
CREATE TABLE [dbo].[tblFileSCCS_Deposit]
(
    [FldData] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tblSCCSPledge_data
-- --------------------------------------------------
CREATE TABLE [dbo].[tblSCCSPledge_data]
(
    [Scrip_Cd] VARCHAR(15) NULL,
    [isin] VARCHAR(20) NULL,
    [party_code] VARCHAR(10) NULL,
    [Accno] VARCHAR(20) NULL,
    [qty] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TEMP_CMSDATA
-- --------------------------------------------------
CREATE TABLE [dbo].[TEMP_CMSDATA]
(
    [updt] DATETIME NULL,
    [branch] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [party_name] VARCHAR(100) NULL,
    [cltcode] VARCHAR(10) NULL,
    [acdl_effbal] MONEY NULL,
    [acdl_actbal] MONEY NULL,
    [abl_effbal] MONEY NULL,
    [abl_Actbal] MONEY NULL,
    [chqamt] MONEY NULL,
    [holding] MONEY NULL,
    [family] VARCHAR(10) NULL,
    [eff_fambal] MONEY NULL,
    [act_fambal] MONEY NULL,
    [fo_effbal] MONEY NULL,
    [fo_actbal] MONEY NULL,
    [acdlcm_amt] MONEY NULL,
    [acdlfo_amt] MONEY NULL,
    [ablcm_amt] MONEY NULL,
    [maker] VARCHAR(100) NULL,
    [checker] VARCHAR(100) NULL,
    [generated] VARCHAR(10) NULL,
    [ncdx_effbal] MONEY NULL,
    [ncdx_Actbal] MONEY NULL,
    [mcdx_effbal] MONEY NULL,
    [mcdx_Actbal] MONEY NULL,
    [ncdx_amt] MONEY NULL,
    [mcdx] MONEY NULL,
    [mcd_effbal] MONEY NULL,
    [mcd_Actbal] MONEY NULL,
    [mcd_amt] MONEY NULL,
    [nsx_effbal] MONEY NULL,
    [nsx_Actbal] MONEY NULL,
    [nsx_amt] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_sccs_clientmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_sccs_clientmaster]
(
    [party_code] VARCHAR(10) NULL,
    [sccs_settdate_last] DATETIME NULL,
    [sccs_settdate_next] DATETIME NULL,
    [RAA_Date] VARCHAR(23) NOT NULL,
    [RAA_Expiry_date] VARCHAR(23) NOT NULL,
    [Exclude] VARCHAR(1) NOT NULL,
    [Remark] VARCHAR(7) NOT NULL,
    [dormant] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_Sharepo
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_Sharepo]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [exchange] VARCHAR(3) NULL,
    [isin] VARCHAR(15) NULL,
    [Qty] FLOAT NULL,
    [FDPid] VARCHAR(16) NULL,
    [FCltid] VARCHAR(20) NULL,
    [Bankid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(8) NULL,
    [REM] VARCHAR(3) NOT NULL,
    [BSECM_ShrtVal] MONEY NULL,
    [NSECM_ShrtVal] MONEY NULL,
    [HldVal] FLOAT NULL,
    [Block] VARCHAR(1) NOT NULL,
    [Qty_Allowed] INT NULL,
    [BSECM_ShrtValAftAdj] MONEY NULL,
    [symbol] VARCHAR(12) NULL,
    [series] VARCHAR(12) NULL,
    [approved] INT NULL,
    [dedval] MONEY NULL,
    [update_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_tbl_SCCS_Jv
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_tbl_SCCS_Jv]
(
    [Fld_SrNo] INT IDENTITY(1,1) NOT NULL,
    [Fld_JVDate] DATETIME NULL,
    [Fld_FromCode] VARCHAR(15) NULL,
    [Fld_ToCode] VARCHAR(15) NULL,
    [Fld_FromSegment] VARCHAR(10) NULL,
    [Fld_ToSegment] VARCHAR(10) NULL,
    [Fld_MarkAmt] MONEY NULL,
    [Fld_EntryBy] VARCHAR(10) NULL,
    [Fld_AccessCode] VARCHAR(10) NULL,
    [Fld_Ip] VARCHAR(15) NULL,
    [Fld_Flag] CHAR(1) NULL,
    [Fld_ValidJV] CHAR(1) NOT NULL,
    [Fld_BatchNo] VARCHAR(15) NULL,
    [Fld_VerifyTime] DATETIME NULL,
    [Fld_Remark] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_tbl_SCCS_Jv_hist
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_tbl_SCCS_Jv_hist]
(
    [Fld_SrNo] INT NOT NULL,
    [Fld_JVDate] DATETIME NULL,
    [Fld_FromCode] VARCHAR(15) NULL,
    [Fld_ToCode] VARCHAR(15) NULL,
    [Fld_FromSegment] VARCHAR(10) NULL,
    [Fld_ToSegment] VARCHAR(10) NULL,
    [Fld_MarkAmt] MONEY NULL,
    [Fld_EntryBy] VARCHAR(10) NULL,
    [Fld_AccessCode] VARCHAR(10) NULL,
    [Fld_Ip] VARCHAR(15) NULL,
    [Fld_Flag] CHAR(1) NULL,
    [Fld_ValidJV] CHAR(1) NOT NULL,
    [Fld_BatchNo] VARCHAR(15) NULL,
    [Fld_VerifyTime] DATETIME NULL,
    [Fld_Remark] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tempGen
-- --------------------------------------------------
CREATE TABLE [dbo].[tempGen]
(
    [data] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.test_shpo_rcs
-- --------------------------------------------------
CREATE TABLE [dbo].[test_shpo_rcs]
(
    [update_date] DATETIME NULL,
    [party_code] VARCHAR(10) NULL,
    [exchange] VARCHAR(3) NULL,
    [scrip_cd] VARCHAR(15) NULL,
    [symbol] VARCHAR(12) NULL,
    [series] VARCHAR(12) NULL,
    [isin] VARCHAR(15) NULL,
    [FDPid] VARCHAR(16) NULL,
    [FCltid] VARCHAR(20) NULL,
    [Bankid] VARCHAR(8) NULL,
    [Cltdpid] VARCHAR(8) NULL,
    [HldVal] FLOAT NULL,
    [Actual Qty] FLOAT NULL,
    [Payout Qty] INT NULL,
    [PayoutVal] FLOAT NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.sccs_bo_report_vw
-- --------------------------------------------------
CREATE view sccs_bo_report_vw  
as  
select distinct   
Sett_date=update_date   
,ClientName = Party_name   
,ClientCode=a.party_code   
,NetFundsPO =case when net_credit<0 then net_credit else 0 end   
,NetSecPo=[payout Value]   
,NetLedger=BSECM_Ledger+NSECM_Ledger+NSEFO_Ledger+MCDX_Ledger+NCDX_Ledger+MCD_Ledger+NSX_Ledger  
,Deposit= BSECM_Deposit+NSECM_Deposit+NSEFO_Deposit+MCD_Deposit+NSX_Deposit  
,Margin=NSEFO_Margin+MCD_Margin+NSX_MArgin   
,[Unsett.Credit Var Margin]=BSECM_Var+NSECM_Var  
,[Unsettl.Debit Bill]=BSECM_USD+NSECM_USD   
,[75% of Margin Block]=Total_Marg75   
,[Intraday_FO_Margin] = intra_hghmrg_fo   
,[Intraday_Cash_Margin]=intra_hghmrg_cash   
,[AuctionDebit]=BSECM_Shrtval+NSECM_ShrtVal   
,[OtherSegment Debit]=(case when mcdx_ledger+ncdx_ledger > 0 then mcdx_ledger+ncdx_ledger else 0 end)  
,[AccrualBlock]=[Blocked Funds]  
,[TotalHold]=[Holding Value]  
from (select t.*,[Blocked Funds],[Holding Value],[payout Value] from   
(select * from SCCS_Data s (nolock) left outer join RMS_Client_Vertical r (nolock)  
 on s.party_code=r.client) t left outer join vw_sccs_po_summary v (nolock)  
 on t.party_Code=v.party_code) a left outer join sccs_clientmaster b (nolock)  
on a.party_code=b.party_code   
--where a.party_code='CHEN5970'

GO

-- --------------------------------------------------
-- VIEW dbo.SCCS_CMS_DraweeLocation_Combine
-- --------------------------------------------------
CREATE view SCCS_CMS_DraweeLocation_Combine         
as        
select * from         
(        
select cltcode,branch,subgroup,b.sbtag,drawee_loca,print_loca,HDFC,CITI,status,Draft,PO   
from sccs_cmsdata  a (nolock)  left outer join intranet.cms.dbo.cmscli b         
on a.cltcode=b.sbtag where b.sbtag is not null        
union         
select cltcode,branch,subgroup,b.sbtag,b.drawee_loca,print_loca,hdfc,Citi,status,draft,po         
from sccs_cmsdata  a (nolock)  left outer join intranet.cms.dbo.cmssb b         
on a.subgroup=b.sbtag where b.sbtag is not null and cltcode not in (        
select cltcode from sccs_cmsdata  a (nolock)  left outer join intranet.cms.dbo.cmscli b         
on a.cltcode=b.sbtag where b.sbtag is not null        
)        
) x

GO

-- --------------------------------------------------
-- VIEW dbo.SCCS_OnlineClient
-- --------------------------------------------------

create view SCCS_OnlineClient
as
select a.* from intranet.cms.dbo.Acc_master_Online_cli a with (nolock),
(
select id,cltcode from intranet.cms.dbo.Acc_master_Online_cli with (nolock) where selforonline=1
union
select max(id) as id,cltcode from intranet.cms.dbo.Acc_master_Online_cli with (nolock) 
where selforonline=0 and cltcode not in
(select cltcode from intranet.cms.dbo.Acc_master_Online_cli where selforonline=1)
group by cltcode
) b where a.id=b.id

GO

-- --------------------------------------------------
-- VIEW dbo.SCCS_T3_Shortage
-- --------------------------------------------------
CREATE View SCCS_T3_Shortage  
as  
select Segment='BSE',sett_no,sett_type,party_code,scrip_cd,qty*-1 as short_qty,short_value=total*-1,  
DedVal=(total*-1)
/* DedVal=(total*-1)*(120.00/100) 
from intranet.risk.dbo.BSET3Shrt with (nolock) */  
from BSET3Shrt with (nolock)
union  
select Segment='NSE',sett_no,sett_type,party_code,scrip_cd,qty*-1 as short_qty,short_value=total*-1,  
DedVal=(total*-1)
/* 
DedVal=(total*-1)*(120.00/100)
from intranet.risk.dbo.NSET3Shrt with (nolock) 
*/  
from NSET3Shrt with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.SCCS_Vw_Clientinfo
-- --------------------------------------------------
Create  View SCCS_Vw_Clientinfo
As
Select s.*,ActivationDate=first_active_date,Last_Inactive_date,
bse_last_date,nse_last_date,fo_last_date,ncdx_last_date,mcdx_last_date,comb_last_date
from SCCS_ClientMaster s left outer join intranet.risk.dbo.Client_Details c
on s.party_code=c.party_code

GO

-- --------------------------------------------------
-- VIEW dbo.SCCS_Vw_Data
-- --------------------------------------------------
CREATE View SCCS_Vw_Data  
as  
select * from SCCS_Data_hist with (nolock)  
union all  
select * from SCCS_Data with (nolock)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_BSE_ShPayout_Credit
-- --------------------------------------------------
CREATE vIEW Vw_BSE_ShPayout_Credit
as

/* 10 mins to fetch full data into hash file*/

select a.party_code,scrip_cd,exchange,isin,a.DPid as FDPid,accno as FCltid,
Bankid,Cltdpid=(Case when len(Cltdpid)=16 then substring(Cltdpid,9,8) ELSE substring(Cltdpid,1,8) end),'BTC' AS REM,
BSECM_ShrtVal,NSECM_ShrtVal
from 
(
select a1.*,DPID=(case when b1.dpid is not null and len(Accno)=8 then b1.dpid else substring(a1.accno,1,8) end)
from 
(
select a2.party_Code,scrip_cd,exchange,accno,
Qty=sum(case when accno<>'' then qty else 0 end),
Amount=Sum(case when accno <> '' then Total else 0 end),
BSECM_ShrtVal,NSECM_ShrtVal
from intranet.risk.dbo.holding a2 with (nolock),  
(select party_code,BSECM_ShrtVal,NSECM_ShrtVal from SCCS_Data with (nolock) where net_credit > 0) b2 
where a2.party_Code=b2.party_code and a2.accno <> '' group by a2.party_Code,scrip_cd,exchange,accno,BSECM_ShrtVal,NSECM_ShrtVal
) a1 left outer join angeldemat.msajag.dbo.deliverydp b1 with (nolock) on a1.accno=b1.dpcltno
where a1.exchange='BSE'
)  a, 
(
select bsecode,isin=max(isin) from intranet.risk.dbo.scrip_master with (nolock) group by bsecode
) b,
(select party_code,BAnkid,Cltdpid from angeldemat.bsedb.dbo.client4 with (nolock) where defdp=1) c
where a.scrip_Cd=b.bsecode and a.party_Code=c.party_code

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_Gen_CMS_online_Marked
-- --------------------------------------------------
CREATE View Vw_Gen_CMS_online_Marked  
as  
select a.* from sccs_CMS_online_Marked (nolock)a/* join  
(select cltcode from verification_data_online where processdate>=convert(varchar(11),getdate())) b  
on a.cltcode=b.cltcode  */

GO

-- --------------------------------------------------
-- VIEW dbo.VW_SCCS_Data
-- --------------------------------------------------
CREATE view VW_SCCS_Data    
as    
select a.*,b.comb_last_Date,b.first_active_date,b.region,b.branch_cd,b.sub_broker,b.long_name from sccs_data a with (nolock) ,    
(SELECT party_Code,comb_last_Date,first_active_date,region,branch_cd,sub_broker,long_name FROM INtranet.risk.dbo.client_Details with (nolock)) b    
where a.party_Code=b.party_Code

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_PO_Log
-- --------------------------------------------------
Create View Vw_SCCS_PO_Log 
as            
select update_date,q.region,q.branch,q.sb,q.client as party_Code,party_code as opcode,q.party_name,q.clitype,p.[Net Credit],[Funds Payout],      
Blocked as [Blocked Funds],[Holding Value],[Payout value]            
from            
(            
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from             
(            
select a.update_date,party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],            
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)           
as Blocked  from             
(      
select party_Code,net_credit,update_date=convert(datetime,convert(varchar(11),update_date)) from SCCS_Data_hist with (nolock) )a            
left outer join       
(      
select cltcode,chqamt,updt from sccs_CMSDATA_hist with (nolock)      
)b on a.party_Code=b.cltcode and  a.update_Date=b.updt      
      
) x left outer join             
(      
select update_date,party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal)       
from Vw_SCCS_RawSharePODetails_hist group by party_code,update_date      
) y on x.party_Code=y.party_Code  and x.update_date=y.update_date              
) p             
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client       
--where ([Funds Payout] <> 0 or [Payout value] <> 0)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_PO_Summary
-- --------------------------------------------------

CREATE View Vw_SCCS_PO_Summary    
as    
select q.region,q.branch,q.sb,q.client as party_Code,party_code as opcode,q.party_name,q.clitype,p.[Net Credit],[Funds Payout],Blocked as [Blocked Funds],     
[Holding Value],[Payout value]    
from    
(    
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from     
(    
select party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],    
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)   
as Blocked  from     
(select party_Code,net_credit from SCCS_Data with (nolock) )a    
left outer join (select cltcode,chqamt from SCCS_cmsdata with (nolock))b on a.party_Code=b.cltcode     
) x left outer join     
(select party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal) from Vw_SCCS_RawSharePODetails group by party_code)    
y on x.party_Code=y.party_Code    
) p     
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_PO_Summary_0709
-- --------------------------------------------------
CREATE View Vw_SCCS_PO_Summary_0709      
as      
select q.region,q.branch,q.sb,q.client as party_Code,party_code as opcode,q.party_name,q.clitype,p.[Net Credit],[Funds Payout],Blocked as [Blocked Funds],       
[Holding Value],[Payout value]      
from      
(      
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from       
(      
select party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],      
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)     
as Blocked  from       
(select party_Code,net_credit from SCCS_Data_0709 with (nolock) )a      
left outer join (select cltcode,chqamt from SCCS_cmsdata_0709 with (nolock))b on a.party_Code=b.cltcode       
) x left outer join       
(select party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal) from Vw_SCCS_RawSharePODetails_0709 group by party_code)      
y on x.party_Code=y.party_Code      
) p       
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_PO_Summary_1409
-- --------------------------------------------------

CREATE View Vw_SCCS_PO_Summary_1409        
as        
select q.region,q.branch,q.sb,q.client as party_Code,party_code as opcode,q.party_name,q.clitype,p.[Net Credit],[Funds Payout],Blocked as [Blocked Funds],         
[Holding Value],[Payout value]        
from        
(        
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from         
(        
select party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],        
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)       
as Blocked  from         
(select party_Code,net_credit from SCCS_Data_1409 with (nolock) )a        
left outer join (select cltcode,chqamt from SCCS_cmsdata_1409 with (nolock))b on a.party_Code=b.cltcode         
) x left outer join         
(select party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal) from Vw_SCCS_RawSharePODetails_1409 group by party_code)        
y on x.party_Code=y.party_Code        
) p         
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_PO_Summary_hist
-- --------------------------------------------------
CREATE View Vw_SCCS_PO_Summary_hist            
as            
select update_date,q.region,q.branch,q.sb,q.client as party_Code,party_code as opcode,q.party_name,q.clitype,p.[Net Credit],[Funds Payout],      
Blocked as [Blocked Funds],[Holding Value],[Payout value]            
from            
(            
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from             
(            
select a.update_date,party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],            
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)           
as Blocked  from             
(      
select party_Code,net_credit,update_date=convert(datetime,convert(varchar(11),update_date)) from SCCS_Data_hist with (nolock) )a            
left outer join       
(      
select cltcode,chqamt,updt from sccs_CMSDATA_hist with (nolock)      
)b on a.party_Code=b.cltcode and  a.update_Date=b.updt      
      
) x left outer join             
(      
select update_date,party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal)       
from Vw_SCCS_RawSharePODetails_hist group by party_code,update_date      
) y on x.party_Code=y.party_Code  and x.update_date=y.update_date              
) p             
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client       
where ([Funds Payout] <> 0 or [Payout value] <> 0)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_PO_Summary_hist1
-- --------------------------------------------------
CREATE View Vw_SCCS_PO_Summary_hist1        
as        
select update_date,q.region,q.branch,q.sb,q.client as party_Code,party_code as opcode,q.party_name,q.clitype,p.[Net Credit],[Funds Payout],  
Blocked as [Blocked Funds],[Payout value]        
from        
(        
select x.*,isnull(y.HldVal,0) as [Holding Value],isnull(y.PAyoutVal,0) as [payout Value] from         
(        
select a.update_date,party_Code,net_Credit as [Net Credit],isnull(b.chqamt,0)*-1 as [Funds Payout],        
(case when (a.net_credit-(isnull(chqamt,0)*-1)) > 0 then 0 else (a.net_credit-(isnull(chqamt,0)*-1)) end)       
as Blocked  from         
(  
select party_Code,net_credit,update_date=convert(datetime,convert(varchar(11),update_date)) from SCCS_Data_hist with (nolock) )a        
left outer join   
(  
select cltcode,chqamt,updt from SCCS_cmsdata_hist with (nolock)  
)b on a.party_Code=b.cltcode and  a.update_Date=b.updt  
  
) x left outer join         
(  
select update_date,party_Code,HldVal=sum(HldVal),PayoutVal=sum(PayoutVal)   
from test_shpo_rcs group by party_code,update_date  
) y on x.party_Code=y.party_Code  and x.update_date=y.update_date          
) p         
left outer join RMS_Client_Vertical q with (nolock) on p.party_Code=q.client   
where ([Funds Payout] <> 0 or [Payout value] <> 0)

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_RawSharePODetails
-- --------------------------------------------------
CREATE View Vw_SCCS_RawSharePODetails    
as    
select     
party_code,exchange,scrip_cd,symbol,series,isin,FDPid,FCltid,Bankid,Cltdpid,    
HldVal,Qty as [Actual Qty],Qty_Allowed as [Payout Qty],(HldVal/Qty)*Qty_Allowed as PayoutVal    
from SCCS_Sharepo with (nolock) --where block='N'

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_RawSharePODetails_0709
-- --------------------------------------------------
CREATE View Vw_SCCS_RawSharePODetails_0709
as        
select update_date=convert(datetime,convert(varchar(11),update_date)),        
party_code,exchange,scrip_cd,symbol,series,isin,FDPid,FCltid,Bankid,Cltdpid,        
HldVal,Qty as [Actual Qty],Qty_Allowed as [Payout Qty],(HldVal/Qty)*Qty_Allowed as PayoutVal        
from SCCS_Sharepo_0709 with (nolock) where qty_allowed > 0

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_RawSharePODetails_1409
-- --------------------------------------------------
CREATE View Vw_SCCS_RawSharePODetails_1409
as          
select update_date=convert(datetime,convert(varchar(11),update_date)),          
party_code,exchange,scrip_cd,symbol,series,isin,FDPid,FCltid,Bankid,Cltdpid,          
HldVal,Qty as [Actual Qty],Qty_Allowed as [Payout Qty],(HldVal/Qty)*Qty_Allowed as PayoutVal          
from SCCS_Sharepo_1409 with (nolock) where qty_allowed > 0

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_RawSharePODetails_hist
-- --------------------------------------------------
CREATE View Vw_SCCS_RawSharePODetails_hist      
as      
select update_date=convert(datetime,convert(varchar(11),update_date)),      
party_code,exchange,scrip_cd,symbol,series,isin,FDPid,FCltid,Bankid,Cltdpid,      
HldVal,Qty as [Actual Qty],Qty_Allowed as [Payout Qty],(HldVal/Qty)*Qty_Allowed as PayoutVal      
from SCCS_Sharepo_hist with (nolock) where qty_allowed > 0

GO

-- --------------------------------------------------
-- VIEW dbo.Vw_SCCS_SharePODetails
-- --------------------------------------------------
CREATE View Vw_SCCS_SharePODetails
as
select 
Region,Branch,SB,a.party_code,party_name,clitype,exchange,scrip_cd,symbol,series,isin,FDPid,FCltid,Bankid,Cltdpid,
HldVal,[Actual Qty],[Payout Qty],PayoutVal from
Vw_SCCS_RawSharePODetails a left outer join RMS_Client_Vertical b with (nolock) on a.party_Code=b.client

GO

