-- Solution to question 3
USE adashi_staging;
SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(DATE(s.transaction_date)) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
JOIN savings_savingsaccount s ON p.id = s.plan_id AND s.confirmed_amount > 0
WHERE p.is_deleted = 0
GROUP BY p.id, p.owner_id, type
HAVING MAX(s.transaction_date) IS NOT NULL
   AND MAX(s.transaction_date) < DATE_SUB(CURDATE(), INTERVAL 365 DAY);