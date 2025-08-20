# Data Folder

## Required Files:
- `buyer_currency.csv` - Buyer master data
- `invoice_raised.csv` - Shipping and invoicing records  
- `transport_bill.csv` - AWB and transport documentation
- `payment_received.csv` - Payment transactions
- `po_receive.csv` - Purchase order details (in enquiry schema)
- `inquery.csv` - Order inquiry and product data
- `split_qty.csv` - Split order management
- `order_cancel.csv` - Cancelled orders with reasons

## Data Loading:
Use MySQL LOAD DATA INFILE or import via MySQL Workbench.
Ensure proper data types and relationships are maintained.

## Privacy Note:
Anonymize sensitive data (buyer names, invoice numbers, amounts) before uploading to public repositories.
