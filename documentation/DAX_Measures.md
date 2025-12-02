
📐 DAX Measures Documentation

This file documents all DAX measures used in the Apple Product Performance Analytics Dashboard.

## 1. Sales Measures

Total Revenue = SUM(sales[revenue])

Total Quantity = SUM(sales[quantity])

Total No of Sales = DISTINCTCOUNT(sales[sale_id])

Sales YTD = TOTALYTD([Total Revenue], 'Calender'[Date])

Avg Revenue per Sale = DIVIDE([Total Revenue],[Total No of Sales],0)

Sales PY Exact = 
CALCULATE(
    [Total Revenue],
    DATESBETWEEN(
        'Calender'[Date],
        DATE(YEAR(MAX('Calender'[Date]))-1,1,1),
        DATE(YEAR(MAX('Calender'[Date]))-1, MONTH(MAX('Calender'[Date])), DAY(MAX('Calender'[Date])))
    )
)

Quantity YTD = TOTALYTD([Total Quantity], 'Calender'[Date])

Quantity PY Exact = 
CALCULATE(
    [Total Quantity],
    DATESBETWEEN(
        'Calender'[Date],
        DATE(YEAR(MAX('Calender'[Date]))-1,1,1),
        DATE(YEAR(MAX('Calender'[Date]))-1, MONTH(MAX('Calender'[Date])), DAY(MAX('Calender'[Date])))
    )
)

YoY Growth % = 
DIVIDE([Sales YTD] - [Sales PY Exact], [Sales PY Exact])

YoY qty % = DIVIDE([Quantity YTD] - [Quantity PY Exact], [Quantity PY Exact])


## 2. Product Measures

AVG selling price = AVERAGE(products[price])

Top Product = 
VAR T1 =
    TOPN(
        1,
        SUMMARIZE(products, products[product_name], "Rev", [Total Revenue]),
        [Rev],
        DESC
    )
RETURN
MAXX(T1, products[product_name])

Top QTY Product = 
VAR T1 =
    TOPN(
        1,
        SUMMARIZE(products, products[product_name], "Qty", [Total Quantity]),
        [Qty],
        DESC
    )
RETURN
MAXX(T1, products[product_name])


## 3. Stores Measures

Avg qty per Store = 
AVERAGEX(VALUES(sales[store_id]), [Total Quantity])

Avg Revenue per Store = 
AVERAGEX(VALUES(sales[store_id]), [Total Revenue])

Revenue by Store = 
CALCULATE(
    [Total Revenue],
    ALLEXCEPT(stores, stores[store_id])
)

Sales Count = COUNT(sales[sale_id])


## 4. Warranty Measures

Claims Outside Warranty = 
CALCULATE(
    [Total Claims],
    warranty[ClaimWarrantyStatus] = "Outside Warranty"
)

Claims Within Warranty = 
CALCULATE(
    [Total Claims],
    warranty[ClaimWarrantyStatus]= "Within Warranty"
)

Total Claims = DISTINCTCOUNT( warranty[claim_id] )

Claim Rate % = 
DIVIDE([Total Claims], DISTINCTCOUNT(sales[sale_id]), 0)



📐 DAX Columns 


## 1. Warranty 

DaysToClaim = 
IF(
    ISBLANK([claim_date]) || ISBLANK([SaleDate]),
    BLANK(),
    DATEDIFF([SaleDate], [claim_date], DAY)
)

DaysToClaimBucket = 
SWITCH(
    TRUE(),
    ISBLANK([DaysToClaim]), "No Claim Date",
    [DaysToClaim] <= 30, "0-30 days",
    [DaysToClaim] <= 90, "31-90 days",
    [DaysToClaim] <= 180, "91-180 days",
    [DaysToClaim] <= 365, "181-365 days",
    [DaysToClaim] <= 730, "366-730 days",
    ">730 days"
)

ClaimWarrantyStatus = 
IF(
    ISBLANK([claim_date]) || ISBLANK([WarrantyEnd]),
    "No Claim or Missing Data",
    IF([claim_date] <= [WarrantyEnd], "Within Warranty", "Outside Warranty")
)

SaleDate = RELATED(sales[sale_date])

WarrantyEnd = RELATED(sales[WarrantyEndDate])


## 2. Sales

revenue = sales[quantity]*sales[price]

WarrantyEndDate = 
DATEADD( 'sales'[sale_date], 1, YEAR )   



📐 New table


Calender = CALENDAR(FIRSTDATE(sales[sale_date]),LASTDATE(sales[sale_date]))

Date = 
ADDCOLUMNS (
    CALENDAR ( DATE(2024,1,1), DATE(2024,12,31) ),
    "Year", YEAR([Date]),
    "Month Number", MONTH([Date]),
    "Month Name", FORMAT([Date], "MMMM"),
    "Year-Month", FORMAT([Date], "YYYY-MM")
)
