/*Cursores*/

/*1) Desarrollar un programa que visualice el apellido y la fecha de alta de todos los empleados ordenados por apellido.*/

DECLARE
   apellido_emple EMPLE.APELLIDO%type;
   fecha_alta EMPLE.FECHA_ALT%type;
	cont INT:=1;
   CURSOR empleados_ordenados IS
    	SELECT e.apellido, e.fecha_alt 
    	FROM EMPLE e
    	ORDER BY e.apellido; 
BEGIN
    OPEN empleados_ordenados;
    LOOP
    	FETCH empleados_ordenados INTO apellido_emple, fecha_alta;
		EXIT WHEN empleados_ordenados%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('El apellido del empleado es: ' || apellido_emple ||' con una fecha de alta: '|| fecha_alta);
    END LOOP;
	CLOSE empleados_ordenados;
END;


/*2) Codificar un programa que muestre el nombre de cada departamento y el número de empleados que tiene.*/

DECLARE
   nombre_depart DEPART.DEPT_NO%type;
   numero_empleados INT := 0;
   CURSOR depart_num_emple IS
      SELECT d.DEPT_NO, COUNT(e.apellido)
      FROM DEPART d, EMPLE e
       WHERE d.DEPT_NO = e.DEPT_NO
      GROUP BY d.DEPT_NO;
BEGIN 
   OPEN depart_num_emple;
   LOOP 
      FETCH depart_num_emple INTO nombre_depart, numero_empleados;
      EXIT WHEN depart_num_emple%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('departamento: '||nombre_depart ||' con: '|| numero_empleados||' empleados');
   END LOOP;
   CLOSE depart_num_emple;
END;



/*3) Escribir un programa que reciba una cadena como parámeto ('&cadena') y visualice el apellido y el número de empleado de todos los 
empleados cuyo apellido contenga la cadena especificada. Al finalizar visualizar el número de empleados mostrados.*/



/*4) Escribir un programa que visualice el apellido y el salario de los cinco empleados que tienen el salario más alto.
   Nota: En el SELECT asociado al cursor NO debe limitarse el número de filas con %ROWNUM*/


/*5) Codificar un programa que visualice los dos empleados que ganan menos de cada oficio.
   Nota: En el SELECT asociado al cursor NO debe limitarse el número de filas con %ROWNUM */

/*6) Escribir un programa que muestre, en formato similar a las rupturas de control o secuencia vistas en SQL*plus los siguientes datos:

- Para cada empleado: apellido y salario.
- Para cada departamento: Número de empleados y suma de los salarios del departamento.
- Al final del listado: Número total de empleados y suma de todos los salarios.

  Nota: En el SELECT asociado al cursor debe recorrer simplemente las filas de la tabla de empleados/*


/*7) Escribir un programa PL-SQL que reciba un nombre de departamento como parámetro ('&parámetro') y muestre los datos de ese departamento.
   Nota: debe emplearse un cursor con parámetros */


/*8) Escribir un programa PL-SQL parametrizado que reciba un nombre de ciudad y dos valores de comisión y muestre el nombre de los empleados y su oficio de cada departamento de aquelos que tengan una comisión en ese rango. Solo se considerarán los departamentos localizados en la ciudad indicada.

Nota: deberán emplearse dos cursores parametrizados:
  -El primero que tenga como parámetro una ciudad
  -El segundo que tenga como parámetros un rango de comisiones y un departamento*/



/*9) Escribir un programa PL-SQL que incremente en un 10% el salario de los empleados más antiguos en todos los departamentos. Definir un cursor con la cláusula 'FOR UPDATE'*/


/*10) Escribir un programa PL-SQL parametrizado que reciba un nombre de departamento y un número positivo y que despida a ese número de empleados con menor antiguedad de ese departamento.
 Nota: debe emplearse un cursor parametrizado. Definir un cursor con parámetros que tenga la cláusula 'FOR UPDATE'*/





