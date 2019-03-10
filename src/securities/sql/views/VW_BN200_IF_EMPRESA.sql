-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN200_IF_EMPRESA]'))
DROP VIEW [dbo].[VW_BN200_IF_EMPRESA]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN200_IF_EMPRESA]
WITH ENCRYPTION
AS
  SELECT 
      	
	BN200.BN200_NR_GRUPO
	,BN200.BN200_NR_INST
	,BN200.BN200_NR_CNPJ
	--,BN200.BN200_NR_REME	
	--,BN200.BN200_NR_PROD
	--,BN200.BN200_NR_BANCETIP
	,BN200.BN200_NM_EEMCCB
	
	,(	SELECT
			TOP 1 BN200_ULTIMO.BN200_NR_CNAESUBC
		FROM BN200 AS BN200_ULTIMO
		WHERE 
			BN200_ULTIMO.BN200_NR_GRUPO     = BN200.BN200_NR_GRUPO    
		AND BN200_ULTIMO.BN200_NR_INST      = BN200.BN200_NR_INST    
		AND BN200_ULTIMO.BN200_NR_CNPJ      = BN200.BN200_NR_CNPJ
		ORDER BY BN200_ULTIMO.BN200_DT_ATUSIS DESC
	) AS BN200_NR_CNAESUBC


	,(	SELECT
			TOP 1 BN200_ULTIMO.BN200_LT_ENDEEMP
		FROM BN200 AS BN200_ULTIMO
		WHERE 
			BN200_ULTIMO.BN200_NR_GRUPO     = BN200.BN200_NR_GRUPO    
		AND BN200_ULTIMO.BN200_NR_INST      = BN200.BN200_NR_INST    
		AND BN200_ULTIMO.BN200_NR_CNPJ      = BN200.BN200_NR_CNPJ
		ORDER BY BN200_ULTIMO.BN200_DT_ATUSIS DESC
	) AS BN200_LT_ENDEEMP

	--,BN200.BN200_LT_ENDEEMP
	--,BN200.BN200_LT_BAIRROEMP
	--,BN200.BN200_LT_CIDADEEMP
	--,BN200.BN200_LT_UFEMP
	--,BN200.BN200_NR_CEPEMP
		

	,(	SELECT
			TOP 1 BN200_ULTIMO.BN200_QT_QTDEIF
		FROM BN200 AS BN200_ULTIMO
		WHERE 
			BN200_ULTIMO.BN200_NR_GRUPO     = BN200.BN200_NR_GRUPO    
		AND BN200_ULTIMO.BN200_NR_INST      = BN200.BN200_NR_INST    
		AND BN200_ULTIMO.BN200_NR_CNPJ      = BN200.BN200_NR_CNPJ
		ORDER BY BN200_ULTIMO.BN200_DT_ATUSIS DESC
	) AS BN200_QT_QTDEIF


	--,BN200.BN200_QT_TTCONTRA
	--,BN200.BN200_LT_RATEMP
	--,BN200.BN200_LT_RATCALCFGC

	,(	SELECT
			TOP 1 BN200_ULTIMO.BN200_LT_RATCALCBC
		FROM BN200 AS BN200_ULTIMO
		WHERE 
			BN200_ULTIMO.BN200_NR_GRUPO     = BN200.BN200_NR_GRUPO    
		AND BN200_ULTIMO.BN200_NR_INST      = BN200.BN200_NR_INST    
		AND BN200_ULTIMO.BN200_NR_CNPJ      = BN200.BN200_NR_CNPJ
		ORDER BY BN200_ULTIMO.BN200_DT_ATUSIS DESC
	) AS BN200_LT_RATCALCBC

	,(	SELECT
			TOP 1 BN200_ULTIMO.BN200_LT_RISKSCOR
		FROM BN200 AS BN200_ULTIMO
		WHERE 
			BN200_ULTIMO.BN200_NR_GRUPO     = BN200.BN200_NR_GRUPO    
		AND BN200_ULTIMO.BN200_NR_INST      = BN200.BN200_NR_INST    
		AND BN200_ULTIMO.BN200_NR_CNPJ      = BN200.BN200_NR_CNPJ
		ORDER BY BN200_ULTIMO.BN200_DT_ATUSIS DESC
	) AS BN200_LT_RISKSCOR
	

	--,BN200.BN200_VL_TTREME 
	--,BN200.BN200_VL_TTCONTRA
	--,BN200.BN200_VL_CNPJXREME
	--,BN200.BN200_VL_CNPJXPR1 
	--,BN200.BN200_DT_GRAVREME 
	--,BN200.BN200_ST_EMPRESA
	--,BN200.BN200_ST_CONCREME
	--,BN200.BN200_ST_CONCNPJ
	--,BN200.BN200_NR_OPESIS
	--,BN200.BN200_DT_INCSIS
	--,BN200.BN200_DT_ATUSIS

	/*
	,BN200_TP_CLIENTE = 
	CASE
    	WHEN BN200.BN200_QT_QTDEIF = 1 THEN 'E'
        ELSE 'C'
    END
	*/
			
	--,VW_BN019_ST_ATUAL.BN019_NR_STATUS_MAX
	--,VW_BN019_ST_ATUAL.BN019_NR_STATUSP
	
	--,VW_BN019_ST_ATUAL.BN201_NR_PROD
	
	--,VW_BN019_ST_ATUAL.BN004_VL_RISKCOR

	,BN001.BN001_NR_GRUPO
	,BN001.BN001_NM_GRUPO
	
	,BN002.BN002_NR_INST
	,BN002.BN002_NM_INST
	
		
	-- QUANTIDADE DE IF QUE A EMPRESA POSSUI OPERA��ES NO SISTEMA DO DPGE
	,ISNULL(
		(
		SELECT COUNT(*)
		FROM 
		(
			SELECT	
					BN200_COUNT.BN200_NR_GRUPO
					,BN200_COUNT.BN200_NR_INST
			FROM	BN200 AS BN200_COUNT
			WHERE	BN200_COUNT.BN200_NR_CNPJ	= BN200.BN200_NR_CNPJ
			GROUP BY
					BN200_COUNT.BN200_NR_GRUPO
					,BN200_COUNT.BN200_NR_INST
		) as subquery

	),0)	AS BN200_QT_QTDEIFFGC
	

	-- TOTAL DE CONTRATOS QUE A EMPRESA POSSUI ATIVOS (STATUS LIBERADO E PR�VIA DESBLOQUEIO)
	,ISNULL(
		(
			SELECT	COUNT(BN201_VL_TCONTRA) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST	= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ	= BN200.BN200_NR_CNPJ
			AND BN201_ST_CONTRATO IN('L','P')
		),0
	)	AS BN200_QT_CONTRA_ATIVO
	

	-- VALOR TOTAL DOS CONTRATOS QUE A EMPRESA POSSUI ATIVOS (STATUS LIBERADO E PR�VIA DESBLOQUEIO)
	,ISNULL(
		(
			SELECT	
					SUM(BN201_VL_TCONTRA) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST	= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ	= BN200.BN200_NR_CNPJ
			AND BN201_ST_CONTRATO IN('L','P')
		),0			
	)AS BN200_TT_CONTRA_ATIVO
	
	/*
	-- TOTAL DE CONTRATOS (ATUALIZADO) (STATUS LIBERADO E PR�VIA DESBLOQUEIO)
	,ISNULL(
		(
			SELECT	
					SUM(BN201_VL_CONTRATU) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST	= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ	= BN200.BN200_NR_CNPJ
			AND BN201_ST_CONTRATO IN('L','P')
		),0			
	)AS BN200_QT_CONTRATU
	*/
	
	
	-- VALOR TOTAL DOS CONTRATOS (ATUALIZADO) (STATUS LIBERADO E PR�VIA DESBLOQUEIO)
	,ISNULL(
		(
			SELECT	
					SUM(BN201_VL_CONTRATU) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST	= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ	= BN200.BN200_NR_CNPJ
			AND BN201_ST_CONTRATO IN('L','P')
		),0			
	)AS BN200_TT_CONTRATU		
	
			
	-- TOTAL DE CONTRATOS QUE A EMPRESA POSSUI INATIVOS (STATUS <> LIBERADO E PR�VIA DESBLOQUEIO)
	,ISNULL(
		(
			SELECT	COUNT(BN201_VL_TCONTRA) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST	= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ	= BN200.BN200_NR_CNPJ
			AND BN201_ST_CONTRATO NOT IN('L','P')
		),0
	)	AS BN200_QT_CONTRA_INATIVO
	
			
	-- VALOR TOTAL DOS CONTRATOS QUE A EMPRESA POSSUI INATIVOS (STATUS <> LIBERADO E PR�VIA DESBLOQUEIO)
	,ISNULL(
		(
			SELECT	
					SUM(BN201_VL_TCONTRA) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST	= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ	= BN200.BN200_NR_CNPJ
			AND BN201_ST_CONTRATO NOT IN('L','P')
		),0			
	)AS BN200_TT_CONTRA_INATIVO
	
	/*
	--  TOTAL DOS CONTRATOS APROVADOS NA REMESSA
	,ISNULL(
		(
			SELECT	
					COUNT(1) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO		= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST		= BN200.BN200_NR_INST
			AND BN201_NR_CNPJ		= BN200.BN200_NR_CNPJ
			--AND BN201_NR_REME		= BN200.BN200_NR_REME
			AND	BN201_ST_CONTRATO	= 'A' -- APROVADO
		),0			
	)AS BN200_TT_CONTRA_APROVADO
	*/

	/*
	-- TOTAL DE CONTRATOS QUE EST�O COMO STATUS DE DEVOLU��O COMO PENDENTE
	,ISNULL(
		(
			SELECT	COUNT(1) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO		= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST		= BN200.BN200_NR_INST
			--AND BN201_NR_CNPJ		= BN200.BN200_NR_CNPJ
			--AND BN201_NR_REME		= BN200.BN200_NR_REME
			AND BN201_ST_DEVSOL = 'P'
		),0
	)	AS BN200_QT_DEV_PENDENTE
	*/

	/*
	-- TOTAL DE CONTRATOS QUE EST�O COMO STATUS DE DEVOLU��O COMO ACEITO
	,ISNULL(
		(
			SELECT	COUNT(1) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO		= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST		= BN200.BN200_NR_INST
			--AND BN201_NR_CNPJ		= BN200.BN200_NR_CNPJ
			--AND BN201_NR_REME		= BN200.BN200_NR_REME
			AND BN201_ST_DEVSOL = 'A'
		),0
	)	AS BN200_QT_DEV_ACEITO
	*/

	/*
	-- TOTAL DE CONTRATOS QUE EST�O COMO STATUS DE DEVOLU��O COMO RECUSADO
	,ISNULL(
		(
			SELECT	COUNT(1) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO		= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST		= BN200.BN200_NR_INST
			--AND BN201_NR_CNPJ		= BN200.BN200_NR_CNPJ
			--AND BN201_NR_REME		= BN200.BN200_NR_REME
			AND BN201_ST_DEVSOL = 'R'
		),0
	)	AS BN200_QT_DEV_RECUSADO
	*/

	-- TOTAL DE CONTRATOS QUE EST�O COMO STATUS DE DEVOLU��O COMO FINALIZADA
	/*
	,ISNULL(
		(
			SELECT	COUNT(1) 
			FROM	BN201
			WHERE
				BN201_NR_GRUPO		= BN200.BN200_NR_GRUPO
			AND BN201_NR_INST		= BN200.BN200_NR_INST
			--AND BN201_NR_CNPJ		= BN200.BN200_NR_CNPJ
			--AND BN201_NR_REME		= BN200.BN200_NR_REME
			AND BN201_ST_DEVSOL = 'F'
		),0
	)	AS BN200_QT_DEV_FINALIZADA
	*/
	
	--,BN205.BN205_NR_GRUPO
	--,BN205.BN205_NR_INST
	--,BN205.BN205_NR_CNPJ
	--,BN205.BN205_TT_APFGCEM
	--,BN205.BN205_TT_APFGCIF
	--,BN205.BN205_TX_CART
	--,BN205.BN205_NM_RATEM
	--,BN205.BN205_QT_IFEM
	--,BN205.BN205_TP_APROV
	--,BN205.BN205_VL_APFGC

	/*
	,BN205.BN205_TT_COINST -- Este campo est� 'recebendo' o select abaixo:
	*/

	/*
	-- SOMA VC CONTRATOS ALIENADOS
	,ISNULL(
		(
			SELECT
				SUM(BN201_VL_CONTRATU)
			FROM BN201
			WHERE 
				BN201_NR_GRUPO     = BN200.BN200_NR_GRUPO    
			AND BN201_NR_INST      = BN200.BN200_NR_INST    
			AND BN201_NR_CNPJ      = BN200.BN200_NR_CNPJ    
			AND BN201_ST_CONTRATO  IN ('I','C','L','P','S')
		),0
	)	AS BN205_TT_COINST
	*/

	--,BN205.BN205_NR_OPESIS
	--,BN205.BN205_DT_INCSIS
	--,BN205.BN205_DT_ATUSIS
	

	--,VW_BN022.BN022_VL_COMUM AS BN200_RAZAO_GARANTIA
	/*
	,ISNULL(
		(
			SELECT 
				SUM(BN205_TT_APFGCEM) AS BN205_TT_APFGCEM			
			FROM BN205
			WHERE 1=1
			AND BN205_NR_GRUPO	= BN200.BN200_NR_GRUPO
			AND BN205_NR_INST	= BN200.BN200_NR_INST
			AND BN205_NM_RATEM	= BN200.BN200_LT_RATCALCBC			
		),0
	)	AS BN205_TT_APFGCEM_RATING
	*/
	          
  FROM BN200 AS BN200
  
  /*    
  INNER JOIN VW_BN019_ST_ATUAL AS VW_BN019_ST_ATUAL -- NECESS�RIO JOIN COM VIEW PARA MANTER C�DIGO LIMPO
  ON BN200.BN200_NR_GRUPO = VW_BN019_ST_ATUAL.BN019_NR_GRUPO
  AND BN200.BN200_NR_INST = VW_BN019_ST_ATUAL.BN019_NR_INST  
  AND BN200.BN200_NR_REME = VW_BN019_ST_ATUAL.BN019_NR_REME  
  AND BN200.BN200_NR_CNPJ = VW_BN019_ST_ATUAL.BN200_NR_CNPJ
  */

  INNER JOIN BN001 AS BN001
  --ON BN002.BN002_NR_CNPJ = BN200.BN200_NR_CNPJ
  ON BN001.BN001_NR_GRUPO = BN200.BN200_NR_GRUPO  

  INNER JOIN BN002 AS BN002
  --ON BN002.BN002_NR_CNPJ = BN200.BN200_NR_CNPJ
  ON BN002.BN002_NR_GRUPO = BN200.BN200_NR_GRUPO
  AND BN002.BN002_NR_INST = BN200.BN200_NR_INST
  
  /*
  LEFT OUTER JOIN BN205 AS BN205 -- NECESS�RIO LEFT OUTER JOIN PARA QUE SEJA POSS�VEL RECUPERA INFORMA��ES DE REMESSAS RECUSADAS (Que n�o gera registro na BN205)
  ON BN200.BN200_NR_GRUPO = BN205.BN205_NR_GRUPO
  AND BN200.BN200_NR_INST = BN205.BN205_NR_INST    
  --AND BN200.BN200_NR_CNPJ = BN205.BN205_NR_CNPJ 
  AND BN200.BN200_LT_RATCALCBC = BN205.BN205_NM_RATEM

  /*
  AND  
  (
		(BN205.BN205_TP_CLIENTE		= 'E' AND BN200.BN200_QT_QTDEIF = 1)
	OR   BN205.BN205_TP_CLIENTE	= 'C' AND BN200.BN200_QT_QTDEIF > 1
  )
  */
  AND  BN205.BN205_TP_CLIENTE = (CASE
    								WHEN BN200.BN200_QT_QTDEIF = 1 THEN 'E'
									ELSE 'C'
								 END)
  
  */

  /*
  LEFT OUTER JOIN VW_BN022 AS VW_BN022
  ON VW_BN022.BN022_NR_PROD		= BN200.BN200_NR_PROD
  AND VW_BN022.BN015_NM_MENSAG	= BN200.BN200_LT_RATCALCBC
  AND VW_BN022.BN015_TP_MENSAG	= 9 -- RAZ�O DE GARANTIA
  */


GROUP BY

	BN200.BN200_NR_GRUPO
	,BN200.BN200_NR_INST
	,BN200.BN200_NR_CNPJ
	--,BN200.BN200_NR_REME	
	--,BN200.BN200_NR_PROD
	--,BN200.BN200_NR_BANCETIP
	,BN200.BN200_NM_EEMCCB
	--,BN200.BN200_NR_CNAESUBC
	--,BN200.BN200_LT_ENDEEMP
	--,BN200.BN200_LT_BAIRROEMP
	--,BN200.BN200_LT_CIDADEEMP
	--,BN200.BN200_LT_UFEMP
	--,BN200.BN200_NR_CEPEMP
	--,BN200.BN200_QT_QTDEIF  
	--,BN200.BN200_QT_TTCONTRA
	--,BN200.BN200_LT_RATEMP
	--,BN200.BN200_LT_RATCALCFGC
	--,BN200.BN200_LT_RATCALCBC
	--,BN200.BN200_LT_RISKSCOR
	--,BN200.BN200_VL_TTREME 
	--,BN200.BN200_VL_TTCONTRA
	--,BN200.BN200_VL_CNPJXREME
	--,BN200.BN200_VL_CNPJXPR1 
	--,BN200.BN200_DT_GRAVREME 
	--,BN200.BN200_ST_EMPRESA
	--,BN200.BN200_ST_CONCREME
	--,BN200.BN200_ST_CONCNPJ
	--,BN200.BN200_NR_OPESIS
	--,BN200.BN200_DT_INCSIS
	--,BN200.BN200_DT_ATUSIS

	--,BN200_TP_CLIENTE
			
	--,VW_BN019_ST_ATUAL.BN019_NR_STATUS_MAX
	--,VW_BN019_ST_ATUAL.BN019_NR_STATUSP
	
	--,VW_BN019_ST_ATUAL.BN201_NR_PROD
	
	--,VW_BN019_ST_ATUAL.BN004_VL_RISKCOR

	,BN001.BN001_NR_GRUPO
	,BN001.BN001_NM_GRUPO
	
	,BN002.BN002_NR_INST
	,BN002.BN002_NM_INST
				
	--,BN205.BN205_NR_GRUPO
	--,BN205.BN205_NR_INST
	--,BN205.BN205_NR_CNPJ
	--,BN205.BN205_TT_APFGCEM
	--,BN205.BN205_TT_APFGCIF
	--,BN205.BN205_TX_CART
	--,BN205.BN205_NM_RATEM
	--,BN205.BN205_QT_IFEM
	--,BN205.BN205_TP_APROV
	--,BN205.BN205_VL_APFGC
	
	--,BN205.BN205_NR_OPESIS
	--,BN205.BN205_DT_INCSIS
	--,BN205.BN205_DT_ATUSIS
	

	--,VW_BN022.BN022_VL_COMUM AS BN200_RAZAO_GARANTIA	
GO



