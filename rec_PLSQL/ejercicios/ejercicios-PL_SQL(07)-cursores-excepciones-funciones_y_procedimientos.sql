1) Desarrollar un procedimiento que permita insertar nuevos departamentos según las siguientes especificaciones:

   -Se pasará al procedimiento el nombre del departamento y la localidad.
   -El procedimiento insertará la fila nueva asignando como número de departamento la decena siguiente al número
    mayor de la  tabla. 

   Se incluirá gestión de posibles errores.


2) Escribir un procedimiento que reciba todos los datos de un nuevo empleado y realice el alta del mismo, gestionando posibles errores.


3) Codificar un procedimiento reciba como parámetros un numero de departamento, un importe (es decir, una cantidad de dinero) y un porcentaje (es decir, un tanto por ciento) y suba el salario a todos los empleados del departamento indicado. La subida de salario será o bien el porcentaje que se indica como parámetro o bien el importe indicado como parámetro: de las dos posibilidades, la que sea más beneficiosa para cada caso de empleado.

 Se incluirá gestión de posibles errores.


4) Escribir un procedimiento que suba el sueldo de todos los empleados que ganen igual o menos que el salario medio de su oficio. La subida será de el 50% de la diferencia entre el salario del empleado y la media de su oficio. Se deberá asegurar que la transacción no se quede a medias, y se gestionarán los posibles errores. 


5) Diseñar una aplicación que simule un listado de liquidación de los empleados según las siguientes especificaciones:

- El listado tendrá el siguiente formato para cada empleado:
**********************************************************************
Liquidación del empleado:...................(1) 	Dpto:.................(2) 	Oficio:...........(3)

Salario		: ............(4)
Trienios		:.............(5)
Comp. Responsabil	:.............(6)
Comisión		:.............(7)
 			------------
Total		           :.............(8)
**********************************************************************
- Donde:
1 ,2, 3 y 4 Corresponden al apellido, departamento, oficio y salario del empleado.
5 Es el importe en concepto de trienios. Cada trienio son tres años completos desde la fecha de alta hasta la de emisión y supone 50 €. 
6 Es el complemento por responsabilidad. Será de 100 € por cada empleado que se encuentre directamente a cargo del empleado en cuestión.
7 Es la comisión. Los valores nulos serán sustituidos por ceros.
8 Suma de todos los conceptos anteriores.

El listado irá ordenado por Apellido. 


6) Crear la tabla T_liquidacion con las columnas apellido, departamento, oficio, salario, trienios, comp_responsabilidad, comisión y total; y modificar la aplicación anterior para que en lugar de realizar el listado directamente en pantalla, guarde los datos en la tabla. Se controlarán todas las posibles incidencias que puedan ocurrir durante el proceso.



