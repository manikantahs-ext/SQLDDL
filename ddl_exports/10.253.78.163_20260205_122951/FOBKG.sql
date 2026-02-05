-- DDL Export
-- Server: 10.253.78.163
-- Database: FOBKG
-- Exported: 2026-02-05T12:29:57.573191

USE FOBKG;
GO

-- --------------------------------------------------
-- INDEX dbo.FO_Margin
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party_code] ON [dbo].[FO_Margin] ([Party_code], [Spanmargin_Prepayable])

GO

-- --------------------------------------------------
-- INDEX dbo.fo_pre_trade
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_trade_no] ON [dbo].[fo_pre_trade] ([trade_no])

GO

-- --------------------------------------------------
-- INDEX dbo.FOMARGIN
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party_code] ON [dbo].[FOMARGIN] ([Party_code], [Col_after_haircut], [Cash_coll], [Ledgeramount], [Margindate], [Col_without_haircut])

GO

-- --------------------------------------------------
-- INDEX dbo.fomismatch
-- --------------------------------------------------
CREATE CLUSTERED INDEX [branch_Cd] ON [dbo].[fomismatch] ([branch_cd], [brcd])

GO

-- --------------------------------------------------
-- INDEX dbo.fomismatch
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [IX_branch_Cd] ON [dbo].[fomismatch] ([branch_cd], [brcd])

GO

-- --------------------------------------------------
-- INDEX dbo.mcx_mismatch
-- --------------------------------------------------
CREATE CLUSTERED INDEX [branch_Cd] ON [dbo].[mcx_mismatch] ([branch_cd], [brcd])

GO

-- --------------------------------------------------
-- INDEX dbo.ncx_mismatch
-- --------------------------------------------------
CREATE CLUSTERED INDEX [branch_Cd] ON [dbo].[ncx_mismatch] ([branch_cd], [brcd])

GO

-- --------------------------------------------------
-- INDEX dbo.ncx_pre_trade
-- --------------------------------------------------
CREATE NONCLUSTERED INDEX [party_code] ON [dbo].[ncx_pre_trade] ([party_code], [aa], [user_id])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.mcx_term_detail
-- --------------------------------------------------
ALTER TABLE [dbo].[mcx_term_detail] ADD CONSTRAINT [PK_mcx_term_detail] PRIMARY KEY ([term_no])

GO

-- --------------------------------------------------
-- PK_UNIQUE dbo.ncx_term_detail
-- --------------------------------------------------
ALTER TABLE [dbo].[ncx_term_detail] ADD CONSTRAINT [PK_ncx_term_detail] PRIMARY KEY ([term_no])

GO

-- --------------------------------------------------
-- PROCEDURE dbo.a1
-- --------------------------------------------------
CREATE  proc a1 (@name char(20),@value1 char(8) output)
as
select branch_name from ncx_term_detail  where term_no=@name

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECK_FOCLIENT
-- --------------------------------------------------

CREATE PROCEDURE CHECK_FOCLIENT                                                      
AS                                                      
                                              
                                              
SELECT Cl_code into #t                                         
FROM  angelfo.nsefo.dbo.Client5 where Inactivefrom <= getdate()                                                         
                                                      
 update fo_pre_trade set aa='9' where party_code in                                                      
 (                                                      
-- select party_code from angelfo.nsefo.dbo.client5 c5, angelfo.nsefo.dbo.client2 c2 where c2.cl_code=c5.cl_Code and inactivefrom <= getdate()                                                      
                                              
--SELECT Cl_code FROM anand1.msajag.dbo.client_brok_details where Exchange = 'NSE' and Segment = 'Futures'  and inactive_from <= getdate()                                                 
                                              
SELECT Cl_code FROM #t                                              
                                              
 )                                                      
                                                      
---    by    DharmeshM                                              
                                            
SELECT Cl_code into #MissCl FROM angelfo.nsefo.dbo.Client1 --- where Exchange = 'NSE' and Segment = 'Futures'                                              
                                            
Update fo_pre_trade set aa='0' where party_code NOT in                                                      
 (                                                      
select cl_code from  #MissCl                                            
 )                                                    
                                        
                                        
select x.*,brcd=isnull(y.brcd,'')                                         
into #file_a                                        
from mis.fobkg.dbo.FO_PRE_TRADE x                                         
left outer join (                                        
--select party_code,brcd=branch_cd from angelfo.nsefo.dbo.client1 c1 , angelfo.nsefo.dbo.client2 c2 where c1.cl_code=c2.cl_code                                        
select party_code=cl_code,brcd=branch_cd from  angelfo.nsefo.dbo.Client1                                          
) y on x.party_code=y.party_Code                                        
                                        
                                                      
truncate table fomismatch                                                      
                                                      
insert into fomismatch                                                      
select a.party_code,a.USER_ID,a.scrip_name,a.qty,a.AA,                                                      
b.termid,b.termid_desig,b.branch_cd,b.branch_name,b.status,b.conn_type,b.conn_id,b.location,b.segment,b.user_name1,b.ref_name,b.user_addr,b.sub_broker,b.branch_cd_alt,b.sub_broker_alt,trade_date,brcd                                                       
from #file_a a                                             
left outer join mis.ps03.dbo.fo_termid_list b                                                       
on a.user_id=b.termid                                                       
                                        
                                                      
update fomismatch set brcd=b.br_Code2 from br_map b where fomismatch.brcd=b.br_Code1 AND BRCD <> branch_cd                                                  
update fomismatch set aa='9' where branch_Cd <> 'ALL' and branch_Cd <>brcd and brcd <> ''                                                      
update fomismatch set aa='1' where branch_Cd ='HO' and brcd ='XF'                                
update fomismatch set aa='1' where branch_Cd ='BVI' and brcd ='BVIN'              
update fomismatch set aa='1' where branch_Cd ='BVI' and brcd ='TVLG'            
update fomismatch set aa='1' where branch_Cd ='YB' and brcd ='XH'            
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS1'                      
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='SSH'                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='NDD'                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='GDHI'                                              
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='SSH'                              
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='GDHI'                                  
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='HIMT'                       
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='PALP'                            
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='PATAN'          
update fomismatch set aa='1' where branch_Cd ='ACM' and brcd ='AGOLD'                            
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='PTM'              
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELP'                                                  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELL'                                                
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='YD'    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='HSLUD'    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='JLNDR'   
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='MLVYA'   
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NAJAF'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='FRBAD'                        
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NODIA'                     
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='AMRTS'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='CHNDI'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='GJIBD'   
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='MYVR'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='GRGN'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='LUDHN'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NEHRU'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NOIDA'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='VSANT'                    
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELCP'                
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='SEBD'                                                  
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='VKPT'                         
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='GJWK'                                             
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='WRNGL'      
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='GNTUR'     
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='BHL'                                               
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='YI'                                                  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ1'                                                  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='JAM1'                                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='JAMB'            
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='PBR'          
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='PBRG'                                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='SDRN'                                                    
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJN'                                                  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='GRR'              
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='JND'                         
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ2'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='BVN'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJC'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ3'                                                  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ4'                                    
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='ARL'                     
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='GDHAM'                    
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJEB'     
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='BHUJ'       
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJOB'                    
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJRR'                    
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJPCG'                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAPCG'                                                 
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='SVEB'                                                  
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS2'                                                  
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS3'                                  
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='VLSD'                               
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='VP'                                                 
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YA3'                                               
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAM5'                                                  
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAR4'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAK6'                                                  
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='ANAND'                                                  
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YA2'                              
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAS7'                 
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='CNDN'                              
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='VWD'                                                  
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='KTPLY'                              
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='JYNG'                                 
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='COHIN'                 
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='CMBTR'                 
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='ERODE'                 
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='SALEM'                
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='TRPUR'    
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='HBLI'                  
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MDURI'            
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MNGLR'          
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MYSOR'            
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='MESA'                                                   
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='XPU1'   
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='KTHRD'   
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS4'     
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XSAD'     
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='ALWAR'   
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='RJPR'                                   
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='UDAY'                    
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='AJMER'                    
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='BHIL'                    
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='BKNER'                    
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='KOTA'                    
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='MNSVR'                            
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='INDO1'                     
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='INDO2'          
update fomismatch set aa='1' where branch_Cd ='CMBTR' and brcd ='ERODE'                                   
update fomismatch set aa='1' where branch_Cd ='CMBTR' and brcd ='SALEM'                    
update fomismatch set aa='1' where branch_Cd ='CMBTR' and brcd ='TRPUR'                    
update fomismatch set aa='1' where branch_Cd ='KOLK' and brcd ='KOLK1'                    
update fomismatch set aa='1' where branch_Cd ='KOLK' and brcd ='KOLNS'                    
update fomismatch set aa='1' where branch_Cd ='KOLK' and brcd ='KOLPA'                                 
update fomismatch set aa='1' where branch_Cd ='LUCK' and brcd ='KNPR'                    
update fomismatch set aa='1' where branch_Cd ='LUCK' and brcd ='VRNS'                    
update fomismatch set aa='1' where branch_Cd ='VKPT' and brcd ='GJWK'                    
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='AUNDH'                    
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='KLHPR'                    
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='XPU2'      
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='GDHI'     
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='HIMT'   
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='PALP'                        
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='SSH'           
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='CMBTR'                            
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='COHIN'                            
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='ERODE'                            
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='HBLI'                            
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='JYNG'     
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MDURI'     
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MNGLR'    
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='CKPET'    
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MLWAM'    
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='MYSOR'     
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='SALEM'     
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='TCHPL'     
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='TRPUR'     
update fomismatch set aa='1' where branch_Cd ='CHEN' and brcd ='CHENA'     
update fomismatch set aa='1' where branch_Cd ='CHEN' and brcd ='CHENAD'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.CHECK_FOCLIENT_dkm
-- --------------------------------------------------
CREATE PROCEDURE CHECK_FOCLIENT_dkm                                  
AS                                  
                          
                          
SELECT Cl_code into #t                     
FROM anand1.msajag.dbo.client_brok_details where Exchange = 'NSE' and Segment = 'Futures'  and inactive_from <= getdate()                                     
                                  
 update fo_pre_trade set aa='9' where party_code in                                  
 (                                  
-- select party_code from angelfo.nsefo.dbo.client5 c5, angelfo.nsefo.dbo.client2 c2 where c2.cl_code=c5.cl_Code and inactivefrom <= getdate()                                  
                          
--SELECT Cl_code FROM anand1.msajag.dbo.client_brok_details where Exchange = 'NSE' and Segment = 'Futures'  and inactive_from <= getdate()                             
                          
SELECT Cl_code FROM #t                          
                          
 )                                  
                                  
---    by    DharmeshM                          
                        
SELECT Cl_code into #MissCl FROM anand1.msajag.dbo.client_brok_details where Exchange = 'NSE' and Segment = 'Futures'                          
                        
Update fo_pre_trade set aa='0' where party_code NOT in                                  
 (                                  
select cl_code from  #MissCl                        
 )                                
                    
                    
select x.*,brcd=isnull(y.brcd,'')                     
into #file_a                    
from mis.fobkg.dbo.FO_PRE_TRADE x                     
left outer join (                    
--select party_code,brcd=branch_cd from angelfo.nsefo.dbo.client1 c1 , angelfo.nsefo.dbo.client2 c2 where c1.cl_code=c2.cl_code                    
select party_code,brcd=branch_cd from anand1.msajag.dbo.client_Details                    
) y on x.party_code=y.party_Code                    
                    
                                  
truncate table fomismatch                                  
                                  
insert into fomismatch                                  
select a.party_code,a.USER_ID,a.scrip_name,a.qty,a.AA,                                  
b.termid,b.termid_desig,b.branch_cd,b.branch_name,b.status,b.conn_type,b.conn_id,b.location,b.segment,b.user_name1,b.ref_name,b.user_addr,b.sub_broker,b.branch_cd_alt,b.sub_broker_alt,trade_date,brcd                                   
from #file_a a                         
left outer join mis.ps03.dbo.fo_termid_list b                                   
on a.user_id=b.termid                                   
                    
                                  
update fomismatch set brcd=b.br_Code2 from br_map b where fomismatch.brcd=b.br_Code1 AND BRCD <> branch_cd                              
update fomismatch set aa='9' where branch_Cd <> 'ALL' and branch_Cd <>brcd and brcd <> ''                                  
update fomismatch set aa='1' where branch_Cd ='HO' and brcd ='XF'                                  
update fomismatch set aa='1' where branch_Cd ='YB' and brcd ='XH'                                  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELP'                                
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELL'                                
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS1'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='SSH'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='NDD'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='GDHI'                            
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='SSH'                
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='GDHI'                
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='HIMT'                            
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='PALP'          
update fomismatch set aa='1' where branch_Cd ='ACM' and brcd ='AGOLD'          
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='PTM'                             
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='YD'      
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='FRBAD'      
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NODIA'   
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='AMRTS'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='CHNDI'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='GJIBD'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='GRGN'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='LUDHN'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NEHRU'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='NOIDA'  
update fomismatch set aa='1' where branch_Cd ='DELHI' and brcd ='VSANT'  
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='SEBD'                                
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='VKPT'       
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='GJWK'                           
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='WRNGL'   
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='BHL'                             
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='YI'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ1'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='JAM1'                              
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='PBR'                              
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='SDRN'                                  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJN'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='GRR'        
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ2'              
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='BVN'              
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJC'              
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ3'                                
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJ4'                  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='ARL'   
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='GDHAM'  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJEB'  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJOB'  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJRR'  
update fomismatch set aa='1' where branch_Cd ='RAJ' and brcd ='RAJPCG'                               
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='SVEB'                                
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS2'                                
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS3'                
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='VLSD'             
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='VP'                               
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YA3'                             
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAM5'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAR4'              
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAK6'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='ANAND'                                
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YA2'            
update fomismatch set aa='1' where branch_Cd ='YA' and brcd ='YAS7'            
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='VWD'                                
update fomismatch set aa='1' where branch_Cd ='HYD' and brcd ='KTPLY'            
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='JYNG'               
update fomismatch set aa='1' where branch_Cd ='BNG' and brcd ='COHIN'  
update fomismatch set aa='1' where branch_Cd ='AHD' and brcd ='MESA'                                 
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='XPU1'           
update fomismatch set aa='1' where branch_Cd ='XS' and brcd ='XS4'           
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='RJPR'                            
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='UDAY'  
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='AJMER'  
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='BHIL'  
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='BKNER'  
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='KOTA'  
update fomismatch set aa='1' where branch_Cd ='JAIP' and brcd ='MNSVR'          
update fomismatch set aa='1' where branch_Cd ='INDO' and brcd ='INDO1'   
update fomismatch set aa='1' where branch_Cd ='CMBTR' and brcd ='ERODE'                 
update fomismatch set aa='1' where branch_Cd ='CMBTR' and brcd ='SALEM'  
update fomismatch set aa='1' where branch_Cd ='CMBTR' and brcd ='TRPUR'  
update fomismatch set aa='1' where branch_Cd ='KOLK' and brcd ='KOLK1'  
update fomismatch set aa='1' where branch_Cd ='KOLK' and brcd ='KOLNS'  
update fomismatch set aa='1' where branch_Cd ='KOLK' and brcd ='KOLPA'               
update fomismatch set aa='1' where branch_Cd ='LUCK' and brcd ='KNPR'  
update fomismatch set aa='1' where branch_Cd ='LUCK' and brcd ='VRNS'  
update fomismatch set aa='1' where branch_Cd ='VKPT' and brcd ='GJWK'  
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='AUNDH'  
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='KLHPR'  
update fomismatch set aa='1' where branch_Cd ='XPU' and brcd ='XPU2'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.check_mcxclient
-- --------------------------------------------------
CREATE procedure check_mcxclient                
as                
set nocount on         
/* it will insert data in mcx_misamtch table and then it will show the mismatch from that table*/              
          --changes by navin      
          
          
select party_code into #temp from angelcommodity.mcdx.dbo.client5 c5 inner join
angelcommodity.mcdx.dbo.client2 c2 on c2.cl_code=c5.cl_Code
where  inactivefrom <= getdate()

 update  mcx_pre_trade set aa='9' where EXISTS                     
 (                    
 select * from #temp where #temp.party_code = mcx_pre_trade.party_code 
 )                
 
 select party_code into #temp1 from angelcommodity.mcdx.dbo.client2 
 
                     
 update mcx_pre_trade set aa='0' where NOT EXISTS                     
 (                    
 select * from #temp1 where #temp1.party_code = mcx_pre_trade.party_code
 )                    
                    
truncate table mcx_mismatch      
                    
select party_code,USER_ID,scrip_name,qty,AA,term_no,term_desigt,branch_cd,branch_name,nstatus,conn_type,conn_id,location,segement,username,reference,user_address,subbro_code,c.branch,c.subbroker,trade_date,brcd,buy_sell                    
into #temp2 from  (                 
select a.party_code,a.USER_ID,a.scrip_name,a.qty,a.AA,                    
b.term_no,b.term_desigt,b.branch_cd,b.branch_name,b.nstatus,b.conn_type,b.conn_id,b.location,b.segement,b.username,b.reference,b.user_address,b.subbro_code,trade_date,brcd,buy_sell                     
from (select x.*,brcd=isnull(y.brcd,'') from mis.fobkg.dbo.mcx_pre_trade x left outer join (select party_code,brcd=branch_cd from angelcommodity.mcdx.dbo.client1 c1 inner join angelcommodity.mcdx.dbo.client2 c2 on c1.cl_code=c2.cl_code) y   
on x.party_code=y.party_Code)a                     
left outer join mis.fobkg.dbo.mcx_term_detail b                     
on a.user_id=b.term_no                
) as a1 left outer join altsub_branch c              
on a1.term_no=c.termid              

                
                
insert into mcx_mismatch                
select * from #temp2 
                     
                    
update mcx_mismatch set brcd=b.br_Code2 from br_map b where mcx_mismatch.brcd=b.br_Code1 AND BRCD <> branch_cd                    
                    
update mcx_mismatch set aa='9' where branch_Cd <> 'ALL' and branch_Cd <>brcd and brcd <> ''                    
update mcx_mismatch set aa='1' where branch_Cd ='HO' and brcd ='XF'                    
update mcx_mismatch set aa='1' where branch_Cd ='YB' and brcd ='XH'                    
update mcx_mismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELP'                  
update mcx_mismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELL'                  
update mcx_mismatch set aa='1' where branch_Cd ='XS' and brcd ='XS1'                  
update mcx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='SSH'                  
update mcx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='NDD'                  
update mcx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='GDHI'                  
                
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.check_ncxclient
-- --------------------------------------------------
create procedure check_ncxclient
as
set nocount on

 update  ncx_pre_trade set aa='9' where party_code in    
 (    
 select party_code from angelcommodity.ncdx.dbo.client5 c5, angelcommodity.ncdx.dbo.client2 c2 where c2.cl_code=c5.cl_Code and inactivefrom <= getdate()    
 )
     
 update ncx_pre_trade set aa='0' where party_code NOT in    
 (    
 select party_code from angelcommodity.ncdx.dbo.client2     
 )    
    
truncate table ncx_mismatch   
    


insert into ncx_mismatch    
select a.party_code,a.USER_ID,a.scrip_name,a.qty,a.AA,    
b.term_no,b.term_desigt,b.branch_cd,b.branch_name,b.nstatus,b.conn_type,b.conn_id,b.location,b.segement,b.username,b.reference,b.user_address,b.subbro_code,b.branch_cd_alt,b.sub_broker_alt,trade_date,brcd     
from (select x.*,brcd=isnull(y.brcd,'') from mis.fobkg.dbo.ncx_pre_trade x left outer join (select party_code,brcd=branch_cd from angelcommodity.ncdx.dbo.client1 c1 , angelcommodity.ncdx.dbo.client2 c2 where c1.cl_code=c2.cl_code) y on x.party_code=y.party_Code)a     
left outer join mis.fobkg.dbo.ncx_term_detail b     
on a.user_id=b.term_no     
    
update ncx_mismatch set brcd=b.br_Code2 from br_map b where ncx_mismatch.brcd=b.br_Code1 AND BRCD <> branch_cd    
    
update ncx_mismatch set aa='9' where branch_Cd <> 'ALL' and branch_Cd <>brcd and brcd <> ''    
update ncx_mismatch set aa='1' where branch_Cd ='HO' and brcd ='XF'    
update ncx_mismatch set aa='1' where branch_Cd ='YB' and brcd ='XH'    
update ncx_mismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELP'  
update ncx_mismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELL'  
update ncx_mismatch set aa='1' where branch_Cd ='XS' and brcd ='XS1'  
update ncx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='SSH'  
update ncx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='NDD'  
update ncx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='GDHI'  

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.check_ncxclient1
-- --------------------------------------------------
CREATE procedure check_ncxclient1            
as            
set nocount on            
/* it will insert data in ncx_mismatch table from where we display record in mismatch */            

select c2.party_code into #temp from angelcommodity.ncdx.dbo.client5 c5 inner join
angelcommodity.ncdx.dbo.client2 c2 on c2.cl_code=c5.cl_Code
where inactivefrom <= getdate()
 

update ncx_pre_trade set aa='9' where EXISTS 
(select * from #temp where #temp.party_code = ncx_pre_trade.party_code )
                 
 select a1.party_code into #temp1 from angelcommodity.ncdx.dbo.client2 a1  
 --where a1.party_code = ncx_pre_trade.party_code  
 
 
 
 update ncx_pre_trade set aa='0' where NOT EXISTS                
 (                
 select * from #temp1 where #temp1.party_code = ncx_pre_trade.party_code  
 )                
                
truncate table ncx_mismatch               

select party_code,USER_ID,scrip_name,qty,AA,term_no,term_desigt,branch_cd,branch_name,nstatus,conn_type,conn_id,location,segement,username,reference,user_address,subbro_code,c.branch,c.subbroker,trade_date,brcd,buy_sell
into #temp2
from  (             
select a.party_code,a.USER_ID,a.scrip_name,a.qty,a.AA,                
b.term_no,b.term_desigt,b.branch_cd,b.branch_name,b.nstatus,b.conn_type,b.conn_id,b.location,b.segement,b.username,b.reference,b.user_address,b.subbro_code,trade_date,brcd,buy_sell                     
from (select x.*,brcd=isnull(y.brcd,'') from mis.fobkg.dbo.ncx_pre_trade x left outer join (select party_code,brcd=branch_cd from angelcommodity.ncdx.dbo.client1 c1 inner join angelcommodity.ncdx.dbo.client2 c2 on c1.cl_code=c2.cl_code) y   
on x.party_code=y.party_Code)a                 
left outer join mis.fobkg.dbo.ncx_term_detail b                 
on a.user_id=b.term_no            
) as a1 left outer join altsub_branch c          
on a1.term_no=c.termid   
                 

                
            
            
insert into ncx_mismatch                
select * from #temp2          
                 
                
update ncx_mismatch set brcd=b.br_Code2 from br_map b where ncx_mismatch.brcd=b.br_Code1 AND BRCD <> branch_cd                
                
update ncx_mismatch set aa='9' where branch_Cd <> 'ALL' and branch_Cd <>brcd and brcd <> ''                
update ncx_mismatch set aa='1' where branch_Cd ='HO' and brcd ='XF'                
update ncx_mismatch set aa='1' where branch_Cd ='YB' and brcd ='XH'                
update ncx_mismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELP'              
update ncx_mismatch set aa='1' where branch_Cd ='DELHI' and brcd ='DELL'              
update ncx_mismatch set aa='1' where branch_Cd ='XS' and brcd ='XS1'              
update ncx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='SSH'              
update ncx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='NDD'              
update ncx_mismatch set aa='1' where branch_Cd ='YA' and brcd ='GDHI'              
            
set nocount off

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
-- PROCEDURE dbo.FO_Report
-- --------------------------------------------------
CREATE procedure FO_Report  
as  
set transaction isolation level read uncommitted  
  
set nocount on  
  
----------- With Hair Cut  
  
Select Margindate,whc_coll=100-(sum(case  when (Ledgeramount+Cash_coll+Col_after_haircut) > 0   
and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable   
then (Ledgeramount+Cash_coll+Col_after_haircut)   
when (Ledgeramount+Cash_coll+Col_after_haircut) > 0   
and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable   
then Spanmargin_Prepayable else 0 end   
)/ sum(Spanmargin_Prepayable)) *100  
into #WHC  
 from fo_margin a(nolock) left outer join fomargin b(nolock)  
on a.party_code=b.party_code group by Margindate  
  
  
---------- Without Haircut  
  
Select Margindate,  
HC_coll=100-(sum(case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0   
and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable   
then (Ledgeramount+Cash_coll+col_without_haircut)   
when (Ledgeramount+Cash_coll+col_without_haircut) > 0   
and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable   
then Spanmargin_Prepayable else 0 end)/sum(Spanmargin_Prepayable))*100  
into #HC  
from fo_margin a(nolock) left outer join fomargin b(nolock)   
on a.party_code=b.party_code   
group by Margindate  
  
  
delete from FO_reporting   
where report_Date = (select convert(datetime,margindate) from #whc WHERE MARGINDATE IS NOT NULL)  
  
insert into FO_reporting  
select report_Date=convert(datetime,a.margindate),reported=  
(case when a.whc_coll > 20 then b.hc_coll else a.whc_coll end)  
from #whc a left outer join #hc b on a.margindate=b.margindate  
WHERE A.MARGINDATE IS NOT NULL  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.FO_Report_t1
-- --------------------------------------------------
CREATE procedure FO_Report_t1(@tdate as varchar(11))  
as  
set transaction isolation level read uncommitted  
  
set nocount on  
delete from fo_margin_T1 
where convert(datetime,dt)>=@tdate +' 00:00:00' and convert(datetime,dt)<=@tdate +' 23:59:59'

insert into fo_margin_T1 
select * from fo_margin
----------- With Hair Cut  
select * into #tbl from fomargin_T1 
where convert(datetime,margindate)>=@tdate +' 00:00:00' and convert(datetime,margindate)<=@tdate +' 23:59:59'

  
Select Margindate,whc_coll=100-(sum(case  when (Ledgeramount+Cash_coll+Col_after_haircut) > 0   
and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable   
then (Ledgeramount+Cash_coll+Col_after_haircut)   
when (Ledgeramount+Cash_coll+Col_after_haircut) > 0   
and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable   
then Spanmargin_Prepayable else 0 end   
)/ sum(Spanmargin_Prepayable)) *100  
into #WHC  
from fo_margin_T1 a left outer join #tbl b   
on a.party_code=b.party_code group by Margindate  
  
  
---------- Without Haircut  
  
Select Margindate,  
HC_coll=100-(sum(case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0   
and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable   
then (Ledgeramount+Cash_coll+col_without_haircut)   
when (Ledgeramount+Cash_coll+col_without_haircut) > 0   
and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable   
then Spanmargin_Prepayable else 0 end)/sum(Spanmargin_Prepayable))*100  
into #HC  
from fo_margin_T1 a left outer join #tbl b   
on a.party_code=b.party_code   
group by Margindate  
  
  
delete from FO_reporting1   
where report_Date = (select convert(datetime,margindate) from #whc WHERE MARGINDATE IS NOT NULL)  
  
insert into FO_reporting1  
select report_Date=convert(datetime,a.margindate),reported=  
(case when a.whc_coll > 20 then b.hc_coll else a.whc_coll end)  
from #whc a left outer join #hc b on a.margindate=b.margindate  
WHERE A.MARGINDATE IS NOT NULL  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fobrk_report
-- --------------------------------------------------
create procedure fobrk_report(@wh as varchar(10))
as

set nocount on
set transaction isolation level read uncommitted
select party_Code,sbtag=branch_cd,subgroup=sub_Broker into #file1 from intranet.risk.dbo.client_details 

if @wh='WHC'
Begin
	set transaction isolation level read uncommitted
	Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag, 
	coll=case when (Ledgeramount+Cash_coll+Col_after_haircut) > 0 
	and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable 
	then (Ledgeramount+Cash_coll+Col_after_haircut) 
	when (Ledgeramount+Cash_coll+Col_after_haircut) > 0 
	and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable 
	then Spanmargin_Prepayable else 0 end, 
	ledgeramount,cash_coll, col_without_haircut,col_after_haircut 
	from (select a.*,b.sbtag,b.subgroup from fo_margin a (nolock) , #file1 b where a.party_Code=b.party_Code) a left outer join fomargin b 
	on a.party_code=b.party_code 
	order by a.party_code 
end
else
begin
	set transaction isolation level read uncommitted
	Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag, 
	coll=case 	when (Ledgeramount+Cash_coll+col_without_haircut) > 0 
	and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable 
	then (Ledgeramount+Cash_coll+col_without_haircut) 
	when (Ledgeramount+Cash_coll+col_without_haircut) > 0 
	and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable 
	then Spanmargin_Prepayable else 0 end, 
	ledgeramount,cash_coll, col_without_haircut,col_after_haircut 
	from (select a.*,b.sbtag,b.subgroup from fo_margin a (nolock) , #file1 b where a.party_Code=b.party_Code) a left outer join fomargin b 
	on a.party_code=b.party_code 
	order by a.party_code 
end

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fobrk_report_shortage
-- --------------------------------------------------
CREATE procedure fobrk_report_shortage(@wh as varchar(10))      
as      
      
set nocount on      
set transaction isolation level read uncommitted      
select party_Code,sbtag=branch_cd,subgroup=sub_Broker into #file1 from intranet.risk.dbo.client_details       
  
truncate table Shortage_  
      
if @wh='WHC'      
Begin      
 set transaction isolation level read uncommitted      

select a.*,b.sbtag,b.subgroup into #fo from fo_margin a (nolock) left outer join #file1 b     
on a.party_Code=b.party_Code

insert into Shortage_  
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,       
 coll=case when (Ledgeramount+Cash_coll+Col_after_haircut) > 0       
 and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable       
 then (Ledgeramount+Cash_coll+Col_after_haircut)       
 when (Ledgeramount+Cash_coll+Col_after_haircut) > 0       
 and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable       
 then Spanmargin_Prepayable else 0 end,       
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut       
 from #fo a left outer join fomargin b       
 on a.party_code=b.party_code       
 order by a.party_code       

end      
else      
begin      
 set transaction isolation level read uncommitted      
  
insert into Shortage_  
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,       
 coll=case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0       
 and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable       
 then (Ledgeramount+Cash_coll+col_without_haircut)       
 when (Ledgeramount+Cash_coll+col_without_haircut) > 0       
 and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable       
 then Spanmargin_Prepayable else 0 end,       
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut       
 from (select a.*,b.sbtag,b.subgroup from fo_margin a (nolock) left outer join #file1 b     
on a.party_Code=b.party_Code) a left outer join fomargin b       
 on a.party_code=b.party_code       
 order by a.party_code       
end      
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fobrk_report_T1
-- --------------------------------------------------
CREATE procedure fobrk_report_T1(@wh as varchar(10),@tdate as varchar(11))      
as      
      
set nocount on      
set transaction isolation level read uncommitted      
select party_Code,sbtag=branch_cd,subgroup=sub_Broker into #file1 from intranet.risk.dbo.client_details       
 
select * into #fo_margin_t1 from fo_margin_t1 where convert(datetime,dt)>=@tdate+' 00:00:00' and 
convert(datetime,dt)<=@tdate+' 23:59:59'

select * into #fomargin_t1 from fomargin_t1 where convert(datetime,margindate)>=@tdate+' 00:00:00' and 
convert(datetime,margindate)<=@tdate+' 23:59:59'
     
if @wh='WHC'      
Begin      
 set transaction isolation level read uncommitted      
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,       
 coll=case when (Ledgeramount+Cash_coll+Col_after_haircut) > 0       
 and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable       
 then (Ledgeramount+Cash_coll+Col_after_haircut)       
 when (Ledgeramount+Cash_coll+Col_after_haircut) > 0       
 and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable       
 then Spanmargin_Prepayable else 0 end,       
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut       
 from (select a.*,b.sbtag,b.subgroup from #fo_margin_t1 a (nolock) left outer join #file1 b     
 on a.party_Code=b.party_Code) a left outer join #fomargin_t1 b       
 on a.party_code=b.party_code       
 order by a.party_code       
end      
else      
begin      
 set transaction isolation level read uncommitted      
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,       
 coll=case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0       
 and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable       
 then (Ledgeramount+Cash_coll+col_without_haircut)       
 when (Ledgeramount+Cash_coll+col_without_haircut) > 0       
 and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable       
 then Spanmargin_Prepayable else 0 end,       
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut       
 from (select a.*,b.sbtag,b.subgroup from #fo_margin_t1 a (nolock) left outer join #file1 b     
on a.party_Code=b.party_Code) a left outer join #fomargin_t1 b       
 on a.party_code=b.party_code       
 order by a.party_code       
end      
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fobrk_report1
-- --------------------------------------------------
create procedure fobrk_report1(@wh as varchar(10))  
as  
  
set nocount on  
set transaction isolation level read uncommitted  
select party_Code,sbtag=branch_cd,subgroup=sub_Broker into #file1 from intranet.risk.dbo.client_details   
  
if @wh='WHC'  
Begin  
 set transaction isolation level read uncommitted  
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,   
 coll=case when (Ledgeramount+Cash_coll+Col_after_haircut) > 0   
 and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable   
 then (Ledgeramount+Cash_coll+Col_after_haircut)   
 when (Ledgeramount+Cash_coll+Col_after_haircut) > 0   
 and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable   
 then Spanmargin_Prepayable else 0 end,   
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut   
 from (select a.*,b.sbtag,b.subgroup from fo_margin a (nolock) left outer join #file1 b 
on a.party_Code=b.party_Code) a left outer join fomargin b   
 on a.party_code=b.party_code   
 order by a.party_code   
end  
else  
begin  
 set transaction isolation level read uncommitted  
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,   
 coll=case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0   
 and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable   
 then (Ledgeramount+Cash_coll+col_without_haircut)   
 when (Ledgeramount+Cash_coll+col_without_haircut) > 0   
 and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable   
 then Spanmargin_Prepayable else 0 end,   
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut   
 from (select a.*,b.sbtag,b.subgroup from fo_margin a (nolock) left outer join #file1 b 
on a.party_Code=b.party_Code) a left outer join fomargin b   
 on a.party_code=b.party_code   
 order by a.party_code   
end  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fomargin_new
-- --------------------------------------------------
CREATE procedure fomargin_new( @tdate as varchar(25))    
as    
    
set nocount on    
    
/*declare @tdate as varchar(11)    
set @tdate='Nov  9 2005 '    
  */  
declare @acdate as varchar(25)      
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')         
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'        
--print @acdate    
    
--drop table #FOCOL    
--drop table #FOLed    
--drop table #margin    
    
SELECT PARTY_CODE,AMOUNT=SUM(AMOUNT),FINALAMOUNT=SUM(FINALAMOUNT)    
INTO #FOCOL    
from angelfo.Msajag.Dbo.CollateralDetails     
where     
exchange = 'NSE'     
and segment like 'Futures'    
And Coll_Type = 'SEC'    
and EffDate like @tdate +'%'    
and Cash_Ncash = 'N'    
GROUP BY PARTY_cODE    
Order By party_code    
SELECT CLTCODE,BAL=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)     
INTO #FOLED    
FROM angelfo.ACCOUNTFO.DBO.LEDGER WHERE VDT >=@acdate AND VDT <=@tdate  
AND CLTCODE >='A00001' AND CLTCODE <= 'ZZZZZZZ'  AND NARRATION <> 'NSEFOF'+@tdate+' Bill Posted'    
GROUP BY CLTCODE    
    
select     
margindate = left(convert(varchar,margindate,109),11),party_code, branch_cd,short_name,    
ledgeramount = isnull(ledgeramount,0),     
cash_coll = isnull(cash_coll,0),    
initialmargin = isnull(initialmargin,0),    
family,sub_broker,trader    
into #margin    
from angelfo.nsefo.dbo.tbl_clientmargin     
where margindate >= @tdate+' 00:00:00' and margindate <= @tdate+' 23:59:59'    

truncate table fomargin     

insert into fomargin    
select a.*,Col_without_haircut=isnull(b.amount,0),Col_after_haircut=isnull(b.finalamount,0) from    
(select * from #margin) a left outer join #focol b on a.party_Code=b.party_code    
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.fomargin_T1_Query
-- --------------------------------------------------

CREATE procedure fomargin_T1_Query(@tdate as varchar(11))          
as          
          
set nocount on          
          
/*declare @tdate as varchar(11)          
set @tdate='Jun 05 2008'         
*/      
      
declare @EffDate as varchar(11)      
select  @EffDate=convert(varchar(11),max(EffDate)) from angelfo.Msajag.Dbo.CollateralDetails where EffDate<@tdate       
       
        
declare @acdate as varchar(25)            
select @acdate='Apr 1 '+ (case when substring(@tdate,1,3) in ('Jan','Feb','Mar')               
then convert(varchar(4),substring(@tdate,8,4)-1) else convert(varchar(4),substring(@tdate,8,4)) end)+' 00:00:00'              
--print @acdate          
          
--drop table #FOCOL2          
--drop table #FOLed          
--drop table #margin          
--where a.party_code='m709'     
         
SELECT PARTY_CODE,scrip_cd,series,isin,cl_rate,haircut,qty=sum(qty)         
INTO #FOCOL1          
--drop table #FOCOL          
from angelfo.Msajag.Dbo.CollateralDetails           
where           
--party_code = 'JN54' and           
exchange = 'NSE'           
and segment like 'Futures'          
And Coll_Type = 'SEC'          
and EffDate>=@EffDate+' 00:00:00' and effdate<=@EffDate+' 23:59:59'      
and Cash_Ncash = 'N'          
group by PARTY_CODE,scrip_cd,series,isin,cl_rate,haircut    
    
SELECT PARTY_CODE,scrip_cd,series,isin,cl_rate,haircut,qty=sum(qty)         
INTO #FOCOL2          
--drop table #FOCOL          
from angelfo.Msajag.Dbo.CollateralDetails           
where           
--party_code = 'JN54' and           
exchange = 'NSE'           
and segment like 'Futures'          
And Coll_Type = 'SEC'          
and EffDate>=@tdate+' 00:00:00' and effdate<=@tdate+' 23:59:59'      
and Cash_Ncash = 'N'          
group by PARTY_CODE,scrip_cd,series,isin,cl_rate,haircut    
    
    
select a.party_code,amount=(a.cl_rate*isnull(b.qty,0)),    
finalamount=(a.cl_rate*isnull(b.qty,0))-(a.cl_rate*isnull(b.qty,0)*a.haircut/100)     
into #final    
from #FOCOL1 a       
left outer join    
#FOCOL2 b    
on a.party_code=b.party_code and a.scrip_cd=b.scrip_cd    
    
select party_code,amount=sum(amount),finalamount=sum(finalamount)    
into #FOCOL    
from    
#final    
group by party_code     
       
    
    
SELECT CLTCODE,BAL=SUM(CASE WHEN DRCR='D' THEN VAMT ELSE -VAMT END)           
INTO #FOLED          
--drop table #FOLED          
FROM angelfo.ACCOUNTFO.DBO.LEDGER WHERE VDT >=@acdate AND VDT <=@tdate        
--AND CLTCODE >='A00001' AND CLTCODE <= 'ZZZZZZZ'  AND NARRATION <> 'NSEFOFSep 23 2005  Bill Posted'          
AND CLTCODE >='A00001' AND CLTCODE <= 'ZZZZZZZ'  AND NARRATION <> 'NSEFOF'+@tdate+' Bill Posted'          
GROUP BY CLTCODE          
     
--select top 5 * from angelfo.Msajag.Dbo.CollateralDetails       
    
      
select           
margindate = left(convert(varchar,margindate,109),11),party_code, branch_cd,short_name,          
--billamount = isnull(billamount,0),          
ledgeramount = isnull(ledgeramount,0),           
cash_coll = isnull(cash_coll,0),          
--noncash_coll=isnull(noncash_coll,0),           
initialmargin = isnull(initialmargin,0),          
--myear=year(margindate),mmonth=month(margindate),mday=day(margindate),          
family,sub_broker,trader          
--namount=ledgeramount+(cash_coll+noncash_coll),           
--FREEcol=ledgeramount+billamount+(cash_coll+noncash_coll-initialmargin-MTMmargin)          
into #margin          
--drop table #margin          
from angelfo.nsefo.dbo.tbl_clientmargin           
where margindate >= @tdate+' 00:00:00' and margindate <= @tdate+' 23:59:59'          
--and party_code='a1031'          
          
          
---insert into fomargin          
---select a.*,Col_without_haircut=isnull(b.amount,0),Col_after_haircut=isnull(b.finalamount,0) from          
---(select * from #margin where initialmargin > 0) a left outer join #focol b on a.party_Code=b.party_code          
delete from fomargin_T1 where margindate=@tdate          
insert into fomargin_T1          
select a.*,Col_without_haircut=isnull(b.amount,0),Col_after_haircut=isnull(b.finalamount,0) from          
(select * from #margin) a left outer join #focol b on a.party_Code=b.party_code          
      
          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mcx_active_inactive
-- --------------------------------------------------
CREATE proc mcx_active_inactive    
as    
    
set nocount on    
  
select distinct convert(int,trd.user_id) as termid_notindb from mcx_pre_trade trd  where user_id not in    
(select distinct term_no from mcx_term_detail where nstatus='ACTIVE' and segement='MCX')    
order by convert(int,trd.user_id)    
  
select distinct party_code as party_notindb from(      
--select  distinct party_code from(      
select distinct party_code,user_id from mcx_pre_trade       
)as a1      
--where user_id not in (select distinct userid from termparty) )as a2      
where    party_code not in (select distinct party_code from angelcommodity.mcdx.dbo.client2)         
order by party_code    
  
  
select party_code as inact_partycode from       
angelcommodity.mcdx.dbo.client1 c1, angelcommodity.mcdx.dbo.client2 c2, angelcommodity.mcdx.dbo.client5 c5     
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()      
and party_code in (select distinct party_code  from mcx_pre_trade  )   
  
   
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mcx_inactive
-- --------------------------------------------------
--changes by navin 23/04/2012
CREATE proc mcx_inactive       
as      
      
set nocount on         
      
select party_code as partycode_inactive into #test from         
angelcommodity.mcdx.dbo.client1 c1, angelcommodity.mcdx.dbo.client2 c2, angelcommodity.mcdx.dbo.client5 c5       
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()        


select partycode_inactive from #test c1
where EXISTS (select *  from mcx_pre_trade a where c1.partycode_inactive = a.party_code)      
      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mcx_party_notin_database
-- --------------------------------------------------
--changes by navin 23/04/2012
CREATE proc mcx_party_notin_database    
as    
    
set nocount on    
    
select distinct party_code as party_notin_db from(      
--select  distinct party_code from(      
select distinct party_code,user_id from mcx_pre_trade       
)as a1      
--where user_id not in (select distinct userid from termparty) )as a2      
where NOT EXISTS (select * from angelcommodity.mcdx.dbo.client2 a where a1.party_code = a.party_code)         
order by party_code      
    
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.mcx_terminfo
-- --------------------------------------------------
CREATE proc mcx_terminfo  
as  
  
set nocount on  
  
select distinct convert(int,trd.user_id) as termid_notin_db from mcx_pre_trade trd  where user_id not in  
(select distinct term_no from mcx_term_detail where nstatus='ACTIVE' and segement='MCX')  
order by convert(int,trd.user_id)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ncx_active_inactive
-- --------------------------------------------------
create proc ncx_active_inactive  
as  
  
set nocount on  
  
select distinct convert(int,trd.user_id) as termid_notindb from ncx_pre_trade trd  where user_id not in  
(select distinct term_no from ncx_term_detail where nstatus='ACTIVE' and segement='NCX')  
order by convert(int,trd.user_id)  
  


select distinct party_code as party_notin_db from(    
--select  distinct party_code from(    
select distinct party_code,user_id from ncx_pre_trade     
)as a1    
--where user_id not in (select distinct userid from termparty) )as a2    
where    party_code not in (select distinct party_code from angelcommodity.ncdx.dbo.client2 )       
order by party_code 

select party_code as inact_party_code from     
angelcommodity.ncdx.dbo.client1 c1, angelcommodity.ncdx.dbo.client2 c2, angelcommodity.ncdx.dbo.client5 c5   
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()    
and party_code in (select distinct party_code  from ncx_pre_trade  )  

 
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.ncx_inactive
-- --------------------------------------------------
--Changes by navin    
--23/04/2012    
CREATE proc ncx_inactive         
as        
        
set nocount on           
        
--select party_code as partycode_inactive from           
--angelcommodity.ncdx.dbo.client1 c1, angelcommodity.ncdx.dbo.client2 c2, angelcommodity.ncdx.dbo.client5 c5         
--where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()          
--and party_code in (select distinct party_code  from ncx_pre_trade  )        
    
    
select party_code as partycode_inactive into #test from           
angelcommodity.ncdx.dbo.client1 c1, angelcommodity.ncdx.dbo.client2 c2, angelcommodity.ncdx.dbo.client5 c5         
where c1.cl_code = c5.cl_code and c2.cl_code = c1.cl_code  and c5.inactivefrom < getdate()          
  
select partycode_inactive from #test c1  
where EXISTS (select party_code from ncx_pre_trade a  where a.party_code = c1.partycode_inactive)  
    
    
        
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.party_notin_database
-- --------------------------------------------------
--changes by navin  
CREATE proc party_notin_database        
as        
        
set nocount on        
        
select distinct party_code  as party_notin_db from(          
--select  distinct party_code from(          
select distinct party_code,user_id from ncx_pre_trade           
)as a1          
--where user_id not in (select distinct userid from termparty) )as a2          
where NOT EXISTS (select * from angelcommodity.ncdx.dbo.client2 a where a1.party_code = a.party_code)             
order by party_code          
        
set nocount off

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
-- PROCEDURE dbo.Short_JV
-- --------------------------------------------------




CREATE proc Short_JV
as

Declare @str as varchar(50)
set @str = 'fobrk_report_shortage ''wh'''
exec (@str)

select Party_Code,FO_Shortage=Spanmargin_Prepayable-coll into #short_Amt from Shortage_
where Spanmargin_Prepayable-coll <> 0

declare @fdate as varchar(11)                                
select @fdate=convert(varchar(11),sdtcur) from anand.account_ab.dbo.parameter 
where getdate() >= sdtcur and getdate() <= ldtcur                          
print @fdate                                                                         
      
declare @gdate as varchar(25)                                
set @gdate = (select convert(varchar(11),ledger_updated_date)+' 00:00:00' from MIs.Jvfile.dbo.legder_date)                              
print @gdate  

set transaction isolation level read uncommitted                                      
select cltcode,ACDL_Balancea=sum(case when upper(drcr)='D' then vamt else -vamt end)                                        
into #bse_led_a from risk.dbo._abl_ledger  where vdt >=@fdate                                       
and edt <= @gdate  and cltcode in (select Party_Code from #short_Amt )group by cltcode                                         

select cltcode,ACDL_Balancea=case when (ACDL_Balancea) < (ACDL_Balancea)*-1 then (ACDL_Balancea)*-1 else 0 end  into #bse_short from #bse_led_a 

set transaction isolation level read uncommitted                                      
select cltcode,ACDL_Balancea=sum(case when upper(drcr)='D' then vamt else -vamt end)                                        
into #nse_led_a from anand1.inhouse.dbo.ledger  where vdt >=@fdate                                       
and edt <= @gdate  and cltcode in (select Party_Code from #short_Amt )group by cltcode                                         

select cltcode,ACDL_Balancea=case when (ACDL_Balancea) < (ACDL_Balancea)*-1 then (ACDL_Balancea)*-1 else 0 end  into #nse_short from #nse_led_a 

select a.*,NSE_BAL=b.ACDL_Balancea,BSE_BAL=c.ACDL_Balancea 
into #Temp1
from #short_Amt a 
left outer join #nse_short b on a.party_code = b.cltcode
left outer join #bse_short c on a.party_code = c.cltcode

select * into #JVFILE from #Temp1 where BSE_BAL <> 0 and NSE_BAL <> 0

select *,Total_BAL=NSE_BAL+BSE_BAL,Short_Bal=(NSE_BAL+BSE_BAL)-Fo_shortage from #JVFILE

select 
*,
NSE_JV_AMT=case when Fo_Shortage < NSE_BAL then Fo_Shortage else NSE_BAL end 
INTO #NSE_jv
from #JVFILE

SELECT *,
--Fo_shortage-NSE_JV_AMt,
BSE_JV_AMT=case when Fo_shortage-NSE_JV_AMt < BSE_BAL then Fo_shortage-NSE_JV_AMt else BSE_BAL end
into #NSE_JV_FInal
 FROM #NSE_jv

select *,Final_SHortage_amt=FO_Shortage-(NSE_JV_AMT+BSE_JV_AMT) from #NSE_JV_FInal

GO

-- --------------------------------------------------
-- PROCEDURE dbo.terminfo
-- --------------------------------------------------
CREATE proc terminfo  
as  
  
set nocount on  
  
select distinct convert(int,trd.user_id) as termid_notin_db from ncx_pre_trade trd  where user_id not in  
(select distinct term_no from ncx_term_detail where nstatus='ACTIVE' and segement='NCX')  
order by convert(int,trd.user_id)  
  
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.usp_findInUSP
-- --------------------------------------------------
CREATE PROCEDURE usp_findInUSP        
@dbname varchar(500),      
@srcstr varchar(500)        
AS        
        
 set nocount on      
 set @srcstr  = '%' + @srcstr + '%'        
      
 declare @str as varchar(1000)      
 set @str=''      
 if @dbname <>''      
 Begin      
 set @dbname=@dbname+'.dbo.'      
 End      
 else      
 begin      
 set @dbname=db_name()+'.dbo.'      
 End      
 print @dbname      
      
 set @str='select distinct O.name,O.xtype from '+@dbname+'sysComments  C '       
 set @str=@str+' join '+@dbname+'sysObjects O on O.id = C.id '       
 set @str=@str+' where O.xtype in (''P'',''V'') and C.text like '''+@srcstr+''''        
 --print @str      
  exec(@str)      
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FO_Rpt
-- --------------------------------------------------
CREATE Proc USP_FO_Rpt(@fdate as varchar(11),@tdate as varchar(11),@branch as varchar(20))  
as  
  
select PARTY_CODE,SUB_BROKER,SYMBOL,convert(decimal(10,2),STRIKE_PRICE) as STRIKE_PRICE,OPTION_TYPE,EXPIRY_DATE,BUY_QTY,SELL_QTY,WRONG_CODE,  
WRONG_BRANCH,WRONG_SUBBROKER from tbl_Fo_Trade_CHanges (nolock) where sauda_date >= @fdate   
and Sauda_date <= @tdate+' 23:59:59' and branch_cd = @branch

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_FOMARGINUPLOADCSV
-- --------------------------------------------------
CREATE PROC USP_FOMARGINUPLOADCSV               
(              
@filename as varchar(100),
@server as varchar(30)              
)               
as                  
--print @filename    
set nocount on   
set transaction  isolation  level read uncommitted                  
truncate table FO_margin              
declare @path as varchar(200)              
declare @sql as varchar(1000)              
--set @path='G:\MIS\Inetpub\wwwroot\CTCL1.1\Uploaded\' + @filename              
set @path='\\'+@server+'\D$\upload1\Fovar_margin\' + @filename              
--print @filename      
--print @path      
      
SET @SQL = 'BULK INSERT FO_margin FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=2,KeepNULLS)'              
--print @SQL              
exec (@sql) 
select count1=Count(*) from FO_margin(nolock)

set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_FoMismatches
-- --------------------------------------------------
CREATE Proc Usp_FoMismatches (@Type as Char(1))  
As  
  
Select * into #t from fomismatch WHERE AA in ('0','9')  ORDER BY AA,branch_cd   
  
IF @Type = 'C'  
 Select * from #t where AA = 0  
Else IF @Type = 'I'  
Begin  
 Select min(Brcd) BrCd,Party_code,User_Id,min(Scrip_name) Scrip_name,min(Qty) Qty,min(Termid) TermId,min(Branch_Cd) Branch_Cd,min(Location) Location   
 from #t where (Branch_Cd = Brcd or branch_cd = 'ALL') and AA <> 0 group by party_code,User_Id  
End  
Else  
Begin  
 Select min(Brcd) BrCd,Party_code,User_Id,min(Scrip_name) Scrip_name,min(Qty) Qty,min(Termid) TermId,min(Branch_Cd) Branch_Cd,min(Location) Location   
 from #t where Branch_Cd <> Brcd and branch_cd <> 'ALL' and AA <> 0  
 group by party_code,User_Id order by branch_cd  
End

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_FoMismatches_new
-- --------------------------------------------------
CREATE Proc Usp_FoMismatches_new (@Type as Char(1))    
As    
  
Select * into #t from fomismatch WHERE AA in ('0','9')  ORDER BY AA,branch_cd     
    
IF @Type = 'C'    
begin    
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from   
(select * from #t (nolock) )a  
left outer join  
(select * from mis.bse.dbo.tbl_vanda_mismatch)b  
on party_code = partycode where a.AA = 0 
end
Else IF @Type = 'I'    
Begin    
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from
(Select min(Brcd) BrCd,Party_code,User_Id,min(Scrip_name) Scrip_name,min(Qty) Qty,min(Termid) TermId,min(Branch_Cd) Branch_Cd,min(Location) Location     
from #t where (Branch_Cd = Brcd or branch_cd = 'ALL') and AA <> 0 group by party_code,User_Id)a
left outer join
(select * from mis.bse.dbo.tbl_vanda_mismatch)b
on party_code = partycode
End    
Else    
Begin 
select a.*,b.partycode,case when a.party_code=b.partycode then '1' else '0' end Flag from
(Select min(Brcd) BrCd,Party_code,User_Id,min(Scrip_name) Scrip_name,min(Qty) Qty,min(Termid) TermId,min(Branch_Cd) Branch_Cd,min(Location) Location  from #t where Branch_Cd <> Brcd and branch_cd <> 'ALL' and AA <> 0 group by party_code,User_Id  )a
left outer join
(select * from mis.bse.dbo.tbl_vanda_mismatch)b
on party_code = partycode
End

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
-- PROCEDURE dbo.USP_globalfobrk_report1
-- --------------------------------------------------
CREATE procedure USP_globalfobrk_report1(@wh as varchar(10),@access_to as varchar(20),@access_code as varchar(20))          
as          
          
set nocount on          
set transaction isolation level read uncommitted          
select a.*,pcode=b.party_Code,sbtag=b.branch_cd,subgroup=b.sub_Broker into #file1 from mis.fobkg.dbo.fo_margin a (nolock) left outer join     
 intranet.risk.dbo.client_details b         
on a.party_Code=b.party_Code    
     
if @wh='WHC'          
Begin          
 set transaction isolation level read uncommitted          
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,           
 coll=case when (Ledgeramount+Cash_coll+Col_after_haircut) > 0           
 and (Ledgeramount+Cash_coll+Col_after_haircut) < Spanmargin_Prepayable           
 then (Ledgeramount+Cash_coll+Col_after_haircut)           
 when (Ledgeramount+Cash_coll+Col_after_haircut) > 0           
 and (Ledgeramount+Cash_coll+Col_after_haircut) >= Spanmargin_Prepayable           
 then Spanmargin_Prepayable else 0 end,           
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut   into #data        
 from (select * from #file1) a left outer join fomargin b           
 on a.party_code=b.party_code           
 order by a.party_code           
      
 Select      
Date=DT,--[Branch Code]=sbtag,[Sub-Broker]=subgroup,
[Party code]=Party_code,[Span margin]=Span_margin,      
[Pre payable]=Pre_payable,Addition=Spanmargin_Prepayable,MTM,Client_tag,coll      
 from  #data          
       
      
select        
DT='',--sbtag='',subgroup='',
Party_code='',Span_margin=sum(Span_margin),Pre_payable=sum(Pre_payable)      
,Spanmargin_Prepayable=sum(Spanmargin_Prepayable),MTM=sum(MTM),Client_tag='',coll=sum(coll)      
 from #data      
      
end          
else          
begin          
 set transaction isolation level read uncommitted          
 Select DT,Margindate,a.sbtag,a.subgroup,a.Party_code,Span_margin,Pre_payable,Spanmargin_Prepayable,MTM,Client_tag,           
 coll=case  when (Ledgeramount+Cash_coll+col_without_haircut) > 0           
 and (Ledgeramount+Cash_coll+col_without_haircut) < Spanmargin_Prepayable           
 then (Ledgeramount+Cash_coll+col_without_haircut)           
 when (Ledgeramount+Cash_coll+col_without_haircut) > 0           
 and (Ledgeramount+Cash_coll+col_without_haircut) >= Spanmargin_Prepayable           
 then Spanmargin_Prepayable else 0 end,           
 ledgeramount,cash_coll, col_without_haircut,col_after_haircut into #data1           
 from (select * from #file1) a left outer join fomargin b           
 on a.party_code=b.party_code           
 order by a.party_code           
      
   Select      
Date=DT,--[Branch Code]=sbtag,[Sub-Broker]=subgroup,
[Party code]=Party_code,[Span margin]=Span_margin,      
[Pre payable]=Pre_payable,Addition=Spanmargin_Prepayable,MTM,Client_tag,coll      
 from  #data1          
       
      
select        
DT='',--sbtag='',subgroup='',
Party_code='',Span_margin=sum(Span_margin),Pre_payable=sum(Pre_payable)      
,Spanmargin_Prepayable=sum(Spanmargin_Prepayable),MTM=sum(MTM),Client_tag='',coll=sum(coll)      
 from #data1      
end          
set nocount off

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_Mismatch_Commodity
-- --------------------------------------------------
CREATE Proc Usp_Mismatch_Commodity(@Seg as Varchar(3))    
As    
    
Declare @Server as Varchar(50)    
Declare @Table as Varchar(50)    
Declare @Str as Varchar(2000)    
    
IF @Seg = 'M'    
Begin    
 Set @Table = 'mcx_pre_trade'    
 Set @Server = 'angelcommodity.mcdx.dbo.client2'    
 Set @Seg = 'MCX'    
End    
Else    
Begin    
 Set @Table = 'ncx_pre_trade'    
 Set @Server = 'angelcommodity.ncdx.dbo.client2'    
 Set @Seg = 'NCX'    
End    
    
Set @Str = 'Select a.party_code,c.Branch_cd,user_id,Fld_Branch_Cd,scrip_name,qty into #t1 from '+@Table+' a'    
Set @Str = @Str+' Left outer join'    
Set @Str = @Str+' (Select Fld_Manager_Id,Fld_Branch_Cd from Helpdesk.dbo.V_Manager_Details) b'    
Set @Str = @Str+' on a.user_id = b.Fld_Manager_Id Left outer join Intranet.risk.dbo.Client_Details c'    
Set @Str = @Str+' on a.Party_Code = c.Party_Code;'  
Set @Str = @Str+' Select party_code,Branch_cd,user_id,Fld_Branch_Cd,scrip_name,sum(Convert(numeric,qty)) Qty into #t from #t1 group by party_code,Branch_cd,user_id,Fld_Branch_Cd,scrip_name'    
Set @Str = @Str+' Select *,''MISSING'' Status from #t where Party_Code not in (Select distinct party_code from '+@Server+') union all'    
Set @Str = @Str+' Select *,''INACTIVE'' from #t where Party_Code in (Select Distinct Cl_Code from anand1.msajag.dbo.client_brok_details where InActive_from < getdate()'     
Set @Str = @Str+' and Exchange = '''+@Seg+''')'    
    
--Print @Str    
Exec(@Str)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SebiBanned_Traded
-- --------------------------------------------------
CREATE Proc Usp_SebiBanned_Traded  
as  
  
--Select Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA from fomismatch WHERE AA in ('0','9')  
--union all  
--Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
--where AA in ('0','9') and Party_code in (Select Fld_PartyCode from Bse.dbo.tbl_Sebi_Banned b(nolock))   
--Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd  

--Sebi_bannedFromintranet

Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA  into #fomismatch from fomismatch WHERE AA in ('0','9')  
union all  
Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
where AA in ('0','9') and Party_code in (SELECT distinct party_Code from Bse.dbo.Sebi_bannedFromintranet b(nolock))   
Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd 

--select * from #fomismatch where Brcd!=Branch_cd and Branch_cd!='ALL' and AA !='0' and AA !=2

update #fomismatch
set Termid='D'
where Brcd!=Branch_cd and Branch_cd!='ALL' and AA !='0' and AA !=2

select * from #fomismatch where termid !='D'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SebiBanned_Traded_02aug2021
-- --------------------------------------------------
CREATE Proc Usp_SebiBanned_Traded_02aug2021  
as  
  
--Select Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA from fomismatch WHERE AA in ('0','9')  
--union all  
--Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
--where AA in ('0','9') and Party_code in (Select Fld_PartyCode from Bse.dbo.tbl_Sebi_Banned b(nolock))   
--Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd  

--Sebi_bannedFromintranet

Select distinct Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA from fomismatch WHERE AA in ('0','9')  
union all  
Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
where AA in ('0','9') and Party_code in (SELECT distinct party_Code from Bse.dbo.Sebi_bannedFromintranet b(nolock))   
Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SebiBanned_Traded_07jun2021
-- --------------------------------------------------
CREATE Proc Usp_SebiBanned_Traded_07jun2021  
as  
  
--Select Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA from fomismatch WHERE AA in ('0','9')  
--union all  
--Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
--where AA in ('0','9') and Party_code in (Select Fld_PartyCode from Bse.dbo.tbl_Sebi_Banned b(nolock))   
--Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd  

--Sebi_bannedFromintranet

Select distinct Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA from fomismatch WHERE AA in ('0','9')  
union all  
Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
where AA in ('0','9') and Party_code in (SELECT distinct party_Code from Bse.dbo.Sebi_bannedFromintranet b(nolock))   
Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SebiBanned_Traded_AA
-- --------------------------------------------------
CREATE Proc Usp_SebiBanned_Traded_AA 
@PAR INT
as  

Select Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA INTO #TEMP1 from fomismatch WHERE AA in ('0','9')  
union all  
Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
where AA in ('0','9') and Party_code in (Select Fld_PartyCode from Bse.dbo.tbl_Sebi_Banned b(nolock))   
Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd  

SELECT * FROM #TEMP1 WHERE AA = @PAR

GO

-- --------------------------------------------------
-- PROCEDURE dbo.Usp_SebiBanned_Traded_UAT
-- --------------------------------------------------
CREATE Proc Usp_SebiBanned_Traded_UAT
as  
  
--Select Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA from fomismatch WHERE AA in ('0','9')  
--union all  
--Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
--where AA in ('0','9') and Party_code in (Select Fld_PartyCode from Bse.dbo.tbl_Sebi_Banned b(nolock))   
--Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd  

--Sebi_bannedFromintranet

Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Qty,termid,Branch_cd,Location,AA  into #fomismatch from fomismatch WHERE AA in ('0','9')  
union all  
Select Distinct Brcd,Party_Code,USer_Id,Scrip_Name,Sum(Qty) Qty,termid,Branch_cd,Location,'2' from fomismatch a(nolock)  
where AA in ('0','9') and Party_code in (SELECT distinct party_Code from Bse.dbo.Sebi_bannedFromintranet b(nolock))   
Group by Brcd,Party_Code,USer_Id,Scrip_Name,termid,Branch_cd,Location ORDER BY AA,branch_cd 

--select * from #fomismatch where Brcd!=Branch_cd and Branch_cd!='ALL' and AA !='0' and AA !=2

update #fomismatch
set Termid='D'
where Brcd!=Branch_cd and Branch_cd!='ALL' and AA !='0' and AA !=2

select * from #fomismatch where termid !='D'

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_SHOW_FOTradechange
-- --------------------------------------------------
CREATE Proc USP_SHOW_FOTradechange(@fdate as varchar(11),@tdate as varchar(11))    
as    
    
set @fdate = convert(varchar(11),convert(datetime,@fdate,103))    
set @tdate = convert(varchar(11),convert(datetime,@tdate,103))    
    
select '<a href=''/Utilities/updation/nsefo/frmBranchWiseRpt.aspx?Val=1&Code='+branch_cd+'&fdate='+replace(@fdate,' ','_')+'&tdate='+replace(@tdate,' ','_')+'''><b>'+branch_cd+'</b></a>' as branch_cd,
convert(decimal(10,2),sum(Buy_Value)) as Buy_Value,convert(decimal(10,2),sum(Sell_Value)) as Sell_Value    
from tbl_Fo_Trade_CHanges (nolock) where sauda_date >= @fdate and     
Sauda_date <= @tdate+' 23:59:59' group by branch_cd

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPCOMTRD_bulkupload
-- --------------------------------------------------
CREATE proc USPCOMTRD_bulkupload                 
(@filename as varchar(100),@segment as varchar(15),@server as varchar(20))                       
as                          
            
set transaction  isolation  level read uncommitted                          
            
declare @tbl as varchar(15)            
declare @path as varchar(100)                      
declare @sql as varchar(1000)                   
set @tbl = case when @segment = 'MCDX' then 'mcx_pre_trade' else 'ncx_pre_trade' end                
            
set @path='\\'+@server+'\d$\upload1\' + @filename                      
SET @SQL = 'truncate table '+@tbl+';BULK INSERT '+@tbl+' FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=2,KeepNULLS);select * from '+@tbl+''                      
--print @Sql      
exec (@sql)

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPCOMTRD_bulkupload_AUTO
-- --------------------------------------------------
--select * from mcx_pre_trade  
--exec USPCOMTRD_bulkupload_AUTO 'NCX','',''  
  
/*Made by Navin  
Automatic dumping of MCX and NCDEX Data*/  
  
CREATE proc USPCOMTRD_bulkupload_AUTO  
  
as  
BEGIN  
--MCX UPDATION--  
  
  
  
BEGIN  
TRUNCATE TABLE mcx_pre_trade  
INSERT INTO mcx_pre_trade  
SELECT trade_no,trade_status,Inst_id,Inst_name,Contract_code,Expirydate,StrikePrice,OptionType,Filler1,  
Contract_desc,Book_type,Booktype_name,market_type,User_id,Branch_no,Buy_sell,trade_qty,Price,Pro_cli,  
Account,Participant_settler,Reserved1,Reserved,Spread_price,Tradetime,LastModified,  
OrderNo,Reserved2,User_remarks,Filler2,Filler3,Updatingdatetime FROM [196.1.115.233].general.dbo.mcxdata  
  
  
  
  
  
select  
trade_no as [trade no],  
trade_type as [trade type],  
inst_id as [inst id],  
inst_type as [inst type],  
symbol as [symbol],  
expiry_date as [expiry date],  
strike_price as [strike price],  
option_type as [option type],  
NCol as [NCol],  
scrip_name as [scrip name],  
aa as [aa],  
lot_type as [lot type],  
bb as [bb],  
user_id as [user id],  
location as [location],  
buy_sell as [buy sell],  
qty as [qty],  
rate as [rate],  
cl_type as [cl type],  
party_code as [party code],  
broker_code as [broker code],  
a22 as [a22],  
a23 as [a23],  
spread_price as [spread price],  
trade_date as [trade date],  
order_date as [order date],  
order_no as [order no],  
a27 as [a27],  
user_remarks as [user remarks],  
Date1 as [Date1],  
Date2 as [Date2],  
Updatingdatetime as [Updatingdatetime]  
from mcx_pre_trade  
  
  
--NCDEX UPDATION--  
TRUNCATE TABLE ncx_pre_trade  
INSERT INTO ncx_pre_trade  
SELECT trade_no,trade_status,Instrument_id,Instrument_name,Expiray_date,Strike_Price,Option_Type,Contract_desc,  
Book_type,Book_typename,Market_type,user_id,Branch_id,Buy_sell,Trade_qty,Trade_price,Pro_cli,  
Client_Account_nbr,Participant_id,Reserved,Reserved1,Entry_date,Mod_date_time,  
Order_No,Participant_id,Updatingdatetime FROM [196.1.115.233].general.dbo.ncdexdata  
  
select  
trade_no as [trade no],  
trade_type as [trade type],  
inst_type as [inst type],  
symbol as [symbol],  
expiry_date as [expiry date],  
strike_price as [strike price],  
option_type as [option type],  
scrip_name as [scrip name],  
aa as [aa],  
lot_type as [lot type],  
bb as [bb],  
user_id as [user id],  
location as [location],  
buy_sell as [buy sell],  
qty as [qty],  
rate as [rate],  
cl_type as [cl type],  
party_code as [party code],  
broker_code as [broker code],  
style as [style],  
c_u as [c u],  
trade_date as [trade date],  
order_date as [order date],  
order_no as [order no],  
broker_code_a as [broker code a],  
Updatingdatetime as [Updatingdatetime]  
  
from ncx_pre_trade  
END  
  
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPJV_admin_FOTRD
-- --------------------------------------------------
CREATE proc USPJV_admin_FOTRD             
as                      
    
set transaction  isolation  level read uncommitted                      
          
declare @filename as varchar(100)                  
declare @path as varchar(100)                  
declare @sql as varchar(1000)              
declare @cnt as int          
          
set @filename = 'admintrade.txt'        
            
truncate table tbl_on_Terminal_FO_Changes          
                  
set @path='d:\upload1\FoTrade\' + @filename                  
SET @SQL = 'BULK INSERT tbl_on_Terminal_FO_Changes FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=1,KeepNULLS)'          
exec (@sql)                  
        
        
select         
case when x.party_code is null then y.party_code else x.party_code  end as party_code,         
case when x.symbol is null then y.symbol  else x.symbol end as symbol,         
case when x.strike_price is null  then y.strike_price else x.strike_price end as strike_price,         
case when x.option_type is null then y.option_type else  x.option_type  end as option_type,      
case when x.expiry_date is null then y.expiry_date else  x.expiry_date  end as expiry_date,      
isnull(x.qty,0) as BUY_Qty,        
isnull(x.Trade_Value,0) as Buy_Value,        
isnull(y.qty,0) as sell_Qty,        
isnull(y.Trade_Value,0) as Sell_Value into #trd  
 from        
(        
select party_code,symbol,expiry_date,isnull(strike_price,0) as strike_price,option_type,        
sum(qty) as QTY,sum(qty*rate) as Trade_Value        
from tbl_on_Terminal_FO_Changes a (nolock) where exists        
(select * from tbl_on_Terminal_FO_Changes b (nolock)  where       
trade_type = 12 and a.Trade_no = b.Trade_no and a.buy_sell = b.buy_sell ) and trade_type <> 11 and buy_sell = 1  
group by party_code,symbol,expiry_date,isnull(strike_price,0) ,option_type  
) x        
full outer join        
(        
select party_code,symbol,expiry_date,isnull(strike_price,0) as strike_price,option_type,        
sum(qty) as QTY,sum(qty*rate) as Trade_Value        
from tbl_on_Terminal_FO_Changes a (nolock) where exists      
(select * from tbl_on_Terminal_FO_Changes b (nolock) where trade_type = 12 and a.Trade_no = b.Trade_no and a.buy_sell = b.buy_sell)        
and trade_type <> 11 and buy_sell = 2 group by party_code,symbol,expiry_date,isnull(strike_price,0) ,option_type           
) y          
on x.party_code = y.party_code and x.symbol = y.symbol and x.expiry_date = y.expiry_date and         
isnull(x.strike_price,0) = isnull(y.strike_price,0) and x.option_type = y.option_type    
  
  
select Trade_no,trade_type,symbol,expiry_date,strike_price,party_code into #q from   
tbl_on_Terminal_FO_Changes  x (nolock) where exists (select * from tbl_on_Terminal_FO_Changes y (nolock) where trade_type = 12 and   
x.Trade_no = y.Trade_no and x.buy_sell = y.buy_sell)  
        
/*  
select y.Party_code as correct_code,x.* from        
(select * from #q (nolock) where trade_type = 11)x        
full outer join        
(select * from #q (nolock) where trade_type = 12) y on x.trade_no = y.trade_no       
*/  
      
declare @tdate as varchar(11)       
set @tdate = (select distinct convert(varchar(11),trade_date) from tbl_on_Terminal_FO_Changes (nolock))      
      
delete tbl_Fo_Trade_CHanges where sauda_Date = @tdate      
    
insert into tbl_Fo_Trade_CHanges      
select a.*,b.branch_cd,b.Sub_broker,c.branch_cd as Wrong_Branch,c.Sub_Broker as Wrong_SubBroker,@tdate from      
(      
select distinct y.party_code as wrong_code,x.* from        
(      
select party_code,symbol,strike_price,option_type,sum(BUY_Qty) as BUY_QTY,        
sum(Buy_Value) as BUY_Value,sum(sell_Qty) as Sell_Qty,sum(Sell_Value) as SELL_Value,expiry_date from #trd        
group by party_code,symbol,strike_price,option_type,expiry_date ) x      
left outer join      
(  
select y.Party_code as correct_code,x.* from        
(select * from #q (nolock) where trade_type = 11)x        
full outer join        
(select * from #q (nolock) where trade_type = 12) y on x.trade_no = y.trade_no       
) y on x.party_code = y.correct_code and x.symbol = y.symbol and x.expiry_date = y.expiry_date     
) a        
left outer join      
(select * from anand1.msajag.dbo.client_details with (nolock)) b      
 on a.party_code = b.cl_code       
left outer join       
(select * from anand1.msajag.dbo.client_details with (nolock)) c      
 on a.party_code = c.cl_code

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPJV_admin_Trade_FO
-- --------------------------------------------------
CREATE proc [dbo].[USPJV_admin_Trade_FO]                       
as                                
set transaction  isolation  level read uncommitted                                
    
--Exec master.dbo.xp_cmdshell 'NET USE \\INHOUSELIVEAPP1-FS.angelone.in\IPC$ /USER:svc-appdataInhouse@angelone.in Angel@123456780'  
  
declare @filename as varchar(100)                            
declare @path as varchar(100)                            
declare @sql as varchar(1000)                        
declare @cnt as int                    
                    
set @filename = 'admintrade.txt'                  
                      
truncate table FO_PRE_Trade    
truncate table FO_PRE_Trade_tmp                    
                            
--set @path='\\196.1.115.136\d$\upload1\FoTrade\' + @filename                            
set @path='\\INHOUSELIVEAPP1-FS.angelone.in\d\upload1\FoTrade\' + @filename                            
SET @SQL = 'BULK INSERT FO_PRE_Trade_tmp FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=1,KeepNULLS)'                    
exec (@sql)        
    
insert into FO_PRE_Trade(trade_no,trade_type,inst_type,symbol,[expiry_date],strike_price,option_type,scrip_name,aa,lot_type,bb,user_id,location,buy_sell,qty,rate,cl_type,party_code,broker_code,style,c_u,trade_date,order_date,order_no,broker_code_a,order_mod_date,ctclid)    
select trade_no,trade_type,inst_type,symbol,Convert(datetime,[expiry_date],103) [expiry_date],strike_price,option_type,scrip_name,aa,lot_type,bb,user_id,location,buy_sell,qty,rate,cl_type,party_code,broker_code,style,c_u,trade_date,order_date,order_no,broker_code_a,order_mod_date,ctclid    
from FO_PRE_Trade_tmp                        
                    
truncate table tbl_upd                    
set @cnt = (select Total=count(*) from FO_PRE_Trade(nolock))                    
                    
insert into tbl_upd values (getdate(),@cnt)                    
                  
exec CHECK_FOCLIENT

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USPJV_admin_Trade_FO_19Mar2021
-- --------------------------------------------------
CREATE proc USPJV_admin_Trade_FO_19Mar2021                   
as                            
set transaction  isolation  level read uncommitted                            
                
declare @filename as varchar(100)                        
declare @path as varchar(100)                        
declare @sql as varchar(1000)                    
declare @cnt as int                
                
set @filename = 'admintrade.txt'              
                  
truncate table FO_PRE_Trade                
                        
--set @path='\\196.1.115.136\d$\upload1\FoTrade\' + @filename                        
set @path='\\196.1.115.183\d$\upload1\FoTrade\' + @filename                        
SET @SQL = 'BULK INSERT FO_PRE_Trade FROM '''+@Path+''' WITH (FIELDTERMINATOR = '','', FirstRow=2,KeepNULLS)'                
exec (@sql)                        
                
truncate table tbl_upd                
set @cnt = (select Total=count(*) from FO_PRE_Trade(nolock))                
                
insert into tbl_upd values (getdate(),@cnt)                
              
exec CHECK_FOCLIENT

GO

-- --------------------------------------------------
-- TABLE dbo.altsub_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[altsub_branch]
(
    [segment] VARCHAR(25) NULL,
    [termid] VARCHAR(25) NULL,
    [branch] VARCHAR(25) NULL,
    [subbroker] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.altsub_mcx
-- --------------------------------------------------
CREATE TABLE [dbo].[altsub_mcx]
(
    [segment] VARCHAR(25) NULL,
    [termid] VARCHAR(25) NULL,
    [branch] VARCHAR(25) NULL,
    [subbroker] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.br_map
-- --------------------------------------------------
CREATE TABLE [dbo].[br_map]
(
    [Br_code1] VARCHAR(10) NULL,
    [Br_Code2] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.brmap28102010
-- --------------------------------------------------
CREATE TABLE [dbo].[brmap28102010]
(
    [Br_code1] VARCHAR(10) NULL,
    [Br_Code2] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.data_04Mar2024
-- --------------------------------------------------
CREATE TABLE [dbo].[data_04Mar2024]
(
    [party_Code] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO
-- --------------------------------------------------
CREATE TABLE [dbo].[FO]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [User_id] INT NULL,
    [Trade_no] VARCHAR(50) NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL,
    [Option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_bkgmaster
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_bkgmaster]
(
    [valid] VARCHAR(3) NULL,
    [sb_code] VARCHAR(50) NULL,
    [cl_code] VARCHAR(50) NULL,
    [percentage] MONEY NULL,
    [slabamax] MONEY NULL,
    [slabamin] MONEY NULL,
    [SSlabamin] MONEY NULL,
    [SSlabamax] MONEY NULL,
    [slabbmax] MONEY NULL,
    [slabbmin] MONEY NULL,
    [SSlabbmin] MONEY NULL,
    [SSlabbmax] MONEY NULL,
    [Pva] VARCHAR(50) NULL,
    [Pvb] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_bse123
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_bse123]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(50) NULL,
    [ACT] MONEY NULL,
    [CALC_BROK] MONEY NULL,
    [NET] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_DETAIL
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_DETAIL]
(
    [SUB_BROKER] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [User_id] INT NOT NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NOT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NOT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_detail_perc
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_detail_perc]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [User_id] INT NULL,
    [Trade_no] VARCHAR(50) NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_fut
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_fut]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [PARTY_CODE] VARCHAR(50) NULL,
    [ACT] MONEY NULL,
    [CALC_BROK] MONEY NULL,
    [NET] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_Margin
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_Margin]
(
    [dt] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Span_margin] MONEY NULL,
    [Pre_payable] MONEY NULL,
    [Spanmargin_Prepayable] MONEY NULL,
    [MTM] MONEY NULL,
    [Client_tag] VARCHAR(1) NULL,
    [Collection] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_margin_T1
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_margin_T1]
(
    [dt] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Span_margin] MONEY NULL,
    [Pre_payable] MONEY NULL,
    [Spanmargin_Prepayable] MONEY NULL,
    [MTM] MONEY NULL,
    [Client_tag] VARCHAR(1) NULL,
    [Collection] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_margin29102009
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_margin29102009]
(
    [dt] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Span_margin] MONEY NULL,
    [Pre_payable] MONEY NULL,
    [Spanmargin_Prepayable] MONEY NULL,
    [MTM] MONEY NULL,
    [Client_tag] VARCHAR(1) NULL,
    [Collection] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_op
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_op]
(
    [SUB_BROKER] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [BROK_AMT] MONEY NOT NULL,
    [sauda_date] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_opt
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_opt]
(
    [SUB_BROKER] VARCHAR(10) NULL,
    [PARTY_CODE] VARCHAR(10) NOT NULL,
    [ACT1] MONEY NULL,
    [CALC_BROK1] MONEY NULL,
    [NET1] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo_pre_trade
-- --------------------------------------------------
CREATE TABLE [dbo].[fo_pre_trade]
(
    [trade_no] INT NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] SMALLDATETIME NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(10) NULL,
    [user_id] VARCHAR(10) NULL,
    [location] VARCHAR(10) NULL,
    [buy_sell] INT NULL,
    [qty] INT NULL,
    [rate] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(25) NULL,
    [style] VARCHAR(10) NULL,
    [c_u] VARCHAR(10) NULL,
    [trade_date] SMALLDATETIME NULL,
    [order_date] SMALLDATETIME NULL,
    [order_no] VARCHAR(20) NULL,
    [broker_code_a] VARCHAR(10) NULL,
    [order_mod_date] SMALLDATETIME NULL,
    [ctclid] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_PRE_Trade_tmp
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_PRE_Trade_tmp]
(
    [trade_no] INT NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] VARCHAR(20) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(10) NULL,
    [user_id] VARCHAR(10) NULL,
    [location] VARCHAR(10) NULL,
    [buy_sell] INT NULL,
    [qty] INT NULL,
    [rate] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(25) NULL,
    [style] VARCHAR(10) NULL,
    [c_u] VARCHAR(10) NULL,
    [trade_date] SMALLDATETIME NULL,
    [order_date] SMALLDATETIME NULL,
    [order_no] VARCHAR(20) NULL,
    [broker_code_a] VARCHAR(10) NULL,
    [order_mod_date] SMALLDATETIME NULL,
    [ctclid] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_reporting
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_reporting]
(
    [report_Date] DATETIME NULL,
    [reported] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FO_reporting1
-- --------------------------------------------------
CREATE TABLE [dbo].[FO_reporting1]
(
    [report_Date] DATETIME NULL,
    [reported] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fo1
-- --------------------------------------------------
CREATE TABLE [dbo].[fo1]
(
    [SUB_BROKER] VARCHAR(10) NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(3) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(6) NULL,
    [symbol] VARCHAR(12) NULL,
    [User_id] INT NOT NULL,
    [Trade_no] VARCHAR(10) NOT NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NOT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] DATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL,
    [option_type] VARCHAR(2) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOBKG_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[FOBKG_MASTER]
(
    [valid] VARCHAR(3) NULL,
    [sb_code] VARCHAR(50) NULL,
    [cl_code] VARCHAR(50) NULL,
    [percentage] MONEY NULL,
    [slabamax] MONEY NULL,
    [slabamin] MONEY NULL,
    [SSlabamin] MONEY NULL,
    [SSlabamax] MONEY NULL,
    [slabbmax] MONEY NULL,
    [slabbmin] MONEY NULL,
    [SSlabbmin] MONEY NULL,
    [SSlabbmax] MONEY NULL,
    [Pva] VARCHAR(50) NULL,
    [Pvb] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.FOMARGIN
-- --------------------------------------------------
CREATE TABLE [dbo].[FOMARGIN]
(
    [Margindate] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Short_name] VARCHAR(50) NULL,
    [Ledgeramount] MONEY NULL,
    [Cash_coll] MONEY NULL,
    [Initialmargin] MONEY NULL,
    [Family] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Trader] VARCHAR(50) NULL,
    [Col_without_haircut] MONEY NULL,
    [Col_after_haircut] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fomargin_04062008
-- --------------------------------------------------
CREATE TABLE [dbo].[fomargin_04062008]
(
    [Margindate] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Short_name] VARCHAR(50) NULL,
    [Ledgeramount] MONEY NULL,
    [Cash_coll] MONEY NULL,
    [Initialmargin] MONEY NULL,
    [Family] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Trader] VARCHAR(50) NULL,
    [Col_without_haircut] MONEY NULL,
    [Col_after_haircut] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fomargin_T1
-- --------------------------------------------------
CREATE TABLE [dbo].[fomargin_T1]
(
    [Margindate] VARCHAR(50) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Branch_cd] VARCHAR(50) NULL,
    [Short_name] VARCHAR(50) NULL,
    [Ledgeramount] MONEY NULL,
    [Cash_coll] MONEY NULL,
    [Initialmargin] MONEY NULL,
    [Family] VARCHAR(50) NULL,
    [Sub_broker] VARCHAR(50) NULL,
    [Trader] VARCHAR(50) NULL,
    [Col_without_haircut] MONEY NULL,
    [Col_after_haircut] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.fomismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[fomismatch]
(
    [party_code] VARCHAR(25) NULL,
    [USER_ID] VARCHAR(10) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [qty] INT NULL,
    [AA] VARCHAR(25) NULL,
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(5) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL,
    [trade_date] SMALLDATETIME NULL,
    [brcd] VARCHAR(10) NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCD
-- --------------------------------------------------
CREATE TABLE [dbo].[MCD]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [User_id] INT NULL,
    [Trade_no] VARCHAR(50) NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCD_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MCD_MASTER]
(
    [valid] VARCHAR(3) NULL,
    [sb_code] VARCHAR(50) NULL,
    [cl_code] VARCHAR(50) NULL,
    [percentage] MONEY NULL,
    [slabamax] MONEY NULL,
    [slabamin] MONEY NULL,
    [SSlabamin] MONEY NULL,
    [SSlabamax] MONEY NULL,
    [slabbmax] MONEY NULL,
    [slabbmin] MONEY NULL,
    [SSlabbmin] MONEY NULL,
    [SSlabbmax] MONEY NULL,
    [Pva] VARCHAR(50) NULL,
    [Pvb] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [User_id] INT NULL,
    [Trade_no] VARCHAR(50) NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_altsub_branch
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_altsub_branch]
(
    [segment] VARCHAR(25) NULL,
    [termid] VARCHAR(25) NULL,
    [branch] VARCHAR(25) NULL,
    [subbroker] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.MCX_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[MCX_MASTER]
(
    [valid] VARCHAR(3) NULL,
    [sb_code] VARCHAR(50) NULL,
    [cl_code] VARCHAR(50) NULL,
    [percentage] MONEY NULL,
    [slabamax] MONEY NULL,
    [slabamin] MONEY NULL,
    [SSlabamin] MONEY NULL,
    [SSlabamax] MONEY NULL,
    [slabbmax] MONEY NULL,
    [slabbmin] MONEY NULL,
    [SSlabbmin] MONEY NULL,
    [SSlabbmax] MONEY NULL,
    [Pva] VARCHAR(50) NULL,
    [Pvb] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_mismatch]
(
    [party_code] VARCHAR(25) NULL,
    [USER_ID] VARCHAR(10) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [qty] INT NULL,
    [AA] VARCHAR(25) NULL,
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(20) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(50) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL,
    [trade_date] DATETIME NULL,
    [brcd] VARCHAR(10) NULL,
    [buy_sell] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_pre_trade
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_pre_trade]
(
    [trade_no] VARCHAR(50) NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_id] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] VARCHAR(20) NULL,
    [strike_price] VARCHAR(50) NOT NULL,
    [option_type] VARCHAR(25) NULL,
    [NCol] VARCHAR(20) NULL,
    [scrip_name] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(10) NULL,
    [user_id] VARCHAR(10) NULL,
    [location] VARCHAR(10) NULL,
    [buy_sell] VARCHAR(50) NULL,
    [qty] VARCHAR(50) NULL,
    [rate] VARCHAR(50) NULL,
    [cl_type] VARCHAR(20) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(20) NULL,
    [a22] VARCHAR(50) NULL,
    [a23] VARCHAR(50) NULL,
    [spread_price] VARCHAR(50) NULL,
    [trade_date] VARCHAR(50) NULL,
    [order_date] VARCHAR(50) NULL,
    [order_no] VARCHAR(50) NULL,
    [a27] VARCHAR(50) NULL,
    [user_remarks] VARCHAR(100) NULL,
    [Date1] VARCHAR(50) NULL,
    [Date2] VARCHAR(50) NULL,
    [UpdatingDateTime] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.mcx_term_detail
-- --------------------------------------------------
CREATE TABLE [dbo].[mcx_term_detail]
(
    [segement] VARCHAR(10) NULL,
    [term_no] VARCHAR(30) NOT NULL,
    [term_desigt] VARCHAR(30) NULL,
    [branch_cd] VARCHAR(30) NULL,
    [subbro_code] VARCHAR(40) NULL,
    [branch_name] VARCHAR(50) NULL,
    [nstatus] VARCHAR(20) NULL,
    [party_code] VARCHAR(20) NULL,
    [conn_type] VARCHAR(40) NULL,
    [conn_id] VARCHAR(40) NULL,
    [location] VARCHAR(50) NULL,
    [username] VARCHAR(50) NULL,
    [reference] VARCHAR(50) NULL,
    [user_address] VARCHAR(100) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDX
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDX]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [User_id] INT NULL,
    [Trade_no] VARCHAR(50) NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NCDX_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[NCDX_MASTER]
(
    [valid] VARCHAR(3) NULL,
    [sb_code] VARCHAR(50) NULL,
    [cl_code] VARCHAR(50) NULL,
    [percentage] MONEY NULL,
    [slabamax] MONEY NULL,
    [slabamin] MONEY NULL,
    [SSlabamin] MONEY NULL,
    [SSlabamax] MONEY NULL,
    [slabbmax] MONEY NULL,
    [slabbmin] MONEY NULL,
    [SSlabbmin] MONEY NULL,
    [SSlabbmax] MONEY NULL,
    [Pva] VARCHAR(50) NULL,
    [Pvb] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncx_mismatch
-- --------------------------------------------------
CREATE TABLE [dbo].[ncx_mismatch]
(
    [party_code] VARCHAR(25) NULL,
    [USER_ID] VARCHAR(10) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [qty] INT NULL,
    [AA] VARCHAR(25) NULL,
    [termid] VARCHAR(15) NULL,
    [termid_desig] VARCHAR(25) NULL,
    [branch_cd] VARCHAR(20) NULL,
    [branch_name] VARCHAR(25) NULL,
    [status] VARCHAR(50) NULL,
    [conn_type] VARCHAR(50) NULL,
    [conn_id] VARCHAR(50) NULL,
    [location] VARCHAR(50) NULL,
    [segment] VARCHAR(50) NULL,
    [user_name1] VARCHAR(50) NULL,
    [ref_name] VARCHAR(200) NULL,
    [user_addr] VARCHAR(50) NULL,
    [sub_broker] VARCHAR(10) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL,
    [trade_date] VARCHAR(20) NULL,
    [brcd] VARCHAR(10) NULL,
    [buy_sell] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncx_pre_trade
-- --------------------------------------------------
CREATE TABLE [dbo].[ncx_pre_trade]
(
    [trade_no] VARCHAR(50) NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] VARCHAR(15) NULL,
    [strike_price] VARCHAR(50) NULL,
    [option_type] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(30) NULL,
    [user_id] VARCHAR(30) NULL,
    [location] VARCHAR(30) NULL,
    [buy_sell] VARCHAR(50) NULL,
    [qty] VARCHAR(50) NULL,
    [rate] VARCHAR(50) NULL,
    [cl_type] VARCHAR(20) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(50) NULL,
    [style] VARCHAR(30) NULL,
    [c_u] VARCHAR(30) NULL,
    [trade_date] VARCHAR(50) NULL,
    [order_date] VARCHAR(50) NULL,
    [order_no] VARCHAR(50) NULL,
    [broker_code_a] VARCHAR(50) NULL,
    [UpdatingDateTime] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.ncx_term_detail
-- --------------------------------------------------
CREATE TABLE [dbo].[ncx_term_detail]
(
    [segement] VARCHAR(10) NULL,
    [term_no] VARCHAR(30) NOT NULL,
    [term_desigt] VARCHAR(30) NULL,
    [branch_cd] VARCHAR(30) NULL,
    [subbro_code] VARCHAR(40) NULL,
    [branch_name] VARCHAR(50) NULL,
    [nstatus] VARCHAR(20) NULL,
    [party_code] VARCHAR(40) NULL,
    [conn_type] VARCHAR(40) NULL,
    [conn_id] VARCHAR(40) NULL,
    [location] VARCHAR(50) NULL,
    [username] VARCHAR(50) NULL,
    [reference] VARCHAR(50) NULL,
    [user_address] VARCHAR(100) NULL,
    [branch_cd_alt] VARCHAR(25) NULL,
    [sub_broker_alt] VARCHAR(25) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSX
-- --------------------------------------------------
CREATE TABLE [dbo].[NSX]
(
    [SUB_BROKER] VARCHAR(50) NULL,
    [party_code] VARCHAR(50) NULL,
    [brokapplied] MONEY NULL,
    [SETT_TYPE] VARCHAR(50) NULL,
    [sauda_date] DATETIME NULL,
    [INST_TYPE] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [User_id] INT NULL,
    [Trade_no] VARCHAR(50) NULL,
    [Tradeqty] INT NULL,
    [SELL_BUY] INT NULL,
    [Strike_price] MONEY NULL,
    [Price] MONEY NULL,
    [BROKCHRG] MONEY NULL,
    [BROK_AMT] MONEY NULL,
    [expirydate] SMALLDATETIME NULL,
    [Percentage] MONEY NULL,
    [bmarkup] INT NULL,
    [smarkup] INT NULL,
    [brok_per_share] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.NSX_MASTER
-- --------------------------------------------------
CREATE TABLE [dbo].[NSX_MASTER]
(
    [valid] VARCHAR(3) NULL,
    [sb_code] VARCHAR(50) NULL,
    [cl_code] VARCHAR(50) NULL,
    [percentage] MONEY NULL,
    [slabamax] MONEY NULL,
    [slabamin] MONEY NULL,
    [SSlabamin] MONEY NULL,
    [SSlabamax] MONEY NULL,
    [slabbmax] MONEY NULL,
    [slabbmin] MONEY NULL,
    [SSlabbmin] MONEY NULL,
    [SSlabbmax] MONEY NULL,
    [Pva] VARCHAR(50) NULL,
    [Pvb] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.Shortage_
-- --------------------------------------------------
CREATE TABLE [dbo].[Shortage_]
(
    [DT] VARCHAR(50) NULL,
    [Margindate] VARCHAR(50) NULL,
    [sbtag] VARCHAR(10) NULL,
    [subgroup] VARCHAR(10) NULL,
    [Party_code] VARCHAR(50) NULL,
    [Span_margin] MONEY NULL,
    [Pre_payable] MONEY NULL,
    [Spanmargin_Prepayable] MONEY NULL,
    [MTM] MONEY NULL,
    [Client_tag] VARCHAR(1) NULL,
    [coll] MONEY NULL,
    [ledgeramount] MONEY NULL,
    [cash_coll] MONEY NULL,
    [col_without_haircut] MONEY NULL,
    [col_after_haircut] MONEY NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Fo_Trade_CHanges
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Fo_Trade_CHanges]
(
    [wrong_code] VARCHAR(25) NULL,
    [party_code] VARCHAR(25) NULL,
    [symbol] VARCHAR(50) NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(25) NULL,
    [BUY_QTY] INT NULL,
    [BUY_Value] MONEY NULL,
    [Sell_Qty] INT NULL,
    [SELL_Value] MONEY NULL,
    [Expiry_Date] VARCHAR(11) NULL,
    [branch_cd] VARCHAR(10) NULL,
    [Sub_broker] VARCHAR(10) NULL,
    [Wrong_Branch] VARCHAR(10) NULL,
    [Wrong_SubBroker] VARCHAR(10) NULL,
    [Sauda_Date] DATETIME NOT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mcx_admin
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mcx_admin]
(
    [Trade Number] INT NULL,
    [Trade Status] INT NULL,
    [Instrument ID] INT NULL,
    [Instrument Name] VARCHAR(100) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry Date] DATETIME NULL,
    [Reserved] VARCHAR(10) NULL,
    [Strike Price ] VARCHAR(50) NULL,
    [Reserved1] VARCHAR(10) NULL,
    [Options Type] VARCHAR(50) NULL,
    [Product Description] INT NULL,
    [Book Type Name] VARCHAR(25) NULL,
    [Book Type] INT NULL,
    [User ID] VARCHAR(10) NULL,
    [Branch No] VARCHAR(50) NULL,
    [B/S] INT NULL,
    [Trade quantity] INT NULL,
    [Price] VARCHAR(50) NULL,
    [Account Type] INT NULL,
    [Account ID] VARCHAR(50) NULL,
    [Participant Settler] INT NULL,
    [Spread Price] VARCHAR(50) NULL,
    [TM ID] INT NULL,
    [Reserved2] VARCHAR(10) NULL,
    [Activity Time] DATETIME NULL,
    [Last Modified time] DATETIME NULL,
    [Order Number] VARCHAR(50) NULL,
    [Opposite Broker Id] VARCHAR(100) NULL,
    [Order User Last Update Time] VARCHAR(255) NULL,
    [Mod Date Time] DATETIME NULL,
    [Order Entered/Mod Date Time] DATETIME NULL,
    [Reserverd9] VARCHAR(50) NULL,
    [Reserverd10] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Mcx_Currency
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Mcx_Currency]
(
    [Trade_no] INT NULL,
    [Trade_Status] INT NULL,
    [Instrument_ID] INT NULL,
    [Instrument_Name] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [expirydate] SMALLDATETIME NULL,
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
    [Spread Price] MONEY NULL,
    [TM ID] VARCHAR(50) NULL,
    [Reserved3] VARCHAR(20) NULL,
    [Activity Time] SMALLDATETIME NULL,
    [Last Modified time] SMALLDATETIME NULL,
    [Order Number] VARCHAR(20) NULL,
    [Opposite Broker Id] VARCHAR(10) NULL,
    [Order User Last Update Time] SMALLDATETIME NULL,
    [Mod Date Time] SMALLDATETIME NULL,
    [Order Entered/Mod Date Time] SMALLDATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mcx_currency_exchange
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mcx_currency_exchange]
(
    [Trade Number] FLOAT NULL,
    [Trade Status] FLOAT NULL,
    [Instrument ID] FLOAT NULL,
    [Instrument Name] NVARCHAR(255) NULL,
    [Symbol] NVARCHAR(255) NULL,
    [Expiry Date] DATETIME NULL,
    [Reserved] NVARCHAR(255) NULL,
    [Strike Price] NVARCHAR(255) NULL,
    [Options Type] NVARCHAR(255) NULL,
    [Product Description] NVARCHAR(255) NULL,
    [Book Type] FLOAT NULL,
    [Book Type Name] NVARCHAR(255) NULL,
    [Market Type] FLOAT NULL,
    [User ID] FLOAT NULL,
    [Branch No] FLOAT NULL,
    [Buy/Sell Indicator] FLOAT NULL,
    [Trade quantity] FLOAT NULL,
    [Price] FLOAT NULL,
    [Account Type] FLOAT NULL,
    [Account ID] NVARCHAR(255) NULL,
    [Participant Settler] FLOAT NULL,
    [Spread Price] NVARCHAR(255) NULL,
    [TM ID] FLOAT NULL,
    [Reserved1] NVARCHAR(255) NULL,
    [Trade time] DATETIME NULL,
    [Last Modified Time] DATETIME NULL,
    [Order Number] FLOAT NULL,
    [Reserved2] NVARCHAR(255) NULL,
    [Remarks] NVARCHAR(255) NULL,
    [Order User Last Update Time] DATETIME NULL,
    [Reserved3] DATETIME NULL,
    [Reference Number] NVARCHAR(255) NULL,
    [Reserved4] NVARCHAR(255) NULL,
    [Reserved5] NVARCHAR(255) NULL,
    [ISV Unique No#] NVARCHAR(255) NULL,
    [Product Month] NVARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_MCX_CURRENCY1
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_MCX_CURRENCY1]
(
    [Trade_no] INT NULL,
    [Trade_Status] INT NULL,
    [Instrument_ID] INT NULL,
    [Instrument_Name] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [expirydate] SMALLDATETIME NULL,
    [Reserved] VARCHAR(20) NULL,
    [Strike Price] MONEY NULL,
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
    [Spread Price] MONEY NULL,
    [TM ID] VARCHAR(50) NULL,
    [Reserved3] VARCHAR(20) NULL,
    [Activity Time] SMALLDATETIME NULL,
    [Last Modified time] SMALLDATETIME NULL,
    [Order Number] VARCHAR(20) NULL,
    [Opposite Broker Id] VARCHAR(10) NULL,
    [Order User Last Update Time] VARCHAR(50) NULL,
    [Mod Date Time] DATETIME NULL,
    [Order Entered/Mod Date Time] DATETIME NULL,
    [RESERVED5] VARCHAR(50) NULL,
    [RESERVED6] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_mcxcurrency_exchange
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_mcxcurrency_exchange]
(
    [Trade Number] INT NULL,
    [Trade Status] INT NULL,
    [Instrument ID] INT NULL,
    [Instrument Name] VARCHAR(150) NULL,
    [Symbol] VARCHAR(150) NULL,
    [Expiry Date] DATETIME NULL,
    [Reserved] VARCHAR(100) NULL,
    [Strike Price] FLOAT NULL,
    [Options Type] VARCHAR(100) NULL,
    [Product Description] VARCHAR(150) NULL,
    [Book Type] INT NULL,
    [Book Type Name] VARCHAR(100) NULL,
    [Market Type] INT NULL,
    [User ID] VARCHAR(50) NULL,
    [Branch No] VARCHAR(150) NULL,
    [Buy/Sell Indicator] INT NULL,
    [Trade quantity] INT NULL,
    [Price] FLOAT NULL,
    [Account Type] INT NULL,
    [Account ID] VARCHAR(150) NULL,
    [Participant Settler] VARCHAR(25) NULL,
    [Spread Price] FLOAT NULL,
    [TM ID] VARCHAR(50) NULL,
    [Reserved1] VARCHAR(50) NULL,
    [Trade time] DATETIME NULL,
    [Last Modified Time] DATETIME NULL,
    [Order Number] VARCHAR(100) NULL,
    [Reserved2] VARCHAR(25) NULL,
    [Remarks] VARCHAR(200) NULL,
    [Order User Last Update Time] DATETIME NULL,
    [Reserved3] DATETIME NULL,
    [Reference Number] VARCHAR(50) NULL,
    [Reserved4] VARCHAR(25) NULL,
    [Reserved5] VARCHAR(25) NULL,
    [ISV Unique No#] VARCHAR(150) NULL,
    [Product Month] VARCHAR(50) NULL,
    [Reserved8] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nse_admin
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nse_admin]
(
    [Trade Number] INT NULL,
    [Trade Status] INT NULL,
    [Instrument Name] VARCHAR(100) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price ] VARCHAR(255) NULL,
    [Option type] VARCHAR(50) NULL,
    [Security name ] VARCHAR(150) NULL,
    [Book Type] INT NULL,
    [Book Type Name] VARCHAR(50) NULL,
    [Market Type] INT NULL,
    [User Id] VARCHAR(10) NULL,
    [Branch No] INT NULL,
    [Buy/Sell Ind] INT NULL,
    [Trade Qty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [Pro/Client ] INT NULL,
    [Account] VARCHAR(100) NULL,
    [Participant] VARCHAR(20) NULL,
    [Open/Close Flag] VARCHAR(15) NULL,
    [Cover/Uncover Flag] VARCHAR(15) NULL,
    [Activity Time] DATETIME NULL,
    [Last Modified time] DATETIME NULL,
    [Order No] VARCHAR(100) NULL,
    [Opposite Broker Id] VARCHAR(50) NULL,
    [Order Entered/Mod Date Time] DATETIME NULL,
    [ColTest] VARCHAR(1000) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TBL_NSE_ADMIN_BKP
-- --------------------------------------------------
CREATE TABLE [dbo].[TBL_NSE_ADMIN_BKP]
(
    [Trade Number] INT NULL,
    [Trade Status] INT NULL,
    [Instrument Name] VARCHAR(100) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price ] VARCHAR(255) NULL,
    [Option type] VARCHAR(50) NULL,
    [Security name ] VARCHAR(150) NULL,
    [Book Type] INT NULL,
    [Book Type Name] VARCHAR(50) NULL,
    [Market Type] INT NULL,
    [User Id] VARCHAR(10) NULL,
    [Branch No] INT NULL,
    [Buy/Sell Ind] INT NULL,
    [Trade Qty] INT NULL,
    [Price] VARCHAR(50) NULL,
    [Pro/Client ] INT NULL,
    [Account] VARCHAR(100) NULL,
    [Participant] VARCHAR(20) NULL,
    [Open/Close Flag] VARCHAR(15) NULL,
    [Cover/Uncover Flag] VARCHAR(15) NULL,
    [Activity Time] DATETIME NULL,
    [Last Modified time] DATETIME NULL,
    [Order No] VARCHAR(100) NULL,
    [Opposite Broker Id] VARCHAR(50) NULL,
    [Order Entered/Mod Date Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Nse_Currency
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Nse_Currency]
(
    [Trade ID] INT NULL,
    [Trade_Status] INT NULL,
    [Instrument_ID] INT NULL,
    [Instrument Type] VARCHAR(50) NULL,
    [Symbol] VARCHAR(50) NULL,
    [Expirty Date] SMALLDATETIME NULL,
    [Reserved] VARCHAR(20) NULL,
    [Strike Price] VARCHAR(50) NULL,
    [Reserved1] VARCHAR(20) NULL,
    [Options Type] VARCHAR(25) NULL,
    [Product Description] INT NULL,
    [Book Tpe Name] VARCHAR(20) NULL,
    [Book Type] INT NULL,
    [user id] INT NULL,
    [Branch Id] INT NULL,
    [Buy/Sell] INT NULL,
    [Quantity] INT NULL,
    [Price] MONEY NULL,
    [Pro/Cli Flag] INT NULL,
    [Account number] VARCHAR(25) NULL,
    [Participant] INT NULL,
    [Spread Price] VARCHAR(50) NULL,
    [TM ID] VARCHAR(50) NULL,
    [Reserved3] VARCHAR(20) NULL,
    [Activity Time] SMALLDATETIME NULL,
    [Last Modified time] VARCHAR(50) NULL,
    [Order Number] VARCHAR(20) NULL,
    [Opposite Broker Id] VARCHAR(10) NULL,
    [Order User Last Update Time] VARCHAR(50) NULL,
    [Mod Date Time] VARCHAR(50) NULL,
    [Order Entered/Mod Date Time] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nse_currency_exchange
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nse_currency_exchange]
(
    [Trade ID] FLOAT NULL,
    [Activity type] FLOAT NULL,
    [Symbol] NVARCHAR(255) NULL,
    [Instrument Type] NVARCHAR(255) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price] FLOAT NULL,
    [Option Type] NVARCHAR(255) NULL,
    [Contract Name] NVARCHAR(255) NULL,
    [Book Type] FLOAT NULL,
    [Market Type] FLOAT NULL,
    [User Id] FLOAT NULL,
    [Branch Id] FLOAT NULL,
    [Buy/Sell] FLOAT NULL,
    [Quantity] FLOAT NULL,
    [Price] FLOAT NULL,
    [Pro/Cli Flag] FLOAT NULL,
    [Account number] NVARCHAR(255) NULL,
    [Participant] FLOAT NULL,
    [Settlement] FLOAT NULL,
    [Trade Date/Time] DATETIME NULL,
    [Modified Date/Time] DATETIME NULL,
    [Order Number] FLOAT NULL,
    [CP ID] NVARCHAR(255) NULL,
    [Entry Date/Time] DATETIME NULL,
    [CTCLID] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nse_currency_exchange1
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nse_currency_exchange1]
(
    [Trade ID] FLOAT NULL,
    [Activity type] FLOAT NULL,
    [Symbol] VARCHAR(255) NULL,
    [Instrument Type] VARCHAR(255) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price] VARCHAR(1) NULL,
    [Option Type] VARCHAR(255) NULL,
    [Contract Name] VARCHAR(255) NULL,
    [Book Type] VARCHAR(1) NULL,
    [Market Type] INT NULL,
    [User Id] VARCHAR(50) NULL,
    [Branch Id] INT NULL,
    [Buy/Sell] INT NULL,
    [Quantity] INT NULL,
    [Price] FLOAT NULL,
    [Pro/Cli Flag] INT NULL,
    [Account number] VARCHAR(255) NULL,
    [Participant] VARCHAR(50) NULL,
    [Settlement] FLOAT NULL,
    [Trade Date/Time] DATETIME NULL,
    [Modified Date/Time] DATETIME NULL,
    [Order Number] VARCHAR(20) NULL,
    [CP ID] NVARCHAR(255) NULL,
    [Entry Date/Time] VARCHAR(50) NULL,
    [CTCLID] FLOAT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nse_currency_exchange2
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nse_currency_exchange2]
(
    [Trade ID] INT NULL,
    [Activity type] INT NULL,
    [Symbol] VARCHAR(50) NULL,
    [Instrument Type] VARCHAR(150) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price] FLOAT NULL,
    [Option Type] VARCHAR(50) NULL,
    [Contract Name] VARCHAR(100) NULL,
    [Book Type] INT NULL,
    [Market Type] INT NULL,
    [User Id] VARCHAR(15) NULL,
    [Branch Id] INT NULL,
    [Buy/Sell] INT NULL,
    [Quantity] INT NULL,
    [Price] FLOAT NULL,
    [Pro/Cli Flag] INT NULL,
    [Account number] VARCHAR(50) NULL,
    [Participant] VARCHAR(50) NULL,
    [Settlement] INT NULL,
    [Trade Date/Time] DATETIME NULL,
    [Modified Date/Time] DATETIME NULL,
    [Order Number] VARCHAR(100) NULL,
    [CP ID] VARCHAR(100) NULL,
    [Entry Date/Time] DATETIME NULL,
    [CTCLID] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_nsecurrency_exchange
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_nsecurrency_exchange]
(
    [Trade ID] INT NULL,
    [Activity type] INT NULL,
    [Symbol] VARCHAR(50) NULL,
    [Instrument Type] VARCHAR(150) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price] FLOAT NULL,
    [Option Type] VARCHAR(50) NULL,
    [Contract Name] VARCHAR(100) NULL,
    [Book Type] VARCHAR(20) NULL,
    [Market Type] INT NULL,
    [User Id] VARCHAR(15) NULL,
    [Branch Id] INT NULL,
    [Buy/Sell] INT NULL,
    [Quantity] INT NULL,
    [Price] FLOAT NULL,
    [Pro/Cli Flag] INT NULL,
    [Account number] VARCHAR(50) NULL,
    [Participant] VARCHAR(50) NULL,
    [Settlement] INT NULL,
    [Trade Date/Time] DATETIME NULL,
    [Modified Date/Time] DATETIME NULL,
    [Order Number] VARCHAR(100) NULL,
    [CP ID] VARCHAR(100) NULL,
    [Entry Date/Time] VARCHAR(50) NULL,
    [CTCLID] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_on_Terminal_FO_Changes
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_on_Terminal_FO_Changes]
(
    [trade_no] INT NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] SMALLDATETIME NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(50) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(10) NULL,
    [user_id] VARCHAR(10) NULL,
    [location] VARCHAR(10) NULL,
    [buy_sell] INT NULL,
    [qty] INT NULL,
    [rate] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(25) NULL,
    [style] VARCHAR(10) NULL,
    [c_u] VARCHAR(10) NULL,
    [trade_date] SMALLDATETIME NULL,
    [order_date] SMALLDATETIME NULL,
    [order_no] VARCHAR(20) NULL,
    [broker_code_a] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_upd
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_upd]
(
    [upd_time] DATETIME NULL,
    [records] INT NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_mcx_admin
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_mcx_admin]
(
    [Trade Number] FLOAT NULL,
    [Trade Status] FLOAT NULL,
    [Instrument ID] FLOAT NULL,
    [Instrument Name] NVARCHAR(255) NULL,
    [Symbol] NVARCHAR(255) NULL,
    [Expiry Date] DATETIME NULL,
    [Reserved] NVARCHAR(255) NULL,
    [Strike Price ] NVARCHAR(255) NULL,
    [Reserved1] NVARCHAR(255) NULL,
    [Options Type] NVARCHAR(255) NULL,
    [Product Description] FLOAT NULL,
    [Book Type Name] NVARCHAR(255) NULL,
    [Book Type] FLOAT NULL,
    [User ID] FLOAT NULL,
    [Branch No] FLOAT NULL,
    [B/S] FLOAT NULL,
    [Trade quantity] FLOAT NULL,
    [Price] FLOAT NULL,
    [Account Type] FLOAT NULL,
    [Account ID] NVARCHAR(255) NULL,
    [Participant Settler] FLOAT NULL,
    [Spread Price] NVARCHAR(255) NULL,
    [TM ID] FLOAT NULL,
    [Reserved2] NVARCHAR(255) NULL,
    [Activity Time] DATETIME NULL,
    [Last Modified time] DATETIME NULL,
    [Order Number] FLOAT NULL,
    [Opposite Broker Id] NVARCHAR(255) NULL,
    [Order User Last Update Time] NVARCHAR(255) NULL,
    [Mod Date Time] DATETIME NULL,
    [Order Entered/Mod Date Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.temp_nse_admin
-- --------------------------------------------------
CREATE TABLE [dbo].[temp_nse_admin]
(
    [Trade Number] FLOAT NULL,
    [Trade Status] FLOAT NULL,
    [Instrument Name] NVARCHAR(255) NULL,
    [Symbol] NVARCHAR(255) NULL,
    [Expiry Date] DATETIME NULL,
    [Strike Price ] NVARCHAR(255) NULL,
    [Option type] NVARCHAR(255) NULL,
    [Security name ] NVARCHAR(255) NULL,
    [Book Type] FLOAT NULL,
    [Book Type Name] NVARCHAR(255) NULL,
    [Market Type] FLOAT NULL,
    [User Id] FLOAT NULL,
    [Branch No] FLOAT NULL,
    [Buy/Sell Ind] FLOAT NULL,
    [Trade Qty] FLOAT NULL,
    [Price] FLOAT NULL,
    [Pro/Client ] FLOAT NULL,
    [Account] NVARCHAR(255) NULL,
    [Participant] FLOAT NULL,
    [Open/Close Flag] NVARCHAR(255) NULL,
    [Cover/Uncover Flag] NVARCHAR(255) NULL,
    [Activity Time] DATETIME NULL,
    [Last Modified time] DATETIME NULL,
    [Order No] FLOAT NULL,
    [Opposite Broker Id] NVARCHAR(255) NULL,
    [Order Entered/Mod Date Time] DATETIME NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.testm
-- --------------------------------------------------
CREATE TABLE [dbo].[testm]
(
    [trade_no] INT NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_id] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] SMALLDATETIME NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(10) NULL,
    [user_id] VARCHAR(10) NULL,
    [location] VARCHAR(10) NULL,
    [buy_sell] INT NULL,
    [qty] INT NULL,
    [rate] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(10) NULL,
    [a22] VARCHAR(50) NULL,
    [a23] VARCHAR(50) NULL,
    [spread_price] VARCHAR(50) NULL,
    [trade_date] SMALLDATETIME NULL,
    [order_date] SMALLDATETIME NULL,
    [order_no] VARCHAR(50) NULL,
    [a27] VARCHAR(50) NULL,
    [user_remarks] VARCHAR(100) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.testn
-- --------------------------------------------------
CREATE TABLE [dbo].[testn]
(
    [trade_no] INT NULL,
    [trade_type] VARCHAR(3) NULL,
    [inst_type] VARCHAR(50) NULL,
    [symbol] VARCHAR(50) NULL,
    [expiry_date] SMALLDATETIME NULL,
    [strike_price] MONEY NULL,
    [option_type] VARCHAR(25) NULL,
    [scrip_name] VARCHAR(100) NULL,
    [aa] VARCHAR(25) NULL,
    [lot_type] VARCHAR(25) NULL,
    [bb] VARCHAR(10) NULL,
    [user_id] VARCHAR(10) NULL,
    [location] VARCHAR(10) NULL,
    [buy_sell] INT NULL,
    [qty] INT NULL,
    [rate] MONEY NULL,
    [cl_type] VARCHAR(10) NULL,
    [party_code] VARCHAR(25) NULL,
    [broker_code] VARCHAR(10) NULL,
    [style] VARCHAR(10) NULL,
    [c_u] VARCHAR(10) NULL,
    [trade_date] SMALLDATETIME NULL,
    [order_date] SMALLDATETIME NULL,
    [order_no] VARCHAR(20) NULL,
    [broker_code_a] VARCHAR(10) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.TRD
-- --------------------------------------------------
CREATE TABLE [dbo].[TRD]
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
    [Col025] VARCHAR(255) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.xxxTrade901912032007
-- --------------------------------------------------
CREATE TABLE [dbo].[xxxTrade901912032007]
(
    [Col001] VARCHAR(255) NULL,
    [Col002] VARCHAR(255) NULL,
    [Col003] VARCHAR(255) NULL,
    [Col004] VARCHAR(255) NULL,
    [Col005] VARCHAR(255) NULL,
    [Col006] MONEY NULL,
    [Col007] VARCHAR(255) NULL,
    [Col008] VARCHAR(255) NULL,
    [Col009] VARCHAR(255) NULL,
    [Col010] VARCHAR(255) NULL,
    [Col011] VARCHAR(255) NULL,
    [Col012] VARCHAR(255) NULL,
    [Col013] VARCHAR(255) NULL,
    [Col014] VARCHAR(255) NULL,
    [Col015] VARCHAR(255) NULL,
    [Col016] MONEY NULL,
    [Col017] VARCHAR(255) NULL,
    [Col018] VARCHAR(255) NULL,
    [Col019] VARCHAR(255) NULL,
    [Col020] VARCHAR(255) NULL,
    [Col021] VARCHAR(255) NULL,
    [Col022] VARCHAR(255) NULL,
    [Col023] VARCHAR(255) NULL,
    [Col024] VARCHAR(255) NULL,
    [Col025] VARCHAR(255) NULL
);

GO

