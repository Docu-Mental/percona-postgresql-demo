-- 1. Run the test query

SELECT COUNT(*)
FROM orders
WHERE customer_id = 9999;

-- 2. Examine the execution information

EXPLAIN ANALYZE
SELECT COUNT(*)
FROM orders
WHERE customer_id = 9999;

-- 3. Examine pg_stat_monitor stats

SELECT ...
FROM pg_stat_monitor
...

-- 4. Add the index

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

ANALYZE orders;

-- 5. Repeat the "Explain Analyze" and pg_stat_monitor executions
...