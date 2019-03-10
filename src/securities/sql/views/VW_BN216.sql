-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN216]'))
DROP VIEW [dbo].[VW_BN216]
GO

-- Relatório Diário de Garantias

-- Cria View
CREATE VIEW [dbo].[VW_BN216]
WITH ENCRYPTION
AS
SELECT
  
	  BN216.BN216_NR_GRUPO
      ,BN216.BN216_NR_INST
      ,BN216.BN216_TP_PAPEL
      ,BN216.BN216_DT_VENCTO
      ,BN216.BN216_QT_UNIT
      ,BN216.BN216_VL_UNIT
      ,BN216.BN216_TP_STATUS
      ,BN216.BN216_NR_OPESIS
      ,BN216.BN216_DT_INCSIS
      ,BN216.BN216_DT_ATUSIS
	  ,VW_BN002.BN001_NM_GRUPO as BN216_NM_GRUPO
	  ,VW_BN002.BN002_NM_INST as BN216_NM_INST
	  ,VW_BN002.BN001_NM_GRUPO as BN001_NM_GRUPO
	  ,VW_BN002.BN002_NM_INST as BN002_NM_INST
 
FROM BN216 AS BN216

LEFT OUTER JOIN VW_BN002 AS VW_BN002
ON  VW_BN002.BN002_NR_GRUPO	= BN216.BN216_NR_GRUPO
AND VW_BN002.BN002_NR_INST	= BN216.BN216_NR_INST

GO
