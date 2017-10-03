INSERT INTO Customers
 VALUES (1001, 'Suzanne', 'Viescas', '15127 NE 24th, #383',
 'Redmond', 'WA', '98052', 425, '555-2686');
-------------------------------------------------------------------------
INSERT INTO Customers (customerid, custfirstname, custlastname,
custstreetaddress, custcity, custstate, custzipcode, custareacode,
custphonenumber)
 VALUES (1001, 'Suzanne', 'Viescas', '15127 NE 24th, #383',
 'Redmond', 'WA', '98052', 425, '555-2686');
select * from customers;



-------------------------------------
create sequence orders_ordernumber_seq
increment by 1
start with 945
nocache
nocycle;

select max(ordernumber)from orders;

drop sequence orders_ordernumber_seq


ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
create public synonym orderid
for order_ordername_Seq;

INSERT INTO ORDERS(ORDERNUMBER, ORDERDATE, SHIPDATE, customerid, employeeid)
values(orders_ordernumber_seq.nextval,'2007-09-01','2007-09-04',1018,707);


insert into order_details(ordernumber,productnumber,quotedprice,quantityordered)
values(orders_ordernumber_seq.currval,1,1200,1)


-------------------------can't use sequence in where clause

SELECT orders.ordernumber, quantityordered from orders JOIN order_details
ON orders.ordernumber = order_details.ordernumber
where order_details.ordernumber = orders_ordernumber.currval;


---------------------------will work
----------------temp table using currval property
create table tempTbl AS
SELECT orders_ordernumber_seq.currval as ordernum
from dual; ---dual table is scratch space--????

----see the value in the order number column
SELECT Orders.ordernumber, quantityordered from orders join order_details
on orders.ordernumber= order_details.ordernumber
where order_details.ordernumber = (SELECT Ordernum from tempTbl);

drop table tempTbl;

-------------update
---update multiple columns on one row
---update one column on multiple row 
---update multiple columns on multiple rows
---set a save point so no data is permanently changed
savepoint one


select * from employees;
--MULTIPLE COLUMNS ON ONE ROW
--update employees SET EmpState = 'NY', EmpCity = 'Syracuse', EmpZipCode = 12965,
--EmpAreaCode ='315',EmpPhoneNumber = '555-5555'
--where EmployeeID = 705;



MULTIPLE ROW ONE COLUMN
UPDATE EMPLOYEES SET EmpState = 'CA';

--change multiple columns on multiple rows
--update employees set EmpState = 'AZ', EmpCity = 'Phenix'
--WHERE EmployeeID>704;

ROLLBACK TO one;


--Transactions --jiaoyi

---delete rows
delete * from Order_Details

delete from employees where employeeid=115;
savepoint one
delete employees where EMPAREACO;


----Synonyms server as permanent aliases for database objects 
--simplify object references
-- can be private or public
-- private synonyms are only avaliable to the user who created them
--public synonyms are avaliable to all database users

--find max order number being used 
select max(ordernumber) from orders;


---Base the sequence starting point on +1 from max
create sequence orders_ordernumber_seq
increment by 1
start with 945
nocycle 
nocache;
drop sequence orders_ordernumber_seq

--create a synonm for the sequence
CREATE PUBLIC SYNONYm Orderid
for orders_ordernumber_seq;

--- using the synonym instead of the actual name 
select orderid.nextval from dual;


--remove sequence and synonym
drop public synonym Orderid;
drop sequence orders_ordernumber_seq;

select * from products
--inner join vs Outer join
select p.productnumber, productname, ordernumber from products p
left outer join Order_Details od
ON p.productnumber = od.productnumber
where od.ordernumber is null;


---left outer join-- all of data from right side or listed 2nd and first 
--table put out nulls when no datas
select p.productnumber, productName, orderNumber from order_details od
right outer join Products p 
on p.ProductNumber = od.ProductNumber
where od.OrderNumber = p.OrderNumber;


--Oracle special way of doing outer join

select p.productnumber, productName, orderNumber 
from Products P, Order_Details od
where P.PRODUCTNUMBER = od.productnumber(+)
AND ORDERNUMBER IS NULL;


--THE LOWER function
SELECT LOWER (custlastname), UPPER(custfirstname)
from customers where custlastname = 'Brown';


--The upper function
SELECT UPPER(custlastname), upper(CUSTFIRSTNAME)
FROM CUSTOMERS WHERE Custlastname = 'Brown';


---SUBSTR function = (string, start, length)
--negative will start at the end


select distinct custzipcode,
substr(custzipcode, 1,3)as"1st 3bytes",
substr(custzipcode, -3,2)as"bytes 3 and 4"
from customers;


CREATE TABLE contacts
 (name VARCHAR2(40));
INSERT INTO contacts
 VALUES('LaFodant,Mike,934-384-3493');
INSERT INTO contacts
 VALUES('Harris,Annette,727-868-2739');
INSERT INTO contacts
 VALUES('Crew,Ben,352-239-3638');
COMMIT;


---string within string 
--format=(string, string to find, [start pos],[occurrence])

select name, instr(name,',') as "1st comma pos.",
             instr(name,',',10)as"1st comma after 9th bytes pos",
             instr(name,',',1,2)  "2nd comma pos"
             from contacts;
             
             
select name,
substr(name,1,instr(name,',')-1)as"Last",
substr(NAME,INSTR(NAME,',')+1, INSTR(NAME,',',1,2)-INSTR(NAME,',')-1) AS "FIRST"
FROM CONTACTS;


---LPAD/RPAD
--USED PAD /FILL IN/ CHARACTER STRING TO fix width
--LPAD/RPAD(field, length, fillchar)
select custfirstname, LPAD(custfirstname, 12,'*'), RPAD(custfirstname, 12,'*')
from customers
where custfirstname like 'J%';

---RTRIM/LTRIM
--USED TO REMOVE SPECIFIC string of character
--LTRIM(string, string to be trimmed from left)
--RTRIM(----------------------------------RIGHT)
SELECT vendname, vendstreetaddress, LTRIM(vendstreetaddress, 'PO')as "Box"
from vendors
where vendstreetaddress like 'PO%';


SELECT vendname, vendstreetaddress, RTRIM(vendstreetaddress, 'PO')as "Box"
from vendors
where vendstreetaddress like 'PO%';



---------------REPLACE
--REPLACE A string with another specified string
--format(string, old string, new string)

select vendstreetaddress,
replace(vendstreetaddress,'PO','Post Office')
from vendors where vendstreetaddress LIKE 'PO%';


--------------TRANSLATE
--ONLY FOR character
select name, translate(name,',','-')
from contacts;


------concat
--used to concatenate two character strings(same as ||)
select custlastname, ('Customer #' || CustomerID)
AS "Number"
From customers where CustomerID Between 1000 and 1005;

--length
--used to find the length of string, returns an int
select custlastname,
length(custlastname) as "Character in last name"
from customers where CustomerID BETWEEN 1000 AND 1005;
------------------------------Chapter 11
--TRUNC
--USED TO TRUNCATE A NUMERIC VALUE TO A SPECIAL NUMBER OF 
--DECIMAL POSITIONS
--MOD- USED TO RETURN REMAINDER PART OF CALCULATION WHEN DOING
--DIVISION
--MOD ???  16*14=224 235-224=11
SELECT 235/16 FROM DUAL;
SELECT TRUNC(235/16, 0),
MOD(235,16)FROM DUAL;

--NVL- Substitutes a value for a null value 
alter session set nls_date_format = 'YYYY-MON-DD';
--ESTABLISH A STARTING POINT TO ROLLBACK 
SAVEPOINT ONE;
--REMOVE A FEW ORDERS' SHIPDATE 
--CAN TEST THE NVL AND NVL2 functions

UPDATE ORDERS SET SHIPDATE = NULL WHERE ORDERNUMBER IN(667,668,669);
SELECT ORDERNUMBER, ORDERDATE, SHIPDATE,
NVL(SHIPDATE, '2008-JAN-20'),
NVL(SHIPDATE, '2008-JAN-20')-ORDERDATE AS "DELAY"
FROM ORDERS WHERE ordernumber between 665 and 670;

--NVL2 -ALLOW different actions base on weather a value is null
--takes the format NVL2(X,Y,Z)- if x is null z is display else y is displayed
SELECT SHIPDATE FROM ORDERS;

select ordernumber, orderdate,NVL2(shipdate, 'shipped', 'Not shipped') as "Status"
FROM ORDERS WHERE ORDERNUMBER BETWEEN 665 AND 670;

--to_char-converts dates and numbers to a formatted character string 
select productnumber, productname, to_char(retailprice, '$9,999.99') as "Retail Price"
from products where productnumber between 1 and 10
order by 3 desc;

--FORMAT DATES WITH TO_CHAR
--select to_Char(sysdate, 'yyyy/mm/dd') "Date today" from dual;
--select to_Char(sysdate, 'FMMonth DD, YYYY') FROM dual;
--select to_char(sysdate,'HH24:MI:SS') "TIME NOW" FROM DUAL;


-------------------Aggregates
 ----return one result per group of rows processed
 --also called multiple row and aggregate function
 --all group ignore null value except count(*)
 --distinct suppress duplicate values
 --COUNT MIN MAX functions can be used on values with character,
 --numeric, date data types
 
 --sum-- calculate total amount stored in a numeric column for a group rows
 select sum(retailprice- quotedprice)as "Total Profit"
 from order_details join products on
 order_details.productnumber = products.productnumber
 where ordernumber = 662;
-----avg--average of numeric values in a special colum
select avg(retailprice-quotedprice) as "Avg Profit"
FROM order_details JOIN products ON
ORDER_DETAILS.PRODUCTNUMBER = PRODUCTS.PRODUCTNUMBER
WHERE PRODUCTNAME LIKE '%Bike';

--use to_char pretty the result
select TO_CHAR(AVG(RETAILPRICE-QUOTEDPRICE),'$999.99')as "Avg Profit"
FROM Order_details join products on 
order_details.productnumber = products.productnumber
where PRODUCTNAME LIKE '%Bike';


---COUNT
--COUNT NON-NULL VALUE
--COUNT TOTAL RECORDS,INCLUDE NULL
SELECT COUNT(*) AS "# of Customers" from customers;

select count (*) as "# of vendors with no WWW"
FROM vendors where vendwebpage IS NULL;

---MAX --RETURN LARGEST NUMBER
SELECT TO_CHAR(MAX(RETAILPRICE-QUOTEDPRICE),'$9999.99')
AS "Largest Profit on Sale"
FROM Products JOIN order_details ON
products.productnumber = order_details.productnumber;

--MIN--smallest value
select to_Char(MIN(RETAILPRICE), '$999.99')
as "Lowest Price in products"
FROM PRODUCTS;

---GROUP BY 
--USED TO GROUP DATA
--MUST USE FOR individual column in the select clause with group
--cannot reference column aliases
--automatically go through our customers table and sort the table by state
--and then count the number of customers in each state.

select custstate, count(*)AS"# of customers in state" from Customers
group by custstate
order by 2 DESC;

-- this information is powerful because it can effect the bottom line
--marketing department was

select custcity, custstate from customers

select custcity, custstate, count(*)AS"# of customers in state" from Customers
group by  custstate,custcity
order by 2 DESC;

select custcity, custstate, count(*)AS"# of customers in state" from Customers
group by custcity, custstate
order by 2 DESC;

--be careful because you’ll lose the intent of the original statement 
--as now we’ll get the ranking by CITY and not by STATE

----having- filtering grouping results
--having clause server where clause 
--in the same select statement, the clause are evaluated in the
--order of: where, group by , having 
--if just interested in states have more than 5 customers 
--we can't use where to qualify the result of grouping need 
--use having 

select custstate, count(*)AS "States>5 Customers" FROM Customers
GROUP BY CUSTSTATE
HAVING count(*)>5
ORDER BY 2 DESC;

--where place WHERE and where to place 
--having, we can also use where but only filter
--the original data before it group 

SELECT CUSTAREACODE FROM CUSTOMERS;

SELECT CUSTSTATE, COUNT(*)AS "STATES>5 CUSTOMERS" FROM CUSTOMERS
WHERE CUSTAREACODE LIKE '4%'
GROUP BY CUSTSTATE
HAVING COUNT(*)>5
ORDER BY 2 DESC;


---COMPLEX QUERY
SELECT O.ORDERDETAILS,
TO_CHAR(SUM(QUANTITYORDERED*RETAILPRICE),'$99,999.99')
AS "Orders > $20,000.00"
from orders o
JOIN ORDER_DETAILS OD
ON O.ORDERNUMBER = OD.ORDERNUMBER
JOIN PRODUCTS P
ON OD.PRODUCTNUMBER = P.PRODUCTNUMBER
GROUP BY O.ORDERNUMBER
HAVING SUM(QUANTITYORDERED*RETAILPRICE)>20000
ORDER BY 2 DESC;


-------------------------------------CHAPTER 12
---SUBQUERIES
-- a query inside another query
--used when a query based on unknown value
---requires select and from clause
---must enclose in parentheses
--place on right side of comparison operator
-- can be sloved by join on
----single-row subqueries in a where clause
--only return one result to the outer query
--operator = < ,>, <== ,>==,<>
-- "scalar" subquery, only single value is returned
--scalars are one of the more frequence used types 
--of sub queries


select productname, to_char(retailprice,'$9,999.99') from products
where retailprice = (select MAX (RETAILPRICE) FROM PRODUCTS);


--SCALAR SUB QUERY IN SELECT CLAUSE
--Replicates the sub query value for each row displayed,
select orders.ordernumber, orders.orderdate,orders.shipdate,
(SELECT CUSTOMERS.CUSTLASTNAME FROM CUSTOMERS WHERE CUSTOMERS.CUSTOMERID = ORDERS.CUSTOMERID)AS
Customer from orders where orders.shipdate = '2007-10-03';
---Multiple row sub queries(sets)
--retuen more than one row of results
--requires the use IN, ANY, or Exists operators

---Multiply row in where clause -in operator


----exist operatorselect distinct productname
from orders join order_details
on orders.ordernumber = order_details.ordernumber
join products on order_details.productnumber = products.productnumber
where orders.ordernumber in 
(select ordernumber from order_details
 where productnumber = 2)
 AND products.productnumber <>2;

--find all customers who ordered a bicycle
select Customers.Customerid,
Customers.CustFirstname,
Customers.CustLastName
from Customers
WHERE EXISTS
(SELECT * FROM Orders inner join
 order_details ON Orders.ordernumber = order_details.orderNumber
 inner join products on products.productnumber = order_details.productnumber
 where Products.categoryID = 2 AND Orders.CustomerID = Orders.CustomerID);
 
 ----VIEW 
 -- it looks like a real table, 2 main purpose
 --simplify having to issue complex queries
 --Restrict access to certain columns from a table
 
 
 create view inventory
 as 
 select productname, productnumber,
 quantityonhand, retailprice
 from products
 with read only;
 
 
 select * from inventory

--------------*-----------------------------------------------------
select to_char(avg(sum (UNITPRICE*quantity-(unitprice*quantity*discount))),'$9,999.99') as " Avg Total Amount" 
         from orders join orderdetails on orders.ORDERID = orderdetails.ORDERID  
group by orders.ORDERID


SELECT TO_CHAR(AVG(SUM(quantity*unitprice-(unitprice*quantity*discount))),'$9,999.99')
FROM orders INNER JOIN orderdetails
ON orders.orderid = orderdetails.orderid
GROUP BY orders.orderid;


--vies is treated just like a table, process select clause 
-- to against it

select productnumber, to_Char(retailprice, '$9,999.99')
from inventory;


----can create views from more than one table 
--two table
create view CustomerOrders
AS
SELECT CustFirstName, custlastname, ordernumber, orderdate
from customers join orders
on customers.customerid = orders.customerid
with read only;

drop view CustomerOrders


--statement object

--an object sending sql statement to database
--resultset--an object contain the results of a query
--data retrive to resultset, 2 ways
--column name use it 
--use column's ordinal position