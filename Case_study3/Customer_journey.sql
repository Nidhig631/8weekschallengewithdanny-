						--Case Study #3 - Foodie-Fi
				
-- Customer Journey
-- Customers having recent plans				
with cte_customer_current_plan as(
select customer_id,row_number()over(partition by customer_id order by customer_id asc) as row_num,
case when plan_id=0  then 1 else 0 end as trial_plan,
case when plan_id=1  then 1 else 0 end as basic_monthly_plan,
case when plan_id=2  then 1 else 0 end as pro_monthly_plan,
case when plan_id=3  then 1 else 0 end as pro_annual_plan,
case when plan_id=4 then 1 else 0 end as churn
from subscriptions
inner join plans using(plan_id)
order by customer_id asc
	)
select customer_id,trial_plan,basic_monthly_plan,pro_monthly_plan,pro_annual_plan,churn
 from  cte_customer_current_plan
where row_num=2;

--Data Analysis Questions
--How many customers has Foodie-Fi ever had?
select count(*) from subscriptions;

--What is the monthly distribution of trial plan start_date
--values for our dataset - use the start of the month as
--the group by value

select extract(month from start_date) as month,
count(customer_id)from subscriptions
where plan_id=0 group by month
order by month asc;

--What plan start_date values occur after the year 2020 
--for our dataset? 
--Show the breakdown by 
--count of events for each plan_name?

select start_date,
count(case when plan_id=0 then 1 else 0 end)as trial,
count(case when plan_id=1 then 1 else 0 end)as basic_monthly,
count(case when plan_id=2 then 1 else 0 end)as pro_monthly,
count(case when plan_id=3 then 1 else 0 end)as pro_annual,
count(case when plan_id=4 then 1 else 0 end)as churn
from subscriptions inner join plans using (plan_id)
where start_date>'2020-12-31'
group by start_date
order by start_date asc limit 1;


--How many customers have churned straight after their 
--initial free trial - what percentage is this rounded 
--to the nearest whole number?
create view vw_count123 as
with cte as(
select customer_id
, plan_id ,
 lead(plan_id,1)over(partition by customer_id)as next_val
  from subscriptions
),
cte1 as(
select *, row_number()over(partition by customer_id)
	as row_num
from cte
),
cte2 as(
select * from cte1
),
cte3 as(
select * from cte1
where row_num=1 and
plan_id=0 and next_val=4
)
select * from cte3;

select count(*) from subscriptions; ==> 2650.0,


select 
round(count(*) * 100 /2650.0,1)  as 
percentofcustomershavechurnedstraightaftertheirinitialfreetrial
from 
vw_count123;



-- What is the number and percentage of customer plans after their initial free trial?
with cte as(
select customer_id
, plan_id ,
 lead(plan_id,1)over(partition by customer_id)as next_val
  from subscriptions
),
cte1 as(
select *, 
row_number()over(partition by customer_id)
	as row_num
from cte)
select count(customer_id),
round(count(customer_id) * 100 / 2650.0,1) as percent,
plan_id,next_val from cte1 
where row_num=1
group by plan_id,next_val;




with cte as(
select count(customer_id) as each_plan_vise,
case when plan_id=0  then 1 else 0 end as trial_plan,
case when plan_id=1  then 1 else 0 end as basic_monthly_plan,
case when plan_id=2  then 1 else 0 end as pro_monthly_plan,
case when plan_id=3  then 1 else 0 end as pro_annual_plan,
case when plan_id=4 then 1 else 0 end as churn
from subscriptions
inner join plans using(plan_id)
group by plan_id)
select *,percent_rank() over(order by each_plan_vise 
							) from cte;
	


--What is the customer count and
--percentage breakdown of all 5 plan_name values
--at 2020-12-31?

select p.plan_name,
count(s.customer_id) as customer_count ,
count(s.customer_id)* 100/(select count(*) from subscriptions) as percentage_breakdown
from plans p inner join subscriptions s
using (plan_id)
where s.start_date<='2020-12-31'
group  by p.plan_name;


--How many customers have upgraded to an 
--annual plan in 2020?

with cte as(
select customer_id
, plan_id ,
 lead(plan_id,1)over(partition by customer_id)as 
	next_val,extract(year from start_date) as year
  from subscriptions
),
cte1 as(
select * from cte where next_val is not null)
select count(*) from cte1 where next_val=3 and year=2020

















