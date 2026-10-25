# E-Commerce Sales Analysis with SQL

52 business questions answered with SQL on a sample e-commerce database, covering sales, products, customers, revenue trends, order gaps, and retention and churn.

**Author:** Rudra Prakash Das | Data Analyst | Power BI Developer
[LinkedIn](https://linkedin.com/in/rudra-prakash-das) | [GitHub](https://github.com/RUDRAPRAKASHDAS)

## Project Overview

This project uses a four-table e-commerce database to answer 52 real business questions. It shows how SQL turns raw order data into KPIs, rankings, trends and customer insights.

## Dataset

| Table | Rows | Description |
|---|---|---|
| `customers` | 90 | Customer name, city, gender, signup date |
| `products` | 38 | Product name, category, unit price |
| `orders` | 2,000 | Order date and status (Delivered, Cancelled, Pending) |
| `order_items` | 4,967 | Products, quantity and price for each order |

- 12 cities, 7 product categories
- Orders from June 2024 to July 2026

**Relationships:** `customers` 1 to many `orders` 1 to many `order_items` many to 1 `products`.

## Analysis Areas

| # | Area | Questions | Example |
|---|---|---|---|
| 1 | Sales Overview | 6 | Total revenue, orders, customers, average order value |
| 2 | Product Performance | 7 | Top 5 and top 10 products, revenue contribution % |
| 3 | Category Performance | 5 | Best and worst category, fastest-growing category |
| 4 | Customer Value | 7 | Top customers, ranking, lifetime value (LTV) |
| 5 | Customer Behavior | 5 | Repeat buyers, never ordered, inactive for 90 days |
| 6 | Revenue Trends | 6 | Month-over-month growth, running total, daily trend |
| 7 | Geography & Orders | 6 | Top cities, products bought together, cancellation % |
| 8 | Order Gap Analysis | 4 | Previous and next order, days between orders |
| 9 | Retention & Churn | 6 | New vs returning, churn rate, RFM analysis |

## SQL Concepts Used

Joins, subqueries, CTEs, window functions (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`, running totals), aggregations, `CASE` statements, date functions, and RFM segmentation.

## How to Run

1. Clone the repository:
   ```bash
   git clone https://github.com/RUDRAPRAKASHDAS/ECommerce-SQL-Analysis.git
   ```
2. Open your SQL client (MySQL Workbench, SQL Server Management Studio, pgAdmin or similar).
3. Run `data/ecommerce_dataset.sql`. It creates the database, the four tables and inserts all the data.
4. Run the queries from the `queries/` folder.

> The script begins with `CREATE DATABASE E_Commerce_Project; USE E_Commerce_Project;`. On PostgreSQL, remove the `USE` line and connect to the database instead.

## Repository Structure

```
ECommerce-SQL-Analysis/
├── data/
│   └── ecommerce_dataset.sql
├── queries/
│   └── (52 business-question queries)
├── presentation/
│   └── ECommerce_SQL_Project.pptx
├── README.md
└── .gitignore
```

## Key Skills Demonstrated

SQL, data analysis, KPI development, customer analytics, cohort and retention analysis, RFM segmentation.

## Contact

Rudra Prakash Das | rudraprakash1405@gmail.com | Pune, India
