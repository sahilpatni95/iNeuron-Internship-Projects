--Complex SQL Questions for Interview Preparation

--This playlist contains scenario based SQL problems. 

/*1. Derive Points Table for ICC tournment */

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
GO

INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');
GO

select * from icc_world_cup;
GO

SELECT team_1, CASE WHEN team_1 = winner THEN 1 ELSE 0 END AS win_flag
FROM icc_world_cup
UNION ALL
SELECT team_2, CASE WHEN team_2 = winner THEN 1 ELSE 0 END AS win_flag
FROM icc_world_cup
GO

SELECT team_name, 
count(1) AS no_of_played,
sum(win_flag) AS no_of_won,
count(1)-sum(win_flag) AS no_of_loss,
(2*sum(win_flag)) AS Points
FROM
(SELECT team_1 as team_name, 
CASE WHEN team_1 = winner THEN 1 ELSE 0 END AS win_flag
FROM icc_world_cup
UNION ALL
SELECT team_2 as team_name, 
CASE WHEN team_2 = winner THEN 1 ELSE 0 END AS win_flag
FROM icc_world_cup) A
group by team_name
order by Points desc
Go
/*2.  find new and repeat customers */
create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
GO
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000);
GO

SELECT * 
FROM customer_orders;
GO

SELECT  customer_id, min(order_date) as first_visit_date
FROM customer_orders
group by customer_id; -- first_visit_date
GO

with first_visit as(
SELECT  customer_id, min(order_date) as first_visit_date
FROM customer_orders
group by customer_id),
visit_flag as (
SELECT  co.*, fv.first_visit_date,
CASE WHEN co.order_date = fv.first_visit_date THEN 1 ELSE 0 END as first_visit_flag,
CASE WHEN co.order_date != fv.first_visit_date THEN 1 ELSE 0 END as Repeat_visit_flag
FROM customer_orders co
inner join first_visit fv on co.customer_id=fv.customer_id)
SELECT order_date, 
sum(first_visit_flag) as no_of_new_cust,
sum(Repeat_visit_flag) as no_of_repeat_cust
FROM visit_flag
GROUP BY order_date;
GO

with first_visit as(
SELECT  customer_id, min(order_date) as first_visit_date
FROM customer_orders
group by customer_id)
SELECT  co.order_date, 
SUM(CASE WHEN co.order_date = fv.first_visit_date THEN 1 ELSE 0 END)as first_visit_flag,
SUM(CASE WHEN co.order_date != fv.first_visit_date THEN 1 ELSE 0 END)as Repeat_visit_flag
FROM customer_orders co
inner join first_visit fv on co.customer_id=fv.customer_id
GROUP BY co.order_date
GO

Select a.order_date,
Sum(Case when a.order_date = a.first_order_date then 1 else 0 end) as new_customer,
Sum(Case when a.order_date != a.first_order_date then 1 else 0 end) as repeat_customer
from(Select customer_id, order_date, min(order_date) over(partition by customer_id) as first_order_date
from customer_orders) a 
group by a.order_date
GO

/*3.  Scenario based Interviews Question for Product companies */
create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));
GO

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')
GO

SELECT *
FROM entries;
GO

with
distinct_resources as (select distinct name,resources from entries)
,agg_resources as (
select name, STRING_AGG(resources,',') as used_resources 
FROM distinct_resources Group by name)
,total_visit as (
SELECT name,count(1) as total_visits, STRING_AGG(resources,',') as resources 
FROM entries GROUP BY name)
,floor_visit as(
SELECT name, floor,count(1) as no_of_time,
rank() over(partition by name order by count(1) desc) as rn
FROM entries group by name, floor)
SELECT fv.name, fv.floor as most_visited_floor,tv.total_visits,ar.used_resources
FROM floor_visit fv 
inner join total_visit tv on fv.name=tv.name
inner join agg_resources ar on fv.name=ar.name
WHERE rn=1
GO

--SELECT name,count(1) as total_visits, STRING_AGG(resources,',') as resources 
--FROM entries
--GROUP BY name;
GO

/*4.   */