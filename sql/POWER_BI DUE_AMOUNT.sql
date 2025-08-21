-- Create a summary of payment balances by buyer and payment due month
WITH BALANCE AS (
    -- Calculate payment details including balances for each invoice
    SELECT
        LD.BUYER, -- Buyer name from LOGISTIC_DETAILS
        LD.INVOICE_NO, -- Invoice number
        -- Calculate payment due date by adding buyer's payment term to ship date
        DATE_ADD(TW.SHIP_DATE, INTERVAL LD.BUYER_PAYMENT_TERM_IN_DAYS DAY) AS PAYMENT_DUE_DATE,
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
    -- Join with TRANSPORT_BILL to get ship date for due date calculation
    JOIN Order_Details_Responses_Logistic.TRANSPORT_BILL AS TW 
        ON TW.ORD_NUM = LD.ORD_NUM AND TW.INVOICE_NO = LD.INVOICE_NO
    -- Filter for payment due dates on or after April 1, 2023
    WHERE DATE_ADD(TW.SHIP_DATE, INTERVAL LD.BUYER_PAYMENT_TERM_IN_DAYS DAY) >= '2023-04-01'
)
-- Final output: Aggregate data by buyer, payment due month, and financial year
SELECT 
    BUYER, -- Buyer name
    -- Format payment due month as 'MMM-YYYY' (e.g., Apr-2023)
    CONCAT(SUBSTRING(MONTHNAME(PAYMENT_DUE_DATE), 1, 3), '-', YEAR(PAYMENT_DUE_DATE)) AS PAYMENT_DUE_MONTH,
    SUM(SHIP_QTY) AS SHIP_QTY, -- Total shipped quantity
    ROUND(SUM(SHIP_VALUE), 2) AS SHIP_VALUE, -- Total shipped value, rounded to 2 decimals
    ROUND(SUM(SHIP_VALUE_INR), 2) AS SHIP_VALUE_INR, -- Total shipped value in INR, rounded
    IFNULL(ROUND(SUM(PAYMENT_RECEIVED), 2), 0) AS PAYMENT_RECEIVED, -- Total payment received, default to 0 if NULL
    ROUND(SUM(PAYMENT_RECEIVED_INR), 2) AS PAYMENT_RECEIVED_INR, -- Total payment received in INR
    -- Balance: Set to 0 if total balance is <= 2, else sum of balances
    CASE 
        WHEN SUM(BALANCE) <= 2 THEN 0 
        ELSE SUM(BALANCE) 
    END AS BALANCE,
    -- Balance in INR: Set to 0 if total < 100, else rounded sum
    CASE 
        WHEN SUM(BALANCE_INR) < 100 THEN 0
        ELSE ROUND(SUM(BALANCE_INR), 2)
    END AS BALANCE_INR,
    -- Calculate financial year (Apr-Dec: YYYY-YYYY+1, Jan-Mar: YYYY-1-YYYY)
    CASE 
        WHEN MONTH(PAYMENT_DUE_DATE) BETWEEN 4 AND 12 THEN CONCAT(YEAR(PAYMENT_DUE_DATE), '-', YEAR(PAYMENT_DUE_DATE) + 1) 
        ELSE CONCAT(YEAR(PAYMENT_DUE_DATE) - 1, '-', YEAR(PAYMENT_DUE_DATE)) 
    END AS FinYear
FROM BALANCE
-- Group by buyer, payment due month, and financial year for aggregation
GROUP BY 
    BUYER, 
    CONCAT(SUBSTRING(MONTHNAME(PAYMENT_DUE_DATE), 1, 3), '-', YEAR(PAYMENT_DUE_DATE)),
    CASE 
        WHEN MONTH(PAYMENT_DUE_DATE) BETWEEN 4 AND 12 THEN CONCAT(YEAR(PAYMENT_DUE_DATE), '-', YEAR(PAYMENT_DUE_DATE) + 1) 
        ELSE CONCAT(YEAR(PAYMENT_DUE_DATE) - 1, '-', YEAR(PAYMENT_DUE_DATE)) 
    END;