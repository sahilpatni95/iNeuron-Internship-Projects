/****** Script for SelectTopNRows command from SSMS  ******/
--CREATE PROCEDURE dbo.InsertInto @state nvarchar(30), @population int
--AS
--BEGIN
--	INSERT INTO dbo.States_in_USA(
--		State, Population)
--		VALUES(@state, @population)
--END

SELECT TOP (1000) [id]
      ,[task_date]
      ,[task_type]
      ,[amount]
  FROM [DB_Test].[dbo].[sample]
GO


CREATE PROCEDURE task_type
	@task_type varchar(255)
AS
	SELECT task_type, amount
	FROM sample
	WHERE task_type = @task_type;
GO

EXECUTE task_type @task_type = "buy";
EXECUTE task_type @task_type = "send";
EXECUTE task_type @task_type = "close";

GO
CREATE PROCEDURE add_task
	@task_type varchar(255),
	@amount int
AS
BEGIN
	INSERT INTO sample(task_date,task_type,amount)
	VALUES ('11-11-2022',@task_type, @amount)
END
GO

EXEC add_task 'buy' , 200
EXEC add_task 'close' , 909

SELECT * FROM [DB_Test].[dbo].[sample]