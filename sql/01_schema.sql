-- 01_schema.sql
-- Creates the database and the `customers` table that the analysis queries run against.
-- Tested on MySQL 8.0 (CHECK constraints need 8.0.16 or later).
--
-- Usage (from the repository root):
--   mysql -u <user> -p < sql/01_schema.sql

CREATE DATABASE IF NOT EXISTS customer_behavior
    DEFAULT CHARACTER SET utf8mb4;
USE customer_behavior;

DROP TABLE IF EXISTS customers;

-- One row per customer purchase (3,900 rows). Column order matches data/cleaned/customers.csv,
-- which is produced by notebooks/customer_trend_data_analysis.ipynb.
CREATE TABLE customers (
    customer_id             INT              NOT NULL,
    age                     TINYINT UNSIGNED NOT NULL,
    gender                  VARCHAR(10)      NOT NULL,
    item_purchased          VARCHAR(30)      NOT NULL,
    category                VARCHAR(20)      NOT NULL,
    purchase_amount         DECIMAL(6,2)     NOT NULL,   -- USD
    location                VARCHAR(30)      NOT NULL,
    size                    VARCHAR(5)       NOT NULL,
    color                   VARCHAR(20)      NOT NULL,
    season                  VARCHAR(10)      NOT NULL,
    review_rating           DECIMAL(2,1)     NOT NULL,   -- 37 missing values were imputed with the category median
    subscription_status     VARCHAR(3)       NOT NULL,
    shipping_type           VARCHAR(20)      NOT NULL,
    discount_applied        VARCHAR(3)       NOT NULL,   -- identical to the dropped promo_code_used column
    previous_purchases      SMALLINT UNSIGNED NOT NULL,
    payment_method          VARCHAR(20)      NOT NULL,
    frequency_of_purchases  VARCHAR(20)      NOT NULL,
    age_group               VARCHAR(15)      NOT NULL,   -- quartiles of age: 18-31, 32-44, 45-57, 58-70
    purchase_frequency_days SMALLINT UNSIGNED NOT NULL,  -- approximate days between purchases
    PRIMARY KEY (customer_id),
    CONSTRAINT chk_subscription CHECK (subscription_status IN ('Yes', 'No')),
    CONSTRAINT chk_discount     CHECK (discount_applied IN ('Yes', 'No')),
    CONSTRAINT chk_rating       CHECK (review_rating BETWEEN 1.0 AND 5.0),
    CONSTRAINT chk_amount       CHECK (purchase_amount > 0)
) ENGINE = InnoDB;

-- Indexes for the grouping columns used by the analysis queries.
CREATE INDEX idx_customers_category ON customers (category, item_purchased);
CREATE INDEX idx_customers_age_group ON customers (age_group);
