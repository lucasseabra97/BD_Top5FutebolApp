--create database top_5_futebol
USE top_5_futebol
GO
--CREATE SCHEMA gestao_futebol
GO

CREATE TABLE gestao_futebol.jornada(
	data_jogo	  DATE NOT NULL
	PRIMARY KEY(data_jogo)
)

CREATE TABLE gestao_futebol.nacionalidade(
	nome       VARCHAR(30) NOT NULL,
	abreviacao VARCHAR(10) NOT NULL,
	PRIMARY KEY(nome)	
)

CREATE TABLE gestao_futebol.campeonato(
	id         INT NOT NULL IDENTITY(1,1),
	nome		         	VARCHAR(30) NOT NULL,
	nacionalidade			VARCHAR(30) NOT NULL
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
	nome       VARCHAR(30) NOT NULL,
	lotacao    INT NOT NULL,
	morada     VARCHAR(100),
	data_crons DATE NOT NULL,
	equipa      INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(equipa) REFERENCES gestao_futebol.equipa(id)
)

CREATE TABLE gestao_futebol.jogo(
	id         INT NOT NULL IDENTITY(1,1),
	n_jornada			   DATE NOT NULL ,
	estadio				   INT NOT NULL,
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
	PRIMARY KEY(id_jogo,minuto),
	FOREIGN KEY(jogador)    REFERENCES gestao_futebol.jogador(id_jogador)
)

CREATE TABLE gestao_futebol.pessoa_nacionalidade(
	pessoa		INT NOT NULL,
	naciona		VARCHAR(30) NOT NULL,
	PRIMARY KEY(pessoa,naciona),
	FOREIGN KEY(pessoa)		REFERENCES gestao_futebol.pessoa(id),
	FOREIGN KEY(naciona)    REFERENCES gestao_futebol.nacionalidade(nome),
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


INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Inglesa','ENG');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Espanhola','ES');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Intaliana','ITA');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Alema','GER');
INSERT INTO gestao_futebol.nacionalidade(nome,abreviacao) VALUES('Portuguesa','PT');

INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Premier League','Inglesa');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('La Liga','Espanhola');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Serie A','Intaliana');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Bundesliga','Alema');
INSERT INTO gestao_futebol.campeonato(nome,nacionalidade) VALUES('Primeira Liga','Portuguesa');


--Insert teams--
--Portuguese

DECLARE @Identity int

SELECT @Identity = id FROM [top_5_futebol].[gestao_futebol].[campeonato] where nome='Primeira Liga';


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


BULK INSERT gestao_futebol.pessoa_staging
FROM 'C:\Users\Andre Marques\Documents\BD\BD_Top5FutebolApp\csvFiles\pessoa_result.csv'
with
(
	FIELDTERMINATOR =',',
	ROWTERMINATOR ='\n'
)
--Copia para a tabela original
INSERT INTO gestao_futebol.pessoa(nome, data_nasc,salario) 
   SELECT nome, data_nasc,salario
   FROM gestao_futebol.pessoa_staging





DECLARE @IncID int
DECLARE @ClubID int

--Cria pessoas para serem treinadores
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








--Cria pessoas para serem presidentes
INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES('Pinto da Costa','1928-12-22','53223');
SET @IncID = SCOPE_IDENTITY();
INSERT INTO gestao_futebol.presidente([id_presidente]) VALUES (@IncID);
SELECT @ClubID = id FROM [top_5_futebol].[gestao_futebol].[equipa] where nome='Porto';
INSERT INTO gestao_futebol.preside_em([team],[president], [data_ini], [data_fim], [n_mandatos]) VALUES (@ClubID ,@IncID,'2018-01-01', '2020-01-01', 10);

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





--query--
--SELECT * FROM gestao_futebol.campeonato
--SELECT * FROM gestao_futebol.pessoa

--SELECT * FROM top_5_futebol.dbo.pessoa_result;

--Query--gestao_futebol.equipa

