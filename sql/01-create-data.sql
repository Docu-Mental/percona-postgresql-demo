CREATE TABLE customers (
    customer_id BIGSERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    country TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE orders (
    order_id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(customer_id),
    product TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL,
    order_date DATE NOT NULL
);

-- Create 10,000 customers.
INSERT INTO customers (
    first_name,
    last_name,
    email,
    country
)
SELECT
    'Customer' || g,
    'Test',
    'customer' || g || '@example.com',
    CASE (g % 5)
        WHEN 0 THEN 'Spain'
        WHEN 1 THEN 'UK'
        WHEN 2 THEN 'France'
        WHEN 3 THEN 'Germany'
        ELSE 'Italy'
    END
FROM generate_series(1, 10000) AS g;

-- Create 100,000 orders.
INSERT INTO orders (
    customer_id,
    product,
    quantity,
    unit_price,
    status,
    order_date
)
SELECT
    1 + floor(random() * 10000)::BIGINT,
    CASE (g % 5)
        WHEN 0 THEN 'Sea Kayak'
        WHEN 1 THEN 'Paddle'
        WHEN 2 THEN 'Life Jacket'
        WHEN 3 THEN 'Dry Bag'
        ELSE 'Paddle Jacket'
    END,
    1 + floor(random() * 4)::INTEGER,
    round((20 + random() * 480)::numeric, 2),
    CASE (g % 4)
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'processing'
        WHEN 2 THEN 'shipped'
        ELSE 'completed'
    END,
    CURRENT_DATE - floor(random() * 730)::INTEGER
FROM generate_series(1, 100000) AS g;

ANALYZE customers;
ANALYZE orders;

CREATE EXTENSION pg_stat_monitor;