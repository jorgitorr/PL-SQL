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

/*QUE CONTENGA LA CADENA, NO QUE SEA LA MISMA CADENA -> CORREGIDO*/
DECLARE
    numero_empleado INT := 0;
	nombre_empleado EMPLE.APELLIDO%type;
	numero_empleados INT:=1;

	CURSOR apellido_cadena(cadena VARCHAR2) IS
        SELECT e.APELLIDO, COUNT(e.APELLIDO)
        FROM EMPLE e, DEPART d
        WHERE e.DEPT_NO = d.DEPT_NO AND e.APELLIDO LIKE cadena
        GROUP BY e.APELLIDO;
BEGIN
    OPEN apellido_cadena('SÁNCHEZ');
    LOOP
    	FETCH apellido_cadena INTO nombre_empleado, numero_empleados;
		EXIT WHEN apellido_cadena%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE(nombre_empleado || ' número de empleados con ese nombre: ' || numero_empleados);
		numero_empleados := numero_empleados+1;
    END LOOP;
	CLOSE apellido_cadena;
END;

/*4) Escribir un programa que visualice el apellido y el salario de los cinco empleados que tienen el salario más alto.
   Nota: En el SELECT asociado al cursor NO debe limitarse el número de filas con %ROWNUM
   CORREGIDO*/
   

DECLARE
	cont INT := 0;
	CURSOR emple_mas_salario IS
        SELECT e.APELLIDO, e.SALARIO
        FROM EMPLE e
        ORDER BY e.SALARIO DESC;

	empleados emple_mas_salario%ROWTYPE;
BEGIN
   OPEN emple_mas_salario;
    LOOP
    	FETCH emple_mas_salario INTO empleados;
		cont := cont+1;
		DBMS_OUTPUT.PUT_LINE(empleados.APELLIDO ||' '||empleados.SALARIO ||'$');
		EXIT WHEN cont=5; 
		EXIT WHEN emple_mas_salario%NOTFOUND;
    END LOOP;
	CLOSE emple_mas_salario;
END;


/*5) Codificar un programa que visualice los dos empleados que ganan menos de cada oficio.
   Nota: En el SELECT asociado al cursor NO debe limitarse el número de filas con %ROWNUM */
 
 /*NO LE PUEDO PASAR EL OFICIO POR PARÁMETRO, ES DIFERENTE A LO QUE PIDE EL EJERCICIO, TENGO QUE GUARDAR EL OFICIO POR EL QUE IBA

 PONERME EJEMPLOS CON PICARDÍA 
 */
DECLARE
    CURSOR empleado_menor_salario IS
    	SELECT e.OFICIO, e.APELLIDO, e.SALARIO
    	FROM EMPLE e
    	ORDER BY e.OFICIO, e.SALARIO ASC;
	cont NUMBER := 0;
	oficio_anterior	EMPLE.OFICIO%type;
	oficio_actual EMPLE.OFICIO%type;
	
BEGIN
    FOR empleado IN empleado_menor_salario LOOP
		cont := cont+1;
		oficio_actual:= empleado.OFICIO;
		IF cont > 1 AND oficio_anterior != oficio_actual THEN
            cont := 0;
		END IF;
		IF cont<2 THEN 
            DBMS_OUTPUT.PUT_LINE(empleado.OFICIO|| ' ' || empleado.APELLIDO||' '||empleado.SALARIO);
        END IF;
		oficio_anterior := empleado.OFICIO;
    END LOOP;
END;

/*no se puede hacer GROUP BY (SE SUPONE) si no vas a usar una funcion de grupo*/

/*6) Escribir un programa que muestre, en formato similar a las rupturas de control o secuencia vistas en SQL*plus los siguientes datos:

- Para cada empleado: apellido y salario.
- Para cada departamento: Número de empleados y suma de los salarios del departamento.
- Al final del listado: Número total de empleados y suma de todos los salarios.

  Nota: En el SELECT asociado al cursor debe recorrer simplemente las filas de la tabla de empleados/*
/*ordenar por departamento para hacerlo en un solo cursor*/

/*PARA HACER LEFT JOIN EN ORACLE LO HAGO CON (+) EN EL CONTRARIO AL QUE QUIERO HACERLE LEFT JOIN*/
DECLARE
    CURSOR apellido_salario IS
    	SELECT d.DEPT_NO, e.APELLIDO, e.SALARIO
    	FROM EMPLE e, DEPART d 
    	WHERE e.DEPT_NO = d.DEPT_NO;

	CURSOR departamento_salario IS
        SELECT d.DEPT_NO, SUM(e.salario) sumaSalario
        FROM DEPART d, EMPLE e
        WHERE d.DEPT_NO = e.DEPT_NO
        GROUP BY d.DEPT_NO
        ORDER BY d.DEPT_NO ASC;

	CURSOR total_salario IS
        SELECT e.APELLIDO, e.salario
        FROM EMPLE e 
        ORDER BY e.APELLIDO DESC;

	emple_salario apellido_salario%ROWTYPE;
	depart_sal departamento_salario%ROWTYPE;
	total_sal total_salario%ROWTYPE;
	salario_total NUMBER(10):=0;
	num_emple INT := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('*****Para cada empleado*****');
    FOR emple_salario IN apellido_salario LOOP
		DBMS_OUTPUT.PUT_LINE(emple_salario.APELLIDO ||' '|| emple_salario.SALARIO);
    END LOOP;
	DBMS_OUTPUT.PUT_LINE('*****Para cada departamento*****');
	FOR depart_sal IN departamento_salario LOOP
		DBMS_OUTPUT.PUT_LINE(depart_sal.DEPT_NO ||' '||depart_sal.sumaSalario);
    END LOOP;
	DBMS_OUTPUT.PUT_LINE('*****Total empleados - Total salario*****');
	FOR total_sal IN total_salario LOOP
        salario_total := total_sal.SALARIO + salario_total;
		num_emple := num_emple +1;
    END LOOP;
	DBMS_OUTPUT.PUT_LINE('el numero de empleados total es: '||num_emple ||' con un salario total de: ' || salario_total);
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

/*NO SE HACERLO CON FOR UPDATE -ESTE EJERCICIO ES IMPORTANTE-*/
DECLARE
    CURSOR emple_mas_antiguo IS 
    	SELECT d.DEPT_NO, e.APELLIDO, e.SALARIO, e.fecha_alt
		FROM EMPLE e, DEPART d
		WHERE e.DEPT_NO = d.DEPT_NO
		ORDER BY dept_no, fecha_alt ASC;

    emple_mas_viejo emple_mas_antiguo%ROWTYPE;
	depart_actual DEPART.DEPT_NO%type;
	depart_antiguo DEPART.DEPT_NO%type;
	cont INT:= 0;
BEGIN
    depart_antiguo := 0;
    FOR emple_mas_viejo IN emple_mas_antiguo LOOP
    	depart_actual := emple_mas_viejo.DEPT_NO;
		IF cont>0 THEN
            depart_antiguo := depart_actual;
			cont:=0;
        END IF;
		IF (depart_antiguo!=depart_actual) THEN
            cont := cont+1;
            UPDATE EMPLE
            SET SALARIO = SALARIO*1.1;
			DBMS_OUTPUT.PUT_LINE(emple_mas_viejo.DEPT_NO || ' ' || emple_mas_viejo.APELLIDO || ' :'||emple_mas_viejo.SALARIO);
		END IF;
    END LOOP;
END;



/*10) Escribir un programa PL-SQL parametrizado que reciba un nombre de departamento y un número positivo y que despida a ese número de empleados con menor antiguedad de ese departamento.
 Nota: debe emplearse un cursor parametrizado. Definir un cursor con parámetros que tenga la cláusula 'FOR UPDATE'*/

DECLARE
    CURSOR despidos(depart VARCHAR2, num INT) IS
    	SELECT e.APELLIDO, e.FECHA_ALT
    	FROM DEPART d, EMPLE e 
    	WHERE d.DEPT_NO = e.DEPT_NO AND d.DEPT_NO=depart AND ROWNUM<num+1 /*es como limit en oracle*/
    	ORDER BY e.FECHA_ALT
		FOR UPDATE OF e.APELLIDO, e.DEPT_NO, d.DEPT_NO NOWAIT;
    dept_emple despidos%ROWTYPE;
BEGIN
    FOR dept_emple IN despidos(30, 2) LOOP
    	DBMS_OUTPUT.PUT_LINE(dept_emple.APELLIDO ||' '||dept_emple.FECHA_ALT);
    END LOOP;
END;


/*NO ME BORRA LAS FILAS*/
DECLARE
    CURSOR despidos(depart VARCHAR2, num INT) IS
    	SELECT e.APELLIDO, e.FECHA_ALT
    	FROM DEPART d, EMPLE e 
    	WHERE d.DEPT_NO = e.DEPT_NO AND d.DEPT_NO=depart AND ROWNUM<num+1 /*es como limit en oracle*/
    	ORDER BY e.FECHA_ALT
		FOR UPDATE OF e.APELLIDO, e.DEPT_NO, d.DEPT_NO NOWAIT;
    dept_emple despidos%ROWTYPE;
BEGIN
    FOR dept_emple IN despidos(30, 2) LOOP
    	UPDATE EMPLE e
    	SET e.APELLIDO = null, e.DEPT_NO=null
    	WHERE CURRENT OF despidos;
    	DBMS_OUTPUT.PUT_LINE(dept_emple.APELLIDO ||' '||dept_emple.FECHA_ALT);
    END LOOP;
END;


/*HACER EL 9 CON FOR UPDATE TAMBIÉN, EL 10 NO ME BORRA NADA*/



