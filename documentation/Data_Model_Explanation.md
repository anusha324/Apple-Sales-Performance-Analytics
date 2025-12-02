📘 Data Model Explanation

This document explains the data model used in the Apple Product Perfomance Analytics Power BI Project, based on the final schema built in Power BI.

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

Columns:

sale_id

sale_date

product_id

store_id

quantity


🔹 2. warranty (Secondary Fact Table)

Captures warranty claim activity.

Columns:

claim_id

claim_date

sale_id

repair_status


## 3. Dimension Tables
🔹 products (Dimension)

Contains product-level attributes.

Columns:

product_id

product_name

category_id

launch_date

price

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


🔹 Date (Dimension for Warranty)

Used for all time intelligence for warranty.

Columns:

Date

Month Name

Month Number

Year

Year-Month

🔹 Calendar (Dimension for Sles)

A second date table specifically used with the sales fact.

Columns:

Date

Month

Month Name

Year



## 4. Relationships Summary
| From Table | Column      | To Table | Column      | Relationship                            |
| ---------- | ----------- | -------- | ----------- | --------------------------------------- |
| products   | product_id  | sales    | product_id  | 1:*                                     |
| category   | category_id | products | category_id | 1:*                                     |
| stores     | store_id    | sales    | store_id    | 1:*                                     |
| Date       | Date        | warranty | claim_date  | 1:*                                     |
| Calendar   | Date        | sales    | sale_date   | 1:*                                     |
| sales      | sale_id     | warranty | sale_id     | 1:* (one sale can have multiple claims) |


## 5. Why This Schema Was Chosen
✔ Easy to understand

✔ Efficient for Power BI

✔ Supports advanced DAX (YTD, MTD, YoY)

✔ Eliminates circular dependencies (through separate date tables)



## 7. Conclusion

The model is a Star Schema with a Snowflake extension, intentionally designed to deliver:

Fast performance

Clear relationships

Clean DAX

Accurate filtering

Professional BI modeling standards
