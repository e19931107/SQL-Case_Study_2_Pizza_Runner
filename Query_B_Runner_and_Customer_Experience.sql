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

-- Comment:
1 pizza took around 10 mins, 2 pizzas took around 20 minutes, 3 pizzas took around 30 minutes.
That means more pizzas created, more time speed.
But it did not represent average time per pizza increase, it is also possible the data is not enough to analyze.

-- 4. What was the average distance travelled for each customer?
SELECT 
DISTINCT r.runner_id,
ROUND(AVG(REGEXP_REPLACE(r.distance, '[^0-9.]+', '')),2) AS avg_distance
FROM pizza_runner.customer_orders AS c
LEFT JOIN pizza_runner.runner_orders AS r
ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY r.runner_id;

-- Result:
| runner_id | avg_distance |
| --------- | ------------ |
| 1         | 14.47        |
| 2         | 23.72        |
| 3         | 10           |

-- Comment:
I think the question is wrong, it is not "customer", should be "runner".
Therefore, my answer is the average distance by runner.


-- 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT 
MAX(REGEXP_REPLACE(r.duration, '[^0-9.]+', ''))-Min(REGEXP_REPLACE(r.duration, '[^0-9.]+', '')) as diff_duration
FROM pizza_runner.runner_orders r
WHERE REGEXP_REPLACE(r.duration, '[^0-9.]+', '')>0;
    
-- Result:
| diff_duration |
| ------------- |
| 30            |


-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
with CTE as(
SELECT *,
REGEXP_REPLACE(r.distance, '[^0-9.]+', '') as new_distance,
REGEXP_REPLACE(r.duration, '[^0-9.]+', '')/60 as new_duration
FROM pizza_runner.runner_orders r
WHERE REGEXP_REPLACE(r.duration, '[^0-9.]+', '')>0)

SELECT order_id,
runner_id,
new_distance/new_duration as speed
FROM CTE
ORDER BY runner_id;


-- Result:
| order_id | runner_id | speed             |
| -------- | --------- | ----------------- |
| 1        | 1         | 37.5              |
| 2        | 1         | 44.44444444444444 |
| 3        | 1         | 40.2              |
| 10       | 1         | 60                |
| 4        | 2         | 35.1              |
| 7        | 2         | 60                |
| 8        | 2         | 93.6              |
| 5        | 3         | 40                |

-- Comment:
As the runner is more experienced, the speed increases.

-- 7. What is the successful delivery percentage for each runner?
WITH CTE AS(
SELECT 
r.runner_id,
COUNT(*) as TTL_delivery,
SUM(CASE WHEN REGEXP_REPLACE(r.duration, '[^0-9.]+', '')>0 THEN 1 ELSE 0 END) AS Successful_delivery
FROM pizza_runner.runner_orders r
GROUP BY r.runner_id
)

SELECT runner_id,
ROUND((Successful_delivery/TTL_delivery)*100,0) as Successful_delivery_rate
FROM CTE;


-- Result:
| runner_id | Successful_delivery_rate |
| --------- | ------------------------ |
| 1         | 100                      |
| 2         | 75                       |
| 3         | 50                       |

