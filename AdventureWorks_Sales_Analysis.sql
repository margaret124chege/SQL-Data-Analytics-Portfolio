USE AdventureWorks2022;
GO
/*
=========================================================
PROJECT: AdventureWorks Sales & Product Analysis
DATABASE: AdventureWorks2022
TOOL: SQL Server Management Studio (SSMS)

OBJECTIVE:
Analyze AdventureWorks product and sales data to identify
product performance, sales volume, and revenue trends.
=========================================================
*/
-- 1. Explore Product Data

SELECT TOP 10
    ProductID,
    Name,
    ProductNumber,
    Color,
    ListPrice
FROM Production.Product;
-- 2. Products Priced Above $1,000

SELECT
    ProductID,
    Name,
    ProductNumber,
    ListPrice
FROM Production.Product
WHERE ListPrice > 1000
ORDER BY ListPrice DESC;
-- 3. Identify Products With No Recorded Sales

SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS sod
    ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL
ORDER BY p.Name;
-- 4. Top 10 Products by Units Sold

SELECT TOP 10
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS TotalUnitsSold
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sod
    ON p.ProductID = sod.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY TotalUnitsSold DESC;
-- 5. Top 10 Products by Sales Revenue

SELECT TOP 10
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS TotalUnitsSold,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18,2)) AS TotalRevenue
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sod
    ON p.ProductID = sod.ProductID
GROUP BY
    p.ProductID,
    p.Name
ORDER BY TotalRevenue DESC;
-- 6. Monthly Sales Revenue Trend

SELECT
    YEAR(soh.OrderDate) AS SalesYear,
    MONTH(soh.OrderDate) AS SalesMonth,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18,2)) AS TotalRevenue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY
    YEAR(soh.OrderDate),
    MONTH(soh.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;
    -- 7. Highest Revenue Month

SELECT TOP 1
    YEAR(soh.OrderDate) AS SalesYear,
    MONTH(soh.OrderDate) AS SalesMonth,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18,2)) AS TotalRevenue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY
    YEAR(soh.OrderDate),
    MONTH(soh.OrderDate)
ORDER BY TotalRevenue DESC;
-- 8. Annual Sales Revenue

SELECT
    YEAR(soh.OrderDate) AS SalesYear,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18,2)) AS TotalRevenue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
    ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY
    YEAR(soh.OrderDate)
ORDER BY TotalRevenue DESC;
-- 9. Revenue by Product Category

SELECT
    pc.Name AS ProductCategory,
    CAST(SUM(sod.LineTotal) AS DECIMAL(18,2)) AS TotalRevenue
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name
ORDER BY
    TotalRevenue DESC;