#! /bin/bash

# if this command fails, download the Transaktioner 2016 file manually at https://www.opendata.dk/city-of-aarhus/transaktionsdata-fra-aarhus-kommunes-biblioteker, and store it as books.csv
wget https://admin.opendata.dk/datastore/dump/787d0f74-42f9-407e-b52f-7d55e31ee762 -O books.csv

# transform the csv file to parquet format and single borrow record
./duckdb <books2016.sql

echo "main branch"
./duckdb <books.sql

make release >make.log

echo "optimized iejoin"
build/release/duckdb <books.sql
