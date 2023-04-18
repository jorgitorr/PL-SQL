
/*INTRODUCCIÓN A PL/SQL

-Buffer de SQL*plus: listar, guardar, cargar, borrar
-Activar paquetes
-Bloques anónimos
-Pedir valores a usuario, mostrar resultado.
-declaración de variables; %type, %rowtype
-uso de funciones (no de grupo) de SQL
-SELECT en script vs SELECT en PL/SQL
-Varios SELECT en un bloque PL/SQL
*/
========================
/*1.-Active el paquete DBMS_OUTPUT*/
/*2.- Escribir un bloque PL/SQL que escriba el texto 'Hola' y ejecutarlo a continuación*/

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola');
END;


/*3.- Introducir el bloque anterior desde SQL*Plus y guardarlo en un fichero.*/

/*4. Mostrar el contenido del buffer. Ejecutarlo a continuación. Volver a borrarlo*/

/*5.- Cargar en el buffer el bloque anteriormente guardado y ejecutarlo  a continuación
    (Comprobar que aparecen el resultado en pantalla).*/

/*6.- Escribir un bloque PL/SQL para calcular el valor de la hipotenusa de un triángulo
    rectángulo, conocidos los valores de los catetos. Para ello, declare dos variables
    'a', 'b' de tipo NUMBER(3,2) inicializadas a 1, y otra 'h' de tipo NUMBER(3,2), 
    pida, precedido de un mensaje de entrada, valores para los catetos, los almacene
    en 'a'y 'b', calcule el resultado en 'h' y lo muestre por pantalla*/
    
    
DECLARE
	a NUMBER := 2;
	b NUMBER := 3;
	h NUMBER;
BEGIN
	h := a*a+b*b;
	DBMS_OUTPUT.PUT_LINE(h);
END;
  

7.- Escribir un bloque PL/SQL que muestre el número de ciclistas. Guardarlo en un fichero

CREATE TABLE ciclista(
    dorsal integer,
    nombre varchar2(50),
    edad integer,
    nomeq varchar2(50),
    PRIMARY KEY(dorsal)
);

insert into ciclista values(1,'Miguel Indurain',21,'Banesto');
insert into ciclista values(2,'Pedro Delgado',29,'Banesto');
insert into ciclista values(3,'Alex Zulle',20,'Navigare');
insert into ciclista values(4,'Alessio Di Basco',30,'TVM');
insert into ciclista values(5,'Armand',17,'Amore Vita');
insert into ciclista values(8,'Jean Van Poppel',24,'Bresciali-Refin');
insert into ciclista values(9,'Maximo Podel',17,'Telecom');
insert into ciclista values(10,'Mario Cipollini',31,'Carrera');
insert into ciclista values(11,'Eddy Seigneur',20,'Amore Vita');
insert into ciclista values(12,'Alessio Di Basco',34,'Bresciali-Refin');
insert into ciclista values(13,'Gianni Bugno',24,'Gatorade');
insert into ciclista values(15,'JesÃºs Montoya',25,'Amore Vita');
insert into ciclista values(16,'Dimitri Konishev',27,'Amore Vita');
insert into ciclista values(17,'Bruno Lealli',30,'Amore Vita');
insert into ciclista values(20,'Alfonso GutiÃ©rrez',27,'Navigare');
insert into ciclista values(22,'Giorgio Furlan',22,'Kelme');
insert into ciclista values(26,'Mikel Zarrabeitia',30,'Carrera');
insert into ciclista values(27,'Laurent Jalabert',22,'Banesto');
insert into ciclista values(30,'Melchor Mauri',26,'Mapei-Clas');
insert into ciclista values(31,'Per Pedersen',33,'Banesto');
insert into ciclista values(32,'Tony Rominger',31,'Kelme');
insert into ciclista values(33,'Stefenao della Sveitia',26,'Amore Vita');
insert into ciclista values(34,'Clauido Chiapucci',23,'Amore Vita');
insert into ciclista values(35,'Gian Mateo Faluca',34,'TVM');



DECLARE
	numero_ciclistas NUMBER; 
BEGIN
	SELECT COUNT(c.dorsal) INTO numero_ciclistas
    FROM ciclista c;
	DBMS_OUTPUT.PUT_LINE('El numero de ciclistas es ' || numero_ciclistas);
END;

/*8.- Ejecutar la orden SELECT especificada en el bloque anterior desde SQL*Plus
    (sin la cláusula INTO).*/
/*9.- Cargar y ejecutar de nuevo el bloque que cuenta los ciclista.
    (Comprobar que aparecen el resultado en pantalla).*/
/*10.- Escribir un bloque PL/SQL que declare variables utilizando '%type' y '%rowtype' y que muestre
     el nombre del ganadador de la vuelta (será el que lleve el maillot amarillo en la última etapa);
     también deberá mostrar todos los datos de su equipo*/
 
     
DECLARE
	nombre_ganador ciclista.nombre%type;
    equipo_ganador ciclista.nomeq%type;
	datos_equipo_ganador equipo%rowtype;
BEGIN
    SELECT c.nombre, c.nomeq INTO nombre_ganador, equipo_ganador
    FROM ciclista c ,llevar l, maillot m
    WHERE c.dorsal=l.dorsal AND l.codigo=m.codigo AND m.color = 'Amarillo' AND l.netapa = 4; 

    DBMS_OUTPUT.PUT_LINE(nombre_ganador || ' ' || equipo_ganador);
END;


/*imprimir tabla del ciclista ganador*/

SELECT equipo INTO datos_equipo_ganador 
FROM equipo e JOIN ciclista c USING(dorsal) 
WHERE c.nombre = nombre_ganador;



/*tablas*/

CREATE TABLE equipo(
    nomeq VARCHAR(50),
    descripcion VARCHAR(50)
);

CREATE TABLE ciclista(
    dorsal INT,
    nombre VARCHAR(50),
    edad INT,
    nomeq VARCHAR(50)
);

CREATE TABLE etapa(
    netapa INT,
    km INT,
    salida VARCHAR(20),
    llegada VARCHAR(20),
    dorsal INT
);

CREATE TABLE puerto(
    nompuerto VARCHAR(50),
    altura INT,
    categoria VARCHAR(1),
    pendiente INT,
    netapa INT,
    dorsal INT
);

CREATE TABLE maillot(
    codigo VARCHAR(5),
    tipo VARCHAR(20),
    color VARCHAR(50),
    premio INT
);

CREATE TABLE llevar(
    dorsal INT,
    netapa INT,
    codigo VARCHAR(5)
);


insert into equipo values('Amore Vita','Ricardo Padacci');
insert into equipo values('Banesto','Miguel EchevarrÃ­a');
insert into equipo values('Bresciali-Refin','Pietro Armani');
insert into equipo values('Carrera','Luigi Petroni');
insert into equipo values('Gatorade','Gian Luca Pacceli');
insert into equipo values('Kelme','Ãlvaro Pino');
insert into equipo values('Mapei-Clas','Juan FernÃ¡ndez');
insert into equipo values('Navigare','Lorenzo Sciacci');
insert into equipo values('Telecom','Morgan Reikacrd');
insert into equipo values('TVM','Steevens Henk');

insert into ciclista values(1,'Miguel Indurain',21,'Banesto');
insert into ciclista values(2,'Pedro Delgado',29,'Banesto');
insert into ciclista values(3,'Alex Zulle',20,'Navigare');
insert into ciclista values(4,'Alessio Di Basco',30,'TVM');
insert into ciclista values(5,'Armand',17,'Amore Vita');
insert into ciclista values(8,'Jean Van Poppel',24,'Bresciali-Refin');
insert into ciclista values(9,'Maximo Podel',17,'Telecom');
insert into ciclista values(10,'Mario Cipollini',31,'Carrera');
insert into ciclista values(11,'Eddy Seigneur',20,'Amore Vita');
insert into ciclista values(12,'Alessio Di Basco',34,'Bresciali-Refin');
insert into ciclista values(13,'Gianni Bugno',24,'Gatorade');
insert into ciclista values(15,'JesÃºs Montoya',25,'Amore Vita');
insert into ciclista values(16,'Dimitri Konishev',27,'Amore Vita');
insert into ciclista values(17,'Bruno Lealli',30,'Amore Vita');
insert into ciclista values(20,'Alfonso GutiÃ©rrez',27,'Navigare');
insert into ciclista values(22,'Giorgio Furlan',22,'Kelme');
insert into ciclista values(26,'Mikel Zarrabeitia',30,'Carrera');
insert into ciclista values(27,'Laurent Jalabert',22,'Banesto');
insert into ciclista values(30,'Melchor Mauri',26,'Mapei-Clas');
insert into ciclista values(31,'Per Pedersen',33,'Banesto');
insert into ciclista values(32,'Tony Rominger',31,'Kelme');
insert into ciclista values(33,'Stefenao della Sveitia',26,'Amore Vita');
insert into ciclista values(34,'Clauido Chiapucci',23,'Amore Vita');
insert into ciclista values(35,'Gian Mateo Faluca',34,'TVM');

insert into etapa values(1,35,'Valladolid','Ãvila',1);
insert into etapa values(2,70,'Salamanca','Zamora',2);
insert into etapa values(3,150,'Zamora','Almendralejo',1);
insert into etapa values(4,330,'CÃ³rdoba','Granada',1);
insert into etapa values(5,150,'Granada','AlmerÃ­a',3);

insert into puerto values('p1',2489,'1',34,2,3);
insert into puerto values('p2',2789,'1',44,4,3);
insert into puerto values('Puerto F',2500,'E',17,4,2);
insert into puerto values('Puerto fff',2500,'E',17,4,2);
insert into puerto values('Puerto nuevo1',2500,'a',17,4,1);
insert into puerto values('Puerto otro',2500,'E',17,4,1);
insert into puerto values('Puerto1',2500,'E',23,1,2);

insert into maillot values('MGE','General','Amarillo',1000000);
insert into maillot values('MMO','MontaÃ±a','Blanco y rojo',500000);
insert into maillot values('MMS','MÃ¡s sufrido','Estrellitas rojas',400000);
insert into maillot values('MMV','Metas volantes','Rojo',400000);
insert into maillot values('MRE','Regularidad','Verde',300000);
insert into maillot values('MSE','Sprint especial','Rosa',300000);

insert into llevar values(1,3,'MGE');
insert into llevar values(1,4,'MGE');
insert into llevar values(2,2,'MGE');
insert into llevar values(3,1,'MGE');
insert into llevar values(3,1,'MMV');
insert into llevar values(3,4,'MRE');
insert into llevar values(4,1,'MMO');




