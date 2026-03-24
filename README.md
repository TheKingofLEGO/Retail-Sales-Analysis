# Retail Sales Analysis (2014–2017)

A data analytics portfolio project analyzing four years of retail sales data to identify where a business is generating value, where it is losing money, and what actions the data supports.

**Tools Used:** SQL (T-SQL) • Power BI

---

## Business Problem

A regional retail company experienced consistent revenue growth over four years but raised concerns that profitability was not keeping pace. This project investigates that gap across five business questions:

1. What are total sales, profit, and order volume, and what is the overall profit margin?
2. Which regions and states are driving the most revenue and profit?
3. Which product categories and subcategories are the most and least profitable?
4. How do Consumer, Corporate, and Home Office segments compare on sales and profit?
5. How have sales and profit trended over time, and are there seasonal patterns?

---

## Dataset

- **Source:** Superstore retail dataset
- **Table:** `Superstore`
- **Size:** 9,994 rows | 793 distinct customers | 5,009 distinct orders
- **Time Range:** 2014–2017
- **Key Fields:** Order_ID, Order_Date, Customer_ID, Segment, Region, State, Category, Sub_Category, Sales, Profit

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| SQL (T-SQL) | Data validation, aggregation, and metric calculation |
| Power BI | Three-page interactive dashboard |

---

## SQL Analysis

All queries were written in T-SQL against a single `Superstore` table. The analysis is structured in five sections, each tied to a specific business question. Before any analysis was run, a data validation pass was completed to confirm the dataset was clean and ready to work with.

---

### Data Validation

Before running any analysis, row counts and null checks were performed to confirm the dataset had no missing or blank values across all key fields.

```sql
-- Row and field counts
SELECT
    COUNT(*)                    AS total_rows,
    COUNT(Customer_ID)          AS total_customers,
    COUNT(DISTINCT Customer_ID) AS total_distinct_customers,
    COUNT(DISTINCT Order_ID)    AS total_distinct_orders,
    COUNT(Order_ID)             AS total_orders,
    COUNT(Row_ID)               AS Total,
    COUNT(sales)                AS total_sales
FROM Superstore;

-- Null and blank check across key fields
SELECT
    SUM(CASE WHEN Order_ID      IS NULL OR Order_ID      = '' THEN 1 ELSE 0 END) AS Order_ID_issues,
    SUM(CASE WHEN Customer_Name IS NULL OR Customer_Name = '' THEN 1 ELSE 0 END) AS Customer_issues,
    SUM(CASE WHEN Sales         IS NULL                       THEN 1 ELSE 0 END) AS Sales_issues,
    SUM(CASE WHEN Profit        IS NULL                       THEN 1 ELSE 0 END) AS Profit_issues,
    SUM(CASE WHEN Category      IS NULL OR Category      = '' THEN 1 ELSE 0 END) AS Category_issues,
    SUM(CASE WHEN Region        IS NULL OR Region        = '' THEN 1 ELSE 0 END) AS Region_issues,
    SUM(CASE WHEN State         IS NULL OR State         = '' THEN 1 ELSE 0 END) AS State_issues
FROM Superstore;
```

**Result:** Zero issues found across all fields. Dataset confirmed clean — no nulls, no blanks, no missing values.

---

### Query 1 — Sales Overview

**Question:** What are total sales, profit, and order volume? What is the overall profit margin?

```sql
SELECT
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore;
```

**Finding:** $2.30M in total sales, $286.82K in profit, 5,009 orders, and a 12.49% overall profit margin.

---

### Query 2 — Regional Performance

**Question:** Which regions and states are driving the most revenue and profit?

```sql
-- By region
SELECT
    Region,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY Region
ORDER BY ROUND(SUM(Sales), 2) DESC, ROUND(SUM(Profit), 2) DESC;

-- Top 10 states by revenue
SELECT TOP 10
    State,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY State
ORDER BY ROUND(SUM(Sales), 2) DESC, ROUND(SUM(Profit), 2) DESC;
```

**Finding:** The West leads with $725K in sales. New York is the most efficient state — $310K in sales and $74K in profit at half California's order volume. Texas, Illinois, and Ohio all show negative margins.

---

### Query 3 — Product Analysis

**Question:** Which categories and subcategories are the most and least profitable?

```sql
-- By category
SELECT
    Category,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY Category
ORDER BY ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) DESC;

-- By subcategory
SELECT
    Sub_Category,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY Sub_Category
ORDER BY ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) DESC;
```

**Finding:** Technology leads at 17% margin. Furniture generates $742K in revenue but only 3% margin. Tables are the weakest subcategory with negative profit (-$17K).

---

### Query 4 — Customer Segments

**Question:** How do Consumer, Corporate, and Home Office segments compare on sales and profit?

```sql
SELECT
    Segment,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY Segment
ORDER BY ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) DESC;
```

**Finding:** Consumer generates $1.16M — nearly double Corporate. All three segments sit between 12–14% margin, meaning segment mix is not the source of the margin problem.

---

### Query 5 — Trend Analysis

**Question:** How have sales and profit trended over time? Are there seasonal patterns?

```sql
-- Monthly breakdown
SELECT
    YEAR(Order_Date)                            AS year,
    MONTH(Order_Date)                           AS month_number,
    DATENAME(MONTH, Order_Date)                 AS month_name,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY YEAR(Order_Date), MONTH(Order_Date), DATENAME(MONTH, Order_Date)
ORDER BY year, month_number;

-- Yearly rollup
SELECT
    YEAR(Order_Date)                            AS year,
    COUNT(DISTINCT Order_ID)                    AS total_orders,
    ROUND(SUM(Sales), 2)                        AS total_sales_revenue,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM Superstore
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date);
```

**Finding:** Sales grew consistently from $484K (2014) to $733K (2017). Profit margin peaked at 13.43% in 2016 then dipped to 12.80% in 2017. Two seasonal peaks: March and November ($352K). January and February are the slowest months.

---

## Power BI Dashboard

The dashboard is three pages with interactive slicers for Year, Category, and Region.

**Page 1 — Trend Analysis**
Yearly and monthly sales and profit bar/line charts, plus a profit margin by year visual.
<p align="center">
  <img src="Screen Shots/1. Trend Analysis.png" width="800"/>
</p>
**Page 2 — Region Analysis**
Region and state performance table, profit margin by region pie chart, and a geographic map of sales by state.
<p align="center">
  <img src="Screen Shots/2. Region Analysis.png" width="800"/>
</p>
**Page 3 — Product Performance Analysis**
Category and subcategory breakdowns, segment comparison, and a top products table ranked by profit margin.
<p align="center">
  <img src="Screen Shots/3. Product Performance Analysis.png" width="800"/>
</p>
---

## Key Findings Summary

- Revenue grew every year, but the 2017 margin dip signals rising costs or discounting worth investigating
- New York is the most efficient state in the dataset and is likely underserved
- The Central region is losing money across its three largest states by order volume
- Furniture is a high-revenue, low-margin problem category
- Technology and Copiers are the clearest margin drivers in the portfolio
- Q1 is consistently the weakest period — January and February warrant a demand strategy

---

## Recommendations

1. Investigate the 2017 margin decline before treating revenue growth as a sign of overall health
2. Build a growth strategy around New York — high efficiency, likely underserved
3. Conduct a full operational review of the Central region before any further investment there
4. Review Furniture pricing and cost structure — $742K in sales at 3% margin is a significant opportunity cost
5. Double down on Technology and Copiers, the clearest margin drivers
6. Develop a Q1 demand strategy to address the consistent January–February slowdown

---

## Files

| File | Description |
|------|-------------|
| `Financial_report.sql` | All SQL queries used in the analysis |
| Power BI Dashboard | Three-page interactive report (Trend, Region, Product) |

---

## Author

**William Fowler**
