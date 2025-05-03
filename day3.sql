USE Northwind
GO

-- 1. List all cities that have both Employees and Customers.
SELECT DISTINCT c.City
FROM dbo.Customers c JOIN dbo.Employees e ON c.City = e.City

-- 2. List all cities that have Customers but no Employee.

  -- a. Use sub-query
SELECT DISTINCT c.City
FROM dbo.Customers c
WHERE c.City NOT IN
(SELECT DISTINCT e.City
FROM dbo.Employees e)

  -- b. Do not use sub-query
SELECT DISTINCT c.City
FROM dbo.Customers c LEFT JOIN dbo.Employees e ON c.city = e.city
WHERE e.EmployeeID IS NULL

--3. List all products and their total order quantities throughout all orders.
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalQuantity
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName

--4. List all Customer Cities and total products ordered by that city.
SELECT c.City, Count(od.ProductID) AS TotalProducts
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City

--5. List all Customer Cities that have at least two customers.
SELECT c.City, COUNT(c.CustomerID) AS NumberOfCustomers
FROM dbo.Customers c
GROUP BY c.city
HAVING COUNT(c.CustomerID) >= 2

--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(DISTINCT od.ProductID) AS NumberOfDifferentProducts
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.city
HAVING COUNT(DISTINCT od.ProductID) >= 2

--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.CustomerID
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity

--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
WITH CityCTE AS
(
SELECT od.ProductID, c.City, SUM(od.Quantity) AS Quantity
FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City, od.ProductID
),
MAXCityCTE AS
(
SELECT ProductID, City, Quantity
FROM
(
SELECT ProductID, City, Quantity, MAX(Quantity) OVER (PARTITION BY ProductID) AS MaxQuantity
FROM CityCTE
) AS t
WHERE Quantity = MaxQuantity
)

SELECT TOP 5 p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalQuantity,
AVG(od.UnitPrice) AS AveragePrice, 
(
  SELECT MAXCityCTE.City
  FROM MAXCityCTE
  WHERE p.ProductID = MAXCityCTE.ProductID
) AS CustomerCity
FROM dbo.Customers c JOIN dbo.Orders o ON o.CustomerID = c.CustomerID
JOIN dbo.[Order Details] od ON od.OrderID = o.OrderID
JOIN dbo.Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY SUM(od.Quantity) DESC

--9. List all cities that have never ordered something but we have employees there.

  --a. Use sub-query
    -- If city means customer city:
SELECT e.City 
FROM dbo.Employees e
WHERE e.City NOT IN 
(SELECT DISTINCT c.City FROM dbo.Customers c WHERE c.CustomerID IN 
  (SELECT DISTINCT o.CustomerID FROM dbo.Orders o)
)
    -- If city means shipcity:
SELECT e.City 
FROM dbo.Employees e
WHERE e.City NOT IN 
(SELECT DISTINCT o.ShipCity FROM dbo.Orders o)

  --b. Do not use sub-query
    -- If city means customer city: 
SELECT DISTINCT e.City
FROM dbo.Employees e LEFT JOIN dbo.Customers c ON e.City = c.City
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID 
WHERE c.City IS NULL OR o.CustomerID IS NULL
    -- If city means shipcity:
SELECT DISTINCT e.City
FROM dbo.Employees e LEFT JOIN dbo.Orders o ON e.City = o.ShipCity
WHERE o.ShipCity IS NULL

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

WITH MostOrdersCTE AS
(
  SELECT TOP 1 e.City, Count(*) OrderNumber
  FROM dbo.Employees e JOIN dbo.Orders o ON e.EmployeeID = o.EmployeeID
  GROUP BY e.City
  ORDER BY Count(*) DESC
),
MostQtyCTE AS
(
  SELECT TOP 1 c.City, SUM(od.Quantity) ProductQuantity
  FROM dbo.Customers c JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
  JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
  GROUP BY c.City
  ORDER BY SUM(od.Quantity) DESC
)
SELECT MostOrdersCTE.city
FROM MostOrdersCTE JOIN MostQtyCTE ON MostOrdersCTE.City = MostQtyCTE.City

--11. How do you remove the duplicates record of a table?
  -- Use partition by over all columns and add row number to find the duplicated ones.

WITH RemoveDuplicates AS
(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY ID, Name ORDER BY ID) AS rn
FROM Q11_Sample
)
DELETE
FROM RemoveDuplicates
WHERE rn > 1



