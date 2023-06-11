CREATE TABLE name (f_name nvarchar(100));
GO
Insert into name (f_name)
values ('i     n        d        i       a'),
('au   r a n a     g   a          b    a  d' ) ;
GO
select * from name;
GO
SELECT REPLACE(f_name,' ','<>')
FROM name;
GO
SELECT REPLACE(
		REPLACE(f_name,' ','<>')
		,'><','')		
FROM name;
Go
SELECT REPLACE(
				REPLACE(
						REPLACE(	
								f_name,' ','<>')
						,'><','')
				,'<>',' ')
FROM name;
GO

DROP table name;