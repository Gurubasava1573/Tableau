/* Q1. Write a stored procedure that accepts the month and 
year as inputs and prints the ordernumber, orderdate and 
status of the orders placed in that month. */

SELECT * FROM orders;
DELIMITER $$
CREATE PROCEDURE order_status(IN p_year INT, IN p_month INT)
BEGIN
    SELECT ordernumber, orderdate, status
    FROM orders
    WHERE YEAR(orderdate) = p_year AND MONTH(orderdate) = p_month;
END$$
DELIMITER ;


/* Q2. Write a stored procedure to insert a record into the cancellations table for all cancelled orders.
STEPS: 
a.	Create a table called cancellations with the following fields
id (primary key), 
 	customernumber (foreign key - Table customers), 
ordernumber (foreign key - Table Orders), 
comments
All values except id should be taken from the order table.
b. Read through the orders table . If an order is cancelled, then put an entry in the cancellations 
table.*/

DELIMITER //

CREATE PROCEDURE insert_cancelled_orders()
BEGIN
    -- Create the cancellations table if it doesn't exist
    CREATE TABLE IF NOT EXISTS cancellations (
        id INT PRIMARY KEY AUTO_INCREMENT,
        customernumber INT NOT NULL,
        ordernumber INT NOT NULL,
        comments VARCHAR(255)
    );

    -- Insert cancelled orders into the cancellations table
    INSERT INTO cancellations (customernumber, ordernumber, comments)
    SELECT o.customernumber, o.ordernumber, 'Order cancelled'
    FROM orders o
    WHERE o.status = 'Cancelled';
END //

DELIMITER ;



/*Q3. a. Write function that takes the customernumber as input and returns the purchase_status 
based on the following criteria . [table:Payments]

if the total purchase amount for the customer is < 25000 status = Silver, amount between 25000 and 50000, 
status = Gold
if amount > 50000 Platinum

b. Write a query that displays customerNumber, customername and purchase_status from customers table. */

SELECT * FROM payments;

DELIMITER //

CREATE FUNCTION purchase_status(
	amount DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE purchase_status VARCHAR(20);
    IF amount > 50000 THEN
		SET purchase_status = 'PLATINUM';
    ELSEIF (amount <= 50000 AND 
			amount >= 25000) THEN
        SET purchase_status = 'GOLD';
    ELSEIF amount < 25000 THEN
        SET purchase_status = 'SILVER';
    END IF;
	-- return the purchase_status
	RETURN (purchase_status);
END //

SELECT customerNumber, customerName, get_purchase_status(customerNumber) AS purchase_status FROM customers;


    
   /* Q4. Replicate the functionality of 'on delete cascade' and 'on update cascade' 
using triggers on movies and rentals tables. 
Note: Both tables - movies and rentals - don't have primary or foreign keys. 
Use only triggers to implement the above.*/

CREATE TABLE movies (
    id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    release_year INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE rentals (
    id INT NOT NULL,
    movie_title VARCHAR(255) NOT NULL,
    rental_date DATE NOT NULL,
    PRIMARY KEY (id)
);

-- Trigger to update rentals table when a movie is updated
CREATE TRIGGER update_rentals_trigger
AFTER UPDATE ON movies
FOR EACH ROW
BEGIN
    UPDATE rentals SET movie_title = NEW.title WHERE movie_title = OLD.title;
END;

-- Trigger to delete rentals when a movie is deleted
CREATE TRIGGER delete_rentals_trigger
AFTER DELETE ON movies
FOR EACH ROW
BEGIN
    DELETE FROM rentals WHERE movie_title = OLD.title;
END;

-- Trigger to update movies table when a rental is updated
CREATE TRIGGER update_movies_trigger
AFTER UPDATE ON rentals
FOR EACH ROW
BEGIN
    UPDATE movies SET title = NEW.movie_title WHERE title = OLD.movie_title;
END;

-- Trigger to delete movies when a rental is deleted
CREATE TRIGGER delete_movies_trigger
AFTER DELETE ON rentals
FOR EACH ROW
BEGIN
    DELETE FROM movies WHERE title = OLD.movie_title;
END;


/* Q5. Select the first name of the employee who gets the third highest salary. [table: employee] */

SELECT FIRST_NAME
FROM employee
ORDER BY SALARY DESC
LIMIT 1 OFFSET 2;




/* Q6. Assign a rank to each employee  based on their salary.
 The person having the highest salary has rank 1. [table: employee] */
 
SELECT * FROM employee;
 
SELECT 
    empid,Deptno,fname,lname,salary,@curRank:=@curRank + 1 AS rank_by_high_salary
FROM employee p, (SELECT @curRank:=0) r
ORDER BY salary DESC;
 
SELECT empid,Deptno,fname,lname,salary,
    (SELECT COUNT(*) + 1 FROM employee B
        WHERE A.salary < B.salary) AS Rank_
FROM
    employee A
ORDER BY salary DESC; 