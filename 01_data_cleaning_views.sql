CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Staging.olist_product_category_name_translation` AS
SELECT 
  INITCAP(REPLACE(product_category_name, '_', ' ')) AS product_category_name,
  INITCAP(REPLACE(product_category_name_english, '_', ' ')) AS product_category_name_english
FROM `my-project-0526-502020.Olist.olist_product_category_name_translation`;



CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Staging.olist_products_dataset` AS
SELECT 
  product_id,
  INITCAP(REPLACE(product_category_name, '_', ' ')) AS product_category_name,
  product_name_lenght,
  product_description_lenght,
  product_photos_qty,
  product_weight_g,
  product_length_cm,
  product_height_cm,
  product_width_cm
FROM `my-project-0526-502020.Olist.olist_products_dataset`; 




CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Staging.olist_order_items_dataset` AS
SELECT 
  order_id,
  order_item_id,
  product_id,
  seller_id,
  DATE(shipping_limit_date) AS shipping_limit_date,
  price,
  freight_value
FROM `my-project-0526-502020.Olist.olist_order_items_dataset`;


CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Staging.olist_order_reviews_dataset` AS
SELECT 
  review_id,
  order_id,
  review_score,
  DATE(review_creation_date) AS review_creation_date,
  DATE(review_answer_timestamp) AS review_answer_timestamp
FROM `my-project-0526-502020.Olist.olist_order_reviews_dataset`; 

CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Staging.olist_orders_dataset` AS
SELECT 
  order_id,
  customer_id,
  INITCAP(order_status) AS order_status,
  DATE(order_purchase_timestamp) AS order_purchase_timestamp,
  DATE(order_approved_at) AS order_approved_at,
  DATE(order_delivered_carrier_date) AS order_delivered_carrier_date,
  DATE(order_delivered_customer_date) AS order_delivered_customer_date,
  DATE(order_estimated_delivery_date) AS order_estimated_delivery_date
FROM `my-project-0526-502020.Olist.olist_orders_dataset`;


CREATE OR REPLACE VIEW `my-project-0526-502020.Olist_Staging.olist_customers_dataset` AS
SELECT 
  customer_id,
  customer_unique_id,
  customer_zip_code_prefix,
  INITCAP(customer_city) AS customer_city,
  UPPER(customer_state) AS customer_state
FROM `my-project-0526-502020.Olist.olist_customers_dataset`;

