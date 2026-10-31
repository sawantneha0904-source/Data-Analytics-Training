-- Create sample tables and data

CREATE DATABASE IF NOT EXISTS Day8_Sales;
USE Day8_Sales;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SaleAmount DECIMAL(10,2),
    SaleStatus VARCHAR(30)
);

INSERT INTO Customers VALUES
(1, 'Amit', 'Pune', 'amit@email.com'),
(2, 'Priya', 'Mumbai', 'priya@email.com'),
(3, 'Rahul', 'Pune', NULL),
(4, 'Sneha', 'Kolhapur', 'sneha@email.com'),
(5, 'Neha', 'Mumbai', NULL);

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Mouse', 'Accessories', 800),
(103, 'Keyboard', 'Accessories', 1500),
(104, 'Monitor', 'Electronics', 12000),
(105, 'Chair', 'Furniture', 4500);

INSERT INTO Sales VALUES
(1001, 1, 101, 1, 55000, 'Completed'),
(1002, 2, 102, 2, 1600, 'Completed'),
(1003, 3, 103, 1, 1500, 'Pending'),
(1004, 1, 104, 2, 24000, 'Completed'),
(1005, 4, 105, 1, 4500, 'Cancelled'),
(1006, 5, 102, 3, 2400, 'Pending');

-- Query 1 — Retrieve all customer records
SELECT * FROM Customers;

-- Explanation:
-- SELECT retrieves data.
-- * means all columns.
-- FROM specifies the table.

-- Query 2 - Retrieve specific columns
SELECT CustomerName, City FROM Customers;

-- Explanation: Displays only customer names and cities instead of every column.

-- Query 3 — Filter customers using WHERE
SELECT *
FROM Customers
WHERE City = 'Pune';


-- Explanation: Returns customers who live in Pune. WHERE filters rows based on a condition.

-- Query 4 — Sort products by price
SELECT ProductName, Price
FROM Products
ORDER BY Price DESC;


-- Explanation: ORDER BY sorts the results. DESC means highest to lowest; ASC means lowest to highest.

-- Query 5 — Retrieve unique cities
SELECT DISTINCT City
FROM Customers;


-- Explanation: DISTINCT removes duplicate values from the result. Pune and Mumbai will each appear only once.

-- Query 6 — Use a column alias
SELECT
    ProductName AS Product,
    Price AS Product_Price
FROM Products;


-- Explanation: AS gives columns temporary display names. It does not rename the original database columns.

-- Query 7 — Apply multiple filtering conditions
SELECT *
FROM Products
WHERE Price > 1000
  AND Category = 'Accessories';


-- Explanation: Returns accessories costing more than ₹1,000. Both conditions must be true because we use AND.

-- Query 8 — Use OR and comparison operators
SELECT *
FROM Customers
WHERE City = 'Pune'
   OR City = 'Mumbai';


-- Explanation: Returns customers from either Pune or Mumbai. With OR, at least one condition must be true.

-- Query 9 — Find customers with missing email addresses
SELECT *
FROM Customers
WHERE Email IS NULL;


-- Explanation: Returns customers whose email address is missing.
-- Remember: use IS NULL, not = NULL.


-- Query 10 — Find customers whose email is available
SELECT *
FROM Customers
WHERE Email IS NOT NULL;


-- Explanation: Returns customers who have a non-NULL email address.

-- Query 11 — Retrieve sales above ₹5,000
SELECT SaleID, CustomerID, SaleAmount
FROM Sales
WHERE SaleAmount > 5000
ORDER BY SaleAmount DESC;


-- Explanation: Retrieves sales exceeding ₹5,000 and sorts them from highest to lowest amount.


-- Query 12 — Retrieve specific sales records
SELECT *
FROM Sales
WHERE SaleStatus = 'Completed'
  AND Quantity >= 2;


-- Explanation: Returns completed sales where at least two units were sold.


-- DAY 9 — SQL Joins and Aggregations 
-- 1. Display customer names and their sale amounts using INNER JOIN.
select c.customerName, s.SaleAmount from customers as c inner join Sales as s 
on c.customerID = s.customerID;

-- 2. Write a query to display all customers and their sale amounts, including customers who have no sales.
select c.customerName, s.SaleAmount from customers as c left join Sales as s
on c.customerID = s.customerID;

-- 3. Calculate the total sales amount for each customer.
select c.customerName, c.customerID ,sum(s.SaleAmount)as total_sales_amount from customers as c inner join Sales as s 
on c.customerID = s.customerID
group by c.customerName, c.customerID;


-- 4. Find customers whose total sales amount is greater than ₹10,000.
SELECT c.customerID, c.customerName , sum(s.SaleAmount) as total_sales_amount 
from customers as c inner join Sales as s 
on c.customerID = s.customerID
group by  c.customerID, c.customerName
having total_sales_amount > 10000;

-- 5. Write one query to calculate these five results from your Sales table:
-- 1. Total number of sales records
-- 2. Total sales amount
-- 3. Average sale amount
-- 4. Minimum sale amount
-- 5. Maximum sale amount
select
count(SaleID) AS Total_number_of_sales_records,
sum(SaleAmount) as Total_sales_amount,
avg(SaleAmount) as Average_sale_amount,
min(SaleAmount) as min_sale_amount,
max(SaleAmount) as max_sale_amount
from Sales;


-- 6. Classify each order as High (₹20,000 or more), Medium (₹5,000 or more), or Low.
select SaleID, SaleAmount,
case
     when SaleAmount >= 20000 Then "High"
     when SaleAmount >= 5000 then "Medium"
     ELSE "Low"
end as salescategory
from Sales;


-- 7. Find sales records where the SaleAmount is greater than the average sale amount across all records.
select SaleID , SaleAmount
from Sales 
where SaleAmount > 
(select avg(SaleAmount) as avg_sale_amount
from Sales);


-- 8. Calculate total sales for each customer, then display only customers whose total sales exceed ₹10,000.
WITH CustomerSales AS (
    SELECT
        c.CustomerID,
        c.CustomerName,
        SUM(s.SaleAmount) AS TotalSales
    FROM Customers AS c
    INNER JOIN Sales AS s
        ON c.CustomerID = s.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT *
FROM CustomerSales
WHERE TotalSales > 10000;
    
    
-- 9. Calculate the total sales amount and total quantity sold for each product.
select p.productID, p.productName, 
sum(s.saleamount) as total_sales_amount,
sum(s.quantity) as total_quantity_sold 
from Sales as s inner join Products as p
on s.productID = p.productID
group by p.productID, p.productName;


-- 10. Calculate the total sales amount for Completed sales in each city.
select c.city, sum(s.SaleAmount) as total_completed_sales
from customers as c inner join Sales as s 
on c.customerID = s.customerID
where s.SaleStatus = "Completed"
group by c.city;
