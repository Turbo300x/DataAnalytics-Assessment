-- Solution to question 2
USE adashi_staging;
-- generate a CTE to obtain the count of transactions per month
WITH customer_monthly_tx AS (
    SELECT
        s.owner_id,
        MONTH(s.transaction_date) AS transaction_month,
        COUNT(*) AS monthly_transactions
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'success'
    GROUP BY s.owner_id, MONTH(s.transaction_date)
),
-- generate a CTE referencing the above CTE to obtain the average transaction per month
avg_tx_per_customer AS (
    SELECT
        owner_id,
        ROUND(AVG(monthly_transactions), 1) AS avg_transactions_per_month
    FROM customer_monthly_tx
    GROUP BY owner_id
),
-- generate a CTE referencing the above CTE to segment the average transaction per month
frequency_segments AS (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE 
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_tx_per_customer
)
-- write outter query to obtain the frquency_category, customer count, and avg transactions per month
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM frequency_segments
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');