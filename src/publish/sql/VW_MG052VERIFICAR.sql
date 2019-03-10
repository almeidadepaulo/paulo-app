 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apagar view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG052]'))
DROP VIEW [dbo].[VW_MG052]
GO

CREATE VIEW [dbo].[VW_MG052]
WITH ENCRYPTION
AS

SELECT
  MG052_NR_INST  ,
  CB050_NM_INST  ,
  MG052_CD_EMIEMP,
  CB053_DS_EMIEMP,
  MG052_NR_BROKER,
  MG050_NM_BROKER
  MG052_NM_USER  ,
  MG052_NM_SENHA ,
  MG052_CD_OPESIS,
  MG052_DT_INCSIS,
  MG052_DT_ATUSIS
FROM
  MG052,
  MG050,
  CB050,
  CB053
WHERE
/* INSTITUI��O */
    MG052_NR_INST   = CB050_NR_INST
/* EMISSOR/EMPRESA */
AND MG052_NR_INST   = CB053_NR_INST   
AND MG052_CD_EMIEMP = CB053_CD_EMIEMP
/* BROKER */
AND MG052_NR_INST   = MG050_NR_INST
AND MG052_NR_BROKER = MG050_NR_BROKER

GO