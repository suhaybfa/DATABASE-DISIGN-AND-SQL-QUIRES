-- 1. Suppliers Table
CREATE TABLE Suppliers (
    SupplierID NUMBER PRIMARY KEY,
    SupplierName VARCHAR2(100) NOT NULL,
    Phone VARCHAR2(20),
    Email VARCHAR2(100),
    Address VARCHAR2(200),
    Country VARCHAR2(50)
);

-- 2. Employees Table (Includes Self-Ref for Manager)
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL,
    LastName VARCHAR2(50) NOT NULL,
    Position VARCHAR2(50),
    ManagerID NUMBER,
    DepartmentID NUMBER,
    Salary NUMBER(10,2),
    HireDate DATE,
    CONSTRAINT fk_emp_manager FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- 3. Departments Table
CREATE TABLE Departments (
    DepartmentID NUMBER PRIMARY KEY,
    DepartmentName VARCHAR2(100) NOT NULL,
    ManagerID NUMBER,
    Email VARCHAR2(100),
    Location VARCHAR2(100),
    CONSTRAINT fk_dept_manager FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- 4. Customer Table
CREATE TABLE Customer (
    CustomerID NUMBER PRIMARY KEY,
    CustomerName VARCHAR2(100) NOT NULL,
    Phone VARCHAR2(20),
    Email VARCHAR2(100),
    RegistrationDate DATE,
    Address VARCHAR2(200),
    LoyaltyPoints NUMBER DEFAULT 0
);

-- 5. TechProducts Table
CREATE TABLE TechProducts (
    ProductID NUMBER PRIMARY KEY,
    SupplierID NUMBER,
    ProductName VARCHAR2(100) NOT NULL,
    Category VARCHAR2(50),
    Price NUMBER(10,2),
    AvailableUnits NUMBER,
    Features VARCHAR2(500),
    CONSTRAINT fk_prod_supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 6. ProjectManagement Table
CREATE TABLE ProjectManagement (
    ProjectID NUMBER PRIMARY KEY,
    DepartmentID NUMBER,
    ProjectName VARCHAR2(100),
    Budget NUMBER(15,2),
    Deadline DATE,
    Status VARCHAR2(20),
    CONSTRAINT fk_proj_dept FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 7. Orders Table
CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    EmployeeID NUMBER,
    OrderDate DATE,
    TotalAmount NUMBER(10,2),
    Status VARCHAR2(20),
    CONSTRAINT fk_order_cust FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT fk_order_emp FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- 8. Payments Table
CREATE TABLE Payments (
    PaymentID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    PaymentDate DATE,
    PaymentMethod VARCHAR2(50),
    AmountPaid NUMBER(10,2),
    Status VARCHAR2(20),
    CONSTRAINT fk_pay_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 9. Dependents Table
CREATE TABLE Dependents (
    DependentID NUMBER PRIMARY KEY,
    EmployeeID NUMBER,
    DependentName VARCHAR2(100),
    Gender VARCHAR2(10),
    DateOfBirth DATE,
    Relationship VARCHAR2(50),
    CONSTRAINT fk_dep_emp FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
-- 10. ServiceRequests Table
CREATE TABLE ServiceRequests (
    RequestID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    ProductID NUMBER,
    EmployeeID NUMBER,
    RequestDate DATE,
    ServiceType VARCHAR2(100),
    Status VARCHAR2(20),
    CONSTRAINT fk_sr_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT fk_sr_product FOREIGN KEY (ProductID) REFERENCES TechProducts(ProductID),
    CONSTRAINT fk_sr_employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


/* Automatically decrease product stock by 1 whenever a new order is placed
*/
CREATE OR REPLACE TRIGGER trg_Update_Inventory
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    UPDATE TechProducts
    SET AvailableUnits = AvailableUnits - 1
    WHERE ProductID = 201; 
END;
/

    --  Security check to prevent entering a salary lower than the company minimum ($4,000) --

    CREATE OR REPLACE TRIGGER trg_Salary_Min_Check
BEFORE INSERT OR UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF :NEW.Salary < 4000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Compliance Error: Salary cannot be less than the company minimum of $4,000.');
    END IF;
END;

INSERT INTO Suppliers (SupplierID, SupplierName, Phone, Email, Address, Country)
VALUES (1, 'TechGlobal Inc', '555-0101', 'contact@techglobal.com', '100 Silicon Way', 'USA');

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, ManagerID, DepartmentID, Salary, HireDate)
VALUES (101, 'Sarah', 'Connor', 'Director', NULL, 501, 12000, TO_DATE('2010-01-15', 'YYYY-MM-DD'));

INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, ManagerID, DepartmentID, Salary, HireDate)
VALUES (102, 'John', 'Doe', 'Senior Engineer', 101, 501, 8500, TO_DATE('2018-05-20', 'YYYY-MM-DD'));

INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Email, Location)
VALUES (501, 'R&D', 101, 'rd@company.com', 'Building A');

INSERT INTO TechProducts (ProductID, SupplierID, ProductName, Category, Price, AvailableUnits, Features)
VALUES (201, 1, 'Titan Laptop', 'Hardware', 2500, 15, '32GB RAM, 1TB SSD');

INSERT INTO Customer (CustomerID, CustomerName, Phone, Email, RegistrationDate, Address, LoyaltyPoints)
VALUES (301, 'Alice Smith', '555-9988', 'alice@email.com', SYSDATE, '742 Evergreen Terrace', 50);

INSERT INTO ProjectManagement (ProjectID, DepartmentID, ProjectName, Budget, Deadline, Status)
VALUES (401, 501, 'NextGen AI', 500000, TO_DATE('2026-12-31', 'YYYY-MM-DD'), 'Active');

INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, TotalAmount, Status)
VALUES (701, 301, 102, SYSDATE, 2500, 'Completed');

INSERT INTO Payments (PaymentID, OrderID, PaymentDate, PaymentMethod, AmountPaid, Status)
VALUES (801, 701, SYSDATE, 'Credit Card', 2500, 'Success');

INSERT INTO ServiceRequests (RequestID, CustomerID, ProductID, EmployeeID, RequestDate, ServiceType, Status)
VALUES (901, 301, 201, 102, SYSDATE, 'Setup', 'In Progress');
