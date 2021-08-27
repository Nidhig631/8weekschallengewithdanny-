PARSENAME Function

I have two columns one column contains value with string as comma separated  like 'James,Sawyer'
and another column contains  like james. So Output as third column as true if value within first column contains in second column 

create table check_n
(comb_name varchar(20),
name varchar(10)
);

insert into check_n values('James,Sawyer','James');
insert into check_n values('James,Sawyer','Sawyer');
insert into check_n values('James,Sawyer','Jamey');

select * from check_n;

select 
	comb_name , name , 
		case
		when name=x.first_name or name = x.second_name then 'true'
		else 'false'
		end as condition_check from (
	select comb_name , name,
	 PARSENAME(REPLACE(comb_name, ',', '.'), 1) AS first_name,
	 PARSENAME(REPLACE(comb_name, ',', '.'), 2) AS second_name
 from check_n) x

In postgresql
=============
 create table check_n
(comb_name varchar(20),
name varchar(10)
);
insert into check_n values('James,Sawyer','James');
insert into check_n values('James,Sawyer','Sawyer');
insert into check_n values('James,Sawyer','Jamey');
select * from check_n;

select
comb_name , name ,
case
when name=x.first_name or name = x.second_name then 'true'
else 'false'
end as condition_check from 
(select comb_name  , name, 
SPLIT_PART(comb_name, ',', 1) as first_name ,
SPLIT_PART(comb_name, ',', 2) as second_name
from check_n)x