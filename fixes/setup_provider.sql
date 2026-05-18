CREATE USER customer_team_reader WITH PASSWORD 'reader_pass';
GRANT USAGE ON SCHEMA public TO customer_team_reader;

-- Grant access to the ORDER table, hiding the waiter_id
GRANT SELECT (order_id, table_id, customer_id, order_time, order_status) ON "ORDER" TO customer_team_reader;

-- Grant access to the bill table, hiding tax and discount
GRANT SELECT (bill_id, order_id, final_amount, bill_time) ON bill TO customer_team_reader;
