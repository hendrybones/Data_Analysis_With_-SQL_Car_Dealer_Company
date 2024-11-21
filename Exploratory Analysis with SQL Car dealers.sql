/*
We will be performing data analysis using SQL, covering everything from basic to advanced techniques, with a case study focused on a car dealership company. 
The data for this case study was optimized from Mockaroo and saved as a CSV file, which was then imported into our SQL Server database for analysis.
 */

 /* Select the database the we are going to use in this case we going with Car Dealers database */
 USE [Car dealers];

/* We start  exploring the data 
 Using SELECT to get all data in the table */

SELECT * FROM Customer; -- this will query all the data available in customer table.
SELECT * FROM Cars;
SELECT * FROM Sales;


-- We are going to count the number of rows in the customer table;
SELECT COUNT(*) as Number_of_Customers 
FROM Customer;

-- We are going to extract Distinct count removing duplicate values 
-- Our results show there is no distinct values.
SELECT DISTINCT COUNT(*) DIST_Customer
FROM Customer;

-- Listing unique values from the table
-- This gives the list of all customer we are dealing with without repeating 
SELECT DISTINCT First_name FROM Customer;

-- Move to Aggregation &  Summaries 
-- Lets count distint customer name in the customer table
SELECT DISTINCT COUNT(First_name)FROM Customer

-- Calulating the average Sale price 

SELECT AVG(SalePrice) AS AVerage_Price
FROM Sales;

-- Get total Sales using SUM()  funtion

SELECT SUM(SalePrice) AS Total_Sales
FROM Sales;

-- Selecting the MAX and MIN SalePrice from our Sales.

SELECT MAX(SalePrice) AS Maximum_Price, MIN(SalePrice) AS Minimum_Price
FROM Sales;

-- Aggregate using Group BY Keyword.

SELECT SaleID , AVG(SalePrice) AS Average_Price, SUM(SalePrice) AS Total_Price
FROM Sales
GROUP BY SaleID
                         -- DATA SLICING AND FILTERING
--  Using SELECT with a certian creteria
SELECT * FROM Customer 
WHERE Address ='7 Eastwood Junction';

-- Filtering Using multiple conditions using Logical AND
SELECT * FROM Cars
WHERE Year =2006 and Color='violet';

-- Filtering by ORDER BY and sorting IN ASC or DESC
SELECT Make, Year, Color FROM Cars
ORDER BY Year DESC;

-- USing LIMIT Keyword to restrict number of records.
SELECT TOP 10 *
FROM Cars;

-- Using BETWEEN for Range 
SELECT * 
FROM Cars
WHERE RegistrationDate BETWEEN '2024-01-31' AND '2024-03-21';

-- Describing the table
EXEC sp_help 'Cars';

--                             Working with Dates

-- How to extract Year from Dates 
SELECT YEAR(RegistrationDate) AS Year
FROM Cars

--How to extract Month in a date 
SELECT Year(RegistrationDate) AS Year,
MONTH(RegistrationDate) AS Month,
Day(RegistrationDate) AS DAY
From Cars 

-- How to set a date format in SQL 

SELECT FORMAT(RegistrationDate, 'yyyy-MM-dd') AS FormattedDate
FROM Cars;

-- Group by date

SELECT Make, Color, RegistrationDate,COUNT(Make) AS Number_of_Cars
FROM Cars
GROUP BY Make, Color,RegistrationDate
ORDER BY  Make DESC;

--               Conditional Logic

--- USING A CASE Statement 
-- Lets consider the sales table 

SELECT (CASE WHEN SalePrice >= 2 THEN SUM(Saleprice) ELSE 0 END) as Total_Sales
FROM Sales
Group by SaleID,SalePrice
ORDER BY SalePrice DESC;