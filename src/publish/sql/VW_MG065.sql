 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG065]'))
DROP VIEW [dbo].VW_MG065
GO

-- Criar View da tela - SMS - Configura��es -�Blacklist
CREATE VIEW [dbo].VW_MG065
WITH ENCRYPTION
AS

SELECT
  MG065_NR_INST   ,
  CB050_NM_INST   ,
  MG065_NR_DDD    ,
  MG065_NR_CEL    ,
  Cast(MG065_NR_DDD AS VARCHAR) + Cast(MG065_NR_CEL AS VARCHAR) AS MG065_NR_DDD_CEL,  
  MG065_NR_CPFCNPJ,
  MG065_ID_MOTIVO ,
  MG065_CD_OPESIS ,
  MG065_DT_INCSIS ,
  MG065_DT_ATUSIS
FROM
  MG065,
  CB050
WHERE
  MG065_NR_INST = CB050_NR_INST

GO