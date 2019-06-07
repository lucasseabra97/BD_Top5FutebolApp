USE top_5_futebol
GO


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



CREATE FUNCTION gestao_futebol.TabelaGolosPorJogoHome (
    
)
RETURNS TABLE
AS
RETURN 

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

