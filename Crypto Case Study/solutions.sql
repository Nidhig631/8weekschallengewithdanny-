Our Crypto Case Study
=====================

CREATE SCHEMA trading;


CREATE INDEX  index_price ON trading.prices (ticker, market_date);
CREATE INDEX index_transactions1 ON trading.transactions (txn_date, ticker);
CREATE INDEX index_transactions2 ON trading.transactions (txn_date, member_id);
CREATE INDEX index_transactions3 ON trading.transactions (member_id);
CREATE INDEX index_transactions4  ON trading.transactions (ticker);

Data Dictionary
===============
Column Name	Description
ticker	one of either BTC or ETH
market_date	the date for each record
price	closing price at end of day
open	the opening price
high	the highest price for that day
low	the lowest price for that day
volume	the total volume traded
change	% change price in price


Exploring The Members Data
==========================

Question 1
Show only the top 5 rows from the trading.members table

SELECT * FROM trading.members LIMIT 5;

Question 2
Sort all the rows in the table by first_name in alphabetical order and show the top 3 rows
SELECT * FROM trading.members ORDER BY first_name LIMIT 3;

Question 3
Which records from trading.members are from the United States region?
SELECT * FROM trading.members WHERE region='United States';

Question 4
Select only the member_id and first_name columns for members who are not from Australia
SELECT member_id, first_name  FROM trading.members WHERE region <> 'Australia';


Question 5
Return the unique region values from the trading.members table and sort the output by reverse alphabetical order
SELECT DISTINCT region FROM  trading.members ORDER BY region DESC;

Question 6
How many mentors are there from Australia or the United States?
SELECT region , COUNT(*) FROM trading.members
WHERE region in ('Australia','United States')
group by region;

Question 7
How many mentors are not from Australia or the United States?
SELECT COUNT(*) FROM trading.members
WHERE region not in ('Australia','United States');

Question 8
How many mentors are there per region? Sort the output by regions with the most mentors to the least?
SELECT region, count(*) as count from trading.members
group by region
order by count desc;

Question 9
How many US mentors and non US mentors are there?
select case
when region <> 'United States' then 'Non US'
else region end as mentor_region,
count(*) 
from trading.members
group by mentor_region;

Question 10
How many mentors have a first name starting with a letter before 'E'?
select count(*) from trading.members where
first_name like 'A%' or  
first_name like 'B%' or 
first_name like 'C%' or
first_name like 'D%';

Data Exploration Questions
=========================
Question 1
How many total records do we have in the trading.prices table?
select count(*) from trading.prices;

Question 2
How many records are there per ticker value?
select ticker, count(*) from trading.prices
group by ticker;

Question 3
What is the minimum and maximum market_date values?
select min(market_date), max(market_date)
 from trading.prices;
 
Question 4
Are there differences in the minimum and maximum market_date values for each ticker?
select ticker,min(market_date), max(market_date)
 from trading.prices
 group by ticker; 
 
Question 5
What is the average of the price column for Bitcoin records during the year 2020? 
select avg(price) as avg
from trading.prices
where ticker='BTC' and
extract(year from  market_date)='2020';
 
Question 6
What is the monthly average of the price column for Ethereum in 2020? Sort the output in chronological order and also round the average price value to 2 decimal places;
select 
extract(month from  market_date) AS month_start,
round(avg(price)::numeric,2) as average_eth_price
from trading.prices
where 
extract(year from market_date)='2020'
and ticker='ETH'
group by month_start;

Question 7
Are there any duplicate market_date values for any ticker value in our table?

As you inspect the output from the following SQL query - what is your final answer?
select ticker,
count(market_date) as total_count,
count(distinct market_date) as unique_count
from trading.prices
group by ticker;

Question 8
How many days from the trading.prices table exist where the high price of Bitcoin is over $30,000?
select count(*)
from trading.prices
where price > 30000 and ticker = 'BTC'
























 

