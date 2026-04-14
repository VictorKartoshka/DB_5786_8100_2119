/* ===================================================================
   LUXE DINE — Phase 2: Constraints (שלב ב)
   ===================================================================
   This file contains ALTER TABLE statements to add 3 new business
   rule constraints and 3 performance indexes.
   
   Run these AFTER the initial schema (01-create-tables.sql) has been
   applied. These improve data integrity for the queries.
   =================================================================== */


/* ===================================================================
   C O N S T R A I N T S  (3)
   =================================================================== */

/* -------------------------------------------------------------------
   CONSTRAINT 1: Ensure reservation date is not in the past relative to creation
   -------------------------------------------------------------------
   Business Rule: The scheduled dining time (datetime) must be on or 
   after the time the reservation was actually requested (created_at).
   ------------------------------------------------------------------- */

ALTER TABLE RESERVATION
DROP CONSTRAINT IF EXISTS chk_reservation_future_date;

ALTER TABLE RESERVATION
ADD CONSTRAINT chk_reservation_future_date
CHECK (datetime >= created_at);


/* -------------------------------------------------------------------
   CONSTRAINT 2: Prevent placeholder/junk feedback comments
   -------------------------------------------------------------------
   Business Rule: If a customer leaves a feedback comment, it must be 
   meaningful (at least 4 characters long). "Ok", "No", or random 
   1-letter typos are rejected.
   ------------------------------------------------------------------- */

ALTER TABLE FEEDBACK
DROP CONSTRAINT IF EXISTS chk_meaningful_comment;

ALTER TABLE FEEDBACK
ADD CONSTRAINT chk_meaningful_comment
CHECK (comment IS NULL OR LENGTH(TRIM(comment)) >= 4);


/* -------------------------------------------------------------------
   CONSTRAINT 3: Ensure Customer Names are logical
   -------------------------------------------------------------------
   Business Rule: A customer's first name and last name cannot be 
   exactly identical (e.g., "John John"), which often indicates a 
   data entry error.
   ------------------------------------------------------------------- */

ALTER TABLE CUSTOMER
DROP CONSTRAINT IF EXISTS chk_names_different;

ALTER TABLE CUSTOMER
ADD CONSTRAINT chk_names_different
CHECK (LOWER(first_name) <> LOWER(last_name));


/* ===================================================================
   I N D E X E S  (3)
   =================================================================== */

/* -------------------------------------------------------------------
   INDEX 1: RESERVATION.Customer_ID for faster JOINs
   -------------------------------------------------------------------
   Performance: Many of our SELECT queries join RESERVATION to CUSTOMER.
   An index on Customer_ID speeds up these lookups significantly.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_reservation_customer
ON RESERVATION (Customer_ID);


/* -------------------------------------------------------------------
   INDEX 2: RESERVATION.datetime for date queries
   -------------------------------------------------------------------
   Performance: Queries S1, S6, S8, U2 all filter or group by
   reservation datetime. An index improves GROUP BY and range scans.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_reservation_datetime
ON RESERVATION (datetime);


/* -------------------------------------------------------------------
   INDEX 3: LOYALTY_TRANSACTION.created_at for date queries
   -------------------------------------------------------------------
   Performance: Query S4 groups by EXTRACT(YEAR/QUARTER) from created_at.
   An index on created_at speeds up the date-based aggregation.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_loyalty_txn_created
ON LOYALTY_TRANSACTION (created_at);
