-- ==============================================================================
-- ASSIGNMENT: 3 Views and 6 Queries
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- VIEW 1: Original Department (Customer_DB)
-- Combines 'customer' and 'loyalty' tables
-- ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_customer_loyalty_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    l.points,
    l.tier_id,
    c.is_active
FROM customer c
JOIN loyalty l ON c.customer_id = l.customer_id;

-- Query 1.1: Find active customers with more than 100 loyalty points
SELECT first_name, last_name, points FROM v_customer_loyalty_summary WHERE points > 100 AND is_active = 1;

-- Query 1.2: Calculate the average points per loyalty tier
SELECT tier_id, AVG(points) as avg_points FROM v_customer_loyalty_summary GROUP BY tier_id ORDER BY tier_id;


-- ------------------------------------------------------------------------------
-- VIEW 2: Received Department (Orders_DB)
-- Combines 'ORDER' and 'bill' tables
-- ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_order_billing_summary AS
SELECT 
    o.order_id,
    o.order_status,
    o.order_time,
    b.total_amount,
    b.discount_amount,
    b.final_amount
FROM "ORDER" o
JOIN bill b ON o.order_id = b.order_id;

-- Query 2.1: Get the average final amount for completed orders
SELECT AVG(final_amount) as avg_completed_amount FROM v_order_billing_summary WHERE order_status = 'Completed';

-- Query 2.2: Find orders where a discount was applied
SELECT order_id, total_amount, discount_amount, final_amount FROM v_order_billing_summary WHERE discount_amount > 0;


-- ------------------------------------------------------------------------------
-- VIEW 3: Cross-Department Integration View (Run in Customer_DB)
-- Combines local 'customer' table with the remote 'ORDER' table via FDW
-- ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_cross_db_customer_orders AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_status,
    o.order_time
FROM customer c
JOIN remote_orders."ORDER" o ON c.customer_id = o.customer_id;

-- Query 3.1: Count the total number of orders placed by each customer
SELECT first_name, last_name, COUNT(order_id) as total_orders FROM v_cross_db_customer_orders GROUP BY first_name, last_name ORDER BY total_orders DESC;

-- Query 3.2: Find customers who have a 'Cancelled' order
SELECT DISTINCT first_name, last_name FROM v_cross_db_customer_orders WHERE order_status = 'Cancelled';
