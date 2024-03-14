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

-- Result:

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

-- Result:

-- 4. What was the average distance travelled for each customer?

-- Result:

-- 5. What was the difference between the longest and shortest delivery times for all orders?

-- Result:

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

-- Result:

-- 7. What is the successful delivery percentage for each runner?

-- Result:
