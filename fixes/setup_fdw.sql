CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER orders_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'db2', port '5432', dbname 'Orders_db2');

CREATE USER MAPPING FOR "MyUser"
SERVER orders_server
OPTIONS (user 'Orders_admin', password 'Orders_pass_456');

CREATE SCHEMA IF NOT EXISTS remote_orders;
IMPORT FOREIGN SCHEMA public
FROM SERVER orders_server INTO remote_orders;
