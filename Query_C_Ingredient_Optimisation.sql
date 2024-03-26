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

-- Result:

--4. Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

-- Result:

--5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

-- Result:

--6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

-- Result:
