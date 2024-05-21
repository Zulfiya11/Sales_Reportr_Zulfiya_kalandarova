WITH WeeklySales AS (
    SELECT
        order_date,
        total_sales,
        WEEK(order_date) AS week_number
    FROM
        orders
    WHERE
        order_date >= '1999-12-06' AND order_date <= '1999-12-26'
)
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS CUM_SUM,
    CASE
        WHEN DAYOFWEEK(order_date) = 2 THEN
            (LAG(total_sales, 2) OVER (ORDER BY order_date) + LAG(total_sales, 1) OVER (ORDER BY order_date) + total_sales + LEAD(total_sales, 1) OVER (ORDER BY order_date) + LEAD(total_sales, 2) OVER (ORDER BY order_date)) / 5
        WHEN DAYOFWEEK(order_date) = 6 THEN
            (LAG(total_sales, 1) OVER (ORDER BY order_date) + total_sales + LEAD(total_sales, 1) OVER (ORDER BY order_date) + LEAD(total_sales, 2) OVER (ORDER BY order_date) + LEAD(total_sales, 3) OVER (ORDER BY order_date)) / 5
        ELSE
            NULL
    END AS CENTERED_3_DAY_AVG
FROM
    WeeklySales;
