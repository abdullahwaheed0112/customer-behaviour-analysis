-- 03_analysis.sql
-- Ten business questions on the `customers` table (MySQL 8.0). Run after 01_schema.sql and 02_load.sql:
--   mysql -u <user> -p customer_behavior < sql/03_analysis.sql
-- Expected output and the matching Python cross-check are in sql/expected_results.md.

USE customer_behavior;

-- Q1. How is revenue split between male and female customers?
-- Includes customer counts: the revenue gap turns out to be a customer-count gap, not a spend gap.
SELECT
    gender,
    COUNT(*)                                          AS customers,
    SUM(purchase_amount)                              AS revenue,
    ROUND(100 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 1) AS pct_of_revenue,
    ROUND(AVG(purchase_amount), 2)                    AS avg_purchase
FROM customers
GROUP BY gender
ORDER BY revenue DESC;

-- Q2. How many customers used a discount AND spent more than the overall average purchase?
-- (Replace the COUNT with customer_id, purchase_amount to list them.)
SELECT
    COUNT(*)                                                      AS discount_users_above_average,
    (SELECT COUNT(*) FROM customers WHERE discount_applied = 'Yes') AS all_discount_users,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM customers WHERE discount_applied = 'Yes'), 1) AS pct_of_discount_users,
    ROUND((SELECT AVG(purchase_amount) FROM customers), 2)        AS overall_average_purchase
FROM customers
WHERE discount_applied = 'Yes'
  AND purchase_amount > (SELECT AVG(purchase_amount) FROM customers);

-- Q3. Which 5 products have the highest average review rating?
-- Sorted on the unrounded average (sorting on the rounded alias would let two products that both round to
-- 3.78 swap places); alphabetical tie-break keeps the result stable. Counts show how many ratings back each average.
SELECT
    item_purchased,
    ROUND(AVG(review_rating), 2) AS average_rating,
    COUNT(*)                     AS purchases
FROM customers
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC, item_purchased
LIMIT 5;

-- Q4. How does the average purchase amount differ by shipping type?
-- The original compared only Standard and Express; all six types are shown here.
SELECT
    shipping_type,
    COUNT(*)                       AS customers,
    ROUND(AVG(purchase_amount), 2) AS average_purchase
FROM customers
GROUP BY shipping_type
ORDER BY average_purchase DESC;

-- Q5. Do subscribers spend more than non-subscribers?
SELECT
    subscription_status,
    COUNT(*)                       AS customers,
    ROUND(AVG(purchase_amount), 2) AS average_spend,
    SUM(purchase_amount)           AS total_revenue
FROM customers
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- Q6. Which 5 products have the HIGHEST share of purchases with a discount applied?
-- (The earlier version sorted ascending and so returned the lowest five.)
SELECT
    item_purchased,
    ROUND(100 * AVG(discount_applied = 'Yes'), 1) AS discount_pct,
    COUNT(*)                                      AS purchases
FROM customers
GROUP BY item_purchased
ORDER BY discount_pct DESC, item_purchased
LIMIT 5;

-- Q7. Segment customers by purchase history into New / Returning / Loyal.
-- previous_purchases runs from 1 to 50 (quartiles 13, 25, 38), so the cut-offs follow the quartiles:
-- bottom 25% = New (1-13), middle 50% = Returning (14-38), top 25% = Loyal (39+).
-- The earlier cut-offs (1 / 2-10 / 11+) put about 80% of customers into "Loyal".
WITH customer_type AS (
    SELECT
        customer_id,
        purchase_amount,
        CASE
            WHEN previous_purchases <= 13 THEN 'New'
            WHEN previous_purchases <= 38 THEN 'Returning'
            ELSE 'Loyal'
        END AS customer_segment
    FROM customers
)
SELECT
    customer_segment,
    COUNT(*)                       AS customers,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_customers,
    ROUND(AVG(purchase_amount), 2) AS average_purchase
FROM customer_type
GROUP BY customer_segment
ORDER BY FIELD(customer_segment, 'New', 'Returning', 'Loyal');

-- Q8. What are the 3 most purchased products within each category?
-- ROW_NUMBER with an alphabetical tie-break gives a stable result (several products tie on order count).
-- Outerwear has only two products.
WITH item_counts AS (
    SELECT
        category,
        item_purchased,
        COUNT(*) AS total_orders,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(*) DESC, item_purchased) AS item_rank
    FROM customers
    GROUP BY category, item_purchased
)
SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3
ORDER BY category, item_rank;

-- Q9. Are repeat buyers (more than 5 previous purchases) more likely to subscribe?
-- Compare repeat buyers with everyone ELSE (not with all customers, which includes them).
SELECT
    previous_purchases > 5                        AS repeat_buyer,
    COUNT(*)                                      AS customers,
    SUM(subscription_status = 'Yes')              AS subscribers,
    ROUND(100 * AVG(subscription_status = 'Yes'), 1) AS subscription_rate_pct
FROM customers
GROUP BY repeat_buyer
ORDER BY repeat_buyer DESC;

-- Q10. How is revenue distributed across age groups?
-- Age groups are quartiles of age, so they hold similar numbers of customers; the revenue ranking
-- therefore follows group size as much as spending.
SELECT
    age_group,
    MIN(age)                                          AS min_age,
    MAX(age)                                          AS max_age,
    COUNT(*)                                          AS customers,
    SUM(purchase_amount)                              AS total_revenue,
    ROUND(AVG(purchase_amount), 2)                    AS average_purchase,
    ROUND(100 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (), 1) AS pct_of_revenue
FROM customers
GROUP BY age_group
ORDER BY total_revenue DESC;
