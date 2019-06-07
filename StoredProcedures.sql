USE top_5_futebol
GO

CREATE PROC gestao_futebol.GetTeamInfo 
	--@id   INT
 AS
--SELECT *
SELECT equipa.id, equipa.nome, equipa.email, equipa.data_fund, camp.nome as campeonato, pessoa.nome as presidente, est.nome as estadio
FROM gestao_futebol.equipa as equipa JOIN gestao_futebol.campeonato as camp ON equipa.campeonato = camp.id
JOIN gestao_futebol.preside_em as preside_em ON preside_em.team = equipa.id
JOIN gestao_futebol.pessoa as pessoa ON pessoa.id = preside_em.president
JOIN gestao_futebol.estadio as est ON est.equipa = equipa.id
--WHERE @id=equipa.id

GO


------------------------------------------------------------------------------------------------------------------
CREATE PROC gestao_futebol.GetPlayerInfo 
	--@id   INT
 AS
--SELECT *
SELECT id, nome, data_nasc, salario, altura, peso, posicao
FROM gestao_futebol.pessoa as pessoa JOIN gestao_futebol.jogador as jogaror ON pessoa.id = id_jogador

GO


-------------------------------------------------------------------------------------------------------------------
CREATE PROC gestao_futebol.TabelaResultados
	--@id   INT
 AS
--SELECT *
CREATE TABLE #resultados(
	id		INT,
	h_team	INT,
	a_team	INT,
	h_score	INT,
	a_score	INT
)

INSERT INTO #resultados (id)
SELECT id FROM gestao_futebol.jogo

UPDATE #resultados
SET #resultados.h_team = jogo.h_team
FROM #resultados 
JOIN gestao_futebol.jogo as jogo
ON  #resultados.id = jogo.id

UPDATE #resultados
SET #resultados.a_team = jogo.a_team
FROM #resultados 
JOIN gestao_futebol.jogo as jogo
ON  #resultados.id = jogo.id

UPDATE #resultados
SET #resultados.h_score = h.h_score_c
FROM #resultados 
JOIN gestao_futebol.TabelaGolosPorJogoHome() as h
ON  h.id_jogo = #resultados.id

UPDATE #resultados
SET #resultados.a_score = h.a_score_c
FROM #resultados 
JOIN gestao_futebol.TabelaGolosPorJogoAway() as h
ON  h.id_jogo = #resultados.id




SELECT #resultados.id, h_team, a_team, ISNULL(h_score, 0 ) as h_score, ISNULL(a_score, 0 ) as a_score, equipa.nome as h_name, equipa2.nome as a_name
--SELECT *
FROM #resultados JOIN gestao_futebol.equipa as equipa on equipa.id = h_team
JOIN gestao_futebol.equipa as equipa2 on equipa2.id = a_team




--SELECT *
--FROM gestao_futebol.TabelaGolosPorJogoHome()

--SELECT * FROM #resultados

GO


-----------------------------------------------------------------------------------------------------------------

CREATE PROC gestao_futebol.GetPoints AS




CREATE TABLE #resultados(
	id		INT,
	h_team	INT,
	a_team	INT,
	h_score	INT,
	a_score	INT
)

INSERT INTO #resultados (id)
SELECT id FROM gestao_futebol.jogo

UPDATE #resultados
SET #resultados.h_team = jogo.h_team
FROM #resultados 
JOIN gestao_futebol.jogo as jogo
ON  #resultados.id = jogo.id

UPDATE #resultados
SET #resultados.a_team = jogo.a_team
FROM #resultados 
JOIN gestao_futebol.jogo as jogo
ON  #resultados.id = jogo.id

UPDATE #resultados
SET #resultados.h_score = h.h_score_c
FROM #resultados 
JOIN gestao_futebol.TabelaGolosPorJogoHome() as h
ON  h.id_jogo = #resultados.id

UPDATE #resultados
SET #resultados.a_score = h.a_score_c
FROM #resultados 
JOIN gestao_futebol.TabelaGolosPorJogoAway() as h
ON  h.id_jogo = #resultados.id



SELECT #resultados.id, h_team, a_team, ISNULL(h_score, 0 ) as h_score, ISNULL(a_score, 0 ) as a_score, equipa.nome as h_name, equipa2.nome as a_name INTO #res
--SELECT *
FROM #resultados JOIN gestao_futebol.equipa as equipa on equipa.id = h_team
JOIN gestao_futebol.equipa as equipa2 on equipa2.id = a_team

SELECT equipa.id, equipa.nome , sum 
	(
		case 
			when equipa.id=h_team and h_score > a_score then 3
			when equipa.id=a_team and h_score < a_score then 3
			when equipa.id=h_team and h_score = a_score then 1
			when equipa.id=a_team and h_score = a_score then 1
			else 0 
		end
	) pontos 
FROM #res as r
JOIN gestao_futebol.equipa as equipa ON equipa.id=r.h_team OR equipa.id=r.a_team
GROUP BY equipa.id, equipa.nome
ORDER BY pontos DESC

GO

-----------------------------------------------------------------------------------------------------------------

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








CREATE PROC gestao_futebol.CriaJogadorSimples (
	@nome			VARCHAR(100), 
	@data_nasc		VARCHAR(50),
	@altura				INT,
	@peso				INT,
	@posicao	VARCHAR(100),
	@salario		VARCHAR(50)
) AS

SET NOCOUNT ON;

INSERT INTO gestao_futebol.pessoa([nome],[data_nasc],[salario]) VALUES(@nome,@data_nasc,@salario);

DECLARE @IncID int
DECLARE @ClubID int
SET @IncID = SCOPE_IDENTITY();



INSERT INTO gestao_futebol.jogador([id_jogador], [altura], [peso]) VALUES (@IncID, @altura, @peso);







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

-----------------------------------------------------------------------



--CREATE PROCEDURE gestao_futebol.GolosPorJogo @id INT
--AS
----DECLARE @id INT;
--SET @id =2;
--select 
--    sum
--	(
--		case 
--			when @id=h_team and home_score > away_score then 3
--			when @id=a_team and home_score < away_score then 3
--			when @id=h_team and home_score = away_score then 1
--			when @id=a_team and home_score = away_score then 1
--			else 0 
--		end
--	) ExecCount
--	select *
--from gestao_futebol.Tabela()
--
--GO
--
---------------------------------------------------------------------------

