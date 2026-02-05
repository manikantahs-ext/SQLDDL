-- DDL Export
-- Server: 10.253.78.163
-- Database: EMP_DB
-- Exported: 2026-02-05T12:29:56.719475

USE EMP_DB;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_TABLE_ACTIVITY
-- --------------------------------------------------
CREATE PROCEDURE DBA_TABLE_ACTIVITY
AS
BEGIN

	WITH LastActivity (ObjectID, LastAction) 
	AS 
	( 
	SELECT object_id AS TableName, Last_User_Seek as LastAction
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_scan as LastAction 
	FROM sys.dm_db_index_usage_stats u 
	WHERE database_id = db_id(db_name()) 
	UNION 
	SELECT object_id AS TableName,last_user_lookup as LastAction 
	FROM sys.dm_db_index_usage_stats u  
	WHERE database_id = db_id(db_name()) 
	) 

	SELECT OBJECT_NAME(so.object_id)AS TableName, so.Create_Date "Creation Date",so.Modify_date "Last Modified",
	MAX(la.LastAction)as "Last Accessed" 
	FROM 
	sys.objects so 
	LEFT JOIN LastActivity la 
	ON so.object_id = la.ObjectID 
	WHERE so.type = 'U' 
	AND so.object_id > 100   --returns only the user tables.Tables with objectid < 100 are systables. 
	GROUP BY OBJECT_NAME(so.object_id),so.Create_Date,so.Modify_date
	ORDER BY OBJECT_NAME(so.object_id)
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.disp_emptrd
-- --------------------------------------------------



CREATE proc [dbo].[disp_emptrd]
(
@frmdate datetime,
@todate datetime,
@segment varchar(10)
)
as

drop table itrd_temp


/*
exec disp_emptrd '2007-10-01','2008-01-01','ABLCM'

select branch_cd as br_code, sub_broker as sb_code,party_code , party_name ,sum(to_del_opt)as del_to, 
sum(to_trd_fut) as trd_to 
into itrd_temp
from intranet.bsedb_ab.dbo.mis_to 
where sauda_date>=@frmdate and sauda_date<=@todate and company=@segment 
and party_code in   
(
select (emptrdcode) collate SQL_Latin1_General_CP1_CI_AS from mis.emp_db.dbo.emptrdcode_master
) 
group by party_code, party_name, branch_cd, sub_broker
*/
select branch_cd as br_code, sub_broker as sb_code,party_code , party_name ,to_del_opt as del_to, 
to_trd_fut as trd_to 
into itrd_temp
from intranet.bsedb_ab.dbo.mis_to 
where sauda_date>=@frmdate 
and sauda_date<=@todate 
and company=@segment
and party_code in   
(
select (emptrdcode) collate SQL_Latin1_General_CP1_CI_AS from mis.emp_db.dbo.emptrdcode_master
) 

/*
select branch_cd as br_code, sub_broker as sb_code,party_code , party_name ,to_del_opt as del_to, 
to_trd_fut as trd_to 
into itrd_temp
from intranet.bsedb_ab.dbo.mis_to 
where sauda_date>='2007-01-07'
--@frmdate 
and sauda_date<='2008-01-01'
--@todate 
and company='ABLCM'
--@segment
and party_code in   
(
select (emptrdcode) collate SQL_Latin1_General_CP1_CI_AS from mis.emp_db.dbo.emptrdcode_master
) 
*/


select b.emp_code,c.emp_name,sum(del_to) as del_to, sum(trd_to) as trd_to from
intranet.risk.dbo.emp_info c , mis.emp_db.dbo.emptrdcode_master b
right outer join
(select * from itrd_temp (nolock)) a
on b.emptrdcode=a.party_code
collate SQL_Latin1_General_CP1_CI_AS
where b.emp_code = c.emp_no
group by b.emp_code, c.emp_name

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.disp_emptrd_details
-- --------------------------------------------------


CREATE proc [dbo].[disp_emptrd_details]
(
@emp_code varchar(10)
)
as 
select br_code,sb_code, party_code, party_name, sum(del_to) as del_to, sum(trd_to) as trd_to from itrd_temp (nolock) 
where party_code in (select emptrdcode  collate SQL_Latin1_General_CP1_CI_AS from mis.emp_db.dbo.emptrdcode_master where emp_code=@emp_code)
group by party_code, party_name, sb_code,br_code

return

GO

-- --------------------------------------------------
-- PROCEDURE dbo.insidertrading_update
-- --------------------------------------------------
CREATE Proc insidertrading_update

(@emp_code as varchar(6),
@emptrdcode as varchar(10),
@bank_name1 as varchar(25),
@branch_name1 as varchar(15),
@bankac_no1 as varchar (20),
@bankac_type1 as varchar(6),
@bank_name2 as varchar(25),
@branch_name2 as varchar(15),
@bankac_no2 as varchar (20),
@bankac_type2 as varchar(6),
@bank_name3 as varchar(25),
@branch_name3 as varchar(15),
@bankac_no3 as varchar (20),
@bankac_type3 as varchar(6),
@dpname1 as varchar(15),
@dptype1 as varchar(4),
@dpid1 as varchar(10),
@cltdpid1 as varchar(20),
@dpname2 as varchar(15),
@dptype2 as varchar(4),
@dpid2 as varchar(10),
@cltdpid2 as varchar(20),
@dpname3 as varchar(15),
@dptype3 as varchar(4),
@dpid3 as varchar(10),
@cltdpid3 as varchar(20),
@hasAng_ac as varchar(1),
@type as varchar(8),
@relationship as varchar(8),
@broker_name as varchar(25)
)

as 

Update emptrdcode_master
set
bank_name1=@bank_name1,
branch_name1=@branch_name1,
bankac_no1=@bankac_no1,
bankac_type1=@bankac_type1,
bank_name2=@bank_name2,
branch_name2=@branch_name2,
bankac_no2=@bankac_no2,
bankac_type2=@bankac_type2,
bank_name3=@bank_name3,
branch_name3=@branch_name3,
bankac_no3=@bankac_no3,
bankac_type3=@bankac_type3,
dpname1=@dpname1,
dptype1=@dptype1,
dpid1=@dpid1,
cltdpid1=@cltdpid1,
dpname2=@dpname2,
dptype2=@dptype2,
dpid2=@dpid2,
cltdpid2=@cltdpid2,
dpname3=@dpname3,
dptype3=@dptype3,
dpid3=@dpid3,
cltdpid3=@cltdpid3,
hasAng_ac=@hasAng_ac,
type=@type,
relationship=@relationship,
broker_name=@broker_name
 where emptrdcode=@emptrdcode and emp_code=@emp_code

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
-- PROCEDURE dbo.ttest
-- --------------------------------------------------
create proc ttest
as 
select 'sumit'

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
-- TABLE dbo.empdetails
-- --------------------------------------------------
CREATE TABLE [dbo].[empdetails]
(
    [empcode] VARCHAR(20) NULL,
    [dojoin] DATETIME NULL,
    [first_name] VARCHAR(100) NULL,
    [middle_name] VARCHAR(100) NULL,
    [last_name] VARCHAR(100) NULL,
    [gender] VARCHAR(8) NULL,
    [dob] DATETIME NULL,
    [father_name] VARCHAR(100) NULL,
    [mother_name] VARCHAR(100) NULL,
    [pan_no] VARCHAR(50) NULL,
    [house_no] VARCHAR(100) NULL,
    [l_address1] VARCHAR(100) NULL,
    [l_address2] VARCHAR(100) NULL,
    [l_city] VARCHAR(100) NULL,
    [pin_code] VARCHAR(10) NULL,
    [phone_std] VARCHAR(8) NULL,
    [phone_no] VARCHAR(20) NULL,
    [mobi_no] VARCHAR(25) NULL,
    [driving_license] VARCHAR(5) NULL,
    [mapin] VARCHAR(5) NULL,
    [passport] VARCHAR(5) NULL,
    [pan_card] VARCHAR(5) NULL,
    [voter_id] VARCHAR(5) NULL,
    [pi_docuno] VARCHAR(80) NULL,
    [pi_pofissue] VARCHAR(80) NULL,
    [pi_doissue] VARCHAR(80) NULL,
    [pa_passport] VARCHAR(10) NULL,
    [pa_voter_id] VARCHAR(10) NULL,
    [pa_driving_license] VARCHAR(10) NULL,
    [pa_bank_passbook] VARCHAR(10) NULL,
    [pa_rent_agreement] VARCHAR(10) NULL,
    [pa_Ration_Card] VARCHAR(10) NULL,
    [pa_flat_mnt_bill] VARCHAR(10) NULL,
    [pa_tel_bill] VARCHAR(10) NULL,
    [pa_elec_bill] VARCHAR(10) NULL,
    [pa_cert_uin] VARCHAR(10) NULL,
    [pa_insurance_policy] VARCHAR(10) NULL,
    [pa_docuno] VARCHAR(80) NULL,
    [pa_pofissue] VARCHAR(80) NULL,
    [pa_doissue] VARCHAR(80) NULL,
    [remarks] VARCHAR(100) NULL,
    [dummy1] VARCHAR(30) NULL,
    [dummy2] VARCHAR(30) NULL,
    [dummy3] VARCHAR(30) NULL,
    [edu_quali1] VARCHAR(255) NULL,
    [edu_issuAuth1] VARCHAR(255) NULL,
    [edu_validupto1] VARCHAR(255) NULL,
    [edu_quali2] VARCHAR(255) NULL,
    [edu_issuAuth2] VARCHAR(255) NULL,
    [edu_validupto2] VARCHAR(255) NULL,
    [edu_quali3] VARCHAR(255) NULL,
    [edu_issuAuth3] VARCHAR(255) NULL,
    [edu_validupto3] VARCHAR(255) NULL,
    [edu_quali4] VARCHAR(255) NULL,
    [edu_issuAuth4] VARCHAR(255) NULL,
    [edu_validupto4] VARCHAR(255) NULL,
    [edu_quali5] VARCHAR(255) NULL,
    [edu_issuAuth5] VARCHAR(255) NULL,
    [edu_validupto5] VARCHAR(255) NULL,
    [tr_name1] VARCHAR(255) NULL,
    [tr_condby1] VARCHAR(255) NULL,
    [tr_from1] VARCHAR(255) NULL,
    [tr_to1] VARCHAR(255) NULL,
    [tr_name2] VARCHAR(255) NULL,
    [tr_condby2] VARCHAR(255) NULL,
    [tr_from2] VARCHAR(255) NULL,
    [tr_to2] VARCHAR(255) NULL,
    [tr_name3] VARCHAR(255) NULL,
    [tr_condby3] VARCHAR(255) NULL,
    [tr_from3] VARCHAR(255) NULL,
    [tr_to3] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.emplist
-- --------------------------------------------------
CREATE TABLE [dbo].[emplist]
(
    [empcode] VARCHAR(20) NULL,
    [NAME] VARCHAR(100) NULL,
    [dojoin] DATETIME NULL,
    [POSITION] VARCHAR(80) NULL,
    [COMPANY] VARCHAR(25) NULL,
    [BRANCH] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.emplist1
-- --------------------------------------------------
CREATE TABLE [dbo].[emplist1]
(
    [empcode] VARCHAR(20) NULL,
    [NAME] VARCHAR(100) NULL,
    [dojoin] DATETIME NULL,
    [POSITION] VARCHAR(80) NULL,
    [COMPANY] VARCHAR(25) NULL,
    [BRANCH] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.emptrdcode_master
-- --------------------------------------------------
CREATE TABLE [dbo].[emptrdcode_master]
(
    [emp_code] VARCHAR(20) NULL,
    [emptrdcode] VARCHAR(20) NULL,
    [type] VARCHAR(1) NULL,
    [Name] VARCHAR(50) NULL,
    [Relationship] VARCHAR(30) NULL,
    [bankac_no1] VARCHAR(30) NULL,
    [hasAng_ac] VARCHAR(1) NULL,
    [broker_name] VARCHAR(50) NULL,
    [bank_name1] VARCHAR(30) NULL,
    [branch_name1] VARCHAR(15) NULL,
    [bankac_type1] VARCHAR(15) NULL,
    [bank_name2] VARCHAR(30) NULL,
    [bankac_no2] VARCHAR(15) NULL,
    [branch_name2] VARCHAR(25) NULL,
    [bankac_type2] VARCHAR(15) NULL,
    [bank_name3] VARCHAR(30) NULL,
    [bankac_no3] VARCHAR(15) NULL,
    [branch_name3] VARCHAR(25) NULL,
    [bankac_type3] VARCHAR(15) NULL,
    [dptype1] VARCHAR(5) NULL,
    [dpid1] VARCHAR(20) NULL,
    [cltdpid1] VARCHAR(20) NULL,
    [dptype2] VARCHAR(5) NULL,
    [dpid2] VARCHAR(20) NULL,
    [cltdpid2] VARCHAR(20) NULL,
    [dptype3] VARCHAR(5) NULL,
    [dpid3] VARCHAR(20) NULL,
    [cltdpid3] VARCHAR(20) NULL,
    [dpname1] VARCHAR(50) NULL,
    [dpname2] VARCHAR(50) NULL,
    [dpname3] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.itrd_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[itrd_temp]
(
    [br_code] VARCHAR(20) NULL,
    [sb_code] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [party_name] VARCHAR(100) NULL,
    [del_to] MONEY NULL,
    [trd_to] MONEY NULL
);

GO

