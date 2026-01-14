--i used Aggregates, CTEs, Subqueries and join to make usefull extracts --

/*  Calculate the total stock value and quantity available for each product category. */
SELECT 
    Category, 
    SUM(AvailableUnits) AS Total_Stock, 
    SUM(Price * AvailableUnits) AS Inventory_Value,
    MAX(Price) AS Most_Expensive_Item
FROM TechProducts
GROUP BY Category;


/* Identify the most demanded service types and their current completion status. */
SELECT 
    ServiceType, 
    Status, 
    COUNT(RequestID) AS Request_Count
FROM ServiceRequests
GROUP BY ServiceType, Status
ORDER BY Request_Count DESC;


/*  Group customers by loyalty levels to understand the distribution of the rewards program. */
SELECT 
    LoyaltyPoints, 
    COUNT(CustomerID) AS Number_of_Customers
FROM Customer
GROUP BY LoyaltyPoints
HAVING COUNT(CustomerID) > 0;
/*  Summarize business performance by status to see total revenue and volume of orders. */
SELECT 
    Status, 
    COUNT(OrderID) AS Total_Orders, 
    SUM(TotalAmount) AS Total_Revenue,
    AVG(TotalAmount) AS Average_Order_Value
FROM Orders
GROUP BY Status;

/*  Join Customer and Orders to calculate total revenue and order frequency per client. */
SELECT 
    c.CustomerName, 
    COUNT(o.OrderID) AS Order_Count, 
    SUM(o.TotalAmount) AS Total_Revenue,
    MAX(o.OrderDate) AS Last_Order_Date
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
ORDER BY Total_Revenue DESC; 

/*  compare total employee salaries against department project budgets. */
WITH DeptCosts AS (
    SELECT DepartmentID, SUM(Salary) AS Total_Payroll
    FROM Employees
    GROUP BY DepartmentID
)
SELECT 
    d.DepartmentName, 
    dc.Total_Payroll, 
    p.ProjectName, 
    p.Budget
FROM Departments d
JOIN DeptCosts dc ON d.DepartmentID = dc.DepartmentID
JOIN ProjectManagement p ON d.DepartmentID = p.DepartmentID;

/*   find products with stock below average and list supplier details. */
SELECT 
    tp.ProductName, 
    tp.AvailableUnits, 
    s.SupplierName, 
    s.Email AS Supplier_Contact
FROM TechProducts tp
JOIN Suppliers s ON tp.SupplierID = s.SupplierID
WHERE tp.AvailableUnits < (SELECT AVG(AvailableUnits) FROM TechProducts);



