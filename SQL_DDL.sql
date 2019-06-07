USE top_5_futebol
GO

CREATE SCHEMA gestao_futebol
GO


CREATE TABLE gestao_futebol.jornada(
	data_jogo	  DATE NOT NULL
	PRIMARY KEY(data_jogo)
)

CREATE TABLE gestao_futebol.nacionalidade(
	nome       VARCHAR(50) NOT NULL,
	abreviacao VARCHAR(10) NOT NULL,
	PRIMARY KEY(nome)	
)

CREATE TABLE gestao_futebol.campeonato(
	id         INT NOT NULL IDENTITY(1,1),
	nome		         	VARCHAR(30) NOT NULL,
	nacionalidade			VARCHAR(50) NOT NULL
	PRIMARY KEY(id),
	FOREIGN KEY(nacionalidade) REFERENCES gestao_futebol.nacionalidade(nome)
)

CREATE TABLE gestao_futebol.equipa(
	id         INT NOT NULL IDENTITY(1,1),
	nome       VARCHAR(100) NOT NULL,
	email      VARCHAR(30),
	telefone   INT,
	data_fund  DATE NOT NULL,
	campeonato INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(campeonato) REFERENCES gestao_futebol.campeonato(id)
)

CREATE TABLE gestao_futebol.estadio(
	id         INT NOT NULL IDENTITY(1,1),
	nome       VARCHAR(100) NOT NULL,
	lotacao    INT NOT NULL,
	morada     VARCHAR(200),
	data_crons DATE NOT NULL,
	equipa      INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(equipa) REFERENCES gestao_futebol.equipa(id)
)

CREATE TABLE gestao_futebol.jogo(
	id         INT NOT NULL IDENTITY(1,1),
	n_jornada			   DATE,
	estadio				   INT,
	h_team				   INT NOT NULL,
	a_team				   INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(n_jornada) REFERENCES gestao_futebol.jornada(data_jogo),
	FOREIGN KEY(estadio)   REFERENCES gestao_futebol.estadio(id),
	FOREIGN KEY(h_team)    REFERENCES gestao_futebol.equipa(id),
	FOREIGN KEY(a_team)    REFERENCES gestao_futebol.equipa(id),
)

CREATE TABLE gestao_futebol.pessoa(
	id         INT NOT NULL IDENTITY(1,1),
	nome		VARCHAR(100) NOT NULL,
	data_nasc   VARCHAR(50) NOT NULL,
	salario		VARCHAR(50),
	PRIMARY KEY(id)
	
)


)

CREATE TABLE gestao_futebol.presidente(
	id_presidente   INT NOT NULL,
	PRIMARY KEY(id_presidente),
	FOREIGN KEY(id_presidente) REFERENCES gestao_futebol.pessoa(id) 
)

CREATE TABLE gestao_futebol.treinador(
	id_treinador   INT NOT NULL,
	nivel		   INT ,
	t_principal	   BIT NOT NULL,
	PRIMARY KEY(id_treinador),
	FOREIGN KEY(id_treinador) REFERENCES gestao_futebol.pessoa(id) 
)

CREATE TABLE gestao_futebol.jogador(
	id_jogador			INT NOT NULL,
	altura				INT NOT NULL,
	peso				INT NOT NULL,
	posicao				VARCHAR(30) ,
	PRIMARY KEY(id_jogador),
	FOREIGN KEY(id_jogador) REFERENCES gestao_futebol.pessoa(id) 
)

CREATE TABLE gestao_futebol.golo(
	id_jogo		INT  NOT NULL,
	minuto		INT  NOT NULL,
	jogador		INT NOT NULL,
	PRIMARY KEY(id_jogo,minuto, jogador),
	FOREIGN KEY(id_jogo)    REFERENCES gestao_futebol.jogo(id),
	FOREIGN KEY(jogador)    REFERENCES gestao_futebol.jogador(id_jogador)
)

CREATE TABLE gestao_futebol.pessoa_nacionalidade(
	pessoa		INT NOT NULL,
	nacionalidade		VARCHAR(50) NOT NULL,
	PRIMARY KEY(pessoa,nacionalidade),
	FOREIGN KEY(pessoa)		REFERENCES gestao_futebol.pessoa(id),
	FOREIGN KEY(nacionalidade)    REFERENCES gestao_futebol.nacionalidade(nome),
)

CREATE TABLE gestao_futebol.joga_em(
	team		 INT NOT NULL,
	player		 INT NOT NULL,
	data_ini	 DATE,
	data_fim	 DATE,
	PRIMARY KEY(team,player),
	FOREIGN KEY(team)     REFERENCES gestao_futebol.equipa(id),
	FOREIGN KEY(player)  REFERENCES gestao_futebol.jogador(id_jogador),
)


CREATE TABLE gestao_futebol.treina_em(
	team		 INT NOT NULL,
	coach		 INT NOT NULL,
	data_ini	 DATE,
	data_fim	 DATE,
	PRIMARY KEY(team,coach),
	FOREIGN KEY(team)     REFERENCES gestao_futebol.equipa(id),
	FOREIGN KEY(coach)    REFERENCES gestao_futebol.treinador(id_treinador),
)

CREATE TABLE gestao_futebol.preside_em(
	team		 INT NOT NULL,
	president	 INT NOT NULL,
	data_ini	 DATE,
	data_fim	 DATE,
	n_mandatos   INT,
	PRIMARY KEY(team,president),
	FOREIGN KEY(team)       REFERENCES gestao_futebol.equipa(id),
	FOREIGN KEY(president)  REFERENCES gestao_futebol.presidente(id_presidente),
)