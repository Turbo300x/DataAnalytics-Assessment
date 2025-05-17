-- Solution to question 4
USE adashi_staging;
/* generate a CTE named CLV that computes obtains customer id, name, tenure months,
computes total transaction and profit per transaction */
WITH CLV AS (
	SELECT
		u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
		TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months,
		COUNT(*) AS total_transactions,
		ROUND(AVG(s.confirmed_amount) * 0.001, 2) AS avg_profit_per_transaction
	FROM users_customuser u
	JOIN savings_savingsaccount s ON u.id = s.owner_id
    WHERE s.transaction_status = 'success'
	GROUP BY u.id
)
-- generate an outer query to obtain the intended results
SELECT
	customer_id,
	name,
	tenure_months,
	total_transactions,
	ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) AS estimated_clv
FROM CLV
WHERE tenure_months > 0
ORDER BY estimated_clv DESC;