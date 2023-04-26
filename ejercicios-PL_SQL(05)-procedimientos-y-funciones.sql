/*FUNCIONES Y PROCEDIMIENTOS*/


1)  Indicar los errores que aparecen en las siguientes instrucciones y la forma de corregirlos.

DECLARE
  Num1 NUMBER(8,2) := 0		/*LE FALTA ;*/				
  Num2 NUMBER(8,2) NOT NULL DEFAULT 0;    
  Num3 NUMBER(8,2) NOT NULL; /*tienes que inicializar de las variables*/
  Cantidad INTEGER(3);				
  Precio, Descuento NUMBER(6);
  Num4 Num1%ROWTYPE;/*%TYPE ya que hace referencia a un único dato, no a una tabla o cursor*/
  Dto CONSTANT INTEGER;	/*tienes que inicializarlo*/	
BEGIN
  ... /*tienes que hacer algo sino se produce un error*/
END;


DECLARE
  Num1 NUMBER(8,2) := 0;					
  Num2 NUMBER(8,2) NOT NULL DEFAULT 0;    
  Num3 NUMBER(8,2) NOT NULL := 1;
  Cantidad INT(3);				
  Precio NUMBER(6);
  Descuento NUMBER(6);
  Num4 Num1%TYPE;
  Dto CONSTANT INT := 3;		
BEGIN
  Num1 := 3;
  Num2 := 4;
  Num3 := Num1 + Num2;
  DBMS_OUTPUT.PUT_LINE(Num3);
END;


/*2) Escribir un procedimiento que reciba dos números y visualice su suma.*/
CREATE OR REPLACE PROCEDURE suma_num(num OUT NUMBER, num1 NUMBER, num2 NUMBER)
IS                                  /*OUT para almacenar un valor*/
BEGIN
	num := num1+num2; 
END;

/*prueba del procedimiento*/
DECLARE 
    num NUMBER:= 0;
	
BEGIN
  suma_num(num,5,5);
	DBMS_OUTPUT.PUT_LINE(num);
END;

/*3) Codificar un procedimiento que reciba una cadena y la visualice al revés.*/

CREATE OR REPLACE PROCEDURE reverse_cadena(cadena VARCHAR2) IS
    salida VARCHAR2(20);
BEGIN
    FOR I IN REVERSE 1..LENGTH(cadena) LOOP
    	salida := salida || SUBSTR(cadena,i,1);/*el 1 representa la cantidad de caracteres que se coge*/
    END LOOP;
	DBMS_OUTPUT.PUT_LINE(salida);
END;



DECLARE 
BEGIN
    reverse_cadena('felipe');
END;



/*4) Escribir una función que reciba una fecha y devuelva el año, en número, correspondiente a esa fecha.*/

CREATE OR REPLACE PROCEDURE devuelve_anio_fecha(fecha DATE) IS
    anio NUMBER := 0;
BEGIN
    anio := EXTRACT(YEAR FROM fecha);/*funcion extract(YEAR,MONTH Y DAY PARA EXTRAER UNA PARTE DE LA FECHA)*/
    DBMS_OUTPUT.PUT_LINE(anio);
END;

/*OTRA FORMA CON TO_CHAR*/

CREATE OR REPLACE PROCEDURE devuelve_anio_fecha(fecha DATE) IS
    anio NUMBER := 0;
BEGIN
    anio := TO_NUMBER(SUBSTR(TO_CHAR(fecha, 'YYYY-MM-DD'), 1, 4));
    /*TO_CHAR() -> convierte a cadena de caracteres la fecha, entonces de esa cadena se extrae una parte
    y el TO_NUMBER convierte a numero
    TO_NUMBER(), TO_DATE()...*/
    DBMS_OUTPUT.PUT_LINE(anio);
END;

DECLARE
BEGIN
    devuelve_anio_fecha(DATE '2023-04-26');
END;


/*HECHO CON FUNCTION COMO PIDE: */

CREATE OR REPLACE FUNCTION retorna_anio(fecha DATE) 
RETURN NUMBER IS
    anio NUMBER;
BEGIN
    anio := EXTRACT(YEAR FROM fecha);
	RETURN anio;
END;



/*5) Escribir un bloque PL/SQL que haga uso de la función anterior.*/
DECLARE
    anio NUMBER;
BEGIN
  anio := retorna_anio(DATE '2023-04-26');
	DBMS_OUTPUT.PUT_LINE(anio);
END;


/*6) Dado el siguiente procedimiento:*/


CREATE OR REPLACE PROCEDURE crear_depart (
  v_num_dept depart.dept_no%TYPE, 
  v_dnombre depart.dnombre%TYPE DEFAULT 'PROVISIONAL',
  v_loc  depart.loc%TYPE DEFAULT 'PROVISIONAL')
IS
BEGIN
  INSERT INTO depart
  VALUES (v_num_dept, v_dnombre, v_loc);
END crear_depart;


/*Indicar cuáles de las siguientes llamadas son correctas y cuáles incorrectas, 
en este último caso escribir la llamada correcta usando la notación posicional 
(en los casos que se pueda):*/

crear_depart;						-- 1º /*NO FUNCIONA YA QUE NO SE LE PASA NINGUN PARÁMETRO*/
crear_depart(50);					-- 2º	/*FUNCIONA YA QUE SE LE PASA EL PARÁMETRO QUE NO TIENE NADA POR DEFECTO*/
crear_depart('COMPRAS');				-- 3º /*TENDRÍA QUE PASARSELE UN NÚMERO SOLAMENTE O ADEMÁS DE LA CADENA PASARLE UN NÚMERO*/
crear_depart(50,'COMPRAS');			-- 4º /*FUNCIONA*/
crear_depart('COMPRAS', 50);			-- 5º /*NO FUNCIONA POR EL ORDEN -> PRIMERO EL NÚMERO*/
crear_depart('COMPRAS', 'VALENCIA');		-- 6º /*NO FUNCIONA PQ FALTA UN NÚMERO*/
crear_depart(50, 'COMPRAS', 'VALENCIA');	-- 7º /*FUNCIONA*/
crear_depart('COMPRAS', 50, 'VALENCIA');	-- 8º /*NO FUNCIONA POR EL ORDEN -> PRIMERO EL NÚMERO*/
crear_depart('VALENCIA', COMPRAS);		-- 9º /* COMPRAS ENTRE COMILLAS SIMPLES Y EL NÚMERO FALTA*/
crear_depart('VALENCIA', 50);  			-- 10º /*NO FUNCIONA POR EL ORDEN -> EL NÚMERO SIEMPRE PRIMERO*/


/*7) Desarrollar una función que devuelva el número de años completos que hay entre dos fechas que se pasan como argumentos.*/

CREATE OR REPLACE FUNCTION anios_entre_fechas(fecha1 DATE, fecha2 DATE) 
RETURN NUMBER IS
BEGIN
    RETURN EXTRACT(YEAR FROM fecha1) - EXTRACT(YEAR FROM fecha2);
END;


/*USO FUNCIÓN: */
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE(anios_entre_fechas(DATE'1998-12-3',DATE'1865-4-5'));
END;

/*OTRA FORMA DE DECLARAR VARIABLES DATE LLAMANDO A LA FUNCION*/
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE(anios_entre_fechas(TO_DATE('03/02/1998', 'DD/MM/YYYY'),TO_DATE('03/02/1960', 'DD/MM/YYYY')));
END;

/*8) Escribir una función que, haciendo uso de la función anterior devuelva los trienios que hay entre dos fechas. (Un trienio son tres años completos).*/

CREATE OR REPLACE FUNCTION trienios_anio(fecha1 DATE, fecha2 DATE)
RETURN NUMBER
IS
trienios NUMBER;
BEGIN
  trienios := anios_entre_fechas(fecha1,fecha2);
	RETURN trienios/3; /*function*/
END;

/*USO*/

DECLARE 
    trienios NUMBER;
BEGIN
   	trienios:=trienios_anio(DATE'1998-12-3',DATE'1950-12-3'); /*en las fechas el año va al principio*/
	DBMS_OUTPUT.PUT_LINE(trienios);
END;

/*con char convirtiendolo a date:*/

DECLARE 
    trienios NUMBER;
BEGIN
   	trienios := trienios_anio(TO_DATE('03/10/2015', 'DD/MM/YYYY'), TO_DATE('1997-10-09', 'YYYY-MM-DD'));
  DBMS_OUTPUT.PUT_LINE(trienios);
END;



/*9) Codificar un procedimiento que reciba una lista de hasta 5 números y visualice su suma.*/


CREATE OR REPLACE PROCEDURE suma(num1 NUMBER, num2 NUMBER, num3 NUMBER, num4 NUMBER, num5 NUMBER)
IS
    suma NUMBER;
BEGIN
    suma := num1 + num2 + num3 + num4 + num5;
	DBMS_OUTPUT.PUT_LINE(suma);
END;

/*USO*/
DECLARE
BEGIN
    suma(2,3,4,5,6);
END;

/*10) Escribir una función que devuelva solamente caracteres alfabéticos sustituyendo cualquier otro carácter por blancos a partir de una cadena que se pasará en la llamada.*/

CREATE OR REPLACE FUNCTION sustituye(cadena VARCHAR2)
RETURN VARCHAR2 IS
	nueva_cadena VARCHAR2(50); /*tienes PONERLE UN TAMAÑO A ESTA VARIABLE*/
BEGIN
    FOR I IN 1..LENGTH(cadena) LOOP
    	IF ASCII(SUBSTR(cadena,i,1))>96 AND ASCII(SUBSTR(cadena,i,1))<123 OR ASCII(SUBSTR(cadena,i,1))>64 AND ASCII(SUBSTR(cadena,i,1))<91 THEN
    		nueva_cadena := nueva_cadena || SUBSTR(cadena,i,1);
		ELSE 
            nueva_cadena := nueva_cadena || ' ';
    	END IF;
    END LOOP;
	RETURN nueva_cadena;
END;

/*USO:*/

DECLARE 
    cadena VARCHAR2(50);/*TIENES QUE PONERLE UN TAMAÑO A ESTA VARIABLE*/
BEGIN
    cadena := sustituye('P5a7co');
	DBMS_OUTPUT.PUT_LINE(cadena);
END;


/*11) Implementar un procedimiento que reciba un importe y visualice el desglose del cambio en unidades monetarias de 1, 5, 10, 25, 50, 100, 200, 500, 1000, 2000, 5000 Ptas. en orden inverso al que aparecen aquí enumeradas.*/

CREATE OR REPLACE PROCEDURE importe_desglose(num1 NUMBER, num2 NUMBER, num3 NUMBER, num4 NUMBER, num5 NUMBER)IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(num5 || num4 || num3 || num2 || num1 );
END;

/*12) Codificar un procedimiento que permita borrar un empleado cuyo número se pasará en la llamada.
Nota: El procedimiento anterior devolverá el mensaje 
<< Procedimiento PL/SQL terminado con éxito >> aunque no exista el número y, por tanto, no se borre el empleado. Para evitarlo se puede escribir:*/

SELECT ROWID INTO v_row FROM emple .....
DELETE ... WHERE ROWID =  v_row;


/*13)  Escribir un procedimiento que modifique la localidad de un departamento. El procedimiento recibirá como parámetros el número del departamento y la localidad nueva.

Nota: Lo indicado en la nota del ejercicio anterior se puede aplicar también a este.*/

/*14) Visualizar todos los procedimientos y funciones del usuario almacenados en la base de datos y su situación (valid o invalid).

Nota: Se necesitará consultar de la tabla del sistema 'USER_OBJECTS' las columnas 'OBJECT_NAME', 'OBJECT_TYPE', 'STATUS', donde el tipo de objeto ('OBJECT_TYPE') puede ser 'PROCEDURE' o 'FUNCTION'
	También se puede utilizar la vista ALL_OBJECTS. */






/*PREGUNTARLE A MIGUEL ANGEL PORQUE EN EL EJERCICIO 10 HAY QUE 
PONERLE UN TAMAÑO A LA VARIABLE*/





