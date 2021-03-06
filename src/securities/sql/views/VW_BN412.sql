-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN412]'))
DROP VIEW [dbo].[VW_BN412]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN412]
WITH ENCRYPTION
AS
  SELECT 
  BN412.BN412_NR_SEQARQ,
  BN412.BN412_NR_GRUPO,
  BN412.BN412_NR_INST,
  BN412.BN412_VL_LIMCON,
  BN412.BN412_DT_VCLIM,
  BN412.BN412_ST_LIM,
  BN412.BN412_NR_OPESIS,
  BN412.BN412_DT_INCSIS,
  BN412.BN412_DT_ATUSIS,
  
  BN002.BN002_NR_INST,
  BN002.BN002_NM_INST,
  
  US.usu_nome
  
  FROM BN412 AS BN412
  
  INNER JOIN BN002 AS BN002
  ON 	BN002.BN002_NR_GRUPO 	= BN412.BN412_NR_GRUPO
  AND 	BN002.BN002_NR_INST 	= BN412.BN412_NR_INST
  
  left JOIN ims.PERFIL_USUARIO AS US
  ON US.usu_id = BN412.BN412_NR_OPESIS

GO


