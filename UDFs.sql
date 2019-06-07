USE top_5_futebol
GO

CREATE FUNCTION gestao_futebol.GolosPorJogoFunction (
    
)
RETURNS TABLE
AS
RETURN 
(
--SELECT a1.id_jogo, a1.h_team, a1.a_team, e1.nome as name1, a1.home_score, e2.nome as name2, a2.away_score
SELECT a1.id_jogo, a1.h_team, a1.a_team, a1.home_score, a2.away_score
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
)
GO




---------------------------------------------------------------------------------------------------------





CREATE FUNCTION gestao_futebol.TabelaGolosPorJogo (
    
)
RETURNS TABLE
AS
RETURN 


SELECT *
FROM gestao_futebol.jogo as jogo
JOIN gestao_futebol.golo as golo ON jogo.id = golo.id_jogo
JOIN gestao_futebol.joga_em as joga_em ON golo.jogador = joga_em.player

GO
-------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------





CREATE FUNCTION gestao_futebol.TabelaGolosPorJogoHome (
    
)
RETURNS TABLE
AS
RETURN 



--SELECT jj.id, jj.n_jornada, jj.estadio, comboio.h_team as h, comboio.a_team as j, id_jogo, comboio.h_score_null, ISNULL(comboio.h_score_null, 0 ) as h_score_c, id_jogo
SELECT *, ISNULL(h_score_null, 0 ) as h_score_c
FROM gestao_futebol.jogo as jj left outer JOIN

	(SELECT  f.h_team as f_h_team, f.a_team as f_a_team, id_jogo, COUNT(*) as h_score_null


	FROM gestao_futebol.TabelaGolosPorJogo() as f JOIN gestao_futebol.jogo as j2 ON f.id=j2.id
	where team=f.h_team
	GROUP BY f.h_team, f.a_team, id_jogo) as comboio

ON comboio.id_jogo = jj.id


GO



---------------------------------------------------------------------------------------------------------





CREATE FUNCTION gestao_futebol.TabelaGolosPorJogoAway (
    
)
RETURNS TABLE
AS
RETURN 



SELECT *, ISNULL(a_score_null, 0 ) as a_score_c
FROM gestao_futebol.jogo as jj left outer JOIN

	(SELECT  f.h_team as f_h_team, f.a_team as f_a_team, id_jogo, COUNT(*) as a_score_null


	FROM gestao_futebol.TabelaGolosPorJogo() as f JOIN gestao_futebol.jogo as j2 ON f.id=j2.id
	where team=f.a_team
	GROUP BY f.h_team, f.a_team, id_jogo) as comboio

ON comboio.id_jogo = jj.id


GO

-------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------



--CREATE FUNCTION gestao_futebol.TabelaGolosPorJogoF (
--    
--)
--RETURNS @resultados TABLE(
--	id		INT,
--	h_team	INT,
--	a_team	INT,
--	h_score	INT,
--	a_score	INT
--)
--AS
--
--
--
--
--begin 
--
--
--DECLARE @resultados TABLE(
--	id		INT,
--	h_team	INT,
--	a_team	INT,
--	h_score	INT,
--	a_score	INT
--)
--
--
--
--INSERT INTO @resultados (id)
--SELECT id FROM gestao_futebol.jogo
--
--
--INSERT INTO @resultados(h_team)
--SET @resultados.h_team = jogo.h_team
--FROM gestao_futebol.jogo as jogo 
--JOIN @resultados as r
--ON  r.id = jogo.id
--
--INSERT INTO @resultados(h_team) 
----SELECT *
--(
--SELECT jogo.h_team
--FROM gestao_futebol.jogo as jogo   
--JOIN @resultados as r 
--ON  r.id = jogo.id)
--
--SELECT *
--FROM @resultados
--
--
--INSERT INTO @resultados(a_team)
--SELECT jogo.a_team
--FROM @resultados as r
--JOIN gestao_futebol.jogo as jogo
--ON  r.id = jogo.id
--
--INSERT INTO @resultados(h_score)
--SELECT h.h_score_c
--FROM @resultados as r
--JOIN gestao_futebol.TabelaGolosPorJogoHome() as h
--ON  h.id_jogo = r.id
--
--INSERT INTO @resultados(a_score)
--SELECT  h.a_score_c
--FROM @resultados as r
--JOIN gestao_futebol.TabelaGolosPorJogoAway() as h
--ON  h.id_jogo = r.id
--
--
--
--INSERT INTO @resultados(h_score)
--SELECT ISNULL(h_score, 0 ) FROM @resultados
--
--
--INSERT INTO @resultados(a_score)
--SELECT ISNULL(a_score, 0 ) FROM @resultados
--
--
--
----SELECT @resultados.id, h_team, a_team, ISNULL(h_score, 0 ) as h_score, ISNULL(a_score, 0 ) as a_score, equipa.nome as h_name, equipa2.nome as a_name
------SELECT *
----FROM @resultados JOIN gestao_futebol.equipa as equipa on equipa.id = h_team
----JOIN gestao_futebol.equipa as equipa2 on equipa2.id = a_team
--return
--end
--
--GO


-----------------------------------------------------------------------------------------------------------------------------------


CREATE FUNCTION gestao_futebol.TabelaPontosPorEquipa (
    
)
RETURNS TABLE AS
RETURN
--SELECT *
--FROM gestao_futebol.equipa as equipa
--JOIN gestao_futebol.TabelaGolosPorJogoF


SELECT *
FROM gestao_futebol.TabelaGolosPorJogoF()



GO