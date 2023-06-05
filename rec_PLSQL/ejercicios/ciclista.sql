CREATE TABLE equipo(
    nomeq VARCHAR2(50),
    descripcion VARCHAR2(50),
    CONSTRAINT eq_nom_pk PRIMARY KEY(nomeq)
);

CREATE TABLE ciclista(
    dorsal NUMBER,
    nombre VARCHAR2(50),
    edad NUMBER,
    nomeq VARCHAR2(50),
    CONSTRAINT ci_do_pk PRIMARY KEY(dorsal),
    CONSTRAINT ci_nom_fk FOREIGN KEY(nomeq) REFERENCES equipo(nomeq)
);

CREATE TABLE etapa(
    netapa NUMBER,
    km NUMBER,
    salida VARCHAR2(20),
    llegada VARCHAR2(20),
    dorsal NUMBER,
    CONSTRAINT et_dor_fk FOREIGN KEY(dorsal) REFERENCES ciclista(dorsal),
    CONSTRAINT et_ne_pk PRIMARY KEY(netapa)
);

CREATE TABLE puerto(
    nompuerto VARCHAR2(50),
    altura NUMBER,
    categoria VARCHAR2(1),
    pendiente NUMBER,
    netapa NUMBER,
    dorsal NUMBER,
    CONSTRAINT pu_nom_pk PRIMARY KEY(nompuerto),
    CONSTRAINT pu_ne_fk FOREIGN KEY(netapa) REFERENCES etapa(netapa),
    CONSTRAINT pu_do_fk FOREIGN KEY(dorsal) REFERENCES ciclista(dorsal)
);

CREATE TABLE maillot(
    codigo VARCHAR2(5),
    tipo VARCHAR2(20),
    color VARCHAR2(50),
    premio NUMBER,
    CONSTRAINT ma_cod_pk PRIMARY KEY(codigo)
);

CREATE TABLE llevar(
    dorsal NUMBER,
    netapa NUMBER,
    codigo VARCHAR(5),
    CONSTRAINT ll_ne_fk FOREIGN KEY(netapa) REFERENCES etapa(netapa),
    CONSTRAINT ll_dor_fk FOREIGN KEY(dorsal) REFERENCES ciclista(dorsal),
    CONSTRAINT ll_cod_fk FOREIGN KEY(codigo) REFERENCES maillot(codigo)
);


insert into equipo values('Amore Vita','Ricardo Padacci');
insert into equipo values('Banesto','Miguel EchevarrÃ­a');
insert into equipo values('Bresciali-Refin','Pietro Armani');
insert into equipo values('Carrera','Luigi Petroni');
insert into equipo values('Gatorade','Gian Luca Pacceli');
insert into equipo values('Kelme','Ãlvaro Pino');
insert into equipo values('Mapei-Clas','Juan FernÃ¡ndez');
insert into equipo values('Navigare','Lorenzo Sciacci');
insert into equipo values('Telecom','Morgan Reikacrd');
insert into equipo values('TVM','Steevens Henk');

insert into ciclista values(1,'Miguel Indurain',21,'Banesto');
insert into ciclista values(2,'Pedro Delgado',29,'Banesto');
insert into ciclista values(3,'Alex Zulle',20,'Navigare');
insert into ciclista values(4,'Alessio Di Basco',30,'TVM');
insert into ciclista values(5,'Armand',17,'Amore Vita');
insert into ciclista values(8,'Jean Van Poppel',24,'Bresciali-Refin');
insert into ciclista values(9,'Maximo Podel',17,'Telecom');
insert into ciclista values(10,'Mario Cipollini',31,'Carrera');
insert into ciclista values(11,'Eddy Seigneur',20,'Amore Vita');
insert into ciclista values(12,'Alessio Di Basco',34,'Bresciali-Refin');
insert into ciclista values(13,'Gianni Bugno',24,'Gatorade');
insert into ciclista values(15,'JesÃºs Montoya',25,'Amore Vita');
insert into ciclista values(16,'Dimitri Konishev',27,'Amore Vita');
insert into ciclista values(17,'Bruno Lealli',30,'Amore Vita');
insert into ciclista values(20,'Alfonso GutiÃ©rrez',27,'Navigare');
insert into ciclista values(22,'Giorgio Furlan',22,'Kelme');
insert into ciclista values(26,'Mikel Zarrabeitia',30,'Carrera');
insert into ciclista values(27,'Laurent Jalabert',22,'Banesto');
insert into ciclista values(30,'Melchor Mauri',26,'Mapei-Clas');
insert into ciclista values(31,'Per Pedersen',33,'Banesto');
insert into ciclista values(32,'Tony Rominger',31,'Kelme');
insert into ciclista values(33,'Stefenao della Sveitia',26,'Amore Vita');
insert into ciclista values(34,'Clauido Chiapucci',23,'Amore Vita');
insert into ciclista values(35,'Gian Mateo Faluca',34,'TVM');

insert into etapa values(1,35,'Valladolid','Ãvila',1);
insert into etapa values(2,70,'Salamanca','Zamora',2);
insert into etapa values(3,150,'Zamora','Almendralejo',1);
insert into etapa values(4,330,'CÃ³rdoba','Granada',1);
insert into etapa values(5,150,'Granada','AlmerÃ­a',3);

insert into puerto values('p1',2489,'1',34,2,3);
insert into puerto values('p2',2789,'1',44,4,3);
insert into puerto values('Puerto F',2500,'E',17,4,2);
insert into puerto values('Puerto fff',2500,'E',17,4,2);
insert into puerto values('Puerto nuevo1',2500,'a',17,4,1);
insert into puerto values('Puerto otro',2500,'E',17,4,1);
insert into puerto values('Puerto1',2500,'E',23,1,2);

insert into maillot values('MGE','General','Amarillo',1000000);
insert into maillot values('MMO','MontaÃ±a','Blanco y rojo',500000);
insert into maillot values('MMS','MÃ¡s sufrido','Estrellitas rojas',400000);
insert into maillot values('MMV','Metas volantes','Rojo',400000);
insert into maillot values('MRE','Regularidad','Verde',300000);
insert into maillot values('MSE','Sprint especial','Rosa',300000);
insert into maillot values('MOR','Sprint especial','morado',200000);--insertar maillot morado
insert into maillot values('AZ','Sprint especial','azul',500000);--insertar maillot azul

insert into llevar values(1,3,'MGE');
insert into llevar values(1,4,'MGE');
insert into llevar values(2,2,'MGE');
insert into llevar values(3,1,'MGE');
insert into llevar values(3,1,'MMV');
insert into llevar values(3,4,'MRE');
insert into llevar values(4,1,'MMO');