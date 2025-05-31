use AdventureWorks2019;

--1. list of all customers
SELECT * FROM Customers;

--2. list of all customers where company name ending in N
SELECT * 
FROM Customers
WHERE CompanyName LIKE '%N';

--3. list of all customers who live in berlin or london
SELECT * FROM Customers
WHERE City IN ('Berlin', 'London');

--4. list of all customers who live in UK or USA
SELECT * FROM Customers
WHERE Country IN ('UK', 'USA');

--5. list of all products stored by product name
SELECT * FROM Products
ORDER BY ProductName ASC;

--6. list of all products where product name starts with A
SELECT * FROM Products
WHERE ProductName LIKE 'A%';

--7. list of customers who have ever placed an order
SELECT DISTINCT c.*
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

--8. list of customers who live in London and have bought chai
SELECT DISTINCT c.*
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE c.City = 'London' AND p.ProductName = 'Chai';

--9. list of customers who never placed an order
SELECT * FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.CustomerID = c.CustomerID
);

--10. list of customers who ordered tofu
SELECT DISTINCT c.*
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Tofu';

--11. details of first order of the system
SELECT TOP 1 * 
FROM Orders
ORDER BY OrderDate ASC;

--12. find the details of the most expensive order date
SELECT TOP 1 
o.OrderID, o.OrderDate, SUM(od.UnitPrice * od.Quantity) AS TotalOrderValue
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate
ORDER BY TotalOrderValue DESC;

--13. for each order get the OrderID and Average quantity of items in that order
SELECT OrderID, AVG(CAST(Quantity AS FLOAT)) AS AverageQuantity
FROM OrderDetails
GROUP BY OrderID;

--14. for each order get the OrderID, minimum quantity and maximum quantity for that order
SELECT OrderID, MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM OrderDetails
GROUP BY OrderID;

--15. Get a list of all managers and total number of employees who report to them. 
SELECT m.EmployeeID AS ManagerID, m.FirstName + ' ' + m.LastName AS ManagerName,
COUNT(e.EmployeeID) AS NumberOfEmployees
FROM Employees e
JOIN Employees m ON e.ReportsTo = m.EmployeeID
GROUP BY m.EmployeeID, m.FirstName, m.LastName;

--16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300 
SELECT OrderID, SUM(Quantity) AS TotalQuantity
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(Quantity) > 300;

--17. list of all orders placed on or after 1996/12/31 
SELECT * 
FROM Orders
WHERE OrderDate >= '1996-12-31';

--18. list of all orders shipped to Canada 
SELECT * 
FROM Orders
WHERE ShipCountry = 'Canada';

--19. list of all orders with order total > 200 
SELECT od.OrderID,
SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal
FROM [Order Details] od
GROUP BY od.OrderID
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 200;

--20. List of countries and sales made in each country 
SELECT o.ShipCountry,
SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipCountry;

--21. List of Customer ContactName and number of orders they placed 
SELECT c.ContactName, COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName;

--22. List of customer contactnames who have placed more than 3 orders 
SELECT c.ContactName, COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
HAVING COUNT(o.OrderID) > 3;

--23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998 
SELECT DISTINCT p.ProductName
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE p.Discontinued = 1 
  AND o.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

--24. List of employee firsname, lastName, superviser FirstName, LastName 
SELECT e.EmployeeID, e.FirstName AS EmployeeFirstName,
e.LastName AS EmployeeLastName,
m.FirstName AS ManagerFirstName,
m.LastName AS ManagerLastName
FROM Employees e
LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeID;

--25. List of Employees id and total sale condcuted by employee
SELECT o.EmployeeID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.EmployeeID;

--26. list of employees whose FirstName contains character a 
SELECT * 
FROM Employees
WHERE FirstName LIKE '%a%';

--27. List of managers who have more than four people reporting to them. 
SELECT e.ReportsTo AS ManagerID, COUNT(*) AS NumberOfReports
FROM Employees e
WHERE e.ReportsTo IS NOT NULL
GROUP BY e.ReportsTo
HAVING COUNT(*) > 4;

--28. List of Orders and ProductNames 
SELECT o.OrderID, p.ProductName
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

--29. List of orders place by the best customer 
SELECT TOP 1 WITH TIES 
o.CustomerID, o.OrderID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID, o.OrderID
ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC;

--30. List of orders placed by customers who do not have a Fax number 
SELECT o.*
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Fax IS NULL;

--31. List of Postal codes where the product Tofu was shipped 
SELECT DISTINCT o.ShipPostalCode
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Tofu';

--32. List of product Names that were shipped to France 
SELECT DISTINCT p.ProductName
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.ShipCountry = 'France';

--33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd. 
SELECT p.ProductName, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.CompanyName = 'Specialty Biscuits, Ltd.';

--34. List of products that were never ordered. 
SELECT p.ProductName
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL;

--35. List of products where units in stock is less than 10 and units on order are 0. 
SELECT ProductName
FROM Products
WHERE UnitsInStock < 10 AND UnitsOnOrder = 0;

--36. List of top 10 countries by sales 
SELECT TOP 10 
o.ShipCountry, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipCountry
ORDER BY TotalSales DESC;

--37. Number of orders each employee has taken for customers with CustomerIDs between A and AO 
SELECT o.EmployeeID, COUNT(o.OrderID) AS OrderCount
FROM Orders o
WHERE o.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY o.EmployeeID;

--38. Orderdate of most expensive order 
SELECT TOP 1 
o.OrderDate, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate
ORDER BY OrderTotal DESC;

--39. Product name and total revenue from that product 
SELECT p.ProductName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName;

--40. Supplierid and number of products offered 
SELECT SupplierID, COUNT(ProductID) AS NumberOfProducts
FROM Products
GROUP BY SupplierID;

--41. Top ten customers based on their business 
SELECT TOP 10 
o.CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalBusiness
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
ORDER BY TotalBusiness DESC;

--42. What is the total revenue of the company.
SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS TotalRevenue
FROM [Order Details];
