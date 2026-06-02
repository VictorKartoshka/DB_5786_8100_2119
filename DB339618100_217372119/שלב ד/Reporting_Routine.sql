-- Main Program 2: Reporting Routine
DO $$ 
DECLARE
    v_refcursor refcursor;
    v_order_record RECORD;
BEGIN
    RAISE NOTICE 'Starting Customer Report Generation...';
    
    -- Call Procedure 2
    CALL pr_resolve_stale_waitlist();
    RAISE NOTICE 'Stale waitlists resolved.';
    
    -- Architecture Note: Strict transaction boundary maintained for Ref Cursor
    -- Call Function 1
    v_refcursor := fn_get_customer_remote_orders(1);
    
    RAISE NOTICE 'Remote Orders for Customer 1:';
    LOOP
        FETCH v_refcursor INTO v_order_record;
        EXIT WHEN NOT FOUND;
        
        RAISE NOTICE 'Order ID: %, Status: %, Final Amount: %', 
                     v_order_record.order_id, 
                     v_order_record.order_status, 
                     v_order_record.final_amount;
    END LOOP;
    
    CLOSE v_refcursor;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Report Generation Failed: %', SQLERRM;
END $$;