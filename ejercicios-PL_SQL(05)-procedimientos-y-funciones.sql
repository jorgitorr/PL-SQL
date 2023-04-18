/*FUNCIONES Y PROCEDIMIENTOS*/


1)  Indicar los errores que aparecen en las siguientes instrucciones y la forma de corregirlos.

DECLARE
  Num1 NUMBER(8,2) := 0						
  Num2 NUMBER(8,2) NOT NULL DEFAULT 0;    
  Num3 NUMBER(8,2) NOT NULL;
  Cantidad INTEGER(3);				
  Precio, Descuento NUMBER(6);
  Num4 Num1%ROWTYPE;
  Dto CONSTANT INTEGER;		
BEGIN
  ...
END;


2) Escribir un procedimiento que reciba dos números y visualice su suma.


3) Codificar un procedimiento que reciba una cadena y la visualice al revés.


4) Escribir una función que reciba una fecha y devuelva el año, en número, correspondiente a esa fecha.


5) Escribir un bloque PL/SQL que haga uso de la función anterior.


6) Dado el siguiente procedimiento:


CREATE OR REPLACE PROCEDURE crear_depart (
  v_num_dept depart.dept_no%TYPE, 
  v_dnombre depart.dnombre%TYPE DEFAULT 'PROVISIONAL',
  v_loc     depart.loc%TYPE DEFAULT PROVISIONAL)
IS
BEGIN
  INSERT INTO depart
    VALUES (v_num_dept, v_dnombre, v_loc);
END crear_depart;


Indicar cuáles de las siguientes llamadas son correctas y cuáles incorrectas, en este último caso escribir la llamada correcta usando la notación posicional (en los casos que se pueda):
crear_depart;						-- 1º
crear_depart(50);					-- 2º	
crear_depart('COMPRAS');				-- 3º
crear_depart(50,'COMPRAS');			-- 4º
crear_depart('COMPRAS', 50);			-- 5º
crear_depart('COMPRAS', 'VALENCIA');		-- 6º
crear_depart(50, 'COMPRAS', 'VALENCIA');	-- 7º
crear_depart('COMPRAS', 50, 'VALENCIA');	-- 8º
crear_depart('VALENCIA', COMPRAS);		-- 9º
crear_depart('VALENCIA', 50);  			-- 10º


7) Desarrollar una función que devuelva el número de años completos que hay entre dos fechas que se pasan como argumentos.


8) Escribir una función que, haciendo uso de la función anterior devuelva los trienios que hay entre dos fechas. (Un trienio son tres años completos).


9) Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su suma.


10) Escribir una función que devuelva solamente caracteres alfabéticos sustituyendo cualquier otro carácter por blancos a partir de una cadena que se pasará en la llamada.


11) Implementar un procedimiento que reciba un importe y visualice el desglose del cambio en unidades monetarias de 1, 5, 10, 25, 50, 100, 200, 500, 1000, 2000, 5000 Ptas. en orden inverso al que aparecen aquí enumeradas.


12) Codificar un procedimiento que permita borrar un empleado cuyo número se pasará en la llamada.
Nota: El procedimiento anterior devolverá el mensaje 
<< Procedimiento PL/SQL terminado con éxito >> aunque no exista el número y, por tanto, no se borre el empleado. Para evitarlo se puede escribir:

SELECT ROWID INTO v_row FROM emple .....
DELETE ... WHERE ROWID =  v_row;


13)  Escribir un procedimiento que modifique la localidad de un departamento. El procedimiento recibirá como parámetros el número del departamento y la localidad nueva.

Nota: Lo indicado en la nota del ejercicio anterior se puede aplicar también a este.

14) Visualizar todos los procedimientos y funciones del usuario almacenados en la base de datos y su situación (valid o invalid).

Nota: Se necesitará consultar de la tabla del sistema 'USER_OBJECTS' las columnas 'OBJECT_NAME', 'OBJECT_TYPE', 'STATUS', donde el tipo de objeto ('OBJECT_TYPE') puede ser 'PROCEDURE' o 'FUNCTION'
	También se puede utilizar la vista ALL_OBJECTS. 












