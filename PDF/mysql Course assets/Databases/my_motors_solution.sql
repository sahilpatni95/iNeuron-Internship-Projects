-- SHOW DATABASES;
-- USE lco_motors;
-- SHOW TABLES;

-- TODO: Q1. How would you fetch details of the customers  who cancelled orders?

-- select * from orders where status = 'cancelled';

-- select customers.customer_id, customers.customer_name, orders.order_id, orders.status 
-- from customers inner join orders on customers.customer_id = orders.customer_id
-- where orders.status = 'cancelled';

-- select * from customers 
-- left join orders on customers.customer_id = orders.customer_id
-- where orders.status = 'cancelled';

-- TODO: Q2. Fetch the details of customers who have done payments between the amount 5,000 and 35,000?

-- select customers.customer_id, payments.amount 
-- from customers 
-- left join payments on customers.customer_id = payments.customer_id
-- where payments.amount between 5000 and 35000 
-- order by payments.amount;

-- TODO: Q3. Add new employee/salesman with following details:-
-- EMP ID - 15657
-- First Name : Lakshmi
-- Last Name: Roy
-- Extension : x4065
-- Email: lakshmiroy1@lcomotors.com
-- Office Code: 4
-- Reports To: 1088
-- Job Title: Sales Rep

-- select * from employees;
-- insert into employees (employee_id, first_name, last_name, extension, email, office_code, reports_to, job_title)
-- VALUES (15657,'Lakshmi', 'Roy', 'x4065','lakshmiroy1@lcomotors.com',4, 1088, 'Sales Rep');

-- TODO: Q4. Assign the new employee to the customer whose phone is 2125557413 .

-- UPDATE customers SET sales_employee_id = 15657 WHERE customer_id = 151;

-- select customer_id, phone, sales_employee_id  from customers where phone = 2125557413;

-- TODO: Q5. Write a SQL query to fetch shipped motorcycles.
--  DISTINCT 

-- select orders.order_id, customers.customer_id, products.product_line, 
-- orderdetails.product_code , products.product_name 
-- from orders
-- left join customers on orders.customer_id = customers.customer_id
-- left join orderdetails on orders.order_id = orderdetails.order_id
-- left join products on orderdetails.product_code = products.product_code
-- where products.product_line = 'motorcycles'
-- limit 15;

-- TODO: Q6. Write a SQL query to get details of all employees/salesmen in the office located in Sydney

-- select * from employees 
-- where office_code = 
-- (select office_code from offices where city = 'Sydney');

-- TODO: Q7. How would you fetch the details of customers whose orders are in process?

-- select *  from customers
-- where customer_id in (select customer_id from orders where status = 'in process');

-- select *, orders.status from customers
-- left join orders on customers.customer_id = orders.customer_id
-- where orders.status = 'in process';

-- TODO: Q8. How would you fetch the details of products with less than 30 orders?
-- Show tables;
-- select products.product_name, orderdetails.product_code, 
-- orderdetails.quantity_ordered, productlines.product_line
-- from products
-- right join productlines on products.product_line = productlines.product_line
-- left join orderdetails on orderdetails.product_code = products.product_code
-- where orderdetails.quantity_ordered < 30
-- limit 15; 

-- TODO: Q9. It is noted that the payment (check number OM314933) was actually 2575. Update the record.

-- show tables;
--  select * from payments where check_number = 'OM314933' ;
-- UPDATE payments set amount = 2575 where check_number = 'OM314933';

-- TODO: Q10. Fetch the details of salesmen/employees dealing with customers whose orders are resolved.

-- select employees.employee_id, customers.customer_id, orders.order_id,orders.status
-- from employees 
-- left join customers on customers.sales_employee_id = employees.employee_id 
-- right join orders on orders.customer_id = customers.customer_id
-- where orders.status = 'resolved';

-- SELECT DISTINCT employees.employee_id, employees.first_name ,employees.last_name, employees.email, 
-- employees.job_title, employees.extension, customers.customer_id, orders.order_id, orders.status 
-- FROM employees 
-- LEFT JOIN customers ON customers.sales_employee_id = employees.employee_id 
-- RIGHT JOIN orders ON orders.customer_id = customers.customer_id 
-- WHERE orders.status = "Resolved";

-- TODO: Q11. Get the details of the customer who made the maximum payment.

-- SELECT customers.customer_id, customers.customer_name, MAX(payments.amount) AS max_amount
-- FROM customers 
-- LEFT JOIN payments on customers.customer_id = payments.customer_id;

-- TODO: Q12. Fetch list of orders shipped to France.

-- SELECT orders.order_id, orders.order_date, orders.status,
-- customers.customer_id, customers.customer_name, customers.country 
-- FROM orders
-- LEFT JOIN customers ON orders.customer_id = customers.customer_id
-- WHERE customers.country = 'France' and orders.status = 'shipped';

-- TODO: Q13. How many customers are from Finland who placed orders.

-- SELECT COUNT(customers.customer_id), customers.country 
-- FROM orders
-- LEFT JOIN customers ON orders.customer_id = customers.customer_id
-- WHERE customers.country = 'Finland';

-- SELECT customers.customer_id, orders.order_id, COUNT(customers.customer_id) 
-- FROM customers 
-- RIGHT JOIN orders ON orders.customer_id=customers.customer_id 
-- WHERE customers.country = "Finland";

-- TODO: Q14. Get the details of the customer who made the maximum payment.

-- SELECT * FROM customers 
-- WHERE customer_id = (Select customer_id From payments where amount = (Select MAX(amount) From payments));

-- SELECT * FROM customers 
-- RIGHT JOIN payments ON customers.customer_id = payments.customer_id 
-- WHERE payments.amount = (SELECT MAX(amount) from payments);

-- TODO: Q15. Get the details of the customer and payments they made between May 2019 and June 2019.

-- SELECT * FROM customers 
-- left JOIN payments ON customers.customer_id = payments.customer_id 
-- WHERE payments.payment_date BETWEEN '2019-05-01' AND '2019-06-01';

-- TODO: Q16. How many orders shipped to Belgium in 2018?

-- SELECT count(orders.order_id) FROM orders
-- inner JOIN customers ON orders.customer_id = customers.customer_id
-- where customers.country = 'Belgium' and orders.shipped_date BETWEEN '2018-01-01' AND '2018-12-31';

-- TODO: Q17. Get the details of the salesman/employee with offices dealing with customers in Germany.

-- select * from employees 
-- cross join offices on employees.office_code = offices.office_code
-- LEFT join customers on employees.employee_id = customers.sales_employee_id
-- where customers.country = 'Germany';

-- SELECT employees.employee_id, employees.first_name, 
-- employees.last_name, employees.email, employees.job_title, employees.extension, 
-- customers.customer_id, customers.country AS customer_country, offices.office_code, offices.address_line1, offices.address_line2, 
-- offices.phone, offices.city, offices.state, offices.country, offices.postal_code, offices.territory 
-- FROM employees 
-- CROSS JOIN offices ON  offices.office_code=employees.office_code 
-- LEFT JOIN customers on customers.sales_employee_id = employees.employee_id 
-- WHERE customers.country = "Germany";

-- TODO: Q18. The customer (id:496 ) made a new order today and the details are as follows:
-- Order id : 10426
-- Product Code: S12_3148
-- Quantity : 41
-- Each price : 151
-- Order line number : 11
-- Order date : <today’s date>
-- Required date: <10 days from today>
-- Status: In Process

-- insert into orders(order_id, order_date, required_date, status, customer_id)
-- values(10426, CURRENT_DATE(), (CURRENT_DATE() + INTERVAL 10 DAY), "In Process" , 496);

-- insert into orderdetails(order_id, product_code, quantity_ordered, each_price, order_line_number)
-- values(10426, "S12_3148", 41, 151, 11);

-- TODO: Q19. Fetch details of employees who were reported for the payments made by the 
-- customers between June 2018 and July 2018.

-- SELECT reported_emp.employee_id, reported_emp.first_name , 
-- reported_emp.last_name, reported_emp.email, reported_emp.job_title, 
-- reported_emp.extension , employees.employee_id AS reported_by_employee, 
-- customers.customer_id 
-- FROM employees 
-- JOIN employees reported_emp ON reported_emp.employee_id = employees.reports_to 
-- LEFT JOIN customers ON customers.sales_employee_id = employees.employee_id 
-- RIGHT JOIN payments ON payments.customer_id = customers.customer_id 
-- WHERE payments.payment_date BETWEEN '2018-06-01' AND '2018-07-31';

-- TODO: Q20. A new payment was done by a customer(id: 119). Insert the below details.
-- Check Number : OM314944
-- Payment date : <today’s date>
-- Amount : 33789.55

-- insert into payments(customer_id, check_number, payment_date, amount)
-- values(119, 'OM314944', CURRENT_DATE(), 33789.55);

-- TODO: Q21. Get the address of the office of the employees that reports to the employee whose id is 1102.

-- SELECT offices.office_code, offices.address_line1, offices.address_line2, 
-- offices.phone, offices.city, offices.state, offices.country, offices.postal_code, 
-- offices.territory, employees.employee_id, employees.reports_to
-- FROM employees 
-- JOIN employees reports_emp ON reports_emp.employee_id = employees.reports_to 
-- RIGHT JOIN offices ON offices.office_code = employees.office_code 
-- WHERE employees.reports_to = "1102";

-- TODO: Q22. Get the details of the payments of classic cars.

-- SELECT count(products.product_line) from payments
-- left join customers on payments.customer_id = customers.customer_id
-- left join orders on customers.customer_id = orders.customer_id
-- left join orderdetails on orders.order_id = orderdetails.order_id
-- left join products on orderdetails.product_code = products.product_code
-- where products.product_line = "Classic Cars";

-- SELECT payments.check_number, payments.payment_date, payments.amount, 
-- products.product_name, products.product_line , customers.customer_id AS done_by 
-- FROM payments 
-- LEFT JOIN customers ON customers.customer_id = payments.customer_id 
-- RIGHT JOIN orders ON orders.customer_id = customers.customer_id 
-- LEFT JOIN orderdetails ON orderdetails.order_id = orders.order_id 
-- LEFT JOIN products ON products.product_code = orderdetails.product_code 
-- WHERE products.product_line = "Classic Cars";

-- TODO: Q23. How many customers ordered from the USA?

-- SELECT count(*) FROM customers
-- left JOIN orders ON customers.customer_id = orders.customer_id
-- WHERE customers.country = "USA";

-- TODO: Q24. Get the comments regarding resolved orders.

-- SELECT orders.comments , orders.customer_id 
-- FROM `orders` WHERE orders.status = "Resolved"; 

-- TODO: Q25. Fetch the details of employees/salesmen in the USA with office addresses.

-- select * from employees
-- LEFT join offices on employees.office_code = offices.office_code
-- where offices.country = "USA";

-- SELECT employees.employee_id, employees.first_name ,employees.last_name, 
-- employees.email, employees.job_title, employees.extension,  offices.office_code, 
-- offices.address_line1, offices.address_line2, offices.phone, offices.city, offices.state, 
-- offices.country, offices.postal_code, offices.territory 
-- FROM employees 
-- LEFT JOIN offices ON offices.office_code = employees.office_code 
-- WHERE offices.country = "USA";

-- TODO: Q26. Fetch total price of each order of motorcycles. (Hint: quantity x price for each record).

-- SELECT orderdetails.product_code,products.product_name, 
-- products.product_line, orderdetails.quantity_ordered , orderdetails.each_price, 
-- orderdetails.quantity_ordered*orderdetails.each_price AS total_price  
-- FROM orderdetails
-- left join products on orderdetails.product_code = products.product_code
-- where products.product_line = "Motorcycles";

-- SELECT orderdetails.product_code,products.product_name, products.product_line, 
-- orderdetails.quantity_ordered , orderdetails.each_price, 
-- orderdetails.quantity_ordered*orderdetails.each_price AS total_price 
-- FROM orderdetails 
-- LEFT JOIN products ON products.product_code= orderdetails.product_code 
-- WHERE products.product_line = "Motorcycles";

-- TODO: Q27. Get the total worth of all planes ordered.

-- SELECT sum(orderdetails.quantity_ordered*orderdetails.each_price) AS total_price 
-- FROM orderdetails 
-- LEFT JOIN products ON products.product_code= orderdetails.product_code 
-- WHERE products.product_line = "planes";

-- TODO: Q28. How many customers belong to France?

-- select count(*) from customers where country = "France";

-- TODO: Q29. Get the payments of customers living in France.

-- SELECT payments.check_number, payments.payment_date, payments.amount
-- from payments
-- left join customers on customers.customer_id = payments.customer_id
-- where customers.country = "France";

-- TODO: Q30. Get the office address of the employees/salesmen who report to employee 1143.

-- select employees.employee_id, offices.office_code ,offices.city, offices.state, offices.country, employees.reports_to from employees
-- LEFT join offices on employees.office_code = offices.office_code
-- where employees.reports_to = "1143";

-- SELECT DISTINCT offices.office_code, offices.address_line1, offices.address_line2, 
-- offices.city, offices.phone, offices.state, offices.country, 
-- offices.postal_code, offices.territory , employees.employee_id 
-- FROM offices 
-- LEFT JOIN employees ON offices.office_code= employees.office_code 
-- WHERE employees.reports_to = 1143;
