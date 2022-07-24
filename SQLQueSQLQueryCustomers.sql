USE [AdventureWorks2017]
GO
------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------
IF OBJECT_ID('Customer') IS NOT NULL
BEGIN 
DROP TABLE Customer
END
GO
CREATE TABLE [dbo].[Customer](
       [CustomerID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	   [FirstName] [varchar](20) NULL,
       [LastName] [varchar](20) NULL,
       [Email] [varchar](20) NULL,
       [PhoneNumber] [int] NULL,
	   [ModifiedDate] [Datetime] NULL
 
) 

-----------------------------------------------------------------------
IF OBJECT_ID('usp_CustomerCreate') IS NOT NULL
BEGIN 
DROP PROC usp_CustomerCreate 
END
GO
CREATE PROCEDURE usp_CustomerCreate
	   @FirstName varchar(20),
	   @LastName varchar(20),
	   @Email	varchar(20),
	   @PhoneNumber int,
	   @ModifiedDate Datetime
	 
AS
BEGIN
INSERT INTO Customer  (
	   FirstName,
	   LastName,
	   Email,
	   PhoneNumber,
	   ModifiedDate)
    VALUES (
	   @FirstName,
	   @LastName,
	   @Email,
	   @PhoneNumber,
	   @ModifiedDate)


DECLARE @CustomerID INT;
SET @CustomerID = SCOPE_IDENTITY()
 
SELECT 
	CustomerID = @CustomerID,
	FirstName = @FirstName,
	LastName = @LastName,
	Email	= @Email,
	PhoneNumber = @PhoneNumber,
	ModifiedDate = @ModifiedDate
FROM Customer 
WHERE  CustomerID = @CustomerID
END


-------------------------------------------------------------
EXECUTE usp_CustomerCreate 
	@FirstName = "Jane",
	@LastName = "Doe",
	@Email = "reazmoj.h@gmail.com",
	@PhoneNumber = 912145,
	@ModifiedDate = '2020-09-10'


-------------------------------------------

IF OBJECT_ID('cusp_CustomerRead') IS NOT NULL
BEGIN 
    DROP PROC cusp_CustomerRead
END 
GO
CREATE PROCEDURE cusp_CustomerRead
    @CustomerID int
AS 
BEGIN 
 
    SELECT CustomerID, FirstName, LastName, Email, PhoneNumber, ModifiedDate
    FROM    [dbo].[Customer]
    WHERE  (CustomerID = @CustomerID) 
END
GO

---------------------------------
EXECUTE cusp_CustomerRead @CustomerID = 1

-----------------------------------------------
IF OBJECT_ID('cusp_CustomerUpdate') IS NOT NULL
BEGIN 
DROP PROC cusp_CustomerUpdate
END 
GO
CREATE PROC cusp_CustomerUpdate
    @CustomerID int,
    @FirstName varchar(20),
    @LastName varchar(20),
    @Email varchar(20),
    @PhoneNumber int,
	@ModifiedDate Datetime
  
AS 
BEGIN 
 
UPDATE Customer
SET  FirstName = @FirstName,
     LastName = @LastName, 
     Email = @Email,
     PhoneNumber = @PhoneNumber,
	 ModifiedDate = @ModifiedDate
WHERE  CustomerID = @CustomerID
END
GO


EXECUTE cusp_CustomerUpdate
	@CustomerID = 9,
	@FirstName = "kola",
	@LastName = "Doe",
	@Email = "reazmoj.h@gmail.com",
	@PhoneNumber = 912145,
	@ModifiedDate = '2021-09-10'
----------------------------------------
IF OBJECT_ID('cusp_CustomerDelete') IS NOT NULL
BEGIN 
DROP PROC cusp_CustomerDelete
END 
GO
CREATE PROC cusp_CustomerDelete 
    @CustomerID int
AS 
BEGIN 
DELETE
FROM   Customer
WHERE  CustomerID = @CustomerID
 
END
GO


-------------------------------------------------------

select  distinct local_net_address, local_tcp_port from  sys.dm_exec_connections  where local_net_address is  not  null