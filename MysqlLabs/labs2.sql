select 235/16 from dual;


select trunc(235/16)as "WHOLE NUMBER PART",
        MOD (235,16)AS"Remainder Part"
From DUAL;

SELECT 100, ABS(-100) FROM DUAL;

alter session set nls_date_format = 'YYYY-MON-DD';

--establish starting point to rollback
SAVEPOINT ONE;

--remove order's shipdate
update orders set shipdate = null where ordernumber in (667, 668, 669);

--exercise the NVL function
SELECT ORDERNUMBER, ORDERDATE, SHIPDATE,
NVL(SHIPDATE,'2008-JAN-20'),
NVL(SHIPDATE,'2008-JAN-20')-orderdate AS "Delay"
FROM orders WHERE ordernumber BETWEEN 665 AND 670;


--EXERCISE the NVL2 function
SELECT ordernumber, orderdate,
NVL2(shipdate, 'Shipped','Not Shipped')
AS "Status"
FROM ORDERS WHERE ORDERNUMBER BETWEEN 665 AND 670;

--EXERCSIE THE NVL2 
SELECT ordernumber, orderdate,
NVL2(shipdate, 'Shipped','Not Shipped')
AS "Status"
FROM ORDERS WHERE ORDERNUMBER BETWEEN 665 AND 670
ORDER BY 3;

ROLLBACK TO ONE;


--FORMAT # A  WITH TO_CHAR
SELECT productnumber, productname, retailprice,
TO_CHAR(retailprice, '$9,999.99')AS "Retail Price"
from products where productnumber between 1 and 10
order by 3 desc;


--format dates with to_char
SELECT TO_CHAR(ORDERDATE,'MONTH DD, YYYY') AS "Order Date",
       TO_CHAR(shipdate,'MON-DD-RR')AS "SHIP DATE"
FROM Orders WHERE ordernumber between 665 and 670;

select * from order_details where ordernumber=662;

select sum (retailprice-quotedprice) AS "Total Profit"
FROM order_details join products on order_details.productnumber = products.PRODUCTNUMBER
where ordernumber=662;

--AVG
--calculate avg profit for bike products
SELECT AVG(retailprice-quotedprice)AS "Avg Profit"
FROM ORDER_DETAILS JOIN PRODUCTS ON
ORDER_DETAILS.PRODUCTNUMBER = PRODUCTS.PRODUCTNUMBER
WHERE PRODUCTNAME LIKE '%Bike';

--AVG embedded to TO_CHAR
SELECT TO_CHAR(AVG(retailprice-quotedprice), '$999.99') AS "Avg Profit"
FROM ORDER_Details JOIN products ON
ORDER_DETAILS.PRODUCTNUMBER = products.PRODUCTNUMBER
WHERE PRODUCTNAME LIKE '%Bike';

--count rows with data
SELECT COUNT (*) AS "# of Customers" FROM customers;
SELECT sum (customerid) AS "# of Customers" FROM customers;
select * from customers;

--count rows without data
select * from vendors;
select count (*) AS "# of Vendors with no WWW"
FROM Vendors
WHERE VENDWEBPAGE is null;

--largest profit made on sale
select * from customers order by custstate;

select to_char(MAX(RETAILPRICE-QUOTEDPRICE), '$999.99')
AS "Largest profit on sale"
from products join order_details on 
products.productnumber=order_details.productnumber;

--group by example where are our customers located


-- common error when using aggregate and group ora979
SELECT custcity, CUSTSTATE, COUNT (*) AS "# of Customers in State" FROM Customers
group by custstate
order by 2 desc;

SELECT * FROM CUSTOMERS ORDER BY CUSTSTATE;

--SELECT CUSTSTATE COUNT (*) AS "# of Customers in State" FROM CUSTOMERS
--GROUP BYCUSTSTATE;

SELECT CUSTCITY,CUSTSTATE COUNT(*)AS "# of Customers in State" FROM Customers
Group by Custstate
order by 2 desc;

SELECT CUSTCITY,CUSTSTATE, COUNT (*) AS "# of Customers in State" FROM Customers
Group by Custstate,custcity
order by 2 desc;

select custstate, count(*)as "States>5 Customers" FROM Customers
Group by CUSTSTATE
HAVING COUNT (*)>5
ORDER BY 2 DESC;



select custstate, count(*)as "States>5 Customers" FROM Customers
WHERE CUSTSTATE IN ('WA','TX')
Group by CUSTSTATE
HAVING COUNT (*)>5
ORDER BY 2 DESC;


-- COMPLEX EXAMPLE
SELECT o.ordernumber,
TO_CHAR(SUM(quantityordered*retailprice), '$99,999.99')
AS"Orders> $20,000.00"
FROM ORDERS O
JOIN ORDER_DETAILS OD
ON O.ORDERNUMBER = OD.ORDERNUMBER
JOIN PRODUCTS P
ON OD.PRODUCTNUMBER = P.PRODUCTNUMBER
GROUP BY O.ORDERNUMBER
HAVING SUM(QUANTITYORDERED*RETAILPRICE)>2000;