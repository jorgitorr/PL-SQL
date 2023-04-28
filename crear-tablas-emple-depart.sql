--Definición de tablas

ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';


REM ******** TABLA DEPART: ***********

DROP TABLE DEPART cascade constraints;

CREATE TABLE DEPART (
DEPT_NO NUMBER(2) NOT NULL,
DNOMBRE VARCHAR2(14),
LOC VARCHAR2(14) ) ;


REM ******** TABLA EMPLE: *************


DROP TABLE EMPLE cascade constraints;

CREATE TABLE EMPLE (
EMP_NO NUMBER(4) NOT NULL,
APELLIDO VARCHAR2(10) ,
OFICIO VARCHAR2(10) ,
DIR NUMBER(4) ,
FECHA_ALT DATE ,
SALARIO NUMBER(10),
COMISION NUMBER(10),
DEPT_NO NUMBER(2) NOT NULL) ;


--Inserción de datos

INSERT INTO DEPART VALUES (10,'CONTABILIDAD','SEVILLA');
INSERT INTO DEPART VALUES (20,'INVESTIGACIÓN','MADRID');
INSERT INTO DEPART VALUES (30,'VENTAS','BARCELONA');
INSERT INTO DEPART VALUES (40,'PRODUCCIÓN','BILBAO');

INSERT INTO EMPLE VALUES (7369,'SÁNCHEZ','EMPLEADO',7902,DATE'1980-12-17', 104000,NULL,20);
INSERT INTO EMPLE VALUES (7499,'ARROYO','VENDEDOR',7698,DATE'1980-02-20', 208000,39000,30);
INSERT INTO EMPLE VALUES (7521,'SALA','VENDEDOR',7698,DATE'1981-02-22', 162500,65000,30);
INSERT INTO EMPLE VALUES (7566,'JIMÉNEZ','DIRECTOR',7839,DATE'1981-04-02', 386750,NULL,20);


INSERT INTO EMPLE VALUES (7364,'JOSELU','EMPLEADO',7902,DATE'1981-12-17', 104000,NULL,20);
INSERT INTO EMPLE VALUES (7321,'JJ','VENDEDOR',7698,DATE'1981-02-22', 162500,65000,30);
INSERT INTO EMPLE VALUES (7501,'GUTS','EMPLEADO',7698,DATE'1989-02-22', 162500,65000,30);
INSERT INTO EMPLE VALUES (7221,'GRIFITH','VENDEDOR',7698,DATE'2001-02-22', 162500,65000,30);

COMMIT;

