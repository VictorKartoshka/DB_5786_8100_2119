/* ===========================================================================
   DROP TABLES — Reverse Dependency Order
   ===========================================================================
   Foreign key constraints prevent dropping a parent table while a child
   table still references it. Therefore we must drop tables from the
   outermost leaves of the dependency tree inward toward the roots.

   Dependency graph (child → parent):
   ───────────────────────────────────
     FEEDBACK            → RESERVATION
     LOYALTY_TRANSACTION → LOYALTY, REASON
     WAITLIST             → CUSTOMER, STATUS_TYPE
     RESERVATION          → CUSTOMER, STATUS_TYPE
     LOYALTY              → CUSTOMER, LOYALTY_TIER
   ───────────────────────────────────

   Drop order rationale:
     Layer 1 – Leaf tables (no other table depends on them):
              FEEDBACK, LOYALTY_TRANSACTION, WAITLIST
     Layer 2 – Mid-level tables (only Layer 1 depended on them):
              RESERVATION, LOYALTY, REASON
     Layer 3 – Root / lookup tables (only Layer 2 depended on them):
              LOYALTY_TIER, STATUS_TYPE, CUSTOMER
=========================================================================== */

-- Layer 1: Leaf tables — nothing references these, safe to drop first.
DROP TABLE IF EXISTS FEEDBACK;
DROP TABLE IF EXISTS LOYALTY_TRANSACTION;
DROP TABLE IF EXISTS WAITLIST;

-- Layer 2: Mid-level tables — referenced only by the tables dropped above.
DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS LOYALTY;
DROP TABLE IF EXISTS REASON;

-- Layer 3: Root / lookup tables — referenced only by the tables dropped above.
DROP TABLE IF EXISTS LOYALTY_TIER;
DROP TABLE IF EXISTS STATUS_TYPE;
DROP TABLE IF EXISTS CUSTOMER;
