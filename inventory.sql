/* 
Question 1 
List the order details where the quantity is between 61 and 86. 
Display the order id and quantity from the OrderDetails table, 
the product id and reorder level from the Products table, and the supplier id from the Suppliers table. 
Order the result set by the order id. 
*/

SELECT o.Quantity, o.OrderID, p.ProductID, p.ReorderLevel, s.SupplierID
FROM orderdetails AS o
JOIN Products AS p ON o.ProductID = p.ProductID
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
WHERE o.Quantity BETWEEN 61 AND 86
ORDER BY o.OrderID;


/* 
Question 2: List the customer id, company name, country, and phone from the Customers table 
where the country is equal to Finland or Maldives or Tuvalu. 
Order the result set by the country, customer id. 
*/

SELECT customerID, CompanyName, Country, Phone
FROM Customers
WHERE Country IN  ('Finland', 'Maldives', 'Tuvalu')
ORDER BY Country, CustomerID;


/* 
Question 3: List all the orders with a shipping city of (Montreal, or Windsor). 
Display the order from the Orders table, and the unit price and quantity from the OrderDetails table. 
Order the result set by the order id, quantity. 
*/

SELECT o.OrderID, od.UnitPrice, od.Quantity
FROM Orders AS o
JOIN OrderDetails AS od ON o.OrderID = od.OrderID
WHERE o.ShipCity = 'Montreal' OR o.ShipCity = 'Windsor'
ORDER BY o.OrderID, od.Quantity;


/* 
Question 4: List the products which contain “mea” or “syr” in their name. 
Display the product id, product name, quantity per unit and unit price from the Products table.
Order the result set by product name. 
*/ 

SELECT productID, ProductName, QuantityPerUnit, UnitPrice
FROM products
WHERE ProductName LIKE '%syr%' OR ProductName LIKE '%mea%'
ORDER BY ProductName;

/* 
Question 5: Using the appropriate statement (INSERT, CREATE, UPDATE, …. ),
change the pager value to NA for all rows in the Customers table where the current pager value is null or empty. 
*/  

SET SQL_SAFE_UPDATES = 0;

UPDATE Customers
SET Pager = 'NA'
WHERE Pager IS NULL OR Pager = '';

-- this is to enable your safe update mode again
SET SQL_SAFE_UPDATES = 1;

-- this is to check the result of your update query
SELECT * FROM Customers;


/* 
Question 6: Create a VIEW called view_order_expenses to list the cost of orders. 
Display the order_date, order id  from the Orders table, the product id from the Products table, 
the company name from the Customers table, and the order cost.
To calculate the cost of the orders, use the formula (OrderDetails.UnitPrice * OrderDetails.Quantity). 
*/

DROP VIEW IF EXISTS view_order_expenses;

CREATE VIEW view_order_expenses AS
SELECT o.OrderDate AS order_date, o.OrderID AS order_id, p.ProductID AS product_id, c.CompanyName AS company_name, (od.UnitPrice * od.Quantity) AS cost_of_orders
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- check the result of your view
SELECT * FROM view_order_expenses;


/* Question 7: List the orders where the shipped date is before than or equal to 1st of May 1997, 
and calculate the length in days from the shipped date to 1st of January  2003. 
Display the order id, and the shipped date from the Orders table, the company name, and the contact name from the Customers table, 
and also the calculated length in months for each order. Order the result set by order id and the calculated months. */

SELECT o.OrderID, o.ShippedDate, c.CompanyName, c.ContactName, TIMESTAMPDIFF(DAY, o.ShippedDate, '2003-01-01') AS length_in_days, TIMESTAMPDIFF(MONTH, o.ShippedDate, '2003-01-01') AS length_in_months
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.ShippedDate <= '1997-05-01'
ORDER BY o.OrderID, length_in_months;

/* Question 8: List the number of products for each individual letter of the alphabet (starts by letter). 
We should display the letter and count if there are at least five product names beginning with the same letter. */

SELECT  substring(productName,1,1) AS letter , COUNT( productName) AS numbers
FROM products
GROUP BY letter 
HAVING numbers >= 5
ORDER BY letter;


/* Question 9: Create a stored procedure called sp_client_info to display the customer id, address, phone, 
and country from the Customers table for a particular Customer. 
The id will be an input parameter for the stored procedure.. */

DROP PROCEDURE IF EXISTS sp_client;
  
DELIMITER $$

CREATE PROCEDURE sp_client (IN id TEXT(5))
BEGIN
SELECT CustomerID, Address, Phone, Country FROM customers 
WHERE CustomerID LIKE id;
END $$

DELIMITER ;

-- usage
CALL sp_client('anatr');


/* Question 10: Create a stored procedure called sp_delClient_info to 
delete the customer rows who have pager value as NA or NULL or empty */ 

DROP PROCEDURE IF EXISTS sp_delClient_info;
SET SQL_SAFE_UPDATES = 0;

DELIMITER $$

CREATE PROCEDURE sp_delClient_info()
BEGIN
	DELETE FROM customers
	WHERE pager IS NULL
	OR
    pager = ''
    OR
    pager = 'NA';
END $$

DELIMITER ;

-- usage
CALL sp_delClient_info;

SET SQL_SAFE_UPDATES = 1;
