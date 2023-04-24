/*Cursores*/

/*1) Desarrollar un programa que visualice el apellido y la fecha de alta de todos los empleados ordenados por apellido.*/

DECLARE
   apellido_emple EMPLE.APELLIDO%type;
   fecha_alta EMPLE.FECHA_ALT%type;
	cont INT:=1;
   CURSOR empleados_ordenados IS
    	SELECT e.apellido, e.fecha_alt 
    	FROM EMPLE e
    	ORDER BY e.apellido; 
BEGIN
    OPEN empleados_ordenados;
    LOOP
    	FETCH empleados_ordenados INTO apellido_emple, fecha_alta;
		EXIT WHEN empleados_ordenados%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('El apellido del empleado es: ' || apellido_emple ||' con una fecha de alta: '|| fecha_alta);
    END LOOP;
	CLOSE empleados_ordenados;
END;


/*2) Codificar un programa que muestre el nombre de cada departamento y el número de empleados que tiene.*/

DECLARE
   nombre_depart DEPART.DEPT_NO%type;
   numero_empleados INT := 0;
   CURSOR depart_num_emple IS
      SELECT d.DEPT_NO, COUNT(e.apellido)
      FROM DEPART d, EMPLE e
       WHERE d.DEPT_NO = e.DEPT_NO
      GROUP BY d.DEPT_NO;
BEGIN 
   OPEN depart_num_emple;
   LOOP 
      FETCH depart_num_emple INTO nombre_depart, numero_empleados;
      EXIT WHEN depart_num_emple%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('departamento: '||nombre_depart ||' con: '|| numero_empleados||' empleados');
   END LOOP;
   CLOSE depart_num_emple;
END;



/*3) Escribir un programa que reciba una cadena como parámeto ('&cadena') y visualice el apellido y el número de empleado de todos los 
empleados cuyo apellido contenga la cadena especificada. Al finalizar visualizar el número de empleados mostrados.*/

/* es que contenga la cadena no que sea la cadena*/
DECLARE
    numero_empleado INT := 0;
	cadena VARCHAR2(50):= 'SÁNCHEZ';
	nombre_empleado EMPLE.APELLIDO%type;
	numero_empleados INT:=1;

	CURSOR apellido_cadena IS
        SELECT e.APELLIDO, COUNT(e.APELLIDO)
        FROM EMPLE e, DEPART d
        WHERE e.DEPT_NO = d.DEPT_NO AND e.APELLIDO LIKE cadena
        GROUP BY e.APELLIDO;
BEGIN
    OPEN apellido_cadena;
    LOOP
    	FETCH apellido_cadena INTO nombre_empleado, numero_empleados;
		EXIT WHEN apellido_cadena%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(nombre_empleado || ' número de empleados con ese nombre: ' || numero_empleados);
		numero_empleados = numero_empleados+1;
    END LOOP;
	CLOSE apellido_cadena;
END;

/*4) Escribir un programa que visualice el apellido y el salario de los cinco empleados que tienen el salario más alto.
   Nota: En el SELECT asociado al cursor NO debe limitarse el número de filas con %ROWNUM
   CORREGIRLO - HACERLO CON CONTADOR*/
   
DECLARE
	cont INT := 1;
	CURSOR emple_mas_salario IS
        SELECT e.APELLIDO, e.SALARIO
        FROM EMPLE e
        ORDER BY e.SALARIO DESC;

	apellido_empleados EMPLE.APELLIDO%type;
	salario_empleados EMPLE.SALARIO%type;
BEGIN
   OPEN emple_mas_salario;
    LOOP
    	FETCH emple_mas_salario INTO apellido_empleados, salario_empleados;
		EXIT WHEN emple_mas_salario%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(apellido_empleados || ' ' || salario_empleados||'$');
    END LOOP;
	CLOSE emple_mas_salario;
	OPEN emple_mas_salario(30);
    LOOP
    	FETCH emple_mas_salario INTO apellido_empleados, salario_empleados;
		EXIT WHEN emple_mas_salario%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(apellido_empleados || ' ' || salario_empleados||'$');
    END LOOP;
   CLOSE emple_mas_salario; 
END;


/*HECHO CON ROWTYPE: PARA ASIGNAR EL MISMO TIPO A LAS VARIABLES QUE LO QUE DEVUELVE EL CURSOR*/

DECLARE
	cont INT := 0;
	CURSOR emple_mas_salario IS
        SELECT e.APELLIDO, e.SALARIO
        FROM EMPLE e
        WHERE e.DEPT_NO = num_dept
        ORDER BY e.SALARIO;

	empleados emple_mas_salario%ROWTYPE;
BEGIN
   OPEN emple_mas_salario;
    LOOP
    	FETCH emple_mas_salario INTO empleados;
		cont := cont+1;
		EXIT WHEN cont=5; 
		EXIT WHEN emple_mas_salario%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(empleados.APELLIDO ||' '||empleados.SALARIO ||'$');
    END LOOP;
	CLOSE emple_mas_salario;
END;


/*5) Codificar un programa que visualice los dos empleados que ganan menos de cada oficio.
   Nota: En el SELECT asociado al cursor NO debe limitarse el número de filas con %ROWNUM */
 
 /*NO LE PUEDO PASAR EL OFICIO POR PARÁMETRO, ES DIFERENTE A LO QUE PIDE EL EJERCICIO, TENGO QUE GUARDAR EL OFICIO POR EL QUE IBA
 TENEMOS DOS VARIABLES OFICIO_ANTERIO Y OFICIO_ACTUAL 
 IF(OFICIO_ANTERIOR != OFICIO_ACTUAL)
 	IMPRIMO TODO
	CONT:= 0;
	
TENER EN CUENTA QUE SOLO PUEDE HABER UN EMPLEADO EN UN OFICIO DESPUÉS DE HACERLO
*/
 /*PONER EJEMPLOS CON PICARDÍA*/
DECLARE
    CURSOR empleado_menor_salario(oficio_emple VARCHAR2) IS
    	SELECT e.OFICIO, e.APELLIDO, e.SALARIO
    	FROM EMPLE e
    	WHERE e.OFICIO = oficio_emple
    	ORDER BY e.SALARIO DESC;/*ordenar por oficio antes de salario (MIRAR ESTO DESC/ASC)*/
	empleado empleado_menor_salario%ROWTYPE;
BEGIN
    OPEN empleado_menor_salario('VENDEDOR');
    	LOOP 
    		FETCH empleado_menor_salario INTO empleado;
            EXIT WHEN empleado_menor_salario%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(empleado.OFICIO|| ' ' || empleado.APELLIDO||' '||empleado.SALARIO);
    	END LOOP;
    CLOSE empleado_menor_salario;
	OPEN empleado_menor_salario('EMPLEADO');
    	LOOP 
    		FETCH empleado_menor_salario INTO empleado;
            EXIT WHEN empleado_menor_salario%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(empleado.OFICIO|| ' ' || empleado.APELLIDO||' '||empleado.SALARIO);
    	END LOOP;
    CLOSE empleado_menor_salario;
END;


/*NO ME DEJA USAR GROUP BY CON LA DE ARRIBA -> no se puede hacer group by si no vas a usar una funcion de grupo*/

/*6) Escribir un programa que muestre, en formato similar a las rupturas de control o secuencia vistas en SQL*plus los siguientes datos:

- Para cada empleado: apellido y salario.
- Para cada departamento: Número de empleados y suma de los salarios del departamento.
- Al final del listado: Número total de empleados y suma de todos los salarios.

  Nota: En el SELECT asociado al cursor debe recorrer simplemente las filas de la tabla de empleados/*
/*ordenar por departamento para hacerlo en un solo cursor*/

DECLARE
    CURSOR apellido_salario IS
    	SELECT d.DEPT_NO, e.APELLIDO, e.SALARIO
    	FROM EMPLE e, DEPART d 
    	WHERE e.DEPT_NO = d.DEPT_NO;

	deptEmple apellido_salario%ROWTYPE;
BEGIN
    OPEN apellido_salario;
    	LOOP
         	FETCH apellido_salario INTO deptEmple;
    		EXIT WHEN apellido_salario%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE(deptEmple.DEPT_NO || ' ' ||deptEmple.APELLIDO ||' '|| deptEmple.SALARIO);
    	END LOOP;
    CLOSE apellido_salario;
END;

/*7) Escribir un programa PL-SQL que reciba un nombre de departamento como parámetro ('&parámetro') y muestre los datos de ese departamento.
   Nota: debe emplearse un cursor con parámetros */

DECLARE
    CURSOR datos_depart(nombre_depart VARCHAR2) IS
    	SELECT *
    	FROM DEPART d
    	WHERE d.DNOMBRE = nombre_depart;

	departamento datos_depart%ROWTYPE;
BEGIN
    OPEN datos_depart('CONTABILIDAD');
    	LOOP
    		FETCH datos_depart INTO departamento;
			EXIT WHEN datos_depart%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('DNOMBRE: '||departamento.DNOMBRE||', DEPT_NO: '||departamento.DEPT_NO||', LOC: '||departamento.LOC);
    	END LOOP;
	CLOSE datos_depart;
END;


/*8) Escribir un programa PL-SQL parametrizado que reciba un nombre de ciudad y 
dos valores de comisión y muestre el nombre de los empleados y su oficio de cada 
departamento de aquelos que tengan una comisión en ese rango. Solo se considerarán 
los departamentos localizados en la ciudad indicada.

Nota: deberán emplearse dos cursores parametrizados:
  -El primero que tenga como parámetro una ciudad
  -El segundo que tenga como parámetros un rango de comisiones y un departamento*/

/*NO SE PUEDE COGER LOS MISMOS DATOS EN EL SELECT CON CURSORES*/


DECLARE
    CURSOR emple_ciudad(ciudad VARCHAR2) IS
    	SELECT e.APELLIDO
    	FROM EMPLE e, DEPART d
    	WHERE e.DEPT_NO=d.DEPT_NO AND d.LOC = ciudad;

	CURSOR oficio_depart(min_comision NUMBER, max_comision NUMBER, depart NUMBER) IS
		SELECT e.OFICIO, e.APELLIDO
		FROM DEPART d, EMPLE e
		WHERE d.DEPT_NO = e.DEPT_NO AND d.DEPT_NO = depart AND e.COMISION BETWEEN min_comision AND max_comision; 
	
	apellido emple_ciudad%ROWTYPE;
	oficio oficio_depart%ROWTYPE; 
BEGIN
	OPEN emple_ciudad('BARCELONA');
		LOOP
		FETCH emple_ciudad INTO apellido;
		EXIT WHEN emple_ciudad%NOTFOUND;
		END LOOP;
	CLOSE emple_ciudad;


	OPEN oficio_depart(50000,70000,30);
		LOOP
		FETCH oficio_depart INTO oficio;
		EXIT WHEN oficio_depart%NOTFOUND;
		END LOOP;
	CLOSE oficio_depart;

	IF (apellido.APELLIDO=oficio.APELLIDO) THEN
		DBMS_OUTPUT.PUT_LINE(apellido.APELLIDO ||' '||oficio.OFICIO);
	ELSE
        DBMS_OUTPUT.PUT_LINE('No coincide el empleado con su departamento o con la comision indicada');
	END IF;
END;


/*9) Escribir un programa PL-SQL que incremente en un 10% el salario de los empleados 
más antiguos en todos los departamentos. Definir un cursor con la cláusula 'FOR UPDATE'*/

DECLARE
    CURSOR emple_mas_antiguo IS 
    	SELECT e.APELLIDO, e.FECHA_ALT
    	FROM EMPLE e
    	GROUP BY e.DEPT_NO, e.FECHA_ALT
		ORDER BY e.DEPT_NO, e.FECHA_ALT DESC;
	

    
    emple_mas_viejo emple_mas_antiguo%ROWTYPE;
BEGIN
    OPEN emple_mas_antiguo;
	LOOP
        FETCH emple_mas_antiguo INTO emple_mas_viejo;
		EXIT WHEN emple_mas_antiguo%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(emple_mas_viejo.APELLIDO||' '||emple_mas_viejo.FECHA_ALT);
    END LOOP;
	CLOSE emple_mas_antiguo;
END;



/*10) Escribir un programa PL-SQL parametrizado que reciba un nombre de departamento y un número positivo y que despida a ese número de empleados con menor antiguedad de ese departamento.
 Nota: debe emplearse un cursor parametrizado. Definir un cursor con parámetros que tenga la cláusula 'FOR UPDATE'*/





/*TERMINAR EL 6*/
