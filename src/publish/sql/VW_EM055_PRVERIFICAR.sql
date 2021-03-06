-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_EM055_PR]'))
DROP VIEW [dbo].[VW_EM055_PR]
GO

-- Cria View
CREATE VIEW [dbo].[VW_EM055_PR]
WITH ENCRYPTION
AS
  SELECT
    EM055.EM055_NR_INST,
  	EM055.EM055_CD_EMIEMP,
  	EM055.EM055_CD_CODEMAIL,
  	EM055.EM055_DS_CODEMAIL,
  	EM055.EM055_ID_ATIVO,
  	EM055.EM055_TP_CATEG,
  	EM055.EM055_CD_OPESIS,
  	EM055.EM055_DT_INCSIS,
  	EM055.EM055_DT_ATUSIS,
  
    EM056.EM056_NR_SEQ
    
  FROM EM055 AS EM055
  LEFT OUTER JOIN EM056 AS EM056
  ON EM055.EM055_CD_CODEMAIL  = EM056.EM056_CD_CODEMAIL
  AND EM055.EM055_NR_INST   = EM056.EM056_NR_INST
  AND EM055.EM055_CD_EMIEMP = EM056.EM056_CD_EMIEMP

GO