# Data Dictionary

## Core Tables

### buyer_currency
| Column | Description |
|--------|-------------|
| BUYER_NAME | Company name (Zara, H&M, Nike, etc.) |
| BUYER_CURRENCY | Base currency (USD, EUR, GBP) |
| BUYER_PAYMENT_TERM_IN_DAYS | Payment terms from ship date |
| exhange_rate | Default INR conversion rate |

### enquiry.po_receive  
| Column | Description |
|--------|-------------|
| ORD_NUM | Unique order identifier |
| QUANTITY | Ordered quantity |
| PRICE_PER_PCS | Unit price in buyer currency |
| DELIVERY_DATE | Requested delivery date |

### invoice_raised
| Column | Description |
|--------|-------------|
| ORD_NUM | Order reference |
| SHIP_QTY | Actual shipped quantity |
| SHIP_DATE | Ship date from factory |
| CURRENT_CURRENCY_RATE | Exchange rate at ship time |

## Business Rules

1. **7% Tolerance**: Remaining qty ≤7% treated as complete
2. **Thresholds**: Balances ≤$2 or ₹100 treated as zero
3. **Fiscal Year**: April to March cycle
4. **Split Orders**: Handled with suffix notation
5. **Currency**: Real-time rates for shipped, defaults for unshipped
