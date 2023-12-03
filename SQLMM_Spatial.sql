--zad1 

--a
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;
 
 --b
 select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

--c 
CREATE TABLE MYST_MAJOR_CITIES (
FIPS_CNTRY VARCHAR2(2),
CITY_NAME VARCHAR2(40),
STGEOM ST_POINT);

--d
insert into MYST_MAJOR_CITIES
select id, fips_cntry, city_name,  ST_POINT(geom) from ZTPD.MAJOR_CITIES;

select * from MYST_MAJOR_CITIES

--zad2

--a
insert into MYST_MAJOR_CITIES values ('PL', 'Szczyrk', ST_POINT(19.036107, 49.718655, 8307));

--zad3

--a
create table MYST_COUNTRY_BOUNDARIES
(FIPS_CNTRY VARCHAR2(2),
CNTRY_NAME VARCHAR2(40),
 STGEOM ST_MULTIPOLYGON);

--b
insert into  MYST_COUNTRY_BOUNDARIES
select FIPS_CNTRY, CNTRY_NAME, ST_MULTIPOLYGON(GEOM)
from COUNTRY_BOUNDARIES;

--c
select B.STGEOM.ST_GEOMETRYTYPE() as TYP_OBIEKTU, count(*) 
from MYST_COUNTRY_BOUNDARIES B 
group by B.STGEOM.ST_GEOMETRYTYPE();

--d
select B.STGEOM.ST_ISSIMPLE() 
from MYST_COUNTRY_BOUNDARIES B 

--zad4

--a
select B.CNTRY_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B,
 MYST_MAJOR_CITIES C
where C.STGEOM.ST_WITHIN(B.STGEOM) = 1
group by B.CNTRY_NAME; 

--b
select A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
from MYST_COUNTRY_BOUNDARIES A,
 MYST_COUNTRY_BOUNDARIES B
where A.STGEOM.ST_TOUCHES(B.STGEOM) = 1
and B.CNTRY_NAME = 'Czech Republic';

--c
select distinct B.CNTRY_NAME, R.name
from MYST_COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Czech Republic'
and ST_LINESTRING(R.GEOM).ST_INTERSECTS(B.STGEOM) = 1;

--d
select TREAT(A.STGEOM.ST_UNION(B.STGEOM)  as ST_POLYGON ).ST_AREA() as powierzchnia
from MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Czech Republic'
and B.CNTRY_NAME = 'Slovakia';

--e
select B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)) as obiekt , B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).ST_GeometryType() WEGRY_BEZ
from MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
and W.name = 'Balaton';

--zad5

--A
explain plan for
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select * from table(dbms_xplan.display);
--b
insert into USER_SDO_GEOM_METADATA
 select 'MYST_MAJOR_CITIES', 'STGEOM',
 T.DIMINFO, T.SRID
 from ALL_SDO_GEOM_METADATA T
 where T.TABLE_NAME = 'MAJOR_CITIES';
 
 --c
create index MYST_MAJOR_CITIES_IDX on
MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;
 
--d
explain plan for
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select * from table(dbms_xplan.display);
