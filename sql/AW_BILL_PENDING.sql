
-- Create a summary of payment balances by buyer and shipment month for orders without transport bills
WITH BALANCE AS (
    -- Calculate payment details including balances for each invoice
    SELECT
        LD.BUYER, -- Buyer name from LOGISTIC_DETAILS
        LD.INVOICE_NO, -- Invoice number
        LD.SHIP_DATE, -- Shipment date from LOGISTIC_DETAILS
        LD.SHIP_QTY, -- Shipped quantity
        LD.PRICE, -- Price per piece
        LD.SHIP_VALUE, -- Total shipped value (SHIP_QTY * PRICE)
        LD.SHIP_VALUE_INR, -- Shipped value in INR (converted using currency rate)
        IFNULL(LD.PAYMENT_RECEIVED, 0) AS PAYMENT_RECEIVED, -- Payment received, default to 0 if NULL
        LD.SHIP_VALUE - IFNULL(LD.PAYMENT_RECEIVED, 0) AS BALANCE, -- Balance = shipped value - payment received
        LD.CURRENT_CURRENCY_RATE, -- Exchange rate for currency conversion
        IFNULL(LD.PAYMENT_RECEIVED_INR, 0) AS PAYMENT_RECEIVED_INR, -- Payment received in INR, default to 0 if NULL
        -- Balance in INR = shipped value in INR - payment received in INR, rounded to 2 decimals
        ROUND(LD.SHIP_VALUE_INR - IFNULL(LD.PAYMENT_RECEIVED_INR, 0), 2) AS BALANCE_INR
    FROM Order_Details_Responses_Logistic.LOGISTIC_DETAILS AS LD
    -- Left join with TRANSPORT_BILL to identify orders without a matching transport bill
    LEFT JOIN Order_Details_Responses_Logistic.TRANSPORT_BILL AS TW 
        ON TW.ORD_NUM = LD.ORD_NUM AND TW.INVOICE_NO = LD.INVOICE_NO
    -- Filter for shipments on or after April 1, 2023, and where no transport bill exists
    WHERE LD.SHIP_DATE >= '2023-04-01' AND TW.ORD_NUM IS NULL
)
-- Final output: Aggregate data by buyer, shipment month, and financial year
SELECT 
    BUYER, -- Buyer name
    -- Format shipment month as 'MMM-YYYY' (e.g., Apr-2023)
    CONCAT(SUBSTRING(MONTHNAME(SHIP_DATE), 1, 3), '-', YEAR(SHIP_DATE)) AS PAYMENT_DUE_MONTH,
    SUM(SHIP_QTY) AS SHIP_QTY, -- Total shipped quantity
    ROUND(SUM(SHIP_VALUE), 2) AS SHIP_VALUE, -- Total shipped value, rounded to 2 decimals
    ROUND(SUM(SHIP_VALUE_INR), 2) AS SHIP_VALUE_INR, -- Total shipped value in INR, rounded
    IFNULL(ROUND(SUM(PAYMENT_RECEIVED), 2), 0) AS PAYMENT_RECEIVED, -- Total payment received, default to 0 if NULL
    ROUND(SUM(PAYMENT_RECEIVED_INR), 2) AS PAYMENT_RECEIVED_INR, -- Total payment received in INR
    -- Balance: Set to 0 if total balance is <= 2, else sum of balances, rounded to 2 decimals
    ROUND(CASE 
        WHEN SUM(BALANCE) <= 2 THEN 0 
        ELSE SUM(BALANCE) 
    END, 2) AS BALANCE,
    -- Balance in INR: Set to 0 if total < 100, else rounded sum
    ROUND(CASE 
        WHEN SUM(BALANCE_INR) < 100 THEN 0
        ELSE SUM(BALANCE_INR)
    END, 2) AS BALANCE_INR,
    -- Calculate financial year (Apr-Dec: YYYY-YYYY+1, Jan-Mar: YYYY-1-YYYY)
    CASE 
        WHEN MONTH(SHIP_DATE) BETWEEN 4 AND 12 THEN CONCAT(YEAR(SHIP_DATE), '-', YEAR(SHIP_DATE) + 1) 
        ELSE CONCAT(YEAR(SHIP_DATE) - 1, '-', YEAR(SHIP_DATE)) 
    END AS FinYear
FROM BALANCE
-- Group by buyer, shipment month, and financial year for aggregation
GROUP BY 
    BUYER, 
    CONCAT(SUBSTRING(MONTHNAME(SHIP_DATE), 1, 3), '-', YEAR(SHIP_DATE)),
    CASE 
        WHEN MONTH(SHIP_DATE) BETWEEN 4 AND 12 THEN CONCAT(YEAR(SHIP_DATE), '-', YEAR(SHIP_DATE) + 1) 
        ELSE CONCAT(YEAR(SHIP_DATE) - 1, '-', YEAR(SHIP_DATE)) 
    END;