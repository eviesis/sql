use AdventureWorks2019

--creating view
CREATE VIEW vwCustomerOrders AS
SELECT
    'Adventure Works' AS CompanyName,
    sod.SalesOrderID, --''
    soh.OrderDate, --salesorderheader
    pp.ProductID, --product
    pp.Name, --''
    sod.OrderQty, --''
    sod.UnitPrice, --''
    sod.LineTotal --salesorderdetail
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
GO

--check
SELECT * FROM vwCustomerOrders;


--creating view to check previous day's data
CREATE VIEW vwCustomerOrders_Yesterday AS
SELECT
    'Adventure Works' AS CompanyName,
    sod.SalesOrderID, --''
    soh.OrderDate, --salesorderheader
    pp.ProductID, --product
    pp.Name, --''
    sod.OrderQty, --''
    sod.UnitPrice, --''
    sod.LineTotal --salesorderdetail
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
WHERE CAST(soh.OrderDate AS DATE) = CAST(GETDATE() - 1 AS DATE);
GO

--check
SELECT * FROM vwCustomerOrders_Yesterday;


--creating product table
CREATE VIEW MyProducts AS
SELECT
    pp.ProductID,
    pp.Name,
    pp.StandardCost,
    sod.UnitPrice,
    v.Name AS VendorName,
    pm.Name AS ProductCategory
FROM Production.Product pp
JOIN  Purchasing.ProductVendor pv ON pp.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
JOIN Production.ProductModel pm ON pp.ProductModelID = pm.ProductModelID
JOIN Sales.SalesOrderDetail sod ON pp.ProductID = sod.ProductID
WHERE pp.DiscontinuedDate IS NULL;
GO

--check
select * from MyProducts
