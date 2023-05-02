--Ejercicios sobre paquetes


/*1) Escribir un paquete completo para gestionar los departamentos. El paquete se llamará gest_depart y deberá incluir, al menos, 
los siguientes subprogramas:

-insertar_nuevo_depart: permite insertar un departamento nuevo. El procedimiento 
recibe el nombre y la localidad del nuevo departamento. 
Creará el nuevo departamento comprobando que el nombre no se duplique y le asignará 
como número de departamento la decena siguiente al último número de departamento utilizado.

-borrar_depart: permite borrar un departamento. El procedimiento recibirá dos números de departamento de los cuales el primero corresponde 
al departamento que queremos borrar y el segundo al departamento al que pasarán los empleados del departamento que se va eliminar. 
El procedimiento se encargará de realizar los cambios oportunos en los números de departamento de los empleados correspondientes. 

-modificar_loc_depart: modifica la localidad del departamento. El procedimiento recibirá el número del departamento a modificar y la 
nueva localidad, y realizará el cambio solicitado.

-visualizar_datos_depart: visualizará los datos de un departamento cuyo número se pasará en la llamada. Además de los datos relativos 
al departamento, se visualizará el número de empleados que pertenecen actualmente al departamento. 

-visualizar_datos_depart: versión sobrecargada del procedimiento anterior que, en lugar del número del departamento, recibirá el nombre 
del departamento. Realizará una llamada a la función buscar_depart_por_nombre que se indica en el apartado siguiente.

-buscar_depart_por_nombre: función local al paquete. Recibe el nombre de un departamento y devuelve el número del mismo.
*/

/*a*/

CREATE OR REPLACE PROCEDURE insertar_nuevo_depart(nombre DEPART.DNOMBRE%TYPE,loc DEPART.LOC%TYPE) 
IS
    last_depart DEPART.DEPT_NO%TYPE;
BEGIN
    SELECT MAX(DEPT_NO) INTO last_depart FROM DEPART;
    IF last_depart IS NULL THEN
        last_depart := 10; -- Si no hay departamentos en la tabla, se empieza en 10
    ELSE
        last_depart := last_depart + 10; -- Se agrega 10 para asignar el número del nuevo departamento
    END IF;

    DECLARE
        num_deps NUMBER;
    BEGIN
        SELECT COUNT(*) INTO num_deps FROM DEPART WHERE DNOMBRE = nombre;
        IF num_deps = 0 THEN
            INSERT INTO DEPART (DEPT_NO, DNOMBRE, LOC) VALUES (last_depart, nombre, loc);
        END IF;
    END;
END;

/*b NO ESTA TERMINADO*/
CREATE OR REPLACE PROCEDURE borrar_depart(departBorrar NUMBER, departPasar NUMBER)
IS
BEGIN
	UPDATE EMPLE e
	SET e.DEPT_NO = departPasar
	WHERE e.DEPT_NO = departBorrar;

	DELETE FROM EMPLE e
	WHERE e.DEPT_NO = departBorrar;
END;


/**/
DECLARE
BEGIN
    borrar_depart(30,40);
END;


/*c*/
CREATE OR REPLACE PROCEDURE modificar_loc(numDepart NUMBER, nuevaLoc DEPART.LOC%TYPE)IS
BEGIN
    UPDATE DEPART d
    SET d.LOC = nuevaLoc
    WHERE d.DEPT_NO = numDepart;
END;

/*uso*/
DECLARE
BEGIN
    modificar_loc(30,'CÁDIZ');
END;


/*d*/




/*2) Escribir un paquete completo para gestionar los empleados. El paquete se llamará gest_emple e incluirá, al menos los siguientes subprogramas:

-insertar_nuevo_emple
-borrar_emple. Cuando se borra un empleado todos los empleados que dependían de él pasarán a depender del director del empleado borrado.
-modificar_oficio_emple
-modificar_dept_emple
-modificar_dir_emple
-modificar_salario_emple
-modificar_comision_emple
-visualizar_datos_emple. También se incluirá una versión sobrecargada del procedimiento que recibirá el nombre del empleado.
-buscar_emple_por_dnombre. Función local que recibe el nombre y devuelve el número.


Todos los procedimientos recibirán el número del empleado seguido de los demás datos necesarios. También se incluirán en el paquete cursores y declaraciones de tipo registro, así como siguientes procedimientos que afectarán a todos los empleados:

-subida_salario_pct: incrementará el salario de todos los empleados el porcentaje indicado en la llamada que no podrá ser superior al 25%.
-subida_salario_imp: sumará al salario de todos los empleados el importe indicado en la llamada. Antes de proceder a la incrementar los salarios se comprobará que el importe indicado no supera el 25% del salario medio. 

*/

