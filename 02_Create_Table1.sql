/*==============================================================
    Script Name   : 02_Create_Table.sql
    Table Name    : Swiggy_Data
    Purpose       : To store Swiggy restaurant dataset for analysis
    Description   : Contains details such as restaurant name, 
                    location, price, ratings, food type, and delivery time
    Created On    : 13-Aug-2025
    Created By    : karthik
==============================================================*/


CREATE TABLE Swiggy_Data (
    ID NVARCHAR(50),
    Area NVARCHAR(255),
    City NVARCHAR(255),
    Restaurant NVARCHAR(255),
    Price NVARCHAR(50),
    Avg_Ratings NVARCHAR(50),
    Total_Ratings NVARCHAR(50),
    Food_Type NVARCHAR(255),
    Address NVARCHAR(MAX),
    Delivery_Time NVARCHAR(50)
);
BULK INSERT Swiggy_Data
FROM 'C:\SwiggyData\swiggy.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
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
-- 1. INNER JOIN (only restaurants that have offers)
SELECT d.Restaurant, d.City, d.Price, o.Offer_Description
FROM Swiggy_Data d
INNER JOIN Swiggy_Offers o
    ON d.Restaurant = o.Restaurant;

-- 2. LEFT JOIN (all restaurants, with offers if available)
SELECT d.Restaurant, d.City, d.Price, o.Offer_Description
FROM Swiggy_Data d
LEFT JOIN Swiggy_Offers o
    ON d.Restaurant = o.Restaurant;

-- 3. RIGHT JOIN (all offers, even if the restaurant doesn't exist in main table)
SELECT d.Restaurant, d.City, d.Price, o.Offer_Description
FROM Swiggy_Data d
RIGHT JOIN Swiggy_Offers o
    ON d.Restaurant = o.Restaurant;

-- 4. FULL OUTER JOIN (all restaurants and all offers)
SELECT d.Restaurant, d.City, d.Price, o.Offer_Description
FROM Swiggy_Data d
FULL OUTER JOIN Swiggy_Offers o
    ON d.Restaurant = o.Restaurant;

-- 5. SELF JOIN example (find restaurants in the same city)
SELECT a.Restaurant AS Restaurant1, b.Restaurant AS Restaurant2, a.City
FROM Swiggy_Data a
INNER JOIN Swiggy_Data b
    ON a.City = b.City
    AND a.Restaurant <> b.Restaurant;

-- 6. CROSS JOIN example (cartesian product of small offers table and first 10 restaurants)
SELECT TOP 10 d.Restaurant, o.Offer_Description
FROM Swiggy_Data d
CROSS JOIN Swiggy_Offers o;

-- 7. INNER JOIN with condition (top-rated restaurants with offers)
SELECT d.Restaurant, d.City, d.Price, d.Avg_Ratings, o.Offer_Description
FROM Swiggy_Data d
INNER JOIN Swiggy_Offers o
    ON d.Restaurant = o.Restaurant
WHERE TRY_CAST(d.Avg_Ratings AS FLOAT) >= 4.5
ORDER BY TRY_CAST(d.Avg_Ratings AS FLOAT) DESC;
/*
06_Aggregation_Queries.sql

Description:
This SQL script contains multiple aggregation queries performed on the Swiggy_Data table.
Aggregation queries are used to summarize, analyze, and extract meaningful insights from data.
The queries include:

1. COUNT – to find the number of records, restaurants, or food types.
2. SUM – to calculate total revenue or total ratings.
3. AVG – to determine average price, average rating, or average delivery time.
4. MIN/MAX – to identify the minimum and maximum ratings, prices, or delivery times.
5. GROUP BY – to group data by city, area, restaurant, or food type.
6. HAVING – to filter aggregated results based on conditions.

These queries are useful for reporting, analytics, and decision-making in business scenarios, 
and they demonstrate practical SQL skills often asked in interviews.
*/
-- 1.Total number of restaurants
SELECT COUNT(*) AS Total_Restaurants
FROM Swiggy_Data

--2.Average price of food
SELECT AVG(TRY_CAST(price AS FLOAT)) AS Avg_price
FROM Swiggy_Data;

--3.Maximum and minimum ratings
SELECT MAX(Avg_Ratings) AS Max_Rating,
       MIN(Avg_Ratings) AS Min_Rating
FROM Swiggy_Data;

--4. Total rating per city
SELECT CITY, SUM(TRY_CAST(total_ratings AS float))  total_ratings
FROM Swiggy_Data
GROUP BY City

--5.Average delivery time per restaurant
SELECT Restaurant, AVG(TRY_CAST(Delivery_Time AS float)) Avg_Delivery_Time
FROM Swiggy_Data
GROUP BY Restaurant;

--6.Number of restaurants by food type
SELECT Food_Type,COUNT(*)AS Num_Restaurants
FROM Swiggy_Data
GROUP BY Food_Type

--7. Total revenue per restaurant(price*total_ratings)
SELECT Restaurant, SUM(TRY_CAST(Price AS FLOAT) * TRY_CAST(Total_Ratings AS INT)) AS Total_Revenue
FROM Swiggy_Data
GROUP BY Restaurant;

--8. Highest-rated restaurant in each city
SELECT City, Restaurant, MAX(TRY_CAST(Avg_Ratings AS FLOAT)) AS Max_Rating
FROM Swiggy_Data
GROUP BY City, Restaurant;

--9.Number of restaurants in each area
SELECT Area, COUNT(*) AS Num_Restaurants
FROM Swiggy_Data
GROUP BY Area;

--10. Average delivery time by food type
SELECT Food_Type, AVG(TRY_CAST(Delivery_Time AS FLOAT)) AS Avg_Delivery_Time
FROM Swiggy_Data
GROUP BY Food_Type;

--11. Cities with more than 50 restaurants
SELECT City, COUNT(*) AS Num_Restaurants
FROM Swiggy_Data
GROUP BY City
HAVING COUNT(*) > 50;

--12. Food types with average rating above 4
SELECT Food_Type, AVG(TRY_CAST(Avg_Ratings AS FLOAT)) AS Avg_Rating
FROM Swiggy_Data
GROUP BY Food_Type
HAVING AVG(TRY_CAST(Avg_Ratings AS FLOAT)) > 4;

--13. Total ratings for top 5 restaurants by revenue
SELECT TOP 5 Restaurant, SUM(TRY_CAST(Total_Ratings AS INT)) AS Total_Ratings
FROM Swiggy_Data
GROUP BY Restaurant
ORDER BY SUM(TRY_CAST(Price AS FLOAT) * TRY_CAST(Total_Ratings AS INT)) DESC;

--14. Minimum and maximum delivery time by city
SELECT City, MIN(TRY_CAST(Delivery_Time AS FLOAT)) AS Min_Delivery, 
             MAX(TRY_CAST(Delivery_Time AS FLOAT)) AS Max_Delivery
FROM Swiggy_Data
GROUP BY City;

15--. Number of restaurants per rating range
SELECT 
    CASE 
        WHEN TRY_CAST(Avg_Ratings AS FLOAT) >= 4.5 THEN '4.5 & above'
        WHEN TRY_CAST(Avg_Ratings AS FLOAT) >= 4 THEN '4 - 4.49'
        ELSE 'Below 4'
    END AS Rating_Range,
    COUNT(*) AS Num_Restaurants
FROM Swiggy_Data
GROUP BY 
    CASE 
        WHEN TRY_CAST(Avg_Ratings AS FLOAT) >= 4.5 THEN '4.5 & above'
        WHEN TRY_CAST(Avg_Ratings AS FLOAT) >= 4 THEN '4 - 4.49'
        ELSE 'Below 4'
    END;

--16. Average rating per area
SELECT Area, AVG(TRY_CAST(Avg_Ratings AS FLOAT)) AS Avg_Rating
FROM Swiggy_Data
GROUP BY Area;

--17. Total number of restaurants and average price per city
SELECT City, COUNT(*) AS Num_Restaurants, AVG(TRY_CAST(Price AS FLOAT)) AS Avg_Price
FROM Swiggy_Data
GROUP BY City;

--18. Restaurants with more than 1000 total ratings
SELECT Restaurant, SUM(TRY_CAST(Total_Ratings AS INT)) AS Total_Ratings
FROM Swiggy_Data
GROUP BY Restaurant

/*
08_Advanced_Queries.sql

Description:
This SQL script contains advanced queries using CTEs (Common Table Expressions) 
and window functions on the Swiggy_Data table.

Key Concepts Covered:
1. CTE (Common Table Expression) – Temporary named result sets that simplify 
   complex queries, improve readability, and allow reuse within a query.
2. Window Functions – Perform calculations across a set of table rows related 
   to the current row, without collapsing rows. Useful for ranking, running totals,
   moving averages, and analytics.

Examples included:
- Ranking restaurants by rating per city (RANK, DENSE_RANK, ROW_NUMBER)
- Cumulative totals of ratings per city
- Moving averages of restaurant ratings
- Filtering top restaurants per city using CTEs
- Comparing individual restaurant performance against city averages

These queries are designed for data analysis, business intelligence reporting,
and to demonstrate advanced SQL skills often tested in interviews.
*/


--1. CTE – Top 5 highest-rated restaurants
WITH TopRated AS (
    SELECT Restaurant, City, TRY_CAST(Avg_Ratings AS FLOAT) AS Rating
    FROM Swiggy_Data
)
SELECT TOP 5 *
FROM TopRated
ORDER BY Rating DESC;

--2. CTE with aggregate – Average price per city
WITH CityAvg AS (
    SELECT City, AVG(TRY_CAST(Price AS FLOAT)) AS Avg_Price
    FROM Swiggy_Data
    GROUP BY City
)
SELECT *
FROM CityAvg
WHERE Avg_Price > 200;  -- Example filter

--3. Window Function – Rank restaurants by rating per city
SELECT Restaurant, City, TRY_CAST(Avg_Ratings AS FLOAT) AS Rating,
       RANK() OVER (PARTITION BY City ORDER BY TRY_CAST(Avg_Ratings AS FLOAT) DESC) AS Rank_In_City
FROM Swiggy_Data;

--4. Window Function – Dense rank by total ratings per city
SELECT Restaurant, City, TRY_CAST(Total_Ratings AS INT) AS Ratings,
       DENSE_RANK() OVER (PARTITION BY City ORDER BY TRY_CAST(Total_Ratings AS INT) DESC) AS DenseRank_In_City
FROM Swiggy_Data;

5. Window Function – Cumulative total ratings per city
SELECT City, Restaurant, TRY_CAST(Total_Ratings AS INT) AS Total_Ratings,
       SUM(TRY_CAST(Total_Ratings AS INT)) OVER (PARTITION BY City ORDER BY Restaurant) AS Cumulative_Ratings
FROM Swiggy_Data;

--6. Window Function – Moving average of ratings per restaurant
SELECT Restaurant, City, TRY_CAST(Avg_Ratings AS FLOAT) AS Rating,
       AVG(TRY_CAST(Avg_Ratings AS FLOAT)) OVER (PARTITION BY City ORDER BY Restaurant ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg_Rating
FROM Swiggy_Data;

--7. CTE + Window Function – Top restaurant in each city
WITH Ranked AS (
    SELECT Restaurant, City, TRY_CAST(Avg_Ratings AS FLOAT) AS Rating,
           ROW_NUMBER() OVER (PARTITION BY City ORDER BY TRY_CAST(Avg_Ratings AS FLOAT) DESC) AS RowNum
    FROM Swiggy_Data
)
SELECT Restaurant, City, Rating
FROM Ranked
WHERE RowNum = 1;

--8. CTE – Restaurants with above-average rating per city
WITH CityAvg AS (
    SELECT City, AVG(TRY_CAST(Avg_Ratings AS FLOAT)) AS Avg_Rating
    FROM Swiggy_Data
    GROUP BY City
)
SELECT s.Restaurant, s.City, TRY_CAST(s.Avg_Ratings AS FLOAT) AS Rating
FROM Swiggy_Data s
JOIN CityAvg c
    ON s.City = c.City
WHERE TRY_CAST(s.Avg_Ratings AS FLOAT) > c.Avg_Rating;
