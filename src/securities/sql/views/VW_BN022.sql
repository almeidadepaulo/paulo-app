-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN022]'))
DROP VIEW [dbo].[VW_BN022]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN022]
WITH ENCRYPTION
AS
  SELECT 
	BN022.BN022_NR_PROD
	,BN022.BN022_TP_MENSAG
	,BN022.BN022_NR_MENSAG
	,BN022.BN022_NR_ORDEM
	,BN022.BN022_VL_COMUM
	,BN022.BN022_VL_EXCLUS
	
	,BN015.BN015_TP_MENSAG
	,BN015.BN015_NR_MENSAG
	,BN015.BN015_NM_MENSAG
	,BN015.BN015_NR_OPESIS
	,BN015.BN015_DT_INCSIS
	,BN015.BN015_DT_ATUSIS
	


  FROM BN022 AS BN022
  
  INNER JOIN BN015 AS BN015
  ON	BN022.BN022_NR_MENSAG = BN015.BN015_NR_MENSAG
  AND	BN022.BN022_TP_MENSAG = BN015.BN015_TP_MENSAG
  
GO
