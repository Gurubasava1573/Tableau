/* Q1. select all employees in department 10 whose salary is greater than 3000. [table: employee] */

SELECT * FROM employee WHERE deptno = 10 AND salary > 3000;

/* Q2. The grading of students based on the marks they have obtained is done as follows:

40 to 50 -> Second Class
50 to 60 -> First Class
60 to 80 -> First Class
80 to 100 -> Distinctions

a. How many students have graduated with first class?
b. How many students have obtained distinction? [table: students] */

SELECT COUNT(*) FROM students WHERE marks >= 50 AND marks < 60;

SELECT COUNT(*) FROM students WHERE marks >= 80 AND marks <= 100;
   
    /* Q3. Get a list of city names from station with even ID numbers only. 
Exclude duplicates from your answer.[table: station] */

SELECT DISTINCT city FROM station WHERE id % 2 = 0;



/* Q4. Find the difference between the total number of city entries in the table and 
the number of distinct city entries in the table. In other words, 
if N is the number of city entries in station, and N1 is the number of distinct city names in station, 
write a query to find the value of N-N1 from station.
[table: station] */

SELECT COUNT(city) - COUNT(DISTINCT city) AS difference FROM station;


/* Q5. Answer the following
a. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. 
Your result cannot contain duplicates. [Hint: Use RIGHT() / LEFT() methods ].
b. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as 
both their first and last characters. Your result cannot contain duplicates.
c. Query the list of CITY names from STATION that do not start with vowels. 
Your result cannot contain duplicates.
d. Query the list of CITY names from STATION that either do not start with vowels or do not 
end with vowels. Your result cannot contain duplicates. [table: station] */ 


SELECT DISTINCT city FROM station WHERE city LIKE 'A%' OR city LIKE 'E%' OR city LIKE 'I%' OR city LIKE 'O%' OR city LIKE 'U%';


SELECT DISTINCT city FROM station WHERE city LIKE '[aeiou]%[aeiou]' ;

SELECT DISTINCT city FROM station WHERE city NOT LIKE 'A%' AND city NOT LIKE 'E%' AND city NOT LIKE 'I%' AND city NOT LIKE 'O%' AND city NOT LIKE 'U%';


SELECT DISTINCT city FROM station WHERE city NOT LIKE '[aeiou]%' OR city NOT LIKE '%[aeiou]' ;



/* Q6. Write a query that prints a list of employee names having a salary greater than $2000 
per month who have been employed for less than 36 months. Sort your result by descending 
order of salary. [table: emp] */

SELECT emp_name
FROM emp
WHERE salary > 2000 AND months_employed < 36
ORDER BY salary DESC;



/* Q7. How much money does the company spend every month on salaries for each department? [table: employee]

Expected Result
----------------------
+--------+--------------+
| deptno | total_salary |
+--------+--------------+
|     10 |     20700.00 |
|     20 |     12300.00 |
|     30 |      1675.00 |
+--------+--------------+
3 rows in set (0.002 sec)  */


SELECT deptno, SUM(salary) AS total_salary
FROM employee
GROUP BY deptno;



/* Q8. How many cities in the CITY table have a Population larger than 100000. [table: city] */

SELECT COUNT(name)
FROM city
HAVING SUM(population) > 100000;

/* Q9. What is the total population of California? [table: city] */

SELECT SUM(population)
FROM city
WHERE district = 'California';

/* Q10. What is the average population of the districts in each country? [table: city] */

SELECT CountryCode, AVG(Population) as AvgPopulation
FROM City
GROUP BY CountryCode;



/* Q11. Find the ordernumber, status, customernumber, 
customername and comments for all orders that are ‘Disputed=  [table: orders, customers] */

SELECT * FROM orders;
 
SELECT * FROM customers;

SELECT o.orderNumber, o.status, o.customerNumber, c.customerName, o.comments
FROM orders o
JOIN customers c ON o.customerNumber = c.customerNumber
WHERE o.status = 'Disputed';
