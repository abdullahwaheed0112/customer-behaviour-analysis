# Expected results of `03_analysis.sql`

Output of `sql/01_schema.sql`, `sql/02_load.sql` and `sql/03_analysis.sql`, run on MySQL 8.0.46 against
`data/cleaned/customers.csv`. Every result was cross-checked against the pandas calculations in
`notebooks/customer_trend_data_analysis.ipynb` and matches.

## Q1. Revenue by gender

```text
+--------+-----------+-----------+----------------+--------------+
| gender | customers | revenue   | pct_of_revenue | avg_purchase |
+--------+-----------+-----------+----------------+--------------+
| Male   |      2652 | 157890.00 |           67.7 |        59.54 |
| Female |      1248 |  75191.00 |           32.3 |        60.25 |
+--------+-----------+-----------+----------------+--------------+
```

Men are 68% of customers, so they bring 67.7% of revenue. Average spend per purchase is about the same.

## Q2. Discount users who spent above the average purchase

```text
+------------------------------+--------------------+-----------------------+--------------------------+
| discount_users_above_average | all_discount_users | pct_of_discount_users | overall_average_purchase |
+------------------------------+--------------------+-----------------------+--------------------------+
|                          839 |               1677 |                  50.0 |                    59.76 |
+------------------------------+--------------------+-----------------------+--------------------------+
```

Exactly half of discount users spent above the average, the same share as non-discount buyers (50.6%, see the notebook).

## Q3. Top 5 products by average review rating

```text
+----------------+----------------+-----------+
| item_purchased | average_rating | purchases |
+----------------+----------------+-----------+
| Gloves         |           3.86 |       140 |
| Sandals        |           3.84 |       160 |
| Boots          |           3.82 |       144 |
| Hat            |           3.80 |       154 |
| Skirt          |           3.78 |       158 |
+----------------+----------------+-----------+
```

The five averages sit within 0.08 of each other.

## Q4. Average purchase by shipping type

```text
+----------------+-----------+------------------+
| shipping_type  | customers | average_purchase |
+----------------+-----------+------------------+
| 2-Day Shipping |       627 |            60.73 |
| Express        |       646 |            60.48 |
| Free Shipping  |       675 |            60.41 |
| Store Pickup   |       650 |            59.89 |
| Next Day Air   |       648 |            58.63 |
| Standard       |       654 |            58.46 |
+----------------+-----------+------------------+
```

Group means span about $2.27.

## Q5. Subscribers vs non-subscribers

```text
+---------------------+-----------+---------------+---------------+
| subscription_status | customers | average_spend | total_revenue |
+---------------------+-----------+---------------+---------------+
| No                  |      2847 |         59.87 |     170436.00 |
| Yes                 |      1053 |         59.49 |      62645.00 |
+---------------------+-----------+---------------+---------------+
```

Subscribers are 27% of customers and spend the same per purchase.

## Q6. Top 5 products by share of discounted purchases

```text
+----------------+--------------+-----------+
| item_purchased | discount_pct | purchases |
+----------------+--------------+-----------+
| Hat            |         50.0 |       154 |
| Sneakers       |         49.7 |       145 |
| Coat           |         49.1 |       161 |
| Sweater        |         48.2 |       164 |
| Pants          |         47.4 |       171 |
+----------------+--------------+-----------+
```

These are the highest shares, but the notebook's chi-square test (p = 0.13) says the shares do not differ significantly across products.

## Q7. Customer segments by purchase history

```text
+------------------+-----------+------------------+------------------+
| customer_segment | customers | pct_of_customers | average_purchase |
+------------------+-----------+------------------+------------------+
| New              |      1014 |             26.0 |            60.14 |
| Returning        |      1958 |             50.2 |            59.47 |
| Loyal            |       928 |             23.8 |            59.98 |
+------------------+-----------+------------------+------------------+
```

Quartile cut-offs (1-13 / 14-38 / 39+).

## Q8. Top 3 most purchased products per category

```text
+-----------+-------------+----------------+--------------+
| item_rank | category    | item_purchased | total_orders |
+-----------+-------------+----------------+--------------+
|         1 | Accessories | Jewelry        |          171 |
|         2 | Accessories | Belt           |          161 |
|         3 | Accessories | Sunglasses     |          161 |
|         1 | Clothing    | Blouse         |          171 |
|         2 | Clothing    | Pants          |          171 |
|         3 | Clothing    | Shirt          |          169 |
|         1 | Footwear    | Sandals        |          160 |
|         2 | Footwear    | Shoes          |          150 |
|         3 | Footwear    | Sneakers       |          145 |
|         1 | Outerwear   | Jacket         |          163 |
|         2 | Outerwear   | Coat           |          161 |
+-----------+-------------+----------------+--------------+
```

Ties are broken alphabetically. Outerwear has only two products.

## Q9. Repeat buyers (more than 5 previous purchases) and subscription

```text
+--------------+-----------+-------------+-----------------------+
| repeat_buyer | customers | subscribers | subscription_rate_pct |
+--------------+-----------+-------------+-----------------------+
|            1 |      3476 |         958 |                  27.6 |
|            0 |       424 |          95 |                  22.4 |
+--------------+-----------+-------------+-----------------------+
```

`repeat_buyer` 1 = more than 5 previous purchases. The notebook reports +5.2 points, p = 0.03.

## Q10. Revenue by age group

```text
+-------------+---------+---------+-----------+---------------+------------------+----------------+
| age_group   | min_age | max_age | customers | total_revenue | average_purchase | pct_of_revenue |
+-------------+---------+---------+-----------+---------------+------------------+----------------+
| Young Adult |      18 |      31 |      1028 |      62143.00 |            60.45 |           26.7 |
| Middle-aged |      45 |      57 |       986 |      59197.00 |            60.04 |           25.4 |
| Adult       |      32 |      44 |       942 |      55978.00 |            59.42 |           24.0 |
| Senior      |      58 |      70 |       944 |      55763.00 |            59.07 |           23.9 |
+-------------+---------+---------+-----------+---------------+------------------+----------------+
```

Age groups are quartiles of age, so they have similar sizes.
