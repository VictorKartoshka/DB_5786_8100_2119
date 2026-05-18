-- ==============================================================================
-- INTEGRATION SCRIPT (Integrate.sql)
-- Contains all table modifications, schema creations, and FDW links
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- PART 1: Phase 2 - Foreign Data Wrapper Setup 
-- (Run on Customer_DB)
-- ------------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER orders_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'db2', port '5432', dbname 'Orders_db2');

CREATE SCHEMA IF NOT EXISTS remote_orders;

IMPORT FOREIGN SCHEMA public
FROM SERVER orders_server INTO remote_orders;


-- ------------------------------------------------------------------------------
-- PART 2: Phase 3 - Security-First Workflow (Restricted Users)
-- ------------------------------------------------------------------------------

-- Run on Orders_DB (Provider)
CREATE USER customer_team_reader WITH PASSWORD 'reader_pass';
GRANT USAGE ON SCHEMA public TO customer_team_reader;
GRANT SELECT (order_id, table_id, customer_id, order_time, order_status) ON "ORDER" TO customer_team_reader;
GRANT SELECT (bill_id, order_id, final_amount, bill_time) ON bill TO customer_team_reader;

-- Run on Customer_DB (Consumer)
CREATE USER MAPPING FOR "MyUser"
SERVER orders_server
OPTIONS (user 'customer_team_reader', password 'reader_pass');


-- ------------------------------------------------------------------------------
-- PART 3: Phase 4 - Soft Keys and Soft Deletes
-- (Run on Customer_DB)
-- ------------------------------------------------------------------------------

-- Add the deleted_at column to the customer table
ALTER TABLE customer ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP NULL;

-- Create the trigger function to intercept physical DELETE commands
CREATE OR REPLACE FUNCTION soft_delete_customer()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE customer 
    SET deleted_at = CURRENT_TIMESTAMP, is_active = 0 
    WHERE customer_id = OLD.customer_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the customer table to prevent orphans
DROP TRIGGER IF EXISTS trigger_soft_delete_customer ON customer;
CREATE TRIGGER trigger_soft_delete_customer
BEFORE DELETE ON customer
FOR EACH ROW EXECUTE FUNCTION soft_delete_customer();
