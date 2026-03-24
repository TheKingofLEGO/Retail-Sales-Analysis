SELECT TOP 10 Profit
FROM Superstore
ORDER BY Profit DESC;

SELECT TOP 10 Profit
FROM Superstore
ORDER BY Profit ASC;

SELECT *
FROM Superstore
WHERE discount IS NULL;

SELECT
COUNT(*) AS total_rows,
COUNT(Customer_ID) AS total_customers,
COUNT(DISTINCT Customer_ID) AS total_distinct_customers,
COUNT(DISTINCT Order_ID) AS total_distinct_orders,
COUNT(Order_ID) AS total_orders,
COUNT(Row_ID) AS Total,
COUNT(sales) AS total_sales
FROM Superstore

SELECT @@SERVERNAME;

SELECT
    SUM(CASE WHEN Order_ID IS NULL OR Order_ID = '' THEN 1 ELSE 0 END) AS Order_ID_issues,
    SUM(CASE WHEN Customer_Name IS NULL OR Customer_Name = '' THEN 1 ELSE 0 END) AS Customer_issues,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Sales_issues,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Profit_issues,
    SUM(CASE WHEN Category IS NULL OR Category = '' THEN 1 ELSE 0 END) AS Category_issues,
    SUM(CASE WHEN Region IS NULL OR Region = '' THEN 1 ELSE 0 END) AS Region_issues,
    SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS State_issues
FROM Superstore