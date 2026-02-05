-- DDL Export
-- Server: 10.253.33.87
-- Database: Test
-- Exported: 2026-02-05T12:29:51.631852

USE Test;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_BSERefno_File
-- --------------------------------------------------
CREATE PROC [dbo].[USP_BSERefno_File]         
             
AS               
BEGIN   
      
      
      
 insert into tbl_BSERefno_File_Hist(TX,ScripId, Qty,RevQty,Limit_Rate,Trig_Rate ,Time,OrderId,ClientId ,InstId ,Retain,C,Remarks,UpdateDate)        
    select TX,ScripId,Qty,RevQty,Limit_Rate, Trig_Rate,Time,OrderId,ClientId ,InstId,Retain ,C ,Remarks,GETDATE()from tbl_BSERefno_File   
        --select 'TX','ScripId','Qty','RevQty','Limit_Rate', 'Trig_Rate','Time','OrderId','ClientId' ,'InstId','Retain' ,'C' ,'Remark's,GETDATE()from tbl_BSERefno_File   
      
 --truncate table tbl_BSERefno_File  
      
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_GSM_Series_Upload
-- --------------------------------------------------




    
       
CREATE PROC [dbo].[USP_GSM_Series_Upload]           
(            
 @FileName VARCHAR(50) = NULL ,          
 @Total int out   
         
)                       
AS                 
BEGIN            
         
        
    Declare @filePath varchar(500)=''            
    --Declare @FileName varchar(500)='uploadAdvChart.csv'            
    set @filePath ='\\196.1.115.183\D$\UploadAdvChart\'+@FileName+''            
    --set @filePath ='\\196.1.115.183\D$\UploadAdvChart\GSM_Script3.csv'          
    DECLARE @sql NVARCHAR(4000) = 'BULK INSERT temp_GSM_Series FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=1 )';            
    EXEC(@sql)            
    print (@sql)            
    print @filePath            
                  
       
               select Script_Cd,SEGMENT,Buy_Sell,Stage     
               into #temp    
               from  temp_GSM_Series    
                       
      select t.Script_Cd,t.Segment,t.Buy_Sell,t.Stage     
      into  #aa    
      from tbl_GSM_Series gm     
      inner join #temp t    
               On gm.Scrip_Cd=t.Script_Cd    
                  IF  (select count(*) from #aa ) > 0    
      begin     
        print 'Update '    
       update tbl_GSM_Series  set Stage=b.Stage,UpdateDate=GETDATE() from              
        (                            
         select Script_Cd,SEGMENT,Buy_Sell,Stage,GETDATE() as UpdateDate  from #aa                           
        )     
        b where tbl_GSM_Series.Scrip_Cd=b.Script_Cd     
      END    
    
       
                  --select t.Script_Cd,t.Segment,t.Buy_Sell,t.Stage    
                  --into #bb      
                  --from tbl_GSM_Series gm     
                  --right join #temp t    
                  --On gm.Scrip_Cd=t.Script_Cd    
                  --where gm.Scrip_Cd is null    
                      
                      
                    SELECT  t.Script_Cd,t.Segment,t.Buy_Sell,t.Stage    
                    into  #bb      
     FROM    #temp t     
     WHERE   t.Script_Cd  NOT IN      
     (      
     SELECT  gm.Scrip_Cd      
     FROM    tbl_GSM_Series gm      
     )      
                         
                     if (select count(*) from #bb)> 0       
        begin     
          print 'Insert '    
         --tbl_GSM_Series where Scrip_Cd='519486'    
         --delete from tbl_GSM_Series where Srno='179'    
          insert into tbl_GSM_Series(Scrip_Cd,Segment,Buy_sell,stage,UpdateDate)     
          select Script_Cd,Segment,Buy_sell,Stage,GETDATE() from #bb    
         
        END    
       -- set total =  count(*) from #temp    
        drop table #temp    
        drop table #aa    
        drop table #bb    
        truncate table temp_GSM_Series    
                         
END    
       
--  tbl_GSM_Series where Scrip_Cd in('524210',    
--'531699',    
--'zota','519485')

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NSERefno_upload
-- --------------------------------------------------


  
  
    
      
      
    
--[USP_NSERefno_upload]  --    
CREATE PROC [dbo].[USP_NSERefno_upload]       
(        
 @FileName VARCHAR(50) = NULL ,      
 @Total int out         
)                   
AS             
BEGIN        
--select * from dbo.TBL_ADVCHART_ACTIVATE       
      
    truncate table tbl_NSERefno_upload    
   Declare @filePath varchar(500)=''        
   --Declare @FileName varchar(500)='uploadAdvChart.csv'        
  set @filePath ='\\196.1.115.183\D$\UploadAdvChart\'+@FileName+''        
  -- set @filePath ='\\196.1.115.183\D$\UploadAdvChart\NSE_REF_1304ORD11.txt'      
   DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_NSERefno_upload FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=1)';    
    --DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_BSERefno_upload FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR =''|'', ROWTERMINATOR =''\n'',FirstRow=1 )';        
   EXEC(@sql)        
   print (@sql)        
   print @filePath        
       
       
           
    insert into tbl_NSERefno_upload_Hist(OrderNo,Order_Status,Sysbol,Series,Security_Name,Instrument_Type,Book_Type,Market_Type,UserId,Branch_Id,  
           Buy_Sell,DQ,DQ_Remaining,Order_Qty,MF_Qty,AON_Indicator,Quantity_Price,PRO_CLI,Price,TM_Id,Order_Type,GTD,  
           Order_Duration,PRO_Client,Client_AC,Participant_Code,Auction_Part_Type,Auction_No,Sett_Period,Order_Modified_Dt_Time,  
           Credit_Rating,Remarks,Order_Entry_Dt_Time,CP_ID,updateDate)   
    select OrderNo,Order_Status,Sysbol,Series,Security_Name,Instrument_Type,Book_Type,Market_Type,UserId,Branch_Id,Buy_Sell,    
     DQ,DQ_Remaining,Order_Qty,MF_Qty,AON_Indicator,Quantity_Price,PRO_CLI,Price,TM_Id,Order_Type,GTD,Order_Duration,    
     PRO_Client,Client_AC,Participant_Code,Auction_Part_Type,Auction_No,Sett_Period,Order_Modified_Dt_Time,Credit_Rating,    
     Remarks,Order_Entry_Dt_Time,CP_ID,GETDATE()    
    from tbl_NSERefno_upload   
      
    select count(*) from  tbl_NSERefno_upload_Hist               
             
                    
END

GO

-- --------------------------------------------------
-- TABLE dbo.DISRequest
-- --------------------------------------------------
CREATE TABLE [dbo].[DISRequest]
(
    [inst_id] NVARCHAR(50) NOT NULL,
    [REQUESTDATE] DATE NOT NULL,
    [EXECUTIONDATE] DATE NOT NULL,
    [trans_descp] NVARCHAR(50) NOT NULL,
    [SLIPNO] INT NOT NULL,
    [ACCOUNTNO] DATETIME2 NOT NULL,
    [ACCOUNTNAME] NVARCHAR(50) NOT NULL,
    [QUANTITY] SMALLINT NOT NULL,
    [DUAL_CHECKER] NVARCHAR(1) NULL,
    [mkr] MONEY NOT NULL,
    [mkr_dt] DATETIME2 NOT NULL,
    [ORDBY] TINYINT NOT NULL,
    [ISIN_NAME] NVARCHAR(50) NOT NULL,
    [ISIN] NVARCHAR(50) NOT NULL,
    [dptdc_request_dt] NVARCHAR(50) NOT NULL,
    [Amt_charged] TINYINT NOT NULL,
    [outstand_amt] FLOAT NOT NULL,
    [mkt_type] NVARCHAR(1) NULL,
    [other_mkt_type] NVARCHAR(1) NULL,
    [settlementno] NVARCHAR(1) NULL,
    [othersettmno] NVARCHAR(1) NULL,
    [cmbp] NVARCHAR(1) NULL,
    [counter_account] NVARCHAR(1) NULL,
    [counter_dpid] NVARCHAR(1) NULL,
    [Status1] NVARCHAR(50) NOT NULL,
    [auth_rmks] NVARCHAR(1) NULL,
    [checker1] MONEY NOT NULL,
    [checker1_dt] DATETIME2 NOT NULL,
    [checker2] NVARCHAR(1) NULL,
    [checker2_dt] NVARCHAR(1) NULL,
    [slip_reco] NVARCHAR(1) NULL,
    [image_scan] NVARCHAR(1) NULL,
    [scan_dt] NVARCHAR(1) NULL,
    [dptdc_rmks] NVARCHAR(1) NULL,
    [backoffice_code] NVARCHAR(1) NULL,
    [reason] NVARCHAR(1) NULL,
    [recon_datetime] NVARCHAR(1) NULL,
    [batchno] NVARCHAR(1) NULL,
    [RejectionDate] NVARCHAR(1) NULL,
    [courier] NVARCHAR(1) NULL,
    [podno] NVARCHAR(1) NULL,
    [dispdate] NVARCHAR(1) NULL,
    [Rate] NVARCHAR(1) NULL,
    [Valuation] TINYINT NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSERefno_File
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSERefno_File]
(
    [TX] VARCHAR(10) NULL,
    [ScripId] VARCHAR(100) NULL,
    [Qty] VARCHAR(10) NULL,
    [RevQty] VARCHAR(10) NULL,
    [Limit_Rate] VARCHAR(10) NULL,
    [Trig_Rate] VARCHAR(10) NULL,
    [Time] VARCHAR(20) NULL,
    [OrderId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(20) NULL,
    [InstId] VARCHAR(20) NULL,
    [Retain] VARCHAR(50) NULL,
    [C] VARCHAR(10) NULL,
    [Remarks] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_BSERefno_File_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_BSERefno_File_Hist]
(
    [TX] VARCHAR(10) NULL,
    [ScripId] VARCHAR(100) NULL,
    [Qty] VARCHAR(10) NULL,
    [RevQty] VARCHAR(10) NULL,
    [Limit_Rate] VARCHAR(10) NULL,
    [Trig_Rate] VARCHAR(10) NULL,
    [Time] VARCHAR(20) NULL,
    [OrderId] VARCHAR(50) NULL,
    [ClientId] VARCHAR(20) NULL,
    [InstId] VARCHAR(20) NULL,
    [Retain] VARCHAR(50) NULL,
    [C] VARCHAR(10) NULL,
    [Remarks] VARCHAR(100) NULL,
    [UpdateDate] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_GSM_Series
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_GSM_Series]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Scrip_Cd] VARCHAR(100) NULL,
    [Segment] VARCHAR(100) NULL,
    [Buy_Sell] VARCHAR(5) NULL,
    [Stage] VARCHAR(10) NULL,
    [UpdateDate] VARCHAR(50) NULL,
    [UpdateBy] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSERefno_upload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSERefno_upload]
(
    [OrderNo] VARCHAR(20) NULL,
    [Order_Status] VARCHAR(10) NULL,
    [Sysbol] VARCHAR(10) NULL,
    [Series] VARCHAR(10) NULL,
    [Security_Name] VARCHAR(100) NULL,
    [Instrument_Type] VARCHAR(10) NULL,
    [Book_Type] VARCHAR(10) NULL,
    [Market_Type] VARCHAR(10) NULL,
    [UserId] VARCHAR(10) NULL,
    [Branch_Id] VARCHAR(10) NULL,
    [Buy_Sell] VARCHAR(10) NULL,
    [DQ] VARCHAR(10) NULL,
    [DQ_Remaining] VARCHAR(10) NULL,
    [Order_Qty] VARCHAR(10) NULL,
    [MF_Qty] VARCHAR(10) NULL,
    [AON_Indicator] VARCHAR(10) NULL,
    [Quantity_Price] VARCHAR(50) NULL,
    [PRO_CLI] VARCHAR(10) NULL,
    [Price] VARCHAR(10) NULL,
    [TM_Id] VARCHAR(10) NULL,
    [Order_Type] VARCHAR(10) NULL,
    [GTD] VARCHAR(50) NULL,
    [Order_Duration] VARCHAR(10) NULL,
    [PRO_Client] VARCHAR(20) NULL,
    [Client_AC] VARCHAR(10) NULL,
    [Participant_Code] VARCHAR(50) NULL,
    [Auction_Part_Type] VARCHAR(10) NULL,
    [Auction_No] VARCHAR(10) NULL,
    [Sett_Period] VARCHAR(10) NULL,
    [Order_Modified_Dt_Time] VARCHAR(50) NULL,
    [Credit_Rating] VARCHAR(50) NULL,
    [Remarks] VARCHAR(25) NULL,
    [Order_Entry_Dt_Time] VARCHAR(50) NULL,
    [CP_ID] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_NSERefno_upload_Hist
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_NSERefno_upload_Hist]
(
    [OrderNo] VARCHAR(20) NULL,
    [Order_Status] VARCHAR(10) NULL,
    [Sysbol] VARCHAR(10) NULL,
    [Series] VARCHAR(10) NULL,
    [Security_Name] VARCHAR(100) NULL,
    [Instrument_Type] VARCHAR(10) NULL,
    [Book_Type] VARCHAR(10) NULL,
    [Market_Type] VARCHAR(10) NULL,
    [UserId] VARCHAR(10) NULL,
    [Branch_Id] VARCHAR(10) NULL,
    [Buy_Sell] VARCHAR(10) NULL,
    [DQ] VARCHAR(10) NULL,
    [DQ_Remaining] VARCHAR(10) NULL,
    [Order_Qty] VARCHAR(10) NULL,
    [MF_Qty] VARCHAR(10) NULL,
    [AON_Indicator] VARCHAR(10) NULL,
    [Quantity_Price] VARCHAR(50) NULL,
    [PRO_CLI] VARCHAR(10) NULL,
    [Price] VARCHAR(10) NULL,
    [TM_Id] VARCHAR(10) NULL,
    [Order_Type] VARCHAR(10) NULL,
    [GTD] VARCHAR(50) NULL,
    [Order_Duration] VARCHAR(10) NULL,
    [PRO_Client] VARCHAR(20) NULL,
    [Client_AC] VARCHAR(10) NULL,
    [Participant_Code] VARCHAR(50) NULL,
    [Auction_Part_Type] VARCHAR(10) NULL,
    [Auction_No] VARCHAR(10) NULL,
    [Sett_Period] VARCHAR(10) NULL,
    [Order_Modified_Dt_Time] VARCHAR(50) NULL,
    [Credit_Rating] VARCHAR(50) NULL,
    [Remarks] VARCHAR(25) NULL,
    [Order_Entry_Dt_Time] VARCHAR(50) NULL,
    [CP_ID] VARCHAR(10) NULL,
    [updateDate] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_GSM_Series
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_GSM_Series]
(
    [Script_Cd] VARCHAR(50) NULL,
    [Segment] VARCHAR(50) NULL,
    [Buy_Sell] VARCHAR(10) NULL,
    [Stage] VARCHAR(50) NULL
);

GO

