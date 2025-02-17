-- Q1: Write an SQL query to find the top 5 cities with the highest number of mobile subscribers.
/*
Table: customer_data

    customer_id (INT)
    city (VARCHAR)
    subscription_status (VARCHAR, values: 'Active', 'Inactive')
    */
    
Select city , count(customer_id) as total_subscriber
from customer_data
where subscription_status ='Active';
group by city
order by 2 desc
limit 5;

/*
Q2: Retrieve the total revenue generated in the last 3 months from the billing table.

Table: billing

    customer_id (INT)
    amount_paid (DECIMAL)
    payment_date (DATE)
    
*/

select sum(amount_paid) as revenue
from billing
where payment_date >= DATE_SUB(curdate(),Interval 3 month);

/*
Q3: Identify customers who have been inactive for the last 6 months.

Table: customer_usage

    customer_id (INT)
    last_active_date (DATE)
    */
    
  select customer_id
  from customer_usage
  where last_active_date <= Date_sub(Curdate(),interval 6 month);
  
-- Find the total revenue generated per city for the last 3 months.

SELECT city, SUM(total_bill) AS total_revenue
FROM billing_data
WHERE billing_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY city
ORDER BY total_revenue DESC;

-- Find cities where total revenue is above ৳1,000,000 in the last 3 months.

SELECT city, SUM(total_bill) AS total_revenue
FROM billing_data
WHERE billing_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY city
HAVING total_revenue > 1000000;


-- Find customers along with their last recharge amount.

SELECT c.customer_id, c.customer_name, r.amount
FROM customers c
JOIN recharges r ON c.customer_id = r.customer_id
WHERE r.recharge_date = (SELECT MAX(recharge_date) FROM recharges WHERE customer_id = c.customer_id);

-- Retrieve customers who have made at least one call in the last month
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN call_logs cl ON c.customer_id = cl.customer_id
WHERE cl.call_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Find customers who have spent more than the average monthly bill amount.
SELECT customer_id, customer_name, total_bill
FROM billing_data
WHERE total_bill > (SELECT AVG(total_bill) FROM billing_data);

--  Find customers who have made the highest number of calls.
SELECT customer_id, COUNT(call_id) AS call_count
FROM call_logs
GROUP BY customer_id
HAVING call_count = (SELECT MAX(call_count) FROM (SELECT customer_id, COUNT(call_id) AS call_count FROM call_logs GROUP BY customer_id) AS temp);

-- Find the top 3 customers with the highest total billing amounts.
SELECT customer_id, total_bill,
       RANK() OVER (ORDER BY total_bill DESC) AS rank
FROM billing_data
LIMIT 3;

--  Find the month-over-month change in total revenue.
SELECT billing_month, total_revenue, 
       LAG(total_revenue, 1) OVER (ORDER BY billing_month) AS previous_month_revenue,
       (total_revenue - LAG(total_revenue, 1) OVER (ORDER BY billing_month)) AS revenue_change
FROM (SELECT DATE_FORMAT(billing_date, '%Y-%m') AS billing_month, SUM(total_bill) AS total_revenue 
      FROM billing_data 
      GROUP BY billing_month) AS monthly_revenue;

-- Find the highest-paying customers and their most recent payment details.

WITH RecentPayments AS (
    SELECT customer_id, MAX(payment_date) AS last_payment_date
    FROM payments
    GROUP BY customer_id
)
SELECT c.customer_id, c.customer_name, p.amount, p.payment_date
FROM customers c
JOIN payments p ON c.customer_id = p.customer_id
JOIN RecentPayments r ON p.customer_id = r.customer_id AND p.payment_date = r.last_payment_date
ORDER BY p.amount DESC;


-- Categorize customers based on their data usage in the last month.
SELECT customer_id, data_usage,
       CASE 
           WHEN data_usage > 50 THEN 'High User'
           WHEN data_usage BETWEEN 20 AND 50 THEN 'Medium User'
           ELSE 'Low User'
       END AS usage_category
FROM data_usage_table
WHERE usage_month = '2024-01';


-- Find the percentage of customers who have not used any service in the last 3 months (churn rate calculation).


SELECT 
    (COUNT(DISTINCT customer_id) / (SELECT COUNT(DISTINCT customer_id) FROM customers)) * 100 AS churn_rate
FROM call_logs
WHERE call_date < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

--  Calculate the average duration of calls per customer.

SELECT customer_id, AVG(call_duration) AS avg_call_duration
FROM call_logs
GROUP BY customer_id;
