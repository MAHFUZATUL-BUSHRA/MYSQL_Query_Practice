-- [medium ]pb solving

WITH RECURSIVE numbers AS (
    SELECT 2 AS num
    UNION ALL
    SELECT num + 1
    FROM numbers
    WHERE num + 1 <= 20
),
primes AS (
    SELECT num
    FROM numbers n
    WHERE NOT EXISTS (
        SELECT 1
        FROM numbers d
        WHERE d.num < n.num AND d.num > 1 AND n.num % d.num = 0
    )
)
SELECT GROUP_CONCAT(num SEPARATOR '&') AS prime_list
FROM primes;


-- Task 1
SELECT E.employee_id, L.bonus
FROM employee_information AS E
LEFT JOIN last_quarter_bonus AS L
ON E.employee_id = L.employee_id
WHERE E.division = 'HR' AND L.bonus >= 5000;

-- Task 2

SELECT 
    T.stock_code
FROM
    price_today AS T
        LEFT JOIN
    price_tomorrow AS T2 ON T.stock_code = T2.stock_code
WHERE
    T2.price > T.price
ORDER BY T.stock_code ASC;
