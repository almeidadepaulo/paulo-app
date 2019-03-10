-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG056]'))
DROP VIEW [dbo].[VW_MG056]
GO

-- Criar View da tela - SMS - Configurações -  Prioridade
CREATE VIEW [dbo].[VW_MG056]
WITH ENCRYPTION
AS

SELECT
  MG056_NR_SEQ   ,
  MG056_CD_CODSMS,  
  MG056_CD_OPESIS,
  MG056_DT_INCSIS,
  MG056_DT_ATUSIS,

  MG055_DS_CODSMS,
  MG055_NR_INST,
  MG055_CD_EMIEMP
FROM
  MG056
INNER JOIN VW_MG055
ON  MG056_CD_CODSMS = MG055_CD_CODSMS

GO
