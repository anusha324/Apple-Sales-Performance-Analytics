📘 Data Model Explanation

This document explains the data model used in the Apple Sales & Warranty Analytics Power BI Project, based on the final schema built in Power BI.

## 1. Overview of the Data Model

The data model follows a Star Schema, with two fact tables (sales and warranty) surrounded by multiple dimension tables such as products, category, stores, and two date dimensions.

There is one snowflake-style extension from the products table to the category table.

This approach provides:

Faster performance

Cleaner DAX measures

Easier filtering

Better scalability

## 2. Fact Tables
🔹 1. sales (Primary Fact Table)

Stores transactional sales information.
Important Columns:

sale_id

sale_date

product_id

store_id

quantity

price

revenue (calculated)

This table answers:

How much was sold?

When?

Which product?

Which store?

🔹 2. warranty (Secondary Fact Table)

Captures warranty claim activity.

Columns:

claim_id

claim_date

sale_id

repair_status

ClaimWarrantyStatus

DaysToClaim

This table allows post-sale analytics:

Pending vs completed claims

Warranty performance by product

Warranty performance by store

warranty connects to:

sales through sale_id

Calendar through claim_date

## 3. Dimension Tables
🔹 products (Dimension)

Contains product-level attributes.

Columns:

product_id

product_name

category_id

launch_date

price

Year

Month Name

This supports:

Product-level revenue

Launch-year comparisons

Category-level grouping

🔹 category (Dimension)

Contains product category information.

Columns:

category_id

category_name

This is part of a snowflake extension from the products table.

🔹 stores (Dimension)

Holds store and geographic attributes.

Columns:

store_id

store_name

city

country

Used for:

Store comparison

City and country insights

🔹 Date (Dimension for Sales)

Used for all time intelligence on the sales table.

Columns:

Date

Month Name

Month Number

Year

Year-Month

🔹 Calendar (Dimension for Warranty Claims)

A second date table specifically used with the warranty fact.

Columns:

Date

Month

Month Name

Year

This separation avoids circular relationships between sales and warranty timelines.

## 4. Relationships Summary
From Table	Column	To Table	Column	Relationship
products	product_id	sales	product_id	1:*
category	category_id	products	category_id	1:*
stores	store_id	sales	store_id	1:*
Date	Date	sales	sale_date	1:*
Calendar	Date	warranty	claim_date	1:*
sales	sale_id	warranty	sale_id	1:* (one sale can have multiple claims)

Relationship directions were set to maintain clean filter flow and avoid ambiguity.

## 5. Why This Schema Was Chosen
✔ Easy to understand
✔ Efficient for Power BI
✔ Supports advanced DAX (YTD, MTD, YoY)
✔ Eliminates circular dependencies (through separate date tables)
✔ Enables scalable insights across multiple business areas:

Sales

Warranty

Geographic performance

Product & category trends

## 6. Data Flow Explanation

sales fact receives filters from:

products → category

stores

Date

warranty fact receives filters from:

Calendar

sales (via sale_id)

products is connected to category, enabling category-level segmentation.

This creates a full 360° analytics ecosystem:
Product → Category → Store → Date → Sales → Warranty

## 7. Conclusion

The model is a Star Schema with a Snowflake extension, intentionally designed to deliver:

Fast performance

Clear relationships

Clean DAX

Accurate filtering

Professional BI modeling standards
