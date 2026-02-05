-- DDL Export
-- Server: 10.254.33.61
-- Database: NXTAuthSession
-- Exported: 2026-02-05T11:35:16.719469

USE NXTAuthSession;
GO

-- --------------------------------------------------
-- INDEX dbo.ASPStateTempApplications
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Index_AppName] ON [dbo].[ASPStateTempApplications] ([AppName])

GO

-- --------------------------------------------------
-- INDEX dbo.ASPStateTempSessions
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [Index_Expires] ON [dbo].[ASPStateTempSessions] ([Expires])

GO

-- --------------------------------------------------
-- INDEX dbo.ASPStateTempSessions
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_Session] ON [dbo].[ASPStateTempSessions] ([SessionId])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_NXTSession
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ix_tbl_NXTSession_Session] ON [dbo].[tbl_NXTSession] ([SessionId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ASPStateTempApplications
-- --------------------------------------------------
ALTER TABLE [dbo].[ASPStateTempApplications] ADD CONSTRAINT [PK__ASPState__8E2CF7F93CD542EC] PRIMARY KEY ([AppId])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ASPStateTempSessions
-- --------------------------------------------------
ALTER TABLE [dbo].[ASPStateTempSessions] ADD CONSTRAINT [PK__ASPState__C9F49290650CB226] PRIMARY KEY ([SessionId])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CreateTempTables
-- --------------------------------------------------

        CREATE PROCEDURE dbo.CreateTempTables
        AS
            CREATE TABLE [NXTAuthSession].dbo.ASPStateTempSessions (
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

            CREATE NONCLUSTERED INDEX Index_Expires ON [NXTAuthSession].dbo.ASPStateTempSessions(Expires)

            CREATE TABLE [NXTAuthSession].dbo.ASPStateTempApplications (
                AppId               int             NOT NULL PRIMARY KEY,
                AppName             char(280)       NOT NULL,
            ) 

            CREATE NONCLUSTERED INDEX Index_AppName ON [NXTAuthSession].dbo.ASPStateTempApplications(AppName)

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.DeleteExpiredSessions
-- --------------------------------------------------

        CREATE PROCEDURE dbo.DeleteExpiredSessions
        AS
            SET NOCOUNT ON
            SET DEADLOCK_PRIORITY LOW 

            DECLARE @now datetime
            SET @now = GETUTCDATE() 

            CREATE TABLE #tblExpiredSessions 
            ( 
                SessionId nvarchar(88) NOT NULL PRIMARY KEY
            )

            INSERT #tblExpiredSessions (SessionId)
                SELECT SessionId
                FROM [NXTAuthSession].dbo.ASPStateTempSessions WITH (READUNCOMMITTED)
                WHERE Expires < @now

            IF @@ROWCOUNT <> 0 
            BEGIN 
                DECLARE ExpiredSessionCursor CURSOR LOCAL FORWARD_ONLY READ_ONLY
                FOR SELECT SessionId FROM #tblExpiredSessions 

                DECLARE @SessionId nvarchar(88)

                OPEN ExpiredSessionCursor

                FETCH NEXT FROM ExpiredSessionCursor INTO @SessionId

                WHILE @@FETCH_STATUS = 0 
                    BEGIN
                        DELETE FROM [NXTAuthSession].dbo.ASPStateTempSessions WHERE SessionId = @SessionId AND Expires < @now
                        FETCH NEXT FROM ExpiredSessionCursor INTO @SessionId
                    END

                CLOSE ExpiredSessionCursor

                DEALLOCATE ExpiredSessionCursor

            END 

            DROP TABLE #tblExpiredSessions

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
-- PROCEDURE dbo.TempGetAppID
-- --------------------------------------------------

    CREATE PROCEDURE dbo.TempGetAppID
    @appName    tAppName,
    @appId      int OUTPUT
    AS
    SET @appName = LOWER(@appName)
    SET @appId = NULL

    SELECT @appId = AppId
    FROM [NXTAuthSession].dbo.ASPStateTempApplications
    WHERE AppName = @appName

    IF @appId IS NULL BEGIN
        BEGIN TRAN        

        SELECT @appId = AppId
        FROM [NXTAuthSession].dbo.ASPStateTempApplications WITH (TABLOCKX)
        WHERE AppName = @appName
        
        IF @appId IS NULL
        BEGIN
            EXEC GetHashCode @appName, @appId OUTPUT
            
            INSERT [NXTAuthSession].dbo.ASPStateTempApplications
            VALUES
            (@appId, @appName)
            
            IF @@ERROR = 2627 
            BEGIN
                DECLARE @dupApp tAppName
            
                SELECT @dupApp = RTRIM(AppName)
                FROM [NXTAuthSession].dbo.ASPStateTempApplications 
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

            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
                READTEXT [NXTAuthSession].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
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

            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
                READTEXT [NXTAuthSession].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
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

            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
                READTEXT [NXTAuthSession].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
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
            
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
                READTEXT [NXTAuthSession].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
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
            
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
                READTEXT [NXTAuthSession].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
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
            
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
                READTEXT [NXTAuthSession].dbo.ASPStateTempSessions.SessionItemLong @textptr 0 @length
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

            INSERT [NXTAuthSession].dbo.ASPStateTempSessions 
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

            INSERT [NXTAuthSession].dbo.ASPStateTempSessions 
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

            INSERT [NXTAuthSession].dbo.ASPStateTempSessions 
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
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
        DELETE [NXTAuthSession].dbo.ASPStateTempSessions
        WHERE SessionId = @id AND LockCookie = @lockCookie
        RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.TempResetTimeout
-- --------------------------------------------------

        CREATE PROCEDURE dbo.TempResetTimeout
            @id     tSessionId
        AS
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
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
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()), 
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
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()), 
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
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()), 
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
            UPDATE [NXTAuthSession].dbo.ASPStateTempSessions
            SET Expires = DATEADD(n, @timeout, GETUTCDATE()), 
                SessionItemShort = @itemShort, 
                SessionItemLong = NULL, 
                Timeout = @timeout,
                Locked = 0
            WHERE SessionId = @id AND LockCookie = @lockCookie

            RETURN 0

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_AMD_ASPStateTempSessions
-- --------------------------------------------------

CREATE PROCEDURE USP_AMD_ASPStateTempSessions
AS
BEGIN

INSERT INTO ASPStateTempSessionsHistory
			(
			SessionId
			,Created
			,Expires
			,LockDate
			,LockDateLocal
			,LockCookie
			,Timeout
			,Locked
			,SessionItemShort
			,SessionItemLong
			,Flags
			)

				SELECT 
					SessionId
					,Created
					,Expires
					,LockDate
					,LockDateLocal
					,LockCookie
					,Timeout
					,Locked
					,SessionItemShort
					,SessionItemLong
					,Flags
				FROM ASPStateTempSessions

TRUNCATE TABLE ASPStateTempSessions

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_DELETE_tbl_NXTSession
-- --------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_DELETE_tbl_NXTSession 1
-----------------------------------------------------------
MODIFICATION-

*/

CREATE PROCEDURE [dbo].[USP_DELETE_tbl_NXTSession]
(
	@SessionId	NVARCHAR(MAX)
)
AS
BEGIN
SET NOCOUNT ON

DELETE FROM tbl_NXTSession WHERE SessionId = @SessionId

SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findinJobs
-- --------------------------------------------------
Create Procedure usp_findinJobs(@Str as varchar(500))

as

select b.name,

Case when b.enabled=1 then 'Active' else 'Deactive' end as Status,

date_created,date_modified,a.step_id,a.step_name,a.command

from msdb.dbo.sysjobsteps a, msdb.dbo.sysjobs b

where command like '%'+@Str+'%'

and a.job_id=b.job_id

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FINDINUSP
-- --------------------------------------------------

CREATE PROCEDURE USP_FINDINUSP                  

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

 PRINT @STR                

  EXEC(@STR)                

        

SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_ALL_DATA_NXTSession
-- --------------------------------------------------

/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_GET_ALL_DATA_NXTSession 1
-----------------------------------------------------------
MODIFICATION-

*/

CREATE PROCEDURE [dbo].[USP_GET_ALL_DATA_NXTSession]
(
	@SessionId nVarchar(MAX)
)
AS
BEGIN
SET NOCOUNT ON

---return 0

DECLARE @SessionId_l VARCHAR(500)
 SET @SessionId_l = @SessionId 

SELECT 
	Id,
	SessionId,
	Created,
	Expires,
	SessionDataValue
FROM 
	tbl_NXTSession with (nolock)
WHERE
	SessionId = @SessionId_l

SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_get_logout_session
-- --------------------------------------------------


/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC usp_get_logout_session 'Session_HOET_3a582c5d-0cbe-4521-9181-b284a99fd09e'
-----------------------------------------------------------
MODIFICATION-

*/
CREATE PROCEDURE [dbo].[usp_get_logout_session]
(
	@Key VARCHAR(500)
)
AS
BEGIN

---RETURN 0

DELETE
FROM 
	tbl_NXTSession
WHERE 
	SessionId like @Key+'%'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_get_logout_session_BACKUP18dEC2018
-- --------------------------------------------------

/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC usp_get_logout_session 'Session_HOET_3a582c5d-0cbe-4521-9181-b284a99fd09e'
-----------------------------------------------------------
MODIFICATION-

*/
CREATE PROCEDURE [dbo].[usp_get_logout_session_BACKUP18dEC2018]
(
	@Key VARCHAR(max)
)
AS
BEGIN

DELETE
FROM 
	tbl_NXTSession
WHERE 
	SessionId like @Key+'%'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_SESSION_DETAILS_DATEWISE
-- --------------------------------------------------


/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_GET_SESSION_DETAILS_DATEWISE '2018-08-16', '2018-08-21'
-----------------------------------------------------------
MODIFICATION-

*/

CREATE PROCEDURE [dbo].[USP_GET_SESSION_DETAILS_DATEWISE]
(
	@FROM_DATE VARCHAR(50),
	@TO_DATE VARCHAR(50)
)
AS
BEGIN
SET NOCOUNT ON

SELECT 
	id,
	SessionId,
	Created,
	Expires,
	SessionDataValue
FROM
	tbl_NXTSession
WHERE
	CAST(Created AS date) BETWEEN @FROM_DATE AND @TO_DATE
SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_TO_DELETE_EXPIRES_SESSION
-- --------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GET_TO_DELETE_EXPIRES_SESSION]
AS
BEGIN
SET NOCOUNT ON

--select * from 

Insert into [tbl_NXTSessionHistory]
select *,GETDATE() from tbl_NXTSession
WHERE
	Expires < GETDATE()



DELETE
FROM tbl_NXTSession
WHERE
	Expires < GETDATE()
	  --convert(date,Created)<dateadd(day,-1,convert(date,getdate()))


SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GET_TO_RESET_EXPIRE_TIMEOUT
-- --------------------------------------------------


/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_GET_TO_RESET_EXPIRE_TIMEOUT 123 
-----------------------------------------------------------
MODIFICATION-

*/

CREATE PROCEDURE [dbo].[USP_GET_TO_RESET_EXPIRE_TIMEOUT]
(
	@MINUTES INT
)
AS
BEGIN
SET NOCOUNT ON

DELETE
FROM tbl_NXTSession
WHERE
	Expires < GETDATE()+@MINUTES

SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INSERT_tbl_NXTSession
-- --------------------------------------------------

/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_INSERT_tbl_NXTSession 2,'2018-08-07 15:45:25.807','2018-08-07 15:45:25.807','2018-08-07 15:45:25.807',0
-----------------------------------------------------------
MODIFICATION-

*/

CREATE PROCEDURE [dbo].[USP_INSERT_tbl_NXTSession]
(
	@SessionId	VARCHAR(500),
	@Created	DATETIME,
	@Expires	DATETIME,
	@SessionDataValue VARCHAR(max),/*@SessionDataValue VARCHAR(500),*/
	@STATUS INT OUTPUT
)
AS
BEGIN
SET NOCOUNT ON

---RETURN 0 

DECLARE @ROW_COUNT INT


--return 0 


	UPDATE tbl_NXTSession
	SET Created = @Created, Expires = @Expires, SessionDataValue = @SessionDataValue
	WHERE SessionId = @SessionId

	SET @ROW_COUNT = @@ROWCOUNT

	IF (@ROW_COUNT =0)
	BEGIN
		INSERT INTO tbl_NXTSession (SessionId,Created,Expires,SessionDataValue)
		VALUES(@SessionId, @Created, @Expires, @SessionDataValue)
		SET @ROW_COUNT = @@ROWCOUNT
	END


IF(@ROW_COUNT > 0)
SET @STATUS = 1  --TRUE
ELSE
SET @STATUS = 0  -- FALSE

SELECT @STATUS AS STATUS

SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_INSERT_tbl_NXTSession_BKP18dEC2018
-- --------------------------------------------------

/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_INSERT_tbl_NXTSession 2,'2018-08-07 15:45:25.807','2018-08-07 15:45:25.807','2018-08-07 15:45:25.807',0
-----------------------------------------------------------
MODIFICATION-

*/

CREATE  PROCEDURE [dbo].[USP_INSERT_tbl_NXTSession_BKP18dEC2018]
(
	@SessionId	NVARCHAR(MAX),
	@Created	DATETIME,
	@Expires	DATETIME,
	@SessionDataValue Varchar(MAX),
	@STATUS INT OUTPUT
)
AS
BEGIN
SET NOCOUNT ON


--return 0 

IF NOT EXISTS(SELECT * FROM tbl_NXTSession with (nolock) WHERE SessionId = @SessionId)
BEGIN
	INSERT INTO tbl_NXTSession (SessionId,Created,Expires,SessionDataValue)
	VALUES(@SessionId, @Created, @Expires, @SessionDataValue)
END

ELSE
BEGIN
	UPDATE tbl_NXTSession
	SET Created = @Created, Expires = @Expires, SessionDataValue = @SessionDataValue
	WHERE SessionId = @SessionId
END

IF(@@ROWCOUNT > 0)
SET @STATUS = 1  --TRUE
ELSE
SET @STATUS = 0  -- FALSE

SELECT @STATUS AS STATUS

SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_UPDATE_tbl_NXTSession
-- --------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
-----------------------------------------------------------
CREATED BY - Neeta Patil
CREATED ON - 07/08/2018
EXEC USP_UPDATE_tbl_NXTSession 1,'2018-08-07 15:50:47.723','2018-08-07 15:50:47.723','2018-08-07 15:50:47.723'
-----------------------------------------------------------
MODIFICATION-

*/

CREATE PROCEDURE [dbo].[USP_UPDATE_tbl_NXTSession]
(
	@SessionId	NVARCHAR(MAX),
	@Created	DATETIME,
	@Expires	DATETIME,
	@SessionDataValue Varchar(MAX)
)
AS
BEGIN
SET NOCOUNT ON

UPDATE tbl_NXTSession 
SET
	Created = @Created,
	Expires = @Expires,
	SessionDataValue = @SessionDataValue
	
Where
	SessionId = @SessionId

SET NOCOUNT OFF

END

GO

-- --------------------------------------------------
-- TABLE dbo.ASPStateTempApplications
-- --------------------------------------------------
CREATE TABLE [dbo].[ASPStateTempApplications]
(
    [AppId] INT NOT NULL,
    [AppName] CHAR(280) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASPStateTempSessions
-- --------------------------------------------------
CREATE TABLE [dbo].[ASPStateTempSessions]
(
    [SessionId] NVARCHAR(88) NOT NULL,
    [Created] DATETIME NOT NULL DEFAULT (getutcdate()),
    [Expires] DATETIME NOT NULL,
    [LockDate] DATETIME NOT NULL,
    [LockDateLocal] DATETIME NOT NULL,
    [LockCookie] INT NOT NULL,
    [Timeout] INT NOT NULL,
    [Locked] BIT NOT NULL,
    [SessionItemShort] VARBINARY(7000) NULL,
    [SessionItemLong] IMAGE NULL,
    [Flags] INT NOT NULL DEFAULT ((0))
);

GO

-- --------------------------------------------------
-- TABLE dbo.ASPStateTempSessionsHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[ASPStateTempSessionsHistory]
(
    [SessionId] NVARCHAR(88) NOT NULL,
    [Created] DATETIME NOT NULL,
    [Expires] DATETIME NOT NULL,
    [LockDate] DATETIME NOT NULL,
    [LockDateLocal] DATETIME NOT NULL,
    [LockCookie] INT NOT NULL,
    [Timeout] INT NOT NULL,
    [Locked] BIT NOT NULL,
    [SessionItemShort] VARBINARY(7000) NULL,
    [SessionItemLong] IMAGE NULL,
    [Flags] INT NOT NULL,
    [CreatedDate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NXTSession
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NXTSession]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [SessionId] VARCHAR(500) NULL,
    [Created] DATETIME NOT NULL,
    [Expires] DATETIME NOT NULL,
    [SessionDataValue] VARCHAR(MAX) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NXTSessionHistory
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NXTSessionHistory]
(
    [Id] INT NOT NULL,
    [SessionId] VARCHAR(MAX) NOT NULL,
    [Created] DATETIME NOT NULL,
    [Expires] DATETIME NOT NULL,
    [SessionDataValue] VARCHAR(MAX) NULL,
    [EntryDate] DATETIME NULL
);

GO

