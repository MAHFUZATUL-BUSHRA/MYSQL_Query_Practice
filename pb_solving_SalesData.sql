-- Important SQL interview question asked in the Data Analyst interview at Google
/*
Question:
You are given the following table SalesData that records the sales performance of employees across different regions and quarters.

SalesData 
----------- 
employee_id (int) 
region (varchar) 
quarter (varchar) 
sales_amount (int) 

Write an SQL query to identify the top-performing employee(s) in each region for each quarter based on their sales_amount.
 If multiple employees have the highest sales in a region for the same quarter, include all of them.

Constraints:

   - The output should include region, quarter, employee_id, and sales_amount.
   - Handle cases where two or more employees might tie for the top sales in a region for a specific quarter.


Solution:

WITH RankedSales AS ( 
   SELECT 
       region, 
       quarter, 
       employee_id, 
       sales_amount, 
       RANK() OVER (PARTITION BY region, quarter ORDER BY sales_amount DESC) AS rank 
   FROM 
       SalesData 
) 
SELECT 
   region, 
   quarter, 
   employee_id, 
   sales_amount 
FROM 
   RankedSales 
WHERE 
   rank = 1; 


What This Tests:

   - Advanced use of RANK() for ranking data within partitions.
   - Ability to handle tied rankings in SQL queries.
   - Understanding of partitioning and ordering in window functions.


Your Turn: Would you be able to solve this during an interview? Let me know your approach in the comments! */

-- Create SalesData table
CREATE TABLE SalesData (
    employee_id INT,
    region VARCHAR(50),
    quarter VARCHAR(10),
    sales_amount INT
);

-- Insert 50 rows into SalesData
INSERT INTO SalesData (employee_id, region, quarter, sales_amount) VALUES
    (101, 'Dhaka', 'Q1', 50000),
    (102, 'Chittagong', 'Q1', 45000),
    (103, 'Khulna', 'Q1', 40000),
    (104, 'Rajshahi', 'Q1', 35000),
    (105, 'Sylhet', 'Q1', 60000),
    (106, 'Dhaka', 'Q2', 52000),
    (107, 'Chittagong', 'Q2', 47000),
    (108, 'Khulna', 'Q2', 42000),
    (109, 'Rajshahi', 'Q2', 37000),
    (110, 'Sylhet', 'Q2', 61000),
    (111, 'Dhaka', 'Q3', 55000),
    (112, 'Chittagong', 'Q3', 48000),
    (113, 'Khulna', 'Q3', 43000),
    (114, 'Rajshahi', 'Q3', 38000),
    (115, 'Sylhet', 'Q3', 62000),
    (116, 'Dhaka', 'Q4', 56000),
    (117, 'Chittagong', 'Q4', 49000),
    (118, 'Khulna', 'Q4', 44000),
    (119, 'Rajshahi', 'Q4', 39000),
    (120, 'Sylhet', 'Q4', 63000),
    (121, 'Dhaka', 'Q1', 57000),
    (122, 'Chittagong', 'Q1', 50000),
    (123, 'Khulna', 'Q1', 45000),
    (124, 'Rajshahi', 'Q1', 40000),
    (125, 'Sylhet', 'Q1', 64000),
    (126, 'Dhaka', 'Q2', 58000),
    (127, 'Chittagong', 'Q2', 51000),
    (128, 'Khulna', 'Q2', 46000),
    (129, 'Rajshahi', 'Q2', 41000),
    (130, 'Sylhet', 'Q2', 65000),
    (131, 'Dhaka', 'Q3', 59000),
    (132, 'Chittagong', 'Q3', 52000),
    (133, 'Khulna', 'Q3', 47000),
    (134, 'Rajshahi', 'Q3', 42000),
    (135, 'Sylhet', 'Q3', 66000),
    (136, 'Dhaka', 'Q4', 60000),
    (137, 'Chittagong', 'Q4', 53000),
    (138, 'Khulna', 'Q4', 48000),
    (139, 'Rajshahi', 'Q4', 43000),
    (140, 'Sylhet', 'Q4', 67000),
    (141, 'Dhaka', 'Q1', 61000),
    (142, 'Chittagong', 'Q1', 54000),
    (143, 'Khulna', 'Q1', 49000),
    (144, 'Rajshahi', 'Q1', 44000),
    (145, 'Sylhet', 'Q1', 68000),
    (146, 'Dhaka', 'Q2', 62000),
    (147, 'Chittagong', 'Q2', 55000),
    (148, 'Khulna', 'Q2', 50000),
    (149, 'Rajshahi', 'Q2', 45000),
    (150, 'Sylhet', 'Q2', 69000);
 
 Select * from salesdata;
 
 select distinct region from salesdata;
 
 select count(distinct employee_id), region, Sum(sales_amount)
 from SalesData
 group by 2;
 
With cte as
(select 
	 employee_id, region , quarter, Sales_amount,
	 rank() over (partition by region,quarter order by sales_amount desc) as rnk
 from salesdata)
 
SELECT 
    employee_id, region, quarter, Sales_amount
FROM
    cte
where rnk=1;
