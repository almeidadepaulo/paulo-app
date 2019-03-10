-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN214]'))
DROP VIEW [dbo].[VW_BN214]
GO

-- Relatório Diário de Garantias

-- Cria View
CREATE VIEW [dbo].[VW_BN214]
WITH ENCRYPTION
AS
SELECT
  
	BN214.BN214_NR_GRUPO
	,BN214.BN214_NR_INST
	,BN214.BN214_NR_PROD
	,BN214.BN214_NR_CONTRA
	,BN214.BN214_NR_LOTE
	,BN214.BN214_NR_BANCO
	,BN214.BN214_NR_AGENC
	,BN214.BN214_NR_CONTA
	,BN214.BN214_TP_CPFCNPJ
	,BN214.BN214_NR_CPFCNPJ
	,BN214.BN214_VL_PARC
	,BN214.BN214_TX_FINANC
	,BN214.BN214_QT_PAREX
	,BN214.BN214_DT_PVCTO
	,BN214.BN214_DT_UVCTO
	,BN214.BN214_TT_NOM
	,BN214.BN214_TT_PRES
	,BN214.BN214_TT_EXIG
	,BN214.BN214_NR_OPESIS
	,BN214.BN214_DT_INCSIS
	,BN214.BN214_DT_ATUSIS

	,BN009.BN009_NM_CONTA
	,BN009.BN009_NR_BANCO
	,BN009.BN009_NR_AGENC
	,BN009.BN009_NR_CONTA

	,BN004.BN004_TP_PROD

	,(SELECT TOP 1 BN200.BN200_NM_EEMCCB FROM BN200
	  WHERE 1=1
		AND BN200.BN200_NR_GRUPO	= BN214.BN214_NR_GRUPO
		AND BN200.BN200_NR_INST		= BN214.BN214_NR_INST
		AND BN200.BN200_NR_CNPJ		= BN214.BN214_NR_CPFCNPJ
	) AS BN200_NM_EEMCCB

	,VW_BN002.BN001_NM_GRUPO
	,Cast(VW_BN002.BN001_NM_GRUPO as varchar)+' - '+VW_BN002.BN001_NM_GRUPO AS BN001_NR_NM_GRUPO
	,VW_BN002.BN002_NM_INST
	,Cast(VW_BN002.BN002_NR_INST as varchar)+' - '+VW_BN002.BN002_NM_INST AS BN002_NR_NM_INST
 
FROM BN214 AS BN214

LEFT OUTER JOIN BN009 AS BN009
ON  BN009.BN009_NR_BANCO 	=  BN214.BN214_NR_BANCO
AND BN009.BN009_NR_AGENC 	=  BN214.BN214_NR_AGENC
AND BN009.BN009_NR_CONTA 	=  BN214.BN214_NR_CONTA

INNER JOIN BN004 AS BN004
ON BN004.BN004_NR_PROD = BN214.BN214_NR_PROD

/*
LEFT OUTER JOIN BN200 AS BN200
ON  BN200.BN200_NR_GRUPO	= BN214.BN214_NR_GRUPO
AND BN200.BN200_NR_INST		= BN214.BN214_NR_INST
AND BN200.BN200_NR_CNPJ		= BN214.BN214_NR_CPFCNPJ
*/


LEFT OUTER JOIN VW_BN002 AS VW_BN002
ON  VW_BN002.BN002_NR_GRUPO	= BN214.BN214_NR_GRUPO
AND VW_BN002.BN002_NR_INST	= BN214.BN214_NR_INST





GO