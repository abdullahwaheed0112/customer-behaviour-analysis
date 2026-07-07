# Customer Shopping Behavior Analysis

An end-to-end analysis of customer shopping behavior using transactional data from **3,900 purchases** across multiple product categories. The project combines **Python** (data cleaning & EDA), **SQL** (business-question analysis), and **Power BI** (interactive dashboard) to uncover insights into spending patterns, customer segments, product preferences, and subscription behavior — culminating in actionable business recommendations.

## Project Overview

The goal of this project is to analyze customer transaction data to guide strategic business decisions around marketing, pricing, loyalty, and subscriptions. The workflow moves from raw data → cleaned dataset → SQL-driven business analysis → visual dashboard → recommendations.

## Dataset

| | |
|---|---|
| **Rows** | 3,900 |
| **Columns** | 18 |
| **Missing Data** | 37 values in `Review Rating` |

**Feature groups:**
- **Demographics:** Age, Gender, Location, Subscription Status
- **Purchase Details:** Item Purchased, Category, Purchase Amount, Season, Size, Color
- **Shopping Behavior:** Discount Applied, Promo Code Used, Previous Purchases, Frequency of Purchases, Review Rating, Shipping Type

## Tech Stack

- **Python** (pandas) — data loading, cleaning, feature engineering
- **MySQL** — business-question analysis via SQL
- **Power BI** — interactive dashboard for visual reporting

## Workflow

### 1. Exploratory Data Analysis (Python)
- Loaded data into a pandas DataFrame and explored it with `df.info()` / `df.describe()`
- Filled missing `Review Rating` values using the median rating per product category
- Standardized column names to snake_case for cleaner querying
- Engineered new features:
  - `age_group` — grouped raw ages into broader categories
  - `purchase_frequency_days` — converted categorical purchase frequency into a numeric interval
- Removed redundant columns (e.g., dropped one of `discount_applied` / `promo_code_used`)
- Loaded the cleaned DataFrame into MySQL for SQL analysis

### 2. Business Analysis (SQL)
Ten key business questions were answered using SQL, including:
1. Revenue by gender
2. High-spending customers who still use discounts
3. Top 5 products by average rating
4. Purchase amount by shipping type (standard vs. express)
5. Subscriber vs. non-subscriber spend and revenue
6. Products most dependent on discounts
7. Customer segmentation (New / Returning / Loyal)
8. Top 3 products per category
9. Relationship between repeat purchases (>5) and subscription status
10. Revenue contribution by age group

### 3. Dashboard (Power BI)
An interactive Power BI dashboard visualizes customer counts, average purchase amount, review ratings, subscription mix, category performance, and revenue/sales by age group — with filters for subscription status, gender, category, and shipping type.

## Key Business Recommendations

- **Target marketing by gender** to grow the lower-contributing segment
- **Shift from blanket discounting** to targeted offers for price-sensitive customers
- **Promote top-rated products** more prominently across marketing channels
- **Reposition shipping options** (e.g., express as a paid or loyalty perk)
- **Invest in the subscription program** with added perks to convert high-value non-subscribers
- **Review discount-dependent products** for pricing strategy or repositioning
- **Build tiered loyalty rewards** to move customers from New → Returning → Loyal
- **Double down on top-performing products** per category
- **Target frequent repeat buyers** for subscription conversion
- **Align marketing spend with age-group revenue contribution**
- **Operationalize the dashboard** for ongoing monitoring by marketing, sales, and inventory teams

## Repository Structure

```
├── data/                                   # Raw and cleaned datasets
├── notebooks/                              # Python EDA & feature engineering notebooks
├── sql/                                    # SQL scripts for business-question analysis
├── Power BI / dashboard                    # Power BI (.pbix) dashboard file
├── report/ customer_behavior_report.docx   # Full written report with findings & recommendations
├── presentation/                           # pptx File for Presentation
└── README.md
```

## Getting Started

1. Clone the repo
   ```bash
   git clone <https://github.com/abdullahwaheed0112/customer-behaviour-analysis.git>
   cd customer-shopping-behavior-analysis
   ```
2. Install Python dependencies
   ```bash
   pip install pandas
   ```
3. Run the EDA notebook(s) in `notebooks/` to reproduce the cleaned dataset
4. Load the cleaned data into MySQL and run the scripts in `sql/`
5. Open the `.pbix` file in Power BI Desktop to explore the dashboard
