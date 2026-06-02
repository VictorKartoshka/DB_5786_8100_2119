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