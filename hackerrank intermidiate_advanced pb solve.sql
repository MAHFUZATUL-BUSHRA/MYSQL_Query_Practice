-- t1

SELECT 
    co.country_name,
    COUNT(*) AS total_customers,
    ROUND(AVG(i.total_price), 6) AS avg_total_price
FROM 
    country AS co
    INNER JOIN city AS ci ON co.id = ci.country_id
    INNER JOIN customer AS cu ON ci.id = cu.city_id
    INNER JOIN invoice AS i ON cu.id = i.customer_id
GROUP BY 
    co.country_name
HAVING 
    AVG(i.total_price) > (
        SELECT AVG(total_price) FROM invoice
    );
    
-- t2
SELECT 
    CI.city_name, 
    PR.product_name, 
    ROUND(SUM(INV_I.line_total_price), 2) AS tot
FROM 
    city AS CI
    INNER JOIN customer AS CU ON CI.id = CU.city_id
    INNER JOIN invoice AS INV ON CU.id = INV.customer_id
    INNER JOIN invoice_item AS INV_I ON INV.id = INV_I.invoice_id
    INNER JOIN product AS PR ON INV_I.product_id = PR.id
GROUP BY 
    CI.city_name, 
    PR.product_name
ORDER BY 
    tot DESC, 
    CI.city_name, 
    PR.product_name;
-- t3
WITH QuarterVolumes AS (
    SELECT
        C.Algorithm,
        QUARTER(Dt) AS Quarter,
        SUM(Volume) AS V
    FROM
        coins C
        INNER JOIN transactions T ON T.coin_code = C.code
    WHERE
        YEAR(Dt) = 2020
    GROUP BY
        C.Algorithm, QUARTER(Dt)
)

SELECT
    Q1.Algorithm,
    COALESCE(Q1.V, 0) AS Q1_v,
    COALESCE(Q2.V, 0) AS Q2_v,
    COALESCE(Q3.V, 0) AS Q3_v,
    COALESCE(Q4.V, 0) AS Q4_v
FROM
    QuarterVolumes Q1
    LEFT JOIN QuarterVolumes Q2 ON Q1.Algorithm = Q2.Algorithm AND Q2.Quarter = 2
    LEFT JOIN QuarterVolumes Q3 ON Q1.Algorithm = Q3.Algorithm AND Q3.Quarter = 3
    LEFT JOIN QuarterVolumes Q4 ON Q1.Algorithm = Q4.Algorithm AND Q4.Quarter = 4
WHERE
    Q1.Quarter = 1
ORDER BY
    Q1.Algorithm ASC;

-- t4
WITH difference AS (
    SELECT
        *,
        DATEDIFF(minute, LAG(dt) OVER (PARTITION BY sender ORDER BY dt), dt) AS diff_minute,
        ROW_NUMBER() OVER (PARTITION BY sender ORDER BY dt) AS rownumber
    FROM krypto
),
marked AS (
    SELECT *,
           CASE 
               WHEN diff_minute IS NULL OR diff_minute >= 60 THEN 1
               ELSE 0
           END AS new_sequence_flag
    FROM difference
),
grouped_sequences AS (
    SELECT *,
           SUM(new_sequence_flag) OVER (PARTITION BY sender ORDER BY dt ROWS UNBOUNDED PRECEDING) AS sequence_id
    FROM marked
),
aggregated AS (
    SELECT 
        sender,
        MIN(dt) AS sequence_start,
        MAX(dt) AS sequence_end,
        COUNT(*) AS transactions_count,
        SUM(amount) AS transactions_sum
    FROM grouped_sequences
    GROUP BY sender, sequence_id
)
SELECT 
    sender,
    sequence_start,
    sequence_end,
    transactions_count,
    transactions_sum
FROM aggregated
WHERE transactions_sum >= 150
ORDER BY sender, sequence_start, sequence_end;

-- Top Earners Per Department
WITH RankedSalaries AS (
    SELECT
        e.name AS employee_name,
        d.name AS department_name,
        e.salary,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.id
)

SELECT 
    employee_name,
    department_name,
    salary
FROM RankedSalaries
WHERE rn <= 3;

-- Find the average temperature and average humidity for each city over the last 30 days.

-- Identify cities where the temperature trend is increasing (i.e., the average temperature for each day in the last 30 days is greater than the previous day).

WITH TemperatureData AS (
    SELECT
        city_name,
        date,
        temperature,
        humidity,
        AVG(temperature) OVER (PARTITION BY city_name ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS avg_temperature_last_30_days,
        AVG(humidity) OVER (PARTITION BY city_name ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS avg_humidity_last_30_days,
        LAG(temperature) OVER (PARTITION BY city_name ORDER BY date) AS prev_temperature
    FROM weather_data
    WHERE date >= CURDATE() - INTERVAL 30 DAY
)
SELECT 
    city_name,
    avg_temperature_last_30_days,
    avg_humidity_last_30_days,
    CASE 
        WHEN avg_temperature_last_30_days > prev_temperature THEN 'Yes'
        ELSE 'No'
    END AS trend_in_temperature
FROM TemperatureData
GROUP BY city_name, avg_temperature_last_30_days, avg_humidity_last_30_days
ORDER BY city_name;

-- write a query to get the months, monthly max, monthly min, and monthly average temperatures for each of the 6 months of 2020 from a weather table.
SELECT
    MONTH(record_date) AS month,
    ROUND(MAX(CASE WHEN data_type = 'max' THEN data_value END), 0) AS monthly_max_temperature,
    ROUND(MIN(CASE WHEN data_type = 'min' THEN data_value END), 0) AS monthly_min_temperature,
    ROUND(AVG(CASE WHEN data_type = 'avg' THEN data_value END), 0) AS monthly_avg_temperature
FROM
    temperature_records
WHERE
    YEAR(record_date) = 2020
GROUP BY
    MONTH(record_date)
ORDER BY
    month;


-- t5
WITH difference AS (
    SELECT
        *,
        TIMESTAMPDIFF(MINUTE, LAG(dt) OVER (PARTITION BY sender ORDER BY dt), dt) AS diff_minute,  -- Calculate the time difference between consecutive transactions
        ROW_NUMBER() OVER (PARTITION BY sender ORDER BY dt) AS rownumber  -- Assign a row number for each transaction per sender
    FROM transactions
),
sequences AS (
    SELECT 
        sender,
        dt,
        amount,
        diff_minute,
        rownumber,
        SUM(CASE WHEN ABS(diff_minute) < 60 THEN 0 ELSE 1 END) OVER (PARTITION BY sender ORDER BY dt) AS sequence_group  -- Create a new group whenever the time difference is >= 60 minutes
    FROM difference
)
SELECT 
    sender, 
    MIN(dt) AS sequence_start,  -- Start of the sequence (earliest transaction)
    MAX(dt) AS sequence_end,    -- End of the sequence (latest transaction)
    COUNT(*) AS transactions_count,  -- Number of transactions in the sequence
    ROUND(SUM(amount), 6) AS transactions_sum  -- Total amount of the sequence
FROM sequences
GROUP BY sender, sequence_group  -- Group by sender and the sequence group
HAVING SUM(amount) >= 150  -- Filter sequences with total amount >= 150
ORDER BY sender, sequence_start;  -- Order by sender and sequence start time

/*Question:

You are designing a simple vending machine simulation.

Implement a class VendingMachine with the following behavior:

    The machine is initialized with a certain number of items and the price per item.

    Users can attempt to buy a specific number of items with a certain amount of money.

Write a method buy(req_items, money) that:

    Returns "Not enough items in the machine" if the requested quantity exceeds the remaining stock.

    Returns "Not enough coins" if the money provided is less than the total price.

    Otherwise, reduces the number of items in the machine and returns the change (i.e., money - total_price).

📥 Input:

    Number of items in the machine (integer)

    Price per item (integer)

    Multiple calls to buy(req_items, money)

📤 Output:

    A number (change) if the transaction is successful.

    A message if it fails due to lack of items or insufficient money.*/
    
   -- solution 
   
class VendingMachine:
    def __init__(self, num_items, item_price):
        self.numItems = num_items
        self.itemPrice = item_price

    def buy(self, req_items, money):
        total_price = req_items * self.itemPrice

        if req_items > self.numItems:
            return "Not enough items in the machine"

        if money < total_price:
            return "Not enough coins"

        self.numItems -= req_items
        return money - total_price


# Test Cases
vend = VendingMachine(200, 2)

print(vend.buy(50, 103))  # 50 * 2 = 100; 103 - 100 = 3 => Expected: 3
print(vend.buy(160, 400))  # Only 150 items left => Expected: "Not enough items in the machine"
print(vend.buy(43, 172))  # 43 * 2 = 86; 172 - 86 = 86 => Expected: 86
print(vend.buy(5, 3))  # 5 * 2 = 10; only 3 coins => Expected: "Not enough coins"

