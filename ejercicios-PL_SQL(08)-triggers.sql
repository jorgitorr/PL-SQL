--EJEMPLOS DE DISPARADORES Ó TRIGGERS


1.- Construir un disparador de base de datos que permita auditar las operaciones de inserción o borrado de datos que se realicen en la tabla emple según las siguientes especificaciones:
-	En primer lugar se creará desde SQL*Plus la tabla auditaremple con la columna col1 VARCHAR2(200).
-	Cuando se produzca cualquier manipulación se insertará una fila en dicha tabla que contendrá: 
-	Fecha y hora
-	Número de empleado
-	Apellido
-	La operación de actualización INSERCIÓN o BORRADO


2.- Escribir un trigger de base de datos un que permita auditar las modificaciones en la tabla empleados insertado en la tabla auditaremple los siguientes datos: 
-	Fecha y hora
-	Número de empleado
-	Apellido
-	La operación de actualización: MODIFICACIÓN.
-	El valor anterior y el valor nuevo de cada columna modificada. (solo las columnas modificadas)


3.- Escribir un disparador de base de datos que haga fallar cualquier operación de modificación del apellido o del número de un empleado, o que suponga una subida de sueldo superior al 10%.


4.- Suponiendo que disponemos de la vista

CREATE VIEW DEPARTAM AS
SELECT DEPART.DEPT_NO, DNOMBRE, LOC, COUNT(EMP_NO) TOT_EMPLE  
FROM EMPLE, DEPART
WHERE EMPLE.DEPT_NO (+) = DEPART.DEPT_NO
GROUP BY DEPART.DEPT_NO, DNOMBRE, LOC;

Construir un disparador que, cuando se pretenda realizar una operación de actualización sobre la vista 'DEPARM', realice la actualización efectiva sobre la tabla 'depart'. En concreto se consideraran las siguientes operaciones de actualización:
	-Insertar departamento.
	-Borrar departamento.
	-Modificar la localidad de un departamento.

