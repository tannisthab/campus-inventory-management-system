CREATE DATABASE IF NOT EXISTS CampusInventory;
USE CampusInventory;
CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100)
);
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact VARCHAR(15),
    email VARCHAR(100)
);
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_name VARCHAR(100) NOT NULL,
    department_id INT,
    designation VARCHAR(100),
    FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);
CREATE TABLE Item (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    category_id INT,
    supplier_id INT,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity_in_stock INT DEFAULT 0,
    reorder_level INT DEFAULT 5,
    FOREIGN KEY (category_id)
        REFERENCES Category(category_id),
    FOREIGN KEY (supplier_id)
        REFERENCES Supplier(supplier_id),
    CHECK (unit_price >= 0),
    CHECK (quantity_in_stock >= 0),
    CHECK (reorder_level >= 0)
);
CREATE TABLE Inventory_Transaction (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    staff_id INT NOT NULL,
    transaction_type ENUM('IN', 'OUT', 'ADJUSTMENT') NOT NULL,
    quantity INT NOT NULL,
    transaction_date DATE NOT NULL,
    FOREIGN KEY (item_id)
        REFERENCES Item(item_id),
    FOREIGN KEY (staff_id)
        REFERENCES Staff(staff_id),
    CHECK (quantity > 0)
);

SHOW tables;
DESCRIBE Item;
DESCRIBE Inventory_Transaction;
INSERT INTO Department (department_name, location)
VALUES
('Computer Science', 'Block A'),
('Data Science', 'Block B'),
('Mathematics', 'Block C'),
('Administration', 'Main Building'),
('Electronics', 'Block D');
INSERT INTO Supplier (supplier_name, contact, email)
VALUES
('TechWorld Solutions', '9876543210', 'tech@techworld.com'),
('OfficeMart', '9876543211', 'sales@officemart.com'),
('LabEquip India', '9876543212', 'info@labequip.com'),
('FurnishPro', '9876543213', 'contact@furnishpro.com'),
('Digital Systems', '9876543214', 'support@digitalsys.com');
INSERT INTO Category (category_name)
VALUES
('Computer Equipment'),
('Stationery'),
('Laboratory Equipment'),
('Furniture'),
('Electronics');
INSERT INTO Staff (staff_name, department_id, designation)
VALUES
('Rahul Sharma', 1, 'IT Administrator'),
('Priya Nair', 2, 'Lab Assistant'),
('Amit Das', 3, 'Inventory Manager'),
('Sneha Roy', 4, 'Administrative Officer'),
('Arjun Mehta', 5, 'Technical Assistant');
INSERT INTO Item
(item_name, category_id, supplier_id, unit_price,
 quantity_in_stock, reorder_level)
VALUES
('Laptop', 1, 1, 55000, 15, 5),
('Printer', 1, 5, 12000, 8, 3),
('Notebook', 2, 2, 50, 100, 20),
('Whiteboard', 4, 4, 2500, 10, 2),
('Microscope', 3, 3, 18000, 5, 2),
('Projector', 5, 5, 35000, 4, 3),
('Keyboard', 1, 1, 800, 25, 5),
('Office Chair', 4, 4, 4500, 12, 4),
('Laboratory Glassware', 3, 3, 1500, 30, 10),
('Marker Pen', 2, 2, 30, 200, 50);
INSERT INTO Inventory_Transaction
(item_id, staff_id, transaction_type, quantity, transaction_date)
VALUES
(1, 1, 'IN', 10, '2026-10-01'),
(2, 1, 'OUT', 2, '2026-10-02'),
(3, 3, 'IN', 50, '2026-10-03'),
(4, 4, 'OUT', 1, '2026-10-04'),
(5, 2, 'IN', 3, '2026-10-05'),
(6, 5, 'OUT', 1, '2026-10-06'),
(7, 1, 'IN', 15, '2026-10-07'),
(8, 4, 'OUT', 2, '2026-10-08'),
(9, 2, 'IN', 10, '2026-10-09'),
(10, 3, 'OUT', 20, '2026-10-10');

SELECT * FROM Department;
SELECT * FROM Supplier;
SELECT * FROM Category;
SELECT * FROM Staff;
SELECT * FROM Item;
SELECT * FROM Inventory_Transaction;

SET SQL_SAFE_UPDATES = 0;

UPDATE Item
SET unit_price = 900
WHERE item_name = 'Keyboard';
SELECT * FROM Item
WHERE item_name = 'Keyboard';

UPDATE Item
SET quantity_in_stock = 20
WHERE item_id = 7;
SELECT item_id, item_name, quantity_in_stock
FROM Item
WHERE item_id = 7;

INSERT INTO Category (category_name)
VALUES ('Temporary Category');
DELETE FROM Category
WHERE category_name = 'Temporary Category';
SELECT * FROM Category;


SELECT * FROM Item
WHERE unit_price > 5000; 
SELECT * FROM Item
WHERE quantity_in_stock < reorder_level;
SELECT * FROM Item
ORDER BY unit_price DESC;

SELECT
    i.item_id,
    i.item_name,
    c.category_name,
    i.unit_price
FROM Item i
INNER JOIN Category c
ON i.category_id = c.category_id;

SELECT
    i.item_name,
    c.category_name,
    s.supplier_name,
    i.unit_price
FROM Item i INNER JOIN Category c ON i.category_id = c.category_id
INNER JOIN Supplier s ON i.supplier_id = s.supplier_id;

SELECT
    d.department_name,
    s.staff_name,
    s.designation
FROM Department d
LEFT JOIN Staff s
ON d.department_id = s.department_id;

SELECT
    t.transaction_id,
    i.item_name,
    s.staff_name,
    t.transaction_type,
    t.quantity,
    t.transaction_date
FROM Inventory_Transaction t
INNER JOIN Item i
ON t.item_id = i.item_id
INNER JOIN Staff s
ON t.staff_id = s.staff_id
INNER JOIN Department d
ON s.department_id = d.department_id;
    
SELECT
    c.category_name,
    COUNT(i.item_id) AS total_items,
    SUM(i.quantity_in_stock) AS total_quantity,
    SUM(i.quantity_in_stock * i.unit_price) AS inventory_value
FROM Category c
INNER JOIN Item i
ON c.category_id = i.category_id
GROUP BY c.category_name;

INSERT INTO Department (department_name, location)
VALUES ('Library', 'Block E');
    
    
    