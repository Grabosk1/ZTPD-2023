-- zad 1
--A
CREATE TABLE FIGURY (
id NUMBER PRIMARY KEY,
geometria MDSYS.SDO_GEOMETRY);

--B
--B
INSERT INTO FIGURY values(
    1, 
    MDSYS.SDO_GEOMETRY(
        2003,
        null,
        null,
        SDO_ELEM_INFO_ARRAY(1,1003,4),
        SDO_ORDINATE_ARRAY(3,5 ,5,3 ,7,5)
    )
);

INSERT INTO FIGURY values(
    2,
    MDSYS.SDO_GEOMETRY(
        2003, 
        NULL, 
        NULL, 
        MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
        MDSYS.SDO_ORDINATE_ARRAY(1,1, 5,5)
    )
);	

INSERT INTO FIGURY values(
    3,
    MDSYS.SDO_GEOMETRY(
        2002,
        null,
        null,
        SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1 ,5,2,2),
        SDO_ORDINATE_ARRAY(3,2 ,6,2 ,7,3 ,8,2, 7,1)
    )
);

select * from FIGURY;

--C
INSERT INTO FIGURY values(
    4,
    MDSYS.SDO_GEOMETRY(
			2003, 
			NULL, 
			NULL, 
			MDSYS.SDO_ELEM_INFO_ARRAY(1,1003,3),
			MDSYS.SDO_ORDINATE_ARRAY(4,4, 4,4)
    )
);

--D
SELECT id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(geometria,0.01)
FROM FIGURY;

--E
DELETE FROM FIGURY WHERE
SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(geometria,0.01) != 'TRUE';

--F
COMMIT;