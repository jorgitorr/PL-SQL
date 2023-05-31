CREATE TABLE empleados (codigoEmple NUMBER PRIMARY KEY NOT NULL, nombre VARCHAR(30), jefe NUMBER);

CREATE TABLE jefesYempleados (codigoJefe NUMBER, numeroEmpleados NUMBER);

INSERT INTO empleados VALUES ((1,'pepe',1),(2,'josemaxp',1), (3,'pablo',1),(4,'mc',4)
,(5,'ruben',4),(6,'sergio',4),(7,'joselui',4),(8,'MBAPPE',4),(9,'HALAAND',9),(10,'JorgeXd',9));

INSERT INTO empleados VALUES (1,'pepe',1);
INSERT INTO empleados VALUES (2,'josemaxp',1);
INSERT INTO empleados VALUES (3,'pablo',1);
INSERT INTO empleados VALUES (4,'mc',4);
INSERT INTO empleados VALUES (5,'ruben',4);
INSERT INTO empleados VALUES (6,'sergio',4);
INSERT INTO empleados VALUES (7,'joselui',4); 
INSERT INTO empleados VALUES (8,'MBAPPE',4);
INSERT INTO empleados VALUES (9,'HALAAND',9);
INSERT INTO empleados VALUES (10,'JorgeXd',9);

CREATE TABLE jefesBorrados ( idJefe NUMBER(2));

select jefe, count(codigoEmple) FROM empleados group by jefe; 
// consulta para saber cuantos empleados tiene a cargo cada jefe//

--añadir jefes con numero empleados
CREATE OR REPLACE TRIGGER addJefesYNumerosEmple 
BEFORE DELETE ON empleados 
DECLARE 
    CURSOR meterJefes IS 
        select jefe, count(codigoEmple) as cuenta 
        FROM empleados 
        group by jefe;  
BEGIN
    FOR datosJefes IN meterJefes LOOP
        INSERT INTO jefesYempleados VALUES (datosJefes.jefe,datosJefes.cuenta);
    END LOOP;
END;

--insertar jefes borrados
CREATE OR REPLACE TRIGGER insertarJefesBorrados 
BEFORE DELETE ON empleados 
FOR EACH ROW 
BEGIN
	INSERT INTO jefesBorrados 
    (idJefe) VALUES(:OLD.codigoEmple);


--cambiar jefes
CREATE OR REPLACE TRIGGER cambiarJefes 
AFTER DELETE ON empleados 
DECLARE 
    nuevoJefe NUMBER;
BEGIN
    SELECT jefe INTO nuevoJefe 
    FROM jefesYempleados 
    ORDER BY numeroEmpleados ASC LIMIT 1;

    UPDATE empleados 
    SET jefe=nuevoJefe 
    WHERE jefe=:OLD.jefe;
END;

