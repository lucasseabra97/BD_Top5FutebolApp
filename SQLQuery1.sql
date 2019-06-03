--create database top_5_futebol
USE top_5_futebol
GO
--CREATE SCHEMA gestao_futebol
GO

CREATE PROC gestao_futebol.CriaPresidente (
	@nome			VARCHAR(100), 
	@data_nasc		VARCHAR(50),
	@salario		VARCHAR(50),
	@nome_equipa       VARCHAR(100),
	@data_ini	 DATE,
	@data_fim	 DATE,
	@n_mandatos   INT
) AS
SET NOCOUNT ON
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES(@nome,@data_nasc,@salario);

DECLARE @IncID int
DECLARE @ClubID int
SET @IncID = SCOPE_IDENTITY();

INSERT INTO gestao_futebol.presidente([id_presidente]) VALUES (@IncID);




SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome=@nome_equipa;

IF @ClubID is NULL
BEGIN
	--PRINT 'There are ' + CAST(@ClubID AS VARCHAR) + ' alias combinations did not match a record';
	SELECT @ClubID;

	SELECT nome
	FROM gestao_futebol.equipa;
END


INSERT INTO gestao_futebol.preside_em([team],[president], [data_ini], [data_fim], [n_mandatos]) VALUES (@ClubID ,@IncID,@data_ini, @data_fim, @n_mandatos);

SET NOCOUNT OFF
GO










CREATE PROC gestao_futebol.CriaJogador (
	@nome			VARCHAR(100), 
	@clube			VARCHAR(100),
	@liga			VARCHAR(100),
	@data_nasc		VARCHAR(50),
	@altura				INT,
	@peso				INT,
	@nacionalidade	VARCHAR(100),
	@salario		VARCHAR(50),
	@data_ini	 DATE,
	@data_fim	 DATE
) AS

SET NOCOUNT ON;

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES(@nome,@data_nasc,@salario);

DECLARE @IncID int
DECLARE @ClubID int
SET @IncID = SCOPE_IDENTITY();



IF NOT EXISTS (SELECT * FROM gestao_futebol.nacionalidade WHERE [nome] = @nacionalidade)
	SELECT @nacionalidade;


INSERT INTO gestao_futebol.pessoa_nacionalidade(pessoa, nacionalidade) VALUES (@IncID, @nacionalidade);

INSERT INTO gestao_futebol.jogador([id_jogador], [altura], [peso]) VALUES (@IncID, @altura, @peso);

SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome=@clube;



INSERT INTO gestao_futebol.joga_em([team],[player], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,@data_ini, @data_fim);





SET NOCOUNT OFF
GO








CREATE PROC gestao_futebol.CriaEstadio (
	@clube			VARCHAR(100),
	@nome			VARCHAR(100),
	@lotacao    INT,
	@morada     VARCHAR(100),
	@data_crons DATE
) AS
SET NOCOUNT ON;

DECLARE @id_equipa int

SELECT @id_equipa = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome=@clube;

INSERT INTO gestao_futebol.estadio([nome],[lotacao],[morada], [data_crons], [equipa]) VALUES(@nome, @lotacao, @morada,@data_crons,@id_equipa);

SET NOCOUNT OFF
GO










CREATE PROC gestao_futebol.CriaJogo (
	@id			int,
	@team_home	VARCHAR(100),
	@team_away  VARCHAR(100)
) AS
SET NOCOUNT ON;

DECLARE @id_equipa_home int
DECLARE @id_equipa_away int

SELECT @id_equipa_home = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome=@team_home;
SELECT @id_equipa_away = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome=@team_away;

INSERT INTO gestao_futebol.jogo([id],[h_team],[a_team]) VALUES(@id, @id_equipa_home, @id_equipa_away);

SET NOCOUNT OFF
GO







CREATE PROC gestao_futebol.CriaGolo (
	@id			int,
	@minuto			int,
	@jogador	VARCHAR(100)
) AS
SET NOCOUNT ON;

DECLARE @id_jogador int

SELECT @id_jogador = id FROM [top_5_futebol].[gestao_futebol].[pessoa] where nome=@jogador;


INSERT INTO gestao_futebol.golo([id_jogo],[minuto],[jogador]) VALUES(@id, @minuto, @id_jogador);

SET NOCOUNT OFF
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

--aux table just for adding de values from de csv file
--drop table gestao_futebol.pessoa_staging
CREATE TABLE gestao_futebol.pessoa_staging(
	nome		VARCHAR(100) NOT NULL,
	data_nasc   VARCHAR(50) NOT NULL,
	salario		VARCHAR(50)
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



--Insert values into tables--

SET NOCOUNT ON;
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Inglesa','ENG'),('France','FR'),('Ivory Coast','IC');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Spain','ES'),('Argentina','AR'),('Greece','GR');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Italy','ITA'),('Mexico','MX'),('Cameroon','CM');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Alema','GER'),('Uruguay','UY'),('Costa Rica','CR');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Portugal','PT'), ('Algeria','DZ'),('Mali','ML');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Netherlands','NL'), ('Brazil','BR'),('Serbia','RS');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Belarus','BY'), ('Croatia','HR'),('Peru','PE');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Cape Verde','CV'), ('Venezuela','VE'),('Belgium','BE');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Montenegro','ME'), ('Egypt','EG'),('Ghana','GH');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Switzerland','CH'), ('Colombia','CO'),('FYR Macedonia','MK');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Mozambique','MZ'), ('Georgia','GE'),('Scotland','UK');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Angola','AO'), ('Senegal','SN'),('Nigeria','NG');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Guinea Bissau','GN'), ('DR Congo','CD'),('Burkina Faso','BF');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Armenia','AM'), ('Australia','AU'),('Japan','JP');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Haiti','HT'), ('Sweden','SE'),('Slovakia','SK');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Poland','PL'), ('Cyprus','CY'),('New Zealand','NZ');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('England','UK'), ('Gabon','GA'),('Panama','PA');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Morocco','MA'), ('Uganda','UG'),('Libya','LY');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('China PR','CN'), ('Iran','IR'),('Gambia','GM');




INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Premier League','Inglesa');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('La Liga','Spain');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Serie A','Italy');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Bundesliga','Alema');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Primeira Liga','Portugal');

SET NOCOUNT Off;
--Insert teams--
--Portuguese

DECLARE @Identity int

SELECT @Identity = id FROM [top_5_futebol].[gestao_futebol].[campeonato] where nome='Primeira Liga';

SET NOCOUNT ON;
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Belenenses', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Benfica', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Boavista', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Braga', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Aves', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Desportivo das Chaves', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Feirense', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Maritimo', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Moreirense', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Nacional', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Portimonense', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Porto', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Rio Ave', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Santa Clara', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Sporting CP', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Tondela', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Vitoria de Guimaraes', '1919-07-23', @Identity);
INSERT INTO gestao_futebol.equipa(nome, data_fund, campeonato) VALUES('Vitoria de Setubal', '1919-07-23', @Identity);

SET NOCOUNT OFF;










EXEC gestao_futebol.CriaJogador 'Danilo Luís Hélio Pereira','Porto','Primeira Liga','1991-09-09',188.0,83.0,'Portugal',27500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bas Dost','Sporting CP','Primeira Liga','1989-05-31',196.0,89.0,'Netherlands',27000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rui Pedro dos Santos Patrício','Sporting CP','Primeira Liga','1988-02-15',190.0,84.0,'Portugal',17500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jonas Gonçalves Oliveira','Benfica','Primeira Liga','1984-04-01',182.0,74.0,'Brazil',16500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Iker Casillas Fernández','Porto','Primeira Liga','1981-05-20',185.0,84.0,'Spain',3500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Felipe Augusto de Almeida Monteiro','Porto','Primeira Liga','1989-05-16',185.0,77.0,'Brazil',18000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luis Miguel Afonso Fernandes','Benfica','Primeira Liga','1989-10-06',177.0,72.0,'Portugal',23000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Yacine Brahimi','Porto','Primeira Liga','1990-02-08',175.0,66.0,'Algeria',23000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ljubomir Fejsa','Benfica','Primeira Liga','1988-08-14',183.0,80.0,'Serbia',18000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gelson Dany Batalha Martins','Sporting CP','Primeira Liga','1995-05-11',173.0,65.0,'Portugal',25000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sebastián Coates','Sporting CP','Primeira Liga','1990-10-07',196.0,92.0,'Uruguay',18000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jesús Corona','Porto','Primeira Liga','1993-01-06',173.0,62.0,'Mexico',23000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alex Nicolao Telles','Porto','Primeira Liga','1992-12-15',181.0,71.0,'Brazil',16000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo D. Barbosa Pereira','Porto','Primeira Liga','1993-10-06',175.0,70.0,'Portugal',17000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alejandro Grimaldo García','Benfica','Primeira Liga','1995-09-20',171.0,69.0,'Spain',17500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Eduardo Salvio','Benfica','Primeira Liga','1990-07-13',173.0,77.0,'Argentina',16000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Iván Marcano Sierra','Porto','Primeira Liga','1987-06-23',187.0,77.0,'Spain',11000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jardel Nivaldo Vieira','Benfica','Primeira Liga','1986-03-29',192.0,87.0,'Brazil',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jérémy Mathieu','Sporting CP','Primeira Liga','1983-10-29',189.0,84.0,'France',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Júlio César Soares Espíndola','Benfica','Primeira Liga','1979-09-03',186.0,79.0,'Brazil',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Francisco Soares dos Santos','Porto','Primeira Liga','1991-01-17',187.0,82.0,'Brazil',15500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marcos Acuña','Sporting CP','Primeira Liga','1991-10-28',172.0,69.0,'Argentina',16000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Óliver Torres Muñoz','Porto','Primeira Liga','1994-11-10',175.0,63.0,'Spain',17000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Seydou Doumbia','Sporting CP','Primeira Liga','1987-12-31',179.0,71.0,'Ivory Coast',12500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Héctor Herrera','Porto','Primeira Liga','1990-04-19',183.0,72.0,'Mexico',14000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Anderson Luís da Silva','Benfica','Primeira Liga','1981-02-13',195.0,91.0,'Brazil',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Franco Cervi','Benfica','Primeira Liga','1994-05-26',166.0,62.0,'Argentina',14500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Raúl Michel Melo da Silva','Braga','Primeira Liga','1989-11-04',187.0,81.0,'Brazil',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rodrigo Battaglia','Sporting CP','Primeira Liga','1991-07-12',187.0,79.0,'Argentina',12500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael A. Ferreira Silva','Benfica','Primeira Liga','1993-05-17',171.0,66.0,'Portugal',14000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Lisandro López','Benfica','Primeira Liga','1989-09-01',188.0,82.0,'Argentina',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alan Ruiz','Sporting CP','Primeira Liga','1993-08-19',183.0,77.0,'Argentina',14500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hernâni Jorge Santos Fortes','Porto','Primeira Liga','1991-08-20',178.0,69.0,'Portugal',12500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Iuri José Picanço Medeiros','Sporting CP','Primeira Liga','1994-07-10',174.0,64.0,'Portugal',14500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Miguel Borges Fernandes','Sporting CP','Primeira Liga','1994-09-08',179.0,69.0,'Portugal',14000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Andreas Samaris','Benfica','Primeira Liga','1989-06-13',189.0,84.0,'Greece',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Raúl Jiménez','Benfica','Primeira Liga','1991-05-05',187.0,81.0,'Mexico',12500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Carlos Coentrão Marafona','Braga','Primeira Liga','1987-05-08',190.0,86.0,'Portugal',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Filipe Brás André','Porto','Primeira Liga','1989-08-26',174.0,65.0,'Portugal',10500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vincent Aboubakar','Porto','Primeira Liga','1992-01-22',184.0,82.0,'Cameroon',13500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Maximiliano Pereira','Porto','Primeira Liga','1984-06-08',173.0,73.0,'Uruguay',4000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Miguel Layún','Porto','Primeira Liga','1988-06-25',179.0,69.0,'Mexico',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diego Reyes','Porto','Primeira Liga','1992-09-19',189.0,74.0,'Mexico',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marcelo dos Santos Ferreira','Rio Ave','Primeira Liga','1989-07-27',182.0,74.0,'Brazil',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bryan Ruíz','Sporting CP','Primeira Liga','1985-08-18',188.0,78.0,'Costa Rica',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Almeida Pinto','Sporting CP','Primeira Liga','1989-10-05',194.0,86.0,'Portugal',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Andrija Živković','Benfica','Primeira Liga','1996-07-11',169.0,70.0,'Serbia',14000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Miguel Semedo Varela','Benfica','Primeira Liga','1994-11-04',191.0,87.0,'Portugal',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Henrique Pereira da Silva','Vitoria de Guimaraes','Primeira Liga','1992-12-18',190.0,88.0,'Brazil',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fábio Alexandre Silva Coentrão','Sporting CP','Primeira Liga','1988-03-11',179.0,66.0,'Portugal',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo José Araújo Ferreira','Braga','Primeira Liga','1992-11-25',190.0,76.0,'Portugal',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno César Zanaki','Sporting CP','Primeira Liga','1988-11-03',177.0,75.0,'Brazil',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Raphael Dias Belloli','Vitoria de Guimaraes','Primeira Liga','1996-12-14',176.0,68.0,'Brazil',13000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Moussa Marega','Porto','Primeira Liga','1991-04-14',186.0,83.0,'Mali',9500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Otávio Edmilson da Silva Monteiro','Porto','Primeira Liga','1995-02-09',172.0,71.0,'Brazil',12000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Jorge da Luz Horta','Braga','Primeira Liga','1994-09-15',173.0,63.0,'Portugal',11000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Maria Palhinha Gonçalves','Sporting CP','Primeira Liga','1995-07-09',190.0,82.0,'Portugal',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Renan Bardini Bressan','Desportivo das Chaves','Primeira Liga','1988-11-03',182.0,75.0,'Belarus',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wilson Bruno Naval Costa Eduardo','Braga','Primeira Liga','1990-07-08',179.0,73.0,'Portugal',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Filip Krovinović','Benfica','Primeira Liga','1995-08-29',175.0,70.0,'Croatia',10500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gabriel Barbosa Almeida','Benfica','Primeira Liga','1996-08-30',178.0,68.0,'Brazil',12000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Dyego Wilverson Ferreira Sousa','Braga','Primeira Liga','1989-09-14',190.0,83.0,'Brazil',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fábio Santos Martins','Braga','Primeira Liga','1993-07-24',178.0,70.0,'Portugal',10500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Douglas Renato de Jesus','Vitoria de Guimaraes','Primeira Liga','1983-03-09',188.0,87.0,'Brazil',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Paolo Hurtado','Vitoria de Guimaraes','Primeira Liga','1990-07-27',176.0,72.0,'Peru',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Daniel Castelo Podence','Sporting CP','Primeira Liga','1995-10-21',165.0,58.0,'Portugal',11500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Erdem Şen','Maritimo','Primeira Liga','1989-01-05',180.0,75.0,'Belgium',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo José Monteiro','Rio Ave','Primeira Liga','1983-10-07',188.0,78.0,'Portugal',4500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cristiano Piccini','Sporting CP','Primeira Liga','1992-09-26',189.0,79.0,'Italy',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Pedro Malheiro de Sá','Porto','Primeira Liga','1993-01-17',192.0,85.0,'Portugal',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Gomes Magalhães Almeida','Benfica','Primeira Liga','1990-09-10',186.0,80.0,'Portugal',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Víctor García','Vitoria de Guimaraes','Primeira Liga','1994-06-11',178.0,71.0,'Venezuela',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fransérgio Rodrigues Barbosa','Braga','Primeira Liga','1990-10-18',187.0,82.0,'Brazil',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jonathan Silva','Sporting CP','Primeira Liga','1994-06-29',180.0,75.0,'Argentina',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Héldon Augusto Almeida Ramos','Vitoria de Guimaraes','Primeira Liga','1988-11-14',174.0,66.0,'Cape Verde',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Francisco Geraldes','Rio Ave','Primeira Liga','1995-04-18',175.0,67.0,'Portugal',10500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Filipe Luz Horta','Braga','Primeira Liga','1996-11-07',175.0,70.0,'Portugal',10000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alhassan Wakaso','Vitoria de Guimaraes','Primeira Liga','1992-01-07',180.0,76.0,'Ghana',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Paulo Sérgio Mota','Desportivo das Chaves','Primeira Liga','1991-07-13',175.0,70.0,'Portugal',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ahmed Hassan','Braga','Primeira Liga','1993-03-05',191.0,85.0,'Egypt',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nikola Vukčević','Braga','Primeira Liga','1991-12-13',184.0,76.0,'Montenegro',7000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Daniel Castro Moreira','Nacional','Primeira Liga','1987-09-06',185.0,79.0,'Portugal',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ghislain Konan','Vitoria de Guimaraes','Primeira Liga','1995-12-27',176.0,71.0,'Ivory Coast',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Haris Seferović','Benfica','Primeira Liga','1992-02-22',185.0,85.0,'Switzerland',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cássio Albuquerque Anjos','Rio Ave','Primeira Liga','1980-08-12',186.0,79.0,'Brazil',900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno Miguel Sousa Pinto','Vitoria de Setubal','Primeira Liga','1986-08-06',173.0,65.0,'Portugal',4800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jefferson Nascimento','Braga','Primeira Liga','1988-07-05',176.0,72.0,'Brazil',5500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Salvador José Milhazes Agra','Aves','Primeira Liga','1991-11-11',166.0,61.0,'Portugal',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Filipe Barbosa Moreira','Nacional','Primeira Liga','1992-12-20',170.0,68.0,'Portugal',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Jorge Novo Nunes','Desportivo das Chaves','Primeira Liga','1982-07-06',188.0,84.0,'Portugal',2700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mattheus A. Gama de Oliveira','Sporting CP','Primeira Liga','1994-07-07',182.0,76.0,'Brazil',9500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Matheus Lima Magalhães','Braga','Primeira Liga','1992-07-19',187.0,76.0,'Brazil',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Djavan da Silva Ferreira','Desportivo das Chaves','Primeira Liga','1987-12-31',184.0,76.0,'Brazil',5000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Welthon Fiel Sampaio','Nacional','Primeira Liga','1992-06-21',180.0,74.0,'Brazil',9000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Radosav Petrović','Sporting CP','Primeira Liga','1989-03-08',193.0,78.0,'Serbia',4600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Danilo Barbosa da Silva','Braga','Primeira Liga','1996-02-28',182.0,86.0,'Brazil',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Miguel Coimbra Aurélio','Vitoria de Guimaraes','Primeira Liga','1988-08-17',182.0,72.0,'Portugal',4400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Guillermo Celis','Vitoria de Guimaraes','Primeira Liga','1993-05-08',178.0,73.0,'Colombia',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marcelo Augusto Ferreira Teixeira','Braga','Primeira Liga','1987-10-13',176.0,69.0,'Brazil',4300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Geraldes de Barros','Belenenses','Primeira Liga','1991-05-02',181.0,74.0,'Portugal',5500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Matheus Fellipe Costa Pereira','Desportivo das Chaves','Primeira Liga','1996-05-05',175.0,66.0,'Brazil',9500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Renato João Saleiro Santos','Boavista','Primeira Liga','1991-10-05',177.0,75.0,'Portugal',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fabiano Ribeiro de Freitas','Porto','Primeira Liga','1988-02-29',197.0,91.0,'Brazil',3800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Alexandre Vieira Almeida','Braga','Primeira Liga','1997-12-02',179.0,72.0,'Portugal',9500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rúben Tiago Rodrigues Ribeiro','Rio Ave','Primeira Liga','1987-08-01',175.0,67.0,'Portugal',5500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vasco Herculano Cunha Fernandes','Vitoria de Setubal','Primeira Liga','1986-11-12',182.0,76.0,'Portugal',4200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Filipe Augusto Carvalho Souza','Benfica','Primeira Liga','1993-08-12',183.0,80.0,'Brazil',8000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Paulo Henrique Soares dos Santos','Portimonense','Primeira Liga','1994-07-10',166.0,58.0,'Brazil',8500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jeferson Fernandes Macedo','Desportivo das Chaves','Primeira Liga','1991-07-17',180.0,70.0,'Brazil',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Miguel Jesus Rosa','Belenenses','Primeira Liga','1989-01-13',176.0,70.0,'Portugal',5500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jaílton Alves Miranda','Boavista','Primeira Liga','1989-08-02',181.0,63.0,'Cape Verde',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Kléber Laube Pinheiro','Santa Clara','Primeira Liga','1990-05-02',187.0,81.0,'Brazil',6500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Stefan Ristovski','Sporting CP','Primeira Liga','1992-02-12',180.0,72.0,'FYR Macedonia',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sérgio Miguel Relvas de Oliveira','Porto','Primeira Liga','1992-06-02',181.0,72.0,'Portugal',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ousmane Dramé','Moreirense','Primeira Liga','1992-08-25',174.0,70.0,'France',7000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Zainadine Chavango Júnior','Maritimo','Primeira Liga','1988-06-24',178.0,75.0,'Mozambique',4400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fábio Ricardo Gomes Fonseca','Boavista','Primeira Liga','1985-08-18',171.0,64.0,'Portugal',4800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nélson Ricardo Rodrigues Lenho','Aves','Primeira Liga','1984-03-22',179.0,75.0,'Portugal',2200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Eduardo Gottardi','Maritimo','Primeira Liga','1985-10-18',193.0,82.0,'Brazil',3400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Romain Salin','Sporting CP','Primeira Liga','1984-07-29',189.0,76.0,'France',3200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Sousa Esgaio','Braga','Primeira Liga','1993-05-16',173.0,68.0,'Portugal',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Jorge Pinto da Silva','Nacional','Primeira Liga','1980-08-19',186.0,78.0,'Cape Verde',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'António José Pinheiro Carvalho','Moreirense','Primeira Liga','1993-01-14',166.0,61.0,'Portugal',7500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Carlos Santos Rodrigues','Aves','Primeira Liga','1995-01-13',183.0,84.0,'Cape Verde',4800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Manuel Araújo Braga','Aves','Primeira Liga','1983-06-17',181.0,77.0,'Portugal',1900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Giorgi Makaridze','Moreirense','Primeira Liga','1990-03-31',190.0,85.0,'Georgia',2700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Douglas Franco Teixeira','Sporting CP','Primeira Liga','1988-01-12',192.0,80.0,'Netherlands',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ryan Gauld','Aves','Primeira Liga','1995-12-16',169.0,61.0,'Scotland',7000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Clecildo Rafael Martins Ladislau','Vitoria de Guimaraes','Primeira Liga','1989-03-17',177.0,73.0,'Brazil',4099999.9999999995, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Alexandre Carreira Sousa','Belenenses','Primeira Liga','1990-07-09',181.0,78.0,'Portugal',4300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fábio José Ferreira Pacheco','Maritimo','Primeira Liga','1988-05-26',180.0,73.0,'Portugal',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mateus Galiano da Costa','Boavista','Primeira Liga','1984-06-19',176.0,75.0,'Angola',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Idrissa Mandiang','Boavista','Primeira Liga','1984-12-27',189.0,80.0,'Senegal',2300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Muriel Gustavo Becker','Belenenses','Primeira Liga','1987-02-14',190.0,78.0,'Brazil',2600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João José Pereira da Costa','Vitoria de Setubal','Primeira Liga','1992-08-25',170.0,64.0,'Portugal',5500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ronei Gleison Rodrigues Reis','Belenenses','Primeira Liga','1991-06-26',171.0,67.0,'Brazil',4700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vitor Hugo Gomes da Silva','Aves','Primeira Liga','1987-12-25',183.0,81.0,'Portugal',3800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'David Martins Simão','Boavista','Primeira Liga','1990-05-15',183.0,74.0,'Portugal',4500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Charles Marcelo da Silva','Maritimo','Primeira Liga','1994-02-04',186.0,84.0,'Brazil',4400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Óscar Estupiñán','Vitoria de Guimaraes','Primeira Liga','1996-12-29',182.0,74.0,'Colombia',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alberto Bueno Calvo','Porto','Primeira Liga','1988-03-20',179.0,67.0,'Spain',3900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mauro Silva Sousa','Braga','Primeira Liga','1990-10-31',177.0,72.0,'Brazil',4000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hassan Yebda','Belenenses','Primeira Liga','1984-05-14',187.0,82.0,'Algeria',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fábio Miguel Santos Sturgeon','Vitoria de Guimaraes','Primeira Liga','1994-02-04',183.0,76.0,'Portugal',5000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rúben Rafael Sousa Ferreira','Desportivo das Chaves','Primeira Liga','1990-02-17',183.0,67.0,'Portugal',3700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Peter Etebo','Feirense','Primeira Liga','1995-11-09',176.0,70.0,'Nigeria',6000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo António Cupido Gonçalves','Benfica','Primeira Liga','1997-02-06',177.0,71.0,'Portugal',7000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Paulo Ricardo de Jesús Machado','Aves','Primeira Liga','1986-03-31',174.0,74.0,'Portugal',3400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Patrick De Oliveira Vieira','Vitoria de Setubal','Primeira Liga','1991-01-22',173.0,76.0,'Brazil',3900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jacinto Muondo Dala','Sporting CP','Primeira Liga','1996-07-13',175.0,65.0,'Angola',7000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Arnaldo Edi Lopes da Silva','Vitoria de Setubal','Primeira Liga','1982-07-07',182.0,75.0,'Portugal',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno André da Silva Coelho','Desportivo das Chaves','Primeira Liga','1986-01-07',192.0,82.0,'Portugal',2700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tobias Pereira Figueiredo','Sporting CP','Primeira Liga','1994-02-02',188.0,84.0,'Portugal',3600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Filipe Claro de Jesus','Santa Clara','Primeira Liga','1991-03-31',183.0,75.0,'Portugal',3800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diego Fortunato dos Santos Queiroz','Aves','Primeira Liga','1984-01-14',185.0,80.0,'Brazil',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Araújo dos Santos','Nacional','Primeira Liga','1993-02-07',183.0,79.0,'Brazil',3500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno Miguel Gomes dos Santos','Rio Ave','Primeira Liga','1995-02-13',179.0,73.0,'Portugal',4400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jorge Costa Pires','Portimonense','Primeira Liga','1981-04-01',176.0,73.0,'Portugal',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Adriano Facchini','Aves','Primeira Liga','1983-03-12',187.0,78.0,'Brazil',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Jorge Oliveira Valente','Maritimo','Primeira Liga','1991-04-03',181.0,76.0,'Portugal',3700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Miguel Coimbra Aurélio','Feirense','Primeira Liga','1988-08-17',179.0,70.0,'Portugal',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gonçalo José Gonçalves Santos','Aves','Primeira Liga','1986-11-15',184.0,79.0,'Portugal',2300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Domingos Sousa Menezes Duarte','Desportivo das Chaves','Primeira Liga','1995-03-03',190.0,78.0,'Portugal',3900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno Henrique Gonçalves Nogueira','Boavista','Primeira Liga','1986-10-19',186.0,75.0,'Portugal',2300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cláudio Pires de Morais Ramos','Tondela','Primeira Liga','1991-11-16',183.0,85.0,'Portugal',3000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Filipe Miguel Neves Ferreira','Nacional','Primeira Liga','1990-09-09',178.0,72.0,'Portugal',3000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marco João Costa Baixinho','Nacional','Primeira Liga','1989-07-11',187.0,80.0,'Portugal',2900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael Henrique Assis Cardoso','Braga','Primeira Liga','1990-10-31',170.0,61.0,'Brazil',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Filipe da Silva Moreira','Santa Clara','Primeira Liga','1982-03-20',185.0,83.0,'Portugal',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Edgar Andrade da Costa','Maritimo','Primeira Liga','1987-04-14',177.0,78.0,'Portugal',2900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael Garcia Tonioli Defendi','Nacional','Primeira Liga','1983-12-22',191.0,88.0,'Brazil',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hélder Tiago Pinto Moura Guedes','Rio Ave','Primeira Liga','1987-05-07',182.0,76.0,'Portugal',3000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Douglas Pereira dos Santos','Benfica','Primeira Liga','1990-08-06',171.0,60.0,'Brazil',2600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Eber Henrique Ferreira de Bessa','Maritimo','Primeira Liga','1992-03-21',167.0,72.0,'Brazil',3800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vagner da Silva','Boavista','Primeira Liga','1986-06-06',185.0,79.0,'Brazil',1900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Maurides Roque Junior','Belenenses','Primeira Liga','1994-03-10',188.0,77.0,'Brazil',4300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Carlos Vilaça Teixeira','Braga','Primeira Liga','1993-01-18',177.0,76.0,'Portugal',4300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Amilton Minervino da Silva','Aves','Primeira Liga','1989-08-12',172.0,68.0,'Brazil',3300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno Miguel Jerónimo Sequeira','Braga','Primeira Liga','1990-08-19',184.0,79.0,'Portugal',2600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael Furlan Soares','Desportivo das Chaves','Primeira Liga','1994-09-20',177.0,75.0,'Brazil',3300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gonçalo Jardim Brandão','Santa Clara','Primeira Liga','1986-10-09',182.0,76.0,'Portugal',2300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João António Antunes Carvalho','Benfica','Primeira Liga','1997-03-09',170.0,66.0,'Portugal',5500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Judilson Mamadu Tuncara Gomes','Rio Ave','Primeira Liga','1991-09-29',182.0,77.0,'Guinea Bissau',3200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tiago Henrique Damil Gomes','Feirense','Primeira Liga','1986-07-29',177.0,80.0,'Portugal',2200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Miguel Moreira Costa','Tondela','Primeira Liga','1981-05-16',183.0,80.0,'Portugal',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tiago Rafael Maia Silva','Feirense','Primeira Liga','1993-06-02',175.0,68.0,'Portugal',4099999.9999999995, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Lucas E. Santana de Oliveira','Santa Clara','Primeira Liga','1995-05-06',181.0,79.0,'Brazil',3500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Evanildo Fernandes Gomes','Aves','Primeira Liga','1986-05-01',175.0,63.0,'Brazil',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Nuno Fernandes Ferreira','Tondela','Primeira Liga','1995-01-13',176.0,68.0,'Portugal',3600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Elvis Manuel Monteiro Macedo','Feirense','Primeira Liga','1985-07-27',180.0,74.0,'Cape Verde',2000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Miguel Pereira Silva','Desportivo das Chaves','Primeira Liga','1988-08-31',182.0,76.0,'Portugal',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Lionn Barbosa de Lucena','Rio Ave','Primeira Liga','1989-01-29',184.0,77.0,'Brazil',1900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Filipe Carneiro Leal','Nacional','Primeira Liga','1995-08-06',174.0,64.0,'Portugal',3700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luis Fariña','Aves','Primeira Liga','1991-04-20',177.0,72.0,'Argentina',2900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Diogo Gomes de Freitas','Belenenses','Primeira Liga','1988-02-28',175.0,69.0,'Portugal',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Eduardo José Borges Machado','Boavista','Primeira Liga','1990-04-26',175.0,67.0,'Portugal',2000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Rafael Brito Teixeira','Vitoria de Setubal','Primeira Liga','1994-02-06',179.0,72.0,'Portugal',3200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Miguel Macedo da Silva','Vitoria de Guimaraes','Primeira Liga','1995-04-07',188.0,78.0,'Portugal',2300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vanderley Dias Marinho','Aves','Primeira Liga','1987-12-29',183.0,76.0,'Brazil',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Yannick dos Santos Djaló','Vitoria de Setubal','Primeira Liga','1986-05-05',171.0,62.0,'Portugal',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Óscar Barreto','Rio Ave','Primeira Liga','1993-04-28',173.0,68.0,'Colombia',3200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Alexandre Marques Pereirinha','Belenenses','Primeira Liga','1988-03-02',174.0,67.0,'Portugal',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Arnold Issoko','Vitoria de Setubal','Primeira Liga','1992-04-06',185.0,79.0,'DR Congo',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Carlos Fonseca Silva','Boavista','Primeira Liga','1989-08-30',180.0,75.0,'Portugal',2000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Campos Moreira','Braga','Primeira Liga','1995-12-02',194.0,84.0,'Portugal',2600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sebastián Rincón','Vitoria de Guimaraes','Primeira Liga','1994-01-14',185.0,79.0,'Colombia',3300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Leonardo Ruíz','Boavista','Primeira Liga','1996-04-18',185.0,76.0,'Colombia',3900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Filipe Ribeiro Leão','Nacional','Primeira Liga','1985-05-20',185.0,72.0,'Portugal',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafik Halliche','Santa Clara','Primeira Liga','1986-09-02',187.0,77.0,'Algeria',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rúben Miguel Santos Fernandes','Portimonense','Primeira Liga','1986-05-06',185.0,78.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Pedro Reis Amaral','Vitoria de Setubal','Primeira Liga','1991-09-07',172.0,65.0,'Portugal',2800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luis Otavio Bonilha de Oliveira','Vitoria de Setubal','Primeira Liga','1992-02-17',175.0,69.0,'Brazil',2900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Paulo Dias Fernandes','Braga','Primeira Liga','1992-11-09',187.0,81.0,'Portugal',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bakary Saré','Belenenses','Primeira Liga','1990-04-05',185.0,77.0,'Burkina Faso',2300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jubal Rocha Mendes Junior','Vitoria de Guimaraes','Primeira Liga','1993-08-29',187.0,80.0,'Brazil',2800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rodrigo Defendi','Aves','Primeira Liga','1986-06-16',190.0,83.0,'Brazil',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vítor Bruno Ramos Gonçalves','Boavista','Primeira Liga','1990-01-13',171.0,69.0,'Portugal',2000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Miguel Lopes Mendes','Santa Clara','Primeira Liga','1987-04-09',170.0,67.0,'Portugal',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Leocísio Júlio Sami','Aves','Primeira Liga','1988-12-18',184.0,76.0,'Guinea Bissau',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hichem Belkaroui','Moreirense','Primeira Liga','1990-08-24',185.0,81.0,'Algeria',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Lazar Rosić','Braga','Primeira Liga','1993-06-29',190.0,83.0,'Serbia',2800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gabriel Airton de Souza','Rio Ave','Primeira Liga','1996-03-29',171.0,61.0,'Brazil',2600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Carlos Filipe Fonseca Chaby','Belenenses','Primeira Liga','1994-01-22',174.0,64.0,'Portugal',2500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Miguel Cunha Sá','Portimonense','Primeira Liga','1993-12-01',175.0,70.0,'Portugal',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jorge Fernando Barbosa Intima','Desportivo das Chaves','Primeira Liga','1995-09-21',169.0,68.0,'Portugal',3100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alfa Semedo Esteves','Moreirense','Primeira Liga','1997-08-30',190.0,82.0,'Guinea Bissau',2700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Miguel Ribeiro Vigário','Vitoria de Guimaraes','Primeira Liga','1995-11-20',181.0,74.0,'Portugal',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Andrade Toledo Nascimento','Feirense','Primeira Liga','1991-05-30',188.0,80.0,'Brazil',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rodrigo Cunha Pereira de Pinho','Maritimo','Primeira Liga','1991-05-30',185.0,79.0,'Brazil',2200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rui Filipe Caetano Moura','Boavista','Primeira Liga','1993-03-01',177.0,74.0,'Portugal',2000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Victor Andrade Santos','Santa Clara','Primeira Liga','1995-09-30',177.0,70.0,'Brazil',2900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Yazalde Gomes Pinto','Rio Ave','Primeira Liga','1988-09-10',183.0,86.0,'Portugal',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rui Pedro da Silva e Sousa','Boavista','Primeira Liga','1998-03-20',182.0,75.0,'Portugal',3800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'António Filipe Norinho de Carvalho','Desportivo das Chaves','Primeira Liga','1985-04-14',186.0,79.0,'Portugal',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Carlos Ramos Martins','Maritimo','Primeira Liga','1992-06-10',177.0,67.0,'Portugal',1900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Willyan Da Silva Barbosa','Vitoria de Setubal','Primeira Liga','1994-02-17',169.0,62.0,'Brazil',2400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vasco André Moreira da Rocha','Nacional','Primeira Liga','1989-01-29',182.0,70.0,'Portugal',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vincent Sasso','Belenenses','Primeira Liga','1991-02-16',190.0,82.0,'France',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hugo André Rodrigues Seco','Feirense','Primeira Liga','1988-06-17',176.0,72.0,'Portugal',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ernest Ohemeng','Moreirense','Primeira Liga','1996-01-17',175.0,65.0,'Ghana',2800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nélson Macedo Monte','Rio Ave','Primeira Liga','1995-07-30',187.0,78.0,'Portugal',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'David Texeira','Vitoria de Guimaraes','Primeira Liga','1991-02-27',181.0,80.0,'Uruguay',2200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Filipe Guerreiro Viana','Belenenses','Primeira Liga','1990-02-22',174.0,68.0,'Portugal',1900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tiago Manuel Oliveira Mesquita','Boavista','Primeira Liga','1990-11-23',180.0,74.0,'Portugal',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gevorg Ghazaryan','Maritimo','Primeira Liga','1988-04-05',177.0,73.0,'Armenia',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Manuel da Silva Moreira','Rio Ave','Primeira Liga','1989-03-15',182.0,76.0,'Portugal',1800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Allano Brendon de Souza Lima','Santa Clara','Primeira Liga','1995-04-24',182.0,73.0,'Brazil',2600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Jorge Rodrigues Pessoa','Portimonense','Primeira Liga','1982-02-05',173.0,68.0,'Portugal',375000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Carlos Reis Graça','Tondela','Primeira Liga','1989-07-02',185.0,77.0,'Portugal',1500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Micael Pereira','Moreirense','Primeira Liga','1989-02-04',188.0,83.0,'Portugal',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Higor Inácio Platiny Rodrigues','Desportivo das Chaves','Primeira Liga','1990-10-02',178.0,71.0,'Brazil',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Flávio da Silva Ramos','Feirense','Primeira Liga','1994-05-12',190.0,85.0,'Brazil',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Filipe Joaquim Melo Silva','Desportivo das Chaves','Primeira Liga','1989-11-03',189.0,82.0,'Portugal',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Arsénio Martins Lafuente Nunes','Moreirense','Primeira Liga','1989-08-30',180.0,72.0,'Portugal',1900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Viana Willemen Da Silva','Braga','Primeira Liga','1995-02-05',187.0,79.0,'Brazil',2100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luiz Phellype Luciano Silva','Nacional','Primeira Liga','1993-09-27',188.0,81.0,'Brazil',1500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Vinícius Souza Ramos','Portimonense','Primeira Liga','1997-03-30',175.0,67.0,'Brazil',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Edson Rodrigues Farias','Feirense','Primeira Liga','1992-01-12',170.0,67.0,'Brazil',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Juan Tomás Ortuño Martínez','Belenenses','Primeira Liga','1992-02-11',178.0,72.0,'Spain',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Florent Hanin','Belenenses','Primeira Liga','1990-02-04',177.0,65.0,'France',975000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pierre Sagna','Moreirense','Primeira Liga','1990-08-21',183.0,76.0,'France',900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Stéphane Sparagna','Boavista','Primeira Liga','1995-02-17',186.0,82.0,'France',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wagner Andrade Borges','Tondela','Primeira Liga','1987-04-03',173.0,70.0,'Brazil',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mário Jorge Quintas Felgueiras','Nacional','Primeira Liga','1986-12-12',186.0,80.0,'Portugal',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro José da Silva Trigueira','Vitoria de Setubal','Primeira Liga','1988-01-04',192.0,79.0,'Portugal',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Anastasios Karamanos','Rio Ave','Primeira Liga','1990-09-21',185.0,78.0,'Greece',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hélder José Castro Ferreira','Vitoria de Guimaraes','Primeira Liga','1997-04-05',179.0,70.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Miguel Vieira da Silva','Nacional','Primeira Liga','1990-10-08',190.0,80.0,'Portugal',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Cristiano Carvalho Santos','Feirense','Primeira Liga','1984-01-17',179.0,70.0,'Portugal',625000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gonçalo Mendes Paciência','Vitoria de Setubal','Primeira Liga','1994-08-01',184.0,80.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Oriol Rosell Argerich','Portimonense','Primeira Liga','1992-07-07',182.0,74.0,'Spain',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Dylan McGowan','Nacional','Primeira Liga','1991-08-06',186.0,80.0,'Australia',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rui Jorge Farto Correia','Nacional','Primeira Liga','1990-08-23',188.0,74.0,'Portugal',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Francisco Neto Ramos','Vitoria de Guimaraes','Primeira Liga','1995-04-10',185.0,76.0,'Portugal',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'William Alves de Oliveira','Desportivo das Chaves','Primeira Liga','1991-12-07',182.0,80.0,'Brazil',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ruben Alexandre Rocha Lima','Moreirense','Primeira Liga','1989-10-03',176.0,72.0,'Portugal',875000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Shoya Nakajima','Portimonense','Primeira Liga','1994-08-23',164.0,64.0,'Japan',1500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alexandre Costa Silva','Vitoria de Guimaraes','Primeira Liga','1997-03-16',177.0,68.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Miguel Pereira','Benfica','Primeira Liga','1998-01-22',182.0,72.0,'Portugal',1700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fábio Diogo Agrela Ferreira','Maritimo','Primeira Liga','1992-07-07',178.0,68.0,'Portugal',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marcos Nascimento Teixeira','Rio Ave','Primeira Liga','1996-06-05',185.0,77.0,'Brazil',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jean Sony Alcenat','Feirense','Primeira Liga','1986-01-23',174.0,67.0,'Haiti',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rúben Alves Dias','Benfica','Primeira Liga','1997-05-14',187.0,82.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Felipe Francisco Macedo','Portimonense','Primeira Liga','1994-03-27',187.0,76.0,'Brazil',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'António Manuel Pereira Xavier','Nacional','Primeira Liga','1992-07-06',176.0,66.0,'Portugal',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Joan Angel Román Ollè','Braga','Primeira Liga','1993-05-18',175.0,70.0,'Spain',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'António Manuel Fernandes Mendes','Tondela','Primeira Liga','1992-10-23',184.0,84.0,'Portugal',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alexandre Garcia Guedes','Aves','Primeira Liga','1994-02-11',185.0,79.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Yordan Osorio','Tondela','Primeira Liga','1994-05-10',189.0,77.0,'Venezuela',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'César Henrique Martins','Vitoria de Setubal','Primeira Liga','1992-12-28',192.0,83.0,'Brazil',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Lucas Silva Afonso','Santa Clara','Primeira Liga','1996-03-23',185.0,75.0,'Brazil',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Joaquim Manuel Sampaio Silva','Aves','Primeira Liga','1975-11-13',182.0,80.0,'Portugal',70000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Miguel da Cunha Teixeira','Vitoria de Guimaraes','Primeira Liga','1981-08-19',185.0,85.0,'Portugal',250000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mateus da Silva','Nacional','Primeira Liga','1991-08-30',184.0,73.0,'Brazil',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pablo Renan dos Santos','Maritimo','Primeira Liga','1992-03-18',185.0,77.0,'Brazil',950000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Falaye Sacko','Vitoria de Guimaraes','Primeira Liga','1995-05-01',179.0,64.0,'Mali',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cristiano Pereira Figueiredo','Vitoria de Setubal','Primeira Liga','1990-11-29',194.0,88.0,'Portugal',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jadson Silva de Morais','Portimonense','Primeira Liga','1991-11-05',186.0,80.0,'Brazil',925000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Iago Azevedo dos Santos','Moreirense','Primeira Liga','1992-05-22',188.0,85.0,'Brazil',975000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Viktor Lundberg','Maritimo','Primeira Liga','1991-03-24',187.0,79.0,'Sweden',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Robert Åhman Persson','Belenenses','Primeira Liga','1987-03-26',188.0,84.0,'Sweden',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bilel Aouacheria','Moreirense','Primeira Liga','1994-04-02',183.0,74.0,'France',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Inácio Carneiro dos Santos','Portimonense','Primeira Liga','1996-01-29',179.0,71.0,'Brazil',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Leandro de Lima Silva','Rio Ave','Primeira Liga','1993-09-25',178.0,70.0,'Brazil',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ença Fati','Moreirense','Primeira Liga','1993-08-11',180.0,68.0,'Guinea Bissau',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Diogo Dalot Teixeira','Porto','Primeira Liga','1999-03-18',183.0,71.0,'Portugal',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Filipe Rodrigues','Santa Clara','Primeira Liga','1997-05-20',183.0,75.0,'Portugal',1500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael Eduardo Costa','Moreirense','Primeira Liga','1991-01-19',183.0,79.0,'Brazil',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Vasco António Barbosa da Costa','Vitoria de Setubal','Primeira Liga','1991-08-08',184.0,78.0,'Portugal',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Martin Chrien','Benfica','Primeira Liga','1995-09-08',182.0,72.0,'Slovakia',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Emanuel Ferreira Sousa','Maritimo','Primeira Liga','1990-09-19',174.0,75.0,'Portugal',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Dénis Paulo Duarte','Vitoria de Guimaraes','Primeira Liga','1994-05-04',190.0,84.0,'Portugal',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fabrício dos Santos Messias','Portimonense','Primeira Liga','1990-03-28',182.0,75.0,'Brazil',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Pedro Azevedo Ferreira','Aves','Primeira Liga','1987-09-01',180.0,75.0,'Portugal',875000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Gomes Oliveira Conceição','Santa Clara','Primeira Liga','1996-07-19',182.0,75.0,'Brazil',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marko Bakić','Braga','Primeira Liga','1993-11-01',185.0,78.0,'Montenegro',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Miguel Filipe Nunes Cardoso','Tondela','Primeira Liga','1994-06-19',176.0,74.0,'Portugal',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wenderson Nascimento Galeno','Porto','Primeira Liga','1997-10-22',182.0,72.0,'Brazil',1500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Anderson Conceição Benedito','Desportivo das Chaves','Primeira Liga','1989-10-24',188.0,81.0,'Brazil',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Thiago Cardoso','Santa Clara','Primeira Liga','1991-08-04',185.0,82.0,'Brazil',925000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Matheus da Cunha Gomes','Santa Clara','Primeira Liga','1996-02-28',170.0,70.0,'Brazil',1500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cristian Arango','Aves','Primeira Liga','1995-03-09',180.0,78.0,'Colombia',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Eduardo Antônio Machado Teixeira','Santa Clara','Primeira Liga','1993-06-07',178.0,73.0,'Brazil',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tiago Galvão da Silva','Desportivo das Chaves','Primeira Liga','1989-08-24',185.0,78.0,'Brazil',925000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ronaldo Peña','Moreirense','Primeira Liga','1997-03-10',183.0,78.0,'Venezuela',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gian dos Santos Martins','Nacional','Primeira Liga','1993-04-02',184.0,74.0,'Brazil',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Junior Tallo','Vitoria de Guimaraes','Primeira Liga','1992-12-21',185.0,77.0,'Ivory Coast',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alfredo Kulembe Ribeiro','Belenenses','Primeira Liga','1990-03-27',170.0,68.0,'Angola',950000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Washington Santana da Silva','Aves','Primeira Liga','1989-01-20',183.0,79.0,'Brazil',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luis Henrique Farinhas Taffner','Feirense','Primeira Liga','1998-03-17',184.0,81.0,'Brazil',1400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Martins Teles','Rio Ave','Primeira Liga','1986-05-01',183.0,77.0,'Brazil',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wallyson Teixeira Mallmann','Sporting CP','Primeira Liga','1994-02-16',183.0,77.0,'Brazil',1300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hélder Luís Vieira Tavares','Tondela','Primeira Liga','1989-12-26',178.0,73.0,'Portugal',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gonçalo Filipe Oliveira Silva','Belenenses','Primeira Liga','1991-06-04',185.0,80.0,'Portugal',900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ângelo Pelegrinelli Neto','Moreirense','Primeira Liga','1991-09-02',181.0,68.0,'Brazil',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tiago David Janeiro Caeiro','Belenenses','Primeira Liga','1984-03-29',192.0,84.0,'Portugal',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luis Felipe Dias do Nascimento','Vitoria de Setubal','Primeira Liga','1991-04-08',178.0,74.0,'Brazil',875000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diego Luiz Siqueira Medeiros','Nacional','Primeira Liga','1993-03-28',187.0,75.0,'Brazil',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Miguel Barbosa Queirós','Desportivo das Chaves','Primeira Liga','1984-08-08',180.0,73.0,'Portugal',500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Roberto Jesus Machado Beto Alves','Maritimo','Primeira Liga','1990-01-01',174.0,70.0,'Brazil',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Miguel Vieira Machado','Feirense','Primeira Liga','1992-11-04',168.0,62.0,'Portugal',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wilson Miguéis Manafá Jancó','Portimonense','Primeira Liga','1994-07-23',174.0,69.0,'Portugal',1200000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Heliardo Vieira da Silva','Tondela','Primeira Liga','1991-12-14',190.0,84.0,'Brazil',975000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Paulo Jorge Pedro Lopes','Benfica','Primeira Liga','1978-06-29',184.0,76.0,'Portugal',50000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jesús Hernández','Belenenses','Primeira Liga','1993-01-06',182.0,80.0,'Venezuela',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marcos André Costa Valente','Vitoria de Guimaraes','Primeira Liga','1994-02-04',196.0,90.0,'Portugal',900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jefferson De Jesus Santos','Desportivo das Chaves','Primeira Liga','1993-04-14',192.0,85.0,'Brazil',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Valencia','Feirense','Primeira Liga','1991-12-18',185.0,82.0,'Colombia',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno André Freitas Monteiro','Tondela','Primeira Liga','1984-10-05',177.0,72.0,'Portugal',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Abel Barbosa Ferreira','Portimonense','Primeira Liga','1989-12-03',188.0,82.0,'Portugal',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mateusz Zachara','Tondela','Primeira Liga','1990-03-27',180.0,75.0,'Poland',825000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Abenego Tembeng','Tondela','Primeira Liga','1991-09-13',188.0,80.0,'Cameroon',800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alan Eduardo Schons','Moreirense','Primeira Liga','1993-05-24',180.0,74.0,'Brazil',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Joaquim Claude Gonçalves Araújo','Tondela','Primeira Liga','1994-04-09',174.0,68.0,'Portugal',925000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mama Samba Baldé','Aves','Primeira Liga','1995-11-06',181.0,75.0,'Guinea Bissau',975000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Miguel Aires Fernandes Olivera','Vitoria de Guimaraes','Primeira Liga','1994-05-25',196.0,98.0,'Portugal',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sueliton Florêncio Nogueira','Vitoria de Guimaraes','Primeira Liga','1991-06-26',184.0,78.0,'Brazil',775000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Robert Murić','Braga','Primeira Liga','1996-03-12',180.0,72.0,'Croatia',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Yuri Oliveira Ribeiro','Rio Ave','Primeira Liga','1997-01-24',175.0,74.0,'Portugal',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Piqueti Djassi Brito Silva','Maritimo','Primeira Liga','1993-02-12',173.0,72.0,'Guinea Bissau',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fernando Manuel Ferreira Fonseca','Santa Clara','Primeira Liga','1997-03-14',182.0,75.0,'Portugal',1100000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sérgio Filipe da Silva Barge','Feirense','Primeira Liga','1984-01-04',174.0,69.0,'Portugal',290000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Charalampos Kyriakou','Santa Clara','Primeira Liga','1995-02-09',180.0,74.0,'Cyprus',975000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cláudio Falcão Santos','Aves','Primeira Liga','1994-07-03',170.0,62.0,'Brazil',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael Leme Amorim','Tondela','Primeira Liga','1987-07-30',196.0,85.0,'Brazil',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tyler Boyd','Tondela','Primeira Liga','1994-12-30',170.0,74.0,'New Zealand',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Iván Bulos','Boavista','Primeira Liga','1993-05-20',186.0,82.0,'Peru',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Joel António Soares Ferreira','Santa Clara','Primeira Liga','1992-01-10',180.0,72.0,'Portugal',825000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marco António Garcia Pinto','Aves','Primeira Liga','1988-03-22',181.0,76.0,'Portugal',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Vítor Moreira Semedo','Vitoria de Setubal','Primeira Liga','1985-01-11',181.0,80.0,'Portugal',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Carlos Rocha Rodrigues','Feirense','Primeira Liga','1986-08-13',186.0,85.0,'Portugal',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Chris Willock','Benfica','Primeira Liga','1998-01-31',178.0,67.0,'England',1600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'David Dias Resende Bruno','Tondela','Primeira Liga','1992-02-14',175.0,69.0,'Portugal',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Robson Januario de Paula','Boavista','Primeira Liga','1994-02-14',181.0,73.0,'Brazil',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Héctor Quiñones','Nacional','Primeira Liga','1992-03-17',178.0,70.0,'Colombia',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jorge Samuel Fernandes','Tondela','Primeira Liga','1996-01-30',167.0,60.0,'Portugal',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Paulo Santos da Costa','Porto','Primeira Liga','1996-02-02',185.0,78.0,'Portugal',800000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bernardo Oliveira Dias','Belenenses','Primeira Liga','1997-01-04',175.0,66.0,'Portugal',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Antonio Briseño','Feirense','Primeira Liga','1994-02-05',184.0,72.0,'Mexico',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Ricardo Valdez Wilson','Braga','Primeira Liga','1996-12-27',192.0,86.0,'Portugal',825000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Vasco Santos de Miranda','Tondela','Primeira Liga','1994-12-26',180.0,75.0,'Portugal',925000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gildo Lourenço Vilanculos','Maritimo','Primeira Liga','1995-01-31',171.0,64.0,'Mozambique',900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tomás Martins Podstawski','Vitoria de Setubal','Primeira Liga','1995-01-30',180.0,72.0,'Portugal',900000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Abner Felipe Souza de Almeida','Santa Clara','Primeira Liga','1996-05-30',175.0,75.0,'Brazil',1000000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Aymen Tahar','Boavista','Primeira Liga','1989-10-02',176.0,70.0,'Algeria',550000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Miguel Silva Rocha','Aves','Primeira Liga','1985-03-06',175.0,72.0,'Portugal',350000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Filipe Tinoco Monteiro','Santa Clara','Primeira Liga','1994-01-30',192.0,85.0,'Portugal',775000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Pedro Pinto Trabulo','Tondela','Primeira Liga','1994-08-22',189.0,76.0,'Portugal',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Victor Guilherme Massaia','Desportivo das Chaves','Primeira Liga','1992-02-09',190.0,85.0,'Brazil',650000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Pedro Pereira Silva','Feirense','Primeira Liga','1990-05-21',187.0,77.0,'Portugal',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Duarte Teixeira Góis','Nacional','Primeira Liga','1990-05-05',174.0,66.0,'Portugal',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Cleylton Santos','Belenenses','Primeira Liga','1993-03-19',190.0,90.0,'Brazil',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nick Ansell','Tondela','Primeira Liga','1994-02-02',186.0,84.0,'Australia',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Manuel da Mota Pinto','Vitoria de Setubal','Primeira Liga','1994-11-08',187.0,78.0,'Portugal',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Filipe Rocha Costa','Boavista','Primeira Liga','1995-05-03',169.0,68.0,'Portugal',950000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Edilson Alberto Sanches Borges','Maritimo','Primeira Liga','1995-01-17',185.0,79.0,'Cape Verde',825000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Lucas Possignolo','Portimonense','Primeira Liga','1994-05-11',185.0,79.0,'Brazil',650000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Carlos Anastácio Henriques','Portimonense','Primeira Liga','1993-07-07',185.0,78.0,'Portugal',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Merlin Tandjigora','Belenenses','Primeira Liga','1990-04-06',172.0,68.0,'Gabon',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Manuel David Afonso','Sporting CP','Primeira Liga','1994-03-03',185.0,71.0,'Angola',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Assis Giovanaz','Boavista','Primeira Liga','1989-10-04',187.0,92.0,'Brazil',375000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ewerton da Silva Pereira','Portimonense','Primeira Liga','1992-12-01',179.0,69.0,'Brazil',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ahmed Sayed','Moreirense','Primeira Liga','1996-01-10',174.0,67.0,'Egypt',825000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Chidera Ezeh','Portimonense','Primeira Liga','1997-10-02',186.0,69.0,'Nigeria',775000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Davidson da Luz Pereira','Desportivo das Chaves','Primeira Liga','1991-03-05',177.0,70.0,'Brazil',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Lucas Queirós','Porto','Primeira Liga','1999-01-05',185.0,80.0,'Portugal',850000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jorman Aguilar','Santa Clara','Primeira Liga','1994-09-11',181.0,71.0,'Panama',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rui Pedro Coimbra Chaves','Tondela','Primeira Liga','1990-09-11',189.0,79.0,'Portugal',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jean Cleber Santos da Silva','Maritimo','Primeira Liga','1990-04-29',180.0,80.0,'Brazil',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Filipe Couto Patrão','Desportivo das Chaves','Primeira Liga','1990-01-22',175.0,69.0,'Portugal',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro José Moreira da Silva','Sporting CP','Primeira Liga','1997-02-13',189.0,76.0,'Portugal',775000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jacob Adebanjo','Vitoria de Setubal','Primeira Liga','1993-09-05',184.0,78.0,'Nigeria',625000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alejandro Rodríguez Gorrín','Boavista','Primeira Liga','1993-08-01',177.0,70.0,'Spain',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Lumor Agbenyenu','Portimonense','Primeira Liga','1996-08-10',175.0,70.0,'Ghana',850000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Everton Nascim. de Mendonça','Maritimo','Primeira Liga','1993-07-03',186.0,81.0,'Brazil',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rui Gabriel Pinheiro Vieira','Rio Ave','Primeira Liga','1991-11-13',189.0,83.0,'Portugal',475000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Baleia Janota','Tondela','Primeira Liga','1987-03-10',190.0,86.0,'Portugal',350000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mohamed Abarhoun','Moreirense','Primeira Liga','1989-05-03',187.0,75.0,'Morocco',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Pedro Salazar da Graça','Feirense','Primeira Liga','1995-06-18',177.0,70.0,'Portugal',775000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Francisco Loureiro Afonso','Nacional','Primeira Liga','1997-04-24',176.0,69.0,'Portugal',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rodrigo Alves Soares','Aves','Primeira Liga','1992-12-26',176.0,71.0,'Brazil',625000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jhonatan Luiz Siqueira','Moreirense','Primeira Liga','1991-05-08',189.0,79.0,'Brazil',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno Miguel Adro Tomás','Belenenses','Primeira Liga','1995-09-15',184.0,84.0,'Portugal',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Frédéric Ferreira Maciel','Moreirense','Primeira Liga','1994-03-15',175.0,65.0,'Portugal',750000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wesley Dias Dias Claudino','Santa Clara','Primeira Liga','1995-06-22',178.0,68.0,'Brazil',650000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ibson Pereira de Melo','Maritimo','Primeira Liga','1989-10-08',179.0,74.0,'Brazil',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wilmar Jordán','Desportivo das Chaves','Primeira Liga','1990-10-17',181.0,85.0,'Colombia',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Filipe Santos Oliveira','Maritimo','Primeira Liga','1994-04-21',193.0,78.0,'Portugal',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Emmanuel Hackman','Portimonense','Primeira Liga','1995-05-14',187.0,76.0,'Ghana',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gustavo H. Barbosa Freire','Santa Clara','Primeira Liga','1996-01-11',179.0,70.0,'Brazil',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Luís Carlos Santos Ribeiro','Santa Clara','Primeira Liga','1992-04-19',187.0,81.0,'Portugal',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Samuel Cruz Moura','Tondela','Primeira Liga','1988-12-14',184.0,76.0,'Portugal',325000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Christian Neiva Afonso','Feirense','Primeira Liga','1994-12-10',181.0,74.0,'Portugal',675000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo José da Silva Fernandes','Belenenses','Primeira Liga','1994-10-28',193.0,79.0,'Portugal',400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Koffi Kouao','Moreirense','Primeira Liga','1998-05-20',173.0,65.0,'Ivory Coast',650000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Guilherme Gonçalves de Sousa','Moreirense','Primeira Liga','1995-05-13',190.0,78.0,'Portugal',625000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Ricardo Clarke','Boavista','Primeira Liga','1992-09-27',180.0,75.0,'Panama',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Filipe Pinto Leite','Porto','Primeira Liga','1999-01-23',188.0,73.0,'Portugal',850000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Awer Mabil','Nacional','Primeira Liga','1995-09-15',179.0,73.0,'Australia',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fahd Moufi','Tondela','Primeira Liga','1996-05-05',175.0,70.0,'Morocco',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Erick de Arruda Serafim','Braga','Primeira Liga','1997-12-10',173.0,65.0,'Brazil',775000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Wellington Nascimento Carvalho','Portimonense','Primeira Liga','1992-11-21',182.0,67.0,'Brazil',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gustavo Hebling de Aguiar','Portimonense','Primeira Liga','1996-04-05',173.0,66.0,'Brazil',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Alex Kakuba','Feirense','Primeira Liga','1991-06-12',177.0,72.0,'Uganda',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Pedro da Costa Gamboa','Maritimo','Primeira Liga','1996-08-31',187.0,80.0,'Portugal',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nikola Maraš','Desportivo das Chaves','Primeira Liga','1997-12-19',186.0,78.0,'Serbia',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Moreto Moro Cassamá','Porto','Primeira Liga','1998-02-16',165.0,55.0,'Portugal',950000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Fabricio Santos de Jesus','Maritimo','Primeira Liga','1992-06-13',177.0,75.0,'Brazil',500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Murilo Oliveira de Freitas','Tondela','Primeira Liga','1996-05-12',174.0,67.0,'Brazil',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sandro Rafael Veiga Cunha','Vitoria de Setubal','Primeira Liga','1992-04-30',166.0,58.0,'Portugal',550000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Leonardo Navacchio','Portimonense','Primeira Liga','1992-12-28',189.0,77.0,'Brazil',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Alexandre Antunes Pedrosa','Vitoria de Setubal','Primeira Liga','1997-04-12',185.0,70.0,'Portugal',725000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Caio Gobbo Secco','Feirense','Primeira Liga','1990-12-22',192.0,88.0,'Brazil',375000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Sunday Abalo','Rio Ave','Primeira Liga','1995-05-14',180.0,72.0,'Ghana',550000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gustavo Ermel','Feirense','Primeira Liga','1995-03-29',165.0,64.0,'Brazil',700000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Gilson Sequeira da Costa','Boavista','Primeira Liga','1996-09-24',183.0,77.0,'Portugal',650000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Nuno Alberto Macedo Pereira','Moreirense','Primeira Liga','1999-05-29',184.0,78.0,'Portugal',375000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Tavares Almeida','Feirense','Primeira Liga','1998-12-12',175.0,70.0,'Portugal',575000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Raphael Spiegel','Boavista','Primeira Liga','1992-12-19',196.0,88.0,'Switzerland',375000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marcel Alves Pereira','Portimonense','Primeira Liga','1992-10-16',187.0,79.0,'Brazil',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Theodoros Ryuki Panagopoulos','Portimonense','Primeira Liga','1995-07-31',179.0,73.0,'Japan',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Michał Miśkiewicz','Feirense','Primeira Liga','1989-01-20',194.0,92.0,'Poland',300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Dener Gomes Clemente','Portimonense','Primeira Liga','1992-03-13',185.0,76.0,'Brazil',450000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Leite de Sousa','Vitoria de Setubal','Primeira Liga','1993-08-08',176.0,67.0,'Portugal',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno da Silva Fonseca','Moreirense','Primeira Liga','1992-09-14',180.0,73.0,'Brazil',400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Francisco Simões Rodrigues','Vitoria de Guimaraes','Primeira Liga','1997-02-27',180.0,73.0,'Portugal',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Filipe José Lima Mendes','Belenenses','Primeira Liga','1985-06-17',194.0,88.0,'Portugal',210000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Junior Pius','Tondela','Primeira Liga','1995-12-20',193.0,86.0,'Nigeria',500000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'José Pedro Costa Leite','Feirense','Primeira Liga','1997-01-12',175.0,69.0,'Portugal',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hamdou Elhouni','Desportivo das Chaves','Primeira Liga','1994-02-12',175.0,67.0,'Libya',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Bruno Edgar Silva Almeida','Moreirense','Primeira Liga','1994-03-18',189.0,77.0,'Brazil',475000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Eliseu Mendja Soares Cassamá','Rio Ave','Primeira Liga','1994-02-06',184.0,74.0,'Guinea Bissau',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Raphael Rossi Branco','Boavista','Primeira Liga','1990-07-25',188.0,84.0,'Brazil',350000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Dráusio Luis Salia Gil','Maritimo','Primeira Liga','1991-08-21',188.0,86.0,'Brazil',400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Kelechi John','Rio Ave','Primeira Liga','1998-09-07',186.0,74.0,'Nigeria',525000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Jhonder Cádiz','Moreirense','Primeira Liga','1995-07-29',191.0,74.0,'Venezuela',550000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Cristiano Castro Gomes','Maritimo','Primeira Liga','1994-08-05',185.0,76.0,'Portugal',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Mile Svilar','Benfica','Primeira Liga','1999-08-27',188.0,82.0,'Belgium',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Thierry Ramos Graça','Santa Clara','Primeira Liga','1995-01-27',194.0,87.0,'Cape Verde',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Aidi Fulang Xisi','Boavista','Primeira Liga','1990-12-17',181.0,75.0,'China PR',350000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Paulo Silva Pinho','Nacional','Primeira Liga','1992-04-30',185.0,80.0,'Portugal',280000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Hendrio Araujo da Silva','Nacional','Primeira Liga','1994-05-16',181.0,74.0,'Brazil',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Duarte Beirão Valente','Santa Clara','Primeira Liga','1999-11-02',182.0,75.0,'Portugal',600000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'João Pedro Barradas Novais','Rio Ave','Primeira Liga','1993-07-10',179.0,73.0,'Portugal',400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Aylton Filipe Boa Morte','Santa Clara','Primeira Liga','1993-09-23',182.0,75.0,'Portugal',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Manuel Nogueira Sousa','Nacional','Primeira Liga','1997-07-16',175.0,67.0,'Portugal',475000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Amir Abedzadeh','Maritimo','Primeira Liga','1993-04-26',186.0,86.0,'Iran',290000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Emanuel Rodrigues Novo','Desportivo das Chaves','Primeira Liga','1992-08-26',191.0,84.0,'Portugal',290000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Miguel Serrano Romão Lázaro','Vitoria de Setubal','Primeira Liga','1995-04-24',193.0,79.0,'Portugal',300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Pedro Pinho Marques','Nacional','Primeira Liga','1998-03-18',180.0,65.0,'Portugal',425000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Marco Aurélio Ribeiro Sousa','Nacional','Primeira Liga','1995-01-29',185.0,70.0,'Portugal',300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Federico Falcone','Aves','Primeira Liga','1990-02-21',188.0,79.0,'Argentina',325000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Rafael Broetto Henrique','Maritimo','Primeira Liga','1990-08-18',195.0,87.0,'Brazil',250000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Yusupha Njie','Boavista','Primeira Liga','1994-01-03',188.0,78.0,'Gambia',400000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Flavio Medeiros da Silva','Boavista','Primeira Liga','1996-02-10',177.0,73.0,'Brazil',350000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Carlos Daniel Cevada Teixeira','Maritimo','Primeira Liga','1994-07-11',178.0,72.0,'Portugal',375000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Miguel Guedes Almeida','Feirense','Primeira Liga','1998-03-30',173.0,69.0,'Portugal',325000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Carlos Reinaldo Moreira Alves','Rio Ave','Primeira Liga','1998-02-19',187.0,80.0,'Portugal',300000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'André Martins de Sousa','Vitoria de Setubal','Primeira Liga','1998-02-26',174.0,59.0,'Portugal',350000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Allef Andrade Rodrigues','Vitoria de Setubal','Primeira Liga','1994-11-04',174.0,72.0,'Brazil',290000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Tiago André Araújo Rodrigues','Rio Ave','Primeira Liga','1997-01-18',182.0,70.0,'Portugal',290000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Kódjo Alphonse','Feirense','Primeira Liga','1993-05-28',180.0,74.0,'Ivory Coast',250000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Silvério Júnio Gonçalves da Silva','Rio Ave','Primeira Liga','1995-12-26',186.0,75.0,'Portugal',290000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Dele Alampasu','Feirense','Primeira Liga','1996-12-24',199.0,78.0,'Nigeria',280000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Stanley Awurum','Portimonense','Primeira Liga','1990-06-24',185.0,75.0,'Nigeria',170000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Victor Emanuel Araújo Ferreira','Rio Ave','Primeira Liga','1997-09-18',180.0,70.0,'Portugal',240000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Diogo Guedes Nunes','Boavista','Primeira Liga','1996-11-10',186.0,79.0,'Portugal',240000.0, '2018-01-01', '2020-01-01'
EXEC gestao_futebol.CriaJogador 'Miguel Ângelo Moreira Magalhães','Vitoria de Guimaraes','Primeira Liga','1999-04-19',174.0,58.0,'Portugal',180000.0, '2018-01-01', '2020-01-01'












DECLARE @IncID int
DECLARE @ClubID int

--Cria pessoas para serem treinadores
SET NOCOUNT ON;
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Nuno Oliveira','1989-23-02','633384');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Belenenses';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Bruno Lage','1924-12-14','71450');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Benfica';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Lito Vidigal','1954-12-13','5708');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Boavista';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Abel Ferreira','1982-03-21','96622');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Braga';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Jose Mota','1939-12-16','1694');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Chaves';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Augusto Inacio','1946-05-01','5151');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Desportivo das Aves';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Filipe Martins','1956-07-12','88697');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Feirense';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Petit','1988-04-03','79233');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Maritimo';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Ivo Vieira','1955-07-12','19637');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Moreirense';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Costinha','1973-01-03','68405');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Nacional';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Antonio Folha','1961-06-02','64647');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Portimonense';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Sergio Conceicao','1946-12-15','0303');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Porto';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Carlos Carvalhal','1927-07-08','38495');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Rio Ave';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Joao Henriques','1994-06-17','27707');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Santa Clara';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Marcel Keizer','1993-10-29','64583');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Sporting CP';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Pepa','1975-12-10','39279');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Tondela';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Luis Castro','1983-10-01','22814');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Vitoria de Guimaraes';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Sandro Mendes','1978-12-19','64633');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Vitoria de Setubal';
INSERT INTO gestao_futebol.treina_em([team],[coach], [data_ini], [data_fim]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01');

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Hakeem Zamora','1981-05-12','73904');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Hasad Austin','1964-06-06','0084');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Brian Barber','1963-05-11','86305');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Dylan Hopkins','1998-11-16','62617');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Slade Pruitt','1971-12-18','52977');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Brandon Holland','1974-11-08','88115');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Eagan Puckett','1935-12-17','33264');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Rahim Witt','1935-12-17','33151');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Nolan Bridges','1987-11-03','56338');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Gabriel Rowe','1972-09-21','97806');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Blaze Harrison','1977-05-22','88795');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Thaddeus Hatfield','1955-06-15','1823');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Brent Flynn','1961-04-17','39720');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Samson Bender','1936-05-06','30846');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Adam Merritt','1972-02-29','70886');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Hedley Prince','1958-08-31','47039');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Neil Lynch','1986-09-07','32451');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Walter Soto','1940-02-27','49005');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Byron Mitchell','1939-12-13','4956');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Brennan Pollard','1989-06-05','69875');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Harrison Vasquez','1973-04-15','22399');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Joseph Jarvis','1977-11-11','60808');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Blaze Riggs','1973-03-14','92814');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Vladimir Hooper','1990-10-10','8379');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.treinador([id_treinador],[t_principal]) VALUES (@IncID, 1);
SET NOCOUNT OFF;



--Cria estadios
EXEC gestao_futebol.CriaEstadio 'Benfica', 'Estadio da Luz',65647,'Rua José Maria Nicolau','2003-06-01';
EXEC gestao_futebol.CriaEstadio 'Porto' ,'Estadio do Dragao',60399,'Via Futebol Clube do Porto','2003-06-01';
EXEC gestao_futebol.CriaEstadio 'Sporting CP' ,'Estadio Jose Alvalade',50466,'Rua Professor Fernando da Fonseca','2003-06-01';
EXEC gestao_futebol.CriaEstadio 'Braga' ,'Estadio Municipal de Braga',30286,'Parque Norte Ap. 12 4700-087 Monte Castro','2003-12-30';
EXEC gestao_futebol.CriaEstadio 'Vitoria de Guimaraes' ,'Estadio Dom Afonso Henriques',30165,'Rua de São Gonçalo 505','1965-01-01';
EXEC gestao_futebol.CriaEstadio 'Moreirense' ,'Parque Desportivo Comendador Joaquim de Almeida Freitas',6000,'Joaquim de Almeida Freitas','1938-11-01';
EXEC gestao_futebol.CriaEstadio 'Rio Ave' ,'Estadio do Rio Ave Futebol Clube',1985,'Rua Dona Maria Pães Ribeiro','1939-05-10';
EXEC gestao_futebol.CriaEstadio 'Boavista' ,'Estadio do Bessa',20000,'Rua O Primeiro de Janeiro','2003-01-01';
EXEC gestao_futebol.CriaEstadio 'Belenenses' ,'Estadio do Restelo',25000,'Avenida da Ilha da Madeira','1956-09-23';
EXEC gestao_futebol.CriaEstadio 'Santa Clara' ,'Estadio Sao Miguel',13277,'Rua Comandante Jaime de Sousa 21','1930-01-01';
EXEC gestao_futebol.CriaEstadio 'Maritimo' ,'Estadio dos Barreiros',8992,'Rua do Dr. Pita','1970-01-01';
EXEC gestao_futebol.CriaEstadio 'Portimonense' ,'Estadio do Portimonense FC',9544,'Avenida Zeca Afonso Portimão','1914-08-14';
EXEC gestao_futebol.CriaEstadio 'Vitoria de Setubal' ,'Estadio do Bonfim',1962,'Praça Vitoria Futebol Clube','1962-09-16';
EXEC gestao_futebol.CriaEstadio 'Aves' ,'Estadio Clube Desportivo das Aves',8560,'Rua Luís Gonzaga Mendes de Carvalho 265','1981-01-01';
EXEC gestao_futebol.CriaEstadio 'Tondela' ,'Estadio Joao Cardoso',7500,'Rua Doutor Eurico José Gouveia','1933-07-06';
EXEC gestao_futebol.CriaEstadio 'Desportivo das Chaves' ,'Estadio Municipal Eng. Manuel Branco Teixeira',12000,'Avenida do Estádio Municipal','1930-01-01';
EXEC gestao_futebol.CriaEstadio 'Nacional' ,'Estadio da Madeira',8589,'Rua do Esmeraldo','1998-01-01';
EXEC gestao_futebol.CriaEstadio 'Feirense' ,'Estadio Marcolino de Castro',4667,'Avenida 25 de Abril 14','1962-01-01';




--Cria pessoas para serem presidentes


EXEC gestao_futebol.CriaPresidente 'Luis Vieira', '1928-12-22', '53223', 'Benfica','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Pinto da Costa','1928-12-22','53223', 'Porto','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Frederico Varandas','1928-12-22','53223', 'Sporting CP','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Antonio Salvador','1928-12-22','53223', 'Braga','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Julio Mendes','1928-12-22','53223', 'Vitoria de Guimaraes','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Domingos Vitor Abreu Magalhaes','1928-12-22','53223', 'Moreirense','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Joao Resende','1928-12-22','53223', 'Rio Ave','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Vitor Murta','1928-12-22','53223', 'Boavista','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Patrick Morais de Carvalho','1928-12-22','53223', 'Belenenses','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Rui Coordeiro','1928-12-22','53223', 'Santa Clara','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Carlos Pereira','1928-12-22','53223', 'Maritimo','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Rodiney Sampaio','1928-12-22','53223', 'Portimonense','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Vitor Hugo Valente','1928-12-22','53223', 'Vitoria de Setubal','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Armando Silva','1928-12-22','53223', 'Aves','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'David Belenguer','1928-12-22','53223', 'Tondela','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Bruno Carvalho','1928-12-22','53223', 'Desportivo das Chaves','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Rui Antonio Macedo Alves','1928-12-22','53223', 'Nacional','2018-01-01', '2020-01-01', 10;
EXEC gestao_futebol.CriaPresidente 'Rodrigo Nunes','1928-12-22','53223', 'Feirense','2018-01-01', '2020-01-01', 10;

 
SET NOCOUNT ON
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Luke Chapman','1983-02-07','17160');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Amery Juarez','1942-04-04','83089');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Norman Conrad','1948-03-18','66199');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Ezra Kane','1925-01-17','40325');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Raymond Jones','1967-03-04','13451');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Thane Blanchard','1926-01-21','62434');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Aristotle Chan','1996-06-17','61728');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Jasper Chaney','1955-04-25','7641');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Drew Pope','1991-08-25','50144');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Perry Reilly','1994-08-24','61915');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Nolan Martin','1958-07-04','25622');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Dexter Gross','1958-09-03','88820');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Michael Torres','1984-03-15','72589');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Blaze Lamb','1986-03-15','87131');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Samson Shepherd','1968-11-30','41372');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Kelly Hernandez','1990-04-06','13765');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Cruz Fowler','1971-07-22','45369');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Demetrius Reese','1979-03-07','66575');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Jermaine Adams','1951-01-25','69662');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Thor Hatfield','1948-08-16','82213');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Aristotle Boyle','1998-05-02','57955');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Coby Molina','1938-08-30','99939');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Isaiah Hendricks','1984-12-23','91238');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Carter Hardin','1951-11-06','73887');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Russell Maynard','1964-04-07','20533');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Alan Gilbert','1955-07-14','11574');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Nigel Norton','1985-07-15','88704');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Cyrus Willis','1947-02-15','58918');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Fitzgerald Kline','1945-01-10','63724');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Bruno Velez','1990-01-10','86927');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Tyler Robbins','1982-05-31','63865');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Giacomo Burton','1961-03-03','13883');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Randall Washington','1927-11-08','27589');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Judah Bender','1968-03-14','76978');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Jasper Booth','1937-09-02','75518');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Ryder Mooney','1976-05-14','23879');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Brendan Weber','1931-12-23','82879');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Tyler Valencia','1972-04-30','52077');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Elton Guthrie','1974-10-05','22638');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Deacon Hebert','1955-01-05','5331');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Akeem Norman','1986-04-25','89273');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Lawrence Hunter','1956-12-16','18573');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Odysseus Green','1972-06-21','33478');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Dorian Cline','1930-02-08','71866');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Colt Elliott','1944-06-01','74381');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Micah Santana','1972-11-26','63954');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Gabriel Hunt','1993-10-16','69644');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Warren Cash','1925-06-07','58223');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Lucas Romero','1940-06-04','43472');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Reed Reese','1950-11-02','89515');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Caldwell Sanchez','1986-12-10','80192');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Oscar Henderson','1952-05-18','29253');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Dieter Paul','1936-02-13','7665');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Brian Hines','1930-12-04','2551');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Kato Lynn','1964-04-21','77149');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Upton Ochoa','1958-07-23','20182');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Callum Salinas','1961-10-14','0883');
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Jonah Chan','1981-12-09','45414');

SET NOCOUNT OFF



--query--
--SELECT * FROM gestao_futebol.campeonato
--SELECT * FROM gestao_futebol.pessoa

--SELECT * FROM top_5_futebol.dbo.pessoa_result;

--Query--gestao_futebol.equipa

