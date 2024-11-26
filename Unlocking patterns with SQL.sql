

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
SELECT 
    s.PaymentMethod,
    COUNT(DISTINCT s.SaleID) AS Distinct_Sales,
    SUM(DISTINCT s.SalePrice) AS Distinct_Revenue
FROM 
    Sales s
GROUP BY 
    s.PaymentMethod
ORDER BY 
    s.PaymentMethod;
