ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';
DROP TABLE trueque;
DROP TABLE construccion;
DROP TABLE inventarioRecurso;
DROP TABLE recurso;
DROP TABLE paisPartidaJugador;
DROP TABLE partida;
DROP TABLE pais;
DROP TABLE jugador;

CREATE TABLE jugador ( 
	Alias VARCHAR2(30) PRIMARY KEY, 
	NombreJugador VARCHAR2(30) NOT NULL, 
	Email VARCHAR2(20) NOT NULL UNIQUE,
    FechaRegistro DATE NOT NULL);

CREATE TABLE pais ( 
	IdPais NUMBER(3) NOT NULL CONSTRAINT pais_pk PRIMARY KEY, 
	NombrePais VARCHAR2(50) NOT NULL UNIQUE);

CREATE TABLE partida ( 
	IdPartida NUMBER(8) NOT NULL, 
	IdPais NUMBER(3) NOT NULL, 
	FechaCreacion DATE NOT NULL,
    ConfiguracionConsumo NUMBER(5),
    CONSTRAINT partida_pk PRIMARY KEY (IdPartida,IdPais),
	CONSTRAINT partida_to_pais_fk FOREIGN KEY (IdPais) REFERENCES pais(IdPais));
	
CREATE TABLE paisPartidaJugador ( 
	IdPartida NUMBER(8) NOT NULL, 
	IdPais NUMBER(3) NOT NULL, 
	Alias VARCHAR2(30) NOT NULL, 
	Rol VARCHAR2(10) NOT NULL,
    CONSTRAINT ppj_pk PRIMARY KEY (IdPartida,IdPais,Alias),
    CONSTRAINT ppj_to_partida_fk FOREIGN KEY (IdPartida,IdPais) REFERENCES partida(IdPartida,IdPais),
	CONSTRAINT ppj_to_jugador_fk FOREIGN KEY (Alias) REFERENCES jugador(Alias),
	CONSTRAINT rol_chk CHECK (Rol IN('INVITADO','ANFITRION','SE UNIO')));
	
CREATE TABLE recurso ( 
	IdRecurso NUMBER(5) PRIMARY KEY,
	Nombre VARCHAR2(40) NOT NULL, 
	TipoRecurso VARCHAR2(20) NOT NULL, 
	CONSTRAINT tipo_rec_chk CHECK (TipoRecurso IN('PBN','CONSTRUCCION','CONSUMO')));

CREATE TABLE inventarioRecurso ( 
    IdPartida NUMBER(8) NOT NULL, 
	IdPais NUMBER(3) NOT NULL, 
	Alias VARCHAR2(30) NOT NULL,
	IdRecurso NUMBER(5) NOT NULL,
	StockAcumulado NUMBER(8) DEFAULT 0 NOT NULL,
	CONSTRAINT uso_rec_pk PRIMARY KEY (IdPartida,IdPais,Alias,IdRecurso),
    CONSTRAINT uso_rec_to_ppj_fk FOREIGN KEY (IdPartida,IdPais,Alias) REFERENCES paisPartidaJugador(IdPartida,IdPais,Alias),
	CONSTRAINT uso_rec_to_recurso_fk FOREIGN KEY (IdRecurso) REFERENCES recurso(IdRecurso));

CREATE TABLE construccion ( 
    IdPartida NUMBER(8) NOT NULL, 
	IdPais NUMBER(3) NOT NULL, 
	Alias VARCHAR2(30) NOT NULL,
	IdRecurso NUMBER(5) NOT NULL,
	IdConstruccion NUMBER(5) NOT NULL,
	TipoConstruccion VARCHAR2(15) NOT NULL,
    TipoOperacion VARCHAR2(8) NOT NULL,
    CantidadRecurso NUMBER(8) NOT NULL,
	CONSTRAINT construccion_pk PRIMARY KEY (IdPartida,IdPais,Alias,IdRecurso,IdConstruccion),
    CONSTRAINT construccion_to_uso_rec_fk FOREIGN KEY (IdPartida,IdPais,Alias,IdRecurso) REFERENCES inventarioRecurso(IdPartida,IdPais,Alias,IdRecurso),
	CONSTRAINT tipo_cons_chk CHECK (TipoConstruccion IN('PUERTO','ASTILLERO','PLANTACION','USINAS')),
    CONSTRAINT tipo_op_chk CHECK (TipoOperacion IN('CONSUME','PRODUCE')));

CREATE TABLE trueque ( 
    IdTrueque NUMBER(8) NOT NULL CONSTRAINT trueque_pk PRIMARY KEY,
    IdPartidaA NUMBER(8) NOT NULL, 
    IdPaisA NUMBER(3) NOT NULL, 
    JugadorA VARCHAR2(30) NOT NULL,
    IdRecursoA NUMBER(5) NOT NULL,
    IdPartidaB NUMBER(8) NOT NULL,
    IdPaisB NUMBER(3) NOT NULL, 
    JugadorB VARCHAR2(30) NOT NULL,
    IdRecursoB NUMBER(5) NOT NULL,
    CantidadRecursoA NUMBER(8) NOT NULL,
    CantidadRecursoB NUMBER(8) NOT NULL,
    CONSTRAINT trueque_A_to_uso_rec_fk FOREIGN KEY (IdPartidaA,IdPaisA,JugadorA,IdRecursoA) REFERENCES inventarioRecurso(IdPartida,IdPais,Alias,IdRecurso),
    CONSTRAINT trueque_B_to_uso_rec_fk FOREIGN KEY (IdPartidaB,IdPaisB,JugadorB,IdRecursoB) REFERENCES inventarioRecurso(IdPartida,IdPais,Alias,IdRecurso));
    
COMMIT;

--DATOS:

-- PAISES
INSERT INTO pais VALUES (1, 'Uruguay');
INSERT INTO pais VALUES (2, 'Peru');
INSERT INTO pais VALUES (3, 'Argentina');
INSERT INTO pais VALUES (4, 'Brasil');

-- JUGADORES
INSERT INTO jugador VALUES ('michp', 'Michel Pintos', 'mp@email.com', TO_DATE('01/06/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('letik', 'Leticia Zadikian', 'lk@email.com', TO_DATE('15/07/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('paud10', 'Paulina Danten', 'pd10@email.com', TO_DATE('10/08/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('franva', 'Francisco Vazquez', 'fv@email.com', TO_DATE('20/05/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('melik', 'Melissa Kuza', 'mk@email.com', TO_DATE('25/07/2025','DD/MM/YYYY'));

-- PARTIDAS
INSERT INTO partida VALUES (101, 1, TO_DATE('01/09/2025','DD/MM/YYYY'), 1200);
INSERT INTO partida VALUES (102, 2, TO_DATE('15/09/2025','DD/MM/YYYY'), 900);
INSERT INTO partida VALUES (103, 3, TO_DATE('20/08/2025','DD/MM/YYYY'), 1500);
INSERT INTO partida VALUES (104, 4, TO_DATE('25/06/2025','DD/MM/YYYY'), 1100);

-- PAISPARTIDAJUGADOR
INSERT INTO paisPartidaJugador VALUES (101, 1, 'michp', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (101, 1, 'letik', 'INVITADO');
INSERT INTO paisPartidaJugador VALUES (102, 2, 'paud10', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (102, 2, 'franva', 'SE UNIO');
INSERT INTO paisPartidaJugador VALUES (103, 3, 'melik', 'INVITADO');
INSERT INTO paisPartidaJugador VALUES (103, 3, 'michp', 'SE UNIO');

-- RECURSOS
INSERT INTO recurso VALUES (1, 'Hierro', 'CONSTRUCCION');
INSERT INTO recurso VALUES (2, 'Madera', 'CONSTRUCCION');
INSERT INTO recurso VALUES (3, 'Trigo', 'CONSUMO');
INSERT INTO recurso VALUES (4, 'Papel', 'PBN');

-- INVENTARIO RECURSO
INSERT INTO inventarioRecurso VALUES (101, 1, 'michp', 1, 500);
INSERT INTO inventarioRecurso VALUES (101, 1, 'letik', 2, 300);
INSERT INTO inventarioRecurso VALUES (102, 2, 'paud10', 1, 400);
INSERT INTO inventarioRecurso VALUES (102, 2, 'franva', 3, 200);
INSERT INTO inventarioRecurso VALUES (103, 3, 'melik', 2, 350);
INSERT INTO inventarioRecurso VALUES (103, 3, 'michp', 3, 150);

-- CONSTRUCCIONES
INSERT INTO construccion VALUES (101, 1, 'michp', 1, 1, 'PUERTO', 'CONSUME', 100);
INSERT INTO construccion VALUES (101, 1, 'letik', 2, 2, 'ASTILLERO', 'PRODUCE', 150);
INSERT INTO construccion VALUES (102, 2, 'paud10', 1, 3, 'PLANTACION', 'CONSUME', 200);
INSERT INTO construccion VALUES (103, 3, 'melik', 2, 4, 'USINAS', 'CONSUME', 50);
INSERT INTO construccion VALUES (103, 3, 'michp', 3, 5, 'USINAS', 'PRODUCE', 300);

-- TRUEQUES
INSERT INTO trueque VALUES (1, 101, 1, 'michp', 1, 102, 2, 'paud10', 1, 50, 50);
INSERT INTO trueque VALUES (2, 102, 2, 'franva', 3, 103, 3, 'melik', 2, 20, 30);

COMMIT;

--EJERCICIOS

--1
SELECT p.*
FROM pais p
JOIN construccion c ON p.IdPais = c.IdPais
JOIN recurso r ON c.IdRecurso = r.IdRecurso
WHERE (c.TipoConstruccion = 'ASTILLERO' OR c.TipoConstruccion = 'PUERTO') 
       AND r.TipoRecurso = 'CONSTRUCCION'

MINUS

(SELECT p.*
FROM pais p
JOIN construccion c ON p.IdPais = c.IdPais
JOIN recurso r ON c.IdRecurso = r.IdRecurso
WHERE c.TipoConstruccion = 'ASTILLERO' AND r.TipoRecurso = 'CONSTRUCCION'

INTERSECT

SELECT p.*
FROM pais p
JOIN construccion c ON p.IdPais = c.IdPais
JOIN recurso r ON c.IdRecurso = r.IdRecurso
WHERE c.TipoConstruccion = 'PUERTO' AND r.TipoRecurso = 'CONSTRUCCION')

--2
SELECT pa.IdPartida, pais.NombrePais, pa.FechaCreacion, ppj.Alias
FROM paisPartidaJugador ppj
JOIN partida pa ON pa.IdPartida = ppj.IdPartida AND pa.IdPais = ppj.IdPais
JOIN pais pais ON pais.IdPais = ppj.IdPais

MINUS

SELECT pa.IdPartida, pais.NombrePais, pa.FechaCreacion, ppj.Alias
FROM paisPartidaJugador ppj
JOIN partida pa ON pa.IdPartida = ppj.IdPartida AND pa.IdPais = ppj.IdPais
JOIN pais pais ON pais.IdPais = ppj.IdPais
JOIN trueque t ON (t.IdPartidaA = ppj.IdPartida AND t.IdPaisA = ppj.IdPais AND t.JugadorA = ppj.Alias) OR
								(t.IdPartidaB = ppj.IdPartida AND t.IdPaisB = ppj.IdPais AND t.JugadorB = ppj.Alias)
JOIN recurso r ON t.IdRecursoA = r.IdRecurso OR t.IdRecursoB = r.IdRecurso
WHERE r.TipoRecurso = 'PBN'

--3
SELECT j.NombreJugador, j.Alias
FROM jugador j
JOIN paisPartidaJugador ppj ON j.Alias = ppj.Alias
JOIN partida pa ON pa.IdPartida = ppj.IdPartida AND pa.IdPais = ppj.IdPais
WHERE ppj.Rol = 'INVITADO' AND
			pa.FechaCreacion >= DATEADD(month, -3, GETDATE()) AND
			pa.ConfiguracionConsumo = (SELECT MAX(ConfiguracionConsumo) FROM partida)

--4
SELECT t.JugadorA
FROM trueque t
JOIN recurso r ON r.IdRecurso = t.IdRecursoA
WHERE r.Nombre = 'H' AND
			t.CantidadRecursoA = (SELECT MIN(t2.CantidadRecursoA)
														FROM trueque t2
														JOIN recurso r2 ON r.IdRecurso = t2.IdRecursoA
														WHERE r2.Nombre = 'H')

--5 
SELECT j.Alias, j.Nombre
FROM jugador j
JOIN paisPartidaJugador ppj ON ppj.Alias = j.Alias
JOIN partida pa ON pa.IdPartida = ppj.IdPartida --CREO QUE FALTA pa.IdPais = ppj.IdPais
WHERE	p.ConfiguracionConsumo > 100
			AND NOT EXISTS (
				SELECT 1
				FROM recurso r
				WHERE r.TipoRecurso = 'CONSTRUCCION'
							AND NOT EXISTS (
								SELECT 1
								FROM construccion c
								WHERE ppj.IdPartida = c.IdPartida AND
											ppj.IdPais = c.IdPais AND
											ppj.Alias = c.Alias AND
											r.IdRecurso = c.IdRecurso AND
											c.TipoOperacion = 'CONSUME'
							)
			)