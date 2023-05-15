--Ejercicios sobre manejos de excepciones:


/*1) Programa parametrizado ('&x') que realiza la operación y/x. Capturar la excepción de dividir por 0 (ZERO_DIVIDE)

Este ejercicio es un ejemplo de tratamiento de una sola excepción del sistema con nombre. */

CREATE OR REPLACE PROCEDURE division(num NUMBER)IS
	res NUMBER;
BEGIN
	res:=num/0;
EXCEPTION
	WHEN ZERO_DIVIDE THEN 
		DBMS_OUTPUT.PUT_LINE('Division entre cero');
END;


/*2) Programa parametrizado ('&nombre_ciclista') que cambie el ganador de la primera etapa. Capturar la excepción de que ese 
ciclista no exista o de que existan varios ciclistas con ese nombre, informando de ello*/

CREATE OR REPLACE PROCEDURE cambia_ganador(nombre_ciclista ciclista.nombre%type)IS
    v_dorsal ciclista.dorsal%type;
BEGIN
    SELECT dorsal INTO v_dorsal FROM ciclista WHERE nombre = nombre_ciclista;

	IF v_dorsal IS NULL THEN
		RAISE_APPLICATION_ERROR(-2001,'El ciclista ' || nombre_ciclista || ' no existe');
	ELSE 
		UPDATE etapa SET dorsal = v_dorsal WHERE netapa = 1;
    	DBMS_OUTPUT.PUT_LINE('El ganador de la primera etapa ha sido actualizado correctamente.');
	END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró ningún ciclista con ese nombre.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Se encontraron varios ciclistas con ese nombre.');
END;




DECLARE
    nombre CICLISTA.NOMBRE%TYPE := 'Paco';
BEGIN
    cambia_ganador(nombre);
END;


/*3) Redactar un programa parametrizado ('&nombre_puerto', '&altura','&categoria','&pendiente','&numero_etapa', '&nombre_ciclista') 
que inserte ese puerto. Controlar los posibles casos de error: No exista ese ciclista, que
existan varios ciclistas con ese nombre, no exista esa etapa, el nombre del puerto ya exista, la altura y pendiente
del puerto sean números.

Tener en cuenta que:

    CICLISTA.dorsal es clave (y por tanto no puede ser NULL)
	ETAPA.netapa es clave (y por tanto UNIQUE y tampoco puede ser NULL)
	PUERTO.nombre es clave (y por tanto UNIQUE)
	Ningún otro campo de PUERTO tiene restricción UNIQUE
	PUERTO.altura es un valor mayor que 0 (en particular no puede ser -1)
	PUERTO.pendiente es un valor mayor que 0 (en particular no puede ser -1)


Este ejercicio es un ejemplo en el que se ilustra:

-Que se puede lanzar la misma excepción desde diferentes sentencias y son capturadas y manejadas en un solo punto.
-Como se utilizan variables 'dummy' que hacen de 'chivato' para saber que sentencia del programa ha lanzado la excepción, 
para tratar cada caso de forma diferente si fuera necesario. 
-Las posibles excepciones que se generan dependen de las restricciones establecidas sobre las tablas.*/


CREATE OR REPLACE PROCEDURE inserta_puerto(nombre_puerto PUERTO.NOMPUERTO%TYPE, altura PUERTO.altura%TYPE, categoria PUERTO.categoria%TYPE, 
pendiente PUERTO.categoria%TYPE, numero_etapa ETAPA.NETAPA%TYPE, nombre_ciclista CICLISTA.NOMBRE%TYPE) IS
    dorsal_ciclista CICLISTA.DORSAL%TYPE;
    numero_ciclistas NUMBER;
    etapa_netapa ETAPA.NETAPA%TYPE;
    puerto VARCHAR2(50);
    altura_number NUMBER:= TO_NUMBER(altura);
    pendiente_number NUMBER:= TO_NUMBER(pendiente);
BEGIN
	--controla los ciclistas
	BEGIN
    SELECT c.dorsal, COUNT(*) INTO dorsal_ciclista, numero_ciclistas
    FROM ciclista c
    WHERE c.nombre = nombre_ciclista
    GROUP BY c.dorsal;

    IF dorsal_ciclista IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'El ciclista no fue encontrado.');
    ELSIF numero_ciclistas > 1 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Existen varios ciclistas con el mismo nombre.');
    END IF;
  	EXCEPTION
    	WHEN NO_DATA_FOUND THEN
      		RAISE_APPLICATION_ERROR(-20001, 'El ciclista no fue encontrado.');
  	END;

	--controla las etapas
	BEGIN
		SELECT e.netapa INTO etapa_netapa
		FROM ETAPA e
		WHERE e.netapa = numero_etapa;

    IF etapa_netapa IS NULL THEN 
      RAISE_APPLICATION_ERROR(-20003, 'La etapa no existe.');
    END IF;
  	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20003, 'La etapa no existe.');
  	END;

	--controla los puertos
	BEGIN
		SELECT p.nompuerto INTO puerto
		FROM puerto p
		WHERE p.nompuerto = nombre_puerto;

    IF puerto IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20004, 'El puerto ya existe.');
    END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
		-- El puerto no existe, no se lanza una excepción ya que es un escenario válido
		NULL;
	END;
END;


/*prueba*/

DECLARE
BEGIN
    inserta_puerto('Picardia',5,'b',20,50,'Mark Sanz');
END;


/*4) Crear un programa PL/SQL parametrizado ('&dorsal','&nombre','&edad','nomeq') que permita insertar un nuevo 
ciclista garantizando que el dorsal sea un número, el dorsal sea único, que ese equipo exista,
que la edad sea un número y que sea positivo.
Nota: guardar el valor del parámetro '&edad' en una variable "edad NUMBER; edad='&edad';" el compilador tratará 
de hacer una conversión de tipo de cadena a number y si no es posible se producirá un error de conversión.
Nota: se asume que el campo 'dorsal' es clave primaria en 'Ciclista' y 'nomeq' es clave ajena en 'Ciclista' respecto a la tabla 'Equipo'


Este ejercicio es un ejemplo que ilustra el tratamiento de excepciones en un solo bloque, en el que las excepciones son de los 
tres tipos posibles (excepciones del sistema con nombre, excepciones del sistema sin nombre y excepciones definidas por el programador).*/


CREATE OR REPLACE PROCEDURE insertar_ciclista(dorsal_ciclista CICLISTA.DORSAL%TYPE, nombre_ciclista CICLISTA.NOMBRE%TYPE, edad_ciclista CICLISTA.EDAD%TYPE,
    nomeq CICLISTA.NOMEQ%TYPE)IS
dorsal_ciclista NUMBER := TO_NUMBER(dorsal_ciclista);
BEGIN
    
    
    INSERT INTO ciclista VALUES();
END;



/*5) Ampliar el ejercicicio anterior de manera que si la edad propuesta es < 18 años el programa asigna una edad de 18 años al ciclista y lo inserta en la tabla ciclistas.
Sin embargo, si la edad es superior a 50, el programa considera que es un error y no se realiza la inserción de datos.

Definir un bloque interno en el que se comprueba si la edad es menor que 18, si es el caso se lanza una excepción de usuario (MENOR_EDAD) y se captura en el propio bloque y se trata asignando 18 a la variable edad. Desde el bloque interno se lanzan otras excepciones con (EDAD_NO_POSITIVA) y sin (-20003) nombre, que son capturadas en el bloque externo. El bloque externo, además, captura el resto de excepciones


Este ejercicio ilustra el tratamiento de excepciones en un bloque anidado, en el que hay excepciones:

-excepciones de programador definidas en el bloque externo, y que pueden ser lanzadas en el bloque interno,
 aunque no son capturadas en el bloque interno, si no en el externo

-excepciones de programador lanzadas desde el bloque interno y que son capturadas por el bloque externo,
 asignándole un nombre

-excepciones de programador lanzadas desde el bloque interno y capturadas (y resueltas) en el bloque interno,
 por lo que el bloque interno finaliza sin generar una excepción para el bloque externo (la excepción es lanzada
 y resuelta en el bloque interno)


Este ejercicio también ilustra como es posible capturar una excepción en un bloque, resolverla y finalizar el bloque sin excepción, 
lo que permite al bloque mas externo continuar la ejecución normal del programa*/

































































