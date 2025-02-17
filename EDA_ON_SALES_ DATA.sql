-- 1.Total Sales by Category:
SELECT 
    CATEGORY, SUM(QUANTITY * AMOUNT) AS SALES
FROM
    ORDER_DETAILS AS OD
        JOIN
    CATEGORY C ON OD.CATEGORY_ID = C.CATEGORY_ID
GROUP BY 1
ORDER BY 2 DESC;

-- 2. Monthly Sales Trends:

SELECT 
 DATE_FORMAT((STR_TO_DATE(ORDER_DATE, '%Y-%m-%d')),'%Y-%m')AS MONTH, SUM(OD.QUANTITY * OD.AMOUNT) AS SALES
FROM
    ORDER_DETAILS AS OD
      LEFT JOIN
    ORDERS O ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY 1
ORDER BY 2 DESC;

-- 3. Find the top 5 users who have spent the most amount of money.

SELECT 
    NAME, SUM(AMOUNT*QUANTITY) AS SPENT_MONEY
FROM
    USERS AS U
        LEFT JOIN
    ORDERS AS O ON U.USER_ID = O.USER_ID
        LEFT JOIN
    ORDER_DETAILS AS OD ON O.ORDER_ID = OD.ORDER_ID
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 5;
    
 --  4. Calculate the monthly revenue for the year 2019
  SELECT 
   MONTH(STR_TO_DATE(ORDER_DATE, '%Y-%m-%d')) AS MONTH,
    SUM(OD.AMOUNT) AS SALES
FROM
    ORDER_DETAILS AS OD
        LEFT JOIN
    ORDERS O ON O.ORDER_ID = OD.ORDER_ID
    WHERE YEAR( STR_TO_DATE(ORDER_DATE, '%Y-%m-%d')) = 2019
  GROUP BY 1
  ORDER BY 1 ASC;
  
  -- 5. Identify the category with the highest average profit per order
SELECT 
CATEGORY,TOTAL_PROFIT,TOTAL_ORDERS,ROUND(AVG(TOTAL_PROFIT/TOTAL_ORDERS),2) AS AVG_PROFIT_PER_ORDER 
FROM
(SELECT 
  CATEGORY, SUM(PROFIT) AS TOTAL_PROFIT, SUM(QUANTITY) AS TOTAL_ORDERS
FROM
    ORDER_DETAILS AS OD
        LEFT JOIN
    ORDERS O ON O.ORDER_ID = OD.ORDER_ID
        LEFT JOIN
    CATEGORY C ON C.CATEGORY_ID = OD.CATEGORY_ID
 GROUP BY CATEGORY) z
 GROUP BY 1;
 
 -- HIGHEST AVG_PROFIT CATEGORY
 
 SELECT
 CATEGORY, ROUND(AVG(PROFIT),2) AS AVERAGE_PROFIT
 FROM
    ORDER_DETAILS AS OD
        LEFT JOIN
    CATEGORY C ON C.CATEGORY_ID = OD.CATEGORY_ID
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1;
    
 -- 6. Find the user who has placed orders in the most number of different categories.  
 
SELECT 
    U.NAME, COUNT(DISTINCT C.CATEGORY_ID)
FROM
    ORDERS AS O
        LEFT JOIN
    ORDER_DETAILS AS OD ON O.ORDER_ID = OD.ORDER_ID
        LEFT JOIN
    CATEGORY AS C ON OD.CATEGORY_ID = C.CATEGORY_ID
        LEFT JOIN
    USERS AS U ON O.USER_ID = U.USER_ID
	GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
 
-- 7. Calculate the total profit for each user and categorize them into 'High', 'Medium', and 'Low' profit groups.    

 
SELECT 
   U.NAME, SUM(PROFIT) AS TOTAL_PROFIT,
   CASE 
   WHEN SUM(PROFIT)> 800 THEN 'HIGH'
   WHEN SUM(PROFIT) BETWEEN 400 AND 800 THEN 'MEDIUM'
   WHEN SUM(PROFIT) BETWEEN 0 AND 400 THEN 'LOW'
   ELSE 'LOSS'
   END AS PROFIT_GROUP
FROM
    ORDERS AS O
        LEFT JOIN
    ORDER_DETAILS AS OD ON O.ORDER_ID = OD.ORDER_ID
        LEFT JOIN
    CATEGORY AS C ON OD.CATEGORY_ID = C.CATEGORY_ID
        LEFT JOIN
    USERS AS U ON O.USER_ID = U.USER_ID
    GROUP BY 1;
    
-- 8. Find the top 3 cities with the highest average order amount

SELECT 
    CITY, ROUND(AVG(OD.AMOUNT), 2) AS AVERAGE_ORDER_AMOUNT
FROM
    USERS AS U
        LEFT JOIN
    ORDERS AS O ON U.USER_ID = O.USER_ID
        LEFT JOIN
    ORDER_DETAILS AS OD ON OD.ORDER_ID = O.ORDER_ID
GROUP BY CITY
ORDER BY 2 DESC
LIMIT 3;