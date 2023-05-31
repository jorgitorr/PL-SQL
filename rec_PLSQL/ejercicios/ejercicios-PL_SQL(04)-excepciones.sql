--Ejercicios sobre manejos de excepciones:


1) Programa parametrizado ('&x') que realiza la operación y/x. Capturar la excepción de dividir por 0 (ZERO_DIVIDE)

Este ejercicio es un ejemplo de tratamiento de una sola excepción del sistema con nombre. 



2) Programa parametrizado ('&nombre_ciclista') que cambie el ganador de la primera etapa. Capturar la excepción de que ese ciclista no exista o de que existan varios ciclistas con ese nombre, informando de ello



3) Redactar un programa parametrizado ('&nombre_puerto', '&altura','&categoria','&pendiente','&numero_etapa', '&nombre_ciclista') que inserte ese puerto. Controlar los posibles casos de error: No exista ese ciclista, que
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
-Como se utilizan variables 'dummy' que hacen de 'chivato' para saber que sentencia del programa ha lanzado la excepción, para tratar cada caso de forma diferente si fuera necesario. 
-Las posibles excepciones que se generan dependen de las restricciones establecidas sobre las tablas.



4) Crear un programa PL/SQL parametrizado ('&dorsal','&nombre','&edad','nomeq') que permita insertar un nuevo 
ciclista garantizando que el dorsal sea un número, el dorsal sea único, que ese equipo exista,
que la edad sea un número y que sea positivo.
Nota: guardar el valor del parámetro '&edad' en una variable "edad NUMBER; edad='&edad';" el compilador tratará 
de hacer una conversión de tipo de cadena a number y si no es posible se producirá un error de conversión.
Nota: se asume que el campo 'dorsal' es clave primaria en 'Ciclista' y 'nomeq' es clave ajena en 'Ciclista' respecto a la tabla 'Equipo'


Este ejercicio es un ejemplo que ilustra el tratamiento de excepciones en un solo bloque, en el que las excepciones son de los tres tipos posibles (excepciones del sistema con nombre, excepciones del sistema sin nombre y excepciones definidas por el programador).




5) Ampliar el ejercicicio anterior de manera que si la edad propuesta es < 18 años el programa asigna una edad de 18 años al ciclista y lo inserta en la tabla ciclistas.
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


Este ejercicio también ilustra como es posible capturar una excepción en un bloque, resolverla y finalizar el bloque sin excepción, lo que permite al bloque mas externo continuar la ejecución normal del programa

































































