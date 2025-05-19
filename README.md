# DataAnalytics-Assessment

## Assessment_Q1
 I broke down the problem into smaller, manageable parts using CTEs. This allowed me to isolate and validate each component before combining them.

 I first created two separate CTEs — one to count funded savings plans (is_regular_savings = 1) per customer, and another to count funded investment plans (is_a_fund = 1). 

 I created a third CTE to sum all confirmed deposit amounts for each customer from the savings_savingsaccount table.

 For the final output, I started from the users_customuser table to ensure that the results are based on actual customers. I joined it with the savings and investment CTEs using inner joins, which effectively filters customers who have at least one savings and one investment plan.

 Since first_name and last_name fields can be NULL, I used COALESCE to replace any NULL values with empty strings before concatenation.


 ## Assessment_Q2
For this task, I built the query from the innermost subquery outwards, testing each step along the way.

The innermost subquery calculates the total number of successful transactions each customer made per month. 

Using the monthly counts from the previous step, the next subquery computes the average number of transactions per month for each user. 

Each user’s average monthly transaction count is then categorized into one of the three buckets.

The outermost query groups the data by these frequency categories to count how many distinct customers fall into each group and calculates the average monthly transactions within each category.


## Assessment_Q3
I started by calculating the number of inactive days. Once I had that sorted, I calculated the last transaction date. I commented the seperate queries before moving into the issue with the joins.

I removed the archived and deleted plans as the question was only for active accounts.

Then I joined on plan_id to effectively track activities on both tables.

I added "s.confirmed_amount > 0" to remove zero transactions as they aren't actually deposits.

Spent a few minutes trying to work it into a subquery so I can use where to keep only accounts inactive for a year before I just shifted to using HAVING as it was the optimal choice.


## Assessment_Q4
As with the first two assessments, I created the CTE queries and tested them first. I find it easier to work this was as it allows me to track my results as I build it. 

I started with the tenure query first as it was the most staright forward and non inclusive part of the query. I calculated the tenure in months from the date_joined date until today (CURDATE()) then filtered out customers with zero tenure to avoid division by zero errors later in the CLV calculation.

I had some doubt about add the outflow section as the withdrawals table was not listed in the question but since the task required total transactions, it made sense to include outflows (withdrawals) as part of customer activity. 

I also calculated the profits (total_inflow and total_outflow) in the individual CTEs so I had to use a weighted average to calculate the estimated_clv

I set the confirmed_amount and amount_withdrawn to greater than 0 because zero transactions would have affected my clv calculations by overestimating the outflow and inflow.

Since some customers might not have inflow or outflow transactions, I used COALESCE to replace NULL values with zero to prevent calculation errors.


## Challenges
All the queries were somewhat challenging and required some level of iteration to get them right, but I didn't have any specific challenges. The questions had some edge cases (especially the NULL values) that I only caught because I was checking my results frequently while writing the query.
