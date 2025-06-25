#  SQL Sales Analysis Project

This project uses SQL to analyze customer orders, products, revenue trends, and buying behavior using a fictional sales dataset.

##  Database Name
jatin_sql_project

##  Tables
- customers: Contains customer info (name, region)
- products: Product catalog with price, category
- orders: Records of customer purchases
- order_items: Details of items per order

##  Key Analyses Performed
| # | Query Description | SQL Features Used |
|---|-------------------|-------------------|
| 1 | Total Revenue by Month | GROUP BY, JOIN, MONTH() |
| 2 | Top 5 Customers by Spend | JOIN, SUM(), ORDER BY, LIMIT |
| 3 | Product-wise Quantity & Revenue | GROUP BY, SUM() |
| 4 | Region-wise Orders and Avg Order Value | COUNT(DISTINCT), JOIN, AVG() |
| 5 | Monthly Revenue vs Previous Month | CTE, LAG(), Window Functions |
| 6 | Product Rankings by Revenue | DENSE_RANK(), CTE, Window Functions |
| 7 | Customer Gap Between Orders | LEAD(), DATEDIFF(), PARTITION BY |
| 8 | Detect Returning Customers | CASE, COUNT(), GROUP BY |

## ⚠ Note
> If you see errors when opening the .sql file in MySQL Workbench, it's likely due to syntax parsing — *not actual errors in logic*. You can run queries manually, and they work as expected.

## 🧠 Skills Demonstrated
- Advanced SQL
- Data Cleaning & Aggregation
- CTEs and Window Functions
- Business Insight from Data

## ✅ Author
Jatin Kumar
