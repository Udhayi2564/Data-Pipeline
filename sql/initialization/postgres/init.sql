-- PostgreSQL initialization SQL
-- Run inside mds-postgres container

-- Create PostgreSQL schemas
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS harmonized;
CREATE SCHEMA IF NOT EXISTS serving;

-- Create serving.orders table (target for batch)
CREATE TABLE IF NOT EXISTS serving.orders (
    order_id       BIGINT PRIMARY KEY,
    customer_name  VARCHAR(200) NOT NULL,
    product_name   VARCHAR(200) NOT NULL,
    category       VARCHAR(100),
    quantity       NUMERIC(10,2),
    unit_price     NUMERIC(12,4),
    order_status   VARCHAR(50),
    updated_at     TIMESTAMP
);

-- Create harmonized.orders_cdc table (target for CDC)
CREATE TABLE IF NOT EXISTS harmonized.orders_cdc (
    order_id       BIGINT,
    customer_name  VARCHAR(200),
    product_name   VARCHAR(200),
    category       VARCHAR(100),
    quantity       NUMERIC(10,2),
    unit_price     NUMERIC(12,4),
    order_status   VARCHAR(50),
    updated_at     TIMESTAMP,
    operation      VARCHAR(10),  -- INSERT/UPDATE/DELETE
    source_ts_ms   BIGINT,
    PRIMARY KEY (order_id)
);

-- Grant permissions
GRANT ALL PRIVILEGES ON SCHEMA raw TO postgres;
GRANT ALL PRIVILEGES ON SCHEMA harmonized TO postgres;
GRANT ALL PRIVILEGES ON SCHEMA serving TO postgres;

-- Note: SeaTunnel will use generate_sink_sql = true to create tables
-- This SQL is for manual initialization if needed