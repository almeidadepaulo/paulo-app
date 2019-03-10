-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN415]'))
DROP VIEW [dbo].[VW_BN415]
GO

-- Tela Relatórios
-- Cria View
CREATE VIEW [dbo].[VW_BN415]
WITH ENCRYPTION
AS
SELECT 
  BN002.BN002_NR_GRUPO,
  BN002.BN002_NR_INST,
  BN002.BN002_NM_INST,

  BN415.BN415_NR_GRUPO,
  BN415.BN415_NR_INST,
  BN415.BN415_TP_RELAT,
  BN415.BN415_DT_RELAT,
  BN415.BN415_HR_RELAT,
  BN415.BN415_IM_PDF,
  BN415.BN415_NR_OPESIS,
  BN415.BN415_DT_INCSIS,
  BN415.BN415_DT_ATUSIS
FROM 
  BN415 AS BN415  

  LEFT JOIN BN002 AS BN002
  ON 	BN002.BN002_NR_GRUPO	= BN415.BN415_NR_GRUPO
  AND	BN002.BN002_NR_INST		= BN415.BN415_NR_INST

GO


