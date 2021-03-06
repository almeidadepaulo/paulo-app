 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apagar view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_EM052]'))
DROP VIEW [dbo].[VW_EM052]
GO

CREATE VIEW [dbo].[VW_EM052]
WITH ENCRYPTION
AS

SELECT
  EM052_NR_INST  ,
  CB050_NM_INST  ,
  EM052_CD_EMIEMP,
  CB053_DS_EMIEMP,
  EM052_NR_BROKER,
  EM050_NM_BROKER
  EM052_NM_USER  ,
  EM052_NM_SENHA ,
  EM052_CD_OPESIS,
  EM052_DT_INCSIS,
  EM052_DT_ATUSIS
FROM
  EM052,
  EM050,
  CB050,
  CB053
WHERE
/* INSTITUIÇÃO */
    EM052_NR_INST   = CB050_NR_INST
/* EMISSOR/EMPRESA */
AND EM052_NR_INST   = CB053_NR_INST   
AND EM052_CD_EMIEMP = CB053_CD_EMIEMP
/* BROKER */
AND EM052_NR_INST   = EM050_NR_INST
AND EM052_NR_BROKER = EM050_NR_BROKER

GO