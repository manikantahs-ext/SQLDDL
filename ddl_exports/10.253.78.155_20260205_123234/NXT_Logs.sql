-- DDL Export
-- Server: 10.253.78.155
-- Database: NXT_Logs
-- Exported: 2026-02-05T12:32:35.371099

USE NXT_Logs;
GO

-- --------------------------------------------------
-- INDEX dbo.Error_log
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [ix_Error_log_ModuleName] ON [dbo].[Error_log] ([ModuleName], [createdDate], [Controller], [Action], [Event])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.delete_Rec_Error_log
-- --------------------------------------------------

CREATE procedure delete_Rec_Error_log
as
begin

delete from [dbo].[Error_log]
where createdDate<Dateadd(MM,-7,getdate())


END

GO

-- --------------------------------------------------
-- TABLE dbo.Error_log
-- --------------------------------------------------
CREATE TABLE [dbo].[Error_log]
(
    [ProjectName] VARCHAR(20) NULL,
    [ModuleName] VARCHAR(300) NULL,
    [Controller] VARCHAR(50) NULL,
    [ErrorMsg] VARCHAR(MAX) NULL,
    [Action] VARCHAR(50) NULL,
    [API_URL] VARCHAR(3000) NULL,
    [Request] VARCHAR(MAX) NULL,
    [Response] VARCHAR(MAX) NULL,
    [StackTrace] VARCHAR(MAX) NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [createdDate] DATETIME NULL,
    [Event] VARCHAR(20) NULL,
    [IPadress] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NotificationNXT
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NotificationNXT]
(
    [NotificationID] INT NULL,
    [sub_broker] VARCHAR(200) NULL,
    [NotificationText] VARCHAR(7000) NULL,
    [NotificationType] VARCHAR(70) NULL,
    [Individualview] VARCHAR(2) NULL,
    [IndividualviewDate] DATETIME NULL,
    [Notification_9] VARCHAR(2) NULL,
    [Notification_Date_9] DATETIME NULL,
    [CreatedBy] VARCHAR(200) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] VARCHAR(200) NULL,
    [UpdatedDate] DATETIME NULL,
    [CLTCODEDupl] VARCHAR(8000) NULL,
    [URL] VARCHAR(8000) NULL,
    [area] VARCHAR(80) NULL,
    [controller] VARCHAR(80) NULL,
    [action] VARCHAR(80) NULL,
    [CampaignId] VARCHAR(100) NULL,
    [areaname] VARCHAR(50) NULL,
    [IsInActive] BIT NULL,
    [StartDate] DATE NULL,
    [StartTime] TIME NULL,
    [ExpiryDate] DATE NULL,
    [ExpiryTime] TIME NULL,
    [QueryParameter] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NotificationNXT_Bkp18Feb2022
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NotificationNXT_Bkp18Feb2022]
(
    [NotificationID] INT IDENTITY(1,1) NOT NULL,
    [sub_broker] VARCHAR(200) NULL,
    [NotificationText] VARCHAR(7000) NULL,
    [NotificationType] VARCHAR(70) NULL,
    [Individualview] VARCHAR(2) NULL,
    [IndividualviewDate] DATETIME NULL,
    [Notification_9] VARCHAR(2) NULL,
    [Notification_Date_9] DATETIME NULL,
    [CreatedBy] VARCHAR(200) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] VARCHAR(200) NULL,
    [UpdatedDate] DATETIME NULL,
    [CLTCODEDupl] VARCHAR(8000) NULL,
    [URL] VARCHAR(8000) NULL,
    [area] VARCHAR(80) NULL,
    [controller] VARCHAR(80) NULL,
    [action] VARCHAR(80) NULL,
    [CampaignId] VARCHAR(100) NULL,
    [areaname] VARCHAR(50) NULL
);

GO

