-- USING DATABASE
USE [Car dealers];

-- List all columns and their 
EXEC sp_help 'Customer';
EXEC sp_help 'Cars';
EXEC sp_help 'Sales';



-- Count Rows in each table

SELECT COUNT(*) Total_Customers FROM Customer;
SELECT COUNT(*) Total_Cars FROM Cars;
SELECT COUNT(*) Total_Sales FROM Sales;
SELECT * FROM Dealer;
SELECT * FROM Sales;

-- Summarize Data
-- Count unique customers
SELECT COUNT(DISTINCT CustomerID) AS Unique_Customers FROM Customer;

--Identify most common address
SELECT Address,COUNT(*) AS Customer_Count
FROM Customer
GROUP BY Address
ORDER BY Customer_Count DESC;

-- Distribution of car makes
SELECT Make, COUNT(*) Car_count
FROM Cars
GROUP BY Make
ORDER BY Car_count DESC;

--- Average price by car make
SELECT Make, AVG(Price) AS avg_price
FROM Cars
GROUP BY Make;

-- Sales
-- Monthy sales

SELECT FORMAT(SaleDate, 'yyyy-MM') As Sale_Month, SUM(SalePrice) AS Total_Sales
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
ORDER BY Sale_Month DESC;

--- Top-Selling Cars
SELECT CarID, COUNT(*) AS Sale_Count
From Sales
GROUP BY CarID
ORDER BY Sale_Count DESC;

--- Data Quality Chesks
SELECT COUNT(*) AS Null_Count FROM Customer WHERE First_name IS NULL OR last_name IS NULL;
SELECT COUNT(*) AS Null_Count FROM Cars WHERE Make IS NULL OR Model IS NULL; 

-- Duplicates 

SELECT CustomerID, COUNT(*) AS Duplicates_Count
FROM Customer
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- Relationship and Key Insight

-- Customer Sales Insight
SELECT c.First_name,Last_name, COUNT(s.SaleID) AS Total_Sales, SUM (s.SalePrice) AS Total_Revenue
FROM Customer c 
JOIN Sales s ON c.CustomerID =s.CustomerID
GROUP BY c.First_name,c.last_name
ORDER BY Total_Revenue DESC;

--Car Performance 
SELECT ca.Make,ca.Model,COUNT(s.SaleID) AS Total_Sale,SUM(s.SalePrice) AS Total_Revenue
FROM Cars ca
JOIN Sales s ON ca.CarID =s.CarID
GROUP BY ca.Make, ca.Model
ORDER BY Total_Revenue DESC;

-- Total revenue generate by car, customer and the payment mode mostly used.

SELECT c.First_name,c.last_name,ca.Make,s.PaymentMethod,COUNT(s.SaleID) AS Total_sale,SUM(s.Saleprice) as Total_revenue
From customer c
JOIN Sales s ON c.CustomerID= s.CustomerID
JOIN  Cars ca ON s.CarID = ca.CarID
GROUP BY c.First_name,c.last_name,ca.Make,s.PaymentMethod
Order by s.PaymentMethod

--Here’s how you can query distinct revenue and sales per payment method:
SELECT s.PaymentMethod,COUNT(DISTINCT s.SaleID) AS Distinct_Sales,SUM(DISTINCT s.SalePrice) AS Distinct_Revenue
FROM Sales s
GROUP BY s.PaymentMethod
ORDER BY s.PaymentMethod;
-- Calculating total profit generated monthly by car

SELECT FORMAT(s.SaleDate,'yyyy-MM'),ca.Make, SUM(s.SalePrice) Total_sale,SUM(ca.Price) AS Total_Revenue, sum(s.SalePrice - ca.Price) as Profit
FROM Sales s
JOIN Cars ca ON ca.CarID =s.CarID
GROUP BY s.SaleDate,Make
ORDER BY Profit desc;


-- Calculating total profit generated quartely 

SELECT 
    DATEPART(YEAR, s.SaleDate) AS Sale_Year,'Q' + CAST(DATEPART(QUARTER, s.SaleDate) AS VARCHAR) AS Quarter,
    ca.Make, SUM(s.SalePrice) AS Total_Sale, SUM(ca.Price) AS Total_Cost, SUM(s.SalePrice - ca.Price) AS Profit
FROM  Sales s
JOIN Cars ca ON ca.CarID = s.CarID
GROUP BY DATEPART(YEAR, s.SaleDate), DATEPART(QUARTER, s.SaleDate), ca.Make
ORDER BY Sale_Year, Quarter, Profit DESC;

-- Visualize Trends
-- Yearly Revenue
SELECT YEAR(SaleDate) AS Sale_Year, SUM(SalePrice) AS Yearly_Revenue
FROM Sales
GROUP BY YEAR(SaleDate)
ORDER BY Sale_Year;

--- Advanced Insights
-- Identify High-Value Customers

SELECT CustomerID, SUM(SalePrice) As Total_Spent
FROM Sales 
GROUP BY CustomerID
HAVING SUM(SalePrice) > 5
ORDER BY Total_Spent desc;

-- Identify the highest-spending customers and their purchase details:
SELECT c.CustomerID,c.First_name,c.Last_name, COUNT(s.SaleID) AS Total_purchases,SUM(s.SalePrice) AS Total_Spent
FROM  Customer c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY  c.CustomerID, c.First_name, c.last_name
ORDER BY Total_Spent DESC;

-- Analyze which car models generate the most revenue:
SELECT ca.Make,ca.Model,
    COUNT(s.SaleID) AS Total_Sales,
    SUM(s.SalePrice) AS Revenue
FROM Cars ca
JOIN  Sales s ON ca.CarID = s.CarID
GROUP BY  ca.Make, ca.Model
ORDER BY  Revenue DESC;

-- Find customers who purchased multiple cars:
SELECT c.First_name, c.Last_name, 
    COUNT(ca.CarID) as Total_cars
From Customer c
JOIN Sales s ON s.CustomerID =c.CustomerID
LEFT JOIN Cars ca ON ca.CarID =s.CarID
GROUP BY c.First_name,c.last_name
ORDER BY Total_cars desc;

-- Exploring dealers and Service records 
SELECT * FROM Dealer
SELECT * FROM ServiceRecords

--- Which car model is more costly to service
SELECT c.Model, Sum(s.cost) as Total_cost
FROM Cars c
JOIN ServiceRecords s ON s.CarID =c.CarID
GROUP BY c.model
ORDER BY Total_cost desc;

-- The total cost of purchansing a car from the initial cost, the selling price and the cost of maintaning the car.
SELECT c.Model, 
       Sum(c.cost)as Initial_Price,
	   SUM(s.SalePrice) as Revenue,
	   ((s.SalePrice)-(c.cost)) as profit
	   SUM(s.cost) as Service_cost,
	   Sum(Initial_Price,Revenue,Service_cost) as Total_c
FROM Cars c
JOIN ON Sales s ON s.SalePrice=c.
GROUP BY c.model
ORDER BY Total_cost
        
