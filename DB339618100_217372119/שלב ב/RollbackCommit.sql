/* ===================================================================
   LUXE DINE — Phase 2: Rollback & Commit Demonstration (שלב ב)
   ===================================================================
   This file demonstrates transaction control in PostgreSQL.
   
   Demo 1: UPDATE → show change → ROLLBACK → show restored state
   Demo 2: UPDATE → show change → COMMIT  → show persisted state
   
   IMPORTANT: Run each demo block separately in pgAdmin or psql.
   Do NOT run the entire file at once.
   =================================================================== */


/* ===================================================================
   DEMO 1: ROLLBACK — Update loyalty points, then undo the change
   ===================================================================
   Scenario: An admin accidentally adds 9999 points to Customer 1's
   loyalty account. We show the change, then ROLLBACK to undo it.
   =================================================================== */

-- Step 1: Show the BEFORE state
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    l.points,
    lt.level AS tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.Customer_ID = 1;

-- Step 2: Begin a transaction
BEGIN;

-- Step 3: Perform the UPDATE (accidental over-credit)
UPDATE LOYALTY
SET points = 9999, last_Updated = CURRENT_DATE
WHERE Customer_ID = 1;

-- Step 4: Show the AFTER state (points should now be 9999)
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    l.points,
    lt.level AS tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.Customer_ID = 1;

-- Step 5: ROLLBACK the transaction (undo the change)
ROLLBACK;

-- Step 6: Show the RESTORED state (points should be back to original)
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    l.points,
    lt.level AS tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.Customer_ID = 1;


/* ===================================================================
   DEMO 2: COMMIT — Update reservation status, then persist the change
   ===================================================================
   Scenario: A host confirms a pending reservation (ID = 1). We update
   the status to 'Confirmed', COMMIT, and verify it sticks.
   =================================================================== */

-- Step 1: Show the BEFORE state
SELECT
    r.reservation_ID,
    c.first_name || ' ' || c.last_name AS customer_name,
    r.datetime,
    r.party_size,
    st.description AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE r.reservation_ID = 1;

-- Step 2: Begin a transaction
BEGIN;

-- Step 3: Perform the UPDATE (confirm the reservation)
UPDATE RESERVATION
SET status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Confirmed')
WHERE reservation_ID = 1;

-- Step 4: Show the AFTER state (status should now be 'Confirmed')
SELECT
    r.reservation_ID,
    c.first_name || ' ' || c.last_name AS customer_name,
    r.datetime,
    r.party_size,
    st.description AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE r.reservation_ID = 1;

-- Step 5: COMMIT the transaction (persist the change)
COMMIT;

-- Step 6: Show the FINAL state (status should STILL be 'Confirmed')
SELECT
    r.reservation_ID,
    c.first_name || ' ' || c.last_name AS customer_name,
    r.datetime,
    r.party_size,
    st.description AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE r.reservation_ID = 1;
