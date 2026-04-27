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

# Part 1 & 2: Business Analysis Questions & Query Development Logic

-- ==========================================================
-- Question 1:
-- What is total revenue overall for sales in the assigned
-- territory, plus the start date and end date that tell you
-- what period the data covers?
-- ==========================================================
SELECT
    (SELECT SUM(SalesTotal) 
     FROM online_sales 
     WHERE ShiptoState = 'Maryland') AS Online_Revenue,

    (SELECT SUM(ss.Sale_Amount) 
     FROM store_sales ss
     JOIN store_locations sl ON ss.Store_ID = sl.StoreId
     WHERE sl.State = 'Maryland') AS Store_Revenue,

    (SELECT SUM(SalesTotal) 
     FROM online_sales 
     WHERE ShiptoState = 'Maryland') 
    +
    (SELECT SUM(ss.Sale_Amount) 
     FROM store_sales ss
     JOIN store_locations sl ON ss.Store_ID = sl.StoreId
     WHERE sl.State = 'Maryland') AS Total_Revenue,

    (SELECT MIN(Date) 
     FROM online_sales 
     WHERE ShiptoState = 'Maryland') AS Start_Date,

    (SELECT MAX(Date) 
     FROM online_sales 
     WHERE ShiptoState = 'Maryland') AS End_Date;
     
-- ==========================================================
-- Question 2:
-- What is the month by month revenue breakdown for the
-- sales territory?
-- ==========================================================

-- ==========================================================
-- Question 3:
-- Provide a comparison of total revenue for the specific
-- sales territory and the region it belongs to.
-- ==========================================================

-- ==========================================================
-- Question 4:
-- What is the number of transactions per month and average
-- transaction size by product category for the sales 
-- territory?
-- ==========================================================

-- ==========================================================
-- Question 5:
-- Can you provide a ranking of in-store sales performance by
-- each store in the sales territory?
-- ==========================================================

-- ==========================================================
-- Question 6:
-- What is your recommendation for where to focus sales
-- attention in the next quarter?
-- ==========================================================