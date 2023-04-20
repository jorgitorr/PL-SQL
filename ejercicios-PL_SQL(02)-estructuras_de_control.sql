
/*ESTRUCTURAS DE CONTROL DE PL/SQL
-Funciones (no de grupo) de SQL en PL/SQL
-IF
-CASE
-LOOP
-WHILE
-FOR
*/
/*========================
nota:puesto que aún no hemos visto manejo de excepciones, el dorsal de
     ciclista debe existir en la tabla ciclista*/

/*1.- Escribir un bloque PL/SQL que 
    -Muestre el mensaje: "Predicción de puestos"
    -Pida el número de dorsal de un ciclista,
    -Muestre un mensaje por pantalla con su nombre en mayúsculas (sin el apellido)
    seguido de la frase "de " y a continuación el nombre de su equipo en minúsculas
    excepto su primera letra, que debe estar en mayúsculas, seguido de la cadena "acabará en
    la posición" y a continuación un número aleatorio entre 10 y el 50 (por ejemplo, para el dorsal 1,
    el mensaje debería decir: "MIGUEL de Banesto acabará en la posición 27")
*/

DECLARE
    numero_dorsal INT := 10;
	nombre_ciclista ciclista.nombre%type;
		 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Predicción de puestos');
    SELECT c.nombre INTO nombre_ciclista
    FROM ciclista c
    WHERE c.dorsal = numero_dorsal; 
    DBMS_OUTPUT.PUT_LINE(UPPER(SUBSTR(nombre_ciclista,0,INSTR(nombre_ciclista,' '))));
END;

/*instr es como indexOf*/

/*2.- Escribir un bloque PL/SQL que pida un dorsal y nos muestre su el Apellido del ciclista,
    con la primera letra en minúscula seguido de su calificación como 'junior' (edad <20), 
    'senior' (edad entre 20 y 30) o 'veterano' (mayor que 30), empleando la estructura de control IF
*/

DECLARE
	calificacion VARCHAR2(50);
    numero_dorsal INT:= 20;
	apellido_ciclista ciclista.nombre%type; 
	edad_ciclista ciclista.edad%type;
BEGIN
    SELECT c.nombre, c.edad INTO apellido_ciclista, edad_ciclista
    FROM ciclista c
    WHERE c.dorsal = numero_dorsal;
	
	IF edad_ciclista<20 THEN
        calificacion := 'junior';
	ELSIF edad_ciclista>20 AND edad_ciclista<30 THEN 
        calificacion := 'senior';
	ELSE 
        calificacion := 'veterano';
	END IF;

	DBMS_OUTPUT.PUT_LINE(SUBSTR(apellido_ciclista,INSTR(apellido_ciclista,' '),LENGTH(apellido_ciclista)) || ' edad: ' ||edad_ciclista || ' calificacion: ' || calificacion);
END;




/*3.- Repita el ejercicio anterior pero empleando la estructura de control CASE (nota: emplee una sola
    sentencia de asignación).*/

DECLARE
	calificacion VARCHAR2(50);
    numero_dorsal INT:= 20;
	apellido_ciclista ciclista.nombre%type; 
	edad_ciclista ciclista.edad%type;
BEGIN
    SELECT c.nombre, c.edad INTO apellido_ciclista, edad_ciclista
    FROM ciclista c
    WHERE c.dorsal = numero_dorsal;
	
	calificacion := CASE 
        WHEN edad_ciclista<20 THEN 'junior'
    	WHEN edad_ciclista>20 AND edad_ciclista<30 THEN 'senior'
    	WHEN edad_ciclista>30 THEN 'veterano'
	END;

	DBMS_OUTPUT.PUT_LINE(SUBSTR(apellido_ciclista,INSTR(apellido_ciclista,' '),LENGTH(apellido_ciclista)) || ' edad: ' ||edad_ciclista || ' calificacion: ' || calificacion);
END; 

/*LA SENTENCIA CASE DEVUELVE UN VALOR, POR ESO AL LADO DEL CASE SIEMPRE DEBES PONER UNA VARIABLE QUE ES 
A LA QUE SE LE VA A DAR UN VALOR*/

/*Otra forma de hacer el CASE ->

calificacion:= CASE edad_ciclista
        WHEN 27 THEN 'junior'
    	WHEN 30 THEN 'senior'
    	WHEN 50 THEN 'veterano'
	END;
*/
    

/*4.-Escribir un bloque PL/SQL que muestre el año de nacimiento del ganador de cada etapa (nota, tendremos
   en cuenta el dato de que el número de la última estapa es conocido por el programador, digamos que es 5).
   Emplee un bucle LOOP*/

/*así va de etapa en etapa, si no no va porque devuelve más de 
un valor ya que hay varias etapas, pero cada etapa tiene un ganador.
EN EL SELECT INTO SOLO SE PUEDE DEVOLVER UN VALOR 
CON LOOP TIENE QUE DEVOLVER UN SOLO VALOR CADA VEZ
POR ESO VAMOS PASANDO DE ETAPA EN ETAPA*/
DECLARE
    fecha_actual INT:=2023;
    edad_ciclista ciclista.edad%type;
    ultima_etapa CONSTANT INT := 5;
	cont INT:=1;
BEGIN
    LOOP 
        DBMS_OUTPUT.PUT_LINE(fecha_actual-edad_ciclista);
        SELECT c.edad INTO edad_ciclista
    	FROM ciclista c, etapa e 
    	WHERE c.dorsal = e.dorsal AND e.netapa=cont;
    	EXIT WHEN cont=ultima_etapa;
		cont:=cont+1;
    END LOOP;
END;



/*5.-Dado un número de etapa introducido por el usuario que tiene puertos de montaña (en principio, no sabemos
   cuantos), escribir un bloque PL/SQL que incremente la altura de dichos puertos en un 10%. Emplee un bucle WHILE*/

DECLARE
    etapa INT:=1;
	incremento INT:=10;
    altura_puerto puerto.altura%type;
    cont INT:= 1;
BEGIN
    WHILE cont<2 LOOP
    	SELECT p.altura INTO altura_puerto
    	FROM etapa e, puerto p 
    	WHERE e.netapa = p.netapa AND p.netapa=etapa;
        cont:=cont+1;
		DBMS_OUTPUT.PUT_LINE(altura_puerto + (incremento*altura_puerto)/100);
	END LOOP;
END;

/*si quiero actualizar la altura realmente (no puede usar la altura del puerto netapa:4, ya que ese puerto tiene
varias filas en puerto, por tanto sería más de un valor, si quisiera modificar algo de eso tendría que especificar
cual de esas filas)*/
DECLARE
    etapa INT:=2;
	incremento INT:=10;
    altura_puerto puerto.altura%type;
	nueva_altura puerto.altura%type;
    cont INT:= 1;
BEGIN
    WHILE cont<2 LOOP
    	SELECT p.altura INTO altura_puerto
    	FROM etapa e, puerto p 
    	WHERE e.netapa = p.netapa AND p.netapa=etapa;
        cont:=cont+1;
		nueva_altura := altura_puerto + (incremento*altura_puerto)/100;
		DBMS_OUTPUT.PUT_LINE('altura antigua del puerto: ' || altura_puerto);
		DBMS_OUTPUT.PUT_LINE('nueva altura del puerto: ' || nueva_altura);
		UPDATE puerto 
    	SET altura = nueva_altura
    	WHERE netapa = cont;
	END LOOP;
END;



/*6.-Escribir un bloque PL/SQL que muestre las ciudades de salida de las etapas impares en orden inverso, o sea, de la  
   última a la primera, asumiendo que se conoce el número de la última y que la primera es la 1. Emplear un bucle FOR*/

DECLARE
    ciudades_salida etapa.salida%type;
BEGIN
    FOR i IN REVERSE 1..5 LOOP
        	SELECT e.salida INTO ciudades_salida
        	FROM etapa e
        	WHERE e.netapa = i;
		IF MOD(i,2)!=0 THEN
			DBMS_OUTPUT.PUT_LINE(ciudades_salida);
		END IF;
    END LOOP;
END;

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





