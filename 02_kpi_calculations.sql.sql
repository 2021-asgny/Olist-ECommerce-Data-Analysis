CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Gold.kpi01_top_products_by_units` AS
SELECT
  COALESCE(t.product_category_name_english, 'Diğer') AS category_name,
  i.product_id AS product_id,
  COUNT(*) AS units_sold,
  ROUND(SUM(i.price), 1) AS total_product_revenue
FROM `my-project-0526-502020.Olist_Staging.olist_order_items_dataset` AS i
JOIN `my-project-0526-502020.Olist_Staging.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `my-project-0526-502020.Olist_Staging.olist_product_category_name_translation` AS t
  ON p.product_category_name = t.product_category_name
JOIN `my-project-0526-502020.Olist_Staging.olist_orders_dataset` AS o
  ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY category_name, product_id
ORDER BY total_product_revenue DESC 
LIMIT 20; 


CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Gold.kpi01_top_products_by_revenue` AS
SELECT
  COALESCE(t.product_category_name_english, 'Diğer') AS category_name,
  i.product_id AS product_id,
  COUNT(*) AS units_sold,
  ROUND(SUM(i.price), 1) AS total_product_revenue
FROM `my-project-0526-502020.Olist_Staging.olist_order_items_dataset` AS i
JOIN `my-project-0526-502020.Olist_Staging.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `my-project-0526-502020.Olist_Staging.olist_product_category_name_translation` AS t
  ON p.product_category_name = t.product_category_name
JOIN `my-project-0526-502020.Olist_Staging.olist_orders_dataset` AS o
  ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY category_name, product_id
ORDER BY  units_sold DESC
LIMIT 20;  


CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Gold.kpi02_category_freight_burden` AS
SELECT
  COALESCE(t.product_category_name_english, 'Diğer') AS category_name,
  ROUND(SUM(i.price), 1) AS net_product_revenue,
  ROUND(SUM(i.freight_value), 1) AS freight_cost,
  ROUND(SUM(i.price + i.freight_value), 1) AS gmv_total_spend,
  ROUND(SAFE_DIVIDE(SUM(i.freight_value), SUM(i.price)) * 100, 1) AS freight_burden_pct
FROM `my-project-0526-502020.Olist_Staging.olist_order_items_dataset` AS i
JOIN `my-project-0526-502020.Olist_Staging.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `my-project-0526-502020.Olist_Staging.olist_product_category_name_translation` AS t
  ON p.product_category_name = t.product_category_name
JOIN `my-project-0526-502020.Olist_Staging.olist_orders_dataset` AS o
  ON i.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY category_name
ORDER BY freight_burden_pct DESC; 




CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Gold.kpi03_csat_monthly_by_category` AS
SELECT
  DATE_TRUNC(DATE(r.review_creation_date), MONTH) AS review_month,
  COALESCE(t.product_category_name_english, 'Diğer') AS category_name,
  COUNT(DISTINCT r.review_id) AS total_review_count,
  ROUND(AVG(r.review_score), 2) AS avg_review_score_1_to_5,
  ROUND(SAFE_DIVIDE(COUNTIF(r.review_score >= 4), COUNT(DISTINCT r.review_id)) * 100, 2) AS csat_pct,
  ROUND(SAFE_DIVIDE(COUNTIF(r.review_score <= 2), COUNT(DISTINCT r.review_id)) * 100, 2) AS negative_pct
FROM `my-project-0526-502020.Olist_Staging.olist_order_reviews_dataset` AS r
JOIN `my-project-0526-502020.Olist_Staging.olist_orders_dataset` AS o
  ON r.order_id = o.order_id
JOIN `my-project-0526-502020.Olist_Staging.olist_order_items_dataset` AS i
  ON o.order_id = i.order_id
JOIN `my-project-0526-502020.Olist_Staging.olist_products_dataset` AS p
  ON i.product_id = p.product_id
LEFT JOIN `my-project-0526-502020.Olist_Staging.olist_product_category_name_translation` AS t
  ON p.product_category_name = t.product_category_name
WHERE r.review_score IS NOT NULL
  AND o.order_status = 'Delivered'
GROUP BY
  DATE_TRUNC(DATE(r.review_creation_date), MONTH),
  category_name
ORDER BY review_month, csat_pct DESC; 





CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Gold.kpi04_repeat_purchase_rate` AS
WITH customer_order_counts AS (
  SELECT
    c.customer_unique_id AS customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
  FROM `my-project-0526-502020.Olist_Staging.olist_orders_dataset` AS o
  JOIN `my-project-0526-502020.Olist_Staging.olist_customers_dataset` AS c
    ON o.customer_id = c.customer_id
  WHERE o.order_status = 'Delivered'
  GROUP BY customer_unique_id
)
SELECT
  COUNT(*) AS total_unique_customers,
  COUNTIF(order_count > 1) AS repeat_customers,
  ROUND(SAFE_DIVIDE(COUNTIF(order_count > 1), COUNT(*)) * 100, 2) AS repeat_purchase_rate_pct
FROM customer_order_counts;