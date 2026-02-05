-- Active: 1769354484664@@127.0.0.1@3306@multi_vendor
CREATE DATABASE Multi_Vendor;

SHOW DATABASES;

USE multi_vendor;

SHOW TABLES;

--3
CREATE TABLE SubscriptionPlan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(100),
    price FLOAT,
    duration INT,
    features VARCHAR(100)
);

CREATE TABLE vendor (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    business_name VARCHAR(150),
    contact_person VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(100),
    plan_id INT,
    FOREIGN KEY (plan_id) REFERENCES SubscriptionPlan(plan_id)
);

--4
CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    name VARCHAR(100),
    description VARCHAR(200),
    price FLOAT,
    stock_quantity INT,
    status VARCHAR(20),
    FOREIGN KEY (vendor_id) REFERENCES Vendor(vendor_id)
);


CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100)
);

CREATE TABLE ProductCategory (
    product_id INT,
    category_id INT,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);


--5

INSERT INTO SubscriptionPlan 
(plan_name, price, duration, features)
VALUES 
('Basic', 2000, 30, 'Limited products, Email support');

INSERT INTO Vendor 
(business_name, contact_person, email, phone, address, plan_id)
VALUES 
('SmartTech Ltd.', 'Rahim Khan', 'rahim@smarttech.com', 
 '017XXXXXXXX', 'Dhaka, Bangladesh', 1);

SELECT * FROM vendor

--6
INSERT INTO Product
(vendor_id, name, description, price, stock_quantity, status)
VALUES
(1, 'Laptop', 'High performance laptop', 75000, 10, 'active');

SELECT * FROM product

--7
UPDATE Product
SET stock_quantity = 15
WHERE name = 'Laptop';

--8
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(100)
);
DELETE FROM Customer
WHERE email = 'oldcustomer@gmail.com';


--9
SELECT v.business_name, sp.plan_name, sp.price
FROM Vendor v
JOIN SubscriptionPlan sp ON v.plan_id = sp.plan_id;

--10
SELECT p.name, p.price, p.stock_quantity
FROM Product p
JOIN ProductCategory pc ON p.product_id = pc.product_id
JOIN Category c ON pc.category_id = c.category_id
WHERE c.name = 'Electronics';


--11
CREATE TABLE O_rder (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount FLOAT,
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

SELECT o.order_id, o.order_date, o.total_amount, o.status
FROM O_rder o
JOIN Customer c ON o.customer_id = c.customer_id
WHERE c.name = 'Karim Uddin';

--12
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    method VARCHAR(30),
    amount FLOAT,
    payment_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (order_id) REFERENCES O_rder(order_id)
);
SELECT method, amount, status
FROM Payment
WHERE order_id = 1;

--13
CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price FLOAT,
    subtotal FLOAT,
    FOREIGN KEY (order_id) REFERENCES O_rder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

SELECT p.name, SUM(oi.quantity) AS total_sold
FROM OrderItem oi
JOIN Product p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;




