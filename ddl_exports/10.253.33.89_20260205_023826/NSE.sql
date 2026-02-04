-- DDL Export
-- Server: 10.253.33.89
-- Database: NSE
-- Exported: 2026-02-05T02:39:11.997983

USE NSE;
GO

-- --------------------------------------------------
-- INDEX dbo.nsecashtrd
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_brokerid] ON [dbo].[nsecashtrd] ([brokerid], [termid], [party_code], [symbol], [Sell_buy])

GO

-- --------------------------------------------------
-- INDEX dbo.nsecashtrd
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_party_code] ON [dbo].[nsecashtrd] ([party_code], [symbol], [Sell_buy])

GO

-- --------------------------------------------------
-- INDEX dbo.nsecashtrd_admin
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_party_code] ON [dbo].[nsecashtrd_admin] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.nsecashtrd_admin
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_symbol] ON [dbo].[nsecashtrd_admin] ([symbol]) INCLUDE ([Sec_name])

GO

-- --------------------------------------------------
-- INDEX dbo.nsecashtrd_admin
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_termid] ON [dbo].[nsecashtrd_admin] ([termid])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.new_NSE_MISMATCHES
-- --------------------------------------------------
--new_NSE_MISMATCHES 'BROKER','CSO'
CREATE procedure [dbo].[new_NSE_MISMATCHES](@access_to AS VARCHAR(11),@access_code AS VARCHAR(11))      
AS      
      
SET NOCOUNT ON       
      
truncate table temp_tbl_NSE_Mismatch      
    
-----------------------INSTITUTIONAL CLIENTS-----------------------------------------------------      
INSERT INTO tbl_NSE_Mismatch            
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''           
            
insert into temp_tbl_NSE_Mismatch            
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '             
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''              
from nsecashtrd with(nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy           
            
INSERT INTO temp_tbl_NSE_Mismatch            
SELECT '','','',''            
            
-----------------------MISSING Scrip-------------------------------------------------------------            
INSERT INTO temp_tbl_NSE_Mismatch            
select '<B>MISSING SCRIPS</B>','','',''            
            
INSERT INTO temp_tbl_NSE_Mismatch            
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nsecashtrd x with(nolock)where not exists            
(SELECT * FROM AngelNseCM.msajag.dbo.scrip2 y where x. symbol = y.scrip_cd)           
            
INSERT INTO temp_tbl_NSE_Mismatch            
SELECT '' ,'','',''           
            
-----------------------MISSING Terminal ID------------------------------------------------------            
INSERT INTO temp_tbl_NSE_Mismatch            
select '<B>MISSING TERMINAL ID</B>','','',''            
            
INSERT INTO temp_tbl_NSE_Mismatch            
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nsecashtrd x with(nolock) where not exists            
(select * from mis.ps03.dbo.fo_termid_list y with(nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)            
            
INSERT INTO temp_tbl_NSE_Mismatch            
SELECT '' ,'','',''      
------------------------------------------Misiimg client codes-------------------------------------------------------------        
INSERT INTO temp_tbl_NSE_Mismatch              
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''        
      
      
INSERT INTO temp_tbl_NSE_Mismatch       
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from       
(       
select distinct party_code,termid from nsecashtrd x with(nolock) where not exists              
(select * from AngelNseCM.msajag.dbo.client1 y with(nolock) where x.party_code = y.cl_code)              
)a              
inner join              
(select *       
from mis.ps03.dbo.fo_termid_list with(nolock)       
where segment = 'NSE CASH') b       
on a.termid = b.termid         
     
      
      
INSERT INTO temp_tbl_NSE_Mismatch              
SELECT '' ,'','' ,''            
              
---------------------------------------------INActive CLients---------------------------------------------------------------------------------      
      
INSERT INTO temp_tbl_NSE_Mismatch              
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''       
      
    
INSERT INTO temp_tbl_NSE_Mismatch        
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd      
,a.party_code,a.termid,b.branch_cd from          
(          
select distinct party_code,termid from nsecashtrd x with(nolock) where exists              
(select * from AngelNseCM.msajag.dbo.client5 y with(nolock)              
where x.party_code = y.cl_code and y.INactivefrom <= getdate())    )a          
inner  join          
(select * from mis.ps03.dbo.fo_termid_list with(nolock)       
where segment = 'NSE CASH') b      
 on a.termid = b.termid      
      
INSERT INTO temp_tbl_NSE_Mismatch              
SELECT '','','',''      
----------------------------------------------Wrong Branch------------------------------------------------------------      
      
     
      
     
select *       
into #WRONG_BRANCH      
from               
(select a.*,b.branch_cd from              
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from              
(select distinct party_code,termid from nsecashtrd with(nolock)) x              
inner join              
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from AngelNseCM.msajag.dbo.client1 with(nolock)) y              
on x.party_code = y.cl_code) a              
inner join              
(select * from mis.ps03.dbo.fo_termid_list with(nolock) where segment = 'NSE CASH'       
and branch_cd <> 'ALL' ) b         
on a.termid = b.termid) g where branch_cd1 <> branch_Cd        
      
    
      
INSERT INTO temp_tbl_NSE_Mismatch              
SELECT '<B>MISMATCH BRANCHES</B>','','',''        
      
INSERT INTO temp_tbl_NSE_Mismatch       
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,      
PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists               
(select * from mis.ps03.dbo.alternatebranchsb y with(nolock) where y.alt_Exchange = 'NSE CASH'              
and x.termid = y.alt_termid       
and x.branch_cd1 = y.alt_branchSB)       
      
    
      
INSERT INTO temp_tbl_NSE_Mismatch              
SELECT '','','',''              
      
    
    
SELECT a.*,case when a.fld_mismatch='' then '0'          
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '2'          
when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '3'          
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '4'          
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '5'          
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '6'          
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '7'          
else '1' end as flag INTO #F1 FROM temp_tbl_NSE_Mismatch a with(NOLOCK)     
    
IF @access_to='BROKER'      
BEGIN    
 SELECT * FROM #F1       
END    
    
IF @access_to='BRANCH'      
BEGIN    
SELECT * FROM #F1 WHERE FLAG IN (0,2,3,4,5,6,7) OR brcode=@access_code    
END    
         
IF @access_to='BRMAST'      
BEGIN    
select * from #f1      
WHERE FLAG IN (0,2,3,4,5,6,7) OR brcode in (select branch_Cd from risk.dbo.branch_master where brmast_Cd=@access_code)    
END         
  
IF @access_to='REGION'      
BEGIN    
select * from #f1      
WHERE FLAG IN (0,2,3,4,5,6,7) OR brcode in (select CODE from risk.dbo.REGION  where REG_CODE=@access_code)    
  
  
END   
    
       
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.nse_mismatch_deepak
-- --------------------------------------------------
CREATE procedure [dbo].[nse_mismatch_deepak]  
as  
set nocount on  


select 
distinct trd.party_code,c1.branch_cd,c1.sub_broker, trd.termid,term.branch_cd 
AS 'Branch',term.sub_broker as 'SubBroker',term.branch_cd_alt as 'AltBranch',term.sub_broker_alt as 'AltSubBroker' 
into #MisMatch   
from nsecashtrd trd , mis.ps03.dbo.fo_termid_list term , AngelNseCM.msajag.dbo.client2 c2 , AngelNseCM.msajag.dbo.client1 c1 
where trd.party_code=c2.party_code and trd.party_code not in 
(select distinct party_code from mis.ps03.dbo.pcode_exception) 
and c2.cl_code=c1.cl_code and trd.termid = term.termid and term.segment = 'NSE CASH' 
and ltrim(rtrim(term.branch_cd)) <> 'ALL' 
and not 
( 
(c1.branch_cd = term.branch_cd and term.sub_broker='') or (c1.branch_cd = term.branch_cd and c1.sub_broker = term.sub_broker and term.sub_broker<>'') or (c1.branch_cd = term.branch_cd_alt and term.sub_broker_alt = '') or (c1.branch_cd = term.branch_cd_alt and c1.sub_broker = term.sub_broker_alt and term.sub_broker_alt<>'') ) 
order by trd.party_code



Select * from #MisMatch   
where Branch_Cd+Sub_Broker not in     
(Select LTrim(RTrim(alt_BranchSB))+LTrim(RTrim(alt_BranchSBCode)) from mis.ps03.dbo.AlternateBranchSB where alt_termid = termid and alt_Exchange = 'NSE CASH')
and Branch_cd not in   
(Select LTrim(RTrim(alt_BranchSB)) from mis.ps03.dbo.AlternateBranchSB where alt_BranchSBCode = '' and alt_termid = termid and alt_Exchange = 'NSE CASH')  

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NSE_MISMATCHES
-- --------------------------------------------------
CREATE procedure NSE_MISMATCHES(@access_to AS VARCHAR(11),@access_code AS VARCHAR(11))
AS

SET NOCOUNT ON 

truncate table temp_tbl_NSE_Mismatch
  
INSERT INTO temp_tbl_NSE_Mismatch        
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''  

IF @access_to='BROKER'
BEGIN
INSERT INTO temp_tbl_NSE_Mismatch 
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from 
( 
select distinct party_code,termid from nsecashtrd x (nolock) where not exists        
(select * from anand1.msajag.dbo.client1 y (nolock) where x.party_code = y.cl_code)        
)a        
inner join        
(select * 
from mis.ps03.dbo.fo_termid_list (nolock) 
where segment = 'NSE CASH') b 
on a.termid = b.termid   
END

IF @access_to='BRANCH'
BEGIN
INSERT INTO temp_tbl_NSE_Mismatch 
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from 
( 
select distinct party_code,termid from nsecashtrd x (nolock) where not exists        
(select * from anand1.msajag.dbo.client1 y (nolock) where x.party_code = y.cl_code)        
)a        
inner join        
(select * 
from mis.ps03.dbo.fo_termid_list (nolock) 
where segment = 'NSE CASH' and branch_cd=@access_code) b 
on a.termid = b.termid 
END

IF @access_to='BRMAST'
BEGIN
INSERT INTO temp_tbl_NSE_Mismatch 
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from 
( 
select distinct party_code,termid from nsecashtrd x (nolock) where not exists        
(select * from anand1.msajag.dbo.client1 y (nolock) where x.party_code = y.cl_code)        
)a        
inner join        
(select * 
from mis.ps03.dbo.fo_termid_list (nolock) 
where segment = 'NSE CASH' 
and branch_cd in (select branch_Cd from branch_master where brmast_Cd=@access_code)

) b 
on a.termid = b.termid 
END

INSERT INTO temp_tbl_NSE_Mismatch        
SELECT '' ,'','' ,''      
        
---------------------------------------------INActive CLients---------------------------------------------------------------------------------

INSERT INTO temp_tbl_NSE_Mismatch        
select '<B>INACTIVE CLIENT CODES</B>' ,'','','' 

IF @access_to='BROKER'
BEGIN
INSERT INTO temp_tbl_NSE_Mismatch  
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd
,a.party_code,a.termid,b.branch_cd from    
(    
select distinct party_code,termid from nsecashtrd x (nolock) where exists        
(select * from anand1.msajag.dbo.client5 y (nolock)        
where x.party_code = y.cl_code and y.INactivefrom <= getdate())    )a    
inner  join    
(select * from mis.ps03.dbo.fo_termid_list (nolock) 
where segment = 'NSE CASH') b
 on a.termid = b.termid
END

IF @access_to='BRANCH'
BEGIN
INSERT INTO temp_tbl_NSE_Mismatch  
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd
,a.party_code,a.termid,b.branch_cd from    
(    
select distinct party_code,termid from nsecashtrd x (nolock) where exists        
(select * from anand1.msajag.dbo.client5 y (nolock)        
where x.party_code = y.cl_code and y.INactivefrom <= getdate())    )a    
inner  join    
(select * from mis.ps03.dbo.fo_termid_list (nolock) 
where segment = 'NSE CASH' and branch_cd=@access_code) b
 on a.termid = b.termid 
END

IF @access_to='BRMAST'
BEGIN
INSERT INTO temp_tbl_NSE_Mismatch  
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd
,a.party_code,a.termid,b.branch_cd from    
(    
select distinct party_code,termid from nsecashtrd x (nolock) where exists        
(select * from anand1.msajag.dbo.client5 y (nolock)        
where x.party_code = y.cl_code and y.INactivefrom <= getdate())    )a    
inner  join    
(select * from mis.ps03.dbo.fo_termid_list (nolock) 
where segment = 'NSE CASH'
 and branch_cd in (select branch_Cd from branch_master where brmast_Cd=@access_code)
) b
 on a.termid = b.termid 
END


INSERT INTO temp_tbl_NSE_Mismatch        
SELECT '','','',''
----------------------------------------------Wrong Branch------------------------------------------------------------



IF @access_to='BROKER'
BEGIN

INSERT INTO WRONG_BRANCH
select * 
--into #WRONG_BRANCH
from         
(select a.*,b.branch_cd from        
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from        
(select distinct party_code,termid from nsecashtrd (nolock)) x        
inner join        
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1 (nolock)) y        
on x.party_code = y.cl_code) a        
inner join        
(select * from mis.ps03.dbo.fo_termid_list (nolock) where segment = 'NSE CASH' 
and branch_cd <> 'ALL' ) b   
on a.termid = b.termid) g where branch_cd1 <> branch_Cd  

END

IF @access_to='BRANCH'
BEGIN

INSERT INTO WRONG_BRANCH
select * 
--into #WRONG_BRANCH
from         
(select a.*,b.branch_cd from        
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from        
(select distinct party_code,termid from nsecashtrd (nolock)) x        
inner join        
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1 (nolock)) y        
on x.party_code = y.cl_code) a        
inner join        
(select * from mis.ps03.dbo.fo_termid_list (nolock) where segment = 'NSE CASH' 
and branch_cd <> 'ALL'  and branch_cd=@access_code) b   
on a.termid = b.termid) g where branch_cd1 <> branch_Cd  
END

IF @access_to='BRMAST'
BEGIN

INSERT INTO WRONG_BRANCH
select * 
--into #WRONG_BRANCH
from         
(select a.*,b.branch_cd from        
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from        
(select distinct party_code,termid from nsecashtrd (nolock)) x        
inner join        
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1 (nolock)) y        
on x.party_code = y.cl_code) a        
inner join        
(select * from mis.ps03.dbo.fo_termid_list (nolock) where segment = 'NSE CASH' 
and branch_cd <> 'ALL'  and branch_cd=@access_code) b   
on a.termid = b.termid) g where branch_cd1 <> branch_Cd  
END

--truncate table WRONG_BRANCH 

INSERT INTO temp_tbl_NSE_Mismatch        
SELECT '<B>MISMATCH BRANCHES</B>','','',''  

INSERT INTO temp_tbl_NSE_Mismatch 
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,
PARTY_CODE,termid,BRANCH_CD from WRONG_BRANCH x where  not exists         
(select * from mis.ps03.dbo.alternatebranchsb y (nolock) where y.alt_Exchange = 'NSE CASH'        
and x.termid = y.alt_termid 
and x.branch_cd1 = y.alt_branchSB) 

truncate table WRONG_BRANCH

INSERT INTO temp_tbl_NSE_Mismatch        
SELECT '','','',''        
  
SELECT a.*,case when a.fld_mismatch='' then '0'    
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'    
when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'    
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'    
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'    
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'    
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'    
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'    
 else '1' end as flag FROM temp_tbl_NSE_Mismatch a (NOLOCK)              
SET NOCOUNT OFF

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
-- PROCEDURE dbo.spnsecashtrd_x
-- --------------------------------------------------
Create Proc spnsecashtrd_x
as
set nocount on
Truncate Table nsecashtrd_x

Insert into nsecashtrd_x
Select * from TradeOnLine

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_Client_NseTrd
-- --------------------------------------------------
CREATE Proc USP_Client_NseTrd(@clCode varchar(50))      
as        
    
select     
case when isnull(x.termid,'') = '' then y.termid else x.termid end as termid,      
case when isnull(x.symbol,'') = '' then y.symbol else x.symbol end as symbol,      
isnull(x.buy,0) as BUY ,isnull(y.sell,0) as SELL from     
(    
(select party_code,termid,Symbol,sum(tradeqty) as BUY from nsecashtrd (nolock)      
where party_code = @clCode and Sell_buy = '1'  group by Symbol,termid,party_code)x    
full outer join    
(select party_code,termid,Symbol,sum(tradeqty) as SELL from nsecashtrd (nolock)      
where party_code = @clCode and Sell_buy = '2'  group by Symbol,termid,party_code) y     
on x.party_code = y.party_code and x.termid = y.termid and x.Symbol = y.Symbol)  
order by termid,symbol

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_functions_findInUSP
-- --------------------------------------------------
create PROCEDURE usp_functions_findInUSP  
@str varchar(500)  
AS  
  
 set @str = '%' + @str + '%'  
   
 select O.name from sysComments  C  
 join sysObjects O on O.id = C.id  
 where O.xtype = 'P' and C.text like @str

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INactive_Clients_Details
-- --------------------------------------------------
CREATE Proc [dbo].[USP_INactive_Clients_Details]  
as

select * from (
select 
case when isnull(m.party_code,'') = '' then n.party_code else m.party_code end as party_code,
case when isnull(m.SYMBOL,'') = '' then n.SYMBOL else m.SYMBOL end as SYMBOL,
isnull(m.buy,0)as  BUY, 
isnull(n.sell,0)as  SELL
from  
(
select a.PARTY_CODE,a.SYMBOL,convert(varchar,sum(a.TradeQty)) as BUY from
(SELECT * FROM nsecashtrd (nolock) where sell_buy = 1) a inner join 
(select * from nsecashtrd x (nolock) where sell_buy = 1 and exists 
(select * from AngelNseCM.msajag.dbo.client5 y (nolock) where x.party_code = y.cl_code and y.INactivefrom <= getdate()))b on a.party_code = b.party_code group by a.PARTY_CODE,a.SYMBOL
) m
full outer join
(
select a.PARTY_CODE,a.SYMBOL,convert(varchar,sum(a.TradeQty)) as SELL from
(SELECT * FROM nsecashtrd (nolock) where sell_buy = 2) a inner join 
(select * from nsecashtrd x (nolock) where sell_buy = 2 and exists 
(select * from AngelNseCM.msajag.dbo.client5 y (nolock) where x.party_code = y.cl_code and y.INactivefrom <= getdate())) b on a.party_code = b.party_code group by a.PARTY_CODE,a.SYMBOL
) n on m.party_code = n.party_code and m.SYMBOL = n.SYMBOL 
) t order by party_code,SYMBOL

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_MCDX_Inactive_Report
-- --------------------------------------------------
CREATE PROCEDURE Usp_MCDX_Inactive_Report    
@Filename varchar(500)     
AS    
BEGIN    
     
 truncate table tbl_MCDX_InActive    
 SET NOCOUNT ON;    
       
   Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'        
               
    Declare @filePath varchar(500)=''                           
    set @filePath ='\\196.1.115.147\d\upload1\mcxInactive\'+@Filename+''           
    DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_MCDX_InActive FROM ''' + @filePath + ''' WITH (FIELDTERMINATOR ='','', ROWTERMINATOR ='''+char(10)+''')';                        
    EXEC(@sql)      
     
 select * into #tempclient5 from AngelNseCM.msajag.[dbo].[CLIENT_BROK_DETAILS] with (nolock) where  exchange='NCX'and INactive_from <= getdate()        
    
     
 select a.Q as partycode,'inactive' as 'Inactive' from tbl_MCDX_InActive a     
 left outer join #tempclient5 b on a.Q=b.cl_code    
 where b.cl_code  is not null    
       
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_MCX_Inactive_Report
-- --------------------------------------------------
CREATE PROCEDURE Usp_MCX_Inactive_Report  
@Filename varchar(500)   
AS  
BEGIN  
   
 truncate table tbl_MCX_InActive  
 SET NOCOUNT ON;  
     
   Exec master.dbo.xp_cmdshell 'NET USE \\196.1.115.147\IPC$ /USER:Administrator Winw0rld@1604'      
             
    Declare @filePath varchar(500)=''                         
    set @filePath ='\\196.1.115.147\d\upload1\mcxInactive\'+@Filename+''         
    DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_MCX_InActive FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'' )';                      
    EXEC(@sql)    
   
 select * into #tempclient5 from AngelNseCM.msajag.[dbo].[CLIENT_BROK_DETAILS] with (nolock) where  exchange='MCX'and INactive_from <= getdate()       
  
 --select * from tbl_MCX_InActive  
   
 select a.T as partycode,'inactive' as 'Inactive' from tbl_MCX_InActive a   
 left outer join #tempclient5 b on a.T=b.cl_code  
 where b.cl_code is not null  
     
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MCXCURRENCY_MISMATCH
-- --------------------------------------------------
CREATE Proc USP_MCXCURRENCY_MISMatch                        
as                                      
set nocount on                                 
set transaction isolation level READ UNCOMMITTED                                
                             
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                                          
truncate table TBL_MCXC_MISMATCH                                          
                                   
-----------------------MISSING Scrip-------------------------------------------------------------                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
select '<B>MISSING SCRIPS</B>','','',''                                          
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
select distinct '<B>SCRIP :</B>'+Symbol+' '+[Instrument Name],'','',''            
from mis.FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE x  with  (nolock) where not exists                                          
(SELECT * FROM  angelcommodity.mcdxcds.dbo.foscrip2 y with (nolock) where x. symbol = y.symbol)                                         
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
SELECT '' ,'','',''                                         
                                          
-----------------------MISSING Terminal ID------------------------------------------------------                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
select '<B>MISSING TERMINAL ID</B>','','',''                                          
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
select distinct '<B>TERMINAL ID: </B>' + [user id],'',[user id],'' from mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE x  with (nolock) where not exists                                          
(select * from mis.ps03.dbo.currency_termid_list y  with (nolock) where y.segment = 'MCD' and x.[user id] = y.termid)                                          
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
SELECT '' ,'','',''                                         
                                          
-----------------------MISSING CLients---------------                                           
INSERT INTO TBL_MCXC_MISMATCH                                          
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                                        
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
select '<B>PARTY CODE :</B>'+a.[account id]+' '+'<B>TERMINAL ID :</B>'+A.[user id]+' '+'<B> BRANCH CODE : </B>'+          
b.branch_cd,a.[account id],a.[user id],b.branch_cd from                                          
(                                          
select distinct [account id],[user id] from mis.FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE x  with (nolock) where not exists                                          
(select * from angelcommodity.mcdxcds.dbo.client1 y  with (nolock) where x.[account id] = y.cl_code)                                          
)a                                          
left outer join                                          
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD') b on a.[user id] = b.termid                                          
                    
INSERT INTO TBL_MCXC_MISMATCH                                          
SELECT '' ,'','' ,''                                        
                                     
----------------------INActive CLients----------------------------                        
select * into #tempclient5 from angelcommodity.mcdxcds.dbo.client5  with (nolock) where INactivefrom <= getdate()                            
select * into #tempfo_term_list from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD'                            
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''            
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
select Distinct '<B>PARTY CODE :</B>'+ a.[account id]+ '<B>TERMINAL ID :</B>'+ a.[user id]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[account id],a.[user id],b.branch_cd from                                      
(                                      
select distinct [account id],[user id] from mis.FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE x  with (nolock) where exists                                          
(select * from #tempclient5 y                              
where x.[account id] = y.cl_code ) )a                                      
left outer join                             
(select * from #tempfo_term_list  with (nolock)) b on a.[user id] = b.termid                                       
                                          
INSERT INTO TBL_MCXC_MISMATCH                                          
SELECT '','','',''                                          
                                          
----------------------Dormant Clients----------------------------                         
                  
INSERT INTO TBL_MCXC_MISMATCH                                          
select '<B>DORMANT CLIENT CODES</B>' ,'','',''                       
                      
INSERT INTO TBL_MCXC_MISMATCH                       
SELECT Distinct '<B>PARTY CODE :</B>'+ a.[account id]+ '<B>TERMINAL ID :</B>'+ a.[user id]+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.[account id],a.[user id],c.branch_cd                    
        FROM mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE A                      
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)                      
        ON A.[account id]=B.PARTY_CODE                      
        left outer join                                          
  (select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD') c on a.[user id] = c.termid                      
        WHERE B.EXCHANGE='MCD'AND B.SEGMENT='FUTURES'                      
        ORDER BY A.[account id]                      
                              
INSERT INTO TBL_MCXC_MISMATCH                                          
SELECT '','','',''                           
                                      
----------------------Wrong Branch--------------------------------                                     
                            
select * into #WRONG_BRANCH from                                           
(select a.*,b.branch_cd from                                          
(select x.[account id],x.[user id],y.branch_cd1,y.sub_broker from                                          
(select distinct [account id],[user id] from mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE with (nolock)) x                                          
inner join                                          
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from angelcommodity.mcdxcds.dbo.client1   with (nolock)) y                                          
on x.[account id] = y.cl_code) a                                          
inner join                                          
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD' and branch_cd <> 'ALL') b                                     
on a.[user id] = b.termid) g where branch_cd1 <> branch_Cd                                           
                                          
                   
                  
INSERT INTO TBL_MCXC_MISMATCH                                          
SELECT '<B>MISMATCH BRANCHES</B>','','',''                                          
                                          
INSERT INTO TBL_MCXC_MISMATCH                       
select '<B>PARTY CODE :</B>'+[account id]+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+          
'<B> TERMINAL ID : </B>'+[user id] + '<B> TERM BR : </B>'+ BRANCH_CD,[account id],         
[user id],BRANCH_CD from #WRONG_BRANCH x where  not exists                         
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'MCD'                
and x.[user id] = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                                          
                                          
INSERT INTO TBL_MCXC_MISMATCH                           
SELECT '','','',''                                          
                                          
---------------- To Find Nri Clients who are Trading-----------------------------                                        
                               
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details  with (nolock) where (cl_status = 'NRI'    or cl_type='NRI')                                        
                                        
select a.[account id],a.symbol into #temp1 from                                         
(select distinct [account id],symbol from mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE  with (nolock) where [account id] in                                        
(select party_code from #temp) and [Buy/Sell Indicator] = 1)a                                          
inner join                                        
(select distinct [account id],symbol from mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE  with (nolock) where [account id] in                                        
(select party_code from #temp) and [Buy/Sell Indicator] = 2)b                                        
on a.[account id] = b.[account id] and a.symbol = b.symbol                                        
                                         
select x.[account id],x.symbol,y.branch_cd,y.sub_broker                   
into #temp2                   
from                                         
(select * from #temp1)x                                        
inner join                                        
(select * from #temp)y                                        
on x.[account id] = y.party_code                                         
                                          
                        
INSERT INTO TBL_MCXC_MISMATCH                                      
select '<B>NRI CLIENTS</B>','','',''                                          
                                          
insert into TBL_MCXC_MISMATCH                                          
select '<B>NRIClientId :</B>'+' '+[account id]+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                                           
,[account id],'',branch_cd from #temp2 (nolock)                                            
                                  
-------------------------------Sebi Banned Clients----------------                                  
                              
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                                
--SELECT * FROM #file                              
                              
INSERT INTO TBL_MCXC_MISMATCH                                          
select '<B>SEBI-BANNED CLIENTS</B>','','',''                                      
                               
INSERT INTO TBL_MCXC_MISMATCH                                  
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE a(nolock)                                  
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                                  
                              
Select Distinct '<B>PARTY CODE :</B>'+a.[account id],'','','' from mis. FOBKG.DBO.TBL_MCXCURRENCY_EXCHANGE a  with (nolock)                                  
Inner join #file b(nolock) on a.[account id] = b.Party_Code                                  
                                         
                                 
--select * from TBL_MCXC_MISMATCH (NOLOCK)                                          
SELECT a.*,case when a.fld_mismatch='' then '0'                                      
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                                      
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                                      
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                       
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                                      
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                                      
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                                      
 else '1' end as flag FROM TBL_MCXC_MISMATCH a  with (NOLOCK)                             
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MCXCURRENCY_MISMatch_admin
-- --------------------------------------------------
CREATE Proc USP_MCXCURRENCY_MISMatch_admin                          
as                                    
set nocount on                               
set transaction isolation level READ UNCOMMITTED                              
                           
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                                        
truncate table TBL_MCXC_MISMATCH                                        
                                                                 
-----------------------MISSING Scrip-------------------------------------------------------------                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>MISSING SCRIPS</B>','','',''                                        
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
select distinct '<B>SCRIP :</B>'+symbol+' '+[Instrument Name],'','',''  from mis.fobkg.dbo.tbl_mcx_admin x  with  (nolock) where not exists                                        
(SELECT * FROM angelcommodity.mcdxcds.dbo.foscrip2 y with (nolock) where x.symbol = y.symbol)                                       
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '' ,'','',''                                       
                                        
-----------------------MISSING Terminal ID------------------------------------------------------                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>MISSING TERMINAL ID</B>','','',''                                        
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
select distinct '<B>TERMINAL ID: </B>' + [user id],'',[user id],'' from mis.fobkg.dbo.tbl_mcx_admin x  with (nolock) where not exists                                        
(select * from mis.ps03.dbo.currency_termid_list y  with (nolock) where y.segment = 'MCD' and x.[user id] = y.termid)                                        
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '' ,'','',''                                       
                                        
-----------------------MISSING CLients---------------                                         
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                                      
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>PARTY CODE :</B>'+a.[account id]+' '+'<B>TERMINAL ID :</B>'+A.[user id]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[account id],a.[user id],b.branch_cd from                                        
(                                        
select distinct [account id],[user id] from mis.fobkg.dbo.tbl_mcx_admin x  with (nolock) where not exists                                        
(select * from angelcommodity.mcdxcds.dbo.client1 y  with (nolock) where x.[account id] = y.cl_code)                                        
)a                                        
left outer join                                        
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD') b on a.[user id] = b.termid                                        
                  
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '' ,'','' ,''                                      
                                   
----------------------INActive CLients----------------------------                      
select * into #tempclient5 from angelcommodity.mcdxcds.dbo.client5  with (nolock) where INactivefrom <= getdate()                          
select * into #tempfo_term_list from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD'                          
INSERT INTO TBL_MCXC_MISMATCH                                
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                
                                        
INSERT INTO TBL_MCXC_MISMATCH                
select Distinct '<B>PARTY CODE :</B>'+ a.[account id]+ '<B>TERMINAL ID :</B>'+ a.[user id]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[account id],a.[user id],b.branch_cd from                                    
(                                    
select distinct [account id],[user id] from mis.fobkg.dbo.tbl_mcx_admin x  with (nolock) where exists                                        
(select * from #tempclient5 y                            
where x.[account id] = y.cl_code ) )a                                    
left outer join                           
(select * from #tempfo_term_list  with (nolock)) b on a.[user id] = b.termid                                     
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '','','',''                                        
                                        
----------------------Dormant Clients----------------------------                       
                
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>DORMANT CLIENT CODES</B>' ,'','',''                     
                    
INSERT INTO TBL_MCXC_MISMATCH                     
SELECT Distinct '<B>PARTY CODE :</B>'+ a.[account id]+ '<B>TERMINAL ID :</B>'+ a.[user id]+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.[account id],a.[user id],c.branch_cd                  
        FROM mis.fobkg.dbo.tbl_mcx_admin A                    
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)                    
        ON A.[account id]=B.PARTY_CODE                    
        left outer join                                        
  (select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD') c on a.[user id] = c.termid                    
        WHERE B.EXCHANGE='MCD'AND B.SEGMENT='FUTURES'                    
        ORDER BY A.[account id]                    
                            
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '','','',''                         
                                    
----------------------Wrong Branch--------------------------------                                   
                          
select * into #WRONG_BRANCH from                                         
(select a.*,b.branch_cd from                                        
(select x.[account id],x.[user id],y.branch_cd1,y.sub_broker from                                        
(select distinct [account id],[user id] from mis.fobkg.dbo.tbl_mcx_admin with (nolock)) x                                        
inner join                                        
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                                        
on x.[account id] = y.cl_code) a                                        
inner join                                        
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'MCD' and branch_cd <> 'ALL') b                                   
on a.[user id] = b.termid) g where branch_cd1 <> branch_Cd                                         
                                        
                 
                
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '<B>MISMATCH BRANCHES</B>','','',''                                        
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>PARTY CODE :</B>'+[account id]+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+[user id] + '<B> TERM BR : </B>'+ BRANCH_CD,[account id],[user id],BRANCH_CD from #WRONG_BRANCH x where  not exists                
 
    
               
          
            
                       
                
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'MCD'                                        
and x.[user id] = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                                        
                                        
INSERT INTO TBL_MCXC_MISMATCH                                        
SELECT '','','',''                                        
                                        
---------------- To Find Nri Clients who are Trading-----------------------------                                                                      
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details  with (nolock) where (cl_status = 'NRI'    or cl_type='NRI')
                                      
select a.[account id],a.symbol into #temp1 from                                       
(select distinct [account id],symbol from mis.fobkg.dbo.tbl_mcx_admin  with (nolock) where [account id] in                                      
(select party_code from #temp) and [b/s] = 1)a                                        
inner join                                      
(select distinct [account id],symbol from mis.fobkg.dbo.tbl_mcx_admin  with (nolock) where [account id] in                                      
(select party_code from #temp) and [b/s] = 2)b                                      
on a.[account id] = b.[account id] and a.symbol = b.symbol                                      
                                       
select x.[account id],x.symbol,y.branch_cd,y.sub_broker                 
into #temp2                 
from                                       
(select * from #temp1)x                                      
inner join                                      
(select * from #temp)y                                      
on x.[account id] = y.party_code                                       
                                        
                      
INSERT INTO TBL_MCXC_MISMATCH                                    
select '<B>NRI CLIENTS</B>','','',''                                        
                                        
insert into TBL_MCXC_MISMATCH                                        
select '<B>NRIClientId :</B>'+' '+[account id]+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                                         
,[account id],'',branch_cd from #temp2 (nolock)                                          
                                
-------------------------------Sebi Banned Clients----------------                                
                            
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                              
--SELECT * FROM #file                            
                            
INSERT INTO TBL_MCXC_MISMATCH                                        
select '<B>SEBI-BANNED CLIENTS</B>','','',''                                    
                             
INSERT INTO TBL_MCXC_MISMATCH                                
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from mis.fobkg.dbo.tbl_mcx_admin a(nolock)                                
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                                
                            
Select Distinct '<B>PARTY CODE :</B>'+a.[account id],'','','' from mis.fobkg.dbo.tbl_mcx_admin a  with (nolock)                                
Inner join #file b(nolock) on a.[account id] = b.Party_Code                                
                                       
                               
--select * from TBL_MCXC_MISMATCH (NOLOCK)                                        
SELECT a.*,case when a.fld_mismatch='' then '0'                                    
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                                    
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                                    
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                                    
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                                    
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                                    
 else '1' end as flag FROM TBL_MCXC_MISMATCH a  with (NOLOCK)                           
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_MISSING_Clients_Details
-- --------------------------------------------------
CREATE Proc [dbo].[USP_MISSING_Clients_Details]    
as  
  
select * from 
(
select   
case when isnull(m.party_code,'') = '' then n.party_code else m.party_code end as party_code,  
case when isnull(m.SYMBOL,'') = '' then n.SYMBOL else m.SYMBOL end as SYMBOL,  
isnull(m.buy,0)as  BUY,   
isnull(n.sell,0)as  SELL  
from    
(  
select a.PARTY_CODE,a.SYMBOL,convert(varchar,sum(a.TradeQty)) as BUY from  
(SELECT * FROM nsecashtrd (nolock) where sell_buy = 1) a inner join   
(select * from nsecashtrd x (nolock) where sell_buy = 1 and not exists (select * from AngelNseCM.msajag.dbo.client1 y (nolock)   
where x.party_code = y.cl_code)) b on a.party_code = b.party_code group by a.PARTY_CODE,a.SYMBOL  
) m  
full outer join  
(  
select a.PARTY_CODE,a.SYMBOL,convert(varchar,sum(a.TradeQty)) as SELL from  
(SELECT * FROM nsecashtrd (nolock) where sell_buy = 2) a inner join   
(select * from nsecashtrd x (nolock) where sell_buy = 2 and not exists (select * from AngelNseCM.msajag.dbo.client1 y (nolock)   
where x.party_code = y.cl_code)) b on a.party_code = b.party_code group by a.PARTY_CODE,a.SYMBOL  
) n on m.party_code = n.party_code and m.SYMBOL = n.SYMBOL  
) t order by party_code,SYMBOL

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_MISMatch
-- --------------------------------------------------
CREATE Proc [dbo].[USP_NSE_MISMatch]        
as                  
set nocount on             
set transaction isolation level READ UNCOMMITTED            
               
                     
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                      
truncate table tbl_NSE_Mismatch                      
                      
INSERT INTO tbl_NSE_Mismatch                      
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''                     
                      
insert into tbl_NSE_Mismatch                      
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '                       
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''                        
from nsecashtrd with (nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy                     
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '','','',''                      
                      
-----------------------MISSING Scrip-------------------------------------------------------------                      
INSERT INTO tbl_NSE_Mismatch                      
select '<B>MISSING SCRIPS</B>','','',''                      
                      
INSERT INTO tbl_NSE_Mismatch                      
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nsecashtrd x  with  (nolock) where not exists                      
(SELECT * FROM AngelNseCM.msajag.dbo.scrip2 y with (nolock) where x. symbol = y.scrip_cd)                     
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '' ,'','',''                     
                      
-----------------------MISSING Terminal ID------------------------------------------------------                      
INSERT INTO tbl_NSE_Mismatch                      
select '<B>MISSING TERMINAL ID</B>','','',''                      
                      
INSERT INTO tbl_NSE_Mismatch                      
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nsecashtrd x  with (nolock) where not exists                      
(select * from mis.ps03.dbo.fo_termid_list y  with (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)                      
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '' ,'','',''                     
                      
-----------------------MISSING CLients---------------                       
INSERT INTO tbl_NSE_Mismatch                      
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                    
                      
INSERT INTO tbl_NSE_Mismatch                      
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                      
(                      
select distinct party_code,termid from nsecashtrd x  with (nolock) where not exists                      
(select * from AngelNseCM.msajag.dbo.client1 y  with (nolock) where x.party_code = y.cl_code)                      
)a                      
left outer join                      
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') b on a.termid = b.termid                      
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '' ,'','' ,''                    
                      
----------------------INActive CLients----------------------------           
select * into #tempclient5 from AngelNseCM.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()        
select * into #tempfo_termid_list from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH'        
INSERT INTO tbl_NSE_Mismatch                      
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                     
                      
INSERT INTO tbl_NSE_Mismatch            
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                  
(                  
select distinct party_code,termid from nsecashtrd x  with (nolock) where exists                      
(select * from #tempclient5 y          
where x.party_code = y.cl_code ) )a                  
left outer join         
(select * from #tempfo_termid_list  with (nolock)) b on a.termid = b.termid                   
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '','','',''                      
                      
                      
 ----------------------Dormant Clients----------------------------         
      
INSERT INTO tbl_NSE_Mismatch                          
select '<B>DORMANT CLIENT CODES</B>' ,'','',''       
      
INSERT INTO tbl_NSE_Mismatch       
SELECT Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.party_code,a.termid,c.branch_cd    
        FROM NSECASHTRD_ADMIN A      
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        left outer join                          
  (select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') c on a.termid = c.termid      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE      
              
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''           
                      
                      
----------------------Wrong Branch--------------------------------                 
        
select * into #WRONG_BRANCH from                       
(select a.*,b.branch_cd from                      
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                      
(select distinct party_code,termid from nsecashtrd (nolock)) x                      
inner join                      
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from AngelNseCM.msajag.dbo.client1  with (nolock)) y                      
on x.party_code = y.cl_code) a                      
inner join                      
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                 
on a.termid = b.termid) g where branch_cd1 <> branch_Cd                       
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '<B>MISMATCH BRANCHES</B>','','',''                      
                      
INSERT INTO tbl_NSE_Mismatch                      
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists                       
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSE CASH'                      
and x.termid = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                      
                      
INSERT INTO tbl_NSE_Mismatch                      
SELECT '','','',''                      
                      
---------------- To Find Nri Clients who are Trading-----------------------------                    
                    
select party_code,branch_cd,sub_broker into #temp from AngelNseCM.msajag.dbo.client_details  with (nolock) where 
(cl_status = 'NRI'    or cl_type='NRI')
                    
select a.party_code,a.symbol into #temp1 from                     
(select distinct party_code,symbol from nsecashtrd  with (nolock) where party_code in                    
(select party_code from #temp) and sell_buy = 1)a                      
inner join                    
(select distinct party_code,symbol from nsecashtrd  with (nolock) where party_code in                    
(select party_code from #temp) and sell_buy = 2)b                    
on a.party_code = b.party_code and a.symbol = b.symbol                    
                     
select x.party_code,x.symbol,y.branch_cd,y.sub_broker into #temp2 from                     
(select * from #temp1)x                    
inner join                    
(select * from #temp)y                    
on x.party_code = y.party_code                     
                      
                      
INSERT INTO tbl_NSE_Mismatch                      
select '<B>NRI CLIENTS</B>','','',''                      
                      
insert into tbl_NSE_Mismatch                      
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                       
,Party_Code,'',branch_cd from #temp2 (nolock)                        
              
-------------------------------Sebi Banned Clients----------------              
          
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)            
--SELECT * FROM #file          
          
INSERT INTO tbl_NSE_Mismatch                      
select '<B>SEBI-BANNED CLIENTS</B>','','',''                  
              
INSERT INTO tbl_NSE_Mismatch              
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nsecashtrd a(nolock)              
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode              
          
Select Distinct '<B>PARTY CODE :</B>'+a.Party_Code,'','','' from nsecashtrd a  with (nolock)              
Inner join #file b(nolock) on a.party_Code = b.Party_Code              
                     
             
--select * from tbl_NSE_Mismatch (NOLOCK)                      
SELECT a.*,case when a.fld_mismatch='' then '0'                  
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                  
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                  
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                  
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                  
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                  
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                  
 else '1' end as flag FROM tbl_NSE_Mismatch a  with (NOLOCK)         
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_MISMatch_admin
-- --------------------------------------------------
CREATE Proc [dbo].[USP_NSE_MISMatch_admin]         
as                      
set nocount on                 
set transaction isolation level READ UNCOMMITTED                
                   
                         
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                          
truncate table tbl_NSE_Mismatch                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''                         
                          
insert into tbl_NSE_Mismatch                          
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '                           
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''                            
from nsecashtrd_admin with (nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
-----------------------MISSING Scrip-------------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING SCRIPS</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nsecashtrd_admin x  with  (nolock) where not exists                          
(SELECT * FROM AngelNseCM.msajag.dbo.scrip2 y with (nolock) where x. symbol = y.scrip_cd)                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING Terminal ID------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING TERMINAL ID</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nsecashtrd_admin x  with (nolock) where not exists                          
(select * from mis.ps03.dbo.fo_termid_list y  with (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING CLients---------------                           
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                        
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                          
(                          
select distinct party_code,termid from nsecashtrd_admin x  with (nolock) where not exists                          
(select * from AngelNseCM.msajag.dbo.client1 y  with (nolock) where x.party_code = y.cl_code)                          
)a                          
left outer join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') b on a.termid = b.termid                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','' ,''                        
                          
----------------------INActive CLients----------------------------               
select * into #tempclient5 from AngelNseCM.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()            
select * into #tempfo_termid_list from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH'            
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                         
                          
INSERT INTO tbl_NSE_Mismatch                          
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                      
(                      
select distinct party_code,termid from nsecashtrd_admin x  with (nolock) where exists                          
(select * from #tempclient5 y              
where x.party_code = y.cl_code ) )a                      
left outer join             
(select * from #tempfo_termid_list  with (nolock)) b on a.termid = b.termid                       
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
----------------------Dormant Clients----------------------------         
      
INSERT INTO tbl_NSE_Mismatch                          
select '<B>DORMANT CLIENT CODES</B>' ,'','',''       
      
INSERT INTO tbl_NSE_Mismatch       
SELECT Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.party_code,a.termid,c.branch_cd    
        FROM NSECASHTRD_ADMIN A      
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        left outer join                          
  (select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') c on a.termid = c.termid      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE      
              
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''           
                      
----------------------Wrong Branch--------------------------------                     
            
--select * into #WRONG_BRANCH from                           
--(select a.*,b.branch_cd from                          
--(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
--(select distinct party_code,termid from nsecashtrd_admin (nolock)) x                          
--inner join                          
--(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from AngelNseCM.msajag.dbo.client1  with (nolock)) y                          
--on x.party_code = y.cl_code) a                          
--inner join                          
--(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                     
--on a.termid = b.termid) g where branch_cd1 <> branch_Cd 

select a.*,b.branch_cd into #tmp1 from                          
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
(select distinct party_code,termid from nsecashtrd_admin (nolock)) x                          
inner join                          
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from AngelNseCM.msajag.dbo.client1  with (nolock)) y                          
on x.party_code = y.cl_code) a                          
inner join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                    
on a.termid = b.termid
 
select * into #WRONG_BRANCH from #tmp1 where branch_cd1 <> branch_Cd    

                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '<B>MISMATCH BRANCHES</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists                          


 
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSE CASH'                          
and x.termid = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
---------------- To Find Nri Clients who are Trading-----------------------------                        
                        
select party_code,branch_cd,sub_broker into #temp from AngelNseCM.msajag.dbo.client_details  with (nolock) where 
(cl_status = 'NRI'    or cl_type='NRI')                        
                        
select a.party_code,a.symbol into #temp1 from                         
(select distinct party_code,symbol from nsecashtrd_admin  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 1)a                          
inner join                        
(select distinct party_code,symbol from nsecashtrd_admin  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 2)b                        
on a.party_code = b.party_code and a.symbol = b.symbol                        
                         
select x.party_code,x.symbol,y.branch_cd,y.sub_broker into #temp2 from                         
(select * from #temp1)x                        
inner join                        
(select * from #temp)y                        
on x.party_code = y.party_code                         
                          
        
INSERT INTO tbl_NSE_Mismatch                          
select '<B>NRI CLIENTS</B>','','',''                          
                          
insert into tbl_NSE_Mismatch                          
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                           
,Party_Code,'',branch_cd from #temp2 (nolock)                            
                  
-------------------------------Sebi Banned Clients----------------                  
              
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                
--SELECT * FROM #file              
              
INSERT INTO tbl_NSE_Mismatch                          
select '<B>SEBI-BANNED CLIENTS</B>','','',''                      
               
INSERT INTO tbl_NSE_Mismatch                  
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nsecashtrd_admin a(nolock)                  
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                  
              
Select Distinct '<B>PARTY CODE :</B>'+a.Party_Code,'','','' from nsecashtrd_admin a  with (nolock)                  
Inner join #file b(nolock) on a.party_Code = b.Party_Code                  
                         
                 
--select * from tbl_NSE_Mismatch (NOLOCK)                          
SELECT a.*,case when a.fld_mismatch='' then '0'                      
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                      
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                      
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                      
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                      
 else '1' end as flag FROM tbl_NSE_Mismatch a  with (NOLOCK)             
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_MISMatch_admin_19oct2021
-- --------------------------------------------------
CREATE Proc USP_NSE_MISMatch_admin_19oct2021         
as                      
set nocount on                 
set transaction isolation level READ UNCOMMITTED                
                   
                         
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                          
truncate table tbl_NSE_Mismatch                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''                         
                          
insert into tbl_NSE_Mismatch                          
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '                           
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''                            
from nsecashtrd_admin with (nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
-----------------------MISSING Scrip-------------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING SCRIPS</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nsecashtrd_admin x  with  (nolock) where not exists                          
(SELECT * FROM anand1.msajag.dbo.scrip2 y with (nolock) where x. symbol = y.scrip_cd)                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING Terminal ID------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING TERMINAL ID</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nsecashtrd_admin x  with (nolock) where not exists                          
(select * from mis.ps03.dbo.fo_termid_list y  with (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING CLients---------------                           
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                        
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                          
(                          
select distinct party_code,termid from nsecashtrd_admin x  with (nolock) where not exists                          
(select * from anand1.msajag.dbo.client1 y  with (nolock) where x.party_code = y.cl_code)                          
)a                          
left outer join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') b on a.termid = b.termid                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','' ,''                        
                          
----------------------INActive CLients----------------------------               
select * into #tempclient5 from anand1.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()            
select * into #tempfo_termid_list from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH'            
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                         
                          
INSERT INTO tbl_NSE_Mismatch                          
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                      
(                      
select distinct party_code,termid from nsecashtrd_admin x  with (nolock) where exists                          
(select * from #tempclient5 y              
where x.party_code = y.cl_code ) )a                      
left outer join             
(select * from #tempfo_termid_list  with (nolock)) b on a.termid = b.termid                       
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
----------------------Dormant Clients----------------------------         
      
INSERT INTO tbl_NSE_Mismatch                          
select '<B>DORMANT CLIENT CODES</B>' ,'','',''       
      
INSERT INTO tbl_NSE_Mismatch       
SELECT Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.party_code,a.termid,c.branch_cd    
        FROM NSECASHTRD_ADMIN A      
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        left outer join                          
  (select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') c on a.termid = c.termid      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE      
              
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''           
                      
----------------------Wrong Branch--------------------------------                     
            
--select * into #WRONG_BRANCH from                           
--(select a.*,b.branch_cd from                          
--(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
--(select distinct party_code,termid from nsecashtrd_admin (nolock)) x                          
--inner join                          
--(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                          
--on x.party_code = y.cl_code) a                          
--inner join                          
--(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                     
--on a.termid = b.termid) g where branch_cd1 <> branch_Cd 

select a.*,b.branch_cd into #tmp1 from                          
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
(select distinct party_code,termid from nsecashtrd_admin (nolock)) x                          
inner join                          
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                          
on x.party_code = y.cl_code) a                          
inner join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                    
on a.termid = b.termid
 
select * into #WRONG_BRANCH from #tmp1 where branch_cd1 <> branch_Cd    

                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '<B>MISMATCH BRANCHES</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists                          


 
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSE CASH'                          
and x.termid = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
---------------- To Find Nri Clients who are Trading-----------------------------                        
                        
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details  with (nolock) where 
(cl_status = 'NRI'    or cl_type='NRI')                        
                        
select a.party_code,a.symbol into #temp1 from                         
(select distinct party_code,symbol from nsecashtrd_admin  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 1)a                          
inner join                        
(select distinct party_code,symbol from nsecashtrd_admin  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 2)b                        
on a.party_code = b.party_code and a.symbol = b.symbol                        
                         
select x.party_code,x.symbol,y.branch_cd,y.sub_broker into #temp2 from                         
(select * from #temp1)x                        
inner join                        
(select * from #temp)y                        
on x.party_code = y.party_code                         
                          
        
INSERT INTO tbl_NSE_Mismatch                          
select '<B>NRI CLIENTS</B>','','',''                          
                          
insert into tbl_NSE_Mismatch                          
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                           
,Party_Code,'',branch_cd from #temp2 (nolock)                            
                  
-------------------------------Sebi Banned Clients----------------                  
              
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                
--SELECT * FROM #file              
              
INSERT INTO tbl_NSE_Mismatch                          
select '<B>SEBI-BANNED CLIENTS</B>','','',''                      
               
INSERT INTO tbl_NSE_Mismatch                  
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nsecashtrd_admin a(nolock)                  
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                  
              
Select Distinct '<B>PARTY CODE :</B>'+a.Party_Code,'','','' from nsecashtrd_admin a  with (nolock)                  
Inner join #file b(nolock) on a.party_Code = b.Party_Code                  
                         
                 
--select * from tbl_NSE_Mismatch (NOLOCK)                          
SELECT a.*,case when a.fld_mismatch='' then '0'                      
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                      
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                      
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                      
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                      
 else '1' end as flag FROM tbl_NSE_Mismatch a  with (NOLOCK)             
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_MISMatch_admin_26jul2021
-- --------------------------------------------------
CREATE Proc USP_NSE_MISMatch_admin_26jul2021           
as                      
set nocount on                 
set transaction isolation level READ UNCOMMITTED                
                   
                         
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                          
truncate table tbl_NSE_Mismatch                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''                         
                          
insert into tbl_NSE_Mismatch                          
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '                           
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''                            
from nsecashtrd_admin with (nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
-----------------------MISSING Scrip-------------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING SCRIPS</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nsecashtrd_admin x  with  (nolock) where not exists                          
(SELECT * FROM anand1.msajag.dbo.scrip2 y with (nolock) where x. symbol = y.scrip_cd)                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING Terminal ID------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING TERMINAL ID</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nsecashtrd_admin x  with (nolock) where not exists                          
(select * from mis.ps03.dbo.fo_termid_list y  with (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING CLients---------------                           
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                        
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                          
(                          
select distinct party_code,termid from nsecashtrd_admin x  with (nolock) where not exists                          
(select * from anand1.msajag.dbo.client1 y  with (nolock) where x.party_code = y.cl_code)                          
)a                          
left outer join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') b on a.termid = b.termid                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','' ,''                        
                          
----------------------INActive CLients----------------------------               
select * into #tempclient5 from anand1.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()            
select * into #tempfo_termid_list from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH'            
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                         
                          
INSERT INTO tbl_NSE_Mismatch                          
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                      
(                      
select distinct party_code,termid from nsecashtrd_admin x  with (nolock) where exists                          
(select * from #tempclient5 y              
where x.party_code = y.cl_code ) )a                      
left outer join             
(select * from #tempfo_termid_list  with (nolock)) b on a.termid = b.termid                       
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
----------------------Dormant Clients----------------------------         
      
INSERT INTO tbl_NSE_Mismatch                          
select '<B>DORMANT CLIENT CODES</B>' ,'','',''       
      
INSERT INTO tbl_NSE_Mismatch       
SELECT Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.party_code,a.termid,c.branch_cd    
        FROM NSECASHTRD_ADMIN A      
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        left outer join                          
  (select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') c on a.termid = c.termid      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE      
              
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''           
                      
----------------------Wrong Branch--------------------------------                     
            
select * into #WRONG_BRANCH from                           
(select a.*,b.branch_cd from                          
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
(select distinct party_code,termid from nsecashtrd_admin (nolock)) x                          
inner join                          
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                          
on x.party_code = y.cl_code) a                          
inner join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                     
on a.termid = b.termid) g where branch_cd1 <> branch_Cd                           
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '<B>MISMATCH BRANCHES</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists                          

 
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSE CASH'                          
and x.termid = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
---------------- To Find Nri Clients who are Trading-----------------------------                        
                        
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details  with (nolock) where 
(cl_status = 'NRI'    or cl_type='NRI')                        
                        
select a.party_code,a.symbol into #temp1 from                         
(select distinct party_code,symbol from nsecashtrd_admin  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 1)a                          
inner join                        
(select distinct party_code,symbol from nsecashtrd_admin  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 2)b                        
on a.party_code = b.party_code and a.symbol = b.symbol                        
                         
select x.party_code,x.symbol,y.branch_cd,y.sub_broker into #temp2 from                         
(select * from #temp1)x                        
inner join                        
(select * from #temp)y                        
on x.party_code = y.party_code                         
                          
        
INSERT INTO tbl_NSE_Mismatch                          
select '<B>NRI CLIENTS</B>','','',''                          
                          
insert into tbl_NSE_Mismatch                          
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                           
,Party_Code,'',branch_cd from #temp2 (nolock)                            
                  
-------------------------------Sebi Banned Clients----------------                  
              
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                
--SELECT * FROM #file              
              
INSERT INTO tbl_NSE_Mismatch                          
select '<B>SEBI-BANNED CLIENTS</B>','','',''                      
               
INSERT INTO tbl_NSE_Mismatch                  
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nsecashtrd_admin a(nolock)                  
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                  
              
Select Distinct '<B>PARTY CODE :</B>'+a.Party_Code,'','','' from nsecashtrd_admin a  with (nolock)                  
Inner join #file b(nolock) on a.party_Code = b.Party_Code                  
                         
                 
--select * from tbl_NSE_Mismatch (NOLOCK)                          
SELECT a.*,case when a.fld_mismatch='' then '0'                      
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                      
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                      
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                      
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                      
 else '1' end as flag FROM tbl_NSE_Mismatch a  with (NOLOCK)             
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_MISMatch_admin_bkp19Oct2021
-- --------------------------------------------------
CREATE Proc USP_NSE_MISMatch_admin_bkp19Oct2021        
as                      
set nocount on                 
set transaction isolation level READ UNCOMMITTED                
                   
                         
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                          
truncate table tbl_NSE_Mismatch                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''                         
                          
insert into tbl_NSE_Mismatch                          
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '                           
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''                            
from DBA_Admin.dbo.nsecashtrd_admin1 with (nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
-----------------------MISSING Scrip-------------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING SCRIPS</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from DBA_Admin.dbo.nsecashtrd_admin1 x  with  (nolock) where not exists                          
(SELECT * FROM anand1.msajag.dbo.scrip2 y with (nolock) where x. symbol = y.scrip_cd)                         
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING Terminal ID------------------------------------------------------                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING TERMINAL ID</B>','','',''                          
                          
INSERT INTO tbl_NSE_Mismatch                          
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from DBA_Admin.dbo.nsecashtrd_admin1 x  with (nolock) where not exists                          
(select * from mis.ps03.dbo.fo_termid_list y  with (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','',''                         
                          
-----------------------MISSING CLients---------------                           
INSERT INTO tbl_NSE_Mismatch                          
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                        
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                          
(                          
select distinct party_code,termid from DBA_Admin.dbo.nsecashtrd_admin1 x  with (nolock) where not exists                          
(select * from anand1.msajag.dbo.client1 y  with (nolock) where x.party_code = y.cl_code)                          
)a                          
left outer join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') b on a.termid = b.termid                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '' ,'','' ,''                        
                          
----------------------INActive CLients----------------------------               
select * into #tempclient5 from anand1.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()            
select * into #tempfo_termid_list from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH'            
INSERT INTO tbl_NSE_Mismatch                          
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                         
                          
INSERT INTO tbl_NSE_Mismatch                          
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from                      
(                      
select distinct party_code,termid from DBA_Admin.dbo.nsecashtrd_admin1 x  with (nolock) where exists                          
(select * from #tempclient5 y              
where x.party_code = y.cl_code ) )a                      
left outer join             
(select * from #tempfo_termid_list  with (nolock)) b on a.termid = b.termid                       
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
----------------------Dormant Clients----------------------------         
      
INSERT INTO tbl_NSE_Mismatch                          
select '<B>DORMANT CLIENT CODES</B>' ,'','',''       
      
INSERT INTO tbl_NSE_Mismatch       
SELECT Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.party_code,a.termid,c.branch_cd    
        FROM DBA_Admin.dbo.nsecashtrd_admin1 A      
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)      
        ON A.PARTY_CODE=B.PARTY_CODE      
        left outer join                          
  (select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') c on a.termid = c.termid      
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'      
        ORDER BY A.PARTY_CODE      
              
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''           
                      
----------------------Wrong Branch--------------------------------                     
            
--select * into #WRONG_BRANCH from                           
--(select a.*,b.branch_cd from                          
--(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
--(select distinct party_code,termid from nsecashtrd_admin (nolock)) x                          
--inner join                          
--(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                          
--on x.party_code = y.cl_code) a                          
--inner join                          
--(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                     
--on a.termid = b.termid) g where branch_cd1 <> branch_Cd 

select a.*,b.branch_cd into #tmp1 from                          
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from                          
(select distinct party_code,termid from DBA_Admin.dbo.nsecashtrd_admin1 (nolock)) x                          
inner join                          
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                          
on x.party_code = y.cl_code) a                          
inner join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                    
on a.termid = b.termid
 
select * into #WRONG_BRANCH from #tmp1 where branch_cd1 <> branch_Cd    

                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '<B>MISMATCH BRANCHES</B>','','',''       
                          
INSERT INTO tbl_NSE_Mismatch                          
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists                         
 


 
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSE CASH'                          
and x.termid = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                          
                          
INSERT INTO tbl_NSE_Mismatch                          
SELECT '','','',''                          
                          
---------------- To Find Nri Clients who are Trading-----------------------------                        
                        
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details  with (nolock) where 
(cl_status = 'NRI'    or cl_type='NRI')                        
                        
select a.party_code,a.symbol into #temp1 from                         
(select distinct party_code,symbol from DBA_Admin.dbo.nsecashtrd_admin1  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 1)a                          
inner join                        
(select distinct party_code,symbol from DBA_Admin.dbo.nsecashtrd_admin1  with (nolock) where party_code in                        
(select party_code from #temp) and sell_buy = 2)b                        
on a.party_code = b.party_code and a.symbol = b.symbol                        
                         
select x.party_code,x.symbol,y.branch_cd,y.sub_broker into #temp2 from                         
(select * from #temp1)x                        
inner join                        
(select * from #temp)y                        
on x.party_code = y.party_code                         
                          
        
INSERT INTO tbl_NSE_Mismatch                          
select '<B>NRI CLIENTS</B>','','',''                          
                          
insert into tbl_NSE_Mismatch                          
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                           
,Party_Code,'',branch_cd from #temp2 (nolock)                            
                  
-------------------------------Sebi Banned Clients----------------                  
              
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                
--SELECT * FROM #file              
              
INSERT INTO tbl_NSE_Mismatch                          
select '<B>SEBI-BANNED CLIENTS</B>','','',''                      
               
INSERT INTO tbl_NSE_Mismatch                  
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nsecashtrd_admin a(nolock)                  
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                  
              
Select Distinct '<B>PARTY CODE :</B>'+a.Party_Code,'','','' from DBA_Admin.dbo.nsecashtrd_admin1 a  with (nolock)                  
Inner join #file b(nolock) on a.party_Code = b.Party_Code                  
                         
                 
--select * from tbl_NSE_Mismatch (NOLOCK)                          
SELECT a.*,case when a.fld_mismatch='' then '0'                      
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                      
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                      
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                      
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                      
 else '1' end as flag FROM tbl_NSE_Mismatch a  with (NOLOCK)             
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_MISMatch_new1
-- --------------------------------------------------
CREATE Proc USP_NSE_MISMatch_new1        
as        
        
-----------------------INSTITUTIONAL CLIENTS-----------------------------------------------------        
truncate table tbl_NSE_Mismatch        
        
INSERT INTO tbl_NSE_Mismatch        
select '<B>INSTITUTIONAL TRADE</B>' ,'','',''       
        
insert into tbl_NSE_Mismatch        
select distinct '<B>TERM ID :</B>'+' '+termid+ ' '+'<B>INST CODE :</B>'+' '+party_code +'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum(tradeqty))+' '         
+case when sell_buy = 1 then 'BUY' else 'SELL' end ,party_code,termid,''          
from nsecashtrd (nolock) where isnumeric(brokerid) = 0 group by termid,party_code,symbol,sell_buy       
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '','','',''        
        
-----------------------MISSING Scrip-------------------------------------------------------------        
INSERT INTO tbl_NSE_Mismatch        
select '<B>MISSING SCRIPS</B>','','',''        
        
INSERT INTO tbl_NSE_Mismatch        
select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nsecashtrd x (nolock) where not exists        
(SELECT * FROM anand1.msajag.dbo.scrip2 y where x. symbol = y.scrip_cd)       
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '' ,'','',''       
        
-----------------------MISSING Terminal ID------------------------------------------------------        
INSERT INTO tbl_NSE_Mismatch        
select '<B>MISSING TERMINAL ID</B>','','',''        
        
INSERT INTO tbl_NSE_Mismatch        
select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nsecashtrd x (nolock) where not exists        
(select * from mis.ps03.dbo.fo_termid_list y (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)        
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '' ,'','',''       
        
-----------------------MISSING CLients---------------         
INSERT INTO tbl_NSE_Mismatch        
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''      
        
INSERT INTO tbl_NSE_Mismatch        
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' '+'<B>TERMINAL ID :</B>'+A.TERMID+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from        
(        
select distinct party_code,termid from nsecashtrd x (nolock) where not exists        
(select * from anand1.msajag.dbo.client1 y (nolock) where x.party_code = y.cl_code)        
)a        
left outer join        
(select * from mis.ps03.dbo.fo_termid_list (nolock) where segment = 'NSE CASH') b on a.termid = b.termid        
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '' ,'','' ,''      
        
----------------------INActive CLients----------------------------        
INSERT INTO tbl_NSE_Mismatch        
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''       
        
INSERT INTO tbl_NSE_Mismatch        
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+ '<B>TERMINAL ID :</B>'+ a.termid+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.party_code,a.termid,b.branch_cd from    
(    
select distinct party_code,termid from nsecashtrd x (nolock) where exists        
(select * from anand1.msajag.dbo.client5 y (nolock)        
where x.party_code = y.cl_code and y.INactivefrom <= getdate())    )a    
left outer join    
    
(select * from mis.ps03.dbo.fo_termid_list (nolock) where segment = 'NSE CASH') b on a.termid = b.termid     
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '','','',''        
        
        
        
----------------------Wrong Branch--------------------------------        
select * into #WRONG_BRANCH from         
(select a.*,b.branch_cd from        
(select x.party_code,x.termid,y.branch_cd1,y.sub_broker from        
(select distinct party_code,termid from nsecashtrd (nolock)) x        
inner join        
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1 (nolock)) y        
on x.party_code = y.cl_code) a        
inner join        
(select * from mis.ps03.dbo.fo_termid_list (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b   
on a.termid = b.termid) g where branch_cd1 <> branch_Cd         
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '<B>MISMATCH BRANCHES</B>','','',''        
        
INSERT INTO tbl_NSE_Mismatch        
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+termid + '<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE,termid,BRANCH_CD from #WRONG_BRANCH x where  not exists         
(select * from mis.ps03.dbo.alternatebranchsb y (nolock) where y.alt_Exchange = 'NSE CASH'        
and x.termid = y.alt_termid and x.branch_cd1 = y.alt_branchSB)        
        
INSERT INTO tbl_NSE_Mismatch        
SELECT '','','',''        
        
---------------- To Find Nri Clients who are Trading-----------------------------      
      
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details (nolock) where cl_status = 'NRI'      
      
select a.party_code,a.symbol into #temp1 from       
(select distinct party_code,symbol from nsecashtrd (nolock) where party_code in      
(select party_code from #temp) and sell_buy = 1)a        
inner join      
(select distinct party_code,symbol from nsecashtrd (nolock) where party_code in      
(select party_code from #temp) and sell_buy = 2)b      
on a.party_code = b.party_code and a.symbol = b.symbol      
       
select x.party_code,x.symbol,y.branch_cd,y.sub_broker into #temp2 from       
(select * from #temp1)x      
inner join      
(select * from #temp)y      
on x.party_code = y.party_code       
        
        
INSERT INTO tbl_NSE_Mismatch        
select '<B>NRI CLIENTS</B>','','',''        
        
insert into tbl_NSE_Mismatch        
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '         
,Party_Code,'',branch_cd from #temp2 (nolock)          
    
--select * from tbl_NSE_Mismatch (NOLOCK)        
SELECT a.*,case when a.fld_mismatch='' then '0'    
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'    
when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'    
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'    
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'    
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'    
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'    
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'    
 else '1' end as flag into #temp22 FROM tbl_NSE_Mismatch a (NOLOCK) 


select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end fld_flag from   
(select * from #temp22 (nolock))a
left outer join 
(select * from mis.bse.dbo.tbl_vanda_mismatch (nolock))b  
on party_code = partycode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSE_OFS_MISMatchs
-- --------------------------------------------------
CREATE Proc [dbo].[USP_NSE_OFS_MISMatchs]            
as                      
set nocount on                 
set transaction isolation level READ UNCOMMITTED                
                   
                         
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                          
truncate table tbl_NSE_OFS_Mismatch                          
 /*                         
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>INSTITUTIONAL TRADE</B>' ,''                      
                          
insert into tbl_NSE_OFS_Mismatch                          
select distinct '<B>INST CODE :</B>'+' '+party_code +''                          
,party_code                            
from nseofstrd with (nolock) group by party_code                    
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '',''                          
  */                        
-----------------------MISSING Scrip-------------------------------------------------------------                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>MISSING SCRIPS</B>',''                        
                          
--INSERT INTO tbl_NSE_OFS_Mismatch                          
--select distinct '<B>SCRIP :</B>'+symbol+' '+sec_name,'','',''  from nseofstrd x  with  (nolock) where not exists                          
--(SELECT * FROM AngelNseCM.msajag.dbo.scrip2 y with (nolock) where x. symbol = y.scrip_cd)                         
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '' ,''                         
                          
-----------------------MISSING Terminal ID------------------------------------------------------                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>MISSING TERMINAL ID</B>',''                        
                          
--INSERT INTO tbl_NSE_OFS_Mismatch                          
--select distinct '<B>TERMINAL ID: </B>' + termid,'',termid,'' from nseofstrd x  with (nolock) where not exists                          
--(select * from mis.ps03.dbo.fo_termid_list y  with (nolock) where y.segment = 'NSE CASH' and x.termid = y.termid)                          
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '' ,''                         
                          
-----------------------MISSING CLients---------------                           
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>MISSING CLIENT CODES</B>' ,''                      
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>PARTY CODE :</B>'+a.PARTY_CODE+' ',a.party_code from                          
(                          
select distinct party_code from nseofstrd x  with (nolock) where not exists                          
(select * from AngelNseCM.msajag.dbo.client1 y  with (nolock) where x.party_code = y.cl_code)                          
)a                          
left outer join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') b on a.party_code = b.party_code                          
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '' ,''                       
                          
----------------------INActive CLients----------------------------               
select * into #tempclient5 from AngelNseCM.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()            
select * into #tempfo_termid_list from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH'            
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>INACTIVE CLIENT CODES</B>' ,''                        
                          
INSERT INTO tbl_NSE_OFS_Mismatch                
select Distinct '<B>PARTY CODE :</B>'+ a.party_code+' ',a.party_code from                      
(                      
select distinct party_code from nseofstrd x  with (nolock) where exists                          
(select * from #tempclient5 y              
where x.party_code = y.cl_code ) )a                      
left outer join             
(select * from #tempfo_termid_list  with (nolock)) b on a.party_code = b.party_code                       
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '',''                         
                          
                          
 ----------------------Dormant Clients----------------------------             
          
INSERT INTO tbl_NSE_OFS_Mismatch                              
select '<B>DORMANT CLIENT CODES</B>' ,''           
          
INSERT INTO tbl_NSE_OFS_Mismatch           
SELECT Distinct '<B>PARTY CODE :</B>'+ a.party_code+ ' ',a.party_code     
        FROM nseofstrd A          
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)          
        ON A.PARTY_CODE=B.PARTY_CODE          
        left outer join                              
  (select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH') c on a.PARTY_CODE = c.PARTY_CODE          
        WHERE B.EXCHANGE='NSE'AND B.SEGMENT='CAPITAL'          
        ORDER BY A.PARTY_CODE          
                  
INSERT INTO tbl_NSE_OFS_Mismatch                              
SELECT '',''              
                          
                          
----------------------Wrong Branch--------------------------------                     
            
select * into #WRONG_BRANCH from                           
(select a.*,b.branch_cd from                          
(select x.party_code,y.branch_cd1,y.sub_broker from                          
(select distinct party_code from nseofstrd (nolock)) x                          
inner join                          
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from AngelNseCM.msajag.dbo.client1  with (nolock)) y                          
on x.party_code = y.cl_code) a                          
inner join                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = 'NSE CASH' and branch_cd <> 'ALL') b                     
on a.party_code = b.party_code) g where branch_cd1 <> branch_Cd                           
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '<B>MISMATCH BRANCHES</B>',''                         
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>PARTY CODE :</B>'+PARTY_CODE+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERM BR : </B>'+ BRANCH_CD,PARTY_CODE from #WRONG_BRANCH x where  not exists                           
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSE CASH'                          
and  x.branch_cd1 = y.alt_branchSB)                          
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
SELECT '',''                         
                          
---------------- To Find Nri Clients who are Trading-----------------------------                        
                        
select party_code,branch_cd,sub_broker into #temp from AngelNseCM.msajag.dbo.client_details  with (nolock) where     
(cl_status = 'NRI'    or cl_type='NRI')    
                        
select a.party_code into #temp1 from                         
(select distinct party_code from nseofstrd  with (nolock) where party_code in                        
(select party_code from #temp) )a                          
inner join                        
(select distinct party_code from nseofstrd  with (nolock) where party_code in                        
(select party_code from #temp))b                        
on a.party_code = b.party_code                      
                         
select x.party_code,y.branch_cd,y.sub_broker into #temp2 from                         
(select * from #temp1)x          
inner join                        
(select * from #temp)y                        
on x.party_code = y.party_code                         
                          
                          
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>NRI CLIENTS</B>',''                          
                          
insert into tbl_NSE_OFS_Mismatch                          
select '<B>NRIClientId :</B>'+' '+Party_Code+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '                           
,Party_Code from #temp2 (nolock)                            
                  
-------------------------------Sebi Banned Clients----------------                  
              
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                
--SELECT * FROM #file              
              
INSERT INTO tbl_NSE_OFS_Mismatch                          
select '<B>SEBI-BANNED CLIENTS</B>',''                     
                  
INSERT INTO tbl_NSE_OFS_Mismatch                  
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nseofstrd a(nolock)                  
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                  
              
Select Distinct '<B>PARTY CODE :</B>'+a.Party_Code,a.Party_Code from nseofstrd a  with (nolock)                  
Inner join #file b(nolock) on a.party_Code = b.Party_Code                  
                         
                 
--select * from tbl_NSE_OFS_Mismatch (NOLOCK)                          
SELECT a.*,case when a.fld_mismatch='' then '0'                      
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'           -- when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                      
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                      
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                      
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                      
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                      
 else '1' end as flag FROM tbl_NSE_OFS_Mismatch a  with (NOLOCK)             
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Nse_TradeChanges
-- --------------------------------------------------
CREATE Proc Usp_Nse_TradeChanges(@Chkval as int,@party_code as varchar(25),@orderno as varchar(20),@rbn as varchar(6))          
as          
          
if @rbn = 'Order'          
begin          
	select distinct Order_No,Sell_Buy,Symbol,termid,b.branch_cd  from           
	(select * from nsecashtrd (nolock) where party_code = @party_code and Order_No = @orderno)a           
	left outer join intranet.risk.dbo.client_details b (nolock)          
	on a.party_code = b.party_code order by a.Symbol           
end          
else if @rbn = 'TermId'        
begin    
	select distinct Order_No,Sell_Buy,Symbol,termid,b.branch_cd  from           
	(select * from nsecashtrd (nolock) where party_code = @party_code and termid = @orderno)a           
	left outer join intranet.risk.dbo.client_details b (nolock)          
	on a.party_code = b.party_code order by a.Symbol   
end    
else     
begin 
if @Chkval = 1
begin
	select distinct Order_No,Sell_Buy,Symbol,termid,b.branch_cd  from           
	(select * from nsecashtrd (nolock) where party_code = @party_code) a           
	left outer join intranet.risk.dbo.client_details b (nolock)          
	on a.party_code = b.party_code order by a.Symbol   
end
else
begin
	select distinct Order_No,Sell_Buy,Symbol,termid,b.branch_cd  from           
	(select * from nsecashtrd (nolock) where Order_No = @party_code) a           
	left outer join intranet.risk.dbo.client_details b (nolock)          
	on a.party_code = b.party_code order by a.Symbol   
end 
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSECURRENCY_MISMatch
-- --------------------------------------------------
CREATE Proc USP_NSECURRENCY_MISMatch                                  
as                                            
set nocount on                                       
set transaction isolation level READ UNCOMMITTED                                      
                                         
                                  
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                                                
truncate table tbl_NseCurrency_Mismatch                                                 
        
-----------------------MISSING Scrip-------------------------------------------------------------                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>MISSING SCRIPS</B>','','',''                                                
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
select distinct '<B>SCRIP :</B>'+cast(symbol as varchar)+' '+[instrument Type],'','',''              
from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2 x  with  (nolock)             
where not exists                                                
(SELECT * FROM Angelfo.nsecurfo.dbo.foscrip2 y with (nolock) where cast(x.symbol as varchar) = y.symbol)                                               
                                              
INSERT INTO tbl_NseCurrency_Mismatch                                                
SELECT '' ,'','',''                                               
                                                
-----------------------MISSING Terminal ID------------------------------------------------------                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>MISSING TERMINAL ID</B>','','',''                                                
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
select distinct '<B>TERMINAL ID: </B>' + [user id],'',[user id],'' from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2 x  with (nolock) where not exists                                                
(select * from mis.ps03.dbo.currency_termid_list y  with (nolock) where y.segment = 'NSX' and x.[user id] = y.termid)                                                
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
SELECT '' ,'','',''                                               
                                                
-----------------------MISSING CLients---------------                                                 
INSERT INTO tbl_NseCurrency_Mismatch         
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                                              
                              
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>PARTY CODE :</B>'+cast([Account Number] as varchar)+' '+'<B>TERMINAL ID :</B>'+A.[user id]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[Account Number],a.[user id],b.branch_cd from                                                
(                                                
select distinct [Account Number],[user id] from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2 x  with (nolock) where not exists                                                
(select * from Angelfo.nsecurfo.dbo.client1 y  with (nolock) where cast(x.[Account Number] as varchar) = y.cl_code)                                                
)a                                                
left outer join                                              
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'NSX') b on a.[user id] = b.termid                                                
         
INSERT INTO tbl_NseCurrency_Mismatch                                                
SELECT '' ,'','' ,''                                              
               
----------------------INActive CLients----------------------------                                     
select * into #tempclient5 from anand1.msajag.dbo.client5  with (nolock) where INactivefrom <= getdate()                                  
select * into #tempfo_termid_list from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'NSX'                                  
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                                               
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                      
select Distinct '<B>PARTY CODE :</B>'+ a.[Account Number]+ '<B>TERMINAL ID :</B>'+ a.[USER ID]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[Account Number],a.[USER ID],b.branch_cd from                                            
(                                            
select distinct [Account Number],[USER ID] from  mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2  x  with (nolock) where exists                                                
(select * from #tempclient5 y                                    
where cast(x.[Account Number] as varchar) = y.cl_code ) )a                                            
left outer join                                   
(select * from #tempfo_termid_list  with (nolock)) b on a.[USER ID] = b.termid                                             
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
SELECT '','','',''                                                
                            --SELECT  DISTINCT EXCHANGE FROM RISK.DBO.DORMANT_CLIENT                 
                                                
 ----------------------Dormant Clients----------------------------                                   
                                
INSERT INTO tbl_NseCurrency_Mismatch                                                    
select '<B>DORMANT CLIENT CODES</B>' ,'','',''                                 
                                
INSERT INTO tbl_NseCurrency_Mismatch                                 
SELECT Distinct '<B>PARTY CODE :</B>'+ a.[Account]+ '<B>TERMINAL ID :</B>'+ a.[USER ID]+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.[Account],a.[USER ID],c.branch_cd                              
        FROM mis.fobkg.dbo.TBL_NSE_ADMIN A                                
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)                                
        ON A.[Account]=B.PARTY_CODE                                
        left outer join                                                    
  (select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'NSX') c on a.[USER ID] = c.termid                                
        WHERE B.EXCHANGE='NSX'AND B.SEGMENT='FUTURES'                                
        ORDER BY A.[Account]                     
                                        
INSERT INTO tbl_NseCurrency_Mismatch                                                    
SELECT '','','',''                                     
                            
                                                
----------------------Wrong Branch--------------------------------                                           
                                  
select *                into #WRONG_BRANCH                           
from                                                 
(select a.*,b.branch_cd from                                                
(select x.[Account Number],x.[USER ID],y.branch_cd1,y.sub_broker from                                                
(select distinct [Account Number],[USER ID] from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2 with (nolock)) x                                       
inner join                                                
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                                                
on cast(x.[Account Number] as varchar) = y.cl_code) a                                                
inner join                                          
(select * from mis.ps03.dbo.fo_termid_list  with (nolock) where segment = ' ' and branch_cd <> 'ALL') b                                           
on a.[USER ID]  = b.termid) g where branch_cd1 <> branch_Cd                                                 
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
SELECT '<B>MISMATCH BRANCHES</B>','','',''                                                
                       
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>PARTY CODE :</B>'+[Account Number]+' '+'<B> BR :</B>'            
+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+[USER ID]             
+ '<B> TERM BR : </B>'+ BRANCH_CD,[Account Number],            
[USER ID],BRANCH_CD from #WRONG_BRANCH x where  not exists                                                
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSX'                                                
and x.[USER ID] = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                                                
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
SELECT '','','',''                                                
                                                
---------------- To Find Nri Clients who are Trading-----------------------------                                              
                                              
select party_code,branch_cd,sub_broker                           
into #temp                           
from anand1.msajag.dbo.client_details  with (nolock) where (cl_status = 'NRI'    or cl_type='NRI')                                             
                                              
select a.[Account Number],a.symbol                           
into #temp1                           
from                                               
(select distinct [Account Number],symbol from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2   with (nolock) where cast([Account Number] as varchar) in                                              
(select party_code from #temp) and [buy/sell] = 1)a                                                
inner join                                              
(select distinct [Account Number],symbol from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2   with (nolock) where [Account Number] in                                              
(select party_code from #temp) and [buy/sell] = 2)b                                              
on cast(a.[Account Number] as varchar) = b.[Account Number] and a.symbol = b.symbol                                              
                                               
select x.[Account Number],x.symbol,y.branch_cd,y.sub_broker into #temp2 from                                               
(select * from #temp1)x                                              
inner join                                              
(select * from #temp)y                                              
on x.[Account Number] = y.PARTY_CODE                                               
                                                
                                                
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>NRI CLIENTS</B>','','',''                                         
                                                
insert into tbl_NseCurrency_Mismatch                                                
select '<B>NRIClientId :</B>'+' '+cast([Account Number] as varchar)+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' ',[Account Number]         
,'',branch_cd from #temp2 (nolock)                                                  
                               
-------------------------------Sebi Banned Clients----------------                                        
                                    
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)            
--SELECT * FROM #file                                    
                                    
INSERT INTO tbl_NseCurrency_Mismatch                                                
select '<B>SEBI-BANNED CLIENTS</B>','','',''                                            
                                        
INSERT INTO tbl_NseCurrency_Mismatch                                        
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from nsecashtrd a(nolock)                                        
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                                        
                                    
Select Distinct '<B>PARTY CODE :</B>'+a.[Account Number],'','','' from mis.FOBKG.DBO.TBL_NSE_CURRENCY_EXCHANGE2 a  with (nolock)                                        
Inner join #file b(nolock) on cast(a.[Account Number] as varchar) = b.Party_Code                                        
                                               
                                       
--select * from tbl_NseCurrency_Mismatch (NOLOCK)                                                
SELECT a.*,case when a.fld_mismatch='' then '0'                                            
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                                            
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                                   
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                                            
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                                            
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                                            
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                                            
 else '1' end as flag FROM tbl_NseCurrency_Mismatch a  with (NOLOCK)                                   
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSECURRENCY_MISMatch_admin
-- --------------------------------------------------
CREATE Proc USP_NSECURRENCY_MISMatch_admin                      
as                                
set nocount on                           
set transaction isolation level READ UNCOMMITTED                          
                             
                                   
-------------------------INSTITUTIONAL CLIENTS-----------------------------------------------------                                    
truncate table TBL_NSEC_MISMATCH                                    
                                 
                                    
--INSERT INTO TBL_NSEC_MISMATCH                                    
--select '<B>INSTITUTIONAL TRADE</B>' ,'','',''                                   
                                    
--insert into TBL_NSEC_MISMATCH                                    
--select distinct '<B>TERM ID :</B>'+' '+[USER ID]+ ' '+'<B>INST CODE :</B>'+' '+[Account]+'<B> SCRIP :</B>'+ RTRIM(LTRIM(symbol)) +' '+'<B>QTY :</B>'+ convert(varchar,sum([trade qty]))+' '                                     
--+case when [Buy/Sell ind] = 1 then 'BUY' else 'SELL' end ,[Account],[USER ID],''                                      
--from mis.fobkg.dbo.tbl_nse_admin with (nolock)             
----where isnumeric(brokerid) = 0             
--group by [USER ID],[Account],symbol,[Buy/Sell ind]                                   
                                    
--INSERT INTO TBL_NSEC_MISMATCH                                    
--SELECT '','','',''                                    
                                    
-----------------------MISSING Scrip-------------------------------------------------------------                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>MISSING SCRIPS</B>','','',''                                    
                                       
INSERT INTO TBL_NSEC_MISMATCH                                    
select distinct '<B>SCRIP :</B>'+x.symbol+' '+[Instrument Name],'','',''  from mis.fobkg.dbo.tbl_nse_admin x  with  (nolock) where not exists                                    
(SELECT * FROM Angelfo.nsecurfo.dbo.foscrip2 y with (nolock) where x. symbol = y.symbol)                                   
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '' ,'','',''                                   
                                    
-----------------------MISSING Terminal ID------------------------------------------------------                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>MISSING TERMINAL ID</B>','','',''                                    
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
select distinct '<B>TERMINAL ID: </B>' + [user id],'',[user id],'' from mis.fobkg.dbo.tbl_nse_admin x  with (nolock) where not exists                                    
(select * from mis.ps03.dbo.currency_termid_list y  with (nolock) where y.segment = 'NSX' and x.[user id] = y.termid)                                    
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '' ,'','',''                                   
                                    
-----------------------MISSING CLients---------------                                     
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>MISSING CLIENT CODES</B>' ,'','' ,''                                  
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>PARTY CODE :</B>'+a.[Account]+' '+'<B>TERMINAL ID :</B>'+A.[user id]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[Account],a.[user id],b.branch_cd from                                    
(                                    
select distinct [Account],[user id] from mis.fobkg.dbo.tbl_nse_admin x  with (nolock) where not exists       
(select * from Angelfo.nsecurfo.dbo.client1 y  with (nolock) where x.[Account] = y.cl_code)                          
)a                                    
left outer join                                    
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'NSX') b on a.[user id] = b.termid                                  
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '' ,'','' ,''                               
                                    
----------------------INActive CLients----------------------------                  
select * into #tempclient5 from Angelfo.nsecurfo.dbo.client5  with (nolock) where INactivefrom <= getdate()                      
select * into #tempfo_term_list from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'NSX'                      
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>INACTIVE CLIENT CODES</B>' ,'','',''                                   
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
select Distinct '<B>PARTY CODE :</B>'+ a.[account]+ '<B>TERMINAL ID :</B>'+ a.[user id]+' '+'<B> BRANCH CODE : </B>'+b.branch_cd,a.[account],a.[user id],b.branch_cd from                                
(                                
select distinct [Account],[user id] from mis.fobkg.dbo.tbl_nse_admin x  with (nolock) where exists                                    
(select * from #tempclient5 y                        
where x.[Account] = y.cl_code ) )a                                
left outer join                       
(select * from #tempfo_term_list  with (nolock)) b on a.[user id] = b.termid                                 
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '','','',''                                    
                                    
----------------------Dormant Clients----------------------------                   
              
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>DORMANT CLIENT CODES</B>' ,'','',''                 
                
INSERT INTO TBL_NSEC_MISMATCH                 
SELECT Distinct '<B>PARTY CODE :</B>'+ a.[Account]+ '<B>TERMINAL ID :</B>'+ a.[user id]+' '+'<B> BRANCH CODE : </B>'+c.branch_cd,a.[Account],a.[user id],c.branch_cd              
        FROM mis.fobkg.dbo.tbl_nse_admin A                
        INNER JOIN RISK.DBO.DORMANT_CLIENT B WITH(NOLOCK)                
        ON A.[Account]=B.PARTY_CODE                
        left outer join                                    
  (select * from mis.ps03.dbo.currency_termid_list with (nolock) where segment = 'NSX') c on a.[user id] = c.termid                
        WHERE B.EXCHANGE='NSX'AND B.SEGMENT='FUTURES'                
        ORDER BY A.[Account]                
                        
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '','','',''                     
                                
----------------------Wrong Branch--------------------------------                               
                      
select * into #WRONG_BRANCH from                                     
(select a.*,b.branch_cd from                                    
(select x.account,x.[user id],y.branch_cd1,y.sub_broker from                                    
(select distinct account,[user id] from mis.fobkg.dbo.tbl_nse_admin  with (nolock)) x                                    
inner join                                    
(select cl_code,branch_Cd as branch_cd1,SUB_BROKER from anand1.msajag.dbo.client1  with (nolock)) y                                    
on x.account = y.cl_code) a                                    
inner join                                    
(select * from mis.ps03.dbo.currency_termid_list  with (nolock) where segment = 'NSX' and branch_cd <> 'ALL') b                               
on a.[user id] = b.termid) g where branch_cd1 <> branch_Cd                                     
                                    
             
            
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '<B>MISMATCH BRANCHES</B>','','',''                                    
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>PARTY CODE :</B>'+account+' '+'<B> BR :</B>'+BRANCH_CD1+'<B> SB : </B>'+sub_broker+'<B> TERMINAL ID : </B>'+[user id] + '<B> TERM BR : </B>'+ BRANCH_CD,account,[user id],BRANCH_CD from #WRONG_BRANCH x where  not exists                         
  
     
     
        
          
            
(select * from mis.ps03.dbo.alternatebranchsb y  with (nolock) where y.alt_Exchange = 'NSX'                                    
and x.[user id] = y.alt_termid and x.branch_cd1 = y.alt_branchSB)                                    
                                    
INSERT INTO TBL_NSEC_MISMATCH                                    
SELECT '','','',''                                    
                                    
---------------- To Find Nri Clients who are Trading-----------------------------                                  
                                  
select party_code,branch_cd,sub_broker into #temp from anand1.msajag.dbo.client_details  with (nolock) where (cl_status = 'NRI'    or cl_type='NRI')                                  
                                  
select a.account,a.symbol into #temp1 from                                   
(select distinct account,symbol from mis.fobkg.dbo.tbl_nse_admin  with (nolock) where account in                                  
(select party_code from #temp) and [Buy/Sell ind] = 1)a                                    
inner join                                  
(select distinct account,symbol from mis.fobkg.dbo.tbl_nse_admin  with (nolock) where account in                                  
(select party_code from #temp) and [Buy/Sell ind] = 2)b                                  
on a.account = b.account and a.symbol = b.symbol                                  
                                   
select x.account,x.symbol,y.branch_cd,y.sub_broker             
into #temp2             
from                                   
(select * from #temp1)x                                  
inner join                                  
(select * from #temp)y                                  
on x.account = y.party_code                                   
                                    
                  
INSERT INTO TBL_NSEC_MISMATCH                                
select '<B>NRI CLIENTS</B>','','',''                                    
                                    
insert into TBL_NSEC_MISMATCH                                    
select '<B>NRIClientId :</B>'+' '+account+ ' '+'<B> Of Branch :</B>'+' '+branch_cd +'<B> and SubBroker :</B>'+ sub_broker +' '+'<B> has Traded on :</B>'+ symbol +' '                                     
,account,'',branch_cd from #temp2 with (nolock)                                      
                            
-------------------------------Sebi Banned Clients----------------                            
                        
select * INTO #file FROM MIS.BSE.dbo.Sebi_bannedFromintranet WITH(nolock)                          
--SELECT * FROM #file                        
                        
INSERT INTO TBL_NSEC_MISMATCH                                    
select '<B>SEBI-BANNED CLIENTS</B>','','',''                                
                         
INSERT INTO TBL_NSEC_MISMATCH                            
--Select Distinct '<B>PARTY CODE :</B>'+Party_Code,'','','' from mis.fobkg.dbo.tbl_nse_admin a(nolock)                            
--Inner join Mis.Bse.dbo.tbl_Sebi_Banned b(nolock) on a.party_Code = b.Fld_PartyCode                            
                        
Select Distinct '<B>PARTY CODE :</B>'+a.account,'','','' from mis.fobkg.dbo.tbl_nse_admin a  with (nolock)                            
Inner join #file b with (nolock) on a.account = b.Party_Code                            
                                   
                           
--select * from TBL_NSEC_MISMATCH (NOLOCK)                                    
SELECT a.*,case when a.fld_mismatch='' then '0'                                
when a.fld_mismatch='<B>MISSING SCRIPS</B>' then '0'            when a.fld_mismatch='<B>INSTITUTIONAL TRADE</B>' then '0'                                
when a.fld_mismatch='<B>MISSING TERMINAL ID</B>' then '0'                                
when a.fld_mismatch='<B>MISSING CLIENT CODES</B>' then '0'                                
when a.fld_mismatch='<B>MISMATCH BRANCHES</B>' then '0'                                
when a.fld_mismatch='<B>INACTIVE CLIENT CODES</B>' then '0'                                
when a.fld_mismatch='<B>NRI CLIENTS</B>' then '0'                                
 else '1' end as flag FROM TBL_NSEC_MISMATCH a  with (NOLOCK)                       
 set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Upd_BulkNseChanges
-- --------------------------------------------------
create Proc Usp_Upd_BulkNseChanges(@partycode as varchar(15),@bs as varchar(5),@Orderno as numeric)
as
set nocount on

insert into cld_file values('20',@partycode,@bs,@Orderno) 

delete from nsecashtrd where Order_no = @Orderno

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Upd_NseChanges
-- --------------------------------------------------
CREATE Proc Usp_Upd_NseChanges     
(@partycode as varchar(15),@Orderno as numeric,@bs as varchar(5),@mode as varchar(10))    
as     
    
set @bs = case when @bs = 'BUY' then 'B' else 'S' end    
    
if @mode = 'ADD'    
begin    
 insert into cld_file values('20',@partycode,@bs,@Orderno)   
end    
else    
begin    
 delete from cld_file where orderno = @Orderno    
end

GO

-- --------------------------------------------------
-- TABLE dbo.bsechangesdetails
-- --------------------------------------------------
CREATE TABLE [dbo].[bsechangesdetails]
(
    [wrong_code] VARCHAR(10) NULL,
    [correct_code] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(10) NULL,
    [Symbol] VARCHAR(12) NULL,
    [Tradeqty] INT NULL,
    [Marketrate] MONEY NULL,
    [order_no] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.changes_records
-- --------------------------------------------------
CREATE TABLE [dbo].[changes_records]
(
    [account] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [total_records] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.changes_recordsnsx
-- --------------------------------------------------
CREATE TABLE [dbo].[changes_recordsnsx]
(
    [account] VARCHAR(20) NULL,
    [sauda_date] DATETIME NULL,
    [total_records] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cld_file
-- --------------------------------------------------
CREATE TABLE [dbo].[cld_file]
(
    [record_type] INT NULL,
    [party_code] VARCHAR(10) NULL,
    [buysell] VARCHAR(1) NULL,
    [orderno] VARCHAR(16) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cld_file_success
-- --------------------------------------------------
CREATE TABLE [dbo].[cld_file_success]
(
    [record_type] INT NULL,
    [party_code] VARCHAR(10) NULL,
    [buysell] VARCHAR(1) NULL,
    [orderno] VARCHAR(15) NULL,
    [success] VARCHAR(5) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cldnsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[cldnsecashtrd]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(2) NULL,
    [Sell_buy] VARCHAR(1) NULL,
    [Tradeqty] VARCHAR(9) NULL,
    [Price] VARCHAR(13) NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(15) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.kycregister
-- --------------------------------------------------
CREATE TABLE [dbo].[kycregister]
(
    [party_code] VARCHAR(20) NULL,
    [short_name] VARCHAR(200) NULL,
    [segment] VARCHAR(80) NULL,
    [branch_cd] VARCHAR(15) NULL,
    [sub_broker] VARCHAR(15) NULL,
    [entry_date] DATETIME NULL,
    [dummy1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mantrd
-- --------------------------------------------------
CREATE TABLE [dbo].[mantrd]
(
    [Col001] VARCHAR(255) NULL,
    [Col002] VARCHAR(255) NULL,
    [Col003] VARCHAR(255) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] VARCHAR(255) NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL,
    [Col010] VARCHAR(255) NULL,
    [Col011] VARCHAR(255) NULL,
    [Col012] VARCHAR(255) NULL,
    [Col013] VARCHAR(255) NULL,
    [Col014] VARCHAR(255) NULL,
    [Col015] VARCHAR(255) NULL,
    [Col016] VARCHAR(255) NULL,
    [Col017] VARCHAR(255) NULL,
    [Col018] VARCHAR(255) NULL,
    [Col019] VARCHAR(255) NULL,
    [Col020] VARCHAR(255) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mantrd1
-- --------------------------------------------------
CREATE TABLE [dbo].[mantrd1]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(2) NULL,
    [Sell_buy] VARCHAR(1) NULL,
    [Tradeqty] VARCHAR(9) NULL,
    [Price] VARCHAR(13) NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(15) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_error_report
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_error_report]
(
    [party_code] VARCHAR(20) NULL,
    [pcode_branch_cd] VARCHAR(10) NULL,
    [pcode_sub_broker] VARCHAR(10) NULL,
    [termid] VARCHAR(20) NULL,
    [termid_branch_cd] VARCHAR(10) NULL,
    [termid_sub_broker] VARCHAR(10) NULL,
    [termid_branch_cd_alt] VARCHAR(10) NULL,
    [termid_sub_broker_alt] VARCHAR(10) NULL,
    [remark] VARCHAR(255) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_error_report_x
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_error_report_x]
(
    [party_code] VARCHAR(20) NULL,
    [pcode_branch_cd] VARCHAR(10) NULL,
    [pcode_sub_broker] VARCHAR(10) NULL,
    [termid] VARCHAR(20) NULL,
    [termid_branch_cd] VARCHAR(10) NULL,
    [termid_sub_broker] VARCHAR(10) NULL,
    [termid_branch_cd_alt] VARCHAR(10) NULL,
    [termid_sub_broker_alt] VARCHAR(10) NULL,
    [remark] VARCHAR(255) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsecashcheck
-- --------------------------------------------------
CREATE TABLE [dbo].[nsecashcheck]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(2) NULL,
    [Sell_buy] VARCHAR(1) NULL,
    [Tradeqty] VARCHAR(9) NULL,
    [Price] VARCHAR(13) NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(15) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[nsecashtrd]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(3) NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] FLOAT NULL,
    [Price] FLOAT NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(20) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL,
    [ctcl_id] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsecashtrd_admin
-- --------------------------------------------------
CREATE TABLE [dbo].[nsecashtrd_admin]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(3) NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] FLOAT NULL,
    [Price] FLOAT NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(20) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL,
    [ctclid] VARCHAR(300) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsecashtrd_mis
-- --------------------------------------------------
CREATE TABLE [dbo].[nsecashtrd_mis]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(2) NULL,
    [Sell_buy] TINYINT NULL,
    [Tradeqty] FLOAT NULL,
    [Price] FLOAT NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(15) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsecashtrd_x
-- --------------------------------------------------
CREATE TABLE [dbo].[nsecashtrd_x]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(3) NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] FLOAT NULL,
    [Price] FLOAT NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(15) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsechangesdetails
-- --------------------------------------------------
CREATE TABLE [dbo].[nsechangesdetails]
(
    [Wrong Code] VARCHAR(10) NULL,
    [Correct Code] VARCHAR(10) NULL,
    [Symbol] VARCHAR(10) NULL,
    [Tradeqty] INT NULL,
    [Marketrate] MONEY NULL,
    [Order No] VARCHAR(16) NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nseofstrd
-- --------------------------------------------------
CREATE TABLE [dbo].[nseofstrd]
(
    [party_code] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsxtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[nsxtrd]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(3) NULL,
    [Sell_buy] INT NULL,
    [Tradeqty] FLOAT NULL,
    [Price] FLOAT NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(20) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL,
    [ctcl_id] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.raktrd
-- --------------------------------------------------
CREATE TABLE [dbo].[raktrd]
(
    [Col001] VARCHAR(255) NULL,
    [Col002] VARCHAR(255) NULL,
    [Col003] VARCHAR(255) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] VARCHAR(255) NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL,
    [Col010] VARCHAR(255) NULL,
    [Col011] VARCHAR(255) NULL,
    [Col012] VARCHAR(255) NULL,
    [Col013] VARCHAR(255) NULL,
    [Col014] VARCHAR(255) NULL,
    [Col015] VARCHAR(255) NULL,
    [Col016] VARCHAR(255) NULL,
    [Col017] VARCHAR(255) NULL,
    [Col018] VARCHAR(255) NULL,
    [Col019] VARCHAR(255) NULL,
    [Col020] VARCHAR(255) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.raktrd1
-- --------------------------------------------------
CREATE TABLE [dbo].[raktrd1]
(
    [scripno] VARCHAR(16) NULL,
    [svalue11] VARCHAR(2) NULL,
    [symbol] VARCHAR(10) NULL,
    [series] VARCHAR(2) NULL,
    [Sec_name] VARCHAR(25) NULL,
    [svalue0] VARCHAR(2) NULL,
    [svalue1] VARCHAR(2) NULL,
    [svalue_1] VARCHAR(2) NULL,
    [termid] VARCHAR(5) NULL,
    [termid_location] VARCHAR(2) NULL,
    [Sell_buy] VARCHAR(1) NULL,
    [Tradeqty] VARCHAR(9) NULL,
    [Price] VARCHAR(13) NULL,
    [s_value_1] VARCHAR(1) NULL,
    [party_code] VARCHAR(10) NULL,
    [brokerid] VARCHAR(12) NULL,
    [svaluen] VARCHAR(1) NULL,
    [svalue_0] VARCHAR(4) NULL,
    [svalue_7] VARCHAR(2) NULL,
    [sauda_date] VARCHAR(20) NULL,
    [sauda_date1] VARCHAR(20) NULL,
    [Order_no] VARCHAR(15) NULL,
    [svaluenil] VARCHAR(7) NULL,
    [svaluexyz] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.replace_id
-- --------------------------------------------------
CREATE TABLE [dbo].[replace_id]
(
    [termid] VARCHAR(5) NULL,
    [ctclid] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MCDX_InActive
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MCDX_InActive]
(
    [A] VARCHAR(20) NULL,
    [B] VARCHAR(5) NULL,
    [C] VARCHAR(50) NULL,
    [D] VARCHAR(20) NULL,
    [E] VARCHAR(20) NULL,
    [F] VARCHAR(5) NULL,
    [G] VARCHAR(5) NULL,
    [H] VARCHAR(50) NULL,
    [I] VARCHAR(5) NULL,
    [J] VARCHAR(5) NULL,
    [K] VARCHAR(20) NULL,
    [L] VARCHAR(20) NULL,
    [M] VARCHAR(5) NULL,
    [N] VARCHAR(10) NULL,
    [O] VARCHAR(10) NULL,
    [P] VARCHAR(5) NULL,
    [Q] VARCHAR(20) NULL,
    [R] VARCHAR(10) NULL,
    [S] VARCHAR(10) NULL,
    [T] VARCHAR(50) NULL,
    [U] VARCHAR(50) NULL,
    [V] VARCHAR(50) NULL,
    [W] VARCHAR(10) NULL,
    [X] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_MCX_InActive
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_MCX_InActive]
(
    [A] VARCHAR(20) NULL,
    [B] VARCHAR(20) NULL,
    [C] VARCHAR(20) NULL,
    [D] VARCHAR(20) NULL,
    [E] VARCHAR(20) NULL,
    [F] VARCHAR(30) NULL,
    [G] VARCHAR(20) NULL,
    [H] VARCHAR(20) NULL,
    [I] VARCHAR(20) NULL,
    [J] VARCHAR(100) NULL,
    [K] VARCHAR(20) NULL,
    [L] VARCHAR(5) NULL,
    [M] VARCHAR(20) NULL,
    [N] VARCHAR(20) NULL,
    [O] VARCHAR(20) NULL,
    [P] VARCHAR(20) NULL,
    [Q] VARCHAR(20) NULL,
    [R] VARCHAR(10) NULL,
    [S] VARCHAR(20) NULL,
    [T] VARCHAR(20) NULL,
    [U] VARCHAR(20) NULL,
    [V] VARCHAR(20) NULL,
    [W] VARCHAR(20) NULL,
    [X] VARCHAR(10) NULL,
    [Y] VARCHAR(50) NULL,
    [Z] VARCHAR(50) NULL,
    [AA] VARCHAR(20) NULL,
    [AB] VARCHAR(20) NULL,
    [AC] VARCHAR(20) NULL,
    [AD] VARCHAR(50) NULL,
    [AE] VARCHAR(50) NULL,
    [AF] VARCHAR(20) NULL,
    [AG] VARCHAR(20) NULL,
    [AH] VARCHAR(20) NULL,
    [AI] VARCHAR(50) NULL,
    [AJ] VARCHAR(20) NULL,
    [AK] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mcxc_mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mcxc_mismatch]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MCXCURRENCY_MISMATCH
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MCXCURRENCY_MISMATCH]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NSE_CURRENCY
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NSE_CURRENCY]
(
    [Trade_no] INT NULL,
    [Trade_Status] INT NULL,
    [Instrument_ID] INT NULL,
    [Instrument_Name] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [expirydate] DATETIME NULL,
    [Reserved] VARCHAR(20) NULL,
    [Strike Price] VARCHAR(50) NULL,
    [Reserved1] VARCHAR(20) NULL,
    [Options Type] VARCHAR(25) NULL,
    [Product Description] INT NULL,
    [Book Tpe Name] VARCHAR(20) NULL,
    [Book Type] INT NULL,
    [user id] INT NULL,
    [Branch No] INT NULL,
    [Buy Sell] INT NULL,
    [Trade quantity] INT NULL,
    [Price] MONEY NULL,
    [Account Type] INT NULL,
    [Account ID] VARCHAR(25) NULL,
    [Participant Settler] INT NULL,
    [Spread Price] VARCHAR(50) NULL,
    [TM ID] VARCHAR(50) NULL,
    [Reserved3] VARCHAR(20) NULL,
    [Activity Time] DATETIME NULL,
    [Last Modified time] VARCHAR(50) NULL,
    [Order Number] VARCHAR(20) NULL,
    [Opposite Broker Id] VARCHAR(10) NULL,
    [Order User Last Update Time] VARCHAR(50) NULL,
    [Mod Date Time] VARCHAR(50) NULL,
    [Order Entered/Mod Date Time] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSE_Mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSE_Mismatch]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSE_OFS_Mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSE_OFS_Mismatch]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NSEC_MISMATCH
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NSEC_MISMATCH]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NseCurrency_Mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NseCurrency_Mismatch]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NseCurrency_Mismatch031111
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NseCurrency_Mismatch031111]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSX_Mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSX_Mismatch]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_nsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_nsecashtrd]
(
    [termid] FLOAT NULL,
    [turnover] FLOAT NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_nsxtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_nsxtrd]
(
    [termid] FLOAT NULL,
    [turnover] FLOAT NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_tbl_NSE_Mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_tbl_NSE_Mismatch]
(
    [Fld_Mismatch] VARCHAR(500) NULL,
    [party_code] VARCHAR(100) NULL,
    [terminalid] VARCHAR(100) NULL,
    [brcode] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.todelete
-- --------------------------------------------------
CREATE TABLE [dbo].[todelete]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.todelete3
-- --------------------------------------------------
CREATE TABLE [dbo].[todelete3]
(
    [col1] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TradeOnLine
-- --------------------------------------------------
CREATE TABLE [dbo].[TradeOnLine]
(
    [Col001] VARCHAR(8000) NULL,
    [Col002] VARCHAR(8000) NULL,
    [Col003] VARCHAR(8000) NULL,
    [Col004] VARCHAR(8000) NULL,
    [Col005] VARCHAR(8000) NULL,
    [Col006] VARCHAR(8000) NULL,
    [Col007] VARCHAR(8000) NULL,
    [Col008] VARCHAR(8000) NULL,
    [Col009] VARCHAR(8000) NULL,
    [Col010] VARCHAR(8000) NULL,
    [Col011] VARCHAR(8000) NULL,
    [Col012] VARCHAR(8000) NULL,
    [Col013] VARCHAR(8000) NULL,
    [Col014] VARCHAR(8000) NULL,
    [Col015] VARCHAR(8000) NULL,
    [Col016] VARCHAR(8000) NULL,
    [Col017] VARCHAR(8000) NULL,
    [Col018] VARCHAR(8000) NULL,
    [Col019] VARCHAR(8000) NULL,
    [Col020] VARCHAR(8000) NULL,
    [Col021] VARCHAR(8000) NULL,
    [Col022] VARCHAR(8000) NULL,
    [Col023] VARCHAR(8000) NULL,
    [Col024] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.varmarg_scrip_perc
-- --------------------------------------------------
CREATE TABLE [dbo].[varmarg_scrip_perc]
(
    [rec_type] INT NULL,
    [scrip_cd] VARCHAR(25) NULL,
    [series] VARCHAR(10) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] VARCHAR(255) NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [marg_perc] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.WRONG_BRANCH
-- --------------------------------------------------
CREATE TABLE [dbo].[WRONG_BRANCH]
(
    [party_code] VARCHAR(10) NULL,
    [termid] VARCHAR(5) NULL,
    [branch_cd1] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [branch_cd] VARCHAR(5) NULL
);

GO

