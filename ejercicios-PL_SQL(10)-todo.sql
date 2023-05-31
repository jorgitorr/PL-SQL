/*Problema 1

Partiendo del siguiente script, crea la BD correspondiente a los alumnos matriculados 
en algunos de los módulos de 1º y 2º curso del CFS y sus correspondientes notas:


REM ******** TABLAS ALUMNOS, ASIGNATURAS, NOTAS: **********/

DROP TABLE ALUMNOS cascade constraints;

CREATE TABLE ALUMNOS
(
  DNI VARCHAR2(10) NOT NULL,
  APENOM VARCHAR2(30),
  DIREC VARCHAR2(30),
  POBLA  VARCHAR2(15),
  TELEF  VARCHAR2(10)  
) 

DROP TABLE ASIGNATURAS cascade constraints;

CREATE TABLE ASIGNATURAS
(
  COD NUMBER(2) NOT NULL,
  NOMBRE VARCHAR2(25)
) 

DROP TABLE NOTAS cascade constraints;

CREATE TABLE NOTAS
(
  DNI VARCHAR2(10) NOT NULL,
  COD NUMBER(2) NOT NULL,
  NOTA NUMBER(2)
) 

INSERT INTO ASIGNATURAS VALUES (1,'Prog. Leng. Estr.');
INSERT INTO ASIGNATURAS VALUES (2,'Sist. Informáticos');
INSERT INTO ASIGNATURAS VALUES (3,'Análisis');
INSERT INTO ASIGNATURAS VALUES (4,'FOL');
INSERT INTO ASIGNATURAS VALUES (5,'RET');
INSERT INTO ASIGNATURAS VALUES (6,'Entornos Gráficos');
INSERT INTO ASIGNATURAS VALUES (7,'Aplic. Entornos 4ªGen');

INSERT INTO ALUMNOS VALUES
('12344345','Alcalde García, Elena', 'C/Las Matas, 24','Madrid','917766545');

INSERT INTO ALUMNOS VALUES
('4448242','Cerrato Vela, Luis', 'C/Mina 28 - 3A', 'Madrid','916566545');

INSERT INTO ALUMNOS VALUES
('56882942','Díaz Fernández, María', 'C/Luis Vives 25', 'Móstoles','915577545');

INSERT INTO NOTAS VALUES('12344345', 1,6);
INSERT INTO NOTAS VALUES('12344345', 2,5);
INSERT INTO NOTAS VALUES('12344345', 3,6);

INSERT INTO NOTAS VALUES('4448242', 4,6);
INSERT INTO NOTAS VALUES('4448242', 5,8);
INSERT INTO NOTAS VALUES('4448242', 6,4);
INSERT INTO NOTAS VALUES('4448242', 7,5);

INSERT INTO NOTAS VALUES('56882942', 4,8);
INSERT INTO NOTAS VALUES('56882942', 5,7);
INSERT INTO NOTAS VALUES('56882942', 6,8);
INSERT INTO NOTAS VALUES('56882942', 7,9);

COMMIT;



/*Diseña un procedimiento al que pasemos como parámetro de entrada el nombre de uno de los 
módulos existentes en la BD y visualice el nombre de los alumnos que lo han cursado junto 
a su nota.
Al final del listado debe aparecer el nº de suspensos, aprobados, notables y sobresalientes.
Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan la nota más 
alta y la más baja.
Debes comprobar previamente que las tablas tengan almacenada información y que exista el 
módulo cuyo nombre pasamos como parámetro al procedimiento.
*/

CREATE OR REPLACE PROCEDURE listado_alumnos(modulo ASIGNATURAS.NOMBRE%TYPE)IS
	CURSOR cursor_nombre IS	
		SELECT a.nombre, al.APENOM, n.nota
		FROM NOTAS n, ALUMNOS al, ASIGNATURAS a 
		WHERE al.DNI = n.DNI AND n.cod = a.cod AND a.nombre = modulo
		ORDER BY al.apenom DESC;
	devuelve_cursor cursor_nombre%ROWTYPE;
	suspensos NUMBER := 0;
	notables NUMBER := 0;
	aprobados NUMBER := 0;
	sobresalientes NUMBER:=0;
	nota_mas_alta NOTAS.NOTA%TYPE;
	nota_mas_baja NOTAS.NOTA%TYPE;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Todos los alumnos con sus modulos y sus notas');
	FOR devuelve_cursor IN cursor_nombre LOOP
		DBMS_OUTPUT.PUT_LINE(devuelve_cursor.nombre ||' ' || devuelve_cursor.APENOM || ' '|| devuelve_cursor.nota);
		IF devuelve_cursor.nota <5 THEN
			suspensos := suspensos +1;
		ELSIF devuelve_cursor.nota <7 THEN 
			aprobados := aprobados +1;
		ELSIF devuelve_cursor.nota <9 THEN 
			notables := notables +1;
		ELSIF devuelve_cursor.nota = 10 THEN
			sobresalientes := sobresalientes +1;
		END IF;

		IF nota_mas_alta < devuelve_cursor.nota THEN 
			nota_mas_alta := devuelve_cursor.nota;
		ELSIF nota_mas_baja > devuelve_cursor.nota THEN 
			nota_mas_baja := devuelve_cursor.nota;
		END IF;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('numero de suspensos '||suspensos);
	DBMS_OUTPUT.PUT_LINE('numero de aprobado '|| aprobados);
	DBMS_OUTPUT.PUT_LINE('numero de notables '|| notables);
	DBMS_OUTPUT.PUT_LINE('numero de sobresalientes '|| sobresalientes);

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('No hay datos en la sentencia');
END;


---------------------------------------------------------------------------------------------------------------------
Problema 2

A partir de las tablas creadas con el siguiente script:*/

DROP TABLE productos CASCADE CONSTRAINTS;

CREATE TABLE productos
(
	CodProducto 	VARCHAR2(10) CONSTRAINT p_cod_no_nulo NOT NULL,
	Nombre    	VARCHAR2(20) CONSTRAINT p_nom_no_nulo NOT NULL,
	LineaProducto	VARCHAR2(10),
	PrecioUnitario	NUMBER(6),
	Stock 		NUMBER(5),
	PRIMARY KEY (CodProducto)
);

DROP TABLE ventas CASCADE CONSTRAINTS;

CREATE TABLE ventas
(
	CodVenta  		VARCHAR2(10) CONSTRAINT cod_no_nula NOT NULL,
	CodProducto 		VARCHAR2(10) CONSTRAINT pro_no_nulo NOT NULL,
	FechaVenta 		DATE,
	UnidadesVendidas	NUMBER(3),
	PRIMARY KEY (CodVenta)
);

INSERT INTO productos VALUES ('1','Procesador P133', 'Proc',15000,20);
INSERT INTO productos VALUES ('2','Placa base VX',   'PB',  18000,15);
INSERT INTO productos VALUES ('3','Simm EDO 16Mb',   'Memo', 7000,30);
INSERT INTO productos VALUES ('4','Disco SCSI 4Gb',  'Disc',38000, 5);
INSERT INTO productos VALUES ('5','Procesador K6-2', 'Proc',18500,10);
INSERT INTO productos VALUES ('6','Disco IDE 2.5Gb', 'Disc',20000,25);
INSERT INTO productos VALUES ('7','Procesador MMX',  'Proc',15000, 5);
INSERT INTO productos VALUES ('8','Placa Base Atlas','PB',  12000, 3);
INSERT INTO productos VALUES ('9','DIMM SDRAM 32Mb', 'Memo',17000,12);
 
INSERT INTO ventas VALUES('V1', '2', '22/09/97',2);
INSERT INTO ventas VALUES('V2', '4', '22/09/97',1);
INSERT INTO ventas VALUES('V3', '6', '23/09/97',3);
INSERT INTO ventas VALUES('V4', '5', '26/09/97',5);
INSERT INTO ventas VALUES('V5', '9', '28/09/97',3);
INSERT INTO ventas VALUES('V6', '4', '28/09/97',1);
INSERT INTO ventas VALUES('V7', '6', '02/10/97',2);
INSERT INTO ventas VALUES('V8', '6', '02/10/97',1);
INSERT INTO ventas VALUES('V9', '2', '04/10/97',4);
INSERT INTO ventas VALUES('V10','9', '04/10/97',4);
INSERT INTO ventas VALUES('V11','6', '05/10/97',2);
INSERT INTO ventas VALUES('V12','7', '07/10/97',1);
INSERT INTO ventas VALUES('V13','4', '10/10/97',3);
INSERT INTO ventas VALUES('V14','4', '16/10/97',2);
INSERT INTO ventas VALUES('V15','3', '18/10/97',3);
INSERT INTO ventas VALUES('V16','4', '18/10/97',5);
INSERT INTO ventas VALUES('V17','6', '22/10/97',2);
INSERT INTO ventas VALUES('V18','6', '02/11/97',2);
INSERT INTO ventas VALUES('V19','2', '04/11/97',3);
INSERT INTO ventas VALUES('V20','9', '04/12/97',3);

/*a) Realiza un procedimiento que actualice la columna Stock de la tabla Productos a partir 
de los registros de la tabla Ventas.

El citado procedimiento debe informarnos por pantalla si alguna de las tablas está vacía 
o si el stock de un producto pasa a ser negativo, en cuyo caso se parará la actualización.*/

/*b) Realiza un procedimiento que presente por pantalla un listado de las ventas con el 
siguiente formato:

Linea Producto: NombreLinea1
	
	Prod11		UnidadesTotales1	ImporteTotal1
 	Prod12		UnidadesTotales2	ImporteTotal2
	…
	Prod1n		UnidadesTotalesn	ImporteTotaln

Importe total NombreLinea1: ImporteLinea1

Linea Producto: NombreLinea2
	
	Prod21		UnidadesTotales1	ImporteTotal1
 	Prod22		UnidadesTotales2	ImporteTotal2
	…
	Prod2n		UnidadesTotalesn	ImporteTotaln

Importe total NombreLinea2: ImporteLinea2
.
.
.
Total Ventas: Importedetodaslaslineas*/

---------------------------------------------------------------------------------------------------------------------

/*Problema 3

Realiza un procedimiento llamado mostrar_usuarios_con rol que recibiendo como parámetro un rol nos devuelva los nombres de los usuarios a los que se ha concedido dicho rol. Realiza otro procedimiento llamado mostrar_privilegios_del_rol que  recibe como parámetro un rol y muestra los privilegios que lo componen.
*/
---------------------------------------------------------------------------------------------------------------------

/*Problema 4

Realizar una función que reciba un código de departamento y devuelva al programa que 
la llamó el nombre del mismo y el número de empleados que tiene.
*/

CREATE OR REPLACE FUNCTION nombre_depart(codigo DEPART.DEPT_NO%TYPE) 
RETURN DEPART.DNOMBRE%type IS
	nombre_depart DEPART.DNOMBRE%TYPE;
BEGIN
	SELECT d.DNOMBRE INTO nombre_depart
	FROM DEPART d
	WHERE d.DEPT_NO = codigo;
	RETURN nombre_depart;
END;

---------------------------------------------------------------------------------------------------------------------

/*Problema 5

Realiza un trigger que cada vez que se inserten o modifiquen los datos de una venta, actualice de forma automática la columna stock de la tabla productos y compruebe si el stock pasa a estar por debajo del umbral de pedido. Si se da este caso, debe insertarse un registro en la tabla Ordenes de Pedido de forma que se pidan las unidades necesarias para restablecer el stock al triple del valor señalado en el umbral de pedido.

Realiza un trigger que en el momento en que una orden de pedido se marque como servida se actualizara el stock del producto corrrespondiente.

(Opcional) El trigger envía un correo electrónico a la dirección del proveedor correspondiente, registrada en la tabla Proveedores.
*/
---------------------------------------------------------------------------------------------------------------------

/*Problema 6

Realizar un trigger que mantenga actualizada la columna CosteSalarial, con la suma de los salarios y comisiones de los empleados de dichos departamentos reflejando cualquier cambio que se produzca en la tabla empleados.
*/
---------------------------------------------------------------------------------------------------------------------

/*Problema 7

Realiza un trigger que incremente en un 5% el salario de un empleado si cambia la localidad del departamento en que trabaja.
*/

CREATE OR REPLACE TRIGGER incrementa_salario 
AFTER UPDATE OF localidad 
ON DEPART 
FOR EACH ROW 
BEGIN
	IF :OLD.localidad != :NEW.localidad THEN
		UPDATE EMPLE E 
		SET e.salario = e.salario*5
		WHERE e.DEPT_NO = :NEW.DEPT_NO;
	END IF;
END; 
---------------------------------------------------------------------------------------------------------------------

/*Problema 8

Realiza un trigger que registre en la base de datos los intentos de modificar, actualizar o borrar datos en las filas de la tabla EMP correspondientes al presidente y a los jefes de departamento, especificando el usuario, la fecha y la operacion intentada.
*/
---------------------------------------------------------------------------------------------------------------------

/*Problema 9

(Opcional) Realizar un trigger que impida que un departamento tenga más de 5 empleados o menos de dos.

*/
