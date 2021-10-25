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

Question 9
How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker?
select ticker, count(*) as breakout_days
from 
trading.prices
where price > open
and market_date >= '2020-01-01'
and market_date <= '2020-12-31'
group by ticker;

Question 10
How many "non_breakout" days were there in 2020 where the price column is less than the open column for each ticker?
select ticker, count(*) as non_breakout_days
from 
trading.prices
where price < open
and market_date >= '2020-01-01'
and market_date <= '2020-12-31'
group by ticker;


Question 11
What percentage of days in 2020 were breakout days vs non-breakout days? Round the percentages to 2 decimal places
select ticker, count(*),
count(case when price > open then 1 
	  else 0
end) as breakout_percentage
from 
trading.prices
where price < open
and market_date >= '2020-01-01'
and market_date <= '2020-12-31'
group by ticker;


Transactions Table
==================

txn_id	unique ID for each transaction
member_id	member identifier for each trade
ticker	the ticker for each trade
txn_date	the date for each transaction
txn_type	either BUY or SELL
quantity	the total quantity for each trade
percentage_fee	% of total amount charged as fees
txn_time	the timestamp for each trade


In our third trading.transactions database table we have each BUY or SELL transaction for a specific ticker performed by each member
You can inspect the most recent 10 transactions by member_id = 'c4ca42' (do you remember who that is?)

SELECT * FROM trading.transactions
WHERE member_id = 'c4ca42'
ORDER BY txn_time DESC
LIMIT 10;

Question 1
How many records are there in the trading.transactions table?
SELECT count(*) FROM trading.transaction;

Question 2
How many unique transactions are there?
SELECT count(distinct txn_id) FROM trading.transaction;


Question 3
How many buy and sell transactions are there for Bitcoin?
SELECT txn_type,
count (case when txn_type='BUY' then 'BUY'
else 'SELL'
end) as transaction_count
FROM trading.transaction
where ticker='BTC'
group by txn_type


Question 4
For each year, calculate the following buy and sell metrics for Bitcoin:

total transaction count
total quantity
average quantity per transaction
Also round the quantity columns to 2 decimal places.

select 
extract(year from txn_date) as txn_year,
txn_type,
count(*) as transaction_count,
round(cast (sum(quantity) as numeric),2) as total_qunatity,
round(cast (avg(quantity) as numeric),2) as average_quantity
FROM trading.transaction
where ticker='BTC'
group by extract(year from txn_date),txn_type
order by txn_year,txn_type;

Question 4
What was the monthly total quantity purchased and sold for Ethereum in 2020?
select date_trunc('month',txn_date)::date as calendar_month,
sum(case when txn_type='BUY' then quantity else 0 end) 
as buy_quantity,
sum(case when txn_type='SELL' then quantity else 0 end) 
as sell_quantity
FROM trading.transaction
where ticker='ETH'and txn_date between '2020-01-01'
and '2020-12-31'
group by calendar_month
order by calendar_month;


Question 5
Summarise all buy and sell transactions for each member_id by generating 1 row for each member with the following additional columns:

Bitcoin buy quantity
Bitcoin sell quantity
Ethereum buy quantity
Ethereum sell quantity


select member_id,
sum(case when txn_type='BUY' and ticker='BTC'
	then quantity else 0 end) 
as btc_buy_quantity,
sum(case when txn_type='SELL'  and ticker='BTC'
	then quantity else 0 end) 
as btc_sell_quantity,
sum(case when txn_type='SELL'  and ticker='ETH'
	then quantity else 0 end) 
as eth_sell_quantity,
sum(case when txn_type='BUY'  and ticker='ETH'
	then quantity else 0 end) 
as eth_buy_quantity
FROM trading.transaction
group by member_id;

Question 6
What was the final quantity holding of Bitcoin for each member? Sort the output from the highest BTC holding to lowest
select member_id, 
sum(
	case 
	when txn_type='BUY' then quantity
	when txn_type='BUY' then -quantity
	else 0
  end	
) as final_btc_holding from trading.transaction
where ticker='BTC'
group by member_id order by 
final_btc_holding desc;


Question 7
Which members have sold less than 500 Bitcoin? Sort the output from the most BTC sold to least
select member_id, 
sum(quantity) as final_btc_holding from trading.transaction
where ticker='BTC' and txn_type='SELL'
group by member_id 
having sum(quantity)< 500 
order by final_btc_holding desc;


Question 8
What is the total Bitcoin quantity for each member_id owns after adding all of the BUY and SELL transactions from the transactions table? Sort the output by descending total quantity
select member_id, 
sum(
	case 
	when txn_type='BUY' then quantity
	when txn_type='BUY' then -quantity
	else 0
  end	
) as total_quantity from trading.transaction
where ticker='BTC'
group by member_id order by 
total_quantity desc;

Question 9
Which member_id has the highest buy to sell ratio by quantity?
select member_id,
sum(case when txn_type='BUY' then quantity else 0 end)/
sum(case when txn_type='SELL' then quantity else 0 end)
as buy_to_sell_ration from trading.transaction
group by member_id
order by buy_to_sell_ration desc; 

Question 10
For each member_id - which month had the highest total Ethereum quantity sold`?

with cte as(
select member_id,sum(quantity) as sold_eth_quantity,
date_trunc('month',txn_date)::date
as calendar_month,
dense_rank()over(partition by member_id 
				 order by sum(quantity) desc) 
	as ranking
from trading.transaction
where ticker='ETH' and txn_type='SELL'
group by member_id,
date_trunc('month',txn_date)::date
order by calendar_month)
select member_id, calendar_month, sold_eth_quantity from cte where ranking=1;

Let the Data Analysis Begin!
============================

Question 1
What is the earliest and latest date of transactions for all members?
select min(txn_time)::date as earliest_date, 
max(txn_time)::date as latest_date
from trading.transaction;

Question 2
What is the range of market_date values available in the prices data?
select min(market_date)as earliest_date,
max(market_date) as latest_date 
from trading.prices;

Question 3
Which top 3 mentors have the most Bitcoin quantity as of the 29th of August?
select m.first_name, 
sum(
case when t.txn_type='BUY' then t.quantity
when t.txn_type='SELL' then -t.quantity
end ) 
as total_quantity
from trading.members m , 
trading.transaction t
where m.member_id=t.member_id and
t.ticker='BTC'
group by m.first_name
order by total_quantity desc limit 3;


Question 4
What is total value of all Ethereum portfolios for each region at the end date of our analysis? Order the output by descending portfolio value
select m.region,
  SUM(
    CASE
      WHEN t.txn_type = 'BUY'  THEN t.quantity
      WHEN t.txn_type = 'SELL' THEN -t.quantity
    END
  )  AS sum_ethereum_value,
   AVG(
    CASE
      WHEN t.txn_type = 'BUY'  THEN t.quantity
      WHEN t.txn_type = 'SELL' THEN -t.quantity
    END
  ) AS avg_ethereum_value
from trading.members m,trading.prices p,
trading.transaction t 
where m.member_id=t.member_id
and p.ticker=t.ticker
and t.txn_type='ETH' and p.market_date='2021-08-29'
group by m.region;

Question 5
What is the average value of each Ethereum portfolio in each region? Sort this output in descending order
with cte as (
select ticker , price from trading.prices where
ticker='ETH' and market_date='2021-08-29'
)
select m.region,AVG(
    CASE
      WHEN t.txn_type = 'BUY'  THEN t.quantity
      WHEN t.txn_type = 'SELL' THEN -t.quantity
    END
  )* p.price AS avg_ethereum_value
from trading.members m,trading.prices p,
trading.transaction t, cte c 
where m.member_id=t.member_id
and p.ticker=t.ticker and c.price=p.price
group by m.region,p.price 
order by avg_ethereum_value desc;


Planning Ahead for Data Analysis
=================================
Step 1
Create a base table that has each mentors name, region and end of year total quantity for each ticker

CREATE TEMP TABLE  TEMP_DATA_P AS
WITH CTE AS(
SELECT M.FIRST_NAME,M.REGION,T.TXN_DATE,T.TICKER,
CASE 
WHEN T.TXN_TYPE='SELL' THEN -T.QUANTITY ELSE T.QUANTITY 
END AS QUANTITY FROM TRADING.MEMBERS M inner join
TRADING.TRANSACTION T on M.MEMBER_ID=T.MEMBER_ID 
inner join TRADING.PRICES P on  P.TICKER=T.TICKER
WHERE T.TXN_DATE<='2020-12-31'
)
SELECT FIRST_NAME, REGION, 
(DATE_TRUNC('YEAR',TXN_DATE) + INTERVAL '12MONTHS' - INTERVAL '1DAY')::DATE AS
YEAR_END,TICKER,
SUM(QUANTITY) AS YEARLY_QUANTITY
FROM CTE 
GROUP BY FIRST_NAME, REGION, YEAR_END,TICKER;

Step 2
Lets take a look at our base table now to see what data we have to play with - to keep things simple, let's take a look at Abe's data from our new temp table temp_portfolio_base

Inspect the year_end, ticker and yearly_quantity values from our new temp table temp_portfolio_base for Mentor Abe only. Sort the output with ordered BTC values followed by ETH values

select year_end, ticker, yearly_quantity from  
TEMP_DATA_P where first_name='Abe'
order by ticker;

Step 3
Create a cumulative sum for Abe which has an independent value for each ticker
select year_end, ticker, yearly_quantity,
sum(yearly_quantity)over(order by year_end) as
running_total  from 
TEMP_DATA_P where first_name='Abe'
order by ticker;

Step 4
Generate an additional cumulative_quantity column for the temp_portfolio_base temp table
select year_end, ticker, yearly_quantity,
sum(yearly_quantity)over(order by year_end) as
running_total  from 
TEMP_DATA_P where first_name='Abe'
order by ticker;

alter table TEMP_DATA_P
add column cumu_quant numeric;

update TEMP_DATA_P 
set cumu_quant =
(select sum(yearly_quantity)over(order by year_end));


CREATE TEMP TABLE temp_cumulative_portfolio_base AS
SELECT
  first_name,
  region,
  year_end,
  ticker,
  yearly_quantity,
  SUM(yearly_quantity) OVER (
    ORDER BY year_end
  ) AS cum_quant
FROM TEMP_DATA_P;










































 

