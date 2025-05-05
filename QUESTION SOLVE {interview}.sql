-- Here are some challenging SQL interview questions:
/*
1. Write a query to calculate the median salary of employees in a table.

2. Identify products that were sold in all regions.

3. Retrieve the name of the manager who supervises the most employees.

4. Write a query to group employees by age ranges (e.g., 20–30, 31–40) and count the number of employees in each group.

5. Display the cumulative percentage of total sales for each product.

6. Write a query to retrieve the first order placed by each customer.

7. Identify employees who have never received a performance review.

8. Find the most common value (mode) in a specific column.

9. Display all months where sales exceeded the average monthly sales.

10. Write a query to identify the employee(s) whose salary is closest to the average salary of the company.
*/
-- Answers:

-- Solution 1

SELECT AVG(salary) AS median_salary 
FROM ( 
SELECT salary 
FROM employees 
ORDER BY salary 
LIMIT 2 - (SELECT COUNT(*) FROM employees) % 2 
OFFSET (SELECT (COUNT(*) - 1) / 2 FROM employees) 
) subquery; 

-- Solution 2

SELECT product_id 
FROM sales 
GROUP BY product_id 
HAVING COUNT(DISTINCT region_id) = (SELECT COUNT(*) FROM regions); 

-- Solution 3

SELECT manager_id, COUNT(*) AS num_employees 
FROM employees 
GROUP BY manager_id 
ORDER BY num_employees DESC 
LIMIT 1; 

-- Solution 4

SELECT CASE 
WHEN age BETWEEN 20 AND 30 THEN '20-30' 
WHEN age BETWEEN 31 AND 40 THEN '31-40' 
WHEN age BETWEEN 41 AND 50 THEN '41-50' 
ELSE '50+' 
END AS age_range, 
COUNT(*) AS num_employees 
FROM employees 
GROUP BY age_range; 

-- Solution 5

SELECT product_id, 
SUM(sales) AS product_sales, 
SUM(SUM(sales)) OVER (ORDER BY SUM(sales) DESC) * 100.0 / SUM(SUM(sales)) OVER () AS cumulative_percentage 
FROM sales_table 
GROUP BY product_id; 

-- Solution 6

SELECT customer_id, MIN(order_date) AS first_order_date 
FROM orders 
GROUP BY customer_id; 

-- Solution 7

SELECT * 
FROM employees 
WHERE employee_id NOT IN (SELECT employee_id FROM performance_reviews); 

-- Solution 8

SELECT column_name, COUNT(*) AS frequency 
FROM table_name 
GROUP BY column_name 
ORDER BY frequency DESC 
LIMIT 1; 

-- Solution 9

SELECT month, SUM(sales) AS monthly_sales 
FROM sales 
GROUP BY month 
HAVING monthly_sales > (SELECT AVG(SUM(sales)) FROM sales GROUP BY month); 

-- Solution 10

SELECT employee_id, salary 
FROM employees 
ORDER BY ABS(salary - (SELECT AVG(salary) FROM employees)) ASC 
LIMIT 1; 



