USE [AdventureWorks2019]
GO
------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-----------------EXE1-------------------------------
IF OBJECT_ID('return_Command') IS NOT NULL
BEGIN 
    DROP PROC return_Command
END 
GO
CREATE PROCEDURE return_Command
    @comment VARCHAR
AS 
BEGIN 
 
    SELECT pp.Comments , pp.ProductReviewID
    FROM Production.ProductReview as pp
    WHERE  pp.Comments LIKE '%' + @comment + '%'
END
GO

---------------RUN EXE1------------------
EXECUTE return_Command @comment = 'Maybe'
---------------------------------


-----------------EXE2-1-------------------------------
IF OBJECT_ID('Return_Date') IS NOT NULL
BEGIN 
    DROP PROC Return_Date
END 
GO
CREATE PROCEDURE Return_Date
    @startDate DATE ,
    @endDate DATE
AS 
BEGIN 
 
    SELECT sso.*
    FROM Sales.SalesOrderHeader as sso
    WHERE  sso.OrderDate BETWEEN @startDate AND @endDate
END
GO

---------------RUN EXE2-1------------------
EXECUTE Return_Date @startDate = '2011-06-11', @endDate = '2011-06-20'
---------------------------------

-----------------EXE2-2-------------------------------
IF OBJECT_ID('Return_Date_Price') IS NOT NULL
BEGIN 
    DROP PROC Return_Date_price
END 
GO
CREATE PROCEDURE Return_Date_Price
    @startDate1 DATE ,
    @endDate1 DATE,
    @price INTEGER
AS 
BEGIN 
    DECLARE @tempTable TABLE(
	[SalesOrderID] [int] IDENTITY(1,1) NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [dbo].[Flag] NOT NULL,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
	[AccountNumber] [dbo].[AccountNumber] NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
	[Comment] [nvarchar](128) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
)
INSERT @tempTable EXEC Return_Date @startDate = @startDate1, @endDate = @endDate1

    -- SELECT   tm.*
    -- FROM @tempTable as tm
    -- WHERE (SELECT SUM(sod.OrderQty* sod.UnitPrice) 
    --         FROM Sales.SalesOrderDetail as sod
    --         WHERE sod.SalesOrderID = tm.SalesOrderID
    --         ) >= @price
END
GO

---------------RUN EXE2-2------------------
EXECUTE Return_Date_price @startDate1 = '2011-06-11', @endDate1 = '2011-06-20', @price = 29
---------------------------------

-----------------EXE3-------------------------------
IF OBJECT_ID('Return_Product') IS NOT NULL
BEGIN 
    DROP PROC Return_Product
END 
GO
CREATE PROCEDURE Return_Product
AS 
BEGIN 
 
    SELECT sod.ProductID, soh.OrderDate, COUNT(sod.ProductID) AS Count_of_products
    FROM (Sales.SalesOrderDetail as sod INNER JOIN Sales.SalesOrderHeader as soh ON soh.SalesOrderID = sod.SalesOrderID )
    INNER JOIN Production.Product as pp on pp.ProductID = sod.ProductID
    GROUP BY sod.ProductID, soh.OrderDate
END
GO

---------------RUN EXE3------------------
EXECUTE Return_Product 
---------------------------------


-----------------EXE5-------------------------------
IF OBJECT_ID('Return_Sales') IS NOT NULL
BEGIN 
    DROP PROC Return_Sales
END 
GO
CREATE PROCEDURE Return_Sales
AS 
BEGIN 
 
    SELECT soh.SalesOrderID, soh.CustomerID, soh.OrderDate
    FROM Sales.SalesOrderHeader as soh 
    WHERE (SELECT SUM(sod.OrderQty)
            FROM Sales.SalesOrderDetail as sod 
            WHERE sod.SalesOrderID = soh.SalesOrderID) >= 4
END
GO

---------------RUN EXE5------------------
EXECUTE Return_Sales 
---------------------------------


-----------------EXE6-------------------------------


SELECT * 
INTO tempProduct
FROM Production.Product

DELETE FROM tempProduct WHERE NOT EXISTS(SELECT *
                                        FROM Sales.SalesOrderDetail as sod
                                        WHERE sod.ProductID = tempProduct.ProductID )

---------------RUN EXE6------------------

-----------------------------------------


-----------------EXE7-------------------------------
IF OBJECT_ID('Return_Days') IS NOT NULL
BEGIN 
    DROP PROC Return_Days
END 
GO
CREATE PROCEDURE Return_Days
    @number INTEGER 
AS 
BEGIN 
 
    SELECT soh.*
    FROM Sales.SalesOrderHeader as soh 
    WHERE (SELECT DATEDIFF(day, soh.OrderDate, soh.ShipDate) AS DateDiff) >= @number
END
GO

---------------RUN EXE7------------------
EXECUTE Return_Days @number = 5
---------------------------------


---------------EXE8------------------
IF OBJECT_ID('return_id') IS NOT NULL
BEGIN 
    DROP VIEW Return_id
END 
GO
CREATE VIEW return_id AS
SELECT soh.SalesOrderID , ROUND(soh.SubTotal, 1) AS RoundSubTotal, ABS(CHECKSUM(NewId())) % 100+100 as randNumber
FROM Sales.SalesOrderHeader as soh

--------------run EXE8------------------------
SELECT * from return_id


---------------EXE9------------------
IF OBJECT_ID('tempSalesOrderHeader') IS NOT NULL
BEGIN 
    DROP TABLE tempSalesOrderHeader
END 
GO
CREATE TABLE tempSalesOrderHeader(
    [SalesOrderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [dbo].[Flag] NOT NULL,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
	[AccountNumber] [dbo].[AccountNumber] NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
	[Comment] [nvarchar](128) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
)

SELECT * 
INTO tempSalesOrderHeader
FROM Sales.SalesOrderHeader

