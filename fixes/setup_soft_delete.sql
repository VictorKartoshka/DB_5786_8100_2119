-- Implement Soft Deletes for the Customer DB

-- 1. Add the deleted_at column to track soft deletions
ALTER TABLE customer ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;

-- 2. Create the trigger function to intercept physical DELETE commands
CREATE OR REPLACE FUNCTION soft_delete_customer()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the record instead of deleting it
    UPDATE customer 
    SET deleted_at = CURRENT_TIMESTAMP, is_active = 0 
    WHERE customer_id = OLD.customer_id;
    
    -- Return NULL to cancel the actual physical DELETE operation
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 3. Attach the trigger to the customer table
DROP TRIGGER IF EXISTS trigger_soft_delete_customer ON customer;
CREATE TRIGGER trigger_soft_delete_customer
BEFORE DELETE ON customer
FOR EACH ROW EXECUTE FUNCTION soft_delete_customer();
