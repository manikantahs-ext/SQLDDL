-- DDL Export
-- Server: 10.253.33.87
-- Database: Dustbin
-- Exported: 2026-02-05T02:38:02.964149

USE Dustbin;
GO

-- --------------------------------------------------
-- INDEX dbo.file1
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_file1] ON [dbo].[file1] ([party_code])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_vw_rmsdtclfi_collection
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_tbl_Vw_RmsDtclFi_Collection] ON [dbo].[tbl_vw_rmsdtclfi_collection] ([party_code], [groupname])

GO

-- --------------------------------------------------
-- INDEX dbo.tbl_Vw_RmsDtclFi_Collection__Raw
-- --------------------------------------------------
CREATE CLUSTERED INDEX [ci_tbl_Vw_RmsDtclFi_Collection__Raw] ON [dbo].[tbl_Vw_RmsDtclFi_Collection__Raw] ([Party_code], [groupname])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.client_notification_template
-- --------------------------------------------------
ALTER TABLE [dbo].[client_notification_template] ADD CONSTRAINT [PK__client_n__3213E83F3A04A4E7] PRIMARY KEY ([id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.cns_common_notification
-- --------------------------------------------------
ALTER TABLE [dbo].[cns_common_notification] ADD CONSTRAINT [PK_cns_common_notification] PRIMARY KEY ([requestid])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.imargin
-- --------------------------------------------------
ALTER TABLE [dbo].[imargin] ADD CONSTRAINT [pk_imargin] PRIMARY KEY ([party_code])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.short
-- --------------------------------------------------
ALTER TABLE [dbo].[short] ADD CONSTRAINT [pk_short] PRIMARY KEY ([client])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AgeingProcess_Bucketing_MTF_07dec2025
-- --------------------------------------------------
--EXEC [Ageing].[AgeingProcess_DataFetching] 'Jan 31 2016','ALL','N','Y','N','N','Y'    
--EXEC [Ageing].[AgeingProcess_DataFetching] 'Jan 31 2016','COMMODITY','N','Y','N','Y','Y'    
--EXEC [Ageing].[AgeingProcess_DataFetching] 'Mar 31 2016','EQUITY','N','N','N','N','N'    
    
--Exec [Ageing].[AgeingProcess_Bucketing_MTF] 'DEC 30 2017','DEC 30 2017','2017-04-01 00:00:000','2016-04-01 00:00:000','EQUITY','Y'    
   
CREATE PROCEDURE [AgeingProcess_Bucketing_MTF_07dec2025]    
(    
@Agedate as varchar(30),    
@DT AS DATETIME,    
@CURRFYFROM AS DATETIME,    
@PREVFYFROM AS DATETIME,     
@Segment as varchar(15),    
@intersegment as char(1)='Y'    
)    
as    
 BEGIN TRY    
     
 print 'pramod 1'    
  
--   declare @Agedate as varchar(30)='JAN 31 2022',    
--@DT AS DATETIME ='JAN 31 2022 23:59:50',    
--@CURRFYFROM AS DATETIME='2021-04-01 00:00:00.000',    
--@PREVFYFROM AS DATETIME='2020-04-01 00:00:00.000',     
--@Segment as varchar(15)='ALL',    
--@intersegment as char(1)='Y'    
  
set @CURRFYFROM = dateadd(year,-3,@CURRFYFROM)  
set @PREVFYFROM = dateadd(year,-2,@PREVFYFROM)  
--set @Agedate = dateadd(year,-3,@Agedate)  
  
  select distinct vdt into #dateparameter from AngelNseCM.Account.dbo.ledger with (nolock)where vdt<=@Agedate and edt>@Agedate    
  and vtyp=15    
      
  declare @firstdate datetime,@lastdate datetime     
  select @firstdate=MIN(vdt),@lastdate=MAX(vdt) from #dateparameter    
    
     
   DECLARE    
  @ErMessage NVARCHAR(2048),    
  @ErSeverity INT,    
  @ErState INT    
  DECLARE @PROGRESSBAR VARCHAR(800)='STARTED'    
   ----BUCKETING COMBINE    
   SET @PROGRESSBAR= 'BUCKETING PROCESS STARTED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
    
   ---INTERSEGMENT DATA FETCHING       
    
   IF @INTERSEGMENT='Y'      
   SET @PROGRESSBAR= 'INTERSEGMENT DATA FETCHING PROCESS STARTED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
    BEGIN      
        
    ---MTF INTERSEGMENT JV FETCHING    
     BEGIN    
      CREATE TABLE #MTFT1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT    
      )    
      TRUNCATE TABLE #MTFT1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #MTFT1    
        select VNO,DRCR,VAMT,vtyp      
        --into #bset1      
        from AngelNseCM.MTFTRADE.dbo.ledger with (nolock) where CLTCODE in      
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='MTF'     
               and Fld_ToSegment not in ('BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='MTF'     
               and Fld_FromSegment not in ('BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
            
       END    
      ELSE    
       BEGIN    
        INSERT INTO #MTFT1    
        select VNO,DRCR,VAMT,vtyp      
        --into #bset1      
        from AngelNseCM.MTFTRADE.dbo.ledger with (nolock) where CLTCODE in      
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='MTF'     
               and Fld_ToSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='BSECM'     
               and Fld_FromSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END  --gMtfIjv    
     -- select a.CLTCODE,          
            
      update #mtft1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
          
      TRUNCATE TABLE Ageing.temp_AgeingMtfIjv    
          
      INSERT INTO Ageing.temp_AgeingMtfIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
   CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)  
   select a.CLTCODE,    
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),     
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
   CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
   --   DR366Total=0,   
      CR1097Total=0,    
      DR1097Total=0    
      --into #bseIjv      
      --into temp_AgeingBseIjv    
      from AngelNseCM.MTFTRADE.dbo.ledger a with (nolock) inner join #mtft1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr      
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)    
      AND a.VTYP IN (8,88)    
      group by a.cltcode     
     END     
        
    ---BSECM INTERSEGMENT JV FETCHING    
     BEGIN    
      CREATE TABLE #BSET1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT    
      )    
      TRUNCATE TABLE #BSET1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #BSET1    
        select VNO,DRCR,VAMT,vtyp      
        --into #bset1      
       -- from ReplicatedData.dbo.ANANDACCOUNT_ABLEDGER with (nolock) where CLTCODE in   
     from AngelBSECM.ACCOUNT_AB.dbo.LEDGER with (nolock) where CLTCODE in    
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='BSECM'     
               and Fld_ToSegment not in ('BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='BSECM'     
               and Fld_FromSegment not in ('BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
            
       END    
      ELSE    
       BEGIN    
        INSERT INTO #BSET1    
        select VNO,DRCR,VAMT,vtyp      
        --into #bset1      
       -- from ReplicatedData.dbo.ANANDACCOUNT_ABLEDGER with (nolock) where CLTCODE in      
      from AngelBSECM.ACCOUNT_AB.dbo.LEDGER with (nolock) where CLTCODE in    
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='BSECM'     
               and Fld_ToSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='BSECM'     
               and Fld_FromSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END    
            
      update #bset1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
          
      TRUNCATE TABLE Ageing.temp_AgeingBseIjv    
          
      INSERT INTO Ageing.temp_AgeingBseIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
      CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)    
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
   CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
    
      --into #bseIjv      
      --into temp_AgeingBseIjv    
      --from ReplicatedData.dbo.ANANDACCOUNT_ABLEDGER a with (nolock) inner join #bset1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr   
   from AngelBSECM.ACCOUNT_AB.dbo.LEDGER a with (nolock) inner join #bset1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr  
       WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)     
      AND a.VTYP IN (8,88)    
      group by a.cltcode     
     END     
    ---NSECM INTERSEGMENT JV FETCHING    
     BEGIN    
  CREATE TABLE #nset1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT    
      )    
      TRUNCATE TABLE #nset1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #nset1    
        select VNO,DRCR,VAMT,vtyp      
        --into #nset1      
       -- from ReplicatedData.dbo.ANAND1ACCOUNTLEDGER with (nolock) where CLTCODE in    
     from AngelNseCM.ACCOUNT.dbo.LEDGER with (nolock) where CLTCODE in   
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NSECM'    
                and Fld_ToSegment not in ('BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NSECM'     
               and Fld_FromSegment not in ('BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
            
       END    
      ELSE    
       BEGIN    
        INSERT INTO #nset1    
        select VNO,DRCR,VAMT,vtyp      
        --into #nset1      
        --from ReplicatedData.dbo.ANAND1ACCOUNTLEDGER with (nolock) where CLTCODE in    
  from AngelNseCM.ACCOUNT.dbo.LEDGER with (nolock)  where CLTCODE in   
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NSECM'     
               and Fld_ToSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NSECM'     
               and Fld_FromSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END        
    
            
      update #nset1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
            
      TRUNCATE TABLE Ageing.temp_AgeingNseIjv    
          
      INSERT INTO Ageing.temp_AgeingNseIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
      CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)    
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
  
   CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
  
      --CR366Total=0,    
      --DR366Total=0    
      --into #nseIjv      
      --into temp_AgeingNseIjv    
      --from ReplicatedData.dbo.ANAND1ACCOUNTLEDGER a with (nolock) inner join #nset1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr   
    from AngelNseCM.ACCOUNT.dbo.LEDGER a with (nolock) inner join #nset1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr   
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      --AND NOT (A.VTYP=18 AND A.VDT=@CURRFYFROM)        
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)     
      and a.VTYP in (8,88)    
      group by a.cltcode     
     END      
    ---FO INTERSEGMENT JV FETCHING    
     BEGIN    
      CREATE TABLE #fot1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT    
      )    
      TRUNCATE TABLE #fot1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #fot1    
        select VNO,DRCR,VAMT,vtyp      
        --into #fot1      
        --from ReplicatedData.dbo.ACCOUNTFOLEDGER with (nolock) where CLTCODE in   
   from AngelFO.ACCOUNTFO.dbo.LEDGER with (nolock) where CLTCODE in  
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NSEFO'     
                and Fld_ToSegment not in ('BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NSEFO'     
                and Fld_FromSegment not in ('BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
            
       END    
      ELSE    
       BEGIN    
        INSERT INTO #fot1    
        select VNO,DRCR,VAMT,vtyp      
        --into #fot1      
       -- from ReplicatedData.dbo.ACCOUNTFOLEDGER with (nolock) where CLTCODE in  
    from AngelFO.ACCOUNTFO.dbo.LEDGER with (nolock) where CLTCODE in  
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NSEFO'     
                and Fld_ToSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NSEFO'     
                and Fld_FromSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END        
          
            
      update #fot1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
            
      TRUNCATE TABLE Ageing.temp_AgeingFoIjv    
          
      INSERT INTO Ageing.temp_AgeingFoIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
      CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)    
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
  
    CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
       
      --into #foIjv      
      --into temp_AgeingFoIjv    
      --from ReplicatedData.dbo.ACCOUNTFOLEDGER a with (nolock) inner join #fot1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr  
   from AngelFO.ACCOUNTFO.dbo.LEDGER a with (nolock) inner join #fot1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr  
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      --AND NOT (A.VTYP=18 AND A.VDT=@CURRFYFROM)  
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)    
      and a.VTYP in (8,88)    
      group by a.cltcode      
     END     
    ---NSX INTERSEGMENT JV FETCHING    
     BEGIN    
      CREATE TABLE #nsxt1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT    
      )    
      TRUNCATE TABLE #nsxt1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #nsxt1    
        select VNO,DRCR,VAMT,vtyp      
        --into #nsxt1      
        --from ReplicatedData.dbo.ACCOUNTCURFOLEDGER with (nolock) where CLTCODE in   
  from AngelFO.ACCOUNTCURFO.dbo.LEDGER with (nolock) where CLTCODE in  
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NSX'     
               and Fld_ToSegment not in ('BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NSX'     
               and Fld_FromSegment not in ('BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
            
       END    
      ELSE    
       BEGIN    
        INSERT INTO #nsxt1    
        select VNO,DRCR,VAMT,vtyp      
        --into #nsxt1      
        --from ReplicatedData.dbo.ACCOUNTCURFOLEDGER with (nolock) where CLTCODE in     
  from AngelFO.ACCOUNTCURFO.dbo.LEDGER with (nolock) where CLTCODE in  
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NSX'     
               and Fld_ToSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NSX'     
               and Fld_FromSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
 )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END        
    
            
      update #nsxt1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
           
      TRUNCATE TABLE Ageing.TEMP_AGEINGNSXIJV    
          
      INSERT INTO Ageing.TEMP_AGEINGNSXIJV(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)    
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),   
     
    CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
        
      --into #nsxIjv      
      --into temp_AgeingnsxIjv    
      --from ReplicatedData.dbo.ACCOUNTCURFOLEDGER a with (nolock) inner join #nsxt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr      
   from AngelFO.ACCOUNTCURFO.dbo.LEDGER a with (nolock) inner join #nsxt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr    
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      --AND NOT (A.VTYP=18 AND A.VDT=@CURRFYFROM)  
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)   
      and a.VTYP in (8,88)    
      group by a.cltcode     
     END     
    ---MCD INTERSEGMENT JV FETCHING    
     BEGIN    
      CREATE TABLE #mcdt1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT    
      )    
      TRUNCATE TABLE #mcdt1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #mcdt1    
        select VNO,DRCR,VAMT,vtyp      
        --into #mcdt1      
        --from ReplicatedData.dbo.ACCOUNTMCDXCDSLEDGER with (nolock) where CLTCODE in    
  from AngelCommodity.ACCOUNTMCDXCDS.dbo.LEDGER  with (nolock) where CLTCODE in    
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='MCD'     
               and Fld_ToSegment not in ('BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='MCD'    
                and Fld_FromSegment not in ('BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
            
       END    
      ELSE    
       BEGIN    
        INSERT INTO #mcdt1    
        select VNO,DRCR,VAMT,vtyp      
        --into #mcdt1      
        --from ReplicatedData.dbo.ACCOUNTMCDXCDSLEDGER with (nolock) where CLTCODE in      
  from AngelCommodity.ACCOUNTMCDXCDS.dbo.LEDGER  with (nolock) where CLTCODE in  
        (      
        select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='MCD'     
               and Fld_ToSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        union       
        select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='MCD'    
                and Fld_FromSegment not in ('MCX','NCDEX','BSEMS','NSEMS')      
        )      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END        
    
            
      update #mcdt1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
          
      truncate table Ageing.temp_AgeingMcdIjv      
          
      insert into Ageing.temp_AgeingMcdIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)    
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
        
   CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
      --into #mcdIjv      
      --into temp_AgeingMcdIjv    
      --from ReplicatedData.dbo.ACCOUNTMCDXCDSLEDGER a with (nolock) inner join #mcdt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr    
   from AngelCommodity.ACCOUNTMCDXCDS.dbo.LEDGER a with (nolock) inner join #mcdt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr    
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      --AND NOT (A.VTYP=18 AND A.VDT=@CURRFYFROM)  
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)     
      and a.vtyp in (8,88)    
      group by a.cltcode      
     END    
    ---MCDX INTERSEGMENT JV FETCHING     
     BEGIN    
              
      CREATE TABLE #mcdxt1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT,    
      controlcode VARCHAR(30)    
      )    
      TRUNCATE TABLE #mcdxt1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #mcdxt1    
        select VNO,DRCR,VAMT,vtyp,controlcode=CLTCODE       
        --into #mcdxt1      
        --from ReplicatedData.dbo.ACCOUNTMCDXLEDGER with (nolock) where CLTCODE   
  from AngelCommodity.ACCOUNTMCDX.dbo.LEDGER  with (nolock) where CLTCODE  
        like '43000%'    
        --in      
        --(      
        --select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='MCX'     
        --       and Fld_ToSegment not in ('BSEMS','NSEMS')      
        --union       
        --select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='MCX'     
        --       and Fld_FromSegment not in ('BSEMS','NSEMS')      
        --)      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
              
    
       END    
      ELSE    
       BEGIN    
        INSERT INTO #mcdxt1    
        select VNO,DRCR,VAMT,vtyp,controlcode=CLTCODE      
        --into #mcdxt1      
        --from ReplicatedData.dbo.ACCOUNTMCDXLEDGER with (nolock) where CLTCODE   
  from AngelCommodity.ACCOUNTMCDX.dbo.LEDGER  with (nolock) where CLTCODE  
        like '43000%'    
        --in      
        --(      
        --select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='MCX'     
        --       and Fld_ToSegment not in ('BSECM','NSECM','NSEFO','NSX','MCD','BSEMS','NSEMS')      
        --union       
        --select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='MCX'     
        --       and Fld_FromSegment not in ('BSECM','NSECM','NSEFO','NSX','MCD','BSEMS','NSEMS')      
        --)      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END        
         
      update #mcdxt1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
          
          
      TRUNCATE TABLE Ageing.temp_AgeingMcdxIjv      
          
      INSERT INTO Ageing.temp_AgeingMcdxIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)      
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
       
   CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
      --into #mcdxIjv      
      --into temp_AgeingMcdxIjv    
      --from ReplicatedData.dbo.ACCOUNTMCDXLEDGER a with (nolock) inner merge join #mcdxt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr    
   from AngelCommodity.ACCOUNTMCDX.dbo.LEDGER a with (nolock) inner merge join #mcdxt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr    
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      --AND NOT (A.VTYP=18 AND A.VDT=@CURRFYFROM)   
   AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)  
      and a.VTYP in (8,88) and exists    
      (select vtyp,vno,segment,cltcode,vamt from comm$ c where segment='mcdx'    
      and c.vtyp=a.vtyp and c.vno=a.vno and c.vamt=a.vamt )    
      --and a.CLTCODE=b.controlcode    
      group by a.cltcode      
     END    
    ---NCDX INTERSEGMENT JV FETCHING    
     BEGIN    
      CREATE TABLE #ncdxt1    
      (    
      VNO VARCHAR(15),    
      DRCR CHAR(1),    
      VAMT MONEY,    
      VTYP SMALLINT,    
      controlcode VARCHAR(30)    
      )    
      TRUNCATE TABLE #ncdxt1    
          
      if @Segment='ALL'    
       BEGIN     
        INSERT INTO #ncdxt1    
        select VNO,DRCR,VAMT,vtyp,controlcode=CLTCODE      
        --into #ncdxt1      
        --from ReplicatedData.dbo.ACCOUNTNCDXLEDGER with (nolock) where CLTCODE   
  from AngelCommodity.ACCOUNTNCDX.dbo.LEDGER  with (nolock) where CLTCODE    
        like '43000%'    
        --in      
        --(      
        --select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NCDEX'     
        --       and Fld_ToSegment not in ('BSEMS','NSEMS')      
        --union       
        --select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NCDEX'     
        --       and Fld_FromSegment not in ('BSEMS','NSEMS')      
        --)      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
              
                
       END    
      ELSE    
       BEGIN    
        INSERT INTO #ncdxt1    
        select VNO,DRCR,VAMT,vtyp,controlcode=CLTCODE      
        --into #ncdxt1      
        --from ReplicatedData.dbo.ACCOUNTNCDXLEDGER with (nolock) where CLTCODE    
  from AngelCommodity.ACCOUNTNCDX.dbo.LEDGER  with (nolock) where CLTCODE  
        like '43000%'    
        --in      
        --(      
        --select Fld_toControlAc  from general.dbo.tbl_jvcontrolmaster where Fld_FromSegment='NCDEX'     
        --       and Fld_ToSegment not in ('BSECM','NSECM','NSEFO','NSX','MCD','BSEMS','NSEMS')      
        --union       
        --select Fld_fromControlAc from general.dbo.tbl_jvcontrolmaster where fld_toSegment='NCDEX'     
        --       and Fld_FromSegment not in ('BSECM','NSECM','NSEFO','NSX','MCD','BSEMS','NSEMS')      
        --)      
        and VDT>=@PrevFYfrom and vtyp in (8,88)    
       END        
    
            
      update #ncdxt1 set drcr=(Case when DRCR='D' then 'C' else 'D' end)      
    
      TRUNCATE TABLE Ageing.temp_AgeingNcdxIjv    
          
      INSERT INTO Ageing.temp_AgeingNcdxIjv(CLTCODE,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,  
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total)         
      select a.CLTCODE,          
      CR007Total=SUM(case when a.drcr='C' and vdt > @dt-08 then -a.vamt else 0 end),    
      DR007Total=SUM(case when a.drcr='D' and vdt > @dt-08 then a.vamt else 0 end),    
      CR015Total=SUM(case when a.drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -a.vamt else 0 end),    
      DR015Total=SUM(case when a.drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then a.vamt else 0 end),    
      CR030Total=SUM(case when a.drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -a.vamt else 0 end),    
      DR030Total=SUM(case when a.drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then a.vamt else 0 end),    
      CR060Total=SUM(case when a.drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -a.vamt else 0 end),    
      DR060Total=SUM(case when a.drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then a.vamt else 0 end),    
      CR090Total=SUM(case when a.drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -a.vamt else 0 end),    
      DR090Total=SUM(case when a.drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then a.vamt else 0 end),    
      CR180Total=SUM(case when a.drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -a.vamt else 0 end),    
      DR180Total=SUM(case when a.drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then a.vamt else 0 end),    
      CR360Total=SUM(case when a.drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -a.vamt else 0 end),    
      DR360Total=SUM(case when a.drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then a.vamt else 0 end),    
      --CR365Total=SUM(case when a.drcr='C' and vdt < @dt-361 then -a.vamt else 0 end),    
      --DR365Total=SUM(case when a.drcr='D' and vdt < @dt-361 then a.vamt else 0 end),    
        
    CR730Total=SUM(case when a.drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -a.vamt else 0 end),    
      DR730Total=SUM(case when a.drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then a.vamt else 0 end),   
     
   CR1095Total=SUM(case when a.drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -a.vamt else 0 end),    
      DR1095Total=SUM(case when a.drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then a.vamt else 0 end),   
     
   CR1096Total=SUM(case when a.drcr='C' and vdt < @dt-1096 then -a.vamt else 0 end),    
      DR1096Total=SUM(case when a.drcr='D' and vdt < @dt-1096 then a.vamt else 0 end),    
       
   --CR366Total=0,    
      -- DR366Total=0    
      CR1097Total=0,    
      DR1097Total=0    
      --into #ncdxIjv      
      --into temp_AgeingNcdxIjv    
      --from ReplicatedData.dbo.ACCOUNTNCDXLEDGER a with (nolock) inner merge join #ncdxt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr   
   from AngelCommodity.ACCOUNTNCDX.dbo.LEDGER a with (nolock) inner merge join #ncdxt1 b on a.vno=b.vno and a.VAMT=B.vamt and a.drcr=b.drcr   
      WHERE (A.VDT<=@DT AND A.VDT>=@PREVFYFROM)    
      --AND NOT (A.VTYP=18 AND A.VDT=@CURRFYFROM)  
      AND NOT (A.VTYP=18 AND A.VDT>@CURRFYFROM)     
      and a.vtyp in (8,88) and exists    
      (select vtyp,vno,segment,cltcode,vamt from comm$ c where segment='ncdx'    
      and c.vtyp=a.vtyp and c.vno=a.vno and c.vamt=a.vamt )    
      --and a.CLTCODE=b.controlcode    
      group by a.cltcode     
     END    
         
   SET @PROGRESSBAR= 'INTERSEGMENT DATA FETCHING PROCESS COMPLETED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'      
   END    
    
       
   Create Table #DRCRTrx      
   (      
    Cltcode varchar(10),      
    CR007Total money,      
    DR007Total money,      
    CR015Total money,      
    DR015Total money,      
    CR030Total money,      
    DR030Total money,      
    CR060Total money,      
    DR060Total money,      
    CR090Total money,      
    DR090Total money,      
    CR0180Total money,      
    DR0180Total money,      
    CR0360Total money,      
    DR0360Total money,   
 CR730Total money,      
    DR730Total money,  
 CR1095Total money,      
    DR1095Total money,   
 CR1096abvTotal money,      
    DR1096abvTotal money   
    --CR0365abvTotal money,      
    --DR0365abvTotal money          
   )      
       
   Create Table #DRCRTrx1    
   (    
   cltcode varchar(10),    
   CR007Total money,    
   DR007Total money,    
   CR015Total money,    
   DR015Total money,    
   CR030Total money,    
   DR030Total money,    
   CR060Total money,    
   DR060Total money,    
   CR090Total money,    
   DR090Total money,    
   CR180Total money,    
   DR180Total money,    
   CR360Total money,    
   DR360Total money,    
   CR730Total money,      
 DR730Total money,  
 CR1095Total money,      
 DR1095Total money,   
 CR1096abvTotal money,      
 DR1096abvTotal money   
   --CR365Total money,    
   --DR365Total money    
   )    
       
   Create Table #INTERSEGJV    
   (    
   cltcode varchar(10),    
   CR007Total money,    
   DR007Total money,    
   CR015Total money,    
   DR015Total money,    
   CR030Total money,    
   DR030Total money,    
   CR060Total money,    
   DR060Total money,    
   CR090Total money,    
   DR090Total money,    
   CR180Total money,    
   DR180Total money,    
   CR360Total money,    
   DR360Total money,  
   CR730Total money,      
    DR730Total money,  
 CR1095Total money,      
    DR1095Total money,   
 CR1096abvTotal money,      
    DR1096abvTotal money   
   --CR365Total money,    
   --DR365Total money    
   )       
       
       
 IF( @Segment='ALL')    
 BEGIN    
     
  BEGIN      
    
   SET @PROGRESSBAR= 'BUCKETING COMBINE STARTED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
        
   TRUNCATE TABLE AGEING.AGEINGBUCKETINGCOMBINE    
       
   INSERT INTO AGEING.AGEINGBUCKETINGCOMBINE    
   (CLTCODE,SUB_BROKER,PARENT_SB,CL_TYPE,AGEINGDATE,PROCESSDATA,NETBALANCE,CLIENTHOLDING,CLIENTHOLDINGADJ,SBCREDITNONCASH,    
   SBCREDITCASH,SBCREDITBAL,SBCREDITADJ)    
   SELECT     
   CLTCODE,SUB_BROKER,PARENT_SB,B2B_B2C,BAL_DATE,PROCESSDATE=GETDATE(),NET_COMBINE,HOLDINGCOMBINE,HLDNG_ADJ,    
   --SBNONCASHCOMBINE=ISNULL(SBNONCASHCOMBINE,0)+ISNULL(FR_CREDIT_ADJUSTED,0),    
   SBNONCASHCOMBINE=ISNULL(SBNONCASHCOMBINE,0),    
   SBCASHCOMBINE=ISNULL(SBCASHCOMBINE,0),SBBALANCECOMBINE=ISNULL(SBBALANCECOMBINE,0),SBCREDITADJ=ISNULL(SBBAL_ADJUSTCOMBINE,0)    
    FROM AGEING.TEMPCLIENT_COLLSBDETAILS_COMBINE     
        
    /*Changed by renil on 30th april 2015 to consider only physical holding as instructed by Sachin for equity*/     
            SELECT distinct  *  INTO #RMS_HOLDING FROM HISTORY.DBO.RMS_HOLDING     
   WHERE     
   --SOURCE='H' AND     
   UPD_DATE BETWEEN '2017-12-30 00:00:00.000' AND '2017-12-30 23:59:59.000'    
   /*UPD_DATE BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)  */    
   AND EXCHANGE IN ('MTF','BSECM','NSECM','NSEFO','NSX','MCD','MCX','NCDEX')     
       
        
        
          
   SELECT PARTY_CODE,CLIENTHOLDING=SUM(TOTAL) INTO #CLIENTHOLDINGEQCOMM FROM #RMS_HOLDING     
   WHERE     
   --SOURCE='H' AND     
   UPD_DATE BETWEEN '2017-12-30 00:00:00.000' AND '2017-12-30 23:59:59.000'    
   /*UPD_DATE BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)  */    
   AND EXCHANGE IN ('MTF','BSECM','NSECM','NSEFO','NSX','MCD''MCX','NCDEX')     
   GROUP BY PARTY_CODE     
       
      
       
   ---///changes on 24 apr 2018//---    
   --UPDATE AGEING.AGEINGBUCKETINGCOMBINE set CLIENTHOLDING=0.00    
       
       
    
   --UPDATE A SET CLIENTHOLDING=CONVERT(MONEY,B.CLIENTHOLDING) FROM AGEING.AGEINGBUCKETINGCOMBINE A,    
   --(SELECT * FROM #CLIENTHOLDINGEQCOMM)B    
   --WHERE A.CLTCODE=B.PARTY_CODE     
   --//END//--    
       
   /**************************Commented on 24 Dec 2016 by Neha*********************************************/    
   select distinct party_code,amount into #aa from HISTORY.DBO.CLIENT_COLLATERALS_HIST WHERE     
   EffDate BETWEEN '2017-12-30 00:00:00.000' AND '2017-12-30 23:59:59.000'    
   /*EffDate BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103) */     
   --AND PARTY_CODE='u10452'     
   AND co_code IN ('MTF','BSECM','NSECM','NSEFO','NSX','MCD','MCX','NCDEX')    
       
       
   SELECT  PARTY_CODE,AMOUNT=SUM(AMOUNT) INTO #COLLATERALSEQCOMM    
    FROM      
   #aa  GROUP BY PARTY_CODE     
       
   /*SELECT PARTY_CODE,AMOUNT=SUM(AMOUNT) INTO #COLLATERALSEQCOMM FROM      
   HISTORY.DBO.CLIENT_COLLATERALS_HIST WHERE     
   --EffDate BETWEEN '2016-09-29 00:00:00.000' AND '2016-09-29 23:59:59.000'    
   EffDate BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   --AND PARTY_CODE='A66807'     
   AND co_code IN ('BSECM','NSECM','NSEFO','NSX','MCD','MCX','NCDEX')    
   GROUP BY PARTY_CODE*/     
   /***********************************************************************/       
   UPDATE A SET CLIENTCOLLATERAL=CONVERT(MONEY,B.AMOUNT) FROM AGEING.AGEINGBUCKETINGCOMBINE A,    
   (SELECT * FROM #COLLATERALSEQCOMM)B    
   WHERE A.CLTCODE=B.PARTY_CODE     
       
       
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE     
   SET     
   --SBCREDITNONCASH_ADJ=(SBCREDITNONCASH*SBCREDITADJ)/(SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL),    
   --SBCREDITCASHBAL_ADJ=((SBCREDITCASH+SBCREDITBAL)*SBCREDITADJ)/(SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL)    
   SBCREDITCASHBAL_ADJ=SBCREDITADJ    
   --WHERE (SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL)>0    
       
   UPDATE     
   AGEING.AGEINGBUCKETINGCOMBINE     
   --SET NET_DRCR=NETBALANCE-SBCREDITADJ    
   SET NET_DRCR=NETBALANCE-SBCREDITCASHBAL_ADJ    
       
   /*CLUBBING OF DEBITS AND CREDITS AND INTERSEGMENT ADJ*/    
   BEGIN    
    SET @PROGRESSBAR= 'CLUBBING AND INTERSEGMENT COMBINE STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
       
    TRUNCATE TABLE #DRCRTrx1     
   INSERT INTO #DRCRTrx1        
   select cltcode,      
   CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
       
   from      
   (      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     from Ageing.temp_AgeingBseBal  group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     from Ageing.temp_AgeingNseBal group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
  -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)   
    from Ageing.temp_AgeingFoBal group by cltcode  
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
  -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
   CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     from Ageing.temp_AgeingNSXBal group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     from Ageing.temp_AgeingMCDBal group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)  
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     from Ageing.temp_AgeingMCDXBal group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
    CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     from Ageing.temp_AgeingNCDXBal group by cltcode    
   ) a       
   group by cltcode      
       
       
  /*iNTERSEGMENT CODE WILL GO HERE*/     
  IF @INTERSEGMENT='Y'      
   BEGIN      
    TRUNCATE TABLE #INTERSEGJV    
    INSERT INTO #INTERSEGJV    
     SELECT cltcode,      
     CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)      
   CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
     FROM      
     (      
     select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
    -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
  CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingBseIjv  group by cltcode                 
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
    -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
  CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingNseIjv  group by cltcode    
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
    -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
  CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingFoIjv  group by cltcode      
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
    -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
  CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingMcdIjv  group by cltcode    
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
    -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
  CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingnsxIjv  group by cltcode     
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
    -- CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
  CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingMcdxIjv  group by cltcode     
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     --CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
   CR730Total=SUM(CR730Total),DR730Total=SUM(DR730Total),CR1095Total=SUM(CR1095Total),DR1095Total=SUM(DR1095Total),  
 CR1096Total=SUM(CR1096Total),DR1096Total=SUM(DR1096Total)    
        from Ageing.temp_AgeingNcdxIjv  group by cltcode     
     ) X       
     GROUP BY CLTCODE      
          
     TRUNCATE TABLE #DRCRTRX     
     INSERT INTO #DRCRTRX      
     SELECT A.CLTCODE,      
    CR007Total=A.CR007Total-ISNULL(B.CR007Total,0),DR007Total=A.DR007Total-ISNULL(B.DR007Total,0),    
    CR015Total=A.CR015Total-ISNULL(B.CR015Total,0),DR015Total=A.DR015Total-ISNULL(B.DR015Total,0),    
    CR030Total=A.CR030Total-ISNULL(B.CR030Total,0),DR030Total=A.DR030Total-ISNULL(B.DR030Total,0),    
    CR060Total=A.CR060Total-ISNULL(B.CR060Total,0),DR060Total=A.DR060Total-ISNULL(B.DR060Total,0),    
    CR090Total=A.CR090Total-ISNULL(B.CR090Total,0),DR090Total=A.DR090Total-ISNULL(B.DR090Total,0),    
    CR180Total=A.CR180Total-ISNULL(B.CR180Total,0),DR180Total=A.DR180Total-ISNULL(B.DR180Total,0),    
    CR360Total=A.CR360Total-ISNULL(B.CR360Total,0),DR360Total=A.DR360Total-ISNULL(B.DR360Total,0),    
    --CR365Total=A.CR365Total-ISNULL(B.CR365Total,0),DR365Total=A.DR365Total-ISNULL(B.DR365Total,0)    
 CR730Total=A.CR730Total-ISNULL(B.CR730Total,0),DR730Total=A.DR730Total-ISNULL(B.DR730Total,0),  
 CR1095Total=A.CR1095Total-ISNULL(B.CR1095Total,0),DR1095Total=A.DR1095Total-ISNULL(B.DR1095Total,0),  
 CR1096abvTotal=A.CR1096abvTotal-ISNULL(B.CR1096abvTotal,0),DR1096abvTotal=A.DR1096abvTotal-ISNULL(B.DR1096abvTotal,0)   
     FROM #DRCRTRX1 A LEFT OUTER JOIN #INTERSEGJV B ON A.CLTCODE=B.CLTCODE      
         
   END     
  ELSE    
   BEGIN    
    TRUNCATE TABLE #DRCRTRX     
    INSERT INTO #DRCRTRX SELECT * FROM #DRCRTRX1       
   END         
       
  --DROP TABLE #DRCRTRX    
  --DROP TABLE #DRCRTRX1    
      
   SET @PROGRESSBAR= 'CLUBBING AND INTERSEGMENT COMBINE COMPLETED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
       
  END    
       
   /* DEBIT BUCKETING */     
   BEGIN      
    SET @PROGRESSBAR= 'DEBIT BUCKETING COMBINE STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
     --7     
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY7=    
    (CASE WHEN NET_DRCR <= DR007TOTAL THEN NET_DRCR ELSE DR007TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --15    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY15=    
    (CASE WHEN NET_DRCR-DAY7 >= DR015TOTAL THEN DR015TOTAL ELSE NET_DRCR-DAY7 END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --30    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY30=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15) >= DR030TOTAL THEN DR030TOTAL ELSE NET_DRCR-(DAY7+DAY15) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --60    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY60=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30) >= DR060TOTAL THEN DR060TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --90    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY90=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) >= DR090TOTAL THEN DR090TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --180    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY180=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) >= DR0180TOTAL     
    THEN DR0180TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --360    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY360=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) >= DR0360TOTAL     
    THEN DR0360TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --  --361 ABOVE    
    --UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY361ABV=    
    --CASE WHEN NET_DRCR-    
    --(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360)>=0 THEN NET_DRCR-    
    --(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE 0 END WHERE NET_DRCR > 0   
   
 --730  
 UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY730=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) >= DR730TOTAL     
    THEN DR730TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0     
  
 --1095  
 UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY1095=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730) >= DR1095TOTAL     
    THEN DR1095TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR > 0     
  
 --1095 and above  
 UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY1095ABV=    
    CASE WHEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+day730+day1095)>=0 THEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+day730+day1095) ELSE 0 END WHERE NET_DRCR > 0   
        
    SET @PROGRESSBAR= 'DEBIT BUCKETING COMBINE COMPLETED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
   END    
        
    /* CREDIT BUCKETING */    
   BEGIN      
    SET @PROGRESSBAR= 'CREDIT BUCKETING COMBINE STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'      
    --7     
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY7=    
    (CASE WHEN NET_DRCR >= CR007TOTAL THEN NET_DRCR ELSE CR007TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
    
        
    --15    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY15=    
    (CASE WHEN NET_DRCR-DAY7 >= CR015TOTAL THEN NET_DRCR-DAY7 ELSE CR015TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
        
        
      --30    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY30=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15) >= CR030TOTAL THEN NET_DRCR-(DAY7+DAY15) ELSE CR030TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --60    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY60=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30) >= CR060TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30) ELSE CR060TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
        
      --90    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY90=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) >= CR090TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) ELSE  CR090TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --180    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY180=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) >= CR0180TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) ELSE CR0180TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --360    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY360=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) >= CR0360TOTAL   
 THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) ELSE CR0360TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
    --  --361 ABOVE    
    --UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY361ABV=    
    --CASE WHEN NET_DRCR-    
    --(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360)<0 THEN NET_DRCR-    
    --(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE 0 END WHERE NET_DRCR < 0       
  
   --730    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY730=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) >= CR730TOTAL   
 THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE CR730TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0      
   
   --1095    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY1095=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730) >= CR1095TOTAL   
 THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730) ELSE CR1095TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=B.CLTCODE AND NET_DRCR < 0      
  
   --1095 ABOVE    
    UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET DAY1095ABV=    
    CASE WHEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730+DAY1095)<0 THEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730+DAY1095) ELSE 0 END WHERE NET_DRCR < 0    
  
        
    SET @PROGRESSBAR= 'CREDIT BUCKETING COMBINE COMPLETED......'      
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'      
   END     
       
    
       
   --UPDATE  AGEING.AGEINGBUCKETINGCOMBINE SET DRCR=DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY361ABV   
   UPDATE  AGEING.AGEINGBUCKETINGCOMBINE SET DRCR=DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY730+DAY1095+DAY1095ABV    
   UPDATE  AGEING.AGEINGBUCKETINGCOMBINE SET DEBIT=CASE WHEN DRCR>0 THEN DRCR ELSE 0 END    
       
    --Total Security    
   --UPDATE AGEING.AGEINGBUCKETINGCOMBINE --SET TOTALSECURITIES=CLIENTHOLDING    
   ----SET TOTALSECURITIES=CLIENTHOLDING+SbCreditNoncash_adj    
   --SET TOTALSECURITIES=    
   --CASE WHEN (CLIENTHOLDING+SbCreditNoncash_adj)<=0 THEN 0 ELSE     
   --CLIENTHOLDING+SBCREDITNONCASH_ADJ END    
       
       
   ----///commted on pRashant//----    
   --UPDATE AGEING.AGEINGBUCKETINGCOMBINE --SET TOTALSECURITIES=CLIENTHOLDING    
   --SET TOTALSECURITIES=    
   --CASE WHEN (CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL)<=0 THEN 0 ELSE     
   --CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL END    
   ----////----END////----    
       
   ---///Commted on 25/04/2018//---    
   --update  AGEING.AGEINGBUCKETINGCOMBINE set TotalSecurities=CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL    
   ---//---END////---    
   update  AGEING.AGEINGBUCKETINGCOMBINE set TotalSecurities=CLIENTHOLDING+SBCREDITNONCASH_ADJ    
       
       
     /*rAHUL SHAH*/    
   --SELECT * INTO #RCS FROM [172.31.16.57].NBFC.DBO.RCS_31MAR2015_PWC     
   --WHERE FUTUREQTY <> 0    
       
       
    
   --SELECT PARTY_CODE,SUM(FUTUREQTY*CL_RATE) AS HOLDVALUE INTO #A FROM #RCS    
   --GROUP BY PARTY_CODE    
       
       
   --update AGEING.AGEINGBUCKETINGCOMBINE set TOTALSECURITIES=TOTALSECURITIES+Convert(money,x.PFValue) from     
   --(select Cltcode=PARTY_CODE,PFValue=SUM(HOLDVALUE) from  #A    
   --group by PARTY_CODE)x where AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=x.Cltcode    
   /**********************************/      
       
    
  truncate table EquityT2    
     
  insert into EquityT2    
  select SETT_NO,sett_type,party_code,SCRIP_CD,series,SCRIP_NAME,ISIN,SAUDA_DATE,PQTYDEL,PAMTDEL,SQTYDEL,Samtdel,clienttype,SUB_BROKER,    
  branch_Cd,Exchange,Netqty=PQTYDEL-SQTYDEL,NetAmt=PAMTDEL-Samtdel,Processdate=getdate()--CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
   from AngelNseCM.msajag.dbo.CMBILLVALAN where     
   SAUDA_DATE between @firstdate and @lastdate    
   /*SAUDA_DATE between '2016-10-27 00:00:00.000'    
  and '2016-10-31 00:00:00.000' --and clienttype='NBF' */    
  --SAUDA_DATE=CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
  and not(PAMTDEL=0 and SQTYDEL=0)     
    
    
      
    
    
  insert into EquityT2    
  select SETT_NO,sett_type,party_code,SCRIP_CD,series,SCRIP_NAME,ISIN,SAUDA_DATE,PQTYDEL,PAMTDEL,SQTYDEL,Samtdel,clienttype,SUB_BROKER,    
  branch_Cd,Exchange,Netqty=PQTYDEL-SQTYDEL,NetAmt=PAMTDEL-Samtdel,Processdate=getdate()--CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
   from AngelBSECM.BSEDB_AB.dbo.CMBILLVALAN where     
    SAUDA_DATE between @firstdate    
  and @lastdate    
   /*SAUDA_DATE between '2016-10-27 00:00:00.000'    
  and '2016-10-31 00:00:00.000' --and clienttype='NBF' */    
  --SAUDA_DATE=CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
  and not(PAMTDEL=0 and SQTYDEL=0)     
    
   update AGEING.AGEINGBUCKETINGCOMBINE set TOTALSECURITIES=TOTALSECURITIES+Convert(money,x.PFValue) from     
   (select Cltcode=PARTY_CODE,PFValue=SUM(PAMTDEL) from  EquityT2 --where PARTY_CODE='C20943'    
   where PAMTDEL<>0    
   group by PARTY_CODE)x where AGEING.AGEINGBUCKETINGCOMBINE.CLTCODE=x.Cltcode    
       
       
    
   --TOTAL SECURED    
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET SECURED=CASE     
   WHEN DEBIT-TOTALSECURITIES >= 0 THEN TOTALSECURITIES     
   ELSE DEBIT END WHERE DEBIT>0     
    
   --TOTAL UNSECURED    
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET UNSECURED=DEBIT-SECURED WHERE DEBIT>0     
    
   --SECURED MORE THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET SECUREMORE_6MNTH=    
   --CASE WHEN (DAY360+DAY361ABV)-TOTALSECURITIES>=0 THEN TOTALSECURITIES ELSE (DAY360+DAY361ABV) END    
    CASE WHEN (DAY360+Day730+Day1095+DAY1095ABV)-TOTALSECURITIES>=0 THEN TOTALSECURITIES ELSE (DAY360+Day730+Day1095+DAY1095ABV) END    
   WHERE DEBIT>0     
       --UNSECURED MORE THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE   
   --SET UNSECUREMORE_6MNTH=(DAY360+DAY361ABV)-SECUREMORE_6MNTH    
   SET UNSECUREMORE_6MNTH=(DAY360+Day730+Day1095+DAY1095ABV)-SECUREMORE_6MNTH   
   WHERE DEBIT>0     
    
   --SECURED LESS THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET SECURELESS_6MNTH=    
   CASE WHEN SECURED-SECUREMORE_6MNTH<=0 THEN 0 ELSE SECURED-SECUREMORE_6MNTH END    
   WHERE DEBIT>0     
    
   --UNSECURED LESS THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMBINE SET UNSECURELESS_6MNTH=    
   CASE WHEN UNSECURED-UNSECUREMORE_6MNTH<=0 THEN 0 ELSE UNSECURED-UNSECUREMORE_6MNTH END    
   WHERE DEBIT>0     
    
   SET @PROGRESSBAR= ' BUCKETING COMBINE COMPLETED......'     
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'      
       
  END      
      
 END    
 ELSE IF(@Segment='COMMODITY')     
 BEGIN    
  BEGIN      
    
   SET @PROGRESSBAR= 'BUCKETING COMMODITY STARTED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
        
   TRUNCATE TABLE AGEING.AGEINGBUCKETINGCOMMODITY    
       
   INSERT INTO AGEING.AGEINGBUCKETINGCOMMODITY    
   (CLTCODE,SUB_BROKER,PARENT_SB,CL_TYPE,AGEINGDATE,PROCESSDATA,NETBALANCE,CLIENTHOLDING,CLIENTHOLDINGADJ,SBCREDITNONCASH,    
   SBCREDITCASH,SBCREDITBAL,SBCREDITADJ)    
   SELECT     
   CLTCODE,SUB_BROKER,PARENT_SB,B2B_B2C,BAL_DATE,PROCESSDATE=GETDATE(),NET_COMMODITY,    
   --HOLDINGCOMMODITY,HLDNG_ADJCOMMODITY,    
   HOLDINGCOMMODITY=CONVERT(money,0.00),HLDNG_ADJCOMMODITY,    
   --SBNONCASHCOMBINE=ISNULL(SBNONCASHCOMMODITY,0)+ISNULL(FR_CREDIT_ADJUSTED,0),    
   SBNONCASHCOMBINE=ISNULL(SBNONCASHCOMMODITY,0),    
   SBCASHCOMBINE=ISNULL(SBCASHCOMMODITY,0),SBBALANCECOMBINE=ISNULL(SBBALANCECOMMODITY,0),    
   SBCREDITADJ=ISNULL(SBBAL_ADJUSTCOMMODITY,0)+    
   ISNULL(frbal_adjustCommodity,0)    
    FROM AGEING.TEMPCLIENT_COLLSBDETAILS_COMBINE     
     print 'pramod 2'    
   /*Changed by renil on 30th april 2015 to consider only physical holding as instructed by Sachin for commodity*/       
   SELECT PARTY_CODE,CLIENTHOLDING=SUM(TOTAL) INTO #CLIENTHOLDING FROM HISTORY.DBO.RMS_HOLDING     
   WHERE --SOURCE='H' AND    
   UPD_DATE BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   /*UPD_DATE BETWEEN '2016-02-01 00:00:00.000' AND '2016-02-01 23:59:59.000'*/    
   AND EXCHANGE IN ('MCX','NCX')    
   GROUP BY PARTY_CODE     
       
       
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY set CLIENTHOLDING=0.00          
    
   UPDATE A SET CLIENTHOLDING=CONVERT(MONEY,B.CLIENTHOLDING) FROM AGEING.AGEINGBUCKETINGCOMMODITY A,    
   (SELECT * FROM #CLIENTHOLDING)B    
   WHERE A.CLTCODE=B.PARTY_CODE     
       
       
   /**********************************************************/    
   select distinct party_code,amount into #bb from     
   HISTORY.DBO.CLIENT_COLLATERALS_HIST WHERE EffDate     
   --BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   BETWEEN '2017-07-01 00:00:00.000' AND '2017-07-01 23:59:59.000'    
   /*BETWEEN '2016-02-01 00:00:00.000' AND '2016-02-01 23:59:59.000'*/    
   --AND PARTY_CODE='MAHV058'     
   AND co_code IN ('MCX','NCDEX')    
       
   SELECT  PARTY_CODE,AMOUNT=SUM(AMOUNT) INTO #COLLATERALS    
    FROM      
   #bb  GROUP BY PARTY_CODE    
       
   /*         
   SELECT PARTY_CODE,AMOUNT=SUM(AMOUNT) INTO #COLLATERALS    
    FROM      
   HISTORY.DBO.CLIENT_COLLATERALS_HIST WHERE EffDate     
   BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   --BETWEEN '2016-09-29 00:00:00.000' AND '2016-09-29 23:59:59.000'    
   /*BETWEEN '2016-02-01 00:00:00.000' AND '2016-02-01 23:59:59.000'*/    
   --AND PARTY_CODE='MAHV058'     
   AND co_code IN ('MCX','NCDEX')    
   GROUP BY PARTY_CODE */    
   /**********************************************************/    
       
   UPDATE A SET CLIENTCOLLATERAL=CONVERT(MONEY,B.AMOUNT) FROM AGEING.AGEINGBUCKETINGCOMMODITY A,    
   (SELECT * FROM #COLLATERALS)B    
   WHERE A.CLTCODE=B.PARTY_CODE     
       
       
       
       
       
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY     
   SET     
   SBCREDITNONCASH_ADJ=(SBCREDITNONCASH*SBCREDITADJ)/(SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL),    
   SBCREDITCASHBAL_ADJ=((SBCREDITCASH+SBCREDITBAL)*SBCREDITADJ)/(SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL)    
   WHERE (SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL)>0    
       
   UPDATE     
   AGEING.AGEINGBUCKETINGCOMMODITY     
   --SET NET_DRCR=NETBALANCE-SBCREDITADJ    
   SET NET_DRCR=NETBALANCE-SBCREDITCASHBAL_ADJ    
       
   /*CLUBBING OF DEBITS AND CREDITS AND INTERSEGMENT ADJ*/    
   BEGIN    
    SET @PROGRESSBAR= 'CLUBBING AND INTERSEGMENT COMMODITY STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
       
   TRUNCATE TABLE #DRCRTrx1     
   INSERT INTO #DRCRTrx1    
   select cltcode,      
   CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)         
   from      
   (         
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingMCDXBal  group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingNCDXBal  group by cltcode    
   ) a       
   group by cltcode      
       
       
    /*iNTERSEGMENT CODE WILL GO HERE*/     
  IF @INTERSEGMENT='Y'      
   BEGIN      
    TRUNCATE TABLE #INTERSEGJV    
    INSERT INTO #INTERSEGJV    
     SELECT cltcode,      
     CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)        
     FROM      
     (      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingMcdxIjv  group by cltcode     
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingNcdxIjv  group by cltcode     
     ) X       
     GROUP BY CLTCODE      
          
     TRUNCATE TABLE #DRCRTRX     
     INSERT INTO #DRCRTRX      
     SELECT A.CLTCODE,      
    CR007Total=A.CR007Total-ISNULL(B.CR007Total,0),DR007Total=A.DR007Total-ISNULL(B.DR007Total,0),    
    CR015Total=A.CR015Total-ISNULL(B.CR015Total,0),DR015Total=A.DR015Total-ISNULL(B.DR015Total,0),    
    CR030Total=A.CR030Total-ISNULL(B.CR030Total,0),DR030Total=A.DR030Total-ISNULL(B.DR030Total,0),    
    CR060Total=A.CR060Total-ISNULL(B.CR060Total,0),DR060Total=A.DR060Total-ISNULL(B.DR060Total,0),    
    CR090Total=A.CR090Total-ISNULL(B.CR090Total,0),DR090Total=A.DR090Total-ISNULL(B.DR090Total,0),    
    CR180Total=A.CR180Total-ISNULL(B.CR180Total,0),DR180Total=A.DR180Total-ISNULL(B.DR180Total,0),    
    CR360Total=A.CR360Total-ISNULL(B.CR360Total,0),DR360Total=A.DR360Total-ISNULL(B.DR360Total,0),    
    CR365Total=A.CR365Total-ISNULL(B.CR365Total,0),DR365Total=A.DR365Total-ISNULL(B.DR365Total,0)      
     FROM #DRCRTRX1 A LEFT OUTER JOIN #INTERSEGJV B ON A.CLTCODE=B.CLTCODE      
         
   END     
  ELSE    
   BEGIN    
    TRUNCATE TABLE #DRCRTRX     
    INSERT INTO #DRCRTRX SELECT * FROM #DRCRTRX1       
   END       
       
       
  --DROP TABLE #DRCRTRX    
  --DROP TABLE #DRCRTRX1    
       
   SET @PROGRESSBAR= 'CLUBBING AND INTERSEGMENT COMMODITY COMPLETED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
       
  END    
       
   /* DEBIT BUCKETING */     
   BEGIN      
    SET @PROGRESSBAR= 'DEBIT BUCKETING COMMODITY STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
     --7     
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY7=    
    (CASE WHEN NET_DRCR <= DR007TOTAL THEN NET_DRCR ELSE DR007TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --15    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY15=    
    (CASE WHEN NET_DRCR-DAY7 >= DR015TOTAL THEN DR015TOTAL ELSE NET_DRCR-DAY7 END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --30    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY30=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15) >= DR030TOTAL THEN DR030TOTAL ELSE NET_DRCR-(DAY7+DAY15) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --60    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY60=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30) >= DR060TOTAL THEN DR060TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --90    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY90=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) >= DR090TOTAL THEN DR090TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --180    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY180=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) >= DR0180TOTAL     
    THEN DR0180TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --360    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY360=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) >= DR0360TOTAL     
    THEN DR0360TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --361 ABOVE    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY361ABV=    
    CASE WHEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360)>=0 THEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE 0 END WHERE NET_DRCR > 0        
        
    SET @PROGRESSBAR= 'DEBIT BUCKETING COMMODITY COMPLETED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
   END    
        
    /* CREDIT BUCKETING */    
   BEGIN      
    SET @PROGRESSBAR= 'CREDIT BUCKETING COMMODITY STARTED......'     
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'     
    --7     
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY7=    
    (CASE WHEN NET_DRCR >= CR007TOTAL THEN NET_DRCR ELSE CR007TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
    
        
    --15    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY15=    
    (CASE WHEN NET_DRCR-DAY7 >= CR015TOTAL THEN NET_DRCR-DAY7 ELSE CR015TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
        
        
      --30    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY30=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15) >= CR030TOTAL THEN NET_DRCR-(DAY7+DAY15) ELSE CR030TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --60    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY60=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30) >= CR060TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30) ELSE CR060TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
        
      --90    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY90=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) >= CR090TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) ELSE  CR090TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --180    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY180=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) >= CR0180TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) ELSE CR0180TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --360    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY360=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) >= CR0360TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) ELSE CR0360TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGCOMMODITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --361 ABOVE    
    UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET DAY361ABV=    
    CASE WHEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360)<0 THEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE 0 END WHERE NET_DRCR < 0       
        
    SET @PROGRESSBAR= 'CREDIT BUCKETING COMMODITY COMPLETED......'      
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'     
        
   END     
       
    
       
   UPDATE  AGEING.AGEINGBUCKETINGCOMMODITY SET DRCR=DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY361ABV    
   UPDATE  AGEING.AGEINGBUCKETINGCOMMODITY SET DEBIT=CASE WHEN DRCR>0 THEN DRCR ELSE 0 END    
       
    --Total Security    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY --SET TOTALSECURITIES=CLIENTHOLDING    
   --SET TOTALSECURITIES=CLIENTHOLDING+SbCreditNoncash_adj+CLIENTCOLLATERAL    
   SET TOTALSECURITIES=    
   CASE WHEN (CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL)<=0 THEN 0 ELSE     
   CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL END    
       
    
   --TOTAL SECURED    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET SECURED=CASE     
   WHEN DEBIT-TOTALSECURITIES >= 0 THEN TOTALSECURITIES     
   ELSE DEBIT END WHERE DEBIT>0     
    
   --TOTAL UNSECURED    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET UNSECURED=DEBIT-SECURED WHERE DEBIT>0     
    
   --SECURED MORE THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET SECUREMORE_6MNTH=    
   CASE WHEN (DAY360+DAY361ABV)-TOTALSECURITIES>=0 THEN TOTALSECURITIES ELSE (DAY360+DAY361ABV) END    
   WHERE DEBIT>0     
    
   --UNSECURED MORE THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET UNSECUREMORE_6MNTH=(DAY360+DAY361ABV)-SECUREMORE_6MNTH    
   WHERE DEBIT>0     
    
   --SECURED LESS THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET SECURELESS_6MNTH=    
   CASE WHEN SECURED-SECUREMORE_6MNTH<=0 THEN 0 ELSE SECURED-SECUREMORE_6MNTH END    
   WHERE DEBIT>0     
    
   --UNSECURED LESS THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGCOMMODITY SET UNSECURELESS_6MNTH=    
   CASE WHEN UNSECURED-UNSECUREMORE_6MNTH<=0 THEN 0 ELSE UNSECURED-UNSECUREMORE_6MNTH END    
   WHERE DEBIT>0     
    
   SET @PROGRESSBAR= ' BUCKETING COMMODITY COMPLETED......'     
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'     
       
  END            
 END     
 ELSE    
 BEGIN    
  BEGIN      
    
   SET @PROGRESSBAR= 'BUCKETING EQUITY STARTED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
        
   TRUNCATE TABLE AGEING.AGEINGBUCKETINGEQUITY    
       
   INSERT INTO AGEING.AGEINGBUCKETINGEQUITY    
   (CLTCODE,SUB_BROKER,PARENT_SB,CL_TYPE,AGEINGDATE,PROCESSDATA,NETBALANCE,CLIENTHOLDING,CLIENTHOLDINGADJ,SBCREDITNONCASH,    
   SBCREDITCASH,SBCREDITBAL,SBCREDITADJ)    
   SELECT     
   CLTCODE,SUB_BROKER,PARENT_SB,B2B_B2C,BAL_DATE,PROCESSDATE=GETDATE(),NET_EQUITY,    
   HOLDINGEQUITY,HLDNG_ADJEQUITY,    
   --HOLDINGEQUITY=Convert(money,0.00),HLDNG_ADJEQUITY,    
   --SBNONCASHCOMBINE=ISNULL(SBNONCASHEQUITY,0)+ISNULL(FR_CREDIT_ADJUSTED,0),    
   SBNONCASHCOMBINE=ISNULL(SBNONCASHEQUITY,0),    
   SBCASHCOMBINE=ISNULL(SBCASHEQUITY,0),SBBALANCECOMBINE=ISNULL(SBBALANCEEQUITY,0),SBCREDITADJ=ISNULL(SBBAL_ADJUSTEQUITY,0)    
    FROM AGEING.TEMPCLIENT_COLLSBDETAILS_COMBINE     
        
     print 'pramod 3'    
   /*Changed by renil on 30th april 2015 to consider only physical holding as instructed by Sachin for equity*/       
   SELECT PARTY_CODE,CLIENTHOLDING=SUM(TOTAL) INTO #CLIENTHOLDINGEQ FROM HISTORY.DBO.RMS_HOLDING     
   WHERE     
   --SOURCE='H' AND     
   UPD_DATE     
   /*BETWEEN '2016-02-01 00:00:00.000' AND '2016-02-01 23:59:59.000'*/    
   BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   AND EXCHANGE IN ('MTF','BSECM','NSECM','NSEFO','NSX','MCD')     
   GROUP BY PARTY_CODE     
       
   UPDATE AGEING.AGEINGBUCKETINGEQUITY set CLIENTHOLDING=0.00    
    
   UPDATE A SET CLIENTHOLDING=CONVERT(MONEY,B.CLIENTHOLDING) FROM AGEING.AGEINGBUCKETINGEQUITY A,    
   (SELECT * FROM #CLIENTHOLDINGEQ)B    
   WHERE A.CLTCODE=B.PARTY_CODE     
   /*******************************************************************/    
       
   select distinct party_code,amount into #cc from HISTORY.DBO.CLIENT_COLLATERALS_HIST WHERE     
   EffDate     
   /*BETWEEN '2016-02-01 00:00:00.000' AND '2016-02-01 23:59:59.000'*/    
   --BETWEEN '2016-09-29 00:00:00.000' AND '2016-09-29 23:59:59.000'    
   BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   --AND PARTY_CODE='A66807'     
   AND co_code IN ('MTF','BSECM','NSECM','NSEFO','NSX','MCD')    
       
   SELECT  PARTY_CODE,AMOUNT=SUM(AMOUNT) INTO #COLLATERALSEQ    
    FROM      
   #cc  GROUP BY PARTY_CODE     
   /*    
   SELECT PARTY_CODE,AMOUNT=SUM(AMOUNT) INTO #COLLATERALSEQ FROM      
   HISTORY.DBO.CLIENT_COLLATERALS_HIST WHERE EffDate     
   /*BETWEEN '2016-02-01 00:00:00.000' AND '2016-02-01 23:59:59.000'*/    
   --BETWEEN '2016-09-29 00:00:00.000' AND '2016-09-29 23:59:59.000'    
   BETWEEN CONVERT(DATETIME,@Agedate+' 00:00:00',103)  AND  CONVERT(DATETIME,@Agedate+' 23:59:59',103)      
   --AND PARTY_CODE='A66807'     
   AND co_code IN ('BSECM','NSECM','NSEFO','NSX','MCD')    
   GROUP BY PARTY_CODE*/    
   /*******************************************************************/     
          
   UPDATE A SET CLIENTCOLLATERAL=CONVERT(MONEY,B.AMOUNT) FROM AGEING.AGEINGBUCKETINGEQUITY A,    
   (SELECT * FROM #COLLATERALSEQ)B    
   WHERE A.CLTCODE=B.PARTY_CODE     
       
       
       
   UPDATE AGEING.AGEINGBUCKETINGEQUITY     
   SET     
   SBCREDITNONCASH_ADJ=(SBCREDITNONCASH*SBCREDITADJ)/(SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL),    
   SBCREDITCASHBAL_ADJ=((SBCREDITCASH+SBCREDITBAL)*SBCREDITADJ)/(SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL)    
   WHERE (SBCREDITNONCASH+SBCREDITCASH+SBCREDITBAL)>0    
       
          
   UPDATE     
   AGEING.AGEINGBUCKETINGEQUITY     
   --SET NET_DRCR=NETBALANCE-SBCREDITADJ    
   SET NET_DRCR=NETBALANCE-SBCREDITCASHBAL_ADJ    
       
   /*CLUBBING OF DEBITS AND CREDITS AND INTERSEGMENT ADJ*/    
   BEGIN    
    SET @PROGRESSBAR= 'CLUBBING AND INTERSEGMENT EQUITY STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
       
   TRUNCATE TABLE #DRCRTrx1     
   INSERT INTO #DRCRTrx1    
   select cltcode,      
   CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)         
   from      
   (         
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingBseBal  group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingNseBal  group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingFoBal  group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingNSXBal  group by cltcode    
   union all      
   select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
   CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
   CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
   CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
   CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
     from Ageing.temp_AgeingMCDBal  group by cltcode    
   ) a       
   group by cltcode      
       
       
    /*iNTERSEGMENT CODE WILL GO HERE*/     
  IF @INTERSEGMENT='Y'      
   BEGIN      
    TRUNCATE TABLE #INTERSEGJV    
    INSERT INTO #INTERSEGJV    
     SELECT cltcode,      
     CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)        
     FROM      
     (      
     select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingBseIjv  group by cltcode                 
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingNseIjv  group by cltcode    
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingFoIjv  group by cltcode      
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingMcdIjv  group by cltcode    
     UNION ALL      
      select CLTCODE,CR007Total=SUM(CR007Total),DR007Total=SUM(DR007Total),    
     CR015Total=SUM(CR015Total),DR015Total=SUM(DR015Total),CR030Total=SUM(CR030Total),DR030Total=SUM(DR030Total),    
     CR060Total=SUM(CR060Total),DR060Total=SUM(DR060Total),CR090Total=SUM(CR090Total),DR090Total=SUM(DR090Total),    
     CR180Total=SUM(CR180Total),DR180Total=SUM(DR180Total),CR360Total=SUM(CR360Total),DR360Total=SUM(DR360Total),    
     CR365Total=SUM(CR365Total),DR365Total=SUM(DR365Total)    
        from Ageing.temp_AgeingnsxIjv  group by cltcode     
     ) X       
     GROUP BY CLTCODE      
          
     TRUNCATE TABLE #DRCRTRX     
     INSERT INTO #DRCRTRX      
     SELECT A.CLTCODE,      
    CR007Total=A.CR007Total-ISNULL(B.CR007Total,0),DR007Total=A.DR007Total-ISNULL(B.DR007Total,0),    
    CR015Total=A.CR015Total-ISNULL(B.CR015Total,0),DR015Total=A.DR015Total-ISNULL(B.DR015Total,0),    
    CR030Total=A.CR030Total-ISNULL(B.CR030Total,0),DR030Total=A.DR030Total-ISNULL(B.DR030Total,0),    
    CR060Total=A.CR060Total-ISNULL(B.CR060Total,0),DR060Total=A.DR060Total-ISNULL(B.DR060Total,0),    
    CR090Total=A.CR090Total-ISNULL(B.CR090Total,0),DR090Total=A.DR090Total-ISNULL(B.DR090Total,0),    
    CR180Total=A.CR180Total-ISNULL(B.CR180Total,0),DR180Total=A.DR180Total-ISNULL(B.DR180Total,0),    
    CR360Total=A.CR360Total-ISNULL(B.CR360Total,0),DR360Total=A.DR360Total-ISNULL(B.DR360Total,0),    
    CR365Total=A.CR365Total-ISNULL(B.CR365Total,0),DR365Total=A.DR365Total-ISNULL(B.DR365Total,0)      
     FROM #DRCRTRX1 A LEFT OUTER JOIN #INTERSEGJV B ON A.CLTCODE=B.CLTCODE      
         
   END     
  ELSE    
   BEGIN    
    TRUNCATE TABLE #DRCRTRX     
    INSERT INTO #DRCRTRX SELECT * FROM #DRCRTRX1       
   END       
       
       
  --DROP TABLE #DRCRTRX    
  --DROP TABLE #DRCRTRX1    
      
   SET @PROGRESSBAR= 'CLUBBING AND INTERSEGMENT EQUITY COMPLETED......'    
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
  END    
       
   /* DEBIT BUCKETING */     
   BEGIN      
    SET @PROGRESSBAR= 'DEBIT BUCKETING EQUITY STARTED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
     --7     
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY7=    
    (CASE WHEN NET_DRCR <= DR007TOTAL THEN NET_DRCR ELSE DR007TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --15    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY15=    
    (CASE WHEN NET_DRCR-DAY7 >= DR015TOTAL THEN DR015TOTAL ELSE NET_DRCR-DAY7 END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
    --30    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY30=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15) >= DR030TOTAL THEN DR030TOTAL ELSE NET_DRCR-(DAY7+DAY15) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --60    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY60=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30) >= DR060TOTAL THEN DR060TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --90    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY90=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) >= DR090TOTAL THEN DR090TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --180    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY180=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) >= DR0180TOTAL     
    THEN DR0180TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --360    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY360=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) >= DR0360TOTAL     
    THEN DR0360TOTAL ELSE NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR > 0       
        
      --361 ABOVE    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY361ABV=    
    CASE WHEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360)>=0 THEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE 0 END WHERE NET_DRCR > 0        
        
    SET @PROGRESSBAR= 'DEBIT BUCKETING EQUITY COMPLETED......'    
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
   END    
        
    /* CREDIT BUCKETING */    
   BEGIN      
    SET @PROGRESSBAR= 'CREDIT BUCKETING EQUITY STARTED......'      
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
    --7     
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY7=    
    (CASE WHEN NET_DRCR >= CR007TOTAL THEN NET_DRCR ELSE CR007TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
    
        
    --15    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY15=    
    (CASE WHEN NET_DRCR-DAY7 >= CR015TOTAL THEN NET_DRCR-DAY7 ELSE CR015TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
        
        
      --30    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY30=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15) >= CR030TOTAL THEN NET_DRCR-(DAY7+DAY15) ELSE CR030TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --60    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY60=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30) >= CR060TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30) ELSE CR060TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0       
        
      --90    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY90=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) >= CR090TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60) ELSE  CR090TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --180    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY180=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) >= CR0180TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90) ELSE CR0180TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --360    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY360=    
    (CASE WHEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) >= CR0360TOTAL THEN NET_DRCR-(DAY7+DAY15+DAY30+DAY60+DAY90+DAY180) ELSE CR0360TOTAL END)      
    FROM  #DRCRTRX B       
    WHERE AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=B.CLTCODE AND NET_DRCR < 0        
        
      --361 ABOVE    
    UPDATE AGEING.AGEINGBUCKETINGEQUITY SET DAY361ABV=    
    CASE WHEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360)<0 THEN NET_DRCR-    
    (DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360) ELSE 0 END WHERE NET_DRCR < 0       
        
    SET @PROGRESSBAR= 'CREDIT BUCKETING EQUITY COMPLETED......'      
    RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
   END     
       
    
       
   UPDATE  AGEING.AGEINGBUCKETINGEQUITY SET DRCR=DAY7+DAY15+DAY30+DAY60+DAY90+DAY180+DAY360+DAY361ABV    
   UPDATE  AGEING.AGEINGBUCKETINGEQUITY SET DEBIT=CASE WHEN DRCR>0 THEN DRCR ELSE 0 END    
       
    --Total Security    
   --UPDATE AGEING.AGEINGBUCKETINGEQUITY --SET TOTALSECURITIES=CLIENTHOLDING    
   --SET TOTALSECURITIES=CLIENTHOLDING+SbCreditNoncash_adj+CLIENTCOLLATERAL    
       
   UPDATE AGEING.AGEINGBUCKETINGEQUITY --SET TOTALSECURITIES=CLIENTHOLDING    
   SET TOTALSECURITIES=    
   CASE WHEN (CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL)<=0 THEN 0 ELSE     
   CLIENTHOLDING+SBCREDITNONCASH_ADJ+CLIENTCOLLATERAL END    
       
   /*rAHUL SHAH*/    
   /*    
   SELECT * INTO #RCSC FROM [172.31.16.57].NBFC.DBO.RCS_31MAR2015_PWC     
   WHERE FUTUREQTY <> 0    
       
       
    
   SELECT PARTY_CODE,SUM(FUTUREQTY*CL_RATE) AS HOLDVALUE INTO #AC FROM #RCSC    
   GROUP BY PARTY_CODE    
       
       
   update AGEING.AGEINGBUCKETINGEQUITY set TOTALSECURITIES=TOTALSECURITIES+Convert(money,x.PFValue) from     
   (select Cltcode=PARTY_CODE,PFValue=SUM(HOLDVALUE) from  #AC    
   group by PARTY_CODE)x where AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=x.Cltcode    
   */    
   /**********************************/    
       
       
   /*general.dbo.BO_Sett_Mst----calender master*/    
       
  truncate table EquityT2    
    
  insert into EquityT2    
  select SETT_NO,sett_type,party_code,SCRIP_CD,series,SCRIP_NAME,ISIN,SAUDA_DATE,PQTYDEL,PAMTDEL,SQTYDEL,Samtdel,clienttype,SUB_BROKER,    
  branch_Cd,Exchange,Netqty=PQTYDEL-SQTYDEL,NetAmt=PAMTDEL-Samtdel,Processdate=getdate()--CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
   from AngelNseCM.msajag.dbo.CMBILLVALAN where     
   SAUDA_DATE between @firstdate and @lastdate    
   /*SAUDA_DATE between '2016-10-27 00:00:00.000'    
  and '2016-10-31 00:00:00.000' --and clienttype='NBF'*/     
  --SAUDA_DATE=CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
   and not(PAMTDEL=0 and SQTYDEL=0)     
      
    
      
    
    
  insert into EquityT2    
  select SETT_NO,sett_type,party_code,SCRIP_CD,series,SCRIP_NAME,ISIN,SAUDA_DATE,PQTYDEL,PAMTDEL,SQTYDEL,Samtdel,clienttype,SUB_BROKER,    
  branch_Cd,Exchange,Netqty=PQTYDEL-SQTYDEL,NetAmt=PAMTDEL-Samtdel,Processdate=getdate()--CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
   from AngelBSECM.BSEDB_AB.dbo.CMBILLVALAN where     
   SAUDA_DATE between @firstdate and @lastdate    
   /*SAUDA_DATE between '2016-10-27 00:00:00.000'    
  and '2016-10-31 00:00:00.000' --and clienttype='NBF' */    
  --SAUDA_DATE=CONVERT(DATETIME,@Agedate+' 00:00:00',103)    
   and not(PAMTDEL=0 and SQTYDEL=0)     
      
      
      
    
   update AGEING.AGEINGBUCKETINGEQUITY set TOTALSECURITIES=TOTALSECURITIES+Convert(money,x.PFValue) from     
   (select Cltcode=PARTY_CODE,PFValue=SUM(PAMTDEL) from  EquityT2 --where PARTY_CODE='C20943'    
   group by PARTY_CODE)x where AGEING.AGEINGBUCKETINGEQUITY.CLTCODE=x.Cltcode    
        
    
   --TOTAL SECURED    
   UPDATE AGEING.AGEINGBUCKETINGEQUITY SET SECURED=CASE     
   WHEN DEBIT-TOTALSECURITIES >= 0 THEN TOTALSECURITIES     
   ELSE DEBIT END WHERE DEBIT>0    
    
   --TOTAL UNSECURED    
   UPDATE AGEING.AGEINGBUCKETINGEQUITY SET UNSECURED=DEBIT-SECURED WHERE DEBIT>0    
    
   --SECURED MORE THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGEQUITY SET SECUREMORE_6MNTH=    
   CASE WHEN (DAY360+DAY361ABV)-TOTALSECURITIES>=0 THEN TOTALSECURITIES ELSE (DAY360+DAY361ABV) END    
   WHERE DEBIT>0     
    
   --UNSECURED MORE THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGEQUITY SET UNSECUREMORE_6MNTH=(DAY360+DAY361ABV)-SECUREMORE_6MNTH    
   WHERE DEBIT>0     
    
   --SECURED LESS THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGEQUITY SET SECURELESS_6MNTH=    
   CASE WHEN SECURED-SECUREMORE_6MNTH<=0 THEN 0 ELSE SECURED-SECUREMORE_6MNTH END    
   WHERE DEBIT>0     
    
   --UNSECURED LESS THAN 6 MONTHS    
   UPDATE AGEING.AGEINGBUCKETINGEQUITY SET UNSECURELESS_6MNTH=    
   CASE WHEN UNSECURED-UNSECUREMORE_6MNTH<=0 THEN 0 ELSE UNSECURED-UNSECUREMORE_6MNTH END    
   WHERE DEBIT>0     
    
   SET @PROGRESSBAR= ' BUCKETING EQUITY COMPLETED......'     
   RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
       
  END     
              
 END     
   DROP TABLE #DRCRTRX    
   DROP TABLE #DRCRTRX1    
  SET @PROGRESSBAR= 'BUCKETING PROCESS COMPLETED......'    
  RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'    
      
 END TRY    
 BEGIN CATCH    
     
  PRINT 'ERROR ENCOUNTERED DURING BUCKETING PROCESS.....'     
  SELECT @ErMessage = ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()    
  RAISERROR (@ErMessage,@ErSeverity,@ErState )    
      
 END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.AgeingProcess_DataFetching_MTF_07dec2025
-- --------------------------------------------------
--EXEC [Ageing].[AgeingProcess_DataFetching] 'Jan 31 2016','ALL','N','Y','N','N','Y'      
--EXEC [Ageing].[AgeingProcess_DataFetching] 'Jan 31 2016','COMMODITY','N','Y','N','Y','Y'      
--EXEC [Ageing].[AgeingProcess_DataFetching] 'Jan 31 2016','EQUITY','N','N','N','N','N'      
      
CREATE PROCEDURE [AgeingProcess_DataFetching_MTF_07dec2025]      
(      
@DT AS DATETIME,      
@CURRFYFROM AS DATETIME,      
@PREVFYFROM AS DATETIME,       
@Segment as varchar(15)      
)      
as      
set nocount on       
      
       
 BEGIN TRY      
    
 set @CURRFYFROM = dateadd(year,-3,@CURRFYFROM)    
 set @PREVFYFROM = dateadd(year,-2,@PREVFYFROM)    
       
  DECLARE      
  @ErMessage NVARCHAR(2048),      
  @ErSeverity INT,      
  @ErState INT      
  DECLARE @PROGRESSBAR VARCHAR(800)='STARTED'      
       
 SET @PROGRESSBAR= 'FETCHING PROCESS STARTED.....'       
 RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'       
       
 IF @Segment='Equity' OR @Segment='ALL'      
 BEGIN       
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
  BEGIN TRY      
  SET @PROGRESSBAR= 'EQUITY FETCHING PROCESS STARTED.....'       
  RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'       
---/* BSECM Fetch Data*/-------------------        
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingBseBal      
        
  INSERT INTO Ageing.temp_AgeingBseBal(CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)      
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
       
  CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
  DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),      
         
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,      
   LastTrxDate=Max(vdt)      
--into #BseBal      
  --into temp_AgeingBseBal      
  --from ReplicatedData.dbo.ANANDACCOUNT_ABLEDGER    
  from AngelBseCM.ACCOUNT_AB.dbo.LEDGER with (nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
  --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)      
  group by cltcode      
        
       
END       
---/* NSECM Fetch Data*/-------------------      
BEGIN      
      
  TRUNCATE TABLE Ageing.temp_AgeingNseBal      
        
  INSERT INTO Ageing.temp_AgeingNseBal (CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)      
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
    CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,     
  LastTrxDate=Max(vdt)      
  --into #NseBal      
  --into temp_AgeingNseBal      
  --from ReplicatedData.dbo.AngelNseCMACCOUNTLEDGER     
  from AngelNseCM.ACCOUNT.dbo.LEDGER with (nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
 --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)        
  group by cltcode      
        
       
END       
---/* NSEFO Fetch Data*/-------------------      
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingFoBal      
        
  INSERT INTO Ageing.temp_AgeingFoBal(CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)      
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
    CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,      
  LastTrxDate=Max(vdt)      
  --into #foBal      
  --into temp_AgeingFoBal      
  --from ReplicatedData.dbo.ACCOUNTFOLEDGER     
  from AngelFO.ACCOUNTFO.dbo.LEDGER with (nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
 --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)        
  group by cltcode      
        
      
END       
---/* NSX Fetch Data*/-------------------      
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingNsxBal      
        
  INSERT INTO Ageing.temp_AgeingNsxBal(CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)     
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
   CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,     
  LastTrxDate=Max(vdt)      
  --into #nsxBal      
  --into temp_AgeingNsxBal      
  -- from ReplicatedData.dbo.ACCOUNTCURFOLEDGER      
  from AngelFO.ACCOUNTCURFO.dbo.LEDGER with(nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
  --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)       
  group by cltcode      
        
       
END       
---/* MCD Fetch Data*/-------------------      
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingMcdBal      
        
  INSERT INTO Ageing.temp_AgeingMcdBal (CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)     
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
   CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,      
  LastTrxDate=Max(vdt)      
  --into #MCDBal      
  --into temp_AgeingMcdBal      
  --from ReplicatedData.dbo.ACCOUNTMCDXCDSLEDGER     
  from AngelCommodity.ACCOUNTMCDXCDS.dbo.LEDGER with(nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
  --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)       
  group by cltcode      
      
END       
      
      
---/* MTF Fetch Data* Addded by Prashant on 30 oct 2017/-------------------      
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingMTFBal      
        
  INSERT INTO Ageing.temp_AgeingMTFBal(CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)      
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
  CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,     
  LastTrxDate=Max(vdt)      
  --into #MCDBal      
  --into temp_AgeingMcdBal      
  from AngelNseCM.MTFTRADE.dbo.ledger  with(nolock)      
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
  --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)        
  group by cltcode      
      
END        
---END---------        
  SET @PROGRESSBAR= 'EQUITY FETCHING PROCESS COMPLETED.....'      
  RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'        
  END TRY      
  BEGIN CATCH      
   PRINT 'ERROR ENCOUNTERED DURING EQUITY FETCHING PROCESS.....'          
   SELECT @ErMessage = ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()      
   RAISERROR (@ErMessage,@ErSeverity,@ErState )      
  END CATCH      
 END       
       
  IF @Segment='Commodity' OR @Segment='ALL'      
 BEGIN       
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
  BEGIN TRY      
  SET @PROGRESSBAR= 'COMMODITY FETCHING PROCESS STARTED.....'       
  RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'       
---/* MCDX Fetch Data*/-------------------        
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingMcdxBal      
      
  INSERT INTO Ageing.temp_AgeingMcdxBal(CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)      
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
   CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,      
  LastTrxDate=Max(vdt)      
  --into #mcdxBal      
  --into temp_AgeingMcdxBal      
  --from ReplicatedData.dbo.ACCOUNTMCDXLEDGER      
  from AngelCommodity.ACCOUNTMCDX.dbo.LEDGER with (nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
  --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)        
  group by cltcode      
        
      
END       
---/* NCDX Fetch Data*/-------------------      
BEGIN      
  TRUNCATE TABLE Ageing.temp_AgeingNcdxBal      
        
  INSERT INTO Ageing.temp_AgeingNcdxBal(CLTCODE,BALAMT,CR007Total,DR007Total,CR015Total,DR015Total,CR030Total,DR030Total,CR060Total,DR060Total,CR090Total,DR090Total,    
  CR180Total,DR180Total,CR360Total,DR360Total,CR730Total,DR730Total,CR1095Total,DR1095Total,CR1096Total,DR1096Total,CR1097Total,DR1097Total,LastTrxDate)       
  select CLTCODE,BALAMT=SUM(case when drcr='D' then vamt else -VAMT end),      
  CR007Total=SUM(case when drcr='C' and vdt > @dt-08 then -vamt else 0 end),      
  DR007Total=SUM(case when drcr='D' and vdt > @dt-08 then vamt else 0 end),      
  CR015Total=SUM(case when drcr='C' and vdt <= @dt-08 and vdt > @dt-16 then -vamt else 0 end),      
  DR015Total=SUM(case when drcr='D' and vdt <= @dt-08 and vdt > @dt-16 then vamt else 0 end),      
  CR030Total=SUM(case when drcr='C' and vdt <= @dt-16 and vdt > @dt-31 then -vamt else 0 end),      
  DR030Total=SUM(case when drcr='D' and vdt <= @dt-16 and vdt > @dt-31 then vamt else 0 end),      
  CR060Total=SUM(case when drcr='C' and vdt <= @dt-31 and vdt > @dt-61 then -vamt else 0 end),      
  DR060Total=SUM(case when drcr='D' and vdt <= @dt-31 and vdt > @dt-61 then vamt else 0 end),      
  CR090Total=SUM(case when drcr='C' and vdt <= @dt-61 and vdt > @dt-91 then -vamt else 0 end),      
  DR090Total=SUM(case when drcr='D' and vdt <= @dt-61 and vdt > @dt-91 then vamt else 0 end),      
  CR180Total=SUM(case when drcr='C' and vdt <= @dt-91 and vdt > @dt-181 then -vamt else 0 end),      
  DR180Total=SUM(case when drcr='D' and vdt <= @dt-91 and vdt > @dt-181 then vamt else 0 end),      
  CR360Total=SUM(case when drcr='C' and vdt <= @dt-181 and vdt > @dt-361 then -vamt else 0 end),      
  DR360Total=SUM(case when drcr='D' and vdt <= @dt-181 and vdt > @dt-361 then vamt else 0 end),      
  --CR365Total=SUM(case when drcr='C' and vdt < @dt-361 then -vamt else 0 end),      
  --DR365Total=SUM(case when drcr='D' and vdt < @dt-361 then vamt else 0 end),      
  CR730Total=SUM(case when drcr='C' and vdt <= @dt-361 and vdt > @dt-731 then -vamt else 0 end),      
    DR730Total=SUM(case when drcr='D' and vdt <= @dt-361 and vdt > @dt-731 then vamt else 0 end),        
 CR1095Total=SUM(case when drcr='C' and vdt <= @dt-731 and vdt > @dt-1096 then -vamt else 0 end),      
 DR1095Total=SUM(case when drcr='D' and vdt <= @dt-731 and vdt > @dt-1096 then vamt else 0 end),       
 CR1096Total=SUM(case when drcr='C' and vdt < @dt-1096 then -vamt else 0 end),      
 DR1096Total=SUM(case when drcr='D' and vdt < @dt-1096 then vamt else 0 end),     
   --CR366Total=0,      
      -- DR366Total=0      
      CR1097Total=0,      
      DR1097Total=0,     
  LastTrxDate=Max(vdt)      
  --into #NcdxBal      
  --into temp_AgeingNcdxBal      
  --from ReplicatedData.dbo.ACCOUNTNCDXLEDGER      
  from AngelCommodity.ACCOUNTNCDX.dbo.LEDGER with(nolock)    
  where --CLTCODE='S0007' and       
  (VDT<=@dt and VDT>=@PrevFYfrom)      
  --and not (VTYP=18 and VDT=@currFYfrom)       
   and not (VTYP=18 and VDT>@currFYfrom)        
  group by cltcode      
        
       
END      
      
  SET @PROGRESSBAR= 'COMMODITY FETCHING PROCESS COMPLETED.....'        
  RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'       
  END TRY      
  BEGIN CATCH      
   PRINT 'ERROR ENCOUNTERED DURING COMMODITY FETCHING PROCESS.....'       
   SELECT @ErMessage = ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()      
   RAISERROR (@ErMessage,@ErSeverity,@ErState )      
  END CATCH      
 END      
       
 SET @PROGRESSBAR= 'FETCHING PROCESS COMPLETED.....'       
 RAISERROR (@PROGRESSBAR, 10, 0 ) WITH NOWAIT WAITFOR DELAY '00:00:01'      
       
 END TRY      
 BEGIN CATCH      
       
  PRINT 'ERROR ENCOUNTERED DURING FETCHING PROCESS.....'       
  SELECT @ErMessage = ERROR_MESSAGE(),@ErSeverity = ERROR_SEVERITY(),@ErState = ERROR_STATE()      
  RAISERROR (@ErMessage,@ErSeverity,@ErState )      
        
 END CATCH

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDSL_HOlding_info_new_Pledge_UP_bkp_25012024
-- --------------------------------------------------



CREATE Proc [dbo].[CDSL_HOlding_info_new_Pledge_UP_bkp_25012024]
as

select nise_party_code as party_Code,substring(client_code,1,8) as dpid,client_code as cltdpid into #poa  
from  
AngelDP4.dmat.dbo.TBL_CLIENT_MASTER with (nolock)  where ISNULL(poa_ver,'')=2 
and status='Active' AND nise_party_code is not null --and nise_party_code='KHAO1044'

select * into #client
from 
(
select distinct cl_code,cltdpid  from ANGELDEMAT.msajag.dbo.CLIENT4  B with (nolock)  WHERE  Defdp=1 and bankid in ('12033202','12033201','12033200') AND DEPOSITORY = 'CDSL'
union  
select distinct cl_code,cltdpid   from ANGELDEMAT.bsedb.dbo.CLIENT4  B with (nolock)  WHERE  Defdp=1 and bankid in ('12033202','12033201','12033200') AND DEPOSITORY = 'CDSL'
)a --where a.cl_code in (select distinct party_Code from #poa )

delete from #client where cl_code in (select distinct party_code  from client_details where cl_status='NRI')
delete from #client where cl_code in (select distinct party_code  from client_details where cl_type='NRI')

/*Source from neha*/
select party_code,isin,scrip_cd,short_qty into #Shortage from [INTRANET].risk.dbo.CMSVerified_Cash_ShrtVal with (nolock) --where party_code='F4050'

select  party_code=tradingid,hld_ac_code as BOID,hld_isin_code as isin,Free_Qty=isnull(Free_Qty,0.00),
pledge_qty=isnull(pledge_qty,0.00),datetimestamp=getdate()
into #temp 
from AngelDP4.dmat.citrus_usr.holding  r (nolock)  inner join #client c 
on r.tradingid=c.cl_code and r.hld_ac_code=c.cltdpid 

delete from #temp where Free_Qty=0.00 and pledge_qty=0.00

delete from #temp where isin='INE001A01036'

select * into #unpledge from [INTRANET].cms.dbo.VW_Unpledge_Request with (nolock)
--where cast(requestdate as date)=(select max(cast(requestdate as date)) from [INTRANET].cms.dbo.VW_Unpledge_Request)

--select U.*,S.status from #unpledge U inner join scrip_master S on U.isin=S.isin

/*NBFC blocking quatity adjustment*/
exec Upd_NBFC_Pledge_Process

update #temp set Free_Qty=(case when Free_Qty-t2.NBFC_Block_Qty>=0.00 then Free_Qty-t2.NBFC_Block_Qty else 0.00 end)
from tbl_nbfc_Pledge_Blocking_qty t2 with (nolock) where  #temp.party_code=t2.party_code and #temp.isin=t2.isin
--and  tbl_pledge_calculation.party_code='DELP2378'

if (select count(1) from [INTRANET].CMS.dbo.MTF_AutoRelease_log with (nolock) 
where cast(updatedon as date)=cast(getdate() as date))>=1
begin

		truncate table tbl_po_neha_22062022
		insert into tbl_po_neha_22062022
		select *  from  [MIS].Demat.dbo.VW_SharePO_Request_NRMS f with (nolock)

		/*Added to handle poor scrips updated in free qty (cusa po)*/
		select * into #po from [MIS].Demat.dbo.VW_SharePO_Request_NRMS f with (nolock)

		delete T  from #po T inner join scrip_master S on T.isin=S.isin
		where S.status='Poor'

		/*Update Branch PO Marking data*/
		update #temp set Free_Qty=Free_Qty+F.veirfied_qty from #po f with (nolock) inner join #temp T on F.party_code=T.party_code
		and F.isin=T.isin----40000

		insert into #temp
		select F.party_code,F.ClientCLTDPID,F.isin,F.veirfied_qty,0.00,getdate() from #po f with (nolock) left OUTER JOIN  #temp F1
		on F.party_code=F1.party_code and F.isin=F1.isin where F1.isin is null and F.veirfied_qty is not null--and  F.party_code='G63122' ----
		/*Update Branch PO Marking data*/
 end

select party_code,scrip_cd,series,certno,sum(qty) qty into #MTF_hold
from ANGELDEMAT.msajag.dbo.deltrans with (nolock) where  BCltDpId ='1203320030135829'
and drcr='d' and Delivered ='0' and Filler2 =1 and trtype ='904'
group by party_code,scrip_cd,series,certno

update #temp set Pledge_Qty=Pledge_Qty- qty from #MTF_hold M where 
#temp.party_code=M.party_code and #temp.isin=M.certno


select distinct isin into #MF_ISin
from
(
select distinct isin  from [AngelNseCM].msajag.dbo.SCRIP_APPROVED_MF  with (nolock)
union all 
select distinct isin from tbl_scripMaster_marginPledge with (nolock)
union all 
select distinct isin_Number from [tbl_ETF_list] with (nolock)
)a

delete from #temp where isin like 'INF%' and 
isin not in (select distinct isin from #MF_ISin with (nolock))
and pledge_qty=0

--union all select distinct isin from tbl_MF_Approved_List

alter table #temp add scripname varchar(500),Obligation int,unpledge int,Net_Free_Qty int,Net_Pldg_qty int
alter table #temp add POA varchar(10),Cls_Rate money,Var_Margin money,Value_BHC money,Value_AHC money,Value_BHC_NPA money
alter table #temp add Value_AHC_NPA money,Mobile_number varchar(50),Email varchar(500),Approved_Flag varchar(20),ISIN_Type varchar(50),NBFC_Block_Qty int,Client_Type varchar(50),Client_name varchar(200),Migrated varchar(20),BseCode varchar(20),NseSymbol varchar(100)

update #temp set Client_name =c.Party_name from vw_rms_client_vertical c with (nolock) where #temp.party_code=c.client
update #temp set NBFC_Block_Qty=isnull(t2.NBFC_Block_Qty,0.00) from tbl_nbfc_Pledge_Blocking_qty t2 with (nolock) where  #temp.party_code=t2.party_code and #temp.isin=t2.isin 
update #temp set NBFC_Block_Qty=0.00 where NBFC_Block_Qty is null

--select distinct accountid into #omnesys from [172.31.15.250].[uploader-db].dbo.V_InvestorName V with (nolock)
update #temp set Client_Type= 'Omnesys' --where  party_code  in ( select accountid COLLATE SQL_Latin1_General_CP1_CI_AS from #omnesys )
--update #temp set Client_Type='Odin' where Client_Type is null


--update tbl_pledge_calculation set BseCode=S.BseCode ,NseSymbol=S.NseSymbol from scrip_master S with (nolock)
--where tbl_pledge_calculation.isin=S.isin


update #temp set scripname= s.scripname,Approved_Flag=s.Status,BseCode=S.BseCode ,NseSymbol=S.NseSymbol 
from scrip_master s with(nolock) where #temp.isin=s.isin

delete from #temp where Approved_Flag='POOR' and pledge_qty=0.00
delete from #temp where Approved_Flag is null

update #temp set poa= 'Y' from #poa where #temp.party_code=#poa.party_Code
update #temp set poa= 'N' from #poa where poa is null
update #temp set poa= 'N' where party_code='RP61' 
update #temp set Obligation= isnull(s.short_qty,0.00) from #Shortage s 
where #temp.party_code=s.party_code and #temp.isin=s.isin 

update #temp set unpledge=MarkedQty from #unpledge U where #temp.party_code=U.party_code and  #temp.isin=U.isin 
update #temp set unpledge= 0.00 where unpledge is null
update #temp set Obligation= 0.00 where Obligation is null

/*
update #temp set pledge_qty=(case when Obligation>=Free_Qty then pledge_qty-(Obligation-Free_Qty) else pledge_qty end)
update #temp set unpledge=(case when Obligation>=Free_Qty then unpledge-pledge_qty else unpledge end)

--update #temp set Net_Free_Qty=(Free_Qty-pledge_qty)+unpledge-Obligation
update #temp set Net_Free_Qty=(Free_Qty)+unpledge-Obligation

update #temp set Net_Pldg_qty=(pledge_qty-unpledge-Obligation)
*/


update #temp set pledge_qty=(case when Obligation>=Free_Qty then pledge_qty-unpledge-(Obligation-Free_Qty) else pledge_qty-unpledge end) 
where pledge_qty>0.00 

update #temp set Net_Free_Qty=case when (Free_Qty)+unpledge-Obligation>0.00 then (Free_Qty)+unpledge-Obligation else 0.00 end 
update #temp set Net_Pldg_qty=pledge_qty
update #temp set Cls_Rate=r.MTM_Price from Combine_Closing_File r with(nolock) where #temp.isin=r.Security_ISIN

declare @date1 datetime ,@date2 datetime
set @date1=(select max(rate_date-15 ) from AngelDP4.dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK))
set @date2=(select max(rate_date-30 ) from AngelDP4.dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK))

select isin,Upd_date=max(rate_date)into #aa from AngelDP4.dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK)
where rate_date>=@date1  --where isin='INF179KB1HK0'
group by isin --17111

select isin,Upd_date=max(rate_date)into #rate from AngelDP4.dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK)
where rate_date>=@date2  --where isin='INF179KB1HK0'
group by isin --18287

select R.isin,close_price into #rate1 from AngelDP4.dmat.citrus_usr.VW_ISIN_RAte_master R  WITH (NOLOCK) inner join  #aa A on R.isin=A.isin and R.rate_date=A.Upd_date
select R.isin,close_price into #rate2 from AngelDP4.dmat.citrus_usr.VW_ISIN_RAte_master R  WITH (NOLOCK) inner join  #rate A on R.isin=A.isin and R.rate_date=A.Upd_date
select distinct A.isin,A.clsrate,A.scrip_cd into #rms_holding from rms_holding A where (scrip_cd like '9%'  or scrip_cd like '10%') and clsrate=0.00 and source='DP' 
and a.series not in ('MF_new','MF')

select distinct  A.isin,b.close_price 
into #CP_MF 
from DP_Holding a left outer join 
#rate1 b
on a.isin=b.isin where a.nseseries in ('MF_new','MF') and b.close_price is not null        ---1659           

 select distinct  A.isin,b.close_price
 into #bonds_rate   
 from #rms_holding a with (nolock) left outer join 
 #rate2 b
 on a.isin=b.isin where b.close_price is not null---387

/*For MF ISIN*/
update #temp set Cls_Rate=r.close_price from #CP_MF r where #temp.isin=r.isin and  #temp.cls_rate is null 
update #temp set Cls_Rate=r.close_price from #bonds_rate r where #temp.isin=r.isin and  #temp.cls_rate is null 


select distinct isin,nav_value,nav_date  into #mf_nav
from [172.31.16.75].ANGEL_WMS.dbo.dw_mst_bse_mf_scheme with (nolock) order by isin,nav_date desc

update #temp set Cls_Rate=r.nav_value from #mf_nav r where #temp.isin=r.isin and  #temp.cls_rate is null 
and #temp.isin like 'INF%'
update #temp set Cls_Rate=0.00 where #temp.cls_rate is null

/*
--select * from #temp where party_code='I1884'
create table #varrate
(bsecode varchar(20),nse_symbol varchar(20),series varchar(10),isin varchar(20),co_name varchar(100),nm varchar(25),focoll varchar(20),scrip_category varchar(15),
block_scrips varchar(50),bsevar money,nsevar money,angel_var money)


insert into #varrate
select * from TBL_NRMS_RESTRICTED_SCRIPS
*/

create table #varrate
(isin varchar(50),Var_Margin money)

insert into #varrate
select distinct isin,Haircut=min(ExchangeHairCut) from VW_RMS_HOLDING_WITHPOA with(nolock)
where source='H'
group by  isin 


select distinct isin,Var_margin=var_margin 
into #nse_var 
from fovar_margin 

create index #ix_var on #varrate ( isin)
create index #ix_nsevar on #nse_var ( isin)
create index #ix_pc on #temp ( party_code,isin)


update #temp set Var_Margin = isnull(v.Var_Margin,0.00)
from #nse_var v where v.isin=#temp.isin 

update #temp set Var_Margin = isnull(v.Var_Margin,0.00)
from #varrate v where v.isin=#temp.isin and #temp.Var_Margin is null

/*Added on Dec 03 2022 (Jira ID 1724)*/
update #temp set Var_Margin =20.00 where Var_Margin <20.00

update #temp set Var_Margin=10.00 
where isin in (select distinct ISIN_Number from [tbl_ETF_list])

update #temp set Var_Margin=10.00 
where isin like 'INF%'

update #temp set Var_Margin =0.00 where Var_Margin is null

update #temp set Value_BHC=Net_Free_Qty*Cls_Rate
update #temp set Value_AHC=Value_BHC-(Value_BHC*Var_Margin/100)

update #temp set Value_BHC_NPA=Net_Pldg_qty*Cls_Rate
update #temp set Value_AHC_NPA=Value_BHC_NPA-(Value_BHC_NPA*Var_Margin/100)

/*added to handle unpledge MF scrips
select * into #infcodes from #temp where isin like 'INF%' and 
isin not in (select distinct isin_Number from [tbl_ETF_list] with (nolock))
--and Pledge_Qty=0

update #temp set Free_Qty=0.00,Net_Free_Qty=0 from #infcodes F
where #temp.party_code=F.party_code and #temp.isin=F.isin
*/
--------------------------------------------

select nise_party_code,client_code,email_Add,FIRST_HOLD_MOBILE into #cl_email from AngelDP4.dmat.dbo.tbl_client_master with(nolock)

update #temp set Mobile_number=FIRST_HOLD_MOBILE from #cl_email c with (nolock) where #temp.party_code=C.nise_party_code
update #temp set Email=c.email_Add from #cl_email c with (nolock) where #temp.party_code=C.nise_party_code


-----------------------------------------------------------------------------------
----drop table tbl_pledge_calculation
select distinct isin,amc_code,scheme_name into #INF from [172.31.16.75].ANGEL_WMS.dbo.dw_mst_bse_mf_scheme with (nolock)
update #temp set ISIN_Type='MF' from #INF where #temp.isin=#INF.isin--60163
update #temp set scripname=scheme_name from #INF where #temp.isin=#INF.isin and  ISIN_Type='MF'--60163

/*update etf isin*/

 --select ISIN_Type='ETF',isin,s.scripname from #temp t inner join scrip_master s on  t.isin=s.isin where  s.scripname like '%etf%' 
update #temp set ISIN_Type='ETF' from scrip_master s with(nolock) where s.scripname like '%etf%' and #temp.isin=s.isin
update #temp set ISIN_Type='ETF' from scrip_master s with(nolock)  where s.scripname like '%Gold%' and s.Isin like 'INF%'  and #temp.isin=s.isin

update #temp set ISIN_Type='Equity'  where ISIN_Type is null

update #temp set Migrated='Y'
 
--select distinct party_code into #Non_Migrated from tbl_pledge_mapping with (nolock) where cast(Pldg_Req_Date as date)>cast(getdate() as date)

--update #temp set Migrated='N' where party_code in (select party_code from #Non_Migrated)

--delete from #temp where Value_AHC=0.00

--select * from #temp where isin='INE752E01010'
--select distinct isin from [196.1.115.195].ClientService.dbo.CrmSClientportfolioWithAh 
----select * from tbl_pledge_calculation where party_code='M103737' and ISIN_Type='MF'
--alter table tbl_pledge_calculation_Hist add qty_limit2 int

delete from #temp where  Net_Free_Qty<0
delete from #temp where  Net_Pldg_qty<0

delete from #temp where isin='INE001A01036'


--select * from  #temp where party_code='B27773'
/*
delete from tbl_pledge_calculation_Hist where cast(datetimestamp as date)=cast(getdate() as date)
insert into tbl_pledge_calculation_Hist
select * from tbl_pledge_calculation
*/

 IF  EXISTS (SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_pledge_calculation]') AND name = N'Idx_ID')    
 DROP INDEX [Idx_ID] ON [dbo].tbl_pledge_calculation WITH ( ONLINE = OFF )    


truncate table tbl_pledge_calculation
insert into tbl_pledge_calculation
select  party_code,Mobile_Num=Mobile_Number,Email,dpid=BOID,scripname,isin,Free_Qty,Pledge_Qty,datetimestamp=getdate(),
Obligation,Unpledge,POA,Net_Pldg_qty,qty=Net_Free_Qty,close_rate=Cls_Rate,total=Value_BHC,
nse_approved=approved_flag,var_mar=Var_Margin,net_amt=Value_AHC,net_pldg_amt=Value_AHC_NPA,ISIN_Type,NBFC_Block_Qty,Client_Type,Client_name,Migrated,0,0,bsecode,nsesymbol from #temp 

CREATE CLUSTERED INDEX [Idx_ID] ON [dbo].[tbl_pledge_calculation] (ID ASC) 

/*Added on Jan 19 2021 to resolve unpledge issue*/
update tbl_pledge_calculation set net_pldg_amt=1 where var_mar=100.00 and Free_Qty<>0.00 and close_rate>0.00

--update tbl_pledge_calculation set Free_Qty=729,qty=729 where party_code='RP61' and isin='INF247L01478'

/*ODIN
update tbl_pledge_calculation set qty_limit1=T.qty,qty_limit2= LIMIT_QTY from tbl_NewDPBgFile T with (nolock)
where tbl_pledge_calculation.party_code=T.PARTY_CODE and tbl_pledge_calculation.isin=T.isin
and Client_Type='Odin'

select a.*,b.QTY, b.LIMIT_QTY,b.VARMARGIN,b.CLOSINGPRICE into #OdinCusaPayout 
from [MIS].Demat.dbo.VW_SharePO_Request_NRMS a with (nolock) 
inner join tbl_NewDPBgFile b with (nolock)
on a.party_code=b.PARTY_CODE and  a.ISIN=b.ISIN and a.isin <>'INX528G01035'
       
select * into #odinclientinfo from [INTRANET].MIS.dbo.odinclientinfo with (nolock)
       
select a.*,b.tag into #OdinCusaPayout_withGroup from #OdinCusaPayout a inner join #odinclientinfo b
 on a.party_code=b.pcode
               
select *,QTY- Veirfied_Qty as normal_Qty, LIMIT_QTY-Veirfied_Qty as Final_Collater_Qty 
into #OdinotherDP from #OdinCusaPayout_withGroup where ClientCLTDPID not like  '%12033200%'
       
select *,LIMIT_QTY-Veirfied_Qty as Final_Collater_Qty into #OdinAngelDp from #OdinCusaPayout_withGroup where ClientCLTDPID  like  '%12033200%'
       
/*update #OdinAngelDp set VARMARGIN =100 where ISIN in (select distinct isin from tbl_ISIN_100per_Haricut)*/

update #OdinAngelDp set VARMARGIN =T.VARMARGIN  from tbl_ISIN_100per_Haricut T where #OdinAngelDp.isin=T.isin
update #OdinAngelDp set VARMARGIN =100 where ISIN in  (select distinct [ISIN No] from TBL_NRMS_RESTRICTED_SCRIPS with (nolock) where [Angel scrip category]='Poor')

update tbl_pledge_calculation set qty_limit2=O.Final_Collater_Qty 
from (select distinct party_code,isin,Final_Collater_Qty from #OdinAngelDp 
where Final_Collater_Qty>=0  and AccountType='BEN')  O
where tbl_pledge_calculation.party_code=O.party_code 
and tbl_pledge_calculation.isin=O.isin  and Client_Type='Odin'--34503
*/

/*OMNESYS*/
update tbl_pledge_calculation set qty_limit1=T.qty,qty_limit2= isnull(Collaterls_Qty,0.00) 
from tbl_DPDirectPush T with (nolock)
where tbl_pledge_calculation.party_code=T.PARTY_CODE 
and tbl_pledge_calculation.isin=T.isin
and Client_Type='Omnesys'
 
/*Added on Aug 12 2023 as required by Tushar Jorgial ORE -2605*/ 

select scrip as Scrip_cd,sum(markedqty) as Veirfied_Qty,party_code,ISIN,cltdpid as ClientCLTDPID   
into #cuspo
from [INTRANET].cms.dbo.tbl_CusaPO_File with(nolock)  group by        
scrip,party_code,ISIN,cltdpid
 
update T set qty_limit1 =qty_limit1+P.veirfied_qty from 
tbl_pledge_calculation T inner join #cuspo P on T.party_code=P.party_code
and T.isin=P.isin where  Client_Type='Omnesys'

select * into #mtf_unpledge 
from [INTRANET].cms.dbo.VW_Unpleadge_MTF with (nolock)

update T set qty_limit2 =qty_limit2-P.MarkedQty from 
tbl_pledge_calculation T inner join #mtf_unpledge P on T.party_code=P.party_code
and T.isin=P.isin where  Client_Type='Omnesys'


/*
select a.*,b.QTY, b.LIMIT_QTY,b.VARMARGIN,b.CLOSINGPRICE 
into #OmnesysCusapayout 
from [MIS].Demat.dbo.VW_SharePO_Request_NRMS a with (nolock) 
inner join tbl_Omne_NewDPBgFile b with (nolock)
on a.party_code=b.PARTY_CODE and  a.ISIN=b.ISIN and a.isin <>'INX528G01035'
       
select *,QTY- Veirfied_Qty as normal_Qty, LIMIT_QTY-Veirfied_Qty as Final_Collater_Qty 
into #OmnesysotherDP from #OmnesysCusapayout 
where ClientCLTDPID not like  '%12033200%'

select *,LIMIT_QTY-Veirfied_Qty as Final_Collater_Qty 
into #OmnesysAngelDp from #OmnesysCusapayout where ClientCLTDPID  like  '%12033200%'


/*update #OmnesysAngelDp set VARMARGIN =100 where ISIN in (select distinct isin from tbl_ISIN_100per_Haricut)*/          
update #OmnesysAngelDp set VARMARGIN =T.VARMARGIN  
from tbl_ISIN_100per_Haricut T where #OmnesysAngelDp.isin=T.ISIN
       
update #OmnesysAngelDp set VARMARGIN =100 
where ISIN in  (select distinct [ISIN No] from TBL_NRMS_RESTRICTED_SCRIPS with (nolock) 
where [Angel scrip category]='Poor')

update  tbl_pledge_calculation set qty_limit2=O.Final_Collater_Qty 
from 
(
select distinct party_code,isin,Final_Collater_Qty from #OmnesysAngelDp 
where Final_Collater_Qty>=0  and AccountType='BEN'
)  O
where tbl_pledge_calculation.party_code=O.party_code and tbl_pledge_calculation.isin=O.isin  
and Client_Type='Omnesys'--79826
*/

delete from tbl_pledge_calculation where isin='INE797F01012'

--select * from tbl_pledge_calculation where net_pldg_amt =0 and net_pldg_qty > 0

/*Unpledge issue of MF scrips
update tbl_pledge_calculation set net_pldg_amt=1 ,net_amt=1
where net_pldg_amt =0 and net_pldg_qty > 0  and isin like 'inf%'

*/

/*Added to handle poor scrips pledge issue ,added on Aug 23 2023*/

update tbl_pledge_calculation set Free_Qty=0.00,qty=0.00 
where nse_approved='POOR' and Free_Qty>0 and Pledge_Qty>0



Declare @OdinTime datetime,@OmnesysTime Datetime,@CDSL_ProcessTime  Datetime

select  @OdinTime= max(insert_date) from tbl_NewDPBgFile
select @OmnesysTime= max(insert_date) from tbl_Omne_NewDPBgFile
select @CDSL_ProcessTime= max(datetimestamp) from tbl_pledge_calculation

truncate table Tbl_CDSL_PledgeProcess_Log
insert into Tbl_CDSL_PledgeProcess_Log
select 'CDSL Pledge Process','Completed',@CDSL_ProcessTime,@OdinTime,@OmnesysTime


INSERT INTO intranet.sms.dbo.sms    
SELECT Mobile_No,'CDSL Pledge Process Completed Successfully.',CONVERT(VARCHAR(10), Getdate(), 103) as [Date],Ltrim(Rtrim(Str(Datepart(hh, Dateadd(minute, 15, Getdate())))))  
+ ':'+ Ltrim(Rtrim(Str(Datepart(minute, Dateadd(minute, 15, Getdate()))))) as [Time],'P' as flag,  
CASE WHEN ( Datepart(hh, Dateadd(minute, 15, Getdate())) ) >= 12 THEN 'PM' ELSE 'AM' END [AMPM],'Info' as purpose
from tbl_Pledge_Calculation_Intimation  --where Emp_No in ('Vishal Gohil','Abha Jaiswal')

exec Upd_CDSL_PleadgeDelay_Mailer


if(@CDSL_ProcessTime<@OdinTime or @CDSL_ProcessTime<@OmnesysTime)
begin
	declare @Status varchar(20)         
	set @Status=''          
	exec NRMS_JoBStatus 'CDSLLimitUpdateDelay',@Status  output    
	if(@Status='In Progress')          
	begin          
	  print 'job is already running'      
	end          
	else          
	begin         
	  EXEC [CSOKYC-6].msdb.dbo.sp_start_job 'CDSLLimitUpdateDelay'      
	end    
end
else 
begin
print 'byee'

end


--where  Net_Free_Qty>0

/*
select  distinct  top 50 isin ,scripname from tbl_pledge_calculation 
where Free_Qty>0 and isin_type ='Equity' AND POA='n'

*/

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDSL_HOlding_info_new_Pledge_UP_MovetoLiveDec2023
-- --------------------------------------------------

CREATE Proc [dbo].[CDSL_HOlding_info_new_Pledge_UP_MovetoLiveDec2023]
as
Begin
	select nise_party_code as party_Code,client_code,email_Add,FIRST_HOLD_MOBILE,status,poa_ver
	into #TBL_CLIENT_MASTER  
	from  
	[172.31.16.108].dmat.dbo.TBL_CLIENT_MASTER with (nolock)
	--where ISNULL(poa_ver,'')=2 
	--and status='Active' AND nise_party_code is not null --39 sec

	create clustered index idx_pc on #poa(party_Code)

	select *,Migrated='Y',POA='N',ISIN_Type='Equity',Client_Type='Omnesys' into #client
	from 
	(
	select distinct cl_code,cltdpid  from ANGELDEMAT.msajag.dbo.CLIENT4  B with (nolock)  
	WHERE  Defdp=1 and bankid in ('12033202','12033201','12033200') AND DEPOSITORY = 'CDSL'
	union  
	select distinct cl_code,cltdpid   from ANGELDEMAT.bsedb.dbo.CLIENT4  B with (nolock)  
	WHERE  Defdp=1 and bankid in ('12033202','12033201','12033200') AND DEPOSITORY = 'CDSL'
	)a --where a.cl_code in (select distinct party_Code from #poa )  1:01


	create clustered index idx_pc on #client (cl_code)

	--4.5 min
	delete from #client where cl_code in (select distinct party_code  from client_details where cl_status='NRI')
	delete from #client where cl_code in (select distinct party_code  from client_details where cl_type='NRI')
	--12 sec
	alter table #client add Mobile_number varchar(50),Email varchar(500),Client_Type varchar(50),Client_name varchar(200)

	update #client set Client_name =c.Party_name from 
	vw_rms_client_vertical c with (nolock) where #client.cl_code=c.client--3min

	update #client set Mobile_number=FIRST_HOLD_MOBILE,Email=c.email_Add 
	from #TBL_CLIENT_MASTER c with (nolock) where #client.cl_code=C.party_Code--4:29

	update #client set poa= 'Y' from #TBL_CLIENT_MASTER T where #client.cl_code=T.party_Code
	and isnull(poa_ver,'')=2 
	and status='Active' AND T.party_Code is not null

	select party_code=tradingid,hld_ac_code as BOID,hld_isin_code as isin,Free_Qty=isnull(Free_Qty,0.00),
	pledge_qty=isnull(pledge_qty,0.00),Client_name,Mobile_number,Email,Client_Type,
	Migrated,poa,ISIN_Type,datetimestamp=getdate()
	into #temp 
	from [172.31.16.108].dmat.citrus_usr.holding  r (nolock)  inner join #client c 
	on r.tradingid=c.cl_code and r.hld_ac_code=c.cltdpid 
	where Free_Qty<>0.00 or pledge_qty<>0.00--3min 23 sec

	create clustered index idx_pc_isin on #temp(party_code,isin)


	select distinct isin into #MF_ISin
	from
	(
	select distinct isin  from [AngelNseCM].msajag.dbo.SCRIP_APPROVED_MF  with (nolock)
	union all 
	select distinct isin from tbl_scripMaster_marginPledge with (nolock)
	union all 
	select distinct isin_Number from [tbl_ETF_list] with (nolock)
	)a

	delete from #temp where isin like 'INF%' and 
	isin not in (select distinct isin from #MF_ISin with (nolock))
	and pledge_qty=0

	alter table #temp add scripname varchar(500),Cls_Rate money,Var_Margin money,Approved_Flag varchar(20),NBFC_Block_Qty int

	update #temp set scripname= s.scripname,Approved_Flag=s.Status from scrip_master s with(nolock) 
	where #temp.isin=s.isin

	delete from #temp where Approved_Flag='POOR' and pledge_qty=0.00
	delete from #temp where Approved_Flag is null


	/*NBFC blocking quatity adjustment*/
	exec Upd_NBFC_Pledge_Process

	update #temp set Free_Qty=(case when Free_Qty-t2.NBFC_Block_Qty>=0.00 then Free_Qty-t2.NBFC_Block_Qty else 0.00 end)
	from tbl_nbfc_Pledge_Blocking_qty t2 with (nolock) where  #temp.party_code=t2.party_code and #temp.isin=t2.isin
	--and  tbl_pledge_calculation.party_code='DELP2378' --1 sec

	update #temp set NBFC_Block_Qty=isnull(t2.NBFC_Block_Qty,0.00) 
	from tbl_nbfc_Pledge_Blocking_qty t2 with (nolock) 
	where  #temp.party_code=t2.party_code and #temp.isin=t2.isin 

	update #temp set NBFC_Block_Qty=0.00 where NBFC_Block_Qty is null


	if (select count(1) from [INTRANET].CMS.dbo.MTF_AutoRelease_log with (nolock) 
	where cast(updatedon as date)=cast(getdate() as date))>=1
	begin
		truncate table tbl_po_neha_22062022
		insert into tbl_po_neha_22062022
		select *  from  [MIS].Demat.dbo.VW_SharePO_Request_NRMS f with (nolock)

		/*Added to handle poor scrips updated in free qty (cusa po)*/
		select * into #po from [MIS].Demat.dbo.VW_SharePO_Request_NRMS f with (nolock)

		delete T  from #po T inner join scrip_master S on T.isin=S.isin
		where S.status='Poor'

		/*Update Branch PO Marking data*/
		update #temp set Free_Qty=Free_Qty+F.veirfied_qty from #po f with (nolock) inner join #temp T on F.party_code=T.party_code
		and F.isin=T.isin----40000

		insert into #temp
		select F.party_code,F.ClientCLTDPID,F.isin,F.veirfied_qty,0.00,getdate() from #po f with (nolock) left OUTER JOIN  #temp F1
		on F.party_code=F1.party_code and F.isin=F1.isin where F1.isin is null and F.veirfied_qty is not null--and  F.party_code='G63122' ----
	end

	select party_code,scrip_cd,series,certno,sum(qty) qty into #MTF_hold
	from ANGELDEMAT.msajag.dbo.deltrans with (nolock) where  BCltDpId ='1203320030135829'
	and drcr='d' and Delivered ='0' and Filler2 =1 and trtype ='904'
	group by party_code,scrip_cd,series,certno--0 sec

	create clustered index idx_pc_isin on #MTF_hold(party_code,isin)


	update #temp set Pledge_Qty=Pledge_Qty- qty from #MTF_hold M where 
	#temp.party_code=M.party_code and #temp.isin=M.certno---2 sec

	alter table #temp add Obligation int,unpledge int,Net_Free_Qty int,Net_Pldg_qty int,Value_BHC money,Value_AHC money,Value_BHC_NPA money,Value_AHC_NPA money
	--select * into tbl_pledgedatauat from #temp

	/*Source from neha*/
	select party_code,isin,scrip_cd,short_qty into #Shortage 
	from [INTRANET].risk.dbo.CMSVerified_Cash_ShrtVal with (nolock) --where party_code='F4050'

	create clustered index idx_pc_isin on #Shortage(party_code,isin)


	update #temp set Obligation= isnull(s.short_qty,0.00) from #Shortage s 
	where #temp.party_code=s.party_code and #temp.isin=s.isin 

	select * into #unpledge from [INTRANET].cms.dbo.VW_Unpledge_Request with (nolock)

	update #temp set unpledge=MarkedQty from #unpledge U where #temp.party_code=U.party_code and  #temp.isin=U.isin 
	update #temp set unpledge= 0.00 where unpledge is null
	update #temp set Obligation= 0.00 where Obligation is null

	update #temp set pledge_qty=(case when Obligation>=Free_Qty then pledge_qty-unpledge-(Obligation-Free_Qty) else pledge_qty-unpledge end) 
	where pledge_qty>0.00 
	update #temp set Net_Free_Qty=case when (Free_Qty)+unpledge-Obligation>0.00 then (Free_Qty)+unpledge-Obligation else 0.00 end 
	update #temp set Net_Pldg_qty=pledge_qty
	update #temp set Cls_Rate=r.MTM_Price 
	from Combine_Closing_File r with(nolock) where #temp.isin=r.Security_ISIN

	delete from #temp where  Net_Free_Qty<0
	delete from #temp where  Net_Pldg_qty<0

	declare @date1 datetime ,@date2 datetime
	set @date1=(select max(rate_date-15 ) from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK))
	set @date2=(select max(rate_date-30 ) from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK))

	select isin,Upd_date=max(rate_date)into #aa from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK)
	where rate_date>=@date1  --where isin='INF179KB1HK0'
	group by isin --17111

	select isin,Upd_date=max(rate_date)into #rate from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK)
	where rate_date>=@date2  --where isin='INF179KB1HK0'
	group by isin --18287

	select R.isin,close_price into #rate1 from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master R  WITH (NOLOCK) inner join  #aa A on R.isin=A.isin and R.rate_date=A.Upd_date
	select R.isin,close_price into #rate2 from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master R  WITH (NOLOCK) inner join  #rate A on R.isin=A.isin and R.rate_date=A.Upd_date

	select distinct A.isin,A.clsrate,A.scrip_cd into #rms_holding from rms_holding A with (nolock) 
	where (scrip_cd like '9%'  or scrip_cd like '10%') and clsrate=0.00 and source='DP' 
	and a.series not in ('MF_new','MF')

	select distinct  A.isin,b.close_price 
	into #CP_MF 
	from DP_Holding a left outer join 
	#rate1 b
	on a.isin=b.isin where a.nseseries in ('MF_new','MF') and b.close_price is not null        ---1659           

	 select distinct  A.isin,b.close_price
	 into #bonds_rate   
	 from #rms_holding a with (nolock) left outer join 
	 #rate2 b
	 on a.isin=b.isin where b.close_price is not null---387

	 create clustered index idx_isin on #CP_MF(isin)
	 create clustered index idx_isin on #bonds_rate(isin)


	/*For MF ISIN*/
	update #temp set Cls_Rate=r.close_price from #CP_MF r where #temp.isin=r.isin and  #temp.cls_rate is null 
	update #temp set Cls_Rate=r.close_price from #bonds_rate r where #temp.isin=r.isin and  #temp.cls_rate is null 

	select distinct isin,nav_value,nav_date,amc_code,scheme_name  into #mf_nav
	from [172.31.16.75].ANGEL_WMS.dbo.dw_mst_bse_mf_scheme with (nolock) order by isin,nav_date desc

	create clustered index idx_isin on #mf_nav(isin)

	update #temp set Cls_Rate=r.nav_value from #mf_nav r where #temp.isin=r.isin and  #temp.cls_rate is null 
	and #temp.isin like 'INF%'
	update #temp set Cls_Rate=0.00 where #temp.cls_rate is null

	update #temp set ISIN_Type='MF' from #INF where #temp.isin=#INF.isin--60163
	update #temp set scripname=scheme_name from #INF where #temp.isin=#INF.isin and  ISIN_Type='MF'--60163

	create table #varrate
	(isin varchar(50),Var_Margin money)

	select distinct B.isin,ExchangeHairCut =(CASE WHEN ISNULL(B.BSE_VAR, 100) >= ISNULL(B.NSE_VAR, 100)    
								 THEN ISNULL(B.BSE_VAR, 100)    
								 WHEN ISNULL(B.BSE_VAR, 100) < ISNULL(B.NSE_VAR, 100)    
								 THEN ISNULL(B.NSE_VAR, 100)    
								 ELSE 100 end) into #vardata 
	from  SCRIPVAR_MASTER B with (nolock) where isin like 'INE%'

	insert into #varrate
	select distinct isin,Haircut=min(ExchangeHairCut) from VW_RMS_HOLDING_WITHPOA with(nolock)
	where source='H'
	group by  isin 

	select distinct isin,Var_margin=var_margin 
	into #nse_var 
	from fovar_margin 

	create index #ix_var on #varrate ( isin)
	create index #ix_nsevar on #nse_var ( isin)
	--create nonclustered index #nix_pc_isin on #temp ( party_code,isin)


	update #temp set Var_Margin = isnull(v.Var_Margin,0.00)
	from #nse_var v where v.isin=#temp.isin 

	update #temp set Var_Margin = isnull(v.Var_Margin,0.00)
	from #varrate v where v.isin=#temp.isin and #temp.Var_Margin is null

	/*Added on Dec 03 2022 (Jira ID 1724)*/
	update #temp set Var_Margin =20.00 where Var_Margin <20.00

	update #temp set Var_Margin=10.00 
	where isin in (select distinct ISIN_Number from [tbl_ETF_list])

	update #temp set Var_Margin=10.00 
	where isin like 'INF%'

	update #temp set Var_Margin =0.00 where Var_Margin is null

	update #temp set Value_BHC=Net_Free_Qty*Cls_Rate
	update #temp set Value_AHC=Value_BHC-(Value_BHC*Var_Margin/100)

	update #temp set Value_BHC_NPA=Net_Pldg_qty*Cls_Rate
	update #temp set Value_AHC_NPA=Value_BHC_NPA-(Value_BHC_NPA*Var_Margin/100)

	/*update etf isin*/

	 --select ISIN_Type='ETF',isin,s.scripname from #temp t inner join scrip_master s on  t.isin=s.isin where  s.scripname like '%etf%' 
	update #temp set ISIN_Type='ETF' from scrip_master s with(nolock) where s.scripname like '%etf%' and #temp.isin=s.isin
	update #temp set ISIN_Type='ETF' from scrip_master s with(nolock)  where s.scripname like '%Gold%' and s.Isin like 'INF%'  and #temp.isin=s.isin


	--IF  EXISTS (SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_pledge_calculation_uatnew]') AND name = N'Idx_ID')    
	--DROP INDEX [Idx_ID] ON [dbo].tbl_pledge_calculation_uatnew WITH ( ONLINE = OFF )    

	truncate table tbl_pledge_calculation_uatnew
	insert into tbl_pledge_calculation_uatnew
	select  party_code,Mobile_Num=Mobile_Number,Email,dpid=BOID,scripname,isin,Free_Qty,Pledge_Qty,datetimestamp=getdate(),
	Obligation,Unpledge,POA,Net_Pldg_qty,qty=Net_Free_Qty,close_rate=Cls_Rate,total=Value_BHC,
	nse_approved=approved_flag,var_mar=Var_Margin,net_amt=Value_AHC,net_pldg_amt=Value_AHC_NPA,ISIN_Type,NBFC_Block_Qty,Client_Type,Client_name,Migrated,0,0,'','' from #temp 

	CREATE CLUSTERED INDEX [Idx_ID] ON [dbo].tbl_pledge_calculation_uatnew (ID ASC) 

	/*Added on Jan 19 2021 to resolve unpledge issue*/
	update tbl_pledge_calculation_uatnew set net_pldg_amt=1 where var_mar=100.00 and Free_Qty<>0.00 and close_rate>0.00

	update tbl_pledge_calculation_uatnew set qty_limit1=T.qty,qty_limit2= isnull(Collaterls_Qty,0.00) 
	from tbl_DPDirectPush T with (nolock)
	where tbl_pledge_calculation_uatnew.party_code=T.PARTY_CODE 
	and tbl_pledge_calculation_uatnew.isin=T.isin
	and Client_Type='Omnesys'

	/*Added on Aug 12 2023 as required by Tushar Jorgial ORE -2605*/ 

	select scrip as Scrip_cd,sum(markedqty) as Veirfied_Qty,party_code,ISIN,cltdpid as ClientCLTDPID   
	into #cuspo
	from [INTRANET].cms.dbo.tbl_CusaPO_File with(nolock)  group by        
	scrip,party_code,ISIN,cltdpid

	create clustered index idx_pc_isin on #cuspo(party_code,isin)

	update T set qty_limit1 =qty_limit1+P.veirfied_qty from 
	tbl_pledge_calculation_uatnew T inner join #cuspo P on T.party_code=P.party_code
	and T.isin=P.isin where  Client_Type='Omnesys'

	select * into #mtf_unpledge 
	from [INTRANET].cms.dbo.VW_Unpleadge_MTF with (nolock)

	create clustered index idx_pc_isin on #mtf_unpledge(party_code,isin)


	update T set qty_limit2 =qty_limit2-P.MarkedQty from 
	tbl_pledge_calculation_uatnew T inner join #mtf_unpledge P on T.party_code=P.party_code
	and T.isin=P.isin where  Client_Type='Omnesys'

	delete from tbl_pledge_calculation_uatnew where isin='INE797F01012'

	/*Unpledge issue of MF scrips*/
	update tbl_pledge_calculation_uatnew set net_pldg_amt=1 ,net_amt=1
	where net_pldg_amt =0 and net_pldg_qty > 0  and isin like 'inf%'

	Declare @OdinTime datetime,@OmnesysTime Datetime,@CDSL_ProcessTime  Datetime

	select  @OdinTime= max(insert_date) from tbl_NewDPBgFile
	select @OmnesysTime= max(insert_date) from tbl_Omne_NewDPBgFile
	select @CDSL_ProcessTime= max(datetimestamp) from tbl_pledge_calculation_uatnew

	truncate table Tbl_CDSL_PledgeProcess_Log
	insert into Tbl_CDSL_PledgeProcess_Log
	select 'CDSL Pledge Process','Completed',@CDSL_ProcessTime,@OdinTime,@OmnesysTime


end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CDSL_HOlding_info_new_Pledge_UP_newopt11032023
-- --------------------------------------------------
CREATE Proc [dbo].[CDSL_HOlding_info_new_Pledge_UP_newopt11032023]
as
Begin
	select nise_party_code as party_Code,client_code,email_Add,FIRST_HOLD_MOBILE,status,poa_ver,first_hold_name
	into #TBL_CLIENT_MASTER  
	from [172.31.16.108].dmat.dbo.TBL_CLIENT_MASTER with (nolock)--5:20
		
	create clustered index idx_pc on #TBL_CLIENT_MASTER (party_Code)--2:50

	select *,Migrated='Y',POA='N',ISIN_Type='Equity',Client_Type='Omnesys' into #client
	from 
	(
	select distinct cl_code,cltdpid  from ANGELDEMAT.msajag.dbo.CLIENT4  B with (nolock)  
	WHERE  Defdp=1 and bankid in ('12033202','12033201','12033200') AND DEPOSITORY = 'CDSL'
	union  
	select distinct cl_code,cltdpid   from ANGELDEMAT.bsedb.dbo.CLIENT4  B with (nolock)  
	WHERE  Defdp=1 and bankid in ('12033202','12033201','12033200') AND DEPOSITORY = 'CDSL'
	)a --where a.cl_code in (select distinct party_Code from #poa )  --4:09(20348008)

	create clustered index idx_pc on #client (cl_code)--3:10

	--4.5 min
	delete from #client where cl_code in (select distinct party_code  from client_details where cl_status='NRI' or cl_type='NRI')
	--delete from #client where cl_code in (select distinct party_code  from client_details where cl_type='NRI')
	--12 sec
	alter table #client add Mobile_number varchar(50),Email varchar(500),Client_name varchar(200)

	--update #client set Client_name =c.Party_name from 
	--vw_rms_client_vertical c with (nolock) where #client.cl_code=c.client--3min

	update #client set Mobile_number=FIRST_HOLD_MOBILE,Email=c.email_Add ,Client_name=c.first_hold_name
	from #TBL_CLIENT_MASTER c with (nolock) where #client.cl_code=C.party_Code--8:43

	update #client set poa= 'Y' from #TBL_CLIENT_MASTER T where #client.cl_code=T.party_Code
	and isnull(poa_ver,'')=2 
	and status='Active' AND T.party_Code is not null--20 sec

	select party_code=tradingid,hld_ac_code as BOID,hld_isin_code as isin,Free_Qty=isnull(Free_Qty,0.00),
	pledge_qty=isnull(pledge_qty,0.00),Client_name,Mobile_number,Email,Client_Type,
	Migrated,poa,ISIN_Type,datetimestamp=getdate()
	into #temp 
	from [172.31.16.108].dmat.citrus_usr.holding  r (nolock)  inner join #client c 
	on r.tradingid=c.cl_code and r.hld_ac_code=c.cltdpid 
	where Free_Qty<>0.00 or pledge_qty<>0.00--9 min (25022816)

	if (select count(1) from [INTRANET].CMS.dbo.MTF_AutoRelease_log with (nolock) 
	where cast(updatedon as date)=cast(getdate() as date))>=1
	begin
		truncate table tbl_po_neha_22062022
		insert into tbl_po_neha_22062022
		select *  from  [MIS].Demat.dbo.VW_SharePO_Request_NRMS f with (nolock)

		/*Added to handle poor scrips updated in free qty (cusa po)*/
		select * into #po from [MIS].Demat.dbo.VW_SharePO_Request_NRMS f with (nolock)

		delete T  from #po T inner join scrip_master S on T.isin=S.isin
		where S.status='Poor'

		/*Update Branch PO Marking data*/
		update #temp set Free_Qty=Free_Qty+F.veirfied_qty from #po f with (nolock) inner join #temp T on F.party_code=T.party_code
		and F.isin=T.isin----40000

		insert into #temp
		select F.party_code,F.ClientCLTDPID,F.isin,F.veirfied_qty,0.00,
		'','','','','','','',
		getdate() from #po f with (nolock) left OUTER JOIN  #temp F1
		on F.party_code=F1.party_code and F.isin=F1.isin where F1.isin is null and F.veirfied_qty is not null--and  F.party_code='G63122' ----
	end

	create clustered index idx_pc_isin on #temp(party_code,isin)--2:33


	select distinct isin into #MF_ISin
	from
	(
	select distinct isin  from [AngelNseCM].msajag.dbo.SCRIP_APPROVED_MF  with (nolock)
	union all 
	select distinct isin from tbl_scripMaster_marginPledge with (nolock)
	union all 
	select distinct isin_Number from [tbl_ETF_list] with (nolock)
	)a

	delete from #temp where isin like 'INF%' and 
	isin not in (select distinct isin from #MF_ISin with (nolock))
	and pledge_qty=0--9 sec

	alter table #temp add scripname varchar(500),Cls_Rate money,Var_Margin money,Approved_Flag varchar(20),NBFC_Block_Qty int

	update #temp set scripname= s.scripname,Approved_Flag=s.Status from scrip_master s with(nolock) 
	where #temp.isin=s.isin--9:56 

	delete from #temp where Approved_Flag='POOR' and pledge_qty=0.00
	delete from #temp where Approved_Flag is null
	--1:27

	/*NBFC blocking quatity adjustment*/
	exec Upd_NBFC_Pledge_Process

	update #temp set Free_Qty=(case when Free_Qty-t2.NBFC_Block_Qty>=0.00 then Free_Qty-t2.NBFC_Block_Qty else 0.00 end)
	from tbl_nbfc_Pledge_Blocking_qty t2 with (nolock) where  #temp.party_code=t2.party_code and #temp.isin=t2.isin
	--and  tbl_pledge_calculation.party_code='DELP2378' --1 sec

	update #temp set NBFC_Block_Qty=isnull(t2.NBFC_Block_Qty,0.00) 
	from tbl_nbfc_Pledge_Blocking_qty t2 with (nolock) 
	where  #temp.party_code=t2.party_code and #temp.isin=t2.isin 

	update #temp set NBFC_Block_Qty=0.00 where NBFC_Block_Qty is null


	

	select party_code,scrip_cd,series,certno,sum(qty) qty into #MTF_hold
	from ANGELDEMAT.msajag.dbo.deltrans with (nolock) where  BCltDpId ='1203320030135829'
	and drcr='d' and Delivered ='0' and Filler2 =1 and trtype ='904'
	group by party_code,scrip_cd,series,certno--0 sec

	create clustered index idx_pc_isin on #MTF_hold(party_code,certno)


	update #temp set Pledge_Qty=Pledge_Qty- qty from #MTF_hold M where 
	#temp.party_code=M.party_code and #temp.isin=M.certno---2 sec

	alter table #temp add Obligation int,unpledge int,Net_Free_Qty int,Net_Pldg_qty int,Value_BHC money,Value_AHC money,Value_BHC_NPA money,Value_AHC_NPA money
	--select * into tbl_pledgedatauat from #temp

	/*Source from neha*/
	select party_code,isin,scrip_cd,short_qty into #Shortage 
	from [INTRANET].risk.dbo.CMSVerified_Cash_ShrtVal with (nolock) --where party_code='F4050'

	create clustered index idx_pc_isin on #Shortage(party_code,isin)


	update #temp set Obligation= isnull(s.short_qty,0.00) from #Shortage s 
	where #temp.party_code=s.party_code and #temp.isin=s.isin 

	select * into #unpledge from [INTRANET].cms.dbo.VW_Unpledge_Request with (nolock)

	update #temp set unpledge=MarkedQty from #unpledge U where #temp.party_code=U.party_code and  #temp.isin=U.isin 
	update #temp set unpledge= 0.00 where unpledge is null
	update #temp set Obligation= 0.00 where Obligation is null
	--1:20 min above 3 updates

	update #temp set pledge_qty=(case when Obligation>=Free_Qty then pledge_qty-unpledge-(Obligation-Free_Qty) else pledge_qty-unpledge end) 
	where pledge_qty>0.00 
	update #temp set Net_Free_Qty=case when (Free_Qty)+unpledge-Obligation>0.00 then (Free_Qty)+unpledge-Obligation else 0.00 end 
	update #temp set Net_Pldg_qty=pledge_qty
	update #temp set Cls_Rate=r.MTM_Price 
	from Combine_Closing_File r with(nolock) where #temp.isin=r.Security_ISIN

	--8:09 min above 4 updates

	delete from #temp where  Net_Free_Qty<0
	delete from #temp where  Net_Pldg_qty<0

	declare @date1 datetime ,@date2 datetime
	set @date1=(select max(rate_date-15 ) from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK))
	set @date2=(select max(rate_date-30 ) from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK))

	select isin,Upd_date=max(rate_date)into #aa from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK)
	where rate_date>=@date1  --where isin='INF179KB1HK0'
	group by isin --17111

	select isin,Upd_date=max(rate_date)into #rate from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master  WITH (NOLOCK)
	where rate_date>=@date2  --where isin='INF179KB1HK0'
	group by isin --18287

	select R.isin,close_price into #rate1 from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master R  WITH (NOLOCK) inner join  #aa A on R.isin=A.isin and R.rate_date=A.Upd_date
	select R.isin,close_price into #rate2 from [172.31.16.108].dmat.citrus_usr.VW_ISIN_RAte_master R  WITH (NOLOCK) inner join  #rate A on R.isin=A.isin and R.rate_date=A.Upd_date

	select distinct A.isin,A.clsrate,A.scrip_cd into #rms_holding from rms_holding A with (nolock) 
	where (scrip_cd like '9%'  or scrip_cd like '10%') and clsrate=0.00 and source='DP' 
	and a.series not in ('MF_new','MF')

	select distinct  A.isin,b.close_price 
	into #CP_MF 
	from DP_Holding a left outer join 
	#rate1 b
	on a.isin=b.isin where a.nseseries in ('MF_new','MF') and b.close_price is not null        ---1659           

	 select distinct  A.isin,b.close_price
	 into #bonds_rate   
	 from #rms_holding a with (nolock) left outer join 
	 #rate2 b
	 on a.isin=b.isin where b.close_price is not null---387

	 --3 min 58 sec

	 create clustered index idx_isin on #CP_MF(isin)
	 create clustered index idx_isin on #bonds_rate(isin)


	/*For MF ISIN*/
	update #temp set Cls_Rate=r.close_price from #CP_MF r where #temp.isin=r.isin and  #temp.cls_rate is null 
	update #temp set Cls_Rate=r.close_price from #bonds_rate r where #temp.isin=r.isin and  #temp.cls_rate is null 
	---37 sec

	select distinct isin,nav_value,nav_date,amc_code,scheme_name  into #mf_nav
	from [172.31.16.75].ANGEL_WMS.dbo.dw_mst_bse_mf_scheme with (nolock) order by isin,nav_date desc

	create clustered index idx_isin on #mf_nav(isin)

	update #temp set Cls_Rate=r.nav_value from #mf_nav r where #temp.isin=r.isin and  #temp.cls_rate is null 
	and #temp.isin like 'INF%'
	update #temp set Cls_Rate=0.00 where #temp.cls_rate is null

	update #temp set ISIN_Type='MF' from #mf_nav where #temp.isin=#mf_nav.isin--60163
	update #temp set scripname=scheme_name from #mf_nav where #temp.isin=#mf_nav.isin and  ISIN_Type='MF'--60163
	--1 min
	create table #varrate
	(isin varchar(50),Var_Margin money)

	select distinct B.isin,ExchangeHairCut =(CASE WHEN ISNULL(B.BSE_VAR, 100) >= ISNULL(B.NSE_VAR, 100)    
								 THEN ISNULL(B.BSE_VAR, 100)    
								 WHEN ISNULL(B.BSE_VAR, 100) < ISNULL(B.NSE_VAR, 100)    
								 THEN ISNULL(B.NSE_VAR, 100)    
								 ELSE 100 end) into #vardata 
	from  SCRIPVAR_MASTER B with (nolock) where isin like 'INE%'

	insert into #varrate
	select distinct isin,Haircut=min(ExchangeHairCut) from VW_RMS_HOLDING_WITHPOA with(nolock)
	where source='H'
	group by  isin 

	select distinct isin,Var_margin=var_margin 
	into #nse_var 
	from fovar_margin 

	create index #ix_var on #varrate ( isin)
	create index #ix_nsevar on #nse_var ( isin)
	--create nonclustered index #nix_pc_isin on #temp ( party_code,isin)
	--8 sec

	update #temp set Var_Margin = isnull(v.Var_Margin,0.00)
	from #nse_var v where v.isin=#temp.isin 

	update #temp set Var_Margin = isnull(v.Var_Margin,0.00)
	from #varrate v where v.isin=#temp.isin and #temp.Var_Margin is null

	-----6:16 min
	/*Added on Dec 03 2022 (Jira ID 1724)*/
	update #temp set Var_Margin =20.00 where Var_Margin <20.00

	update #temp set Var_Margin=10.00 
	where isin in (select distinct ISIN_Number from [tbl_ETF_list])

	update #temp set Var_Margin=10.00 
	where isin like 'INF%'

	update #temp set Var_Margin =0.00 where Var_Margin is null

	----1:16

	update #temp set Value_BHC=Net_Free_Qty*Cls_Rate
	update #temp set Value_AHC=Value_BHC-(Value_BHC*Var_Margin/100)

	update #temp set Value_BHC_NPA=Net_Pldg_qty*Cls_Rate
	update #temp set Value_AHC_NPA=Value_BHC_NPA-(Value_BHC_NPA*Var_Margin/100)
	--3 : 10

	/*update etf isin*/

	 --select ISIN_Type='ETF',isin,s.scripname from #temp t inner join scrip_master s on  t.isin=s.isin where  s.scripname like '%etf%' 
	update #temp set ISIN_Type='ETF' from scrip_master s with(nolock) where s.scripname like '%etf%' and #temp.isin=s.isin
	update #temp set ISIN_Type='ETF' from scrip_master s with(nolock)  where s.scripname like '%Gold%' and s.Isin like 'INF%'  and #temp.isin=s.isin

	----08 sec
	IF  EXISTS (SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_pledge_calculation_uatnew]') AND name = N'Idx_ID')    
	DROP INDEX [Idx_ID] ON [dbo].tbl_pledge_calculation_uatnew WITH ( ONLINE = OFF )    

	truncate table tbl_pledge_calculation_uatnew
	insert into tbl_pledge_calculation_uatnew
	select  party_code,Mobile_Num=Mobile_Number,Email,dpid=BOID,scripname,isin,Free_Qty,Pledge_Qty,datetimestamp=getdate(),
	Obligation,Unpledge,POA,Net_Pldg_qty,qty=Net_Free_Qty,close_rate=Cls_Rate,total=Value_BHC,
	nse_approved=approved_flag,var_mar=Var_Margin,net_amt=Value_AHC,net_pldg_amt=Value_AHC_NPA,ISIN_Type,NBFC_Block_Qty,Client_Type,Client_name,Migrated,0,0,'','' from #temp 

	CREATE CLUSTERED INDEX [Idx_ID] ON [dbo].tbl_pledge_calculation_uatnew (ID ASC) 

	/*Added on Jan 19 2021 to resolve unpledge issue*/
	update tbl_pledge_calculation_uatnew set net_pldg_amt=1 where var_mar=100.00 and Free_Qty<>0.00 and close_rate>0.00

	update tbl_pledge_calculation_uatnew set qty_limit1=T.qty,qty_limit2= isnull(Collaterls_Qty,0.00) 
	from tbl_DPDirectPush T with (nolock)
	where tbl_pledge_calculation_uatnew.party_code=T.PARTY_CODE 
	and tbl_pledge_calculation_uatnew.isin=T.isin
	and Client_Type='Omnesys'

	/*Added on Aug 12 2023 as required by Tushar Jorgial ORE -2605*/ 

	select scrip as Scrip_cd,sum(markedqty) as Veirfied_Qty,party_code,ISIN,cltdpid as ClientCLTDPID   
	into #cuspo
	from [INTRANET].cms.dbo.tbl_CusaPO_File with(nolock)  group by        
	scrip,party_code,ISIN,cltdpid

	create clustered index idx_pc_isin on #cuspo(party_code,isin)

	update T set qty_limit1 =qty_limit1+P.veirfied_qty from 
	tbl_pledge_calculation_uatnew T inner join #cuspo P on T.party_code=P.party_code
	and T.isin=P.isin where  Client_Type='Omnesys'

	select * into #mtf_unpledge 
	from [INTRANET].cms.dbo.VW_Unpleadge_MTF with (nolock)

	create clustered index idx_pc_isin on #mtf_unpledge(party_code,isin)


	update T set qty_limit2 =qty_limit2-P.MarkedQty from 
	tbl_pledge_calculation_uatnew T inner join #mtf_unpledge P on T.party_code=P.party_code
	and T.isin=P.isin where  Client_Type='Omnesys'

	delete from tbl_pledge_calculation_uatnew where isin='INE797F01012'

	/*Unpledge issue of MF scrips*/
	update tbl_pledge_calculation_uatnew set net_pldg_amt=1 ,net_amt=1
	where net_pldg_amt =0 and net_pldg_qty > 0  and isin like 'inf%'

	Declare @OdinTime datetime,@OmnesysTime Datetime,@CDSL_ProcessTime  Datetime

	select  @OdinTime= max(insert_date) from tbl_NewDPBgFile
	select @OmnesysTime= max(insert_date) from tbl_Omne_NewDPBgFile
	select @CDSL_ProcessTime= max(datetimestamp) from tbl_pledge_calculation_uatnew

	truncate table Tbl_CDSL_PledgeProcess_Log
	insert into Tbl_CDSL_PledgeProcess_Log
	select 'CDSL Pledge Process','Completed',@CDSL_ProcessTime,@OdinTime,@OmnesysTime


end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.nrms_all_square_off_report_bkup_04012024
-- --------------------------------------------------

-- author:  Abha Jaiswal                             
-- create date: 20/06/2022                          
-- description: All Square off process report                      
          
-- =============================================                             
/*              
exec nrms_all_square_off_report @AccessLevel=N'Client',@AccessCode='%',@AlertDate='2023-12-27',@Access_to=N'BROKER',        
@Access_Code=N'CSO',@SQ_OFF_TYPE=N'All'              
*/                 
                 
Create procedure [dbo].[nrms_all_square_off_report_bkup_04012024]                            
@accesslevel varchar(20),                                                            
@accesscode varchar(20),                                                           
@alertdate datetime,                                                            
@access_to varchar(20),                                                            
@access_code varchar(20),                                                           
@sq_off_type varchar(20)                             
as   

--return 0  
  
begin            
set nocount on          
        
 if @accesscode ='all'                                                         
 set @accesscode =@access_code                                                    
          
 if @sq_off_type ='all'                                                            
 set @sq_off_type ='%'                          
          
 declare @main varchar(max)                                                           
 set @main =''                                  
 set @main = @main + 'set nocount on; select distinct Party_code,mtf_active_inactive = convert(varchar(20),case when is_accepted =''y'' then ''Active'' else ''InActive'' end) Into #Temp_MTF from general.dbo.vw_ClientMargin_Campaign with(nolock) where IS_Accepted=''Y'''          
          
 set @main = @main + ' declare @dt1 varchar(10)'          
 set @main = @main + ' declare @dt2 varchar(10)'          
 set @main = @main + ' declare @dt3 varchar(10),@dt datetime   '          
 set @main = @main + ' declare @dtmtf_day1 varchar(10)'           
 set @main = @main + ' declare @dtmtf_day2 varchar(10) '          
 set @main = @main + ' declare @dtnbfc_ms_day2 varchar(10)'           
 set @main = @main + ' declare @dtnbfc_ms_day3 varchar(10)'           
 set @main = @main + ' declare @dtnbfc_ms_day4 varchar(10)'          
 set @main = @main + ' SELECT @dt=min(Start_date) FROM general.dbo.bse_sett_mst a WHERE Start_date >=convert(varchar(11),GETDATE(),120) AND SETT_TYPE =''D'' '        
         
 set @main = @main + '     
 ;with sqoffdatae as      
 (      
 select ROW_NUMBER() over(order by a.Start_Date)as srno,  isnull(convert(varchar(10), a.Start_Date, 103),'''')   Start_Date                                            
    from general.dbo.bo_sett_mst a with(nolock)                                                                           
    where start_date >@dt and start_date<>@dt                                                         
    and datepart(dw,a.start_Date) <> 7  --exclude saturday                                              
    and datepart(dw,a.start_Date) <> 1 --exclude sunday                                                                            
    group by Start_Date)      
          
    select * into #temp_date from sqoffdatae      
          
    select @dt1 = isnull(convert(varchar(10), Start_Date , 103),'''')  from #temp_date where srno=2       
    select @dt2 = isnull(convert(varchar(10), Start_Date , 103),'''')  from #temp_date where srno=1       
    select @dtmtf_day1= isnull(convert(varchar(10), start_date, 103), '''') from   #temp_date where  srno =4      
    select @dtmtf_day2= isnull(convert(varchar(10), start_date, 103), '''') from #temp_date where srno =3      
    select @dtnbfc_ms_day2 = isnull(convert(varchar(10), start_date, 103), '''') from #temp_date where srno = 5      
    select @dtnbfc_ms_day3= isnull(convert(varchar(10), start_date, 103), '''') from #temp_date where  srno = 4      
    select @dtnbfc_ms_day4 = isnull(convert(varchar(10), start_date, 103), '''') from #temp_date where srno = 3           
    select @dt3 =CONVERT(VARCHAR(10),@dt,103)    '           
                    
 set @main = @main + ' create table #temp(party_code varchar(20),shortage_value money,squareoffvalue money,squareoffaction varchar(20),square_off_type varchar(20),Square_off_date varchar (20),updated_on date,status varchar(20)) '                          
        
 set @main = @main + ' insert into #temp (party_code,shortage_value,squareoffvalue,squareoffaction,square_off_type,Square_off_date,updated_on,status) '                                                           
 set @main = @main + ' ( select party_code,convert(decimal(18,2),var_margin_shortage) as shortage_value,squareoffvalue=cash_sqaureup ,squareoffaction=''t+2'',''t+2 day proj'' as square_off_type,@dt3 as Square_off_date,cast(updt as date) as updated_on,''-'' from tbl_projrisk_t2day_data with(nolock) WHERE SQUAREUPAVAILABLE=''Y'''                         
 set @main = @main + ' union select party_code,net_debit as shortage_value,squareoffvalue=cash_sqaureup,squareoffaction=''t+2'',''t+2 day nbfc'' as square_off_type, @dt3 as Square_off_date,cast(updt as date) as updated_on,''-''  from squareup_client_nbfc with(nolock) WHERE SQUAREUPAVAILABLE=''Y'''                              
 set @main = @main + ' union select client_code as party_code,margin_shortage_after_excesscredit_adj as shortage_value,squareoffvalue=square_off_value, '                             
 set @main = @main + ' squareoffaction=cast(squareoffaction as varchar(20)),''nbfc margin shortage'' as square_off_type,(case when squareoffaction=2 then @dtnbfc_ms_day2           
                                                                                                                              when squareoffaction=3 then @dtnbfc_ms_day3                                                                                      
                                                  
                                 when squareoffaction=7 then @dt3 else ''-'' end )as Square_off_date,cast(Update_date as date) as updated_on ,''-''  '                               
 set @main = @main + ' from general.dbo.tbl_nbfc_excess_shortagesqoff with(nolock) where square_off_value>0 and squareoffaction>1         
        and  cast(update_date as date)=(select max(cast(update_date as date)) from general.dbo.tbl_nbfc_excess_shortagesqoff with(nolock))'                                                    
                                                                     
 set @main = @main + ' union select [client code] as party_code, marginshortage as shortage_value,squareoffvalue=total_sq_off_val,squareoffaction=''t+1 day'',''t+1 day nbfc'' as square_off_type,@dt2 as Square_off_date, cast(updt as date) as updated_on,''-'' from squareup_client_alert_nbfc with(nolock) where Cast(updt AS DATE)=@dt'                     
 /*
 set @main = @main + ' union  select party_code,shortage_value= (case when t_day=5 and bucket_005<0.00 then Bucket_005  when t_day=6 and bucket_006 <0.00 then Bucket_006 when t_day=7 and bucket_007<0.00 then Bucket_007 else 0.00 end) , '                  
        
 set @main = @main + ' squareoffvalue=sq_amt,squareoffaction=cast(T_day as varchar(2)) ,''ageing T+7'' AS square_off_type, (case when t_day=5 then @dt1           
                                                                                                                                 when  t_day=6 then  @dt2 else @dt3 end )as Square_off_date,Cast(rms_date AS DATE) AS updated_on,status=''''  '                
       
          
 set @main = @main + ' from mis.dbo.ASB7_Clidetails_CrDet_process2 with(nolock) where rms_date=(select max(rms_date) from mis.dbo.ASB7_Clidetails_CrDet_process2 with(nolock)) and t_day>=5 and sq_amt<>0.00 and abs(t_value) > 1000 '   
 */
 set @main = @main +  ' union SELECT party_code,shortage_value= shortage*(-1),squareoffvalue=squareoffvalue,squareoffaction=Cast(Noofdays AS VARCHAR(10)),''MTF'' AS square_off_type,(case when noofdays = 1 then @dtmtf_day1           
                                                 when noofdays = 2 then @dtmtf_day2           
                                                                                                                                                                                           when Noofdays=3 then @dt1   
                                                 when Noofdays=4 then  @dt2           
                                                                                                                                                                                           when Noofdays>=5 then @dt3 else ''-'' end )as Square_off_date,Cast(processdate AS DATE) AS updated_on,''-'' FROM  squareoff.dbo.mtf_data with (nolock) WHERE  processdate = (SELECT Max(processdate) FROM   squareoff.dbo.mtf_data with (nolock)) AND Noofdays >= 1 AND squareoffvalue <> 0.00'   
                                                                                                                                                                                         
 set @main = @main + ' union  select party_code,shortage_value, '                       
 set @main = @main + ' squareoffvalue,squareoffaction=cast(square_off_day as varchar(10)) ,''MTF Ageing'' AS square_off_type,   
 (case when square_off_day=5 then @dt1           
    when  square_off_day=6 then @dt2 else @dt3 end )as Square_off_date,updated_on,status'          
                                                                                                                                                      
 set @main=@main +' from Vw_MTF_AGEING_FINALDATA with (nolock))'          
                                                                                                                                                                                              
 set @main = @main + ' delete from #temp where shortage_value<1000  AND square_off_type=''MTF Ageing'' '          
 Set @main = @main + ' update #temp set shortage_value=shortage_value *(-1) WHERE square_off_type=''MTF Ageing'' '          
          
 ---set @main = @main + ' delete from #temp where shortage_value=0.00  AND square_off_type=''ageing T+7'' '          
           
 --set @main = @main + ' delete from #temp where party_code  in (select party_code from #temp_mtf)  AND square_off_type=''ageing T+7'' '          
  --set @main = @main + ' delete A from #temp A inner join #temp_mtf T on A.party_code=T.party_code where square_off_type=''ageing T+7'' '          
         
 set @main = @main + ' update #temp set squareoffaction=5 where squareoffaction>=6 and square_off_type=''MTF'' '          
   
 set @main = @main + ' alter table #temp add Net_ledger money,mtf_ledger money,Last_inactive_date varchar(11)'  
 set @main = @main + ' alter table #temp add BSEACTIVE varchar(1),NSEACTIVE varchar(1)'   
 set @main = @main + ' alter table #temp add ServerMapped varchar(20),code_blocking_old varchar(11),code_blocking_new varchar(11),mtf_status varchar(50)'   
 


 --set @main = @main + ' update #temp set Net_ledger=tbl.Net_Ledger ,mtf_ledger=tbl.mtf_ledger from tbl_RMS_Collection_Cli tbl with (nolock) where  #temp.party_code=tbl.party_code '  
 set @main = @main + ' update #temp set Net_ledger=tbl.balance  from tbl_ledger_All_Risk tbl with (nolock) where  #temp.party_code=tbl.cltcode '  
 set @main = @main + ' update #temp set mtf_ledger=tbl.ledger from rms_dtclfi tbl with (nolock) where  #temp.party_code=tbl.party_code and co_code=''MTF'''  
 set @main = @main + ' update #temp set Last_inactive_date=convert(varchar(11),cli.Last_inactive_date,103),BSEACTIVE=cli.BSECM,NSEACTIVE=cli.NSECM from client_details cli with (nolock) where #temp.party_code = cli.party_code'  
 set @main = @main + ' update #temp set mtf_status=tbl.mtf_active_inactive from #Temp_MTF tbl with (nolock) where  #temp.party_code=tbl.party_code '  

 --set @main = @main + ' update #temp set Passive_codes=T.party_code from  #temp T1 left join [196.1.115.132].MIS.dbo.Tbl_PassiveRecords t with (nolock) on T1.party_code = t.party_code'  
 --set @main = @main + ' update #temp set ServerMapped=O.ServerMapped from #temp b left join intranet.mis.dbo.odinclientinfo o with (nolock) on b.party_code = o.pcode'  
 --set @main = @main + ' update #temp set code_blocking_old=case when (select count(party_code) from [196.1.115.132].MIS.dbo.SQUAREOF_CLIENTDETAILS with (nolock) where cast([date] as date)=cast(getdate() as date) '       
 --set @main = @main + ' and party_code=#temp.party_code group by party_code)>0 then ''Y'' else ''N'' end '  
 set @main = @main + ' update #temp set code_blocking_new=case when (select count(party_code) from [196.1.115.132].MIS.dbo.TBL_ALLSQUAREOFF_BLOCKING_DATA d with (nolock) where d.party_code=#temp.party_code and         
                       cast(d.[date] as date)=cast(getdate() as date) group by party_code )>0 then ''Y'' else ''N'' end'  
  
 set @main = @main + ' select distinct b.zone,b.region,b.branch,b.SB,b.category,b.SB_category,B.Cli_Type,c.party_code,c.Net_ledger,c.mtf_ledger,        
 convert(decimal(18,2),shortage_value) as shortage_value,squareoffvalue,squareoffaction,square_off_type,Square_off_date,updated_on=convert(varchar(11),updated_on,103),c.Last_inactive_date ,BSEACTIVE,NSEACTIVE,   
 code_blocking_new,mtf_status from #temp c '         
             
 set @main = @main + ' inner join vw_rms_client_vertical b with (nolock) on  c.party_code=b.client '                                     
 set @main = @main + ' where square_off_type like '''+@sq_off_type+''''                          
 if @accesslevel ='region' and @accesscode <> '%'                                                           
 set @main = @main + ' and b.region like ''' + @accesscode +''''                                                    
          
 else if @accesslevel = 'branch' and @accesscode <> '%'                                                           
 set @main = @main + ' and b.branch like ''' + @accesscode +''''                                                    
                                      
 else if @accesslevel = 'sb'                                                           
 set @main = @main + ' and b.sb like ''' + @accesscode +''''                                                    
          
 else if @accesslevel = 'client'                                                          
 set @main = @main + ' and b.client like ''' + @accesscode +''''                                                    
          
 if @access_to = 'regionmast'                                                          
 set @main = @main + ' and b.region in (select accesscode from tbl_rms_groupmaster with(nolock) where groupcode= '''+@access_code+''') '                                                    
          
 else if @access_to = 'brmast'                                                         
 set @main = @main + ' and b.branch in (select accesscode from tbl_rms_groupmaster with(nolock) where groupcode= '''+@access_code+''') '                                                    
          
 else if @access_to ='sbmast'                                                          
 set @main = @main + ' and b.sb in ( select distinct sub_broker from sb_master with(nolock) where sbmast_cd='''+@access_code+''')'                                                    
          
 else if @access_to = 'broker'                                                          
 set @main = @main + ' '                                                                                                                 
          
 else                                                                   
 set @main = @main + ' and b.'+@access_to+' like '''+@access_code+''' '                              
                
 set @main = @main +' order by squareoffvalue desc '

 set @main = @main +' if((DATEPART(DW,GETDATE())>=2 or DATEPART(DW,GETDATE())<6) and (DATEPART(HH,GETDATE())>=8 and DATEPART(HH,GETDATE())<=10))'
 set @main = @main +' begin '
 set @main = @main +' print ''hii'' '
 set @main = @main +' truncate table tbl_nrms_allsqoff_report '
 set @main=  @main +' insert into tbl_nrms_allsqoff_report '
 
 set @main= @main + ' select distinct b.zone,b.region,b.branch,b.SB,b.category,b.SB_category,B.Cli_Type,c.party_code,c.Net_ledger,c.mtf_ledger,        
 convert(decimal(18,2),shortage_value) as shortage_value,squareoffvalue,squareoffaction,square_off_type,Square_off_date,updated_on=convert(varchar(11),updated_on,103),c.Last_inactive_date ,BSEACTIVE,NSEACTIVE,   
 code_blocking_new,getdate() from #temp c inner join vw_rms_client_vertical b with (nolock) on  c.party_code=b.client  '

 set @main=  @main +' end '

print @main                             
exec (@main)                     
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.PR_GET_MORN_RMS_PROCESS_bkup_04122023
-- --------------------------------------------------


CREATE PROC [dbo].[PR_GET_MORN_RMS_PROCESS_bkup_04122023]  
(@date AS DATETIME)            
AS            
BEGIN            
select  b.batchID, b.BatchName,convert(varchar,a.batchdate,106) as BatchDate,                                                
Status=case when a.batchstatus='Y' then 'Completed' else 'Pending' end ,            
 convert(varchar,a.BatchStartTime,108) as [Start Time],            
 convert(varchar,a.BatchEndTime,108) as [End Time]  from rms_batchjob_log a                                                
inner join rms_batchjob b on a.batchid=b.BatchID                                                
 where convert(varchar,batchdate,106)=convert(varchar,@date,106)       
 and (a.batchid BETWEEN 1 AND 18  or a.batchid BETWEEN 50 AND 65  )    
 order by b.batchid, a.BatchStartTime                                                 
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Prc_INSMFData_bkp_29_11_2024
-- --------------------------------------------------

CREATE Procedure [dbo].[Prc_INSMFData_bkp_29_11_2024]  
As  
Begin  
 begin try  
 /*
 select c.party_code,ACTIVE_FROM,INACTIVE_FROM into #cd dbo.client_details cd with (nolock)
on c.party_code=cd.party_code where cast(INACTIVE_FROM as date)>cast(getdate() as date) and cd.MF is null
*/

/*Added on April 8 2022 to updated back dated MF inactive codes*/ 

insert into tbl_log_Prc_INSMFData
select getdate(),null

select c.party_code,ACTIVE_FROM,INACTIVE_FROM into #client  
from angelfo.bsemfss.dbo.mfss_client c with (nolock) 
where cast(INACTIVE_FROM as date)>cast(getdate() as date) 

select distinct c.party_code,ACTIVE_FROM,INACTIVE_FROM  into #MF_Null
from #client c with (nolock) inner join client_details cd with (nolock)
on c.party_code=cd.party_code where  cd.MF is null

update client_details set MF='Y' from #MF_Null a where  client_details.party_code=a.party_code 
AND client_details.mf IS NULL 
--3:42sec

select * into #mfss from angelfo.bsemfss.dbo.mfss_client c with (nolock) 
where cast(ACTIVE_FROM as date)>=cast(getdate() as date) 

select * into #newmfclients from #mfss c with (nolock) 
where party_code not in (select distinct party_code from client_details with (nolock))      

--select C.* from client_details C with (nolock) inner join #newmfclients N on C.party_code=N.party_code
                    
/*Added on April 8 2022 to updated back dated MF inactive codes*/ 

delete A from #newmfclients A inner join client_details C on A.party_code=C.party_code
 
insert into client_details   
select c.PARTY_CODE,c.BRANCH_CD,c.PARTY_CODE,c.SUB_BROKER,c.trader,c.PARTY_NAME,convert(varchar(21),c.PARTY_NAME),
convert(varchar(100),c.ADDR1),c.CITY,convert(varchar(100),c.ADDR2),c.STATE,convert(varchar(100),c.ADDR3),
convert(varchar(15),c.NATION),convert(varchar(10),c.ZIP),convert(varchar(50),c.PAN_NO),'','',
convert(varchar(15),c.RES_PHONE),'',convert(varchar(15),c.OFFICE_PHONE),'',convert(varchar(40),c.MOBILE_NO),convert(varchar(15),c.RESIFAX),convert(varchar(50),c.EMAIL_ID),convert(varchar(3),c.CL_TYPE),convert(varchar(3),c.CL_STATUS),convert(varchar(10),c.FAMILY)  
,convert(varchar(50),c.REGION),convert(varchar(10),c.AREA),'','','','','','','','','',convert(char(1),c.Gender),
c.DOB,'','' as Approver,0 as interactmode,'','',NULL,NULL as passport_expires_on,'','',
NULL,NULL as licence_expires_on,'','',NULL as rat_card_issued_on,'','',NULL as votersid_issued_on,'',
NULL as it_return_filed_on,'','',NULL as regr_on,'',NULL as client_agreement_on,'','','','',
'' as introducer_relation,0 as repatriat_bank,  
'',0,0,0,0,0,0 as chk_corp_dtls_recd,convert(varchar(50),c.BANK_NAME),convert(varchar(50),c.BANK_BRANCH),
convert(varchar(10),c.BANK_AC_TYPE),convert(varchar(20),c.ACC_no),convert(varchar(7),c.DP_TYPE),
convert(varchar(16),c.DPID),convert(varchar(16),c.CLTDPID),'','','','','','','','' as CltDpId3,'','','','',
'' as Status,0 as Imp_Status,'',null as ModifidedOn,0 as Bank_id,'','','','','','' as FMCode,NULL  
,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'N','N','N','N','N','N','N','N',c.INACTIVE_FROM,c.ACTIVE_FROM,'',
c.SUB_BROKER,c.BRANCH_CD,'N',NULL,'Y',NULL,NULL,NULL 
from #newmfclients c with (nolock) left join dbo.client_details cd  with (nolock)
on c.party_code=cd.party_code where cd.party_code is null AND ISNULL(c.party_code,'')<>''                   
  
delete from Vw_RMS_Client_Vertical where Zone like '%**%'  
  
 SELECT             
 isnull(B.DUMMY1,'**') AS ZONE,            
 isnull(B.REGIONCODE,'**') AS REGION,            
 REGIONNAME=isnull(B.DESCRIPTION,'**missing**'),              
 isnull(A.branch_cd,'**') AS BRANCH,            
 BRANCHNAME=LTRIM(RTRIM(isnull(C.BRANCH,'**missing**'))),              
 isnull(A.sub_broker,'**') AS SB,            
 SB_NAME=isnull(D.SBNAME,'**missing**'),            
 isnull(A.PARTY_CODE,'**') AS CLIENT,            
 isnull(A.SHORT_NAME,'**missing**') as Party_Name,              
 CATEGORY='',            
 A.ORG_BRANCH,            
 A.ORG_SB              
 INTO #Vw_RMS_Client_Vertical1              
 FROM CLIENT_DETAILS A WITH(NOLOCK)              
 LEFT outer JOIN BO_REGION B WITH(NOLOCK) ON ltrim(Rtrim(A.branch_cd))=ltrim(Rtrim(B.BRANCH_CODE))           
 /*LEFT outer JOIN BO_BRANCH C WITH(NOLOCK) ON A.branch_cd=C.BRANCH_CODE */        
 LEFT outer JOIN (select BRANCH_CODE,BRANCH=max(BRANCH) from  BO_BRANCH WITH(NOLOCK) group by BRANCH_CODE)C ON ltrim(Rtrim(A.branch_cd))=ltrim(Rtrim(C.BRANCH_CODE))           
 LEFT outer JOIN SUBGROUP D WITH(NOLOCK) ON A.sub_broker=D.SUB_BROKER    
 where a.MF='Y'  
  
  
INSERT INTO Vw_RMS_Client_Vertical /* Before: 01:31 Secs */                
 SELECT a.Zone,a.Region,a.RegionName,a.Branch,a.BranchName,a.SB,a.SB_Name,a.Client,a.Party_name,a.Category,                
 0,'Normal',0,'Normal','Others','','',a.Org_SB,a.Org_branch                
 FROM #Vw_RMS_Client_Vertical1 a WITH(NOLOCK) left join Vw_RMS_Client_Vertical  b with (nolock) on a.client=b.client      
 where b.Client is null  and   a.zone not like '%**%' 

 exec [Upd_Client_Activation_date_MF]
 
 declare @Status varchar(20)    
 set @Status='' 
 
 exec NRMS_JoBStatus 'RemoveDuplicateClients',@Status  output    
 if(@Status='In Progress')    
 begin    
 print 'job is already running'      
 end    
 else    
 begin    
 EXEC msdb.dbo.sp_start_job 'RemoveDuplicateClients'     
 end
 
 update CLIENT_DETAILS set branch_cd=C.branch_cd ,sub_broker=C.sub_broker,Org_SB=C.sub_broker,Org_branch=C.branch_cd 
 from AngelNseCM.msajag.dbo.client_details c with (nolock)
 where CLIENT_DETAILS.party_code=C.party_code and MF='Y' and (CLIENT_DETAILS.branch_cd='' or  CLIENT_DETAILS.sub_broker='')

 
 update CLIENT_DETAILS set branch_cd=C.branch_cd ,sub_broker=C.sub_broker,Org_SB=C.sub_broker,Org_branch=C.branch_cd 
 from angelfo.bsemfss.dbo.mfss_client  c with (nolock)
 where CLIENT_DETAILS.party_code=C.party_code and MF='Y' 
 and (CLIENT_DETAILS.branch_cd='' or  CLIENT_DETAILS.sub_broker='' or CLIENT_DETAILS.branch_cd<>C.branch_cd or CLIENT_DETAILS.sub_broker<>C.sub_broker)
 and CLIENT_DETAILS.party_code not in (select party_code from  AngelNseCM.msajag.dbo.client_details c with (nolock))

 
 update Vw_RMS_Client_Vertical set branch=C.branch_cd ,sb=C.sub_broker,Org_SB=C.sub_broker,Org_branch=C.branch_cd 
 from CLIENT_DETAILS  c with (nolock)
 where Vw_RMS_Client_Vertical.client=C.party_code and c.MF='Y' 
 and (Vw_RMS_Client_Vertical.branch='' or  Vw_RMS_Client_Vertical.sb='' or Vw_RMS_Client_Vertical.branch<>C.branch_cd or Vw_RMS_Client_Vertical.sb<>C.sub_broker)

 /*added on  May 06 2022 to update cli type */

 update Vw_RMS_Client_Vertical    
 set Cli_Type = b.Cli_Type    
 from    
 (select distinct sub_Broker,Cli_Type=(case when b2c='Y' then 'B2C' ELSE 'B2B' END)    
 from bo_subbrokers (nolock)) b    
 where Vw_RMS_Client_Vertical.Org_SB=b.sub_broker and Vw_RMS_Client_Vertical.Cli_Type=''

  /* 9 seconds */            
 SELECT B2C_SB into #b2csb FROM [MIS].remisior.dbo.B2C_SB WITH(NOLOCK)            
 create clustered index idxsb on #b2csb (b2c_sb) 
 
 /* 09 seconds */            
 UPDATE a            
 SET cli_type ='B2B'            
 FROM Vw_RMS_Client_Vertical a WITH(NOLOCK)            
 LEFT outer JOIN #b2csb b            
 ON a.SB=b.B2C_SB            
 WHERE b.B2C_SB IS NULL and a.cli_type=''        
             
 --------------------------Optimized BY Saroj Gajraj ON 12Dec2012---------------            
             
 UPDATE a            
 SET cli_type='B2B'            
 FROM Vw_RMS_Client_Vertical a WITH(NOLOCK)            
 INNER JOIN Temp_CNT_AcCli b WITH(NOLOCK) ON a.Org_SB = b.entity_code            
 AND a.SB = b.product            
 WHERE a.cli_type='B2C'            
 AND a.SB='CALNT'            
 AND b.entity_Code <> 'EMT' and a.cli_type=''            
             
 UPDATE Vw_RMS_Client_Vertical             
 SET cli_type =            
 CASE WHEN (cli_type='B2C'AND left(Org_SB,2)='CB') THEN            
 'B2B'            
 WHEN (cli_type='B2B'AND (left(Org_SB,2) <> 'CB%' or left(client,3)='CBI')) THEN            
 'B2C'            
 END            
 WHERE branch = 'CALNT' and Vw_RMS_Client_Vertical.cli_type='' 

select C1.party_code,C2.party_name into #new1
from client_details C1 inner join angelfo.bsemfss.dbo.mfss_client C2 with (nolock)
on C1.party_code=c2.party_code and ltrim(rtrim(C1.long_name))<>ltrim(rtrim(C2.party_name))
and C1.mf='Y' and  C1.party_code not in (select distinct party_code from AngelNseCM.msajag.dbo.client_details with (nolock))
--and C1.party_code=''

update client_details set long_name=n.party_name from #new1 n where client_details.party_code=n.party_code
and  client_details.mf='Y'
 
update Vw_RMS_Client_Vertical set Party_name=n.party_name from #new1 n where Vw_RMS_Client_Vertical.client=n.party_code

exec [usp_clitype_alert]

update tbl_log_Prc_INSMFData set endtime=getdate() where id=(select max(id) from tbl_log_Prc_INSMFData with (nolock))
 
end try              
 begin catch              
  insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)              
  select GETDATE(),'Prc_INSMFData',ERROR_LINE(),ERROR_MESSAGE()              
              
  DECLARE @ErrorMessage NVARCHAR(4000);              
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());              
  RAISERROR (@ErrorMessage , 16, 1);              
 end catch; 

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.proc_squareOff_mailprocess_bkup21122023
-- --------------------------------------------------

--[proc_squareOff_mailprocess]'','','ExposureProcess'

CREATE procedure [dbo].[proc_squareOff_mailprocess_bkup21122023](@step int, @userid varchar(10),@mode varchar(20))              
AS              
begin              
              
create table #temp(srno int,batchid varchar(10))              
if(@step='1')              
begin              
insert into #temp                
select 1,120  union all               
select 2,121  union all               
select 3,122  union all               
select 4,123  union all
select 5,124  union all                              
select 6,139  union all
select 7,163
             
end              
              
if(@step='2')              
begin              
insert into #temp                
--select 1,125  union all                 
--select 2,126  union all                 
select 1,127  union all                 
select 2,128  union all                 
select 3,129  union all    
select 4,130  union all                
select 5,137  union all                            
select 6,138  union all   
select 7,162                 
end              
              
if(@step='3')              
begin              
insert into #temp                
select 1,131  union all              
select 2,132                 
end            
            
--if(@step='4')              
--begin              
--insert into #temp                
--select 1,133                
--end              

if(@step='4')              
begin              
insert into #temp                
select 1,140                
end

if(@step='5')              
begin              
insert into #temp                
select 1,141   union all
select 1,160             
end  
        
              
IF(@mode='Process')              
BEGIN              
 Declare @max int=(select MAX(srno) from #temp )              
 while (@max >=1)              
 begin              
 Declare @batchid int=null;              
 select @batchid=batchid from #temp where srno =@max               
 IF NOT EXISTS (SELECT BatchID FROM RMS_BatchJob_Log WHERE BatchID=@batchid AND cast(BatchDate as date) =cast(GETDATE() as date))                                          
 BEGIN                                          
  INSERT INTO RMS_BatchJob_Log (BatchID,BatchDate,BatchStatus)                                           
  SELECT BatchID,GETDATE(),'N' FROM RMS_BatchJob WHERE BatchID =@batchid                                            
 END               
 set @max=@max -1;              
 end              
End              
              
              
if (@mode ='check')              
begin 
		     
			if exists(select * from RMS_BatchJob_Log where BatchID in (select BatchID from #temp) AND cast(BatchDate as date) =cast(GETDATE() as date))              
			begin               
			select 'false';               
			end              
			else               
			begin               
			select 'true';              
			end  
		         
end                           
         
if(@mode='OdinProcess')          
begin          
--if not exists(select * from  tbl_odinsqOffMailerLog where processName like '%ODIN FILE GENERATION%' and cast(processDate as date) =CAST(GETDATE() as date) )              
--begin      
insert into  tbl_odinsqOffMailerLog (processName,StartTime ,Status) values ('ODIN FILE GENERATION',GETDATE(),'N')          
--EXEC ODIN_SQUAREOFF_MAILER 
exec [Omnesys_SQUAREOFF_MAILER]
 update a set status ='Y' ,EndTime = Getdate() from tbl_odinsqOffMailerLog a where processDate=CAST(GETDATE() as date) and processname='ODIN FILE GENERATION' and status ='N'           
--end        
end   

/*
if(@mode='ExposureProcess')          
begin    
	print 'exposure' 
	insert into  tbl_odinsqOffMailerLog (processName,StartTime ,Status) values ('Exposure FILE GENERATION',GETDATE(),'N')           
	exec upload.dbo.proc_FileAutoUploadprocess_exposure 'process'  
	update a set status ='Y' ,EndTime = Getdate() from tbl_odinsqOffMailerLog a where processDate=CAST(GETDATE() as date) and processname='Exposure FILE GENERATION' and status ='N'                   
end   
*/
/*
if(@mode='CusaProcess')          
begin          
--if not exists(select * from  tbl_odinsqOffMailerLog where processName like '%ODIN FILE GENERATION%' and cast(processDate as date) =CAST(GETDATE() as date) )              
--begin      
insert into  tbl_odinsqOffMailerLog (processName,StartTime ,Status) values ('CUSA FILE GENERATION',GETDATE(),'N')          
 EXEC Upd_Cusa_AllFile_Mailer          
 update a set status ='Y' ,EndTime = Getdate() from tbl_odinsqOffMailerLog a where processDate=CAST(GETDATE() as date) and processname='CUSA FILE GENERATION' and status ='N'           
--end        
end        
 */      
          
if(@mode ='Odincheck')              
begin          
          
if exists(select * from  tbl_odinsqOffMailerLog where processName like '%ODIN FILE GENERATION%' and cast(processDate as date) =CAST(GETDATE() as date) )              
begin               
select 'true';               
end              
else               
begin               
select 'true';              
end               
          
end              
              
              
              
            
              
              
-----------------------              
end

GO

-- --------------------------------------------------
-- PROCEDURE dbo.rebuild_index
-- --------------------------------------------------
/*

Proc Created by Amit kumar Bhatta on 27th feb 2013 for rebuilding the indexes of database passed as paremeter for the proc.

*/
create procedure [dbo].[rebuild_index]
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
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

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
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        IF @frag < 30.0
            SET @command = N'use '+@database + N' ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';
        IF @frag >= 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';
        IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));
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
-- PROCEDURE dbo.upd_client_details_bkup_31072023
-- --------------------------------------------------

 
create procedure [dbo].[upd_client_details_bkup_31072023]                  
AS                  
SET NOCOUNT ON      
SET XACT_ABORT ON                 
BEGIN TRY 
/*                  
NOTE: Never execute part of the queries from this SP.                  
*/                  
/* STEP-1 : define Variables and Initialize environment --- 00:01 Secs*/                  
/* insert into NRMS_clientDetails_log (Batchid,BatchTaskid,Procname,StartTime,LastStatus) select 0,0,'upd_client_details',getdate(),'Inprocess' */                  
declare @adate as datetime, @chkctr as int                  
set @chkctr = 0                  
select @adate = getdate(), @chkctr = @chkctr+1                  
--Step---1                  
DECLARE @lastchangedate as datetime                  
select @lastchangedate=max(BatchTaskStartTime) from Rms_SSISBatchTaskJob_log with (nolock) where batchid=1 and batchtaskid=3 and batchTaskStatus='Y'                  
/* select @lastchangedate=max(EndTime) from NRMS_clientDetails_log with (nolock) where laststatus='Success' */

truncate table tbl_masterPdate
insert into tbl_masterPdate
select @lastchangedate

TRUNCATE TABLE tmp_client_details                  
TRUNCATE TABLE tmp_IncrClient                  
TRUNCATE TABLE client_details_trig                  
TRUNCATE TABLE Client_Brok_Details_trig                  
TRUNCATE TABLE Temp_CNT_AcCli


insert into tbl_clientdetailsProcess_log
select  'Client_Brok_Details_trig',getdate(),''
                  
insert into Client_Brok_Details_trig(Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status)                  
/* select cl_code,Exchange,Segment,getdate() as UpdateDate,'INSERT' as DBAction,Active_Date,InActive_From,Status from anand1.msajag.dbo.client_brok_details */                  
select Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status                  
from AngelNseCM.msajag.dbo.client_brok_details_trig with (nolock) where updatedate >= @lastchangedate             
               
/* NOTE: Update all the party codes in table client_brok_details_trig from full updation */                  
insert into tmp_IncrClient(party_Code)                  
select party_Code from AngelNseCM.msajag.dbo.client_details_trig where updatedate >= @lastchangedate                  
insert into tmp_IncrClient(party_Code)                  
select party_Code from Client_Brok_Details_trig group by party_code                  
select party_Code into #aa from tmp_IncrClient with (nolock) group by party_Code                  
truncate table tmp_IncrClient                  
insert into tmp_IncrClient(party_Code) select party_Code from #aa                  
drop table #aa                  
select Party_Code,Exchange,Segment,max(UpdateDate) as UpdateDate,max(DBAction) as DBAction,Activate_Date,InActive_From,max(Status) as Status                  
into #cd_trig                  
from Client_Brok_Details_trig with (nolock)                  
group by Party_Code,Exchange,Segment,Activate_Date,InActive_From                  
select a.party_code into #clt from tmp_IncrClient a with (nolock) left outer join client_brok_details_trig b with (nolock) on a.party_Code=b.party_code where b.party_code is null                  
insert into #cd_trig (Party_Code,Exchange,Segment,Activate_Date,InActive_From,Status)                  
select cl_Code,Exchange,Segment,Active_Date,InActive_From,Status from Client_Brok_Details a with (nolock) join #clt B ON A.CL_cODE=B.PARTY_CODE                  
truncate table Client_Brok_Details_trig                  
insert into Client_Brok_Details_trig select Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status from #cd_trig                  
drop table #cd_trig 

update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='Client_Brok_Details_trig'


insert into tbl_clientdetailsProcess_log
select  'tmp_client_Details',getdate(),''
                               
/* Step-2 : Fetch required data from source --- 00:06 Secs (7810 records:Time 8:51 PM)*/                  
INSERT INTO tmp_client_Details(cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,                  
l_city,l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,                  
off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,                  
p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,                  
passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,                  
licence_issued_on,licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,                  
votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,                  
client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,                  
repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,                  
chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,                  
Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,                  
rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Director_name,                  
paylocation,FMCode,Org_SB,Org_branch,NBFC_cli)                  
SELECT cl_code,branch_cd,a.party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,                  
l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,                  
off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,                  
substring(p_state,1,15) as p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,                  
passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,                  
licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,                  
votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,                  
sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,                  
chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,                  
Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,                  
DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,                  
Micr_No,Director_name,paylocation,FMCode,sub_broker, branch_cd,'N'                  
FROM replicateddata.dbo.ANAND1MSAJAGClient_Details  a WITH(NOLOCK) join tmp_IncrClient b with (nolock)                  
on a.party_Code=b.party_code   

/*Added to rectify data for client ledger issue Feb 24 2021*/
insert into tmp_IncrClient_log
select *,getdate() from tmp_IncrClient     

update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='tmp_client_Details'  


insert into tbl_clientdetailsProcess_log
select  '99999',getdate(),''        
                  
DELETE FROM tmp_client_Details WHERE party_code >='0' AND party_code <='999999999999'                  
/* STEP-3: Fetch External Data */                  
--- NBFC Client (00:00 Secs)                  
select cl_code,cl_type,mobile_pager,                  
Valid = CASE WHEN LEN(ISNULL(mobile_pager,''))=10 AND LEFT(ISNULL(mobile_pager,''),1) in ('6','7','8','9') THEN 1 ELSE 0 END                  
into #nbfc_client                  
--from [172.31.16.59].LiveAngel_fundingsystem_new.dbo.Table_CLIENT_MASTER_FINAL WITH(NOLOCK)                
from ABVSCITRUS.inhouse.dbo.client_Details WITH(NOLOCK)                 
WHERE (cl_type='NBF' or cl_type='TMF') and mobile_pager <> ''                  
delete from #nbfc_client where valid=0                  
Create clustered index idxclnbfc on #nbfc_client (cl_code)                  
--- Call-N-Trade Deactivated Client (00:00 secs)                  
                  
SELECT Client_Id as Party_Code into #CNT_DeCli FROM mis.kyc.dbo.tbl_call_trade WITH (NOLOCK) WHERE flag='D'                  
                  
Create Clustered index idx_cli on #CNT_DeCli (party_Code)                  
--- Call-N-Trade Activate Entity (00:00 secs)                  
insert into Temp_CNT_AcCli                  
select id,entity_type,entity_code,product from mis.kyc.dbo.tbl_cnt_add_bo with (nolock)                  
--- BSE Demat Default DPid                  
select party_Code,bankid,cltdpid,depository into #BSECM_depDef FROM angeldemat.inhouse_bse.dbo.VW_Client4_def1 /* 00:11 Secs */                  
Create Clustered index idx_pty on #BSECM_depDef (party_Code) /* 00:03 Secs */                  
--- NSE Demat Default DPid                  
select party_Code,bankid,cltdpid,depository into #NSECM_depDef FROM angeldemat.inhouse_nse.dbo.VW_Client4_def1 /* 00:11 Secs */   


update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='99999'

insert into tbl_clientdetailsProcess_log
select  'upd tmp_client_details',getdate(),''
               
Create Clustered index idx_pty on #NSECM_depDef (party_Code) /* 00:02 Secs */                  
/* STEP-4: INCREMENTAL UPDATES -- 00:00 Secs*/                  
UPDATE tmp_client_details SET sub_broker=Org_SB,branch_cd=Org_branch WHERE Org_SB = 'BH'                  
UPDATE tmp_client_details SET Branch_cd='NVASHI' WHERE sub_Broker='ANET' AND branch_cd='VASHI'                  
UPDATE tmp_client_details SET Branch_cd='ANK' WHERE sub_Broker='ANK' AND branch_cd='XS'                  
UPDATE tmp_client_details SET Branch_cd='BHL' WHERE sub_Broker='MFS' AND branch_cd='HYD'                  
/* Step-5: UPDATE NRI CLIENT & CALL-N-TRADE STATUS --00:00 Secs*/   

update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='upd tmp_client_details'

insert into tbl_clientdetailsProcess_log
select  '#CALNT',getdate(),''                              
                  
SELECT cl_code,(CASE WHEN LEFT(CL_CODE,2)='ZR' AND cl_status='NRI' THEN 'NRIS' ELSE 'CALNT' END) AS status                  
INTO #CALNT                  
FROM NRICALLNTRADECLIENT WITH(NOLOCK)                  
WHERE (cl_status='NRI' AND cl_code LIKE 'ZR%') OR flag='CALNT'                  
                  
CREATE CLUSTERED INDEX IDXCL ON #CALNT (CL_CODE)                  
                  
/* Below Line Added by Manesh Mukherjee on 21/02/2014 4:04 pm*/                  
Delete from #CNT_DeCli where Party_Code in (select cl_code from #CALNT)                  
                  
/* change general_new.dbo.NRMS_clientDetails_log to NRMS_clientDetails_log on 09/04/2015*/      
                  
insert into NRMS_clientDetails_log (Batchid,BatchTaskid,Procname,StartTime,EndTime,LastStatus)                  
select 0,0,'Cli.NRI CNT-'+convert(varchar(2),@chkctr),@adate,getdate(),'Inprocess'                  
select @adate = getdate(), @chkctr = @chkctr+1                  
---Initialise Call-N-Trade deactivated Client                  
                  
SELECT PARTY_CODE                  
INTO #NO_CALNT                  
FROM client_details WITH (NOLOCK)                  
WHERE (branch_cd='NRIS' OR branch_cd='CALNT')                  
                  
select party_code into #RB_marking from                  
(                  
SELECT Party_Code FROM #CNT_DeCli                  
UNION                  
SELECT A.PARTY_CODE FROM #NO_CALNT A LEFT OUTER JOIN #CALNT B ON A.PARTY_cODE=B.CL_CODE WHERE B.CL_CODE IS NULL                  
) x                  
                  
CREATE CLUSTERED INDEX IDXCL ON #RB_marking (party_code)                  
--- Initialise CALNT status in Client_Details (00:00 Secs)                  
UPDATE CLIENT_DETAILS SET branch_cd=isnull(Org_branch,''),sub_Broker=isnull(Org_SB,'') FROM #RB_marking B WHERE CLIENT_DETAILS.PARTY_CODE=B.PARTY_CODE 

update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='#CALNT'

insert into tbl_clientdetailsProcess_log
select  'subgroup',getdate(),''
                                
--- Update Call-N-Trade activated Client (00:00 Secs)                  
--UPDATE tmp_client_details SET sub_broker=A.status,branch_cd=A.status FROM #CALNT A WHERE A.cl_code=tmp_client_details.cl_code                  
/* Step-7: Update Subgroup 00:00 Secs */                  
--- Add Incremental Records                  
INSERT INTO subgroup                  
SELECT a.sub_broker,SBName=MAX(Name)                  
FROM BO_subBrokers a WITH(NOLOCK)                  
LEFT JOIN subgroup b WITH(NOLOCK) ON a.sub_Broker = b.sub_Broker                  
WHERE b.Sub_Broker IS NULL                  
GROUP BY a.sub_Broker                  
--- Rectify existing Sub-brokers Name                  
UPDATE subgroup SET SBName = A.SBName                  
FROM (SELECT sub_broker,SBName=MAX(Name)   
FROM BO_subBrokers WITH(NOLOCK) GROUP BY sub_Broker) A                  
WHERE subgroup.sub_broker = A.sub_broker                  
/* Step-8: Update Branch 00:00 Secs */                  
INSERT INTO branch (sbtag,tradername,email,add5)                  
SELECT branch_cd=a.branch_code,a.Long_name,a.email,a.state                  
FROM BO_branch a WITH(NOLOCK)                  
LEFT JOIN branch b WITH(NOLOCK) ON a.BRANCH_CODE = b.sbtag                  
WHERE b.sbtag IS NULL                  
/* STEP-9: **** FULL UPDATION ******* 00:19 Secs */  


update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='subgroup'


insert into tbl_clientdetailsProcess_log
select  'client_details',getdate(),''
               
ALTER TABLE Client_details ENABLE TRIGGER [TRG_CLIENT_DETAILS]                  
BEGIN TRY                  
BEGIN TRAN                  
delete a from client_details a join tmp_client_details b with (nolock) on a.party_Code=b.party_code                  
INSERT INTO client_details                  
SELECT                  
A.cl_code,A.branch_cd,A.party_code,A.sub_broker,A.trader,A.long_name,A.short_name,A.l_address1,A.l_city,                  
A.l_address2,A.l_state,A.l_address3,A.l_nation,A.l_zip,A.pan_gir_no,A.ward_no,A.sebi_regn_no,A.res_phone1,                  
A.res_phone2,A.off_phone1,A.off_phone2,A.mobile_pager,A.fax,A.email,A.cl_type,A.cl_status,A.family,A.region,                  
A.area,A.p_address1,A.p_city,A.p_address2,A.p_state,A.p_address3,A.p_nation,A.p_zip,A.p_phone,A.addemailid,                  
A.sex,A.dob,A.introducer,A.approver,A.interactmode,A.passport_no,A.passport_issued_at,A.passport_issued_on,                  
A.passport_expires_on,A.licence_no,A.licence_issued_at,A.licence_issued_on,A.licence_expires_on,A.rat_card_no,                  
A.rat_card_issued_at,A.rat_card_issued_on,A.votersid_no,A.votersid_issued_at,A.votersid_issued_on,A.it_return_yr,                  
A.it_return_filed_on,A.regr_no,A.regr_at,A.regr_on,A.regr_authority,A.client_agreement_on,A.sett_mode,                  
A.dealing_with_other_tm,A.other_ac_no,A.introducer_id,A.introducer_relation,A.repatriat_bank,A.repatriat_bank_ac_no,                  
A.chk_kyc_form,A.chk_corporate_deed,A.chk_bank_certificate,A.chk_annual_report,A.chk_networth_cert,A.chk_corp_dtls_recd,                  
A.Bank_Name,A.Branch_Name,A.AC_Type,A.AC_Num,A.Depository1,A.DpId1,A.CltDpId1,A.Poa1,A.Depository2,A.DpId2,A.CltDpId2,                  
A.Poa2,A.Depository3,A.DpId3,A.CltDpId3,A.Poa3,A.rel_mgr,A.c_group,A.sbu,A.Status,A.Imp_Status,A.ModifidedBy,                  
A.ModifidedOn,A.Bank_id,A.Mapin_id,A.UCC_Code,A.Micr_No,A.Director_name,A.paylocation,A.FMCode,A.BSECM_LAST_DATE,                  
A.NSECM_LAST_DATE,A.BSEFO_LAST_DATE,A.NSEFO_LAST_DATE,A.NCDEX_LAST_DATE,A.MCX_LAST_DATE,A.NSX_LAST_DATE,A.MCD_LAST_DATE,                  
A.comb_LAST_DATE,A.bsecm,A.nsecm,A.nsefo,A.mcdx,A.ncdx,A.bsefo,A.mcd,A.nsx,A.Last_inactive_date,A.First_Active_date,                  
A.NBFC_cli,A.Org_SB,A.Org_branch,A.BSX,A.BSX_LAST_DATE,NULL,NULL                      
FROM tmp_client_details a WITH (NOLOCK)                  
COMMIT TRAN                  
END TRY                  
BEGIN CATCH                  
ROLLBACK TRAN                  
END CATCH 

update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='client_details'
/*Added to rectify data for client ledger issue Feb 24 2021*/
--insert into tmp_client_details_log
--select *,Upd_date=getdate()  from tmp_client_details 

insert into tbl_clientdetailsProcess_log
select  'upd client_details',getdate(),''
   
UPDATE client_details SET nbfc_cli = 'Y' WHERE cl_type IN ('NBF','TMF')                  
                  
ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                  
/*---- Update Call-N-Trade Tag in Client Master ----*/                  
                  
UPDATE client_details                  
SET sub_broker=A.status,branch_cd=A.status                  
FROM #CALNT A                  
WHERE A.cl_code=client_details.cl_code                  
                  
UPDATE b                  
SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.party_Code=A.entity_code                  
AND entity_type='party_Code' AND product='CALNT' and isnull(entity_Code,'') <> ''                  
                  
UPDATE b                  
SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b INNER JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.sub_Broker=A.entity_code                  
AND entity_type='ori_sub_broker' AND product='CALNT' and isnull(entity_Code,'') <> '' LEFT JOIN #CNT_DeCli c WITH(NOLOCK) ON b.party_code = c.party_code                  
WHERE c.party_Code IS NULL and left(a.entity_Code,2) <> 'CB'                  
                  
UPDATE b                  
SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b INNER JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.branch_cd=A.entity_code                  
AND entity_type='ori_branch_cd' AND product='CALNT' and isnull(entity_Code,'') <> '' LEFT JOIN #CNT_DeCli c WITH(NOLOCK) ON b.party_code = c.party_code                  
WHERE c.party_code IS NULL        


update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='upd client_details'  


insert into tbl_clientdetailsProcess_log
select  'Temp_ClientCode_Series',getdate(),''        
                
/*---CODE ADDED ON 28 AUG 2014 TO INSERT SEGMENTWISE CLIENTS WITH SERIES---MOVED FROM UPD_SSIS_LEDGER*/ 

SELECT SEGMENT,PCODE=Y.seriescode+LTRIM(RTRIM(party_Code)),seriesDesc into #incTemp_ClientCode_Series                   
FROM (SELECT a.party_Code                   
  FROM tmp_IncrClient a                   
  INNER JOIN client_details b WITH(NOLOCK) ON a.party_Code = b.party_code                   
  --WHERE DBAction IN ('INSERTED','DELETED')                  
  GROUP BY a.party_Code                  
  HAVING COUNT(*) = 1) X                  
CROSS JOIN LedgerSeries Y WITH(NOLOCK)                  
WHERE Segment IN('BSECM','MCD','MCX','NCDEX','NSECM','NSEFO','NSX','BSX')                  
AND active=1                  
AND EntityType='Client' 

/*Added to rectify data for client ledger issue Feb 24 2021*/
insert into tbl_incTemp_ClientCode_Series_log
select *,upd_date=getdate()  from #incTemp_ClientCode_Series


--delete a from Temp_ClientCode_Series  a join tmp_IncrClient b on a.pcode=b.Party_Code
delete a from Temp_ClientCode_Series  a join #incTemp_ClientCode_Series b on a.pcode=b.PCODE

/*drop index to optimize query as on Sep 02 2016*/
--drop index Temp_ClientCode_Series.IX_Code

INSERT INTO Temp_ClientCode_Series  (segment,pcode,seriesDesc)                  
select * from  #incTemp_ClientCode_Series  

drop table #incTemp_ClientCode_Series


update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='Temp_ClientCode_Series'

/*create index again to optimize query as on Sep 02 2016*/
--CREATE CLUSTERED INDEX IX_CODE ON Temp_ClientCode_Series(segment, pcode)                
/*--------END----------*/                
                
               
/* --- Commented by Manesh Mukherjee on 21/02/2014 ---                  
                  
select x.* from                  
(                  
select a.* from                  
(select party_Code,sub_BRoker from client_Details with (nolock) ) a join (select cl_code from NRICALLNTRADECLIENT with (nolock)) b                  
on a.party_Code=b.cl_Code                
) x join                  
(select * from Temp_CNT_AcCli where entity_type='ori_sub_broker' AND product='CALNT' and left(entity_Code,2)='CB') y                  
on x.sub_Broker=y.entity_Code                  
*/                  
 
 
insert into tbl_clientdetailsProcess_log
select  'branch_cd',getdate(),''
                  
select a.party_Code,a.sub_BRoker,a.branch_cd,a.org_SB,a.Org_branch into #Temp_cnt from                  
(select party_Code,sub_BRoker,branch_cd,org_SB,Org_branch from client_Details with (nolock) where sub_BRoker<>org_SB) a join                  
(select * from Temp_CNT_AcCli where entity_type='ori_sub_broker' AND product='CALNT' and left(entity_Code,2)='CB') b                  
on a.org_sb=b.entity_Code                  
                  
update client_details set branch_cd=client_details.Org_branch,Sub_Broker=client_details.org_sb from #temp_cnt b where client_details.party_Code=b.party_Code                  
/* STEP-10: ---- UPDATE DEPOSITORY INFORMATION ---*/                  
UPDATE client_details                  
SET Depository1=b.Depository,DPid1=b.Bankid,Cltdpid1=b.Cltdpid                  
FROM #BSECM_depDef b /* 00:04 secs (Total 11+03+04=17 Secs :: direct fetching 00:26 secs */                  
WHERE client_details.party_Code=b.party_Code and ISNULL(client_details.cltdpid1,'') = ''                  
UPDATE client_details                  
SET Depository1=b.Depository,DPid1=b.Bankid,Cltdpid1=b.Cltdpid                  
FROM #NSECM_depDef b /* 00:01 secs (Total 11+03+01=15 Secs :: direct fetching 00:17 secs */        
WHERE client_details.party_Code=b.party_Code and ISNULL(client_details.cltdpid1,'') = ''                  
/* STEP-11:------ UPDATE NBFC CLIENT Telephone No(s) */                  
UPDATE a                  
SET fax = b.mobile_pager                  
FROM client_details a WITH(NOLOCK)                  
JOIN                  
#nbfc_client b WITH(NOLOCK)                  
ON a.party_Code=b.cl_code                  
/* Step-13: ---- MODIFIED Date udpate ---- 00:02 Secs */                  
UPDATE client_details SET modifidedon = b.editedOn                  
FROM                  
( SELECT cltcode,editedOn=MAX(editedOn) FROM AngelNseCM.msajag.dbo.multibankid_log WITH(NOLOCK) GROUP BY cltcode ) b                  
WHERE client_details.party_Code=b.cltcode   


update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='branch_cd'
               
BEGIN TRY                  
BEGIN TRAN                  
COMMIT TRAN                  
END TRY                  
BEGIN CATCH                  
ROLLBACK TRAN                  
END CATCH       


insert into tbl_clientdetailsProcess_log
select  'NRMS_Upd_Finmast',getdate(),''         
exec NRMS_Upd_Finmast /* 02 secs */
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='NRMS_Upd_Finmast' 

insert into tbl_clientdetailsProcess_log
select  'NRMS_Client_Vertical',getdate(),''                                                        
exec NRMS_Client_Vertical /* 40 Secs */   
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='NRMS_Client_Vertical'
                            

insert into tbl_clientdetailsProcess_log
select  'NRMS_CliVertical_missing_Email',getdate(),''           
exec NRMS_CliVertical_missing_Email
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='NRMS_CliVertical_missing_Email'
                            

insert into tbl_clientdetailsProcess_log
select  'NRMS_Vandha_POA',getdate(),''                        
exec NRMS_Vandha_POA /* 05 Secs */    
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='NRMS_Vandha_POA'
                            

insert into tbl_clientdetailsProcess_log
select  'Upd_ClientBrokDetails_Incr',getdate(),''                        
exec [Upd_ClientBrokDetails_Incr] /* 01 Secs */  
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='Upd_ClientBrokDetails_Incr'
                            

insert into tbl_clientdetailsProcess_log
select  'Upd_Client_Activation_date',getdate(),''                           
exec Upd_Client_Activation_date /* 01 SEcs */ 
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='Upd_Client_Activation_date'
                            

insert into tbl_clientdetailsProcess_log
select  'USP_UPDATE_CALNT_MISSING_BRANCH',getdate(),''            
exec USP_UPDATE_CALNT_MISSING_BRANCH
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='USP_UPDATE_CALNT_MISSING_BRANCH'
                      

insert into tbl_clientdetailsProcess_log
select  'usp_insert_missing_sb',getdate(),''           
EXEC usp_insert_missing_sb
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='usp_insert_missing_sb'
                            

insert into tbl_clientdetailsProcess_log
select  'usp_insertTempseriesLedger',getdate(),''         
exec [usp_insertTempseriesLedger]
update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='usp_insertTempseriesLedger'

--insert into tbl_clientdetailsProcess_log
--select  'usp_b2b_update',getdate(),'' 
--exec usp_b2b_update
--update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='usp_b2b_update'


--insert into tbl_clientdetailsProcess_log
--select  'Prc_INSMFData',getdate(),''  
--exec  Prc_INSMFData 
--update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='Prc_INSMFData'

        

/*added by abha on jul 14 2015 to check job status*/    
 declare @Status varchar(20)    
 set @Status=''    
 exec NRMS_JoBStatus 'NBFC_Client_Activation_Date',@Status  output      
 if(@Status='In Progress')    
 begin    
 print 'job is already running'      
 end    
 else    
 begin    
 EXEC msdb.dbo.sp_start_job 'NBFC_Client_Activation_Date'    
 end                     
        
/*added by abha on jul 14 2015 to check job status*/    
       
 set @Status=''    
 exec NRMS_JoBStatus 'SB CMS MASTER INSERT',@Status  output    
 if(@Status='In Progress')    
 begin    
 print 'job is already running'      
 end    
 else    
 begin    
 EXEC [MIS].msdb.dbo.sp_start_job 'SB CMS MASTER INSERT'     
 end  
                
     

insert into tbl_clientdetailsProcess_log
select  'UPD_ANGELSCRIPCATEGORY',getdate(),''

EXEC UPD_ANGELSCRIPCATEGORY /* 00 Secs */  

update tbl_clientdetailsProcess_log set EndTime=getdate() where Processname='UPD_ANGELSCRIPCATEGORY'
                                            

END try                  
begin catch                  
INSERT INTO EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)                  
SELECT GETDATE(),'upd_client_details',ERROR_LINE(),ERROR_MESSAGE()           
ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                  
/*                  
update NRMS_clientDetails_log set LastError=Error_line(),LastErrorDatetime=getdate() where srno=                  
(select max(srno) as srno from NRMS_clientDetails_log with (nolock) where LastStatus='Inprocess')                  
*/                  
DECLARE @ErrorMessage NVARCHAR(4000);                  
SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                  
RAISERROR (@ErrorMessage , 16, 1);                  
END catch;                  
ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                  
UPDATE MasterUpdDate SET lastupdated_on=GETDATE() WHERE particular='CLIENT_MASTER'                  
/*                  
update NRMS_clientDetails_log set LastStatus='Success' where srno=                  
(select max(srno) as srno from NRMS_clientDetails_log with (nolock) where LastStatus='Inprocess')                  
*/                 
SET nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_client_details_FULL_Bak_10122023
-- --------------------------------------------------

Create  procedure [dbo].[upd_client_details_FULL_Bak_10122023]                            
AS                            
SET NOCOUNT ON          
SET XACT_ABORT ON                           
BEGIN TRY 

 /*                            
 NOTE: Never execute part of the queries from this SP.                            
 */                            
 /* STEP-1 : define Variables and Initialize environment --- 00:01 Secs*/                            
 /* insert into NRMS_clientDetails_log (Batchid,BatchTaskid,Procname,StartTime,LastStatus) select 0,0,'upd_client_details',getdate(),'Inprocess' */                            
 declare @adate as datetime, @chkctr as int                            
 set @chkctr = 0                            
 select @adate = getdate(), @chkctr = @chkctr+1                            
              
 --Step---1                            
 DECLARE @lastchangedate as datetime                            
 select @lastchangedate=max(BatchTaskStartTime) from Rms_SSISBatchTaskJob_log with (nolock) where batchid=1 and batchtaskid=3 and batchTaskStatus='Y'                            
 /* select @lastchangedate=max(EndTime) from NRMS_clientDetails_log with (nolock) where laststatus='Success' */                            
              
 TRUNCATE TABLE tmp_client_details                            
 TRUNCATE TABLE tmp_IncrClient                            
 TRUNCATE TABLE client_details_trig                            
 TRUNCATE TABLE Client_Brok_Details_trig                            
 TRUNCATE TABLE Temp_CNT_AcCli                   
                        
 insert into Client_Brok_Details_trig(Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status)                            
 select CL_CODE,Exchange,Segment,GETDATE() AS UpdateDate,'UPDATED' AS DBAction,ACTIVE_DATE AS Activate_Date,InActive_From,Status                            
 from AngelNseCM.msajag.dbo.client_brok_details with (nolock)               
                          
 /* NOTE: Update all the party codes in table client_brok_details_trig from full updation */                            
 insert into tmp_IncrClient(party_Code)                            
 select party_Code from ReplicatedData.dbo.ANAND1MSAJAGClient_Details WITH (NOLOCK)              
              
 select Party_Code,Exchange,Segment,max(UpdateDate) as UpdateDate,max(DBAction) as DBAction,Activate_Date,InActive_From,max(Status) as Status                            
 into #cd_trig                            
 from Client_Brok_Details_trig with (nolock)                            
 group by Party_Code,Exchange,Segment,Activate_Date,InActive_From                            
 select a.party_code into #clt from tmp_IncrClient a with (nolock) left outer join client_brok_details_trig b with (nolock) on a.party_Code=b.party_code where b.party_code is null                            
 insert into #cd_trig (Party_Code,Exchange,Segment,Activate_Date,InActive_From,Status)                            
 select cl_Code,Exchange,Segment,Active_Date,InActive_From,Status from Client_Brok_Details a with (nolock) join #clt B ON A.CL_cODE=B.PARTY_CODE                            
              
 truncate table Client_Brok_Details_trig                            
 insert into Client_Brok_Details_trig select Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status from #cd_trig                            
 drop table #cd_trig                            
 /* Step-2 : Fetch required data from source --- 00:06 Secs (7810 records:Time 8:51 PM)*/                            
              
 INSERT INTO tmp_client_Details(cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,                            
 l_city,l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,                            
 off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,                            
 p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,                          
 passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,                            
 licence_issued_on,licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,                            
 votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,                            
 client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,                            
 repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,                            
 chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,                            
 Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,                            
 rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Director_name,                            
 paylocation,FMCode,Org_SB,Org_branch,NBFC_cli)                            
 SELECT cl_code,branch_cd,a.party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,                            
 l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,                            
 off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,                            
 substring(p_state,1,15) as p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,                            
 passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,                            
 licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,                            
 votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,                            
 sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,                            
 chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,                            
 Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,                            
 DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,                            
 Micr_No,Director_name,paylocation,FMCode,sub_broker, branch_cd,'N'                            
 FROM ReplicatedData.dbo.ANAND1MSAJAGClient_Details a WITH(NOLOCK) 
 --join tmp_IncrClient b with (nolock) on a.party_Code=b.party_code                            
                            
 DELETE FROM tmp_client_Details WHERE party_code >='0' AND party_code <='999999999999'                            
 /* STEP-3: Fetch External Data */                            
 --- NBFC Client (00:00 Secs)                            
 select cl_code,cl_type,mobile_pager,                            
 Valid = CASE WHEN LEN(ISNULL(mobile_pager,''))=10 AND LEFT(ISNULL(mobile_pager,''),1) in ('6','7','8','9') THEN 1 ELSE 0 END                            
 into #nbfc_client                            
 --from [172.31.16.59].LiveAngel_fundingsystem_new.dbo.Table_CLIENT_MASTER_FINAL WITH(NOLOCK)                          
 from [ABVSCITRUS].inhouse.dbo.client_Details WITH(NOLOCK)                           
 WHERE (cl_type='NBF' or cl_type='TMF') and mobile_pager <> ''                            
 delete from #nbfc_client where valid=0                            
 Create clustered index idxclnbfc on #nbfc_client (cl_code)                            
 
 --- Call-N-Trade Deactivated Client (00:00 secs)                            
   /*                          
 SELECT Client_Id as Party_Code into #CNT_DeCli FROM mis.kyc.dbo.tbl_call_trade WITH (NOLOCK) WHERE flag='D'                            
                            
 Create Clustered index idx_cli on #CNT_DeCli (party_Code)                            
 --- Call-N-Trade Activate Entity (00:00 secs)                            
 insert into Temp_CNT_AcCli                            
 select id,entity_type,entity_code,product from mis.kyc.dbo.tbl_cnt_add_bo with (nolock)                            
 --- BSE Demat Default DPid                            
 select party_Code,bankid,cltdpid,depository into #BSECM_depDef FROM angeldemat.inhouse_bse.dbo.VW_Client4_def1 /* 00:11 Secs */                            
 Create Clustered index idx_pty on #BSECM_depDef (party_Code) /* 00:03 Secs */                            
 --- NSE Demat Default DPid                            
 select party_Code,bankid,cltdpid,depository into #NSECM_depDef FROM angeldemat.inhouse_nse.dbo.VW_Client4_def1 /* 00:11 Secs */                            
 Create Clustered index idx_pty on #NSECM_depDef (party_Code) /* 00:02 Secs */                            
 /* STEP-4: INCREMENTAL UPDATES -- 00:00 Secs*/                            
 UPDATE tmp_client_details SET sub_broker=Org_SB,branch_cd=Org_branch WHERE Org_SB = 'BH'                            
 UPDATE tmp_client_details SET Branch_cd='NVASHI' WHERE sub_Broker='ANET' AND branch_cd='VASHI'                            
 UPDATE tmp_client_details SET Branch_cd='ANK' WHERE sub_Broker='ANK' AND branch_cd='XS'                            
 UPDATE tmp_client_details SET Branch_cd='BHL' WHERE sub_Broker='MFS' AND branch_cd='HYD'                            
 /* Step-5: UPDATE NRI CLIENT & CALL-N-TRADE STATUS --00:00 Secs*/                            
                             
 SELECT cl_code,(CASE WHEN LEFT(CL_CODE,2)='ZR' AND cl_status='NRI' THEN 'NRIS' ELSE 'CALNT' END) AS status                            
 INTO #CALNT                            
 FROM NRICALLNTRADECLIENT WITH(NOLOCK)                            
 WHERE (cl_status='NRI' AND cl_code LIKE 'ZR%') OR flag='CALNT'                            
                             
 CREATE CLUSTERED INDEX IDXCL ON #CALNT (CL_CODE)                            
                             
 /* Below Line Added by Manesh Mukherjee on 21/02/2014 4:04 pm*/                            
 Delete from #CNT_DeCli where Party_Code in (select cl_code from #CALNT)                            
                             
 /* change general_new.dbo.NRMS_clientDetails_log to NRMS_clientDetails_log on 09/04/2015*/                
                             
 insert into NRMS_clientDetails_log (Batchid,BatchTaskid,Procname,StartTime,EndTime,LastStatus)                            
 select 0,0,'Cli.NRI CNT-'+convert(varchar(2),@chkctr),@adate,getdate(),'Inprocess'                            
 select @adate = getdate(), @chkctr = @chkctr+1                            
 ---Initialise Call-N-Trade deactivated Client                            
                            
 SELECT PARTY_CODE                            
 INTO #NO_CALNT                            
 FROM client_details WITH (NOLOCK)                            
 WHERE (branch_cd='NRIS' OR branch_cd='CALNT')                            
                             
 select party_code into #RB_marking from                            
 (                            
 SELECT Party_Code FROM #CNT_DeCli                            
 UNION                            
 SELECT A.PARTY_CODE FROM #NO_CALNT A LEFT OUTER JOIN #CALNT B ON A.PARTY_cODE=B.CL_CODE WHERE B.CL_CODE IS NULL                            
 ) x                            
                             
 CREATE CLUSTERED INDEX IDXCL ON #RB_marking (party_code)                            
 --- Initialise CALNT status in Client_Details (00:00 Secs)                            
              
 UPDATE CLIENT_DETAILS SET branch_cd=isnull(Org_branch,''),sub_Broker=isnull(Org_SB,'') FROM #RB_marking B WHERE CLIENT_DETAILS.PARTY_CODE=B.PARTY_CODE                            
 --- Update Call-N-Trade activated Client (00:00 Secs)                            
 --UPDATE tmp_client_details SET sub_broker=A.status,branch_cd=A.status FROM #CALNT A WHERE A.cl_code=tmp_client_details.cl_code                            
 /* Step-7: Update Subgroup 00:00 Secs */                            
 --- Add Incremental Records                            
*/              
 INSERT INTO subgroup                            
 SELECT a.sub_broker,SBName=MAX(Name)                            
 FROM BO_subBrokers a WITH(NOLOCK)                            
 LEFT JOIN subgroup b WITH(NOLOCK) ON a.sub_Broker = b.sub_Broker                            
 WHERE b.Sub_Broker IS NULL                            
 GROUP BY a.sub_Broker                            
 --- Rectify existing Sub-brokers Name                            
              
 UPDATE subgroup SET SBName = A.SBName                            
 FROM (SELECT sub_broker,SBName=MAX(Name)                            
 FROM BO_subBrokers WITH(NOLOCK) GROUP BY sub_Broker) A                            
 WHERE subgroup.sub_broker = A.sub_broker                            
 /* Step-8: Update Branch 00:00 Secs */                            
              
 INSERT INTO branch (sbtag,tradername,email,add5)                            
 SELECT branch_cd=a.branch_code,a.Long_name,a.email,a.state                            
 FROM BO_branch a WITH(NOLOCK)                            
 LEFT JOIN branch b WITH(NOLOCK) ON a.BRANCH_CODE = b.sbtag                            
WHERE b.sbtag IS NULL                            
 /* STEP-9: **** FULL UPDATION ******* 00:19 Secs */ 
 
select *
into #client_Details
from client_Details a
where not exists (select 1/0 from tmp_client_details b with (nolock) where a.party_Code=b.party_code)

              
BEGIN TRY                            
 BEGIN TRAN                            
  --delete a from client_details a join tmp_client_details b with (nolock) on a.party_Code=b.party_code                            
  truncate table client_Details
  INSERT INTO client_details                            
  SELECT                            
  A.cl_code,A.branch_cd,A.party_code,A.sub_broker,A.trader,A.long_name,A.short_name,A.l_address1,A.l_city,                            
  A.l_address2,A.l_state,A.l_address3,A.l_nation,A.l_zip,A.pan_gir_no,A.ward_no,A.sebi_regn_no,A.res_phone1,                            
  A.res_phone2,A.off_phone1,A.off_phone2,A.mobile_pager,A.fax,A.email,A.cl_type,A.cl_status,A.family,A.region,                            
  A.area,A.p_address1,A.p_city,A.p_address2,A.p_state,A.p_address3,A.p_nation,A.p_zip,A.p_phone,A.addemailid,                            
  A.sex,A.dob,A.introducer,A.approver,A.interactmode,A.passport_no,A.passport_issued_at,A.passport_issued_on,                            
  A.passport_expires_on,A.licence_no,A.licence_issued_at,A.licence_issued_on,A.licence_expires_on,A.rat_card_no,                            
  A.rat_card_issued_at,A.rat_card_issued_on,A.votersid_no,A.votersid_issued_at,A.votersid_issued_on,A.it_return_yr,                            
  A.it_return_filed_on,A.regr_no,A.regr_at,A.regr_on,A.regr_authority,A.client_agreement_on,A.sett_mode,                            
  A.dealing_with_other_tm,A.other_ac_no,A.introducer_id,A.introducer_relation,A.repatriat_bank,A.repatriat_bank_ac_no,                            
  A.chk_kyc_form,A.chk_corporate_deed,A.chk_bank_certificate,A.chk_annual_report,A.chk_networth_cert,A.chk_corp_dtls_recd,                            
  A.Bank_Name,A.Branch_Name,A.AC_Type,A.AC_Num,A.Depository1,A.DpId1,A.CltDpId1,A.Poa1,A.Depository2,A.DpId2,A.CltDpId2,                            
  A.Poa2,A.Depository3,A.DpId3,A.CltDpId3,A.Poa3,A.rel_mgr,A.c_group,A.sbu,A.Status,A.Imp_Status,A.ModifidedBy,                            
  A.ModifidedOn,A.Bank_id,A.Mapin_id,A.UCC_Code,A.Micr_No,A.Director_name,A.paylocation,A.FMCode,A.BSECM_LAST_DATE,                            
  A.NSECM_LAST_DATE,A.BSEFO_LAST_DATE,A.NSEFO_LAST_DATE,A.NCDEX_LAST_DATE,A.MCX_LAST_DATE,A.NSX_LAST_DATE,A.MCD_LAST_DATE,                            
  A.comb_LAST_DATE,A.bsecm,A.nsecm,A.nsefo,A.mcdx,A.ncdx,A.bsefo,A.mcd,A.nsx,A.Last_inactive_date,A.First_Active_date,                            
  A.NBFC_cli,A.Org_SB,A.Org_branch,A.BSX,A.BSX_LAST_DATE,NULL,NULL                                  
  FROM #client_Details a WITH (NOLOCK)                            
  COMMIT TRAN                            
  END TRY                            
  BEGIN CATCH                            
  ROLLBACK TRAN                            
  END CATCH                            
                              
  UPDATE client_details SET nbfc_cli = 'Y' WHERE cl_type IN ('NBF','TMF')                            
                              
  ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                            
  /*---- Update Call-N-Trade Tag in Client Master ----*/                            
  /*                            
  UPDATE client_details                            
  SET sub_broker=A.status,branch_cd=A.status                            
  FROM #CALNT A                            
  WHERE A.cl_code=client_details.cl_code                            
                              
  UPDATE b                            
  SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.party_Code=A.entity_code                            
  AND entity_type='party_Code' AND product='CALNT' and isnull(entity_Code,'') <> ''                            
                              
  UPDATE b                            
  SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b INNER JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.sub_Broker=A.entity_code                            
  AND entity_type='ori_sub_broker' AND product='CALNT' and isnull(entity_Code,'') <> '' LEFT JOIN #CNT_DeCli c WITH(NOLOCK) ON b.party_code = c.party_code                            
  WHERE c.party_Code IS NULL and left(a.entity_Code,2) <> 'CB'                            
                              
  UPDATE b                            
  SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b INNER JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.branch_cd=A.entity_code                            
  AND entity_type='ori_branch_cd' AND product='CALNT' and isnull(entity_Code,'') <> '' LEFT JOIN #CNT_DeCli c WITH(NOLOCK) ON b.party_code = c.party_code                            
  WHERE c.party_code IS NULL                            
 */                           
  /*---CODE ADDED ON 28 AUG 2014 TO INSERT SEGMENTWISE CLIENTS WITH SERIES---MOVED FROM UPD_SSIS_LEDGER*/ 
  
 IF  EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_tmp_pcode')
  DROP INDEX idx_tmp_pcode ON [dbo].[tbl_inc_fullTemp_ClientCode_Series]

 CREATE NONCLUSTERED INDEX [idx_tmp_pcode] ON [dbo].[tbl_inc_fullTemp_ClientCode_Series]
 (
		[pcode] ASC
 )

 SELECT a.party_Code into #sereies                            
 FROM tmp_IncrClient a                             
 INNER JOIN client_details b WITH(NOLOCK) ON a.party_Code = b.party_code                             
 --WHERE DBAction IN ('INSERTED','DELETED')                            
 GROUP BY a.party_Code                            
 HAVING COUNT(*) = 1
 
 truncate table [tbl_inc_fullTemp_ClientCode_Series]
 insert into [tbl_inc_fullTemp_ClientCode_Series](SEGMENT,PCODE,seriesDesc)
 SELECT SEGMENT,PCODE=Y.seriescode+LTRIM(RTRIM(party_Code)),seriesDesc                                     
 FROM #sereies X                            
 CROSS JOIN LedgerSeries Y WITH(NOLOCK)                            
 WHERE Segment IN('BSECM','MCD','MCX','NCDEX','NSECM','NSEFO','NSX','BSX')                            
 AND active=1                            
 AND EntityType='Client'  
                             
/*

	WHILE (1=1)
		BEGIN
			SET ROWCOUNT 3000000
			delete a from Temp_ClientCode_Series  a join #inc_fullTemp_ClientCode_Series b on a.pcode=b.pcode 
			IF (@@ROWCOUNT = 0)
				BREAK
			SET ROWCOUNT 0

			--WAITFOR DELAY '00:00:00.200'
		END

	SET ROWCOUNT 0  

	/*
	End of new code
	*/
*/

  /* added on 03-09-2016  for opt*/
    
  --DROP INDEX [IX_Code] ON [dbo].[Temp_ClientCode_Series]  ----------
  
  --IF  EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Code_TCCS')
  --DROP INDEX [idx_Code_TCCS] ON [dbo].[Temp_ClientCode_Series]
  
  select segment,pcode,seriesDesc into #Temp_ClientCode_Series_ins 
  from [tbl_inc_fullTemp_ClientCode_Series] T1 with (nolock)
  where not exists 
  (select pcode from Temp_ClientCode_Series T2 with (nolock) where T1.pcode=T2.PCODE 
  and T1.segment=T2.segment and T1.seriesDesc=T2.seriesDesc)--6:58
  
  INSERT INTO Temp_ClientCode_Series (segment,pcode,seriesDesc)                            
  select * from #Temp_ClientCode_Series_ins  
  
  /*
  select a.party_Code,a.sub_BRoker,a.branch_cd,a.org_SB,a.Org_branch into #Temp_cnt from                            
  (select party_Code,sub_BRoker,branch_cd,org_SB,Org_branch from client_Details with (nolock) where sub_BRoker<>org_SB) a join                            
  (select * from Temp_CNT_AcCli where entity_type='ori_sub_broker' AND product='CALNT' and left(entity_Code,2)='CB') b                            
  on a.org_sb=b.entity_Code                            
                              
  update client_details set branch_cd=client_details.Org_branch,Sub_Broker=client_details.org_sb from #temp_cnt b where client_details.party_Code=b.party_Code                            
               
  /* STEP-10: ---- UPDATE DEPOSITORY INFORMATION ---*/                            
  UPDATE client_details                            
  SET Depository1=b.Depository,DPid1=b.Bankid,Cltdpid1=b.Cltdpid                            
  FROM #BSECM_depDef b /* 00:04 secs (Total 11+03+04=17 Secs :: direct fetching 00:26 secs */                            
  WHERE client_details.party_Code=b.party_Code and ISNULL(client_details.cltdpid1,'') = ''                            
               
  UPDATE client_details                            
  SET Depository1=b.Depository,DPid1=b.Bankid,Cltdpid1=b.Cltdpid                            
  FROM #NSECM_depDef b /* 00:01 secs (Total 11+03+01=15 Secs :: direct fetching 00:17 secs */          
  WHERE client_details.party_Code=b.party_Code and ISNULL(client_details.cltdpid1,'') = ''                            
  /* STEP-11:------ UPDATE NBFC CLIENT Telephone No(s) */                            
               
  UPDATE a                            
  SET fax = b.mobile_pager                            
  FROM client_details a WITH(NOLOCK)                            
  JOIN                            
  #nbfc_client b WITH(NOLOCK)                            
  ON a.party_Code=b.cl_code                            
  /* Step-13: ---- MODIFIED Date udpate ---- 00:02 Secs */   
  */
               
  UPDATE client_details SET modifidedon = b.editedOn                            
  FROM                            
  ( SELECT cltcode,editedOn=MAX(editedOn) FROM AngelNseCM.msajag.dbo.multibankid_log WITH(NOLOCK) GROUP BY cltcode ) b                            
  WHERE client_details.party_Code=b.cltcode                            
              
 BEGIN TRY                            
  BEGIN TRAN                            
  COMMIT TRAN                            
 END TRY                            
 BEGIN CATCH                            
  ROLLBACK TRAN                            
 END CATCH                   
                       
 exec NRMS_Upd_Finmast /* 02 secs */                            
 exec NRMS_Client_Vertical_FULL   /* 40 Secs */           
 exec NRMS_CliVertical_missing_Email                           
 exec NRMS_Vandha_POA /* 05 Secs */                            
 /* exec [Upd_ClientBrokDetails_Incr] /* 01 Secs */*/ 
 exec Upd_ClientBrokDetails_FULL /* 01 Secs */                            
 exec Upd_Client_Activation_date /* 01 SEcs */                            
/*added by abha on jul 14 2015 to check job status*/        
    declare @Status varchar(20)        
 set @Status=''        
 exec NRMS_JoBStatus 'NBFC_Client_Activation_Date',@Status  output         
 if(@Status='In Progress')        
 begin        
 print 'job is already running'         
 end        
 else        
 begin        
 EXEC msdb.dbo.sp_start_job 'NBFC_Client_Activation_Date'        
 end                         
            
/*added by abha on jul 14 2015 to check job status*/        
           
 set @Status=''        
 exec NRMS_JoBStatus 'SB CMS MASTER INSERT',@Status  output          
 if(@Status='In Progress')        
 begin        
 print 'job is already running'        
 end        
 else        
 begin        
 EXEC [MIS].msdb.dbo.sp_start_job 'SB CMS MASTER INSERT'         
 end      
               
 UPDATE MasterUpdDate SET lastupdated_on=GETDATE() WHERE particular='CLIENT_MASTER'                      
 exec NRMS_upd_client_details_FULL_Notification 1 
 
 --commented on Sep 30 2016 as suggested by sir         
  /*   
 delete from anand1.msajag.dbo.client_brok_details_trig    
 delete from anand1.msajag.dbo.client_details_trig   
 */
 /*Commented on Sep 24 2016 as discussed with Renil Sir*/ 
 /*     
 IF  not EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Code_TCCS')
Create NonClustered Index idx_Code_TCCS on Temp_ClientCode_Series (segment, pcode)
*/
 
  
  /*------start INDEX [IX_Code]      03-09-2016 */
  /*
  CREATE CLUSTERED INDEX [IX_Code] ON [dbo].[Temp_ClientCode_Series] 
  (
	[segment] ASC,
	[pcode] ASC
 )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = ON, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SECONDARY]
      /*-------end INDEX [IX_Code] */                    
  /*--------END----------*/      
    */
          
END try                            
begin catch                            
 INSERT INTO EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)        
 SELECT GETDATE(),'upd_client_details_FULL',ERROR_LINE(),ERROR_MESSAGE()                     
 ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                            
 DECLARE @ErrorMessage NVARCHAR(4000);                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                            
 RAISERROR (@ErrorMessage , 16, 1);           
           
 exec NRMS_upd_client_details_FULL_Notification 0,@ErrorMessage          
                            
END catch;                            
              
              
SET nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_client_details_FULL_bkup_05122023
-- --------------------------------------------------

create  procedure [dbo].[upd_client_details_FULL_bkup_05122023]                            
AS                            
SET NOCOUNT ON          
SET XACT_ABORT ON                           
BEGIN TRY 

 /*                            
 NOTE: Never execute part of the queries from this SP.                            
 */                            
 /* STEP-1 : define Variables and Initialize environment --- 00:01 Secs*/                            
 /* insert into NRMS_clientDetails_log (Batchid,BatchTaskid,Procname,StartTime,LastStatus) select 0,0,'upd_client_details',getdate(),'Inprocess' */                            
 declare @adate as datetime, @chkctr as int                            
 set @chkctr = 0                            
 select @adate = getdate(), @chkctr = @chkctr+1                            
              
 --Step---1                            
 DECLARE @lastchangedate as datetime                            
 select @lastchangedate=max(BatchTaskStartTime) from Rms_SSISBatchTaskJob_log with (nolock) where batchid=1 and batchtaskid=3 and batchTaskStatus='Y'                            
 /* select @lastchangedate=max(EndTime) from NRMS_clientDetails_log with (nolock) where laststatus='Success' */                            
              
 TRUNCATE TABLE tmp_client_details                            
 TRUNCATE TABLE tmp_IncrClient                            
 TRUNCATE TABLE client_details_trig                            
 TRUNCATE TABLE Client_Brok_Details_trig                            
 TRUNCATE TABLE Temp_CNT_AcCli                   
                        
 insert into Client_Brok_Details_trig(Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status)                            
 select CL_CODE,Exchange,Segment,GETDATE() AS UpdateDate,'UPDATED' AS DBAction,ACTIVE_DATE AS Activate_Date,InActive_From,Status                            
 from AngelNseCM.msajag.dbo.client_brok_details with (nolock)               
                          
 /* NOTE: Update all the party codes in table client_brok_details_trig from full updation */                            
 insert into tmp_IncrClient(party_Code)                            
 select party_Code from AngelNseCM.msajag.dbo.client_details WITH (NOLOCK)              
              
 select Party_Code,Exchange,Segment,max(UpdateDate) as UpdateDate,max(DBAction) as DBAction,Activate_Date,InActive_From,max(Status) as Status                            
 into #cd_trig                            
 from Client_Brok_Details_trig with (nolock)                            
 group by Party_Code,Exchange,Segment,Activate_Date,InActive_From                            
 select a.party_code into #clt from tmp_IncrClient a with (nolock) left outer join client_brok_details_trig b with (nolock) on a.party_Code=b.party_code where b.party_code is null                            
 insert into #cd_trig (Party_Code,Exchange,Segment,Activate_Date,InActive_From,Status)                            
 select cl_Code,Exchange,Segment,Active_Date,InActive_From,Status from Client_Brok_Details a with (nolock) join #clt B ON A.CL_cODE=B.PARTY_CODE                            
              
 truncate table Client_Brok_Details_trig                            
 insert into Client_Brok_Details_trig select Party_Code,Exchange,Segment,UpdateDate,DBAction,Activate_Date,InActive_From,Status from #cd_trig                            
 drop table #cd_trig                            
 /* Step-2 : Fetch required data from source --- 00:06 Secs (7810 records:Time 8:51 PM)*/                            
              
 INSERT INTO tmp_client_Details(cl_code,branch_cd,party_code,sub_broker,trader,long_name,short_name,l_address1,                            
 l_city,l_address2,l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,                            
 off_phone1,off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,                            
 p_address2,p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,                          
 passport_no,passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,                            
 licence_issued_on,licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,                            
 votersid_issued_at,votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,                            
 client_agreement_on,sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,                            
 repatriat_bank,repatriat_bank_ac_no,chk_kyc_form,chk_corporate_deed,chk_bank_certificate,                            
 chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,Bank_Name,Branch_Name,AC_Type,AC_Num,                            
 Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,DpId3,CltDpId3,Poa3,                            
 rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,Micr_No,Director_name,                            
 paylocation,FMCode,Org_SB,Org_branch,NBFC_cli)                            
 SELECT cl_code,branch_cd,a.party_code,sub_broker,trader,long_name,short_name,l_address1,l_city,l_address2,                            
 l_state,l_address3,l_nation,l_zip,pan_gir_no,ward_no,sebi_regn_no,res_phone1,res_phone2,off_phone1,                            
 off_phone2,mobile_pager,fax,email,cl_type,cl_status,family,region,area,p_address1,p_city,p_address2,                            
 substring(p_state,1,15) as p_state,p_address3,p_nation,p_zip,p_phone,addemailid,sex,dob,introducer,approver,interactmode,passport_no,                            
 passport_issued_at,passport_issued_on,passport_expires_on,licence_no,licence_issued_at,licence_issued_on,                            
 licence_expires_on,rat_card_no,rat_card_issued_at,rat_card_issued_on,votersid_no,votersid_issued_at,                            
 votersid_issued_on,it_return_yr,it_return_filed_on,regr_no,regr_at,regr_on,regr_authority,client_agreement_on,                            
 sett_mode,dealing_with_other_tm,other_ac_no,introducer_id,introducer_relation,repatriat_bank,repatriat_bank_ac_no,                            
 chk_kyc_form,chk_corporate_deed,chk_bank_certificate,chk_annual_report,chk_networth_cert,chk_corp_dtls_recd,                            
 Bank_Name,Branch_Name,AC_Type,AC_Num,Depository1,DpId1,CltDpId1,Poa1,Depository2,DpId2,CltDpId2,Poa2,Depository3,                            
 DpId3,CltDpId3,Poa3,rel_mgr,c_group,sbu,Status,Imp_Status,ModifidedBy,ModifidedOn,Bank_id,Mapin_id,UCC_Code,                            
 Micr_No,Director_name,paylocation,FMCode,sub_broker, branch_cd,'N'                            
 FROM AngelNseCM.msajag.dbo.Client_Details a WITH(NOLOCK) 
 --join tmp_IncrClient b with (nolock) on a.party_Code=b.party_code                            
                            
 DELETE FROM tmp_client_Details WHERE party_code >='0' AND party_code <='999999999999'                            
 /* STEP-3: Fetch External Data */                            
 --- NBFC Client (00:00 Secs)                            
 select cl_code,cl_type,mobile_pager,                            
 Valid = CASE WHEN LEN(ISNULL(mobile_pager,''))=10 AND LEFT(ISNULL(mobile_pager,''),1) in ('6','7','8','9') THEN 1 ELSE 0 END                            
 into #nbfc_client                            
 --from [172.31.16.59].LiveAngel_fundingsystem_new.dbo.Table_CLIENT_MASTER_FINAL WITH(NOLOCK)                          
 from ABVSCITRUS.inhouse.dbo.client_Details WITH(NOLOCK)                           
 WHERE (cl_type='NBF' or cl_type='TMF') and mobile_pager <> ''                            
 delete from #nbfc_client where valid=0                            
 Create clustered index idxclnbfc on #nbfc_client (cl_code)                            
 
 --- Call-N-Trade Deactivated Client (00:00 secs)                            
   /*                          
 SELECT Client_Id as Party_Code into #CNT_DeCli FROM mis.kyc.dbo.tbl_call_trade WITH (NOLOCK) WHERE flag='D'                            
                            
 Create Clustered index idx_cli on #CNT_DeCli (party_Code)                            
 --- Call-N-Trade Activate Entity (00:00 secs)                            
 insert into Temp_CNT_AcCli                            
 select id,entity_type,entity_code,product from mis.kyc.dbo.tbl_cnt_add_bo with (nolock)                            
 --- BSE Demat Default DPid                            
 select party_Code,bankid,cltdpid,depository into #BSECM_depDef FROM angeldemat.inhouse_bse.dbo.VW_Client4_def1 /* 00:11 Secs */                            
 Create Clustered index idx_pty on #BSECM_depDef (party_Code) /* 00:03 Secs */                            
 --- NSE Demat Default DPid                            
 select party_Code,bankid,cltdpid,depository into #NSECM_depDef FROM angeldemat.inhouse_nse.dbo.VW_Client4_def1 /* 00:11 Secs */                            
 Create Clustered index idx_pty on #NSECM_depDef (party_Code) /* 00:02 Secs */                            
 /* STEP-4: INCREMENTAL UPDATES -- 00:00 Secs*/                            
 UPDATE tmp_client_details SET sub_broker=Org_SB,branch_cd=Org_branch WHERE Org_SB = 'BH'                            
 UPDATE tmp_client_details SET Branch_cd='NVASHI' WHERE sub_Broker='ANET' AND branch_cd='VASHI'                            
 UPDATE tmp_client_details SET Branch_cd='ANK' WHERE sub_Broker='ANK' AND branch_cd='XS'                            
 UPDATE tmp_client_details SET Branch_cd='BHL' WHERE sub_Broker='MFS' AND branch_cd='HYD'                            
 /* Step-5: UPDATE NRI CLIENT & CALL-N-TRADE STATUS --00:00 Secs*/                            
                             
 SELECT cl_code,(CASE WHEN LEFT(CL_CODE,2)='ZR' AND cl_status='NRI' THEN 'NRIS' ELSE 'CALNT' END) AS status                            
 INTO #CALNT                            
 FROM NRICALLNTRADECLIENT WITH(NOLOCK)                            
 WHERE (cl_status='NRI' AND cl_code LIKE 'ZR%') OR flag='CALNT'                            
                             
 CREATE CLUSTERED INDEX IDXCL ON #CALNT (CL_CODE)                            
                             
 /* Below Line Added by Manesh Mukherjee on 21/02/2014 4:04 pm*/                            
 Delete from #CNT_DeCli where Party_Code in (select cl_code from #CALNT)                            
                             
 /* change general_new.dbo.NRMS_clientDetails_log to NRMS_clientDetails_log on 09/04/2015*/                
                             
 insert into NRMS_clientDetails_log (Batchid,BatchTaskid,Procname,StartTime,EndTime,LastStatus)                            
 select 0,0,'Cli.NRI CNT-'+convert(varchar(2),@chkctr),@adate,getdate(),'Inprocess'                            
 select @adate = getdate(), @chkctr = @chkctr+1                            
 ---Initialise Call-N-Trade deactivated Client                            
                            
 SELECT PARTY_CODE                            
 INTO #NO_CALNT                            
 FROM client_details WITH (NOLOCK)                            
 WHERE (branch_cd='NRIS' OR branch_cd='CALNT')                            
                             
 select party_code into #RB_marking from                            
 (                            
 SELECT Party_Code FROM #CNT_DeCli                            
 UNION                            
 SELECT A.PARTY_CODE FROM #NO_CALNT A LEFT OUTER JOIN #CALNT B ON A.PARTY_cODE=B.CL_CODE WHERE B.CL_CODE IS NULL                            
 ) x                            
                             
 CREATE CLUSTERED INDEX IDXCL ON #RB_marking (party_code)                            
 --- Initialise CALNT status in Client_Details (00:00 Secs)                            
              
 UPDATE CLIENT_DETAILS SET branch_cd=isnull(Org_branch,''),sub_Broker=isnull(Org_SB,'') FROM #RB_marking B WHERE CLIENT_DETAILS.PARTY_CODE=B.PARTY_CODE                            
 --- Update Call-N-Trade activated Client (00:00 Secs)                            
 --UPDATE tmp_client_details SET sub_broker=A.status,branch_cd=A.status FROM #CALNT A WHERE A.cl_code=tmp_client_details.cl_code                            
 /* Step-7: Update Subgroup 00:00 Secs */                            
 --- Add Incremental Records                            
*/              
 INSERT INTO subgroup                            
 SELECT a.sub_broker,SBName=MAX(Name)                            
 FROM BO_subBrokers a WITH(NOLOCK)                            
 LEFT JOIN subgroup b WITH(NOLOCK) ON a.sub_Broker = b.sub_Broker                            
 WHERE b.Sub_Broker IS NULL                            
 GROUP BY a.sub_Broker                            
 --- Rectify existing Sub-brokers Name                            
              
 UPDATE subgroup SET SBName = A.SBName                            
 FROM (SELECT sub_broker,SBName=MAX(Name)                            
 FROM BO_subBrokers WITH(NOLOCK) GROUP BY sub_Broker) A                            
 WHERE subgroup.sub_broker = A.sub_broker                            
 /* Step-8: Update Branch 00:00 Secs */                            
              
 INSERT INTO branch (sbtag,tradername,email,add5)                            
 SELECT branch_cd=a.branch_code,a.Long_name,a.email,a.state                            
 FROM BO_branch a WITH(NOLOCK)                            
 LEFT JOIN branch b WITH(NOLOCK) ON a.BRANCH_CODE = b.sbtag                            
WHERE b.sbtag IS NULL                            
 /* STEP-9: **** FULL UPDATION ******* 00:19 Secs */                            
              
BEGIN TRY                            
 BEGIN TRAN                            
  delete a from client_details a join tmp_client_details b with (nolock) on a.party_Code=b.party_code                            
  INSERT INTO client_details                            
  SELECT                            
  A.cl_code,A.branch_cd,A.party_code,A.sub_broker,A.trader,A.long_name,A.short_name,A.l_address1,A.l_city,                            
  A.l_address2,A.l_state,A.l_address3,A.l_nation,A.l_zip,A.pan_gir_no,A.ward_no,A.sebi_regn_no,A.res_phone1,                            
  A.res_phone2,A.off_phone1,A.off_phone2,A.mobile_pager,A.fax,A.email,A.cl_type,A.cl_status,A.family,A.region,                            
  A.area,A.p_address1,A.p_city,A.p_address2,A.p_state,A.p_address3,A.p_nation,A.p_zip,A.p_phone,A.addemailid,                            
  A.sex,A.dob,A.introducer,A.approver,A.interactmode,A.passport_no,A.passport_issued_at,A.passport_issued_on,                            
  A.passport_expires_on,A.licence_no,A.licence_issued_at,A.licence_issued_on,A.licence_expires_on,A.rat_card_no,                            
  A.rat_card_issued_at,A.rat_card_issued_on,A.votersid_no,A.votersid_issued_at,A.votersid_issued_on,A.it_return_yr,                            
  A.it_return_filed_on,A.regr_no,A.regr_at,A.regr_on,A.regr_authority,A.client_agreement_on,A.sett_mode,                            
  A.dealing_with_other_tm,A.other_ac_no,A.introducer_id,A.introducer_relation,A.repatriat_bank,A.repatriat_bank_ac_no,                            
  A.chk_kyc_form,A.chk_corporate_deed,A.chk_bank_certificate,A.chk_annual_report,A.chk_networth_cert,A.chk_corp_dtls_recd,                            
  A.Bank_Name,A.Branch_Name,A.AC_Type,A.AC_Num,A.Depository1,A.DpId1,A.CltDpId1,A.Poa1,A.Depository2,A.DpId2,A.CltDpId2,                            
  A.Poa2,A.Depository3,A.DpId3,A.CltDpId3,A.Poa3,A.rel_mgr,A.c_group,A.sbu,A.Status,A.Imp_Status,A.ModifidedBy,                            
  A.ModifidedOn,A.Bank_id,A.Mapin_id,A.UCC_Code,A.Micr_No,A.Director_name,A.paylocation,A.FMCode,A.BSECM_LAST_DATE,                            
  A.NSECM_LAST_DATE,A.BSEFO_LAST_DATE,A.NSEFO_LAST_DATE,A.NCDEX_LAST_DATE,A.MCX_LAST_DATE,A.NSX_LAST_DATE,A.MCD_LAST_DATE,                            
  A.comb_LAST_DATE,A.bsecm,A.nsecm,A.nsefo,A.mcdx,A.ncdx,A.bsefo,A.mcd,A.nsx,A.Last_inactive_date,A.First_Active_date,                            
  A.NBFC_cli,A.Org_SB,A.Org_branch,A.BSX,A.BSX_LAST_DATE,NULL,NULL                                  
  FROM tmp_client_details a WITH (NOLOCK)                            
  COMMIT TRAN                            
  END TRY                            
  BEGIN CATCH                            
  ROLLBACK TRAN                            
  END CATCH                            
                              
  UPDATE client_details SET nbfc_cli = 'Y' WHERE cl_type IN ('NBF','TMF')                            
                              
  ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                            
  /*---- Update Call-N-Trade Tag in Client Master ----*/                            
  /*                            
  UPDATE client_details                            
  SET sub_broker=A.status,branch_cd=A.status                            
  FROM #CALNT A                            
  WHERE A.cl_code=client_details.cl_code                            
                              
  UPDATE b                            
  SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.party_Code=A.entity_code                            
  AND entity_type='party_Code' AND product='CALNT' and isnull(entity_Code,'') <> ''                            
                              
  UPDATE b                            
  SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b INNER JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.sub_Broker=A.entity_code                            
  AND entity_type='ori_sub_broker' AND product='CALNT' and isnull(entity_Code,'') <> '' LEFT JOIN #CNT_DeCli c WITH(NOLOCK) ON b.party_code = c.party_code                            
  WHERE c.party_Code IS NULL and left(a.entity_Code,2) <> 'CB'                            
                              
  UPDATE b                            
  SET b.branch_cd=A.product,b.sub_Broker=A.product FROM client_details b INNER JOIN Temp_CNT_AcCli a WITH (NOLOCK) ON b.branch_cd=A.entity_code                            
  AND entity_type='ori_branch_cd' AND product='CALNT' and isnull(entity_Code,'') <> '' LEFT JOIN #CNT_DeCli c WITH(NOLOCK) ON b.party_code = c.party_code                            
  WHERE c.party_code IS NULL                            
 */                           
  /*---CODE ADDED ON 28 AUG 2014 TO INSERT SEGMENTWISE CLIENTS WITH SERIES---MOVED FROM UPD_SSIS_LEDGER*/ 
  
 IF  EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_tmp_pcode')
  DROP INDEX idx_tmp_pcode ON [dbo].[tbl_inc_fullTemp_ClientCode_Series]

 CREATE NONCLUSTERED INDEX [idx_tmp_pcode] ON [dbo].[tbl_inc_fullTemp_ClientCode_Series]
 (
		[pcode] ASC
 )

 SELECT a.party_Code into #sereies                            
 FROM tmp_IncrClient a                             
 INNER JOIN client_details b WITH(NOLOCK) ON a.party_Code = b.party_code                             
 --WHERE DBAction IN ('INSERTED','DELETED')                            
 GROUP BY a.party_Code                            
 HAVING COUNT(*) = 1
 
 truncate table [tbl_inc_fullTemp_ClientCode_Series]
 insert into [tbl_inc_fullTemp_ClientCode_Series](SEGMENT,PCODE,seriesDesc)
 SELECT SEGMENT,PCODE=Y.seriescode+LTRIM(RTRIM(party_Code)),seriesDesc                                     
 FROM #sereies X                            
 CROSS JOIN LedgerSeries Y WITH(NOLOCK)                            
 WHERE Segment IN('BSECM','MCD','MCX','NCDEX','NSECM','NSEFO','NSX','BSX')                            
 AND active=1                            
 AND EntityType='Client'  
                             
/*

	WHILE (1=1)
		BEGIN
			SET ROWCOUNT 3000000
			delete a from Temp_ClientCode_Series  a join #inc_fullTemp_ClientCode_Series b on a.pcode=b.pcode 
			IF (@@ROWCOUNT = 0)
				BREAK
			SET ROWCOUNT 0

			--WAITFOR DELAY '00:00:00.200'
		END

	SET ROWCOUNT 0  

	/*
	End of new code
	*/
*/

  /* added on 03-09-2016  for opt*/
    
  --DROP INDEX [IX_Code] ON [dbo].[Temp_ClientCode_Series]  ----------
  
  --IF  EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Code_TCCS')
  --DROP INDEX [idx_Code_TCCS] ON [dbo].[Temp_ClientCode_Series]
  
  select segment,pcode,seriesDesc into #Temp_ClientCode_Series_ins 
  from [tbl_inc_fullTemp_ClientCode_Series] T1 with (nolock)
  where not exists (select pcode from Temp_ClientCode_Series T2 with (nolock) where T1.pcode=T2.PCODE and T1.segment=T2.segment and T1.seriesDesc=T2.seriesDesc)--6:58
  
  INSERT INTO Temp_ClientCode_Series (segment,pcode,seriesDesc)                            
  select * from #Temp_ClientCode_Series_ins  
  
  /*
  select a.party_Code,a.sub_BRoker,a.branch_cd,a.org_SB,a.Org_branch into #Temp_cnt from                            
  (select party_Code,sub_BRoker,branch_cd,org_SB,Org_branch from client_Details with (nolock) where sub_BRoker<>org_SB) a join                            
  (select * from Temp_CNT_AcCli where entity_type='ori_sub_broker' AND product='CALNT' and left(entity_Code,2)='CB') b                            
  on a.org_sb=b.entity_Code                            
                              
  update client_details set branch_cd=client_details.Org_branch,Sub_Broker=client_details.org_sb from #temp_cnt b where client_details.party_Code=b.party_Code                            
               
  /* STEP-10: ---- UPDATE DEPOSITORY INFORMATION ---*/                            
  UPDATE client_details                            
  SET Depository1=b.Depository,DPid1=b.Bankid,Cltdpid1=b.Cltdpid                            
  FROM #BSECM_depDef b /* 00:04 secs (Total 11+03+04=17 Secs :: direct fetching 00:26 secs */                            
  WHERE client_details.party_Code=b.party_Code and ISNULL(client_details.cltdpid1,'') = ''                            
               
  UPDATE client_details                            
  SET Depository1=b.Depository,DPid1=b.Bankid,Cltdpid1=b.Cltdpid                            
  FROM #NSECM_depDef b /* 00:01 secs (Total 11+03+01=15 Secs :: direct fetching 00:17 secs */          
  WHERE client_details.party_Code=b.party_Code and ISNULL(client_details.cltdpid1,'') = ''                            
  /* STEP-11:------ UPDATE NBFC CLIENT Telephone No(s) */                            
               
  UPDATE a                            
  SET fax = b.mobile_pager                            
  FROM client_details a WITH(NOLOCK)                            
  JOIN                            
  #nbfc_client b WITH(NOLOCK)                            
  ON a.party_Code=b.cl_code                            
  /* Step-13: ---- MODIFIED Date udpate ---- 00:02 Secs */   
  */
               
  UPDATE client_details SET modifidedon = b.editedOn                            
  FROM                            
  ( SELECT cltcode,editedOn=MAX(editedOn) FROM AngelNseCM.msajag.dbo.multibankid_log WITH(NOLOCK) GROUP BY cltcode ) b                            
  WHERE client_details.party_Code=b.cltcode                            
              
 BEGIN TRY                            
  BEGIN TRAN                            
  COMMIT TRAN                            
 END TRY                            
 BEGIN CATCH                            
  ROLLBACK TRAN                            
 END CATCH                   
                       
 exec NRMS_Upd_Finmast /* 02 secs */                            
 exec NRMS_Client_Vertical_FULL   /* 40 Secs */           
 exec NRMS_CliVertical_missing_Email                           
 exec NRMS_Vandha_POA /* 05 Secs */                            
 /* exec [Upd_ClientBrokDetails_Incr] /* 01 Secs */*/ 
 exec Upd_ClientBrokDetails_FULL /* 01 Secs */                            
 exec Upd_Client_Activation_date /* 01 SEcs */                            
/*added by abha on jul 14 2015 to check job status*/        
    declare @Status varchar(20)        
 set @Status=''        
 exec NRMS_JoBStatus 'NBFC_Client_Activation_Date',@Status  output         
 if(@Status='In Progress')        
 begin        
 print 'job is already running'         
 end        
 else        
 begin        
 EXEC msdb.dbo.sp_start_job 'NBFC_Client_Activation_Date'        
 end                         
            
/*added by abha on jul 14 2015 to check job status*/        
           
 set @Status=''        
 exec NRMS_JoBStatus 'SB CMS MASTER INSERT',@Status  output          
 if(@Status='In Progress')        
 begin        
 print 'job is already running'        
 end        
 else        
 begin        
 EXEC [MIS].msdb.dbo.sp_start_job 'SB CMS MASTER INSERT'         
 end      
               
 UPDATE MasterUpdDate SET lastupdated_on=GETDATE() WHERE particular='CLIENT_MASTER'                      
 exec NRMS_upd_client_details_FULL_Notification 1 
 
 --commented on Sep 30 2016 as suggested by sir         
  /*   
 delete from anand1.msajag.dbo.client_brok_details_trig    
 delete from anand1.msajag.dbo.client_details_trig   
 */
 /*Commented on Sep 24 2016 as discussed with Renil Sir*/ 
 /*     
 IF  not EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Code_TCCS')
Create NonClustered Index idx_Code_TCCS on Temp_ClientCode_Series (segment, pcode)
*/
 
  
  /*------start INDEX [IX_Code]      03-09-2016 */
  /*
  CREATE CLUSTERED INDEX [IX_Code] ON [dbo].[Temp_ClientCode_Series] 
  (
	[segment] ASC,
	[pcode] ASC
 )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = ON, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [SECONDARY]
      /*-------end INDEX [IX_Code] */                    
  /*--------END----------*/      
    */
          
END try                            
begin catch                            
 INSERT INTO EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)        
 SELECT GETDATE(),'upd_client_details_FULL',ERROR_LINE(),ERROR_MESSAGE()                     
 ALTER TABLE Client_details DISABLE TRIGGER [TRG_CLIENT_DETAILS]                            
 DECLARE @ErrorMessage NVARCHAR(4000);                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                            
 RAISERROR (@ErrorMessage , 16, 1);           
           
 exec NRMS_upd_client_details_FULL_Notification 0,@ErrorMessage          
                            
END catch;                            
              
              
SET nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Upd_ClientBrokDetails_FULL_bkup_03122023
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[Upd_ClientBrokDetails_FULL_bkup_03122023]
AS
SET NOCOUNT ON
BEGIN TRY

DECLARE @str AS VARCHAR(1500),@BoSvr AS VARCHAR(25),@BOAcDb AS VARCHAR(25),@BOshDb AS VARCHAR(25),
@co_code AS VARCHAR(25), @done BIT
SET @done = 1

SELECT @BoSvr=BO_Server,@BOAcDb=bo_Account_DB,@BOshDb=BO_share_Db
FROM company WITH(NOLOCK)
WHERE offlinekyc=1 AND ISNULL(exchange,'') <> ''

SET @str=' '

/*select top 0 * into #client_brok_details from client_brok_details*/
IF OBJECT_ID(N'client_brok_details_TEMP') IS NOT NULL
BEGIN
DROP TABLE client_brok_details_TEMP
END

select top 0 * into client_brok_details_TEMP from client_brok_details

set @str = ' INSERT INTO client_brok_details_TEMP
SELECT Cl_Code,Exchange,Segment,Brok_Scheme,Trd_Brok,Del_Brok,Ser_Tax,Ser_Tax_Method,Credit_Limit,InActive_From,Print_Options,No_Of_Copies,
Participant_Code,Custodian_Code,Inst_Contract,Round_Style,STP_Provider,STP_Rp_Style,Market_Type,Multiplier,Charged,Maintenance,Reqd_By_Exch,
Reqd_By_Broker,Client_Rating,Debit_Balance,Inter_Sett,TRD_STT,Trd_Tran_Chrgs,Trd_Sebi_Fees,Trd_Stamp_Duty,Trd_Other_Chrgs,Trd_Eff_Dt,
Del_Stt,Del_Tran_Chrgs,Del_SEBI_Fees,Del_Stamp_Duty,Del_Other_Chrgs,Del_Eff_Dt,Rounding_Method,Round_To_Digit,Round_To_Paise,
Fut_Brok,Fut_Opt_Brok,Fut_Fut_Fin_Brok,Fut_Opt_Exc,Fut_Brok_Applicable,Fut_Stt,Fut_Tran_Chrgs,Fut_Sebi_Fees,Fut_Stamp_Duty,
Fut_Other_Chrgs,Status,Modifiedon,Modifiedby,Imp_Status,Pay_B3B_Payment,Pay_Bank_name,Pay_Branch_name,Pay_AC_No,Pay_payment_Mode,
Brok_Eff_Date,Inst_Trd_Brok,Inst_Del_Brok,SYSTEMDATE,Active_Date,CheckActiveClient
FROM '+@BoSvr+'.'+@BOshDb+'.dbo.client_brok_details WITH (NOLOCK) where isnull(Deactive_value,'''')<>''P'' '
/*PRINT @str*/
EXEC(@str)



DECLARE @RowCnt BIGINT
SET @RowCnt = @@ROWCOUNT

IF @RowCnt < (SELECT COUNT(DISTINCT Cl_Code) FROM client_brok_details WITH(NOLOCK))
BEGIN
RAISERROR('Incomplete Client Brok Details fetched..Please check SP: Upd_ClientBrokDetails' , 16, 1);
END
ELSE
BEGIN
BEGIN TRAN

SET @done = 0

TRUNCATE TABLE client_brok_details

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[client_brok_Details]') AND name = N'IX_cl_Code')
DROP INDEX [IX_cl_Code] ON [dbo].[client_brok_Details] WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[client_brok_Details]') AND name = N'IX_Segment')
DROP INDEX [IX_Segment] ON [dbo].[client_brok_Details] WITH ( ONLINE = OFF )

INSERT INTO client_brok_details
SELECT * 
FROM client_brok_details_TEMP
ORDER BY Cl_Code

CREATE NONCLUSTERED INDEX [IX_cl_Code] ON [dbo].[client_brok_Details] 
([Cl_Code] ASC,[InActive_From] ASC,[Active_Date] ASC)

CREATE NONCLUSTERED INDEX [IX_Segment] ON [dbo].[client_brok_Details] 
([Segment] ASC,[Exchange] ASC,[Cl_Code] ASC)

SET @done = 1

COMMIT TRAN
END

IF OBJECT_ID(N'client_brok_details_TEMP') IS NOT NULL
BEGIN
DROP TABLE client_brok_details_TEMP
END

END TRY

BEGIN CATCH

----IF @done = 0
----ROLLBACK TRAN

INSERT INTO EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)
SELECT GETDATE(),'Upd_ClientBrokDetails',ERROR_LINE(),ERROR_MESSAGE()

DECLARE @ErrorMessage NVARCHAR(4000);
SELECT @ErrorMessage = ERROR_MESSAGE() + CONVERT(VARCHAR(10),ERROR_LINE());
RAISERROR (@ErrorMessage , 16, 1);

END CATCH;
RETURN
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.upd_ins_rms_collection_cli_Parallel2_bkup_27082023
-- --------------------------------------------------

      
    
CREATE Proc [dbo].[upd_ins_rms_collection_cli_Parallel2_bkup_27082023]    
AS    
SET NOCOUNT ON       
SET XACT_ABORT ON      
begin try


  insert into tbl_sbcredit_tracking select 'step 1',getdate()
  declare  @ID BIGINT  
  INSERT INTO SB_CREDIT_LOG (PROC_NAME, PROC_START_TIME) VALUES ('Update_OtherDebit', GETDATE())              
  SET @ID = @@IDENTITY              
  EXEC Update_OtherDebit 
       
  UPDATE SB_CREDIT_LOG SET PROC_END_TIME = GETDATE() WHERE RUNID = @ID      
 
 insert into tbl_sbcredit_tracking select 'step 2',getdate()
    
 truncate table tbl_rms_collection_cli      
     
 IF  EXISTS(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_RMS_Collection_Cli]') AND name = N'IX_CLparty_Code')      
 DROP INDEX [IX_CLparty_Code] ON [dbo].[tbl_RMS_Collection_Cli] WITH (ONLINE=OFF) 
 
 
 IF  EXISTS(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_RMS_Collection_Cli]') AND name = N'IX_nc_clinfo')      
 DROP INDEX [IX_nc_clinfo] ON [dbo].[tbl_RMS_Collection_Cli] WITH (ONLINE=OFF)      

 insert into tbl_sbcredit_tracking select 'step 3',getdate()       
 -- insert is taking   2.09    
 insert into tbl_rms_collection_cli (Party_Code, Cash, Derivatives, Currency, Commodities,      
 ABL_Net,ACBL_Net,NBFC_Net,Deposit,Net_Debit,      
 MOS,Pure_Risk,Proj_Risk,UB_Loss,UnReco_Credit,Hold_Total, Hold_TotalHC, Margin_Total,      
 /*Margin_Shortage ,*/ SB_CrAdjWithPureRisk, SB_CrAdjwithProjRisk, SB_Cr_Adjusted,      
 Net_Available, DP)      
       
 select party_code, Cash, Derivatives, Currency, Commodities, (Cash+Derivatives+Currency),Commodities,NBFC,Deposit,Net,      
 mos,(case when PureRisk < 0 then PureRisk else 0 end),      
 (case when ProjRisk < 0 then ProjRisk else 0 end),UnbookedLoss, Un_Reco, Holding, [App.Holding], imargin,      
 /*(case when imargin > 0 then Margin_Shortage else 0 end), */ isnull(PureAdj, 0), isnull(ProjAdj,0),isnull(PureAdj, 0)+isnull(ProjAdj,0),      
 Total_Colleteral, DP      
 from dbo.tbl_rms_collection with (nolock)      
 
 insert into tbl_sbcredit_tracking select 'step 4',getdate()        
 /*TO UPDATE COLLATERAL WITHOUT HAIRCUT 33Secs*/      
 UPDATE A      
 SET Net_Available = B.Coll_Total      
 FROM tbl_rms_collection_cli A      
 INNER JOIN       
 (      
 SELECT Party_Code, SUM(CASE WHEN CASH_NCASH = 'N' THEN AMOUNT ELSE FINALAMOUNT END) Coll_Total      
 FROM dbo.CLIENT_COLLATERALS      
 GROUP BY Party_Code      
 ) B      
 ON A.Party_Code = B.Party_Code      
 
 insert into tbl_sbcredit_tracking select 'step 5',getdate() 
 
 IF NOT EXISTS(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_RMS_Collection_Cli]') AND name = N'IX_CLparty_Code')      
 CREATE CLUSTERED INDEX [IX_CLparty_Code] ON [dbo].[tbl_RMS_Collection_Cli]       
 ([Party_Code] ASC)

 Select * into #rms from dbo.rms_dtclfi with (nolock)

 delete t from #rms t with (nolock) where
 Ledger =0 and 	Deposit	 =0 and IMargin=0 and	Cash_Colleteral	=0 and NonCash_Colleteral=0 and
 Holding_total	=0 and Holding_Approved =0 and	Holding_NonApproved	=0 and Other_Credit =0 and
 Other_Deposit	=0 and MTM_Loss_Act	=0 and MTM_Loss_Proj =0 and
 MTM_Profit_Act	=0 and NoDel_Loss =0 and	NoDel_Profit =0 and	Unrecosiled_Credit =0 and
 MTM_Profit_Proj=0 and	IMargin_Shortage_value =0 and
 IMargin_Shortage_Percent=0 and	LastBillDate=0 and	LastDrCrDays=0 and	Exposure=0 and	HoldingWithHC=0

 Create index #r on #rms(party_code,co_code)

;with coll_data as(
 select
 Party_code,
 BSE_Ledger=sum(case when co_Code='BSECM' then Ledger else 0 end),
 NSE_Ledger=sum(case when co_Code='NSECM' then Ledger else 0 end),
 NSEFO_Ledger=sum(case when co_Code='NSEFO' then Ledger else 0 end),
 MCD_Ledger=sum(case when co_Code='MCD' then Ledger else 0 end),
 NSX_Ledger=sum(case when co_Code='NSX' then Ledger else 0 end),
 BSX_Ledger=sum(case when co_Code='BSX' then Ledger else 0 end),
 MCX_Ledger=sum(case when co_Code='MCX' then Ledger else 0 end),
 NCDEX_Ledger=sum(case when co_Code='NCDEX' then Ledger else 0 end),
 NBFC_Ledger=sum(case when co_Code='NBFC' then Ledger else 0 end),
 Net_Ledger=sum(Ledger),
 Exp_NSEFO=sum(case when co_Code='NSEFO' then exposure else 0 end),
 Exp_MCD=sum(case when co_Code='MCD' then exposure else 0 end),
 Exp_NSX=sum(case when co_Code='NSX' then exposure else 0 end),
 Exp_BSX=sum(case when co_Code='BSX' then exposure else 0 end),
 Exp_MCX=sum(case when co_Code='MCX' then exposure else 0 end),
 Exp_NCDEX=sum(case when co_Code='NCDEX' then exposure else 0 end),
 Margin_NSEFO=sum(case when co_Code='NSEFO' then iMargin else 0 end),
 Margin_MCD=sum(case when co_Code='MCD' then iMargin else 0 end),
 Margin_NSX=sum(case when co_Code='NSX' then iMargin else 0 end),
 Margin_BSX=sum(case when co_Code='BSX' then iMargin else 0 end),
 Margin_MCX=sum(case when co_Code='MCX' then iMargin else 0 end),
 Margin_NCDEX=sum(case when co_Code='NCDEX' then iMargin else 0 end),
 Coll_NSEFO=sum(case when co_Code='NSEFO' then (NonCash_Colleteral + Cash_Colleteral) else 0 end),
 Coll_MCD=sum(case when co_Code='MCD' then (NonCash_Colleteral + Cash_Colleteral) else 0 end),
 Coll_NSX=sum(case when co_Code='NSX' then (NonCash_Colleteral + Cash_Colleteral) else 0 end),
 Coll_BSX=sum(case when co_Code='BSX' then (NonCash_Colleteral + Cash_Colleteral) else 0 end),
 Coll_MCX=sum(case when co_Code='MCX' then (NonCash_Colleteral + Cash_Colleteral) else 0 end),
 Coll_NCDEX=sum(case when co_Code='NCDEX' then (NonCash_Colleteral + Cash_Colleteral) else 0 end),
 Coll_TotalHC = sum(NonCash_Colleteral + Cash_Colleteral),
 Last_Bill_Date = max(LastBillDate),
 CashColl_Total = sum(Cash_Colleteral),
 Coll_Total = sum(Cash_Colleteral),
 Margin_Shortage = sum(imargin_shortage_value*-1),
 MTF_Ledger=sum(case when co_Code='MTF' then Ledger else 0 end) ,-- into #aa
 MFSS_Ledger=sum(case when co_Code='MFSS_BSE' then Ledger else 0 end)
 from #rms with (nolock)
 group by Party_code
 )
 Select * into #coll_fin from coll_data
 
 insert into tbl_sbcredit_tracking select 'step 6',getdate() 
 /*to optimize query*/
 Create index #pc on #coll_fin(party_code)

 --insert into tbl_sbcredit_tracking select 'step 7',getdate()    
 -- 2.54 min      
 update B set      
 BSE_Ledger=A.BSE_Ledger, NSE_Ledger=A.NSE_Ledger, NSEFO_Ledger=A.NSEFO_Ledger, MCD_Ledger=A.MCD_Ledger, NSX_Ledger=A.NSX_Ledger,BSX_Ledger=A.BSX_Ledger,      
 MCX_Ledger=A.MCX_Ledger, NCDEX_Ledger=A.NCDEX_Ledger, NBFC_Ledger=A.NBFC_Ledger, Net_Ledger=A.Net_Ledger,      
       
 Exp_NSEFO=A.Exp_NSEFO, Exp_MCD=A.Exp_MCD, Exp_NSX=A.Exp_NSX,Exp_BSX=A.Exp_BSX, Exp_MCX=A.Exp_MCX, Exp_NCDEX=A.Exp_NCDEX,      
       
 Margin_NSEFO=A.Margin_NSEFO, Margin_MCD=A.Margin_MCD, Margin_NSX=A.Margin_NSX, Margin_BSX=A.Margin_BSX, Margin_MCX=A.Margin_MCX,      
 Margin_NCDEX=A.Margin_NCDEX,      
       
 Coll_NSEFO = A.Coll_NSEFO, Coll_MCD = A.Coll_MCD, Coll_NSX = A.Coll_NSX,Coll_BSX = A.Coll_BSX, Coll_MCX = A.Coll_MCX,      
 Coll_NCDEX = A.Coll_NCDEX, Coll_TotalHC = A.Coll_TotalHC,      
       
 Last_Bill_Date = A.Last_Bill_Date, CashColl_Total = A.CashColl_Total,      
 Margin_Shortage = A.Margin_Shortage, Coll_Total = A.Coll_Total,      
 MTF_Ledger=A.MTF_Ledger ,
 MFSS_Ledger=A.MFSS_Ledger     
 from tbl_rms_collection_cli B WITH(NOLOCK)      
 INNER JOIN      
 (      
 select Party_code,BSE_Ledger,NSE_Ledger ,NSEFO_Ledger,MCD_Ledger,NSX_Ledger,BSX_Ledger,MCX_Ledger,NCDEX_Ledger,NBFC_Ledger,Net_Ledger,Exp_NSEFO,Exp_MCD,Exp_NSX,Exp_BSX,Exp_MCX,Exp_NCDEX,
 Margin_NSEFO,Margin_MCD,Margin_NSX,Margin_BSX,Margin_MCX ,Margin_NCDEX,Coll_NSEFO ,Coll_MCD,Coll_NSX,Coll_BSX,Coll_MCX,Coll_NCDEX,Coll_TotalHC,
 Last_Bill_Date,CashColl_Total,Coll_Total,Margin_Shortage,MTF_Ledger,MFSS_Ledger from #coll_fin
 
 ) A      
 ON B.Party_Code = A.Party_code      
    
 
 insert into tbl_sbcredit_tracking select 'step 8',getdate() 
    
 -- .45 sec      
 update tbl_rms_collection_cli set      
 Hold_BlueChip=A.Hold_BlueChip, Hold_Good=A.Hold_Good, Hold_Poor=A.Hold_Poor, Hold_Junk=A.Hold_Junk      
 FROM (      
 SELECT party_code,      
 Hold_BlueChip = SUM(CASE WHEN VRH.nse_approved='BlueChip' THEN Total ELSE 0 END),      
 Hold_Good=SUM(CASE WHEN VRH.nse_approved='Good' THEN Total ELSE 0 END),      
 Hold_Poor=SUM(CASE WHEN VRH.nse_approved='Average' THEN Total ELSE 0 END),      
 Hold_Junk=SUM(CASE WHEN VRH.nse_approved='Poor' THEN Total ELSE 0 END)      
 from  dbo.Rms_holding VRH WITH(NOLOCK)      
 INNER JOIN COMPANY (NOLOCK) Q ON VRH.EXCHANGE=Q.CO_CODE        
 GROUP BY party_code) A      
 where tbl_rms_collection_cli.Party_Code=A.Party_code      
 
 insert into tbl_sbcredit_tracking select 'step 9',getdate() 
       
 /*Updating Non cash collateral without Haircut .02 Sec*/      
 update tbl_rms_collection_cli      
 set Coll_Total = Coll_Total + a.amt      
 from      
 (      
 select Party_Code,SUM(Amount) as amt      
 from dbo.Client_Collaterals with (nolock)      
 where Cash_Ncash = 'N' and Segment = 'Futures' and Coll_Type = 'SEC' and Cash_Ncash = 'N'      
 group by party_code      
 ) a      
 where tbl_rms_collection_cli.Party_Code = a.Party_Code      
 
 insert into tbl_sbcredit_tracking select 'step 10',getdate()   
 
  /* commented on Nov 27 2017  for optimization
 update tbl_rms_collection_cli set      
 Net_Available = Net_Available + Net_Ledger+deposit+Hold_Total+UB_Loss+isnull(OT.other_debit,0.00),      
 --Coll_Total = Coll_NSEFO + Coll_MCD + Coll_NSX + Coll_MCX + Coll_NCDEX,      
 Exp_cash = Hold_Total + Coll_NSEFO + Coll_MCD + Coll_NSX+ Coll_BSX + Coll_MCX + Coll_NCDEX,      
 Exp_Gross = (Hold_Total + Coll_Total) +      
 Exp_NSEFO + Exp_MCD + Exp_NSX + Exp_BSX + Exp_MCX + Exp_NCDEX,      
 Margin_Violation = convert(decimal(20,0),      
 (CASE      
 WHEN Margin_Total > 0 then      
 (case when ((abs(Margin_Shortage)/abs(Margin_Total)) * 100) > 100 then 100      
 ELSE ((abs(Margin_Shortage)/abs(Margin_Total)) * 100) END)      
 ELSE 0      
 END)),      
 Proj_Risk = case when (Proj_Risk*-1) > 0 then      
 (case when (Proj_Risk - Pure_Risk) <0 then Proj_Risk - Pure_Risk else 0 end )      
 else Proj_Risk end  FROM tbl_rms_collection_cli A   
 left outer join (select client,other_debit from  TBL_OTHER_DEBIT with (nolock)) OT  on A.party_code=OT.client  
*/

 update tbl_rms_collection_cli set      
 Net_Available = Net_Available + Net_Ledger+deposit+Hold_Total+UB_Loss,--+isnull(OT.other_debit,0.00),      
 --Coll_Total = Coll_NSEFO + Coll_MCD + Coll_NSX + Coll_MCX + Coll_NCDEX,      
 Exp_cash = Hold_Total + Coll_NSEFO + Coll_MCD + Coll_NSX+ Coll_BSX + Coll_MCX + Coll_NCDEX,      
 Exp_Gross = (Hold_Total + Coll_Total) +      
 Exp_NSEFO + Exp_MCD + Exp_NSX + Exp_BSX + Exp_MCX + Exp_NCDEX,      
 Margin_Violation = convert(decimal(20,0),      
 (CASE      
 WHEN Margin_Total > 0 then      
 (case when ((abs(Margin_Shortage)/abs(Margin_Total)) * 100) > 100 then 100      
 ELSE ((abs(Margin_Shortage)/abs(Margin_Total)) * 100) END)      
 ELSE 0      
 END)),      
 Proj_Risk = case when (Proj_Risk*-1) > 0 then      
 (case when (Proj_Risk - Pure_Risk) <0 then Proj_Risk - Pure_Risk else 0 end )      
 else Proj_Risk end  FROM tbl_rms_collection_cli A   
 
 /*Added on Nov 27 2017  to optimize query*/
 update tbl_rms_collection_cli set      
 Net_Available = Net_Available+isnull(OT.other_debit,0.00) 
 from tbl_rms_collection_cli a
 inner join  (select client,other_debit from TBL_OTHER_DEBIT  with (nolock))OT   on A.party_code=OT.client 
 
 insert into tbl_sbcredit_tracking select 'step 11',getdate() 

 truncate table tbl_rms_collection_cli_NXT
 insert into tbl_rms_collection_cli_NXT
 select party_code,net_ledger,upd_date=getdate(),0.00 from tbl_rms_collection_cli

 update tbl_rms_collection_cli_NXT set ledgerbal=bal from (select client,bal=sum(net) from [Vw_CollectionDetails_CLIENT] group by client)A
 where tbl_rms_collection_cli_NXT.party_code=A.client

 /*added by abha on Feb 04 2021 to run nxt job */      
          
  declare @Status varchar(20)         
  set @Status=''   
           
  exec NRMS_JoBStatus 'NXT_JOB_Collection',@Status  output     
  if(@Status='In Progress')          
  begin          
   print 'job is already running'      
  end          
  else          
  begin         
    EXEC [CSOKYC-6].msdb.dbo.sp_start_job 'NXT_JOB_Collection'       
  end    

 IF NOT EXISTS(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tbl_RMS_Collection_Cli]') AND name = N'IX_nc_clinfo')      
 CREATE NONCLUSTERED INDEX [IX_nc_clinfo] ON [dbo].[tbl_RMS_Collection_Cli] 
([Party_Code] ASC,
 [Net_Ledger] ASC,
 [Coll_NSEFO] ASC,
 [Last_Bill_Date] ASC
)

 insert into tbl_sbcredit_tracking select 'step 12',getdate()   
 end try                
 begin catch                
  insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)                
  select GETDATE(),'upd_ins_rms_collection_cli_Parallel2',ERROR_LINE(),ERROR_MESSAGE()                
                
  DECLARE @ErrorMessage NVARCHAR(4000);                
  SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                
  RAISERROR (@ErrorMessage , 16, 1);                
 end catch;                
 SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NBFC_PROJ_RISK_04012024
-- --------------------------------------------------


   
/*******************************************************************************************    
CREATED BY :: SUSHANT SAWANT    
CREATED DATE :: 22 JUNE 2012    
PURPOSE :: TO USED IN NBFC PROJ RISK AS PER PRMS ID    
*******************************************************************************************/    
    
CREATE PROC [dbo].[UPD_NBFC_PROJ_RISK_04012024]    
AS    
    
Set nocount on                          
SET XACT_ABORT ON                             
BEGIN TRY    
    
/*    
    
DROP TABLE #NBFC_DUMP    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'KOLK10328'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'AA37'    
SELECT * FROM NBFC_PROJ_RISK WHERE PARTYCODE = 'AA37'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'AA37'    
    
    
/*    
SELECT CLI.REGION, CLI.BRANCH, CLI.SB, NB.PARTYCODE, RMS.LEDGER LOGICAL_LEDGER,    
SUM(NB.[TOTAL HOLD]) [TOTAL HOLD], SUM(NB.[Margin With Total]) [HOLD WITH HC FOR MARGIN SHORTAGE],    
RMS.NET_COLLECTION, SUM(NB.[Hold with HC]) [Hold with HC FOR PROJ RISK],    
RM_COLL.PROJ_RISK    
INTO #NBFC_DUMP    
FROM NBFC_PROJ_RISK NB WITH (NOLOCK)    
INNER JOIN Vw_RMS_Client_Vertical CLI WITH (NOLOCK) ON NB.PARTYCODE = CLI.CLIENT    
LEFT OUTER JOIN (    
SELECT PARTY_CODE, LEDGER,    
(ISNULL(ledger,0) + ISNULL(IMargin_Shortage_value,0) - ISNULL(Unrecosiled_Credit,0)) NET_COLLECTION    
FROM RMS_DtclFi WITH (NOLOCK)    
WHERE CO_CODE = 'NBFC'    
) RMS ON RMS.PARTY_CODE = NB.PARTYCODE    
LEFT OUTER JOIN TBL_RMS_COLLECTION_CLI RM_COLL WITH (NOLOCK) ON RM_COLL.PARTY_CODE = NB.PARTYCODE    
*/    
---- drop table #NBFC_DUMP    
    
SELECT CLI.REGION, CLI.BRANCH, CLI.SB, NB.PARTYCODE, RMS.LEDGER LOGICAL_LEDGER,    
SUM(NB.[TOTAL HOLD]) [TOTAL HOLD], SUM(NB.[Margin With Total]) [HOLD WITH HC FOR MARGIN SHORTAGE],    
RMS.NET_COLLECTION, SUM(NB.[Hold with HC]) [Hold with HC FOR PROJ RISK],    
RM_COLL.PROJ_RISK    
INTO #NBFC_DUMP    
FROM NBFC_PROJ_RISK NB WITH (NOLOCK)    
INNER JOIN Vw_RMS_Client_Vertical CLI WITH (NOLOCK) ON NB.PARTYCODE = CLI.CLIENT    
LEFT OUTER JOIN (    
SELECT PARTY_CODE, LEDGER,    
(ISNULL(ledger,0) + ISNULL(IMargin_Shortage_value,0) - ISNULL(Unrecosiled_Credit,0)) NET_COLLECTION    
FROM RMS_DtclFi WITH (NOLOCK)    
WHERE CO_CODE = 'NBFC'    
) RMS ON RMS.PARTY_CODE = NB.PARTYCODE    
LEFT OUTER JOIN (SELECT PARTYCODE, (CASE WHEN (LOGICALLEDGER + [HOLD WITH HC]) < 0    
THEN (LOGICALLEDGER + [HOLD WITH HC])    
ELSE    
0    
END)    
PROJ_RISK    
FROM CLI_NBFC_RISK RM_COLL WITH (NOLOCK)) RM_COLL ON RM_COLL.PARTYCODE = NB.PARTYCODE    
    
WHERE NB.PARTYCODE IN ('A30969',    
'A35303',    
'C2250',    
'S10468',    
'J29489',    
'T11245',    
'S2627',    
'N42209',    
'N43455',    
'J31082')    
    
GROUP BY    
CLI.REGION, CLI.BRANCH, CLI.SB, NB.PARTYCODE, RMS.LEDGER, RMS.NET_COLLECTION, RM_COLL.PROJ_RISK    
--HAVING SUM(NBFC_LEDGER) > 0    
--HAVING SUM(BSE_Ledger + NSE_Ledger + NSEFO_Ledger + BSEFO_Ledger + MCD_Ledger + NSX_Ledger + MCX_Ledger + NCDEX_Ledger) = 0    
    
    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'CHEN3429'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'K34780'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'T5756'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'KC73'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'P24095'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'P26978'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'RCK026'    
    
SELECT * FROM [196.1.115.182].[GENERAL].DBO.CLIENT_DETAILS WITH (NOLOCK)    
WHERE CL_TYPE = 'NBF'    
AND PARTY_CODE NOT IN (SELECT DISTINCT PARTYCODE FROM NBFC_PROJ_RISK)    
    
    
SELECT * FROM [196.1.115.182].[GENERAL].DBO.CLIENT_DETAILS WITH (NOLOCK)    
WHERE CL_TYPE = 'NBF'    
AND PARTY_CODE IN (SELECT DISTINCT PARTYCODE FROM NBFC_PROJ_RISK)    
    
IMargin_Shortage_value IMargin_Shortage_Percent    
0.00 0.00    
    
SELECT DISTINCT PARTYCODE FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'CHEN7356'    
    
SELECT TOP 10 * FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'CHEN3429'    
    
SELECT TOP 10 * FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'P24095'    
    
SELECT * FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'SU69'    
    
    
SELECT TOP 10 * FROM RMS_DtclFi WITH (NOLOCK)    
WHERE PARTY_CODE = 'S76034'    
    
SELECT TOP 10 * FROM [196.1.115.182].[general].dbo.RMS_DtclFi WITH (NOLOCK) WHERE PARTY_CODE = 'S76034'    
    
SELECT TOP 10 * FROM NBFC_MILES_LEDGER WITH (NOLOCK) -- -1003933.63    
WHERE BACKOFFICECODE = 'CHEN7356'    
    
SELECT TOP 10 * FROM NBFC_MILES_LEDGER WITH (NOLOCK) -- -1003933.63    
WHERE BACKOFFICECODE = 'CHEN3429'    
    
SELECT TOP 10 * FROM TBL_RMS_COLLECTION_CLI WITH (NOLOCK)    
WHERE PARTY_CODE = 'CHEN7356'    
    
SELECT * FROM TBL_RMS_COLLECTION_CLI WITH (NOLOCK)    
WHERE PARTY_CODE IN (SELECT BACKOFFICECODE FROM NBFC_MILES_LEDGER)    
AND PARTY_CODE LIKE 'CHE%'    
    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'CHEN3429'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'CHEN7356'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'CHEN7315'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'T5756'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'KC73'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'RCK026'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'KC73'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'SU69'    
    
SELECT * FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315' and [SCRIP CODE] LIKE '%532747%'    
    
SELECT SUM([Total hold]) FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315'    
SELECT SUM([Margin With Total]) FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315'    
SELECT SUM([HOLD WITH HC]) FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315'    
    
DROP TABLE CLI_NBFC_RISK    
DROP TABLE NBFC_PROJ_RISK    
    
SELECT * FROM NBFC_PROJ_RISK WHERE PARTYCODE = 'CHEN7356'    
    
*/    
    
/* MODIFIED BY SUSHANT NAGARKAR ON 20 NOV 2012     
   TO GET LIST OF NBFC CLIENTS */    
TRUNCATE TABLE NBFC_PARTY_CODE    
INSERT INTO NBFC_PARTY_CODE    
SELECT party_code FROM client_Details WHERE cl_type IN('NBF','TMF')    
    
/* DROP TABLE NBFC_PROJ_RISK */    
    
TRUNCATE TABLE NBFC_PROJ_RISK    
INSERT INTO NBFC_PROJ_RISK    
SELECT S.Status, M.ISIN, M.PartyCode, S.BseCode AS [Scrip Code], [Scrip Name] = S.ScripName, S.ScripName, sum(M.NetQty) AS [Quantity],    
M.clsPr AS [Closing Rate],    
BLUECHIP = CASE WHEN S.Status ='Bluechip' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
GOOD = CASE WHEN S.Status ='Good' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
Average = CASE WHEN S.Status ='Average' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
Poor = CASE WHEN S.Status ='Poor' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
[Total HOLD] = convert(decimal(15,2),0),    
/*    
[Exchange Var %]= isnull(convert(decimal(15,2),SVM.nse_var),0.00),    
*/    
[Exchange Var %]= isnull(convert(decimal(15,2),M.Exchange_HairCut),0.00),    
    
[Angel Var %]= convert(decimal(15,2),isnull(angel_var,0)),    
[Valid Var %]= convert(decimal(15,2),0),    
[Final Var %]=isnull(convert(decimal(15,2), (CASE WHEN S.Status = 'Poor' THEN 100 ELSE SVM.nse_final_var END)),0.00),    
[Margin With Highest VaR] = convert(decimal(15,2),0),    
[Margin With Total]= convert(decimal(15,2),0),    
[Haircut %]= convert(decimal(15,2),0),    
[Haircut For Proj%]= convert(decimal(15,2),0),    
[Hold with HC]=convert(decimal(15,2),0)    
--INTO NBFC_PROJ_RISK    
FROM vw_miles_StockholdingData_nbfc M WITH (NOLOCK)    
LEFT OUTER JOIN SCRIP_MASTER S ON M.ISIN = S.ISIN    
left outer join ScripVaR_Master SVM WITH (NOLOCK) on M.ISIN=SVM.ISIN    
--WHERE M.PartyCode ='KC73'    
group by    
S.Status, M.ISIN, M.PartyCode, S.ScripName, S.BseCode, M.clsPr, S.Status, -- VRH.HairCut,    
SVM.nse_var, isnull(angel_var,0), SVM.nse_final_var, M.Exchange_HairCut    
    
/* DELETE FROM NBFC_PROJ_RISK WHERE PARTYCODE IS NULL */    
    
    
update NBFC_PROJ_RISK    
set [Margin With Highest VaR] = isnull(convert(decimal(15,2), (CASE WHEN Status = 'Poor' THEN 100 ELSE [Exchange Var %] END)),0.00)    
    
--update NBFC_PROJ_RISK set [Hold with HC] = A.total_withHC    
--FROM    
-- (    
-- SELECT ISIN, SUM(total_withHC) total_withHC    
-- FROM Vw_Rms_holding WITH (NOLOCK) -- GROUP BY ISIN    
-- ) A WHERE A.ISIN = NBFC_PROJ_RISK.ISIN    
    
    
--update NBFC_PROJ_RISK set [Haircut %] = B.HairCut    
--FROM    
-- (    
-- SELECT ISIN, HairCut    
-- FROM Vw_Rms_holding WITH (NOLOCK)    
-- ) B WHERE B.ISIN = NBFC_PROJ_RISK.ISIN    
    
--update NBFC_PROJ_RISK    
--set [Haircut %] =    
-- (CASE WHEN STATUS = 'Average'    
-- THEN    
-- (    
-- CASE WHEN [Margin With Highest VaR] >= B.HairCut    
-- THEN [Margin With Highest VaR]    
-- ELSE B.HairCut    
-- END    
-- )    
-- ELSE    
-- B.HairCut    
-- END    
-- )    
--FROM    
--(    
-- SELECT ISIN, HairCut    
-- FROM Vw_Rms_holding WITH (NOLOCK)    
--) B WHERE B.ISIN = NBFC_PROJ_RISK.ISIN    
    
    
update NBFC_PROJ_RISK SET [Total HOLD] = Convert(decimal(15,2),(BlueChip + Good + Average + Poor))    
    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
(    
CASE WHEN STATUS = 'POOR' THEN 100    
WHEN (STATUS = 'GOOD' OR STATUS = 'BLUECHIP') THEN    
(    
CASE WHEN [Exchange Var %] >= [Valid Var %] THEN [Exchange Var %] / 2    
WHEN [Valid Var %] > [Exchange Var %] THEN [Valid Var %] / 2    
END    
)    
END    
)    
    
/*---CONVERT 50 TO 40 AND 25 to 20----*/    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
convert(decimal(18,2),    
(    
CASE WHEN STATUS = 'Average' THEN    
(    
(    
CASE WHEN [Exchange Var %] <= 40 AND [Valid Var %] <= 40 THEN 20    
when ([Exchange Var %] <= 40 and [Valid Var %] > 40) THEN [Valid Var %] / 2    
when ([Exchange Var %] > 40 and [Valid Var %] <= 40) THEN [Exchange Var %] / 2    
when ([Exchange Var %] > 40 and [Valid Var %] > 40) THEN    
(    
CASE WHEN [Exchange Var %] >= [Valid Var %] THEN [Exchange Var %] / 2    
ELSE [Valid Var %] / 2    
END    
)    
END    
)    
)    
ELSE    
[Haircut For Proj%]    
END    
)    
)    
/*---COMMENT ON 19-11-2013----    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
convert(decimal(18,2),    
(    
CASE WHEN STATUS = 'Average' THEN    
(    
(    
CASE WHEN [Exchange Var %] <= 50 AND [Valid Var %] <= 50 THEN 25    
when ([Exchange Var %] <= 50 and [Valid Var %] > 50) THEN [Valid Var %] / 2    
when ([Exchange Var %] > 50 and [Valid Var %] <= 50) THEN [Exchange Var %] / 2    
when ([Exchange Var %] > 50 and [Valid Var %] > 50) THEN    
(    
CASE WHEN [Exchange Var %] >= [Valid Var %] THEN [Exchange Var %] / 2    
ELSE [Valid Var %] / 2    
END    
)    
END    
)    
)    
ELSE    
[Haircut For Proj%]    
END    
)    
)    
*/    
    
/*    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
(    
CASE WHEN STATUS = 'POOR'    
THEN 100    
WHEN STATUS = 'Average'    
THEN [Exchange Var %]    
ELSE    
CASE WHEN [Exchange Var %] > 50    
THEN [Exchange Var %]    
ELSE    
[Exchange Var %] / 2    
END    
END    
)    
    
    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
convert(decimal(18,2),(    
CASE WHEN [Exchange Var %] <= 50 AND [Valid Var %] <= 50 THEN 25    
when ([Exchange Var %] <= 50 and [Valid Var %] > 50) THEN [Valid Var %] / 2    
when ([Exchange Var %] > 50 and [Valid Var %] <= 50) THEN [Exchange Var %] / 2    
when ([Exchange Var %] > 50 and [Valid Var %] > 50) THEN    
(    
CASE WHEN [Exchange Var %] >= [Valid Var %] THEN [Exchange Var %] / 2    
ELSE [Valid Var %] / 2    
END    
)    
END)    
)    
*/    
    
/*    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
(    
CASE WHEN STATUS = 'Average' THEN    
CASE WHEN [Exchange Var %] >= [Valid Var %] THEN    
CASE WHEN [Exchange Var %] > 50 THEN [Exchange Var %] / 2 ELSE [Exchange Var %] END    
WHEN [Exchange Var %] < [Valid Var %] THEN    
CASE WHEN [Valid Var %] > 50 THEN [Valid Var %] / 2 ELSE [Valid Var %] END    
END    
ELSE    
[Haircut For Proj%]    
END    
)    
*/    
    
--update NBFC_PROJ_RISK    
--SET [Haircut For Proj%] =    
-- (    
-- CASE WHEN STATUS = 'Average' THEN    
-- CASE WHEN [Exchange Var %] > [Valid Var %] THEN    
-- CASE WHEN [Exchange Var %] > 50 THEN [Exchange Var %] / 2 END    
-- WHEN [Exchange Var %] < [Valid Var %] THEN    
-- CASE WHEN [Valid Var %] > 50 THEN [Valid Var %] / 2 END    
-- END    
-- ELSE    
-- [Haircut For Proj%]    
-- END    
-- )    
--update NBFC_PROJ_RISK SET [Hold with HC] = Convert(decimal(15,2), ([Total HOLD] - ([Total HOLD] * [Haircut %])/100))    
    
UPDATE NBFC_PROJ_RISK SET [Haircut %] = [Haircut For Proj%]    
    
update NBFC_PROJ_RISK SET [Hold with HC] = Convert(decimal(15,2), ([Total HOLD] - ([Total HOLD] * [Haircut For Proj%])/100))    
update NBFC_PROJ_RISK SET [Margin With Highest VaR] = (([Total HOLD] * [Margin With Highest VaR]) / 100)    
update NBFC_PROJ_RISK SET [Margin With Total] = [Total HOLD] - [Margin With Highest VaR]    
update NBFC_PROJ_RISK SET [Valid Var %] = (CASE WHEN Status ='Poor' THEN 100 ELSE [Exchange Var %] END)    
    
    
/* DROP TABLE CLI_NBFC_RISK */    
    
TRUNCATE TABLE CLI_NBFC_RISK    
INSERT INTO CLI_NBFC_RISK    
SELECT PARTYCODE, SUM(LOGICALLEDGER) LOGICALLEDGER, SUM([Hold with HC]) [Hold with HC],    
SUM([Margin With Total]) [Margin With Total]    
--INTO CLI_NBFC_RISK    
FROM    
(    
SELECT BACKOFFICECODE PARTYCODE, LOGICALLEDGER, 0 [Hold with HC], 0 [Margin With Total]    
FROM NBFC_MILES_LEDGER WITH (NOLOCK)    
    
UNION ALL    
    
SELECT PARTYCODE, 0 LOGICALLEDGER, SUM([Hold with HC]) [Hold with HC],    
SUM([Margin With Total]) [Margin With Total]    
FROM NBFC_PROJ_RISK WITH (NOLOCK)    
GROUP BY    
PARTYCODE    
) A    
--WHERE PARTYCODE = 'CHEN7356'    
GROUP BY    
PARTYCODE    
    
    
----- NOT YET UPDATED    
-- 3651    
    
/* -- COMMENTED ON 31 JULY 2012 FOR TIME BEING REPLCAING HoldingWithHC WITH Holding_Approved    
UPDATE RMS    
SET RMS.HoldingWithHC = ISNULL(CLI.[MARGIN WITH TOTAL], 0)    
FROM RMS_DtclFi RMS WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
WHERE RMS.CO_CODE = 'NBFC'    
*/    
  
    
UPDATE RMS    
SET RMS.Holding_Approved = ISNULL(CLI.[MARGIN WITH TOTAL], 0)    
FROM RMS_DtclFi RMS WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
WHERE RMS.CO_CODE = 'NBFC'    
    
    
/* SELECT TOP 10 * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'PTA7863' */    
    
-- drop table #TEMP_MARGIN    
    
CREATE TABLE #TEMP_MARGIN    
(    
PARTY_CODE VARCHAR(50),    
LEDGER MONEY,    
IMARGIN MONEY,    
[HOLD WITH HC] MONEY    
)    
    
INSERT INTO #TEMP_MARGIN    
SELECT PARTYCODE, 0, 0, 0    
FROM CLI_NBFC_RISK    
WHERE PARTYCODE IN (SELECT PARTYCODE FROM NBFC_PARTY_CODE)    
    
UPDATE #TEMP_MARGIN    
SET LEDGER = RMS.LEDGER    
FROM    
(    
SELECT PARTY_CODE,    
SUM(    
LEDGER + CASH_COLLETERAL + NONCASH_COLLETERAL + NODEL_LOSS + NODEL_PROFIT +    
(    
CASE WHEN    
(MTM_LOSS_ACT + MTM_PROFIT_ACT) < 0    
THEN    
(MTM_LOSS_ACT + MTM_PROFIT_ACT)    
ELSE    
0    
END    
)    
) LEDGER    
FROM Vw_RmsDtclFi_Collection WITH (NOLOCK)    
GROUP BY    
PARTY_CODE    
) RMS    
WHERE #TEMP_MARGIN.PARTY_CODE = RMS.PARTY_CODE    
    
UPDATE #TEMP_MARGIN    
SET IMARGIN = RMS.IMARGIN    
FROM    
(    
SELECT PARTY_CODE, ((SUM(IMARGIN) / 2) * -1) IMARGIN    
FROM Vw_RmsDtclFi_Collection WITH (NOLOCK)    
GROUP BY    
PARTY_CODE    
) RMS    
WHERE #TEMP_MARGIN.PARTY_CODE = RMS.PARTY_CODE    
    
UPDATE #TEMP_MARGIN    
SET [HOLD WITH HC] = NBFC.[HOLD WITH HC]    
FROM    
(    
SELECT PARTYCODE, [HOLD WITH HC]    
FROM CLI_NBFC_RISK WITH (NOLOCK)    
) NBFC    
WHERE #TEMP_MARGIN.PARTY_CODE = NBFC.PARTYCODE    
    
    
UPDATE CLI    
SET CLI.PROJRISK = A.PROJ_RISK    
FROM TBL_RMS_COLLECTION CLI WITH (NOLOCK)    
INNER JOIN    
(    
SELECT PARTY_CODE,    
(CASE    
WHEN    
(LEDGER + IMARGIN + [HOLD WITH HC]) < 0    
THEN    
(LEDGER + IMARGIN + [HOLD WITH HC])    
ELSE    
0    
END) PROJ_RISK    
FROM #TEMP_MARGIN    
) A    
ON CLI.PARTY_CODE = A.PARTY_CODE    
    
/**/    
    
    
    
--SELECT RMS.*    
--FROM RMS_DtclFi RMS WITH (NOLOCK)    
-- INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
--WHERE RMS.CO_CODE = 'NBFC'    
    
--RMS_DtclFi    
    
    
--SELECT NBFC.*, CLI.PROJ_RISK    
--FROM CLI_NBFC_RISK NBFC    
-- INNER JOIN TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK) ON NBFC.PARTYCODE = CLI.PARTY_CODE   
--WHERE CLI.PROJ_RISK < 0    
    
    
--UPDATE CLI    
--SET CLI.PROJ_RISK =    
-- (    
-- CASE WHEN (VW_RMS.LEDGER + ISNULL(NBFC.[HOLD WITH HC], 0)) < 0    
-- THEN (VW_RMS.LEDGER + ISNULL(NBFC.[HOLD WITH HC], 0))    
-- ELSE    
-- 0    
-- END    
-- )    
--FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
-- INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
-- INNER JOIN Vw_RmsDtclFi_Collection VW_RMS WITH (NOLOCK) ON VW_RMS.PARTY_CODE = CLI.PARTY_CODE    
--WHERE VW_RMS.CO_CODE = 'NBFC'    
    
/*    
SELECT VW_RMS.LEDGER, ISNULL(NBFC.[HOLD WITH HC], 0)    
FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
INNER JOIN Vw_RmsDtclFi_Collection VW_RMS WITH (NOLOCK) ON VW_RMS.PARTY_CODE = CLI.PARTY_CODE    
WHERE CLI.PARTY_CODE = 'KC73'    
AND VW_RMS.CO_CODE = 'NBFC'    
    
*/    
    
    
UPDATE RMS    
SET RMS.Holding_Approved = ISNULL(CLI.[MARGIN WITH TOTAL], 0)    
FROM RMS_DtclFi RMS WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
WHERE RMS.CO_CODE = 'NBFC'    
    
/*    
    
    
/* --- COMMENTED ON 24 AUG 2012 BEFORE ADDING 50% VaR AVERAGE    
    
DROP TABLE #NBFC_DUMP    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'KOLK10328'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'AA37'    
SELECT * FROM NBFC_PROJ_RISK WHERE PARTYCODE = 'AA37'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'AA37'    
    
    
/*    
SELECT CLI.REGION, CLI.BRANCH, CLI.SB, NB.PARTYCODE, RMS.LEDGER LOGICAL_LEDGER,    
SUM(NB.[TOTAL HOLD]) [TOTAL HOLD], SUM(NB.[Margin With Total]) [HOLD WITH HC FOR MARGIN SHORTAGE],    
RMS.NET_COLLECTION, SUM(NB.[Hold with HC]) [Hold with HC FOR PROJ RISK],    
RM_COLL.PROJ_RISK    
INTO #NBFC_DUMP    
FROM NBFC_PROJ_RISK NB WITH (NOLOCK)    
INNER JOIN Vw_RMS_Client_Vertical CLI WITH (NOLOCK) ON NB.PARTYCODE = CLI.CLIENT    
LEFT OUTER JOIN (    
SELECT PARTY_CODE, LEDGER,    
(ISNULL(ledger,0) + ISNULL(IMargin_Shortage_value,0) - ISNULL(Unrecosiled_Credit,0)) NET_COLLECTION    
FROM RMS_DtclFi WITH (NOLOCK)    
WHERE CO_CODE = 'NBFC'    
) RMS ON RMS.PARTY_CODE = NB.PARTYCODE    
LEFT OUTER JOIN TBL_RMS_COLLECTION_CLI RM_COLL WITH (NOLOCK) ON RM_COLL.PARTY_CODE = NB.PARTYCODE    
*/    
---- drop table #NBFC_DUMP    
    
SELECT CLI.REGION, CLI.BRANCH, CLI.SB, NB.PARTYCODE, RMS.LEDGER LOGICAL_LEDGER,    
SUM(NB.[TOTAL HOLD]) [TOTAL HOLD], SUM(NB.[Margin With Total]) [HOLD WITH HC FOR MARGIN SHORTAGE],    
RMS.NET_COLLECTION, SUM(NB.[Hold with HC]) [Hold with HC FOR PROJ RISK],    
RM_COLL.PROJ_RISK    
INTO #NBFC_DUMP    
FROM NBFC_PROJ_RISK NB WITH (NOLOCK)    
INNER JOIN Vw_RMS_Client_Vertical CLI WITH (NOLOCK) ON NB.PARTYCODE = CLI.CLIENT    
LEFT OUTER JOIN (    
SELECT PARTY_CODE, LEDGER,    
(ISNULL(ledger,0) + ISNULL(IMargin_Shortage_value,0) - ISNULL(Unrecosiled_Credit,0)) NET_COLLECTION    
FROM RMS_DtclFi WITH (NOLOCK)    
WHERE CO_CODE = 'NBFC'    
) RMS ON RMS.PARTY_CODE = NB.PARTYCODE    
LEFT OUTER JOIN (SELECT PARTYCODE, (CASE WHEN (LOGICALLEDGER + [HOLD WITH HC]) < 0    
THEN (LOGICALLEDGER + [HOLD WITH HC])    
ELSE    
0    
END)    
PROJ_RISK    
FROM CLI_NBFC_RISK RM_COLL WITH (NOLOCK)) RM_COLL ON RM_COLL.PARTYCODE = NB.PARTYCODE    
    
WHERE NB.PARTYCODE IN ('A30969',    
'A35303',    
'C2250',    
'S10468',    
'J29489',    
'T11245',    
'S2627',    
'N42209',    
'N43455',    
'J31082')    
    
GROUP BY    
CLI.REGION, CLI.BRANCH, CLI.SB, NB.PARTYCODE, RMS.LEDGER, RMS.NET_COLLECTION, RM_COLL.PROJ_RISK    
--HAVING SUM(NBFC_LEDGER) > 0    
--HAVING SUM(BSE_Ledger + NSE_Ledger + NSEFO_Ledger + BSEFO_Ledger + MCD_Ledger + NSX_Ledger + MCX_Ledger + NCDEX_Ledger) = 0    
    
    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'CHEN3429'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'K34780'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'T5756'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'KC73'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'P24095'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'P26978'    
SELECT * FROM #NBFC_DUMP WHERE PARTYCODE = 'RCK026'    
    
SELECT * FROM [196.1.115.182].[GENERAL].DBO.CLIENT_DETAILS WITH (NOLOCK)    
WHERE CL_TYPE = 'NBF'    
AND PARTY_CODE NOT IN (SELECT DISTINCT PARTYCODE FROM NBFC_PROJ_RISK)    
    
    
SELECT * FROM [196.1.115.182].[GENERAL].DBO.CLIENT_DETAILS WITH (NOLOCK)    
WHERE CL_TYPE = 'NBF'    
AND PARTY_CODE IN (SELECT DISTINCT PARTYCODE FROM NBFC_PROJ_RISK)    
    
IMargin_Shortage_value IMargin_Shortage_Percent    
0.00 0.00    
    
SELECT DISTINCT PARTYCODE FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'CHEN7356'    
    
SELECT TOP 10 * FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'CHEN3429'    
    
SELECT TOP 10 * FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'P24095'    
    
SELECT * FROM NBFC_PROJ_RISK WITH (NOLOCK)    
WHERE PARTYCODE = 'SU69'    
    
    
SELECT TOP 10 * FROM RMS_DtclFi WITH (NOLOCK)    
WHERE PARTY_CODE = 'S76034'    
    
SELECT TOP 10 * FROM [196.1.115.182].[general].dbo.RMS_DtclFi WITH (NOLOCK)    
WHERE PARTY_CODE = 'S76034'    
    
SELECT TOP 10 * FROM NBFC_MILES_LEDGER WITH (NOLOCK) -- -1003933.63    
WHERE BACKOFFICECODE = 'CHEN7356'    
    
SELECT TOP 10 * FROM NBFC_MILES_LEDGER WITH (NOLOCK) -- -1003933.63    
WHERE BACKOFFICECODE = 'CHEN3429'    
    
SELECT TOP 10 * FROM TBL_RMS_COLLECTION_CLI WITH (NOLOCK)    
WHERE PARTY_CODE = 'CHEN7356'    
    
SELECT * FROM TBL_RMS_COLLECTION_CLI WITH (NOLOCK)    
WHERE PARTY_CODE IN (SELECT BACKOFFICECODE FROM NBFC_MILES_LEDGER)    
AND PARTY_CODE LIKE 'CHE%'    
    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'CHEN3429'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'CHEN7356'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'CHEN7315'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'T5756'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'KC73'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'RCK026'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'KC73'    
SELECT * FROM CLI_NBFC_RISK WHERE PARTYCODE = 'SU69'    
    
SELECT * FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315' and [SCRIP CODE] LIKE '%532747%'    
    
SELECT SUM([Total hold]) FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315'    
SELECT SUM([Margin With Total]) FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315'    
SELECT SUM([HOLD WITH HC]) FROM NBFC_PROJ_RISK WITH (NOLOCK) WHERE PARTYCODE = 'CHEN7315'    
    
DROP TABLE CLI_NBFC_RISK    
DROP TABLE NBFC_PROJ_RISK    
    
SELECT * FROM NBFC_PROJ_RISK WHERE PARTYCODE = 'CHEN7356'    
    
*/    
    
/* DROP TABLE NBFC_PROJ_RISK */    
    
TRUNCATE TABLE NBFC_PROJ_RISK    
INSERT INTO NBFC_PROJ_RISK    
SELECT S.Status, M.ISIN, M.PartyCode, S.BseCode AS [Scrip Code], [Scrip Name] = S.ScripName, S.ScripName, sum(M.NetQty) AS [Quantity],    
M.clsPr AS [Closing Rate],    
BLUECHIP = CASE WHEN S.Status ='Bluechip' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
GOOD = CASE WHEN S.Status ='Good' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
Average = CASE WHEN S.Status ='Average' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
Poor = CASE WHEN S.Status ='Poor' THEN (convert(decimal(15,2),sum(M.PFValue))) else 0 END,    
[Total HOLD] = convert(decimal(15,2),0),    
/*    
[Exchange Var %]= isnull(convert(decimal(15,2),SVM.nse_var),0.00),    
*/    
[Exchange Var %]= isnull(convert(decimal(15,2),M.Exchange_HairCut),0.00),    
    
[Angel Var %]= convert(decimal(15,2),isnull(angel_var,0)),    
[Valid Var %]= convert(decimal(15,2),0),    
[Final Var %]=isnull(convert(decimal(15,2), (CASE WHEN S.Status = 'Poor' THEN 100 ELSE SVM.nse_final_var END)),0.00),    
[Margin With Highest VaR] = convert(decimal(15,2),0),    
[Margin With Total]= convert(decimal(15,2),0),    
[Haircut %]= convert(decimal(15,2),0),    
[Haircut For Proj%]= convert(decimal(15,2),0),    
[Hold with HC]=convert(decimal(15,2),0)    
--INTO NBFC_PROJ_RISK    
FROM Vw_MILES_STOCKHOLDINGDATA M WITH (NOLOCK)    
LEFT OUTER JOIN SCRIP_MASTER S ON M.ISIN = S.ISIN    
left outer join ScripVaR_Master SVM WITH (NOLOCK) on M.ISIN=SVM.ISIN    
--WHERE M.PartyCode ='KC73'    
group by    
S.Status, M.ISIN, M.PartyCode, S.ScripName, S.BseCode, M.clsPr, S.Status, -- VRH.HairCut,    
SVM.nse_var, isnull(angel_var,0), SVM.nse_final_var, M.Exchange_HairCut    
    
/* DELETE FROM NBFC_PROJ_RISK WHERE PARTYCODE IS NULL */    
    
    
update NBFC_PROJ_RISK    
set [Margin With Highest VaR] = isnull(convert(decimal(15,2), (CASE WHEN Status = 'Poor' THEN 100 ELSE [Exchange Var %] END)),0.00)    
    
--update NBFC_PROJ_RISK set [Hold with HC] = A.total_withHC    
--FROM    
-- (    
-- SELECT ISIN, SUM(total_withHC) total_withHC    
-- FROM Vw_Rms_holding WITH (NOLOCK) -- GROUP BY ISIN    
-- ) A WHERE A.ISIN = NBFC_PROJ_RISK.ISIN    
    
    
--update NBFC_PROJ_RISK set [Haircut %] = B.HairCut    
--FROM    
-- (    
-- SELECT ISIN, HairCut    
-- FROM Vw_Rms_holding WITH (NOLOCK)    
-- ) B WHERE B.ISIN = NBFC_PROJ_RISK.ISIN    
    
--update NBFC_PROJ_RISK    
--set [Haircut %] =    
-- (CASE WHEN STATUS = 'Average'    
-- THEN    
-- (    
-- CASE WHEN [Margin With Highest VaR] >= B.HairCut    
-- THEN [Margin With Highest VaR]    
-- ELSE B.HairCut    
-- END    
-- )    
-- ELSE    
-- B.HairCut    
-- END    
-- )    
--FROM    
--(    
-- SELECT ISIN, HairCut    
-- FROM Vw_Rms_holding WITH (NOLOCK)    
--) B WHERE B.ISIN = NBFC_PROJ_RISK.ISIN    
    
    
update NBFC_PROJ_RISK SET [Total HOLD] = Convert(decimal(15,2),(BlueChip + Good + Average + Poor))    
    
update NBFC_PROJ_RISK    
SET [Haircut For Proj%] =    
(    
CASE WHEN STATUS = 'POOR'    
THEN 100    
WHEN STATUS = 'Average'    
THEN 50    
ELSE    
CASE WHEN [Exchange Var %] > 50    
THEN [Exchange Var %]    
ELSE    
[Exchange Var %] / 2    
END    
END    
)    
    
--update NBFC_PROJ_RISK SET [Hold with HC] = Convert(decimal(15,2), ([Total HOLD] - ([Total HOLD] * [Haircut %])/100))    
    
UPDATE NBFC_PROJ_RISK SET [Haircut %] = [Haircut For Proj%]    
    
update NBFC_PROJ_RISK SET [Hold with HC] = Convert(decimal(15,2), ([Total HOLD] - ([Total HOLD] * [Haircut For Proj%])/100))    
update NBFC_PROJ_RISK SET [Margin With Highest VaR] = (([Total HOLD] * [Margin With Highest VaR]) / 100)    
update NBFC_PROJ_RISK SET [Margin With Total] = [Total HOLD] - [Margin With Highest VaR]    
    
/* DROP TABLE CLI_NBFC_RISK */    
    
TRUNCATE TABLE CLI_NBFC_RISK    
INSERT INTO CLI_NBFC_RISK    
SELECT PARTYCODE, SUM(LOGICALLEDGER) LOGICALLEDGER, SUM([Hold with HC]) [Hold with HC],    
SUM([Margin With Total]) [Margin With Total]    
--INTO CLI_NBFC_RISK    
FROM    
(    
SELECT BACKOFFICECODE PARTYCODE, LOGICALLEDGER, 0 [Hold with HC], 0 [Margin With Total]    
FROM NBFC_MILES_LEDGER WITH (NOLOCK)    
    
UNION ALL    
    
SELECT PARTYCODE, 0 LOGICALLEDGER, SUM([Hold with HC]) [Hold with HC],    
SUM([Margin With Total]) [Margin With Total]    
FROM NBFC_PROJ_RISK WITH (NOLOCK)    
GROUP BY    
PARTYCODE    
) A    
--WHERE PARTYCODE = 'CHEN7356'    
GROUP BY    
PARTYCODE    
    
    
----- NOT YET UPDATED    
-- 3651    
    
    
UPDATE RMS    
SET RMS.HoldingWithHC = ISNULL(CLI.[MARGIN WITH TOTAL], 0)    
FROM RMS_DtclFi RMS WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
WHERE RMS.CO_CODE = 'NBFC'    
    
/**/    
    
-- drop table #TEMP_MARGIN    
    
CREATE TABLE #TEMP_MARGIN    
(    
PARTY_CODE VARCHAR(50),    
LEDGER MONEY,    
IMARGIN MONEY,    
[HOLD WITH HC] MONEY    
)    
    
INSERT INTO #TEMP_MARGIN    
SELECT PARTYCODE, 0, 0, 0    
FROM CLI_NBFC_RISK    
WHERE PARTYCODE IN (SELECT PARTYCODE FROM NBFC_PARTY_CODE)    
    
UPDATE #TEMP_MARGIN    
SET LEDGER = RMS.LEDGER    
FROM    
(    
SELECT PARTY_CODE,    
SUM(    
LEDGER + CASH_COLLETERAL + NONCASH_COLLETERAL + NODEL_LOSS + NODEL_PROFIT +    
(    
CASE WHEN    
(MTM_LOSS_ACT + MTM_PROFIT_ACT) < 0    
THEN    
(MTM_LOSS_ACT + MTM_PROFIT_ACT)    
ELSE    
0    
END    
)    
) LEDGER    
FROM Vw_RmsDtclFi_Collection WITH (NOLOCK)    
GROUP BY    
PARTY_CODE    
) RMS    
WHERE #TEMP_MARGIN.PARTY_CODE = RMS.PARTY_CODE    
    
UPDATE #TEMP_MARGIN    
SET IMARGIN = RMS.IMARGIN    
FROM    
(    
SELECT PARTY_CODE, ((SUM(IMARGIN) / 2) * -1) IMARGIN    
FROM Vw_RmsDtclFi_Collection WITH (NOLOCK)    
GROUP BY    
PARTY_CODE    
) RMS    
WHERE #TEMP_MARGIN.PARTY_CODE = RMS.PARTY_CODE    
    
UPDATE #TEMP_MARGIN    
SET [HOLD WITH HC] = NBFC.[HOLD WITH HC]    
FROM    
(    
SELECT PARTYCODE, [HOLD WITH HC]    
FROM CLI_NBFC_RISK WITH (NOLOCK)    
) NBFC    
WHERE #TEMP_MARGIN.PARTY_CODE = NBFC.PARTYCODE    
    
    
UPDATE CLI    
SET CLI.PROJRISK = A.PROJ_RISK    
FROM TBL_RMS_COLLECTION CLI WITH (NOLOCK)    
INNER JOIN    
(    
SELECT PARTY_CODE,    
(CASE    
WHEN    
(LEDGER + IMARGIN + [HOLD WITH HC]) < 0    
THEN    
(LEDGER + IMARGIN + [HOLD WITH HC])    
ELSE    
0    
END) PROJ_RISK    
FROM #TEMP_MARGIN    
) A    
ON CLI.PARTY_CODE = A.PARTY_CODE    
    
/**/    
    
    
    
--SELECT RMS.*    
--FROM RMS_DtclFi RMS WITH (NOLOCK)    
-- INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
--WHERE RMS.CO_CODE = 'NBFC'    
    
--RMS_DtclFi    
    
    
--SELECT NBFC.*, CLI.PROJ_RISK    
--FROM CLI_NBFC_RISK NBFC    
-- INNER JOIN TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK) ON NBFC.PARTYCODE = CLI.PARTY_CODE    
--WHERE CLI.PROJ_RISK < 0    
    
    
--UPDATE CLI    
--SET CLI.PROJ_RISK =    
-- (    
-- CASE WHEN (VW_RMS.LEDGER + ISNULL(NBFC.[HOLD WITH HC], 0)) < 0    
-- THEN (VW_RMS.LEDGER + ISNULL(NBFC.[HOLD WITH HC], 0))    
-- ELSE    
-- 0    
-- END    
-- )    
--FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
-- INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
-- INNER JOIN Vw_RmsDtclFi_Collection VW_RMS WITH (NOLOCK) ON VW_RMS.PARTY_CODE = CLI.PARTY_CODE    
--WHERE VW_RMS.CO_CODE = 'NBFC'    
    
/*    
SELECT VW_RMS.LEDGER, ISNULL(NBFC.[HOLD WITH HC], 0)    
FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
INNER JOIN Vw_RmsDtclFi_Collection VW_RMS WITH (NOLOCK) ON VW_RMS.PARTY_CODE = CLI.PARTY_CODE    
WHERE CLI.PARTY_CODE = 'KC73'    
AND VW_RMS.CO_CODE = 'NBFC'    
    
*/    
    
UPDATE RMS    
SET RMS.Holding_Approved = ISNULL(CLI.[MARGIN WITH TOTAL], 0)    
FROM RMS_DtclFi RMS WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK CLI ON CLI.PARTYCODE = RMS.PARTY_CODE    
WHERE RMS.CO_CODE = 'NBFC'    
    
    
--UPDATE CLI    
--SET CLI.NET_DEBIT = ISNULL(A.NET_COL, 0)    
--FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
-- INNER JOIN    
-- (    
-- SELECT VW.PARTY_CODE, SUM(VW.EX_NET) NET_COL    
-- FROM VW_RMSDTCLFI_COLLECTION VW WITH (NOLOCK)    
-- INNER JOIN CLI_NBFC_RISK NBFC WITH (NOLOCK) ON NBFC.PARTYCODE = VW.PARTY_CODE    
-- --WHERE VW.PARTY_CODE = 'KOLK3487'    
-- GROUP BY    
-- VW.PARTY_CODE    
-- ) A    
-- ON A.PARTY_CODE = CLI.PARTY_CODE    
    
/* FOR FILE DUMP */    
-- EXEC NBFC_DUMP_FILE    
/* FOR FILE DUMP */    
    
    
/*    
    
SELECT COUNT(1) FROM CLI_NBFC_RISK    
SELECT COUNT(1) FROM NBFC_PROJ_RISK    
    
    
UPDATE CLI    
-- SET CLI.PROJ_RISK = CLI.PROJ_RISK + ISNULL(NBFC.LOGICALLEDGER, 0) + ISNULL(NBFC.[HOLD WITH HC], 0)    
SET CLI.PROJ_RISK =    
(    
CASE WHEN CLI.PROJ_RISK < 0 THEN    
(    
CASE WHEN (CLI.PROJ_RISK - ISNULL(CLI.HOLD_TOTALHC, 0) + ISNULL(NBFC.[HOLD WITH HC], 0)) < 0    
THEN (CLI.PROJ_RISK - ISNULL(CLI.HOLD_TOTALHC, 0) + ISNULL(NBFC.[HOLD WITH HC], 0))    
ELSE    
0    
END    
)    
ELSE    
0    
END    
)    
FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
*/    
    
--UPDATE CLI    
--SET CLI.NET_DEBIT = ISNULL(NBFC.LOGICALLEDGER, 0) + ISNULL(NBFC.[MARGIN WITH TOTAL], 0)    
--FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
-- INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
    
    
    
    
/*    
    
UPDATE UAT    
SET UAT.PROJ_RISK = LIVE.PROJ_RISK    
FROM TBL_RMS_COLLECTION_CLI UAT WITH (NOLOCK)    
INNER JOIN [196.1.115.182].[GENERAL].DBO.TBL_RMS_COLLECTION_CLI LIVE WITH (NOLOCK) ON UAT.PARTY_CODE = LIVE.PARTY_CODE    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = UAT.PARTY_CODE    
    
UPDATE UAT    
SET UAT.IMargin_Shortage_value = LIVE.IMargin_Shortage_value    
FROM RMS_DtclFi UAT WITH (NOLOCK)    
INNER JOIN [196.1.115.182].[GENERAL].DBO.RMS_DtclFi LIVE WITH (NOLOCK) ON UAT.PARTY_CODE = LIVE.PARTY_CODE    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = UAT.PARTY_CODE    
WHERE UAT.CO_CODE = 'NBFC'    
    
UPDATE UAT    
SET UAT.Holding_Approved = LIVE.Holding_Approved    
FROM RMS_DtclFi UAT WITH (NOLOCK)    
INNER JOIN [196.1.115.182].[GENERAL].DBO.RMS_DtclFi LIVE WITH (NOLOCK) ON UAT.PARTY_CODE = LIVE.PARTY_CODE    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = UAT.PARTY_CODE    
WHERE UAT.CO_CODE = 'NBFC'    
    
    
UPDATE UAT    
SET UAT.NET_DEBIT = LIVE.NET_DEBIT    
FROM TBL_RMS_COLLECTION_CLI UAT WITH (NOLOCK)    
INNER JOIN [196.1.115.182].[GENERAL].DBO.TBL_RMS_COLLECTION_CLI LIVE WITH (NOLOCK) ON UAT.PARTY_CODE = LIVE.PARTY_CODE    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = UAT.PARTY_CODE    
    
    
------------------------------------------    
    
SELECT CLI.PROJ_RISK, ISNULL(NBFC.[MARGIN WITH TOTAL], 0), ISNULL(NBFC.[HOLD WITH HC], 0)    
FROM TBL_RMS_COLLECTION_CLI CLI WITH (NOLOCK)    
INNER JOIN CLI_NBFC_RISK NBFC ON NBFC.PARTYCODE = CLI.PARTY_CODE    
WHERE CLI.PARTY_CODE = 'CHEN3429'    
    
*/    
    
/*    
SELECT [Scrip Code], [Scrip Name],convert(int,[Quantity]) as [Quantity],[Closing Rate],    
BLUECHIP , GOOD , Average , Poor , [Total HOLD] , isnull([Exchange Var %],0) as [Exchange Var %],    
isnull([Final Var %],0) as [Valid Var %], ISNULL([Margin With Highest VaR], 0) AS [Margin With Highest VaR],    
isnull([Haircut %],0.00) as [Haircut % For Proj Risk], isnull([Hold with HC],0.00) as [Hold with HC For Proj Risk]    
from NBFC_PROJ_RISK    
where partycode = 'CHEN7356'    
order by    
[Scrip Name], [Scrip Code]    
    
    
SELECT * FROM miles_StockholdingData WITH (NOLOCK)    
SELECT TOP 10 * FROM miles_StockholdingData WITH (NOLOCK)    
WHERE PARTYCODE = 'CHEN7356'    
*/    
*/  

END TRY        
 BEGIN CATCH        
   INSERT INTO EODBODDetail_Error (ErrTime, ErrObject, ErrLine, ErrMessage)        
   SELECT GETDATE(), 'UPD_NBFC_PROJ_RISK', ERROR_LINE(), ERROR_MESSAGE()        
        
   DECLARE @ErrorMessage NVARCHAR(4000);        
        
   SELECT @ErrorMessage = ERROR_MESSAGE() + convert(VARCHAR(10), error_line());        
        
   RAISERROR (@ErrorMessage, 16, 1);        
 END CATCH;                    
Set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NRI_LG_BANKMASTER
-- --------------------------------------------------


CREATE PROCEDURE [dbo].[UPD_NRI_LG_BANKMASTER]  
-- Add the parameters for the stored procedure here        
AS  
  BEGIN  
      -- SET NOCOUNT ON added to prevent extra result sets from        
      -- interfering with SELECT statements.        
      SET NOCOUNT ON;  
  
      -- Insert statements for procedure here       
      SELECT BANKID,  
             BANKNAME,  
             CONVERT(VARCHAR, LASTUPDATEDDATE) AS LASTUPDATEDDATE,  
             TOTALCOUNT,  
             ZRCOUNT,  
             Replace(FILENAMEVALIDATION, 'DDMMYYYY', Replace(CONVERT(VARCHAR, Getdate(), 103), '/', '')) AS FILENAMEVALIDATION,  
             CASE  
               WHEN CONVERT(VARCHAR, LASTUPDATEDDATE, 103) = CONVERT(VARCHAR, Getdate(), 103) THEN 'Green'  
               ELSE 'Red'  
             END                                                                                         AS RowColour  
      FROM   NRI_LG_BANK_MASTER  
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NRI_LG_FILE_UPLOAD
-- --------------------------------------------------

 /*=============================================                  
Author:  RITESH                  
Create date: OCT 17 2013               
Description: NRI PIS FILE UPLOAD                 
 
CHANGE ID  :: 1      
MODIFIED BY  :: RITESH          
MODIFIED DATE :: NOV 14 2013                                                            
REASON   :: Indusind bank has changed the separator in PIS balance file from "~" this character to ",".     
PRMS ID :: 10351017      
=============================================*/  
CREATE PROCEDURE [dbo].[UPD_NRI_LG_FILE_UPLOAD]  
  -- Add the parameters for the stored procedure here      
  @FILEPATH VARCHAR(50),  
  @FILENAME VARCHAR(50),  
  @BANKID   INT,  
  @UPLOADID VARCHAR(50),  
  @UPLOADBY VARCHAR(20)  
AS  
  BEGIN  
      -- SET NOCOUNT ON added to prevent extra result sets from                  
      -- interfering with SELECT statements.                  
      SET NOCOUNT ON;  
  
      -- Insert statements for procedure here                  
      --DECLARE @FILENAME AS VARCHAR(200),                  
      --        @BANKID   AS INT                  
      --SET @FILENAME='PISBalance_INDUSINDBANK_06052013.txt'                  
      --SET @BANKID='3'                  
      DECLARE @str               AS VARCHAR(300),  
              @result            AS VARCHAR(11),  
              @FileExt           AS VARCHAR(11),  
              @dt                AS VARCHAR(11),  
              @date              AS VARCHAR(10),  
              @STR_TEMP_AXIS     AS VARCHAR(1000),  
              @STR_TEMP_IDBI     AS VARCHAR(1000),  
              @STR_TEMP_INDUSIND AS VARCHAR(1000),  
              @STR_TEMP_YES      AS VARCHAR(1000),  
              @total_Cnt         INT,  
              @Total_ZR_Cnt      INT  
  
  /*Check File Exists*/  
      --SET @FileExt = Substring(@FILENAME, Charindex('.', @FILENAME), Len(@FILENAME))                  
      SET @str=' declare @result as int'  
      SET @str=@str + ' exec @result=MASTER.dbo.xp_cmdshell ''dir' + @FILEPATH + @FILENAME + ''', NO_OUTPUT'  
      SET @str=@str + ' select Result=@result '  
  
      CREATE TABLE #temp1  
        (  
           status INT  
        )  
  
      INSERT INTO #temp1  
      EXEC(@str)  
  
      SELECT @result = status  
      FROM   #temp1  
  
      CREATE TABLE #NRI_LG_PIS_BALANCE  
        (  
           [BANKID]          [INT] NULL,  
           [PIS_ACCOUNT_NO]  [VARCHAR](50) NULL,  
           [PARTY_CODE]      [VARCHAR](20) NULL,  
           [BALANCE]         [DECIMAL](18, 2) NULL,  
           [UPLOAD_DATETIME] [DATETIME] NULL,  
           [UPLOAD_BY]       [VARCHAR](20) NULL,  
           [UPLOAD_IP]       [VARCHAR](20) NULL  
        )  
  
      BEGIN TRY  
          IF( @result = '0' )  
            BEGIN  
                IF( @BANKID = '1' )  
                  BEGIN  
   
     SET @STR_TEMP_AXIS=''  
     SET @STR_TEMP_AXIS='BULK INSERT NRI_LG_AXISBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = '','',KeepNULLS, firstrow=2)'  
  
                      --print @STR_TEMP_AXIS  
                      EXEC (@STR_TEMP_AXIS)  
  
                      SET @TOTAL_CNT = @@ROWCOUNT  
  
                      INSERT INTO #NRI_LG_PIS_BALANCE  
                      SELECT BANKID=@BANKID,  
                             PIS_ACCOUNT_NO,  
							 PARTY_CODE,  
                             BALANCE,  
                             UPLOAD_DATETIME=Getdate(),  
                             UPLOAD_BY=@UPLOADBY,  
							 UPLOAD_IP=@UPLOADID  
                      FROM   NRI_LG_AXISBANK_TEMP  
                      WHERE  PARTY_CODE LIKE 'ZR%'  
  
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT  
                  END  
                ELSE IF ( @BANKID = '2' )  
                  BEGIN  
                      SET @STR_TEMP_IDBI=''  
                      SET @STR_TEMP_IDBI='BULK INSERT NRI_LG_IDBIBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = ''|'',KeepNULLS, firstrow=2)'  
  
                      --PRINT (@STR_TEMP_IDBI)           
                      EXEC (@STR_TEMP_IDBI)  
  
                      SET @TOTAL_CNT = @@ROWCOUNT  
  
                      SELECT *  
                      INTO   #NRI_CLIENT_MST  
                      FROM   INTRANET.RISK.DBO.VW_NRI_CLIENT_MASTER
  
                      INSERT INTO #NRI_LG_PIS_BALANCE  
                      SELECT BANKID=@BANKID,  
                             PIS_ACCOUNT_NO=I.PIS_ACCOUNT_NO,  
                             PARTY_CODE=C.Fld_ClientCode,  
                             BALANCE=I.BALANCE,  
                             UPLOAD_DATETIME=Getdate(),  
                             UPLOAD_BY=@UPLOADBY,  
                             UPLOAD_IP=@UPLOADID  
                      FROM   NRI_LG_IDBIBANK_TEMP I  
                             INNER JOIN #NRI_CLIENT_MST C  
                               ON I.PIS_ACCOUNT_NO = C.Fld_ClientPISAC  
                      WHERE  C.Fld_ClientCode LIKE 'ZR%'  
  
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT  
  
                      DROP TABLE #NRI_CLIENT_MST  
                  END  
                ELSE IF ( @BANKID = '3' )  
                  BEGIN  
       /* CHANGE ID  :: 1 */      
                      SET @STR_TEMP_INDUSIND=''  
                      SET @STR_TEMP_INDUSIND='BULK INSERT NRI_LG_INDUSINDBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = '','',KeepNULLS)'  
  
                      --PRINT @STR_TEMP_INDUSIND    
                      EXEC (@STR_TEMP_INDUSIND)  
  
                      SET @TOTAL_CNT = @@ROWCOUNT  
  
                      INSERT INTO #NRI_LG_PIS_BALANCE  
                      SELECT BANKID=@BANKID,  
                             PIS_ACCOUNT_NO=PIS_ACCOUNT_NO,  
                             PARTY_CODE=PARTY_CODE,  
                             BALANCE=BALANCE,  
                             UPLOAD_DATETIME=Getdate(),  
                             UPLOAD_BY=@UPLOADBY,  
                             UPLOAD_IP=@UPLOADID  
                      FROM   NRI_LG_INDUSINDBANK_TEMP  
                      WHERE  PARTY_CODE LIKE 'ZR%'  
  
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT  
                  END  
                   ELSE IF ( @BANKID = '4' )    
                  BEGIN    
                      SET @STR_TEMP_YES=''    
                      SET @STR_TEMP_YES='BULK INSERT NRI_LG_YESBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = '','',firstrow=2,KeepNULLS)'  
                      EXEC (@STR_TEMP_YES)    
    
                      SET @TOTAL_CNT = @@ROWCOUNT    
    
                      SELECT *    
                      INTO   #NRI_CLIENT_MASTER    
                      FROM   INTRANET.RISK.DBO.VW_NRI_CLIENT_MASTER    
    
                      INSERT INTO #NRI_LG_PIS_BALANCE    
                      SELECT BANKID=@BANKID,    
                             PIS_ACCOUNT_NO=I.ACCOUNT_NUMBER,    
                             PARTY_CODE=C.Fld_ClientCode,    
                             BALANCE=I.BALANCE_AVAILABLE,    
                             UPLOAD_DATETIME=Getdate(),    
                             UPLOAD_BY=@UPLOADBY,    
                             UPLOAD_IP=@UPLOADID    
                      FROM   NRI_LG_YESBANK_TEMP I    
                             INNER JOIN #NRI_CLIENT_MASTER C    
                               ON I.ACCOUNT_NUMBER = C.Fld_ClientPISAC    
                      WHERE  C.Fld_ClientCode LIKE 'ZR%'    
    
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT    
    
                      DROP TABLE #NRI_CLIENT_MASTER    
                  END
				  ELSE IF ( @BANKID = '5' )  -- ADDING new banks Masters 11-02-2022 -- Leon 
				    BEGIN
					  SET @STR_TEMP_YES=''    
                      
                      SET @STR_TEMP_YES='BULK INSERT NRI_LG_IDFCCBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = '','',firstrow=2,KeepNULLS)'  
                      EXEC (@STR_TEMP_YES) 
					  
					  SET @TOTAL_CNT = @@ROWCOUNT    
    
                      SELECT *    
                      INTO   #NRI_CLIENT_MASTERIDFC    
                      FROM   INTRANET.RISK.DBO.VW_NRI_CLIENT_MASTER    
    
                      INSERT INTO #NRI_LG_PIS_BALANCE    
                      SELECT BANKID=@BANKID,    
                             PIS_ACCOUNT_NO=I.AccountNo,    
                             PARTY_CODE=C.Fld_ClientCode,    
                             BALANCE=I.BALANCE,    
                             UPLOAD_DATETIME=Getdate(),    
                             UPLOAD_BY=@UPLOADBY,    
                             UPLOAD_IP=@UPLOADID    
                      FROM   NRI_LG_IDFCCBANK_TEMP I    
                             INNER JOIN #NRI_CLIENT_MASTERIDFC C    
                               ON I.AccountNo = C.Fld_ClientPISAC    
                      WHERE  C.Fld_ClientCode LIKE 'ZR%'    
    
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT    
    
					DROP TABLE #NRI_CLIENT_MASTERIDFC 
					End
					ELSE IF ( @BANKID = '6' )  -- ADDING new banks Masters 11-02-2022 -- Leon 
				    BEGIN
					  SET @STR_TEMP_YES=''    
                      
                      SET @STR_TEMP_YES='BULK INSERT NRI_LG_HDFCBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = '','',firstrow=3,KeepNULLS)'  
                                
                      EXEC (@STR_TEMP_YES) 
					  
					  SET @TOTAL_CNT = @@ROWCOUNT    
    
                      SELECT *    
                      INTO   #NRI_CLIENT_MASTERHDFC    
                      FROM   INTRANET.RISK.DBO.VW_NRI_CLIENT_MASTER    
    
                      INSERT INTO #NRI_LG_PIS_BALANCE    
                      SELECT BANKID=@BANKID,    
                             PIS_ACCOUNT_NO=I.AccountNo,    
                             PARTY_CODE=C.Fld_ClientCode,    
                             BALANCE=I.AvailableBALANCE,    
                             UPLOAD_DATETIME=Getdate(),    
                             UPLOAD_BY=@UPLOADBY,    
                             UPLOAD_IP=@UPLOADID    
                      FROM   NRI_LG_HDFCBANK_TEMP I    
                             INNER JOIN #NRI_CLIENT_MASTERHDFC C    
                               ON I.AccountNo = C.Fld_ClientPISAC    
                      WHERE  C.Fld_ClientCode LIKE 'ZR%'    
    
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT    
    
					DROP TABLE #NRI_CLIENT_MASTERHDFC 
					End
					ELSE IF ( @BANKID = '7' )  -- ADDING new banks (KOTAK) Masters 28-05-2025 -- HRISHI START
				    BEGIN
					  SET @STR_TEMP_YES=''    
                      
                      SET @STR_TEMP_YES='BULK INSERT NRI_LG_KOTAKBANK_TEMP FROM ''' + @FILEPATH + @FILENAME + ''' WITH (FIELDTERMINATOR = '','',firstrow=3,KeepNULLS)'  
                                
                      EXEC (@STR_TEMP_YES) 
					  
					  SET @TOTAL_CNT = @@ROWCOUNT    
    
                      SELECT *    
                      INTO   #NRI_CLIENT_MASTERKOTAK
                      FROM   INTRANET.RISK.DBO.VW_NRI_CLIENT_MASTER    
    
                      INSERT INTO #NRI_LG_PIS_BALANCE    
                      SELECT BANKID=@BANKID,    
                             PIS_ACCOUNT_NO=I.ACCOUNT_NUMBER,    
                             PARTY_CODE=C.Fld_ClientCode,    
                             BALANCE=I.BALANCE_AVAILABLE,    
                             UPLOAD_DATETIME=Getdate(),    
                             UPLOAD_BY=@UPLOADBY,    
                             UPLOAD_IP=@UPLOADID    
                      FROM   NRI_LG_KOTAKBANK_TEMP I    
                             INNER JOIN #NRI_CLIENT_MASTERKOTAK C    
                               ON I.ACCOUNT_NUMBER = C.Fld_ClientPISAC    
                      WHERE  C.Fld_ClientCode LIKE 'ZR%'    
    
                      SET @TOTAL_ZR_CNT = @@ROWCOUNT    
    
					DROP TABLE #NRI_CLIENT_MASTERKOTAK 
					End  -- ADDING new banks (KOTAK) Masters 28-05-2025 -- HRISHI START
  
                PRINT @TOTAL_CNT  
                  
  
                IF /*@TOTAL_ZR_CNT <> 0 AND*/ @TOTAL_CNT <> 0  
                  BEGIN  
                      DELETE FROM NRI_LG_PIS_BALANCE  
                      WHERE  CONVERT(VARCHAR(11), UPLOAD_DATETIME, 103) = CONVERT(VARCHAR(11), Getdate(), 103)  
                             AND BANKID = @BANKID  
  
                      INSERT INTO NRI_LG_PIS_BALANCE  
                      SELECT BANKID,  
                             PIS_ACCOUNT_NO,  
                             Ltrim(Rtrim(PARTY_CODE)),  
                             BALANCE,  
                             UPLOAD_DATETIME,  
                             UPLOAD_BY,  
                             UPLOAD_IP  
                      FROM   #NRI_LG_PIS_BALANCE  
  
                      INSERT INTO NRI_LG_PIS_BALANCE_LOG  
                      SELECT BANKID,  
                             PIS_ACCOUNT_NO,  
                             Ltrim(Rtrim(PARTY_CODE)),  
                             BALANCE,  
                             UPLOAD_DATETIME,  
                             UPLOAD_BY,  
                             UPLOAD_IP  
                      FROM   NRI_LG_PIS_BALANCE  
                      WHERE  BANKID = @BANKID  
  
                      INSERT INTO NRI_LG_BANK_FILE_UPLOAD_LOG  
                      SELECT BANKID=@BANKID,  
                             [FILENAME]=@FILENAME,  
                             TOTALCOUNT=@TOTAL_CNT,  
                             ZRCOUNT=@TOTAL_ZR_CNT,  
                             UPLOAD_DATETIME=Getdate(),  
                             UPLOAD_BY=@UPLOADBY,  
                             UPLOAD_IP=@UPLOADID  
  
                      UPDATE NRI_LG_BANK_MASTER  
                      SET    LASTUPDATEDDATE = Getdate(),  
                             TOTALCOUNT = @TOTAL_CNT,  
                             ZRCOUNT = @TOTAL_ZR_CNT  
                      WHERE  BANKID = @BANKID  
  
                      SELECT '1'                     AS Processed,  
                             'Uploaded Successfully' AS RESULT  
                  END  
                ELSE  
                  BEGIN  
                      SELECT '2'                       AS Processed,  
                             'No record found in file' AS RESULT  
                  END  
            END  
          ELSE  
            BEGIN  
                SELECT '0'                     AS Processed,  
                       'Unable to locate file' AS RESULT  
            END  
      END TRY  
  
      BEGIN CATCH  
          SELECT '0'                     AS Processed,  
                 'Unable to upload file' AS RESULT  
      END CATCH  
  
      DROP TABLE #temp1  
  
      TRUNCATE TABLE NRI_LG_AXISBANK_TEMP  
  
      TRUNCATE TABLE NRI_LG_IDBIBANK_TEMP  
  
      TRUNCATE TABLE NRI_LG_INDUSINDBANK_TEMP  
        
       TRUNCATE TABLE NRI_LG_YESBANK_TEMP  

	   TRUNCATE TABLE NRI_LG_IDFCCBANK_TEMP 

	   Truncate table NRI_LG_HDFCBANK_TEMP

	   Truncate table NRI_LG_KOTAKBANK_TEMP
  END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_NRI_LG_REPORT_
-- --------------------------------------------------
/*=============================================  
Author      : RITESH  
Create Date : 23-JUNE-2025  
Updated By  : Vishwajeet  
Update Desc : Added NRI Type (NRE/NRO) using tbl_NRIClientMaster  
Example     :  
EXEC dbo.UPD_NRI_LG_REPORT_ 'ZONE','ALL','12/23/2013','ALL','BROKER','CSO','E34080'  
=============================================*/  
CREATE PROCEDURE [dbo].[UPD_NRI_LG_REPORT_]  
(  
    @FILTERLEVEL  VARCHAR(30),  
    @FILTERCODE   VARCHAR(30),  
    @LMTDATE      VARCHAR(12),  
    @BNK          VARCHAR(30),  
    @ACCESS_TO    VARCHAR(25),  
    @ACCESS_CODE  VARCHAR(25),  
    @USERID       VARCHAR(100)  
)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    /*------------------------------------------  
      Normalize input parameters  
    ------------------------------------------*/  
    IF (@FILTERLEVEL = 'CLIENT')  
        SET @FILTERLEVEL = 'PARTY_CODE';  
  
    IF (@BNK = 'ALL')  
        SET @BNK = '%';  
  
    IF (@FILTERCODE = 'ALL')  
        SET @FILTERCODE = '%';  
  
    /*------------------------------------------  
      Base data collection  
    ------------------------------------------*/  
    SELECT  
        C.ZONE,  
        C.REGION,  
        C.BRANCH,  
        C.SB,  
        NET.PARTY_CODE,  
  
        ISNULL(B.BANKNAME, '-') AS BANKNAME,  
        ISNULL('''' + N.PIS_ACCOUNT_NO, '-') AS PIS_ACCOUNT_NO,  
  
        NET.PIS_BALANCE AS BALANCE,  
        NET.FO_LEDGER,  
        NET.TDAYOBLIGATION,  
        NET.PRIOR_TO_TDAYOBLIGATION,  
        NET.NET_LIMIT,  
        NET.UPDATE_DATETIME,  
  
        /* 🔹 NRI TYPE LOGIC */  
        CASE  
            WHEN CM.Fld_NREACNO IS NOT NULL  
                 AND LTRIM(RTRIM(CM.Fld_NREACNO)) <> '' THEN 'NRO'  
            WHEN CM.Fld_NROACNO IS NOT NULL  
                 AND LTRIM(RTRIM(CM.Fld_NROACNO)) <> '' THEN 'NRE'  
            ELSE 'NA'  
        END AS NRI_TYPE  
  
    INTO #ClientVet  
  
    FROM GENERAL.DBO.VW_RMS_CLIENT_VERTICAL C WITH (NOLOCK)  
  
    INNER JOIN GENERAL.DBO.NRI_LG_PIS_NET_BALANCE_HIST NET WITH (NOLOCK)  
        ON NET.PARTY_CODE = C.CLIENT  
  
    LEFT JOIN GENERAL.DBO.NRI_LG_PIS_BALANCE N WITH (NOLOCK)  
        ON NET.PARTY_CODE = N.PARTY_CODE  
       AND CONVERT(DATETIME, CONVERT(VARCHAR(11), N.UPLOAD_DATETIME))  
           = CONVERT(DATETIME, CONVERT(VARCHAR(11), NET.UPDATE_DATETIME))  
  
    LEFT JOIN GENERAL.DBO.NRI_LG_BANK_MASTER B WITH (NOLOCK)  
        ON N.BANKID = B.BANKID  
  
    LEFT JOIN INTRANET.risk.dbo.tbl_NRIClientMaster CM WITH (NOLOCK)  
        ON NET.PARTY_CODE = CM.Fld_ClientCode  
  
    WHERE NET.UPDATE_DATETIME BETWEEN @LMTDATE AND @LMTDATE + ' 23:59:59'  
      AND ISNULL(BANKNAME, '-') LIKE @BNK;  
  
  
    /*------------------------------------------  
      Dynamic output query (as per access rules)  
    ------------------------------------------*/  
    DECLARE @Source VARCHAR(4000);  
  
    SET @Source = '  
        SELECT  
            ZONE,  
            REGION,  
            BRANCH,  
            SB,  
            PARTY_CODE AS [PARTY CODE],  
            BANKNAME,  
            NRI_TYPE AS [NRI TYPE],  
            PIS_ACCOUNT_NO AS [PIS ACCOUNT NO],  
            BALANCE AS [PIS BALANCE],  
            FO_LEDGER AS [FO LEDGER],  
            TDAYOBLIGATION AS [TDAY OBLIGATION],  
            PRIOR_TO_TDAYOBLIGATION AS [PRIOR TO TDAY OBLIGATION],  
            NET_LIMIT AS [NET LIMIT]  
        FROM #ClientVet WITH (NOLOCK)  
        WHERE ISNULL(' + @FILTERLEVEL + ', '''') LIKE ''' + @FILTERCODE + '''';  
  
    /*------------------------------------------  
      Access Control Filters  
    ------------------------------------------*/  
    IF (@ACCESS_TO = 'SB')  
        SET @Source = @Source + ' AND SB LIKE ''' + @ACCESS_CODE + '''';  
  
    ELSE IF (@ACCESS_TO = 'BRANCH')  
        SET @Source = @Source + ' AND BRANCH LIKE ''' + @ACCESS_CODE + '''';  
  
    ELSE IF (@ACCESS_TO = 'BRMAST')  
        SET @Source = @Source + '  
            AND BRANCH IN (  
                SELECT branch_cd COLLATE SQL_Latin1_General_CP1_CI_AS  
                FROM intranet.risk.dbo.branch_master WITH (NOLOCK)  
                WHERE brmast_cd = ''' + @ACCESS_CODE + '''  
            )';  
  
    ELSE IF (@ACCESS_TO = 'REGION')  
        SET @Source = @Source + ' AND REGION = ''' + @ACCESS_CODE + '''';  
  
    ELSE IF (@ACCESS_TO = 'SBMAST')  
        SET @Source = @Source + '  
            AND SB IN (  
                SELECT sub_broker  
                FROM intranet.risk.dbo.sb_master WITH (NOLOCK)  
                WHERE sbmast_cd = ''' + @ACCESS_CODE + '''  
            )';  
  
    /*------------------------------------------  
      Execute final query  
    ------------------------------------------*/  
    EXEC (@Source);  
  
    /*------------------------------------------  
      Dummy selects (kept for backward compatibility)  
    ------------------------------------------*/  
    SELECT '';  
    SELECT '';  
    SELECT '' AS tDate;  
  
    SET NOCOUNT OFF;  
END;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SSIS_LEDGER_Bkup_12082023
-- --------------------------------------------------

CREATE Proc [dbo].[UPD_SSIS_LEDGER_Bkup_12082023]    
AS    
BEGIN  
Set nocount on       
set xact_abort on                                            
begin try   

----------- NEW part started for DP holding-------------    
--if exists(    
-- select top 1 batchID FROM RMS_BATCHJOB_LOG    
-- WHERE BATCHID = 51    
-- AND CONVERT(VARCHAR(10), BATCHDATE, 120) = CONVERT(VARCHAR(10), GETDATE(), 120)    
-- AND BatchStatus = 'N'    
-- ORDER BY BATCHDATE DESC)    
--BEGIN    
-- SELECT A.*    
-- INTO #JOBSTATUS    
-- FROM OPENROWSET('SQLOLEDB',    
-- 'SERVER=(local);Trusted_Connection=yes;',    
-- '    
-- SET FMTONLY OFF;    
-- Exec GENERAL.DBO.SP_Get_Job_Status ''DP_Holding_MorningProcess''    
-- ') a    
-- if (select running from #JOBSTATUS) = 0    
-- EXEC [CSOKYC-6].msdb.dbo.sp_start_job 'DP_Holding_MorningProcess'    
--END    
----------- NEW part Ended for DP holding-------------    

SELECT SEGMENT,PCODE=Y.seriescode+LTRIM(RTRIM(party_Code)),seriesDesc    
into #incTemp_ClientCode_Series
FROM (SELECT a.party_Code     
FROM client_details_trig a     
INNER JOIN client_details b WITH(NOLOCK) ON a.party_Code = b.party_code     
WHERE DBAction IN ('INSERTED','DELETED')    
GROUP BY a.party_Code    
HAVING COUNT(*) = 1) X    
CROSS JOIN LedgerSeries Y WITH(NOLOCK)    
WHERE Segment IN('BSECM','MCD','MCX','NCDEX','NSECM','NSEFO','NSX')    
AND active=1    
AND EntityType='Client'    
    
delete a from Temp_ClientCode_Series  a join #incTemp_ClientCode_Series b on a.pcode=b.PCODE

/*CODE ADDED ON 28 AUG 2013 TO INSERT SEGMENTWISE CLIENTS WITH SERIES*/    

INSERT INTO Temp_ClientCode_Series (segment,pcode,seriesDesc)  
select * from #incTemp_ClientCode_Series 

drop table #incTemp_ClientCode_Series
declare @cmd varchar(1000)    
declare @ssispath varchar(1000)    

/*set @ssispath = 'D:\RMS PKG\RMS PKG\RMS PKG\RMS PKG.dtsx'    */
set @ssispath = 'H:\RMS PKG\RMS PKG\RMS PKG\RMS PKG.dtsx'    

select @cmd = 'dtexec /F "' + @ssispath + '"'    
select @cmd = @cmd    

exec master..xp_cmdshell @cmd  

/*Added on 26 mar 2021 to consider MF BSS bal in net ledger*/
exec [USP_MFSS_BSE_LEDGER]

/* mimansa process to update holding and ledger on Nov 20 2015*/  

--select DATEPART(HH,GETDATE())
--select DATEPART(DW,GETDATE())
  if((DATEPART(DW,GETDATE())=2 and DATEPART(HH,GETDATE())<=9) or DATEPART(DW,GETDATE())=1)
		begin
		    EXEC mimansa.msdb.dbo.sp_start_job N'UPNRMSLedger'
		end
		else
  begin
		    EXEC mimansa.msdb.dbo.sp_start_job N'UPNRMSLedgerAndHolding' 
		end

if exists(select top 7 *, batchtaskName = (select BatchTaskName from Rms_SSISBatchTaskJob A    
where A.batchid=B.batchid and A.batchtaskid=B.batchtaskID)    
from Rms_SSISBatchTaskJob_log B where batchID=2    
and batchtaskstatus='N' order by batchtaskrunID desc)    
begin    
RAISERROR('THERE IS AN ERROR IN LEDGER FETCHING', 16, 1);    
end    

end try                                            
begin catch                                            
 insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)                                            
 select GETDATE(),'UPD_SSIS_LEDGER',ERROR_LINE(),ERROR_MESSAGE()                                            

 DECLARE @ErrorMessage NVARCHAR(4000);                                            
 SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                            
 RAISERROR (@ErrorMessage , 16, 1);                                  

 end catch;
 set nocount off        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SSIS_MORN_LEDGER_bkup_20082023
-- --------------------------------------------------


CREATE Proc [dbo].[UPD_SSIS_MORN_LEDGER_bkup_20082023]    
AS    
BEGIN    
 
Set nocount on            
set xact_abort on                                                  
begin try     
 /* EXEC [172.31.16.59].msdb.dbo.sp_start_job 'FOR ANGEL MARGIN AND HOLDING REPORT'  */  
 /*CODE ADDED ON 28 AUG 2013 TO INSERT SEGMENTWISE CLIENTS WITH SERIES*/    
 
 
SELECT SEGMENT,PCODE=Y.seriescode+LTRIM(RTRIM(party_Code)),seriesDesc    
into #incledgerTemp_ClientCode_Series
FROM (SELECT a.party_Code     
FROM client_details_trig a     
INNER JOIN client_details b WITH(NOLOCK) ON a.party_Code = b.party_code     
WHERE DBAction IN ('INSERTED','DELETED')    
GROUP BY a.party_Code    
HAVING COUNT(*) = 1) X    
CROSS JOIN LedgerSeries Y WITH(NOLOCK)    
WHERE Segment IN('BSECM','MCD','MCX','NCDEX','NSECM','NSEFO','NSX','BSX')    
AND active=1    
AND EntityType='Client' 
  
delete a from Temp_ClientCode_Series  a join #incledgerTemp_ClientCode_Series b on a.pcode=b.PCODE
 
INSERT INTO Temp_ClientCode_Series (segment,pcode,seriesDesc)    
select * from #incledgerTemp_ClientCode_Series
 
drop table #incledgerTemp_ClientCode_Series
  
declare @cmd varchar(1000)    
declare @ssispath varchar(1000)    

/*set @ssispath = 'D:\RMS PKG\RMS PKG\RMS PKG\RMS_PKG_MORN_ledger.dtsx'*/    
set @ssispath = 'H:\RMS PKG\RMS PKG\RMS PKG\RMS_PKG_MORN_ledger.dtsx'     
select @cmd = 'dtexec /F "' + @ssispath + '"'    
select @cmd = @cmd    
exec master..xp_cmdshell @cmd    

/*Added on 26 mar 2021 to consider MF BSS bal in net ledger*/
exec [USP_MFSS_BSE_LEDGER]
  
/*added mimansa morning ledger updation on nov 20 2015 */  
EXEC mimansa.msdb.dbo.sp_start_job N'UPNRMSLedger'  
  
if exists(select top 7 *, batchtaskName =(select BatchTaskName from Rms_SSISBatchTaskJob A    
where A.batchid=B.batchid and A.batchtaskid=B.batchtaskID )    
from Rms_SSISBatchTaskJob_log B where batchID=2 AND batchtaskid<>8    
and batchtaskstatus='N' order by batchtaskrunID desc)    
begin    
RAISERROR('THERE IS AN ERROR IN LEDGER FETCHING', 16, 1);    
end    
  
end try                                                  
begin catch                                                
insert into EODBODDetail_Error(ErrTime,ErrObject,ErrLine,ErrMessage)                                                
select GETDATE(),'UPD_SSIS_MORN_LEDGER',ERROR_LINE(),ERROR_MESSAGE()                                                

DECLARE @ErrorMessage NVARCHAR(4000);                                                
  
SELECT @ErrorMessage = ERROR_MESSAGE() + convert(varchar(10),error_line());                                                
RAISERROR (@ErrorMessage , 16, 1);                                      
  
end catch;           

set nocount off    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetHoldingNetoffRiskReport
-- --------------------------------------------------
CREATE PROCEDURE usp_GetHoldingNetoffRiskReport
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM history.dbo.tbl_Proj_risk_Holding_netoff_Final_Hist
    WHERE CONVERT(DATE, Upd_date) 
          BETWEEN CAST(DATEADD(DAY, -7, GETDATE()) AS DATE)
              AND CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_GetVarshortageRiskReport
-- --------------------------------------------------
CREATE PROCEDURE usp_GetVarshortageRiskReport
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM history.dbo.tbl_projRisk_Varshortage_Hist
    WHERE CONVERT(DATE, Upd_date) 
          BETWEEN CAST(DATEADD(DAY, -7, GETDATE()) AS DATE)
              AND CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mtf_sqoff_process_manual_bkup_05022024
-- --------------------------------------------------



CREATE proc [dbo].[usp_mtf_sqoff_process_manual_bkup_05022024]
as
begin

	declare @ProcDate as datetime                       
	select @ProcDate=MIN(Start_date-1) from General.dbo.BO_Sett_Mst where Sett_Type='N' and start_date >                 
	(select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
	
	declare @FY datetime  
	select @FY= sdtcur from parameter where curyear=1
	print @FY
    print @ProcDate

	truncate table tbl_MTFHolding_Sqoff
	insert into tbl_MTFHolding_Sqoff
	EXEC AngelNseCM.mtftrade.dbo.MFUND_RPT_FUNDING_OPENPOS @StatusId='broker', @StatusName='broker', @FROMPARTY='00000', @TOPARTY='ZZZZZ', @FromDate=@ProcDate, @ToDate=@ProcDate

	--truncate table tbl_MTF90days_data
	--insert into tbl_MTF90days_data
	--select * from tbl_MTFHolding_Sqoff where openday>90

	select distinct party_code,openday into #party_code1 from tbl_MTFHolding_Sqoff where openday>90

	update #party_code set openday=1 where openday=91
	update #party_code set openday=2 where openday=92
	update #party_code set openday=3 where openday>=93

	select distinct T.party_code, MTFLEDBAL,P.openday,netledger=cast(0.00 as money),
	Final_bal=cast(0.00 as money)
	into #ledger 
	from [AngelNseCM].MTFTrade.dbo.TBL_MTF_DATA T with (nolock) 
	inner join #party_code P
	on T.PARTY_CODE=P.party_code
	where cast(SAUDA_DATE as date)=(select max(cast(SAUDA_DATE as date)) 
	from [AngelNseCM].MTFTrade.dbo.TBL_MTF_DATA with (nolock))    -- ''' +CONVERT(VARCHAR(11),cast(@ALERTDATE as date))+ ''' AND 

	select party_code, netledger=bse_ledger+ Nse_ledger+nsefo_ledger+mcd_ledger+nsx_ledger+mcx_ledger+ncdex_ledger
	into #net from tbl_rms_collection_cli R with (nolock)

	update #ledger set netledger=R.netledger from #net R with (nolock)
	where #ledger.PARTY_CODE=R.PARTY_CODE

	update #ledger set Final_bal=case when netledger>0.00 then MTFLEDBAL+netledger  
									  when netledger<=0.00 then MTFLEDBAL else MTFLEDBAL end

	truncate table tbl_MTF_Shortage
	insert into tbl_MTF_Shortage
	select *  from #ledger

	select psrno =dense_rank() over(order by T.party_code ),
	sqoffsseg=row_number() over(partition by T.party_code order by T.sett_no asc)  ,
	T.*
	into #holding1
	from tbl_MTFHolding_Sqoff T inner join  tbl_MTF_Shortage T1
	on T.party_code=t1.party_code where T.OPENDAY>90      
  
	SELECT ID = ROW_NUMBER() OVER(ORDER BY PARTY_CODE),        
	DENSEID = DENSE_RANK() OVER(ORDER BY PARTY_CODE),*,NET_DEBIT=CONVERT(DECIMAL(18,2),0),        
	NET_DEBIT_ADJ=CONVERT(DECIMAL(18,2),0),SqQty=CONVERT(INT,0),CashSqup=CONVERT(DECIMAL(18,2),0),        
	Shortage=CONVERT(DECIMAL(18,2),0) INTO #CASHLOOP 
	FROM #holding1

	UPDATE #CASHLOOP        
	SET NET_DEBIT = B.Final_bal ,        
	NET_DEBIT_ADJ = B.Final_bal
	FROM #CASHLOOP A        
	INNER JOIN tbl_MTF_Shortage B ON A.party_code = B.party_code 
	 
	delete from #CASHLOOP where  CL_RATE=0      

	UPDATE #CASHLOOP        
	SET NET_DEBIT_ADJ = 0,DENSEID = 0        
	WHERE ID NOT IN(SELECT MIN(ID) FROM #CASHLOOP  GROUP BY PARTY_CODE)

	select ID = ROW_NUMBER() OVER(partition BY PARTY_CODE order by sett_no asc),        
	DENSEID = DENSE_RANK() OVER(ORDER BY PARTY_CODE),
	party_code,isin,scrip_cd,series,qty,cl_rate,total=Qty*Cl_rate,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ,SqQty,CashSqup into #CASHLOOP1
	from #CASHLOOP  

	;WITH Hold_CTE AS (  
	SELECT   
	ID,DENSEID,party_code,isin,scrip_cd,series,qty,Cl_rate,total,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ=cast(case when (NET_DEBIT_ADJ*-1)>=total then ((NET_DEBIT_ADJ*-1)-total) else 0 end as money),
	SqQty,CashSqup=cast(case when (NET_DEBIT_ADJ*-1)>=total then total else NET_DEBIT_ADJ*-1 end as money) 
	FROM #CASHLOOP1 e where  --party_code='M165956' and 
	id=1  
	UNION ALL  
	SELECT   
	e.ID,DENSEID,e.party_code,isin,scrip_cd,series,qty,Cl_rate,total,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ=cast(case when (ecte.NET_DEBIT_ADJ)>=e.total then ((ecte.NET_DEBIT_ADJ)-e.total) else 0 end as money),
	SqQty,CashSqup=cast(case when (ecte.NET_DEBIT_ADJ)>=total then total else ecte.NET_DEBIT_ADJ end as money)
	FROM #CASHLOOP1 e   
	INNER JOIN (select id,party_code,NET_DEBIT_ADJ from  Hold_CTE) ecte ON ecte.party_code =e.party_code and e.id=ecte.id+1  -- where e.party_code='M165956'  
	)  
	SELECT * into #sqoff
	FROM Hold_CTE option  (maxrecursion 32767) ; 

	update #sqoff set sqqty= CEILING(convert(money,CashSqup)/convert(money,Cl_rate))        
	
	truncate table tbl_manualsqof_mtf
	insert into tbl_manualsqof_mtf
	select *  from #sqoff where sqqty>0

	truncate table Tbl_MTF_scripwise_data_Manual
	insert into Tbl_MTF_scripwise_data_Manual
	select party_code,isin,scrip_cd,series,qty=sum(qty),cl_rate=max(cl_rate),sqqty=sum(sqqty),
	exchange,Cashsqup=sum(Cashsqup),upd_date=getdate(),'','',''
	from tbl_manualsqof_mtf T with (nolock) 
	group by party_code,isin,scrip_cd,series,exchange

	update Tbl_MTF_scripwise_data_Manual set bsecode=S.BseCode, nsesymbol=S.NseSymbol
	from scrip_master S with (nolock) where Tbl_MTF_scripwise_data_Manual.isin=S.isin

	update Tbl_MTF_scripwise_data_Manual  set EXCHANGE_NEW=(case when  C.BSECM='Y' and C.NSECM='N' and ISNULL(BSECODE,'')<>'' then 'BSECM'
											 when   C.BSECM='N' and C.NSECM='Y' and ISNULL(NSESYMBOL,'')<>'' then 'NSECM'
											 when  (C.BSECM='Y'  and C.NSECM='Y') then EXCHANGE
										--	 when  (C.BSECM='Y'  and C.NSECM='Y') then EXCHANGE
											 else '' end)
	from Tbl_MTF_scripwise_data_Manual T inner join client_details C with (nolock) 
	on T.party_code=C.party_code

	delete T from Tbl_MTF_scripwise_data_Manual T inner join client_details C with (nolock) 
	on T.party_code=C.party_code WHERE bsecm='N' and nsecm='N'

	truncate table tbl_MTF_Finaldata_90days
	insert into tbl_MTF_Shortage_Finaldata_90days
    select T1.party_code,T1.openday,T1.Final_bal,T2.sqoff_value,bsecm,nsecm, V.Cli_Type,upd_days=getdate()  
	--into tbl_MTF_Shortage_Finaldata_90days
	from tbl_MTF_Shortage T1 with (nolock) 
	inner join 
	(
	select  party_code,sqoff_value=sum(Cashsqup) from Tbl_MTF_scripwise_data_Manual 
	with (nolock) group by party_code
	)T2 
	on	T1.party_code=T2.party_code
	left outer join  client_details C with (nolock)
	on T1.party_code=C.party_code
	left outer join  Vw_RMS_Client_Vertical V with (nolock) 
	on T1.party_code=V.client


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mtf_sqoff_process_manual_bkup_08022024
-- --------------------------------------------------


CREATE proc [dbo].[usp_mtf_sqoff_process_manual_bkup_08022024]
as
begin

	declare @ProcDate as datetime                       
	select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >=                 
	(select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
	
	declare @FY datetime  
	select @FY= sdtcur from parameter where curyear=1
	print @FY
    print @ProcDate

	truncate table tbl_MTFHolding_Sqoff
	insert into tbl_MTFHolding_Sqoff
	EXEC AngelNseCM.mtftrade.dbo.MFUND_RPT_FUNDING_OPENPOS @StatusId='broker', @StatusName='broker', @FROMPARTY='00000', @TOPARTY='ZZZZZ', @FromDate=@ProcDate, @ToDate=@ProcDate

	--truncate table tbl_MTF90days_data
	--insert into tbl_MTF90days_data
	--select * from tbl_MTFHolding_Sqoff where openday>90

	select distinct party_code,openday into #party_code 
	from tbl_MTFHolding_Sqoff where openday>90

	update #party_code set openday=1 where openday=91
	update #party_code set openday=2 where openday=92
	update #party_code set openday=3 where openday>=93

	select distinct T.party_code, MTFLEDBAL,P.openday,netledger=cast(0.00 as money),
	Final_bal=cast(0.00 as money)
	into #ledger 
	from [AngelNseCM].MTFTrade.dbo.TBL_MTF_DATA T with (nolock) 
	inner join #party_code P
	on T.PARTY_CODE=P.party_code
	where cast(SAUDA_DATE as date)=(select max(cast(SAUDA_DATE as date)) 
	from [AngelNseCM].MTFTrade.dbo.TBL_MTF_DATA with (nolock))    -- ''' +CONVERT(VARCHAR(11),cast(@ALERTDATE as date))+ ''' AND 

	--select party_code, netledger=bse_ledger+ Nse_ledger+nsefo_ledger+mcd_ledger+nsx_ledger+mcx_ledger+ncdex_ledger
	--into #net from tbl_rms_collection_cli R with (nolock)

	select party_code,MTFLEDBAL,openday, balance,netledger=balance-MTFLEDBAL 
	into #net 
	from tbl_ledger_All_Risk T inner join #ledger L with (nolock)
	on T.cltcode=L.party_code --where L.party_code='A578176'

	--select party_code,bse_ledger,Nse_ledger,nsefo_ledger,mcd_ledger,
	--nsx_ledger,mcx_ledger,ncdex_ledger,mtf_ledger from  tbl_rms_collection_cli where party_code='A578176'

	update #ledger set netledger=R.netledger from #net R with (nolock)
	where #ledger.PARTY_CODE=R.PARTY_CODE

	update #ledger set Final_bal=case when netledger>0.00 then MTFLEDBAL+netledger  
									  when netledger<=0.00 then MTFLEDBAL else MTFLEDBAL end

	truncate table tbl_MTF_Shortage
	insert into tbl_MTF_Shortage
	select *  from #ledger

	select psrno =dense_rank() over(order by T.party_code ),
	sqoffsseg=row_number() over(partition by T.party_code order by T.sett_no asc)  ,
	T.*
	into #holding1
	from tbl_MTFHolding_Sqoff T inner join  tbl_MTF_Shortage T1
	on T.party_code=t1.party_code where T.OPENDAY>90      
  
	SELECT ID = ROW_NUMBER() OVER(ORDER BY PARTY_CODE),        
	DENSEID = DENSE_RANK() OVER(ORDER BY PARTY_CODE),*,NET_DEBIT=CONVERT(DECIMAL(18,2),0),        
	NET_DEBIT_ADJ=CONVERT(DECIMAL(18,2),0),SqQty=CONVERT(INT,0),CashSqup=CONVERT(DECIMAL(18,2),0),        
	Shortage=CONVERT(DECIMAL(18,2),0) INTO #CASHLOOP 
	FROM #holding1

	UPDATE #CASHLOOP        
	SET NET_DEBIT = B.Final_bal ,        
	NET_DEBIT_ADJ = B.Final_bal
	FROM #CASHLOOP A        
	INNER JOIN tbl_MTF_Shortage B ON A.party_code = B.party_code 
	 
	delete from #CASHLOOP where  CL_RATE=0      

	UPDATE #CASHLOOP        
	SET NET_DEBIT_ADJ = 0,DENSEID = 0        
	WHERE ID NOT IN(SELECT MIN(ID) FROM #CASHLOOP  GROUP BY PARTY_CODE)

	select ID = ROW_NUMBER() OVER(partition BY PARTY_CODE order by sett_no asc),        
	DENSEID = DENSE_RANK() OVER(ORDER BY PARTY_CODE),
	party_code,isin,scrip_cd,series,qty,cl_rate,total=Qty*Cl_rate,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ,SqQty,CashSqup into #CASHLOOP1
	from #CASHLOOP  

	;WITH Hold_CTE AS (  
	SELECT   
	ID,DENSEID,party_code,isin,scrip_cd,series,qty,Cl_rate,total,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ=cast(case when (NET_DEBIT_ADJ*-1)>=total then ((NET_DEBIT_ADJ*-1)-total) else 0 end as money),
	SqQty,CashSqup=cast(case when (NET_DEBIT_ADJ*-1)>=total then total else NET_DEBIT_ADJ*-1 end as money) 
	FROM #CASHLOOP1 e where  --party_code='M165956' and 
	id=1  
	UNION ALL  
	SELECT   
	e.ID,DENSEID,e.party_code,isin,scrip_cd,series,qty,Cl_rate,total,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ=cast(case when (ecte.NET_DEBIT_ADJ)>=e.total then ((ecte.NET_DEBIT_ADJ)-e.total) else 0 end as money),
	SqQty,CashSqup=cast(case when (ecte.NET_DEBIT_ADJ)>=total then total else ecte.NET_DEBIT_ADJ end as money)
	FROM #CASHLOOP1 e   
	INNER JOIN (select id,party_code,NET_DEBIT_ADJ from  Hold_CTE) ecte ON ecte.party_code =e.party_code and e.id=ecte.id+1  -- where e.party_code='M165956'  
	)  
	SELECT * into #sqoff
	FROM Hold_CTE option  (maxrecursion 32767) ; 

	update #sqoff set sqqty= CEILING(convert(money,CashSqup)/convert(money,Cl_rate))        
	
	truncate table tbl_manualsqof_mtf
	insert into tbl_manualsqof_mtf
	select *  from #sqoff where sqqty>0

	truncate table Tbl_MTF_scripwise_data_Manual
	insert into Tbl_MTF_scripwise_data_Manual
	select party_code,isin,scrip_cd,series,qty=sum(qty),cl_rate=max(cl_rate),sqqty=sum(sqqty),
	exchange,Cashsqup=sum(Cashsqup),upd_date=getdate(),'','',''
	from tbl_manualsqof_mtf T with (nolock) 
	group by party_code,isin,scrip_cd,series,exchange

	update Tbl_MTF_scripwise_data_Manual set bsecode=S.BseCode, nsesymbol=S.NseSymbol
	from scrip_master S with (nolock) where Tbl_MTF_scripwise_data_Manual.isin=S.isin

	update Tbl_MTF_scripwise_data_Manual  set EXCHANGE_NEW=(case when  C.BSECM='Y' and C.NSECM='N' and ISNULL(BSECODE,'')<>'' then 'BSECM'
											 when   C.BSECM='N' and C.NSECM='Y' and ISNULL(NSESYMBOL,'')<>'' then 'NSECM'
											 when  (C.BSECM='Y'  and C.NSECM='Y') then EXCHANGE
										--	 when  (C.BSECM='Y'  and C.NSECM='Y') then EXCHANGE
											 else '' end)
	from Tbl_MTF_scripwise_data_Manual T inner join client_details C with (nolock) 
	on T.party_code=C.party_code

	delete T from Tbl_MTF_scripwise_data_Manual T inner join client_details C with (nolock) 
	on T.party_code=C.party_code WHERE bsecm='N' and nsecm='N'

	truncate table tbl_MTF_Shortage_Finaldata_90days
	insert into tbl_MTF_Shortage_Finaldata_90days
    select T1.party_code,T1.openday,T1.Final_bal,T2.sqoff_value,bsecm,nsecm, V.Cli_Type,upd_days=getdate()  
	--into tbl_MTF_Shortage_Finaldata_90days
	from tbl_MTF_Shortage T1 with (nolock) 
	inner join 
	(
	select  party_code,sqoff_value=sum(Cashsqup) from Tbl_MTF_scripwise_data_Manual 
	with (nolock) group by party_code
	)T2 
	on	T1.party_code=T2.party_code
	left outer join  client_details C with (nolock)
	on T1.party_code=C.party_code
	left outer join  Vw_RMS_Client_Vertical V with (nolock) 
	on T1.party_code=V.client


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_mtf90days_sqoff_process_bkup_08022024
-- --------------------------------------------------



CREATE proc [dbo].[usp_mtf90days_sqoff_process_bkup_08022024]
as
begin

	declare @ProcDate as datetime                       
	select @ProcDate=MIN(Start_date) from General.dbo.BO_Sett_Mst where Sett_Type='D' and start_date >=                 
	(select MAX(Start_date) from General.dbo.BO_Sett_Mst where start_date < convert(date, getdate()) and Sett_Type='D')                
	
	declare @FY datetime  
	select @FY= sdtcur from parameter where curyear=1
	print @FY
    print @ProcDate

	truncate table tbl_MTFHolding_Sqoff
	insert into tbl_MTFHolding_Sqoff
	EXEC AngelNseCM.mtftrade.dbo.MFUND_RPT_FUNDING_OPENPOS @StatusId='broker', @StatusName='broker', @FROMPARTY='00000', @TOPARTY='ZZZZZ', @FromDate=@ProcDate, @ToDate=@ProcDate

	--truncate table tbl_MTF90days_data
	--insert into tbl_MTF90days_data
	--select * from tbl_MTFHolding_Sqoff where openday>90

	select distinct party_code,openday into #party_code 
	from tbl_MTFHolding_Sqoff where openday>90

	update #party_code set openday=1 where openday=91
	update #party_code set openday=2 where openday=92
	update #party_code set openday=3 where openday>=93
	
	select distinct T.party_code, MTFLEDBAL,P.openday,Other_Segment_Cr=cast(0.00 as money),
	Final_bal=cast(0.00 as money)
	into #ledger 
	from [AngelNseCM].MTFTrade.dbo.TBL_MTF_DATA T with (nolock) 
	inner join #party_code P
	on T.PARTY_CODE=P.party_code
	where cast(SAUDA_DATE as date)=(select max(cast(SAUDA_DATE as date)) 
	from [AngelNseCM].MTFTrade.dbo.TBL_MTF_DATA with (nolock))    -- ''' +CONVERT(VARCHAR(11),cast(@ALERTDATE as date))+ ''' AND 

	--select party_code, netledger=bse_ledger+ Nse_ledger+nsefo_ledger+mcd_ledger+nsx_ledger+mcx_ledger+ncdex_ledger
	--into #net from tbl_rms_collection_cli R with (nolock)

	select cltcode,balance,MTFLEDBAL, other=balance-MTFLEDBAL 
	into #bobal
	from tbl_ledger_All_Risk T with (nolock) inner join #ledger L with (nolock)
	on T.cltcode=L.party_code 
	--where T.cltcode='M12122'

	update #bobal set other=0.00 where other<=0.00
    update #ledger set Other_Segment_Cr=b.other from #bobal b 
	where #ledger.party_code=b.cltcode
	

	update #ledger set Final_bal=case when Other_Segment_Cr>0.00 then MTFLEDBAL+Other_Segment_Cr  
									  when Other_Segment_Cr<=0.00 then MTFLEDBAL else MTFLEDBAL end

   
 
	truncate table tbl_MTF_Shortage
	insert into tbl_MTF_Shortage
	select party_code,MTFLEDBAL,openday,Noofdays=0,Other_Segment_Cr,Final_bal  from #ledger

	select psrno =dense_rank() over(order by T.party_code ),
	sqoffsseg=row_number() over(partition by T.party_code order by T.sett_no asc)  ,
	T.*
	into #holding1
	from tbl_MTFHolding_Sqoff T inner join  tbl_MTF_Shortage T1
	on T.party_code=t1.party_code where T.OPENDAY>90      
  
	SELECT ID = ROW_NUMBER() OVER(ORDER BY PARTY_CODE),        
	DENSEID = DENSE_RANK() OVER(ORDER BY PARTY_CODE),*,NET_DEBIT=CONVERT(DECIMAL(18,2),0),        
	NET_DEBIT_ADJ=CONVERT(DECIMAL(18,2),0),SqQty=CONVERT(INT,0),CashSqup=CONVERT(DECIMAL(18,2),0),        
	Shortage=CONVERT(DECIMAL(18,2),0) INTO #CASHLOOP 
	FROM #holding1

	UPDATE #CASHLOOP        
	SET NET_DEBIT = B.Final_bal ,        
	NET_DEBIT_ADJ = B.Final_bal
	FROM #CASHLOOP A        
	INNER JOIN tbl_MTF_Shortage B ON A.party_code = B.party_code 
	 
	delete from #CASHLOOP where  CL_RATE=0      

	UPDATE #CASHLOOP        
	SET NET_DEBIT_ADJ = 0,DENSEID = 0        
	WHERE ID NOT IN(SELECT MIN(ID) FROM #CASHLOOP  GROUP BY PARTY_CODE)

	select ID = ROW_NUMBER() OVER(partition BY PARTY_CODE order by sett_no asc),        
	DENSEID = DENSE_RANK() OVER(ORDER BY PARTY_CODE),
	party_code,isin,scrip_cd,series,qty,cl_rate,total=Qty*Cl_rate,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ,SqQty,CashSqup into #CASHLOOP1
	from #CASHLOOP  

	;WITH Hold_CTE AS (  
	SELECT   
	ID,DENSEID,party_code,isin,scrip_cd,series,qty,Cl_rate,total,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ=cast(case when (NET_DEBIT_ADJ*-1)>=total then ((NET_DEBIT_ADJ*-1)-total) else 0 end as money),
	SqQty,CashSqup=cast(case when (NET_DEBIT_ADJ*-1)>=total then total else NET_DEBIT_ADJ*-1 end as money) 
	FROM #CASHLOOP1 e where  --party_code='M165956' and 
	id=1  
	UNION ALL  
	SELECT   
	e.ID,DENSEID,e.party_code,isin,scrip_cd,series,qty,Cl_rate,total,exchange,sett_no,NET_DEBIT,        
	NET_DEBIT_ADJ=cast(case when (ecte.NET_DEBIT_ADJ)>=e.total then ((ecte.NET_DEBIT_ADJ)-e.total) else 0 end as money),
	SqQty,CashSqup=cast(case when (ecte.NET_DEBIT_ADJ)>=total then total else ecte.NET_DEBIT_ADJ end as money)
	FROM #CASHLOOP1 e   
	INNER JOIN (select id,party_code,NET_DEBIT_ADJ from  Hold_CTE) ecte ON ecte.party_code =e.party_code and e.id=ecte.id+1  -- where e.party_code='M165956'  
	)  
	SELECT * into #sqoff
	FROM Hold_CTE option  (maxrecursion 32767) ; 

	update #sqoff set sqqty= CEILING(convert(money,CashSqup)/convert(money,Cl_rate))        
	
	truncate table tbl_manualsqof_mtf
	insert into tbl_manualsqof_mtf
	select *  from #sqoff where sqqty>0

	truncate table Tbl_MTF_scripwise_data_Manual
	insert into Tbl_MTF_scripwise_data_Manual
	select party_code,isin,scrip_cd,series,qty=sum(qty),cl_rate=max(cl_rate),sqqty=sum(sqqty),
	exchange,Cashsqup=sum(Cashsqup),upd_date=getdate(),'','',''
	from tbl_manualsqof_mtf T with (nolock) 
	group by party_code,isin,scrip_cd,series,exchange

	update Tbl_MTF_scripwise_data_Manual set bsecode=S.BseCode, nsesymbol=S.NseSymbol
	from scrip_master S with (nolock) where Tbl_MTF_scripwise_data_Manual.isin=S.isin

	update Tbl_MTF_scripwise_data_Manual  set EXCHANGE_NEW=(case when  C.BSECM='Y' and C.NSECM='N' and ISNULL(BSECODE,'')<>'' then 'BSECM'
											 when   C.BSECM='N' and C.NSECM='Y' and ISNULL(NSESYMBOL,'')<>'' then 'NSECM'
											 when  (C.BSECM='Y'  and C.NSECM='Y') then EXCHANGE
										--	 when  (C.BSECM='Y'  and C.NSECM='Y') then EXCHANGE
											 else '' end)
	from Tbl_MTF_scripwise_data_Manual T inner join client_details C with (nolock) 
	on T.party_code=C.party_code

	delete T from Tbl_MTF_scripwise_data_Manual T inner join client_details C with (nolock) 
	on T.party_code=C.party_code WHERE bsecm='N' and nsecm='N'

	truncate table tbl_MTF_Shortage_Finaldata_90days
	insert into tbl_MTF_Shortage_Finaldata_90days
    select T1.party_code,T1.openday,T1.Final_bal,T2.sqoff_value,bsecm,nsecm, V.Cli_Type,upd_days=getdate()  
	--into tbl_MTF_Shortage_Finaldata_90days
	from tbl_MTF_Shortage T1 with (nolock) 
	inner join 
	(
	select  party_code,sqoff_value=sum(Cashsqup) from Tbl_MTF_scripwise_data_Manual 
	with (nolock) group by party_code
	)T2 
	on	T1.party_code=T2.party_code
	left outer join  client_details C with (nolock)
	on T1.party_code=C.party_code
	left outer join  Vw_RMS_Client_Vertical V with (nolock) 
	on T1.party_code=V.client


END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_MTFData_query_dp_BO
-- --------------------------------------------------

  

  

--exec Usp_MTFData_query_dp_BO  

CREATE Proc [dbo].[Usp_MTFData_query_dp_BO]  

AS  

BEGIN  

  

 select *  

 into #sett12  

 from [AngelDemat].[msajag].dbo.sett_mst where Start_date < Convert(varchar(11),GETDATE(),120) and  Sec_Payin>= Convert(varchar(11),GETDATE(),120)  

 and Sett_Type in ('M','Z')  

   

 declare @maxDate datetime  

 Declare @Vardate datetime  

 Select @Vardate= max(Start_date)  from #sett12  

 

 select * into #VARDETAIL from AngelNSECM.msajag.dbo.VARDETAIL where DetailKey=replace(convert(varchar, @Vardate, 103),'/','')  

  

 select distinct SCRIP_CD,ISIN,CL_RATE into #tbl_closing_mtm from AngelNSECM.msajag.dbo.closing_mtm  

 where cast(sysdate as date)= (select max(sysdate)  from AngelNSECM.msajag.dbo.closing_mtm)  

 

 select a.Party_Code,a.scrip_cd,a.isin,a.Qty,a.accno,b.VarMarginRate,b.AppVar  

 into #var_deltrans  

 from general.dbo.rms_holding a left join #VARDETAIL b on  

 a.isin=b.IsIN  

 where a.accno in ('1203320030135829') --and DrCr='D' and Filler2='1'   and Delivered='0'  --3 58 973  

  

  

 select a.*,b.CL_RATE  

 into #closing_2_deltrans  

 from #var_deltrans a left join #tbl_closing_mtm b on  

 a.isin=b.IsIN  

  

 select a.*,b.[Angel scrip category],b.[BSE_VAR %],b.[NSE_VAR %],b.[ANGEL_VAR %]  

 into #final_data  

 from #closing_2_deltrans a left join general.dbo.TBL_NRMS_RESTRICTED_SCRIPS b  

 on a. isin =b.[ISIN No]  

  

 select Party_Code,scrip_cd,isin,sum (Qty) as Qty,accno,VarMarginRate,AppVar,CL_RATE,[Angel scrip category],[BSE_VAR %],[NSE_VAR %],[ANGEL_VAR %]  

 into #final_value1 from #final_data  

 group by Party_Code,scrip_cd,isin,accno,VarMarginRate,AppVar,CL_RATE,[Angel scrip category],[BSE_VAR %],[NSE_VAR %],[ANGEL_VAR %]  

  

 update #final_value1  

 set VarMarginRate='100.00'  

 where [Angel scrip category]='Poor'  

  

 update #final_value1  

 set VarMarginRate='20.00'  

 where VarMarginRate <=20  

  

 select *,Qty*CL_RATE as total_value, (Qty*CL_RATE)*VarMarginRate/100 as haircut_value,(Qty*CL_RATE)-((Qty*CL_RATE)*VarMarginRate/100) as final_value 

 into #tbl_final_data

 from #final_value1  

  

 select Party_Code,sum (final_value) as final_value  from #tbl_final_data group by Party_Code   

  

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_NRI_DEBT_CRED_RPT
-- --------------------------------------------------

--// DESCRIPTION :- TO FETCH NRI CLIENTS DEBT_CRED_LEDGER_DATA
--// CREATED BY  :- HRISHI ON 07 FEB 2025

CREATE PROC USP_NRI_DEBT_CRED_RPT
AS
BEGIN

IF OBJECT_ID(N'TEMPDB..#NRICODE') IS NOT NULL
DROP TABLE #NRICODE
SELECT CL_CODE,BANK_NAME,BRANCH_NAME,AC_TYPE,AC_NUM,BRANCH_CD,SUB_BROKER,LONG_NAME INTO #NRICODE FROM ANGELNSECM.MSAJAG.DBO.CLIENT_DETAILS WHERE CL_TYPE='NRI' --AND CL_CODE='ZR1009N' --2634

IF OBJECT_ID(N'TEMPDB..#B2B_B2C') IS NOT NULL
DROP TABLE #B2B_B2C
SELECT B.CL_CODE,(CASE WHEN B.B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C INTO #B2B_B2C FROM #NRICODE N LEFT JOIN [INTRANET].RISK.DBO.CLIENT_DETAILS B ON B.CL_CODE=N.CL_CODE --2634

IF OBJECT_ID(N'TEMPDB..#CB_DATA') IS NOT NULL
DROP TABLE #CB_DATA
SELECT DISTINCT (N.CL_CODE),MIN(ACTIVE_DATE)AS ACTIVE_DATE,MAX(INACTIVE_FROM)AS INACTIVE_FROM, N.BANK_NAME, N.BRANCH_NAME, N.AC_TYPE, N.AC_NUM,N.BRANCH_CD,N.SUB_BROKER,N.LONG_NAME
INTO #CB_DATA
FROM ANGELNSECM.MSAJAG.DBO.CLIENT_BROK_DETAILS CB RIGHT JOIN #NRICODE N ON CB.CL_CODE=N.CL_CODE
GROUP BY N.CL_CODE, N.BANK_NAME, N.BRANCH_NAME, N.AC_TYPE, N.AC_NUM,N.BRANCH_CD,N.SUB_BROKER,N.LONG_NAME


IF OBJECT_ID(N'TEMPDB..#LEDGER_DATA') IS NOT NULL
DROP TABLE #LEDGER_DATA
SELECT * INTO #LEDGER_DATA FROM GENERAL.DBO.RMS_DTCLFI (NOLOCK) WHERE PARTY_CODE IN (SELECT CL_CODE FROM #NRICODE) --2592

IF OBJECT_ID(N'TEMPDB..#MAIN_DATA') IS NOT NULL
DROP TABLE #MAIN_DATA
SELECT CONVERT(DATE,RMS_DATE) AS RMS_DATE,PARTY_CODE,SUM(LEDGER) AS LEDGER
INTO #MAIN_DATA
FROM #LEDGER_DATA
--WHERE PARTY_CODE ='ZR1009N'
GROUP BY CONVERT(DATE,RMS_DATE),PARTY_CODE --1271

SELECT C.CL_CODE, B.B2B_B2C, C.LONG_NAME, C.BRANCH_CD, C.SUB_BROKER, C.INACTIVE_FROM,  C.ACTIVE_DATE, CASE WHEN INACTIVE_FROM>=GETDATE() THEN 'ACTIVE' ELSE 'INACTIVE' END AS STATUS,
C.BANK_NAME, C.BRANCH_NAME, C.AC_TYPE, C.AC_NUM, M.LEDGER
FROM #CB_DATA C LEFT JOIN #MAIN_DATA M ON C.CL_CODE=M.PARTY_CODE 
LEFT JOIN #B2B_B2C B ON B.CL_CODE=C.CL_CODE

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_omnytradefiles_uploadjob
-- --------------------------------------------------
CREATE PROCEDURE usp_omnytradefiles_uploadjob
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @date AS VARCHAR(10) = CONVERT(VARCHAR(10), GETDATE(), 103); -- dd/mm/yyyy format for current date
    DECLARE @cnt AS INT = 1;
    DECLARE @FileName VARCHAR(100),   
            @Server VARCHAR(20);

    WHILE (@cnt <= 13)
    BEGIN
        IF (@cnt = 5)
        BEGIN
            SET @cnt = @cnt + 2;
        END
        IF (@cnt = 10)
        BEGIN
            SET @cnt = @cnt + 1;
        END

        IF (@cnt = 1)
        BEGIN
            SET @FileName = @date + '\Trades-' + @date + '.txt';
        END
        ELSE
        BEGIN
            SET @FileName = @date + '\Trades-' + CAST(@cnt AS VARCHAR(5)) + '-' + @date + '.txt';
        END

        SET @Server = 'Server' + CAST(@cnt AS VARCHAR(5));

        BEGIN TRY
            IF EXISTS (SELECT 1 FROM tbl_omnestrdfileStatus WHERE uploadStatus = 'Upload')
            BEGIN
                SELECT 'Another Tradefile is already being uploaded. Please try again later.' AS Message;
                RETURN;
            END

            UPDATE tbl_omnestrdfileStatus
            SET uploadStatus = 'Upload', updateddate = GETDATE();

            TRUNCATE TABLE tbl_OmnTradeFile_Temp;

            DECLARE @filePath VARCHAR(500) = '\\INHOUSELIVEAPP1-FS.angelone.in\upload1\OmnyTradeFileUpload\' + @FileName;
            DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_OmnTradeFile_Temp FROM ''' + @filePath + ''' WITH (FIELDTERMINATOR ='','', ROWTERMINATOR = ''\n'', FirstRow = 2)';
            EXEC(@sql);

            IF EXISTS (SELECT 1 FROM tbl_omni_tradeFileupload WHERE file_ = @FileName AND status_ = 'success')
            BEGIN
                UPDATE tbl_omnestrdfileStatus
                SET uploadStatus = 'Success';

                SELECT 'File already uploaded.' AS Message;
                RETURN;
            END

            DECLARE @rwcnt AS INT;
            DECLARE @sernum AS INT = RIGHT(@Server, 1);
            SELECT @rwcnt = COUNT(1)
            FROM (
                SELECT TOP 10 Accountid
                FROM tbl_OmnTradeFile_Temp
            ) a
            INNER JOIN [10.253.33.65].[uploader-db-amx].dbo.tbl_usermasterinfo b WITH (NOLOCK) ON a.AccountId COLLATE SQL_Latin1_General_CP1_CI_AS = b.Accountid
            WHERE RIGHT(OmneManagerId, 1) = @sernum;

            IF (@rwcnt < 1)
            BEGIN
                INSERT INTO tbl_omni_tradeFileupload (server_, status_, Remark_, file_)
                VALUES (@Server, 'error', 'Wrong server selected for file', @FileName);

                SELECT 'Please select proper Server.' AS Message;
                RETURN;
            END

            IF EXISTS (SELECT TOP 1 1 FROM tbl_OmnTradeFile_Temp WHERE ISDATE(tradedate) = 0 OR LEFT(CONVERT(DATETIME, tradedate), 11) = 'Jan  1 1900')
            BEGIN
                SELECT 'Invalid file format - Date/Time column mismatch.' AS Message;
                RETURN;
            END

            DECLARE @tmptradedate VARCHAR(12), @tradedate VARCHAR(12);
            SELECT TOP 1 @tradedate = tradedate FROM tbl_OmnTradeFile;
            SELECT TOP 1 @tmptradedate = CONVERT(DATETIME, tradedate) FROM tbl_OmnTradeFile_Temp;

            IF (@tradedate != @tmptradedate)
            BEGIN
                INSERT INTO tbl_OmnTradeFile_Hist
                SELECT *, GETDATE() FROM tbl_OmnTradeFile;

                INSERT INTO tbl_OmnTradeFile_Hist_arq
                SELECT *, GETDATE() FROM tbl_OmnTradeFile_arq;

                TRUNCATE TABLE tbl_OmnTradeFile;

                TRUNCATE TABLE tbl_OmnTradeFile_arq;
            END

            INSERT INTO tbl_OmnTradeFile
            SELECT * FROM tbl_OmnTradeFile_Temp;

            DECLARE @count AS INT;
            INSERT INTO tbl_OmnTradeFile_arq
            SELECT DISTINCT * FROM tbl_OmnTradeFile_Temp WHERE Exchange IN ('NSE', 'BSE');

            SELECT @count = @@ROWCOUNT;

            INSERT INTO tbl_omni_tradeFileupload (server_, status_, Remark_, file_)
            VALUES (@Server, 'success', CAST(@count AS VARCHAR) + ' rows uploaded', @FileName);

            UPDATE tbl_omnestrdfileStatus
            SET uploadStatus = 'Success', updateddate = GETDATE();

            SELECT 'File uploaded successfully.' AS Message;
        END TRY
        BEGIN CATCH
            INSERT INTO tbl_omnytrdfileException ([Filename], Remark)
            VALUES (@FileName, ERROR_MESSAGE());

            DECLARE @bodymsg AS VARCHAR(MAX) = ERROR_MESSAGE();

            EXEC msdb.dbo.sp_send_dbmail
                @profile_name = 'AngelBroking',
                @recipients = 'pramod.jadhav@angelbroking.com;tushar.jorigal@angelbroking.com;upload-trade-order-fi-aaaagqxkoxqqghhl2kadhkl2oe@angelbroking.slack.com;dp-posttrade-success-aaaag53dq4ufn6zozkgyp2rgdi@angelbroking.slack.com',
                @blind_copy_recipients = 'Leon.vaz@angelbroking.com;Rahul.shah@angelbroking.com',
                @subject = 'Test - Omny Tradefile upload Error',
                @body = @bodymsg,
                @body_format = 'HTML';

            SELECT 'Error occurred in bulk insert.' AS Message;
        END CATCH

        SET @cnt = @cnt + 1;
    END
END;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_proj_risk_squareOff_t2_day_process_morn_bkup_24012024
-- --------------------------------------------------



-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****** object:  storedprocedure [dbo].[squareup_updation]    script date: 02/08/2017 10:37:31 ******/
create  proc [dbo].[usp_proj_risk_squareOff_t2_day_process_morn_bkup_24012024]            
as            
set nocount on                              
set xact_abort on                                 
begin try   

--IF ((DATEPART(DW,GETDATE()) >1 or DATEPART(DW,GETDATE()) <= 6) and DATEPART(HH,GETDATE())>=5)     
--begin  
--	delete from tbl_Process_log_NRMS where cast(log_date as date)=cast(getdate() as date)
--	insert into tbl_Process_log_NRMS
--	select getdate(),'Combined_Squared_Off_Report','BOD',getdate(),'','Started'
--end

 delete from squareup_client_t2_day_hist            
 where updt = (select max(updt) from tbl_projrisk_t2day_data with(nolock))            
             
 delete from squareup_cash_t2_day_hist            
 where updt = (select max(updt) from tbl_projrisk_scripwise_t2day_data with(nolock))            
                          
 insert into squareup_client_t2_day_hist (party_code,net_debit,proj_risk,cash_sqaureup,squareupavailable,exemption,remarks,act_cash_squareup,
 mobile_pager,email,updt,sq_off_type,net_bal,var_margin_shortage)            
 select party_code, net_debit, proj_risk,cash_sqaureup,squareupavailable,            
 exemption, remarks, act_cash_squareup, mobile_pager, email, updt,sq_off_type,net_bal,var_margin_shortage            
 from tbl_projrisk_t2day_data with(nolock)
 
 insert into squareup_cash_t2_day_hist (psrno,sqoffsseg,exchange,sett_no,scrip_cd,series,party_code,qty,clsrate,haircut,scripcat,source,squareoffqty,sqoffseq,adjamt,isin,actualsqoffqty,avgrate,shortagereduction,shortage,updt)            
 select psrno,sqoffsseg,exchange,sett_no,scrip_cd,series,party_code,qty,clsrate,haircut,scripcat,source,
 squareoffqty,sqoffseq,adjamt,isin,actualsqoffqty,avgrate,shortagereduction,shortage,updt          
 from tbl_projrisk_scripwise_t2day_data with(nolock)            
            
              
 truncate table tbl_projrisk_t2day_data            
 truncate table tbl_projrisk_scripwise_t2day_data            
          
 create table #temp         
(        
 idno int identity(1,1) not null,        
 sb_code varchar(10),        
 cli_type varchar(5),        
 party_code varchar(10),        
 net_debit money default((0)),        
 pure_risk money default((0)),        
 proj_risk money default((0)),        
 proj_adj money default((0)),   
 dp_adj  money default((0)),     
 sb_cr_adjust money default((0)),        
 cash_sqaureup money default((0)),        
 lastbilldate datetime default(('1900-01-01')),        
 sq_off_type varchar(25),
 var_margin_shortage money
)         

/*-----dp holding whose dp poa is active----*/      
select a.party_code,isin,      
scrip_cd=(case when exchange='nsecm' then a.dummy1 else scrip_cd end),      
series,qty as actqty,clsrate,total,exchange,      
scripcategory=case when rtrim(nse_approved) = 'bluechip' then 4      
    when rtrim(nse_approved) = 'good' then 3      
    when rtrim(nse_approved) = 'average' then 2      
    when rtrim(nse_approved) = 'poor' then 1      
    else 0 end,      
source--,a.sett_no      
into #netoff_dp      
from (
	select op.party_code,isin,series=max(series),nse_approved,max(isnull(dummy1,'')) as dummy1,scrip_cd=max(scrip_cd),      
	exchange,qty=sum(qty),clsrate,total=sum(total),source,sett_no=max(case when qty > 0 then sett_no else '' end)      
	from rms_holding op with (nolock)       
	join tbl_newpoa poa with (nolock)       
	on poa.party_code = op.party_code      
	where isnull(op.source,'') ='dp'  
	and op.qty>0      
	and op.nse_approved in ('bluechip','good','average')   /* added on 27-08-2015 as instructed by vishal g. */      
	group by op.party_code,isin,nse_approved,scrip_cd,exchange,clsrate,source/*,sett_no*/
) a
 
      
truncate table tbl_newpoa_active_squareup      
      
insert into tbl_newpoa_active_squareup    
select party_code,[new_poa]='active',sum(total)  as holding from #netoff_dp  group by party_code
          
select client,cli_type,sb            
into #client            
from vw_rms_client_vertical with(nolock)            
where ((cli_type='b2c')            
or (cli_type='b2b' )) --and client='p154302'

insert into #temp (sb_code,cli_type,party_code,net_debit,pure_risk, proj_risk,proj_adj,lastbilldate,sq_off_type)        
select sb,cli_type,cltcode,net_debit=c.ledger_bo,pure_risk=0.00,proj_risk, c.proj_risk proj_adj, isnull(lb.lasttradeddate,'1900-01-01'),cli_type        
from Tbl_BOD_Projrisk_data c with(nolock)  inner join ---changed on 12 Feb 2019 from tbl_rms_collection_cli_abl to tbl_rms_collection_cli
(select party_code,squareupavailable from tbl_projrisk_t1day_data where  updt=(select max(updt) from tbl_projrisk_t1day_data )union   select party_code,squareupavailable='Y' from All_Squareoff_Exception_Marking_Mail	where Square_Off_Type='t+2 day proj')a  
on c.cltcode = a.party_code        
inner join #client v with(nolock) on c.cltcode=v.client  
left join 
(select party_code, lasttradeddate=max(lastbilldate) from rms_dtclfi with(nolock) 
where   co_code in ('bsecm','nsecm','nsefo','mcd','nsx','mcx','ncdex') 
group by party_code) lb        
on v.client = lb.party_code        
where a.squareupavailable = 'y'  and
c.proj_risk < 0 --and  c.Ledger_BO<0 


--------------------------------------------------------Corporate VAlues added on 26 Dec 2018-------------------------------------------------------

/*Commented on April 02  as required by vishal gohil*/
--update C set net_debit=isnull(net_debit,0)+isnull(Amount,0)  from #temp c join tbl_CorporateAction_Data t on c.party_code= t.PARTY_CODE 

/*Added  on April 02  as required by vishal gohil*/
update C set proj_risk=isnull(proj_risk,0)+isnull(Amount,0)  from #temp c join tbl_CorporateAction_Data t on c.party_code= t.PARTY_CODE 
-------------------------------------------------------End here-------------------------------------------------------------------------------------

/*Other Segment Credit Adjustment*/
/*
SELECT VC.party_code,       
       CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) AS RMSDate1,       
       BROKING_NET_LEDGER=Sum(VC.ledger),       
       TOTAL_COLLATERAL_AFTER_HC=Sum(VC.noncash_colleteral),       
       NET_COLLECTION=Sum(VC.brk_net),  
       Margin=sum(Imargin)       
INTO  #Other_seg_Credit
FROM  dbo.vw_rmsdtclfi_collection VC   inner join #temp C on VC.party_code=C.party_code     
WHERE   --VC.party_code='N39099' and   
          (vc.co_code = 'mcx'       
          OR vc.co_code = 'ncdex'       
           )      
GROUP  BY VC.party_code,       
          CONVERT(DATETIME, CONVERT(VARCHAR(11), vc.rms_date)) 

SELECT A.party_code,       
       A.rmsdate1,       
       Isnull(A.broking_net_ledger, 0.0)        AS BROKING_NET_LEDGER,       
       Isnull(A.total_collateral_after_hc, 0.0) AS TOTAL_COLLATERAL_AFTER_HC,       
       /* Isnull(B.net_collection, 0.0)            AS NET_COLLECTION */  
       (case when A.net_collection<0 then 0 else Isnull(A.net_collection, 0.0) end) AS NET_COLLECTION ,A.margin as margin,  
       (case when A.broking_net_ledger<0 then ((A.broking_net_ledger-A.margin)+A.total_collateral_after_hc)   
       else ((A.broking_net_ledger-A.margin)+A.total_collateral_after_hc)end)   as net_shortage   
             
INTO   #Temp_final       
FROM   #Other_seg_Credit A  inner join #temp C on A.party_code=C.party_code      

Update #temp  set proj_risk=proj_risk+net_collection from
(select party_code,net_collection from #Temp_final where net_collection>0.00)T  
where  #temp.party_code=T.party_code

*/
delete from #temp where proj_risk>=0.00

 /*dp holding adjustement added on May 28 2018 */       
 /*
 update #temp set dp_adj=t.dp_adj_holding from tbl_projrisk_afterdpdj t where #temp.party_code=t.party_code
 and  t.dp_adj_holding>0.00

 update #temp  set proj_risk=(case when b.dp_adj_holding+#temp.proj_risk>0.00 then 0.00 else b.dp_adj_holding+#temp.proj_risk end)
 from tbl_projrisk_afterdpdj b where #temp.party_code in(select party_code from tbl_projrisk_afterdpdj where dp_adj_holding>0.00) and #temp.party_code=b.party_code--24877
 */      
 create nonclustered index ix_party_code on #temp(party_code)            
 create nonclustered index ix_idno on #temp(idno)            
             
 /*remove exceptional clients from the list*/            
 --------------------------------------------  
 delete #temp            
 from #temp            
 inner join vw_rms_client_vertical c with(nolock) on #temp.party_code = c.client            
 inner join squareup_exception e with(nolock) on e.accesslevel = 'branch' and c.branch = e.accesscode and #temp.sq_off_type = e.sq_off_type            
 and e.status = 'y'            
 and ( (validfrom <= convert(datetime, convert(varchar(12), getdate()))            
 and validto >= convert(datetime, convert(varchar(12), getdate()))))
           
 delete a            
 from #temp a            
 inner join squp_t_block_client c with(nolock) on a.party_code = c.accesscode            
             
 delete from #temp            
 where 
 /*Added by Abha on 16 jan 2020 as required by Vishal G*/
 party_code in (select party_code from client_details a where a.nbfc_cli = 'y') --remove nbfc clients.            
 or party_code in (select distinct cl_code from bannedpanno with(nolock)) --remove banned panno clients from the list.            
 or party_code in (select distinct party_code from sebibanpano with(nolock))            
 or party_code in (select party_code from legalblkclients with(nolock))            
             
 delete #temp            
 from #temp            
 inner join vw_rms_client_vertical c with(nolock) on #temp.party_code = c.client            
 inner join squareup_exception e with(nolock) on e.accesslevel = 'sb' and c.sb = e.accesscode 
 and #temp.sq_off_type = e.sq_off_type            
 and e.status = 'y'            
 and (validfrom is null or (validfrom <= convert(datetime, convert(varchar(12), getdate()))            
 and validto >= convert(datetime, convert(varchar(12), getdate()))))            
             
 delete #temp            
 from #temp            
 inner join squareup_exception e with(nolock) on e.accesslevel = 'client' and #temp.party_code = e.accesscode          
 and e.status = 'y'            
 and (validfrom is null or (validfrom <= convert(datetime, convert(varchar(12), getdate()))            
 and validto >= convert(datetime, convert(varchar(12), getdate()))))            
              
             
 select a.party_code,isin,            
 scrip_cd=(case when exchange='nsecm' then a.dummy1 else scrip_cd end),            
 series,qty as actqty,clsrate,total,exchange,            
 scripcategory=case when rtrim(nse_approved) = 'bluechip' then 4            
  when rtrim(nse_approved) = 'good' then 3            
  when rtrim(nse_approved) = 'average' then 2            
  when rtrim(nse_approved) = 'poor' then 1            
  else 0 end,            
 source--,a.sett_no            
 into #netoff            
 from (select party_code,isin,series=max(series),nse_approved,max(isnull(dummy1,'')) as dummy1,scrip_cd=max(scrip_cd),            
 exchange,qty=sum(qty),clsrate,total=sum(total),source='h',sett_no=max(case when qty > 0 then sett_no else '' end)            
 from rms_holding with (nolock)            
 where party_code in(select party_code from #temp)            
 and source in ('h','d','si')            
 group by party_code,isin,nse_approved,scrip_cd,exchange,clsrate/*,sett_no*/) a,            
 scripcategory_master c            
 where upper(a.nse_approved)=upper(c.categoryname)            
 and qty>0            
             
 union            
             
 select a.party_code,            
 a.isin,a.scrip_cd,a.series,            
 a.actqty+isnull(b.qty,0)+isnull(c.qty,0) as actqty,a.clsrate,a.clsrate*(a.actqty+isnull(b.qty,0)+isnull(c.qty,0)) as total,            
 a.exchange,            
 scripcategory=case when rtrim(a.scripcategory) = 'bluechip' then 4            
  when rtrim(a.scripcategory) = 'good' then 3            
  when rtrim(a.scripcategory) = 'average' then 2            
  when rtrim(a.scripcategory) = 'poor' then 1            
  else 0 end ,            
 a.source            
 from            
 (            
  select             
  a.party_code,a.isin,a.scrip_cd,a.series,isnull(b.status,'poor') as scripcategory,exchange=co_code,            
  qty as actqty,cl_rate as clsrate,amount as total,'c' as source,isnull(b.srno,9) as srno,seqflag            
  from            
  (            
  select party_code,isin,scrip_cd,series,qty,cl_rate,amount,co_code,            
  (case when co_code='nsefo' then 1 when co_code='mcd' then 2 when co_code='nsx' then 3 when co_code='mcx' then 4 when co_code='ncdex' then 5 else 9 end) as seqflag            
  from client_collaterals a where party_code in(select party_code from #temp)            
  and cash_ncash='n'            
  and co_code in ('mcd','nsx','nsefo','mcx','ncdex')            
  ) a left join scrip_master_intstatus b on a.isin=b.isin            
 ) a            
 left join             
 (            
 select isin,party_code,sum(qty) as qty from rms_holding with (nolock)            
 where party_code in(select party_code from #temp)            
 and source='si'            
 group by isin,party_code having sum(qty) < 0            
 ) b            
 on a.party_code=b.party_code and a.isin=b.isin            
 left join             
 (            
 select isin,partycode,sum(netqty) as qty from miles_stockholdingdata with (nolock)            
 where partycode in(select party_code from #temp)            
 group by isin,partycode having sum(netqty) < 0            
 )c            
 on a.party_code = c.partycode and a.isin = c.isin            
 where a.actqty+isnull(b.qty,0)+isnull(c.qty,0) > 0            
 order by source desc, scripcategory            
             
 select distinct vrh.isin, vrh.scrip_cd as [scrip code],            
     vrh.nse_approved,            
     [exchange var %]= case when 'nsecm' = 'bsecm' then isnull(convert(decimal(15, 2), svm.bse_var), 0.00)            
      else isnull(convert(decimal(15, 2), svm.nse_var), 0.00) end,            
     [angel var %]= convert(decimal(15, 2), isnull(angel_var, 0)),            
     [final var %]=case when 'nsecm' = 'bsecm' then isnull(convert(decimal(15, 2), svm.bse_final_var), 0.00)            
         else isnull(convert(decimal(15, 2), svm.nse_final_var), 0.00) end,            
     [haircut %]=case when 'nsecm' = 'bsecm' then isnull(convert(decimal(15, 2), svm.bse_proj_var), 0.00)            
       else isnull(convert(decimal(15, 2), svm.nse_proj_var), 0.00) end,            
     [hold with hc]= convert(decimal(15, 2), sum(isnull(vrh.total_withhc, 0))),            
     [bse var %]= convert(decimal(15, 2), isnull(svm.bse_var_display, 0)),            
     [nse var %]= convert(decimal(15, 2), isnull(svm.nse_var_display, 0))            
 into   #var            
 from   vw_rms_holding vrh            
     left join scripvar_master svm            
      on vrh.isin = svm.isin            
 where  vrh.isin in (select isin from #netoff)            
 group  by vrh.isin,vrh.scrip_cd,vrh.nse_approved,            
     svm.bse_var,isnull(angel_var, 0),svm.bse_final_var,            
     svm.bse_proj_var,svm.nse_final_var,            
     svm.nse_proj_var,svm.nse_var,            
     svm.bse_proj_var,isnull(svm.bse_var_display, 0),            
     isnull(svm.nse_var_display, 0)  
 
delete from #var where [scrip code]='935752' and isin='INE774D01024'           
             
 update #var            
 set [final var %] = (case when nse_approved ='average'            
     then (case when isnull([exchange var %], 0) <= 30 and isnull([final var %], 0) <= 30            
     then 30 else isnull([final var %], 0) end)            
     else isnull([final var %],0) end)   
					         

update #var        
set    [final var %] = ( case        
                           when nse_approved ='poor' then 100.00     
                           
                           else isnull([final var %], 0)        
                         end )
                                      
 delete a             
 from #temp a            
 join             
 (            
  select distinct sb_credit,tot_clientrisk,sb_crafteradjpurerisk,sub_broker as sb,tot_projrisk              
  from tbl_rms_collection_sb with(nolock)    
  ---changed on 12 Feb 2019 from tbl_rms_collection_sb_abl to tbl_rms_collection_sb         
  where (sb_credit+(tot_clientrisk+tot_projrisk))>=0  and sb_type='b2b'  /*added to handle sb credit for b2c clients for ndd branch*/               
 ) b            
 on a.sb_code = b.sb    
 


/*sb credit adjustment process starts */
/* Changes removal of Sb Credits on 12112019
 Requested by : Vishal Gohil
 Changes done By : Siva Kumar
*/ 
/*sb credit adjustment process starts */            
select top 0  sb,sb_credit=sb_credit,isnull(tot_clientrisk,0) pure_risk,        
sb_credit_after_pr_adjust = sb_crafteradjpurerisk,        
sb_credit_after_adjust = sb_crafteradjpurerisk,        
row_number() over(order by sb) as row_num, tot_projrisk        
into #sb_credit        
from (select distinct sb_credit,tot_clientrisk,sb_crafteradjpurerisk,sub_broker as sb,tot_projrisk  from tbl_rms_collection_sb with(nolock))a  
---changed on 12 Feb 2019 from tbl_rms_collection_sb_abl to tbl_rms_collection_sb       
where sb in         
(        
 select distinct sb_code         
 from #temp         
 where cli_type='b2b'        
)        
and sb_credit+isnull(tot_clientrisk,0) > 0  

--drop table #sb_credit_adj 
--drop table #client_risk 
--drop table #priority 


select  srno=row_number () over (order by sb) ,  sb,sb_credit=sb_credit+pure_risk , balance_credit=convert(money,null) into  #sb_credit_adj from #sb_credit  --where sb in ('vvws','ddah')  
select sb_code ,party_code  ,lastbilldate, proj_risk=(-1)*proj_risk  into  #client_risk from #temp where proj_risk<0.00 and cli_type='b2b'
select *,row=row_number () over ( partition by sb_code order by lastbilldate desc,proj_risk desc),adjrisk =convert(money,null) 
into  #priority from #client_risk --where sb_code in ('vvws','ddah') 

declare @i int =(select max (srno) from #sb_credit_adj )
declare @srno int =1;
while (@i>0)
  begin
       
       declare @sb varchar(10)=null, @credit money=null;
       select @sb=sb,@credit =sb_credit  from #sb_credit_adj where srno =@srno
      
       declare @j int= (select max(row)  from #priority where  sb_code =@sb)
       declare @srno2 int =1;
       while(@j>0 and @credit>0 )
       begin
       declare @partycode varchar(10)=null, @proj_risk money =null;
       select @partycode=party_code,@proj_risk=proj_risk from #priority where  sb_code =@sb and row =@srno2
      
	   update #priority set adjrisk=(case when (@credit -(@proj_risk ))>=0 then @proj_risk 
	                                      when (@credit -(@proj_risk ))<0 then @credit -(@proj_risk ) else 0 end) where row =@srno2 and party_code =@partycode 
	   set @credit=@credit -(@proj_risk )
       
       set @j =@j-1; 
       set @srno2=@srno2 +1;
       end        
       
       if(@credit >=0)
       begin  
       
       update #sb_credit_adj set balance_credit=@credit where  sb=@sb;
       end
       
     set @i =@i-1;
     set @srno =@srno +1; 
  end
  
update  #priority set adjrisk=proj_risk * (-1) where adjrisk is null 

update #temp  set proj_risk=case when convert(decimal(15,2),b.adjrisk)>=0 then 0.00 else b.adjrisk end
from #priority b where #temp.party_code=b.party_code 
and #temp.sb_code=b.sb_code  and 
#temp.party_code in( select party_code from #priority)-- where adjrisk is not null))
and  cli_type='b2b'  

delete from #temp where proj_risk>=0.00
 
update #sb_credit set sb_credit_after_adjust=balance_credit from #sb_credit_adj a where #sb_credit.sb=a.sb 
update #sb_credit set sb_credit_after_adjust=0.00 where sb_credit_after_adjust is null 

update #temp set sb_cr_adjust=p.adjrisk from #priority p where
#temp.sb_code=p.sb_code and #temp.party_code=p.party_code

 /*sb credit adjustmnet ends */

           
 delete from tbl_t1squareoff_sbadjust            
 where updt between convert(varchar(11),getdate(),106) and convert(varchar(11),getdate(),106) + ' 23:59:59'            
             
 insert into tbl_t1squareoff_sbadjust            
 select sb,sb_credit,pure_risk,sb_credit_after_pr_adjust,sb_credit_after_adjust,getdate()            
 from #sb_credit            
         
 delete from tbl_t2_daysquareoff_clsb_adjust            
 where updt between convert(varchar(11),getdate(),106) and convert(varchar(11),getdate(),106) + ' 23:59:59'          
            
 insert into tbl_t2_daysquareoff_clsb_adjust            
 select idno,sb_code,cli_type,party_code,net_debit,pure_risk,proj_risk,sb_cr_adjust,cash_sqaureup,lastbilldate,getdate() as updt             
 from #temp            
                        
 
--/* Added on June 20 2018 as requested by vishal gohil */
--update #temp set proj_risk=(case when T.pure_risk<0 then T.net_debit else #temp.proj_risk end)
--from tbl_rms_collection_cli T with (nolock) where #temp.party_code=T.party_code and   #temp.proj_risk<0.00 
---changed on 12 Feb 2019 from tbl_rms_collection_cli_abl to tbl_rms_collection_cli

 select party_code,isin,            
 scrip_cd=(case when exchange='nsecm' then a.dummy1 else scrip_cd end),            
 series,qty ,clsrate,total,exchange,            
 scripcat =case when rtrim(nse_approved) = 'bluechip' then 4            
  when rtrim(nse_approved) = 'good' then 3            
  when rtrim(nse_approved) = 'average' then 2            
  when rtrim(nse_approved) = 'poor' then 1            
  else 0 end,            
 source--,a.sett_no            
 into #cashtemp            
 from (select party_code,isin,series=max(series),nse_approved,max(isnull(dummy1,'')) as dummy1,scrip_cd=max(scrip_cd),            
 exchange,qty=sum(qty),clsrate,total=sum(total),source='h',sett_no=max(case when qty > 0 then sett_no else '' end)            
 from rms_holding with (nolock)            
 where party_code in(select party_code from #temp)            
 and source in ('h','d','si')     and accno not in ('1203320018512938','1203320000026359','1203320018512904','20131776','1203320018512144','20129509')       
 /*unsettled scrips excluded as per viral's requirement*/            
 --and isnull(accno,'') not in('','unsettled')            
 group by party_code,isin,nse_approved,scrip_cd,exchange,clsrate/*,sett_no*/) a,            
 scripcategory_master c            
 where upper(a.nse_approved)=upper(c.categoryname)            
 --and a.party_code in (select party_code from squareup_client)            
 /* and qty>0 */      
             
 union            
             
 select a.party_code,            
 a.isin,a.scrip_cd,a.series,            
 a.actqty+isnull(b.qty,0)+isnull(c.qty,0) as actqty,a.clsrate,a.clsrate*(a.actqty+isnull(b.qty,0)+isnull(c.qty,0)) as total,            
 a.exchange,            
 scripcategory=case when rtrim(a.scripcategory) = 'bluechip' then 4            
  when rtrim(a.scripcategory) = 'good' then 3            
  when rtrim(a.scripcategory) = 'average' then 2            
  when rtrim(a.scripcategory) = 'poor' then 1            
  else 0 end ,            
 a.source            
 from            
 (            
  select             
  a.party_code,a.isin,a.scrip_cd,a.series,isnull(b.status,'poor') as scripcategory,exchange=co_code,            
  qty as actqty,cl_rate as clsrate,amount as total,'c' as source,isnull(b.srno,9) as srno,seqflag            
  from            
  (            
  select *,            
  (case when co_code='nsefo' then 1 when co_code='mcd' then 2 when co_code='nsx' then 3 when co_code='mcx' then 4 when co_code='ncdex' then 5 else 9 end) as seqflag            
  from client_collaterals a where party_code in(select party_code from #temp)            
  and cash_ncash='n'            
  and co_code in ('mcd','nsx','nsefo','mcx','ncdex')            
  ) a left outer join scrip_master_intstatus b on a.isin=b.isin            
 --where party_code in (select party_code from squareup_client)            
 ) a            
 left outer join             
 (            
 select isin,party_code,sum(qty) as qty from rms_holding with (nolock)            
 where party_code in(select party_code from #temp)  and accno not in ('1203320018512938','1203320000026359','1203320018512904','20131776','1203320018512144','20129509')          
 --and source='si'            
 --and party_code in (select party_code from squareup_client)            
 group by isin,party_code having sum(qty) < 0            
 ) b            
 on a.party_code=b.party_code and a.isin=b.isin            
 left join             
 (            
 select isin,partycode,sum(netqty) as qty from miles_stockholdingdata with (nolock)            
 where partycode in(select party_code from #temp)            
 --and party_code in (select party_code from squareup_client)            
 group by isin,partycode having sum(netqty) < 0            
 )c    
 on a.party_code = c.partycode and a.isin = b.isin            
 where a.actqty+isnull(b.qty,0)+isnull(c.qty,0) > 0   


--delete from  tbl_MarginPledge_Sqoff_Del where cast(upd_date as date)=cast(getdate() as date)
select *,POA_Status=cast('' as varchar(20)) into #rms_holding from rms_holding with(nolock)        
where party_code in(select distinct party_code from #temp)        
and source in ('h','d','si')              

update #rms_holding set POA_Status='Active' where party_code in (select party_code from tbl_newpoa)
update #rms_holding set POA_Status='InActive' where POA_Status=''

 
/*intra segement added on jun 15 2016 */
-------------step1-------------------
select a.party_code,a.qty ,a.isin,a.exchange 
into #t1
from #cashtemp  a inner join
(select party_code,isin,exchange from #cashtemp  
group by party_code,isin,exchange having count(party_code)>1
)b
on a.party_code=b.party_code and a.isin=b.isin and a.exchange=b.exchange

------------step2---------------------------
select distinct a.party_code,a.isin,a.scrip_cd,a.series,0 as qty,a.clsrate,a.total,a.exchange,a.scripcat,a.[source] 
into   #temp_ins
from #cashtemp a 
inner join #t1 b on a.party_code=b.party_code and a.isin=b.isin and a.exchange=b.exchange

------------step3---------------------------
delete a from #cashtemp a 
inner join #t1 b on a.party_code=b.party_code and a.isin=b.isin and a.exchange=b.exchange

------------step4---------------------------
update #temp_ins
set qty=x.qty
from 
(select b.party_code,b.exchange, sum(b.qty) qty from 
#temp_ins a 
 inner join #t1 b on a.party_code=b.party_code and a.isin=b.isin and a.exchange=b.exchange
group by b.exchange, b.party_code
)x where x.party_code=#temp_ins.party_code and x.exchange=#temp_ins.exchange
     
insert into #cashtemp
select * from #temp_ins where qty>0

------------step5---------------------------
select party_code,isin,(qty),exchange into #aa from #cashtemp where qty<0
delete from #cashtemp where qty<0
/*intra segement added on jun 15 2016  end*/ 

/*
update #cashtemp set qty=a.qty+b.qty from #cashtemp a inner join #aa b on a.party_code=b.party_code and a.isin=b.isin --and a.exchange=b.exchange
where a.qty<0
--select a.party_code,a.isin, qty=a.qty+b.qty from #cashtemp a inner join #aa b on a.party_code=b.party_code and a.isin=b.isin --and a.exchange=b.exchange
delete from #cashtemp where qty <0
*/

/*Added to remove reliance isin, as requierd by V Gohil on May 21 2020*/
delete from #cashtemp where isin='INE002A20018'

select a.party_code,a.isin,            
 a.scrip_cd,            
 a.series,a.qty ,a.clsrate,a.total,a.exchange,            
 a.scripcat,            
 a.source,r.sett_no            
 into #cashtemp_final     
 from #cashtemp a left outer join (select party_code, sett_no=max(sett_no),isin,exchange from rms_holding where  accno not in ('unsettled') group by party_code,isin,exchange) r
 on a.party_code=r.party_code and a.isin=r.isin
 and a.exchange=r.exchange --where a.party_code='klgp2607'

 /*Added to set priority of unsetteled holding sq off */
 select  a.party_code,a.isin,            
 scrip_cd=(case when exchange='nsecm' then max(isnull(dummy1,'')) else scrip_cd end),            
 series=max(series),sum(a.qty) as qty ,a.clsrate,SUM(a.total) AS total,a.exchange,            
 case when rtrim(a.nse_approved) = 'bluechip' then 4            
  when rtrim(a.nse_approved) = 'good' then 3            
  when rtrim(a.nse_approved) = 'average' then 2            
  when rtrim(a.nse_approved) = 'poor' then 1            
  else 0 end as scripcat,            
 a.source,max(sett_no) as sett_no  into #unsett from rms_holding a  where accno in ('unsettled')   and source in ('h','d','si')
 group by a.party_code,a.isin, a.scrip_cd,a.clsrate,a.exchange,a.nse_approved,a.source having sum(qty)>0 

 --select * from rms_holding where party_code in (select distinct party_code from #cashtemp) and party_code='S129012' and source<>'DP' and isin='INE050E01027'  order by isin
 /*
update c set c.qty= ( case when c.qty-u.qty >0 then c.qty-u.qty else 0 end) 
from  #cashtemp_final c , #unsett u
where c.party_Code =u.party_Code and c.isin =u.isin 
*/

update c set c.qty= c.qty-u.qty 
from  #cashtemp_final c , #unsett u
where c.party_Code =u.party_Code and c.isin =u.isin and c.source='h'

update u set u.qty= ( case when u.qty+c.qty >0 then u.qty+c.qty else 0 end)
from  #cashtemp_final c , #unsett u
where c.party_Code =u.party_Code and c.isin =u.isin and c.qty<0 

delete from   #cashtemp_final where qty <=0
/* ADDED VALUE OF QTY*/ 
UPDATE #cashtemp_final SET  TOTAL =QTY*CLSRATE  FROM #cashtemp_final WHERE PARTY_CODE IN (SELECT DISTINCT party_Code FROM #unsett )

insert into #cashtemp_final
select party_code,	isin,	scrip_cd	,series	,qty,	clsrate,	total,	exchange,	scripcat,	source,	sett_no+'_u' from #unsett 




 /*Added to set priority of unsetteled holding sq off*/

select id=row_number() over(order by a.party_code asc, sett_no desc ,scripcat asc,b.[haircut %] desc,a.clsrate asc)          
,denseid=dense_rank() over(order by a.party_code)          
,a.party_code,a.isin,a.scrip_cd,a.series,a.qty          
,a.clsrate,a.total,a.exchange,a.scripcat,a.source          
,b.[exchange var %],c.proj_risk          
,b.[haircut %],scrip_shortage=a.total*b.[haircut %]/100,adjval=convert(money,0),bal=convert(money,0)          
,net=convert(money,0),sq_qty=convert(money,0),sett_no          
into #cash_posi_adj          
from #cashtemp_final a          
inner join #temp c with(nolock)   on a.party_code=c.party_code       
inner join #var b with(nolock)         
on  a.isin=b.isin          

create clustered index ix_id on #cash_posi_adj(party_code asc,scripcat asc,[haircut %] desc,clsrate asc,id asc)          

select psrno =dense_rank() over(order by a.party_code ),
sqoffsseg=row_number() over(partition by a.party_code order by a.party_code, sett_no desc,scripcat asc,b.[final var %] desc)  ,
a.*,haircut=[final var %] 
into #holding
from #cash_posi_adj a inner join #temp c with(nolock)   on a.party_code=c.party_code       
left outer join #var b with(nolock)         
on  a.isin=b.isin  
  
select 
psrno,sqoffsseg,exchange,sett_no,scrip_cd,series,party_code,qty,clsrate,
haircut,scripcat,source,squareoffqty=0,sqoffseq=0,adjamt=convert(money,0),isin,actualsqoffqty=0,avgrate=convert(money,0),total,
shortagereduction=(total*haircut/100),shortage=convert(money,0),[holding value after HC]=convert(money,0) 
into #hld
from #holding --where party_code='a88004'
order by psrno,sqoffsseg

update #hld set [holding value after HC]= total-shortagereduction


update #temp set var_margin_shortage=net_debit+total_AHC from 
(
select party_code, total_AHC=sum([holding value after HC]) from #hld group by party_code) 
A where #temp.party_code=A.party_code


--added on April 02 2020 as required by Vishal Gohil
update #temp set var_margin_shortage= case when var_margin_shortage>0.00 then proj_risk else var_margin_shortage end 

/* commented on Mar 17 2020 for negative b.var_margin_shortage issue */
/*
update a set shortage=(b.var_margin_shortage *-1)  from #hld a inner join (select * from #temp with (nolock)) b
on a.party_code=b.party_code  where a.sqoffsseg=1
*/
--  commented on Mar 17 2020 for negative b.var_margin_shortage issue
update a set shortage=(case when b.var_margin_shortage<0 then (b.var_margin_shortage*-1) else b.var_margin_shortage end)  from #hld a inner join (select * from #temp with (nolock)) b
on a.party_code=b.party_code  where a.sqoffsseg=1

--drop table #holdd
  
;with hold_cte as (
select 
psrno,sqoffsseg,exchange,sett_no,scrip_cd,series,party_code,qty,clsrate,haircut,scripcat,source,
squareoffqty,sqoffseq,adjamt,isin,actualsqoffqty,avgrate,
shortagereduction=case when (shortage-shortagereduction)<0 then shortage else shortagereduction end,
shortage=case when (shortage-shortagereduction)<0 then 0 else(shortage-shortagereduction) end from #hld x 
where  sqoffsseg=1
union all
select 
psrno,e.sqoffsseg,exchange,sett_no,scrip_cd,series,e.party_code,qty,clsrate,haircut,scripcat,source,
squareoffqty,sqoffseq,adjamt,isin,actualsqoffqty,avgrate,shortagereduction,
shortage= (ecte.shortage-shortagereduction)
from #hld e inner join (select party_code,sqoffsseg,shortage from  hold_cte) ecte on ecte.party_code = e.party_code and e.sqoffsseg=ecte.sqoffsseg+1 
and ecte.shortage>0
)
select * into #holdd
from hold_cte option  (maxrecursion 32767) ;


update #holdd set shortagereduction=shortagereduction+shortage,shortage=0 where shortage<0 
/*
update a set squareoffqty=(case when convert(int,floor((((shortagereduction*(100/haircut))/clsrate)*clsrate)/clsrate))<=0 then 1 else  
convert(int,floor((((shortagereduction*(100/haircut))/clsrate)*clsrate)/clsrate)) end) from #holdd a where clsrate>0
--update a set squareoffqty=ceiling(((case when shortage=0 then shortagereduction else vahc end)+shortagereduction)/clsrate) from #holdd a where clsrate>0
*/

/*addedd as suggested by vishal gohil on aug 31 2017*/
update a set squareoffqty=ceiling(case when ((shortagereduction/haircut)*100.00)/clsrate <= qty then ((shortagereduction/haircut)*100.00)/clsrate else qty end)
from #holdd a where clsrate>0 and haircut>0.00

update a set adjamt=squareoffqty*clsrate from #holdd a

update a set squareoffqty=b.squareoffqty ,sqoffseq=b.sqoffsseg , adjamt=b.adjamt,
shortagereduction=b.shortagereduction,
shortage=b.shortage
  from #holdd a  inner join 
(select * from #holdd ) b on a.party_code=b.party_code and 
a.sett_no=b.sett_no  and a.isin=b.isin --and a.sett_type=b.sett_type
and a.exchange=b.exchange

update a        
set cash_sqaureup = b.cashsqup        
from #temp a        
inner join (select party_code,sum(squareoffqty*clsrate) cashsqup from #holdd where squareoffqty>0 group by party_code) b        
on a.party_code = b.party_code  

/*  commented on Mar 12 2020 as required by Vishal Gohil
delete from #temp where party_code in (select party_code from squareoff.dbo.mtf_data with (nolock) 
where squareoffvalue>0.00 and  cast(processdate as date)=(select max(processdate) from squareoff.dbo.mtf_data  with (nolock)) and noofdays>=3 )

select party_code into #asb7 from mis.dbo.[vw_regionwise_asb7_data]  with (nolock) 
where cast(rms_date as date)=(select max(rms_date) from mis.dbo.[vw_regionwise_asb7_data]  with (nolock)) and t_day>=5 and abs(t_value) > 650

delete from #asb7 where party_code in (select distinct party_code 
                      from   dbo.vw_clientmargin_campaign with(nolock) 
                      where  is_accepted = 'y') 
                      
delete  from  #temp where party_code in (select distinct party_code from #asb7)   
*/                  
/* commented on May 16 2019 as required by Vishal Gohil

delete from #temp            
where party_code in            
(            
select distinct b.party_code            
from client_details a            
inner join tbl_projrisk_t2day_data b        
on a.cl_code=b.party_code            
where squareupavailable='y'            
and isnull(bsecm,'n')='n'            
and isnull(nsecm,'n')='n'            
and exemption='n'            
)
*/

insert into tbl_projrisk_t2day_data(party_code,net_debit,proj_risk,cash_sqaureup,squareupavailable,exemption,remarks,act_cash_squareup,mobile_pager,email,updt,sq_off_type,net_bal,var_margin_shortage)        
select a.party_code, net_debit, proj_risk,cash_sqaureup,'','','',0.00,'','',convert(varchar(12), getdate()),sq_off_type,0.00,a.var_margin_shortage      
from #temp a        
inner join client_details b with(nolock) on a.party_code=b.cl_code        
where len(pan_gir_no)=10  and proj_risk<0.00 and cash_sqaureup>=1000.00 and cash_sqaureup is not null       

insert into tbl_projrisk_scripwise_t2day_data (psrno,sqoffsseg,exchange,sett_no,scrip_cd,series,party_code,qty,clsrate,haircut,scripcat,source,squareoffqty,sqoffseq,adjamt,isin,actualsqoffqty,avgrate,shortagereduction,shortage,updt)        
select psrno,sqoffsseg,exchange,sett_no=replace(sett_no,'_u','') ,scrip_cd,series,s.party_code,qty,clsrate,haircut,scripcat,source,squareoffqty,sqoffseq,adjamt,isin,actualsqoffqty,avgrate,shortagereduction,shortage,updt=getdate() from #holdd s
inner join #temp a on s.party_code=a.party_code     
inner join client_details b with(nolock) on a.party_code=b.cl_code        
where len(pan_gir_no)=10  and a.proj_risk<0.00    and squareoffqty>0  

/*Added on Jan 16 2020 to reolve codes in file generation*/
select * into #NSECM from tbl_projrisk_scripwise_t2day_data 
where party_code in (select distinct party_code from client_details where NSECM='Y') 
and scrip_cd in (select distinct nsesymbol from scrip_master)
and exchange<>'NSECM'

update tbl_projrisk_scripwise_t2day_data set exchange='NSECM' from #NSECM N 
where tbl_projrisk_scripwise_t2day_data.party_code=N.party_code 
and tbl_projrisk_scripwise_t2day_data.scrip_cd=N.scrip_cd  
and tbl_projrisk_scripwise_t2day_data.isin=N.ISIN and tbl_projrisk_scripwise_t2day_data.exchange<>'NSECM'

select * into #BSECM from tbl_projrisk_scripwise_t2day_data 
where party_code in (select distinct party_code from client_details where BSECM='Y') 
and scrip_cd in (select distinct bsecode from scrip_master)
and exchange<>'BSECM'

update tbl_projrisk_scripwise_t2day_data set exchange='BSECM' from #BSECM N 
where tbl_projrisk_scripwise_t2day_data.party_code=N.party_code 
and tbl_projrisk_scripwise_t2day_data.scrip_cd=N.scrip_cd  
and tbl_projrisk_scripwise_t2day_data.isin=N.ISIN 
and tbl_projrisk_scripwise_t2day_data.exchange<>'NSECM'

select * into #ForcefullyBSECm 
from tbl_projrisk_scripwise_t2day_data 
where party_code in (select distinct party_code from client_details where BSECM='Y' and nsecm='N') 
and scrip_cd in (select distinct nsesymbol from scrip_master)
 
update tbl_projrisk_scripwise_t2day_data set exchange='BSECM' from #ForcefullyBSECm  N 
where tbl_projrisk_scripwise_t2day_data.party_code=N.party_code 
and tbl_projrisk_scripwise_t2day_data.scrip_cd=N.scrip_cd  and tbl_projrisk_scripwise_t2day_data.isin=N.ISIN 

update tbl_projrisk_scripwise_t2day_data set scrip_cd=s.Bsecode 
from #ForcefullyBSECm  N  left outer join scrip_master s on N.isin=S.isin
where tbl_projrisk_scripwise_t2day_data.party_code=N.party_code 
and tbl_projrisk_scripwise_t2day_data.scrip_cd=N.scrip_cd  and tbl_projrisk_scripwise_t2day_data.isin=N.ISIN

select * into #ForcefullyNSECm 
from tbl_projrisk_scripwise_t2day_data 
where party_code in (select distinct party_code from client_details where BSECM='N' and nsecm='Y') 
and scrip_cd in (select distinct bsecode from scrip_master)
 
update tbl_projrisk_scripwise_t2day_data set exchange='NSECM' from #ForcefullyNSECm  N 
where tbl_projrisk_scripwise_t2day_data.party_code=N.party_code 
and tbl_projrisk_scripwise_t2day_data.scrip_cd=N.scrip_cd  and tbl_projrisk_scripwise_t2day_data.isin=N.ISIN 

update tbl_projrisk_scripwise_t2day_data set scrip_cd=s.NSESYMBOL 
from #ForcefullyNSECm  N  left outer join scrip_master s on N.isin=S.isin
where tbl_projrisk_scripwise_t2day_data.party_code=N.party_code 
and tbl_projrisk_scripwise_t2day_data.scrip_cd=N.scrip_cd  
and tbl_projrisk_scripwise_t2day_data.isin=N.ISIN

delete from tbl_projrisk_t2day_data   
where party_code in (select distinct cltcode from tbl_ledger_All_Risk with (nolock) where balance>0.00 )  
  
/*Delete Cusa sq off codes*/
/*
select distinct party_code  into #cusa 
from [INTRANET].CMS.dbo.Cusa_po WITH(NOLOCK) 
where  squareoffqty>0 and Squareoffdate is not NULL

select T1.party_code into #todeletecusa from tbl_projrisk_t2day_data t1 inner join #cusa t2 on t1.party_code=t2.party_code

delete from tbl_projrisk_t2day_data where party_code in (select party_code from #todeletecusa)
*/

/*added to remove ETF codes from risk sq off on Feb 01 2020 as required by NAvnit shah*/
delete from tbl_projrisk_t2day_data where updt = convert(datetime, convert(varchar(12), getdate())) and 
party_code in (select distinct [client code] from tbl_ETF_Codes with (nolock)) and cast(getdate() as date) <='Feb 16 2020'

update tbl_projrisk_t2day_data        
set mobile_pager = ltrim(rtrim(isnull(c.mobile_pager, ''))),        
email = ltrim(rtrim(lower(isnull(c.email,''))))        
from client_details c with(nolock)        
where updt = convert(varchar(12), getdate())        
and c.cl_code = tbl_projrisk_t2day_data.party_code          
        
update tbl_projrisk_t2day_data        
set squareupavailable = 'y'        
where updt = convert(varchar(12), getdate())        
and cash_sqaureup> 0

update tbl_projrisk_t2day_data        
set exemption = 'n'        
where updt = convert(varchar(12), getdate())        
and cash_sqaureup> 0

update APPROVAL_BLK_STATUS SET status='U',pdate=getdate(),update_by='E00229'  
            
--exec upd_squareoff_ageing_buckets
                    
end try                                   
begin catch                                      
            
 insert into eodboddetail_error(errtime,errobject,errline,errmessage)                                            
 select getdate(),'squareup_updation',error_line(),error_message()                                            
            
 declare @errormessage nvarchar(4000);                                          
 select @errormessage = error_message() + convert(varchar(10),error_line());                                          
 raiserror (@errormessage , 16, 1);                
                                   
end catch                         
                    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_pushtradefilestoHist
-- --------------------------------------------------

CREATE PROCEDURE usp_pushtradefilestoHist
AS
BEGIN
    SET NOCOUNT ON;

    -- Move data from tbl_OmnTradeFile to tbl_OmnTradeFile_Hist
    INSERT INTO tbl_OmnTradeFile_Hist                      
    SELECT *, GETDATE() FROM tbl_OmnTradeFile;

    -- Move data from tbl_OmnTradeFile_arq to tbl_OmnTradeFile_Hist_arq
    INSERT INTO tbl_OmnTradeFile_Hist_arq                       
    SELECT *, GETDATE() FROM tbl_OmnTradeFile_arq;

    -- Truncate tbl_OmnTradeFile
    TRUNCATE TABLE tbl_OmnTradeFile;

    -- Truncate tbl_OmnTradeFile_arq
    TRUNCATE TABLE tbl_OmnTradeFile_arq;
    
    -- Optional: Provide a success message
    PRINT 'Data moved to history tables and original tables truncated successfully.';
END;

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_risk_data_bkup_03082023
-- --------------------------------------------------



CREATE proc [dbo].[usp_risk_data_bkup_03082023]
as
begin
	select * ,Net_Avail_after_DP=convert(money,0.00) into #temp 
	from tbl_RMS_Collection_Cli with (nolock)   
  
	select v.sb,party_code,DP_holding=convert(money,sum(total))  into #poa_holding   
	from rms_holding r  iNNER JOIN vw_rms_vertical v WITH (nolock) on r.party_code=v.client   
	where party_code in (select distinct party_code from Tbl_NewPOA) and exchange='POA'  
	group by v.sb,party_code  

	create clustered index idx_pc on #temp(party_code) 
  	create clustered index idx_pc on #poa_holding(party_code) 

	update #temp set Net_Avail_after_DP =Net_Available+ DP_holding from  #poa_holding P where #temp.party_code=P.party_code   
	update #temp set Net_Avail_after_DP =Net_Available  where Net_Avail_after_DP=0.00  

	truncate table tbl_clientcsv_data
	insert into tbl_clientcsv_data
	select *,Upd_date=GETDATE()  from #temp

End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_TOP25_SEBI_PAYOUT_RPT
-- --------------------------------------------------
  
/* DESCRIPTION :- REPORT OF TOP 25 SEBI PAYOUT VALUE RECORDS.  
 REQUESTED BY:- NAVNIT SHAHA (RISK TEAM)  
 DEVELOPED BY:- HRISHI YERUNKAR ON (26 AUG 2025)  
*/  
  
CREATE PROCEDURE [dbo].[USP_TOP25_SEBI_PAYOUT_RPT]
AS  

--- EXEC USP_TOP25_SEBI_PAYOUT_RPT 'RISK'
  
BEGIN  


SELECT TOP 25 PARTY_CODE,SEGAPPROVEDAMT,PROCESSDATETIME INTO #TOP25 FROM SEBIPAYOUT.SEBI.DBO.SEBI_PAYOUTAPPAMT
--WHERE PROCESSDATETIME='AUG  2 2025'
ORDER BY SEGAPPROVEDAMT DESC

----SELECT DISTINCT PROCESSDATETIME FROM SEBIPAYOUT.SEBI.DBO.SEBI_PAYOUTAPPAMT
----SELECT DISTINCT UPD_DATE FROM GENERAL.DBO.TBL_SEBITDATA_RISK
----SELECT DISTINCT UPD_DATE FROM GENERAL.DBO.TBL_SEBITDATA_RISKSHORTAGE

SELECT REMARK='RISK', T.PARTY_CODE, T.SEGAPPROVEDAMT AS 'SEBI_PAYOUT_VALUE', R.LEDGER, R.MTF_LEDGER, R.CUSA_HOLDING, R.UNSETTLED_HOLDING, R.MTF_HOLDING, PLEDGE_HOLDING='0.00', 
TOTAL_MARGIN='0.00', RISK_SHORTAGE='0.00', R.PURE_RISK, R.UPD_DATE  
FROM #TOP25 T LEFT JOIN GENERAL.DBO.TBL_SEBITDATA_RISK R ON T.PARTY_CODE=R.PARTY_CODE   
--WHERE R.UPD_DATE='AUG 02 2025'
UNION ALL
SELECT REMARK='RISKSHORTAGE', T.PARTY_CODE, T.SEGAPPROVEDAMT AS 'SEBI_PAYOUT_VALUE', RS.LEDGER, RS.MTF_LEDGER, RS.CUSA_HOLDING, RS.UNSETTLED_HOLDING, RS.MTF_HOLDING, 
RS.PLEDGE_HOLDING, RS.TOTAL_MARGIN, RS.RISK_SHORTAGE, PURE_RISK='0.00', RS.UPD_DATE
FROM #TOP25 T LEFT JOIN GENERAL.DBO.TBL_SEBITDATA_RISKSHORTAGE RS ON T.PARTY_CODE=RS.PARTY_CODE
--WHERE RS.UPD_DATE='AUG 02 2025'

END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_UploadOmnytradefile_Job
-- --------------------------------------------------
Create proc [dbo].[usp_UploadOmnytradefile_Job]             
As              
Begin              
declare @date as varchar(10)= Replace(COnvert(varchar,getdate(),103),'/','')--'12072024' --dd/mm/yyyy              
declare @cnt as int = 2               
declare  @FileName varchar(100) ,                 
         @Server varchar(20)                        
 while (@cnt<=12)              
 Begin        
 if(@cnt=4)              
  Begin              
   set @cnt =@cnt + 1 
  end      
  if(@cnt=6)              
  Begin              
   set @cnt =@cnt+1 
  end  
  if(@cnt=8)              
  Begin              
   set @cnt =@cnt+2
  end        
if(@cnt=1)              
begin              
 set @FileName =@date+'\Trades-'+@date+'.txt'              
end              
else              
begin               
 set @FileName =@date+'\Trades-'+cast(@cnt as varchar(5))+'-'+@date+'.txt'              
end              
                  
  set @Server ='Server'+cast(@cnt as varchar(5))+''                         
Begin TRY                      
                      
   if Exists (select 1 from tbl_omnestrdfileStatus where uploadStatus='Upload')                      
    Begin                      
    select 'Another Tradefile is already being uploaded,Please try after, file has been uploaded'                      
    return                      
 End                         
                         
   Update tbl_omnestrdfileStatus                       
   set uploadStatus='Upload',updateddate=getdate()                      
                      
                             
   declare @count as int                       
--declare @FileName as varchar(100)='25092024\Trades-2-25092024.txt'                                    
  truncate table tbl_OmnTradeFile_Temp                            
                         
    Declare @filePath varchar(500)=''                                                       
    set @filePath ='\\INHOUSELIVEAPP1-FS.angelone.in\upload1\OmnyTradeFileUpload\'+@FileName+''                                         
    DECLARE @sql NVARCHAR(4000) = 'BULK INSERT tbl_OmnTradeFile_Temp FROM ''' + @filePath + ''' WITH ( FIELDTERMINATOR ='','', ROWTERMINATOR =''\n'',FirstRow=2 )';                                                    
    EXEC(@sql)                                   
                                   
    if exists(select 1 from tbl_omni_tradeFileupload where file_=@FileName and status_='success' )                            
     Begin                            
  Update tbl_omnestrdfileStatus                       
     set uploadStatus='Success'                    
   select 'File already uploaded.'                            
   Return                            
  End                            
                            
                          
                          
  /*verifing if the file uploaded belongs to the Omne Server that has been selected */                          
 declare @rwcnt as int                          
 declare @sernum as int                          
 set @sernum = right(@Server,1)                          
 select @rwcnt=count(1) from  (select top 10 Accountid from tbl_OmnTradeFile_Temp) a                          
   inner join [10.253.33.65].[uploader-db-amx].dbo.tbl_usermasterinfo b with (nolock) on a.AccountId collate SQL_Latin1_General_CP1_CI_AS=b.Accountid                           
   where right(OmneManagerId,1)=@sernum                          
 if(@rwcnt  <1)                          
   Begin                          
                          
   insert into tbl_omni_tradeFileupload(server_,status_,Remark_,file_)                                  
   select @Server,'error','Wrong server selected for file',@FileName                             
                          
   select 'Please select proper Server.'                          
                           
 return                          
   End                          
              
                                    
 if  exists (select top 1 1 from tbl_OmnTradeFile_Temp where isdate(tradedate)=0 or left(convert(datetime,tradedate),11)='Jan 1 1900')                                    
  Begin                                    
   select 'Invalid file format  - Date/Time column Mismatch'                                     
   return                                    
  End         
               --declare @count as int   ,@Server varchar(20)='Server9'  ,@FileName varchar(100)='28052024\Trades-9-28052024.txt'                  
                        
declare @tmptradedate as varchar(12)                                    
declare @tradedate as varchar(12)                                    
select top 1 @tradedate=tradedate from tbl_OmnTradeFile                                    
select top 1 @tmptradedate=Convert(datetime,tradedate) from tbl_OmnTradeFile_Temp                                    
                                     
if(@tradedate!=@tmptradedate)                                    
Begin                                    
--insert into tbl_OmnTradeFile_Hist                 
--select *,getdate() from tbl_OmnTradeFile                                    
                
--truncate table tbl_OmnTradeFile                   
              
  --Added by pramod                                  
--insert into tbl_OmnTradeFile_Hist_arq                                     
--select *,getdate() from tbl_OmnTradeFile_arq                 
                              
--Added by pramod                                  
--truncate table tbl_OmnTradeFile_arq     
select @count=@@rowcount  
End                                    
                                    
insert into tbl_OmnTradeFile                                    
select * from tbl_OmnTradeFile_Temp                                  
                           
select @count=@@rowcount                            
                          
 --Added by pramod                                  
--insert into tbl_OmnTradeFile_arq                                  
--select distinct *  from tbl_OmnTradeFile_Temp where Exchange in ('NSE','BSE')                                  
                            
insert into tbl_omni_tradeFileupload(server_,status_,Remark_,file_)                                  
select @Server,'success',cast(@count as varchar) + ' rows uploaded',@FileName                             
                          
Update tbl_omnestrdfileStatus                       
set uploadStatus='Success',updateddate=getdate()                      
                          
select 'File Uploaded Successfully'                                    
                                    
End TRY                                    
Begin Catch                                    
                                 
insert into tbl_omnytrdfileException([Filename],Remark)                                
values(@FileName,ERROR_MESSAGE())                          
                               
                    
select 'Error Occured in Bulk Insert'                                    
End Catch         
set @cnt= @cnt+1              
End              
              
/*-https://angelbrokingpl.atlassian.net/browse/SRE-29861 */              
              
End

GO

-- --------------------------------------------------
-- TABLE dbo.bo_sett_mst_18012024
-- --------------------------------------------------
CREATE TABLE [dbo].[bo_sett_mst_18012024]
(
    [co_code] VARCHAR(25) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bo_sett_mst_bak_19012024
-- --------------------------------------------------
CREATE TABLE [dbo].[bo_sett_mst_bak_19012024]
(
    [co_code] VARCHAR(25) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.bo_sett_mst_bse_bak_19012024
-- --------------------------------------------------
CREATE TABLE [dbo].[bo_sett_mst_bse_bak_19012024]
(
    [co_code] VARCHAR(25) NULL,
    [Exchange] CHAR(3) NOT NULL,
    [Sett_Type] CHAR(3) NOT NULL,
    [Sett_No] CHAR(7) NOT NULL,
    [Start_date] DATETIME NULL,
    [End_Date] DATETIME NULL,
    [Funds_Payin] DATETIME NULL,
    [Funds_Payout] DATETIME NULL,
    [Sec_Payin] DATETIME NULL,
    [Sec_Payout] DATETIME NULL,
    [Series] VARCHAR(3) NULL,
    [MarketType] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_Details_23092024
-- --------------------------------------------------
CREATE TABLE [dbo].[client_Details_23092024]
(
    [region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(40) NULL,
    [l_state] VARCHAR(50) NULL,
    [l_zip] VARCHAR(10) NULL,
    [mobile_pager] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_Details_230920241
-- --------------------------------------------------
CREATE TABLE [dbo].[client_Details_230920241]
(
    [region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(40) NULL,
    [l_state] VARCHAR(50) NULL,
    [l_zip] VARCHAR(10) NULL,
    [mobile_pager] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_Details_230920242
-- --------------------------------------------------
CREATE TABLE [dbo].[client_Details_230920242]
(
    [region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Long_name] VARCHAR(100) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [l_address1] VARCHAR(40) NOT NULL,
    [l_address2] VARCHAR(40) NULL,
    [l_address3] VARCHAR(40) NULL,
    [l_city] VARCHAR(40) NULL,
    [l_state] VARCHAR(50) NULL,
    [l_zip] VARCHAR(10) NULL,
    [mobile_pager] VARCHAR(40) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.client_notification_template
-- --------------------------------------------------
CREATE TABLE [dbo].[client_notification_template]
(
    [id] INT NOT NULL,
    [template_id] TEXT NULL,
    [category] VARCHAR(100) NOT NULL,
    [sub_category] VARCHAR(100) NOT NULL,
    [notification_type] VARCHAR(20) NOT NULL,
    [cns_notification_type] VARCHAR(20) NOT NULL,
    [message_title] TEXT NULL,
    [message_body] TEXT NOT NULL,
    [cns_priority] TEXT NOT NULL,
    [cns_type] TEXT NOT NULL,
    [cns_group] TEXT NOT NULL,
    [cns_ttl] INT NOT NULL,
    [variable_params] BIT NOT NULL,
    [metadata] TEXT NOT NULL,
    [is_active] BIT NOT NULL,
    [created_by] TEXT NOT NULL,
    [created_at] ROWVERSION NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cns_common_notification
-- --------------------------------------------------
CREATE TABLE [dbo].[cns_common_notification]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [requestid] VARCHAR(50) NOT NULL,
    [templateid] VARCHAR(50) NULL,
    [clientcode] VARCHAR(20) NULL,
    [paramvalue] VARCHAR(5000) NULL,
    [entryon] DATETIME NULL DEFAULT (getdate()),
    [senton] DATETIME NULL,
    [updatedon] DATETIME NULL,
    [status] SMALLINT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.cns_template_master
-- --------------------------------------------------
CREATE TABLE [dbo].[cns_template_master]
(
    [id] INT IDENTITY(1,1) NOT NULL,
    [templateid] VARCHAR(50) NULL,
    [type] VARCHAR(20) NULL,
    [name] VARCHAR(50) NULL,
    [process] VARCHAR(50) NULL,
    [owner] VARCHAR(50) NULL,
    [createdon] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.COMPANY_10032024
-- --------------------------------------------------
CREATE TABLE [dbo].[COMPANY_10032024]
(
    [Co_code] VARCHAR(25) NULL,
    [Segment] VARCHAR(25) NULL,
    [Exchange] VARCHAR(25) NULL,
    [Co_Name] VARCHAR(100) NULL,
    [Co_Pan] VARCHAR(25) NULL,
    [BO_server] VARCHAR(25) NULL,
    [BO_Account_Db] VARCHAR(25) NULL,
    [BO_share_Db] VARCHAR(25) NULL,
    [BO_Active] INT NULL,
    [Incorporated_date] DATETIME NULL,
    [RetainLedgerDataConcluYear] INT NULL,
    [OffLineKYC] INT NULL,
    [DEMAT_Server] VARCHAR(25) NULL,
    [DEMAT_Db] VARCHAR(25) NULL,
    [COLLATERAL_Server] VARCHAR(25) NULL,
    [COLLATERAL_Db] VARCHAR(25) NULL,
    [CliDepositSeries] VARCHAR(10) NULL,
    [MTM_haircut] INT NULL,
    [Locked_On] DATETIME NULL,
    [Locked_upto] DATETIME NULL,
    [DefTrd_FutSlab] VARCHAR(6) NULL,
    [DefDel_Slab_OptPer] VARCHAR(6) NULL,
    [Calc_Remi] VARCHAR(1) NULL,
    [Remi_upd_status] VARCHAR(1) NULL,
    [Remi_upd_Userid] VARCHAR(12) NULL,
    [Nature] VARCHAR(50) NULL,
    [Sett_Normal] VARCHAR(5) NULL,
    [Sett_T2T] VARCHAR(5) NULL,
    [Sett_AucNormal] VARCHAR(5) NULL,
    [Sett_AucT2T] VARCHAR(5) NULL,
    [groupname] VARCHAR(15) NULL,
    [ApprHoldHairCut] INT NULL,
    [NonApprHoldHairCut] INT NULL,
    [Ex_NonCash_HairCut] MONEY NULL,
    [CompRisk_Imargin_HC] MONEY NULL,
    [STK_HC_MTM] MONEY NULL,
    [IDX_HC_MTM] MONEY NULL,
    [SBDepositSeries] VARCHAR(10) NULL,
    [SBRegGL] VARCHAR(10) NULL,
    [SBUnRegGL] VARCHAR(10) NULL,
    [CalcExSeq] INT NULL,
    [Shrt_HC] MONEY NULL,
    [Qty_Lot] VARCHAR(10) NULL,
    [grp_color] VARCHAR(15) NULL,
    [SQUP_VaR] MONEY NULL,
    [CP_CODE] VARCHAR(15) NULL,
    [EntityType] VARCHAR(10) NULL,
    [IH_dbName] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.company_bkup_28072023
-- --------------------------------------------------
CREATE TABLE [dbo].[company_bkup_28072023]
(
    [Co_code] VARCHAR(25) NULL,
    [Segment] VARCHAR(25) NULL,
    [Exchange] VARCHAR(25) NULL,
    [Co_Name] VARCHAR(100) NULL,
    [Co_Pan] VARCHAR(25) NULL,
    [BO_server] VARCHAR(25) NULL,
    [BO_Account_Db] VARCHAR(25) NULL,
    [BO_share_Db] VARCHAR(25) NULL,
    [BO_Active] INT NULL,
    [Incorporated_date] DATETIME NULL,
    [RetainLedgerDataConcluYear] INT NULL,
    [OffLineKYC] INT NULL,
    [DEMAT_Server] VARCHAR(25) NULL,
    [DEMAT_Db] VARCHAR(25) NULL,
    [COLLATERAL_Server] VARCHAR(25) NULL,
    [COLLATERAL_Db] VARCHAR(25) NULL,
    [CliDepositSeries] VARCHAR(10) NULL,
    [MTM_haircut] INT NULL,
    [Locked_On] DATETIME NULL,
    [Locked_upto] DATETIME NULL,
    [DefTrd_FutSlab] VARCHAR(6) NULL,
    [DefDel_Slab_OptPer] VARCHAR(6) NULL,
    [Calc_Remi] VARCHAR(1) NULL,
    [Remi_upd_status] VARCHAR(1) NULL,
    [Remi_upd_Userid] VARCHAR(12) NULL,
    [Nature] VARCHAR(50) NULL,
    [Sett_Normal] VARCHAR(5) NULL,
    [Sett_T2T] VARCHAR(5) NULL,
    [Sett_AucNormal] VARCHAR(5) NULL,
    [Sett_AucT2T] VARCHAR(5) NULL,
    [groupname] VARCHAR(15) NULL,
    [ApprHoldHairCut] INT NULL,
    [NonApprHoldHairCut] INT NULL,
    [Ex_NonCash_HairCut] MONEY NULL,
    [CompRisk_Imargin_HC] MONEY NULL,
    [STK_HC_MTM] MONEY NULL,
    [IDX_HC_MTM] MONEY NULL,
    [SBDepositSeries] VARCHAR(10) NULL,
    [SBRegGL] VARCHAR(10) NULL,
    [SBUnRegGL] VARCHAR(10) NULL,
    [CalcExSeq] INT NULL,
    [Shrt_HC] MONEY NULL,
    [Qty_Lot] VARCHAR(10) NULL,
    [grp_color] VARCHAR(15) NULL,
    [SQUP_VaR] MONEY NULL,
    [CP_CODE] VARCHAR(15) NULL,
    [EntityType] VARCHAR(10) NULL,
    [IH_dbName] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.company_rds_bo_bkup_25022023
-- --------------------------------------------------
CREATE TABLE [dbo].[company_rds_bo_bkup_25022023]
(
    [Co_code] VARCHAR(25) NULL,
    [Segment] VARCHAR(25) NULL,
    [Exchange] VARCHAR(25) NULL,
    [BO_server] VARCHAR(25) NULL,
    [BO_Account_Db] VARCHAR(25) NULL,
    [BO_Active] INT NULL,
    [LedgerTableName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Company_RDS_RE_bkup_25022023
-- --------------------------------------------------
CREATE TABLE [dbo].[Company_RDS_RE_bkup_25022023]
(
    [Co_code] VARCHAR(25) NULL,
    [Segment] VARCHAR(25) NULL,
    [Exchange] VARCHAR(25) NULL,
    [BO_server] VARCHAR(25) NULL,
    [BO_Account_Db] VARCHAR(25) NULL,
    [BO_Active] INT NULL,
    [LedgerTableName] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.day_defination_change
-- --------------------------------------------------
CREATE TABLE [dbo].[day_defination_change]
(
    [object_name] NVARCHAR(128) NOT NULL,
    [schema_name] NVARCHAR(128) NULL,
    [type_desc] NVARCHAR(60) NULL,
    [create_date] DATETIME NOT NULL,
    [modify_date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.dba_Test
-- --------------------------------------------------
CREATE TABLE [dbo].[dba_Test]
(
    [Fld1] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.DUST_NSEFO_BHAVCOPY
-- --------------------------------------------------
CREATE TABLE [dbo].[DUST_NSEFO_BHAVCOPY]
(
    [INST_TYPE] VARCHAR(100) NULL,
    [SYMBOL] VARCHAR(100) NULL,
    [EXP_DATE] DATE NULL,
    [STRIKE_PRICE] VARCHAR(100) NULL,
    [OPT_TYPE] VARCHAR(100) NULL,
    [AA] MONEY NULL,
    [TradDt] DATE NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.file1
-- --------------------------------------------------
CREATE TABLE [dbo].[file1]
(
    [zone] VARCHAR(25) NULL,
    [region] VARCHAR(50) NULL,
    [branch_cd] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(50) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Category] VARCHAR(5) NULL,
    [Cash] DECIMAL(20, 2) NULL,
    [Derivatives] DECIMAL(20, 2) NULL,
    [Currency] DECIMAL(20, 2) NULL,
    [Commodities] DECIMAL(20, 2) NULL,
    [DP] DECIMAL(20, 2) NULL,
    [NBFC] DECIMAL(20, 2) NULL,
    [Deposit] MONEY NULL,
    [Net] MONEY NULL,
    [App.Holding] MONEY NULL,
    [Non-App.Holding] MONEY NULL,
    [Holding] MONEY NULL,
    [SB Balance] MONEY NULL,
    [ProjRisk] MONEY NULL,
    [PureRisk] MONEY NULL,
    [MOS] MONEY NULL,
    [UnbookedLoss] MONEY NULL,
    [IMargin] MONEY NULL,
    [Total_Colleteral] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [Un_Reco] MONEY NULL,
    [Exposure] MONEY NULL,
    [PureAdj] MONEY NULL,
    [SBCrAfterPureAdj] MONEY NULL,
    [ProjAdj] MONEY NULL,
    [SBCrAfterProjAdj] MONEY NULL,
    [SB_Credit] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.imargin
-- --------------------------------------------------
CREATE TABLE [dbo].[imargin]
(
    [party_code] VARCHAR(10) NOT NULL,
    [IMargin] MONEY NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.JVMarking_04102013_General
-- --------------------------------------------------
CREATE TABLE [dbo].[JVMarking_04102013_General]
(
    [SrNo] INT IDENTITY(1,1) NOT NULL,
    [Party_Code] VARCHAR(10) NULL,
    [From_Seg] VARCHAR(10) NULL,
    [To_Seg] VARCHAR(10) NULL,
    [SB] VARCHAR(10) NULL,
    [Branch] VARCHAR(10) NULL,
    [Transfer_Type] CHAR(1) NULL,
    [Dr_CltCode] VARCHAR(25) NULL,
    [Cr_CltCode] VARCHAR(25) NULL,
    [Amount] MONEY NULL,
    [CO_CODE] VARCHAR(5) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.KycModificationRequests
-- --------------------------------------------------
CREATE TABLE [dbo].[KycModificationRequests]
(
    [modification_request_date] DATE NULL,
    [dp_id] VARCHAR(50) NULL,
    [client_code] VARCHAR(20) NULL,
    [app_number] VARCHAR(20) NULL,
    [mobile_changed] VARCHAR(3) NULL,
    [email_changed] VARCHAR(3) NULL,
    [address_changed] VARCHAR(3) NULL,
    [new_email] VARCHAR(100) NULL,
    [new_mobile] VARCHAR(15) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.LedgerSeries_bkup_24122023
-- --------------------------------------------------
CREATE TABLE [dbo].[LedgerSeries_bkup_24122023]
(
    [Seriesid] INT IDENTITY(1,1) NOT NULL,
    [SeriesCode] VARCHAR(10) NULL,
    [Segment] VARCHAR(10) NULL,
    [seriesDesc] VARCHAR(50) NULL,
    [EntityType] VARCHAR(10) NULL,
    [active] INT NULL,
    [addedon] DATETIME NULL,
    [addedby] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MF_RetirementSchemes
-- --------------------------------------------------
CREATE TABLE [dbo].[MF_RetirementSchemes]
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
-- TABLE dbo.miral
-- --------------------------------------------------
CREATE TABLE [dbo].[miral]
(
    [party_code] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_AXISBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_AXISBANK_TEMP]
(
    [PIS_ACCOUNT_NO] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [BALANCE] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_BANK_FILE_UPLOAD_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_BANK_FILE_UPLOAD_LOG]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [BANKID] INT NULL,
    [FILENAME] VARCHAR(50) NULL,
    [TOTALCOUNT] INT NULL,
    [ZRCOUNT] INT NULL,
    [UPLOAD_DATETIME] DATETIME NULL,
    [UPLOAD_BY] VARCHAR(20) NULL,
    [UPLOAD_IP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_BANK_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_BANK_MASTER]
(
    [BANKID] INT NOT NULL,
    [BANKNAME] VARCHAR(50) NULL,
    [BANKDESCRIPTION] VARCHAR(70) NULL,
    [ADDEDON] DATETIME NULL,
    [LASTUPDATEDDATE] DATETIME NULL,
    [TOTALCOUNT] INT NULL,
    [ZRCOUNT] INT NULL,
    [FILENAMEVALIDATION] NVARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_HDFCBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_HDFCBANK_TEMP]
(
    [AccountNo] VARCHAR(50) NULL,
    [AvailableBalance] MONEY NULL,
    [CompanyName] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_IDBIBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_IDBIBANK_TEMP]
(
    [ACCT_LABLE] VARCHAR(50) NULL,
    [SCHM_DESC] VARCHAR(50) NULL,
    [PIS_ACCOUNT_NO] VARCHAR(50) NULL,
    [ACCOUNT_NAME] VARCHAR(50) NULL,
    [BALANCE] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_IDFCCBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_IDFCCBANK_TEMP]
(
    [AccountNo] VARCHAR(50) NULL,
    [CustomerName] VARCHAR(100) NULL,
    [Balance] MONEY NULL,
    [Client_Code] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_INDUSINDBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_INDUSINDBANK_TEMP]
(
    [PIS_ACCOUNT_NO] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [BALANCE] DECIMAL(18, 2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_KOTAKBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_KOTAKBANK_TEMP]
(
    [CUSTOMER_NAME] VARCHAR(100) NULL,
    [ACCOUNT_NUMBER] VARCHAR(100) NULL,
    [TYPE] VARCHAR(100) NULL,
    [BALANCE_AVAILABLE] VARCHAR(100) NULL,
    [PROM_CODE] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_PIS_BALANCE
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_PIS_BALANCE]
(
    [BANKID] INT NULL,
    [PIS_ACCOUNT_NO] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [BALANCE] DECIMAL(18, 2) NULL,
    [UPLOAD_DATETIME] DATETIME NULL,
    [UPLOAD_BY] VARCHAR(20) NULL,
    [UPLOAD_IP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_PIS_BALANCE_LOG
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_PIS_BALANCE_LOG]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [BANKID] INT NULL,
    [PIS_ACCOUNT_NO] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(20) NULL,
    [BALANCE] DECIMAL(18, 2) NULL,
    [UPLOAD_DATETIME] DATETIME NULL,
    [UPLOAD_BY] VARCHAR(20) NULL,
    [UPLOAD_IP] VARCHAR(20) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NRI_LG_YESBANK_TEMP
-- --------------------------------------------------
CREATE TABLE [dbo].[NRI_LG_YESBANK_TEMP]
(
    [CUSTOMER_NAME] VARCHAR(100) NULL,
    [ACCOUNT_NUMBER] VARCHAR(100) NULL,
    [TYPE] VARCHAR(100) NULL,
    [BALANCE_AVAILABLE] VARCHAR(100) NULL,
    [PROM_CODE] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcs_NNVI
-- --------------------------------------------------
CREATE TABLE [dbo].[rcs_NNVI]
(
    [Exchange] VARCHAR(30) NULL,
    [UserId] VARCHAR(30) NULL,
    [AccountId] VARCHAR(30) NULL,
    [TradeDate] DATETIME NULL,
    [TradeTime] VARCHAR(20) NULL,
    [ParticipantCode] VARCHAR(20) NULL,
    [Buy_Sell] VARCHAR(20) NULL,
    [TradingSymbol] VARCHAR(50) NULL,
    [ProductType] VARCHAR(30) NULL,
    [ExchangeOrderNo] VARCHAR(30) NULL,
    [TradePrice] VARCHAR(30) NULL,
    [TradeQty] VARCHAR(30) NULL,
    [B_W_L] VARCHAR(50) NULL,
    [OrderSource] VARCHAR(100) NULL,
    [NestOrderNo] VARCHAR(30) NULL,
    [PanNumber] VARCHAR(30) NULL,
    [AlgoIdentifier] VARCHAR(30) NULL,
    [ExchangeAlgoCategory] VARCHAR(30) NULL,
    [TradeExchange] VARCHAR(30) NULL,
    [OrderUserMessage] VARCHAR(200) NULL,
    [EQSIPRegistrationNo] VARCHAR(30) NULL,
    [GroupName] VARCHAR(30) NULL,
    [SpreadReferenceNo] VARCHAR(30) NULL,
    [ExchangeAccountId] VARCHAR(30) NULL,
    [QtyUnits] VARCHAR(30) NULL,
    [ModifiedByUser] VARCHAR(30) NULL,
    [AccountName] VARCHAR(30) NULL,
    [OrderPlacedBy] VARCHAR(30) NULL,
    [QtyInLots] VARCHAR(30) NULL,
    [GiveupIndicator] VARCHAR(30) NULL,
    [ModificationRemarks] VARCHAR(30) NULL,
    [ReportType] VARCHAR(30) NULL,
    [QtyToFill] VARCHAR(30) NULL,
    [AuctionNumber] VARCHAR(30) NULL,
    [BranchId] VARCHAR(30) NULL,
    [BrokerId] VARCHAR(30) NULL,
    [OptionType] VARCHAR(30) NULL,
    [MarketType] VARCHAR(30) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Remarks] VARCHAR(50) NULL,
    [ProCli] VARCHAR(50) NULL,
    [TradeID] VARCHAR(50) NULL,
    [TradeStatus] VARCHAR(50) NULL,
    [ExpiryDate] VARCHAR(50) NULL,
    [StrikePrice] VARCHAR(50) NULL,
    [InstrumentName] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [RequestId] VARCHAR(50) NULL,
    [UpdateDate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcsexposure08082024
-- --------------------------------------------------
CREATE TABLE [dbo].[rcsexposure08082024]
(
    [region] VARCHAR(20) NULL,
    [branch code] VARCHAR(100) NULL,
    [sb code] VARCHAR(10) NULL,
    [client code] VARCHAR(10) NULL,
    [cli type] VARCHAR(10) NULL,
    [segment] VARCHAR(5) NOT NULL,
    [inst type] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [expiry date] VARCHAR(11) NULL,
    [option type] VARCHAR(20) NULL,
    [strike price] DECIMAL(20, 2) NULL,
    [net quantity] DECIMAL(20, 0) NULL,
    [net open value] DECIMAL(38, 6) NULL,
    [close price] DECIMAL(20, 2) NULL,
    [OTM/ITM] VARCHAR(20) NULL,
    [EXPOSURE] MONEY NULL,
    [Position Type] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.rcsMARGIN08082024
-- --------------------------------------------------
CREATE TABLE [dbo].[rcsMARGIN08082024]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL,
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.RMS_BatchJob_Log_25022023
-- --------------------------------------------------
CREATE TABLE [dbo].[RMS_BatchJob_Log_25022023]
(
    [BatchRunID] BIGINT IDENTITY(1,1) NOT NULL,
    [BatchID] INT NOT NULL,
    [BatchDate] DATETIME NULL,
    [BatchStatus] CHAR(1) NULL,
    [BatchStartTime] DATETIME NULL,
    [BatchEndTime] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rms_SSISBatchTaskJob_log_09dec2023
-- --------------------------------------------------
CREATE TABLE [dbo].[Rms_SSISBatchTaskJob_log_09dec2023]
(
    [BatchTaskRunID] INT IDENTITY(1,1) NOT NULL,
    [batchId] INT NULL,
    [BatchTaskID] INT NULL,
    [BatchTaskDate] SMALLDATETIME NULL,
    [BatchTaskStatus] CHAR(1) NULL,
    [BatchTaskStartTime] SMALLDATETIME NULL,
    [BatchTaskEndTime] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rms_SSISBatchTaskJob_log_15102023
-- --------------------------------------------------
CREATE TABLE [dbo].[Rms_SSISBatchTaskJob_log_15102023]
(
    [BatchTaskRunID] INT IDENTITY(1,1) NOT NULL,
    [batchId] INT NULL,
    [BatchTaskID] INT NULL,
    [BatchTaskDate] SMALLDATETIME NULL,
    [BatchTaskStatus] CHAR(1) NULL,
    [BatchTaskStartTime] SMALLDATETIME NULL,
    [BatchTaskEndTime] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Rms_SSISBatchTaskJob_log_25022023
-- --------------------------------------------------
CREATE TABLE [dbo].[Rms_SSISBatchTaskJob_log_25022023]
(
    [BatchTaskRunID] INT IDENTITY(1,1) NOT NULL,
    [batchId] INT NULL,
    [BatchTaskID] INT NULL,
    [BatchTaskDate] SMALLDATETIME NULL,
    [BatchTaskStatus] CHAR(1) NULL,
    [BatchTaskStartTime] SMALLDATETIME NULL,
    [BatchTaskEndTime] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.short
-- --------------------------------------------------
CREATE TABLE [dbo].[short]
(
    [client] VARCHAR(10) NOT NULL,
    [Net] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_client_details_02122023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_client_details_02122023]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [trader] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [l_address1] VARCHAR(100) NULL,
    [l_city] VARCHAR(100) NULL,
    [l_address2] VARCHAR(100) NULL,
    [l_state] VARCHAR(100) NULL,
    [l_address3] VARCHAR(100) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [ward_no] VARCHAR(50) NULL,
    [sebi_regn_no] VARCHAR(25) NULL,
    [res_phone1] VARCHAR(15) NULL,
    [res_phone2] VARCHAR(15) NULL,
    [off_phone1] VARCHAR(15) NULL,
    [off_phone2] VARCHAR(15) NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [cl_type] VARCHAR(3) NOT NULL,
    [cl_status] VARCHAR(3) NOT NULL,
    [family] VARCHAR(10) NULL,
    [region] VARCHAR(50) NULL,
    [area] VARCHAR(10) NULL,
    [p_address1] VARCHAR(100) NULL,
    [p_city] VARCHAR(50) NULL,
    [p_address2] VARCHAR(100) NULL,
    [p_state] VARCHAR(100) NULL,
    [p_address3] VARCHAR(100) NULL,
    [p_nation] VARCHAR(15) NULL,
    [p_zip] VARCHAR(10) NULL,
    [p_phone] VARCHAR(15) NULL,
    [addemailid] VARCHAR(230) NULL,
    [sex] CHAR(1) NULL,
    [dob] DATETIME NULL,
    [introducer] VARCHAR(30) NULL,
    [approver] VARCHAR(30) NULL,
    [interactmode] TINYINT NULL,
    [passport_no] VARCHAR(30) NULL,
    [passport_issued_at] VARCHAR(30) NULL,
    [passport_issued_on] DATETIME NULL,
    [passport_expires_on] DATETIME NULL,
    [licence_no] VARCHAR(30) NULL,
    [licence_issued_at] VARCHAR(30) NULL,
    [licence_issued_on] DATETIME NULL,
    [licence_expires_on] DATETIME NULL,
    [rat_card_no] VARCHAR(30) NULL,
    [rat_card_issued_at] VARCHAR(30) NULL,
    [rat_card_issued_on] DATETIME NULL,
    [votersid_no] VARCHAR(30) NULL,
    [votersid_issued_at] VARCHAR(30) NULL,
    [votersid_issued_on] DATETIME NULL,
    [it_return_yr] VARCHAR(30) NULL,
    [it_return_filed_on] DATETIME NULL,
    [regr_no] VARCHAR(50) NULL,
    [regr_at] VARCHAR(50) NULL,
    [regr_on] DATETIME NULL,
    [regr_authority] VARCHAR(50) NULL,
    [client_agreement_on] DATETIME NULL,
    [sett_mode] VARCHAR(50) NULL,
    [dealing_with_other_tm] VARCHAR(50) NULL,
    [other_ac_no] VARCHAR(50) NULL,
    [introducer_id] VARCHAR(50) NULL,
    [introducer_relation] VARCHAR(50) NULL,
    [repatriat_bank] NUMERIC(18, 0) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [chk_kyc_form] TINYINT NULL,
    [chk_corporate_deed] TINYINT NULL,
    [chk_bank_certificate] TINYINT NULL,
    [chk_annual_report] TINYINT NULL,
    [chk_networth_cert] TINYINT NULL,
    [chk_corp_dtls_recd] TINYINT NULL,
    [Bank_Name] VARCHAR(50) NULL,
    [Branch_Name] VARCHAR(50) NULL,
    [AC_Type] VARCHAR(10) NULL,
    [AC_Num] VARCHAR(20) NULL,
    [Depository1] VARCHAR(7) NULL,
    [DpId1] VARCHAR(16) NULL,
    [CltDpId1] VARCHAR(16) NULL,
    [Poa1] CHAR(1) NULL,
    [Depository2] VARCHAR(7) NULL,
    [DpId2] VARCHAR(16) NULL,
    [CltDpId2] VARCHAR(16) NULL,
    [Poa2] CHAR(1) NULL,
    [Depository3] VARCHAR(7) NULL,
    [DpId3] VARCHAR(16) NULL,
    [CltDpId3] VARCHAR(16) NULL,
    [Poa3] CHAR(1) NULL,
    [rel_mgr] VARCHAR(10) NULL,
    [c_group] VARCHAR(10) NULL,
    [sbu] VARCHAR(10) NULL,
    [Status] CHAR(1) NULL,
    [Imp_Status] TINYINT NULL,
    [ModifidedBy] VARCHAR(25) NULL,
    [ModifidedOn] DATETIME NULL,
    [Bank_id] NUMERIC(18, 0) NULL,
    [Mapin_id] VARCHAR(12) NULL,
    [UCC_Code] VARCHAR(12) NULL,
    [Micr_No] VARCHAR(10) NULL,
    [Director_name] VARCHAR(200) NULL,
    [paylocation] VARCHAR(20) NULL,
    [FMCode] VARCHAR(10) NULL,
    [BSECM_LAST_DATE] DATETIME NULL,
    [NSECM_LAST_DATE] DATETIME NULL,
    [BSEFO_LAST_DATE] DATETIME NULL,
    [NSEFO_LAST_DATE] DATETIME NULL,
    [NCDEX_LAST_DATE] DATETIME NULL,
    [MCX_LAST_DATE] DATETIME NULL,
    [NSX_LAST_DATE] DATETIME NULL,
    [MCD_LAST_DATE] DATETIME NULL,
    [comb_LAST_DATE] DATETIME NULL,
    [bsecm] VARCHAR(1) NULL,
    [nsecm] VARCHAR(1) NULL,
    [nsefo] VARCHAR(1) NULL,
    [mcdx] VARCHAR(1) NULL,
    [ncdx] VARCHAR(1) NULL,
    [bsefo] VARCHAR(1) NULL,
    [mcd] VARCHAR(1) NULL,
    [nsx] VARCHAR(1) NULL,
    [Last_inactive_date] DATETIME NULL,
    [First_Active_date] DATETIME NULL,
    [NBFC_cli] VARCHAR(1) NULL,
    [Org_SB] VARCHAR(10) NULL,
    [Org_branch] VARCHAR(10) NULL,
    [BSX] CHAR(1) NULL,
    [BSX_LAST_DATE] DATETIME NULL,
    [MF] VARCHAR(1) NULL,
    [MF_LAST_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_client_details_28102023
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_client_details_28102023]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [trader] VARCHAR(20) NULL,
    [long_name] VARCHAR(100) NULL,
    [short_name] VARCHAR(21) NOT NULL,
    [l_address1] VARCHAR(100) NULL,
    [l_city] VARCHAR(100) NULL,
    [l_address2] VARCHAR(100) NULL,
    [l_state] VARCHAR(100) NULL,
    [l_address3] VARCHAR(100) NULL,
    [l_nation] VARCHAR(15) NULL,
    [l_zip] VARCHAR(10) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [ward_no] VARCHAR(50) NULL,
    [sebi_regn_no] VARCHAR(25) NULL,
    [res_phone1] VARCHAR(15) NULL,
    [res_phone2] VARCHAR(15) NULL,
    [off_phone1] VARCHAR(15) NULL,
    [off_phone2] VARCHAR(15) NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [cl_type] VARCHAR(3) NOT NULL,
    [cl_status] VARCHAR(3) NOT NULL,
    [family] VARCHAR(10) NULL,
    [region] VARCHAR(50) NULL,
    [area] VARCHAR(10) NULL,
    [p_address1] VARCHAR(100) NULL,
    [p_city] VARCHAR(50) NULL,
    [p_address2] VARCHAR(100) NULL,
    [p_state] VARCHAR(100) NULL,
    [p_address3] VARCHAR(100) NULL,
    [p_nation] VARCHAR(15) NULL,
    [p_zip] VARCHAR(10) NULL,
    [p_phone] VARCHAR(15) NULL,
    [addemailid] VARCHAR(230) NULL,
    [sex] CHAR(1) NULL,
    [dob] DATETIME NULL,
    [introducer] VARCHAR(30) NULL,
    [approver] VARCHAR(30) NULL,
    [interactmode] TINYINT NULL,
    [passport_no] VARCHAR(30) NULL,
    [passport_issued_at] VARCHAR(30) NULL,
    [passport_issued_on] DATETIME NULL,
    [passport_expires_on] DATETIME NULL,
    [licence_no] VARCHAR(30) NULL,
    [licence_issued_at] VARCHAR(30) NULL,
    [licence_issued_on] DATETIME NULL,
    [licence_expires_on] DATETIME NULL,
    [rat_card_no] VARCHAR(30) NULL,
    [rat_card_issued_at] VARCHAR(30) NULL,
    [rat_card_issued_on] DATETIME NULL,
    [votersid_no] VARCHAR(30) NULL,
    [votersid_issued_at] VARCHAR(30) NULL,
    [votersid_issued_on] DATETIME NULL,
    [it_return_yr] VARCHAR(30) NULL,
    [it_return_filed_on] DATETIME NULL,
    [regr_no] VARCHAR(50) NULL,
    [regr_at] VARCHAR(50) NULL,
    [regr_on] DATETIME NULL,
    [regr_authority] VARCHAR(50) NULL,
    [client_agreement_on] DATETIME NULL,
    [sett_mode] VARCHAR(50) NULL,
    [dealing_with_other_tm] VARCHAR(50) NULL,
    [other_ac_no] VARCHAR(50) NULL,
    [introducer_id] VARCHAR(50) NULL,
    [introducer_relation] VARCHAR(50) NULL,
    [repatriat_bank] NUMERIC(18, 0) NULL,
    [repatriat_bank_ac_no] VARCHAR(30) NULL,
    [chk_kyc_form] TINYINT NULL,
    [chk_corporate_deed] TINYINT NULL,
    [chk_bank_certificate] TINYINT NULL,
    [chk_annual_report] TINYINT NULL,
    [chk_networth_cert] TINYINT NULL,
    [chk_corp_dtls_recd] TINYINT NULL,
    [Bank_Name] VARCHAR(50) NULL,
    [Branch_Name] VARCHAR(50) NULL,
    [AC_Type] VARCHAR(10) NULL,
    [AC_Num] VARCHAR(20) NULL,
    [Depository1] VARCHAR(7) NULL,
    [DpId1] VARCHAR(16) NULL,
    [CltDpId1] VARCHAR(16) NULL,
    [Poa1] CHAR(1) NULL,
    [Depository2] VARCHAR(7) NULL,
    [DpId2] VARCHAR(16) NULL,
    [CltDpId2] VARCHAR(16) NULL,
    [Poa2] CHAR(1) NULL,
    [Depository3] VARCHAR(7) NULL,
    [DpId3] VARCHAR(16) NULL,
    [CltDpId3] VARCHAR(16) NULL,
    [Poa3] CHAR(1) NULL,
    [rel_mgr] VARCHAR(10) NULL,
    [c_group] VARCHAR(10) NULL,
    [sbu] VARCHAR(10) NULL,
    [Status] CHAR(1) NULL,
    [Imp_Status] TINYINT NULL,
    [ModifidedBy] VARCHAR(25) NULL,
    [ModifidedOn] DATETIME NULL,
    [Bank_id] NUMERIC(18, 0) NULL,
    [Mapin_id] VARCHAR(12) NULL,
    [UCC_Code] VARCHAR(12) NULL,
    [Micr_No] VARCHAR(10) NULL,
    [Director_name] VARCHAR(200) NULL,
    [paylocation] VARCHAR(20) NULL,
    [FMCode] VARCHAR(10) NULL,
    [BSECM_LAST_DATE] DATETIME NULL,
    [NSECM_LAST_DATE] DATETIME NULL,
    [BSEFO_LAST_DATE] DATETIME NULL,
    [NSEFO_LAST_DATE] DATETIME NULL,
    [NCDEX_LAST_DATE] DATETIME NULL,
    [MCX_LAST_DATE] DATETIME NULL,
    [NSX_LAST_DATE] DATETIME NULL,
    [MCD_LAST_DATE] DATETIME NULL,
    [comb_LAST_DATE] DATETIME NULL,
    [bsecm] VARCHAR(1) NULL,
    [nsecm] VARCHAR(1) NULL,
    [nsefo] VARCHAR(1) NULL,
    [mcdx] VARCHAR(1) NULL,
    [ncdx] VARCHAR(1) NULL,
    [bsefo] VARCHAR(1) NULL,
    [mcd] VARCHAR(1) NULL,
    [nsx] VARCHAR(1) NULL,
    [Last_inactive_date] DATETIME NULL,
    [First_Active_date] DATETIME NULL,
    [NBFC_cli] VARCHAR(1) NULL,
    [Org_SB] VARCHAR(10) NULL,
    [Org_branch] VARCHAR(10) NULL,
    [BSX] CHAR(1) NULL,
    [BSX_LAST_DATE] DATETIME NULL,
    [MF] VARCHAR(1) NULL,
    [MF_LAST_DATE] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_isin_06032024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_isin_06032024]
(
    [Client Code] VARCHAR(50) NULL,
    [ISIN] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_omnestrdfileStatus
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_omnestrdfileStatus]
(
    [UploadStatus] VARCHAR(20) NULL,
    [updateddate] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_omni_tradeFileupload
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_omni_tradeFileupload]
(
    [id_] INT IDENTITY(1,1) NOT NULL,
    [server_] VARCHAR(50) NULL,
    [status_] VARCHAR(50) NULL,
    [remark_] VARCHAR(500) NULL,
    [uploadOn_] DATETIME NULL,
    [file_] VARCHAR(500) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_OmnTradeFile
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_OmnTradeFile]
(
    [Exchange] VARCHAR(30) NULL,
    [UserId] VARCHAR(30) NULL,
    [AccountId] VARCHAR(30) NULL,
    [TradeDate] DATETIME NULL,
    [TradeTime] VARCHAR(20) NULL,
    [ParticipantCode] VARCHAR(20) NULL,
    [Buy_Sell] VARCHAR(20) NULL,
    [TradingSymbol] VARCHAR(50) NULL,
    [ProductType] VARCHAR(30) NULL,
    [ExchangeOrderNo] VARCHAR(30) NULL,
    [TradePrice] VARCHAR(30) NULL,
    [TradeQty] VARCHAR(30) NULL,
    [B_W_L] VARCHAR(50) NULL,
    [OrderSource] VARCHAR(30) NULL,
    [NestOrderNo] VARCHAR(30) NULL,
    [PanNumber] VARCHAR(30) NULL,
    [AlgoIdentifier] VARCHAR(30) NULL,
    [ExchangeAlgoCategory] VARCHAR(30) NULL,
    [TradeExchange] VARCHAR(30) NULL,
    [OrderUserMessage] VARCHAR(200) NULL,
    [EQSIPRegistrationNo] VARCHAR(30) NULL,
    [GroupName] VARCHAR(30) NULL,
    [SpreadReferenceNo] VARCHAR(30) NULL,
    [ExchangeAccountId] VARCHAR(30) NULL,
    [QtyUnits] VARCHAR(30) NULL,
    [ModifiedByUser] VARCHAR(30) NULL,
    [AccountName] VARCHAR(30) NULL,
    [OrderPlacedBy] VARCHAR(30) NULL,
    [QtyInLots] VARCHAR(30) NULL,
    [GiveupIndicator] VARCHAR(30) NULL,
    [ModificationRemarks] VARCHAR(30) NULL,
    [ReportType] VARCHAR(30) NULL,
    [QtyToFill] VARCHAR(30) NULL,
    [AuctionNumber] VARCHAR(30) NULL,
    [BranchId] VARCHAR(30) NULL,
    [BrokerId] VARCHAR(30) NULL,
    [OptionType] VARCHAR(30) NULL,
    [MarketType] VARCHAR(30) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Remarks] VARCHAR(50) NULL,
    [ProCli] VARCHAR(50) NULL,
    [TradeID] VARCHAR(50) NULL,
    [TradeStatus] VARCHAR(50) NULL,
    [ExpiryDate] VARCHAR(50) NULL,
    [StrikePrice] VARCHAR(50) NULL,
    [InstrumentName] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [RequestId] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_OmnTradeFile_Temp
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_OmnTradeFile_Temp]
(
    [Exchange] VARCHAR(30) NULL,
    [UserId] VARCHAR(30) NULL,
    [AccountId] VARCHAR(30) NULL,
    [TradeDate] VARCHAR(20) NULL,
    [TradeTime] VARCHAR(20) NULL,
    [ParticipantCode] VARCHAR(20) NULL,
    [Buy_Sell] VARCHAR(20) NULL,
    [TradingSymbol] VARCHAR(50) NULL,
    [ProductType] VARCHAR(30) NULL,
    [ExchangeOrderNo] VARCHAR(30) NULL,
    [TradePrice] VARCHAR(30) NULL,
    [TradeQty] VARCHAR(30) NULL,
    [B_W_L] VARCHAR(50) NULL,
    [OrderSource] VARCHAR(30) NULL,
    [NestOrderNo] VARCHAR(30) NULL,
    [PanNumber] VARCHAR(30) NULL,
    [AlgoIdentifier] VARCHAR(30) NULL,
    [ExchangeAlgoCategory] VARCHAR(30) NULL,
    [TradeExchange] VARCHAR(30) NULL,
    [OrderUserMessage] VARCHAR(200) NULL,
    [EQSIPRegistrationNo] VARCHAR(30) NULL,
    [GroupName] VARCHAR(30) NULL,
    [SpreadReferenceNo] VARCHAR(30) NULL,
    [ExchangeAccountId] VARCHAR(30) NULL,
    [QtyUnits] VARCHAR(30) NULL,
    [ModifiedByUser] VARCHAR(30) NULL,
    [AccountName] VARCHAR(30) NULL,
    [OrderPlacedBy] VARCHAR(30) NULL,
    [QtyInLots] VARCHAR(30) NULL,
    [GiveupIndicator] VARCHAR(30) NULL,
    [ModificationRemarks] VARCHAR(30) NULL,
    [ReportType] VARCHAR(30) NULL,
    [QtyToFill] VARCHAR(30) NULL,
    [AuctionNumber] VARCHAR(30) NULL,
    [BranchId] VARCHAR(30) NULL,
    [BrokerId] VARCHAR(30) NULL,
    [OptionType] VARCHAR(30) NULL,
    [MarketType] VARCHAR(30) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Remarks] VARCHAR(50) NULL,
    [ProCli] VARCHAR(50) NULL,
    [TradeID] VARCHAR(50) NULL,
    [TradeStatus] VARCHAR(50) NULL,
    [ExpiryDate] VARCHAR(50) NULL,
    [StrikePrice] VARCHAR(50) NULL,
    [InstrumentName] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [RequestId] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_OmnTradeFile03sep2024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_OmnTradeFile03sep2024]
(
    [Exchange] VARCHAR(30) NULL,
    [UserId] VARCHAR(30) NULL,
    [AccountId] VARCHAR(30) NULL,
    [ParticipantCode] VARCHAR(20) NULL,
    [Buy_Sell] VARCHAR(20) NULL,
    [TradingSymbol] VARCHAR(50) NULL,
    [ExchangeOrderNo] VARCHAR(30) NULL,
    [TradePrice] VARCHAR(30) NULL,
    [TradeQty] VARCHAR(30) NULL,
    [B_W_L] VARCHAR(50) NULL,
    [OrderSource] VARCHAR(30) NULL,
    [SettlementType] VARCHAR(4) NOT NULL,
    [FillIndicator] VARCHAR(1) NOT NULL,
    [PanNumber] VARCHAR(30) NULL,
    [AlgoIdentifier] VARCHAR(30) NULL,
    [ExchangeAlgoCategory] VARCHAR(30) NULL,
    [TradeExchange] VARCHAR(30) NULL,
    [OrderUserMessage] VARCHAR(200) NULL,
    [EQSIPRegistrationNo] VARCHAR(30) NULL,
    [GroupName] VARCHAR(30) NULL,
    [SpreadReferenceNo] VARCHAR(30) NULL,
    [ExchangeAccountId] VARCHAR(30) NULL,
    [QtyUnits] VARCHAR(30) NULL,
    [ModifiedByUser] VARCHAR(30) NULL,
    [AccountName] VARCHAR(30) NULL,
    [OrderPlacedBy] VARCHAR(30) NULL,
    [QtyInLots] VARCHAR(30) NULL,
    [GiveupIndicator] VARCHAR(30) NULL,
    [ModificationRemarks] VARCHAR(30) NULL,
    [ReportType] VARCHAR(30) NULL,
    [QtyToFill] VARCHAR(30) NULL,
    [AuctionNumber] VARCHAR(30) NULL,
    [BranchId] VARCHAR(30) NULL,
    [BrokerId] VARCHAR(30) NULL,
    [OptionType] VARCHAR(30) NULL,
    [MarketType] VARCHAR(30) NULL,
    [ProductType] VARCHAR(30) NULL,
    [OrderType] VARCHAR(30) NULL,
    [Remarks] VARCHAR(50) NULL,
    [ProCli] VARCHAR(50) NULL,
    [TradeID] VARCHAR(50) NULL,
    [TradeTime] VARCHAR(20) NULL,
    [TradeDate] VARCHAR(20) NULL,
    [TradeStatus] VARCHAR(50) NULL,
    [ExpiryDate] VARCHAR(50) NULL,
    [StrikePrice] VARCHAR(50) NULL,
    [InstrumentName] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [RequestId] VARCHAR(50) NULL,
    [NestOrderNo] VARCHAR(30) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_omnytrdfileException
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_omnytrdfileException]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Filename] VARCHAR(100) NULL,
    [Remark] VARCHAR(MAX) NULL,
    [Exceptiondate] DATETIME NULL DEFAULT (getdate())
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_pledge_calculation_25012024
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_pledge_calculation_25012024]
(
    [party_code] VARCHAR(100) NULL,
    [Mobile_Num] VARCHAR(50) NULL,
    [Email] VARCHAR(500) NULL,
    [dpid] VARCHAR(20) NOT NULL,
    [scripname] VARCHAR(500) NULL,
    [isin] VARCHAR(20) NULL,
    [Free_Qty] NUMERIC(18, 5) NOT NULL,
    [Pledge_Qty] NUMERIC(18, 5) NOT NULL,
    [datetimestamp] DATETIME NOT NULL,
    [Obligation] INT NULL,
    [Unpledge] INT NULL,
    [POA] VARCHAR(10) NULL,
    [Net_Pldg_qty] INT NULL,
    [qty] INT NULL,
    [close_rate] MONEY NULL,
    [total] MONEY NULL,
    [nse_approved] VARCHAR(20) NULL,
    [var_mar] MONEY NULL,
    [net_amt] MONEY NULL,
    [net_pldg_amt] MONEY NULL,
    [ISIN_Type] VARCHAR(30) NULL,
    [NBFC_Block_Qty] INT NULL,
    [Client_Type] VARCHAR(50) NULL,
    [Client_name] VARCHAR(200) NULL,
    [Migrated] VARCHAR(10) NULL,
    [qty_limit1] INT NULL,
    [qty_limit2] INT NULL,
    [BseCode] VARCHAR(20) NULL,
    [NseSymbol] VARCHAR(20) NULL,
    [id] INT IDENTITY(1,1) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_vw_rmsdtclfi_collection
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_vw_rmsdtclfi_collection]
(
    [party_code] VARCHAR(10) NULL,
    [groupname] VARCHAR(15) NOT NULL,
    [amount] MONEY NULL,
    [Deposit] MONEY NULL,
    [Hold_app] MONEY NULL,
    [hold_nonapp] MONEY NULL,
    [hold_total] MONEY NULL,
    [Un_Reco] MONEY NULL,
    [Exposure] MONEY NULL,
    [Margin_Shortage] MONEY NULL,
    [HoldingWithHC] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Vw_RmsDtclFi_Collection__Raw
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Vw_RmsDtclFi_Collection__Raw]
(
    [RMS_Date] DATETIME NULL,
    [Co_code] VARCHAR(10) NULL,
    [Branch_cd] VARCHAR(10) NULL,
    [Sub_Broker] VARCHAR(10) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Party_name] VARCHAR(100) NULL,
    [Ledger] MONEY NULL,
    [Deposit] MONEY NULL,
    [IMargin] MONEY NULL,
    [Cash_Colleteral] MONEY NULL,
    [NonCash_Colleteral] MONEY NULL,
    [Holding_total] MONEY NULL,
    [Holding_Approved] MONEY NULL,
    [Holding_NonApproved] MONEY NULL,
    [Other_Credit] MONEY NULL,
    [Other_Deposit] MONEY NULL,
    [MTM_Loss_Act] MONEY NULL,
    [MTM_Loss_Proj] MONEY NULL,
    [MTM_Profit_Act] MONEY NULL,
    [NoDel_Loss] MONEY NULL,
    [NoDel_Profit] MONEY NULL,
    [Unrecosiled_Credit] MONEY NULL,
    [MTM_Profit_Proj] MONEY NULL,
    [IMargin_Shortage_value] MONEY NULL,
    [IMargin_Shortage_Percent] MONEY NULL,
    [LastBillDate] DATETIME NULL,
    [LastDrCrDays] INT NULL,
    [Exposure] MONEY NULL,
    [HoldingWithHC] MONEY NULL,
    [groupname] VARCHAR(15) NOT NULL,
    [Brk_Net] MONEY NULL,
    [Ex_Net] MONEY NULL
);

GO

