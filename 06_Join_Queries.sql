/*==============================================================
    Script Name   : 05_Join_Queries.sql
    Purpose       : Demonstrate JOIN queries using Swiggy dataset
    Description   : Joins Swiggy_Data with Swiggy_Offers table to show 
                    promotions for restaurants using different JOIN types.
    Created On    : 13-Aug-2025
    Created By    : karthik
==============================================================*/

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