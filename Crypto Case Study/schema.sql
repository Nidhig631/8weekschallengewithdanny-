create schema trading;

create table trading.transaction
(txn_id int,
 member_id varchar(20),
 ticker varchar(5),
 txn_date date,
 txn_type varchar(5),
 quantity float,
 percentage_fee float,
 txn_time timestamp
);

create table trading.members
(member_id varchar(20),
first_name varchar(20),
region varchar(20));

create table trading.prices
(ticker	varchar(5),
market_date	date,
price float,
open float,
high float,
low	float,
volume varchar(20),
change varchar(20)
 );


