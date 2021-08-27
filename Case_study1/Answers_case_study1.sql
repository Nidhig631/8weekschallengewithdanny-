-- create database
create database "8weeksqlchallenge";
--use the created database
use "8weeksqlchallenge";
--members
create table members
(customer_id varchar(1) primary key,
join_date date
);
INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
--sales
CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 --menu
 CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
--Questions
--1) What is the total amount each customer spent at the restaurant?
select s.customer_id,sum(m.price) as total_amount_spend 
from menu m inner  join 
sales s on m.product_id=s.product_id
group by customer_id;

--2) How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as no_of_visits 
from sales
group by customer_id;

--3) What was the first item from the menu purchased by each customer?

with cte as
(
select  product_id,order_date ,customer_id,
rank()over(partition by customer_id order by order_date asc  )
 as ranking from sales 
 )
 select distinct cte.product_id, cte.order_date,m.product_name,
 cte.ranking,
 cte.customer_id
 from cte inner join menu m
 on cte.product_id = m.product_id
 where ranking=1
 group by cte.product_id , cte.order_date,
 m.product_name,cte.customer_id,cte.ranking;

 --4) What is the most purchased item on the menu and how many times was it purchased by all customers?
 --select max(a.total_count) as count ,a.product_name from 
 --(
 select top 1 count(s.customer_id) as total_count ,
 m.product_name from menu m inner join
 sales s on m.product_id=s.product_id
 group by m.product_name
 order by total_count desc;
 --) a group by a.product_name;

--5) Which item was the most popular for each customer?

with cte as (
	select 
		s.customer_id,
		m.product_name,
		count(*) as count
	from sales s 
		inner join menu m 
		on s.product_id=m.product_id
	group by 
		s.customer_id,m.product_name
	
),
cte1 as (
	select 
		*, 
		rank()over(partition by customer_id order by count desc) as rank
	from cte
)
select 
	customer_id,
	product_name,
	count
	from cte1 
where rank=1
order by customer_id, count desc;

--6) Which item was purchased first by the customer after they became a member?
with cte as(
select s.customer_id ,s.order_date,
		s.product_id, m.join_date ,mu.price,mu.product_name,
	case
		when s.order_date>=m.join_date then 'y'
		else 'n'
	end as membership
from sales s
left join  members m   on m.customer_id=s.customer_id
inner join menu mu on mu.product_id=s.product_id
) 
,cte1 as
(select 
	*,
	rank() over (partition by customer_id, membership order by order_date) as product_rank_asc
from cte 
)
select * from  cte1 where membership='y' and  product_rank_asc=1;

--7) Which item was purchased just before the customer became a member?
with cte as
(
select s.customer_id , m.join_date ,
s.order_date,s.product_id,
mu.product_name , mu.price ,
case 
when s.order_date>=m.join_date then 'y' else 'n'
end as membership
from sales s
left join members m on s.customer_id=m.customer_id
inner join menu mu on mu.product_id=s.product_id
)
,cte1 as
(
select *, rank() over (partition by customer_id ,membership order by order_date desc) as rank
from cte
)
select * from cte1
where membership='n' and  rank=1 and join_date is not null;

--8)What is the total items and amount spent for each member before they became a member?

with cte as
(
select s.customer_id , m.join_date ,
s.order_date,s.product_id,
mu.product_name , mu.price ,
case 
when s.order_date>=m.join_date then 'y' else 'n'
end as membership
from sales s
left join members m on s.customer_id=m.customer_id
inner join menu mu on mu.product_id=s.product_id
)
,cte1 as
(
select *, rank() over (partition by customer_id ,membership order by order_date desc) as rank
from cte
)
select sum(price) as amt_price,
count(product_id) as count_items, customer_id from cte1
where membership='n'and join_date is not null
group by customer_id ;

--9) If each $1 spent equates to 10 points and sushi has a 2x 
--points multiplier - how many points would each customer have?

with cte as
(
select s.customer_id , m.join_date ,
s.order_date,s.product_id,
mu.product_name , mu.price ,
case 
when s.order_date>=m.join_date then 'y' else 'n'
end as membership
from sales s
left join members m on s.customer_id=m.customer_id
inner join menu mu on mu.product_id=s.product_id
)
,cte1 as
(
select *, rank() over (partition by customer_id ,membership order by order_date desc) as rank
from cte
)
select customer_id,
sum(case when product_name = 'sushi' then (price *10 * 2) 
else (price * 10) end) as points from cte1
where membership='y'
group by customer_id;

--10)In the first week after a customer joins the program 
--(including their join date) they earn 2x points on all items, 
--not just sushi - how many points do customer A and B have at 
--the end of January?
with cte as
(
select s.customer_id , m.join_date ,
s.order_date,s.product_id,
mu.product_name , mu.price ,
case 
when s.order_date>=m.join_date then 'y' else 'n'
end as membership
from sales s
left join members m on s.customer_id=m.customer_id
inner join menu mu on mu.product_id=s.product_id
)
,cte1 as
(
select *, rank() over (partition by customer_id ,membership order by order_date desc) as rank
from cte
)
select customer_id,order_date ,month(order_date) as month,
sum(case when product_name <>'sushi' then price 
else (price * 10 * 2) end) as points from cte1
where membership='y' and  month(order_date)=1
group by customer_id,order_date;

--Bonus Question
with cte as(
select s.customer_id,
s.order_date,
mu.product_name , mu.price ,
case 
when s.order_date>=m.join_date then 'y' else 'n'
end as membership
from sales s
left join members m on s.customer_id=m.customer_id
inner join menu mu on mu.product_id=s.product_id
)
,cte1 as
(
select *, dense_rank() over (partition by customer_id ,membership order by order_date asc) as rank
from cte 
)
select *,
case when membership='y' then rank 
else null
end as ranking 
from cte1 



