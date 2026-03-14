SET SQL_SAFE_UPDATES = 0;

-- DDL

CREATE SCHEMA IF NOT EXISTS online_store;
USE online_store;
CREATE TABLE IF NOT EXISTS products(
  product_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  order_id INT NOT NULL UNIQUE,
  name VARCHAR(50),
  type CHAR(4),
  price DECIMAL(10,2),
  create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  date DATE,
  active TINYINT DEFAULT 1
);

ALTER TABLE products
ADD COLUMN stock INT;

ALTER TABLE products
MODIFY COLUMN price DECIMAL(15,2);

ALTER TABLE products
RENAME COLUMN date TO order_date;

TRUNCATE TABLE products;

DROP TABLE IF EXISTS products;
DROP SCHEMA IF EXISTS online_store;

-- DML
INSERT INTO products(order_id,name,type,price,date) 
VALUES 
  (3,"Transistor","elec",1200.00,"2023-02-20"),
  (1,"Bag","asse",30.00,"2023-01-18"),
  (2,"Nut","Mech",NULL,"2023-01-18");
  
UPDATE products 
SET price = 45.00
WHERE product_id = 2;

UPDATE products 
SET price = price * 0.8;

DELETE FROM products
WHERE product_id = 1;

-- DQL
SELECT * FROM products;
SELECT price AS 'current price' FROM products;

SELECT name,price 
FROM products
WHERE price > 1000 AND type = 'elec';

SELECT name,price 
FROM products
WHERE type IN ('elec','mech');

SELECT name,price 
FROM products
WHERE name LIKE '_a%';

SELECT name,price 
FROM products
WHERE price > 10
ORDER BY price DESC
LIMIT 1;

SELECT name,price 
FROM products
WHERE price IS NULL;

-- Data Analysis
SELECT
  COUNT(*) AS total_orders
FROM products;

SELECT
  COUNT(price) AS total_completed_orders
FROM products;

SELECT
  SUM(price) AS total_revenue
FROM products;

SELECT
  ROUND(AVG(price),2) AS average_price,
  MIN(price) AS minimum_price,
  MAX(price) AS maximum_price
FROM products;

SELECT
  type,
  SUM(price) AS total_revenue
FROM products
WHERE active = 1
GROUP BY type
ORDER BY total_revenue DESC
LIMIT 1;

SELECT
  type,
  active,
  SUM(price) AS total_revenue
FROM products
GROUP BY type,active
ORDER BY total_revenue DESC;

SELECT
  type,
  SUM(price) AS total_revenue
FROM products
WHERE active = 1
GROUP BY type
HAVING total_revenue > 1000
ORDER BY total_revenue DESC;


-- Conditions

SELECT
  type,
  SUM(price) AS total_revenue,
  CASE
    WHEN SUM(price) > 1000 THEN 'HIGH'
    WHEN SUM(price) > 20 THEN 'Medium'
    ELSE 'LOW'
  END 
FROM products
GROUP BY type;


SELECT
  SUM(CASE WHEN active = 1 THEN 1 ELSE 0 END) AS active
FROM products;



-- MONTH function

SELECT
  MONTH(date) AS month
FROM products;

-- Joins
-- INNER JOIN,LEFT JOIN, RIGHT JOIN
SELECT 
  c.first_name,
  o.order_date,
  o.total_amount
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id;

-- Full outer Join
SELECT *
FROM table1
LEFT JOIN table2 ON table1.id = table2.id
UNION
SELECT *
FROM table1
RIGHT JOIN table2 ON table1.id = table2.id;

-- Views
CREATE VIEW RegionalRevenueSummary AS 
SELECT 
	region,
    SUM(revenue) AS total_revenue,
    COUNT(sale_id) AS total_sales
FROM regional_sales
GROUP BY region;

SELECT * FROM RegionalRevenueSummary;

-- CTE
WITH EmployeeLifetimeSales AS(
	SELECT
		employee_id,
        SUM(revenue) AS total_revenue
	FROM regional_sales
    GROUP BY employee_id
);

SELECT 
	emp.employee_id,
    emp.first_name,
    els.total_revenue
FROM employees AS emp
INNER JOIN EmployeeLifetimeSales AS els ON emp.employee_id = els.employee_id
WHERE els.total_revenue > 35000
ORDER BY els.total_revenue;

-- one value compare in CTE

WITH AverageRevenuePerSale AS(
	SELECT
		AVG(revenue) AS AvgValPerSale
	FROM regional_sales
)
SELECT 
	rs.sale_id,
    rs.employee_id,
    rs.region,
    rs.sale_date,
    rs.revenue
FROM regional_sales AS rs
JOIN AverageRevenuePerSale AS arps ON rs.revenue>arps.AvgValPerSale;

-- rolling sum with partition using window

SELECT 
	rs.region,
    rs.sale_date,
    rs.revenue,
    SUM(revenue) OVER(
		PARTITION BY rs.region
        ORDER BY rs.sale_date) AS rolling_revenue
FROM regional_sales AS rs

-- Procedures
DELIMITER //
CREATE PROCEDURE GetSalesByRegion (IN target_region VARCHAR(50))
BEGIN
  SELECT
    sale_date,
    revenue
  FROM regional_sales
  WHERE region = target_region
  ORDER BY sale_date DESC;
END //
DELIMITER ;

-- Test the procedure:
CALL GetSalesByRegion('North');

-- Triggers

DELIMITER //
CREATE TRIGGER SalaryAuditLog
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  -- Check if the salary actually changed
  IF OLD.salary <> NEW.salary THEN
    INSERT INTO audit_log (table_affected, action_taken)
    VALUES (
      'employees',
      CONCAT('Salary for ID ', OLD.employee_id,' changed from ',OLD.salary,' to ',NEW.salary)
    );
  END IF;
END //
DELIMITER ;

-- Test the trigger:
UPDATE employees SET salary = 80000.00 WHERE employee_id = 1;
SELECT * FROM audit_log;