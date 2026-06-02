-- ==============================================================================
-- SCRIPT: Generate Orders for Customers 1-500
-- Target DB: Orders_DB
-- ==============================================================================

DO $$ 
DECLARE
    v_customer_id INT;
    v_order_id INT;
    v_bill_id INT;
    v_amount NUMERIC;
BEGIN
    -- Get starting IDs to prevent primary key collisions
    SELECT COALESCE(MAX(order_id), 0) INTO v_order_id FROM "ORDER";
    SELECT COALESCE(MAX(bill_id), 0) INTO v_bill_id FROM bill;

    -- Loop through customer IDs 1 to 500
    FOR v_customer_id IN 1..500 LOOP
        v_order_id := v_order_id + 1;
        v_bill_id := v_bill_id + 1;
        
        -- Generate a random subtotal amount between 50 and 150
        v_amount := random() * 100 + 50; 

        -- Insert Order
        INSERT INTO "ORDER" (order_id, table_id, customer_id, waiter_id, order_time, order_status)
        VALUES (v_order_id, 
                (random() * 19 + 1)::INT, -- random table 1-20
                v_customer_id, 
                (random() * 9 + 1)::INT,  -- random waiter 1-10
                CURRENT_TIMESTAMP - (random() * 365 || ' days')::INTERVAL, -- random time in last year
                'Completed');

        -- Insert Bill (linked to the order we just made)
        INSERT INTO bill (bill_id, order_id, total_amount, tax, discount_amount, final_amount, bill_time)
        VALUES (v_bill_id, 
                v_order_id, 
                ROUND(v_amount, 2), 
                ROUND(v_amount * 0.10, 2), -- 10% tax
                0, 
                ROUND(v_amount * 1.10, 2), 
                CURRENT_TIMESTAMP - (random() * 365 || ' days')::INTERVAL);
                
    END LOOP;
    
    RAISE NOTICE 'Successfully inserted 500 orders and bills for Customers 1-500.';
END $$;
