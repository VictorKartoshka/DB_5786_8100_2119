SELECT o.order_id, o.customer_id
FROM remote_orders."ORDER" o
LEFT JOIN customer c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
