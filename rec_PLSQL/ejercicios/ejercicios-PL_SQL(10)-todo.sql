Problema 1

Partiendo del siguiente script, crea la BD correspondiente a los alumnos matriculados en algunos de los módulos de 1º y 2º curso del CFS y sus correspondientes notas:


REM ******** TABLAS ALUMNOS, ASIGNATURAS, NOTAS: ***********


CREATE TABLE ALUMNOS
(
  DNI VARCHAR2(10) NOT NULL,
  APENOM VARCHAR2(30),
  DIREC VARCHAR2(30),
  POBLA  VARCHAR2(15),
  TELEF  VARCHAR2(10)  
) 


CREATE TABLE ASIGNATURAS
(
  COD NUMBER(2) NOT NULL,
  NOMBRE VARCHAR2(25)
) 


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



/*Diseña un procedimiento al que pasemos como parámetro de entrada el nombre de uno de los módulos existentes en la BD y visualice el nombre de 
los alumnos que lo han cursado junto a su nota.
Al final del listado debe aparecer el nº de suspensos, aprobados, notables y sobresalientes.
Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan la nota más alta y la más baja.
Debes comprobar previamente que las tablas tengan almacenada información y que exista el módulo cuyo nombre pasamos como parámetro al 
procedimiento.*/

CREATE OR REPLACE PROCEDURE notasModulo(modulo ASIGNATURAS.NOMBRE%TYPE) IS
   v_suspensos NUMBER := 0;
   v_aprobados NUMBER := 0;
   v_notables NUMBER := 0;
   v_sobresalientes NUMBER := 0;

   v_alumno_nota_alta ALUMNOS.APENOM%TYPE;
   v_alumnos_nota_baja ALUMNOS.APENOM%TYPE;
   v_nota_alta NOTAS.NOTA%TYPE;
   v_nota_baja NOTAS.NOTA%TYPE;

   v_num_registros NUMBER := 0;
   noRegistros EXCEPTION;--excepcion declarada
   CURSOR alumnos_notas IS 
      SELECT a.apenom nombre, n.nota nota
      FROM alumnos a, asignaturas asi, notas n
      WHERE a.dni = n.dni AND n.cod = asi.cod AND asi.nombre = modulo; 

   v_cursor alumnos_notas%ROWTYPE;
BEGIN
   SELECT COUNT(*) INTO v_num_registros
   FROM notas n, asignaturas asi
   WHERE n.cod = asi.cod AND asi.nombre = modulo;

   IF v_num_registros = 0 THEN
      RAISE noRegistros;--lanzo excepcion
   END IF;

   FOR v_cursor IN alumnos_notas LOOP
      DBMS_OUTPUT.PUT_LINE(v_cursor.nombre ||' :'||v_cursor.nota);

      IF v_cursor.nota < 5 THEN
         v_suspensos := v_suspensos + 1;
      ELSIF v_cursor.nota >= 5 THEN 
         v_aprobados := v_aprobados + 1;
      ELSIF v_cursor.nota >= 7 AND v_cursor.nota < 9 THEN
         v_notables := v_notables + 1;
      ELSIF v_cursor.nota >= 9 AND v_cursor.nota <= 10 THEN
         v_sobresalientes := v_sobresalientes + 1;
      END IF;

      IF v_nota_alta < v_cursor.nota OR v_nota_alta IS NULL THEN
         v_nota_alta := v_cursor.nota;
         v_alumno_nota_alta := v_cursor.nombre;
      END IF;

      IF v_nota_baja > v_cursor.nota OR v_nota_baja IS NULL THEN 
         v_nota_baja := v_cursor.nota;
         v_alumnos_nota_baja := v_cursor.nombre;
      END IF;
   END LOOP;

   DBMS_OUTPUT.PUT_LINE('suspensos: '|| v_suspensos ||' aprobados: '||v_aprobados||' notables: '||v_notables
      ||' sobresalientes: '|| v_sobresalientes);

EXCEPTION 
   WHEN noRegistros THEN
      DBMS_OUTPUT.PUT_LINE('No hay registros');--captura la excepción
END;

---------------------------------------------------------------------------------------------------------------------
/*Problema 2

A partir de las tablas creadas con el siguiente script:*/


CREATE TABLE productos
(
	CodProducto 	VARCHAR2(10) CONSTRAINT p_cod_no_nulo NOT NULL,
	Nombre    	VARCHAR2(20) CONSTRAINT p_nom_no_nulo NOT NULL,
	LineaProducto	VARCHAR2(10),
	PrecioUnitario	NUMBER(6),
	Stock 		NUMBER(5),
	PRIMARY KEY (CodProducto)
);

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
 
 
INSERT INTO ventas VALUES('V1', '2', TO_DATE('22/09/97','DD/MM/YY'),2);
INSERT INTO ventas VALUES('V2', '4', TO_DATE('22/09/97','DD/MM/YY'),1);
INSERT INTO ventas VALUES('V3', '6', TO_DATE('23/09/97','DD/MM/YY'),3);
INSERT INTO ventas VALUES('V4', '5', TO_DATE('26/09/97','DD/MM/YY'),5);
INSERT INTO ventas VALUES('V5', '9', TO_DATE('28/09/97','DD/MM/YY'),3);
INSERT INTO ventas VALUES('V6', '4', TO_DATE('28/09/97','DD/MM/YY'),1);
INSERT INTO ventas VALUES('V7', '6', TO_DATE('02/10/97','DD/MM/YY'),2);
INSERT INTO ventas VALUES('V8', '6', TO_DATE('02/10/97','DD/MM/YY'),1);
INSERT INTO ventas VALUES('V9', '2', TO_DATE('04/10/97','DD/MM/YY'),4);
INSERT INTO ventas VALUES('V10','9', TO_DATE('04/10/97','DD/MM/YY'),4);
INSERT INTO ventas VALUES('V11','6', TO_DATE('05/10/97','DD/MM/YY'),2);
INSERT INTO ventas VALUES('V12','7', TO_DATE('07/10/97','DD/MM/YY'),1);
INSERT INTO ventas VALUES('V13','4', TO_DATE('10/10/97','DD/MM/YY'),3);
INSERT INTO ventas VALUES('V14','4', TO_DATE('16/10/97','DD/MM/YY'),2);
INSERT INTO ventas VALUES('V15','3', TO_DATE('18/10/97','DD/MM/YY'),3);
INSERT INTO ventas VALUES('V16','4', TO_DATE('18/10/97','DD/MM/YY'),5);
INSERT INTO ventas VALUES('V17','6', TO_DATE('22/10/97','DD/MM/YY'),2);
INSERT INTO ventas VALUES('V18','6', TO_DATE('02/11/97','DD/MM/YY'),2);
INSERT INTO ventas VALUES('V19','2', TO_DATE('04/11/97','DD/MM/YY'),3);
INSERT INTO ventas VALUES('V20','9', TO_DATE('04/12/97','DD/MM/YY'),3);

/*a) Realiza un procedimiento que actualice la columna Stock de la tabla Productos a 
partir de los registros de la tabla Ventas.

El citado procedimiento debe informarnos por pantalla si alguna de las tablas está vacía 
o si el stock de un producto pasa a ser negativo, en cuyo caso se parará la actualización.*/

CREATE OR REPLACE PROCEDURE actualizarStock IS
   CURSOR ventas_prod IS
      SELECT v.CodProducto AS cod, SUM(v.UnidadesVendidas) AS suma
      FROM ventas v 
      GROUP BY v.CodProducto;
   
   v_stock_actual PRODUCTOS.STOCK%TYPE;
   v_cursor_ventas ventas_prod%ROWTYPE;
   v_cod_prod PRODUCTOS.CodProducto%TYPE;
   negativo EXCEPTION;

BEGIN
   FOR v_cursor_ventas IN ventas_prod LOOP
      UPDATE productos
      SET stock = v_cursor_ventas.suma
      WHERE CodProducto = stock-v_cursor_ventas.cod;

      SELECT stock INTO v_stock_actual
      FROM productos 
      WHERE CodProducto = v_cursor_ventas.cod;

      IF v_stock_actual < 0 THEN
         RAISE negativo;
      ELSIF v_stock_actual = 0 THEN
         DBMS_OUTPUT.PUT_LINE('No queda stock');
      END IF;
   END LOOP; 
EXCEPTION
   WHEN negativo THEN 
      DBMS_OUTPUT.PUT_LINE('No pudo terminar porque alguno de los productos
      es negativo');
END;


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

CREATE OR REPLACE PROCEDURE mostrarVentas IS
   CURSOR prod_ventas IS 
      SELECT p.LineaProducto AS linea, p.nombre AS nombre, v.UnidadesVendidas AS unidadesTotales, v.UnidadesVendidas*p.PrecioUnitario AS importeTotal
      FROM productos p, ventas v 
      WHERE p.CodProducto = v.CodProducto
      ORDER BY p.lineaProducto, p.nombre;--ordenar importante

   v_prod_ventas_cursor prod_ventas%ROWTYPE;
   v_antigua_linea PRODUCTOS.LineaProducto%TYPE;
   v_importe_total_linea PRODUCTOS.PrecioUnitario%TYPE := 0;
BEGIN
   FOR v_prod_ventas_cursor IN prod_ventas LOOP
      IF v_antigua_linea IS NULL OR v_antigua_linea != v_prod_ventas_cursor.linea THEN 
         IF v_importe_total_linea != 0 THEN 
            DBMS_OUTPUT.PUT_LINE('importe total '|| v_antigua_linea || ' :'||v_importe_total_linea);
		   END IF;
         v_antigua_linea := v_prod_ventas_cursor.linea;
         DBMS_OUTPUT.PUT_LINE(v_antigua_linea);
         v_importe_total_linea := v_prod_ventas_cursor.importeTotal;
      ELSE 
         v_importe_total_linea := v_importe_total_linea + v_prod_ventas_cursor.importeTotal;
      END IF;
      
      DBMS_OUTPUT.PUT_LINE(v_prod_ventas_cursor.nombre ||' '||v_prod_ventas_cursor.unidadesTotales ||' '|| v_prod_ventas_cursor.importeTotal);
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('importe total '|| v_antigua_linea || ' :'||v_importe_total_linea);
END;

---------------------------------------------------------------------------------------------------------------------

/*Problema 3

Realiza un procedimiento llamado mostrar_usuarios_con rol que recibiendo como parámetro un rol nos devuelva los nombres de los usuarios a los 
que se ha concedido dicho rol. Realiza otro procedimiento llamado mostrar_privilegios_del_rol que  recibe como parámetro un rol y muestra los 
privilegios que lo componen.
*/


---------------------------------------------------------------------------------------------------------------------

Problema 4

/*Realizar una función que reciba un código de departamento y devuelva al programa que la 
llamó el nombre del mismo y el número de empleados que tiene.*/

CREATE OR REPLACE FUNCTION nombreDepart (cod_depart DEPART.DEPT_NO%TYPE)RETURN NUMBER
IS 
   v_nombre_depart DEPART.DNOMBRE%TYPE;
   v_numEmple NUMBER;
BEGIN
   SELECT d.dnombre, COUNT(e.EMP_NO) INTO v_nombre_depart, v_numEmple
   FROM DEPART d, EMPLE e 
   WHERE d.DEPT_NO = e.DEPT_NO AND d.DEPT_NO = cod_depart
   GROUP BY d.dnombre;

   DBMS_OUTPUT.PUT_LINE(v_nombre_depart);
   RETURN v_numEmple;
END;


--PRUEBA
begin
    DBMS_OUTPUT.PUT_LINE(nombreDepart(20));
end;


---------------------------------------------------------------------------------------------------------------------

Problema 5

/*Realiza un trigger que cada vez que se inserten o modifiquen los datos de una venta, actualice de forma automática la columna stock de la 
tabla productos y compruebe si el stock pasa a estar por debajo del umbral de pedido. Si se da este caso, debe insertarse un registro en la 
tabla Ordenes de Pedido de forma que se pidan las unidades necesarias para restablecer el stock al triple del valor señalado en el umbral de 
pedido.

Realiza un trigger que en el momento en que una orden de pedido se marque como servida se actualizara el stock del producto corrrespondiente.

(Opcional) El trigger envía un correo electrónico a la dirección del proveedor correspondiente, registrada en la tabla Proveedores.
*/
---------------------------------------------------------------------------------------------------------------------

/*Problema 6

Realizar un trigger que mantenga actualizada la columna CosteSalarial, con la suma de los 
salarios y comisiones de los empleados de dichos departamentos reflejando cualquier cambio 
que se produzca en la tabla empleados.*/

ALTER TABLE DEPART ADD costeSalario NUMBER;

CREATE OR REPLACE TRIGGER nuevoSalario /*no funciona*/
AFTER UPDATE OR INSERT ON EMPLE
FOR EACH ROW
BEGIN
   UPDATE DEPART d
   SET d.costeSalario = (SELECT SUM(e.salario)
                         FROM EMPLE e
                         WHERE e.DEPT_NO = :NEW.DEPT_NO
                         GROUP BY e.DEPT_NO)
   WHERE d.DEPT_NO = :NEW.DEPT_NO;
END;


---------------------------------------------------------------------------------------------------------------------

/*Problema 7

Realiza un trigger que incremente en un 5% el salario de un empleado si cambia la localidad del departamento en que trabaja.*/

CREATE OR REPLACE TRIGGER cambiaLoc 
AFTER UPDATE OF LOC 
ON DEPART 
FOR EACH ROW 
BEGIN
   IF :NEW.LOC != :OLD.LOC THEN 
      UPDATE EMPLE 
      SET salario = SALARIO*1.05
   END IF;
END;

---------------------------------------------------------------------------------------------------------------------

/*Problema 8

Realiza un trigger que registre en la base de datos los intentos de modificar, actualizar o borrar datos en las filas de la tabla EMP 
correspondientes al presidente y a los jefes de departamento, especificando el usuario, la fecha y la operacion intentada.*/


---------------------------------------------------------------------------------------------------------------------

/*Problema 9

(Opcional) Realizar un trigger que impida que un departamento tenga más de 5 empleados o menos de dos.*/


