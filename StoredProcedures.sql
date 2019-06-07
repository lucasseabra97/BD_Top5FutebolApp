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



-----------------------------------------------------------------------------------------------------------------
CREATE PROC gestao_futebol.GetPoints (
	@id   INT
) AS


 (SELECT a1.id_jogo, a1.h_team, a1.a_team, e1.nome, a1.home_score, e2.nome, a2.away_score
--SELECT *
FROM 
(
SELECT id_jogo, h_team, a_team,  COUNT(*) as home_score
FROM [top_5_futebol].[gestao_futebol].jogo as jogo JOIN [top_5_futebol].[gestao_futebol].golo as golo ON jogo.id = golo.id_jogo
JOIN [top_5_futebol].[gestao_futebol].pessoa AS pessoa ON golo.jogador = pessoa.id
JOIN [top_5_futebol].[gestao_futebol].joga_em as jogaem ON pessoa.id=jogaem.player
WHERE team=h_team
GROUP BY id_jogo, h_team, a_team
)
as a1 
JOIN 
(
SELECT id_jogo, h_team, a_team,  COUNT(*)as away_score
FROM [top_5_futebol].[gestao_futebol].jogo as jogo JOIN [top_5_futebol].[gestao_futebol].golo as golo ON jogo.id = golo.id_jogo
JOIN [top_5_futebol].[gestao_futebol].pessoa AS pessoa ON golo.jogador = pessoa.id
JOIN [top_5_futebol].[gestao_futebol].joga_em as jogaem ON pessoa.id=jogaem.player
WHERE team=a_team
GROUP BY id_jogo, h_team, a_team
)

as a2 
ON a1.id_jogo=a2.id_jogo 
JOIN [top_5_futebol].[gestao_futebol].equipa as e1 on a1.h_team=e1.id
JOIN [top_5_futebol].[gestao_futebol].equipa as e2 on a1.a_team=e2.id
);



GO

--EXEC gestao_futebol.GetTeamInfo 2
--EXEC gestao_futebol.GetPoints 2

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




CREATE PROCEDURE gestao_futebol.GolosPorJogo @id INT
AS
--DECLARE @id INT;
SET @id =2;
select 
    sum
	(
		case 
			when @id=h_team and home_score > away_score then 3
			when @id=a_team and home_score < away_score then 3
			when @id=h_team and home_score = away_score then 1
			when @id=a_team and home_score = away_score then 1
			else 0 
		end
	) ExecCount
from gestao_futebol.GolosPorJogoFunction()

GO

---------------------------------------------------------------------------

