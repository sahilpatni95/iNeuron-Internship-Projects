-- TODO: Connect DATABASE to the program my_car_solution.SQL

-- SHOW DATABASES;
-- USE lco_car_rentals;
-- SHOW tables;
-- DESC customer;

--  TODO:  Q1. Insert the details of new customer:-
--          First name : Nancy
--          Last Name: Perry
--          Dob : 1988-05-16
--          License Number: K59042656E
--          Email : nancy@gmail.com

-- SELECT * FROM customer;
-- Insert INTO customer (first_name, last_name, dob, driver_license_number, email) 
-- VALUES ('Nancy', 'Perry', '1988-05-16', 'K59042656E', 'nancy@gmail.com');

-- SELECT * FROM customer;

-- TODO: Q2. The new customer (inserted above) wants to rent a car 
-- from 2020-08-25 to 2020-08-30. More details are as follows:(6)
-- Vehicle Type : Economy SUV (4)
-- Fuel Option : Market (3)
-- Pick Up location: 5150 W 55th St , Chicago, IL, zip- 60638 (7)
-- Drop Location: 9217 Airport Blvd, Los Angeles, CA, zip - 90045 (4)

-- select * FROM rental;
-- SELECT * FROM vehicle_type;
-- SELECT * FROM fuel_option;
-- SELECT * FROM location;
 
-- INSERT INTO `rental` (`start_date`, `end_date`, `customer_id`, `vehicle_type_id`, `fuel_option_id`, `pickup_location_id`, `drop_off_location_id`) 
--             VALUES ("2020-08-25", "2020-08-30",
--                     (SELECT customer.id FROM customer WHERE driver_license_number = 'K59042656E'),
--                     (SELECT vehicle_type.id FROM vehicle_type WHERE name = 'Economy SUV'),
--                     (SELECT fuel_option.id FROM fuel_option WHERE name = 'Market'),
--                     (SELECT location.id FROM location WHERE zipcode='60638'),
--                     (SELECT location.id FROM location WHERE zipcode='90045'));

-- select * FROM rental;

-- TODO:Q3. The customer with the driving license W045654959 changed his/her drop off location to 
--         1001 Henderson St,  Fort Worth, TX, zip - 76102  and 
--         wants to extend the rental upto 4 more days. Update the record.

-- UPDATE `rental` INNER JOIN customer ON customer.id = rental.customer_id 
-- SET drop_off_location_id = (SELECT location.id FROM location WHERE location.zipcode=76102) , 
-- end_date=(SELECT end_date + INTERVAL 4 DAY) WHERE customer.driver_license_number="W045654959";

-- -- TODO: Q4. Fetch all rental details with their equipment type.
-- SELECT concat( customer.first_name, ' ', customer.last_name ) AS customer_name,
--         customer.driver_license_number,
--         rental.start_date AS start_date,
--         rental.end_date AS end_date,
--         vehicle_type.name AS vehicle_type, 
--         fuel_option.name AS fuel_option,
--         concat(location.street_address,", ",location.city,", ",location.state,", ",location.zipcode) AS Pickup_location,
--         concat(drop_location.street_address,", ",drop_location.city,", ",drop_location.state,", ",drop_location.zipcode) AS drop_location,
--         equipment_type.name AS equipment_type
--         FROM rental 
--         inner join customer on customer.id = rental.customer_id
--         inner join vehicle_type on vehicle_type.id = rental.vehicle_type_id
--         inner join fuel_option on fuel_option.id = rental.fuel_option_id
--         inner join location on location.id = rental.pickup_location_id
--         inner join location drop_location on drop_location.id = rental.drop_off_location_id
--         inner join rental_has_equipment_type on rental_has_equipment_type.rental_id = rental.id
--         inner join equipment_type on equipment_type.id = rental_has_equipment_type.equipment_type_id;

-- TODO: Q5. Fetch all details of vehicles.
-- SELECT * FROM vehicle;
-- SELECT vehicle.brand, vehicle.model, vehicle.model_year, vehicle.mileage,vehicle.color,
--         vehicle_type.name AS vehicle_type, 
--         concat(location.street_address,", ",location.city,", ",location.state,", ",location.zipcode) AS location
--     FROM vehicle
--     LEFT JOIN vehicle_type ON vehicle_type_id = vehicle_type.id
--     LEFT JOIN location ON current_location_id = location.id;

-- TODO: Q6. Get driving license of the customer with most rental insurances.
-- SELECT customer.driver_license_number,
--         COUNT(rental_has_insurance.rental_id) AS number_of_rentals
--         FROM customer
--         LEFT JOIN rental ON rental.customer_id = customer.id
--         LEFT JOIN rental_has_insurance ON rental_has_insurance.rental_id = rental.id
--         Group by customer.driver_license_number
--         order by number_of_rentals desc
--         limit 1;

-- TODO: Q7. Insert a new equipment type with following details.
-- Name : Mini TV
-- Rental Value : 8.99

-- INSERT INTO equipment_type(name, rental_value)
-- VALUES ('Mini TV', 8.99);

-- TODO: Q8. Insert a new equipment with following details:
-- Name : Garmin Mini TV
-- Equipment type : Mini TV (4)
-- Current Location zip code : 60638

-- INSERT INTO equipment(name, equipment_type_id, current_location_id)
-- Values ('Garmin Mini TV',
--         (SELECT equipment_type.id FROM equipment_type WHERE equipment_type.name = 'Mini TV'),
--         (SELECT location.id FROM location WHERE location.zipcode = 60638));

-- TODO: Q9. Fetch rental invoice for customer (email: smacias3@amazonaws.com) 

-- select customer.email, rental_invoice.net_amount_payable
--         FROM rental_invoice
--         LEFT JOIN rental ON rental.id = rental_invoice.rental_id,
--         LEFT JOIN customer ON customer.id = rental.customer_id
--         WHERE customer.email = "smacias3@amazonaws.com";

-- SELECT * FROM rental_invoice 
-- LEFT JOIN rental ON rental.id = rental_invoice.rental_id 
-- LEFT JOIN customer ON customer.id = rental.customer_id 
-- WHERE customer.email = "smacias3@amazonaws.com";

-- TODO:Q10. Insert the invoice for customer (driving license: K59042656E) with following details:-
-- Car Rent : 785.4
-- Equipment Rent : 114.65
-- Insurance Cost : 688.2
-- Tax : 26.2
-- Total: 1614.45
-- Discount : 213.25
-- Net Amount: 1401.2

-- INSERT INTO rental_invoice(car_rent, equipment_rent_total, insurance_cost_total,
--                             tax_surcharges_and_fees, total_amount_payable, discount_amount,
--                             net_amount_payable, rental_id) 
--                     VALUES(785.4, 114.65, 688.2, 26.2, 1614.45, 213.25, 1401.2,
--                     (SELECT rental.id from rental WHERE rental.customer_id = 
--                     (SELECT customer.id FROM customer 
--                     WHERE customer.driver_license_number = 'K59042656E')));

-- TODO: Q11. Which rental has the most number of equipment.

-- SELECT rental_has_equipment_type.rental_id,
--         COUNT(rental_has_equipment_type.rental_id) AS number_of_rentals
--         FROM rental_has_equipment_type
--         Group by rental_has_equipment_type.rental_id
--         Order by number_of_rentals desc limit 1;

-- TODO: Q12. Get driving license of a customer with least number of rental licenses.

-- SELECT customer.driver_license_number,
--         count(rental_has_insurance.rental_id) AS number_of_rentals
--         FROM customer
--         LEFT JOIN rental ON rental.customer_id = customer.id
--         LEFT JOIN rental_has_insurance ON rental_has_insurance.rental_id = rental.id
--         Group by customer.driver_license_number
--         Order by number_of_rentals asc limit 1;

-- TODO: Q13. Insert new location with following details.
-- Street address : 1460  Thomas Street
-- City : Burr Ridge , State : IL, Zip - 61257

-- INSERT INTO location(street_address, city, state, zipcode)
--             VALUES('1460  Thomas Street', 'Burr Ridge', 'IL', '61257');

-- select * from location;  

-- TODO: Q14. Add the new vehicle with following details:-
-- Brand: Tata 
-- Model: Nexon
-- Model Year : 2020
-- Mileage: 17000
-- Color: Blue
-- Vehicle Type: Economy SUV 
-- Current Location Zip: 20011 

-- INSERT INTO vehicle(brand, model, model_year, mileage, color, vehicle_type_id, current_location_id)
--             Values('tata','nexon',2020,17000,'blue',
--             (SELECT vehicle_type.id FROM vehicle_type WHERE vehicle_type.name = 'Economy SUV'),
--             (SELECT location.id FROM location WHERE location.zipcode = 20011));

-- TODO: Q15. Insert new vehicle type Hatchback and rental value: 33.88.
-- INSERT INTO vehicle_type(name, rental_value) 
--             VALUES('Hatchback', 33.88);
-- select * from vehicle_type; 

-- TODO: Q16. Add new fuel option Pre-paid (refunded).
-- INSERT INTO `fuel_option`(`name`, `description`) 
-- VALUES ("Pre-paid (refunded)" , 
-- "Customer buy a tank of fuel at pick-up and get refunded the amount customer don’t use.");
-- select * from fuel_option;

-- TODO: Q17. Assign the insurance : Cover My Belongings (PEP), 
-- Cover The Car (LDW) to the rental started on 25-08-2020 (created in Q2) by 
-- customer (Driving License:K59042656E).

-- INSERT INTO rental_has_insurance(rental_id, insurance_id) 
-- VALUES((SELECT rental.id FROM rental 
--         inner join customer ON customer.id = rental.customer_id 
--         WHERE rental.start_date = '2020-08-25' AND customer.driver_license_number = 'K59042656E'),
--         (SELECT insurance.id FROM insurance WHERE insurance.name = 'Cover My Belongings (PEP)')),

--         ((SELECT rental.id FROM rental 
--         inner join customer ON customer.id = rental.customer_id 
--         WHERE rental.start_date = '2020-08-25' AND customer.driver_license_number = 'K59042656E'),
--         (SELECT insurance.id FROM insurance WHERE insurance.name = 'Cover The Car (LDW)'));

-- select * from rental_has_insurance;

-- TODO: Q18. Remove equipment_type :
-- Satellite Radio from rental started on 2018-07-14 and ended on 2018-07-23.
-- delete from rental_has_equipment_type 
-- where rental_has_equipment_type.rental_id = 
-- (SELECT rental.id FROM rental where rental.start_date = '2018-07-14' AND rental.end_date = '2018-07-23')
-- AND rental_has_equipment_type.equipment_type_id =
-- (SELECT equipment_type.id FROM equipment_type WHERE equipment_type.name = 'Satellite Radio');

-- TODO: Q19. Update phone to 510-624-4188 of customer (Driving License: K59042656E).

-- UPDATE customer SET phone = '510-624-4188' where
-- driver_license_number = 'K59042656E';
-- SELECT * FROM customer;

-- TODO: Q20. Increase the insurance cost of Cover The Car (LDW) by 5.65.
-- UPDATE insurance SET cost = cost + 5.65 where name = 'Cover The Car (LDW)';

-- TODO: Q21. Increase the rental value of all equipment types by 11.25.
-- UPDATE equipment_type SET rental_value = rental_value + 11.25;

-- TODO: Q22. Increase the cost of all rental insurances except Cover The Car (LDW) by 
-- twice the current cost.

-- UPDATE insurance SET cost = cost * 2 where name != 'Cover The Car (LDW)';

-- TODO: Q23. Fetch the maximum net amount of invoice generated.
-- select MAX(net_amount_payable) from rental_invoice;

-- TODO: Q24. Update the dob of customer with driving license V435899293 to 1977-06-22.

-- Update customer SET dob = '1977-06-22' where driver_license_number='V435899293';

-- TODO: Q25. Insert new location with following details.
-- Street address : 468  Jett Lane
-- City : Gardena , State : CA, Zip - 90248

-- INSERT INTO location(street_address, city, state, zipcode)
-- VALUES ('468  Jett Lane', 'Gardena', 'CA', '90248');

-- TODO: Q26. The new customer (Driving license: W045654959) wants to rent 
-- a car from 2020-09-15 to 2020-10-02. More details are as follows: 
-- Vehicle Type : Hatchback
-- Fuel Option : Pre-paid (refunded)
-- Pick Up location:  468  Jett Lane , Gardena , CA, zip- 90248
-- Drop Location: 5911 Blair Rd NW, Washington, DC, zip - 20011

-- INSERT INTO `rental` (`start_date`, `end_date`, `customer_id`, `vehicle_type_id`, `fuel_option_id`, `pickup_location_id`, `drop_off_location_id`) 
--             VALUES ("2020-09-15", "2020-10-02",
--                     (SELECT customer.id FROM customer WHERE driver_license_number = 'W045654959'),
--                     (SELECT vehicle_type.id FROM vehicle_type WHERE name = 'Hatchback'),
--                     (SELECT fuel_option.id FROM fuel_option WHERE name = 'Pre-paid (refunded)'),
--                     (SELECT location.id FROM location WHERE zipcode='90248'),
--                     (SELECT location.id FROM location WHERE zipcode='20011'));

-- select * from rental;

-- TODO: Q27. Replace the driving license of the customer 
-- (Driving License: G055017319) with new one K16046265.

-- UPDATE customer SET driver_license_number = 'K16046265' where driver_license_number = 'G055017319';

-- TODO: Q28. Calculated the total sum of all insurance costs of all rentals.

-- SELECT sum(insurance.cost) from rental_has_insurance
-- inner join insurance on insurance.id = rental_has_insurance.insurance_id;

-- TODO: Q29. How much discount we gave to customers in total in the rental invoice?

-- select sum(discount_amount) from rental_invoice;

-- TODO: Q30. The Nissan Versa has been repainted to black. Update the record.

-- UPDATE vehicle SET color = 'black' where brand = 'Nissan' AND model='Versa';