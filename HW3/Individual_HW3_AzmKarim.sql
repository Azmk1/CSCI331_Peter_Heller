-- 1
-- 1-1
-- Write a query that generates 5 copies out of each employee row
-- Tables involved: TSQLV6 database, Employees and Nums tables

-- Solution TSQLV6
--SELECT E.empid, E.firstname, E.lastname, N.n
--FROM HR.Employees AS E
--  CROSS JOIN dbo.Nums AS N 
--WHERE N.n <= 5
--ORDER BY n, empid;

-- Solution Northwinds
Select E.employeeid, E.EmployeeFirstName, E.EmployeeLastName, N.digit
from HumanResources.Employee AS E
  CROSS JOIN dbo.Digits AS N 
WHERE N.digit <= 5
ORDER BY N.digit, E.employeeid;
----------------------------------------------------------------------
-- 1-2
-- Write a query that returns a row for each employee and day 
-- in the range June 12, 2022 � June 16 2022.
-- Tables involved: TSQLV6 database, Employees and Nums tables

-- Solution TSQLV6
--SELECT E.empid,
--  DATEADD(day, D.n - 1, CAST('20220612' AS DATE)) AS dt
--FROM HR.Employees AS E
--  CROSS JOIN Nums AS D
--WHERE D.n <= DATEDIFF(day, '20220612', '20220616') + 1
--ORDER BY empid, dt;

-- Solution Northwinds
select e.employeeid, 
  DATEADD(day, D.digit - 1, CAST('20220612' AS DATE)) AS dt
from HumanResources.Employee AS E
  CROSS JOIN dbo.Digits AS D
WHERE D.digit <= DATEDIFF(day, '20220612', '20220616') + 1
ORDER BY e.employeeid, dt;
----------------------------------------------------------------------

-- 2
-- Explain what�s wrong in the following query and provide a correct alternative
SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON Customers.custid = Orders.custid;

-- Solution TSQLV6
--SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
--FROM Sales.Customers
--  INNER JOIN Sales.Orders
--   ON Customers.custid = Orders.custid;

-- Solution Northwinds
SELECT customer.[CustomerId], customer.[CustomerCompanyName], orders.[OrderId], orders.[OrderDate]
FROM sales.Customer AS customer
  INNER JOIN sales.[Order] AS orders
    ON customer.[CustomerId] = orders.[CustomerId];

----------------------------------------------------------------------

-- 3
-- Return US customers, and for each customer the total number of orders 
-- and total quantities.
-- Tables involved: TSQLV6 database, Customers, Orders and OrderDetails tables

-- Solution TSQLV6
--SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
--FROM Sales.Customers AS C
--  INNER JOIN Sales.Orders AS O
--    ON O.custid = C.custid
--  INNER JOIN Sales.OrderDetails AS OD
--    ON OD.orderid = O.orderid
--WHERE C.country = N'USA'
--GROUP BY C.custid;

-- Solution Northwinds
select c.customerid, count(distinct o.orderid) as numorders, sum(od.quantity) as totalqty
from sales.Customer AS c
  inner join sales.[Order] AS o
    on o.customerid = c.customerid
  inner join sales.OrderDetail AS od
    on od.orderid = o.orderid
where c.[CustomerCountry] = N'USA'
group by c.customerid;

----------------------------------------------------------------------

-- 4
-- Return customers and their orders including customers who placed no orders
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Solution TSQLV6
--SELECT C.custid, C.companyname, O.orderid, O.orderdate
--FROM Sales.Customers AS C
--  LEFT OUTER JOIN Sales.Orders AS O
--    ON O.custid = C.custid;

-- Solution Northwinds
select c.customerid, c.customercompanyname, o.orderid, o.orderdate
from sales.Customer AS c
  left outer join sales.[Order] AS o
    on o.customerid = c.customerid;

----------------------------------------------------------------------

-- 5
-- Return customers who placed no orders
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Solution TSQLV6
--SELECT C.custid, C.companyname
--FROM Sales.Customers AS C
--  LEFT OUTER JOIN Sales.Orders AS O
--    ON O.custid = C.custid
--WHERE O.orderid IS NULL;

-- Solution Northwinds
select c.customerid, c.customercompanyname
from sales.Customer AS c
  left outer join sales.[Order] AS o
    on o.customerid = c.customerid
where o.orderid is null;

----------------------------------------------------------------------

-- 6
-- Return customers with orders placed on Feb 12, 2022 along with their orders
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Solution TSQLV6
--SELECT C.custid, C.companyname, O.orderid, O.orderdate
--FROM Sales.Customers AS C
--  INNER JOIN Sales.Orders AS O
--    ON O.custid = C.custid
--WHERE O.orderdate = '20220212';

-- Solution Northwinds
select c.customerid, c.customercompanyname, o.orderid, o.orderdate
from sales.Customer AS c
  inner join sales.[Order] AS o
    on o.customerid = c.customerid
where o.orderdate = '20220212';

----------------------------------------------------------------------

-- 7
-- Write a query that returns all customers, but matches
-- them with their respective orders only if they were placed on February 12, 2022
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Solution TSQLV6
--SELECT C.custid, C.companyname, O.orderid, O.orderdate
--FROM Sales.Customers AS C
--  LEFT OUTER JOIN Sales.Orders AS O
--    ON O.custid = C.custid
--   AND O.orderdate = '20220212';

-- Solution Northwinds
select c.customerid, c.customercompanyname, o.orderid, o.orderdate
from sales.Customer AS c
  left outer join sales.[Order] AS o
    on o.customerid = c.customerid
    and o.orderdate = '20220212';

----------------------------------------------------------------------

-- 8
-- Explain why the following query isn�t a correct solution query for exercise 7.

-- Solution TSQLV6
--SELECT C.custid, C.companyname, O.orderid, O.orderdate
--FROM Sales.Customers AS C
--  LEFT OUTER JOIN Sales.Orders AS O
--    ON O.custid = C.custid
--WHERE O.orderdate = '20220212'
--   OR O.orderid IS NULL;

-- Solution Northwinds
select c.customerid, c.customercompanyname, o.orderid, o.orderdate
from sales.Customer AS c
  left outer join sales.[Order] AS o
    on o.customerid = c.customerid
where o.orderdate = '20220212'
   or o.orderid is null;

-- The above query is not correct because the WHERE clause filters out all rows where O.orderdate 
-- is not '20220212' and O.orderid is not NULL. This means that if a customer has an order that was 
-- not placed on February 12, 2022, that order will be excluded from the results, even though the 
-- customer should still be included with NULL values for the order columns. The correct solution 
-- uses the ON clause to filter orders by date, allowing all customers to be included regardless of 
-- their order history.

----------------------------------------------------------------------

-- 9
-- Return all customers, and for each return a Yes/No value
-- depending on whether the customer placed an order on Feb 12, 2022
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Solution TSQLV6
--SELECT DISTINCT C.custid, C.companyname, 
--  CASE WHEN O.orderid IS NOT NULL THEN 'Yes' ELSE 'No' END AS HasOrderOn20220212
--FROM Sales.Customers AS C
--  LEFT OUTER JOIN Sales.Orders AS O
--    ON O.custid = C.custid
--    AND O.orderdate = '20220212';

-- Solution Northwinds
select distinct c.customerid, c.customercompanyname, 
  CASE WHEN o.orderid IS NOT NULL THEN 'Yes' ELSE 'No' END AS HasOrderOn20220212
from sales.Customer AS c
  left outer join sales.[Order] AS o
    on o.customerid = c.customerid
    and o.orderdate = '20220212';

----------------------------------------------------------------------
-- Proposition 1: Identify high-value customers
-- What it does:
-- Calculates total customer spend by summing (UnitPrice * Quantity) across
-- all order line items, then returns only customers whose total spend is
-- greater than $20,000, sorted from highest to lowest spend.
-- Business use:
-- Helps identify VIP/high-revenue customers for retention efforts, targeted
-- marketing, loyalty programs, and account management prioritization.

SELECT c.CustomerId,
       c.CustomerCompanyName,
       SUM(od.UnitPrice * od.Quantity) AS TotalSpend
FROM sales.Customer AS c
INNER JOIN sales.[Order] AS o
  ON o.CustomerId = c.CustomerId
INNER JOIN sales.OrderDetail AS od
  ON od.OrderId = o.OrderId
GROUP BY c.CustomerId, c.CustomerCompanyName
HAVING SUM(od.UnitPrice * od.Quantity) > 20000
ORDER BY TotalSpend DESC;

----------------------------------------------------------------------
-- Proposition 2: Find customers who have never placed an order
-- What it does:
-- Returns customers that do not have a matching row in sales.[Order] by
-- using a LEFT JOIN and filtering where the order id is NULL.
-- Business use:
-- Builds a re-engagement/onboarding list to convert inactive customers,
-- improve conversion rates, and validate CRM data quality.

SELECT c.CustomerId,
       c.CustomerCompanyName,
       c.CustomerCountry
FROM sales.Customer AS c
LEFT JOIN sales.[Order] AS o
  ON o.CustomerId = c.CustomerId
WHERE o.OrderId IS NULL
ORDER BY c.CustomerCompanyName;

----------------------------------------------------------------------
-- Proposition 3: Measure employee order workload (including zero-order employees)
-- What it does:
-- Returns each employee and counts how many orders are assigned to them.
-- Uses a LEFT JOIN so employees with zero orders are still included.
-- Business use:
-- Supports workload balancing, performance reviews, staffing decisions,
-- and identifying employees who may need training or reassignment.

SELECT e.EmployeeId,
       e.EmployeeFirstName,
       e.EmployeeLastName,
       COUNT(o.OrderId) AS NumOrders
FROM HumanResources.Employee AS e
LEFT JOIN sales.[Order] AS o
  ON o.EmployeeId = e.EmployeeId
GROUP BY e.EmployeeId, e.EmployeeFirstName, e.EmployeeLastName
ORDER BY NumOrders DESC;

----------------------------------------------------------------------
-- Proposition 4: Detect sales of discontinued products
-- What it does:
-- Joins order line items to products and returns order lines where the
-- product is marked as discontinued.
-- Business use:
-- Flags inventory/compliance issues (selling discontinued items), helps
-- audit product lifecycle controls, and supports fixing catalog mistakes.

SELECT od.OrderId,
       od.ProductId,
       p.ProductName,
       od.Quantity
FROM sales.OrderDetail AS od
INNER JOIN Production.Product AS p
  ON p.ProductId = od.ProductId
WHERE p.Discontinued = 1
ORDER BY od.OrderId, p.ProductName;

----------------------------------------------------------------------
-- Proposition 5: Flag customers who ordered on a specific date
-- What it does:
-- Returns all customers and labels them 'Yes' or 'No' depending on whether
-- they placed an order on Feb 12, 2022. Uses a LEFT JOIN with the date
-- filter in the ON clause so customers are not excluded.
-- Business use:
-- Useful for promo-day analysis, auditing date-specific incidents, and
-- segmenting customers based on a specific sales event date.

SELECT DISTINCT
       c.CustomerId,
       c.CustomerCompanyName,
       CASE WHEN o.OrderId IS NOT NULL THEN 'Yes' ELSE 'No' END
         AS HasOrderOn20220212
FROM sales.Customer AS c
LEFT JOIN sales.[Order] AS o
  ON o.CustomerId = c.CustomerId
 AND o.OrderDate = '20220212'
ORDER BY c.CustomerCompanyName;

