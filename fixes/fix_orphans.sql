INSERT INTO customer (customer_id, first_name, last_name, phone, email, created_at, is_active)
SELECT DISTINCT 
    o.customer_id, 
    'Unknown', 
    'Customer_' || o.customer_id, 
    '555' || LPAD(o.customer_id::text, 7, '0'), 
    'unknown_' || o.customer_id || '@example.com', 
    CURRENT_DATE, 
    1
FROM remote_orders."ORDER" o
LEFT JOIN customer c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL AND o.customer_id IS NOT NULL;
