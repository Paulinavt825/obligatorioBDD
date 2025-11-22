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