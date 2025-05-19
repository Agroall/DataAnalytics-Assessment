SELECT 
    p.id AS plan_id, 
    p.owner_id, 
    CASE
        WHEN p.is_regular_savings = 1 THEN 'savings'
        WHEN p.is_a_fund = 1 THEN 'investment'
        ELSE 'unknown'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date, 
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s
  ON p.id = s.plan_id
  AND s.confirmed_amount > 0  -- I only considered inflow transactions greater than 0.
WHERE 
  (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND p.is_deleted = 0
  AND p.is_archived = 0
  -- excluded archived and deleted plans since we were asked to focus on active accounts.
GROUP BY p.id
HAVING DATEDIFF(CURDATE(), MAX(s.transaction_date)) > 365;
