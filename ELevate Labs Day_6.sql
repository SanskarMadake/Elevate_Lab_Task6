-- Create Database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order_Items Table 
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT ,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    method VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Success',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert Users
INSERT INTO users (name, email, phone) VALUES
('Amit Sharma', 'amit.sharma@example.com', '9123456780'),
('Priya Singh', 'priya.singh@example.com', NULL),
('Rohit Kumar', 'rohit.kumar@example.com', '9988776655'),
('Neha Patil', 'neha.patil@example.com', '9112233445'),
('Siddharth Deshmukh', 'siddharth.deshmukh@example.com', NULL);

-- Insert Categories
INSERT INTO categories (category_name) VALUES
('Mobiles & Gadgets'),
('Ethnic Wear'),
('Stationery'),
('Home Appliances'),
('Sports & Fitness');

-- Insert Products 
INSERT INTO products (name, price, stock, category_id) VALUES
('Mobile Phone', 12000.00, 40, 1),     
('Laptop', 50000.00, 15, 1),           
('Kurta', 800.00, 80, 2),              
('Notebook', 250.00, 150, 3),          
('Fitness Band', 2000.00, 30, 5);

-- Insert Orders
INSERT INTO orders (user_id, status) VALUES
(1, 'Shipped'),
(2, 'Pending'),
(3, DEFAULT);

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 12000.00),  
(1, 3, 2, 1600.00),    
(2, 2, 1, 50000.00),  
(3, 4, 5, 1250.00),  
(2, 5, 1, 2000.00);

-- Insert Payments
INSERT INTO payments (order_id, amount, method, status) VALUES
(1, 13600.00, 'Credit Card', 'Success'),
(2, 52000.00, 'UPI', 'Success'),
(3, 1250.00, 'Net Banking', 'Pending'),
(2, 2000.00, 'UPI', 'Success');


-- Scalar Subquery in SELECT
SELECT u.name,
       (SELECT MAX(order_date)
        FROM orders o
        WHERE o.user_id = u.user_id) AS LatestOrder
FROM users u;


-- Subquery in WHERE (IN)
SELECT name
FROM products
WHERE product_id IN (SELECT product_id FROM order_items);


-- Subquery with EXISTS
SELECT u.name
FROM users u
WHERE EXISTS (SELECT 1
              FROM orders o
              JOIN order_items oi ON o.order_id = oi.order_id
              WHERE o.user_id = u.user_id
              AND oi.price > 10000);


-- . Nested Subquery with =
SELECT name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products);


-- Subquery in FROM
SELECT o.order_id, u.name, t.TotalAmount
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN (
      SELECT order_id, SUM(price) AS TotalAmount
      FROM order_items
      GROUP BY order_id
     ) t ON o.order_id = t.order_id;


-- Correlated Subquery
SELECT DISTINCT u.name
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE (SELECT SUM(price)
       FROM order_items oi
       WHERE oi.order_id = o.order_id)
      > (SELECT AVG(total)
         FROM (SELECT SUM(price) AS total
               FROM order_items
               GROUP BY order_id) t);


