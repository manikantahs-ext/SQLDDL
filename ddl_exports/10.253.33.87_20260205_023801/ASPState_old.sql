-- DDL Export
-- Server: 10.253.33.87
-- Database: ASPState_old
-- Exported: 2026-02-05T02:38:02.157142

USE ASPState_old;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateTempTables
-- --------------------------------------------------

        CREATE PROCEDURE dbo.CreateTempTables
        AS
            CREATE TABLE [tempdb].dbo.ASPStateTempSessions (
                SessionId           nvarchar(88)    NOT NULL PRIMARY KEY,
                Created             datetime        NOT NULL DEFAULT GETUTCDATE(),
                Expires             datetime        NOT NULL,
                LockDate            datetime        NOT NULL,
                LockDateLocal       datetime        NOT NULL,
                LockCookie          int             NOT NULL,
                Timeout             int             NOT NULL,
                Locked              bit             NOT NULL,
                SessionItemShort    VARBINARY(7000) NULL,
                SessionItemLong     image           NULL,
                Flags               int             NOT NULL DEFAULT 0,
            ) 

            CREATE NONCLUSTERED INDEX Index_Expires ON [tempdb].dbo.ASPStateTempSessions(Expires)

            CREATE TABLE [tempdb].dbo.ASPStateTempApplications (
                AppId               int             NOT NULL PRIMARY KEY,
                AppName             char(280)       NOT NULL,
            ) 

            CREATE NONCLUSTERED INDEX Index_AppName ON [tempdb].dbo.ASPStateTempApplications(AppName)

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_CheckFileSize
-- --------------------------------------------------

Create proc DBA_CheckFileSize
as
SET NOCOUNT ON 

IF OBJECT_ID('tempdb..#DBSTATS') IS NOT NULL
BEGIN
   DROP TABLE #DBSTATS
END 

CREATE TABLE #DBSTATS (
   dbname   sysname,
   lname    sysname,
   usage    varchar(20),
   [size]   decimal(9, 2) NULL ,
   [used]   decimal(9, 2) NULL
) 

IF OBJECT_ID('tempdb..#temp_log') IS NOT NULL
BEGIN
   DROP TABLE #temp_log
END 

CREATE TABLE #temp_log
(
   DBName          sysname,
   LogSize         real,
   LogSpaceUsed    real,
   Status          int
) 

IF OBJECT_ID('tempdb..#temp_sfs') IS NOT NULL
BEGIN
   DROP TABLE #temp_sfs
END 

CREATE TABLE #temp_sfs
(
   fileid          int,
   filegroup       int,
   totalextents    int,
   usedextents     int,
   name            varchar(1024),
   filename        varchar(1024)
) 

DECLARE @dbname sysname
       ,@sql varchar(8000) 

IF OBJECT_ID('tempdb..#temp_db') IS NOT NULL
BEGIN
    DROP TABLE #temp_db
END 

SELECT name INTO #temp_db
   FROM master.dbo.sysdatabases
   WHERE DATABASEPROPERTY(name,'IsOffline') = 0
   AND has_dbaccess(name) = 1
   ORDER BY name 

WHILE (1 = 1)
BEGIN
   SET @dbname = NULL 

   SELECT TOP 1 @dbname = name
   FROM #temp_db
   ORDER BY name 

   IF @dbname IS NULL
      GOTO _NEXT 

   SET @sql = ' USE ' + @dbname + ' 

      TRUNCATE TABLE #temp_sfs 

      INSERT INTO #temp_sfs
         EXECUTE(''DBCC SHOWFILESTATS'') 

      INSERT INTO #DBSTATS (DBNAME, LNAME, USAGE, [SIZE], [USED])
         SELECT db_name(), NAME, ''Data''
         , totalextents * 64.0 / 1024.0
         , usedextents * 64.0 / 1024.0
         FROM #temp_sfs 

      INSERT INTO #DBSTATS (DBNAME, LNAME, USAGE, [SIZE], [USED])
         SELECT db_name(), name, ''Log'', null, null
         FROM sysfiles
         WHERE status & 0x40 = 0x40' 

    EXEC(@sql) 

    DELETE FROM #temp_db WHERE name = @dbname
END 

_NEXT: 

INSERT INTO #Temp_Log
   EXECUTE ('DBCC SQLPERF(LOGSPACE)') 

UPDATE #DBSTATS
   SET SIZE = B.LogSize
   , USED = LogSize * LogSpaceUsed / 100
FROM #DBSTATS A
INNER JOIN #Temp_Log B
    ON (A.DBNAME = B.DBNAME)AND(A.Usage = 'LOG') 

SELECT dbname AS [Database Name],
   lname AS [Logical Data Name],
   Usage,
   [size] AS [Space Allocated (MB)],
   used AS[Space Used (MB)],
   [size] - used  AS [Free Space (MB)],
   cast(used/[size]*100 AS numeric(9,2)) AS [Space Used %],
   cast(100-(used/[size]*100) AS numeric(9,2)) AS [Free Space %],getdate()Date
FROM #DBSTATS
ORDER BY dbname, usage 

DROP TABLE #DBSTATS
DROP TABLE #temp_db
DROP TABLE #temp_sfs
DROP TABLE #temp_log 

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DBA_test
-- --------------------------------------------------
create proc DBA_test
As
Select 'TRIGGER CHECK PROCEDURE'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteExpiredSessions
-- --------------------------------------------------

        CREATE PROCEDURE dbo.DeleteExpiredSessions
        AS
            DECLARE @now datetime
            SET @now = GETUTCDATE()

            DELETE [tempdb].dbo.ASPStateTempSessions
            WHERE Expires < @now

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetHashCode
-- --------------------------------------------------

/*****************************************************************************/

CREATE PROCEDURE dbo.GetHashCode
    @input tAppName,
    @hash int OUTPUT
AS
    /* 
       This sproc is based on this C# hash function:

        int GetHashCode(string s)
        {
            int     hash = 5381;
            int     len = s.Length;

            for (int i = 0; i < len; i++) {
                int     c = Convert.ToInt32(s[i]);
                hash = ((hash << 5) + hash) ^ c;
            }

            return hash;
        }

        However, SQL 7 doesn't provide a 32-bit integer
        type that allows rollover of bits, we have to
        divide our 32bit integer into the upper and lower
        16 bits to do our calculation.
    */
       
    DECLARE @hi_16bit   int
    DECLARE @lo_16bit   int
    DECLARE @hi_t       int
    DECLARE @lo_t       int
    DECLARE @len        int
    DECLARE @i          int
    DECLARE @c          int
    DECLARE @carry      int

    SET @hi_16bit = 0
    SET @lo_16bit = 5381
    
    SET @len = DATALENGTH(@input)
    SET @i = 1
    
    WHILE (@i <= @len)
    BEGIN
        SET @c = ASCII(SUBSTRING(@input, @i, 1))

        /* Formula:                        
           hash = ((hash << 5) + hash) ^ c */

        /* hash << 5 */
        SET @hi_t = @hi_16bit * 32 /* high 16bits << 5 */
        SET @hi_t = @hi_t & 0xFFFF /* zero out overflow */
        
        SET @lo_t = @lo_16bit * 32 /* low 16bits << 5 */
        
        SET @carry = @lo_16bit & 0x1F0000 /* move low 16bits carryover to hi 16bits */
        SET @carry = @carry / 0x10000 /* >> 16 */
        SET @hi_t = @hi_t + @carry
        SET @hi_t = @hi_t & 0xFFFF /* zero out overflow */

        /* + hash */
        SET @lo_16bit = @lo_16bit + @lo_t
        SET @hi_16bit = @hi_16bit + @hi_t + (@lo_16bit / 0x10000)
        /* delay clearing the overflow */

        /* ^c */
        SET @lo_16bit = @lo_16bit ^ @c

        /* Now clear the overflow bits */	
        SET @hi_16bit = @hi_16bit & 0xFFFF
        SET @lo_16bit = @lo_16bit & 0xFFFF

        SET @i = @i + 1
    END

    /* Do a sign extension of the hi-16bit if needed */
    IF (@hi_16bit & 0x8000 <> 0)
        SET @hi_16bit = 0xFFFF0000 | @hi_16bit

    /* Merge hi and lo 16bit back together */
    SET @hi_16bit = @hi_16bit * 0x10000 /* << 16 */
    SET @hash = @hi_16bit | @lo_16bit

    RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.GetMajorVersion
-- --------------------------------------------------

/*****************************************************************************/

CREATE PROCEDURE dbo.GetMajorVersion
    @@ver int OUTPUT
AS
BEGIN
	DECLARE @version        nchar(100)
	DECLARE @dot            int
	DECLARE @hyphen         int
	DECLARE @SqlToExec      nchar(4000)

	SELECT @@ver = 7
	SELECT @version = @@Version
	SELECT @hyphen  = CHARINDEX(N' - ', @version)
	IF (NOT(@hyphen IS NULL) AND @hyphen > 0)
	BEGIN
		SELECT @hyphen = @hyphen + 3
		SELECT @dot    = CHARINDEX(N'.', @version, @hyphen)
		IF (NOT(@dot IS NULL) AND @dot > @hyphen)
		BEGIN
			SELECT @version = SUBSTRING(@version, @hyphen, @dot - @hyphen)
			SELECT @@ver     = CONVERT(int, @version)
		END
	END
END

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
-- PROCEDURE dbo.TempGetAppID
-- --------------------------------------------------

    CREATE PROCEDURE dbo.TempGetAppID
    @appName    tAppName,
    @appId      int OUTPUT
    AS
    SET @appName = LOWER(@appName)
    SET @appId = NULL

    SELECT @appId = AppId
    FROM [tempdb].dbo.ASPStateTempApplications
    WHERE AppName = @appName

    IF @appId IS NULL BEGIN
        BEGIN TRAN        

        SELECT @appId = AppId
        FROM [tempdb].dbo.ASPStateTempApplications WITH (TABLOCKX)
        WHERE AppName = @appName
        
        IF @appId IS NULL
        BEGIN
            EXEC GetHashCode @appName, @appId OUTPUT
            
            INSERT [tempdb].dbo.ASPStateTempApplications
            VALUES
            (@appId, @appName)
            
            IF @@ERROR = 2627 
            BEGIN
                DECLARE @dupApp tAppName
            
                SELECT @dupApp = RTRIM(AppName)
                FROM [tempdb].dbo.ASPStateTempApplications 
                WHERE AppId = @appId
                
                RAISERROR('SQL session state fatal error: hash-code collision between applications ''%s'' and ''%s''. Please rename the 1st application to resolve the problem.', 
                            18, 1, @appName, @dupApp)
            END
        END

        COMMIT
    END

    RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetStateItem
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempGetStateItem
            @id         tSessionId,
            @itemShort  tSessionItemShort OUTPUT,
            @locked     bit OUTPUT,
            @lockDate   datetime OUTPUT,
            @lockCookie int OUTPUT
        AS
            DECLARE @textptr AS tTextPtr
            DECLARE @length AS int
            DECLARE @now AS datetime
            SET @now = GETUTCDATE()

            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, @now), 
                @locked = Locked,
                @lockDate = LockDateLocal,
                @lockCookie = LockCookie,
                @itemShort = CASE @locked
                    WHEN 0 THEN SessionItemShort
                    ELSE NULL
                    END,
                @textptr = CASE @locked
                    WHEN 0 THEN TEXTPTR(SessionItemLong)
                    ELSE NULL
                    END,
                @length = CASE @locked
                    WHEN 0 THEN DATALENGTH(SessionItemLong)
                    ELSE NULL
                    END
            WHERE SessionId = @id
            IF @length IS NOT NULL BEGIN
                READTEXT [tempdb].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
            END

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetStateItem2
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempGetStateItem2
            @id         tSessionId,
            @itemShort  tSessionItemShort OUTPUT,
            @locked     bit OUTPUT,
            @lockAge    int OUTPUT,
            @lockCookie int OUTPUT
        AS
            DECLARE @textptr AS tTextPtr
            DECLARE @length AS int
            DECLARE @now AS datetime
            SET @now = GETUTCDATE()

            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, @now), 
                @locked = Locked,
                @lockAge = DATEDIFF(second, LockDate, @now),
                @lockCookie = LockCookie,
                @itemShort = CASE @locked
                    WHEN 0 THEN SessionItemShort
                    ELSE NULL
                    END,
                @textptr = CASE @locked
                    WHEN 0 THEN TEXTPTR(SessionItemLong)
                    ELSE NULL
                    END,
                @length = CASE @locked
                    WHEN 0 THEN DATALENGTH(SessionItemLong)
                    ELSE NULL
                    END
            WHERE SessionId = @id
            IF @length IS NOT NULL BEGIN
                READTEXT [tempdb].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
            END

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetStateItem3
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempGetStateItem3
            @id         tSessionId,
            @itemShort  tSessionItemShort OUTPUT,
            @locked     bit OUTPUT,
            @lockAge    int OUTPUT,
            @lockCookie int OUTPUT,
            @actionFlags int OUTPUT
        AS
            DECLARE @textptr AS tTextPtr
            DECLARE @length AS int
            DECLARE @now AS datetime
            SET @now = GETUTCDATE()

            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, @now), 
                @locked = Locked,
                @lockAge = DATEDIFF(second, LockDate, @now),
                @lockCookie = LockCookie,
                @itemShort = CASE @locked
                    WHEN 0 THEN SessionItemShort
                    ELSE NULL
                    END,
                @textptr = CASE @locked
                    WHEN 0 THEN TEXTPTR(SessionItemLong)
                    ELSE NULL
                    END,
                @length = CASE @locked
                    WHEN 0 THEN DATALENGTH(SessionItemLong)
                    ELSE NULL
                    END,

                /* If the Uninitialized flag (0x1) if it is set,
                   remove it and return InitializeItem (0x1) in actionFlags */
                Flags = CASE
                    WHEN (Flags & 1) <> 0 THEN (Flags & ~1)
                    ELSE Flags
                    END,
                @actionFlags = CASE
                    WHEN (Flags & 1) <> 0 THEN 1
                    ELSE 0
                    END
            WHERE SessionId = @id
            IF @length IS NOT NULL BEGIN
                READTEXT [tempdb].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
            END

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetStateItemExclusive
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempGetStateItemExclusive
            @id         tSessionId,
            @itemShort  tSessionItemShort OUTPUT,
            @locked     bit OUTPUT,
            @lockDate   datetime OUTPUT,
            @lockCookie int OUTPUT
        AS
            DECLARE @textptr AS tTextPtr
            DECLARE @length AS int
            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime

            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()
            
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, @now), 
                LockDate = CASE Locked
                    WHEN 0 THEN @now
                    ELSE LockDate
                    END,
                @lockDate = LockDateLocal = CASE Locked
                    WHEN 0 THEN @nowLocal
                    ELSE LockDateLocal
                    END,
                @lockCookie = LockCookie = CASE Locked
                    WHEN 0 THEN LockCookie + 1
                    ELSE LockCookie
                    END,
                @itemShort = CASE Locked
                    WHEN 0 THEN SessionItemShort
                    ELSE NULL
                    END,
                @textptr = CASE Locked
                    WHEN 0 THEN TEXTPTR(SessionItemLong)
                    ELSE NULL
                    END,
                @length = CASE Locked
                    WHEN 0 THEN DATALENGTH(SessionItemLong)
                    ELSE NULL
                    END,
                @locked = Locked,
                Locked = 1
            WHERE SessionId = @id
            IF @length IS NOT NULL BEGIN
                READTEXT [tempdb].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
            END

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetStateItemExclusive2
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempGetStateItemExclusive2
            @id         tSessionId,
            @itemShort  tSessionItemShort OUTPUT,
            @locked     bit OUTPUT,
            @lockAge    int OUTPUT,
            @lockCookie int OUTPUT
        AS
            DECLARE @textptr AS tTextPtr
            DECLARE @length AS int
            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime

            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()
            
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, @now), 
                LockDate = CASE Locked
                    WHEN 0 THEN @now
                    ELSE LockDate
                    END,
                LockDateLocal = CASE Locked
                    WHEN 0 THEN @nowLocal
                    ELSE LockDateLocal
                    END,
                @lockAge = CASE Locked
                    WHEN 0 THEN 0
                    ELSE DATEDIFF(second, LockDate, @now)
                    END,
                @lockCookie = LockCookie = CASE Locked
                    WHEN 0 THEN LockCookie + 1
                    ELSE LockCookie
                    END,
                @itemShort = CASE Locked
                    WHEN 0 THEN SessionItemShort
                    ELSE NULL
                    END,
                @textptr = CASE Locked
                    WHEN 0 THEN TEXTPTR(SessionItemLong)
                    ELSE NULL
                    END,
                @length = CASE Locked
                    WHEN 0 THEN DATALENGTH(SessionItemLong)
                    ELSE NULL
                    END,
                @locked = Locked,
                Locked = 1
            WHERE SessionId = @id
            IF @length IS NOT NULL BEGIN
                READTEXT [tempdb].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
            END

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetStateItemExclusive3
-- --------------------------------------------------
  
        CREATE PROCEDURE dbo.TempGetStateItemExclusive3  
            @id         tSessionId,  
            @itemShort  tSessionItemShort OUTPUT,  
            @locked     bit OUTPUT,  
            @lockAge    int OUTPUT,  
            @lockCookie int OUTPUT,  
            @actionFlags int OUTPUT  
        AS  
            DECLARE @textptr AS tTextPtr  
            DECLARE @length AS int  
            DECLARE @now AS datetime  
            DECLARE @nowLocal AS datetime  
  
            SET @now = GETUTCDATE()  
            SET @nowLocal = GETDATE()  
              
            UPDATE [tempdb].dbo.ASPStateTempSessions  
            SET Expires = DATEADD(n, Timeout, @now),   
                LockDate = CASE Locked  
                    WHEN 0 THEN @now  
                    ELSE LockDate  
                    END,  
                LockDateLocal = CASE Locked  
                    WHEN 0 THEN @nowLocal  
                    ELSE LockDateLocal  
                    END,  
                @lockAge = CASE Locked  
                    WHEN 0 THEN 0  
                    ELSE DATEDIFF(second, LockDate, @now)  
                    END,  
                @lockCookie = LockCookie = CASE Locked  
                    WHEN 0 THEN LockCookie + 1  
                    ELSE LockCookie  
                    END,  
                @itemShort = CASE Locked  
                    WHEN 0 THEN SessionItemShort  
                    ELSE NULL  
                    END,  
                @textptr = CASE Locked  
                    WHEN 0 THEN TEXTPTR(SessionItemLong)  
                    ELSE NULL  
                    END,  
                @length = CASE Locked  
                    WHEN 0 THEN DATALENGTH(SessionItemLong)  
                    ELSE NULL  
                    END,  
                @locked = Locked,  
                Locked = 1,  
  
                /* If the Uninitialized flag (0x1) if it is set,  
                   remove it and return InitializeItem (0x1) in actionFlags */  
                Flags = CASE  
                    WHEN (Flags & 1) <> 0 THEN (Flags & ~1)  
                    ELSE Flags  
                    END,  
                @actionFlags = CASE  
                    WHEN (Flags & 1) <> 0 THEN 1  
                    ELSE 0  
                    END  
            WHERE SessionId = @id  
            IF @length IS NOT NULL BEGIN  
                READTEXT [tempdb].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length  
            END  
  
            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempGetVersion
-- --------------------------------------------------

/*****************************************************************************/

CREATE PROCEDURE dbo.TempGetVersion
    @ver      char(10) OUTPUT
AS
    SELECT @ver = "2"
    RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempInsertStateItemLong
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempInsertStateItemLong
            @id         tSessionId,
            @itemLong   tSessionItemLong,
            @timeout    int
        AS    
            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime
            
            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()

            INSERT [tempdb].dbo.ASPStateTempSessions 
                (SessionId, 
                 SessionItemLong, 
                 Timeout, 
                 Expires, 
                 Locked, 
                 LockDate,
                 LockDateLocal,
                 LockCookie) 
            VALUES 
                (@id, 
                 @itemLong, 
                 @timeout, 
                 DATEADD(n, @timeout, @now), 
                 0, 
                 @now,
                 @nowLocal,
                 1)

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempInsertStateItemShort
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempInsertStateItemShort
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int
        AS    

            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime
            
            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()

            INSERT [tempdb].dbo.ASPStateTempSessions 
                (SessionId, 
                 SessionItemShort, 
                 Timeout, 
                 Expires, 
                 Locked, 
                 LockDate,
                 LockDateLocal,
                 LockCookie) 
            VALUES 
                (@id, 
                 @itemShort, 
                 @timeout, 
                 DATEADD(n, @timeout, @now), 
                 0, 
                 @now,
                 @nowLocal,
                 1)

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempInsertUninitializedItem
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempInsertUninitializedItem
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int
        AS    

            DECLARE @now AS datetime
            DECLARE @nowLocal AS datetime
            
            SET @now = GETUTCDATE()
            SET @nowLocal = GETDATE()

            INSERT [tempdb].dbo.ASPStateTempSessions 
                (SessionId, 
                 SessionItemShort, 
                 Timeout, 
                 Expires, 
                 Locked, 
                 LockDate,
                 LockDateLocal,
                 LockCookie,
                 Flags) 
            VALUES 
                (@id, 
                 @itemShort, 
                 @timeout, 
                 DATEADD(n, @timeout, @now), 
                 0, 
                 @now,
                 @nowLocal,
                 1,
                 1)

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempReleaseStateItemExclusive
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempReleaseStateItemExclusive
            @id         tSessionId,
            @lockCookie int
        AS
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()), 
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempRemoveStateItem
-- --------------------------------------------------

    CREATE PROCEDURE dbo.TempRemoveStateItem
        @id     tSessionId,
        @lockCookie int
    AS
        DELETE [tempdb].dbo.ASPStateTempSessions
        WHERE SessionId = @id AND LockCookie = @lockCookie
        RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempResetTimeout
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempResetTimeout
            @id     tSessionId
        AS
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE())
            WHERE SessionId = @id
            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempUpdateStateItemLong
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempUpdateStateItemLong
            @id         tSessionId,
            @itemLong   tSessionItemLong,
            @timeout    int,
            @lockCookie int
        AS    
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()), 
                SessionItemLong = @itemLong,
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempUpdateStateItemLongNullShort
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempUpdateStateItemLongNullShort
            @id         tSessionId,
            @itemLong   tSessionItemLong,
            @timeout    int,
            @lockCookie int
        AS    
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()), 
                SessionItemLong = @itemLong, 
                SessionItemShort = NULL,
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempUpdateStateItemShort
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempUpdateStateItemShort
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int,
            @lockCookie int
        AS    
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()), 
                SessionItemShort = @itemShort, 
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempUpdateStateItemShortNullLong
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempUpdateStateItemShortNullLong
            @id         tSessionId,
            @itemShort  tSessionItemShort,
            @timeout    int,
            @lockCookie int
        AS    
            UPDATE [tempdb].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, Timeout, GETUTCDATE()), 
                SessionItemShort = @itemShort, 
                SessionItemLong = NULL, 
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0

GO

