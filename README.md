# Apple Product Performance Analytics SQL + POWER BI PROJECT

This project analyzes product sales performance, warranty claims, and store performance using SQL for data extraction and Power BI for data modeling and visualization.
The goal is to help the business identify top-performing products, high-claim categories, store-level performance, and overall revenue insights.

🎯 Project Objective

The main goals of this project:

Analyze sales revenue, quantity sold, and top-performing products

Evaluate warranty claim trends, claim duration

Compare performance across stores, cities, and countries

Build a clean star-schema model for analytics

Create an interactive Power BI dashboard for decision-making.



🛠️ Tools & Technologies

SQL — data extraction & cleaning

Power BI — data modeling & dashboard

Power Query — ETL

DAX — calculated metrics



🧱 Data Model (Star Schema)

Your model follows Star Schema:

Fact Tables

sales — revenue, quantity, sale date

warranty — claims, repair status, claim duration

Dimension Tables

products

category

stores

Date

Calendar

📌 Snowflake only at the category → products relationship, but mainly star schema.

A full explanation is in:
📄 Documentation/Data_Model_Explanation.md


📊 Key Metrics (DAX)

Examples of the DAX measures used:

Total Revenue

Total Quantity Sold

Avg Revenue per Sale

Days to Claim

Warranty Claim Status Buckets

Store Performance Metrics

Full list in:
📄 Documentation/DAX_Measures.md

Power Query — ETL

DAX — calculated metrics



📈 Dashboard Highlights

Your Power BI report includes:

Sales Overview (Revenue, Qty trends)

Top Selling Products

Category-Level Performance

Store Performance Map

Warranty Claims Breakdown

Claim Duration Analysis

Monthly Revenue Trend


📌 Insights Generated

Products with highest revenue and claim issues

Stores generating highest sales

Patterns in warranty claims (fast vs delayed cases)

How product category influences failure rate

Monthly sales seasonality

📧 Contact

If you’d like to collaborate or ask questions:

Your Name
📩 your.email@example.com

🔗 LinkedIn: https://linkedin.com/in/yourprofile
