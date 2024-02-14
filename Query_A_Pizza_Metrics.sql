-- How many pizzas were ordered?
SELECT COUNT(*) AS No_of_pizzas_ordered
FROM pizza_runner.customer_orders;

-- Result:
| No_of_pizzas_ordered |
| -------------------- |
| 14                   |


-- How many unique customer orders were made?
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


-- How many successful orders were delivered by each runner?
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


-- How many of each type of pizza was delivered?

-- Result:


-- How many Vegetarian and Meatlovers were ordered by each customer?

-- Result:

-- What was the maximum number of pizzas delivered in a single order?

-- Result:


-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

-- Result:


-- How many pizzas were delivered that had both exclusions and extras?

-- Result:


-- What was the total volume of pizzas ordered for each hour of the day?

-- Result:


-- What was the volume of orders for each day of the week?

-- Result:

