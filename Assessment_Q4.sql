WITH Tenure AS (
    SELECT 
        first_name, 
        last_name, id AS owner_id, 
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months
    FROM users_customuser
    HAVING tenure_months > 0 -- omitted zeroes to avoid calculation errors down the line
),
-- Used CTE to estimate the account tenure
Inflow AS (
    SELECT 
        owner_id, 
        ROUND(SUM(confirmed_amount) * 0.001, 2) AS total_inflow, 
        COUNT(*) AS inflow  
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
-- Estimated total inflow transaction
Outflow AS (
    SELECT 
        owner_id, 
        ROUND(SUM(amount_withdrawn) * 0.001, 2) AS total_outflow, 
        COUNT(*) AS outflow
    FROM withdrawals_withdrawal
    WHERE amount_withdrawn > 0
    GROUP BY owner_id
)
-- I added the withdrawls because though it was not explicitly listed in the question,
-- its is a type of transaction and the question asked for total transaction not just inflow.
SELECT 
    t.owner_id AS customer_id,
    CONCAT(COALESCE(t.first_name, ''), ' ', COALESCE(t.last_name, '')) AS name, -- combined the first and last name fields to get the joint name field.
    -- Used COALESCE to catch edgecases where either first_name or last_name is NULL
    t.tenure_months,
    COALESCE(i.inflow, 0) + COALESCE(o.outflow, 0) AS total_transactions, 
    ROUND(((COALESCE(i.inflow, 0) + COALESCE(o.outflow, 0)) / t.tenure_months) * 12 * ROUND((i.total_inflow + o.total_outflow) / (i.inflow + o.outflow)), 2) AS estimated_clv
-- (COALESCE(i.inflow, 0) + COALESCE(o.outflow, 0)) = total transactions
-- (i.total_inflow + o.total_outflow) / (i.inflow + o.outflow)) = weighted average profit per transaction
FROM Tenure t
LEFT JOIN Inflow i ON t.owner_id = i.owner_id
LEFT JOIN Outflow o ON t.owner_id = o.owner_id
ORDER BY estimated_clv DESC;
