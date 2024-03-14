-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
    COUNT(*) AS registration_count,
    WEEK(registration_date) AS registration_week
FROM 
    pizza_runner.runners
GROUP BY WEEK(registration_date);

-- Result:
| registration_count | registration_week |
| ------------------ | ----------------- |
| 1                  | 0                 |
| 2                  | 1                 |
| 1                  | 2                 |


-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT
    r.runner_id,
    AVG(ABS(TIMESTAMPDIFF(MINUTE, r.pickup_time, c.order_time))) AS time
FROM 
    pizza_runner.runner_orders AS r
LEFT JOIN 
    pizza_runner.customer_orders AS c ON r.order_id = c.order_id
WHERE r.pickup_time != 0
GROUP BY 
    r.runner_id;

-- Result:
| runner_id | time    |
| --------- | ------- |
| 1         | 15.3333 |
| 2         | 23.4000 |
| 3         | 10.0000 |


-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH CTE AS
(SELECT 
    c.order_id,
    COUNT(c.order_id) AS pizza_order,
    c.order_time,
    r.pickup_time,
    TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) AS time
FROM 
    pizza_runner.customer_orders AS c
INNER JOIN 
    pizza_runner.runner_orders AS r ON c.order_id = r.order_id
WHERE 
    r.pickup_time != 0
GROUP BY  
    c.order_id, c.order_time, r.pickup_time)

SELECT 
pizza_order,
CAST(AVG(time) AS UNSIGNED) AS avg_time
FROM CTE
GROUP BY pizza_order;

-- Result:
| pizza_order | avg_time |
| ----------- | -------- |
| 1           | 12       |
| 2           | 18       |
| 3           | 29       |


-- 4. What was the average distance travelled for each customer?

-- Result:

-- 5. What was the difference between the longest and shortest delivery times for all orders?

-- Result:

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

-- Result:

-- 7. What is the successful delivery percentage for each runner?

-- Result:
