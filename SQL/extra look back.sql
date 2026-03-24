/* SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY Category
ORDER BY ROUND(SUM(Sales), 2) DESC, ROUND(SUM(Profit), 2) DESC;

*/
WITH yearly_salary_totals AS (
    SELECT
        YEAR(Order_date) AS Years,
        job_category AS job_category,
        SUM(salary_in_USD) AS total_salary
    FROM salary
    GROUP BY work_year, job_category
)
SELECT
    Years,
    job_category,
    total_salary,
    -- Average salary across all years for each job category
    AVG(total_salary) OVER (PARTITION BY job_category) AS avg_category_salary,
    -- Difference between current year salary and category average
    total_salary - AVG(total_salary) OVER (PARTITION BY job_category) AS diff_from_avg,
    -- Label whether the salary is above, below, or at the average
    CASE
        WHEN total_salary > AVG(total_salary) OVER (PARTITION BY job_category) THEN 'Above Average'
        WHEN total_salary < AVG(total_salary) OVER (PARTITION BY job_category) THEN 'Below Average'
        ELSE 'At Average'
    END AS avg_comparison,
    -- Salary from the previous year for the same job category
    LAG(total_salary) OVER (
        PARTITION BY job_category
        ORDER BY year
    ) AS previous_year_salary,
    -- Difference between current year and previous year
    total_salary - LAG(total_salary) OVER (
        PARTITION BY job_category
        ORDER BY year
    ) AS year_over_year_difference,
    -- Label whether salary increased, decreased, or stayed the same
    CASE
        WHEN total_salary > LAG(total_salary) OVER (PARTITION BY job_category ORDER BY year) THEN 'Increase'
        WHEN total_salary < LAG(total_salary) OVER (PARTITION BY job_category ORDER BY year) THEN 'Decrease'
        ELSE 'No Change'
    END AS year_over_year_trend
FROM yearly_salary_totals
ORDER BY job_category, year;

---extra
--year by year analysis for each category showing the margin change with category
WITH yearly_category_totals AS (
    SELECT
        YEAR(Order_Date) AS year,
        Category AS category,
        ROUND(SUM(Sales), 2) AS total_sales,
        ROUND(SUM(Profit), 2) AS total_profit,
        ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
    FROM Superstore
    GROUP BY YEAR(Order_Date), Category
)
SELECT
    year,
    category,
    total_sales,
    total_profit,
    profit_margin_pct,
    ROUND(profit_margin_pct - LAG(profit_margin_pct) OVER (PARTITION BY category ORDER BY year), 2) AS margin_change,
    CASE
        WHEN profit_margin_pct > LAG(profit_margin_pct) OVER (PARTITION BY category ORDER BY year) THEN 'Improving'
        WHEN profit_margin_pct < LAG(profit_margin_pct) OVER (PARTITION BY category ORDER BY year) THEN 'Declining'
        ELSE 'Stable'
    END AS margin_trend
FROM yearly_category_totals
ORDER BY category, year

--yearly report regional report
SELECT
    YEAR(Order_date) AS Years,
    Region,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales_revenue,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY YEAR(Order_date), Region
ORDER BY region, YEAR(Order_date);