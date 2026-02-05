-- DDL Export
-- Server: 10.253.33.232
-- Database: INHOUSE_NSE
-- Exported: 2026-02-05T12:29:21.088298

USE INHOUSE_NSE;
GO

-- --------------------------------------------------
-- FUNCTION dbo.MinMaxWorkingDate
-- --------------------------------------------------

CREATE FUNCTION MinMaxWorkingDate(@mdate as varchar(11))      
RETURNS @MinMaxDt TABLE      
   (      
    mindate datetime,  
    maxdate datetime  
   )      
AS      
BEGIN      
         INSERT @MinMaxDt     
         select min(start_date) as mindate, max(start_date) as maxndate from  
  (select top 2 start_date from msajag.dbo.sett_mst where sett_type='N' and start_date<=@mdate order by start_date desc ) x  
    RETURN      
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
 (select party_Code from msajag.dbo.client4_trig with (nolock) where upddate >= @mdate) b
 on a.partY_code=b.party_code
   
RETURN          

END

GO

-- --------------------------------------------------
-- FUNCTION dbo.udf_TitleCase
-- --------------------------------------------------

  CREATE FUNCTION udf_TitleCase (@InputString VARCHAR(4000) )
RETURNS VARCHAR(4000)
AS
BEGIN
DECLARE @Index INT
DECLARE @Char CHAR(1)
DECLARE @OutputString VARCHAR(255)
SET @OutputString = LOWER(@InputString)
SET @Index = 2
SET @OutputString =
STUFF(@OutputString, 1, 1,UPPER(SUBSTRING(@InputString,1,1)))
WHILE @Index <= LEN(@InputString)
BEGIN
SET @Char = SUBSTRING(@InputString, @Index, 1)
IF @Char IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&','''','(')
IF @Index + 1 <= LEN(@InputString)
BEGIN
IF @Char != ''''
OR
UPPER(SUBSTRING(@InputString, @Index + 1, 1)) != 'S'
SET @OutputString =
STUFF(@OutputString, @Index + 1, 1,UPPER(SUBSTRING(@InputString, @Index + 1, 1)))
END
SET @Index = @Index + 1
END
RETURN ISNULL(@OutputString,'')
END

GO

-- --------------------------------------------------
-- INDEX dbo.SCCS_NSE_ShPayout_Credit
-- --------------------------------------------------
CREATE CLUSTERED INDEX [idx_pty] ON [dbo].[SCCS_NSE_ShPayout_Credit] ([Party_Code])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_NSECM_DELTRANS
-- --------------------------------------------------


CREATE procedure [dbo].[NRMS_NSECM_DELTRANS]  
as  
  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  

declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted WITH (NOLOCK) where sett_type='M'  

  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),ISettQty= 0,  
  
IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) , MSAJAG.dbo.DeliveryClt D WITH (NOLOCK)  
  
Left Outer Join MSAJAG.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1 and exists  
  
(select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F','M','Z')  
  
and d.sett_no=b.sett_no and d.sett_type=b.sett_type ) Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From MSAJAG.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F','M','Z')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From MSAJAG.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from MSAJAG.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='NSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from MSAJAG.dbo.MultiIsIn (nolock) where valid=1) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from MSAJAG.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F','M','Z')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='NSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From MSAJAG.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE  valid=1 and DRCR = 'D' AND DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (  
  
SELECT CLTPDPID FROM [CSOKYC-6].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
--AND DT.CLTDPID IN('10184021','10003588')  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'BSECM' AS SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS   
WHERE transdate >= GETDATE()-1  
AND drcr ='d' AND isett_type in ('d','c')  
AND delivered IN ('g','d')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [CSOKYC-6].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='JAIP17555'  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'NSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'BSECM' AS SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS   
WHERE transdate >= GETDATE()-1  
AND drcr ='d' AND isett_type in ('d','c')  
AND delivered IN ('g','d')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [CSOKYC-6].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='JAIP17555'  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'NSECM'  
AND A.DelQty = 0  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_NSECM_DELTRANS_20sept2013
-- --------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure NRMS_NSECM_DELTRANS_20sept2013  

 as   

 /*    

 CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]    
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.
 */    

SET NOCOUNT ON  



 

declare @dt as varchar(11) 

select @dt=convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted  WITH (NOLOCK) where sett_type='N' 

 

select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),ISettQty= 0,

IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  

Into #DPayInMatch  

From MSAJAG.dbo.MultiIsIn M  WITH (NOLOCK) , MSAJAG.dbo.DeliveryClt D  WITH (NOLOCK)

Left Outer Join MSAJAG.dbo.DelTRans c  WITH (NOLOCK)   

On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  

And D.Party_Code = C.Party_Code And DrCr = 'C'  And Filler2 = 1) 

Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1 and exists 

(select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock) 

where start_date <= @dt and sec_payout >=  @dt+' 23:59:00' and sett_type in ('N','W')  

and d.sett_no=b.sett_no and d.sett_type=b.sett_type )  Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn 

Having D.Qty > 0  

  

Insert Into #DPayInMatch  

Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,

ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),

ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End), 

IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End), 

ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  

IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) , 

Hold=0,Pledge=0 From MSAJAG.dbo.DelTrans d  WITH (NOLOCK)  

Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  

and exists (select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  

where start_date <= @dt and sec_payout >=  @dt+' 23:59:00' and sett_type in ('N','W')  

and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  

Group by ISett_No,ISett_Type,Party_Code,CertNo  

  

select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0), 

Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  

into #pledge  

From MSAJAG.dbo.DelTrans D WITH (NOLOCK) ,

(select * from MSAJAG.dbo.DeliveryDp  WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  

Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  

And D.BCltDpId = DP.DpCltNo  

Group By Party_code, CertNo  



Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge From #pledge A  

Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  

  

truncate table BO_Shortage  



insert into BO_Shortage  

select Co_code='NSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  

DelQty=Sum(DelQty),RecQty=Sum(RecQty),  ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  

Hold=Hold,Pledge=Pledge  from #DPayInMatch R, 

(select * from MSAJAG.dbo.MultiIsIn (nolock) ) M  

Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from MSAJAG.dbo.Sett_Mst b (nolock)  

where start_date <= @dt and sec_payout >=  @dt+' 23:59:00' and sett_type in ('N','W')  

and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  

Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  

Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  



insert into BO_Shortage  

SELECT CO_CODE ='NSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD,  M.SERIES, M.ISIN, 

SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0  From MSAJAG.dbo.DelTrans DT WITH (NOLOCK)  

INNER JOIN MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  

WHERE DRCR = 'D' AND DT.TRANSDATE >=  CONVERT(VARCHAR(11),GETDATE() + 1)

AND DT.BCLTDPID IN (

SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)  

--AND DT.CLTDPID IN('10184021','10003588') 
 AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  

GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN 
  




SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_NSECM_DELTRANS_bkup_17jul2018
-- --------------------------------------------------


create procedure [dbo].[NRMS_NSECM_DELTRANS_bkup_17jul2018]  
as  
  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  
  
declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted WITH (NOLOCK) where sett_type='N'  
  
  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),ISettQty= 0,  
  
IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) , MSAJAG.dbo.DeliveryClt D WITH (NOLOCK)  
  
Left Outer Join MSAJAG.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1 and exists  
  
(select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F')  
  
and d.sett_no=b.sett_no and d.sett_type=b.sett_type ) Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From MSAJAG.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From MSAJAG.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from MSAJAG.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='NSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from MSAJAG.dbo.MultiIsIn (nolock) ) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from MSAJAG.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='NSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From MSAJAG.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE DRCR = 'D' AND DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (  
  
SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
--AND DT.CLTDPID IN('10184021','10003588')  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'BSECM' AS SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS   
WHERE transdate >= GETDATE()-1  
AND drcr ='d' AND isett_type in ('d','c')  
AND delivered IN ('g','d')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='JAIP17555'  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'NSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'BSECM' AS SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS   
WHERE transdate >= GETDATE()-1  
AND drcr ='d' AND isett_type in ('d','c')  
AND delivered IN ('g','d')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='JAIP17555'  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'NSECM'  
AND A.DelQty = 0  
  
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.NRMS_NSECM_DELTRANS_bkup_25032022
-- --------------------------------------------------


create procedure [dbo].[NRMS_NSECM_DELTRANS_bkup_25032022]  
as  
  
/*  
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]  
CHANGED BY RAHUL ADDED CDSL POOL ACCOUNT ON 16/08/2013.  
*/  
  
SET NOCOUNT ON  

declare @dt as varchar(11)  
  
select @dt=convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted WITH (NOLOCK) where sett_type='N'  

  
select D.Sett_no,D.Sett_Type,D.Party_Code,CertNo=IsIn,DelQty=D.Qty,RecQty=Sum(IsNull(C.Qty,0)),ISettQty= 0,  
  
IBenQty=0, ISettQtyprint= 0,IBenQtyprint=0,ISettQtyMark= 0,IBenQtyMark=0, Hold=0,Pledge=0  
  
Into #DPayInMatch  
  
From MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) , MSAJAG.dbo.DeliveryClt D WITH (NOLOCK)  
  
Left Outer Join MSAJAG.dbo.DelTRans c WITH (NOLOCK)  
  
On ( D.Sett_no = C.Sett_No And D.Sett_Type = C.Sett_Type And D.Scrip_cd = C.Scrip_cd And D.Series = C.Series  
  
And D.Party_Code = C.Party_Code And DrCr = 'C' And Filler2 = 1)  
  
Where Inout = 'I' And M.Scrip_Cd = D.Scrip_Cd And M.Series = D.Series And Valid = 1 and exists  
  
(select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F')  
  
and d.sett_no=b.sett_no and d.sett_type=b.sett_type ) Group by D.Sett_no,D.Sett_Type,D.Party_Code,D.Qty,IsIn  
  
Having D.Qty > 0  
  
  
  
Insert Into #DPayInMatch  
  
Select ISett_No,ISett_Type,Party_Code,CertNo,Qty=0,RecQty=0,  
  
ISettQty=Sum(Case When TrType <> 1000 Then Qty Else 0 End),IBenQty=Sum(Case When TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyprint= Sum(Case When Delivered = 'G' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyprint= Sum(Case When Delivered = 'G' And TrType = 1000 Then Qty Else 0 End),  
  
ISettQtyMark= Sum(Case When Delivered = '0' And TrType <> 1000 Then Qty Else 0 End),  
  
IBenQtyMark= Sum(Case When Delivered = '0' And TrType = 1000 Then Qty Else 0 End) ,  
  
Hold=0,Pledge=0 From MSAJAG.dbo.DelTrans d WITH (NOLOCK)  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered <> 'D' And TrType in (907,908,1000)  
  
and exists (select sett_no,Sett_type from msajag.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F')  
  
and d.Isett_no=b.sett_no and d.Isett_type=b.sett_type )  
  
Group by ISett_No,ISett_Type,Party_Code,CertNo  
  
  
  
select Party_code, CertNo, Hold=IsNull(Sum(Case When TrType = 904 Then Qty Else 0 End),0),  
  
Pledge=IsNull(Sum(Case When TrType = 909 Then Qty Else 0 End),0)  
  
into #pledge  
  
From MSAJAG.dbo.DelTrans D WITH (NOLOCK) ,  
  
(select * from MSAJAG.dbo.DeliveryDp WITH (NOLOCK) where [Description] Not Like '%POOL%') DP  
  
Where Filler2 = 1 And DrCr = 'D' And Delivered = '0' And TrType in (904,909) And D.BdpId = DP.DpId  
  
And D.BCltDpId = DP.DpCltNo  
  
Group By Party_code, CertNo  
  
  
  
Update #DPayInMatch Set Hold=A.Hold, Pledge=A.Pledge From #pledge A  
  
Where A.Party_Code = #DPayInMatch.Party_Code And A.CertNo = #DPayInMatch.CertNo  
  
  
  
truncate table BO_Shortage  
  
  
  
insert into BO_Shortage  
  
select Co_code='NSECM',Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,ISIN=CertNo,  
  
DelQty=Sum(DelQty),RecQty=Sum(RecQty), ISettQty=Sum(ISettQtyprint),IBenQty=Sum(IBenQtyprint),  
  
Hold=Hold,Pledge=Pledge from #DPayInMatch R,  
  
(select * from MSAJAG.dbo.MultiIsIn (nolock) where valid=1) M  
  
Where M.IsIn = R.CertNo and exists (select sett_no,Sett_type from MSAJAG.dbo.Sett_Mst b (nolock)  
  
where start_date <= @dt and sec_payout >= @dt+' 23:59:00' and sett_type in ('N','W','F')  
  
and R.sett_no=b.sett_no and R.sett_type=b.sett_type )  
  
Group by Sett_no,Sett_Type,R.Party_Code,M.Scrip_CD,M.Series,CertNo,Hold,Pledge  
  
Having Sum(DelQty) > (Sum(RecQty) + Sum(ISettQty) + Sum(IBenQty) )  
  
  
  
insert into BO_Shortage  
  
SELECT CO_CODE ='NSECM', DT.SETT_NO, DT.SETT_TYPE, DT.PARTY_CODE, DT.SCRIP_CD, M.SERIES, M.ISIN,  
  
SUM(DT.QTY) AS QTY, 0, 0, 0, 0, 0 From MSAJAG.dbo.DelTrans DT WITH (NOLOCK)  
  
INNER JOIN MSAJAG.dbo.MultiIsIn M WITH (NOLOCK) ON M.IsIn = DT.CertNo  
  
WHERE  valid=1 and DRCR = 'D' AND DT.TRANSDATE >= CONVERT(VARCHAR(11),GETDATE() + 1)  
  
AND DT.BCLTDPID IN (  
  
SELECT CLTPDPID FROM [196.1.115.182].general.dbo.COLLATERAL_ACCOUNT_MASTER)  
  
--AND DT.CLTDPID IN('10184021','10003588')  
AND DT.CLTDPID IN('10184021','1203320006951435','10003588','1203320000006579')  
  
GROUP BY DT.PARTY_CODE, DT.SCRIP_CD, DT.SETT_NO, DT.SETT_TYPE, M.SERIES, M.ISIN  
  
  
  
/*CODE ADDED BY SUSHANT NAGARKAR ON 20 SEP 2013 TO HANDLE DOUBLE NEGATIVE HOLDING*/  
  
UPDATE A  
SET DelQty = DelQty - B.Qty  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'BSECM' AS SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS   
WHERE transdate >= GETDATE()-1  
AND drcr ='d' AND isett_type in ('d','c')  
AND delivered IN ('g','d')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='JAIP17555'  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')   
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'NSECM'  
  
DELETE A  
--SELECT A.*,B.qty  
FROM BO_Shortage A  
INNER JOIN (  
SELECT 'BSECM' AS SEGMENT,Party_code,CertNo,sett_no,SUM(qty) qty--,cltdpid  
FROM ANGELDEMAT.MSAJAG.DBO.DELTRANS   
WHERE transdate >= GETDATE()-1  
AND drcr ='d' AND isett_type in ('d','c')  
AND delivered IN ('g','d')  
AND BCLTDPID IN (SELECT CLTPDPID FROM [196.1.115.182].GENERAL.dbo.COLLATERAL_ACCOUNT_MASTER)   
--and party_code ='JAIP17555'  
AND cltdpid IN('10184021','1203320006951435','10003588','1203320000006579')  
AND trtype ='1000'  
GROUP BY Party_code,CertNo,sett_no--,cltdpid  
) B  
ON A.Party_code = B.Party_code AND A.ISIN = B.CertNO AND A.sett_no = B.sett_no --AND delqty = B.qty  
WHERE co_Code = 'NSECM'  
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
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';      
        IF @frag >= 30.0      
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD WITH (SORT_IN_TEMPDB = ON)';      
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
-- PROCEDURE dbo.SCCS_NSE_ShPayout
-- --------------------------------------------------
Create procedure SCCS_NSE_ShPayout
as

set nocount on


 Select distinct party_code into #sccs_data from mis.sccs.dbo.sccs_data with (nolock)    

/* FETCH NSE DATA */
 
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='NSE' into  #nsecollateral    
 FROM MSAJAG.DBO.DELTRANS D with (nolock), MSAJAG.DBO.DELIVERYDP DP with (nolock)    
 WHERE BDPTYPE = DP.DPTYPE    
 AND BDPID = DP.DPID    
 AND BCLTDPID = DP.DPCLTNO    
 AND PARTY_CODE <> 'BROKER'    
 AND PARTY_CODE <> 'PARTY'    
 AND TRTYPE in (904, 905, 909)    
 AND DRCR = 'D'    
 AND DELIVERED = '0'    
 AND FILLER2 = 1    
 AND SHARETYPE = 'DEMAT'    
 AND EXCHANGE = 'NSE'    
 AND SEGMENT = 'FUTURES'    
 AND ACCOUNTTYPE = 'MAR'    
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId    


     
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='BSE' into  #bsecollateral    
 FROM BSEDB.DBO.DELTRANS D with (nolock), BSEDB.DBO.DELIVERYDP DP with (nolock)    
 WHERE BDPTYPE = DP.DPTYPE    
 AND BDPID = DP.DPID    
 AND BCLTDPID = DP.DPCLTNO    
 AND PARTY_CODE <> 'BROKER'    
 AND PARTY_CODE <> 'PARTY'    
 AND TRTYPE in (904, 905, 909)    
 AND DRCR = 'D'    
 AND DELIVERED = '0'    
 AND FILLER2 = 1    
 AND SHARETYPE = 'DEMAT'    
 AND EXCHANGE = 'NSE'    
 AND SEGMENT = 'FUTURES'    
 AND ACCOUNTTYPE = 'MAR'    
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId  
 
 
truncate table SCCS_NSE_ShPayout_Credit 

insert into SCCS_NSE_ShPayout_Credit 
select a.*,getdate() from #nsecollateral a join #sccs_data b on a.party_code=b.party_code

insert into SCCS_NSE_ShPayout_Credit 
select a.*,getdate() from #bsecollateral a join #sccs_data b on a.party_code=b.party_code

 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_ShPayout_Credit
-- --------------------------------------------------
CREATE procedure [dbo].[SCCS_ShPayout_Credit]  
as  
  
set nocount on  
   
  
 Select distinct party_code into #sccs_data from mis.sccs.dbo.sccs_data with (nolock)      
  
/* FETCH NSE DATA */  
   
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='NSE' into  #nsecollateral      
 FROM MSAJAG.DBO.DELTRANS D with (nolock), MSAJAG.DBO.DELIVERYDP DP with (nolock)      
 WHERE BDPTYPE = DP.DPTYPE      
 AND BDPID = DP.DPID      
 AND BCLTDPID = DP.DPCLTNO      
 AND PARTY_CODE <> 'BROKER'      
 AND PARTY_CODE <> 'PARTY'      
 AND TRTYPE in (904, 905, 909)      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1      
 AND SHARETYPE = 'DEMAT'      
 AND EXCHANGE  in ( 'NSE','MCD','NSX','MCX','NCX')
 AND SEGMENT = 'FUTURES'      
 AND ACCOUNTTYPE = 'MAR'      
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId      
  

  
       
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='BSE' into  #bsecollateral      
 FROM BSEDB.DBO.DELTRANS D with (nolock), BSEDB.DBO.DELIVERYDP DP with (nolock)      
 WHERE BDPTYPE = DP.DPTYPE      
 AND BDPID = DP.DPID      
 AND BCLTDPID = DP.DPCLTNO      
 AND PARTY_CODE <> 'BROKER'      
 AND PARTY_CODE <> 'PARTY'      
 AND TRTYPE in (904, 905, 909)      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1      
 AND SHARETYPE = 'DEMAT'      
 AND EXCHANGE in ( 'NSE','MCD','NSX','MCX','NCX')
 AND SEGMENT = 'FUTURES'      
 AND ACCOUNTTYPE = 'MAR'      
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId    
   
   
truncate table SCCS_NSE_ShPayout_Credit   
  
insert into SCCS_NSE_ShPayout_Credit   
select a.*,getdate() from #nsecollateral a join #sccs_data b on a.party_code=b.party_code  
  
insert into SCCS_NSE_ShPayout_Credit   
select a.*,getdate() from #bsecollateral a join #sccs_data b on a.party_code=b.party_code  
  
   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_ShPayout_Credit_25012016
-- --------------------------------------------------
Create procedure [dbo].[SCCS_ShPayout_Credit_25012016]  
as  
  
set nocount on  
  
  
 Select distinct party_code into #sccs_data from mis.sccs.dbo.sccs_data with (nolock)      
  
/* FETCH NSE DATA */  
   
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='NSE' into  #nsecollateral      
 FROM MSAJAG.DBO.DELTRANS D with (nolock), MSAJAG.DBO.DELIVERYDP DP with (nolock)      
 WHERE BDPTYPE = DP.DPTYPE      
 AND BDPID = DP.DPID      
 AND BCLTDPID = DP.DPCLTNO      
 AND PARTY_CODE <> 'BROKER'      
 AND PARTY_CODE <> 'PARTY'      
 AND TRTYPE in (904, 905, 909)      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1      
 AND SHARETYPE = 'DEMAT'      
 AND EXCHANGE  in ( 'NSE','MCD','NSX')
 AND SEGMENT = 'FUTURES'      
 AND ACCOUNTTYPE = 'MAR'      
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId      
  

  
       
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='BSE' into  #bsecollateral      
 FROM BSEDB.DBO.DELTRANS D with (nolock), BSEDB.DBO.DELIVERYDP DP with (nolock)      
 WHERE BDPTYPE = DP.DPTYPE      
 AND BDPID = DP.DPID      
 AND BCLTDPID = DP.DPCLTNO      
 AND PARTY_CODE <> 'BROKER'      
 AND PARTY_CODE <> 'PARTY'      
 AND TRTYPE in (904, 905, 909)      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1      
 AND SHARETYPE = 'DEMAT'      
 AND EXCHANGE in ( 'NSE','MCD','NSX')
 AND SEGMENT = 'FUTURES'      
 AND ACCOUNTTYPE = 'MAR'      
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId    
   
   
truncate table SCCS_NSE_ShPayout_Credit   
  
insert into SCCS_NSE_ShPayout_Credit   
select a.*,getdate() from #nsecollateral a join #sccs_data b on a.party_code=b.party_code  
  
insert into SCCS_NSE_ShPayout_Credit   
select a.*,getdate() from #bsecollateral a join #sccs_data b on a.party_code=b.party_code  
  
   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SCCS_ShPayout_Credit_28032013_TT
-- --------------------------------------------------
create procedure SCCS_ShPayout_Credit_28032013_TT  
as  
  
set nocount on  
  
  
 Select distinct party_code into #sccs_data from mis.sccs.dbo.sccs_data with (nolock)      
  
/* FETCH NSE DATA */  
   
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='NSE' into  #nsecollateral      
 FROM MSAJAG.DBO.DELTRANS D with (nolock), MSAJAG.DBO.DELIVERYDP DP with (nolock)      
 WHERE BDPTYPE = DP.DPTYPE      
 AND BDPID = DP.DPID      
 AND BCLTDPID = DP.DPCLTNO      
 AND PARTY_CODE <> 'BROKER'      
 AND PARTY_CODE <> 'PARTY'      
 AND TRTYPE in (904, 905, 909)      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1      
 AND SHARETYPE = 'DEMAT'      
 AND EXCHANGE = 'NSE'      
 AND SEGMENT = 'FUTURES'      
 AND ACCOUNTTYPE = 'MAR'      
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId      
  
  
       
 select Party_Code,scrip_cd,series,BCltDpId,BDpId,Qty=sum(Qty),exchange='BSE' into  #bsecollateral      
 FROM BSEDB.DBO.DELTRANS D with (nolock), BSEDB.DBO.DELIVERYDP DP with (nolock)      
 WHERE BDPTYPE = DP.DPTYPE      
 AND BDPID = DP.DPID      
 AND BCLTDPID = DP.DPCLTNO      
 AND PARTY_CODE <> 'BROKER'      
 AND PARTY_CODE <> 'PARTY'      
 AND TRTYPE in (904, 905, 909)      
 AND DRCR = 'D'      
 AND DELIVERED = '0'      
 AND FILLER2 = 1      
 AND SHARETYPE = 'DEMAT'      
 AND EXCHANGE = 'NSE'      
 AND SEGMENT = 'FUTURES'      
 AND ACCOUNTTYPE = 'MAR'      
 group by Party_Code,scrip_cd,scrip_cd,series,BCltDpId,BDpId    
   
   
truncate table SCCS_NSE_ShPayout_Credit   
  
insert into SCCS_NSE_ShPayout_Credit   
select a.*,getdate() from #nsecollateral a join #sccs_data b on a.party_code=b.party_code  
  
insert into SCCS_NSE_ShPayout_Credit   
select a.*,getdate() from #bsecollateral a join #sccs_data b on a.party_code=b.party_code  
  
   
set nocount off

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
-- PROCEDURE dbo.SMS_Colleteral
-- --------------------------------------------------
CREATE procedure [dbo].[SMS_Colleteral](@mdate as varchar(11))              
as              
              
SET NOCOUNT ON              
   /*           
DECLARE    @MDATE AS VARCHAR(11)           
SET @MDATE='JAN 25 2014'
*/
 

SELECT * INTO #MARGIN_MARGINACC   FROM MARGIN_MARGINACC  WITH (NOLOCK) WHERE SRNO NOT IN 
(SELECT SRNO FROM MARGIN_MARGINACC WHERE (EXCHANGE=EXCHANGE_TO AND SEGMENT=SEGMENT_TO))

SELECT * INTO #MARGIN_MARGINACC_BSE   FROM MARGIN_MARGINACC_BSE  WITH (NOLOCK) WHERE SRNO NOT IN 
(SELECT SRNO FROM MARGIN_MARGINACC_BSE WHERE (EXCHANGE=EXCHANGE_TO AND SEGMENT=SEGMENT_TO))

 DECLARE @MINDATE DATETIME,@MAXDATE DATETIME
 
 SELECT @MINDATE=MINDATE ,@MAXDATE =maxdate  FROM DBO.MINMAXWORKINGDATE(@mdate)
 
-- /* PRMS ID: 10141056 */                   
 SELECT               
 SEGMENT='NSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 INTO #NSE               
 FROM MSAJAG.DBO.DELTRANS_REPORT WITH (NOLOCK) WHERE 
   TRANSDATE >= @MINDATE             
 AND TRANSDATE <= @MAXDATE
 AND  TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
 AND CLTDPID IN (SELECT DPCLTNO FROM MSAJAG.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='MAR')              
AND  BCLTDPID IN (SELECT DPCLTNO FROM MSAJAG.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='BEN')
    
UNION 
 SELECT               
 SEGMENT='NSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 FROM MSAJAG.DBO.DELTRANS_REPORT DR WITH (NOLOCK) WHERE TRANSDATE >= @MINDATE             
 AND TRANSDATE <= @MAXDATE
 AND TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
AND EXISTS (SELECT * FROM #MARGIN_MARGINACC M WHERE DR.CltDpId=M.DPCLTNO AND DR.BCltDpId=M.DPCLTNO_TO)



 /* PRMS ID: 10141056 */                     
 SELECT               
 SEGMENT='BSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 INTO #BSE              
 FROM BSEDB.DBO.DELTRANS_REPORT WITH (NOLOCK) WHERE 
   TRANSDATE >= @MINDATE              
 AND TRANSDATE <= @MAXDATE    AND
 TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
  AND CLTDPID IN (SELECT DPCLTNO FROM BSEDB.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='MAR')              
AND  BCLTDPID IN (SELECT DPCLTNO FROM BSEDB.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='BEN')              
   
UNION
 SELECT               
 SEGMENT='BSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 FROM BSEDB.DBO.DELTRANS_REPORT DR WITH (NOLOCK) WHERE TRANSDATE >= @MINDATE              
 AND TRANSDATE <= @MAXDATE        AND TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
AND EXISTS (SELECT * FROM #MARGIN_MARGINACC_BSE M WHERE DR.CLTDPID=M.DPCLTNO AND DR.BCLTDPID=M.DPCLTNO_TO)
        
         
 /* PRMS id: 10141051 */             
        
 select               
 segment='NSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #nse1        
 from msajag.dbo.deltrans with (nolock) where transdate >= @MINDATE          
 and transdate <= @MAXDATE  
 AND drcr='C' and delivered='0' and filler2=1 and BCltdpid in              
 (select dpcltno from msajag.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and holdername='OFF MARKET'              
 
        
 /* PRMS id: 10141051 */        
        
 select               
 segment='BSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #bse1        
 from bsedb.dbo.deltrans  with (nolock) where transdate >= @MINDATE            
 and transdate <= @MAXDATE      AND  drcr='C' and delivered='0' and filler2=1 and BCltdpid in              
 (select dpcltno from bsedb.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and holdername='OFF MARKET'              
      
               
insert into SMS_CollData               
 select *,'P','P','D2C' as Content_flag  from              
 (              
 select * from #nse              
 union all              
 select * from #bse   
 ) x where sno not in (select sno from SMS_CollData with (nolock))              
         
     
 insert into SMS_CollData               
 select *,'P','P','D2M' as Content_flag  from              
 (              
 select * from #nse1 where cltdpid like '12033200%' and bcltdpid like '12033200%'            
 union all              
 select * from #bse1 where cltdpid like '12033200%' and bcltdpid like '12033200%'               
 ) x where sno not in (select sno from SMS_CollData with (nolock))     
           
    
                   
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SMS_Colleteral_11072017
-- --------------------------------------------------
CREATE procedure [dbo].[SMS_Colleteral_11072017](@mdate as varchar(11))              
as              
              
SET NOCOUNT ON              
   /*           
DECLARE    @MDATE AS VARCHAR(11)           
SET @MDATE='JAN 25 2014'
*/

SELECT * INTO #MARGIN_MARGINACC   FROM MARGIN_MARGINACC  WITH (NOLOCK) WHERE SRNO NOT IN 
(SELECT SRNO FROM MARGIN_MARGINACC WHERE (EXCHANGE=EXCHANGE_TO AND SEGMENT=SEGMENT_TO))

SELECT * INTO #MARGIN_MARGINACC_BSE   FROM MARGIN_MARGINACC_BSE  WITH (NOLOCK) WHERE SRNO NOT IN 
(SELECT SRNO FROM MARGIN_MARGINACC_BSE WHERE (EXCHANGE=EXCHANGE_TO AND SEGMENT=SEGMENT_TO))



-- /* PRMS ID: 10141056 */                   
 SELECT               
 SEGMENT='NSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 INTO #NSE               
 FROM MSAJAG.DBO.DELTRANS_REPORT WITH (NOLOCK) WHERE TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
 AND CLTDPID IN (SELECT DPCLTNO FROM MSAJAG.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='MAR')              
AND  BCLTDPID IN (SELECT DPCLTNO FROM MSAJAG.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='BEN')
  AND TRANSDATE >= (SELECT MINDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))              
 AND TRANSDATE <= (SELECT MAXDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))     
UNION 
 SELECT               
 SEGMENT='NSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 FROM MSAJAG.DBO.DELTRANS_REPORT DR WITH (NOLOCK) WHERE TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
AND EXISTS (SELECT * FROM #MARGIN_MARGINACC M WHERE DR.CltDpId=M.DPCLTNO AND DR.BCltDpId=M.DPCLTNO_TO)
AND TRANSDATE >= (SELECT MINDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))              
 AND TRANSDATE <= (SELECT MAXDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))     


 /* PRMS ID: 10141056 */                     
 SELECT               
 SEGMENT='BSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 INTO #BSE              
 FROM BSEDB.DBO.DELTRANS_REPORT WITH (NOLOCK) WHERE TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
  AND CLTDPID IN (SELECT DPCLTNO FROM BSEDB.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='MAR')              
AND  BCLTDPID IN (SELECT DPCLTNO FROM BSEDB.DBO.DELIVERYDP WITH (NOLOCK) WHERE ACCOUNTTYPE='BEN')              
 AND TRANSDATE >= (SELECT MINDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))              
 AND TRANSDATE <= (SELECT MAXDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))        
UNION
 SELECT               
 SEGMENT='BSECM',SNO,SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,CERTNO AS ISIN,DRCR,DELIVERED,CLTDPID,TRANSDATE,BCLTDPID              
 FROM BSEDB.DBO.DELTRANS_REPORT DR WITH (NOLOCK) WHERE TRTYPE IN ('1002') AND DRCR = 'D' AND DELIVERED = 'G'              
AND EXISTS (SELECT * FROM #MARGIN_MARGINACC_BSE M WHERE DR.CLTDPID=M.DPCLTNO AND DR.BCLTDPID=M.DPCLTNO_TO)
 AND TRANSDATE >= (SELECT MINDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))              
 AND TRANSDATE <= (SELECT MAXDATE FROM DBO.MINMAXWORKINGDATE(@MDATE))          
         
 /* PRMS id: 10141051 */             
        
 select               
 segment='NSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #nse1        
 from msajag.dbo.deltrans with (nolock) where drcr='C' and delivered='0' and filler2=1 and BCltdpid in              
 (select dpcltno from msajag.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and holdername='OFF MARKET'              
 and transdate >= (select MinDate from dbo.MinMaxWorkingDate(@mdate))              
 and transdate <= (select MaxDate from dbo.MinMaxWorkingDate(@mdate))              
        
 /* PRMS id: 10141051 */        
        
 select               
 segment='BSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #bse1        
 from bsedb.dbo.deltrans  with (nolock) where drcr='C' and delivered='0' and filler2=1 and BCltdpid in              
 (select dpcltno from bsedb.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and holdername='OFF MARKET'              
 and transdate >= (select MinDate from dbo.MinMaxWorkingDate(@mdate))              
 and transdate <= (select MaxDate from dbo.MinMaxWorkingDate(@mdate))              
               
insert into SMS_CollData               
 select *,'P','P','D2C' as Content_flag  from              
 (              
 select * from #nse              
 union all              
 select * from #bse   
 ) x where sno not in (select sno from SMS_CollData with (nolock))              
         
     
 insert into SMS_CollData               
 select *,'P','P','D2M' as Content_flag  from              
 (              
 select * from #nse1 where cltdpid like '12033200%' and bcltdpid like '12033200%'            
 union all              
 select * from #bse1 where cltdpid like '12033200%' and bcltdpid like '12033200%'               
 ) x where sno not in (select sno from SMS_CollData with (nolock))     
           
    
                   
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SMS_Colleteral_25012014
-- --------------------------------------------------
CREATE procedure SMS_Colleteral_25012014(@mdate as varchar(11))              
as              
              
SET NOCOUNT ON              
              
 /* PRMS id: 10141056 */                   
 select               
 segment='NSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #nse               
 from msajag.dbo.deltrans_report with (nolock) where trtype in ('1002') and drcr = 'd' and delivered = 'G'              
 and cltdpid in (select dpcltno from msajag.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and transdate >= (select MinDate from dbo.MinMaxWorkingDate(@mdate))              
 and transdate <= (select MaxDate from dbo.MinMaxWorkingDate(@mdate))      
--and (cltdpid!='14216209' and bcltdpid!='32108952') --this line is added by request of nitin hodar(this needs to be reverted)   
        
 /* PRMS id: 10141056 */                     
 select               
 segment='BSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #bse              
 from bsedb.dbo.deltrans_report with (nolock) where trtype in ('1002') and drcr = 'd' and delivered = 'G'              
 and cltdpid in (select dpcltno from bsedb.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and transdate >= (select MinDate from dbo.MinMaxWorkingDate(@mdate))              
 and transdate <= (select MaxDate from dbo.MinMaxWorkingDate(@mdate))        
--and cltdpid!='14216209' and bcltdpid!='32108952' --this line is added by request of nitin hodar(this needs to be reverted)        
         
 /* PRMS id: 10141051 */             
        
 select               
 segment='NSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #nse1        
 from msajag.dbo.deltrans with (nolock) where drcr='C' and delivered='0' and filler2=1 and BCltdpid in              
 (select dpcltno from msajag.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and holdername='OFF MARKET'              
 and transdate >= (select MinDate from dbo.MinMaxWorkingDate(@mdate))              
 and transdate <= (select MaxDate from dbo.MinMaxWorkingDate(@mdate))              
        
 /* PRMS id: 10141051 */        
        
 select               
 segment='BSECM',sno,sett_No,sett_type,party_code,scrip_Cd,series,qty,certno as isin,drcr,delivered,cltdpid,transdate,bcltdpid              
 into #bse1        
 from bsedb.dbo.deltrans  with (nolock) where drcr='C' and delivered='0' and filler2=1 and BCltdpid in              
 (select dpcltno from bsedb.dbo.deliverydp where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))              
 and holdername='OFF MARKET'              
 and transdate >= (select MinDate from dbo.MinMaxWorkingDate(@mdate))              
 and transdate <= (select MaxDate from dbo.MinMaxWorkingDate(@mdate))              
               
insert into SMS_CollData               
 select *,'P','P','D2C' as Content_flag  from              
 (              
 select * from #nse              
 union all              
 select * from #bse   
 ) x where sno not in (select sno from SMS_CollData with (nolock))              
         
     
 insert into SMS_CollData               
 select *,'P','P','D2M' as Content_flag  from              
 (              
 select * from #nse1 where cltdpid like '12033200%' and bcltdpid like '12033200%'            
 union all              
 select * from #bse1 where cltdpid like '12033200%' and bcltdpid like '12033200%'               
 ) x where sno not in (select sno from SMS_CollData with (nolock))     
           
    
                   
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SMS_Colleteral_email
-- --------------------------------------------------
  
CREATE PROCEDURE SMS_Colleteral_email  
as  
SET NOCOUNT ON     
/* insert into intranet.sms.dbo.sms       
after sending sms update the sms_flag='S'      
*/      
      
      
DECLARE                             
@xdate varchar(10),@scrip varchar(100),@qty varchar(10),@pcode varchar(10),    
@email varchar(100),@clname varchar(100),@mess varchar(5000),@mcode varchar(10),    
@srno int,@nor int,@ctr int,@pemail varchar(100)    
    
    
select @nor=count(1) from SMS_Coll_email_data    
set @ctr =1    
    
DECLARE error_cursor CURSOR FOR      
select * from SMS_Coll_email_data order by party_Code, scrip_name    
                  
OPEN error_cursor                                             
FETCH NEXT FROM error_cursor                             
INTO @xdate,@scrip,@qty,@pcode,@email,@clname    
    
set @mcode=''    
    
WHILE @@FETCH_STATUS = 0                            
BEGIN                            
      
  if @mcode <> @pcode    
  BEGIN                    
  
	set @pemail=@email   
  
   if @ctr >= 1     
   BEGIN    
  set @mess = @mess + '</table>'    
  set @mess = @mess + '<br><br>This is only an acknowledgement of collateral being provided by you. In case of any queries kindly feel free to contact us on 33551111 or write to us at feedback@angelbroking.com.<br><br>'    
  set @mess = @mess + '<b>Angel Broking Pvt. Ltd.</b>'    
    
  update SMS_CollData set email_flag='S' where email_flag='P' and party_Code=@mcode    
    
  exec msdb.dbo.sp_send_dbmail                    
  --@recipients  = 'manesh@angelbroking.com;nitin.hodar@angelbroking.com',                             
  @recipients  = @pemail,           
  @profile_name = 'intranet',          
  @subject = 'Acknowledgement of collaterals',                             
  @body_format = 'html',                           
  @body =@mess                            
        
   END    
       
   set @mcode=@pcode     
    
   set @srno=1    
   if @ctr <= @nor    
   BEGIN    
    set @mess = 'To <br>'    
    set @mess = @mess + @clname+'<br>'    
    set @mess = @mess + @pcode+'<br><br>'    
    set @mess = @mess + '<b>Sub: Acknowledgement of collaterals</b><br><br><br>'    
    set @mess = @mess + 'Dear Client,<br><Br>'    
    set @mess = @mess + 'We are in receipt of following Collaterals from you:<br><br>'    
    set @mess = @mess + '<table border="1"><tr><th>Sr.No.</th><th>Date</th><th>Scrip Name</th><th>Quantity</th></tr>'    
    set @mess = @mess + '<tr><td>'+convert(varchar(3),@srno)+'</td><td>'+@xdate+'</td><td>'+@scrip+'</td><td align=right>'+@qty+'</td></tr>'    
 END    
  END    
  ELSE    
  BEGIN    
   set @srno=@srno+1    
   set @mess = @mess + '<tr><td>'+convert(varchar(3),@srno)+'</td><td>'+@xdate+'</td><td>'+@scrip+'</td><td align=right>'+@qty+'</td></tr>'    
  END    
    
                 
FETCH NEXT FROM error_cursor                             
INTO @xdate,@scrip,@qty,@pcode,@email,@clname    
                            
END                                        
CLOSE error_cursor                            
DEALLOCATE error_cursor     
      
           
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SMS_Colleteral_email_backup28022014
-- --------------------------------------------------
    
CREATE PROCEDURE SMS_Colleteral_email_backup28022014
as    
SET NOCOUNT ON       
/* insert into intranet.sms.dbo.sms         
after sending sms update the sms_flag='S'        
*/        
        
        
DECLARE                               
@xdate varchar(10),@scrip varchar(100),@qty varchar(10),@pcode varchar(10),      
@email varchar(100),@clname varchar(100),@mess varchar(5000),@mcode varchar(10),      
@srno int,@nor int,@ctr int,@pemail varchar(100)      
      
      
select @nor=count(1) from SMS_Coll_email_data      
set @ctr =1      
      
DECLARE error_cursor CURSOR FOR        
select * from SMS_Coll_email_data order by party_Code, scrip_name      
                    
OPEN error_cursor                                               
FETCH NEXT FROM error_cursor                               
INTO @xdate,@scrip,@qty,@pcode,@email,@clname      
      
set @mcode=''      
      
WHILE @@FETCH_STATUS = 0                              
BEGIN                              
        
  if @mcode <> @pcode      
  BEGIN                      
    
 set @pemail=@email     
    
   if @ctr >= 1       
   BEGIN      
  set @mess = @mess + '</table>'      
  set @mess = @mess + '<br><br>This is only an acknowledgement of collateral being provided by you. In case of any queries kindly feel free to contact us on 33551111 or write to us at feedback@angelbroking.com.<br><br>'      
  set @mess = @mess + '<b>Angel Broking Pvt. Ltd.</b>'      
      
  update SMS_CollData set email_flag='S' where email_flag='P' and party_Code=@mcode      
      
  exec msdb.dbo.sp_send_dbmail                      
  --@recipients  = 'manesh@angelbroking.com;nitin.hodar@angelbroking.com',                               
  @recipients  = @pemail,             
  @profile_name = 'intranet',            
  @subject = 'Acknowledgement of collaterals',                               
  @body_format = 'html',                             
  @body =@mess                              
          
   END      
         
   set @mcode=@pcode       
      
   set @srno=1      
   if @ctr <= @nor      
   BEGIN      
    set @mess = 'To <br>'      
    set @mess = @mess + @clname+'<br>'      
    set @mess = @mess + @pcode+'<br><br>'      
    set @mess = @mess + '<b>Sub: Acknowledgement of collaterals</b><br><br><br>'      
    set @mess = @mess + 'Dear Client,<br><Br>'      
    set @mess = @mess + 'We are in receipt of following Collaterals from you:<br><br>'      
    set @mess = @mess + '<table border="1"><tr><th>Sr.No.</th><th>Date</th><th>Scrip Name</th><th>Quantity</th></tr>'      
    set @mess = @mess + '<tr><td>'+convert(varchar(3),@srno)+'</td><td>'+@xdate+'</td><td>'+@scrip+'</td><td align=right>'+@qty+'</td></tr>'      
 END      
  END      
  ELSE      
  BEGIN      
   set @srno=@srno+1      
   set @mess = @mess + '<tr><td>'+convert(varchar(3),@srno)+'</td><td>'+@xdate+'</td><td>'+@scrip+'</td><td align=right>'+@qty+'</td></tr>'      
  END      
      
                   
FETCH NEXT FROM error_cursor                               
INTO @xdate,@scrip,@qty,@pcode,@email,@clname      
                              
END                                          
CLOSE error_cursor                              
DEALLOCATE error_cursor       
        
             
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.SMS_Colleteral_sms
-- --------------------------------------------------


CREATE PROCEDURE SMS_Colleteral_sms    
as    
SET NOCOUNT ON       
/* insert into intranet.sms.dbo.sms         
after sending sms update the sms_flag='S'        
*/        

/* PRMS id : 10141056 */

select * into #smsdata from SMS_Coll_sms_data with (nolock) where  convert(varchar(11),mdate,103)=convert(varchar(11),getdate(),103)  
  
select distinct mobile as reg_mobile,                            
mob_message='Dear Customer, your stocks have been moved from your Angel Beneficiary account to Angel Collateral account against margin obligation in '+ rtrim(ltrim(segmentexchange)) +' segment',                                
date=Convert(Varchar(11),getdate(),103),   
Tm = Replace(SubString(Convert(Varchar,dateadd(mi,10,getdate()),9),13,5),' ','')                                
,flag='P',AP=Right(Convert(Varchar,getdate(),100),2),purpose='Collateral',party_code into #sms  
 from #smsdata where  
mobile <> '0' AND (mobile <> '' AND mobile IS NOT NULL)   


/* PRMS id : 10141051 */
insert into #sms  
select distinct mobile_pager as reg_mobile,
mob_message='Dear Customer, your stocks have been moved from your DP account to Angel Margin account against margin obligation in '+rtrim(ltrim(exchange))+' segment.',                                
date=Convert(Varchar(11),getdate(),103),   
Tm = Replace(SubString(Convert(Varchar,dateadd(mi,10,getdate()),9),13,5),' ','')                                
,flag='P',AP=Right(Convert(Varchar,getdate(),100),2),purpose='Collateral',a.party_code
from   
(select * from SMS_Coll_withSCPname_d2m with (nolock) ) a,           
anand1.msajag.dbo.client_Details b with (nolock) where a.party_Code=b.party_code          
and isnull(mobile_pager,'') <> ''          


/* For both the above PRMS request */

insert into intranet.sms.dbo.sms  
select reg_mobile,mob_message,[date],Tm,flag,AP,purpose from #sms   
  
update SMS_CollData set sms_flag='S'  from   
(select * from #sms)b   
where SMS_CollData.sms_flag='P' and SMS_CollData.party_Code=b.party_code  
            
SET NOCOUNT OFF

GO

-- --------------------------------------------------
-- PROCEDURE dbo.UPD_SMS_Colleteral
-- --------------------------------------------------
Create procedure UPD_SMS_Colleteral
as
set nocount on
declare @ndate as varchar(11)
set @ndate = convert(varchar(11),getdate())
print @ndate
exec SMS_Colleteral @ndate
set nocount off

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
-- TABLE dbo.del_109a
-- --------------------------------------------------
CREATE TABLE [dbo].[del_109a]
(
    [Sett_no] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [Party_code] VARCHAR(10) NOT NULL,
    [Qty] INT NOT NULL,
    [Inout] VARCHAR(2) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [PartipantCode] VARCHAR(10) NULL,
    [I_ISIN] VARCHAR(12) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SCCS_NSE_ShPayout_Credit
-- --------------------------------------------------
CREATE TABLE [dbo].[SCCS_NSE_ShPayout_Credit]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [BCltDpId] VARCHAR(16) NULL,
    [BDpId] VARCHAR(16) NULL,
    [Qty] NUMERIC(38, 0) NULL,
    [exchange] VARCHAR(3) NOT NULL,
    [upd_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_CollData
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_CollData]
(
    [segment] VARCHAR(5) NOT NULL,
    [sno] NUMERIC(18, 0) NULL,
    [sett_No] VARCHAR(7) NULL,
    [sett_type] VARCHAR(2) NULL,
    [party_code] VARCHAR(10) NULL,
    [scrip_Cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [qty] NUMERIC(18, 0) NOT NULL,
    [isin] VARCHAR(16) NULL,
    [drcr] CHAR(1) NULL,
    [delivered] CHAR(1) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [transdate] DATETIME NOT NULL,
    [bcltdpid] VARCHAR(16) NULL,
    [sms_flag] VARCHAR(1) NULL DEFAULT 'P',
    [email_flag] VARCHAR(1) NULL DEFAULT 'P',
    [Content_flag] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.SMS_CollData28022014
-- --------------------------------------------------
CREATE TABLE [dbo].[SMS_CollData28022014]
(
    [segment] VARCHAR(5) NOT NULL,
    [sno] NUMERIC(18, 0) NULL,
    [sett_No] VARCHAR(7) NULL,
    [sett_type] VARCHAR(2) NULL,
    [party_code] VARCHAR(10) NULL,
    [scrip_Cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [qty] NUMERIC(18, 0) NOT NULL,
    [isin] VARCHAR(16) NULL,
    [drcr] CHAR(1) NULL,
    [delivered] CHAR(1) NULL,
    [cltdpid] VARCHAR(16) NULL,
    [transdate] DATETIME NOT NULL,
    [bcltdpid] VARCHAR(16) NULL,
    [sms_flag] VARCHAR(1) NULL,
    [email_flag] VARCHAR(1) NULL,
    [Content_flag] VARCHAR(3) NULL
);

GO

-- --------------------------------------------------
-- VIEW dbo.MARGIN_MARGINACC
-- --------------------------------------------------
CREATE VIEW MARGIN_MARGINACC  
AS  
SELECT SRNO=ROW_NUMBER() OVER(ORDER BY EXCHANGE,SEGMENT,DPCLTNO,ACCOUNTTYPE),* FROM  
(SELECT EXCHANGE,SEGMENT,DPCLTNO,ACCOUNTTYPE FROM MSAJAG.DBO.DELIVERYDP DP WITH (NOLOCK) WHERE DP.ACCOUNTTYPE='MAR')A  
FULL OUTER JOIN  
(SELECT EXCHANGE_TO=EXCHANGE,  
SEGMENT_TO=SEGMENT,  
DPCLTNO_TO=DPCLTNO,  
ACCOUNTTYPE_TO=ACCOUNTTYPE FROM MSAJAG.DBO.DELIVERYDP DX WITH (NOLOCK) WHERE DX.ACCOUNTTYPE='MAR')B  
ON A.ACCOUNTTYPE=B.ACCOUNTTYPE_TO

GO

-- --------------------------------------------------
-- VIEW dbo.MARGIN_MARGINACC_BSE
-- --------------------------------------------------
CREATE VIEW MARGIN_MARGINACC_BSE    
AS    
SELECT SRNO=ROW_NUMBER() OVER(ORDER BY EXCHANGE,SEGMENT,DPCLTNO,ACCOUNTTYPE),* FROM    
(SELECT EXCHANGE,SEGMENT,DPCLTNO,ACCOUNTTYPE FROM BSEDB.DBO.DELIVERYDP DP WITH (NOLOCK) WHERE DP.ACCOUNTTYPE='MAR')A    
FULL OUTER JOIN    
(SELECT EXCHANGE_TO=EXCHANGE,    
SEGMENT_TO=SEGMENT,    
DPCLTNO_TO=DPCLTNO,    
ACCOUNTTYPE_TO=ACCOUNTTYPE FROM BSEDB.DBO.DELIVERYDP DX WITH (NOLOCK) WHERE DX.ACCOUNTTYPE='MAR')B    
ON A.ACCOUNTTYPE=B.ACCOUNTTYPE_TO

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
select co_Code='NSECM',sett_no,sett_type,scrip_cd,series,party_code,i_isin,qty=case when inout='I' then -qty else qty end,inout      

from MSAJAG.dbo.deliveryclt a  WITH (NOLOCK)       

where exists  (    

select sett_no,Sett_type from msajag.dbo.Sett_Mst b with (nolock)      

where start_date <=     

(  
select convert(varchar(11),max(vdt)) from ANAND1.ACCOUNT.dbo.BillPosted  WITH (NOLOCK) where sett_type='M'
)    
and sec_payout >     
(  
select convert(varchar(11),max(vdt)) from ANAND1.ACCOUNT.dbo.BillPosted  WITH (NOLOCK) where sett_type='M'
)+' 23:59:59' and sett_type in ('N','W','H','T','M','Z','F')     

and a.sett_no=b.sett_no and a.sett_type=b.sett_type    
)

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_DELCLT_HOLDING_BAK_28092018
-- --------------------------------------------------





CREATE View [dbo].[NRMS_DELCLT_HOLDING_BAK_28092018]      
as      
/*      
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]      
*/      

select co_Code='NSECM',sett_no,sett_type,scrip_cd,series,party_code,    
qty=case when inout='I' then -qty else qty end,inout  from MSAJAG.dbo.deliveryclt a  WITH (NOLOCK)      
where exists  (select sett_no,Sett_type from msajag.dbo.Sett_Mst b with (nolock)     
where start_date <= ( select convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted  WITH (NOLOCK) where sett_type='N')    
and sec_payout >  (select convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted  WITH (NOLOCK) where sett_type='N') +' 23:59:59'     
and sett_type in ('N','W','H','T') 
and a.sett_no=b.sett_no and a.sett_type=b.sett_type )

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_DELCLT_HOLDING_bkup_04102022
-- --------------------------------------------------









CREATE View [dbo].[NRMS_DELCLT_HOLDING_bkup_04102022]    

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

select convert(varchar(11),max(vdt)) from ANAND1.ACCOUNT.dbo.BillPosted  WITH (NOLOCK) where sett_type='N'

)    

and sec_payout >     

(  

select convert(varchar(11),max(vdt)) from ANAND1.ACCOUNT.dbo.BillPosted  WITH (NOLOCK) where sett_type='N'

)+' 23:59:59' and sett_type in ('D','C','OS','TS','RD','RC')      

and a.sett_no=b.sett_no and a.sett_type=b.sett_type    

)

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_DELCLT_HOLDING_rcstest
-- --------------------------------------------------





Create View [dbo].[NRMS_DELCLT_HOLDING_rcstest]      



as      



/*      



CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]      



*/      



      



select co_Code='NSECM',sett_no,sett_type,scrip_cd,series,party_code,    
qty=case when inout='I' then -qty else qty end,inout  from MSAJAG.dbo.deliveryclt a  WITH (NOLOCK)      
where exists  (select sett_no,Sett_type from msajag.dbo.Sett_Mst b with (nolock)     
where start_date <= ( select convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted  WITH (NOLOCK) where sett_type='N')    
and sec_payout >  (select convert(varchar(11),max(vdt)) from ANAND1.inhouse.dbo.BillPosted  WITH (NOLOCK) where sett_type='N') +' 23:59:59'     
and sett_type in ('N','W','H','T') 
and a.sett_no=b.sett_no and a.sett_type=b.sett_type ) 
union all
select co_Code='NSECM',sett_no,sett_type,scrip_cd,series,party_code,
qty=case when inout='I' then -qty else qty end,inout  from MSAJAG.dbo.deliveryclt a  WITH (NOLOCK)      
where exists  (select sett_no,Sett_type from msajag.dbo.Sett_Mst b with (nolock)   
where start_date <= getdate ()
and sec_payout > getdate ()
and sett_type in ('F') 
and a.sett_no=b.sett_no and a.sett_type=b.sett_type )

GO

-- --------------------------------------------------
-- VIEW dbo.NRMS_NSECM_HOLDING
-- --------------------------------------------------

CREATE VIEW [dbo].[NRMS_NSECM_HOLDING]      
as      
/*      
CREATED BY MANESH MUKHERJEE ON 26/10/2012 and being used in NRMS (182/General) SP:[Get_HldVarSource]    
changed on 22/07/2014 to cater -ve holding for intersegment where payin is done in CDSL Account by Rahul shah added pool account source in cltdpid   
*/      
      
select co_code='NSECM',D.Scrip_Cd, series=(CASE WHEN LEN(SERIES) > 2 THEN 'EQ' ELSE SERIES END),      
D.Party_Code, Sett_No, Sett_type, QTy=Sum(Qty),ISIN=CertNo,BDpId,BCltDpId,      
HoldQty=Sum(Case When TrType <> 909 Then Qty Else 0 End),PledgeQty=Sum(Case When TrType = 909 Then Qty Else 0 End)       
from MSAJAG.dbo.DELTRANS D with  (nolock)     
where DrCr = 'D' and Filler2 = 1  And Delivered = '0'  And D.Party_Code <> 'BROKER'  And TrType <> 906     
And CertNo <> 'Auction' AND CERTNO LIKE 'IN%'      
group by D.Scrip_Cd,D.SERIES,CertNo, D.Party_Code,Sett_No, Sett_type,BDpId,BCltDpId     
having Sum(Qty) > 0      
    
      
UNION ALL      
      
select co_code='NSECM1',D.Scrip_Cd,     
series=(CASE WHEN LEN(SERIES) > 2 THEN 'EQ' ELSE SERIES END),  D.Party_Code, Sett_No, Sett_type, QTy=Sum(Qty),    
ISIN=CertNo,BDpId,BCltDpId,  HoldQty=Sum(Qty), PledgeQty=0      
from bsedb.dbo.deltrans D with (nolock)     
where transdate > getdate() and  cltdpid  in (select dpcltno from msajag..DeliveryDp where ACCOUNTTYPE ='pool') 
and trtype ='1000'  and BDpId Like '%'     
And DrCr = 'D' And D.Party_Code <> 'BROKER'     
And CertNo <> 'Auction' AND CERTNO LIKE 'IN%'     
and BCltDpId not in (select DpId from [CSOKYC-6].general.dbo.collateral_dp with (nolock))
group by D.Scrip_Cd,D.SERIES,CertNo, D.Party_Code,Sett_No, Sett_type,BDpId,BCltDpId     
having Sum(Qty) > 0

GO

-- --------------------------------------------------
-- VIEW dbo.SMS_Coll_email_data
-- --------------------------------------------------
CREATE View SMS_Coll_email_data        
as        
select convert(varchar(11),transdate,103) as mdate,       
Scrip_name,convert(varchar(10),sum(Qty)) as qty, a.party_code,lower(b.email) as email,        
dbo.udf_TitleCase(short_name) as ClientName from SMS_Coll_withSCPname a with (nolock),         
anand1.msajag.dbo.client_Details b with (nolock) where a.party_Code=b.party_code        
and email_flag='P' and email <> '' and content_flag='D2C'       
group by convert(varchar(11),transdate,103),Scrip_name,a.party_code,lower(b.email),dbo.udf_TitleCase(short_name)       
/*
union all    
select top 1 'Testing',Scrip_name='TEST email',Qty='0',party_Code='ZZZZ',email='manesh@angelbroking.com',ClientName='Manesh Mukherjee'     
*/

GO

-- --------------------------------------------------
-- VIEW dbo.SMS_Coll_sms_data
-- --------------------------------------------------

CREATE View SMS_Coll_sms_data          
as          
select convert(varchar(11),transdate,103) as mdate,         
Scrip_name,convert(varchar(10),sum(Qty)) as qty, a.party_code,lower(b.mobile_pager) as mobile,          
dbo.udf_TitleCase(short_name) as ClientName,segmentexchange from (select sc.*,segmentexchange=dp.exchange+' '+dp.segment from   
(select * from SMS_Coll_withSCPname   with (nolock) where content_flag='D2C')sc  
inner join  
(select dpcltno,segment,exchange from msajag.dbo.deliverydp with (nolock)  
 where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE'))dp  
 on sc.cltdpid=dp.dpcltno) a,           
anand1.msajag.dbo.client_Details b with (nolock) where a.party_Code=b.party_code          
and sms_flag='P' and isnull(mobile_pager,'') <> ''          
group by convert(varchar(11),transdate,103),Scrip_name,a.party_code,lower(b.mobile_pager),    
dbo.udf_TitleCase(short_name),a.segmentexchange         
union all      
select top 1 'Testing',Scrip_name='TEST sms',Qty='0',party_Code='ZZZZ',mobile='9820556259',  
ClientName='Renil Pillai',segmentexchange='NSE FUTURES'

GO

-- --------------------------------------------------
-- VIEW dbo.SMS_Coll_withSCPname
-- --------------------------------------------------
CREATE View SMS_Coll_withSCPname  
as  
select a.*,b.scrip_name from SMS_CollData a with (nolock) left outer join   
(select isin,Scrip_name=max(scripName) from intranet.risk.dbo.scrip_master with (nolock) group by isin) b  
on a.isin=b.isin

GO

-- --------------------------------------------------
-- VIEW dbo.SMS_Coll_withSCPname_d2m
-- --------------------------------------------------

CREATE View SMS_Coll_withSCPname_d2m  
as  
select sc.*,  
Case when exchange='NSE' then 'FNO'   
when exchange='BSE' then 'BSEFO'   
when exchange='MCD' then 'MCX Currency'   
when exchange='NSX' then 'NSE Currency'   
else exchange end as exchange  
from     
(select * from SMS_CollData   with (nolock) where content_flag='D2M' and sms_flag='P')sc    
inner join    
(select dpcltno,segment,exchange from msajag.dbo.deliverydp with (nolock)    
 where segment='FUTURES' and exchange in ('NSE','MCD','NSX','BSE') and dpcltno like '12033200%' )dp    
 on sc.bcltdpid=dp.dpcltno

GO

-- --------------------------------------------------
-- VIEW dbo.VW_Client4_def1
-- --------------------------------------------------

CREATE View VW_Client4_def1
as
select party_Code,bankid,cltdpid,depository 
from msajag.dbo.client4 a with (nolock) where defdp=1
AND (depository='CDSL' or depository='NSDL')

GO

