CREATE DATABASE IF NOT EXISTS SALES;
USE SALES;

SELECT * FROM SALES.RETAIL LIMIT 1000;
SELECT count(*) FROM sales.retail; -- 404202

SELECT count(*) FROM sales.retail
WHERE CUSTOMERID = ''; -- 103242

SELECT *  FROM SALES.RETAIL LIMIT 10000;
SELECT max(InvoiceDate) FROM SALES.RETAIL; -- mm/dd/yyyy hh:mm

SELECT 
	INVOICEDATE,
	STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE_IN_DATE
FROM RETAIL
LIMIT 1000;


    SELECT 
        InvoiceNo, 
        CUSTOMERID, 
        STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE, 
        ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL AND CUSTOMERID <> ''
    ORDER BY CUSTOMERID;

-- Cohort Analysis/Customer Retention Analysis on Customer Level

WITH CTE1 AS (
    SELECT 
        InvoiceNo, 
        CUSTOMERID, 
        STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE, 
        ABS(ROUND(QUANTITY * UNITPRICE, 2)) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL AND CUSTOMERID <> ''
),
CTE2 AS (
    SELECT 
        InvoiceNo, 
        CUSTOMERID, 
        INVOICEDATE, 
        DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
        DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),
CTE3 AS (
    SELECT 
        CUSTOMERID, 
        FIRST_PURCHASE_MONTH,
        CONCAT(
            'Month_', 
            PERIOD_DIFF(
                EXTRACT(YEAR_MONTH FROM PURCHASE_MONTH),
                EXTRACT(YEAR_MONTH FROM FIRST_PURCHASE_MONTH)
            )
        ) AS COHORT_MONTH
    FROM CTE2
)
SELECT 
    FIRST_PURCHASE_MONTH AS Cohort,
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_0', CUSTOMERID, NULL)) AS "Month_0",
    -- COUNT(DISTINCT CASE WHEN COHORT_MONTH = 'Month_0' THEN CUSTOMERID ELSE NULL END) AS "Month_0",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_1', CUSTOMERID, NULL)) AS "Month_1",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_2', CUSTOMERID, NULL)) AS "Month_2",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_3', CUSTOMERID, NULL)) AS "Month_3",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_4', CUSTOMERID, NULL)) AS "Month_4",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_5', CUSTOMERID, NULL)) AS "Month_5",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_6', CUSTOMERID, NULL)) AS "Month_6",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_7', CUSTOMERID, NULL)) AS "Month_7",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_8', CUSTOMERID, NULL)) AS "Month_8",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_9', CUSTOMERID, NULL)) AS "Month_9",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_10', CUSTOMERID, NULL)) AS "Month_10",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_11', CUSTOMERID, NULL)) AS "Month_11",
    COUNT(DISTINCT IF(COHORT_MONTH = 'Month_12', CUSTOMERID, NULL)) AS "Month_12"
FROM CTE3
GROUP BY FIRST_PURCHASE_MONTH
ORDER BY FIRST_PURCHASE_MONTH;




-- Cohort Analysis on Revenue
WITH CTE1 AS (
    SELECT 
        CUSTOMERID, 
        STR_TO_DATE(INVOICEDATE, '%m/%d/%Y %H:%i') AS INVOICEDATE, 
        ROUND(QUANTITY * UNITPRICE, 0) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL AND CUSTOMERID <> ''
),
CTE2 AS (
    SELECT 
        CUSTOMERID, 
        INVOICEDATE, 
        DATE_FORMAT(INVOICEDATE, '%Y-%m-01') AS PURCHASE_MONTH,
        DATE_FORMAT(MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE), '%Y-%m-01') AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),
CTE3 AS (
    SELECT 
        CUSTOMERID,
        FIRST_PURCHASE_MONTH AS Cohort,
        CONCAT(
            'Month_', 
            PERIOD_DIFF(
                EXTRACT(YEAR_MONTH FROM PURCHASE_MONTH),
                EXTRACT(YEAR_MONTH FROM FIRST_PURCHASE_MONTH)
            )
        ) AS COHORT_MONTH,
        REVENUE
    FROM CTE2
)
SELECT 
    Cohort,
    SUM(CASE WHEN COHORT_MONTH = 'Month_0' THEN REVENUE ELSE 0 END) AS Month_0,
    SUM(CASE WHEN COHORT_MONTH = 'Month_1' THEN REVENUE ELSE 0 END) AS Month_1,
    SUM(CASE WHEN COHORT_MONTH = 'Month_2' THEN REVENUE ELSE 0 END) AS Month_2,
    SUM(CASE WHEN COHORT_MONTH = 'Month_3' THEN REVENUE ELSE 0 END) AS Month_3,
    SUM(CASE WHEN COHORT_MONTH = 'Month_4' THEN REVENUE ELSE 0 END) AS Month_4,
    SUM(CASE WHEN COHORT_MONTH = 'Month_5' THEN REVENUE ELSE 0 END) AS Month_5,
    SUM(CASE WHEN COHORT_MONTH = 'Month_6' THEN REVENUE ELSE 0 END) AS Month_6,
    SUM(CASE WHEN COHORT_MONTH = 'Month_7' THEN REVENUE ELSE 0 END) AS Month_7,
    SUM(CASE WHEN COHORT_MONTH = 'Month_8' THEN REVENUE ELSE 0 END) AS Month_8,
    SUM(CASE WHEN COHORT_MONTH = 'Month_9' THEN REVENUE ELSE 0 END) AS Month_9,
    SUM(CASE WHEN COHORT_MONTH = 'Month_10' THEN REVENUE ELSE 0 END) AS Month_10,
    SUM(CASE WHEN COHORT_MONTH = 'Month_11' THEN REVENUE ELSE 0 END) AS Month_11,
    SUM(CASE WHEN COHORT_MONTH = 'Month_12' THEN REVENUE ELSE 0 END) AS Month_12
FROM CTE3
GROUP BY Cohort
ORDER BY Cohort;



