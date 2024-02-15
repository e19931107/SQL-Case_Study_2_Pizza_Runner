--1. How many pizzas were ordered?
SELECT COUNT(*) AS No_of_pizzas_ordered
FROM pizza_runner.customer_orders;

-- Result:
| No_of_pizzas_ordered |
| -------------------- |
| 14                   |


--2. How many unique customer orders were made?
SELECT
DISTINCT customer_id,
COUNT(*) AS No_of_pizzas_ordered
FROM pizza_runner.customer_orders
GROUP BY customer_id;
  
-- Result:
| customer_id | No_of_pizzas_ordered |
| ----------- | -------------------- |
| 101         | 3                    |
| 102         | 3                    |
| 103         | 4                    |
| 104         | 3                    |
| 105         | 1                    |


--3. How many successful orders were delivered by each runner?
SELECT
DISTINCT runner_id,
COUNT(*) AS delivered_orders
FROM pizza_runner.runner_orders
WHERE pickup_time != 0
GROUP BY runner_id;

-- Result:
| runner_id | delivered_orders |
| --------- | ---------------- |
| 1         | 4                |
| 2         | 3                |
| 3         | 1                |


--4. How many of each type of pizza was delivered?
SELECT 
DISTINCT pizza_id,
COUNT(*) AS No_of_delivered
FROM pizza_runner.customer_orders c
LEFT JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE pickup_time != 0
GROUP BY pizza_id;

-- Result:
| pizza_id | No_of_delivered |
| -------- | --------------- |
| 1        | 9               |
| 2        | 3               |


--5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT
DISTINCT customer_id, pizza_name,
COUNT(*) as No_of_ordered
FROM pizza_runner.customer_orders c
LEFT JOIN pizza_runner.pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY pizza_name, customer_id
ORDER BY customer_id;

-- Result:
| customer_id | pizza_name | No_of_ordered |
| ----------- | ---------- | ------------- |
| 101         | Meatlovers | 2             |
| 101         | Vegetarian | 1             |
| 102         | Meatlovers | 2             |
| 102         | Vegetarian | 1             |
| 103         | Meatlovers | 3             |
| 103         | Vegetarian | 1             |
| 104         | Meatlovers | 3             |
| 105         | Vegetarian | 1             |


--6. What was the maximum number of pizzas delivered in a single order?
WITH CTE AS
(
SELECT 
c.order_id,
COUNT(*) as No_pizza_delivered
FROM pizza_runner.customer_orders c
LEFT JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE pickup_time != 0
GROUP BY c.order_id
)

SELECT *
FROM CTE
ORDER BY No_pizza_delivered DESC
LIMIT 1;

-- Result:
| order_id | No_pizza_delivered |
| -------- | ------------------ |
| 4        | 3                  |


--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
DISTINCT customer_id,
COUNT(*) AS No_change
FROM pizza_runner.customer_orders c
LEFT JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE pickup_time != 0 and (exclusions != 0 or extras != 0)
GROUP BY customer_id;

SELECT 
DISTINCT customer_id,
COUNT(*) AS No_no_change
FROM pizza_runner.customer_orders c
LEFT JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE pickup_time != 0 and (exclusions = 0 and extras = 0)
GROUP BY customer_id;

-- Result:
| customer_id | No_change |
| ----------- | --------- |
| 103         | 3         |
| 104         | 2         |
| 105         | 1         |

| customer_id | No_no_change |
| ----------- | ------------ |
| 101         | 2            |
| 102         | 2            |
| 104         | 1            |


--8. How many pizzas were delivered that had both exclusions and extras?
SELECT 
DISTINCT c.order_id,
COUNT(*) as No_delivered_both_exclusions_and_extras
FROM pizza_runner.customer_orders c
LEFT JOIN pizza_runner.runner_orders r
ON c.order_id = r.order_id
WHERE pickup_time != 0 and exclusions != 0 and extras != 0
GROUP BY c.order_id;

-- Result:
| order_id | No_delivered_both_exclusions_and_extras |
| -------- | --------------------------------------- |
| 10       | 1                                       |


--9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
EXTRACT(HOUR FROM c.order_time) AS hour_of_day,
COUNT(c.order_id) AS volume_for_hour
FROM pizza_runner.customer_orders c
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Result:
| hour_of_day | volume_for_hour |
| ----------- | --------------- |
| 11          | 1               |
| 13          | 3               |
| 18          | 3               |
| 19          | 1               |
| 21          | 3               |
| 23          | 3               |


--10. What was the volume of orders for each day of the week?

-- Result:

