/** This query serves as 
	practice for handling null values */

USE [Advance Excercise]
GO

/** Creating sample table*/
DROP TABLE IF EXISTS Employees

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Department NVARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
)

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Department, Salary, HireDate) VALUES
	(1, 'John', 'Doe', 'john.doe@example.com', 'HR', 60000.00, '2019-05-01'),
	(2, 'Jane', 'Smith', 'jane.smith@example.com', 'Finance', 75000.00, '2020-01-15'),
	(3, 'Sam', 'Williams', 'sam.williams@example.com', 'IT', 50000.00, NULL),
	(4, '', 'Brown', 'emily.brown@example.com', 'Marketing', 55000.00, '2021-07-22'),
	(5, 'Michael', 'Johnson', '', 'Sales', NULL, '2018-11-30'),
	(6, 'Anna', 'Davis', 'anna.davis@example.com', NULL, 48000.00, '2022-03-10'),
	(7, 'James', 'Miller', 'james.miller@example.com', 'Operations', 62000.00, '2017-09-05'),
	(8, 'Laura', '', 'laura.lee@example.com', 'HR', 58000.00, '2019-12-19'),
	(9, 'David', 'Garcia', 'david.garcia@example.com', 'IT', 71000.00, NULL),
	(10, 'Sarah', 'Martinez', NULL, '', NULL, '2023-01-25')



/** 1. Select all rows with NULL values in specific columns:
Example: Find all employees with a NULL Email. */
SELECT 
	*
FROM 
	[Advance Excercise]..Employees
WHERE 
	Email IS NULL


/** 2. Select all rows with blank values in specific columns:
Example: Find all employees with a blank FirstName */
SELECT
	*
FROM
	[Advance Excercise]..Employees
WHERE
	FirstName = ''


/** 3. Replace NULL and blank values with default values using COALESCE or ISNULL:
Example: Replace NULL or blank Department with 'Unassigned'. */

SELECT * FROM [Advance Excercise]..Employees

SELECT
	EmployeeID,
	COALESCE(NULLIF(FirstName, ''), 'Unassigned') AS FirstName,
	COALESCE(NULLIF(LastName, ''), 'Unassigned') AS LastName,
	COALESCE(NULLIF(Email, ''), 'Unassigned') AS Email,
	COALESCE(NULLIF(Department, ''), 'Unassigned') AS Department,
	COALESCE(Salary, 0) AS Salary,
	COALESCE(HireDate, CAST('1900-01-01' AS Date)) AS HiireDate
FROM	
	[Advance Excercise]..Employees

/** NULLIF(Department, '') returns NULL if the Department or row
is blank, which allows COALESCE to replace both NULL and blank values 
with 'Unassigned'.*/

/** 4. Calculate statistics excluding NULL values:
Example: Calculate the average salary excluding NULL values. */
SELECT
	FirstName,
	LastName,
	Salary,
	AVG(Cast(Salary AS FLOAT)) OVER() AS AvgSalary
FROM 
	[Advance Excercise]..Employees
WHERE 
	Salary IS NOT NULL


/** 5. Filter out rows with NULL or blank values:
Example: Find all employees who have a non-NULL, non-blank HireDate.*/
SELECT *
FROM [Advance Excercise]..Employees
WHERE HireDate IS NOT NULL AND
	HireDate <> '' AND
	FirstName IS NOT NULL AND
	FirstName <> '' AND
	LastName IS NOT NULL AND
	LastName <> '' AND
	Email IS NOT NULL AND
	Email <> '' AND
	DepartMent IS NOT NULL AND
	DepartMent <> '' AND
	Salary IS NOT NULL AND
	Salary <> 0



/**  Updating blank and null with new string/numeric value
	using SWITCH CASE statement*/
SELECT
*,
	CASE WHEN FirstName IS NULL THEN 'Unassigned'
		 WHEN FirstName = '' THEN 'Unassigned'
		 ELSE FirstName 
	END AS FirstNameUpdated,
	CASE WHEN LastName IS NULL THEN 'Unassigned'
		 WHEN LastName = '' THEN 'Unassigned'
		 ELSE LastName 
	END AS LastNameUpdated,
	CASE WHEN Email IS NULL THEN 'Unassigned'
		 WHEN Email = '' THEN 'Unassigned'
		 ELSE Email 
	END AS EmailUpdated,
	CASE WHEN Email IS NULL THEN 'Unassigned'
		 WHEN Email = '' THEN 'Unassigned'
		 ELSE Email 
	END AS EmailUpdated,
	CASE WHEN Department IS NULL THEN 'Unassigned'
		 WHEN Department = '' THEN 'Unassigned'
		 ELSE Department 
	END AS DepartmentUpdated,
	CASE WHEN Salary IS NULL THEN 0
		 WHEN Salary = 0 THEN 0
		 ELSE Salary 
	END AS SalaryUpdated
FROM [Advance Excercise]..Employees



-- Selecting rows without null and only blank values
-- It is very unconventional and long to write.
SELECT FirstName,
	LastName,
	Email
FROM [Advance Excercise]..Employees
WHERE Email IS NOT NULL AND
	Email <> '' AND
	FirstName IS NOT NULL AND
	FirstName <> '' AND
	LastName IS NOT NULL AND
	LastName <> ''


-- Using ISNULL() Function
SELECT FirstName,
	ISNULL(FirstName, 'No Value') AS NullInFirstName,
	LastName,
	ISNULL(LastName, 'No Value') AS NullInLastName,
	Email,
	ISNULL(Email, 'No Value') AS NullInEmail
FROM [Advance Excercise]..Employees
