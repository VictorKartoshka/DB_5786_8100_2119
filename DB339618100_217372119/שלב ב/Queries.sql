/* ===================================================================
   LUXE DINE — Phase 2: Database Queries (שלב ב)
   ===================================================================
   Restaurant: Integrated Restaurant Reservation & Loyalty Management
   
   Contents:
     - 8 SELECT queries (S1–S8), 4 of which have dual forms (A/B)
     - 3 DELETE queries (D1–D3)
     - 3 UPDATE queries (U1–U3)
   =================================================================== */


/* ===================================================================
   S1 — RESERVATION SCREEN: Monthly Reservation Volume Report
   ===================================================================
   GUI Screen: Reservation Management / Admin Dashboard
   Purpose: Shows total reservations per month per year, with average
            party size and total guests. Helps management plan staffing.
   Complexity: JOIN, GROUP BY, EXTRACT (year + month), ORDER BY
   =================================================================== */

-- ~~~ Form A: JOIN with GROUP BY (more efficient) ~~~
-- Efficiency: Single pass through RESERVATION joined to STATUS_TYPE.
--   The database engine performs one scan and aggregates in-place.

SELECT
    EXTRACT(YEAR FROM r.datetime)   AS reservation_year,
    EXTRACT(MONTH FROM r.datetime)  AS reservation_month,
    COUNT(*)                        AS total_reservations,
    ROUND(AVG(r.party_size), 1)     AS avg_party_size,
    SUM(r.party_size)               AS total_guests,
    COUNT(CASE WHEN st.description = 'Completed' THEN 1 END) AS completed_count,
    COUNT(CASE WHEN st.description = 'Cancelled' THEN 1 END) AS cancelled_count,
    COUNT(CASE WHEN st.description = 'No-Show'   THEN 1 END) AS noshow_count
FROM RESERVATION r
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
GROUP BY
    EXTRACT(YEAR FROM r.datetime),
    EXTRACT(MONTH FROM r.datetime)
ORDER BY reservation_year DESC, reservation_month DESC;


-- ~~~ Form B: Subqueries in SELECT (less efficient) ~~~
-- Efficiency: For each (year, month) group, a correlated subquery must
--   re-scan the RESERVATION table. This results in N separate scans
--   (one per distinct month) compared to Form A's single pass.

SELECT
    r_agg.reservation_year,
    r_agg.reservation_month,
    r_agg.total_reservations,
    r_agg.avg_party_size,
    r_agg.total_guests,
    (SELECT COUNT(*)
     FROM RESERVATION r2
     WHERE r2.status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Completed')
       AND EXTRACT(YEAR FROM r2.datetime)  = r_agg.reservation_year
       AND EXTRACT(MONTH FROM r2.datetime) = r_agg.reservation_month
    ) AS completed_count,
    (SELECT COUNT(*)
     FROM RESERVATION r2
     WHERE r2.status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Cancelled')
       AND EXTRACT(YEAR FROM r2.datetime)  = r_agg.reservation_year
       AND EXTRACT(MONTH FROM r2.datetime) = r_agg.reservation_month
    ) AS cancelled_count
FROM (
    SELECT
        EXTRACT(YEAR FROM r.datetime)   AS reservation_year,
        EXTRACT(MONTH FROM r.datetime)  AS reservation_month,
        COUNT(*)                        AS total_reservations,
        ROUND(AVG(r.party_size), 1)     AS avg_party_size,
        SUM(r.party_size)               AS total_guests
    FROM RESERVATION r
    GROUP BY
        EXTRACT(YEAR FROM r.datetime),
        EXTRACT(MONTH FROM r.datetime)
) r_agg
ORDER BY reservation_year DESC, reservation_month DESC;


/* ===================================================================
   S2 — LOYALTY SCREEN: Top 10 Customers by Reservations + Loyalty
   ===================================================================
   GUI Screen: Loyalty Dashboard ("Hello, [Customer Name]!")
   Purpose: Identifies the most active customers with their reservation
            count, average feedback rating, loyalty points, and tier.
            This powers the loyalty screen greeting and tier display.
   Complexity: Multi-table JOIN (5 tables), GROUP BY, ORDER BY, LIMIT,
               aggregate functions (COUNT, AVG, COALESCE)
   =================================================================== */

-- ~~~ Form A: JOIN-based (more efficient) ~~~
-- Efficiency: A single query plan that joins all tables once. The query
--   optimizer can use hash joins or merge joins across the tables.

SELECT
    c.Customer_ID,
    c.first_name || ' ' || c.last_name    AS full_name,
    c.email,
    COUNT(DISTINCT r.reservation_ID)       AS total_reservations,
    COALESCE(ROUND(AVG(f.rating), 2), 0)   AS avg_rating,
    l.points                               AS loyalty_points,
    lt.level                               AS loyalty_tier
FROM CUSTOMER c
JOIN RESERVATION r   ON c.Customer_ID = r.Customer_ID
LEFT JOIN FEEDBACK f ON r.reservation_ID = f.reservation_ID
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.is_active = 1
GROUP BY c.Customer_ID, c.first_name, c.last_name, c.email,
         l.points, lt.level
ORDER BY total_reservations DESC, avg_rating DESC
LIMIT 10;


-- ~~~ Form B: Correlated subqueries (less efficient) ~~~
-- Efficiency: For each customer row, the database runs 2 separate
--   correlated subqueries (reservation count + avg rating), each
--   scanning RESERVATION and FEEDBACK independently. With 500 customers,
--   this can mean ~1000 extra sub-scans compared to Form A's single join.

SELECT
    c.Customer_ID,
    c.first_name || ' ' || c.last_name    AS full_name,
    c.email,
    (SELECT COUNT(*)
     FROM RESERVATION r
     WHERE r.Customer_ID = c.Customer_ID
    ) AS total_reservations,
    COALESCE(
      (SELECT ROUND(AVG(f.rating), 2)
       FROM FEEDBACK f
       JOIN RESERVATION r ON f.reservation_ID = r.reservation_ID
       WHERE r.Customer_ID = c.Customer_ID
      ), 0
    ) AS avg_rating,
    l.points           AS loyalty_points,
    lt.level           AS loyalty_tier
FROM CUSTOMER c
JOIN LOYALTY l       ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE c.is_active = 1
ORDER BY total_reservations DESC, avg_rating DESC
LIMIT 10;


/* ===================================================================
   S3 — WAITLIST SCREEN: Active Waitlist with Customer Details
   ===================================================================
   GUI Screen: Waitlist Management (position, name, time, est. wait, status)
   Purpose: Powers the waitlist management table. Shows customers
            currently on the waitlist who also have a loyalty account,
            sorted by request time.
   Complexity: Multi-table JOIN (4 tables), WHERE with IN subquery,
               date filtering with EXTRACT, ORDER BY
   =================================================================== */

-- ~~~ Form A: Using IN subquery (more readable) ~~~
-- Efficiency: The IN subquery materializes the list of active Customer_IDs
--   first, then the outer query filters against it. The optimizer may
--   convert this to a semi-join internally.

SELECT
    w.waitlist_ID                        AS position,
    c.first_name || ' ' || c.last_name   AS customer_name,
    w.party_size,
    w.request_time                       AS time_joined,
    w.est_wait_time                      AS est_wait_min,
    st.description                       AS status,
    COALESCE(lt.level, 'No Loyalty')     AS loyalty_tier
FROM WAITLIST w
JOIN CUSTOMER c    ON w.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON w.status_ID = st.status_ID
LEFT JOIN LOYALTY l  ON c.Customer_ID = l.Customer_ID
LEFT JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE w.Customer_ID IN (
    SELECT Customer_ID FROM CUSTOMER WHERE is_active = 1
)
AND EXTRACT(YEAR FROM w.request_time) >= 2024
ORDER BY w.request_time ASC;


-- ~~~ Form B: Using EXISTS (more efficient for large datasets) ~~~
-- Efficiency: EXISTS short-circuits — it stops scanning the inner query
--   as soon as it finds a match for the current row, while IN must
--   fully materialize the subquery result set first.

SELECT
    w.waitlist_ID                        AS position,
    c.first_name || ' ' || c.last_name   AS customer_name,
    w.party_size,
    w.request_time                       AS time_joined,
    w.est_wait_time                      AS est_wait_min,
    st.description                       AS status,
    COALESCE(lt.level, 'No Loyalty')     AS loyalty_tier
FROM WAITLIST w
JOIN CUSTOMER c    ON w.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON w.status_ID = st.status_ID
LEFT JOIN LOYALTY l  ON c.Customer_ID = l.Customer_ID
LEFT JOIN LOYALTY_TIER lt ON l.tier_id = lt.tier_id
WHERE EXISTS (
    SELECT 1 FROM CUSTOMER c2
    WHERE c2.Customer_ID = w.Customer_ID AND c2.is_active = 1
)
AND EXTRACT(YEAR FROM w.request_time) >= 2024
ORDER BY w.request_time ASC;


/* ===================================================================
   S4 — LOYALTY SCREEN: Points Activity by Reason and Quarter
   ===================================================================
   GUI Screen: Loyalty Dashboard ("Recent Transactions" panel)
   Purpose: Breaks down loyalty point transactions by reason and
            calendar quarter, showing totals and transaction counts.
            Uses date decomposition (EXTRACT YEAR + QUARTER).
   Complexity: Multi-table JOIN, GROUP BY with EXTRACT, HAVING,
               ORDER BY, aggregate functions
   =================================================================== */

-- ~~~ Form A: JOIN with GROUP BY (more efficient) ~~~
-- Efficiency: Single scan through LOYALTY_TRANSACTION joined to REASON
--   and LOYALTY. The database groups and aggregates in one pass.

SELECT
    EXTRACT(YEAR FROM lt.created_at)      AS transaction_year,
    EXTRACT(QUARTER FROM lt.created_at)   AS transaction_quarter,
    rn.description                        AS reason,
    COUNT(*)                              AS transaction_count,
    SUM(lt.points_change)                 AS total_points,
    ROUND(AVG(lt.points_change), 1)       AS avg_points_per_txn
FROM LOYALTY_TRANSACTION lt
JOIN REASON rn  ON lt.reason_id = rn.reason_id
JOIN LOYALTY l  ON lt.loyalty_ID = l.loyalty_ID
GROUP BY
    EXTRACT(YEAR FROM lt.created_at),
    EXTRACT(QUARTER FROM lt.created_at),
    rn.description
HAVING COUNT(*) > 5
ORDER BY transaction_year DESC, transaction_quarter DESC, total_points DESC;


-- ~~~ Form B: Nested subquery with WHERE IN (less efficient) ~~~
-- Efficiency: The subquery first filters LOYALTY_TRANSACTION by reason
--   name (requiring a JOIN to REASON), then the outer query re-scans
--   and aggregates. This two-pass approach is slower than Form A's
--   single-pass join.

SELECT
    EXTRACT(YEAR FROM lt.created_at)      AS transaction_year,
    EXTRACT(QUARTER FROM lt.created_at)   AS transaction_quarter,
    (SELECT rn.description FROM REASON rn WHERE rn.reason_id = lt.reason_id) AS reason,
    COUNT(*)                              AS transaction_count,
    SUM(lt.points_change)                 AS total_points,
    ROUND(AVG(lt.points_change), 1)       AS avg_points_per_txn
FROM LOYALTY_TRANSACTION lt
WHERE lt.reason_id IN (
    SELECT reason_id FROM REASON
)
GROUP BY
    EXTRACT(YEAR FROM lt.created_at),
    EXTRACT(QUARTER FROM lt.created_at),
    lt.reason_id
HAVING COUNT(*) > 5
ORDER BY transaction_year DESC, transaction_quarter DESC, total_points DESC;


/* ===================================================================
   S5 — FEEDBACK SCREEN: Average Rating by Day of Week
   ===================================================================
   GUI Screen: Feedback / Operations Dashboard
   Purpose: Shows which days of the week get the best and worst
            customer ratings, helping optimize staffing and service.
   Complexity: Multi-table JOIN (3 tables), EXTRACT(DOW), GROUP BY,
               CASE expression for day names, ORDER BY, aggregate
   =================================================================== */

SELECT
    CASE EXTRACT(DOW FROM r.datetime)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END                                   AS day_of_week,
    COUNT(f.feedback_ID)                  AS total_reviews,
    ROUND(AVG(f.rating), 2)              AS avg_rating,
    MIN(f.rating)                         AS lowest_rating,
    MAX(f.rating)                         AS highest_rating,
    COUNT(CASE WHEN f.rating >= 4 THEN 1 END) AS positive_reviews,
    COUNT(CASE WHEN f.rating <= 2 THEN 1 END) AS negative_reviews
FROM FEEDBACK f
JOIN RESERVATION r ON f.reservation_ID = r.reservation_ID
JOIN CUSTOMER c    ON r.Customer_ID = c.Customer_ID
GROUP BY EXTRACT(DOW FROM r.datetime)
ORDER BY avg_rating DESC;


/* ===================================================================
   S6 — FEEDBACK SCREEN: Completed Reservations Without Feedback
   ===================================================================
   GUI Screen: Follow-up Actions / Feedback Collection
   Purpose: Identifies completed reservations that have no feedback,
            so staff can send follow-up emails requesting reviews.
   Complexity: LEFT JOIN with IS NULL, multi-table JOIN, date filtering,
               ORDER BY with EXTRACT
   =================================================================== */

SELECT
    r.reservation_ID,
    c.first_name || ' ' || c.last_name    AS customer_name,
    c.email,
    r.datetime                            AS reservation_date,
    EXTRACT(MONTH FROM r.datetime)        AS reservation_month,
    EXTRACT(YEAR FROM r.datetime)         AS reservation_year,
    r.party_size,
    st.description                        AS status
FROM RESERVATION r
JOIN CUSTOMER c     ON r.Customer_ID = c.Customer_ID
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
LEFT JOIN FEEDBACK f ON r.reservation_ID = f.reservation_ID
WHERE f.feedback_ID IS NULL
  AND st.description = 'Completed'
ORDER BY r.datetime DESC
LIMIT 50;


/* ===================================================================
   S7 — LOYALTY SCREEN: Customer Full Profile with Loyalty Transactions
   ===================================================================
   GUI Screen: Loyalty Dashboard ("Recent Transactions" list)
   Purpose: For a given customer, shows their recent loyalty
            transactions with reason, date breakdown, and running context.
            This directly powers the "Recent Transactions" panel.
   Complexity: Multi-table JOIN (5 tables), EXTRACT (year, month, day),
               subquery for points-to-next-tier, ORDER BY, LIMIT
   =================================================================== */

SELECT
    c.first_name || ' ' || c.last_name              AS customer_name,
    lt_tier.level                                    AS current_tier,
    l.points                                         AS current_points,
    CASE
        WHEN lt_tier.level = 'Bronze'   THEN 2501 - l.points
        WHEN lt_tier.level = 'Silver'   THEN 5001 - l.points
        WHEN lt_tier.level = 'Gold'     THEN 7501 - l.points
        WHEN lt_tier.level = 'Platinum' THEN 0
    END                                              AS points_to_next_tier,
    rn.description                                   AS transaction_reason,
    lt_txn.points_change,
    EXTRACT(DAY FROM lt_txn.created_at)              AS txn_day,
    EXTRACT(MONTH FROM lt_txn.created_at)            AS txn_month,
    EXTRACT(YEAR FROM lt_txn.created_at)             AS txn_year
FROM CUSTOMER c
JOIN LOYALTY l           ON c.Customer_ID = l.Customer_ID
JOIN LOYALTY_TIER lt_tier ON l.tier_id = lt_tier.tier_id
JOIN LOYALTY_TRANSACTION lt_txn ON l.loyalty_ID = lt_txn.loyalty_ID
JOIN REASON rn           ON lt_txn.reason_id = rn.reason_id
WHERE c.Customer_ID = 1
ORDER BY lt_txn.created_at DESC
LIMIT 20;


/* ===================================================================
   S8 — RESERVATION SCREEN: Busiest Months Ranked (Seasonal Trends)
   ===================================================================
   GUI Screen: Admin Dashboard / Planning & Forecasting
   Purpose: Ranks months by total guests served across all years,
            revealing seasonal patterns for capacity planning.
   Complexity: EXTRACT (year + month), GROUP BY, window function RANK(),
               ORDER BY, aggregate functions
   =================================================================== */

SELECT
    EXTRACT(YEAR FROM r.datetime)            AS res_year,
    EXTRACT(MONTH FROM r.datetime)           AS res_month,
    COUNT(r.reservation_ID)                  AS total_reservations,
    SUM(r.party_size)                        AS total_guests,
    ROUND(AVG(r.party_size), 1)              AS avg_party_size,
    RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM r.datetime)
        ORDER BY SUM(r.party_size) DESC
    )                                        AS month_rank_by_guests
FROM RESERVATION r
JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
WHERE st.description IN ('Confirmed', 'Completed')
GROUP BY
    EXTRACT(YEAR FROM r.datetime),
    EXTRACT(MONTH FROM r.datetime)
ORDER BY res_year DESC, month_rank_by_guests ASC;


/* ===================================================================
              D E L E T E   Q U E R I E S  (3)
   =================================================================== */


/* ===================================================================
   D1 — Delete Expired Waitlist Entries Older Than 1 Year
   ===================================================================
   GUI Screen: Waitlist Management (cleanup)
   Purpose: Removes stale waitlist records with 'Expired' status that
            are over 1 year old. Keeps the waitlist table lean.
   =================================================================== */

DELETE FROM WAITLIST
WHERE status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Expired')
  AND request_time < CURRENT_DATE - INTERVAL '1 year';


/* ===================================================================
   D2 — Delete Cancelled Reservations Older Than 2 Years
   ===================================================================
   GUI Screen: Reservation Management (data retention)
   Purpose: First deletes any feedback linked to cancelled reservations
            older than 2 years, then deletes the reservations themselves.
            Respects FK constraints by deleting children first.
   =================================================================== */

-- Step 1: Delete feedback associated with old cancelled reservations
DELETE FROM FEEDBACK
WHERE reservation_ID IN (
    SELECT r.reservation_ID
    FROM RESERVATION r
    JOIN STATUS_TYPE st ON r.status_ID = st.status_ID
    WHERE st.description = 'Cancelled'
      AND r.datetime < CURRENT_DATE - INTERVAL '2 years'
);

-- Step 2: Delete the old cancelled reservations themselves
DELETE FROM RESERVATION
WHERE status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Cancelled')
  AND datetime < CURRENT_DATE - INTERVAL '2 years';


/* ===================================================================
   D3 — Delete Loyalty Transactions for Deactivated Zero-Point Customers
   ===================================================================
   GUI Screen: Loyalty Management (cleanup)
   Purpose: Removes loyalty transaction records for customers who have
            been deactivated (is_active = 0) AND have zero points.
            These records are no longer actionable.
   =================================================================== */

DELETE FROM LOYALTY_TRANSACTION
WHERE loyalty_ID IN (
    SELECT l.loyalty_ID
    FROM LOYALTY l
    JOIN CUSTOMER c ON l.Customer_ID = c.Customer_ID
    WHERE c.is_active = 0
      AND l.points = 0
);


/* ===================================================================
              U P D A T E   Q U E R I E S  (3)
   =================================================================== */


/* ===================================================================
   U1 — Auto-Upgrade Loyalty Tier Based on Current Points
   ===================================================================
   GUI Screen: Loyalty Dashboard (tier display & progress bar)
   Purpose: Automatically adjusts each customer's loyalty tier based on
            their current point balance:
              Bronze:   0 – 2500
              Silver:   2501 – 5000
              Gold:     5001 – 7500
              Platinum: 7501+
   =================================================================== */

UPDATE LOYALTY
SET tier_id = CASE
    WHEN points <= 2500 THEN (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Bronze')
    WHEN points <= 5000 THEN (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Silver')
    WHEN points <= 7500 THEN (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Gold')
    ELSE                     (SELECT tier_id FROM LOYALTY_TIER WHERE level = 'Platinum')
END,
last_Updated = CURRENT_DATE;


/* ===================================================================
   U2 — Mark Past Confirmed Reservations as Completed
   ===================================================================
   GUI Screen: Reservation Management (status auto-update)
   Purpose: Automatically updates reservations whose date has passed
            and are still marked 'Confirmed' to 'Completed'.
   =================================================================== */

UPDATE RESERVATION
SET status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Completed')
WHERE datetime < CURRENT_DATE
  AND status_ID = (SELECT status_ID FROM STATUS_TYPE WHERE description = 'Confirmed');


/* ===================================================================
   U3 — Deactivate Dormant Customers (No Reservation in 2+ Years)
   ===================================================================
   GUI Screen: Customer Management (retention cleanup)
   Purpose: Sets is_active = 0 for customers who haven't made a
            reservation in over 2 years. Uses a NOT EXISTS subquery
            to check for recent activity.
   =================================================================== */

UPDATE CUSTOMER
SET is_active = 0
WHERE is_active = 1
  AND NOT EXISTS (
    SELECT 1
    FROM RESERVATION r
    WHERE r.Customer_ID = CUSTOMER.Customer_ID
      AND r.datetime >= CURRENT_DATE - INTERVAL '2 years'
  );
