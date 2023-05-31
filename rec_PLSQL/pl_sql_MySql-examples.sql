--1º)

DELIMITER //

DROP FUNCTION IF EXISTS hello //
CREATE FUNCTION hello ()
RETURNS VARCHAR(20)

BEGIN

   RETURN 'Hello, world';

END; //

DELIMITER ;

-------------------

SELECT hello ();




--2º)

DELIMITER //

DROP FUNCTION IF EXISTS DiasDeVida //
CREATE FUNCTION DiasDeVida ( anios INT )
RETURNS INT

BEGIN

   DECLARE dias INT;

   SET dias = anios*365;
 

   RETURN dias;

END; //

DELIMITER ;

---------------------------------

SELECT DiasDeVida (20);


--3º) 

DELIMITER //

DROP PROCEDURE IF EXISTS DiasDeVidaProc //



CREATE procedure DiasDeVidaProc ( IN anios INT, OUT dias INT )

BEGIN

   SET dias=anios*365;

END; //

DELIMITER ;


-----------

CALL DiasDeVidaProc (20,@numeroDias);

SELECT @numeroDias;



--4º) IF

DELIMITER //

DROP FUNCTION IF EXISTS PosNegCero //
CREATE FUNCTION PosNegCero ( numero INT )
RETURNS Varchar(20)

BEGIN

   IF numero = 0 
   THEN
	RETURN 'El número es cero';
   ELSEIF numero < 0
   THEN
	RETURN 'El número es negativo';
   ELSE RETURN 'eL Número es positivo';
   END IF;

END; //

DELIMITER ;

--------

SELECT PosNegCero (20);

--5º) CASE

DELIMITER //

DROP FUNCTION IF EXISTS precioConIva //
CREATE FUNCTION precioConIva ( precio INT, tipoIva FLOAT)
RETURNS FLOAT

BEGIN

   DECLARE precioIva FLOAT;

   SET precioIva:= CASE tipoIva WHEN 1 THEN precio*0.04 WHEN 2 THEN precio*0.12 ELSE precio*0.21 END;

   RETURN precio+precioIva;


END; //

DELIMITER ;

--------

SELECT precioConIva (20,2);

--6º) LOOP END LOOP

DELIMITER //

DROP PROCEDURE IF EXISTS cuenta //

CREATE PROCEDURE cuenta ( cuentaFinal INT)
   BEGIN
      DECLARE contador INT Default 0 ;
      simple_loop: LOOP
         		SET contador=contador+1;
         		select contador;
         		IF contador=cuentaFinal 
			THEN
	            		LEAVE simple_loop;
		        END IF;
   			END LOOP simple_loop;
END //


DELIMITER ;

--------

CALL CUENTA (10);



--7º) Cursor


DELIMITER //

DROP PROCEDURE IF EXISTS `micursor`//

CREATE PROCEDURE `micursor`()
BEGIN
	DECLARE done BOOLEAN DEFAULT FALSE;
	DECLARE uid integer;
	DECLARE newdate integer;
	DECLARE c1 cursor for SELECT id,timestamp from employers ORDER BY id ASC;
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
      --DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	open c1;
	c1_loop: LOOP
		fetch c1 into uid,newdate;
        	IF `done` THEN LEAVE c1_loop; END IF; 
        	UPDATE calendar SET timestamp = newdate  WHERE id=uid;
	END LOOP c1_loop;
	CLOSE c1;
END //

DELIMITER ;

------

CALL micursor ();


-----------------------------Triggers-------------------------------

--8º)

--Creamos 4 tablas:
--                 *'tabla1' será la tabla soble la que realizaremos operaciones dml (insert)
--                   En esta tabla se insertarán algunos números del uno al diez (algunos repetidos)
--                 *El resto de las tablas son manipuladas por los triggers for each row:
--                   -'test2': será actualizada con una copia de cada tupla de 'test1'
--                   -'test3' (después de ser inicializada con todos los números del uno al diez):
--                     se elminarán los números que se inserten en la tabla 'test1'
--                   -'test4' (después de ser inicializa con 'ceros'): frecuencia con la que aparece cada número en la tabla 'test1' 


CREATE TABLE test1(a1 INT);
CREATE TABLE test2(a2 INT);
CREATE TABLE test3(a3 INT NOT NULL AUTO_INCREMENT PRIMARY KEY);
CREATE TABLE test4(a4 INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                   b4 INT DEFAULT 0
);


--Creamos un trigger sobre la tabla 'test1'

DELIMITER //

CREATE TRIGGER testref
BEFORE INSERT 
ON test1
FOR EACH ROW BEGIN
    INSERT INTO test2 SET a2 = NEW.a1;        		--Hace una copia de la tupla (que consiste solo en un atributo) en 'test2'
    DELETE FROM test3 WHERE a3 = NEW.a1;     		--Elmina la tupla con el mismo valor de la tabla 'test3'
    UPDATE test4 SET b4 = b4 + 1 WHERE a4 = NEW.a1;	--Actualiza la tupla con ese mismo valor de la tabla 'test4'
  END
//

DELIMITER ;



--Inicializamos las tablas 'test3' y 'test4'

--'test3': al ser a3 un atributo AUTOINCRMENT al insertar valores nulos, se crean tuplas con los valores del campo de autoincremento
INSERT INTO test3 (a3) VALUES  
  (NULL), (NULL), (NULL), (NULL), (NULL), 
  (NULL), (NULL), (NULL), (NULL), (NULL);

--'test4' se inicializa con ceros
INSERT INTO test4 (a4) VALUES 
  (0), (0), (0), (0), (0), (0), (0), (0), (0), (0);

--Realizamos la operación insert sobre la tabla 'test1'. Como consecuencia, se disparará el trigger
INSERT INTO test1 VALUES (1), (3), (1), (7), (1), (8), (4), (4);

--Después de insertar estos valores en la tabla 'test1', el contenido de cada una de las tablas será:

/*
mysql> SELECT * FROM test1;
+------+
| a1   |
+------+
|    1 |
|    3 |
|    1 |
|    7 |
|    1 |
|    8 |
|    4 |
|    4 |
+------+
8 rows in set (0.00 sec)

mysql> SELECT * FROM test2;
+------+
| a2   |
+------+
|    1 |
|    3 |
|    1 |
|    7 |
|    1 |
|    8 |
|    4 |
|    4 |
+------+
8 rows in set (0.00 sec)

mysql> SELECT * FROM test3;
+----+
| a3 |
+----+
|  2 |
|  5 |
|  6 |
|  9 |
| 10 |
+----+
5 rows in set (0.00 sec)

mysql> SELECT * FROM test4;
+----+------+
| a4 | b4   |
+----+------+
|  1 |    3 |
|  2 |    0 |
|  3 |    1 |
|  4 |    2 |
|  5 |    0 |
|  6 |    0 |
|  7 |    1 |
|  8 |    1 |
|  9 |    0 |
| 10 |    0 |
+----+------+
10 rows in set (0.00 sec)

*/

--9º) Ejemplo de Trigger AFTER en la sentencia UPDATE
/*Supongamos que tenemos una Tienda de accesorios para Gamers. Para la actividad de nuestro negocio hemos creado un sistema de facturación muy sencillo, que registra las ventas realizadas dentro de una factura que contiene el detalle de las compras.

Nuestra tienda tiene 4 vendedores de turno, los cuales se encargan de registrar las compras de los clientes en el horario de funcionamiento.

Implementaremos un Trigger que guarde los cambios realizados sobre la tabla DETALLE_FACTURA de la base de datos realizados por los vendedores.

Con este registro de logs podremos saber si algún vendedor “ocioso” esta alterando las facturas, lo que lógicamente sería atentar contra las finanzas de nuestro negocio. Cada registro nos informa el usuario que modificó la tabla DETALLE_FACTURA y muestra una descripción sobre los cambios en cada columna.
*/



DELIMITER // 

CREATE TRIGGER detalle_factura_AU_Trigger 
AFTER UPDATE 
ON detalle_factura 
FOR EACH ROW 

BEGIN 

INSERT INTO log_updates (idusuario, descripcion) 
VALUES (user( ),
        CONCAT('Se modificó el registro ','(',
               OLD.iddetalle,',',
               OLD.idfactura,',',
               OLD.idproducto,',',
               OLD.precio,',', 
               OLD.unidades,
               ') por ','(',
               NEW.iddetalle,',',
               NEW.idfactura,',',
               NEW.idproducto,',',
               NEW.precio,',', 
               NEW.unidades,')'
              )
       );

END// 


DELIMITER ;



--10º) Ejemplo de Trigger BEFORE en al sentencia INSERT, UPDATE, DELETE

/*
El siguiente ejemplo muestra como mantener la integridad de una base de datos con respecto a una atributo derivado.

Supón que tienes una Tienda de electrodomésticos y que has implementado un sistema de facturación. En la base de datos que soporta la información de tu negocio, existen varias tablas, pero nos vamos a centrar en la tabla PEDIDO y la tabla TOTAL_VENTAS.

TOTAL_VENTAS almacena las ventas totales que se le han hecho a cada cliente del negocio. Es decir, si el cliente Armado Barreras en una ocasión compró 1000 dolares, luego compró 1250 dolares y hace poco ha vuelto a comprar 2000 dolares, entonces el total vendido a este cliente es de 4250 dolares.

Pero supongamos que eliminamos el ultimo pedido hecho por este cliente, ¿que pasaría con el registro en TOTAL_VENTAS ?,…¡exacto!, quedaría desactualizado.

Usaremos tres Triggers para solucionar esta situación. Para que cada vez que usemos un comando DML en la tabla PEDIDO, no tengamos que preocuparnos por actualizar manualmente TOTAL_VENTAS.
*/

-- TRIGGER PARA INSERT 

DELIMITER // 

CREATE TRIGGER PEDIDO_BI_TRIGGER 
BEFORE INSERT 
ON PEDIDO 
FOR EACH ROW 

BEGIN 

	DECLARE cantidad_filas INT; 

	SELECT COUNT(*) 
	INTO cantidad_filas 
	FROM TOTAL_VENTAS 
	WHERE idcliente=NEW.idcliente; 

	IF cantidad_filas > 0 THEN 
				UPDATE TOTAL_VENTAS 
				SET total=total+NEW.total 
				WHERE idcliente=NEW.idcliente; 
	ELSE 
		INSERT INTO TOTAL_VENTAS (idcliente,total) 
		VALUES(NEW.idcliente,NEW.total); 
	END IF; 
END// 


-- TRIGGER PARA UPDATE 
CREATE TRIGGER PEDIDO_BU_TRIGGER 
BEFORE UPDATE
ON PEDIDO 
FOR EACH ROW 

BEGIN 
	UPDATE TOTAL_VENTAS 	
	SET total=total+(NEW.total-OLD.total) 
	WHERE idcliente=NEW.idcliente; 
END// 


-- TRIGGER PARA DELETE 
CREATE TRIGGER PEDIDO_BD_TRIGGER 
BEFORE DELETE
ON PEDIDO 
FOR EACH ROW 
BEGIN 
	UPDATE TOTAL_VENTAS 
	SET total=total-OLD.total 
	WHERE idcliente=OLD.idcliente; 
END// 

DELIMITER ;




