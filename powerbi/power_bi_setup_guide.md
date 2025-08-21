# Power BI Setup Guide

## Quick Start
1. Connect to MySQL database
2. Import tables using custom SQL
3. Set up relationships  
4. Configure fiscal calendar
5. Add your dashboard screenshots to powerbi/screenshots/

## Custom SQL Queries

**ORDER table:**
```sql
CALL order_details_responses_logistic.POWERBI_ORDERS();
```

**SHIP table:**  
```sql
CALL order_details_responses_logistic.POWERBI_SHIPPED();
```

**DUE_PAYMENT table:**
Use sql/05_due_amount_query.sql

**AWB_PENDING table:**
Use sql/06_awb_pending_query.sql

## DAX Calendar
```dax
Calendar_Table = 
ADDCOLUMNS(
    GENERATESERIES(1, 12, 1),
    "Month", CHOOSE([Value], "Apr", "May", "Jun", "Jul", "Aug", "Sep", 
                            "Oct", "Nov", "Dec", "Jan", "Feb", "Mar"),
    "FiscalSortOrder", IF([Value] <= 3, [Value] + 9, [Value] - 3)
)
```
