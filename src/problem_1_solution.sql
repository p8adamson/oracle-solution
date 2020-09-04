/*

Attempt to drop the transaction table
Ignore error if it already exists

*/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE TRANSACTIONS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

/*

Create transaction table
*/

CREATE TABLE TRANSACTIONS
(
trn_desc1 varchar2(20),
trn_desc2 varchar2(20),
trn_desc3 varchar2(20)
);

/*

insert test data

*/

INSERT INTO TRANSACTIONS(trn_desc1, trn_desc2, trn_desc3)
VALUES('Trn ref 0967456 on 0','2 Sep 2020 by Steve ','Richards');

INSERT INTO TRANSACTIONS(trn_desc1, trn_desc2, trn_desc3)
VALUES('Steve Richards 02-Se','ptember-20 967456','');

INSERT INTO TRANSACTIONS(trn_desc1, trn_desc2, trn_desc3)
VALUES('Transfer from Steve ','Richards trn ref 096','7456 on 02/09/20');

INSERT INTO TRANSACTIONS(trn_desc1, trn_desc2, trn_desc3)
VALUES('Transfer from Steve ','Richards trn ref 096',' 7456 on 02/09/20');
   
INSERT INTO TRANSACTIONS(trn_desc1, trn_desc2, trn_desc3)
VALUES('Transfer from Steve ','Richards trn ref 096','745602/09/20');

/*

extract TRI from strings. 

1. Combine String fields
2. Extract TRI based on regex expression - look for a 0 in the string followed by 6 digits

*/

SELECT TRN_DESC1 || TRN_DESC2 || TRN_DESC3, REGEXP_SUBSTR(TRN_DESC1 || TRN_DESC2 || TRN_DESC3, '[0]\d{6}') AS TRI
FROM TRANSACTIONS
