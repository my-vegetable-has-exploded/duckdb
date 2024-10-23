CREATE TABLE borrow_records (
	_id BIGINT,
    _type INT,
    _date DATE,
    loc BIGINT,
    book_id VARCHAR,
);
COPY borrow_records FROM 'books.csv' (DATEFORMAT '%Y-%m-%dT%H:%M:%S');;

-- SELECT
--     _id,
--     _type,
--     strftime(_date, '%Y-%m-%d %H:%M:%S') AS _date,
--     loc,
--     book_id
-- FROM
--     borrow_records
-- LIMIT 50 OFFSET 10000;

-- explain analyze 
SELECT
    b1.book_id AS book_id,
    b1._date AS checkout_time,
    b2._date AS return_time
FROM
    borrow_records b1
JOIN
    borrow_records b2
ON
    b1.book_id = b2.book_id
    AND b1._type = 1
    AND b2._type = 3
    AND b1._date < b2._date
WHERE
    NOT EXISTS (
        SELECT 1
        FROM borrow_records b3
        WHERE b3.book_id = b1.book_id
        AND b3._type = 3
        AND b3._date > b1._date
        AND b3._date < b2._date
    )
ORDER BY
    b1.book_id, b1._date;

CREATE TABLE books AS
SELECT
    b1.book_id AS book_id,
    b1._date AS checkout_time,
    b2._date AS return_time
FROM
    borrow_records b1
JOIN
    borrow_records b2
ON
    b1.book_id = b2.book_id
    AND b1._type = 1
    AND b2._type = 3
    AND b1._date < b2._date
WHERE
    NOT EXISTS (
        SELECT 1
        FROM borrow_records b3
        WHERE b3.book_id = b1.book_id
        AND b3._type = 3
        AND b3._date > b1._date
        AND b3._date < b2._date
    )
ORDER BY
    b1.book_id, b1._date;

COPY books to 'books.parquet' (format 'parquet');