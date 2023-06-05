/*1. Garantice mediante triggers que se anotará correctamente en la BD a quien se le ha asignado
el maillot morado en esa etapa, que siempre corresponde al ganador de la etapa
(2 puntos)*/

CREATE OR REPLACE TRIGGER MaillotMorado
AFTER INSERT OR UPDATE OF dorsal 
ON etapa 
FOR EACH ROW 
BEGIN
   INSERT INTO llevar VALUES(:NEW.dorsal, :NEW.netapa, (SELECT m.codigo
                                                      FROM maillot m 
                                                      WHERE m.color = 'morado'));
END;

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


CREATE OR REPLACE FUNCTION asignarMaillot(codigo_maillot MAILLOT.CODIGO%TYPE, v_dorsal CICLISTA.DORSAL%TYPE,
v_netapa ETAPA.NETAPA%TYPE)RETURN BOOLEAN IS
   v_color MAILLOT.COLOR%TYPE;
   v_ganador_etapa CICLISTA.DORSAL%TYPE;
   v_posible BOOLEAN;
BEGIN
   SELECT color INTO v_color
   FROM maillot
	WHERE codigo = codigo_maillot;

   IF v_color = 'morado' THEN
      SELECT dorsal INTO v_ganador_etapa
      FROM etapa e 
      WHERE e.netapa = v_netapa;

      IF v_ganador_etapa = v_dorsal THEN
         v_posible := TRUE;
      ELSE
         v_posible := FALSE;
      END IF;
   ELSIF v_color = 'azul' THEN
      SELECT e.dorsal INTO v_ganador_etapa
      FROM etapa e, puerto p 
      WHERE e.netapa = p.netapa AND p.pendiente > 8
      GROUP BY e.dorsal
      ORDER BY COUNT(e.dorsal)
      FETCH FIRST 1 ROW ONLY;

      IF v_ganador_etapa = v_dorsal THEN
         v_posible := TRUE;
      ELSE 
         v_posible := FALSE;
      END IF;
   ELSE 
      v_posible := TRUE;
   END IF;

   IF v_posible = TRUE THEN
      INSERT INTO llevar VALUES(v_dorsal, v_netapa, codigo_maillot);
   END IF;
   RETURN v_posible;
END;


--prueba
DECLARE
    devuelve BOOLEAN;
BEGIN
    devuelve := asignarMaillot('MOR',2,2);
	DBMS_OUTPUT.PUT_LINE(CASE devuelve WHEN TRUE THEN 'TRUE' ELSE 'FALSE' END);
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


CREATE OR REPLACE PROCEDURE etapaCiclistas IS
   v_colores MAILLOT.COLOR%TYPE;
   v_ciclista_anterior CICLISTA.NOMBRE%TYPE;
   v_num_maillots NUMBER;
   v_etapa_anterior ETAPA.NETAPA%TYPE;

   CURSOR etapa_ciclista IS
      SELECT e.netapa netapa, c.nombre nombre, m.color color
      FROM etapa e, llevar l, maillot m, ciclista c 
      WHERE e.netapa = l.netapa AND l.dorsal = c.dorsal AND l.codigo = m.codigo
      GROUP BY e.netapa, c.nombre, m.color
      ORDER BY e.netapa, c.nombre; 
   
   v_ciclista etapa_ciclista%ROWTYPE;

BEGIN
   FOR v_ciclista IN etapa_ciclista LOOP
      IF v_ciclista.netapa != v_etapa_anterior THEN
         DBMS_OUTPUT.PUT_LINE(v_ciclista.netapa);
      END IF;

      IF v_ciclista.nombre != v_ciclista_anterior THEN
         DBMS_OUTPUT.PUT_LINE(v_ciclista_anterior || v_colores);
		   DBMS_OUTPUT.PUT_LINE(v_num_maillots);
         v_ciclista_anterior := v_ciclista.nombre;
         v_num_maillots := 0;
      ELSE 
         v_colores := v_colores || v_ciclista.color;
         v_num_maillots := v_num_maillots +1;
      END IF;
   END LOOP;   
END;


--prueba
begin
    etapaCiclistas();
end;