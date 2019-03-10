-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB071]'))
DROP VIEW [dbo].[VW_CB071]
GO

-- Cria View
CREATE VIEW [dbo].[VW_CB071]
WITH ENCRYPTION
AS
  SELECT
    CB071.CB071_NR_INST,
 	CB071.CB071_CD_REGIAO,
  	CB071.CB071_CD_FORNEC,
  	CB071.CB071_CD_SITE,
  	CB071.CB071_CD_OPESIS,
  	CB071.CB071_DT_INCSIS,
  	CB071.CB071_DT_ATUSIS,
  
    CB050.CB050_NR_INST,
  	CB050.CB050_NM_INST,
  	CB050.CB050_NM_INSTR,
  	CB050.CB050_CD_OPESIS,
  	CB050.CB050_DT_INCSIS,
  	CB050.CB050_DT_ATUSIS,
    Cast(CB050.CB050_NR_INST as varchar) +' - '+ CB050.CB050_NM_INST AS CB050_NR_NM_INST,
    
    CB055.CB055_NM_FORNEC,
    
    CB056.CB056_DS_SITE,
    
    CB070.CB070_DS_REGIAO
    
  FROM CB071 AS CB071
  
  LEFT OUTER JOIN CB055 AS CB055
  ON CB071.CB071_CD_FORNEC = CB055.CB055_CD_FORNEC
  AND CB071.CB071_NR_INST = CB055.CB055_NR_INST
  
  LEFT OUTER JOIN CB070 AS CB070
  ON CB071.CB071_CD_REGIAO = CB070.CB070_CD_REGIAO
  AND CB071.CB071_NR_INST = CB070.CB070_NR_INST
  
  LEFT OUTER JOIN CB056 AS CB056
  ON CB071.CB071_CD_SITE = CB056.CB056_CD_SITE
  AND CB071.CB071_NR_INST = CB056.CB056_NR_INST
  
  LEFT OUTER JOIN CB050 AS CB050
  ON CB071.CB071_NR_INST = CB050.CB050_NR_INST -- Teste
  
GO