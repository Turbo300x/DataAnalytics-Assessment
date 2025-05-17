-- Solution to question 1
USE adashi_staging;
-- generate a CTE to obtain the count of savings plans with a number = 1
WITH savings_plans AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),
-- generate a CTE to obtain the count of investment plans with a number = 1
investment_plans AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
-- generate a CTE to obtain the total deposits with a succesful transaction status
deposits AS (
    SELECT owner_id, ROUND(SUM(confirmed_amount), 2) AS total_deposits
    FROM savings_savingsaccount
    WHERE transaction_status = 'success'
    GROUP BY owner_id
)
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    sp.savings_count,
    ip.investment_count,
    d.total_deposits
FROM users_customuser u
JOIN savings_plans sp ON u.id = sp.owner_id
JOIN investment_plans ip ON u.id = ip.owner_id
LEFT JOIN deposits d ON u.id = d.owner_id
WHERE sp.savings_count > 0 AND ip.investment_count > 0
ORDER BY d.total_deposits DESC;