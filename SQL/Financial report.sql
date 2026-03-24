/*
SQL Task: Seeing business performance.
1) Sales Overview — What are total sales, profit, and order volume? What's the profit margin overall?
2) Regional Performance — Which regions and states are driving the most revenue and profit?
3) Product Analysis — Which categories and sub-categories are the most and least profitable?
4) Customer Segments — How do Consumer, Corporate, and Home Office segments compare on sales and profit?
5) Trend Analysis — How have sales and profit trended over time? Are there seasonal patterns?
*/

--SELECT * FROM Superstore;

--1) Sales Overview — What are total sales, profit, and order volume? What's the profit margin overall?
SELECT
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore;

--2) Regional Performance — Which regions and states are driving the most revenue and profit?
SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Region
ORDER BY ROUND(SUM(Sales), 2) DESC, ROUND(SUM(Profit), 2) DESC;

--States report
SELECT TOP 10
    state,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY state
ORDER BY ROUND(SUM(Sales), 2) DESC, ROUND(SUM(Profit), 2) DESC;

--3) Product Analysis — Which categories and sub-categories are the most and least profitable?
--Categories
SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category
ORDER BY ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) DESC;

--Sub-categories
SELECT
    Sub_Category,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Sub_Category
ORDER BY ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) DESC;

--4) Customer Segments — How do Consumer, Corporate, and Home Office segments compare on sales and profit?
SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY Segment
ORDER BY ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) DESC;

--5) Trend Analysis — How have sales and profit trended over time? Are there seasonal patterns?
--overall
SELECT
    YEAR(Order_Date) AS year,
    MONTH(Order_Date) AS month_number,
    DATENAME(MONTH, Order_Date) AS month_name,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY YEAR(Order_Date), MONTH(Order_Date), DATENAME(MONTH, Order_Date)
ORDER BY year, month_number
--yearly
SELECT
    YEAR(Order_date) AS Years,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY YEAR(Order_date)
ORDER BY YEAR(Order_date), ROUND(SUM(Sales), 2) DESC, ROUND(SUM(Profit), 2) DESC;

