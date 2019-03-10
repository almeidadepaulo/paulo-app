

-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_BKN503_CARTEIRA_BAIXADA_MENSAL]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_BKN503_CARTEIRA_BAIXADA_MENSAL]
GO


-- Cria Procedure
CREATE PROCEDURE [dbo].[SP_BKN503_CARTEIRA_BAIXADA_MENSAL]
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERA��O  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Weslei Freitas                                               ::
  :: DATA       : 10/05/2013                                   VERS�O SP: 4    ::
  :: ALTERA��O  : BKN504_DT_MOVTO Numeric(8) -> : BKN504_DT_MOVTO Numeric(6)   ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: F�bio Bernardo                                               ::
  :: DATA       : 27/03/2013                                   VERS�O SP: 3    ::
  :: ALTERA��O  : produto por perfil										   ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: F�bio Bernardo                                               ::
  :: DATA       : 20/03/2013                                   VERS�O SP: 2    ::
  :: ALTERA��O  : Agrupamento por produto									   ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: F�bio Bernardo                                               ::
  :: DATA       : 20/03/2013                                   VERS�O SP: 1    ::
  :: ALTERA��O  : Atualizada no FLEX										   ::
  ::---------------------------------------------------------------------------::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

  /*-------------------------------------------------------------------------------
  PARAMETROS DE ENTRADA
  ----------------------------------------------------------------------------------*/
  @ENT_NR_VRS				VARCHAR(4),     /* ENTRADA DA VERSAO DO MODULO			*/
  @ENT_DT_MOVTO				NUMERIC(6),     /* Data do movimento 1o. dia do mes		*/
  @ENT_NR_BANCO				NUMERIC(8),		/* N�m. do banco						*/
  @ENT_NR_CESS				NUMERIC(8),		/* N�m. do cession�rio = -1 p/ todos	*/
  @ENT_NR_PROD				NUMERIC(8),		/* N�m. do produto = -1 p/ todos		*/
  @ENT_NR_USR				NUMERIC(8)  	/* N�m. do usu�rio = -1 p/ tudo			*/
  /*--------------------------------------------------------------------------------*/
  
WITH ENCRYPTION
AS

-- Configura Procedure
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

-- Inicio da Procedure
SELECT 
	BKN005_NR_PROD,
	BKN005_NM_PROD,
	BKN503_NR_TPPAG,
	BKN501_NM_TPPAG,
	BKN501_TP_FINANC,

	SUM(BKN503_QT_TITULO)	AS QT_TITULO,
	SUM(BKN503_TT_TITULO)	AS TT_TITULO,
	SUM(BKN503_TT_ACRE)		AS TT_ACRE,
	SUM(BKN503_TT_DESC)		AS TT_DESC,
	SUM(BKN503_TT_LIQ)		AS TT_LIQ,
	SUM(CASE
			WHEN BKN501_TP_FINANC = 'S' THEN BKN503_TT_LIQ
			ELSE 0
		END) AS TT_FINANCEIRO,
	SUM(CASE
			WHEN BKN501_TP_FINANC = 'N' THEN BKN503_TT_LIQ
			ELSE 0
		END) AS TT_NAOFINANCEIRO
FROM  BKN503 AS BKN503

LEFT JOIN BKN501 AS BKN501
ON	BKN501_NR_BANCO = BKN503_NR_BANCO 
AND BKN501_NR_TPPAG = BKN503_NR_TPPAG

LEFT JOIN BKN005 AS BKN005
ON BKN005_NR_PROD = BKN503_NR_PROD
AND BKN005_NR_BANCO = BKN503_NR_BANCO

WHERE  BKN503_DT_MOVTO = @ENT_DT_MOVTO
	AND (BKN503_NR_BANCO = @ENT_NR_BANCO)
--	AND (@ENT_NR_PROD = -1  OR  BKN503_NR_PROD = @ENT_NR_PROD) - alterado abaixo - versao 3

		AND (	-- UM PRODUTO
				(@ENT_NR_PROD <> -1  AND  BKN503_NR_PROD = @ENT_NR_PROD)
			OR   -- TODOS PRODUTOS
				(@ENT_NR_PROD  = -1  AND @ENT_NR_USR  = -1) 

			OR   -- PRODUTOS DO PERFIL DO USUARIO
				(@ENT_NR_PROD  = -1 AND @ENT_NR_USR <> -1 AND BKN503_NR_PROD IN 
					(SELECT PERFIL_PRODUTO.PRO_ID FROM IMS.PERFIL_USUARIO AS PERFIL_USUARIO
						LEFT JOIN IMS.PERFIL_PRODUTO AS PERFIL_PRODUTO
						ON PERFIL_PRODUTO.PER_ID = PERFIL_USUARIO.USU_PER_ID
						WHERE PERFIL_USUARIO.USU_ID= @ENT_NR_USR)
				)
		)

	AND (    -- UM CESSIONARIO
			(@ENT_NR_CESS <> -1 AND BKN503_NR_CESS = @ENT_NR_CESS) 
		OR   -- TODOS CESSIONARIOS
			(@ENT_NR_CESS  = -1 AND @ENT_NR_USR  = -1) 
		OR   -- CESSIONARIOS DO USUARIO
			(@ENT_NR_CESS  = -1 AND @ENT_NR_USR <> -1 AND BKN503_NR_CESS IN 
			(SELECT ins_id FROM ims.USUARIO_INSTITUICAO WHERE usu_id=@ENT_NR_USR))
	)



GROUP BY 
	BKN005_NR_PROD,
	BKN005_NM_PROD,
	BKN503_NR_TPPAG,
	BKN501_NM_TPPAG,
	BKN501_TP_FINANC
	
ORDER BY	
	BKN005_NR_PROD,
	BKN005_NM_PROD,
	BKN503_NR_TPPAG
		

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:

  
-------------------------------------------------------------------------------*/






GO



