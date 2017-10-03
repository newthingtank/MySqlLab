
drop 

-- week 10
--find highest order number
select max(ordernumber) from orders;

--base the sequence starting point on +1 from max
create sequence orders_ordernumber_seq
increment by 1
start with 945
nocache
nocycle;

--create a synonym for the sequence
create public synonym orderid
for orders_ordernumber_seq;

--test out synonm
select orderid.nextval from dual;

--romove sequence and synonym
Drop public synonym orderid;
drop sequence orders_ordernumber_seq;

--outer join
--ansi outer join using left syntax
--answer question : which products haven't been ordered?
--left table always has data, right table may have null

select p.productNumber, productName, OrderNumber From Products P
LEFT OUTER JOIN ORDER_DETAILS OD
ON P.PRODUCTNUMBER = OD.PRODUCTNUMBER
WHERE OD.ORDERNUMBER IS NULL;


----answer question : which products haven't been ordered?
--RIGHT table always has data, right table may have null
SELECT P.PRODUCTNUMBER, PRODUCTNAME, ORDERNUMBER FROM ORDER_DETAILS OD
RIGHT OUTER JOIN products p
ON P.PRODUCTNUMBER = OD.PRODUCTNUMBER
WHERE OD.ORDERNUMBER IS NULL;

--the third way Oracle specific way of doing outer join
--answer question : which products haven't been ordered?
--table without the (+) always has data
--table with (+) may have nulls
SELECT P.PRODUCTNUMBER, PRODUCTNAME, ORDERNUMBER
FROM PRODUCTS P, ORDER_DETAILS OD
WHERE P.PRODUCTNUMBER = OD.PRODUCTNUMBER(+)
AND ORDERNUMBER IS NULL;


--STRING FUNCTION
--LOWER CASE
SELECT LOWER (CUSTLASTNAME), LOWER(CUSTFIRSTNAME)
FROM CUSTOMERS WHERE CUSTLASTNAME = 'Brown';

--UPPER CASE
SELECT UPPER(CUSTLASTNAME), UPPER(CUSTFIRSTNAME)
FROM CUSTOMERS WHERE CUSTLASTNAME = 'Brown';

--if you don't know the case of the data convert and test
SELECT * FROM EMPLOYEES WHERE EMPSTATE = 'Wa';

--istead try 
SELECT * FROM EMPLOYEES WHERE UPPER(empstate) = 'WA';

--OR 
SELECT * FROM EMPLOYEES WHERE LOWER(EMPSTATE)='wa';

--substr function 
-- string state length
select distinct custzipcode,
substr(custzipcode, 1, 3)AS "1st 3 bytes",
substr(custzipcode, -3, 2)AS "bytes 3 and 4"--?
FROM customers;


--need a new table called contacts for a  couple of example
-- note this is a poorly designes table
DROP TABLE CONTACTS;
CREATE TABLE CONTACTS
 (NAME VARCHAR2(40));
INSERT INTO CONTACTS
VALUES('LaFodant,Mike,934-384-3492');
insert into contacts 
VALUES('Harris,Annette,727-868-7823');
insert into contacts
VALUES('Crew,Den,352-321-3421');
commit;

--instring get number 
Return all of the contact names, and contact titles for all customers whose contact title has “Sales” as the 2nd word of the title. Make sure your query can handle any future additions that aren’t currently in the table but added later (where “Sales” is 2nd word). Potential title additions could be:
? Associate Sales Assistant – returned
? Associate Salesmanager – not returned
? Manager Sales – returned
? Assistant to Sales Manager – not returned


--query with substr and instr
SELECT NAME,
SUBSTR(NAME,1,INSTR(NAME,',')-1)AS"Last",
substr(name,instr(name,',')+1,instr(name,',',1,2)-instr(name,',')-1)AS"First"
from contacts



--lpad/rpad example
select Custfirstname, LPAD(custfirstname, 12,'*'), RPAD(custfirstname, 12, '*')
FROM customers
WHERE custfirstname like 'J%';


--trime string on LEFT
SELECT vendname, vendstreetaddress, LTRIM(vendstreetaddress, 'PO ')AS "Box"
FROM vendors
where vendstreetaddress like 'PO %';


--REPLACE -(String, old string, new string) > 1byte
SELECT vendstreetaddress,
 replace(vendstreetaddress,'PO ','Post Office ')
 from vendors where vendstreetaddress like 'PO %';
 
 --USE TRANSLATE FOR 1 BYTE STRING REPLACEMENT 
 SELECT NAME, TRANSLATE(NAME, ',','-')
 FROM CONTACTS;
 
 --USE CONCAT INSTEAD OF ||
SELECT CUSTLASTNAME, CONCAT ('CUSTOMER#', CUSTOMERID)
AS "NUMBER"
FROM CUSTOMERS WHERE CUSTOMERID BETWEEN 1000 AND 1005;

--LENGTH RETURN AS INTEGER
SELECT custlastname,
LENGTH(custlastname) AS "Character in last name"
from customers WHERE customerid between 1000 and 1005;



