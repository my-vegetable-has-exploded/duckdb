-- EXPLAIN ANALYZE
CREATE TABLE date_range AS
SELECT x
FROM range('2013-01-01'::TIMESTAMP, '2017-01-01'::TIMESTAMP, INTERVAL 1 DAY) tbl(x);

-- EXPLAIN
-- SELECT * FROM date_range;

EXPLAIN ANALYZE
SELECT x, count(*) AS y
FROM 'books.parquet' books, date_range
WHERE books.checkout_time <= x AND x <= books.return_time
GROUP BY ALL
ORDER BY 1;