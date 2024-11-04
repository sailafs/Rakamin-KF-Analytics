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
    
    -- Presentase Gross Laba (dalam desimal)
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        WHEN t.price > 500000 THEN 0.30
    END AS persentase_gross_laba,

    -- NET SALES = Harga asli - total diskon 
    -- atau = Harga asli * (1 - total diskon) menggunakan prinsip A - (A * B) = A * (1 - B)
    ROUND(t.price * (1 - t.discount_percentage), 2) as net_sales,
    
    -- NET PROFIT = Net Sales - (Harga asli - (Harga asli × persentase_laba))
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