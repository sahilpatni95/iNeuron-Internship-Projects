
--CREATE TABLE sales (
--  "customer_id" VARCHAR(1),
--  "order_date" DATE,
--  "product_id" INTEGER
--);
--GO

--INSERT INTO sales
--  ("customer_id", "order_date", "product_id")
--VALUES
--  ('A', '2021-01-01', '1'),
--  ('A', '2021-01-01', '2'),
--  ('A', '2021-01-07', '2'),
--  ('A', '2021-01-10', '3'),
--  ('A', '2021-01-11', '3'),
--  ('A', '2021-01-11', '3'),
--  ('B', '2021-01-01', '2'),
--  ('B', '2021-01-02', '2'),
--  ('B', '2021-01-04', '1'),
--  ('B', '2021-01-11', '1'),
--  ('B', '2021-01-16', '3'),
--  ('B', '2021-02-01', '3'),
--  ('C', '2021-01-01', '3'),
--  ('C', '2021-01-01', '3'),
--  ('C', '2021-01-07', '3');
--GO

--CREATE TABLE menu (
--  "product_id" INTEGER,
--  "product_name" VARCHAR(5),
--  "price" INTEGER
--);
--GO

--INSERT INTO menu
--  ("product_id", "product_name", "price")
--VALUES
--  ('1', 'sushi', '10'),
--  ('2', 'curry', '15'),
--  ('3', 'ramen', '12');
--GO  

--CREATE TABLE members (
--  "customer_id" VARCHAR(1),
--  "join_date" DATE
--);
--GO

--INSERT INTO members
--  ("customer_id", "join_date")
--VALUES
--  ('A', '2021-01-07'),
--  ('B', '2021-01-09');
--GO

--SELECT * from members;
--SELECT * from menu;
--SELECT * from sales;
--GO

/*
Q.1 What is the total amount each customer spent at the restaurant?
*/

SELECT sales.customer_id, SUM(menu.price) AS total_amount
FROM sales
inner join menu ON sales.product_id = menu.product_id
GROUP BY sales.customer_id;
GO

/*
Q.2 How many days has each customer visited the restaurant?
*/

SELECT sales.customer_id, COUNT(order_date) AS visited_date
FROM sales
GROUP BY sales.customer_id;
GO

/*
Q.3 What was the first item from the menu purchased by each customer?
*/

 SELECT customer_id, product_name, order_date
  FROM dbo.sales
  INNER JOIN dbo.menu
  ON dbo.sales.product_id = dbo.menu.product_id
  WHERE order_date = '2021-01-01'
  ORDER BY order_date
GO

/*
Q.4 What is the most purchased item on the menu and how many times was it purchased by all customers?
*/

SELECT menu.product_name, count(sales.product_id) as total_item
	from sales
	inner join menu
	on sales.product_id = menu.product_id
	group by menu.product_name
	order by count(sales.product_id) DESC
GO

/*
Q.5 Which item was the most popular for each customer?
*/

with rank as(
select sales.customer_id,
menu.product_name,
count(*) as order_count,
dense_rank() over(partition by sales.customer_id
order by count(sales.customer_id)desc) as rank
FROM dbo.sales
INNER JOIN dbo.menu
ON dbo.sales.product_id = dbo.menu.product_id
group by sales.customer_id,menu.product_name)

Select Customer_id,Product_name,order_Count
From rank
where rank = 1

GO

/*
Q.6 Which item was purchased first by the customer after they became a member?
*/
SELECT dbo.sales.customer_id, dbo.sales.order_date, dbo.menu.product_name, dbo.members.join_date
FROM dbo.sales
JOIN dbo.menu
ON dbo.sales.product_id = dbo.menu.product_id
JOIN dbo.members
ON dbo.members.customer_id = dbo.sales.customer_id

WITH cte AS (
SELECT ROW_NUMBER () OVER (PARTITION BY dbo.members.customer_id ORDER BY dbo.menu.product_id) AS row_id, 
dbo.sales.customer_id, dbo.sales.order_date, dbo.menu.product_name 
FROM dbo.sales 
JOIN dbo.menu
ON dbo.sales.product_id = dbo.menu.product_id
JOIN dbo.members
ON dbo.members.customer_id = dbo.sales.customer_id
WHERE dbo.sales.order_date >= dbo.members.join_date)

SELECT * 
FROM cte 
WHERE row_id = 1


/*
Q.7 Which item was purchased just before the customer became a member?
*/
WITH cte AS (
SELECT ROW_NUMBER () OVER (PARTITION BY dbo.members.customer_id ORDER BY dbo.sales.order_date) AS row_id, 
dbo.sales.customer_id, dbo.sales.order_date, dbo.menu.product_name 
FROM dbo.sales 
	JOIN dbo.menu
	ON dbo.sales.product_id = dbo.menu.product_id
	JOIN dbo.members
	ON dbo.members.customer_id = dbo.sales.customer_id
	WHERE dbo.sales.order_date < dbo.members.join_date)

SELECT * 
FROM cte 
WHERE row_id = 1
GO

/*
Q.8 What is the total items and amount spent for each member before they became a member?
*/
SELECT  dbo.sales.customer_id, COUNT(DISTINCT dbo.menu.product_name) AS number_of_items, SUM(dbo.menu.price) AS Total
FROM dbo.sales
	JOIN dbo.menu
	ON dbo.sales.product_id = dbo.menu.product_id
	JOIN dbo.members
	ON dbo.members.customer_id = dbo.sales.customer_id
WHERE dbo.sales.order_date < dbo.members.join_date
GROUP BY   dbo.sales.customer_id

/*
Q.9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
*/
SELECT
dbo.sales.customer_id,
SUM(
	CASE
  	WHEN dbo.menu.product_name = 'sushi' THEN 20 * price
  	ELSE 10 * PRICE
	END
) AS Points
FROM dbo.sales
	JOIN dbo.menu
	ON dbo.sales.product_id = dbo.menu.product_id
GROUP BY
dbo.sales.customer_id
ORDER BY
dbo.sales.customer_id;


/*
Q.10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
*/

WITH dates_cte AS 
(SELECT *, DATEADD(DAY, 6, join_date) AS valid_date, EOMONTH('2021-01-31') AS last_date FROM members AS m)

 SELECT d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date, m.product_name, m.price,
 SUM(CASE WHEN m.product_name = 'sushi' THEN 2 * 10 * m.price
		 WHEN s.order_date BETWEEN d.join_date AND d.valid_date THEN 2 * 10 * m.price
		ELSE 10 * m.price END) AS points
FROM dates_cte AS d
	JOIN sales AS s
		ON d.customer_id = s.customer_id
	JOIN menu AS m
		ON s.product_id = m.product_id
	WHERE s.order_date < d.last_date
	GROUP BY d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date, m.product_name, m.price


/* Bonus Questions
Join All The Things*/
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN mm.join_date > s.order_date THEN 'N'
	 WHEN mm.join_date <= s.order_date THEN 'Y'
	 ELSE 'N' END AS member
FROM sales AS s
	LEFT JOIN menu AS m
	 ON s.product_id = m.product_id
	LEFT JOIN members AS mm
	 ON s.customer_id = mm.customer_id;

/*
Rank All The Things
*/
WITH summary_cte AS 
( SELECT s.customer_id, s.order_date, m.product_name, m.price,
  CASE  WHEN mm.join_date > s.order_date THEN 'N'
		WHEN mm.join_date <= s.order_date THEN 'Y'
		ELSE 'N' END AS member
 FROM sales AS s
	 LEFT JOIN menu AS m
	 ON s.product_id = m.product_id
	 LEFT JOIN members AS mm
	 ON s.customer_id = mm.customer_id
)
SELECT *, CASE
 WHEN member = 'N' then NULL
 ELSE
  RANK () OVER(PARTITION BY customer_id, member
  ORDER BY order_date) END AS ranking
FROM summary_cte;

/*
Drop table sales;
drop table members;
drop table menu;*/
