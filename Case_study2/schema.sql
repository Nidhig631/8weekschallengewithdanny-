

CREATE TABLE customer_orders (
  order_id int DEFAULT NULL,
  customer_id int DEFAULT NULL,
  pizza_id int DEFAULT NULL,
  exclusions varchar(4) DEFAULT NULL,
  extras varchar(4) DEFAULT NULL,
  order_time timestamp NULL DEFAULT NULL
);


INSERT INTO customer_orders VALUES (1,101,1,NULL,NULL,'2020-01-01 12:35:02'),(2,101,1,NULL,NULL,'2020-01-01 13:30:52'),(3,102,1,NULL,NULL,'2020-01-02 07:21:23'),(3,102,2,NULL,NULL,'2020-01-02 07:21:23'),(4,103,1,'4',NULL,'2020-01-04 07:53:46'),(4,103,1,'4',NULL,'2020-01-04 07:53:46'),(4,103,2,'4',NULL,'2020-01-04 07:53:46'),(5,104,1,NULL,'1','2020-01-08 15:30:29'),(6,101,2,NULL,NULL,'2020-01-08 15:33:13'),(7,105,2,NULL,'1','2020-01-08 15:50:29'),(8,102,1,NULL,NULL,'2020-01-09 18:24:33'),(9,103,1,'4','1,5','2020-01-10 05:52:59'),(10,104,1,NULL,NULL,'2020-01-11 13:04:49'),(10,104,1,'2,6','1,4','2020-01-11 13:04:49');



CREATE TABLE pizza_names (
  pizza_id int DEFAULT NULL,
  pizza_name text
); 

INSERT INTO pizza_names VALUES (1,'Meatlovers'),(2,'Vegetarian');


CREATE TABLE pizza_recipes (
  pizza_id int DEFAULT NULL,
  toppings text
);


INSERT INTO pizza_recipes VALUES (1,'1, 2, 3, 4, 5, 6, 8, 10'),(2,'4, 6, 7, 9, 11, 12');

CREATE TABLE pizza_toppings (
  topping_id int DEFAULT NULL,
  topping_name text
);

INSERT INTO pizza_toppings VALUES (1,'Bacon'),(2,'BBQ Sauce'),(3,'Beef'),(4,'Cheese'),(5,'Chicken'),(6,'Mushrooms'),(7,'Onions'),(8,'Pepperoni'),(9,'Peppers'),(10,'Salami'),(11,'Tomatoes'),(12,'Tomato Sauce');

CREATE TABLE runner_orders (
  order_id int DEFAULT NULL,
  runner_id int DEFAULT NULL,
  pickup_time timestamp NULL DEFAULT NULL,
  distance varchar(7) DEFAULT NULL,
  duration varchar(10) DEFAULT NULL,
  cancellation varchar(23) DEFAULT NULL
);

INSERT INTO runner_orders VALUES (1,1,'2020-01-01 12:45:34','20','1920',NULL),(2,1,'2020-01-01 13:40:54','20','1620',NULL),
(3,1,'2020-01-01 18:42:37','13.4','1200',NULL),(4,2,'2020-01-04 08:23:03','23.4','2400',NULL),(5,3,'2020-01-08 15:40:57','10','900',NULL),
(6,3,NULL,NULL,NULL,'Restaurant Cancellation'),(7,2,'2020-01-08 16:00:45','25','1500',NULL),(8,2,'2020-01-09 18:45:02','23.4','900',NULL),
(9,2,NULL,NULL,NULL,'Customer Cancellation'),(10,1,'2020-01-11 13:20:20','10','600',NULL);

CREATE TABLE runners (
  runner_id int DEFAULT NULL,
  registration_date date DEFAULT NULL
);

INSERT INTO runners VALUES (1,'2021-01-01'),(2,'2021-01-03'),(3,'2021-01-08'),(4,'2021-01-15');

