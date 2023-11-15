--1
CREATE TABLE MOVIES_COPY AS SELECT * FROM ztpd.MOVIES;

--2
DESC MOVIES_COPY;
SELECT * FROM MOVIES_COPY;

--3
select id, title from movies_copy where cover is null;

--4
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from movies_copy where cover is not null;

--5
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from movies_copy where cover is  null;

--6
select * from ALL_DIRECTORIES;

--7
UPDATE MOVIES_COPY
SET cover = EMPTY_BLOB(),
    mime_type = 'image/jpeg'
WHERE id = 66;
COMMIT;

--8
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from movies_copy where id in (65,66);

--9

DECLARE
    blobd blob;
    cover_file BFILE := BFILENAME('TPD_DIR','escape.jpg');
BEGIN
    select cover into blobd
    from movies_copy 
    where id =66
    for update; 
    DBMS_LOB.fileopen(cover_file, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(blobd,cover_file,DBMS_LOB.GETLENGTH(cover_file));
    DBMS_LOB.FILECLOSE(cover_file);
 COMMIT;
END;

--10
CREATE TABLE TEMP_COVERS  (
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

--11
INSERT INTO TEMP_COVERS
VALUES (65, BFILENAME('TPD_DIR','eagles.jpg'), 'image/jpeg');

COMMIT;

--12
select movie_id, dbms_lob.getlength(image) as filesize
from TEMP_COVERS; 

--13
DECLARE
    blobd blob;
    cover_file BFILE;
    mime VARCHAR2(50);
BEGIN
    select image, mime_type 
    into cover_file, mime
    from temp_covers
    for update; 
    
    dbms_lob.createtemporary(blobd, TRUE);
    DBMS_LOB.fileopen(cover_file, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(blobd,cover_file,DBMS_LOB.GETLENGTH(cover_file));
    DBMS_LOB.FILECLOSE(cover_file);
    
    UPDATE MOVIES_COPY 
    set cover = blobd, mime_type = mime
    where id =65;
    
    dbms_lob.freetemporary(blobd);
 COMMIT;
END;


--14
select id, title, DBMS_LOB.GETLENGTH(cover) as filesize from movies_copy where id in (65,66);

--15 
DROP TABLE MOVIES_COPY
