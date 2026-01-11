-- Requirement: Display Department Name, total employees, and total salary per department.
SELECT 
    d.DepartmentName, 
    COUNT(e.EmployeeID) AS Total_Staff, 
    SUM(e.Salary) AS Monthly_Budget
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- Requirement: List employees earning more than the average salary of the entire company.
SELECT FirstName, LastName, Salary, Position
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);


-- Requirement: Link Employees to Departments and find the specific Manager's name for that Dept.
SELECT 
    e.FirstName AS Employee_Name, 
    d.DepartmentName, 
    m.FirstName AS Department_Manager
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Employees m ON d.ManagerID = m.EmployeeID;


-- Requirement: Filter groups of data (departments) based on an aggregate condition (average salary).
SELECT 
    d.DepartmentName, 
    AVG(e.Salary) AS Avg_Salary
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
HAVING AVG(e.Salary) > 60000;

-- Requirement: Find employees who are at the top of the hierarchy (ManagerID is NULL).
SELECT FirstName, LastName, Position
FROM Employees
WHERE ManagerID IS NULL;

-- Requirement: Extract the year from HireDate and count occurrences.
SELECT 
    EXTRACT(YEAR FROM HireDate) AS Hire_Year, 
    COUNT(EmployeeID) AS New_Hires
FROM Employees
GROUP BY EXTRACT(YEAR FROM HireDate)
ORDER BY Hire_Year DESC;

-- Requirement: Extract the employee(s) who earn the maximum salary in their respective departments.
SELECT FirstName, LastName, Salary, DepartmentID
FROM Employees e1
WHERE Salary = (
    SELECT MAX(Salary) 
    FROM Employees e2 
    WHERE e1.DepartmentID = e2.DepartmentID
);

-- Requirement: Count how many subordinates report to each manager.
SELECT 
    m.FirstName AS Manager_Name, 
    COUNT(e.EmployeeID) AS Number_of_Reports
FROM Employees m
JOIN Employees e ON m.EmployeeID = e.ManagerID
GROUP BY m.FirstName;


--  List all employees hired after January 1st, 2020, sorted by the most recent.
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE HireDate >= TO_DATE('2020-01-01', 'YYYY-MM-DD')
ORDER BY HireDate DESC;

