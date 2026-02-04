-- DDL Export
-- Server: 10.253.33.89
-- Database: BusinessLoan
-- Exported: 2026-02-05T02:38:32.765714

USE BusinessLoan;
GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_InsertBusinessLoan
-- --------------------------------------------------
--exec USP_InsertBusinessLoan '123','123','123','123','123','123','123','123','123','123'    
        
CREATE PROC [dbo].[USP_InsertBusinessLoan]  --'BSECM_BANKING_230320171.csv',''          
(          
  @Emp_sb_Code varchar(50) = '',    
  @Emp_sb_Location varchar(50) = '',
  @Sub_Broker_No varchar(50),    
  @Customer_Name varchar(50) = '',    
  @Customer_No varchar(50) = '',    
  @Existing_Loan varchar(50) = '',    
  @Monthly_Income varchar(50) = '',   
  @Loan_Amt_Required varchar(50)='', 
  @Property_Required varchar(50)= '',    
  @Type varchar(50) = '',    
  @Customer_Address varchar(100)  = '',
  @UserName varchar(50)='',
  @AccessTo varchar(50)='',
  @AccessCode varchar(50)=''
)                     
AS               
BEGIN     
 insert into  tbl_Loan    
    (    
      Emp_sb_Code,    
      Emp_sb_Location, 
      Sub_Broker_No,
      Customer_Name,    
      Customer_No,    
      Existing_Loan,    
      Monthly_Income, 
      Loan_Amt_Required,   
      Property_Required,    
      Type,    
      Customer_Address,    
      UpdateDate,
      UserName,
      AccessTo,
      AccessCode
     )           
    values     
    (    
       @Emp_sb_Code,    
       @Emp_sb_Location,
       @Sub_Broker_No,    
       @Customer_Name,    
       @Customer_No ,    
       @Existing_Loan ,    
       @Monthly_Income , 
       @Loan_Amt_Required ,  
       @Property_Required ,    
       @Type ,    
       @Customer_Address,    
       getdate(),
       @UserName,
       @AccessTo,
       @AccessCode  
     )    
    
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_InsertBusinessLoan_Ipartner
-- --------------------------------------------------
--exec USP_InsertBusinessLoan '123','123','123','123','123','123','123','123','123','123'        
            
CREATE PROC [dbo].[USP_InsertBusinessLoan_Ipartner]  --'BSECM_BANKING_230320171.csv',''              
(              
  @Emp_sb_Code varchar(50) = '',        
  @Emp_sb_Location varchar(50) = '',    
  @Sub_Broker_No varchar(50),        
  @Customer_Name varchar(50) = '',        
  @Customer_No varchar(50) = '',        
  @Existing_Loan varchar(50) = '',        
  @Monthly_Income varchar(50) = '',       
  @Loan_Amt_Required varchar(50)='',     
  @Property_Required varchar(50)= '',        
  @Type varchar(50) = '',        
  @Customer_Address varchar(100)  = '',    
  @UserName varchar(50)='',    
  @AccessTo varchar(50)='',    
  @AccessCode varchar(50)=''    
)                         
AS                   
BEGIN         
 insert into  tbl_Loan
    (        
      Emp_sb_Code,        
      Emp_sb_Location,     
      Sub_Broker_No,    
      Customer_Name,        
      Customer_No,        
      Existing_Loan,        
      Monthly_Income,     
      Loan_Amt_Required,       
      Property_Required,        
      Type,        
      Customer_Address,        
      UpdateDate,    
      UserName,    
      AccessTo,    
      AccessCode    
     )               
    values         
    (        
       @Emp_sb_Code,        
       @Emp_sb_Location,    
       @Sub_Broker_No,        
       @Customer_Name,        
       @Customer_No ,        
       @Existing_Loan ,        
       @Monthly_Income ,     
       @Loan_Amt_Required ,      
       @Property_Required ,        
       @Type ,        
       @Customer_Address,        
       getdate(),    
       @UserName,    
       @AccessTo,    
       @AccessCode      
     )        
        
END

GO

-- --------------------------------------------------
-- PROCEDURE dbo.USP_LoanMIS
-- --------------------------------------------------
--USP_LoanMIS '27 sep 2017','27 sep 2017','','',''   
CREATE Procedure [dbo].[USP_LoanMIS]                   
(        
@FromDate as varchar(19),                
@toDate as varchar(19),                  
@access_to varchar(30),                    
@access_code varchar(30)
--@username varchar(30)                   
)                   
as                    
                
set nocount on                

set @FromDate=@FromDate + ' 00:00:00.000'
set @toDate= @toDate+ ' 23:59:59.000'
print @FromDate
select * from tbl_Loan where UpdateDate >=cast ( @FromDate as datetime)  and UpdateDate<=cast (@toDate as datetime)
    
                
set nocount off

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Loan
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Loan]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Emp_sb_Code] VARCHAR(50) NULL,
    [Emp_sb_Location] VARCHAR(50) NULL,
    [Sub_Broker_No] VARCHAR(50) NULL,
    [Customer_Name] VARCHAR(50) NULL,
    [Customer_No] VARCHAR(50) NULL,
    [Existing_Loan] VARCHAR(50) NULL,
    [Monthly_Income] VARCHAR(50) NULL,
    [Loan_Amt_Required] VARCHAR(50) NULL,
    [Property_Required] VARCHAR(50) NULL,
    [Type] VARCHAR(50) NULL,
    [Customer_Address] VARCHAR(100) NULL,
    [UpdateDate] DATETIME NULL,
    [UserName] VARCHAR(50) NULL,
    [AccessTo] VARCHAR(50) NULL,
    [AccessCode] VARCHAR(50) NULL
);

GO

-- --------------------------------------------------
-- TABLE dbo.tbl_Loan_Ipartner
-- --------------------------------------------------
CREATE TABLE [dbo].[tbl_Loan_Ipartner]
(
    [Srno] INT IDENTITY(1,1) NOT NULL,
    [Emp_sb_Code] VARCHAR(50) NULL,
    [Emp_sb_Location] VARCHAR(50) NULL,
    [Sub_Broker_No] VARCHAR(50) NULL,
    [Customer_Name] VARCHAR(50) NULL,
    [Customer_No] VARCHAR(50) NULL,
    [Existing_Loan] VARCHAR(50) NULL,
    [Monthly_Income] VARCHAR(50) NULL,
    [Loan_Amt_Required] VARCHAR(50) NULL,
    [Property_Required] VARCHAR(50) NULL,
    [Type] VARCHAR(50) NULL,
    [Customer_Address] VARCHAR(100) NULL,
    [UpdateDate] DATETIME NULL,
    [UserName] VARCHAR(50) NULL,
    [AccessTo] VARCHAR(50) NULL,
    [AccessCode] VARCHAR(50) NULL
);

GO

