-- 02_load.sql
-- Loads data/cleaned/customers.csv into the `customers` table and checks the result.
--
-- Usage (from the repository root, so the relative path below resolves):
--   mysql --local-infile=1 -u <user> -p < sql/02_load.sql
--
-- LOCAL INFILE must be enabled on both the client (--local-infile=1) and the server
-- (SET GLOBAL local_infile = 1; needs an administrator account).

USE customer_behavior;
TRUNCATE TABLE customers;

LOAD DATA LOCAL INFILE 'data/cleaned/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(customer_id, age, gender, item_purchased, category, purchase_amount, location, size, color, season,
 review_rating, subscription_status, shipping_type, discount_applied, previous_purchases,
 payment_method, frequency_of_purchases, age_group, @purchase_frequency_days)
-- The CSV may have Windows (CRLF) line endings; strip a trailing carriage return from the last column.
SET purchase_frequency_days = TRIM(TRAILING '\r' FROM @purchase_frequency_days);

-- Sanity checks: expect 3,900 rows, revenue 233,081, 1,053 subscribers, 1,677 discounted purchases.
SELECT COUNT(*)                                        AS row_count,
       SUM(purchase_amount)                            AS total_revenue,
       SUM(subscription_status = 'Yes')                AS subscribers,
       SUM(discount_applied = 'Yes')                   AS discounted_purchases,
       MIN(age) AS min_age, MAX(age) AS max_age
FROM customers;
