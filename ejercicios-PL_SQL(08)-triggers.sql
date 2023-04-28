--EJEMPLOS DE DISPARADORES Ó TRIGGERS


/*1.- Construir un disparador de base de datos que permita auditar las operaciones de inserción o borrado de datos que 
se realicen en la tabla emple según las siguientes especificaciones:
-	En primer lugar se creará desde SQL*Plus la tabla auditaremple con la columna col1 VARCHAR2(200).
-	Cuando se produzca cualquier manipulación se insertará una fila en dicha tabla que contendrá: 
-	Fecha y hora
-	Número de empleado
-	Apellido
-	La operación de actualización INSERCIÓN o BORRADO*/

CREATE TABLE AUDITAREMPLE(col VARCHAR2(200));

CREATE OR REPLACE TRIGGER inserta 
AFTER INSERT OR DELETE 
ON EMPLE 
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
    	INSERT INTO AUDITAREMPLE VALUES(TO_CHAR(:NEW.FECHA_ALT,'DD-MON-YYYY')||TO_CHAR(:NEW.EMP_NO,'0000')||' '||:NEW.APELLIDO);
	ELSIF DELETING THEN
    	INSERT INTO AUDITAREMPLE VALUES(TO_CHAR(:OLD.FECHA_ALT,'DD-MON-YYYY')||TO_CHAR(:OLD.EMP_NO,'0000')||' '||:OLD.APELLIDO); 
	END IF;
END;

/*USO*/
INSERT INTO EMPLE VALUES(6588, 'FERNANDEZ', 'OFICIAL', 7655, DATE'1998-03-05',
    5600, 600, 10);

/*2.- Escribir un trigger de base de datos un que permita auditar las modificaciones en la tabla empleados insertado en la tabla auditaremple los siguientes datos: 
-	Fecha y hora
-	Número de empleado
-	Apellido
-	La operación de actualización: MODIFICACIÓN.
-	El valor anterior y el valor nuevo de cada columna modificada. (solo las columnas modificadas)*/

CREATE OR REPLACE TRIGGER auditar_mod 
BEFORE UPDATE 
ON EMPLE 
FOR EACH ROW
BEGIN
    UPDATE AUDITAREMPLE
    SET col = TO_CHAR(:NEW.FECHA_ALT,'DD-MON-YYYY')||' '||TO_CHAR(:NEW.EMP_NO)||' '||:NEW.APELLIDO;
END;

/*USO*/
UPDATE EMPLE e
SET e.EMP_NO = 20,
e.FECHA_ALT = DATE'1978-11-23',
e.APELLIDO = 'Juan'
WHERE e.APELLIDO = 'JJ';


/*3.- Escribir un disparador de base de datos que haga fallar cualquier operación de modificación del apellido o del número de un empleado, o que suponga una subida de sueldo superior al 10%.*/


CREATE OR REPLACE TRIGGER falla_mod 
BEFORE UPDATE 
ON EMPLE
FOR EACH ROW 
BEGIN
    IF(:NEW.APELLIDO!=:OLD.APELLIDO)THEN
    	RAISE_APPLICATION_ERROR(-20001,'No se puede modificar un apellido');
	ELSIF(:NEW.EMP_NO!=:OLD.EMP_NO)THEN
        RAISE_APPLICATION_ERROR(-20001,'No se puede modificar el numero de empleado');
    ELSIF(:NEW.SALARIO>:OLD.SALARIO*1.1)THEN 
    	RAISE_APPLICATION_ERROR(-20001,'No se puede añadir un salario mayor del 10% del anterior');
    END IF;
END;

/*uso*/

UPDATE EMPLE
SET APELLIDO = 'Gutierrez'
WHERE APELLIDO = 'GUTS';

UPDATE EMPLE
SET SALARIO = SALARIO*1.2
WHERE APELLIDO = 'GUTS';


UPDATE EMPLE
SET SALARIO = SALARIO*1.1
WHERE APELLIDO = 'GUTS';



/*
esta mal porque solo se activa cuando hay act de las col indicadas en el OF
CREATE OR REPLACE TRIGGER falla_mod 
BEFORE UPDATE 
OF APELLIDO, EMP_NO ESTE SOLO SE ACTIVA CUANDO HAY ACTUALIZACION DE ESTAS COLUMNAS 
ON EMPLE
FOR EACH ROW 
BEGIN
    IF(:NEW.SALARIO>:OLD.SALARIO*1.1)THEN
    	RAISE_APPLICATION_ERROR(-20001,'No se puede añadir un salario mayor del 10% del anterior');
    END IF;
END;*/

/*USO:*/



/*4.- Suponiendo que disponemos de la vista

CREATE VIEW DEPARTAM AS
SELECT DEPART.DEPT_NO, DNOMBRE, LOC, COUNT(EMP_NO) TOT_EMPLE  
FROM EMPLE, DEPART
WHERE EMPLE.DEPT_NO (+) = DEPART.DEPT_NO
GROUP BY DEPART.DEPT_NO, DNOMBRE, LOC;

Construir un disparador que, cuando se pretenda realizar una operación de actualización sobre la vista 'DEPARM', realice la actualización efectiva sobre la tabla 'depart'. En concreto se consideraran las siguientes operaciones de actualización:
	-Insertar departamento.
	-Borrar departamento.
	-Modificar la localidad de un departamento.*/



/*EL 2 NO SÉ SI ESTÁ BIEN PORQUE NO 
ENTIENDO MUY BIEN EL ENUNCIADO*/