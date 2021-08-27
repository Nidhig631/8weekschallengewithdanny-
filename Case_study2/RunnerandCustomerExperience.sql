--Runner and Customer Experience
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select r.runner_id,
r.registration_date  as start_date,
cast(max(ro.pickup_time)as date) as last_pickup_time , 
datediff(week,cast(max(ro.pickup_time)as date) ,r.registration_date) as 
active_weeks_for_runner
from runners r inner join 
runner_orders ro on r.runner_id=ro.runner_id
where ro.cancellation is null
group by r.runner_id,r.registration_date;

--What was the average time in minutes
--it took for each runner to arrive
--at the Pizza Runner HQ to pickup the order?
WITH CTE AS (
SELECT RO.RUNNER_ID,DATEDIFF(MINUTE,CO.ORDER_TIME,RO.PICKUP_TIME ) AS MIN_DIFF
,DATEDIFF(SECOND,CO.ORDER_TIME,RO.PICKUP_TIME )/60 AS SEC_IN_MIN_DIFF,
datepart(minute ,dateadd(minute,
DATEDIFF(MINUTE,CO.ORDER_TIME,RO.PICKUP_TIME ),
DATEDIFF(SECOND,CO.ORDER_TIME,RO.PICKUP_TIME )/60))as total_min
FROM CUSTOMER_ORDERS CO INNER JOIN
RUNNER_ORDERS RO ON CO.ORDER_ID=RO.ORDER_ID
WHERE RO.CANCELLATION IS NULL
)
SELECT RUNNER_ID , AVG(TOTAL_MIN) AS TOTAL_MINS  FROM CTE
GROUP BY RUNNER_ID;

--Is there any relationship between the number of pizzas and
--how long the order takes to prepare?
SELECT co.order_id , count(co.pizza_id) as total_ordered_pizza,
datepart(minute ,dateadd(minute,
DATEDIFF(MINUTE,CO.ORDER_TIME,RO.PICKUP_TIME ),
DATEDIFF(SECOND,CO.ORDER_TIME,RO.PICKUP_TIME )/60))as total_min
FROM CUSTOMER_ORDERS CO INNER JOIN
RUNNER_ORDERS RO ON CO.ORDER_ID=RO.ORDER_ID
WHERE RO.CANCELLATION IS NULL
group by CO.ORDER_TIME,RO.PICKUP_TIME,co.order_id;

--What was the average distance travelled for each customer?
SELECT co.CUSTOMER_ID, 
avg(convert( int ,round(replace(ro.distance,'km',' '),0)))as avg_distance
FROM CUSTOMER_ORDERS CO INNER JOIN
RUNNER_ORDERS RO ON CO.ORDER_ID=RO.ORDER_ID
WHERE RO.CANCELLATION IS NULL
group by co.CUSTOMER_ID;

--What was the difference between the longest
--and shortest delivery times for all orders?

WITH min_max AS (
	SELECT 
		
		cast(max(replace(replace(replace(duration,'mins',' '), 'minutes', '  ')
		,'minute', ' '))as int)as max_duration,
		cast(min(replace(replace(replace(duration,'mins',' '), 'minutes', '  ')
		,'minute', ' '))as int)as min_duration
    FROM runner_orders
	WHERE cancellation IS NULL
)
SELECT 
	 datediff(day ,min_duration,max_duration) as minmax
FROM min_max;

--What was the total volume of pizzas ordered for each hour 
--of the day?
select count(pizza_id) as total_volume,
day(order_time) as day_from_date
from CUSTOMER_ORDERS
group by day(order_time);

--What is the successful delivery percentage for each runner?
with cte as(
select runner_id ,count(PICKUP_TIME) as succesful_delivery,
count(*) as total_delivery 
from runner_orders  group by runner_id
)
select runner_id,
(cast(succesful_delivery as float) /
cast(total_delivery as float))*100 as per from cte
















