1) Crear el procedimiento ejsqldin que reciba como parámetro una cadena que represente una sentencia SQL y realice la sentencia SQL que representa esa cadena.

Realizar pruebas con ese procedimiento con las siguientes cadenas, observar los resultados y solucionar los problemas que puedan plantearse:

-'CREATE USER DUMM1 IDENTIFIED BY DUMM1'
-'CREATE TABLE PR1 (C1 CHAR)'
-'ALTER TABLE PR1 ADD COMENTARIO VARCHAR2(20)'


/* Ejemplos de definición de datos con ejsqldin */

SQL> EXECUTE EJSQLDIN('CREATE USER DUMM1 IDENTIFIED BY DUMM1')
begin EJSQLDIN('CREATE USER DUMM1 IDENTIFIED BY DUMM1'); end;
*
ERROR en línea 1:
ORA-01031: privilegios insuficientes
ORA-06512: en "SYSTEM.EJSQLDIN", línea 14
ORA-06512: en línea 1
SQL> GRANT CREATE USER TO SYSTEM;
Concesión terminada con éxito.

SQL> EXECUTE EJSQLDIN('CREATE USER DUMM1 IDENTIFIED BY DUMM1')
Procedimiento PL/SQL terminado con éxito.

SQL> EXECUTE EJSQLDIN('CREATE TABLE PR1 (C1 CHAR)');
Procedimiento PL/SQL terminado con éxito.

SQL> EXECUTE EJSQLDIN('ALTER TABLE PR1 ADD COMENTARIO VARCHAR2(20)')
Procedimiento PL/SQL terminado con éxito.

SQL> DESCRIBE PR1
Name Null? Type
------------------------------- -------- ----
C1 CHAR(1)
COMENTARIO VARCHAR2(20)


2) Crear un procedimiento que permita consultar todos los datos de la tabla depart a partir de una condición que se indicará en la llamada al procedimiento.


