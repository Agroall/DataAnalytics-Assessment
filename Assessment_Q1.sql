WITH savings AS (
    SELECT 
        owner_id, 
        COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
), 
-- Used CTE to seperately determine the number of funded savings accounts.
investments AS (
    SELECT 
        owner_id, 
        COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
-- Used CTE to seperately determine the number of funded investment accounts.
deposits AS (
    SELECT 
        owner_id, 
        ROUND(SUM(confirmed_amount) / 100, 2) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)
-- Used CTE to seperately sum up the total deposits
SELECT 
    u.id AS owner_id,
    CONCAT(COALESCE(u.first_name, ''), ' ', COALESCE(u.last_name, '')) AS name, -- combined the first and last name fields to get the joint name field.
    -- Used COALESCE to catch edgecases where either first_name or last_name is NULL
    s.savings_count,
    i.investment_count,
    d.total_deposits  
FROM users_customuser AS u
JOIN savings AS s ON u.id = s.owner_id
JOIN investments AS i ON u.id = i.owner_id
LEFT JOIN deposits AS d ON u.id = d.owner_id
ORDER BY total_deposits DESC;
