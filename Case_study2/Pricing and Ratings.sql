--  Pricing and Ratings

-- If a Meat Lovers pizza costs $12 and Vegetarian 
-- costs $10 and there were no charges for 
-- changes - how much money has Pizza Runner
--made so far if there are no delivery fees?
create view vw_customer_orders as
select order_id ,customer_id,pizza_id,
unnest(string_to_array(extras, ',')) as extras,
unnest(string_to_array(exclusions, ',')) as exclusions,
order_time
from customer_orders;

with cte as(
select ro.runner_id,
((count(case when vw.pizza_id=1 then 1 else 0 
end) ) * 12) +
(count(case when vw.pizza_id=2 then 1 else 0 
end) ) * 10 as total_revenue_by_each_runner
from runner_orders ro inner join
vw_customer_orders vw on ro.order_id=vw.order_id
where ro.cancellation is null
group by ro.runner_id)
select sum(total_revenue_by_each_runner) from cte;

-- What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra
-- What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra

with cte as(
select ro.runner_id,
((count(case when vw.pizza_id=1 then 1 else 0 
end) ) * 12) + 
((case when cast(vw.extras as int)=cast(4 as int) then 1 else 0
end)) * 1 +
(count(case when vw.pizza_id=2 then 1 else 0 
end) ) * 10 as total_revenue_by_each_runner
from runner_orders ro inner join
vw_customer_orders vw on ro.order_id=vw.order_id
where ro.cancellation is null
group by ro.runner_id,vw.extras)
select sum(total_revenue_by_each_runner) from cte;


-- What if substitutes were allowed at no 
--additional cost but any additional extras
--were charged at $1?
-- Exclude Cheese and add Bacon is free
-- Exclude Cheese but add bacon and beef 
--costs $1 extra

with cte as(
select ro.runner_id,
((count(case when vw.pizza_id=1 then 1 else 0 
end) ) * 12) + 
((count(case when (cast(vw.extras as int)=cast(3 as int) and 
		cast(vw.extras as int)=cast(1 as int))
		then 1 else 0
end)) * 1) +
(count(case when vw.pizza_id=2 then 1 else 0 
end) ) * 10 as total_revenue_by_each_runner
from runner_orders ro inner join
vw_customer_orders vw on ro.order_id=vw.order_id
where ro.cancellation is null
group by ro.runner_id)
select sum(total_revenue_by_each_runner) from cte;

