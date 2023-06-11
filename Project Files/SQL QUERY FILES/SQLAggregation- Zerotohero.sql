--ALL ABOUT AGGREGATION in SQL. ZERO to HERO
CREATE TABLE [dbo].[int_orders](
 [order_number] [int] NOT NULL,
 [order_date] [date] NOT NULL,
 [cust_id] [int] NOT NULL,
 [salesperson_id] [int] NOT NULL,
 [amount] [float] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[int_orders] ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) 
VALUES (30, CAST(N'1995-07-14' AS Date), 9, 1, 460),
		(10, CAST(N'1996-08-02' AS Date), 4, 2, 540),
		(40, CAST(N'1998-01-29' AS Date), 7, 2, 2400),
		(50, CAST(N'1998-02-03' AS Date), 6, 7, 600),
		(60, CAST(N'1998-03-02' AS Date), 6, 7, 720),
		(70, CAST(N'1998-05-06' AS Date), 9, 7, 150),
		(20, CAST(N'1999-01-30' AS Date), 4, 8, 1800);
GO
-- sum(), avg(), min(), max()

SELECT * 
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount
FROM int_orders;

-- simple sum
SELECT sum(amount) from int_orders;

SELECT salesperson_id, sum(amount)
FROM int_orders
GROUP BY salesperson_id;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over() -- all val 6670
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over(partition by salesperson_id)
FROM int_orders; 

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over(order by order_date)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over(partition by salesperson_id order by order_date)
FROM int_orders; -- both

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (order by order_date rows between 2 preceding and current row)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (order by order_date rows between 2 preceding and 1 preceding)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (order by order_date rows between 2 preceding and 1 following)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (order by order_date rows between unbounded preceding and current row)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (partition by salesperson_id order by order_date rows between 1 preceding and current row)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (order by order_date rows between 1 preceding and 1 preceding)
FROM int_orders;

SELECT salesperson_id, order_number, order_date,amount,
sum(amount) over (order by order_date rows between 1 following and 1 following)
FROM int_orders;