-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB035]'))
DROP VIEW [dbo].[VW_CB035]
GO

-- Cria View
CREATE VIEW [dbo].[VW_CB035]
WITH ENCRYPTION
AS
  SELECT
    CB035.CB035_NR_INST,
  	CB035.CB035_CD_LOC,
  	CB035.CB035_DS_LOC,
  	CB035.CB035_DS_BD,
  	CB035.CB035_DS_WBSERV,
  	CB035.CB035_CD_OPESIS,
  	CB035.CB035_DT_INCSIS,
  	CB035.CB035_DT_ATUSIS,
  
    CB050.CB050_NR_INST,
  	CB050.CB050_NM_INST,
  	CB050.CB050_NM_INSTR,
  	CB050.CB050_CD_OPESIS,
  	CB050.CB050_DT_INCSIS,
  	CB050.CB050_DT_ATUSIS,
    Cast(CB050.CB050_NR_INST as varchar) +' - '+ CB050.CB050_NM_INST AS CB050_NR_NM_INST
    
  FROM CB035 AS CB035
  LEFT OUTER JOIN CB050 AS CB050
  ON CB035.CB035_NR_INST = CB050.CB050_NR_INST -- Teste

GO