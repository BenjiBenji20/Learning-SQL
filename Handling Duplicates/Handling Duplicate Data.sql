/** This query is for handling: duplicate, null and blank values
	perform: join and cte query */

USE [Advance Excercise]
GO

/** Creating tables and inserting data*/
DROP TABLE IF EXISTS Employees2
CREATE TABLE Employees2 (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    HireDate DATE
)

INSERT INTO Employees2 (EmployeeID, FirstName, LastName, Email, DepartmentID, Salary, HireDate) VALUES
	(1, 'John', 'Doe', 'john.doe@example.com', 1, 60000.00, '2019-05-01'),
	(2, 'Jane', 'Smith', 'jane.smith@example.com', 2, 75000.00, '2020-01-15'),
	(3, 'Sam', 'Williams', 'sam.williams@example.com', NULL, 50000.00, '2018-03-10'),
	(4, 'Emily', 'Brown', '', 1, 55000.00, '2021-07-22'),
	(5, 'Michael', 'Johnson', 'michael.johnson@example.com', 3, NULL, '2018-11-30'),
	(6, 'Anna', 'Davis', 'anna.davis@example.com', 3, 48000.00, '2022-03-10'),
	(7, 'James', 'Miller', 'james.miller@example.com', 4, 62000.00, NULL),
	(8, 'Laura', 'Lee', 'laura.lee@example.com', 1, 58000.00, '2019-12-19'),
	(9, 'David', 'Garcia', 'david.garcia@example.com', 3, 71000.00, '2016-06-15'),
	(10, 'Sarah', 'Martinez', '', 4, 50000.00, '2023-01-25'),
	(11, 'John', 'Doe', 'john.doe@example.com', 1, 60000.00, '2019-05-01'),  -- Duplicate
	(12, 'Emily', 'Brown', '', 1, 55000.00, '2021-07-22'),  -- Duplicate
	(13, 'Jane', 'Smith', 'jane.smith@example.com', 2, 75000.00, '2020-01-15'),  -- Duplicate
	(14, 'David', 'Garcia', 'david.garcia@example.com', 3, 71000.00, '2016-06-15'),  -- Duplicate
	(15, 'Robert', 'Johnson', 'robert.johnson@example.com', NULL, 64000.00, '2021-04-12')

DROP TABLE IF EXISTS Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50),
    ManagerID INT
)


INSERT INTO Departments(DepartmentID, DepartmentName, ManagerID) VALUES 
	(1, 'HR', 1),
	(2, 'Finance', NULL),
	(3, 'IT', 9),
	(4, 'Sales', 7),
	(5, NULL, NULL), -- Department with NULL name
	(6, 'Marketing', 4),
	(7, 'Operations', 5),
	(8, 'Support', 8),
	(9, 'Legal', 6),
	(10, 'Research', 3),
	(11, 'HR', 1), -- Duplicate
	(12, 'Finance', NULL), -- Duplicate
	(13, 'IT', 9), -- Duplicate
	(14, 'Sales', 7), -- Duplicate
	(15, '', 2) -- Department with blank name


/** 1. Identify Duplicates:
Look for duplicate rows in the Departments table.*/
SELECT 
	Empl.FirstName,
	Empl.LastName,
	COUNT(*) AS DuplicateRow
FROM 
	[Advance Excercise]..Employees2 AS Empl
JOIN 
	[Advance Excercise]..Departments AS Dep
ON Empl.EmployeeID = Dep.DepartmentID
GROUP BY 
	Empl.FirstName,
	Empl.LastName
HAVING
	COUNT(*) > 1



/* 2. Remove Duplicates:
Remove duplicate rows from the Departments table, keeping only one instance of each duplicate.*/
WITH EmplDuplicateRow AS (
    SELECT 
        EmployeeID,
        ROW_NUMBER() OVER(PARTITION BY FirstName 
					ORDER BY EmployeeID) AS DuplicateRows
    FROM 
        [Advance Excercise]..Employees2 
)
DELETE FROM [Advance Excercise]..Employees2
WHERE EmployeeID IN (
    SELECT EmployeeID
    FROM EmplDuplicateRow
    WHERE DuplicateRows > 1
)

WITH DepDuplicateRow AS (
    SELECT 
        DepartmentID,
        ROW_NUMBER() OVER(PARTITION BY DepartmentName 
					ORDER BY DepartmentID) AS DuplicateRows
    FROM 
        [Advance Excercise]..Departments
)
DELETE FROM [Advance Excercise]..Departments
WHERE DepartmentID IN (
    SELECT DepartmentID
    FROM DepDuplicateRow
    WHERE DuplicateRows > 1
)

SELECT 
	*
FROM 
	[Advance Excercise]..Employees2 Empl
JOIN 
	[Advance Excercise]..Departments Dep
ON Empl.EmployeeID = Dep.DepartmentID



/* 3. Handle NULL and Blank Values:
Replace NULL and blank values with default values in the Departments table.*/
UPDATE [Advance Excercise]..Employees2 
SET
	FirstName = COALESCE(NULLIF(FirstName, ''), 'Unassigned'),
	LastName = COALESCE(NULLIF(LastName, ''), 'Unassigned'),
	Email = COALESCE(NULLIF(Email, ''), 'Unassigned'),
	DepartmentID = COALESCE(DepartmentID, 0),
	Salary = COALESCE(Salary, 0),
	HireDate = COALESCE(HireDate, CAST('2000-01-01' AS DATE))

UPDATE [Advance Excercise]..Departments
SET
	DepartmentName = COALESCE(NULLIF(DepartmentName, ''), 'Unassigned'),
	ManagerID = COALESCE(ManagerID, 0)



/* 4. Join Practice:
Practice writing join queries between the Employees and Departments tables to get complete employee details.*/
SELECT
	*
FROM
	[Advance Excercise]..Employees2 Empl
JOIN 
	[Advance Excercise]..Departments Dep
ON Empl.EmployeeID = Dep.DepartmentID



/* 5. CTE Practice:
Use CTEs for complex operations, such as identifying departments without managers or 
calculating the total number of employees per department.*/

-- identifying departments without managers
WITH DepartmentsWithoutManager AS (
	SELECT 
		DepartmentName [Department without managers]
	FROM
		dbo.Departments
	WHERE
		ManagerID = 0
)

SELECT [Department without managers] FROM DepartmentsWithoutManager


-- calculating the total number of employees per department
WITH TotalNumEmployeePerDep AS (
	SELECT --DISTINCT
		Dep.DepartmentName [Department Name],
		COUNT(Empl.EmployeeID) OVER(PARTITION BY Dep.DepartmentName) 
									[Total Num. Employees Per Dept]
	FROM 
		dbo.Employees2 Empl 
	JOIN
		dbo.Departments Dep
	ON Empl.EmployeeID = Dep.DepartmentID
),
FinalTotalEmployee AS (
	SELECT 
		[Department Name],
		[Total Num. Employees Per Dept],
		ROW_NUMBER() OVER(PARTITION BY [Department Name]
					ORDER BY [Total Num. Employees Per Dept]) AS RowNum
	FROM TotalNumEmployeePerDep
)

SELECT [Department Name],
	[Total Num. Employees Per Dept]
FROM FinalTotalEmployee
WHERE RowNum = 1
	