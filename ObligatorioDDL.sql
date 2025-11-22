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

-- JUGADOR
INSERT INTO jugador VALUES ('michp', 'Michel Pintos', 'mp@gmail.com', TO_DATE('01/06/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('letik', 'Leticia Zadikian', 'lk@gmail.com', TO_DATE('15/07/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('paud10', 'Paulina Danten', 'pd10@gmail.com', TO_DATE('10/08/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('franva', 'Francisco Vazquez', 'fv@gmail.com', TO_DATE('20/05/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('melik', 'Melissa Kuza', 'mk@gmail.com', TO_DATE('25/07/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('matsal','Mateus Salmon','ms@gmail.com', TO_DATE('01/07/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('julisch', 'Juliana Schneck', 'js@gmail.com', TO_DATE('02/11/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('camica',  'Camila Canabez', 'cc@gmail.com', TO_DATE('03/09/2025','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('franrod', 'Francesca Rodriguez', 'fr@gmail.com', TO_DATE('15/05/2024','DD/MM/YYYY'));
INSERT INTO jugador VALUES ('vickyvaz','Victoria Vazquez', 'vv@gmail.com', TO_DATE('01/10/2025','DD/MM/YYYY'));

-- PAIS
INSERT INTO pais VALUES (100, 'Uruguay');
INSERT INTO pais VALUES (101, 'Brasil');
INSERT INTO pais VALUES (102, 'Argentina');
INSERT INTO pais VALUES (103, 'Chile');
INSERT INTO pais VALUES (104, 'Peru');
INSERT INTO pais VALUES (105, 'Colombia');
INSERT INTO pais VALUES (106, 'Mexico');

-- RECURSO
INSERT INTO recurso VALUES (1, 'A', 'PBN');
INSERT INTO recurso VALUES (2, 'M', 'PBN');
INSERT INTO recurso VALUES (3, 'R', 'PBN');
INSERT INTO recurso VALUES (10, 'H', 'CONSTRUCCION');
INSERT INTO recurso VALUES (11, 'CE', 'CONSTRUCCION');
INSERT INTO recurso VALUES (12, 'AL', 'CONSTRUCCION');
INSERT INTO recurso VALUES (13, 'PL', 'CONSTRUCCION');
INSERT INTO recurso VALUES (14, 'CO', 'CONSTRUCCION');
INSERT INTO recurso VALUES (15, 'CB', 'CONSTRUCCION');
INSERT INTO recurso VALUES (20, 'P', 'CONSUMO');
INSERT INTO recurso VALUES (21, 'CA', 'CONSUMO');
INSERT INTO recurso VALUES (22, 'ALI', 'CONSUMO');
INSERT INTO recurso VALUES (23, 'ELEC', 'CONSUMO');

-- PARTIDA
INSERT INTO partida VALUES (1, 100, TO_DATE('10/01/2025', 'DD/MM/YYYY'), 1500);
INSERT INTO partida VALUES (1, 101, TO_DATE('10/01/2025', 'DD/MM/YYYY'), 1500);
INSERT INTO partida VALUES (1, 102, TO_DATE('10/01/2025', 'DD/MM/YYYY'), 1500);
INSERT INTO partida VALUES (2, 103, TO_DATE('01/11/2025', 'DD/MM/YYYY'), 500);
INSERT INTO partida VALUES (2, 100, TO_DATE('01/11/2025', 'DD/MM/YYYY'), 500);
INSERT INTO partida VALUES (3, 101, TO_DATE('21/11/2025', 'DD/MM/YYYY'), 500);
INSERT INTO partida VALUES (3, 102, TO_DATE('21/11/2025', 'DD/MM/YYYY'), 500);
INSERT INTO partida VALUES (4, 103, TO_DATE('20/10/2025', 'DD/MM/YYYY'), 2000);
INSERT INTO partida VALUES (4, 100, TO_DATE('20/10/2025', 'DD/MM/YYYY'), 2000);
INSERT INTO partida VALUES (4, 104, TO_DATE('20/10/2025', 'DD/MM/YYYY'), 2000);
INSERT INTO partida VALUES (5, 105, TO_DATE('05/11/2025','DD/MM/YYYY'), 700);
INSERT INTO partida VALUES (5, 106, TO_DATE('05/11/2025','DD/MM/YYYY'), 700);
INSERT INTO partida VALUES (6, 100, TO_DATE('10/10/2025','DD/MM/YYYY'), 1200);
INSERT INTO partida VALUES (6, 101, TO_DATE('10/10/2025','DD/MM/YYYY'), 1200);
INSERT INTO partida VALUES (7, 102, TO_DATE('02/11/2025','DD/MM/YYYY'), 2000);
INSERT INTO partida VALUES (7, 104, TO_DATE('02/11/2025','DD/MM/YYYY'), 2000);
INSERT INTO partida VALUES (8, 100, TO_DATE('18/11/2025','DD/MM/YYYY'), 900);

-- PAISPARTIDAJUGADOR
INSERT INTO paisPartidaJugador VALUES (1, 100, 'michp', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (1, 101, 'letik', 'INVITADO');
INSERT INTO paisPartidaJugador VALUES (1, 102, 'paud10', 'SE UNIO');
INSERT INTO paisPartidaJugador VALUES (2, 103, 'franva', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (2, 100, 'melik', 'INVITADO');
INSERT INTO paisPartidaJugador VALUES (3, 101, 'michp', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (3, 102, 'letik', 'SE UNIO');
INSERT INTO paisPartidaJugador VALUES (4, 103, 'paud10', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (4, 104, 'franva', 'INVITADO');
INSERT INTO paisPartidaJugador VALUES (4, 100, 'matsal', 'SE UNIO');
INSERT INTO paisPartidaJugador VALUES (5, 105, 'julisch', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (5, 106, 'camica',  'INVITADO');
INSERT INTO paisPartidaJugador VALUES (6, 100, 'michp',   'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (6, 101, 'franrod', 'SE UNIO');
INSERT INTO paisPartidaJugador VALUES (7, 102, 'paud10', 'INVITADO');
INSERT INTO paisPartidaJugador VALUES (7, 104, 'franva', 'ANFITRION');
INSERT INTO paisPartidaJugador VALUES (7, 104, 'vickyvaz', 'SE UNIO');
INSERT INTO paisPartidaJugador VALUES (8, 100, 'michp', 'ANFITRION');

-- INVENTARIORECURSO
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 1, 100);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 10, 500);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 11, 500);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 12, 500);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 13, 500);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 14, 500);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 15, 500);
INSERT INTO inventarioRecurso VALUES (1, 100, 'michp', 23, 1000);
INSERT INTO inventarioRecurso VALUES (1, 101, 'letik', 10, 150);
INSERT INTO inventarioRecurso VALUES (1, 101, 'letik', 11, 200);
INSERT INTO inventarioRecurso VALUES (1, 102, 'paud10', 10, 100);
INSERT INTO inventarioRecurso VALUES (1, 102, 'paud10', 11, 250);
INSERT INTO inventarioRecurso VALUES (1, 102, 'paud10', 20, 300);
INSERT INTO inventarioRecurso VALUES (2, 103, 'franva', 20, 1000);
INSERT INTO inventarioRecurso VALUES (2, 103, 'franva', 21, 1000);
INSERT INTO inventarioRecurso VALUES (2, 100, 'melik', 20, 500);
INSERT INTO inventarioRecurso VALUES (2, 100, 'melik', 10, 50);
INSERT INTO inventarioRecurso VALUES (3, 101, 'michp', 10, 100);
INSERT INTO inventarioRecurso VALUES (3, 102, 'letik', 11, 100);
INSERT INTO inventarioRecurso VALUES (5, 105, 'julisch', 20, 300);
INSERT INTO inventarioRecurso VALUES (5, 105, 'julisch', 21, 400);
INSERT INTO inventarioRecurso VALUES (5, 106, 'camica', 20, 5);
INSERT INTO inventarioRecurso VALUES (5, 106, 'camica', 10, 8);
INSERT INTO inventarioRecurso VALUES (6, 100, 'michp', 10, 50);
INSERT INTO inventarioRecurso VALUES (6, 100, 'michp', 11, 50);
INSERT INTO inventarioRecurso VALUES (6, 101, 'franrod', 10, 500);
INSERT INTO inventarioRecurso VALUES (6, 101, 'franrod', 11, 300);
INSERT INTO inventarioRecurso VALUES (7, 102, 'paud10', 20, 1000);
INSERT INTO inventarioRecurso VALUES (7, 102, 'paud10', 10, 5);
INSERT INTO inventarioRecurso VALUES (7, 104, 'franva', 20, 10);
INSERT INTO inventarioRecurso VALUES (7, 104, 'franva', 11, 2);
INSERT INTO inventarioRecurso VALUES (7, 104, 'vickyvaz', 20, 50);
INSERT INTO inventarioRecurso VALUES (8, 100, 'michp', 10, 300);

-- CONSTRUCCION
INSERT INTO construccion VALUES (3, 101, 'michp', 10, 101, 'PUERTO', 'CONSUME', 50);
INSERT INTO construccion VALUES (3, 102, 'letik', 11, 102, 'USINAS', 'CONSUME', 50);
INSERT INTO construccion VALUES (1, 100, 'michp', 10, 103, 'PUERTO', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 11, 104, 'ASTILLERO', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 10, 201, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 11, 202, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 12, 203, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 13, 204, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 14, 205, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (1, 100, 'michp', 15, 206, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (2, 103, 'franva', 20, 301, 'USINAS', 'PRODUCE', 500);
INSERT INTO construccion VALUES (2, 103, 'franva', 20, 302, 'USINAS', 'CONSUME', 100);
INSERT INTO construccion VALUES (2, 103, 'franva', 21, 303, 'PLANTACION', 'PRODUCE', 300);
INSERT INTO construccion VALUES (2, 103, 'franva', 21, 304, 'PLANTACION', 'CONSUME', 150);
INSERT INTO construccion VALUES (2, 100, 'melik', 20, 305, 'USINAS', 'PRODUCE', 100);
INSERT INTO construccion VALUES (2, 100, 'melik', 20, 306, 'USINAS', 'CONSUME', 200);
INSERT INTO construccion VALUES (1, 100, 'michp', 23, 401, 'USINAS', 'PRODUCE', 100);
INSERT INTO construccion VALUES (1, 100, 'michp', 23, 402, 'USINAS', 'PRODUCE', 100);
INSERT INTO construccion VALUES (5, 105, 'julisch', 20, 501, 'PUERTO', 'CONSUME', 20);
INSERT INTO construccion VALUES (5, 105, 'julisch', 21, 502, 'ASTILLERO', 'PRODUCE', 40);
INSERT INTO construccion VALUES (5, 106, 'camica',  10, 503, 'PLANTACION', 'CONSUME', 10);
INSERT INTO construccion VALUES (6, 100, 'michp', 10, 601, 'PUERTO', 'CONSUME', 30);
INSERT INTO construccion VALUES (6, 100, 'michp', 11, 602, 'ASTILLERO', 'CONSUME', 30);
INSERT INTO construccion VALUES (6, 100, 'michp', 10, 603, 'PLANTACION', 'CONSUME', 30);
INSERT INTO construccion VALUES (6, 100, 'michp', 11, 604, 'PLANTACION', 'CONSUME', 30);
INSERT INTO construccion VALUES (6, 100, 'michp', 11, 605, 'PLANTACION', 'CONSUME', 30);
INSERT INTO construccion VALUES (6, 100, 'michp', 10, 606, 'PLANTACION', 'CONSUME', 30);
INSERT INTO construccion VALUES (6, 101, 'franrod', 10, 607, 'PUERTO', 'CONSUME', 10);
INSERT INTO construccion VALUES (6, 101, 'franrod', 11, 608, 'ASTILLERO', 'CONSUME', 20);
INSERT INTO construccion VALUES (6, 101, 'franrod', 10, 609, 'PLANTACION', 'CONSUME', 5);
INSERT INTO construccion VALUES (6, 101, 'franrod', 11, 610, 'PLANTACION', 'CONSUME', 5);
INSERT INTO construccion VALUES (6, 101, 'franrod', 10, 611, 'PLANTACION', 'CONSUME', 5);
INSERT INTO construccion VALUES (6, 101, 'franrod', 11, 612, 'PLANTACION', 'CONSUME', 5);
INSERT INTO construccion VALUES (7, 102, 'paud10', 10, 701, 'PUERTO', 'CONSUME', 10);
INSERT INTO construccion VALUES (7, 104, 'franva', 11, 702, 'PLANTACION', 'PRODUCE', 20);
INSERT INTO construccion VALUES (7, 104, 'vickyvaz', 20, 703, 'ASTILLERO', 'CONSUME', 8);
INSERT INTO construccion VALUES (8, 100, 'michp',10, 801, 'PLANTACION', 'CONSUME', 25);


--TRUEQUE
INSERT INTO trueque VALUES (1, 1, 100, 'michp', 1, 1, 101, 'letik', 11, 50, 50);
INSERT INTO trueque VALUES (2, 1, 100, 'michp', 10, 1, 102, 'paud10', 20, 10, 50);
INSERT INTO trueque VALUES (3, 1, 102, 'paud10', 10, 1, 100, 'michp', 11, 25, 20);
INSERT INTO trueque VALUES (4, 5, 105, 'julisch', 20, 5, 106, 'camica', 10, 50, 5);
INSERT INTO trueque VALUES (5, 7, 102, 'paud10', 10, 7, 104, 'franva', 11, 2, 5);
INSERT INTO trueque VALUES (6, 7, 104, 'franva', 20, 7, 102, 'paud10', 20, 1, 1);

COMMIT;

--EJERCICIOS

--1
SELECT p.idPais, p.nombrePais
FROM pais p
JOIN paisPartidaJugador ppj ON ppj.idPais = p.idPais
JOIN construccion c ON ppj.idPais = c.idPais AND ppj.idPartida = c.idPartida AND ppj.Alias = c.Alias
JOIN inventarioRecurso ir ON ir.idPartida = c.idPartida AND ir.idPais = c.idPais AND ir.Alias = c.Alias AND ir.idRecurso = c.idRecurso
JOIN recurso r ON ir.IdRecurso = r.idRecurso
WHERE r.TipoRecurso = 'CONSTRUCCION' AND (c.TipoConstruccion = 'ASTILLERO' OR c.TipoConstruccion = 'PUERTO')

MINUS

(SELECT p.idPais, p.nombrePais
FROM pais p
JOIN paisPartidaJugador ppj ON ppj.idPais = p.idPais
JOIN construccion c ON ppj.idPais = c.idPais AND ppj.idPartida = c.idPartida AND ppj.Alias = c.Alias
JOIN inventarioRecurso ir ON ir.idPartida = c.idPartida AND ir.idPais = c.idPais AND ir.Alias = c.Alias AND ir.idRecurso = c.idRecurso
JOIN recurso r ON ir.IdRecurso = r.idRecurso
WHERE c.TipoConstruccion = 'ASTILLERO' AND r.TipoRecurso = 'CONSTRUCCION'

INTERSECT

SELECT p.idPais, p.nombrePais
FROM pais p
JOIN paisPartidaJugador ppj ON ppj.idPais = p.idPais
JOIN construccion c ON ppj.idPais = c.idPais AND ppj.idPartida = c.idPartida AND ppj.Alias = c.Alias
JOIN inventarioRecurso ir ON ir.idPartida = c.idPartida AND ir.idPais = c.idPais AND ir.Alias = c.Alias AND ir.idRecurso = c.idRecurso
JOIN recurso r ON ir.IdRecurso = r.idRecurso
WHERE c.TipoConstruccion = 'PUERTO' AND r.TipoRecurso = 'CONSTRUCCION');

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
WHERE r.TipoRecurso = 'PBN';

--3
SELECT j.NombreJugador, j.Alias
FROM jugador j
JOIN paisPartidaJugador ppj ON j.Alias = ppj.Alias
JOIN partida pa ON pa.IdPartida = ppj.IdPartida AND pa.IdPais = ppj.IdPais
WHERE ppj.Rol = 'INVITADO' AND
			pa.FechaCreacion >= ADD_MONTHS(SYSDATE, -3) AND
			pa.ConfiguracionConsumo = (SELECT MAX(ConfiguracionConsumo) FROM partida);

--4
SELECT t.JugadorA
FROM trueque t
JOIN recurso r ON r.IdRecurso = t.IdRecursoA
WHERE r.Nombre = 'H' AND
			t.CantidadRecursoA = (SELECT MIN(t2.CantidadRecursoA)
														FROM trueque t2
														JOIN recurso r2 ON r2.IdRecurso = t2.IdRecursoA
														WHERE r2.Nombre = 'H');

--5 
SELECT j.Alias, j.NombreJugador
FROM jugador j
JOIN paisPartidaJugador ppj ON ppj.Alias = j.Alias
JOIN partida pa ON pa.IdPartida = ppj.IdPartida AND pa.IdPais = ppj.IdPais
WHERE pa.ConfiguracionConsumo > 1000
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
			);

--6
SELECT r.nombre, r.tipoRecurso
FROM recurso r
JOIN inventarioRecurso ir ON ir.idRecurso = r.idRecurso
JOIN construccion c ON c.idPartida = ir.idPartida AND c.idPais = ir.idPais AND c.Alias = ir.alias AND c.idRecurso = ir.idRecurso
JOIN paisPartidaJugador ppj ON ppj.idPartida = ir.idPartida AND ppj.idPais = ir.idPais AND ppj.Alias = ir.Alias
JOIN partida p ON p.idPartida = ppj.idPartida
WHERE
  p.fechaCreacion >= (SYSDATE - 30)
  AND NOT EXISTS (
    SELECT 1
    FROM trueque t
    WHERE (t.IdPartidaA = ppj.IdPartida AND t.IdPaisA = ppj.IdPais AND t.JugadorA = ppj.Alias)
       OR (t.IdPartidaB = ppj.IdPartida AND t.IdPaisB = ppj.IdPais AND t.JugadorB = ppj.Alias)
  )
GROUP BY r.nombre, r.tipoRecurso
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM recurso r2
    JOIN inventarioRecurso ir2 ON ir2.idRecurso = r2.idRecurso
    JOIN construccion c2 ON c2.idPartida = ir2.idPartida AND c2.idPais = ir2.idPais AND c2.Alias = ir2.alias AND c2.idRecurso = ir2.idRecurso
    JOIN paisPartidaJugador ppj2 ON ppj2.idPartida = ir2.idPartida AND ppj2.idPais = ir2.idPais AND ppj2.Alias = ir2.Alias
    JOIN partida p2 ON p2.idPartida = ppj2.idPartida
    WHERE
      p2.fechaCreacion >= (SYSDATE - 30)
      AND NOT EXISTS (
        SELECT 1
        FROM trueque t2
        WHERE (t2.IdPartidaA = ppj2.IdPartida AND t2.IdPaisA = ppj2.IdPais AND t2.JugadorA = ppj2.Alias)
           OR (t2.IdPartidaB = ppj2.IdPartida AND t2.IdPaisB = ppj2.IdPais AND t2.JugadorB = ppj2.Alias)
      )
    GROUP BY r2.nombre, r2.tipoRecurso
);

--7
SELECT DISTINCT ppj.idPartida, pai.nombrePais
FROM pais pai
JOIN paisPartidaJugador ppj ON ppj.idPais = pai.idPais
JOIN inventarioRecurso ir ON ir.idPartida = ppj.idPartida AND ir.idPais = ppj.idPais AND ir.Alias = ppj.Alias
JOIN recurso r ON r.idRecurso = ir.idRecurso
WHERE
    r.tipoRecurso = 'CONSTRUCCION'
    
    AND (
        (
        SELECT SUM(ir3.stockAcumulado)
        FROM inventarioRecurso ir3
        JOIN recurso r3 ON r3.idRecurso = ir3.idRecurso
        JOIN paisPartidaJugador ppj3 ON ir3.idPartida = ppj3.idPartida AND ir3.idPais = ppj3.idPais AND ir3.Alias = ppj3.Alias
        WHERE r3.tipoRecurso = 'CONSTRUCCION'
          AND ppj3.idPartida = ppj.idPartida
          AND ppj3.idPais = ppj.idPais
        )
        <= ALL
        (
        SELECT SUM(ir3.stockAcumulado)
        FROM inventarioRecurso ir3
        JOIN recurso r3 ON r3.idRecurso = ir3.idRecurso
        JOIN paisPartidaJugador ppj3 ON ir3.idPartida = ppj3.idPartida AND ir3.idPais = ppj3.idPais AND ir3.Alias = ppj3.Alias
        WHERE r3.tipoRecurso = 'CONSTRUCCION'
          AND ppj3.idPartida = ppj.idPartida
        GROUP BY ppj3.idPais
        )
    )
    
    AND EXISTS (
        SELECT 1
        FROM trueque t
        JOIN inventarioRecurso ir2 ON (ir2.idPartida = t.idPartidaA AND ir2.idPais = t.idPaisA AND ir2.Alias = t.JugadorA)
                                  OR (ir2.idPartida = t.idPartidaB AND ir2.idPais = t.idPaisB AND ir2.Alias = t.JugadorB)
        JOIN paisPartidaJugador ppj2 ON ir2.idPartida = ppj2.idPartida AND ir2.idPais = ppj2.idPais AND ir2.Alias = ppj2.Alias
        JOIN pais pai2 ON ppj2.idPais = pai2.idPais
        WHERE 
            (t.IdPartidaA = ppj.idPartida)
            AND
            (pai2.nombrePais = 'Uruguay' OR pai2.nombrePais = 'Brasil' OR pai2.nombrePais = 'Argentina')
    );

--8
SELECT DISTINCT ppj.idPartida, pai.nombrePais
FROM pais pai
JOIN paisPartidaJugador ppj ON pai.idPais = ppj.idPais
JOIN inventarioRecurso ir ON ir.idPartida = ppj.idPartida AND ir.idPais = ppj.idPais AND ir.Alias = ppj.Alias
JOIN construccion c ON c.idPartida = ir.idPartida AND c.idPais = ir.idPais AND c.Alias = ir.Alias AND c.idRecurso = ir.idRecurso
JOIN recurso r ON r.idRecurso = ir.idRecurso
WHERE r.tipoRecurso = 'CONSUMO'
    AND NOT EXISTS (
            SELECT 1
            FROM trueque t
            WHERE (t.IdPartidaA = ppj.IdPartida AND t.IdPaisA = ppj.IdPais AND t.JugadorA = ppj.Alias)
               OR (t.IdPartidaB = ppj.IdPartida AND t.IdPaisB = ppj.IdPais AND t.JugadorB = ppj.Alias)
          )
    AND (
        (SELECT SUM(c2.CantidadRecurso)
         FROM construccion c2
         JOIN inventarioRecurso ir2 ON ir2.idPartida = c2.idPartida AND ir2.idPais = c2.idPais AND ir2.Alias = c2.Alias AND ir2.idRecurso = c2.idRecurso
         JOIN recurso r2 ON r2.idRecurso = ir2.idRecurso
         WHERE c2.IdPartida = ppj.IdPartida
           AND c2.IdPais = ppj.IdPais
           AND r2.tipoRecurso = 'CONSUMO'
           AND c2.TipoOperacion = 'PRODUCE'
        )
        >
        (SELECT SUM(c3.CantidadRecurso)
         FROM construccion c3
         JOIN inventarioRecurso ir3 ON ir3.idPartida = c3.idPartida AND ir3.idPais = c3.idPais AND ir3.Alias = c3.Alias AND ir3.idRecurso = c3.idRecurso
         JOIN recurso r3 ON r3.idRecurso = ir3.idRecurso
         WHERE c3.IdPartida = ppj.IdPartida
           AND c3.IdPais = ppj.IdPais
           AND r3.tipoRecurso = 'CONSUMO'
           AND c3.TipoOperacion = 'CONSUME'
        )
    );

--9
WITH cantConsUsinas AS (
    SELECT c.idPartida, c.idPais, c.Alias, COUNT(*) AS cantConstruccionUsinas
    FROM construccion c
    JOIN inventarioRecurso ir ON c.idPartida = ir.idPartida AND c.idPais = ir.idPais AND c.Alias = ir.Alias AND c.idRecurso = ir.idRecurso
    JOIN paisPartidaJugador ppj ON ir.idPartida = ppj.idPartida AND ir.idPais = ppj.idPais AND ir.Alias = ppj.Alias
    WHERE c.tipoConstruccion = 'USINAS'
    GROUP BY c.idPartida, c.idPais, c.Alias
),

cantCons AS (
    SELECT c.idPartida, c.idPais, c.Alias, COUNT(*) AS cantConstruccion
    FROM construccion c
    JOIN inventarioRecurso ir ON c.idPartida = ir.idPartida AND c.idPais = ir.idPais AND c.Alias = ir.Alias AND c.idRecurso = ir.idRecurso
    JOIN paisPartidaJugador ppj ON ir.idPartida = ppj.idPartida AND ir.idPais = ppj.idPais AND ir.Alias = ppj.Alias
    GROUP BY c.idPartida, c.idPais, c.Alias
),

stockAc AS (
    SELECT ppj3.idPais, ppj3.idPartida, ppj3.Alias, SUM(ir3.stockAcumulado) AS suma
    FROM inventarioRecurso ir3
    JOIN recurso r3 ON r3.idRecurso = ir3.idRecurso
    JOIN paisPartidaJugador ppj3 ON ir3.idPartida = ppj3.idPartida AND ir3.idPais = ppj3.idPais AND ir3.Alias = ppj3.Alias
    GROUP BY ppj3.idPais, ppj3.idPartida, ppj3.Alias
),

cantTruequesB AS (
    SELECT t.idPaisB, t.idPartidaB, t.JugadorB, COUNT(*) AS cantTB
    FROM trueque t
    GROUP BY t.idPaisB, t.idPartidaB, t.JugadorB
)

SELECT par.*, pai.*, j.alias, j.nombreJugador, ppj.rol,
    CASE
        WHEN ppj.rol = 'ANFITRION' THEN 'Creador de la partida'
        WHEN ppj.rol = 'INVITADO' THEN 'Invitado por el anfitrion'
        WHEN ppj.rol = 'SE UNIO' THEN 'Se unio voluntariamente'
    END AS Descripcion,
    NVL(ccu.cantConstruccionUsinas, 0) AS cantConstruccionUsinas, ((NVL(ccu.cantConstruccionUsinas, 0) * 100) / NVL(cc.cantConstruccion, 1)) AS porcentaje,
    CASE
        WHEN ppj.rol = 'ANFITRION' THEN NVL(sa.suma, 0)
        WHEN ppj.rol = 'INVITADO' THEN NVL(cc.cantConstruccion, 0)
        WHEN ppj.rol = 'SE UNIO' THEN NVL(ctb.cantTB, 0)
    END AS Extra
FROM partida par
JOIN paisPartidaJugador ppj ON ppj.idPartida = par.idPartida AND ppj.idPais = par.idPais
JOIN pais pai ON pai.idPais = ppj.idPais
JOIN jugador j ON j.alias = ppj.alias
LEFT JOIN cantConsUsinas ccu ON ppj.idPartida = ccu.idPartida AND ppj.idPais = ccu.idPais AND ppj.Alias = ccu.Alias
LEFT JOIN cantCons cc ON ppj.idPartida = cc.idPartida AND ppj.idPais = cc.idPais AND ppj.Alias = cc.Alias
LEFT JOIN stockAc sa ON ppj.idPartida = sa.idPartida AND ppj.idPais = sa.idPais AND ppj.Alias = sa.Alias
LEFT JOIN cantTruequesB ctb ON ppj.idPartida = ctb.idPartidaB AND ppj.idPais = ctb.idPaisB AND ppj.Alias = ctb.jugadorB
WHERE par.fechaCreacion >= '01/01/2025';

--10
WITH tabPartidas AS (
    SELECT r.idRecurso, COUNT(DISTINCT ir.idPartida) AS cantPartidas
    FROM recurso r
    JOIN inventarioRecurso ir ON ir.idRecurso = r.idRecurso
    JOIN paisPartidaJugador ppj ON ppj.idPartida = ir.idPartida AND ppj.idPais = ir.idPais AND ppj.Alias = ir.Alias
    JOIN partida par ON par.idPartida = ppj.idPartida AND par.idPais = ppj.idPais
    WHERE par.fechaCreacion >= (SYSDATE - 15) 
    GROUP BY r.idRecurso
),

tabConstrucciones AS (
    SELECT c.idRecurso, COUNT(*) AS cantConstrucciones
    FROM construccion c
    GROUP BY c.idRecurso
),

countPais AS (
    SELECT ir.idRecurso, pai.nombrePais, COUNT(*) AS cantRec
    FROM inventarioRecurso ir
    JOIN paisPartidaJugador ppj ON ppj.idPartida = ir.idPartida AND ppj.idPais = ir.idPais AND ppj.Alias = ir.Alias
    JOIN pais pai ON pai.idPais = ppj.idPais
    GROUP BY ir.idRecurso, pai.nombrePais
)

SELECT r.nombre AS recurso, 
        NVL(tp.cantPartidas, 0) AS cantPartidas,
        NVL(tc.cantConstrucciones, 0) AS cantConstrucciones,
        CASE
            WHEN tc.cantConstrucciones IS NULL THEN 'NO HAY'
            ELSE cpMin.nombrePais
        END AS minPais,
        CASE
            WHEN tc.cantConstrucciones IS NULL THEN 'NO HAY'
            ELSE cpMax.nombrePais
        END AS maxPais
FROM recurso r
LEFT JOIN tabPartidas tp ON tp.idRecurso = r.idRecurso
LEFT JOIN tabConstrucciones tc ON tc.idRecurso = r.idRecurso
LEFT JOIN countPais cpMin ON cpMin.idRecurso = r.idRecurso 
LEFT JOIN countPais cpMax ON cpMax.idRecurso = r.idRecurso
WHERE cpMin.cantRec = (SELECT MIN(cantRec) FROM countPais WHERE r.idRecurso = idRecurso) 
    AND cpMax.cantRec = (SELECT MAX(cantRec) FROM countPais WHERE r.idRecurso = idRecurso);


