--CREATE DATABASE pbitrainingMay22;
USE pbitrainingMay22;
GO

CREATE TABLE department(
DeptID Int,
DeptName varchar(20));

SELECT * FROM department;
GO

CREATE TABLE Student(
StudentID int,
StudentName varchar(30),
StudentAge int,
StudentHeight Float);

SELECT * FROM Student;
GO

INSERT INTO Student 
VALUES(1,'Manish',24,168),
	  (2,'Shankar',35,197),
	  (3,'Anand',27,125),
	  (4,'Rahul',25,162);
GO

--DROP TABLE Student; -- Delect table structure and data
--GO

--TRUNCATE TABLE Student; -- Delect data only
--GO

ALTER TABLE Student
ADD Gender Char;

ALTER TABLE Student
ADD emailID Varchar(30);
GO

ALTER TABLE Student
DROP Column Gender;
GO

UPDATE Student Set Gender = 'M' , emailID = 'abc@example.com' 
WHERE StudentID = 1;
GO

