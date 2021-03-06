-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN200_STATUS]'))
DROP VIEW [dbo].[VW_BN200_STATUS]
GO

-- Cria View
/*
Recupera dados para ser usado no consumdo do Web Service do Bacen
*/
CREATE VIEW [dbo].[VW_BN200_STATUS]
WITH ENCRYPTION
AS
  SELECT 
      	
	BN200.BN200_NR_INST
	,BN200.BN200_NR_GRUPO
	,BN200.BN200_NR_REME
	,BN200.BN200_NR_CNPJ
	,BN200.BN200_QT_QTDEIF   


	,BN200.BN200_LT_RATCALCBC
	,BN200.BN200_LT_RISKSCOR
	,BN200.BN200_DT_ATUSIS
	
	,BN200.BN200_ST_EMPRESA   
	,BN200.BN200_NR_PROD

	--,VW_BN019_ST_ATUAL.BN200_ST_EMPRESA
	,VW_BN019_ST_ATUAL.BN019_NR_STATUS_MAX
	,VW_BN019_ST_ATUAL.BN019_NR_STATUSP

	--,VW_BN019_ST_ATUAL.BN201_NR_PROD

	,VW_BN019_ST_ATUAL.BN004_VL_RISKCOR
	
	/*
	,BN002.BN002_NR_GRUPO
	,BN002.BN002_NR_INST
	*/
	/**/   
  FROM BN200 AS BN200
      
  INNER JOIN VW_BN019_ST_ATUAL AS VW_BN019_ST_ATUAL -- NECESS�RIO JOIN COM VIEW PARA MANTER C�DIGO LIMPO
  ON BN200.BN200_NR_GRUPO = VW_BN019_ST_ATUAL.BN019_NR_GRUPO
  AND BN200.BN200_NR_INST = VW_BN019_ST_ATUAL.BN019_NR_INST  
  AND BN200.BN200_NR_REME = VW_BN019_ST_ATUAL.BN019_NR_REME  
  --AND BN200.BN200_NR_CNPJ = VW_BN019_ST_ATUAL.BN200_NR_CNPJ
  
  /*
  INNER JOIN BN002 AS BN002
  --ON BN200.BN200_NR_GRUPO = BN002.BN002_NR_GRUPO
  --AND BN200.BN200_NR_INST = BN002.BN002_NR_INST   
  ON BN200.BN200_NR_CNPJ = BN002.BN002_NR_CNPJ
  */
  
  GROUP BY
  
	BN200.BN200_NR_INST
	,BN200.BN200_NR_GRUPO
	,BN200.BN200_NR_REME
	,BN200.BN200_NR_CNPJ
	,BN200_QT_QTDEIF  


	,BN200.BN200_LT_RATCALCBC
	,BN200.BN200_LT_RISKSCOR
	,BN200.BN200_DT_ATUSIS
	
	,BN200.BN200_ST_EMPRESA 
	,BN200.BN200_NR_PROD
	

	--,VW_BN019_ST_ATUAL.BN200_ST_EMPRESA
	,VW_BN019_ST_ATUAL.BN019_NR_STATUS_MAX
	,VW_BN019_ST_ATUAL.BN019_NR_STATUSP

	--,VW_BN019_ST_ATUAL.BN201_NR_PROD

	,VW_BN019_ST_ATUAL.BN004_VL_RISKCOR
	/*
	,BN002.BN002_NR_GRUPO
	,BN002.BN002_NR_INST
	*/
 
GO

/*Exemplo*/
SELECT	
	BN200_NR_INST
	,BN200_NR_GRUPO
	,BN200_NR_REME
	
	,BN200_NR_CNPJ
	,BN200_LT_RATCALCBC
	,BN200_NR_PROD
	
	,BN004_VL_RISKCOR
	
	,BN200_ST_EMPRESA

FROM	VW_BN200_STATUS
WHERE	1=1
	AND		BN019_NR_STATUS_MAX 	= 1 	
	AND		BN019_NR_STATUSP 		IN(2,3)	
	AND 	BN200_ST_EMPRESA		= 'A'	

	AND RTRIM(BN200_LT_RATCALCBC)	= ''	

GROUP BY 
	BN200_NR_INST
	,BN200_NR_GRUPO
	,BN200_NR_REME

	,BN200_NR_CNPJ
	,BN200_LT_RATCALCBC
	,BN200_NR_PROD

	,BN004_VL_RISKCOR

	,BN200_ST_EMPRESA



