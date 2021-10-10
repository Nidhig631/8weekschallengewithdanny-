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


