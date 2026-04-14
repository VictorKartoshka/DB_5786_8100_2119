/* ===================================================================
   LUXE DINE — Phase 2: Constraints (שלב ב)
   ===================================================================
   This file contains ALTER TABLE statements to add or modify
   constraints discovered during the query-writing phase.
   
   Run these AFTER the initial schema (01-create-tables.sql) has been
   applied. These constraints improve data integrity for the queries.
   =================================================================== */


/* -------------------------------------------------------------------
   CONSTRAINT 1: Ensure reservation date is not in the past
   -------------------------------------------------------------------
   Business Rule: Customers should not be able to book a reservation
   for a date that has already passed. This is enforced at the DB level
   in addition to any front-end validation on the Reservation Screen.
   ------------------------------------------------------------------- */

ALTER TABLE RESERVATION
ADD CONSTRAINT chk_reservation_future_date
CHECK (datetime >= created_at);


/* -------------------------------------------------------------------
   CONSTRAINT 2: Ensure feedback date is on or after reservation date
   -------------------------------------------------------------------
   Business Rule: A customer cannot submit feedback before the
   reservation actually takes place. The feedback_date must be on
   or after the reservation's scheduled datetime.
   ------------------------------------------------------------------- */

-- This requires a trigger or application-level check since it spans
-- two tables. We enforce it as a comment-documented business rule:
-- FEEDBACK.feedback_date >= RESERVATION.datetime (enforced in app layer)

-- However, we CAN add a constraint that feedback_date is not in the future:
-- (Removed: since dates in our seed data extend to 2025, this would 
--  conflict. Keeping as documentation only.)


/* -------------------------------------------------------------------
   CONSTRAINT 3: Add an index on RESERVATION.Customer_ID for faster JOINs
   -------------------------------------------------------------------
   Performance: Many of our SELECT queries join RESERVATION to CUSTOMER.
   An index on Customer_ID speeds up these lookups significantly.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_reservation_customer
ON RESERVATION (Customer_ID);


/* -------------------------------------------------------------------
   CONSTRAINT 4: Add an index on RESERVATION.datetime for date queries
   -------------------------------------------------------------------
   Performance: Queries S1, S6, S8, U2 all filter or group by
   reservation datetime. An index improves GROUP BY and range scans.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_reservation_datetime
ON RESERVATION (datetime);


/* -------------------------------------------------------------------
   CONSTRAINT 5: Add an index on FEEDBACK.reservation_ID for JOINs
   -------------------------------------------------------------------
   Performance: Query S6 uses LEFT JOIN on FEEDBACK.reservation_ID.
   While it has a UNIQUE constraint (which creates an index), this
   is documented here for clarity.
   ------------------------------------------------------------------- */

-- Already covered by UNIQUE constraint on reservation_ID in FEEDBACK.
-- No additional index needed.


/* -------------------------------------------------------------------
   CONSTRAINT 6: Add an index on LOYALTY_TRANSACTION for date queries
   -------------------------------------------------------------------
   Performance: Query S4 groups by EXTRACT(YEAR/QUARTER) from created_at.
   An index on created_at speeds up the date-based aggregation.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_loyalty_txn_created
ON LOYALTY_TRANSACTION (created_at);


/* -------------------------------------------------------------------
   CONSTRAINT 7: Add an index on WAITLIST for date-based filtering
   -------------------------------------------------------------------
   Performance: Query S3 filters waitlist by request_time year >= 2024.
   ------------------------------------------------------------------- */

CREATE INDEX IF NOT EXISTS idx_waitlist_request_time
ON WAITLIST (request_time);
