				-- Ingredient Optimisation


create view  split_toppings_by_id as
select distinct substring_index(substring_index(a.TOPPINGS,',',b.help_topic_id+1),',',-1)
as topping_id,a.pizza_id from PIZZA_RECIPES a  join  mysql.help_topic b  on
b.help_topic_id < (length(a.TOPPINGS) - length(replace(a.TOPPINGS,',',''))+1);
 
 -- What are the standard ingredients for each pizza?
select pn.pizza_id,pn.pizza_name , pt.topping_name from pizza_names  pn inner join split_toppings_by_id pr on 
pn.pizza_id=pr.pizza_id
inner join pizza_toppings pt on pr.topping_id=pt.topping_id
order by  pn.pizza_id ;

-- What was the most commonly added extra?
create view vw_extras as
select
substring_index(substring_index(a.extras,',',b.help_topic_id+1),',',-1)
as extras   from customer_orders a  join  mysql.help_topic b  on
b.help_topic_id < (length(a.extras) - length(replace(a.extras,',',''))+1);

select topping_name , count(topping_id) as topping_id_count from pizza_toppings pt
  join vw_extras on pt.topping_id=vw_extras.extras
  group by topping_name
 having topping_id_count =(
 select max(x.topping_id_count) from 
 (select topping_name , count(topping_id) as topping_id_count from pizza_toppings pt
  join vw_extras on pt.topping_id=vw_extras.extras
  group by topping_name)x);

-- What was the most common exclusion?

create view vw_exclusions as
select
substring_index(substring_index(a.exclusions,',',b.help_topic_id+1),',',-1)
as exclusions  from customer_orders a  join  mysql.help_topic b  on
b.help_topic_id < (length(a.exclusions) - length(replace(a.exclusions,',',''))+1);

select topping_name , count(topping_id) as topping_id_count from pizza_toppings pt
  join vw_exclusions on pt.topping_id=vw_exclusions.exclusions
  group by topping_name
 having topping_id_count =(
 select max(x.topping_id_count) from 
 (select topping_name , count(topping_id) as topping_id_count from pizza_toppings pt
  join vw_exclusions on pt.topping_id=vw_exclusions.exclusions
  group by topping_name)x);

-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
create view vw_exclu_extras as
select 
order_id ,customer_id,pizza_id,
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 1), ',', -1) as first_exclusions,
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 2), ',', -1) as second_exclusions,
case when 
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 1), ',', -1)  <>
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 2), ',', -1)  then 'exclude'
else 'already excluded'
end as exclu_status,
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 1), ',', -1) as first_extras,
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 2), ',', -1) as second_extras,
case when 
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 1), ',', -1)  <>
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 2), ',', -1)  then 'add'
else 'already added'
end as extras_status
from customer_orders
where pizza_id=1;

select 
case 
when first_exclusions is null and second_exclusions is null and first_extras is null 
and second_extras is null then pizza_id 
when first_exclusions =4 and exclu_status='already excluded' and first_extras is null 
and second_extras is null then pizza_id'-'first_exclusions
 from vw_exclu_extras;

use datawithdanny;

-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
create view vw_exclu_extras as
select 
order_id ,customer_id,pizza_id,
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 1), ',', -1) as first_exclusions,
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 2), ',', -1) as second_exclusions,
case when 
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 1), ',', -1)  <>
SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', 2), ',', -1)  then 'exclude'
else 'already excluded'
end as exclu_status,
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 1), ',', -1) as first_extras,
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 2), ',', -1) as second_extras,
case when 
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 1), ',', -1)  <>
SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', 2), ',', -1)  then 'add'
else 'already added'
end as extras_status
from customer_orders
where pizza_id=1;

-- Generate an alphabetically ordered comma separated ingredient list for
-- each pizza order from the customer_orders table and add a 2x in front of 
-- any relevant ingredients

select  pizza_id,
GROUP_CONCAT(exclusions) as exclusions , GROUP_CONCAT(extras) as extras
 from customer_orders
group by pizza_id;

-- What is the total quantity of each ingredient used in all 
-- delivered pizzas sorted by most frequent first?

select count(v.topping_id) , pt.topping_name from split_toppings_by_id v
inner join customer_orders co using(pizza_id)
inner join runner_orders ro using(order_id)
inner join pizza_toppings pt using(topping_id)
where ro.cancellation is null
group by pt.topping_name;



























