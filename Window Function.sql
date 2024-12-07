-- Aggregate Window Functions in SQL
-- Session Type Duration:Calculate the average session duration (in seconds) for each session type?
SELECT 
    session_type,
    AVG(session_start - session_end) AS session_duration
FROM
    twitch_sessions
GROUP BY session_type;

/* #output 
 session_type	session_duration
streamer	3672940829200
viewer	2525101752857.62
*/

select distinct session_type,
  avg (session_start-session_end) over(partition by session_type )
  as session_duration
from twitch_sessions;

-- Finding Updated Records
/* We have a table with employees and their salaries, however, some of the records are old and contain outdated
 salary information. Find the current salary of each employee 
assuming that salaries increase each year. Output their id, first name, 
last name, department ID, and current salary. Order your list by employee ID in ascending order. */
SELECT id,
       first_name,
       last_name,
       department_id,
       max(salary)
FROM ms_employee_salary
GROUP BY id,
         first_name,
         last_name,
         department_id;
-- window function
SELECT distinct id,
       first_name,
       last_name,
       department_id,
       max(salary) over(partition by id, first_name,last_name,department_id)
FROM ms_employee_salary;
-- Average Salaries
/* Compare each employee's salary with the average salary of the corresponding department.
Output the department, first name, and salary of employees along with the average salary of that department.
Table: employee*/

select 
	department,
	first_name,
	last_name,
	salary,
	avg(salary) over (partition by department) as avg_salary
from employee;

/* Ranking Window functions in SQL  
   ROW_NUMBER()
    RANK()
    DENSE_RANK()
    PERCENT_RANK()
    NTILE()
    
-- Activity Rank

Q:Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will 
have a rank of 1, and so on. Output the user, total emails, and their activity rank.

•	Order records first by the total emails in descending order.

•	Then, sort users with the same number of emails in alphabetical order by their username.

•	In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails.
Table: google_gmail_emails
*/
SELECT  from_user, 

        COUNT(*) as total_emails 

FROM google_gmail_emails 

GROUP BY from_user

ORDER BY 2 DESC;
-- WF
SELECT  from_user, 

        COUNT(*) as total_emails, 

        ROW_NUMBER() OVER ( ORDER BY count(*) desc, from_user asc)

FROM google_gmail_emails 

GROUP BY from_user;

-- RANK()
SELECT  from_user, 

        COUNT(*) as total_emails, 

        RANK() OVER (ORDER BY count(*) desc)

FROM google_gmail_emails 

GROUP BY from_user;

-- WF
SELECT from_user,

       total_emails

FROM

  (SELECT from_user,

          COUNT(*) AS total_emails,

          RANK() OVER (

                       ORDER BY count(*) DESC) rnk

   FROM google_gmail_emails

   GROUP BY from_user) a

WHERE rnk = 1;

/* Your solution output
from_user	total_emails
32ded68d89443e808	19
ef5fe98c6b9f313075	19
*/
-- DENSE_RANK()
SELECT  from_user, 

        COUNT(*) as total_emails, 

        DENSE_RANK() OVER (ORDER BY count(*) desc)

FROM google_gmail_emails 

GROUP BY from_user;

-- 
SELECT from_user,

       total_emails

FROM

  (SELECT from_user,

          COUNT(*) AS total_emails,

          DENSE_RANK() OVER (

                       ORDER BY count(*) DESC) rnk

   FROM google_gmail_emails

   GROUP BY from_user) a

WHERE rnk <= 2;

-- PERCENT_RANK()
SELECT  from_user, 

        COUNT(*) as total_emails, 

        PERCENT_RANK() OVER (ORDER BY count(*) desc)

FROM google_gmail_emails 

GROUP BY from_user;

-- NTILE()

SELECT  from_user, 

        COUNT(*) as total_emails, 

        NTILE(10) OVER (ORDER BY count(*) desc)

FROM google_gmail_emails 

GROUP BY from_user;

/*Value Window Functions in SQL
    LAG()
    LEAD()
    FIRST_VALUE()
    LAST_VALUE()
    NTH_VALUE()
*/
-- Daily Violation Counts
/* Q: Determine the change in the number of daily violations by calculating the difference between the count of current and previous violations by inspection date.

Output the inspection date and the change in the number of daily violations. Order your results by the earliest inspection date first.
Table: sf_restaurant_health_violations */
-- s1
SELECT inspection_date::DATE,

       COUNT(violation_id)

FROM sf_restaurant_health_violations

GROUP BY 1
-- s2
SELECT inspection_date::DATE,

       COUNT(violation_id),

       LAG(COUNT(violation_id)) OVER(ORDER BY inspection_date::DATE)

FROM sf_restaurant_health_violations

GROUP BY 1

-- We’ll remove two columns from the previous step, as they are not required by the question.

SELECT inspection_date::DATE,

       COUNT(violation_id) - LAG(COUNT(violation_id)) OVER(

                                     ORDER BY inspection_date::DATE) 

     						diff

FROM sf_restaurant_health_violations

GROUP BY 1;

-- LEAD()
SELECT inspection_date::DATE,

       COUNT(violation_id),

       LEAD(COUNT(violation_id)) OVER(

                                     ORDER BY inspection_date::DATE),

       COUNT(violation_id) - LEAD(COUNT(violation_id)) OVER(

                                     ORDER BY inspection_date::DATE) 

     						diff

FROM sf_restaurant_health_violations

GROUP BY 1;

-- FIRST_VALUE()
-- Unique Users Per Client Per Month:Write a query that returns the number of unique users per client per month, Table: fact_events
-- s1
SELECT client_id,

       EXTRACT(month from time_id) as month,

       count(DISTINCT user_id) as users_num

FROM fact_events

GROUP BY 1,2;

-- s2
SELECT client_id,

       EXTRACT(month from time_id) as month,

       count(DISTINCT user_id) as users_num,

       FIRST_VALUE(count(DISTINCT user_id)) OVER(

            PARTITION BY client_id 

            ORDER BY EXTRACT(month from time_id))

FROM fact_events

GROUP BY 1,2;

-- LAST_VALUE()

SELECT client_id,

       EXTRACT(month from time_id) as month,

       count(DISTINCT user_id) as users_num,

       LAST_VALUE(count(DISTINCT user_id)) OVER(

            PARTITION BY client_id)

FROM fact_events

GROUP BY 1,2;

-- NTH_VALUE() : calculated from the number of users in the second available month of data:
SELECT client_id,

       EXTRACT(month from time_id) as month,

       count(DISTINCT user_id) as users_num,

       NTH_VALUE(count(DISTINCT user_id), 2) OVER(

            PARTITION BY client_id)

FROM fact_events

GROUP BY 1,2;

-- Advanced Windowing Syntax in SQL
/* 
Frame Specifications;
EXCLUDE clause;
FILTER clause;
Window chaining
 */
 
 /* Revenue Over Time
 Q: Find the 3-month rolling average of total revenue from purchases given a table with users, their purchase amount, and date purchased.
 Do not include returns which are represented by negative purchase values. 
 Output the year-month (YYYY-MM) and 3-month rolling average of revenue, sorted from earliest month to latest month.

A 3-month rolling average is defined by calculating the average total revenue from all user purchases for the current month and previous two months. 
The first two months will not be a true 3-month rolling average since we are not given data from last year. Assume each month has at least one purchase.
Table: amazon_purchases */

-- s1

SELECT to_char(created_at::date, 'YYYY-MM') AS MONTH,

          sum(purchase_amt) AS monthly_revenue

FROM amazon_purchases

WHERE purchase_amt>0

GROUP BY 1

ORDER BY 1 desc;
-- remove the monthly_revenue column because the question doesn’t require it.
SELECT t.month,

       AVG(t.monthly_revenue) OVER(

                                   ORDER BY t.month ROWS BETWEEN 2 PRECEDING

                                   AND CURRENT ROW) AS avg_revenue

FROM

  (SELECT to_char(created_at::date, 'YYYY-MM') AS MONTH,

          sum(purchase_amt) AS monthly_revenue

   FROM amazon_purchases

   WHERE purchase_amt>0

   GROUP BY to_char(created_at::date, 'YYYY-MM')

   ORDER BY to_char(created_at::date, 'YYYY-MM')) t;
   
-- In the query above, the construction within the OVER() clause of the window function ‘ROWS BETWEEN 2 PRECEDING AND CURRENT ROW’ is called a frame specification

-- EXCLUDE
--  the value for April 2020 would be calculated by taking the mean from the revenues in March 2020 and May 2020.
SELECT t.month,

       monthly_revenue,

       AVG(t.monthly_revenue) OVER(

                                   ORDER BY t.month ROWS BETWEEN 1 PRECEDING 

                                   AND 1 FOLLOWING EXCLUDE CURRENT ROW) 

                                   AS avg_revenue

FROM

  (SELECT to_char(created_at::date, 'YYYY-MM') AS MONTH,

          sum(purchase_amt) AS monthly_revenue

   FROM amazon_purchases

   WHERE purchase_amt>0

   GROUP BY to_char(created_at::date, 'YYYY-MM')

   ORDER BY to_char(created_at::date, 'YYYY-MM')) t;
   
   -- FILTER -- only for months where the revenue has been higher than 25000
   
   SELECT t.month,

       monthly_revenue,

       AVG(t.monthly_revenue) 

FILTER(WHERE monthly_revenue > 25000) 

OVER(ORDER BY t.month ROWS BETWEEN 1 PRECEDING AND 1 

FOLLOWING EXCLUDE CURRENT ROW) AS avg_revenue

FROM

  (SELECT to_char(created_at::date, 'YYYY-MM') AS MONTH,

          sum(purchase_amt) AS monthly_revenue

   FROM amazon_purchases

   WHERE purchase_amt>0

   GROUP BY to_char(created_at::date, 'YYYY-MM')

   ORDER BY to_char(created_at::date, 'YYYY-MM')) t
 
 -- Window Chaining 
/*Q: Monthly Percentage Difference
Given a table of purchases by date, calculate the month-over-month percentage change in revenue. The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year.

The percentage change column will be populated from the 2nd month forward and can be calculated as ((this month's revenue - last month's revenue) / last month's revenue)*100.
Table: sf_transactions */

SELECT to_char(created_at::date, 'YYYY-MM') AS year_month,

  round(((sum(value) - lag(sum(value), 1) OVER (ORDER BY to_char

  (created_at::date, 

  'YYYY-MM'))) / (lag(sum(value), 1) OVER (ORDER BY to_char

  (created_at::date, 'YYYY-MM')))) * 100, 2) AS revenue_diff_pct



FROM sf_transactions

GROUP BY year_month 

ORDER BY year_month ASC;
-- The window can be defined as follows and given an alias ‘w’: WINDOW w AS (ORDER BY to_char(created_at::date, 'YYYY-MM')). 
SELECT to_char(created_at::date, 'YYYY-MM') AS year_month,

       round(((sum(value) - lag(sum(value), 1) OVER w) / 

 (lag(sum(value), 1) OVER w)) * 100, 2) AS revenue_diff_pct



FROM sf_transactions

GROUP BY year_month 

WINDOW w AS (ORDER BY to_char(created_at::date, 'YYYY-MM'))

ORDER BY year_month ASC