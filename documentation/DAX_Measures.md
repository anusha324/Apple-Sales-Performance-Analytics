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


