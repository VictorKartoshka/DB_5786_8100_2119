import os
import psycopg2
from psycopg2.pool import SimpleConnectionPool
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    'host': os.environ.get('DB_HOST_SECRET', 'localhost'),
    'port': int(os.environ.get('DB_PORT_SECRET', 5432)),
    'database': os.environ.get('DB_NAME_SECRET', 'DB5786Victor'),
    'user': os.environ.get('DB_USER_SECRET', 'MyUser'),
    'password': os.environ.get('DB_PASSWORD_SECRET', 'password')
}

# Initialize connection pool lazily
db_pool = None

def get_db():
    """Get a connection to Customer_DB from the pool."""
    global db_pool
    if db_pool is None:
        db_pool = SimpleConnectionPool(1, 20, **DB_CONFIG, cursor_factory=RealDictCursor)
    conn = db_pool.getconn()
    conn.autocommit = True
    return conn

def release_db(conn):
    """Release a connection back to the pool."""
    if db_pool:
        db_pool.putconn(conn)
    else:
        conn.close()

def query_db(sql, params=None, fetchone=False):
    """Execute a query and return results."""
    conn = get_db()
    try:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        if cur.description:
            columns = [desc[0] for desc in cur.description]
            if fetchone:
                row = cur.fetchone()
                return dict(row) if row else None, columns
            else:
                rows = [dict(r) for r in cur.fetchall()]
                return rows, columns
        return None, []
    finally:
        db_pool.putconn(conn)

def execute_db(sql, params=None):
    """Execute a statement (INSERT/UPDATE/DELETE) and return success."""
    conn = get_db()
    try:
        cur = conn.cursor()
        cur.execute(sql, params or ())
        return True
    finally:
        db_pool.putconn(conn)
