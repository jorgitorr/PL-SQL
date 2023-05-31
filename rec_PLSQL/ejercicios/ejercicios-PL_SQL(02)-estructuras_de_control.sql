
/*ESTRUCTURAS DE CONTROL DE PL/SQL
-Funciones (no de grupo) de SQL en PL/SQL
-IF
-CASE
-LOOP
-WHILE
-FOR
*/
========================
nota:puesto que aún no hemos visto manejo de excepciones, el dorsal de
     ciclista debe existir en la tabla ciclista

/*1.- Escribir un bloque PL/SQL que 
    -Muestre el mensaje: "Predicción de puestos"
    -Pida el número de dorsal de un ciclista,
    -Muestre un mensaje por pantalla con su nombre en mayúsculas (sin el apellido)
    seguido de la frase "de " y a continuación el nombre de su equipo en minúsculas
    excepto su primera letra, que debe estar en mayúsculas, seguido de la cadena "acabará en
    la posición" y a continuación un número aleatorio entre 10 y el 50 (por ejemplo, para el 
    dorsal 1,el mensaje debería decir: "MIGUEL de Banesto acabará en la posición 27")*/

CREATE OR REPLACE PROCEDURE nombre_ciclista(dorsal_ciclista CICLISTA.DORSAL%type)
IS
    v_nombre CICLISTA.NOMBRE%TYPE;
    v_nomeq CICLISTA.NOMEQ%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Prediccion de presupuesto');
    SELECT c.nombre, c.nomeq INTO v_nombre, v_nomeq
    FROM ciclista c WHERE c.dorsal = dorsal_ciclista;

    DBMS_OUTPUT.PUT_LINE(SUBSTR(UPPER(v_nombre),0,INSTR(v_nombre,' ')) || ' de ' || 
    SUBSTR(UPPER(v_nomeq),1) || 
    ' acabará en la posicion ' || TRUNC(dbms_random.value(1,10)));
END;



/*2.- Escribir un bloque PL/SQL que pida un dorsal y nos muestre el Apellido del ciclista,
    con la primera letra en minúscula seguido de su calificación como 'junior' (edad <20), 
    'senior' (edad entre 20 y 30) o 'veterano' (mayor que 30), empleando la estructura de 
    control IF*/




/*3.- Repita el ejercicio anterior pero empleando la estructura de control CASE (nota: emplee
una sola sentencia de asignación).*/

/*4.-Escribir un bloque PL/SQL que muestre el año de nacimiento del ganador de cada etapa 
(nota, tendremos en cuenta el dato de que el número de la última estapa es conocido por el 
programador, digamos que es 5).Emplee un bucle LOOP*/

/*5.-Dado un número de etapa introducido por el usuario que tiene puertos de montaña (en 
principio, no sabemos cuantos), escribir un bloque PL/SQL que incremente la altura de dichos 
puertos en un 10%. Emplee un bucle WHILE*/

/*6.-Escribir un bloque PL/SQL que muestre las ciudades de salida de las etapas impares en 
orden inverso, o sea, de la última a la primera, asumiendo que se conoce el número de la 
última y que la primera es la 1. Emplear un bucle FOR*/






