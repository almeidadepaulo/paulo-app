 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_EM070]'))
DROP VIEW [dbo].VW_EM070
GO

-- Criar View da tela - EMAIL - Configurações - Pacote
CREATE VIEW [dbo].VW_EM070
WITH ENCRYPTION
AS

SELECT
  EM070_NR_INST  ,
  CB050_NM_INST  ,
  EM070_NR_PACOTE,
  EM070_NM_PACOTE,
  EM070_CD_OPESIS,
  EM070_DT_INCSIS,
  EM070_DT_ATUSIS
FROM
  EM070,
  CB050
WHERE
  EM070_NR_INST = CB050_NR_INST

  
GO