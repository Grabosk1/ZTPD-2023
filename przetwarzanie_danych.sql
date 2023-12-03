--zad 1
INSERT INTO USER_SDO_GEOM_METADATA VALUES (
    'FIGURY',
    'GEOMETRIA',
    MDSYS.SDO_DIM_ARRAY(
        MDSYS.SDO_DIM_ELEMENT('X', 0, 100, 0.01),
        MDSYS.SDO_DIM_ELEMENT('Y', 0, 100, 0.01)
    ),
    NULL
);

DELETE FROM  USER_SDO_GEOM_METADATA
WHERE TABLE_NAME = 'FIGURY';

--B
SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0)
FROM FIGURY
WHERE ROWNUM <= 1;

--C
CREATE INDEX geometria_index
ON FIGURY(GEOMETRIA)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

--D
SELECT ID
FROM FIGURY
WHERE SDO_FILTER(
            GEOMETRIA,
            SDO_GEOMETRY(
                2001,
                NULL,
                SDO_POINT_TYPE(3,3, NULL),
                NULL, 
                NULL
            )
        ) = 'TRUE';
-- wynik nie odpowiada rzeczywistoœci
--E
SELECT ID
FROM FIGURY
WHERE SDO_RELATE(
            GEOMETRIA,
            SDO_GEOMETRY(
                2001,
                NULL,
                SDO_POINT_TYPE(3,3, NULL),
                NULL,
                NULL
            ),
            'mask=ANYINTERACT'
        ) = 'TRUE';
        
-- wynik odpowiada rzeczywistoœci 
--zad 2
--A
SELECT A.CITY_NAME MIASTO, ROUND(SDO_NN_DISTANCE(1), 8) ODL
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE SDO_NN(
        A.GEOM,
        B.GEOM,
        'sdo_num_res=10 unit=km',
        1
    ) = 'TRUE'
    AND B.CITY_NAME = 'Warsaw'
    AND A.CITY_NAME <> 'Warsaw';
 
 
 --B
SELECT A.CITY_NAME MIASTO
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE SDO_WITHIN_DISTANCE(
            A.GEOM,
            MDSYS.SDO_GEOMETRY(
                2001,
                8307,
                B.GEOM.SDO_POINT,
                B.GEOM.SDO_ELEM_INFO,
                B.GEOM.SDO_ORDINATES
            ),
            'distance=100 unit=km'
        ) = 'TRUE'
        AND B.CITY_NAME = 'Warsaw'
        AND A.CITY_NAME <> 'Warsaw';
        
--C
SELECT A.CNTRY_NAME KRAJ, B.CITY_NAME MIASTO
FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
WHERE SDO_RELATE(B.GEOM, A.GEOM, 'mask=INSIDE') = 'TRUE' AND A.CNTRY_NAME = 'Slovakia';
   
--D
SELECT A.CNTRY_NAME PANSTWO, ROUND(SDO_GEOM.SDO_DISTANCE(A.GEOM, B.GEOM, 1, 'unit=km'), 2) ODL
FROM COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
WHERE SDO_RELATE(
            A.GEOM,
            B.GEOM,
            'mask=ANYINTERACT'
        ) != 'TRUE'
        AND B.CNTRY_NAME = 'Poland';

--zad 3
--A
SELECT A.CNTRY_NAME, ROUND(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km'), 2) ODLEGLOSC
FROM COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B
WHERE SDO_FILTER(A.GEOM, B.GEOM) = 'TRUE' AND B.CNTRY_NAME = 'Poland';

--B
SELECT CNTRY_NAME
FROM COUNTRY_BOUNDARIES
WHERE SDO_GEOM.SDO_AREA(GEOM) = (SELECT MAX(SDO_GEOM.SDO_AREA(GEOM)) FROM COUNTRY_BOUNDARIES);

--C
SELECT ROUND(
        SDO_GEOM.SDO_AREA(
            SDO_GEOM.SDO_MBR(
                SDO_GEOM.SDO_UNION(
                    A.GEOM,
                    B.GEOM,
                    0.01
                )
            ),
            1,
            'unit=SQ_KM'
        ),
        5
    ) SQ_KM
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE A.CITY_NAME = 'Warsaw' AND B.CITY_NAME = 'Lodz';


--D
SELECT SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_DIMS() || SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_LRS_DIM() || LPAD(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 0.01).GET_GTYPE(), 2, '0') GTYPE
FROM MAJOR_CITIES A, COUNTRY_BOUNDARIES B
WHERE A.CITY_NAME = 'Prague' AND  B.CNTRY_NAME = 'Poland';

--E
SELECT B.CITY_NAME, A.CNTRY_NAME
FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
WHERE A.CNTRY_NAME = B.CNTRY_NAME AND SDO_GEOM.SDO_DISTANCE(
        SDO_GEOM.SDO_CENTROID(A.GEOM, 1),
        B.GEOM,
        1) = (
            SELECT MIN(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(A.GEOM, 1), B.GEOM, 1))
            FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B
            WHERE A.CNTRY_NAME = B.CNTRY_NAME
        );
       
--F
SELECT NAME, ROUND(SUM(DLUGOSC), 2) DLUGOSC
FROM (
    SELECT R.NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, R.GEOM, 1), 1, 'unit=KM') DLUGOSC
    FROM COUNTRY_BOUNDARIES B, RIVERS R
    WHERE SDO_RELATE(
                B.GEOM,
                 R.GEOM,
                'mask=ANYINTERACT'
            ) = 'TRUE'
            AND B.CNTRY_NAME = 'Poland')
GROUP BY NAME;