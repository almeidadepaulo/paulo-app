-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN019_ST_ATUAL]'))
DROP VIEW [dbo].[VW_BN019_ST_ATUAL]
GO

-- Cria View
/*
	Usado para C�lculo de Rating.
	� necess�rio consultar por empresa (BN200.BN200_NR_CNPJ)
*/
CREATE VIEW [dbo].[VW_BN019_ST_ATUAL]
WITH ENCRYPTION
AS
  SELECT 
	BN019.BN019_NR_GRUPO
	,BN019.BN019_NR_INST
	,BN019.BN019_NR_REME	
	,MAX(BN019.BN019_NR_STATUS) AS BN019_NR_STATUS_MAX
	,BN019.BN019_NR_STATUSP
	,BN019.BN019_DT_INICIO
	,BN019.BN019_HR_INICIO
	,BN019.BN019_DT_FIM
	,BN019.BN019_HR_FIM
	,BN019.BN019_NR_OPESIS
	,BN019.BN019_DT_INCSIS
	,BN019.BN019_DT_ATUSIS
	
	/*
	,BN002.BN002_NR_INST
	,BN002.BN002_NM_INST
	*/
	
	,BN200.BN200_ST_EMPRESA
	,BN200_QT_TTCONTRA
	
	,BN200.BN200_NR_PROD
	--,SUM(BN200.BN200_QT_TTCONTRA) AS BN200_QT_TTCONTRA
	
	,BN200.BN200_NR_CNPJ
	/*	
	,BN200.BN200_LT_RATCALCBC
	,BN200.BN200_DT_ATUSIS
	/**/
	--,BN201.BN201_NR_CONTRAOR
	*/
	--,BN201.BN201_NR_PROD
		
	,BN004.BN004_VL_RISKCOR

  FROM BN019 AS BN019
  

  --INNER JOIN BN002 AS BN002
  --ON BN019_NR_INST = BN002.BN002_NR_INST

   
  LEFT OUTER JOIN BN200 AS BN200
  ON	BN019.BN019_NR_GRUPO	=	BN200.BN200_NR_GRUPO
  AND	BN019.BN019_NR_INST		=	BN200.BN200_NR_INST
  --AND	BN002.BN002_NR_CNPJ		=	BN200.BN200_NR_CNPJ
  AND	BN019.BN019_NR_REME		=	BN200.BN200_NR_REME 
  /**/
  /*
  LEFT OUTER JOIN BN002 AS BN002
  ON BN002.BN002_NR_CNPJ		=	BN200.BN200_NR_CNPJ
  */
  
  LEFT OUTER JOIN BN201 AS BN201
  ON	BN019.BN019_NR_GRUPO	=	BN201.BN201_NR_GRUPO
  AND	BN019.BN019_NR_INST		=	BN201.BN201_NR_INST
  --AND	BN002.BN002_NR_CNPJ		=	BN201.BN201_NR_CNPJ
  AND	BN019.BN019_NR_REME		=	BN201.BN201_NR_REME 
 
  /**/
  
  LEFT OUTER JOIN BN004 AS BN004
  ON	BN200.BN200_NR_PROD		=	BN004.BN004_NR_PROD  
 
  WHERE
		BN019_NR_STATUS = (
		SELECT 
			MAX(BN019_NR_STATUS) 
		FROM BN019 AS B 
		WHERE B.BN019_NR_GRUPO = BN019.BN019_NR_GRUPO
		AND	  B.BN019_NR_INST  = BN019.BN019_NR_INST
		AND   B.BN019_NR_REME  = BN019.BN019_NR_REME
		AND	  B.BN019_NR_STATUSP <> 1 -- Diferente de "Em processamento"
		)
  
  GROUP BY 
		BN019.BN019_NR_GRUPO
		,BN019.BN019_NR_INST
		,BN019.BN019_NR_REME	
		,BN019.BN019_NR_STATUSP
		,BN019.BN019_DT_INICIO
		,BN019.BN019_HR_INICIO
		,BN019.BN019_DT_FIM
		,BN019.BN019_HR_FIM
		,BN019.BN019_NR_OPESIS
		,BN019.BN019_DT_INCSIS
		,BN019.BN019_DT_ATUSIS		
		/*
		,BN002.BN002_NR_INST
		,BN002.BN002_NM_INST
		*/
		
		,BN200.BN200_ST_EMPRESA
		,BN200_QT_TTCONTRA
		,BN200.BN200_NR_PROD
		
		,BN200.BN200_NR_CNPJ
		/*	
		,BN200.BN200_LT_RATCALCBC
		,BN200.BN200_DT_ATUSIS
		*/
		--,BN201.BN201_NR_CONTRAOR
		--,BN201.BN201_NR_PROD
		
		,BN004_VL_RISKCOR
		
GO
