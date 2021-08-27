                      -- Runner and Customer Experience
use datawithdanny;

-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select 
SUM(case when extract(day from  registration_date) <8 then 1 else 0 end) as 'week1',
SUM(case when (extract(day from  registration_date) >=8 and extract(day from  registration_date)<14) then 1 else 0 end) as 'week2',
SUM(case when (extract(day from registration_date) >=14  and extract(day from  registration_date)<21) then 1 else 0 end) as 'week3',
SUM(case when extract(day from registration_date) >=21  then 1 else 0 end) as 'week4'
from runners;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
with cte as(
select ro.runner_id as runner_id , TIMESTAMPDIFF (hour, order_time,pickup_time ) * 60 +
TIMESTAMPDIFF (minute, order_time,pickup_time )+ TIMESTAMPDIFF (second , order_time,pickup_time ) / 60 as total_time_in_min
from  customer_orders co  inner join runner_orders ro using(order_id)
 where cancellation is null
 )
 select runner_id , round(avg(total_time_in_min),2) from cte
 group by runner_id ;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
 select co.order_id, count(pizza_id),
 TIMESTAMPDIFF (hour, order_time,pickup_time ) * 60 * 60 + 
TIMESTAMPDIFF (minute, order_time,pickup_time ) * 60 + 
TIMESTAMPDIFF (second , order_time,pickup_time )  as total_time_in_sec
from  customer_orders co  inner join runner_orders ro using(order_id)
 where cancellation is null
 group by co.order_id
 order by  count(pizza_id) asc;

-- What was the average distance travelled for each customer?
 select customer_id ,round(avg(distance),2) as avg_dist_travelled
from  customer_orders co  inner join runner_orders ro using(order_id)
 where cancellation is null
 group by customer_id;

-- What was the difference between the longest and shortest delivery times for all orders?
select 
max(duration)- min(duration) as max_min_diff from 
runner_orders;

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
select runner_id,order_id,
round(avg(distance/duration),2)* 60*60 as avg_speed_km_per_hr
from runner_orders
 where cancellation is null
group by runner_id,order_id;

-- What is the successful delivery percentage for each runner?
select runner_id , 
round(count(pickup_time) * 100 / count(*) ,2)  as percentage_sucessful_delivery
from runner_orders
 group by runner_id;
 
 
 

 
 