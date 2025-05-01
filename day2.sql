-- 1. There is 504 products
SELECT COUNT(*)
FROM Production.Product

-- 2. 
SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

-- 3.
SELECT ProductSubcategoryID, COUNT(*) AS CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

-- 4.
SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

-- 5.
SELECT ProductID, SUM(Quantity)
FROM Production.ProductInventory
GROUP BY ProductID

-- 6.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

-- 7.
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

-- 8.
SELECT ProductID, AVG(Quantity)
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

-- 9.
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

-- 10.
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

-- 11.
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

-- 12.
SELECT c.Name AS Country, s.Name AS Province
FROM person.CountryRegion c JOIN person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode

-- 13.
SELECT c.Name AS Country, s.Name AS Province
FROM person.CountryRegion c JOIN person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')


USE Northwind
GO

-- 14.
SELECT DISTINCT p.ProductName
FROM dbo.[Order Details] od JOIN dbo.Products p ON od.ProductID = p.ProductID
JOIN dbo.Orders o ON o.OrderID = od.OrderID 
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())

-- 15.
SELECT TOP(5) o.ShipPostalCode
FROM dbo.[Order Details] od JOIN dbo.Orders o ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity) DESC

-- 16.
SELECT TOP(5) o.ShipPostalCode
FROM dbo.[Order Details] od JOIN dbo.Orders o ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity) DESC

-- 17.
SELECT City, Count(CustomerID) AS NumberOfCustomers
FROM dbo.Customers
GROUP BY City

-- 18.
SELECT City, Count(CustomerID) AS NumberOfCustomers
FROM dbo.Customers
GROUP BY City
HAVING Count(CustomerID) > 2

-- 19.
SELECT c.CompanyName, o.OrderDate
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'

-- 20.
SELECT c.CustomerID, c.CompanyName, MAX(o.OrderDate)
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName

-- 21.
SELECT c.CustomerID, c.CompanyName, COUNT(od.ProductID) AS ProductsBought
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID 
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName, c.CustomerID

-- 22.
SELECT c.CustomerID, c.CompanyName, COUNT(od.ProductID) AS ProductsBought
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID 
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName, c.CustomerID
HAVING COUNT(od.ProductID) > 100

-- 23.
SELECT su.CompanyName AS [Supplier Company Name], sh.CompanyName AS [Shipping Company Name]
FROM dbo.Suppliers su CROSS JOIN dbo.Shippers sh

-- 24.
SELECT o.OrderDate, p.ProductName
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
JOIN dbo.Orders o ON o.OrderID = od.OrderID
ORDER BY o.OrderDate

-- 25.
SELECT e1.FirstName + ' ' + e1.LastName AS Employee1FullName,
e2.FirstName + ' ' + e2.LastName AS Employee2FullName
FROM dbo.Employees e1 JOIN dbo.Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeID < e2.EmployeeID

-- 26.
SELECT e2.EmployeeID, e2.FirstName + ' ' + e2.LastName AS Manager
FROM dbo.Employees e1 JOIN dbo.Employees e2 ON e1.ReportsTO = e2.EmployeeID
GROUP BY e2.FirstName + ' ' + e2.LastName, e2.EmployeeID
HAVING Count(e1.EmployeeID) > 2


-- 27.
SELECT City, CompanyName AS Name, ContactName AS [Contact Name], 'Customer' AS Type
FROM dbo.Customers
UNION ALL
SELECT City, CompanyName AS Name, ContactName AS [Contact Name], 'Supplier' AS Type
FROM dbo.Suppliers