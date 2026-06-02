-- ==============================================================================
-- PHASE 4: PL/pgSQL Programming 
-- Contains 2 Functions, 2 Procedures, 2 Triggers, and 2 Main Programs
-- Incorporates explicit/implicit cursors, ref cursors, loops, exceptions, etc.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. FUNCTIONS
-- ------------------------------------------------------------------------------

-- Function 1: Returns a Ref Cursor containing a customer's cross-database orders
CREATE OR REPLACE FUNCTION fn_get_customer_remote_orders(p_customer_id INT)
RETURNS refcursor AS $$
DECLARE
    rc_orders refcursor;
    v_cust_exists INT;
BEGIN
    -- Implicit cursor to verify customer existence
    SELECT COUNT(*) INTO v_cust_exists FROM customer WHERE customer_id = p_customer_id;
    
    IF v_cust_exists = 0 THEN
        RAISE EXCEPTION 'Customer ID % does not exist in the local database.', p_customer_id;
    END IF;

    -- Open the ref cursor for the remote orders
    OPEN rc_orders FOR 
        SELECT o.order_id, o.order_time, o.order_status, b.final_amount
        FROM remote_orders."ORDER" o
        JOIN remote_orders.bill b ON o.order_id = b.order_id
        WHERE o.customer_id = p_customer_id;
        
    RETURN rc_orders;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred fetching remote orders: %', SQLERRM;
        -- Return an unbound cursor in case of failure to prevent crashes
        RETURN rc_orders; 
END;
$$ LANGUAGE plpgsql;

-- Function 2: Calculates average feedback score using a Parameterized Explicit Cursor
CREATE OR REPLACE FUNCTION fn_calculate_avg_feedback_score(p_customer_id INT)
RETURNS NUMERIC AS $$
DECLARE
    -- Parameterized explicit cursor to instantly isolate rows
    c_feedback CURSOR (cp_cust_id INT) FOR 
        SELECT f.rating 
        FROM feedback f
        JOIN reservation r ON f.reservation_id = r.reservation_id
        WHERE r.customer_id = cp_cust_id;
        
    v_feedback_row RECORD;
    v_total_score  NUMERIC := 0;
    v_count        INT := 0;
BEGIN
    OPEN c_feedback(p_customer_id);
    
    LOOP
        FETCH c_feedback INTO v_feedback_row;
        EXIT WHEN NOT FOUND;
        
        v_total_score := v_total_score + v_feedback_row.rating;
        v_count := v_count + 1;
    END LOOP;
    
    CLOSE c_feedback;
    
    IF v_count > 0 THEN
        RETURN ROUND(v_total_score / v_count, 2);
    ELSE
        RETURN 0.00;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred calculating the feedback score for customer %: %', p_customer_id, SQLERRM;
        RETURN 0.00;
END;
$$ LANGUAGE plpgsql;


-- ------------------------------------------------------------------------------
-- 2. PROCEDURES
-- ------------------------------------------------------------------------------

-- Procedure 1: Batch process to update loyalty rewards for highly active customers
CREATE OR REPLACE PROCEDURE pr_process_loyalty_rewards()
LANGUAGE plpgsql AS $$
DECLARE
    c_customers CURSOR FOR 
        SELECT c.customer_id, l.loyalty_id, l.points, COUNT(r.reservation_id) as res_count
        FROM customer c
        JOIN loyalty l ON c.customer_id = l.customer_id
        JOIN reservation r ON c.customer_id = r.customer_id
        WHERE c.is_active = 1
        GROUP BY c.customer_id, l.loyalty_id, l.points;
        
    v_cust RECORD;
    v_reward_points INT := 100;
    v_next_txn_id INT;
BEGIN
    FOR v_cust IN c_customers LOOP
        -- Branching logic: Reward if they have > 3 reservations but low points
        IF v_cust.res_count > 3 AND v_cust.points < 500 THEN
            
            -- DML 1: Update points
            UPDATE loyalty 
            SET points = points + v_reward_points 
            WHERE loyalty_id = v_cust.loyalty_id;
            
            -- Generate next transaction ID
            SELECT COALESCE(MAX(transaction_id), 0) + 1 INTO v_next_txn_id FROM loyalty_transaction;
            
            -- DML 2: Record the transaction
            INSERT INTO loyalty_transaction (transaction_id, loyalty_id, reason_id, points_change, created_at)
            VALUES (v_next_txn_id, v_cust.loyalty_id, (SELECT reason_id FROM reason WHERE description = 'Promotional Offer'), v_reward_points, CURRENT_TIMESTAMP);
            
        END IF;
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Failed to process loyalty rewards: %', SQLERRM;
END;
$$;


-- Procedure 2: Resolves stale waitlist entries
CREATE OR REPLACE PROCEDURE pr_resolve_stale_waitlist()
LANGUAGE plpgsql AS $$
DECLARE
    v_waitlist_row RECORD;
    v_expired_status INT;
    v_waiting_status INT;
BEGIN
    SELECT status_id INTO v_expired_status FROM status_type WHERE description = 'Expired';
    SELECT status_id INTO v_waiting_status FROM status_type WHERE description = 'Waiting';

    -- Loop using implicit cursor query
    FOR v_waitlist_row IN 
        SELECT waitlist_id, customer_id, request_time 
        FROM waitlist 
        WHERE status_id = v_waiting_status 
          AND request_time < CURRENT_TIMESTAMP - INTERVAL '2 hours'
    LOOP
        -- DML Update
        UPDATE waitlist 
        SET status_id = v_expired_status 
        WHERE waitlist_id = v_waitlist_row.waitlist_id;
        
        -- DML Compensate Customer
        UPDATE loyalty 
        SET points = points + 50 
        WHERE customer_id = v_waitlist_row.customer_id;
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error resolving stale waitlists: %', SQLERRM;
END;
$$;


-- ------------------------------------------------------------------------------
-- 3. TRIGGERS
-- ------------------------------------------------------------------------------

-- Trigger 1: AFTER UPDATE on reservation
CREATE OR REPLACE FUNCTION trgf_after_reservation_update()
RETURNS TRIGGER AS $$
DECLARE
    v_confirmed_id INT;
    v_completed_id INT;
    v_loyalty_id INT;
BEGIN
    SELECT status_id INTO v_confirmed_id FROM status_type WHERE description = 'Confirmed';
    SELECT status_id INTO v_completed_id FROM status_type WHERE description = 'Completed';

    -- Branching checking OLD and NEW states
    IF OLD.status_id = v_confirmed_id AND NEW.status_id = v_completed_id THEN
        
        SELECT loyalty_id INTO v_loyalty_id FROM loyalty WHERE customer_id = NEW.customer_id;
        
        IF FOUND THEN
            -- DML Update
            UPDATE loyalty 
            SET points = points + (NEW.party_size * 10)
            WHERE loyalty_id = v_loyalty_id;
        END IF;
        
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_after_reservation_update ON reservation;
CREATE TRIGGER trg_after_reservation_update
AFTER UPDATE ON reservation
FOR EACH ROW EXECUTE FUNCTION trgf_after_reservation_update();


-- Trigger 2: BEFORE INSERT on feedback
CREATE OR REPLACE FUNCTION trgf_prevent_duplicate_feedback()
RETURNS TRIGGER AS $$
DECLARE
    v_exists INT;
BEGIN
    SELECT COUNT(*) INTO v_exists 
    FROM feedback 
    WHERE reservation_id = NEW.reservation_id;
    
    IF v_exists > 0 THEN
        -- Fails fast before disk writes
        RAISE EXCEPTION 'A feedback record already exists for reservation %.', NEW.reservation_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_prevent_duplicate_feedback ON feedback;
CREATE TRIGGER trg_prevent_duplicate_feedback
BEFORE INSERT ON feedback
FOR EACH ROW EXECUTE FUNCTION trgf_prevent_duplicate_feedback();


-- ------------------------------------------------------------------------------
-- 4. MAIN PROGRAMS
-- ------------------------------------------------------------------------------

-- Main Program 1: Maintenance Routine
DO $$ 
DECLARE
    v_avg_score NUMERIC;
BEGIN
    RAISE NOTICE 'Starting Daily Maintenance Job...';
    
    -- Call Function 2
    v_avg_score := fn_calculate_avg_feedback_score(1);
    RAISE NOTICE 'Customer 1 Avg Feedback Score: %', v_avg_score;
    
    -- Call Procedure 1
    CALL pr_process_loyalty_rewards();
    RAISE NOTICE 'Loyalty rewards processed successfully.';
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Maintenance Job Failed: %', SQLERRM;
END $$;


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
