/*

Drop EMPLOYEE table
Hanlde exception if the table does not exist

*/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

/*

Create EMPLOYEE table

*/

CREATE TABLE EMPLOYEE
(
EMPLOYEE_ID NUMBER,
FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
DOB DATE,
PHONE_NUMBER NUMBER(9)
);


/*

Insert 10 records into Employee Table

*/

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(1,'Lee','Munoz',TO_DATE('1980-03-04','yyyy-mm-dd'), 491570156);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(2,'Amelia','Cox',TO_DATE('1987-02-26','yyyy-mm-dd'), 455535507);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(3,'Misty','Benson',TO_DATE('1989-06-19','yyyy-mm-dd'), 406650430);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(4,'Shirley','Mccarthy',TO_DATE('1985-01-05','yyyy-mm-dd'), 427232456);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(5,'Lowell','Simon',TO_DATE('1983-08-30','yyyy-mm-dd'), 467528712);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(6,'Dave','Hines',TO_DATE('1984-08-08','yyyy-mm-dd'), 400894567);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(7,'Van','Schneider',TO_DATE('1986-04-15','yyyy-mm-dd'), 427567987);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(8,'Ervin','Rogers',TO_DATE('1988-09-15','yyyy-mm-dd'), 484663245);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(9,'Virgil','Alexander',TO_DATE('1990-08-02','yyyy-mm-dd'), 499553243);

INSERT INTO EMPLOYEE(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DOB, PHONE_NUMBER)
VALUES(10,'Leonard','Jensen',TO_DATE('1981-07-05','yyyy-mm-dd'), 411607865);

/*

Create new table EMPLOYEE_MASK with privatised version of EMPLOYEE

Drop table if it already exists

Use the following privatisation rules:

FIRST_NAME, LAST_NAME 

Generate a random number from 1 to 10 for each existing employee record. 
Lookup name of randomly generated employee ID and use that in place of their real name

DOB

Generate a random number, add the random number to the current DOB to calculate a new one (can either subtract or add days)

PHONE_NUMBER

Assuming the phone number starts with 4 and is 9 characters in length
Generate a random number between 400000000 and 499999999

*/

DECLARE
 tbl_cnt INTEGER;
 create_stmt varchar2(10000);
BEGIN

SELECT COUNT(*)
INTO tbl_cnt
FROM dba_tables
WHERE table_name = 'EMPLOYEE_MASK';

IF (tbl_cnt > 0) THEN
    EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE_MASK';
END IF;

EXECUTE IMMEDIATE 'CREATE TABLE EMPLOYEE_MASK AS
WITH Employees AS (
SELECT EMPLOYEE_ID
, DOB+floor(dbms_random.value(-200,1000)) AS DOB
,dbms_random.value(400000000,499999999) AS PHONE_NUMBER
,floor(dbms_random.value(1,10)) First_Name_Map
,floor(dbms_random.value(1,10)) Last_Name_Map
FROM EMPLOYEE
)
SELECT e.EMPLOYEE_ID
,ef.FIRST_NAME
,el.LAST_NAME
,e.DOB
,e.PHONE_NUMBER
FROM Employees e
INNER JOIN EMPLOYEE ef
ON e.First_Name_Map = ef.EMPLOYEE_ID
INNER JOIN EMPLOYEE el
ON e.Last_Name_Map = el.EMPLOYEE_ID
';

END;
/

SELECT *
FROM EMPLOYEE_MASK;



