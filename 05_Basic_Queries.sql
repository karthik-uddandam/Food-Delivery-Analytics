/*==============================================================
    Script Name   : 04_Basic_Queries.sql
    Purpose       : Demonstrates basic SQL operations on Swiggy_Data
    Description   : Contains simple SELECT, WHERE, ORDER BY queries
                    for retrieving and filtering restaurant data
    Created On    : 13-Aug-2025
    Created By    : karthik
==============================================================*/
-- 1️ View all rows and columns
SELECT * 
FROM Swiggy_Data;

--2 View only specific columns
SELECT ID,Area,Restaurant,Avg_Ratings
FROM Swiggy_Data

--3 Filter by city
SELECT * 
FROM Swiggy_Data
WHERE City='Pune'

SELECT * 
FROM Swiggy_Data
WHERE City='Bangalore'

--4 Restaurants with price less than Rs300
SELECT Restaurant,Price
FROM Swiggy_Data
where CAST(CAST(price AS FLOAT) AS INT)<300;
 
--5 Restaurants with average rating greater than 4
SELECT Restaurant,Avg_Ratings
FROM Swiggy_Data
WHERE CAST(Avg_Ratings AS float)>4.0;

--6 Sort Restaurants by price(Low to High)
SELECT Restaurant,Price
FROM Swiggy_Data
ORDER BY CAST(CAST(price AS FLOAT) AS INT)ASC;

--7 Sort restaurants by rating(high to low)
SELECT Restaurant,Avg_Ratings
FROM Swiggy_Data
ORDER BY CAST(avg_ratings AS float) DESC;

--8 
--Get top 10 most expensive Restaurants
SELECT TOP 10 Restaurant,Price
FROM Swiggy_Data
ORDER BY  CAST(CAST(price AS FLOAT) AS INT)DESC;

--9 Find all Vegetarian restaurants
SELECT *
FROM Swiggy_Data
WHERE  Food_Type LIKE '%veg%';

--Find all Chinese Restaurants
SELECT *
FROM Swiggy_Data
WHERE Food_Type LIKE '%chinese%';

--10 Find All Restaurants In a specific area
SELECT *
FROM Swiggy_Data
WHERE Area='banjara hills';