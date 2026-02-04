-- DDL Export
-- Server: 10.253.33.89
-- Database: BSE
-- Exported: 2026-02-05T02:38:30.542679

USE BSE;
GO

-- --------------------------------------------------
-- FUNCTION dbo.fn_diagramobjects
-- --------------------------------------------------

	CREATE FUNCTION dbo.fn_diagramobjects() 
	RETURNS int
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		declare @id_upgraddiagrams		int
		declare @id_sysdiagrams			int
		declare @id_helpdiagrams		int
		declare @id_helpdiagramdefinition	int
		declare @id_creatediagram	int
		declare @id_renamediagram	int
		declare @id_alterdiagram 	int 
		declare @id_dropdiagram		int
		declare @InstalledObjects	int

		select @InstalledObjects = 0

		select 	@id_upgraddiagrams = object_id(N'dbo.sp_upgraddiagrams'),
			@id_sysdiagrams = object_id(N'dbo.sysdiagrams'),
			@id_helpdiagrams = object_id(N'dbo.sp_helpdiagrams'),
			@id_helpdiagramdefinition = object_id(N'dbo.sp_helpdiagramdefinition'),
			@id_creatediagram = object_id(N'dbo.sp_creatediagram'),
			@id_renamediagram = object_id(N'dbo.sp_renamediagram'),
			@id_alterdiagram = object_id(N'dbo.sp_alterdiagram'), 
			@id_dropdiagram = object_id(N'dbo.sp_dropdiagram')

		if @id_upgraddiagrams is not null
			select @InstalledObjects = @InstalledObjects + 1
		if @id_sysdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 2
		if @id_helpdiagrams is not null
			select @InstalledObjects = @InstalledObjects + 4
		if @id_helpdiagramdefinition is not null
			select @InstalledObjects = @InstalledObjects + 8
		if @id_creatediagram is not null
			select @InstalledObjects = @InstalledObjects + 16
		if @id_renamediagram is not null
			select @InstalledObjects = @InstalledObjects + 32
		if @id_alterdiagram  is not null
			select @InstalledObjects = @InstalledObjects + 64
		if @id_dropdiagram is not null
			select @InstalledObjects = @InstalledObjects + 128
		
		return @InstalledObjects 
	END

GO

-- --------------------------------------------------
-- FUNCTION dbo.formatedate_ddmmmyyyy
-- --------------------------------------------------
CREATE 

	function [dbo].[formatedate_ddmmmyyyy](@date varchar(11)) returns varchar(20)

as

begin

	declare 
		@day char(2),
		@month char(3),
		@year char(4),
		@ddmmmyyyy varchar(20)

		select
			@day = right('0' + convert(varchar, day(convert(datetime, @date))), 2),
			@month = convert(varchar, month(convert(datetime, @date))),
			@year = convert(varchar, year(convert(datetime, @date)))

		select @month = dbo.monthname (convert(int, @month), 'Y')
		select @ddmmmyyyy = @day + '-' + @month + '-' + @year

	return @ddmmmyyyy

end

GO

-- --------------------------------------------------
-- FUNCTION dbo.monthname
-- --------------------------------------------------
CREATE 

	function [dbo].[monthname](@monthno tinyint, @abbr char(1)) returns varchar(20)

as

begin

	declare 
		@monthname varchar(20)

	select
		@monthname = 
	case 
		when @monthno = 1 then 'January'
		when @monthno = 2 then 'February'
		when @monthno = 3 then 'March'
		when @monthno = 4 then 'April'
		when @monthno = 5 then 'May'
		when @monthno = 6 then 'June'
		when @monthno = 7 then 'July'
		when @monthno = 8 then 'August'
		when @monthno = 9 then 'September'
		when @monthno = 10 then 'October'
		when @monthno = 11 then 'November'
		when @monthno = 12 then 'December'
		else
			'INVALID MONTH'
		end

	if @abbr = 'Y' begin
		set @monthname	= left(@monthname, 3)
	end

	return @monthname

end

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B616166761E] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.____bkup_uccncdex_dec_19_2007
-- --------------------------------------------------



CREATE procedure [dbo].[uccncdex](@fdate as datetime,@tdate as datetime)

as  

/*
	exec uccncdex @fdate = 'Aug 24 2007 00:00:00', @tdate = 'Aug 24 2007 23:59:59'
	exec uccncdex @fdate = 'Dec  1 2007 00:00:00', @tdate = 'Dec 3 2007 23:59:59'
	exec uccncdex '25/08/2007 00:00:00','25/08/2007 23:59:00' 
	exec uccncdex '25/08/2007 00:00:00','25/08/2007 23:59:00' 
*/

set nocount on
set implicit_transactions off
set transaction isolation level read uncommitted 

declare @totalrecord as numeric

	select 
		@totalrecord=count(*)
	from
		angelcommodity.ncdx.dbo.client5 c5    
	where 
		c5.activefrom<= @tdate
		and c5.activefrom>= @fdate

	select 
		totalrecord = @totalrecord,
		c5.cl_code,
/*
		c5.drivelicendtl,
		c5.rationcarddtl,
		c5.passportdtl,
		c5.votersiddtl,
*/
		remark = c5.p_address1,
		c5.introducer,
		c1.pan_gir_no,
		c1.short_name,
		c1.branch_cd,
		c1.sub_broker,
/*
		c4.bankid,
		c4.cltdpid,
		c4.depository,
*/
		c1.long_name,
		c1.l_address1,
		c1.l_address2,
		c1.l_city,
		c1.l_state,
		c1.l_zip, 

		phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
		case when 
			isnumeric(
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			) = 1 
			then
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			else
				''
			end,
			c5.activefrom,

			passport_no = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.passportdtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.passportdtl, ''))) 
					end, 25
				),
			place_of_issue_of_passport = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.passportdtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.passportplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.passportplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_passport = 
				case 
					when ltrim(rtrim(isnull(c5.passportdtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.passportdateofissue, ''), 109), 11))
				end,

			driving_license_no = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.drivelicendtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.drivelicendtl, ''))) 
					end, 25
				),
			place_of_issue_of_driving_license = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.drivelicendtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.licencenoplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.licencenoplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_driving_license = 
				case 
					when ltrim(rtrim(isnull(c5.drivelicendtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.licencenodateofissue, ''), 109), 11))
				end,

			voter_id = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.votersiddtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.votersiddtl, ''))) 
					end, 25
				),
			place_of_issue_of_voter_id = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.votersiddtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.voteridplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.voteridplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_voter_id = 
				case 
					when ltrim(rtrim(isnull(c5.votersiddtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.voteriddateofissue, ''), 109), 11))
				end,

			ration_card_number = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.rationcarddtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.rationcarddtl, ''))) 
					end, 25
				),
			place_of_issue_of_ration_card = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.rationcarddtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.rationcardplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.rationcardplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_ration_card = 
				case 
					when ltrim(rtrim(isnull(c5.rationcarddtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.rationcarddateofissue, ''), 109), 11))
				end
	into
		#ucc_ncdex_client
	from
		angelcommodity.ncdx.dbo.client5 c5
	left outer join
		angelcommodity.ncdx.dbo.client1 c1
	on
		c5.cl_code=c1.cl_code
/*
	left outer join
		angelcommodity.ncdx.dbo.client4 c4
	on
		c5.cl_code=c4.cl_code
*/
	where
		c5.activefrom<=@tdate
		and c5.activefrom>= @fdate
	order by
		c1.branch_cd,c1.sub_broker,c5.cl_code

select distinct
	party_code = ltrim(rtrim(c4.party_code)),
	bank_id = ltrim(rtrim(c4.bankid)),
	bank_name = ltrim(rtrim(isnull(b.bank_name, ''))),
--	bank_address = ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))) + space(1) + ltrim(rtrim(isnull(b.state, ''))) + space(1) + ltrim(rtrim(isnull(b.nation, ''))),
	bank_address = ltrim(rtrim(isnull(b.branch_name, ''))),
	account_type = ltrim(rtrim(c4.depository)),
	account_no = ltrim(rtrim(c4.cltdpid))
into
	#pobank
from
	#ucc_ncdex_client t,
	angelcommodity.ncdx.dbo.client4 c4,
	angelcommodity.ncdx.dbo.pobank b
where
	ltrim(rtrim(t.cl_code)) = ltrim(rtrim(c4.party_code)) and
	ltrim(rtrim(c4.bankid)) = ltrim(rtrim(b.bankid)) and
	ltrim(rtrim(isnull(c4.depository, ''))) in ('SAVING', 'CURRENT', 'OTHER')

select distinct
	party_code = ltrim(rtrim(c4.party_code)),
	bank_id = ltrim(rtrim(c4.bankid)),
	bank_name = ltrim(rtrim(isnull(b.bankname, ''))),
	bank_address = ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))),
	account_type = ltrim(rtrim(c4.depository)),
	account_no = ltrim(rtrim(c4.cltdpid))
into
	#bank
from
	#ucc_ncdex_client t,
	angelcommodity.ncdx.dbo.client4 c4,
	angelcommodity.ncdx.dbo.bank b
where
	ltrim(rtrim(t.cl_code)) = ltrim(rtrim(c4.party_code)) and
	ltrim(rtrim(c4.bankid)) = ltrim(rtrim(b.bankid)) and
	ltrim(rtrim(isnull(c4.depository, ''))) in ('CDSL', 'NSDL') and
	ltrim(rtrim(isnull(c4.defdp, ''))) = '1'

select distinct
	party_code = ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end)),
	bank_name = ltrim(rtrim(isnull(po.bank_name, ''))),
	bank_address = ltrim(rtrim(isnull(po.bank_address, ''))),
	bank_account_type = ltrim(rtrim(isnull(po.account_type, ''))),
	bank_account_no = ltrim(rtrim(isnull(po.account_no, ''))),

	dp_id = ltrim(rtrim(isnull(b.bank_id, ''))),
	dp_name = ltrim(rtrim(isnull(b.bank_name, ''))),
	dp_type = ltrim(rtrim(isnull(b.account_type, ''))),
	demat_id_of_client = ltrim(rtrim(isnull(b.account_no, '')))
into
	#ucc_ncdex_client_bank
from
	#pobank po full outer join #bank b on ltrim(rtrim(po.party_code)) = ltrim(rtrim(b.party_code))
order by
	ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end))

--select
--	party_code = ltrim(rtrim(t.cl_code)),
--	c5.*
--into
--	#ucc_ncdex_client5
--from
--	#ucc_ncdex_client t,
--	angelcommodity.ncdx.dbo.client5 c5
--where
--	ltrim(rtrim(c5.cl_code)) = ltrim(rtrim(t.cl_code))

select
	cl.*,

	bank_name = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_name, ''))) else '' end, 50
		),''),
	bank_address = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_address, ''))) else '' end, 120
		),''),
	bank_account_type = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_account_type, ''))) else '' end, 15
		),''),
	bank_account_no = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_account_no, ''))) else '' end, 25
		),''),
	cdsl_depository_name = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('CDSL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_id, ''))) else '' end, 25
		),''),
	cdsl_depository_participant = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('CDSL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_name, ''))) else '' end, 80
		),''),
	cdsl_client_dp_id = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('CDSL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.demat_id_of_client, ''))) else '' end, 25
		),''),

	nsdl_depository_name = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('NSDL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_id, ''))) else '' end, 25
		),''),
	nsdl_depository_participant = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('NSDL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_name, ''))) else '' end, 80
		),''),
	nsdl_client_dp_id = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('NSDL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.demat_id_of_client, ''))) else '' end, 25
		),'')
from
	#ucc_ncdex_client cl left outer join #ucc_ncdex_client_bank c1_b on cl.cl_code = c1_b.party_code
order by
	cl.branch_cd,
	cl.sub_broker,
	cl.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.cashcount
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[cashcount]
 AS

select co=count(*) 
from nsependinglist ucc 
    join AngelNseCM.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode 
    left join AngelNseCM.msajag.dbo.client4 c4 on c4.party_code = ucc.clcode 
    left join AngelNseCM.msajag.dbo.client1 c1 on c2.cl_code = c1.Cl_Code 
where c2.party_code is not null and ucc.clcode in (select distinct clcode from nsependinglist where segment='C') and ucc.segment='C'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.focount
-- --------------------------------------------------
CREATE PROCEDURE focount
 AS
select co=count(*) from nsependinglist ucc 
    join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode 
    left join angelfo.nsefo.dbo.client4 c4 on c4.party_code = ucc.clcode 
    left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.Cl_Code 
where c2.party_code is not null and ucc.clcode in (select distinct clcode from nsependinglist where segment='F') and ucc.segment='F'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.foTradeUpload
-- --------------------------------------------------
CREATE PROCEDURE foTradeUpload --'AngelFoTrade', 'Oct 13 2005', 'Trade901917102005.txt', ',', '\n', 'angelfotradebefore'    
@DBTable varchar(25),    
--@strDate varchar(15),    
@DataFile varchar(100),    
@FldTerminator varchar(5),    
@RowTerminator varchar(5)    
--@DBTableBefore varchar(50),    
--@DBTableInter varchar(50)    
 AS    
begin    
 declare @strQuery varchar(1000)    
    
 --Step1- To Delete records from table where all records are stored     
 set @strQuery = ''    
 set @strQuery = ('TRUNCATE TABLE ' + @DBTable)     
 print @strQuery    
 exec(@strQuery)    
    
     
 --Step2- Bulk Insert for table where all records are stored     
 set @strQuery = ''    
 set @strQuery = ('BULK INSERT ' + @DBTable +    
    ' FROM ''' + @DataFile + ''' WITH (    
     FIELDTERMINATOR = ''' + @FldTerminator +    
    ''', ROWTERMINATOR = ''' + @RowTerminator + ''')')    
 print @strQuery    
 exec(@strQuery)    
    
    
End

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
-- PROCEDURE dbo.selftrade_new
-- --------------------------------------------------
CREATE procedure selftrade_new (@sett_Date as varchar(11))
as

set nocount on

--drop table temp_selftrade
--declare @sett_date as varchar(11)
--set @sett_date = 'Dec 17 2004'

Select branch_name=isnull(br.branch,'Unknown'),Sauda_date=convert(varchar(11),Sauda_Date,109)+' '+sauda_time,
Series=' ',S.Trade_no,Order_no,[user_id]=S.termid,branchcode=isnull(branch_cd,''), branch_id=s.party_Code,
acname=isnull(c1.short_name,'Party Not found'),S.Scrip_Cd,scpname=s2.scrip_cd,
sb=(case when sell_buy='S' then 'Sell' else 'Buy' end), tradeqty,marketrate,net_trdqty=isnull(no_of_shrs,0),
our=isnull(((100*tradeqty)/no_of_shrs),0) into #
from 

(
select * from esignbse.bse.dbo.bsecashtrd where sauda_Date =@sett_Date and isnumeric(trade_no)=1 ) S 
left join ( select * from intranet.misc.dbo.qe where pddate=@sett_Date ) qe 
on qe.sc_code=s.scrip_cd, 
(select trade_no,Scrip_cd from esignbse.bse.dbo.bsecashtrd
where sauda_date =@sett_Date 
group by trade_no,Scrip_Cd Having count(Trade_no) > 1) D , anand.bsedb_ab.dbo.Scrip2 S2 , 
--( ( select User_id = UserId from anand.bsedb_ab.dbo.termparty) union (
--select User_id = Termid from esignbse.bse.dbo.bse_termid) ) T, 
anand.bsedb_ab.dbo.Client2 C2, 
anand.bsedb_ab.dbo.Client1 C1, anand.bsedb_ab.dbo.branch br where 
sauda_Date=@sett_Date  and S.Scrip_cd = D.Scrip_cd and S.Trade_no = D.Trade_no 
and s.sauda_Date=@sett_Date  and S.Scrip_cd = S2.Bsecode 
and s.Party_code = C2.Party_code and C2.Cl_code = C1.Cl_code and br.branch_code=branch_cd 
--and T.User_Id = S.termid 
order by s2.scrip_cd,S.trade_no,S.Tradeqty,S.Sell_buy 

delete from # where Scrip_Cd in (select scrip from intranet.misc.dbo.scriplockmast where lock = 'Y')

update # set marketrate = marketrate/100

delete from selftrade_fin where sauda_Date like @sett_date+'%'
insert into selftrade_fin select * from #

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_alterdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_alterdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null,
		@version 	int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId 			int
		declare @retval 		int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @ShouldChangeUID	int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid ARG', 16, 1)
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();	 
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		revert;
	
		select @ShouldChangeUID = 0
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		
		if(@DiagId IS NULL or (@IsDbo = 0 and @theId <> @UIDFound))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end
	
		if(@IsDbo <> 0)
		begin
			if(@UIDFound is null or USER_NAME(@UIDFound) is null) -- invalid principal_id
			begin
				select @ShouldChangeUID = 1 ;
			end
		end

		-- update dds data			
		update dbo.sysdiagrams set definition = @definition where diagram_id = @DiagId ;

		-- change owner
		if(@ShouldChangeUID = 1)
			update dbo.sysdiagrams set principal_id = @theId where diagram_id = @DiagId ;

		-- update dds version
		if(@version is not null)
			update dbo.sysdiagrams set version = @version where diagram_id = @DiagId ;

		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_creatediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_creatediagram
	(
		@diagramname 	sysname,
		@owner_id		int	= null, 	
		@version 		int,
		@definition 	varbinary(max)
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
	
		declare @theId int
		declare @retval int
		declare @IsDbo	int
		declare @userName sysname
		if(@version is null or @diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID(); 
		select @IsDbo = IS_MEMBER(N'db_owner');
		revert; 
		
		if @owner_id is null
		begin
			select @owner_id = @theId;
		end
		else
		begin
			if @theId <> @owner_id
			begin
				if @IsDbo = 0
				begin
					RAISERROR (N'E_INVALIDARG', 16, 1);
					return -1
				end
				select @theId = @owner_id
			end
		end
		-- next 2 line only for test, will be removed after define name unique
		if EXISTS(select diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @diagramname)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end
	
		insert into dbo.sysdiagrams(name, principal_id , version, definition)
				VALUES(@diagramname, @theId, @version, @definition) ;
		
		select @retval = @@IDENTITY 
		return @retval
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_dropdiagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_dropdiagram
	(
		@diagramname 	sysname,
		@owner_id	int	= null
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
	
		if(@diagramname is null)
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT; 
		
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		delete from dbo.sysdiagrams where diagram_id = @DiagId;
	
		return 0;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagramdefinition
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagramdefinition
	(
		@diagramname 	sysname,
		@owner_id	int	= null 		
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		set nocount on

		declare @theId 		int
		declare @IsDbo 		int
		declare @DiagId		int
		declare @UIDFound	int
	
		if(@diagramname is null)
		begin
			RAISERROR (N'E_INVALIDARG', 16, 1);
			return -1
		end
	
		execute as caller;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner');
		if(@owner_id is null)
			select @owner_id = @theId;
		revert; 
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname;
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId ))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1);
			return -3
		end

		select version, definition FROM dbo.sysdiagrams where diagram_id = @DiagId ; 
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_helpdiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_helpdiagrams
	(
		@diagramname sysname = NULL,
		@owner_id int = NULL
	)
	WITH EXECUTE AS N'dbo'
	AS
	BEGIN
		DECLARE @user sysname
		DECLARE @dboLogin bit
		EXECUTE AS CALLER;
			SET @user = USER_NAME();
			SET @dboLogin = CONVERT(bit,IS_MEMBER('db_owner'));
		REVERT;
		SELECT
			[Database] = DB_NAME(),
			[Name] = name,
			[ID] = diagram_id,
			[Owner] = USER_NAME(principal_id),
			[OwnerID] = principal_id
		FROM
			sysdiagrams
		WHERE
			(@dboLogin = 1 OR USER_NAME(principal_id) = @user) AND
			(@diagramname IS NULL OR name = @diagramname) AND
			(@owner_id IS NULL OR principal_id = @owner_id)
		ORDER BY
			4, 5, 1
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_renamediagram
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_renamediagram
	(
		@diagramname 		sysname,
		@owner_id		int	= null,
		@new_diagramname	sysname
	
	)
	WITH EXECUTE AS 'dbo'
	AS
	BEGIN
		set nocount on
		declare @theId 			int
		declare @IsDbo 			int
		
		declare @UIDFound 		int
		declare @DiagId			int
		declare @DiagIdTarg		int
		declare @u_name			sysname
		if((@diagramname is null) or (@new_diagramname is null))
		begin
			RAISERROR ('Invalid value', 16, 1);
			return -1
		end
	
		EXECUTE AS CALLER;
		select @theId = DATABASE_PRINCIPAL_ID();
		select @IsDbo = IS_MEMBER(N'db_owner'); 
		if(@owner_id is null)
			select @owner_id = @theId;
		REVERT;
	
		select @u_name = USER_NAME(@owner_id)
	
		select @DiagId = diagram_id, @UIDFound = principal_id from dbo.sysdiagrams where principal_id = @owner_id and name = @diagramname 
		if(@DiagId IS NULL or (@IsDbo = 0 and @UIDFound <> @theId))
		begin
			RAISERROR ('Diagram does not exist or you do not have permission.', 16, 1)
			return -3
		end
	
		-- if((@u_name is not null) and (@new_diagramname = @diagramname))	-- nothing will change
		--	return 0;
	
		if(@u_name is null)
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @theId and name = @new_diagramname
		else
			select @DiagIdTarg = diagram_id from dbo.sysdiagrams where principal_id = @owner_id and name = @new_diagramname
	
		if((@DiagIdTarg is not null) and  @DiagId <> @DiagIdTarg)
		begin
			RAISERROR ('The name is already used.', 16, 1);
			return -2
		end		
	
		if(@u_name is null)
			update dbo.sysdiagrams set [name] = @new_diagramname, principal_id = @theId where diagram_id = @DiagId
		else
			update dbo.sysdiagrams set [name] = @new_diagramname where diagram_id = @DiagId
		return 0
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_ucc_bsecm_load_new_client_data
-- --------------------------------------------------
--drop proc sp_ucc_bsecm_modified_client_data_fetch
CREATE proc

	[dbo].[sp_ucc_bsecm_load_new_client_data] (
		@from_date varchar(11), 
		@to_date varchar(11) 
	)

as

/*
	exec sp_ucc_bsecm_new_client_data_fetch
		@from_date = 'Jan 22 2007',
		@to_date = 'Jan 23 2007'
*/

set implicit_transactions off 
set nocount on 
set transaction isolation level read uncommitted 
select 
	c2.party_code,
	active = case when activefrom >= convert(datetime, left(convert(varchar, getdate(), 109), 11) + ' 00:00:00') then 'Y' else 'N' end,
	added_date = activefrom
from 
	AngelBSECM.bsedb_ab.dbo.client2 c2,
	AngelBSECM.bsedb_ab.dbo.client5 c5
where
	ltrim(rtrim(c2.cl_code)) = ltrim(rtrim(c5.cl_code)) and
	activefrom >= convert(datetime, left(convert(varchar, dateadd(d, -1, getdate()), 109), 11) + ' 14:00:00') and
	activefrom < convert(datetime, left(convert(varchar, getdate(), 109), 11) + ' 14:00:00')
order by
	c2.party_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.sp_upgraddiagrams
-- --------------------------------------------------

	CREATE PROCEDURE dbo.sp_upgraddiagrams
	AS
	BEGIN
		IF OBJECT_ID(N'dbo.sysdiagrams') IS NOT NULL
			return 0;
	
		CREATE TABLE dbo.sysdiagrams
		(
			name sysname NOT NULL,
			principal_id int NOT NULL,	-- we may change it to varbinary(85)
			diagram_id int PRIMARY KEY IDENTITY,
			version int,
	
			definition varbinary(max)
			CONSTRAINT UK_principal_name UNIQUE
			(
				principal_id,
				name
			)
		);


		/* Add this if we need to have some form of extended properties for diagrams */
		/*
		IF OBJECT_ID(N'dbo.sysdiagram_properties') IS NULL
		BEGIN
			CREATE TABLE dbo.sysdiagram_properties
			(
				diagram_id int,
				name sysname,
				value varbinary(max) NOT NULL
			)
		END
		*/

		IF OBJECT_ID(N'dbo.dtproperties') IS NOT NULL
		begin
			insert into dbo.sysdiagrams
			(
				[name],
				[principal_id],
				[version],
				[definition]
			)
			select	 
				convert(sysname, dgnm.[uvalue]),
				DATABASE_PRINCIPAL_ID(N'dbo'),			-- will change to the sid of sa
				0,							-- zero for old format, dgdef.[version],
				dgdef.[lvalue]
			from dbo.[dtproperties] dgnm
				inner join dbo.[dtproperties] dggd on dggd.[property] = 'DtgSchemaGUID' and dggd.[objectid] = dgnm.[objectid]	
				inner join dbo.[dtproperties] dgdef on dgdef.[property] = 'DtgSchemaDATA' and dgdef.[objectid] = dgnm.[objectid]
				
			where dgnm.[property] = 'DtgSchemaNAME' and dggd.[uvalue] like N'_EA3E6268-D998-11CE-9454-00AA00A3F36E_' 
			return 2;
		end
		return 1;
	END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccMcdex
-- --------------------------------------------------

CREATE procedure uccMcdex(@fdate as datetime,@tdate as datetime)    
as  
declare @Totalrecord as numeric

	select 
		@Totalrecord=count(*) 
	from 
		angelcommodity.Mcdx.dbo.client5 c5    
	where 
		c5.activefrom<=@tdate 
		AND c5.activefrom>= @fdate 


	select 
		Totalrecord=@Totalrecord, c5.cl_code, c5.Drivelicendtl,
		c5.Rationcarddtl, c5.passportdtl, c5.VotersIDdtl,
		Remark=c5.p_address1, c5.introducer, c1.pan_gir_no,
		c1.short_name, c1.Branch_cd, c1.Sub_Broker, c4.bankid,
		c4.cltdpid, c4.depository, c1.long_name, c1.l_address1,
		c1.l_address2, c1.l_city, c1.l_state, c1.l_zip, 

phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
case when 
	isnumeric(
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	) = 1 
	then
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	else
		''
	end

	from 
		angelcommodity.Mcdx.dbo.client5 c5    
	left outer join  
		angelcommodity.Mcdx.dbo.client1 c1 
	on 
		c5.cl_code=c1.cl_code    
	left outer join 
		angelcommodity.Mcdx.dbo.client4 c4 
	on 
		c5.cl_code=c4.cl_code
	where 
		c5.activefrom<=@tdate 
		AND c5.activefrom>= @fdate 
	order by 
		c1.Branch_cd,c1.Sub_Broker,c5.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccmcx
-- --------------------------------------------------

CREATE procedure uccmcx(@fdate as datetime,@tdate as datetime)

as  

/*
	exec uccmcx 'Sep 26 2006', 'Sep 26 2006'
*/

declare @Totalrecord as numeric

	select 
		@Totalrecord=count(*) 
	from 
		angelcommodity.mcdx.dbo.client5 c5
	where 
		c5.activefrom <= @tdate
		AND c5.activefrom >= @fdate

	select
		Totalrecord=@Totalrecord, 
		cl_code = ltrim(rtrim(replace(c5.cl_code, ',', ''))),

		drivelicendtl = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c5.drivelicendtl, ',', '') else '' end)),
		rationcarddtl = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c5.rationcarddtl, ',', '') else '' end)),
		passportdtl = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c5.passportdtl, ',', '') else '' end)),
		votersiddtl = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c5.votersiddtl, ',', '') else '' end)),

		remark = ltrim(rtrim(replace(c5.p_address1, ',', ''))),
		introducer = ltrim(rtrim(replace(c5.introducer, ',', ''))),
		pan_gir_no = ltrim(rtrim(replace(left(ltrim(rtrim(isnull(c1.pan_gir_no, ''))), 10), ',', ''))),

		short_name = ltrim(rtrim(replace(c1.short_name, ',', ''))),
		branch_cd = ltrim(rtrim(replace(c1.branch_cd, ',', ''))),
		sub_broker = ltrim(rtrim(replace(c1.sub_broker, ',', ''))),

		bankid = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c4.bankid, ',', '') else '' end)),
		cltdpid = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c4.cltdpid, ',', '') else '' end)),
		depository = ltrim(rtrim(case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then replace(c4.depository, ',', '') else '' end)),

		long_name = ltrim(rtrim(replace(c1.long_name, ',', ''))),
		l_address1 = ltrim(rtrim(replace(c1.l_address1, ',', ''))),
		l_address2 = ltrim(rtrim(replace(c1.l_address2, ',', ''))),
		l_city = ltrim(rtrim(replace(c1.l_city, ',', ''))),
		l_state = ltrim(rtrim(replace(c1.l_state, ',', ''))),

		l_zip = ltrim(rtrim(replace(case when len(ltrim(rtrim(c1.l_zip))) = 6 then ltrim(rtrim(c1.l_zip)) else '' end, ',', ''))),

		phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
		case when 
			isnumeric(
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			) = 1 
			then
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			else
				''
			end,
			c5.activefrom

	from 
		angelcommodity.mcdx.dbo.client5 c5    
	left outer join  
		angelcommodity.mcdx.dbo.client1 c1 
	on 
		c5.cl_code=c1.cl_code    
	left outer join 
		angelcommodity.mcdx.dbo.client4 c4 
	on 
		c5.cl_code=c4.cl_code
	where 
		c5.activefrom <= @tdate
		and c5.activefrom >= @fdate
	order by 
		c1.branch_cd,c1.sub_broker,c5.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccncdex
-- --------------------------------------------------



CREATE procedure [dbo].[uccncdex](@fdate as datetime, @tdate as datetime, @selectedflag char(1))

as

/*
--	sp_rename 'uccncdex', '____bkup_uccncdex_dec_19_2007', 'object'
--	sp_rename 'uccncdex', 'uccncdex', 'object'
	exec uccncdex @fdate = 'Dec 18 2007 00:00:00', @tdate = 'Dec 19 2007 23:59:59', @selectedflag = 'N'
	exec uccncdex @fdate = 'Dec 18 2007 00:00:00', @tdate = 'Dec 19 2007 23:59:59', @selectedflag = 'Y'
	exec uccncdex 'Jan 1 1900 00:00:00','Dec 31 2078 23:59:00', 'Y'
	exec uccncdex 'Aug 14 2008 00:00:00','Aug 16 2008 00:00:00', 'N'
	exec uccncdex 'Aug 11 2008 00:00:00','Aug 12 2008 00:00:00', 'N'
*/

set nocount on
set implicit_transactions off
set transaction isolation level read uncommitted 

select @selectedflag = isnull(@selectedflag, 'N')

if len(@selectedflag) = 0 begin
	set @selectedflag = 'N'
end

declare @totalrecord as numeric

select cl_code = convert(varchar(10), '') into #codes_to_process where 1 = 0

if @selectedflag = 'Y' begin
	select
		@totalrecord = count(distinct clcode)
	from
		angelcs..udt_uploadpdf 
	where
		clcode in (select distinct cl_code from angelcommodity.ncdx.dbo.client5)
		and upload_date >= (select convert(varchar(11),max(upload_date)) from angelcs..udt_uploadpdf)

	set @fdate = 'Jan  1 1900 00:00:00'
	set @tdate = 'Dec 31 2078 23:59:00'

	insert into
		#codes_to_process
	select distinct
		cl_code = ltrim(rtrim(isnull(clcode, '')))
	from
		angelcs..udt_uploadpdf
	where
		upload_date >= (select left(convert(varchar, isnull(max(upload_date), ''), 109), 11) + ' 00:00:00' from angelcs..udt_uploadpdf)
end else begin		/*if @selectedflag = 'Y'*/
	select
		@totalrecord = count(*)
	from
		angelcommodity.ncdx.dbo.client5 c5    
	where 
		c5.activefrom >= @fdate
		and c5.activefrom <= @tdate		

	insert into
		#codes_to_process
	select distinct
		cl_code = ltrim(rtrim(isnull(cl_code, '')))
	from
		angelcommodity.ncdx.dbo.client5
	where
		activefrom >= @fdate 
		and activefrom <= @tdate		
end		/*if @selectedflag = 'Y'*/

--select * from #codes_to_process

	select 
		totalrecord = @totalrecord,
		c5.cl_code,
/*
		c5.drivelicendtl,
		c5.rationcarddtl,
		c5.passportdtl,
		c5.votersiddtl,
*/
		remark = c5.p_address1,
		c5.introducer,
		c1.pan_gir_no,
		c1.short_name,
		c1.branch_cd,
		c1.sub_broker,
/*
		c4.bankid,
		c4.cltdpid,
		c4.depository,
*/
		c1.long_name,
		c1.l_address1,
		c1.l_address2,
		c1.l_city,
		c1.l_state,
		c1.l_zip, 

		phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
		case when 
			isnumeric(
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			) = 1 
			then
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			else
				''
			end,
			c5.activefrom,

			passport_no = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.passportdtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.passportdtl, ''))) 
					end, 25
				),
			place_of_issue_of_passport = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.passportdtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.passportplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.passportplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_passport = 
				case 
					when ltrim(rtrim(isnull(c5.passportdtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.passportdateofissue, ''), 109), 11))
				end,

			driving_license_no = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.drivelicendtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.drivelicendtl, ''))) 
					end, 25
				),
			place_of_issue_of_driving_license = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.drivelicendtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.licencenoplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.licencenoplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_driving_license = 
				case 
					when ltrim(rtrim(isnull(c5.drivelicendtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.licencenodateofissue, ''), 109), 11))
				end,

			voter_id = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.votersiddtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.votersiddtl, ''))) 
					end, 25
				),
			place_of_issue_of_voter_id = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.votersiddtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.voteridplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.voteridplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_voter_id = 
				case 
					when ltrim(rtrim(isnull(c5.votersiddtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.voteriddateofissue, ''), 109), 11))
				end,

			ration_card_number = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.rationcarddtl, ''))) = '' then cast ('' as varchar(1))
						else ltrim(rtrim(isnull(c5.rationcarddtl, ''))) 
					end, 25
				),
			place_of_issue_of_ration_card = 
				left(
					case 
						when ltrim(rtrim(isnull(c5.rationcarddtl, ''))) = '' then cast ('' as varchar(1))
						else case when len(ltrim(rtrim(isnull(c5.rationcardplaceofissue, '')))) = 0 then 'NA' else ltrim(rtrim(isnull(c5.rationcardplaceofissue, ''))) end
					end, 25
				),
			date_of_issue_of_ration_card = 
				case 
					when ltrim(rtrim(isnull(c5.rationcarddtl, ''))) = '' then cast ('' as varchar(1))
					else dbo.formatedate_ddmmmyyyy (left(convert(varchar, isnull(c5.rationcarddateofissue, ''), 109), 11))
				end
	into
		#ucc_ncdex_client
	from
		angelcommodity.ncdx.dbo.client5 c5
	left outer join
		angelcommodity.ncdx.dbo.client1 c1
	on
		c5.cl_code = c1.cl_code
/*
	left outer join
		angelcommodity.ncdx.dbo.client4 c4
	on
		c5.cl_code=c4.cl_code
*/
	where
		ltrim(rtrim(isnull(c5.cl_code, ''))) in (select cl_code from #codes_to_process)
	/*PICK UP ONLY CLIENTS ACTIVATED BETWEEN @from_date AND @to_date*/
	and c5.inactivefrom >= @fdate + ' 00:00:00'
	and c5.activefrom >= @fdate + ' 00:00:00'
	and c5.activefrom <= @tdate + ' 00:00:00'

--		c5.activefrom >= @fdate
--		and c5.activefrom <= @tdate
	order by
		c1.branch_cd,c1.sub_broker,c5.cl_code

select distinct
	party_code = ltrim(rtrim(c4.party_code)),
	bank_id = ltrim(rtrim(c4.bankid)),
	bank_name = ltrim(rtrim(isnull(b.bank_name, ''))),
--	bank_address = ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))) + space(1) + ltrim(rtrim(isnull(b.state, ''))) + space(1) + ltrim(rtrim(isnull(b.nation, ''))),
	bank_address = ltrim(rtrim(isnull(b.branch_name, ''))),
	account_type = ltrim(rtrim(c4.depository)),
	account_no = ltrim(rtrim(c4.cltdpid))
into
	#pobank
from
	#ucc_ncdex_client t,
	angelcommodity.ncdx.dbo.client4 c4,
	angelcommodity.ncdx.dbo.pobank b
where
	ltrim(rtrim(t.cl_code)) = ltrim(rtrim(c4.party_code)) and
	ltrim(rtrim(c4.bankid)) = ltrim(rtrim(b.bankid)) and
	ltrim(rtrim(isnull(c4.depository, ''))) in ('SAVING', 'CURRENT', 'OTHER')

select distinct
	party_code = ltrim(rtrim(c4.party_code)),
	bank_id = ltrim(rtrim(c4.bankid)),
	bank_name = ltrim(rtrim(isnull(b.bankname, ''))),
	bank_address = ltrim(rtrim(isnull(b.address1, ''))) + space(1) + ltrim(rtrim(isnull(b.address2, ''))) + space(1) + ltrim(rtrim(isnull(b.city, ''))),
	account_type = ltrim(rtrim(c4.depository)),
	account_no = ltrim(rtrim(c4.cltdpid))
into
	#bank
from
	#ucc_ncdex_client t,
	angelcommodity.ncdx.dbo.client4 c4,
	angelcommodity.ncdx.dbo.bank b
where
	ltrim(rtrim(t.cl_code)) = ltrim(rtrim(c4.party_code)) and
	ltrim(rtrim(c4.bankid)) = ltrim(rtrim(b.bankid)) and
	ltrim(rtrim(isnull(c4.depository, ''))) in ('CDSL', 'NSDL') and
	ltrim(rtrim(isnull(c4.defdp, ''))) = '1'

select distinct
	party_code = ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end)),
	bank_name = ltrim(rtrim(isnull(po.bank_name, ''))),
	bank_address = ltrim(rtrim(isnull(po.bank_address, ''))),
	bank_account_type = ltrim(rtrim(isnull(po.account_type, ''))),
	bank_account_no = ltrim(rtrim(isnull(po.account_no, ''))),

	dp_id = ltrim(rtrim(isnull(b.bank_id, ''))),
	dp_name = ltrim(rtrim(isnull(b.bank_name, ''))),
	dp_type = ltrim(rtrim(isnull(b.account_type, ''))),
	demat_id_of_client = ltrim(rtrim(isnull(b.account_no, '')))
into
	#ucc_ncdex_client_bank
from
	#pobank po full outer join #bank b on ltrim(rtrim(po.party_code)) = ltrim(rtrim(b.party_code))
order by
	ltrim(rtrim(case when po.party_code is null then b.party_code else po.party_code end))

--select
--	party_code = ltrim(rtrim(t.cl_code)),
--	c5.*
--into
--	#ucc_ncdex_client5
--from
--	#ucc_ncdex_client t,
--	angelcommodity.ncdx.dbo.client5 c5
--where
--	ltrim(rtrim(c5.cl_code)) = ltrim(rtrim(t.cl_code))

select
	cl.*,

	bank_name = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_name, ''))) else '' end, 50
		),''),
	bank_address = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_address, ''))) else '' end, 120
		),''),
	bank_account_type = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_account_type, ''))) else '' end, 15
		),''),
	bank_account_no = 
		isnull(
			left(
				case 
					when (isnull(c1_b.bank_account_type, '')) in ('SAVING', 'CURRENT', 'OTHER') 
					then ltrim(rtrim(isnull(c1_b.bank_account_no, ''))) else '' end, 25
		),''),
	cdsl_depository_name = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('CDSL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_id, ''))) else '' end, 25
		),''),
	cdsl_depository_participant = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('CDSL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_name, ''))) else '' end, 80
		),''),
	cdsl_client_dp_id = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('CDSL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.demat_id_of_client, ''))) else '' end, 25
		),''),

	nsdl_depository_name = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('NSDL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_id, ''))) else '' end, 25
		),''),
	nsdl_depository_participant = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('NSDL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.dp_name, ''))) else '' end, 80
		),''),
	nsdl_client_dp_id = 
		isnull(
			left(
				case 
					when ((isnull(c1_b.dp_type, '') in ('NSDL')) and (len(convert(varchar(80), dp_name))) > 0 and (len(convert(varchar(25), c1_b.demat_id_of_client))) > 0)
					then ltrim(rtrim(isnull(c1_b.demat_id_of_client, ''))) else '' end, 25
		),'')
from
	#ucc_ncdex_client cl left outer join #ucc_ncdex_client_bank c1_b on cl.cl_code = c1_b.party_code
order by
	cl.branch_cd,
	cl.sub_broker,
	cl.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccncdex_orig
-- --------------------------------------------------

CREATE   procedure uccncdex(@fdate as datetime,@tdate as datetime)
as  

/*
	exec uccncdex @fdate = 'Aug 24 2007 00:00:00', @tdate = 'Aug 24 2007 23:59:59'
-- 	exec uccncdex '25/08/2007 00:00:00','25/08/2007 23:59:00' 
*/


declare @totalrecord as numeric

	select 
		@totalrecord=count(*) 
	from
		angelcommodity.ncdx.dbo.client5 c5    
	where 
		c5.activefrom<= @tdate
		and c5.activefrom>= @fdate


	select 
		totalrecord=@totalrecord, c5.cl_code, c5.drivelicendtl,
		c5.rationcarddtl, c5.passportdtl, c5.votersiddtl,
		remark=c5.p_address1, c5.introducer, c1.pan_gir_no,
		c1.short_name, c1.branch_cd, c1.sub_broker,
/*
		c4.bankid,
		c4.cltdpid,
		c4.depository,
*/
		c1.long_name, c1.l_address1,
		c1.l_address2, c1.l_city, c1.l_state, c1.l_zip, 

		phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
		case when 
			isnumeric(
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			) = 1 
			then
				replace(
					replace(
						replace(
							replace(
								replace(
									case 
										when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
										when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
										when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
										when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
									else
										''
									end,
									space(1),
									''
								),
								'-',
								''
							),
							'/',
							''
						),
						'(',
						''
					),
					'(',
					''
				)
			else
				''
			end,
			c5.activefrom
	
	from 
		angelcommodity.ncdx.dbo.client5 c5
	left outer join  
		angelcommodity.ncdx.dbo.client1 c1 
	on 
		c5.cl_code=c1.cl_code    
/*
	left outer join 
		angelcommodity.ncdx.dbo.client4 c4 
	on 
		c5.cl_code=c4.cl_code
*/
	where 
		c5.activefrom<=@tdate 
		and c5.activefrom>= @fdate 
	order by 
		c1.branch_cd,c1.sub_broker,c5.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_count
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[uccnse_count]  AS

set nocount on

select distinct ucc.clcode,ucc.segment,mapin_id=' ',c1.pan_gir_no,wardnumber=' ',passport_no=' ',
placeofissuepassport=' ',dateofissuepassport=' ',drivinglicenseno=' ',placeofissuedrivinglicensno=' ',dateofissuedrivinglicensno=' ',voteridno=' ',placeissuevoteridno=' ',dateofissuevoteridno=' ',Rationcardno=' ',
placeofissuerationcardno=' ',Dateofissuerationcardno=' ',regnno=' ',regnauthority=' ',
placeofregn=' ',dateofregn=' ',long_name,category='01',clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3),pin= l_zip,

phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
case when 
	isnumeric(
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	) = 1 
	then
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	else
		''
	end,


dob=' ',clientagrdate=' ',introdname=' ',relaintro=' ',introclientid=' ',bankname=' ',bankbranchaddress=' ',bankaccounttype=' ',
bankacno=' ',depositoryid=isnull(c4.BankID,' '),depository=isnull(depository,' '),benefowneraccno=isnull(cltdpid,' '),anyotheracwithsametm=' ',settmode=' ',clientwithanyothertm=' ',flag='E'
into #temp1
from nsependinglist ucc 
    join AngelNseCM.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode 
    left join (select * from angelfo.nsefo.dbo.client4 where defdp=1) c4 on c4.party_code = ucc.clcode 
    left join AngelNseCM.msajag.dbo.client1 c1 on c2.cl_code = c1.Cl_Code 
where c2.party_code is not null and ucc.segment='C' order by ucc.clcode


select distinct ucc.clcode,ucc.segment,mapin_id=' ',c1.pan_gir_no,wardnumber=' ',passport_no=' ',
placeofissuepassport=' ',dateofissuepassport=' ',drivinglicenseno=' ',placeofissuedrivinglicensno=' ',dateofissuedrivinglicensno=' ',voteridno=' ',placeissuevoteridno=' ',dateofissuevoteridno=' ',Rationcardno=' ',
placeofissuerationcardno=' ',Dateofissuerationcardno=' ',regnno=' ',regnauthority=' ',
placeofregn=' ',dateofregn=' ',long_name,category='01',clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3),pin= l_zip,

phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
	replace(
		replace(
			replace(
				replace(
					replace(
						case 
							when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
							when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
							when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
							when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
						else
							''
						end,
						space(1),
						''
					),
					'-',
					''
				),
				'/',
				''
			),
			'(',
			''
		),
		'(',
		''
	)
,

dob=' ',clientagrdate=' ',introdname=' ',relaintro=' ',introclientid=' ',bankname=' ',bankbranchaddress=' ',bankaccounttype=' ',
bankacno=' ',depositoryid=isnull(c4.BankID,' '),depository=isnull(depository,' '),benefowneraccno=isnull(cltdpid,' '),anyotheracwithsametm=' ',settmode=' ',clientwithanyothertm=' ',flag='E'
into #temp2
from nsependinglist ucc 
    join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode 
    left join (select * from angelfo.nsefo.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode 
    left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.Cl_Code 
where c2.party_code is not null and ucc.segment='F' order by ucc.clcode

declare @nor1 as int, @nor2 as int
select @nor1=count(*) from #temp1
select @nor2=count(*) from #temp2

select norec=@nor1+@nor2

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadcash
-- --------------------------------------------------

CREATE PROCEDURE [dbo].[uccnse_uploadcash]  AS

select distinct ucc.clcode,ucc.segment,mapin_id='',c1.pan_gir_no,wardnumber='',passport_no='',
placeofissuepassport='',dateofissuepassport='',drivinglicenseno='',placeofissuedrivinglicensno='',dateofissuedrivinglicensno='',voteridno='',placeissuevoteridno='',dateofissuevoteridno='',Rationcardno='',
placeofissuerationcardno='',Dateofissuerationcardno='',regnno='',regnauthority='',
placeofregn='',dateofregn='',long_name,category='01',clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),pin= l_zip,

phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
case when 
	isnumeric(
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	) = 1 
	then
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	else
		''
	end,

dob='',clientagrdate='',introdname='',relaintro='',introclientid='',bankname='',bankbranchaddress='',bankaccounttype='',
bankacno='',depositoryid=isnull(c4.BankID,''),depository=isnull(depository,''),benefowneraccno=isnull(cltdpid,''),anyotheracwithsametm='',settmode='',clientwithanyothertm='',flag='E'

from nsependinglist ucc 
    join AngelNseCM.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode 
    left join (select * from AngelNseCM.msajag.dbo.client4 where defdp=1) c4 on c4.party_code = ucc.clcode 
    left join AngelNseCM.msajag.dbo.client1 c1 on c2.cl_code = c1.Cl_Code 
where c2.party_code is not null and ucc.segment='C' order by ucc.clcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadcashnew
-- --------------------------------------------------

CREATE   procedure
	[dbo].[uccnse_uploadcashnew]

as

	--commentd by shyam--set implicit_transactions off
	--commentd by shyam--
	--commentd by shyam--select distinct 
	--commentd by shyam--	ucc.clcode,
	--commentd by shyam--	ucc.segment,
	--commentd by shyam--	mapin_id='',
	--commentd by shyam--	pan_gir_no = left(ltrim(rtrim(isnull(c1.pan_gir_no, ''))), 10),
	--commentd by shyam--	wardnumber='',
	--commentd by shyam--
	--commentd by shyam--/*
	--commentd by shyam--	passport_no=c5.passportdtl,
	--commentd by shyam--	placeofissuepassport=c5.passportplaceofissue,
	--commentd by shyam--	dateofissuepassport=c5.passportdateofissue,
	--commentd by shyam--	drivinglicenseno=c5.drivelicendtl,
	--commentd by shyam--	placeofissuedrivinglicensno=c5.licencenoplaceofissue,
	--commentd by shyam--	dateofissuedrivinglicensno=c5.licencenodateofissue,
	--commentd by shyam--	voteridno=c5.votersiddtl,
	--commentd by shyam--	placeissuevoteridno=c5.voteridplaceofissue,
	--commentd by shyam--	dateofissuevoteridno=c5.voteriddateofissue,
	--commentd by shyam--	rationcardno=c5.rationcarddtl,
	--commentd by shyam--	placeofissuerationcardno=c5.rationcardplaceofissue,
	--commentd by shyam--	dateofissuerationcardno=c5.rationcarddateofissue,
	--commentd by shyam--*/
	--commentd by shyam--
	--commentd by shyam--	passport_no='',
	--commentd by shyam--	placeofissuepassport='',
	--commentd by shyam--	dateofissuepassport='',
	--commentd by shyam--	drivinglicenseno='',
	--commentd by shyam--	placeofissuedrivinglicensno='',
	--commentd by shyam--	dateofissuedrivinglicensno='',
	--commentd by shyam--	voteridno='',
	--commentd by shyam--	placeissuevoteridno='',
	--commentd by shyam--	dateofissuevoteridno='',
	--commentd by shyam--	rationcardno='',
	--commentd by shyam--	placeofissuerationcardno='',
	--commentd by shyam--	dateofissuerationcardno='',
	--commentd by shyam--
	--commentd by shyam--	regnno='',
	--commentd by shyam--	regnauthority='',
	--commentd by shyam--	placeofregn='',
	--commentd by shyam--	dateofregn='',
	--commentd by shyam--	c1.long_name,  
	--commentd by shyam--
	--commentd by shyam--	/*category='01',*/  
	--commentd by shyam--
	--commentd by shyam--	category = 
	--commentd by shyam--		isnull(  
	--commentd by shyam--		(  
	--commentd by shyam--			select top 1
	--commentd by shyam--				exchangecategory
	--commentd by shyam--			from
	--commentd by shyam--			-- [mimansa].general.dbo.angelclientstatus c   
	--commentd by shyam--				mimansa.general.dbo.angelclientstatus c
	--commentd by shyam--			where
	--commentd by shyam--				ucc.clcode = c.party_code and   
	--commentd by shyam--				exchangesegment = 'NSECM'  
	--commentd by shyam--		), '1'),
	--commentd by shyam--
	--commentd by shyam--	clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),
	--commentd by shyam--	
	--commentd by shyam--	/*pin=c1.l_zip,*/
	--commentd by shyam--	
	--commentd by shyam--	pin=case when len(ltrim(rtrim(c1.l_zip))) = 6 then ltrim(rtrim(c1.l_zip)) else '' end,
	--commentd by shyam--
	--commentd by shyam--	phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
	--commentd by shyam--	case when 
	--commentd by shyam--		isnumeric(
	--commentd by shyam--			replace(
	--commentd by shyam--				replace(
	--commentd by shyam--					replace(
	--commentd by shyam--						replace(
	--commentd by shyam--							replace(
	--commentd by shyam--								case 
	--commentd by shyam--									when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
	--commentd by shyam--									when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
	--commentd by shyam--									when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
	--commentd by shyam--									when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
	--commentd by shyam--								else
	--commentd by shyam--									''
	--commentd by shyam--								end,
	--commentd by shyam--								space(1),
	--commentd by shyam--								''
	--commentd by shyam--							),
	--commentd by shyam--							'-',
	--commentd by shyam--							''
	--commentd by shyam--						),
	--commentd by shyam--						'/',
	--commentd by shyam--						''
	--commentd by shyam--					),
	--commentd by shyam--					'(',
	--commentd by shyam--					''
	--commentd by shyam--				),
	--commentd by shyam--				'(',
	--commentd by shyam--				''
	--commentd by shyam--			)
	--commentd by shyam--		) = 1 
	--commentd by shyam--		then
	--commentd by shyam--			replace(
	--commentd by shyam--				replace(
	--commentd by shyam--					replace(
	--commentd by shyam--						replace(
	--commentd by shyam--							replace(
	--commentd by shyam--								case 
	--commentd by shyam--									when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
	--commentd by shyam--									when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
	--commentd by shyam--									when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
	--commentd by shyam--									when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
	--commentd by shyam--								else
	--commentd by shyam--									''
	--commentd by shyam--								end,
	--commentd by shyam--								space(1),
	--commentd by shyam--								''
	--commentd by shyam--							),
	--commentd by shyam--							'-',
	--commentd by shyam--							''
	--commentd by shyam--						),
	--commentd by shyam--						'/',
	--commentd by shyam--						''
	--commentd by shyam--					),
	--commentd by shyam--					'(',
	--commentd by shyam--					''
	--commentd by shyam--				),
	--commentd by shyam--				'(',
	--commentd by shyam--				''
	--commentd by shyam--			)
	--commentd by shyam--		else
	--commentd by shyam--			''
	--commentd by shyam--		end,
	--commentd by shyam--	
	--commentd by shyam--		dob='',
	--commentd by shyam--		clientagrdate='',
	--commentd by shyam--		introdname='',
	--commentd by shyam--		relaintro='',
	--commentd by shyam--		introclientid='',
	--commentd by shyam--		bankname='',
	--commentd by shyam--		bankbranchaddress='',
	--commentd by shyam--		bankaccounttype='',
	--commentd by shyam--		bankacno='',
	--commentd by shyam--		depositoryid=isnull(c4.bankid,''),
	--commentd by shyam--		depository=isnull(c4.depository,''),
	--commentd by shyam--		benefowneraccno=isnull(c4.cltdpid,''),
	--commentd by shyam--		anyotheracwithsametm='',
	--commentd by shyam--		settmode='',
	--commentd by shyam--		clientwithanyothertm='',
	--commentd by shyam--		flag='E',
	--commentd by shyam--		pan_gir_no_orig = c1.pan_gir_no
	--commentd by shyam--
	--commentd by shyam--	from 
	--commentd by shyam--		nsependinglist ucc
	--commentd by shyam--		join AngelNseCM.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode
	--commentd by shyam--		left join (select * from AngelNseCM.msajag.dbo.client4 where defdp=1) c4 on c4.party_code = ucc.clcode
	--commentd by shyam--		left join AngelNseCM.msajag.dbo.client1 c1 on c2.cl_code = c1.cl_code
	--commentd by shyam--		left join AngelNseCM.msajag.dbo.client5 c5 on c2.cl_code = c5.cl_code
	--commentd by shyam--	where 
	--commentd by shyam--		c2.party_code is not null and 
	--commentd by shyam--		ucc.segment='c' 
	--commentd by shyam--	order by 
	--commentd by shyam--		ucc.clcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadcashnew_party_range
-- --------------------------------------------------
CREATE     proc  
 uccnse_uploadcashnew_party_range (  
  @range char(1)  
 )  
  
as  
  
/*  
 exec uccnse_uploadcashnew_party_range ''  
 exec uccnse_uploadcashnew_party_range 'Y'  
*/  
  
declare  
 @strSelect varchar(8000),  
 @strFrom varchar(2000),  
 @strWhere varchar(2000),  
 @strOrder varchar(1000)  
  
set @strSelect = ''  
set @strFrom = ''  
set @strWhere = ''  
set @strOrder = ''  
  
set @strSelect = @strSelect + 'set implicit_transactions off ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + 'set transaction isolation level read uncommitted ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + 'select distinct ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' ucc.clcode, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' ucc.segment, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' mapin_id='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pan_gir_no = left(ltrim(rtrim(isnull(c1.pan_gir_no, ''''))), 10), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' wardnumber='''', ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' passport_no='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuepassport='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuepassport='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' drivinglicenseno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuedrivinglicensno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuedrivinglicensno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' voteridno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeissuevoteridno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuevoteridno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' rationcardno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuerationcardno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuerationcardno='''', ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' regnno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' regnauthority='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofregn='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofregn='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' c1.long_name, ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' category= ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  isnull( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  ( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   select top 1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    exchangecategory ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   from ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    middleware.mimansa.dbo.angelclientstatus c ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   where ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ucc.clcode = c.party_code and ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    exchangesegment = ''NSECM'' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  ), ''1''), ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' clientaddress=(c1.l_address1+'',''+ c1.l_address2 + '',''+ c1.l_address3+ ''  ''+ c1.L_city), ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' pin=case when len(ltrim(rtrim(c1.l_zip))) = 6 then ltrim(rtrim(c1.l_zip)) else '''' end, ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' phone= ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' case when ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  isnumeric( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        case ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        else ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        end, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        space(1), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''-'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''/'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   ) ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  ) = 1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  then ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        case ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        else ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        end, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        space(1), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''-'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''/'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   ) ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  else ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  end, ' + char(10) /* + char(13)*/  
   
set @strSelect = @strSelect + '  dob='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  clientagrdate='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  introdname='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  relaintro='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  introclientid='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  bankname='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  bankbranchaddress='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  bankaccounttype='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  bankacno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  depositoryid=isnull(c4.bankid,''''), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  depository=isnull(c4.depository,''''), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  benefowneraccno=isnull(c4.cltdpid,''''), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  anyotheracwithsametm='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  settmode='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  clientwithanyothertm='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  flag=''E'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  pan_gir_no_orig = c1.pan_gir_no ' + char(10) /* + char(13)*/  
  
set @strFrom = @strFrom + ' from ' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) = 'Y' begin  
 set @strFrom = @strFrom + '  (select distinct segment = ''c'', clcode = party_code from uccnse_uploadcashnew_party_range_temp) ucc ' + char(10) /* + char(13)*/  
end else begin  
 set @strFrom = @strFrom + '  nsependinglist ucc ' + char(10) /* + char(13)*/  
end  
  
set @strFrom = @strFrom + '  join anand1.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join (select * from anand1.msajag.dbo.client4 where defdp=1) c4 on c4.party_code = ucc.clcode ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join anand1.msajag.dbo.client1 c1 on c2.cl_code = c1.cl_code ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join anand1.msajag.dbo.client5 c5 on c2.cl_code = c5.cl_code ' + char(10) /* + char(13)*/  
  
set @strWhere = @strWhere + ' where ' + char(10) /* + char(13)*/  
set @strWhere = @strWhere + '  c2.party_code is not null and ' + char(10) /* + char(13)*/  
set @strWhere = @strWhere + '  ucc.segment=''c'' ' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) = 'Y' begin  
 set @strWhere = @strWhere + '  and ucc.clcode in (select distinct party_code from uccnse_uploadcashnew_party_range_temp) ' + char(10) /* + char(13)*/  
end  
  
set @strOrder = @strOrder + ' order by ' + char(10) /* + char(13)*/  
set @strOrder = @strOrder + '  ucc.clcode ' + char(10) /* + char(13)*/  
  
--print (@strSelect + @strFrom + @strWhere + @strOrder)  
--return  
  
exec(@strSelect + @strFrom + @strWhere + @strOrder)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadcmnew_trd
-- --------------------------------------------------
CREATE procedure [dbo].[uccnse_uploadcmnew_trd]   
as  
  
declare @maxDate varchar(11)  
  
select @maxDate = left(convert(varchar, max(sauda_date), 109), 11) from AngelBSECM.msajag.dbo.settlement  


set transaction isolation level read uncommitted  
select distinct  
ucc.clcode,  
ucc.segment,  
mapin_id='',  
c1.pan_gir_no,  
wardnumber='',passport_no=c5.passportdtl,            
placeofissuepassport=c5.passportplaceofissue,dateofissuepassport=c5.passportdateofissue,drivinglicenseno=c5.drivelicendtl,placeofissuedrivinglicensno=c5.licenceNoplaceofissue,dateofissuedrivinglicensno=c5.LicenceNoDateOfIssue,voteridno=c5.VotersIDdtl,    
  
placeissuevoteridno=c5.VoterIdPlaceOfIssue,dateofissuevoteridno=c5.VoterIdDateOfIssue,Rationcardno=c5.Rationcarddtl,            
placeofissuerationcardno=c5.RationCardPlaceOfIssue,Dateofissuerationcardno=c5.RationCardDateOfIssue,regnno='',regnauthority='',            
placeofregn='',dateofregn='',c1.long_name,    
/*category='01',*/    
category,    
clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),pin=isnull(c1.l_zip, ''),            
  
phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/  
case when   
 isnumeric(  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 ) = 1   
 then  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 else  
  ''  
 end,  
  
dob='',clientagrdate='',introdname='',relaintro='',introclientid='',bankname='',bankbranchaddress='',bankaccounttype='',            
bankacno='',depositoryid=isnull(c4.BankID,''),depository=isnull(c4.depository,''),benefowneraccno=isnull(c4.cltdpid,''),anyotheracwithsametm='',settmode='',clientwithanyothertm='',flag='E'            
/*,c1.branch_cd, c1.sub_broker, c1.pan_gir_no , long_name, c1.l_address1,              
 c1.l_address2, c1.l_address3, l_city, l_state, l_zip, phone = coalesce(res_phone1,res_phone2,              
off_phone1,off_phone2), fax, email, depository, c4.bankid, cltdpid */              
from           
(select /*clcode*/ clcode = party_code,segment='C' ,    
category =     
isnull(    
(    
 select top 1  
  exchangecategory  
 from  
--  [196.1.115.23].general.dbo.angelclientstatus a    
middleware.mimansa.dbo.angelclientstatus a  
 where  
  /*f.clcode*/ f.party_code = a.party_code and  
  exchangesegment = 'NSECM'  
), '1')  
from  
 AngelBSECM.msajag.dbo.settlement  
 /*trade*/ f /*with (nolock)*/ where sauda_date like @maxDate + '%' and /*clcode*/ party_code not in (select distinct clcode from nse_fo_success f with (nolock) where segment='C' and result='S') /*and clcode not in (select distinct clcode from  ucc_succ w
here segment='f')*/    
) ucc  
--(select clcode,segment='F' from fotrade where clcode not in (select distinct clcode from nse_fo_success where segment='F' and result='S'))  ucc            
--select clcode,segment='F' from fotrade where clcode not in (select distinct clcode from nse_fo_success where segment='F' and result='S') and clcode not in (select clcode from  ucc_succ)           
join AngelBSECM.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode  
    left join (select * from AngelBSECM.msajag.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode  
    left join AngelBSECM.msajag.dbo.client1 c1 on c2.cl_code = c1.Cl_Code  
    left join AngelBSECM.msajag.dbo.client5 c5 on c2.cl_code = c5.cl_code  
where c2.party_code is not null and ucc.segment='F'  
order by  
 ucc.clcode  
  
--select top 10 * from nse_fo_success f with (nolock) where segment='F' and result='S' and filename = 'uci_20060706.t02'  
--select top 10 * from nse_fo_success f with (nolock) where clcode = 'M749'  
--select top 10 * from nse_fo_success f with (nolock) where clcode = 'M3723'  
--insert into nse_fo_success (segment,clcode,mapinid,pangirno,wardno,ppno,pp_place,pp_dt,drv_no,drv_place,drv_dt,vote_no,vote_place,vote_dt,ration_no,ration_place,ration_date,regno,reg_autho,reg_place,reg_date,long_name,category,address,pincode,phone,dob,
--agre_date,intro_name,intro_relation,intro_clcode,bankname,bankaddress,bank_acc_type,bank_acc_no,dp_id,dpno,clid,otheracc,settmode,otheraccd,flag,result,filename)  
--values('F','M749','','AGPPS8751D','','','','','','','','','','','','','','','','','','MANSUKHLAL POPATLAL SHAH',' 1','401, OSWAL APARTMENT,,P.K EXT.ROAD, MULUND (W),,MUMBAI  ','400080','','','','','','','','','','','','','','','','','E','S','ERR')  
--select * from nse_fo_success f with (nolock) where clcode = 'A5810'  
--select * from nse_fo_success f with (nolock) where clcode = 'M749'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadfo
-- --------------------------------------------------

CREATE PROCEDURE uccnse_uploadfo  AS  
  
select distinct ucc.clcode,ucc.segment,mapin_id='',c1.pan_gir_no,wardnumber='',passport_no='',  
placeofissuepassport='',dateofissuepassport='',drivinglicenseno='',placeofissuedrivinglicensno='',dateofissuedrivinglicensno='',voteridno='',placeissuevoteridno='',dateofissuevoteridno='',Rationcardno='',  
placeofissuerationcardno='',Dateofissuerationcardno='',regnno='',regnauthority='',  
placeofregn='',dateofregn='',long_name,category='01',clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ ' '+ c1.L_city),pin= l_zip,  

phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
case when 
	isnumeric(
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	) = 1 
	then
		replace(
			replace(
				replace(
					replace(
						replace(
							case 
								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
							else
								''
							end,
							space(1),
							''
						),
						'-',
						''
					),
					'/',
					''
				),
				'(',
				''
			),
			'(',
			''
		)
	else
		''
	end,

dob='',clientagrdate='',introdname='',relaintro='',introclientid='',bankname='',bankbranchaddress='',bankaccounttype='',  
bankacno='',depositoryid=isnull(c4.BankID,''),depository=isnull(depository,''),benefowneraccno=isnull(cltdpid,''),anyotheracwithsametm='',settmode='',clientwithanyothertm='',flag='E'  
  
  
/*,c1.branch_cd, c1.sub_broker, c1.pan_gir_no , long_name, c1.l_address1,  
 c1.l_address2, c1.l_address3, l_city, l_state, l_zip, phone = coalesce(res_phone1,res_phone2,  
off_phone1,off_phone2), fax, email, depository, c4.bankid, cltdpid */  
from nsependinglist ucc   
    join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode   
    left join (select * from angelfo.nsefo.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode   
    left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.Cl_Code   
where c2.party_code is not null and ucc.segment='F' order by ucc.clcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadfonew
-- --------------------------------------------------
CREATE procedure uccnse_uploadfonew as

--commentd by shyam--  
--commentd by shyam--set implicit_transactions off  
--commentd by shyam--  
--commentd by shyam--select distinct 
--commentd by shyam--	ucc.clcode,
--commentd by shyam--	ucc.segment,
--commentd by shyam--	mapin_id='',
--commentd by shyam--	pan_gir_no = left(ltrim(rtrim(isnull(c1.pan_gir_no, ''))), 10),
--commentd by shyam----	c1.pan_gir_no,
--commentd by shyam--	wardnumber='',
--commentd by shyam--
--commentd by shyam--/*	
--commentd by shyam--	passport_no=c5.passportdtl,
--commentd by shyam--	placeofissuepassport=c5.passportplaceofissue,
--commentd by shyam--	dateofissuepassport=c5.passportdateofissue,
--commentd by shyam--	drivinglicenseno=c5.drivelicendtl,
--commentd by shyam--	placeofissuedrivinglicensno=c5.licencenoplaceofissue,
--commentd by shyam--	dateofissuedrivinglicensno=c5.licencenodateofissue,
--commentd by shyam--	voteridno=c5.votersiddtl,
--commentd by shyam--	placeissuevoteridno=c5.voteridplaceofissue,
--commentd by shyam--	dateofissuevoteridno=c5.voteriddateofissue,
--commentd by shyam--	rationcardno=c5.rationcarddtl,
--commentd by shyam--	placeofissuerationcardno=c5.rationcardplaceofissue,
--commentd by shyam--	dateofissuerationcardno=c5.rationcarddateofissue,
--commentd by shyam--*/
--commentd by shyam--
--commentd by shyam--	passport_no='',
--commentd by shyam--	placeofissuepassport='',
--commentd by shyam--	dateofissuepassport='',
--commentd by shyam--	drivinglicenseno='',
--commentd by shyam--	placeofissuedrivinglicensno='',
--commentd by shyam--	dateofissuedrivinglicensno='',
--commentd by shyam--	voteridno='',
--commentd by shyam--	placeissuevoteridno='',
--commentd by shyam--	dateofissuevoteridno='',
--commentd by shyam--	rationcardno='',
--commentd by shyam--	placeofissuerationcardno='',
--commentd by shyam--	dateofissuerationcardno='',
--commentd by shyam--
--commentd by shyam--	regnno='',
--commentd by shyam--	regnauthority='',
--commentd by shyam--	placeofregn='',
--commentd by shyam--	dateofregn='',
--commentd by shyam--	c1.long_name,
--commentd by shyam--	/*category='01',*/  
--commentd by shyam--
--commentd by shyam--category =   
--commentd by shyam--isnull(  
--commentd by shyam--(  
--commentd by shyam-- select top 1  
--commentd by shyam--  exchangecategory   
--commentd by shyam-- from   
--commentd by shyam----  [196.1.115.23].general.dbo.angelclientstatus c   
--commentd by shyam--   MIMANSA.general.dbo.angelclientstatus c   
--commentd by shyam-- where   
--commentd by shyam--  ucc.clcode = c.party_code and   
--commentd by shyam--  exchangesegment = 'NSEFO'  
--commentd by shyam--), '1'),  
--commentd by shyam--clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),
--commentd by shyam--
--commentd by shyam--/*
--commentd by shyam--pin=c1.l_zip,
--commentd by shyam--*/
--commentd by shyam--
--commentd by shyam--pin= case when len(ltrim(rtrim(c1.l_zip))) = 6 then ltrim(rtrim(c1.l_zip)) else '' end,
--commentd by shyam--
--commentd by shyam--phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/
--commentd by shyam--case when 
--commentd by shyam--	isnumeric(
--commentd by shyam--		replace(
--commentd by shyam--			replace(
--commentd by shyam--				replace(
--commentd by shyam--					replace(
--commentd by shyam--						replace(
--commentd by shyam--							case 
--commentd by shyam--								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
--commentd by shyam--								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
--commentd by shyam--								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
--commentd by shyam--								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
--commentd by shyam--							else
--commentd by shyam--								''
--commentd by shyam--							end,
--commentd by shyam--							space(1),
--commentd by shyam--							''
--commentd by shyam--						),
--commentd by shyam--						'-',
--commentd by shyam--						''
--commentd by shyam--					),
--commentd by shyam--					'/',
--commentd by shyam--					''
--commentd by shyam--				),
--commentd by shyam--				'(',
--commentd by shyam--				''
--commentd by shyam--			),
--commentd by shyam--			'(',
--commentd by shyam--			''
--commentd by shyam--		)
--commentd by shyam--	) = 1 
--commentd by shyam--	then
--commentd by shyam--		replace(
--commentd by shyam--			replace(
--commentd by shyam--				replace(
--commentd by shyam--					replace(
--commentd by shyam--						replace(
--commentd by shyam--							case 
--commentd by shyam--								when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1
--commentd by shyam--								when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2
--commentd by shyam--								when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1
--commentd by shyam--								when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2
--commentd by shyam--							else
--commentd by shyam--								''
--commentd by shyam--							end,
--commentd by shyam--							space(1),
--commentd by shyam--							''
--commentd by shyam--						),
--commentd by shyam--						'-',
--commentd by shyam--						''
--commentd by shyam--					),
--commentd by shyam--					'/',
--commentd by shyam--					''
--commentd by shyam--				),
--commentd by shyam--				'(',
--commentd by shyam--				''
--commentd by shyam--			),
--commentd by shyam--			'(',
--commentd by shyam--			''
--commentd by shyam--		)
--commentd by shyam--	else
--commentd by shyam--		''
--commentd by shyam--	end,
--commentd by shyam--
--commentd by shyam--dob='',clientagrdate='',introdname='',relaintro='',introclientid='',bankname='',bankbranchaddress='',bankaccounttype='',  
--commentd by shyam--bankacno='',depositoryid=isnull(c4.BankID,''),depository=isnull(c4.depository,''),benefowneraccno=isnull(c4.cltdpid,''),anyotheracwithsametm='',settmode='',clientwithanyothertm='',flag='E',
--commentd by shyam--pan_gir_no_orig = c1.pan_gir_no
--commentd by shyam--
--commentd by shyam--/*,c1.branch_cd, c1.sub_broker, c1.pan_gir_no , long_name, c1.l_address1,
--commentd by shyam-- c1.l_address2, c1.l_address3, l_city, l_state, l_zip, phone = coalesce(res_phone1,res_phone2,
--commentd by shyam--off_phone1,off_phone2), fax, email, depository, c4.bankid, cltdpid */
--commentd by shyam--from nsependinglist ucc
--commentd by shyam--    join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode     
--commentd by shyam--    left join (select * from angelfo.nsefo.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode     
--commentd by shyam--    left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.Cl_Code     
--commentd by shyam--    left join angelfo.nsefo.dbo.client5 c5 on c2.cl_code = c5.cl_code   
--commentd by shyam--where c2.party_code is not null and ucc.segment='F' order by ucc.clcode
--commentd by shyam--

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadfonew_party_range
-- --------------------------------------------------
 CREATE procedure   
 uccnse_uploadfonew_party_range (  
  @range char(1)  
 )  
  
as  
  
  
declare  
 @strSelect varchar(8000),  
 @strFrom varchar(2000),  
 @strWhere varchar(2000),  
 @strOrder varchar(1000)  
  
set @strSelect = ''  
set @strFrom = ''  
set @strWhere = ''  
set @strOrder = ''  
  
set @strSelect = @strSelect + 'set implicit_transactions off ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + 'select distinct  ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' ucc.clcode, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' ucc.segment, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' mapin_id='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pan_gir_no = left(ltrim(rtrim(isnull(c1.pan_gir_no, ''''))), 10), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' wardnumber='''', ' + char(10) /* + char(13)*/  
   
set @strSelect = @strSelect + ' passport_no='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuepassport='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuepassport='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' drivinglicenseno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuedrivinglicensno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuedrivinglicensno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' voteridno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeissuevoteridno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuevoteridno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' rationcardno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuerationcardno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuerationcardno='''', ' + char(10) /* + char(13)*/  
   
set @strSelect = @strSelect + ' regnno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' regnauthority='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofregn='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofregn='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' c1.long_name, ' + char(10) /* + char(13)*/  
   
set @strSelect = @strSelect + ' category=isnull((select top 1 exchangecategory from middleware.mimansa.dbo.angelclientstatus c where ucc.clcode = c.party_code and exchangesegment = ''NSEFO''), ''1''), ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' clientaddress=(c1.l_address1+'',''+ c1.l_address2 + '',''+ c1.l_address3+ ''  ''+ c1.l_city), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pin=case when len(ltrim(rtrim(c1.l_zip))) = 6 then ltrim(rtrim(c1.l_zip)) else '''' end, ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' phone=' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  case when ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   isnumeric( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         case  ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         else ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         end, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         space(1), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ''-'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''/'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ) ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   ) = 1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   then ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        replace( ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         case ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2 ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         else ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         end, ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         space(1), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ''-'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''/'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''('', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ) ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   else ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    '''' ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   end, ' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' dob='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' clientagrdate='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' introdname='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' relaintro='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' introclientid='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankname='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankbranchaddress='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankaccounttype='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankacno='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' depositoryid=isnull(c4.bankid,''''), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' depository=isnull(c4.depository,''''), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' benefowneraccno=isnull(c4.cltdpid,''''), ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' anyotheracwithsametm='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' settmode='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' clientwithanyothertm='''', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' flag=''E'', ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pan_gir_no_orig=c1.pan_gir_no ' + char(10) /* + char(13)*/  
  
set @strFrom = @strFrom + 'from ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  nsependinglist ucc ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join (select * from angelfo.nsefo.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.cl_code ' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join angelfo.nsefo.dbo.client5 c5 on c2.cl_code = c5.cl_code ' + char(10) /* + char(13)*/  
  
set @strWhere = @strWhere + 'where ' + char(10) /* + char(13)*/  
set @strWhere = @strWhere + ' c2.party_code is not null and ' + char(10) /* + char(13)*/  
set @strWhere = @strWhere + ' ucc.segment=''F'' ' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) = 'Y' begin  
 set @strWhere = @strWhere + '  and ucc.clcode in (select distinct party_code from uccnse_uploadcashnew_party_range_temp) ' + char(10) /* + char(13)*/  
end  
  
set @strOrder = @strOrder + 'order by ' + char(10) /* + char(13)*/  
set @strOrder = @strOrder + ' ucc.clcode ' + char(10) /* + char(13)*/  
  
exec(@strSelect + @strFrom + @strWhere + @strOrder)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadfonew_trd
-- --------------------------------------------------
 CREATE procedure uccnse_uploadfonew_trd   
as  
  
set transaction isolation level read uncommitted  
select distinct  
ucc.clcode,ucc.segment,mapin_id='',  
pan_gir_no = left(ltrim(rtrim(isnull(c1.pan_gir_no, ''))), 10),  
wardnumber='',  
  
/*  
passport_no = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportdtl else '' end,  
placeofissuepassport = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportplaceofissue else '' end,  
dateofissuepassport = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportdateofissue else '' end,  
drivinglicenseno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.drivelicendtl else '' end,  
placeofissuedrivinglicensno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.licencenoplaceofissue else '' end,  
dateofissuedrivinglicensno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.licencenodateofissue else '' end,  
voteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.votersiddtl else '' end,  
placeissuevoteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.voteridplaceofissue else '' end,  
dateofissuevoteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.voteriddateofissue else '' end,  
rationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcarddtl else '' end,  
placeofissuerationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcardplaceofissue else '' end,  
dateofissuerationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcarddateofissue else '' end,  
*/  
  
passport_no = '',  
placeofissuepassport = '',  
dateofissuepassport = '',  
drivinglicenseno = '',  
placeofissuedrivinglicensno = '',  
dateofissuedrivinglicensno = '',  
voteridno = '',  
placeissuevoteridno = '',  
dateofissuevoteridno = '',  
rationcardno = '',  
placeofissuerationcardno = '',  
dateofissuerationcardno = '',  
  
regnno='',  
regnauthority='',            
placeofregn='',dateofregn='',  
c1.long_name,  
/*category='01',*/    
category,    
clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),  
  
pin=case when len(ltrim(rtrim(isnull(c1.l_zip, '')))) = 6 then c1.l_zip else '' end,  
  
phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/  
case when   
 isnumeric(  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 ) = 1   
 then  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 else  
  ''  
 end,  
  
dob='',clientagrdate='',introdname='',relaintro='',introclientid='',bankname='',bankbranchaddress='',bankaccounttype='',            
bankacno='',depositoryid=isnull(c4.BankID,''),depository=isnull(c4.depository,''),benefowneraccno=isnull(c4.cltdpid,''),anyotheracwithsametm='',settmode='',clientwithanyothertm='',flag='E',  
pan_gir_no_orig = c1.pan_gir_no  
/*,c1.branch_cd, c1.sub_broker, c1.pan_gir_no , long_name, c1.l_address1,              
 c1.l_address2, c1.l_address3, l_city, l_state, l_zip, phone = coalesce(res_phone1,res_phone2,              
off_phone1,off_phone2), fax, email, depository, c4.bankid, cltdpid */              
from           
(select clcode,segment='F' ,    
category =     
isnull(    
(    
 select top 1  
  exchangecategory  
 from  
--  [196.1.115.23].general.dbo.angelclientstatus a    
middleware.mimansa.dbo.angelclientstatus a  
 where  
  f.clcode = a.party_code and  
  exchangesegment = 'NSEFO'  
), '1')  
from  
 fotrade f with (nolock) where clcode not in (select distinct clcode from nse_fo_success f with (nolock) where segment='F' and result='S') /*and clcode not in (select distinct clcode from  ucc_succ where segment='f')*/    
) ucc  
--(select clcode,segment='F' from fotrade where clcode not in (select distinct clcode from nse_fo_success where segment='F' and result='S'))  ucc            
--select clcode,segment='F' from fotrade where clcode not in (select distinct clcode from nse_fo_success where segment='F' and result='S') and clcode not in (select clcode from  ucc_succ)           
join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode  
    left join (select * from angelfo.nsefo.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode  
    left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.Cl_Code  
    left join angelfo.nsefo.dbo.client5 c5 on c2.cl_code = c5.cl_code  
where c2.party_code is not null and ucc.segment='F'  
order by  
 ucc.clcode  
  
--select top 10 * from nse_fo_success f with (nolock) where segment='F' and result='S' and filename = 'uci_20060706.t02'  
--select top 10 * from nse_fo_success f with (nolock) where clcode = 'M749'  
--select top 10 * from nse_fo_success f with (nolock) where clcode = 'M3723'  
--insert into nse_fo_success (segment,clcode,mapinid,pangirno,wardno,ppno,pp_place,pp_dt,drv_no,drv_place,drv_dt,vote_no,vote_place,vote_dt,ration_no,ration_place,ration_date,regno,reg_autho,reg_place,reg_date,long_name,category,address,pincode,phone,dob
--,agre_date,intro_name,intro_relation,intro_clcode,bankname,bankaddress,bank_acc_type,bank_acc_no,dp_id,dpno,clid,otheracc,settmode,otheraccd,flag,result,filename)  
--values('F','M749','','AGPPS8751D','','','','','','','','','','','','','','','','','','MANSUKHLAL POPATLAL SHAH',' 1','401, OSWAL APARTMENT,,P.K EXT.ROAD, MULUND (W),,MUMBAI  ','400080','','','','','','','','','','','','','','','','','E','S','ERR')  
--select * from nse_fo_success f with (nolock) where clcode = 'A5810'  
--select * from nse_fo_success f with (nolock) where clcode = 'M749'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnse_uploadfonew_trd_party_range
-- --------------------------------------------------
      CREATE     proc   
 uccnse_uploadfonew_trd_party_range (  
  @range char(1)  
 )  
  
as  
  
/*  
 exec uccnse_uploadfonew_trd_party_range 'Y'  
*/  
  
declare  
 @strSelect varchar(8000),  
 @strFrom varchar(2000),  
 @strWhere varchar(2000),  
 @strOrder varchar(1000)  
  
set @strSelect = ''  
set @strFrom = ''  
set @strWhere = ''  
set @strOrder = ''  
  
/*  
 drop table c2  
 select * into c2 from angelfo.nsefo.dbo.client2 where ltrim(rtrim(party_code)) in (select distinct party_code from uccnsefo_uploadcashnew_party_range_temp)  
*/  
  
set @strSelect = @strSelect + 'set transaction isolation level read uncommitted' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + 'select distinct ' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' ucc.clcode,' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' ucc.segment,' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' mapin_id='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pan_gir_no=left(ltrim(rtrim(isnull(c1.pan_gir_no, ''''))), 10),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' wardnumber='''',' + char(10) /* + char(13)*/  
   
set @strSelect = @strSelect + ' passport_no = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuepassport = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuepassport = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' drivinglicenseno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuedrivinglicensno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuedrivinglicensno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' voteridno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeissuevoteridno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuevoteridno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' rationcardno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofissuerationcardno = '''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofissuerationcardno = '''',' + char(10) /* + char(13)*/  
   
set @strSelect = @strSelect + ' regnno='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' regnauthority='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' placeofregn='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' dateofregn='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' c1.long_name,' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' category,' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' clientaddress=(c1.l_address1+'',''+ c1.l_address2 + '',''+ c1.l_address3+ ''  ''+ c1.l_city),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pin=case when len(ltrim(rtrim(isnull(c1.l_zip, '''')))) = 6 then c1.l_zip else '''' end,' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' phone=' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '  case when' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   isnumeric(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         case' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         else' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         end,' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         space(1),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ''-'',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''/'',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''('',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''('',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    )' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   ) = 1' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   then' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        replace(' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         case' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         else' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '          ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         end,' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         space(1),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '         ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ''-'',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '        ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''/'',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '       ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''('',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '      ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''('',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '     ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    )' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   else' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '    ''''' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + '   end,' + char(10) /* + char(13)*/  
  
set @strSelect = @strSelect + ' dob='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' clientagrdate='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' introdname='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' relaintro='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' introclientid='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankname='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankbranchaddress='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankaccounttype='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' bankacno='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' depositoryid=isnull(c4.bankid,''''),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' depository=isnull(c4.depository,''''),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' benefowneraccno=isnull(c4.cltdpid,''''),' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' anyotheracwithsametm='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' settmode='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' clientwithanyothertm='''',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' flag=''E'',' + char(10) /* + char(13)*/  
set @strSelect = @strSelect + ' pan_gir_no_orig=c1.pan_gir_no' + char(10) /* + char(13)*/  
  
set @strFrom = @strFrom + ' from (' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  select' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) <> 'Y' begin  
 set @strFrom = @strFrom + '   clcode,' + char(10) /* + char(13)*/  
end else begin  
 set @strFrom = @strFrom + '   clcode=party_code,' + char(10) /* + char(13)*/  
end  
  
set @strFrom = @strFrom + '   segment=''F'',' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '   category=' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) <> 'Y' begin  
 set @strFrom = @strFrom + '   isnull((select top 1 exchangecategory from middleware.mimansa.dbo.angelclientstatus a where f.clcode = a.party_code and exchangesegment = ''NSEFO''), ''1'')' + char(10) /* + char(13)*/  
end else begin  
 set @strFrom = @strFrom + '   isnull((select top 1 exchangecategory from middleware.mimansa.dbo.angelclientstatus a where f.party_code = a.party_code and exchangesegment = ''NSEFO''), ''1'')' + char(10) /* + char(13)*/  
end  
  
set @strFrom = @strFrom + '  from' + char(10) /* + char(13)*/  
--set @strFrom = @strFrom + '   fotrade f with (nolock) where clcode not in (select distinct clcode from nse_fo_success f with (nolock) where segment=''F'' and result=''S'')' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) <> 'Y' begin  
 set @strFrom = @strFrom + '   fotrade f with (nolock) ' + char(10) /* + char(13)*/  
end else begin  
 set @strFrom = @strFrom + '   uccnsefo_uploadcashnew_party_range_temp f with (nolock) ' + char(10) /* + char(13)*/  
end  
if upper(ltrim(rtrim(@range))) <> 'Y' begin  
 set @strFrom = @strFrom + '   where clcode not in (select distinct clcode from nse_fo_success f with (nolock) where segment=''F'' and result=''S'') ' + char(10) /* + char(13)*/  
end  
  
set @strFrom = @strFrom + '  ) ucc join' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  angelfo.nsefo.dbo.client2 /*c2*/ c2 on c2.party_code = ucc.clcode' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join (select * from angelfo.nsefo.dbo.client4 where defdp=1) c4 on c4.party_code = ucc.clcode' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.cl_code' + char(10) /* + char(13)*/  
set @strFrom = @strFrom + '  left join angelfo.nsefo.dbo.client5 c5 on c2.cl_code = c5.cl_code' + char(10) /* + char(13)*/  
  
set @strWhere = @strWhere + 'where' + char(10) /* + char(13)*/  
set @strWhere = @strWhere + ' c2.party_code is not null and ucc.segment=''F''' + char(10) /* + char(13)*/  
  
if upper(ltrim(rtrim(@range))) = 'Y' begin  
 set @strWhere = @strWhere + '  and ucc.clcode in (select distinct party_code from uccnsefo_uploadcashnew_party_range_temp) ' + char(10) /* + char(13)*/  
end  
  
set @strOrder = @strOrder + 'order by' + char(10) /* + char(13)*/  
set @strOrder = @strOrder + ' ucc.clcode' + char(10) /* + char(13)*/  
  
--print (@strSelect + @strFrom + @strWhere + @strOrder)  
  
exec (@strSelect + @strFrom + @strWhere + @strOrder)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnsecm_clientopening
-- --------------------------------------------------
 CREATE procedure [dbo].[uccnsecm_clientopening] (@fdate 
 as varchar(11),@tdate as varchar(11))       
  
as  
  
/*  
 exec  
  uccnsecm_clientopening 'Jan  2 2008', 'Jan  3 2008'  
*/  
  
set implicit_transactions off  
  
select distinct   
 ucc.clcode,  
 ucc.segment,  
 mapin_id='',  
 c1.pan_gir_no,  
 wardnumber='',  
  
/*  
 passport_no = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportdtl else '' end,  
 placeofissuepassport = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportplaceofissue else '' end,  
 dateofissuepassport = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportdateofissue else '' end,  
 drivinglicenseno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.drivelicendtl else '' end,  
 placeofissuedrivinglicensno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.licencenoplaceofissue else '' end,  
 dateofissuedrivinglicensno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.licencenodateofissue else '' end,  
 voteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.votersiddtl else '' end,  
 placeissuevoteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.voteridplaceofissue else '' end,  
 dateofissuevoteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.voteriddateofissue else '' end,  
 rationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcarddtl else '' end,  
 placeofissuerationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcardplaceofissue else '' end,  
 dateofissuerationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcarddateofissue else '' end,  
*/  
  
 passport_no = '',  
 placeofissuepassport = '',  
 dateofissuepassport = '',  
 drivinglicenseno = '',  
 placeofissuedrivinglicensno = '',  
 dateofissuedrivinglicensno = '',  
 voteridno = '',  
 placeissuevoteridno = '',  
 dateofissuevoteridno = '',  
 rationcardno = '',  
 placeofissuerationcardno = '',  
 dateofissuerationcardno = '',  
  
 regnno='',   
 regnauthority='',  
 placeofregn = '',   
 dateofregn = '',   
  
 c1.long_name,   
  
/* category='01',*/  
 category,  
 clientaddress = (c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),  
/*  
 pin = c1.l_zip,  
*/  
  
 pin=case when len(ltrim(rtrim(isnull(c1.l_zip, '')))) = 6 then c1.l_zip else '' end,  
  
 phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2),*/  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 ,  
  
 dob='', clientagrdate='', introdname = '', relaintro = '', introclientid = '', bankname = '',   
 bankbranchaddress = '', bankaccounttype = '', bankacno='', depositoryid = isnull(c4.BankID,''),  
 depository = isnull(c4.depository,''), benefowneraccno = isnull(c4.cltdpid,''),  
 anyotheracwithsametm = '', settmode = '', clientwithanyothertm = '', flag='E'  
--into  
-- #uccnsecm_clientopening  
from  
(  
    select   
  /*clcode = party_code,*/  
  clcode = cl_code,  
  segment = 'C',  
  category =   
  isnull(  
  (  
   select top 1  
    exchangecategory   
   from   
    middleware.mimansa.dbo.angelclientstatus a  
   where   
    /*ac5.party_code = a.party_code and */  
    ac5.cl_code = a.party_code and  
    exchangesegment = 'NSECM'  
  ), '1')  
 from  
    AngelNseCM.msajag.dbo.client5 ac5  
       /*mimansa.angelcs.dbo.angelclient5 ac5*/  
      where   
  
--       nsecmactivefrom >= @fdate + ' 14:00'    
--       and nsecmactivefrom < @tdate + ' 14:00'    
  
      activefrom >= @fdate + ' 00:00:00'  
      and activefrom <= @tdate + ' 23:59:59'  
  
/*        nsecmactivefrom >= @fdate + ' 00:00:00'  
      and nsecmactivefrom <= @tdate + ' 23:59:59'  
*/        
  
      /*and nsecminactivefrom >= getdate()*/)   ucc     
  
    join AngelNseCM.msajag.dbo.client2 c2 on c2.party_code = ucc.clcode  
    left join (select * from AngelNseCM.msajag.dbo.client4 where defdp=1) c4 on c4.party_code = ucc.clcode     
    left join AngelNseCM.msajag.dbo.client1 c1 on c2.cl_code = c1.Cl_Code     
    left join AngelNseCM.msajag.dbo.client5 c5 on c2.cl_code = c5.cl_code     
where  
 c2.party_code is not null and ucc.segment='C' order by ucc.clcode  
  
--select  
-- *  
--into  
-- ____uccnsecm_clientopening  
--from  
-- #uccnsecm_clientopening  
  
--select  
-- *  
--from  
-- #uccnsecm_clientopening

GO

-- --------------------------------------------------
-- PROCEDURE dbo.uccnsefo_clientopening
-- --------------------------------------------------
      CREATE  PROCEDURE uccnsefo_clientopening (@fdate as varchar(11),@tdate as varchar(11))    
  
AS  
  
  
/*  
 exec uccnsefo_clientopening '03/08/2006', '04/08/2006'  
*/  
--  print @fdate    
--  print @tdate         
  
set implicit_transactions off  
  
select distinct   
clcode = ltrim(rtrim(ucc.clcode)),  
ucc.segment,  
mapin_id='',  
c1.pan_gir_no,  
wardnumber='',  
  
/*  
passport_no = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportdtl else '' end,  
placeofissuepassport = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportplaceofissue else '' end,  
dateofissuepassport = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.passportdateofissue else '' end,  
drivinglicenseno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.drivelicendtl else '' end,  
placeofissuedrivinglicensno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.licencenoplaceofissue else '' end,  
dateofissuedrivinglicensno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.licencenodateofissue else '' end,  
voteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.votersiddtl else '' end,  
placeissuevoteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.voteridplaceofissue else '' end,  
dateofissuevoteridno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.voteriddateofissue else '' end,  
rationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcarddtl else '' end,  
placeofissuerationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcardplaceofissue else '' end,  
dateofissuerationcardno = case when len(ltrim(rtrim(c1.pan_gir_no))) = 0 then c5.rationcarddateofissue else '' end,  
*/  
  
passport_no = '',  
placeofissuepassport = '',  
dateofissuepassport = '',  
drivinglicenseno = '',  
placeofissuedrivinglicensno = '',  
dateofissuedrivinglicensno = '',  
voteridno = '',  
placeissuevoteridno = '',  
dateofissuevoteridno = '',  
rationcardno = '',  
placeofissuerationcardno = '',  
dateofissuerationcardno = '',  
  
regnno='',  
regnauthority='',              
placeofregn='',  
dateofregn='',  
  
c1.long_name,  
/*category='01',*/  
  
category,  
clientaddress=(c1.l_address1+','+ c1.l_address2 + ','+ c1.l_address3+ '  '+ c1.L_city),  
  
/*pin=c1.l_zip,*/  
pin=case when len(ltrim(rtrim(isnull(c1.l_zip, '')))) = 6 then c1.l_zip else '' end,  
  
phone = /*coalesce(c1.res_phone1,c1.res_phone2,c1.off_phone1,c1.off_phone2)*/  
case when   
 isnumeric(  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 ) = 1   
 then  
  replace(  
   replace(  
    replace(  
     replace(  
      replace(  
       case   
        when len(ltrim(rtrim(c1.res_phone1))) > 0 then c1.res_phone1  
        when len(ltrim(rtrim(c1.res_phone2))) > 0 then c1.res_phone2  
        when len(ltrim(rtrim(c1.off_phone1))) > 0 then c1.off_phone1  
        when len(ltrim(rtrim(c1.off_phone2))) > 0 then c1.off_phone2  
       else  
        ''  
       end,  
       space(1),  
       ''  
      ),  
      '-',  
      ''  
     ),  
     '/',  
     ''  
    ),  
    '(',  
    ''  
   ),  
   '(',  
   ''  
  )  
 else  
  ''  
 end,  
  
dob='',clientagrdate='',introdname='',relaintro='',introclientid='',bankname='',bankbranchaddress='',bankaccounttype='',              
bankacno='',depositoryid=isnull(c4.BankID,''),depository=isnull(c4.depository,''),benefowneraccno=isnull(c4.cltdpid,''),anyotheracwithsametm='',settmode='',clientwithanyothertm='',flag='E'              
/*,c1.branch_cd, c1.sub_broker, c1.pan_gir_no , long_name, c1.l_address1,                
 c1.l_address2, c1.l_address3, l_city, l_state, l_zip, phone = coalesce(res_phone1,res_phone2,                
off_phone1,off_phone2), fax, email, depository, c4.bankid, cltdpid */                
from             
(    
select   
 clcode=party_code,segment='F',  
 category =   
 isnull(  
 (  
  select top 1  
   exchangecategory   
  from   
--   [196.1.115.23].general.dbo.angelclientstatus a  
   middleware.mimansa.dbo.angelclientstatus a  
  where   
   ac5.party_code = a.party_code and   
   exchangesegment = 'NSEFO'  
 ), '1')  
from     
     middleware.mimansa.dbo.angelclient5 ac5  
--      where nsefoactivefrom >= @fdate + ' 14:00'    
--      and nsefoactivefrom < @tdate + ' 14:00'    
  
     where nsefoactivefrom >= @fdate + ' 00:00:00'  
     and nsefoactivefrom <= @tdate + ' 23:59:59'  
  
/*     and nsefoinactivefrom >= getdate()    */  
     and party_code not in    
(select distinct clcode from nse_fo_success where segment='F' and result='S')    
/*and clcode not in (select distinct clcode from  ucc_succ where segment='f')*/)  ucc              
--(select clcode,segment='F' from fotrade where clcode not in (select distinct clcode from nse_fo_success where segment='F' and result='S'))  ucc              
--select clcode,segment='F' from fotrade where clcode not in (select distinct clcode from nse_fo_success where segment='F' and result='S') and clcode not in (select clcode from  ucc_succ)             
          
 join angelfo.nsefo.dbo.client2 c2 on c2.party_code = ucc.clcode                 
    left join (select * from angelfo.nsefo.dbo.client4 where defdp=1)c4 on c4.party_code = ucc.clcode                 
    left join angelfo.nsefo.dbo.client1 c1 on c2.cl_code = c1.Cl_Code                 
    left join angelfo.nsefo.dbo.client5 c5 on c2.cl_code = c5.cl_code               
where c2.party_code is not null and ucc.segment='F'             
order by ucc.clcode

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSE_Trade_Upload
-- --------------------------------------------------
CREATE proc USP_BSE_Trade_Upload    
as    
    
declare @file as varchar(100)    
declare @path as varchar(100)    
declare @sql as varchar(500)    
    
set @file = 'BR'+left(replace(convert(varchar(11),getdate(),103),'/',''),4) + substring(right(replace(convert(varchar(11),getdate(),103),'/',''),4),3,2)+'.DAT'     
set @path = 'd:\bse\cashtrd\'+@file    
    
truncate table bsecashtrd_MIS    
    
set @sql = 'BULK INSERT bsecashtrd_mis FROM '''+@path+''' WITH (FIELDTERMINATOR=''|'',FIRSTROW=1,KEEPNULLS)'    
exec(@sql)    


truncate table bsecashtrd    
INSERT INTO bsecashtrd SELECT * FROM bsecashtrd_MIS (nolock)

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
-- TABLE dbo.____uccnsecm_clientopening
-- --------------------------------------------------
CREATE TABLE [dbo].[____uccnsecm_clientopening]
(
    [clcode] VARCHAR(10) NOT NULL,
    [segment] VARCHAR(1) NOT NULL,
    [mapin_id] VARCHAR(1) NOT NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [wardnumber] VARCHAR(1) NOT NULL,
    [passport_no] VARCHAR(1) NOT NULL,
    [placeofissuepassport] VARCHAR(1) NOT NULL,
    [dateofissuepassport] VARCHAR(1) NOT NULL,
    [drivinglicenseno] VARCHAR(1) NOT NULL,
    [placeofissuedrivinglicensno] VARCHAR(1) NOT NULL,
    [dateofissuedrivinglicensno] VARCHAR(1) NOT NULL,
    [voteridno] VARCHAR(1) NOT NULL,
    [placeissuevoteridno] VARCHAR(1) NOT NULL,
    [dateofissuevoteridno] VARCHAR(1) NOT NULL,
    [rationcardno] VARCHAR(1) NOT NULL,
    [placeofissuerationcardno] VARCHAR(1) NOT NULL,
    [dateofissuerationcardno] VARCHAR(1) NOT NULL,
    [regnno] VARCHAR(1) NOT NULL,
    [regnauthority] VARCHAR(1) NOT NULL,
    [placeofregn] VARCHAR(1) NOT NULL,
    [dateofregn] VARCHAR(1) NOT NULL,
    [long_name] VARCHAR(100) NULL,
    [category] VARCHAR(2) NOT NULL,
    [clientaddress] VARCHAR(164) NULL,
    [pin] VARCHAR(10) NULL,
    [phone] VARCHAR(8000) NULL,
    [dob] VARCHAR(1) NOT NULL,
    [clientagrdate] VARCHAR(1) NOT NULL,
    [introdname] VARCHAR(1) NOT NULL,
    [relaintro] VARCHAR(1) NOT NULL,
    [introclientid] VARCHAR(1) NOT NULL,
    [bankname] VARCHAR(1) NOT NULL,
    [bankbranchaddress] VARCHAR(1) NOT NULL,
    [bankaccounttype] VARCHAR(1) NOT NULL,
    [bankacno] VARCHAR(1) NOT NULL,
    [depositoryid] VARCHAR(8) NOT NULL,
    [depository] VARCHAR(7) NOT NULL,
    [benefowneraccno] VARCHAR(16) NOT NULL,
    [anyotheracwithsametm] VARCHAR(1) NOT NULL,
    [settmode] VARCHAR(1) NOT NULL,
    [clientwithanyothertm] VARCHAR(1) NOT NULL,
    [flag] VARCHAR(1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo._uccnse_uploadcashnew_party_range_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[_uccnse_uploadcashnew_party_range_temp]
(
    [party_code] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.01_06002vikas
-- --------------------------------------------------
CREATE TABLE [dbo].[01_06002vikas]
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
    [Col023] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.06_06002v
-- --------------------------------------------------
CREATE TABLE [dbo].[06_06002v]
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
    [Col023] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.15tradefile
-- --------------------------------------------------
CREATE TABLE [dbo].[15tradefile]
(
    [Col001] CHAR(255) NULL,
    [Col002] CHAR(255) NULL,
    [Col003] CHAR(255) NULL,
    [Col004] CHAR(255) NULL,
    [Col005] CHAR(255) NULL,
    [Col006] CHAR(255) NULL,
    [Col007] CHAR(255) NULL,
    [Col008] CHAR(255) NULL,
    [Col009] CHAR(255) NULL,
    [Col010] CHAR(255) NULL,
    [Col011] CHAR(255) NULL,
    [Col012] CHAR(255) NULL,
    [Col013] CHAR(255) NULL,
    [Col014] CHAR(255) NULL,
    [Col015] CHAR(255) NULL,
    [Col016] CHAR(255) NULL,
    [Col017] CHAR(255) NULL,
    [Col018] CHAR(255) NULL,
    [Col019] CHAR(255) NULL,
    [Col020] CHAR(255) NULL,
    [Col021] CHAR(255) NULL,
    [Col022] CHAR(255) NULL,
    [Col023] CHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.aprdetail
-- --------------------------------------------------
CREATE TABLE [dbo].[aprdetail]
(
    [MEMBERID] CHAR(9) NULL,
    [TWSNO] CHAR(8) NULL,
    [CLIENTID] CHAR(16) NULL,
    [CLTTYPE] CHAR(9) NULL,
    [SCRIPCODE] CHAR(11) NULL,
    [QTY] CHAR(12) NULL,
    [RATE] CHAR(13) NULL,
    [BS] CHAR(6) NULL,
    [DATETIME] CHAR(48) NULL,
    [flag] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.aprpending
-- --------------------------------------------------
CREATE TABLE [dbo].[aprpending]
(
    [clientid] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.broktable
-- --------------------------------------------------
CREATE TABLE [dbo].[broktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] NUMERIC(19, 4) NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bse_appr_list
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_appr_list]
(
    [srno] VARCHAR(20) NULL,
    [scode] VARCHAR(20) NULL,
    [sname] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bse_error_report
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_error_report]
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
-- TABLE dbo.bse_termid
-- --------------------------------------------------
CREATE TABLE [dbo].[bse_termid]
(
    [termid] VARCHAR(15) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsebroktable
-- --------------------------------------------------
CREATE TABLE [dbo].[bsebroktable]
(
    [Table_No] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] NUMERIC(10, 2) NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[bsecashtrd]
(
    [Clearing_Code] VARCHAR(20) NULL,
    [Termid] VARCHAR(20) NULL,
    [Scrip_cd] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [MarketRate] MONEY NULL,
    [TradeQty] INT NULL,
    [Svalue0] VARCHAR(5) NULL,
    [Svalue_0] VARCHAR(5) NULL,
    [Sauda_time] VARCHAR(50) NULL,
    [Sauda_date] DATETIME NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Order_no] VARCHAR(25) NULL,
    [SvalueL] VARCHAR(5) NULL,
    [Sell_Buy] VARCHAR(5) NULL,
    [trade_no] VARCHAR(25) NULL,
    [pro_cli] VARCHAR(20) NULL,
    [Isin_no] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bsecashtrd_mis
-- --------------------------------------------------
CREATE TABLE [dbo].[bsecashtrd_mis]
(
    [Clearing_Code] VARCHAR(20) NULL,
    [Termid] VARCHAR(20) NULL,
    [Scrip_cd] VARCHAR(20) NULL,
    [Symbol] VARCHAR(50) NULL,
    [MarketRate] MONEY NULL,
    [TradeQty] INT NULL,
    [Svalue0] VARCHAR(5) NULL,
    [Svalue_0] VARCHAR(5) NULL,
    [Sauda_time] VARCHAR(50) NULL,
    [Sauda_date] DATETIME NULL,
    [Party_Code] VARCHAR(50) NULL,
    [Order_no] VARCHAR(25) NULL,
    [SvalueL] VARCHAR(5) NULL,
    [Sell_Buy] VARCHAR(5) NULL,
    [trade_no] VARCHAR(25) NULL,
    [pro_cli] VARCHAR(20) NULL,
    [Isin_no] VARCHAR(150) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.c2
-- --------------------------------------------------
CREATE TABLE [dbo].[c2]
(
    [Cl_Code] CHAR(10) NOT NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Tran_Cat] CHAR(3) NOT NULL,
    [Scrip_cat] NUMERIC(18, 4) NULL,
    [Party_code] CHAR(10) NOT NULL,
    [Table_no] INT NULL,
    [Sub_TableNo] INT NULL,
    [Margin] TINYINT NOT NULL,
    [Turnover_tax] TINYINT NOT NULL,
    [Sebi_Turn_tax] TINYINT NOT NULL,
    [Insurance_Chrg] TINYINT NOT NULL,
    [Service_chrg] TINYINT NOT NULL,
    [Std_rate] INT NULL,
    [P_To_P] INT NULL,
    [exposure_lim] NUMERIC(12, 2) NOT NULL,
    [demat_tableno] INT NULL,
    [BankId] VARCHAR(15) NULL,
    [CltDpNo] VARCHAR(16) NULL,
    [Printf] TINYINT NOT NULL,
    [ALBMDelchrg] TINYINT NULL,
    [ALBMDelivery] SMALLINT NULL,
    [AlbmCF_tableno] SMALLINT NULL,
    [MF_tableno] INT NULL,
    [SB_tableno] INT NULL,
    [brok1_tableno] INT NULL,
    [brok2_tableno] INT NULL,
    [brok3_tableno] INT NULL,
    [BrokerNote] TINYINT NULL,
    [Other_chrg] TINYINT NULL,
    [brok_scheme] TINYINT NULL,
    [Contcharge] TINYINT NULL,
    [MinContAmt] TINYINT NULL,
    [AddLedgerBal] TINYINT NULL,
    [Dummy1] INT NULL,
    [Dummy2] INT NULL,
    [InsCont] CHAR(1) NULL,
    [SerTaxMethod] INT NULL,
    [Dummy6] VARCHAR(5) NULL,
    [Dummy7] VARCHAR(4) NULL,
    [Dummy8] VARCHAR(20) NULL,
    [Dummy9] VARCHAR(20) NULL,
    [Dummy10] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.del
-- --------------------------------------------------
CREATE TABLE [dbo].[del]
(
    [brokerid] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [amt] VARCHAR(25) NULL,
    [segment] VARCHAR(25) NULL,
    [info] VARCHAR(25) NULL,
    [remarks] VARCHAR(100) NULL,
    [uploaddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.down
-- --------------------------------------------------
CREATE TABLE [dbo].[down]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.downnew1
-- --------------------------------------------------
CREATE TABLE [dbo].[downnew1]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo
-- --------------------------------------------------
CREATE TABLE [dbo].[fo]
(
    [clcode] VARCHAR(25) NULL,
    [segment] VARCHAR(25) NULL,
    [mapin_id] VARCHAR(1) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [wardnumber] VARCHAR(1) NULL,
    [passport_no] VARCHAR(1) NULL,
    [placeofissuepassport] VARCHAR(1) NULL,
    [dateofissuepassport] VARCHAR(1) NULL,
    [drivinglicenseno] VARCHAR(1) NULL,
    [placeofissuedrivinglicensno] VARCHAR(1) NULL,
    [dateofissuedrivinglicensno] VARCHAR(1) NULL,
    [voteridno] VARCHAR(1) NULL,
    [placeissuevoteridno] VARCHAR(1) NULL,
    [dateofissuevoteridno] VARCHAR(1) NULL,
    [Rationcardno] VARCHAR(1) NULL,
    [placeofissuerationcardno] VARCHAR(1) NULL,
    [Dateofissuerationcardno] VARCHAR(1) NULL,
    [regnno] VARCHAR(1) NULL,
    [regnauthority] VARCHAR(1) NULL,
    [placeofregn] VARCHAR(1) NULL,
    [dateofregn] VARCHAR(1) NULL,
    [long_name] VARCHAR(100) NULL,
    [category] VARCHAR(2) NULL,
    [clientaddress] VARCHAR(122) NULL,
    [pin] VARCHAR(10) NULL,
    [phone] VARCHAR(15) NULL,
    [dob] VARCHAR(1) NULL,
    [clientagrdate] VARCHAR(1) NULL,
    [introdname] VARCHAR(1) NULL,
    [relaintro] VARCHAR(1) NULL,
    [introclientid] VARCHAR(1) NULL,
    [bankname] VARCHAR(1) NULL,
    [bankbranchaddress] VARCHAR(1) NULL,
    [bankaccounttype] VARCHAR(1) NULL,
    [bankacno] VARCHAR(1) NULL,
    [depositoryid] VARCHAR(20) NULL,
    [depository] VARCHAR(7) NULL,
    [benefowneraccno] VARCHAR(16) NULL,
    [anyotheracwithsametm] VARCHAR(1) NULL,
    [settmode] VARCHAR(1) NULL,
    [clientwithanyothertm] VARCHAR(1) NULL,
    [flag] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fotrade
-- --------------------------------------------------
CREATE TABLE [dbo].[fotrade]
(
    [tradeno] VARCHAR(25) NULL,
    [ttype] VARCHAR(25) NULL,
    [scrip] VARCHAR(25) NULL,
    [scriptype] VARCHAR(25) NULL,
    [expdate] VARCHAR(25) NULL,
    [stkpricce] VARCHAR(25) NULL,
    [opttype] VARCHAR(25) NULL,
    [scripname] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [bb] VARCHAR(25) NULL,
    [userid] VARCHAR(25) NULL,
    [location] VARCHAR(25) NULL,
    [bs] VARCHAR(25) NULL,
    [qty] VARCHAR(25) NULL,
    [price] VARCHAR(25) NULL,
    [cltype] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [brkcode] VARCHAR(25) NULL,
    [brktype] VARCHAR(25) NULL,
    [orderdate] VARCHAR(25) NULL,
    [tradedate] VARCHAR(25) NULL,
    [order_no] VARCHAR(25) NULL,
    [remarks] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fotrade_previous
-- --------------------------------------------------
CREATE TABLE [dbo].[fotrade_previous]
(
    [tradeno] VARCHAR(25) NULL,
    [ttype] VARCHAR(25) NULL,
    [scrip] VARCHAR(25) NULL,
    [scriptype] VARCHAR(25) NULL,
    [expdate] VARCHAR(25) NULL,
    [stkpricce] VARCHAR(25) NULL,
    [opttype] VARCHAR(25) NULL,
    [scripname] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [bb] VARCHAR(25) NULL,
    [userid] VARCHAR(25) NULL,
    [location] VARCHAR(25) NULL,
    [bs] VARCHAR(25) NULL,
    [qty] VARCHAR(25) NULL,
    [price] VARCHAR(25) NULL,
    [cltype] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [brkcode] VARCHAR(25) NULL,
    [brktype] VARCHAR(25) NULL,
    [orderdate] VARCHAR(25) NULL,
    [tradedate] VARCHAR(25) NULL,
    [order_no] VARCHAR(25) NULL,
    [remarks] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fotrade_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[fotrade_temp]
(
    [tradeno] VARCHAR(25) NULL,
    [ttype] VARCHAR(25) NULL,
    [scrip] VARCHAR(25) NULL,
    [scriptype] VARCHAR(25) NULL,
    [expdate] VARCHAR(25) NULL,
    [stkpricce] VARCHAR(25) NULL,
    [opttype] VARCHAR(25) NULL,
    [scripname] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [bb] VARCHAR(25) NULL,
    [userid] VARCHAR(25) NULL,
    [location] VARCHAR(25) NULL,
    [bs] VARCHAR(25) NULL,
    [qty] VARCHAR(25) NULL,
    [price] VARCHAR(25) NULL,
    [cltype] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [brkcode] VARCHAR(25) NULL,
    [brktype] VARCHAR(25) NULL,
    [orderdate] VARCHAR(25) NULL,
    [tradedate] VARCHAR(25) NULL,
    [order_no] VARCHAR(25) NULL,
    [remarks] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fotradecopy
-- --------------------------------------------------
CREATE TABLE [dbo].[fotradecopy]
(
    [tradeno] VARCHAR(25) NULL,
    [ttype] VARCHAR(25) NULL,
    [scrip] VARCHAR(25) NULL,
    [scriptype] VARCHAR(25) NULL,
    [expdate] VARCHAR(25) NULL,
    [stkpricce] VARCHAR(25) NULL,
    [opttype] VARCHAR(25) NULL,
    [scripname] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [bb] VARCHAR(25) NULL,
    [userid] VARCHAR(25) NULL,
    [location] VARCHAR(25) NULL,
    [bs] VARCHAR(25) NULL,
    [qty] VARCHAR(25) NULL,
    [price] VARCHAR(25) NULL,
    [cltype] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [brkcode] VARCHAR(25) NULL,
    [brktype] VARCHAR(25) NULL,
    [orderdate] VARCHAR(25) NULL,
    [tradedate] VARCHAR(25) NULL,
    [order_no] VARCHAR(25) NULL,
    [remarks] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.missingclient_fotrade
-- --------------------------------------------------
CREATE TABLE [dbo].[missingclient_fotrade]
(
    [tradeno] VARCHAR(25) NULL,
    [ttype] VARCHAR(25) NULL,
    [scrip] VARCHAR(25) NULL,
    [scriptype] VARCHAR(25) NULL,
    [expdate] VARCHAR(25) NULL,
    [stkpricce] VARCHAR(25) NULL,
    [opttype] VARCHAR(25) NULL,
    [scripname] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [bb] VARCHAR(25) NULL,
    [userid] VARCHAR(25) NULL,
    [location] VARCHAR(25) NULL,
    [bs] VARCHAR(25) NULL,
    [qty] VARCHAR(25) NULL,
    [price] VARCHAR(25) NULL,
    [cltype] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [brkcode] VARCHAR(25) NULL,
    [brktype] VARCHAR(25) NULL,
    [orderdate] VARCHAR(25) NULL,
    [tradedate] VARCHAR(25) NULL,
    [order_no] VARCHAR(25) NULL,
    [remarks] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newcode
-- --------------------------------------------------
CREATE TABLE [dbo].[newcode]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.newcode1
-- --------------------------------------------------
CREATE TABLE [dbo].[newcode1]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_fo_success
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_fo_success]
(
    [segment] VARCHAR(10) NULL,
    [Clcode] VARCHAR(10) NULL,
    [mapinid] VARCHAR(25) NULL,
    [pangirno] VARCHAR(25) NULL,
    [wardno] VARCHAR(25) NULL,
    [ppno] VARCHAR(25) NULL,
    [pp_place] VARCHAR(100) NULL,
    [pp_dt] VARCHAR(50) NULL,
    [drv_no] VARCHAR(100) NULL,
    [drv_place] VARCHAR(100) NULL,
    [drv_dt] VARCHAR(50) NULL,
    [vote_no] VARCHAR(100) NULL,
    [vote_place] VARCHAR(100) NULL,
    [vote_dt] VARCHAR(50) NULL,
    [ration_no] VARCHAR(100) NULL,
    [ration_place] VARCHAR(100) NULL,
    [ration_date] VARCHAR(50) NULL,
    [regno] VARCHAR(100) NULL,
    [reg_autho] VARCHAR(100) NULL,
    [reg_place] VARCHAR(100) NULL,
    [reg_date] VARCHAR(50) NULL,
    [long_name] VARCHAR(150) NULL,
    [Category] VARCHAR(25) NULL,
    [Address] VARCHAR(500) NULL,
    [Pincode] VARCHAR(25) NULL,
    [phone] VARCHAR(50) NULL,
    [DOB] VARCHAR(25) NULL,
    [agre_date] VARCHAR(25) NULL,
    [intro_name] VARCHAR(100) NULL,
    [intro_relation] VARCHAR(100) NULL,
    [Intro_clcode] VARCHAR(25) NULL,
    [bankname] VARCHAR(200) NULL,
    [bankaddress] VARCHAR(500) NULL,
    [bank_acc_type] VARCHAR(255) NULL,
    [bank_Acc_no] VARCHAR(50) NULL,
    [dp_id] VARCHAR(25) NULL,
    [dpno] VARCHAR(25) NULL,
    [clid] VARCHAR(16) NULL,
    [otherAcc] VARCHAR(100) NULL,
    [settmode] VARCHAR(50) NULL,
    [otherAccD] VARCHAR(100) NULL,
    [flag] VARCHAR(10) NULL,
    [result] VARCHAR(10) NULL,
    [filename] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse_fo_success_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[nse_fo_success_temp]
(
    [segment] VARCHAR(10) NULL,
    [Clcode] VARCHAR(10) NULL,
    [mapinid] VARCHAR(25) NULL,
    [pangirno] VARCHAR(25) NULL,
    [wardno] VARCHAR(25) NULL,
    [ppno] VARCHAR(25) NULL,
    [pp_place] VARCHAR(100) NULL,
    [pp_dt] VARCHAR(50) NULL,
    [drv_no] VARCHAR(100) NULL,
    [drv_place] VARCHAR(100) NULL,
    [drv_dt] VARCHAR(50) NULL,
    [vote_no] VARCHAR(100) NULL,
    [vote_place] VARCHAR(100) NULL,
    [vote_dt] VARCHAR(50) NULL,
    [ration_no] VARCHAR(100) NULL,
    [ration_place] VARCHAR(100) NULL,
    [ration_date] VARCHAR(50) NULL,
    [regno] VARCHAR(100) NULL,
    [reg_autho] VARCHAR(100) NULL,
    [reg_place] VARCHAR(100) NULL,
    [reg_date] VARCHAR(50) NULL,
    [long_name] VARCHAR(150) NULL,
    [Category] VARCHAR(25) NULL,
    [Address] VARCHAR(500) NULL,
    [Pincode] VARCHAR(25) NULL,
    [phone] VARCHAR(50) NULL,
    [DOB] VARCHAR(25) NULL,
    [agre_date] VARCHAR(25) NULL,
    [intro_name] VARCHAR(100) NULL,
    [intro_relation] VARCHAR(100) NULL,
    [Intro_clcode] VARCHAR(25) NULL,
    [bankname] VARCHAR(200) NULL,
    [bankaddress] VARCHAR(500) NULL,
    [bank_acc_type] VARCHAR(255) NULL,
    [bank_Acc_no] VARCHAR(50) NULL,
    [dp_id] VARCHAR(25) NULL,
    [dpno] VARCHAR(25) NULL,
    [clid] VARCHAR(16) NULL,
    [otherAcc] VARCHAR(100) NULL,
    [settmode] VARCHAR(50) NULL,
    [otherAccD] VARCHAR(100) NULL,
    [flag] VARCHAR(10) NULL,
    [result] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nse111
-- --------------------------------------------------
CREATE TABLE [dbo].[nse111]
(
    [Col001] VARCHAR(10) NULL,
    [Col002] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsebroktable
-- --------------------------------------------------
CREATE TABLE [dbo].[nsebroktable]
(
    [Table_no] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsebroktable1
-- --------------------------------------------------
CREATE TABLE [dbo].[nsebroktable1]
(
    [Table_no] SMALLINT NOT NULL,
    [Line_No] NUMERIC(3, 0) NOT NULL,
    [Val_perc] CHAR(1) NULL,
    [Upper_lim] MONEY NULL,
    [Day_puc] NUMERIC(10, 6) NULL,
    [Day_Sales] NUMERIC(10, 6) NULL,
    [Sett_Purch] NUMERIC(10, 6) NULL,
    [round_to] NUMERIC(10, 2) NULL,
    [sett_sales] NUMERIC(10, 6) NULL,
    [NORMAL] NUMERIC(10, 6) NULL,
    [Trd_Del] CHAR(1) NULL,
    [Lower_lim] NUMERIC(10, 2) NULL,
    [def_table] TINYINT NULL,
    [RoFig] INT NULL,
    [ErrNum] MONEY NULL,
    [NoZero] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsependinglist
-- --------------------------------------------------
CREATE TABLE [dbo].[nsependinglist]
(
    [brokerid] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [amt] VARCHAR(25) NULL,
    [segment] VARCHAR(25) NULL,
    [info] VARCHAR(25) NULL,
    [remarks] VARCHAR(100) NULL,
    [uploaddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.nsependinglistf
-- --------------------------------------------------
CREATE TABLE [dbo].[nsependinglistf]
(
    [brokerid] VARCHAR(25) NULL,
    [clcode] VARCHAR(25) NULL,
    [amt] VARCHAR(25) NULL,
    [segment] VARCHAR(25) NULL,
    [info] VARCHAR(25) NULL,
    [remarks] VARCHAR(100) NULL,
    [uploaddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.oldcode
-- --------------------------------------------------
CREATE TABLE [dbo].[oldcode]
(
    [clcode] VARCHAR(255) NULL,
    [proof] VARCHAR(255) NULL,
    [det1] VARCHAR(255) NULL,
    [date1] VARCHAR(255) NULL,
    [date2] VARCHAR(255) NULL,
    [place] VARCHAR(255) NULL,
    [sbcode] VARCHAR(255) NULL,
    [name] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.oldcode1
-- --------------------------------------------------
CREATE TABLE [dbo].[oldcode1]
(
    [clcode] VARCHAR(255) NULL,
    [proof] VARCHAR(255) NULL,
    [det1] VARCHAR(255) NULL,
    [date1] VARCHAR(255) NULL,
    [date2] VARCHAR(255) NULL,
    [place] VARCHAR(255) NULL,
    [sbcode] VARCHAR(255) NULL,
    [name] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.pcode_exception
-- --------------------------------------------------
CREATE TABLE [dbo].[pcode_exception]
(
    [party_code] VARCHAR(30) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NULL
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
-- TABLE dbo.rrr
-- --------------------------------------------------
CREATE TABLE [dbo].[rrr]
(
    [Col001] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sauda_subbrokers_details
-- --------------------------------------------------
CREATE TABLE [dbo].[sauda_subbrokers_details]
(
    [party_code] VARCHAR(25) NULL,
    [sauda_date] DATETIME NULL,
    [symbol] VARCHAR(20) NULL,
    [marketrate] MONEY NULL,
    [tradeqty] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.selftrade_fin
-- --------------------------------------------------
CREATE TABLE [dbo].[selftrade_fin]
(
    [branch_name] CHAR(40) NULL,
    [Sauda_date] VARCHAR(62) NULL,
    [Series] VARCHAR(1) NULL,
    [Trade_no] VARCHAR(25) NULL,
    [Order_no] VARCHAR(25) NULL,
    [user_id] VARCHAR(20) NULL,
    [branchcode] VARCHAR(10) NULL,
    [branch_id] VARCHAR(50) NULL,
    [acname] VARCHAR(21) NULL,
    [Scrip_Cd] VARCHAR(20) NULL,
    [scpname] VARCHAR(12) NULL,
    [sb] VARCHAR(4) NULL,
    [tradeqty] INT NULL,
    [marketrate] MONEY NULL,
    [net_trdqty] NUMERIC(10, 0) NULL,
    [our] NUMERIC(21, 11) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sub_broker_list
-- --------------------------------------------------
CREATE TABLE [dbo].[sub_broker_list]
(
    [party_code] VARCHAR(25) NULL,
    [short_name] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.sysdiagrams
-- --------------------------------------------------
CREATE TABLE [dbo].[sysdiagrams]
(
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT IDENTITY(1,1) NOT NULL,
    [version] INT NULL,
    [definition] VARBINARY(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbsetable
-- --------------------------------------------------
CREATE TABLE [dbo].[tbsetable]
(
    [party_code] VARCHAR(10) NULL,
    [long_name] VARCHAR(100) NULL,
    [activefrom] DATETIME NULL,
    [inactivefrom] DATETIME NULL,
    [todaydate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_bsecashtrd
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_bsecashtrd]
(
    [termid] INT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [branch_name] VARCHAR(50) NULL,
    [party_code] VARCHAR(20) NULL,
    [turnover] FLOAT NULL,
    [sauda_date] DATETIME NULL
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
-- TABLE dbo.ucc_nsecm_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[ucc_nsecm_temp]
(
    [clcode] VARCHAR(10) NULL,
    [segment] VARCHAR(1) NULL,
    [mapin_id] VARCHAR(1) NULL,
    [pan_gir_no] VARCHAR(20) NULL,
    [wardnumber] VARCHAR(1) NULL,
    [passport_no] VARCHAR(30) NULL,
    [placeofissuepassport] VARCHAR(30) NULL,
    [dateofissuepassport] DATETIME NULL,
    [drivinglicenseno] VARCHAR(30) NULL,
    [placeofissuedrivinglicensno] VARCHAR(30) NULL,
    [dateofissuedrivinglicensno] DATETIME NULL,
    [voteridno] VARCHAR(30) NULL,
    [placeissuevoteridno] VARCHAR(30) NULL,
    [dateofissuevoteridno] DATETIME NULL,
    [Rationcardno] VARCHAR(30) NULL,
    [placeofissuerationcardno] VARCHAR(30) NULL,
    [Dateofissuerationcardno] DATETIME NULL,
    [regnno] VARCHAR(1) NULL,
    [regnauthority] VARCHAR(1) NULL,
    [placeofregn] VARCHAR(1) NULL,
    [dateofregn] VARCHAR(1) NULL,
    [long_name] VARCHAR(100) NULL,
    [category] VARCHAR(2) NULL,
    [clientaddress] VARCHAR(164) NULL,
    [pin] VARCHAR(10) NULL,
    [phone] VARCHAR(15) NULL,
    [dob] VARCHAR(1) NULL,
    [clientagrdate] VARCHAR(1) NULL,
    [introdname] VARCHAR(1) NULL,
    [relaintro] VARCHAR(1) NULL,
    [introclientid] VARCHAR(1) NULL,
    [bankname] VARCHAR(1) NULL,
    [bankbranchaddress] VARCHAR(1) NULL,
    [bankaccounttype] VARCHAR(1) NULL,
    [bankacno] VARCHAR(1) NULL,
    [depositoryid] VARCHAR(8) NULL,
    [depository] VARCHAR(7) NULL,
    [benefowneraccno] VARCHAR(16) NULL,
    [anyotheracwithsametm] VARCHAR(1) NULL,
    [settmode] VARCHAR(1) NULL,
    [clientwithanyothertm] VARCHAR(1) NULL,
    [flag] VARCHAR(1) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UCC_SUCC
-- --------------------------------------------------
CREATE TABLE [dbo].[UCC_SUCC]
(
    [segment] VARCHAR(10) NULL,
    [clcode] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ucc_succcopy
-- --------------------------------------------------
CREATE TABLE [dbo].[ucc_succcopy]
(
    [Col001] VARCHAR(8000) NULL,
    [Col002] VARCHAR(8000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccapr
-- --------------------------------------------------
CREATE TABLE [dbo].[uccapr]
(
    [MEMBE] VARCHAR(255) NULL,
    [RID TWS NO] VARCHAR(255) NULL,
    [CLIENTID] VARCHAR(255) NULL,
    [CLTTYPE] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [SCRIPCODE] VARCHAR(255) NULL,
    [QTY] VARCHAR(255) NULL,
    [RATE] VARCHAR(255) NULL,
    [B/S] VARCHAR(255) NULL,
    [DATETIME] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.UCCAPRIL
-- --------------------------------------------------
CREATE TABLE [dbo].[UCCAPRIL]
(
    [Col001] CHAR(1) NULL,
    [clcode] CHAR(1) NULL,
    [Col003] CHAR(2) NULL,
    [Col004] CHAR(3) NULL,
    [Col005] CHAR(125) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbse1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbse1]
(
    [Col001] CHAR(9) NULL,
    [Col002] CHAR(8) NULL,
    [clientid] CHAR(16) NULL,
    [Col004] CHAR(15) NULL,
    [Col005] CHAR(11) NULL,
    [Col006] CHAR(12) NULL,
    [Col007] CHAR(13) NULL,
    [Col008] CHAR(6) NULL,
    [Col009] CHAR(42) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbselist
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbselist]
(
    [TWS NO] VARCHAR(255) NULL,
    [CLIENTID] VARCHAR(255) NULL,
    [CLTTYPE] VARCHAR(255) NULL,
    [SCRIPCODE] VARCHAR(255) NULL,
    [QTY] VARCHAR(255) NULL,
    [RATE] VARCHAR(255) NULL,
    [B_S] VARCHAR(255) NULL,
    [DATETIME] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbselist1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbselist1]
(
    [clientid] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbsesuccess
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbsesuccess]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL,
    [CREATED_BY_ID] VARCHAR(255) NULL,
    [CREATED_BY_NAME] VARCHAR(255) NULL,
    [CREATED_DATE] VARCHAR(255) NULL,
    [MODIFIED_BY_ID] VARCHAR(255) NULL,
    [MODIFIED_BY_NAME] VARCHAR(255) NULL,
    [MODIFIED_DATE] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccbsesuccess1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccbsesuccess1]
(
    [BROKER_ID] VARCHAR(255) NULL,
    [BRANCH_OFFICE_ID] VARCHAR(255) NULL,
    [SUB_BROKER_ID_] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT_CODE] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME_] VARCHAR(255) NULL,
    [FATHER_HUSBAND_NAME_] VARCHAR(255) NULL,
    [NON_INDIVIDUAL_CLIENT_NAME] VARCHAR(255) NULL,
    [_CONTACT_PERSON_NAME] VARCHAR(255) NULL,
    [_ADDR_1] VARCHAR(255) NULL,
    [_ADDR_2] VARCHAR(255) NULL,
    [_CITY_] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [_COUNTRY_] VARCHAR(255) NULL,
    [PINCODE_] VARCHAR(255) NULL,
    [PHONE_NO_] VARCHAR(255) NULL,
    [FAX_NO_] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [_DATE_OF_BIRTH_] VARCHAR(255) NULL,
    [EDUCATIONAL_QUALIFICATION_] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [_CLIENT_AGGR_DATE_] VARCHAR(255) NULL,
    [INTRO_SURNAME] VARCHAR(255) NULL,
    [INTRO_FIRST_NAME] VARCHAR(255) NULL,
    [_INTRO_MIDDLE_NAME] VARCHAR(255) NULL,
    [INTRO_RELATION_] VARCHAR(255) NULL,
    [INTRO_CLIENT_ID_] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [_PAN_DECL_OBTAINED_] VARCHAR(255) NULL,
    [PASSPORT_NO_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_PLACE_] VARCHAR(255) NULL,
    [PASSPORT_ISSUE_DATE_] VARCHAR(255) NULL,
    [PASSPORT_EXPIRY_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_NO_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_PLACE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_ISSUE_DATE_] VARCHAR(255) NULL,
    [DRIVING_LICENSE_EXPIRY_DATE_] VARCHAR(255) NULL,
    [VOTER_ID_NO_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_PLACE_] VARCHAR(255) NULL,
    [VOTER_ID_ISSUE_DATE_] VARCHAR(255) NULL,
    [RATION_CARD_NO] VARCHAR(255) NULL,
    [_RATION_CARD_ISSUE_PLACE_] VARCHAR(255) NULL,
    [RATION_CARD_ISSUE_DATE_] VARCHAR(255) NULL,
    [BANK_CERT_OBTAINED_] VARCHAR(255) NULL,
    [BANK_NAME_] VARCHAR(255) NULL,
    [BANK_BRANCH_ADDR_] VARCHAR(255) NULL,
    [BANK_MICR_NO_] VARCHAR(255) NULL,
    [BANK_ACC_TYPE_] VARCHAR(255) NULL,
    [BANK_ACC_NO_] VARCHAR(255) NULL,
    [DEPOSITORY_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_PARTICIPANT_NAME_] VARCHAR(255) NULL,
    [DEPOSITORY_ID_] VARCHAR(255) NULL,
    [REGISTRATION_NO_] VARCHAR(255) NULL,
    [REGISTRATION_AUTH_] VARCHAR(255) NULL,
    [REGISTRATION_PLACE_] VARCHAR(255) NULL,
    [REGISTRATION_DATE_] VARCHAR(255) NULL,
    [SUB_BROKER_CLIENT_] VARCHAR(255) NULL,
    [SUB_BROKER_NAME_] VARCHAR(255) NULL,
    [SUB_BROKER_SEBI_REGISTRATION_NO] VARCHAR(255) NULL,
    [FAMILY_MEMB_ACC] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE1] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE2] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE3] VARCHAR(255) NULL,
    [FAMILY_MEMB_SETT_MODE4] VARCHAR(255) NULL,
    [FAMILY_MEMB1] VARCHAR(255) NULL,
    [FAMILY_MEMB2] VARCHAR(255) NULL,
    [FAMILY_MEMB3] VARCHAR(255) NULL,
    [FAMILY_MEMB4] VARCHAR(255) NULL,
    [ACC.WITH_OTHER_MEMB] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID1] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID2] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID3] VARCHAR(255) NULL,
    [OTHER_MEMB_CMID4_] VARCHAR(255) NULL,
    [CREATED_BY_ID] VARCHAR(255) NULL,
    [CREATED_BY_NAME] VARCHAR(255) NULL,
    [CREATED_DATE] VARCHAR(255) NULL,
    [MODIFIED_BY_ID] VARCHAR(255) NULL,
    [MODIFIED_BY_NAME] VARCHAR(255) NULL,
    [MODIFIED_DATE] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccdown
-- --------------------------------------------------
CREATE TABLE [dbo].[uccdown]
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
    [Col024] VARCHAR(255) NULL,
    [Col025] VARCHAR(255) NULL,
    [Col026] VARCHAR(255) NULL,
    [Col027] VARCHAR(255) NULL,
    [Col028] VARCHAR(255) NULL,
    [Col029] VARCHAR(255) NULL,
    [Col030] VARCHAR(255) NULL,
    [Col031] VARCHAR(255) NULL,
    [Col032] VARCHAR(255) NULL,
    [Col033] VARCHAR(255) NULL,
    [Col034] VARCHAR(255) NULL,
    [Col035] VARCHAR(255) NULL,
    [Col036] VARCHAR(255) NULL,
    [Col037] VARCHAR(255) NULL,
    [Col038] VARCHAR(255) NULL,
    [Col039] VARCHAR(255) NULL,
    [Col040] VARCHAR(255) NULL,
    [Col041] VARCHAR(255) NULL,
    [Col042] VARCHAR(255) NULL,
    [Col043] VARCHAR(255) NULL,
    [Col044] VARCHAR(255) NULL,
    [Col045] VARCHAR(255) NULL,
    [Col046] VARCHAR(255) NULL,
    [Col047] VARCHAR(255) NULL,
    [Col048] VARCHAR(255) NULL,
    [Col049] VARCHAR(255) NULL,
    [Col050] VARCHAR(255) NULL,
    [Col051] VARCHAR(255) NULL,
    [Col052] VARCHAR(255) NULL,
    [Col053] VARCHAR(255) NULL,
    [Col054] VARCHAR(255) NULL,
    [Col055] VARCHAR(255) NULL,
    [Col056] VARCHAR(255) NULL,
    [Col057] VARCHAR(255) NULL,
    [Col058] VARCHAR(255) NULL,
    [Col059] VARCHAR(255) NULL,
    [Col060] VARCHAR(255) NULL,
    [Col061] VARCHAR(255) NULL,
    [Col062] VARCHAR(255) NULL,
    [Col063] VARCHAR(255) NULL,
    [Col064] VARCHAR(255) NULL,
    [Col065] VARCHAR(255) NULL,
    [Col066] VARCHAR(255) NULL,
    [Col067] VARCHAR(255) NULL,
    [Col068] VARCHAR(255) NULL,
    [Col069] VARCHAR(255) NULL,
    [Col070] VARCHAR(255) NULL,
    [Col071] VARCHAR(255) NULL,
    [Col072] VARCHAR(255) NULL,
    [Col073] VARCHAR(255) NULL,
    [Col074] VARCHAR(255) NULL,
    [Col075] VARCHAR(255) NULL,
    [Col076] VARCHAR(255) NULL,
    [Col077] VARCHAR(255) NULL,
    [Col078] VARCHAR(255) NULL,
    [Col079] VARCHAR(255) NULL,
    [Col080] VARCHAR(255) NULL,
    [Col081] VARCHAR(255) NULL,
    [Col082] VARCHAR(255) NULL,
    [Col083] VARCHAR(255) NULL,
    [Col084] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccnse_uploadcashnew_party_range_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[uccnse_uploadcashnew_party_range_temp]
(
    [party_code] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccnsefo_uploadcashnew_party_range_temp
-- --------------------------------------------------
CREATE TABLE [dbo].[uccnsefo_uploadcashnew_party_range_temp]
(
    [party_code] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccpending
-- --------------------------------------------------
CREATE TABLE [dbo].[uccpending]
(
    [MEMBERID] CHAR(9) NULL,
    [TWS NO] CHAR(8) NULL,
    [CLIENTID] CHAR(16) NULL,
    [CLTTYPE] CHAR(15) NULL,
    [SCRIPCODE] CHAR(11) NULL,
    [QTY] CHAR(12) NULL,
    [RATE] CHAR(13) NULL,
    [B/S] CHAR(6) NULL,
    [DATETIME] CHAR(42) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccpendinglist
-- --------------------------------------------------
CREATE TABLE [dbo].[uccpendinglist]
(
    [clientid] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccpendinglist1
-- --------------------------------------------------
CREATE TABLE [dbo].[uccpendinglist1]
(
    [clcode] VARCHAR(25) NULL,
    [item] VARCHAR(50) NULL,
    [itemdetail] VARCHAR(50) NULL,
    [itemiss] VARCHAR(25) NULL,
    [itemexp] VARCHAR(25) NULL,
    [itemplace] VARCHAR(50) NULL,
    [introcode] VARCHAR(25) NULL,
    [introname] VARCHAR(50) NULL,
    [tradedate] VARCHAR(25) NULL,
    [Col010] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.uccsuccess
-- --------------------------------------------------
CREATE TABLE [dbo].[uccsuccess]
(
    [BROKER ID] VARCHAR(255) NULL,
    [BRANCH OFFICE ID] VARCHAR(255) NULL,
    [SUB BROKER ID] VARCHAR(255) NULL,
    [SEGMENT] VARCHAR(255) NULL,
    [STATUS] VARCHAR(255) NULL,
    [CATEGORY] VARCHAR(255) NULL,
    [CLIENT CODE] VARCHAR(255) NULL,
    [SURNAME] VARCHAR(255) NULL,
    [FIRSTNAME] VARCHAR(255) NULL,
    [MIDDLENAME] VARCHAR(255) NULL,
    [FATHER HUSBAND NAME] VARCHAR(255) NULL,
    [NON INDIVIDUAL CLIENT NAME] VARCHAR(255) NULL,
    [ CONTACT PERSON NAME] VARCHAR(255) NULL,
    [ ADDR 1] VARCHAR(255) NULL,
    [ ADDR 2] VARCHAR(255) NULL,
    [ CITY] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [ COUNTRY] VARCHAR(255) NULL,
    [PINCODE] VARCHAR(255) NULL,
    [PHONE NO] VARCHAR(255) NULL,
    [FAX NO] VARCHAR(255) NULL,
    [EMAIL] VARCHAR(255) NULL,
    [ DATE OF BIRTH] VARCHAR(255) NULL,
    [EDUCATIONAL QUALIFICATION] VARCHAR(255) NULL,
    [OCCUPATION] VARCHAR(255) NULL,
    [ CLIENT AGGR DATE] VARCHAR(255) NULL,
    [INTRO SURNAME] VARCHAR(255) NULL,
    [INTRO FIRST NAME] VARCHAR(255) NULL,
    [ INTRO MIDDLE NAME] VARCHAR(255) NULL,
    [INTRO RELATION] VARCHAR(255) NULL,
    [INTRO CLIENT ID] VARCHAR(255) NULL,
    [PAN] VARCHAR(255) NULL,
    [ PAN DECL OBTAINED] VARCHAR(255) NULL,
    [PASSPORT NO] VARCHAR(255) NULL,
    [PASSPORT ISSUE PLACE] VARCHAR(255) NULL,
    [PASSPORT ISSUE DATE] VARCHAR(255) NULL,
    [PASSPORT EXPIRY DATE] VARCHAR(255) NULL,
    [DRIVING LICENSE NO] VARCHAR(255) NULL,
    [DRIVING LICENSE ISSUE PLACE] VARCHAR(255) NULL,
    [DRIVING LICENSE ISSUE DATE] VARCHAR(255) NULL,
    [DRIVING LICENSE EXPIRY DATE] VARCHAR(255) NULL,
    [VOTER ID NO] VARCHAR(255) NULL,
    [VOTER ID ISSUE PLACE] VARCHAR(255) NULL,
    [VOTER ID ISSUE DATE] VARCHAR(255) NULL,
    [RATION CARD NO] VARCHAR(255) NULL,
    [ RATION CARD ISSUE PLACE] VARCHAR(255) NULL,
    [RATION CARD ISSUE DATE] VARCHAR(255) NULL,
    [BANK CERT OBTAINED] VARCHAR(255) NULL,
    [BANK NAME] VARCHAR(255) NULL,
    [BANK BRANCH ADDR] VARCHAR(255) NULL,
    [BANK MICR NO] VARCHAR(255) NULL,
    [BANK ACC TYPE] VARCHAR(255) NULL,
    [BANK ACC NO] VARCHAR(255) NULL,
    [DEPOSITORY NAME] VARCHAR(255) NULL,
    [DEPOSITORY PARTICIPANT NAME] VARCHAR(255) NULL,
    [DEPOSITORY ID] VARCHAR(255) NULL,
    [REGISTRATION NO] VARCHAR(255) NULL,
    [REGISTRATION AUTH] VARCHAR(255) NULL,
    [REGISTRATION PLACE] VARCHAR(255) NULL,
    [REGISTRATION DATE] VARCHAR(255) NULL,
    [REMARKS] VARCHAR(255) NULL,
    [SUB BROKER CLIENT] VARCHAR(255) NULL,
    [SUB BROKER NAME] VARCHAR(255) NULL,
    [SUB BROKER SEBI REGISTRATION NO] VARCHAR(255) NULL,
    [FAMILY MEMB ACC] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE1] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE2] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE3] VARCHAR(255) NULL,
    [FAMILY MEMB SETT MODE4] VARCHAR(255) NULL,
    [FAMILY MEMB1] VARCHAR(255) NULL,
    [FAMILY MEMB2] VARCHAR(255) NULL,
    [FAMILY MEMB3] VARCHAR(255) NULL,
    [FAMILY MEMB4] VARCHAR(255) NULL,
    [ACC.WITH OTHER MEMB] VARCHAR(255) NULL,
    [OTHER MEMB CMID1] VARCHAR(255) NULL,
    [OTHER MEMB CMID2] VARCHAR(255) NULL,
    [OTHER MEMB CMID3] VARCHAR(255) NULL,
    [OTHER MEMB CMID4] VARCHAR(255) NULL,
    [CREATED BY ID] VARCHAR(255) NULL,
    [CREATED BY NAME] VARCHAR(255) NULL,
    [CREATED DATE] VARCHAR(255) NULL,
    [MODIFIED BY ID] VARCHAR(255) NULL,
    [MODIFIED BY NAME] VARCHAR(255) NULL,
    [MODIFIED DATE] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.vikas
-- --------------------------------------------------
CREATE TABLE [dbo].[vikas]
(
    [pcode] NVARCHAR(255) NULL
);

GO

