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





