--1. What are the standard ingredients for each pizza?
with CTE AS(
  SELECT
  pizza_id,
  SUBSTRING_INDEX(SUBSTRING_INDEX(toppings, ',', numbers.n), ',', -1) AS topping_id
FROM
  pizza_runner.pizza_recipes
JOIN
  (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
ON
  CHAR_LENGTH(toppings) - CHAR_LENGTH(REPLACE(toppings, ',', '')) >= numbers.n - 1
ORDER BY
  pizza_id, topping_id DESC
)

SELECT CTE.pizza_id AS pizza_id,
pp.topping_name
FROM CTE
LEFT JOIN pizza_runner.pizza_toppings pp
ON CTE.topping_id = pp.topping_id
ORDER BY CTE.pizza_id;


-- Result:
| pizza_id | topping_name |
| -------- | ------------ |
| 1        | Bacon        |
| 1        | BBQ Sauce    |
| 1        | Beef         |
| 1        | Cheese       |
| 1        | Chicken      |
| 1        | Mushrooms    |
| 1        | Pepperoni    |
| 1        | Salami       |
| 2        | Cheese       |
| 2        | Mushrooms    |
| 2        | Onions       |
| 2        | Peppers      |
| 2        | Tomatoes     |
| 2        | Tomato Sauce |


--2. What was the most commonly added extra?
WITH CTE AS(
SELECT
  extra,
  COUNT(*) AS count
FROM
  (
    SELECT
      order_id,
      customer_id,
      pizza_id,
      exclusions,
      REGEXP_REPLACE(SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', numbers.n), ',', -1), '[^0-9]', '') AS extra
    FROM
      pizza_runner.customer_orders
    JOIN
      (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
    ON
      CHAR_LENGTH(extras) - CHAR_LENGTH(REPLACE(extras, ',', '')) >= numbers.n - 1
    WHERE
      extras > 0
  ) subquery
GROUP BY
  extra
ORDER BY
  count DESC)

SELECT pp.topping_name,
CTE.count
FROM CTE
LEFT JOIN pizza_runner.pizza_toppings pp
ON CTE.extra = pp.topping_id;

-- Result:
| topping_name | count |
| ------------ | ----- |
| Bacon        | 4     |
| Cheese       | 1     |
| Chicken      | 1     |


--3. What was the most common exclusion?
WITH CTE AS(
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', numbers.n), ',', -1) as exclusion
FROM pizza_runner.customer_orders
JOIN (
    SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
) numbers ON CHAR_LENGTH(exclusions) - CHAR_LENGTH(REPLACE(exclusions, ',', '')) >= n - 1
WHERE exclusions != 'null' AND exclusions != ''
ORDER BY order_id, exclusion
  )
  
SELECT 
DISTINCT topping_name,
COUNT(*) as Count_of_topping_name
FROM CTE
LEFT JOIN pizza_runner.pizza_toppings pp
ON CTE.exclusion = pp.topping_id
GROUP BY pp.topping_name
ORDER BY Count_of_topping_name DESC;

-- Result:
| topping_name | Count_of_topping_name |
| ------------ | --------------------- |
| Cheese       | 4                     |
| Mushrooms    | 1                     |
| BBQ Sauce    | 1                     |


--4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
SELECT pc.order_id, pc.pizza_id, pc.exclusions, pc.extras,pp.pizza_name
FROM pizza_runner.customer_orders pc
LEFT JOIN pizza_runner.pizza_names pp
on pc.pizza_id = pp.pizza_id
WHERE pc.exclusions = 0 AND pc.extras = 0 AND pp.pizza_name = 'Meatlovers'
ORDER BY order_id ASC;

-- Result:
| order_id | pizza_id | exclusions | extras | pizza_name |
| -------- | -------- | ---------- | ------ | ---------- |
| 1        | 1        |            |        | Meatlovers |
| 2        | 1        |            |        | Meatlovers |
| 3        | 1        |            |        | Meatlovers |
| 8        | 1        | null       | null   | Meatlovers |
| 10       | 1        | null       | null   | Meatlovers |

-- Meat Lovers - Exclude Beef
SELECT pc.order_id, pc.pizza_id, pc.exclusions, pc.extras,pp.pizza_name
FROM pizza_runner.customer_orders pc
LEFT JOIN pizza_runner.pizza_names pp
on pc.pizza_id = pp.pizza_id
WHERE pp.pizza_name = 'Meatlovers'#
ORDER BY order_id ASC;

-- Result:
| order_id | pizza_id | exclusions | extras | pizza_name |
| -------- | -------- | ---------- | ------ | ---------- |
| 1        | 1        |            |        | Meatlovers |
| 2        | 1        |            |        | Meatlovers |
| 3        | 1        |            |        | Meatlovers |
| 4        | 1        | 4          |        | Meatlovers |
| 4        | 1        | 4          |        | Meatlovers |
| 5        | 1        | null       | 1      | Meatlovers |
| 8        | 1        | null       | null   | Meatlovers |
| 9        | 1        | 4          | 1, 5   | Meatlovers |
| 10       | 1        | null       | null   | Meatlovers |
| 10       | 1        | 2, 6       | 1, 4   | Meatlovers |

-- Meat Lovers - Extra Bacon
SELECT pc.order_id, pc.pizza_id, pc.exclusions, pc.extras, pp.pizza_name
FROM pizza_runner.customer_orders pc
LEFT JOIN pizza_runner.pizza_names pp ON pc.pizza_id = pp.pizza_id
WHERE pp.pizza_name = 'Meatlovers' 
AND pc.extras LIKE '%1%'
ORDER BY order_id ASC;

-- Result:
| order_id | pizza_id | exclusions | extras | pizza_name |
| -------- | -------- | ---------- | ------ | ---------- |
| 5        | 1        | null       | 1      | Meatlovers |
| 9        | 1        | 4          | 1, 5   | Meatlovers |
| 10       | 1        | 2, 6       | 1, 4   | Meatlovers |

-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
SELECT pc.order_id, pc.pizza_id, pc.exclusions, pc.extras, pp.pizza_name
FROM pizza_runner.customer_orders pc
LEFT JOIN pizza_runner.pizza_names pp ON pc.pizza_id = pp.pizza_id
WHERE pp.pizza_name = 'Meatlovers' 
AND pc.exclusions LIKE '%1%'
AND pc.exclusions LIKE '%4%'
AND pc.extras LIKE '%6%'
AND pc.extras LIKE '%9%'
ORDER BY order_id ASC;

-- Result:
There are no results to be displayed.

--5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

-- Result:

--6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

-- Result:
