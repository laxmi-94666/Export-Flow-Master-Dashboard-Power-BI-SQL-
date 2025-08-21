
# SQL Folder README

## 📁 Files in this folder
- 01_create_schema.sql
- 03_logistic_details_view.sql
- 04_powerbi_procedures.sql
- 05_due_amount_query.sql
- 06_awb_pending_query.sql

## 📚 What each file does

### 01_create_schema.sql
Creates required schemas and core tables:
- buyer_currency, invoice_raised, transport_bill, payment_received, split_qty
- enquiry.po_receive, enquiry.inquery, enquiry.order_cancel
- Adds useful indexes on common joins/filters (ORD_NUM, INVOICE_NO, SHIP_DATE).

### 03_logistic_details_view.sql
Builds the central semantic view: logistic_details.

**Key logic:**
- **Split handling:**
  - Original branch = SUM(PO qty) minus SPLIT_ORDER (avoids double count)
  - Split branch emits distinct rows as ORD_NUM-S(n)
- Invoice alignment to orders/shipments
- Payments joined at (ORD_NUM, INVOICE_NUMBER)
- **FX policy:** shipped → CURRENT_CURRENCY_RATE; unshipped → buyer exhange_rate
- Returns base currency + INR values with delivery/ship dates, buyer terms, location, currency.

### 04_powerbi_procedures.sql
- **POWERBI_ORDERS()**
  - Buyer × Month (fiscal Apr–Mar)
  - 7% tolerance to zero-out tiny remainders
  - Outputs: ORDER_QTY, ORDER_VALUE_INR, REMAINING_QTY, REMAINING_VALUE_INR, FinYear
- **POWERBI_SHIPPED()**
  - Buyer × Ship Month (fiscal)
  - Outputs: SHIP_QTY, SHIP_VALUE_INR, FinYear

### 05_due_amount_query.sql
Receivables by buyer and due month for BI.
- PAYMENT_DUE_DATE = SHIP_DATE + BUYER_PAYMENT_TERM_IN_DAYS (via transport_bill).
- Returns: balances (base + INR), payment received (base + INR), FinYear.

### 06_awb_pending_query.sql
Dock-hold items (factory shipped but no AWB).
- LEFT JOIN transport_bill and filter where bill is missing.
- Returns balances by buyer and ship month with FinYear.

## ▶️ Execution order
1. 01_create_schema.sql
2. 03_logistic_details_view.sql
3. 04_powerbi_procedures.sql
4. Use 05 and 06 directly as custom queries in the BI tool

## 🧭 Modeling notes
- Fiscal year everywhere: April → March
- **Split handling prevents double count:**
  - Original branch: original − SPLIT_ORDER
  - Split branch: emits ORD_NUM-S(n) rows
- ORDER_QTY distribution across multiple shipments: equal split by shipment count
- To switch to proportional split, base it on SHIP_QTY ratios
- **FX policy:**
  - Shipped lines → shipment-time rate (CURRENT_CURRENCY_RATE)
  - Unshipped lines → buyer default exhange_rate

## 🔌 Power BI integration
- **Orders fact:**
  - CALL order_details_responses_logistic.POWERBI_ORDERS();
- **Shipped fact:**
  - CALL order_details_responses_logistic.POWERBI_SHIPPED();
- **Due Amount:**
  - Paste 05_due_amount_query.sql as a custom query
- **AWB Pending:**
  - Paste 06_awb_pending_query.sql as a custom query

## 🚀 Performance tips
- Ensure indexes on ORD_NUM, INVOICE_NO, SHIP_DATE
- Keep business rules centralized in the view and procedures
- For large ranges, consider pre-aggregations/materialized summaries

## 🛠️ Troubleshooting
- **Duplicates?** Check split logic: original minus SPLIT_ORDER + split ORD_NUM-S(n)
- **Missing rows?** Verify joins on (ORD_NUM, INVOICE_NO)
