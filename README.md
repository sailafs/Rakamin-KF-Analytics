# Kimia Farma Performance Analytics Dashboard Project

## Introduction
This project is part of the Big Data Analytics Intern assignment at Kimia Farma to evaluate the company's business performance from 2020-2023. The project involves processing 4 datasets (kf_final_transaction.csv, kf_inventory.csv, kf_kantor_cabang.csv, and kf_product.csv) which will be imported into BigQuery for further analysis. The data includes information on transactions, branch ratings, and sales performance. The problem statement focuses on creating a comprehensive business performance dashboard, including revenue analysis, transactions per province, branch ratings, and profit. The final output will be a dashboard in Google Looker Studio that will help stakeholders monitor and analyse the business performance of Kimia Farma comprehensively.

## Tools Used
* Google BigQuery - for data processing and analysis
* Google Looker Studio - for dashboard visualization

## Process

### 1. Data Preparation in BigQuery
I created a comprehensive analysis table by combining transaction data with product and branch information, while also calculating important business metrics like net sales and profit margins. Here's the query used:

```sql
CREATE OR REPLACE TABLE `Rakamin_KF_Analytics.kimia_farma` AS 
SELECT 
    t.transaction_id,
    t.date,
    t.branch_id,
    b.branch_name,
    b.kota,
    b.provinsi,
    b.rating as rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price,
    t.discount_percentage,
    
    -- Calculate Gross Profit Percentage based on price ranges
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS persentase_gross_laba,

    -- Calculate Net Sales (Price after discount)
    ROUND(t.price * (1 - t.discount_percentage), 2) as net_sales,
    
    -- Calculate Net Profit
    ROUND(
        (t.price * (1 - t.discount_percentage)) - 
        (t.price - (t.price * 
            CASE
                WHEN t.price <= 50000 THEN 0.10
                WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
                WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
                WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
                WHEN t.price > 500000 THEN 0.30
            END
        )), 
    2) as net_profit,
    
    t.rating as rating_transaksi

FROM `Rakamin_KF_Analytics.kf_final_transaction` t
INNER JOIN `Rakamin_KF_Analytics.kf_product` p 
    ON t.product_id = p.product_id
INNER JOIN `Rakamin_KF_Analytics.kf_kantor_cabang` b 
    ON t.branch_id = b.branch_id
ORDER BY product_id;
```

Key aspects of the data preparation:
1. **Table Joins:**
   - Merged transaction data with product information
   - Incorporated branch details including location and ratings

2. **Calculated Fields:**
   - Gross profit percentage based on price ranges
   - Net sales (price after discounts)
   - Net profit calculations

3. **Distinct Ratings:**
   - Separated branch ratings (`rating_cabang`) from transaction ratings (`rating_transaksi`)

### 2. Dashboard Creation
Using the aggregated data table, I created a dashboard in Google Looker Studio that visualizes:
- Net Sales Performance (80.6B)
- Total Transactions (168,642)
- Provincial Sales & Transaction Analysis
- Top Performing Branches with Ratings
- Branch Type Distribution

## Results

The final dashboard can be accessed [here](https://lookerstudio.google.com/u/0/reporting/56ddedb1-77cc-418e-9582-4ee456e1b43a/page/tEnnC).

Here's a preview of the dashboard:
<img width="908" alt="Screenshot 2024-11-04 at 6 19 35 PM" src="https://github.com/user-attachments/assets/b0d57dbb-28ac-43ed-8de5-63b344f43bea">


Key insights from the dashboard:
1. Net Sales reached 80.6B IDR in 2022
2. Processed 168,642 total transactions
3. Top performing provinces include:
   - Jawa Barat
   - Sumatera
   - Jawa Tengah
4. Branch distribution shows an even split between:
   - Kimia Farma - Apotek (34%)
   - Kimia Farma - Klinik & Apotek (33%)
   - Kimia Farma - Klinik-Apotek-Laboratorium (33%)
5. Identified top 5 branches with highest ratings but lower transaction ratings:
   - Malang (52064)
   - Tarakan (82157)
   - Samarinda (23156)
   - Solok (91943)
   - Batam (44567)

## Contact
For any questions or feedback about this project, please feel free to reach out to me:
- LinkedIn: [Saila Fikriyya]([https://www.linkedin.com/in/sailafs1203/])
- Email: sailafs@gmail.com
