# SQL Analysis

# Q1 : Total Reveneue - Male vs Female
SELECT
	gender,
	SUM(purchase_amount) as revenue
FROM customers
GROUP BY gender;

# Q2: Which customers used discount and used more than average purchase amount
SELECT 
	customer_id,
    purchase_amount
FROM customers
WHERE discount_applied = 'Yes' AND purchase_amount > (SELECT AVG(purchase_amount) FROM customers);

# Q3: Top 5 Products with highest Average review rating
SELECT
	item_purchased,
    ROUND(AVG(review_rating),2) AS average_rating
FROM customers
GROUP BY item_purchased
ORDER BY average_rating DESC
LIMIT 5;
    
# Q4: Compare Average Purchase amounts btw standard and express shipping
SELECT
	shipping_type,
    AVG(purchase_amount)
FROM customers
WHERE shipping_type in ('Standard','Express')
GROUP BY shipping_type;

# Q5: Compare Average spend and total revenue between subscribers and non-subscribers
SELECT
	subscription_status,
    COUNT(customer_id) AS total_customers,
	ROUND(AVG(purchase_amount),2) AS average_spend,
    SUM(purchase_amount) AS total_revenue
FROM customers
GROUP BY subscription_status
ORDER BY total_revenue, average_spend DESC;

# Q6: 5 Products with highest percentage of purchases with disocunts applied
SELECT
	item_purchased,
    100 * ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_percentage
FROM customers
GROUP BY item_purchased
ORDER BY discount_percentage
LIMIT 5;

# Q7: Segment Customers in loyal, Returning and new based on previous purchases
WITH customer_type AS(
SELECT 
	customer_id,
    previous_purchases,
    CASE 
		WHEN previous_purchases = 1 THEN 'New'
        WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
		ELSE 'Loyal'
        END AS customer_segment
FROM customers
)

SELECT 
	customer_segment,
    COUNT(*) AS "Number Of Customers"
FROM customer_type
GROUP BY customer_segment;

# Q8: Top 3 Most Purchased Products within each category
WITH item_counts AS (
SELECT
	category,
    item_purchased,
    COUNT(customer_id) AS total_orders,
ROW_NUMBER() OVER ( PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customers
GROUP BY category, item_purchased
)

SELECT 
	item_rank,
    category,
    item_purchased,
    total_orders
FROM item_counts
WHERE item_rank <= 3;

# Q9: are Repeat buyers (previous purchases > 5) likely to subscribe?
SELECT
	subscription_status,
    COUNT(customer_id) AS repeat_buyers
FROM customers
WHERE previous_purchases > 5
GROUP BY subscription_status;

# Q10: Revenue Contribution By each age group
SELECT
	age_group,
    SUM(purchase_amount) AS total_revenue
FROM customers
GROUP BY age_group
ORDER BY total_revenue DESC;