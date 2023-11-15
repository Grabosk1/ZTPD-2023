--1
CREATE TABLE DOKUMENTY (
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
);

--2
DECLARE
    v_dokument CLOB := ''; -- Zmienna tymczasowa typu CLOB
BEGIN
    -- Konkatenacja tekstu 10000 razy
    FOR i IN 1..10000 LOOP
        v_dokument := v_dokument || 'Oto tekst. ';
    END LOOP;

    -- Wstawienie dokumentu do tabeli DOKUMENTY
    INSERT INTO DOKUMENTY (ID, DOKUMENT)
    VALUES (1, v_dokument);
    
    -- Zatwierdzenie transakcji
    COMMIT;
END;

--3 
select * from DOKUMENTY;
select id, UPPER(dokument) from dokumenty;
select id, LENGTH(dokument) from dokumenty;
select id, DBMS_LOB.getlength(dokument) from dokumenty;
select SUBSTR(dokument, 5, 1000) from dokumenty;
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--4
insert into dokumenty
values (2, EMPTY_CLOB());

--5
insert into dokumenty
values (3, NULL);

--6
select * from DOKUMENTY;
select id, UPPER(dokument) from dokumenty;
select id, LENGTH(dokument) from dokumenty;
select id, DBMS_LOB.getlength(dokument) from dokumenty;
select SUBSTR(dokument, 5, 1000) from dokumenty;
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--7
DECLARE
    clobd clob;
    dokumnet_file BFILE := BFILENAME('TPD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    select dokument into clobd
    from dokumenty 
    where id =2
    for update; 
    DBMS_LOB.fileopen(dokumnet_file, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(clobd,dokumnet_file,DBMS_LOB.LOBMAXSIZE,
    doffset, soffset, 0, langctx, warn);
    DBMS_LOB.FILECLOSE(dokumnet_file);
 COMMIT;
  DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);

END;

--8
UPDATE dokumenty
SET DOKUMENT = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'))
WHERE ID = 3;
COMMIT;

--9 
select * from dokumenty;

--10
select id, LENGTH(dokument) from dokumenty;
select id, DBMS_LOB.getlength(dokument) from dokumenty;

--11
DROP TABLE DOKUMENTY;

--12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    p_clob IN OUT  CLOB,
    p_search_string VARCHAR2
) AS
    l_search_len NUMBER;
    l_position NUMBER := 1;
    l_blob_len NUMBER;
BEGIN
    l_search_len := LENGTH(p_search_string);
    l_blob_len := DBMS_LOB.GETLENGTH(p_clob);
    WHILE l_position > 0 AND l_position <= l_blob_len LOOP
        l_position := INSTR(p_clob, p_search_string, l_position);
        IF l_position > 0 THEN
            DBMS_LOB.WRITE(p_clob, l_search_len, l_position, LPAD('.', l_search_len, '.'));
            l_position := l_position + l_search_len;
        END IF;
    END LOOP;
END;

--13
create table BIOGRAPHIES as select * from ztpd.BIOGRAPHIES;
select * from biographies;

--14
DECLARE
    clobd clob;
BEGIN
    select bio into clobd
    from BIOGRAPHIES 
    where person = 'Jara Cimrman'
    for update; 

    clob_censor(clobd, 'Cimrman');
END;

select * from biographies;

--14
drop table biographies;