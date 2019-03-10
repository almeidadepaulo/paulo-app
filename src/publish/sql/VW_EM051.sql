 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apagar view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_EM051]'))
DROP VIEW [dbo].[VW_EM051]
GO

CREATE VIEW [dbo].[VW_EM051]
WITH ENCRYPTION
AS

SELECT
  EM051_NR_INST  ,
  CB050_NM_INST  ,
  EM051_NR_BROKER,
  EM050_NM_BROKER,
  EM051_CD_TARIFA,
  EM051_DT_VALID ,
  EM051_DT_ENCERR,
  EM051_QT_INI   ,
  EM051_QT_FIM   ,
  EM051_VL_CUSTO ,
  EM051_ID_ATIVO ,  
  EM051_ID_ATIVO_label = CASE EM051_ID_ATIVO
    WHEN 1 THEN 'Ativa'      
    ELSE 'Inativa'
  END,
  EM051_CD_OPESIS,
  EM051_DT_INCSIS,
  EM051_DT_ATUSIS
FROM
  EM051,
  EM050,
  CB050
WHERE
/* INSTITUI��O */
  EM051_NR_INST = CB050_NR_INST
/* BROKER */
AND EM051_NR_INST   = EM050_NR_INST
AND EM051_NR_BROKER = EM050_NR_BROKER

GO