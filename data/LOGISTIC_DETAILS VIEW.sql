-- Create a view to consolidate logistic details from multiple tables
--  CREATE VIEW `logistic_details` AS

-- Step 1: Handle split orders and calculate quantities
WITH split_orders AS (
    -- Part 1: Process original (non-split) orders and adjust quantities for split orders
    SELECT 
        po.ORD_NUM, -- Order number from po_receive
        -- Calculate quantity: subtract split quantity if split exists, else use total quantity
        CASE 
            WHEN po.ORD_NUM = sq.ORD_NUM THEN SUM(po.QUANTITY) - sq.SPLIT_ORDER 
            ELSE SUM(po.QUANTITY) 
        END AS QUANTITY,
        MAX(po.DELIVERY_DATE) AS DELIVERY_DATE, -- Latest delivery date for the order
        po.PRICE_PER_PCS AS PRICE, -- Price per piece from po_receive
        i.BuyerId -- Buyer ID from inquery table
    FROM enquiry.po_receive po -- Purchase order details
    JOIN enquiry.inquery i ON i.ORD_NUM = po.ORD_NUM -- Join with inquery to get BuyerId
    LEFT JOIN split_qty sq ON sq.ORD_NUM = po.ORD_NUM -- Join with split_qty for split order details
    LEFT JOIN enquiry.order_cancel oc ON oc.ORD_NUM = po.ORD_NUM -- Join with order_cancel to filter cancelled orders
    WHERE oc.ORD_NUM IS NULL -- Exclude cancelled orders
    AND po.DELIVERY_DATE >= '2023-04-01' -- Filter orders with delivery date on or after April 1, 2023
    GROUP BY po.ORD_NUM, sq.SPLIT_ORDER, po.PRICE_PER_PCS, i.BuyerId -- Group to aggregate quantities

    UNION ALL

    -- Part 2: Process split orders with formatted order numbers
    SELECT 
        -- Create a unique order number for split orders (e.g., ORD_NUM-S(1), ORD_NUM-S(2))
        CONCAT(sq.ORD_NUM, '-S(', 
               COUNT(sq.ORD_NUM) OVER (PARTITION BY sq.ORD_NUM ORDER BY sq.ID), ')') AS ORD_NUM,
        sq.SPLIT_ORDER AS QUANTITY, -- Split order quantity
        po.DELIVERY_DATE, -- Delivery date from po_receive
        po.PRICE_PER_PCS AS PRICE, -- Price per piece
        i.BuyerId -- Buyer ID from inquery
    FROM split_qty sq -- Split order quantities
    JOIN enquiry.inquery i ON i.ORD_NUM = sq.ORD_NUM -- Join with inquery for BuyerId
    JOIN enquiry.po_receive po ON po.ORD_NUM = sq.ORD_NUM -- Join with po_receive for delivery date and price
),

-- Step 2: Combine split orders with invoice data and calculate order quantities
splitting AS (
    SELECT 
        so.ORD_NUM, -- Order number from split_orders
        inv.INVOICE_NO, -- Invoice number from invoice_raised
        -- Calculate order quantity: divide quantity by number of shipments if invoiced, else use original quantity
        IFNULL(ROUND(so.QUANTITY / COUNT(inv.SHIP_DATE) OVER (PARTITION BY inv.ORD_NUM), 2), so.QUANTITY) AS ORDER_QTY,
        inv.SHIP_QTY, -- Shipped quantity from invoice_raised
        so.DELIVERY_DATE, -- Delivery date from split_orders
        inv.SHIP_DATE, -- Shipment date from invoice_raised
        inv.CURRENT_CURRENCY_RATE, -- Currency exchange rate from invoice_raised
        so.PRICE, -- Price per piece from split_orders
        so.BuyerId -- Buyer ID from split_orders
    FROM split_orders so
    LEFT JOIN invoice_raised inv ON inv.ORD_NUM = so.ORD_NUM -- Left join to include orders without invoices
),

-- Step 3: Aggregate payment received for each order and invoice
payment AS (
    SELECT 
        ORD_NUM, -- Order number
        INVOICE_NUMBER, -- Invoice number
        SUM(RECEIVED_AMT) AS PAYMENT_RECEIVED -- Sum of received payment amounts
    FROM payment_received
    GROUP BY ORD_NUM, INVOICE_NUMBER -- Group by order and invoice for total payments
)

-- Final output: Combine all data for logistic details
SELECT 
    s.ORD_NUM, -- Order number
    bc.BUYER_NAME AS BUYER, -- Buyer name from buyer_currency
    s.INVOICE_NO, -- Invoice number
    s.ORDER_QTY, -- Calculated order quantity
    s.SHIP_QTY, -- Shipped quantity
    ROUND(s.PRICE, 2) AS PRICE, -- Rounded price per piece
    ROUND(s.ORDER_QTY * s.PRICE, 2) AS ORDER_VALUE, -- Total order value (quantity * price)
    ROUND(s.SHIP_QTY * s.PRICE, 2) AS SHIP_VALUE, -- Total shipped value (shipped quantity * price)
    -- Use buyer's exchange rate if no shipment, else use invoice's currency rate
    CASE 
        WHEN s.SHIP_QTY IS NULL THEN bc.exhange_rate 
        ELSE s.CURRENT_CURRENCY_RATE 
    END AS CURRENT_CURRENCY_RATE,
    -- Order value in INR (order value * applicable exchange rate)
    ROUND((s.ORDER_QTY * s.PRICE) * 
          (CASE WHEN s.SHIP_QTY IS NULL THEN bc.exhange_rate ELSE s.CURRENT_CURRENCY_RATE END), 2) AS ORDER_VALUE_INR,
    -- Shipped value in INR (shipped value * invoice currency rate)
    ROUND((s.SHIP_QTY * s.PRICE) * s.CURRENT_CURRENCY_RATE, 2) AS SHIP_VALUE_INR,
    pr.PAYMENT_RECEIVED, -- Total payment received
    -- Payment received in INR (payment * invoice currency rate)
    ROUND(pr.PAYMENT_RECEIVED * s.CURRENT_CURRENCY_RATE, 2) AS PAYMENT_RECEIVED_INR,
    s.DELIVERY_DATE, -- Delivery date
    s.SHIP_DATE, -- Shipment date
    bc.BUYER_PAYMENT_TERM_IN_DAYS, -- Buyer's payment terms (in days)
    bc.BUYER_LOCATION, -- Buyer's location
    bc.BUYER_CURRENCY -- Buyer's currency
FROM splitting s
JOIN buyer_currency bc ON bc.ID = s.BuyerId -- Join to get buyer details
LEFT JOIN payment pr ON pr.ORD_NUM = s.ORD_NUM AND pr.INVOICE_NUMBER = s.INVOICE_NO; -- Join to get payment details