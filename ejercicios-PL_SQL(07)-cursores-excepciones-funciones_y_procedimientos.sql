/*1) Desarrollar un procedimiento que permita insertar nuevos departamentos según las 
siguientes especificaciones:

   -Se pasará al procedimiento el nombre del departamento y la localidad.
   -El procedimiento insertará la fila nueva asignando como número de departamento la 
   decena siguiente al número mayor de la  tabla. 

   Se incluirá gestión de posibles errores.*/

CREATE OR REPLACE PROCEDURE insertar_depart(nombre_depart DEPART.DNOMBRE%type, localidad DEPART.LOC%type)IS
   numero_depart DEPART.DEPT_NO%type;
BEGIN
   SELECT MAX(d.DEPT_NO) INTO numero_depart
   FROM DEPART d;

   numero_depart := numero_depart+10;

   INSERT INTO DEPART VALUES(numero_depart,nombre_depart,localidad);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No hay filas');
END; 


/*2) Escribir un procedimiento que reciba todos los datos de un nuevo empleado y realice el alta del mismo, gestionando posibles errores.*/
CREATE OR REPLACE PROCEDURE alta_emple(emp_no EMPLE.EMP_NO%type, apellido EMPLE.APELLIDO%type,
oficio EMPLE.OFICIO%type, direccion EMPLE.DIR%type, fecha_alta EMPLE.FECHA_ALT%type, 
salario EMPLE.SALARIO%type, comision EMPLE.COMISION%type, departamento EMPLE.DEPT_NO%type) IS 
BEGIN
   INSERT INTO EMPLE VALUES(emp_no, apellido, oficio, direccion, fecha_alta, salario, comision, departamento);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No hay filas');
END;

/*PRUEBA*/
BEGIN
    alta_emple(7800,'TRUJILLO','PROFESOR',7800,DATE'1999-12-08',700,100,30);
END;

/*3) Codificar un procedimiento reciba como parámetros un numero de departamento, un importe (es decir, una cantidad de dinero) y un 
porcentaje (es decir, un tanto por ciento) y suba el salario a todos los empleados del departamento indicado. La subida de salario será 
o bien el porcentaje que se indica como parámetro o bien el importe indicado como parámetro: de las dos posibilidades, la que sea más 
beneficiosa para cada caso de empleado.

 Se incluirá gestión de posibles errores.*/

CREATE OR REPLACE PROCEDURE subida_salario(num DEPART.DEPT_NO%type, dinero NUMBER, porcentaje NUMBER)IS
   CURSOR recorre_salario IS 
      SELECT e.SALARIO, e.EMP_NO, e.DEPT_NO
      FROM EMPLE e 
      WHERE e.DEPT_NO = num;
   empleado recorre_salario%rowtype;
   porcentaje_resultado NUMBER;
BEGIN
   FOR empleado IN recorre_salario LOOP
      porcentaje_resultado := empleado.salario*porcentaje/100;
      IF(porcentaje_resultado>empleado.salario) THEN 
         UPDATE EMPLE e 
         SET e.salario = empleado.salario + porcentaje_resultado
         WHERE e.DEPT_NO = num;
      ELSE 
         UPDATE EMPLE e 
         SET e.salario = e.salario + dinero
         WHERE e.DEPT_NO = num;
      END IF;
   END LOOP;
END;


begin
    subida_salario(20,500,20);
end;



/*4) Escribir un procedimiento que suba el sueldo de todos los empleados que ganen igual 
o menos que el salario medio de su oficio. La subida será de el 50% de la diferencia entre 
el salario del empleado y la media de su oficio. Se deberá asegurar que la transacción no 
se quede a medias, y se gestionarán los posibles errores. */

CREATE OR REPLACE PROCEDURE suba_sueldo IS
   CURSOR emple_mayor_media IS
      select apellido, oficio, salario from emple e2
		WHERE salario<=(select avg(e.salario)
		from emple e
		WHERE e.oficio = e2.oficio
		group by e.oficio);
   emple_salario emple_mayor_media%rowtype;
BEGIN
   FOR emple_salario IN emple_mayor_media LOOP
      	UPDATE EMPLE e 
      	SET e.salario = e.salario + (e.salario - emple_salario.salario*0.5)
    	WHERE e.apellido = emple_salario.apellido;
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No hay filas');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error');
END;

/*empleados con salario menor a la media de salarios por oficio*/
select apellido, oficio, salario from emple e2
WHERE salario<=(select avg(e.salario)
from emple e
WHERE e.oficio = e2.oficio
group by e.oficio);

/*5) Diseñar una aplicación que simule un listado de liquidación de los empleados según las siguientes especificaciones:

- El listado tendrá el siguiente formato para cada empleado:
**********************************************************************
Liquidación del empleado:...................(1) 	Dpto:.................(2) 	Oficio:...........(3)

Salario		: ............(4)
Trienios		:.............(5)
Comp. Responsabil	:.............(6)
Comisión		:.............(7)
 			------------
Total		           :.............(8)
**********************************************************************
- Donde:
1 ,2, 3 y 4 Corresponden al apellido, departamento, oficio y salario del empleado.
5 Es el importe en concepto de trienios. Cada trienio son tres años completos desde la fecha de alta hasta la de emisión y supone 50 €. 
6 Es el complemento por responsabilidad. Será de 100 € por cada empleado que se encuentre directamente a cargo del empleado en cuestión.
7 Es la comisión. Los valores nulos serán sustituidos por ceros.
8 Suma de todos los conceptos anteriores.

El listado irá ordenado por Apellido. */

CREATE OR REPLACE PROCEDURE listado IS 
   
   SELECT e.salario
   FROM EMPLE e 

BEGIN
   DBMS_OUTPUT.PUT_LINE('Liquidación del empleado: '|| );

END;


/*6) Crear la tabla T_liquidacion con las columnas apellido, departamento, oficio, 
salario, trienios, comp_responsabilidad, comisión y total; y modificar la aplicación 
anterior para que en lugar de realizar el listado directamente en pantalla, guarde los 
datos en la tabla. Se controlarán todas las posibles incidencias que puedan ocurrir durante 
el proceso.*/



