/*
CREATE table activity(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);

delete from activity;

insert into activity values (1,'app-installed','2022-01-01','India')
							,(1,'app-purchase','2022-01-02','India')
							,(2,'app-installed','2022-01-01','USA')
							,(3,'app-installed','2022-01-01','USA')
							,(3,'app-purchase','2022-01-03','USA')
							,(4,'app-installed','2022-01-03','India')
							,(4,'app-purchase','2022-01-03','India')
							,(5,'app-installed','2022-01-03','SL')
							,(5,'app-purchase','2022-01-03','SL')
							,(6,'app-installed','2022-01-04','Pakistan')
							,(6,'app-purchase','2022-01-04','Pakistan');
*/

SELECT * FROM activity;

/*
Q1 : Find total active users each day
event_date  total_active_users
2022-01-01	3
2022-01-02	1
2022-01-03	3
2022-01-04	1
*/

SELECT event_date, count(distinct user_id) as total_active_users
FROM activity
GROUP BY event_date;

/*
Q2 : Find total active users each week
week_number total_active_users
1			3
2			5
*/

SELECT *, datepart(week,event_date)
FROM activity

SELECT datepart(week,event_date) AS week_number, count(distinct user_id) as total_active_users
FROM activity
GROUP BY datepart(week,event_date);

/*
Q3 : date wise total number of users who made the purchare same day they installed the app

event_date	no_of_users_same_day_purchase
2022-01-01	0
2022-01-02	0
2022-01-03	2
2022-01-04	1
*/

--SELECT event_date, count(user_id) as no_of_users 
--FROM(
--SELECT user_id, event_date, count(distinct event_name) AS no_of_events
--FROM activity
--GROUP BY user_id, event_date
--HAVING count(distinct event_name) = 2) a
--GROUP BY event_date;

SELECT event_date, count(new_user) as no_of_users 
FROM(
SELECT user_id, event_date, 
CASE WHEN count(distinct event_name) = 2 THEN user_id ELSE null END AS new_user
FROM activity
GROUP BY user_id, event_date
--HAVING count(distinct event_name) = 2
) a
GROUP BY event_date

/*
Q4 : Percentage of paid users in india, usa and any other country should be tagged as others
country Percentage_user
India	40
USA		20
Others	40
*/


--SELECT country, count(distinct user_id) 
--FROM activity
--WHERE event_name='app-purchase'
--GROUP BY country;

--SELECT 
--CASE when country in ('USA','India') then country else 'other' end as new_country,
--count(distinct user_id) 
--FROM activity
--WHERE event_name='app-purchase'
--GROUP BY CASE when country in ('USA','India') then country else 'other' end ;

with country_users as(
SELECT CASE when country in ('USA','India') then country else 'other' end as new_country,
count(distinct user_id) as user_cnt
FROM activity
WHERE event_name='app-purchase'
GROUP BY CASE when country in ('USA','India') then country else 'other' end)
, total as (select sum(user_cnt) as total_users From country_users)

Select 
new_country, user_cnt*1.0/total_users * 100 as perc_useres
From country_users, total;


/*
Q5 : Among all the users who installed the app on a given day, how many did in app purchared on the very next day -- day wise result
event_date	cnt_users
2022-01-01	0
2022-01-02	1
2022-01-03	0
2022-01-04	0
*/

with prev_data as(
SELECT *,
lag(event_name,1) over(partition by user_id order by event_date) as prev_event_name,
lag(event_date,1) over(partition by user_id order by event_date) as prev_event_date
FROM activity)
SELECT event_date, count(distinct user_id) as cnt_users 
FROM prev_data
WHERE event_name='app-purchase' and prev_event_name='app-installed'
and DATEDIFF(day,prev_event_date, event_date)=1
GROUP BY event_date;