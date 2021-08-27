--Ingredient Optimisation
--1) What are the standard ingredients for each pizza?
create view 
string_parse_vw
as 
select  pr.pizza_id,cast(value as int) as toppings
from pizza_recipes pr cross apply
string_split(convert(varchar(max),toppings),',')
GO
select v.pizza_id, v.toppings,pt.topping_name,pn.pizza_name
from string_parse_vw
v inner join pizza_toppings pt
on v.toppings=pt.topping_id
inner join pizza_names pn on pn.pizza_id=v.pizza_id;

--2) What was the most commonly added extra?
with cte as (
select co.pizza_id,cast(value as int) as extras 
 from CUSTOMER_ORDERS  co cross apply
string_split(convert(varchar(max),EXTRAS),',')
where extras is not null
)
,cte1 as
(select PIZZA_ID,extras,count(*) as count from cte
group by  PIZZA_ID,extras
)
select top 1 pizza_id , extras , max(count) as max from cte1
group by PIZZA_ID,extras;

--3) What was the most common exclusion?
with cte as (
select co.pizza_id,cast(value as int) as exclusions
 from CUSTOMER_ORDERS  co cross apply
string_split(convert(varchar(max),exclusions),',')
where exclusions is not null
)
,cte1 as
(select PIZZA_ID,exclusions,count(*) as count from cte
group by  PIZZA_ID,exclusions
)
select top 1 pizza_id , exclusions , max(count) as max from cte1
group by PIZZA_ID,exclusions
order by max(count) desc;


--Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
select pizza_id,
exclusions , extras from CUSTOMER_ORDERS
SELECT pizza_id, 
     exclusns = STUFF(
                 (SELECT ',' + exclusions FROM 
				 CUSTOMER_ORDERS FOR XML PATH ('')), 1, 1, ''
               ),
    extras = STUFF(
                 (SELECT ',' + extras FROM CUSTOMER_ORDERS FOR XML PATH ('')), 1, 1, ''
               ) 
FROM CUSTOMER_ORDERS GROUP BY pizza_id

--What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

select v.toppings,count(cast(v.toppings as int)) as times_used
from string_parse_vw v
inner join customer_orders co
on  v.pizza_id=co.PIZZA_ID
inner join  pizza_toppings pt on v.toppings=pt.topping_id
inner join RUNNER_ORDERS ro on ro.ORDER_ID=co.ORDER_ID
cross apply
string_split(convert(varchar(max),extras),',') as ex
where co.extras is not null and 
ro.CANCELLATION is null
group by v.toppings
order by v.toppings asc