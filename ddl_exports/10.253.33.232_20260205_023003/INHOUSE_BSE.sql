-- DDL Export
-- Server: 10.253.33.232
-- Database: INHOUSE_BSE
-- Exported: 2026-02-05T02:30:08.088243

USE INHOUSE_BSE;
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
-- FUNCTION dbo.NRMS_Client4
-- --------------------------------------------------
CREATE FUNCTION NRMS_Client4(@mdate varchar(25))          
RETURNS @NRMS_BSECM_Client4 TABLE          
   (   
		[Party Code] varchar(10),  
		[BankID] varchar(8),
		[Cltdpid] varchar(20),
		[Depository] varchar(7)
 )          
AS          
BEGIN          

 INSERT @NRMS_BSECM_Client4  
 select a.party_Code,a.bankid,a.cltdpid,a.depository  
 from VW_Client4_def1 a with (nolock) 
 join
 (select party_Code from bsedb.dbo.client4_trig with (nolock) where upddate >= @mdate) b
 on a.partY_code=b.party_code
   
RETURN          

END

GO

-- --------------------------------------------------
-- INDEX dbo.sysdiagrams
-- --------------------------------------------------
CREATE UNIQUE NONCLUSTERED INDEX [UK_principal_name] ON [dbo].[sysdiagrams] ([principal_id], [name])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [PK__sysdiagr__C2B05B61108B795B] PRIMARY KEY ([diagram_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.sysdiagrams
-- --------------------------------------------------
ALTER TABLE [dbo].[sysdiagrams] ADD CONSTRAINT [UK_principal_name] UNIQUE ([principal_id], [name])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_BSECM_DELTRAN_bkup_july172019
-- --------------------------------------------------
create procedure [dbo].[NRMS_BSECM_DELTRAN_bkup_july172019]  
as  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  
  
declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANAND.ACCOUNT_AB.dbo.BillPosted WITH (NOLOCK) where sett_type='D'  
  
  
  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),  
  
ISettQty= 0,IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ,  
  
BSEDB.dbo.DeliveryClt D WITH (NOLOCK) Left Outer Join  
  
BSEDB.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1  
  
and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00'  
  
and sett_type in ('D','C') and d.sett_no=b.sett_no and d.sett_type=b.sett_type )  
  
Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),  
  
IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From BSEDB.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from bsedb.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From BSEDB.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from BSEDB.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge  
  
From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='BSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from BSEDB.dbo.MultiIsIn (nolock) ) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='BSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From BSEDB.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE DRCR = 'D' AND DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
AND A.DelQty = 0  
  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_BSECM_DELTRANS
-- --------------------------------------------------
CREATE procedure [dbo].[NRMS_BSECM_DELTRANS]  
as  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  
  
declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANGELBSECM.ACCOUNT_AB.dbo.BillPosted WITH (NOLOCK) where sett_type='D'  
 
  
  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),  
  
ISettQty= 0,IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ,  
  
BSEDB.dbo.DeliveryClt D WITH (NOLOCK) Left Outer Join  
  
BSEDB.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1  
  
and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00'  
  
and sett_type in ('D','C') and d.sett_no=b.sett_no and d.sett_type=b.sett_type )  
  
Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),  
  
IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From BSEDB.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from bsedb.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C','RD','RC')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From BSEDB.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from BSEDB.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge  
  
From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='BSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from BSEDB.dbo.MultiIsIn (nolock) where valid=1 ) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C','RD','RC')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='BSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From BSEDB.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE DRCR = 'D' AND valid=1 and  DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (SELECT CLTPDPID FROM [CSOKYC-6].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [CSOKYC-6].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND BCLTDPID IN (SELECT CLTPDPID FROM [CSOKYC-6].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
AND A.DelQty = 0  
  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_BSECM_DELTRANS_20sept2013
-- --------------------------------------------------
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure NRMS_BSECM_DELTRANS_20sept2013  

 as   

 /*    

 CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]    
 CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.
 */    

  SET NOCOUNT ON  

   

 declare @dt as varchar(11)   

 select @dt=convert(varchar(11),max(vdt)) from ANAND.ACCOUNT_AB.dbo.BillPosted  WITH (NOLOCK) where sett_type='D'   

   

 select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),  

 ISettQty= 0,IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0    

 Into #DPayInMatch  

 From BSEDB.dbo.MultiIsIn M  WITH (NOLOCK) ,  

 BSEDB.dbo.DeliveryClt D  WITH (NOLOCK) Left Outer Join   

 BSEDB.dbo.DelTRans c  WITH (NOLOCK)     

 On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series    

 And D.Party_Code = C.Party_Code And DrCr = 'C'  And Filler2 = 1)   

 Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1   

 and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)    

 where start_date <= @dt and sec_payout >= @dt+' 23:59:00'   

 and sett_type in ('D','C')  and d.sett_no=b.sett_no and d.sett_type=b.sett_type )    

 Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn   

 Having D.Qty > 0    

   

 Insert Into #DPayInMatch    

 Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  

 ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),    

 IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),    

 ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),    

 IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),    

 ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),    

 IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,    

 Hold=0,Pledge=0 From BSEDB.dbo.DelTrans d  WITH (NOLOCK)  

 Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)    

 and exists (select sett_no,Sett_type from bsedb.dbo.Sett_Mst b (nolock)    

 where start_date <= @dt and sec_payout >=  @dt+' 23:59:00' and sett_type in ('D','C')    

 and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )    

 Group by ISett_No,ISett_Type,Party_Code,CertNo    

   

 select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),    

 Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)    

 into #pledge    

 From BSEDB.dbo.DelTrans D WITH (NOLOCK) ,   

 (select * from BSEDB.dbo.DeliveryDp  WITH (NOLOCK) where [Description] Not Like '%POOL%') DP    

 Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId    

 And D.BCltDpId = DP.DpCltNo    

 Group By Party_code, CertNo   

   

 Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge   

 From #pledge A    

 Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo   

   

 truncate table BO_Shortage  

      

 insert into BO_Shortage    

 select Co_code='BSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,    

 DelQty=Sum(DelQty),RecQty=Sum(RecQty),  ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),    

 Hold=Hold,Pledge=Pledge  from #DPayInMatch R,   

 (select * from BSEDB.dbo.MultiIsIn (nolock) ) M    

 Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)    

 where start_date <= @dt and sec_payout >=  @dt+' 23:59:00' and sett_type in ('D','C')    

 and R.sett_no=b.sett_no and R.sett_type=b.sett_type )    

 Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge    

 Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )    

  

 insert into BO_Shortage    

 SELECT CO_CODE ='BSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD,  M.SERIES, M.ISIN,   

 SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0  From BSEDB.dbo.DelTrans DT WITH (NOLOCK)    

 INNER JOIN BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo    

 WHERE DRCR = 'D' AND DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  

 AND DT.BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)    

 AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  

 GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN   


SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_BSECM_DELTRANS_BKP_15032023
-- --------------------------------------------------

CREATE procedure [dbo].[NRMS_BSECM_DELTRANS_BKP_15032023]  
as  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  
  
declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANAND.ACCOUNT_AB.dbo.BillPosted WITH (NOLOCK) where sett_type='D'  
 
  
  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),  
  
ISettQty= 0,IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ,  
  
BSEDB.dbo.DeliveryClt D WITH (NOLOCK) Left Outer Join  
  
BSEDB.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1  
  
and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00'  
  
and sett_type in ('D','C') and d.sett_no=b.sett_no and d.sett_type=b.sett_type )  
  
Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),  
  
IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From BSEDB.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from bsedb.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C','RD','RC')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From BSEDB.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from BSEDB.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge  
  
From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='BSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from BSEDB.dbo.MultiIsIn (nolock) where valid=1 ) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C','RD','RC')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='BSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From BSEDB.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE DRCR = 'D' AND valid=1 and  DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
AND A.DelQty = 0  
  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_BSECM_DELTRANS_bkup_25032022
-- --------------------------------------------------

CREATE procedure [dbo].[NRMS_BSECM_DELTRANS_bkup_25032022]  
as  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  
  
declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANAND.ACCOUNT_AB.dbo.BillPosted WITH (NOLOCK) where sett_type='D'  
 
  
  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),  
  
ISettQty= 0,IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ,  
  
BSEDB.dbo.DeliveryClt D WITH (NOLOCK) Left Outer Join  
  
BSEDB.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1  
  
and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00'  
  
and sett_type in ('D','C') and d.sett_no=b.sett_no and d.sett_type=b.sett_type )  
  
Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),  
  
IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From BSEDB.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from bsedb.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From BSEDB.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from BSEDB.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge  
  
From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='BSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from BSEDB.dbo.MultiIsIn (nolock) where valid=1 ) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from BSEDB.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('D','C')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='BSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From BSEDB.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN BSEDB.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE DRCR = 'D' AND valid=1 and  DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'NSECM' SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.BSEDB.DBO.DELTRANS WITH(NOLOCK)  
WHERE transdate >=GETDATE()-1  
AND drcr ='d' and isett_type in ('n','w')  
AND delivered in ('g','d')  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='S129975'  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'BSECM'  
AND A.DelQty = 0  
  
  
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
-- PROCEDURE dbo.SEARCHINALL
-- --------------------------------------------------

CREATE PROCEDURE [DBO].[SEARCHINALL] 
(@STRFIND AS VARCHAR(MAX))
AS



BEGIN
    SET NOCOUNT ON; 
    --TO FIND STRING IN ALL PROCEDURES        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) SP_NAME
              ,OBJECT_DEFINITION(OBJECT_ID) SP_DEFINITION
        FROM   SYS.PROCEDURES
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@STRFIND+'%'
    END 

    --TO FIND STRING IN ALL VIEWS        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) VIEW_NAME
              ,OBJECT_DEFINITION(OBJECT_ID) VIEW_DEFINITION
        FROM   SYS.VIEWS
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%'+@STRFIND+'%'
    END 

    --TO FIND STRING IN ALL FUNCTION        
    BEGIN
        SELECT ROUTINE_NAME           FUNCTION_NAME
              ,ROUTINE_DEFINITION     FUNCTION_DEFINITION
        FROM   INFORMATION_SCHEMA.ROUTINES
        WHERE  ROUTINE_DEFINITION LIKE '%'+@STRFIND+'%'
               AND ROUTINE_TYPE = 'FUNCTION'
        ORDER BY
               ROUTINE_NAME
    END

    --TO FIND STRING IN ALL TABLES OF DATABASE.    
    BEGIN
        SELECT T.NAME      AS TABLE_NAME
              ,C.NAME      AS COLUMN_NAME
        FROM   SYS.TABLES  AS T
               INNER JOIN SYS.COLUMNS C
                    ON  T.OBJECT_ID = C.OBJECT_ID
        WHERE  C.NAME LIKE '%'+@STRFIND+'%'
        ORDER BY
               TABLE_NAME
    END
END

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
-- TABLE dbo.a1
-- --------------------------------------------------
CREATE TABLE [dbo].[a1]
(
    [fname] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.BO_Shortage
-- --------------------------------------------------
CREATE TABLE [dbo].[BO_Shortage]
(
    [co_Code] VARCHAR(10) NULL,
    [Sett_no] VARCHAR(10) NULL,
    [Srtt_type] VARCHAR(5) NULL,
    [Party_code] VARCHAR(10) NULL,
    [Scrip_cd] VARCHAR(25) NULL,
    [Series] VARCHAR(10) NULL,
    [ISIN] VARCHAR(15) NULL,
    [DelQty] INT NULL,
    [RecQty] INT NULL,
    [ISettQty] INT NULL,
    [IBenQty] INT NULL,
    [Hold] INT NULL,
    [Pledge] INT NULL
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
-- VIEW dbo.NRMS_BSECM_HOLDING
-- --------------------------------------------------


CREATE VIEW [dbo].[NRMS_BSECM_HOLDING]    
as    
/*    
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
\changed on 22/07/2014 to cater -ve holding for intersegment where payin is done in CDSL Account by Rahul shah) added pool account source in cltdpid   
*/    
    
select co_code='BSECM',    
D.Scrip_Cd,     
series=(CASE WHEN LEN(SERIES) > 2 THEN 'EQ' ELSE SERIES END),      
D.Party_Code, Sett_No, Sett_type, QTy=Sum(Qty),ISIN=CertNo,BDpId,BCltDpId,      
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End),PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)       
from BSEDB.dbo.DELTRANS D with  (nolock)      
where DrCr = 'D' and Filler2 = 1  And Delivered = '0'  And D.Party_Code <> 'BROKER'  And TrType <> 906     
And CertNo <> 'Auction' AND CERTNO LIKE 'IN%'     
group by D.Scrip_Cd,D.SERIES,CertNo, D.Party_Code,Sett_No, Sett_type,BDpId,BCltDpId     
having Sum(Qty) > 0      
    
UNION ALL    
    
select co_code='BSECM1',    
D.Scrip_Cd, series=(CASE WHEN LEN(SERIES) > 2 THEN 'EQ' ELSE SERIES END),      
D.Party_Code, Sett_No, Sett_type, QTy=Sum(Qty),ISIN=CertNo,BDpId,BCltDpId,  HoldQty=Sum(Qty), PledgeQty=0      
from msajag.dbo.deltrans D with (nolock)     
where transdate > getdate() and  cltdpid in (select dpcltno from bsedb..DeliveryDp where ACCOUNTTYPE ='pool') and trtype ='1000'      
And DrCr = 'D' And D.Party_Code <> 'BROKER'     
And CertNo <> 'Auction' AND CERTNO LIKE 'IN%'    
and BCltDpId not in (select DpId from [CSOKYC-6].general.dbo.collateral_dp with (nolock))
group by D.Scrip_Cd,D.SERIES,CertNo, D.Party_Code,Sett_No, Sett_type,BDpId,BCltDpId having Sum(Qty) > 0

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_DELCLT_HOLDING
-- --------------------------------------------------









CREATE View [dbo].[NRMS_DELCLT_HOLDING]    

as  



/*CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]     

Created by Siva sir on July 17 2019 for interoperabilty 

Changes done by siva for OFS Trade.

*/

/*  

select co_Code='',	sett_no='',	sett_type='',	scrip_cd	='',series='',	party_code='',	qty	='',inout='' 

CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]    */ 

     

select co_Code='BSECM',sett_no,sett_type,scrip_cd,series,party_code,i_isin,qty=case when inout='I' then -qty else qty end,inout      

from BSEDB.dbo.deliveryclt a  WITH (NOLOCK)      

where exists  (    

  

select sett_no,Sett_type from bsedb.dbo.Sett_Mst b     

where start_date <=     

(  

select convert(varchar(11),max(vdt)) from ANAND1.ACCOUNT.dbo.BillPosted  WITH (NOLOCK) where sett_type='M'

)    

and sec_payout >     

(  

select convert(varchar(11),max(vdt)) from ANAND1.ACCOUNT.dbo.BillPosted  WITH (NOLOCK) where sett_type='M'

)+' 23:59:59' and sett_type in ('D','C','OS','TS','RD','RC')      

and a.sett_no=b.sett_no and a.sett_type=b.sett_type    

)

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_DELCLT_HOLDING_BAK_14092019
-- --------------------------------------------------


CREATE View [dbo].[NRMS_DELCLT_HOLDING_BAK_14092019]    
as  

/*CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]     
Created by Siva sir on July 17 2019 for interoperabilty 
*/

select co_Code='',	sett_no='',	sett_type='',	scrip_cd	='',series='',	party_code='',	qty	='',inout='' 

  
/*    
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]    
    
     
select co_Code='BSECM',sett_no,sett_type,scrip_cd,series,party_code,qty=case when inout='I' then -qty else qty end,inout      
from BSEDB.dbo.deliveryclt a  WITH (NOLOCK)      
where exists  (    
  
select sett_no,Sett_type from bsedb.dbo.Sett_Mst b     
where start_date <=     
(  
select convert(varchar(11),max(vdt)) from ANAND.ACCOUNT_AB.dbo.BillPosted  WITH (NOLOCK) where sett_type='D'  
)    
and sec_payout >     
(  
select convert(varchar(11),max(vdt)) from ANAND.ACCOUNT_AB.dbo.BillPosted  WITH (NOLOCK) where sett_type='D'  
)+' 23:59:59' and sett_type in ('D','C','OS','TS')      
and a.sett_no=b.sett_no and a.sett_type=b.sett_type    
)     */

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_PP_BSECM_HOLDING
-- --------------------------------------------------


CREATE VIEW [dbo].[NRMS_PP_BSECM_HOLDING]    
as    
SELECT BCLTDPID AS ACCOUNTID,PARTY_cODE AS DPCLCODE,SCRIP_CD,SERIES,SCRIP_CD AS DPSCCODE,        
CERTNO AS DPREF5,QTY = SUM(QTY) from    
(    
SELECT BCLTDPID,PARTY_cODE,SCRIP_CD,SERIES,CERTNO,QTY     
FROM bsedb.dbo.DELTRANS with (nolock)        
 WHERE DRCR='D'  AND DELIVERED='0'  and filler2 = 1  
/* WHERE DRCR='D' AND (DELIVERED='0' OR (DELIVERED='G' AND  TransDate > GETDATE())) and filler2 = 1    */
) a join [CSOKYC-6].general.dbo.collateral_dp b with (nolock)    
on a.BCLTDPID=b.DPid    
GROUP BY BCLTDPID,PARTY_cODE,SCRIP_CD,SERIES,CERTNO

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_PP_NSECM_HOLDING
-- --------------------------------------------------


CREATE VIEW [dbo].[NRMS_PP_NSECM_HOLDING]    
as    
SELECT BCLTDPID AS ACCOUNTID,PARTY_cODE AS DPCLCODE,SCRIP_CD,SERIES,SCRIP_CD AS DPSCCODE,        
CERTNO AS DPREF5,QTY = SUM(QTY) from    
(    
SELECT BCLTDPID,PARTY_cODE,SCRIP_CD,SERIES,CERTNO,QTY     
FROM msajag.dbo.DELTRANS with (nolock)        
WHERE DRCR='D' AND DELIVERED='0' and Filler2 = 1  
/* WHERE DRCR='D' AND (DELIVERED='0' OR (DELIVERED='G' AND  TransDate > GETDATE())) and filler2 = 1   */
) a join [CSOKYC-6].general.dbo.collateral_dp b with (nolock)    
on a.BCLTDPID=b.DPid    
GROUP BY BCLTDPID,PARTY_cODE,SCRIP_CD,SERIES,CERTNO

GO

-- --------------------------------------------------
-- VIEW dbo.VW_Client4_def1
-- --------------------------------------------------
CREATE View VW_Client4_def1
as
select party_Code,bankid,cltdpid,depository 
from BSEDB.dbo.client4 a with (nolock) where defdp=1
AND (depository='CDSL' or depository='NSDL')

GO

