/*1. Garantice mediante triggers que se anotará correctamente en la BD a quien se le ha asignado
el maillot morado en esa etapa, que siempre corresponde al ganador de la elapa
(2 puntos)*/



/*2. Crear un módulo "asignarMaillot" que, dado un código de Maillot, un dorsal de ciclista 
y un número de etapa, asigne ese maillot a ese ciclista en dicha etapa. Tenga en cuenta que 
esa asignación solo se permite si cumple las siguientes reglas:
   - El maillot de color morado solo lo puede tener el corredor ganador de esa etapa 
   - El maillot de color azul solo lo puede tener el corredor que haya ganado en esa etapa mas 
   puertos con pendiente superior al 8 % (supondremos que siempre habrá solo uno)
Asuma que el resto de las tablas tienen ya almacenada toda la información
necesaria para poder comprobar la corrección de dicha asignación.
El módulo debe devolver un booleano indicando si fue posible o no anotar ese maillot y 
además debe devolver la cuenta del nümero de mailliots que lleva hasta ese momento ese 
ciclista en esa etapa. (4 puntos)*/

CREATE OR REPLACE FUNCTION asignarMaillot(v_codigo MAILLOT.CODIGO%TYPE, dorsal CICLISTA.DORSAL%TYPE,
v_etapa ETAPA.NETAPA%TYPE, numMaillots OUT NUMBER)RETURN BOOLEAN IS
   corredor_ganador LLEVAR.DORSAL%type;/*esto es un type*/
   maillot_escogido MAILLOT.CODIGO%TYPE;

   CURSOR ganadores IS
      SELECT dorsal
      FROM etapa e
      WHERE e.netapa = v_etapa;

   CURSOR ganadores_pendiente IS
      SELECT l.dorsal
      FROM llevar l, etapa e, puerto p 
      WHERE l.netapa = e.netapa AND p.netapa = e.netapa 
      AND p.pendiente > 8
      GROUP BY l.dorsal;
BEGIN
   SELECT color INTO maillot_escogido
   FROM maillot 
   WHERE codigo = v_codigo;

      IF maillot_escogido = 'morado'THEN
         FOR corredor_ganador IN ganadores LOOP
            IF(corredor_ganador.dorsal = dorsal)THEN
               INSERT INTO llevar VALUES(dorsal,v_etapa, codigo);
				   RETURN TRUE;
            END IF;
         END LOOP;

      ELSIF(codigo = maillot_azul)THEN
         FOR corredor_ganador IN ganadores_pendiente LOOP
            IF(corredor_ganador.dorsal = dorsal) THEN
               INSERT INTO llevar VALUES(dorsal, v_etapa, codigo);
				   RETURN TRUE;
            END IF;
         END LOOP;
         
      ELSE
         INSERT INTO llevar VALUES(dorsal, v_etapa, codigo);
		RETURN TRUE;
	END IF;

   SELECT COUNT(l.codigo) INTO numMaillots
   FROM llevar l 
   WHERE l.dorsal = dorsal;

   DBMS_OUTPUT.PUT_LINE(numMaillots);

	RETURN FALSE;
END;


/*3. Redactar en PUSQL el módulo que se describe a continuación, en el que se deberá utilizar 
un bucle, uno o varios cursores no triviales y definir los parámetros adecuadamente. 
No puede utilizarse Select into.
Obtener un listado de todas las etapas y para cada etapa un listado con los nombres de todos 
los ciclistas a los que se les ha asignado un maillot, cuantos maillots han ganado y los 
colores de dichos mallots.
Tenga en cuenta que a un mismo ciclista se le pueden haber asignado varios maillots en la 
misma etapa; en el listado debe aparecer en la misma linea de cada ciclista, el nümero de 
mailiots que ha ganado en esa etapa y el color de todos los mailiots asgnados en esa etapa 
(en ese order cicista, cuenta y colores)
(4 puntos)*/

CREATE OR REPLACE PROCEDURE etapa_ciclista_num_colores(numMaillot OUT NUMBER, colorMaillot OUT MAILLOT.COLOR%TYPE)IS 
   CURSOR etapas_ciclistas IS
      SELECT e.netapa etapa, c.nombre nombre, m.color color
      FROM ciclista c, llevar l, maillot m, etapa e
      WHERE e.netapa = l.dorsal
      AND l.dorsal = c.dorsal
      AND l.codigo = m.codigo
      /*como no hago cuenta de grupo no se agrupa*/
      ORDER BY e.netapa, c.nombre;
   etc etapas_ciclistas%rowtype;
   nombre_antiguo CICLISTA.NOMBRE%type;
   num_maillots NUMBER := 0;
   v_color MAILLOT.COLOR%TYPE;
BEGIN
   FOR etc IN etapas_ciclistas LOOP
      DBMS_OUTPUT.PUT_LINE(etc.etapa);
      IF nombre_antiguo = etc.nombre THEN
         num_maillots := num_maillots +1;
         v_color := v_color ||', '|| etc.color;
      ELSE 
         DBMS_OUTPUT.PUT_LINE(nombre_antiguo || ': ' || num_maillots ||' '|| v_color);
         nombre_antiguo := '';
         num_maillots := 0;
      END IF;
      nombre_antiguo := etc.nombre;
   END LOOP; 
END;



DECLARE
    numMaillot NUMBER := 3;
	colorMaillot MAILLOT.COLOR%TYPE := 'morado';
BEGIN
    etapa_ciclista_num_colores(numMaillot, colorMaillot);
END;
