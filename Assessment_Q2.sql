SELECT 
    frequency_category,     
    COUNT(DISTINCT owner_id) AS customer_count, 
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM (
    SELECT 
        owner_id, 
        avg_transactions_per_month, 
    CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
FROM (
    SELECT 
        owner_id, 
        AVG(transaction_count) AS avg_transactions_per_month
FROM (
    SELECT 
        owner_id, 
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month, 
        COUNT(*) AS transaction_count
    FROM savings_savingsaccount
    WHERE transaction_status = 'success'
    GROUP BY owner_id, transaction_month
) AS monthly_transaction
-- First subquery level: Used to count the number of transactions each user made per month.
GROUP BY owner_id
) AS customer_monthly_avg
-- Secon subquery level: Used to calculate the average number of transactions per user per momth.
) AS frequency_grouping_avg
-- Final subquery level: Used to create the frequency categories and estimate the averages per group.
GROUP BY frequency_category;
