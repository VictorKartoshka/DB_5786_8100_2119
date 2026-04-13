"""
============================================================================
METHOD C: Programmatic Data Generation (Python)
============================================================================
Generates 20,000 RESERVATION and 20,000 LOYALTY_TRANSACTION records
and writes them to 03-bulk-data.sql as bulk INSERT statements.

Usage:
    python generate_data.py

Output:
    init-db/03-bulk-data.sql

Constraints respected:
    RESERVATION:
        - party_size      : 1..20       (CHECK > 0 AND <= 20)
        - datetime         >= created_at (business rule)
        - Customer_ID     : 1..500      (FK range from Mockaroo)
        - status_ID       : 1..5        (reservation-relevant statuses)
    LOYALTY_TRANSACTION:
        - points_change   != 0          (CHECK <> 0)
        - loyalty_ID      : 1..500      (FK range from Mockaroo)
        - reason_id       : 1..8        (FK range from lookup table)
============================================================================
"""

import random
import os
from datetime import datetime, timedelta

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
NUM_RESERVATIONS        = 20_000
NUM_LOYALTY_TRANSACTIONS = 20_000
NUM_CUSTOMERS           = 500      # Mockaroo-generated CUSTOMER range
NUM_LOYALTY_ACCOUNTS    = 500      # Mockaroo-generated LOYALTY range
BATCH_SIZE              = 500      # rows per INSERT statement (performance)
SEED                    = 42       # fixed seed for reproducible output

# Valid FK values (must match Method A lookup inserts)
RESERVATION_STATUS_IDS  = [1, 2, 3, 4, 5]       # Pending → No-Show
WAITLIST_STATUS_IDS     = [6, 7, 8]              # Waiting, Seated, Expired
REASON_IDS              = list(range(1, 9))      # 1..8

# Realistic special-request phrases (None = NULL in SQL)
SPECIAL_REQUESTS = [
    None, None, None, None, None, None, None,    # ~70 % chance of NULL
    'Window seat please',
    'Birthday celebration - cake at dessert',
    'High chair needed for toddler',
    'Severe nut allergy - please inform kitchen',
    'Vegetarian menu preferred',
    'Anniversary dinner - quiet table',
    'Wheelchair accessible seating required',
    'Prefer seating near the bar',
    'Quiet corner table away from entrance',
    'Kosher meal required',
    'Gluten-free options needed',
    'Surprise proposal - help with setup',
    'Large group - may need two adjacent tables',
    'Outdoor seating if weather permits',
]

# Realistic point-change amounts (never zero)
# Positive = earned; Negative = redeemed / penalty
POINT_AMOUNTS = [-200, -150, -100, -75, -50, -25, -10,
                  10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500]


# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------
def random_date(start_year: int, end_year: int) -> datetime:
    """Return a random date between Jan 1 of start_year and Dec 31 of end_year."""
    start = datetime(start_year, 1, 1)
    end   = datetime(end_year, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))


def fmt_date(d: datetime) -> str:
    """Format a datetime as 'YYYY-MM-DD' for SQL."""
    return d.strftime('%Y-%m-%d')


def sql_str(value) -> str:
    """Convert a Python value to a SQL literal (handles NULL and escaping)."""
    if value is None:
        return 'NULL'
    return "'" + str(value).replace("'", "''") + "'"


# ---------------------------------------------------------------------------
# Generators
# ---------------------------------------------------------------------------
def generate_reservations() -> list[str]:
    """
    Generate NUM_RESERVATIONS rows for the RESERVATION table.
    Ensures datetime >= created_at by creating the reservation date first,
    then adding 0-60 days for the actual dining date.
    """
    rows = []
    for i in range(1, NUM_RESERVATIONS + 1):
        # created_at: when the customer booked (2022-2024)
        created_at = random_date(2022, 2024)

        # datetime: the dining date — always >= created_at
        days_ahead = random.randint(0, 60)
        dining_date = created_at + timedelta(days=days_ahead)

        party_size      = random.randint(1, 20)
        special_req     = random.choice(SPECIAL_REQUESTS)
        customer_id     = random.randint(1, NUM_CUSTOMERS)
        status_id       = random.choice(RESERVATION_STATUS_IDS)

        rows.append(
            f"({i}, '{fmt_date(dining_date)}', {party_size}, "
            f"{sql_str(special_req)}, '{fmt_date(created_at)}', "
            f"{customer_id}, {status_id})"
        )
    return rows


def generate_loyalty_transactions() -> list[str]:
    """
    Generate NUM_LOYALTY_TRANSACTIONS rows for the LOYALTY_TRANSACTION table.
    points_change is guaranteed non-zero by drawing from POINT_AMOUNTS.
    """
    rows = []
    for i in range(1, NUM_LOYALTY_TRANSACTIONS + 1):
        points_change = random.choice(POINT_AMOUNTS)
        created_at    = random_date(2022, 2025)
        loyalty_id    = random.randint(1, NUM_LOYALTY_ACCOUNTS)
        reason_id     = random.choice(REASON_IDS)

        rows.append(
            f"({i}, {points_change}, '{fmt_date(created_at)}', "
            f"{loyalty_id}, {reason_id})"
        )
    return rows


# ---------------------------------------------------------------------------
# SQL file writer
# ---------------------------------------------------------------------------
def write_sql(output_path: str) -> None:
    """Write bulk INSERT statements to the output .sql file."""
    random.seed(SEED)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('-- ==========================================================\n')
        f.write('-- METHOD C: Programmatic Bulk Data (auto-generated)\n')
        f.write(f'-- Generated: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}\n')
        f.write(f'-- Seed: {SEED}\n')
        f.write('-- ==========================================================\n\n')

        # ---- RESERVATION (20,000 rows) ------------------------------------
        f.write(f'-- RESERVATION: {NUM_RESERVATIONS:,} records\n')
        f.write('-- Constraint: datetime >= created_at is guaranteed.\n\n')
        reservation_rows = generate_reservations()

        for start in range(0, len(reservation_rows), BATCH_SIZE):
            batch = reservation_rows[start:start + BATCH_SIZE]
            f.write(
                'INSERT INTO RESERVATION '
                '(reservation_ID, datetime, party_size, special_requests, '
                'created_at, Customer_ID, status_ID) VALUES\n'
            )
            f.write(',\n'.join(batch))
            f.write(';\n\n')

        # ---- LOYALTY_TRANSACTION (20,000 rows) ----------------------------
        f.write(f'-- LOYALTY_TRANSACTION: {NUM_LOYALTY_TRANSACTIONS:,} records\n')
        f.write('-- Constraint: points_change <> 0 is guaranteed.\n\n')
        transaction_rows = generate_loyalty_transactions()

        for start in range(0, len(transaction_rows), BATCH_SIZE):
            batch = transaction_rows[start:start + BATCH_SIZE]
            f.write(
                'INSERT INTO LOYALTY_TRANSACTION '
                '(transaction_ID, points_change, created_at, '
                'loyalty_ID, reason_id) VALUES\n'
            )
            f.write(',\n'.join(batch))
            f.write(';\n\n')

    print(f'✅  Generated {output_path}')
    print(f'    → {NUM_RESERVATIONS:,} RESERVATION rows')
    print(f'    → {NUM_LOYALTY_TRANSACTIONS:,} LOYALTY_TRANSACTION rows')


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
if __name__ == '__main__':
    # Output next to this script in the init-db folder
    script_dir  = os.path.dirname(os.path.abspath(__file__))
    output_file = os.path.join(script_dir, '03-bulk-data.sql')
    write_sql(output_file)
