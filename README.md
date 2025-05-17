# DataAnalytics-Assessment
Cowrywise Data Analytics SQL Assessment

## Pre-Question Explanations:
### Question 1: High-Value Customers with Multiple Products

Objective: Identify customers who have at least one funded savings plan and at least one funded investment plan, then rank them by total deposits.

Approach:
1 Used three CTEs:
	- savings_plans: Counted savings plans (is_regular_savings = 1) per owner_id.

	- investment_plans: Counted investment plans (is_a_fund = 1) per owner_id.

	- deposits: Summed confirmed deposits (transaction_status = 'success') per customer.

2. Joined these CTEs on owner_id and filtered for customers with both savings and investment plans.

3. Ordered by total deposits in descending order.

Outcome: Efficient segmentation of customers for cross-sell opportunities.

### Question 2: Transaction Frequency Analysis

Objective: Categorize customers into:
High Frequency (≥10 transactions/month)

Medium Frequency (3–9)

Low Frequency (≤2)

Approach:

1. CTE customer_monthly_tx: Counted successful transactions per customer per month.

2. CTE avg_tx_per_customer: Calculated average monthly transactions per customer using AVG().

3. CTE frequency_segments: Categorized each customer based on their average using CASE.

4. Final query: Aggregated counts and averages by frequency category and sorted them.

Outcome: Segmentation ready for marketing engagement based on customer activity level.

### Question 3: Account Inactivity Alert

Objective: Identify active savings or investment accounts with no inflow transactions for over 1 year (365 days).

Approach:

1. Filtered transactions to include only inflows (confirmed_amount > 0).

2. Joined plans_plan with savings_savingsaccount on plan_id.

3. Used MAX(transaction_date) to get the last inflow date per plan.

4. Calculated DATEDIFF(CURDATE(), MAX(s.transaction_date)) to get inactivity in days.

5. Applied HAVING clause to filter only those with inactivity > 365 days.

Outcome: A clean list of inactive but active (not deleted) plans to flag for ops review.

### Question 4:Customer Lifetime Value (CLV) Estimation

Objective: Calculate estimated CLV using: CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

Initial Attempt:

1. Used SUM(confirmed_amount) * 0.1% as profit; gave total profit, not average.

2. Calculated COUNT(*) for total_transactions.

Final Fix:

1. Used AVG(confirmed_amount) instead to get avg value per transaction.

2. Applied 0.1% profit margin to compute avg_profit_per_transaction.

3. Used TIMESTAMPDIFF(MONTH, created_on, CURDATE()) for tenure.

4. Computed CLV in outer query using correct formula.

Outcome: Accurate customer-level CLV metric, useful for prioritizing customer value.

## Challenges & Resolutions
1. Confusion Between COUNT() vs SUM() for Total Transactions

	- Challenge: While estimating Customer Lifetime Value (CLV), it was unclear whether total_transactions referred to the count of transactions or the total value of transactions.

	- Resolution:

		- Revisited the CLV formula: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction

		- Since "profit per transaction" depends on value, it made more sense for total_transactions to refer to the count (i.e., how many transactions), and the average profit to reflect the value-based return.

		- Final approach: used COUNT(*) for total transactions and AVG(confirmed_amount) * 0.001 to derive average profit per transaction.

2. Incorrect Use of SUM() in CLV Profit Calculation

	- Challenge: Initially calculated total profit using SUM(confirmed_amount) * 0.001, which led to inflated CLV values.

	- Resolution: Switched to calculating AVG(confirmed_amount) to get profit per transaction. Then applied the 0.1% margin correctly to match the simplified CLV formula.

3. Correct Grouping and Alias Usage

	- Challenge: Encountered Unknown column and not in GROUP BY errors in some intermediate queries due to improper alias references or missing fields in GROUP BY.

	- Resolution: Ensured that every selected column not in an aggregate function was included in the GROUP BY clause. Also reviewed alias scoping between CTEs and outer queries.

4.  Inactivity Alert – Filtering the Right Transactions

	- Challenge: It wasn’t initially clear whether to include all transactions or only inflow transactions when detecting inactivity.

	- Resolution: Clarified that only inflows (i.e., confirmed_amount > 0) should be considered. Added this condition in the JOIN to filter relevant records.
