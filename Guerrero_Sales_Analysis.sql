# ------------------------------------------------------------------------------------------------- #
# Capstone 1:            Sales Territory Analysis
# Name:                  Sharleen Guerrero
# Date:                  April 27, 2026
# Sales Manager:         Shruti Reddy
# Project Objective:     The objective of this project is to conduct a comprehensive business 
#                        analysis of the sample_sales database for a fictional bookstore chain called 
#                        EmporiUm. The analysis focuses on the Northeast region, specifically the 
#                        Maryland sales territory. Key insights will be explored through SQL queries 
#             			 to identify performance trends, and data-driven recommendations will be 
#                        provided for where to focus sales attention in the next quarter.
# -------------------------------------------------------------------------------------------------- #

USE sample_sales;

-- Identifying Sales Territory
-- This query aims to identify the assigned sales territory based on the sales manager.
SELECT * 
FROM management
WHERE SalesManager = 'Shruti Reddy';

-- Assigned Region: Northeast Region - State of Maryland.
-- Online Sales is its own sales territory managed separately in the
-- West region and is therefore excluded from this analysis.

# Part 1 & 2: Business Analysis Questions & Query Development Logic

-- ==========================================================
-- Question 1:
-- What is total revenue overall for sales in the assigned
-- territory, plus the start date and end date that tell you
-- what period the data covers?
-- ==========================================================
SELECT sl.State,
    SUM(ss.Sale_Amount) AS Total_Revenue,
    MIN(ss.Transaction_Date) AS Start_Date,
    MAX(ss.Transaction_Date) AS End_Date
FROM store_sales ss
INNER JOIN store_locations sl 
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland';

-- Explanation of Logic:
-- Question demands calculation of total revenue for Maryland territory.
-- Store ID acts as the bridge between store_sales and territory
-- through StoreId and Store_ID to filter sales by Maryland.
-- SUM calculates total revenue, and MIN and MAX identify start date
-- and end date from the result.
     
-- ==========================================================
-- Question 2:
-- What is the month by month revenue breakdown for the
-- sales territory?
-- ==========================================================
SELECT
    DATE_FORMAT(ss.Transaction_Date, '%Y-%m') AS Revenue_Month,
    SUM(ss.Sale_Amount) AS Monthly_Revenue
FROM store_sales ss
INNER JOIN store_locations sl 
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland'
GROUP BY Revenue_Month
ORDER BY Monthly_Revenue DESC;

-- Explanation of Logic:
-- Question demands a month by month revenue breakdown for Maryland.
-- There is no direct link between store_sales and territor state.
-- Store ID acts as the bridge between store_sales and territory
-- through StoreId and Store_ID to filter sales by Maryland.
-- GROUP BY ensures calculations are per month, not overall.
-- ORDER BY sorts results by monthly revenue DESC to see highest
-- revenue months first.

-- ==========================================================
-- Question 3:
-- Provide a comparison of total revenue for the specific
-- sales territory and the region it belongs to.
-- ==========================================================    
WITH Northeast_Sales AS (
    SELECT sl.State, ss.Sale_Amount AS Revenue
    FROM store_sales ss
    INNER JOIN store_locations sl 
		ON ss.Store_ID = sl.StoreId
    INNER JOIN management m 
		ON sl.State = m.State
    WHERE m.Region = 'Northeast'
)
SELECT 
    'Northeast' AS Region,
    State,
    SUM(Revenue) AS Total_Revenue,
    (SELECT SUM(Revenue) FROM Northeast_Sales) AS Northeast_Total
FROM Northeast_Sales
GROUP BY State
ORDER BY Total_Revenue DESC;

-- Explanation of Logic:
-- Question demands a comparison of Maryland total revenue and overall
-- sales for entire Northeast region.
-- A CTE is used to define store sales data for the Northeast region.
-- There is no direct link from store_sales to region, but a path is created.
-- Store_sales to Store_locations through StoreId and Store_ID, and finally
-- management is reached through shared State from Store_locations.
-- GROUP BY State collapses revenue into one row for each Northeast state.
-- A subquery pulls Northeast total as a reference column on every row
-- for direct comparison. ORDER BY sorts by Total_Revenue DESC to show
-- highest performing states first.

-- ==========================================================
-- Question 4:
-- What is the number of transactions per month and average
-- transaction size by product category for the sales 
-- territory?
-- =========================================================
SELECT
	DATE_FORMAT(ss.Transaction_Date,'%Y-%m') AS Revenue_Month,
    ic.Category as Product_Category,
	COUNT(*) AS Transaction_Count,
    ROUND(AVG(ss.Sale_Amount), 2) AS Average_Transaction_Size,
    SUM(ss.Sale_Amount) AS Category_Revenue
    FROM store_sales ss
    INNER JOIN store_locations sl
		ON ss.Store_ID = sl.StoreId
	INNER JOIN products p
		ON ss.Prod_Num = p.ProdNum
	INNER JOIN inventory_categories ic
		ON p.Categoryid = ic.Categoryid
	WHERE sl.State = 'Maryland'
	GROUP BY Revenue_Month, Product_Category
    ORDER BY Revenue_Month, Category_Revenue DESC;
    
-- Explanation of Logic:
-- Question demands average transaction size by product category
-- for Maryland and monthly count of transactions.
-- There is no direct link from store_sales to inventory_categories,
-- but a path is created. Store_sales joins store_locations through
-- StoreId and Store_ID, Store_sales joins products through ProdNum, 
-- and inventory_categories is reached through shared Categoryid.
-- COUNT calculates the number of transactions, AVG calculates the
-- average transaction size, and SUM calculates category revenue.
-- Results are filtered directly by sl.State.
-- Results are grouped by month and category and ordered by
-- category revenue DESC to display top performing categories first.

-- ==========================================================
-- Question 5:
-- Can you provide a ranking of in-store sales performance by
-- each store in the sales territory?
-- ==========================================================
SELECT ss.Store_ID AS Store_ID,
	   sl.StoreLocation AS Store_City,
    SUM(ss.Sale_Amount) AS Total_Revenue,
	COUNT(ss.Sale_Amount) AS Transaction_Count,
	ROUND(AVG(ss.Sale_Amount), 2) AS Average_Transaction_Size,
	RANK() OVER (ORDER BY SUM(ss.Sale_Amount) DESC) AS Store_Rank
FROM store_sales ss
INNER JOIN store_locations sl
	ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Maryland'
GROUP BY Store_ID, Store_City
ORDER BY Revenue_Rank;

-- Explanation of Logic:
-- Question demands a ranking of store performance across Maryland.
-- Store_sales is linked to store_locations through shared Store_ID
-- and StoreId to filter by Maryland and display store city names.
-- COUNT(ss.Sale_Amount) calculates total transactions, SUM(ss.Sale_Amount)
-- calculates total revenue, and AVG(ss.Sale_Amount) measures average
-- revenue per transaction.
-- RANK() assigns a rank to each store ordered by total revenue.
-- GROUP BY collapses all transactions into one row per store.
-- Results are ordered by Revenue_Rank to display top performing
-- stores first.

-- ==========================================================
-- Question 6:
-- What is your recommendation for where to focus sales
-- attention in the next quarter?
-- ==========================================================