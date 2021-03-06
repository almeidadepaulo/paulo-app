-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB053]'))
DROP VIEW [dbo].[VW_CB053]
GO

-- Cria View
CREATE VIEW [dbo].[VW_CB053]
WITH ENCRYPTION
AS
  SELECT
    CB053.CB053_NR_INST,
  	CB053.CB053_CD_EMIEMP,
  	CB053.CB053_DS_EMIEMP,
	--'Instituição - '+Cast(CB053_CD_EMIEMP as varchar) AS CB053_DS_EMIEMP,
  	CB053.CB053_NR_CPFCNPJ,
  	CB053.CB053_DS_EMIEMR,
  	CB053.CB053_DS_NMARQ,
	CB053_NM_END,
	CB053.CB053_NR_END,
	CB053.CB053_NM_COMPL,
	CB053.CB053_NM_BAIRRO,
	CB053.CB053_NM_CIDADE,
	CB053.CB053_NM_ESTADO,
	CB053.CB053_NR_CEP,
	CB053.CB053_NR_DDD,
	CB053.CB053_NR_TEL,
  	CB053.CB053_CD_OPESIS,
  	CB053.CB053_DT_INCSIS,
  	CB053.CB053_DT_ATUSIS,
  
    CB050.CB050_NR_INST,
  	CB050.CB050_NM_INST,
  	CB050.CB050_NM_INSTR,
  	CB050.CB050_CD_OPESIS,
  	CB050.CB050_DT_INCSIS,
  	CB050.CB050_DT_ATUSIS,
    Cast(CB050.CB050_NR_INST as varchar) +' - '+ CB050.CB050_NM_INST AS CB050_NR_NM_INST,

	CB053.CB053_CD_EMIEMP AS ins_id
    
  FROM CB053 AS CB053
  LEFT OUTER JOIN CB050 AS CB050
  ON CB053.CB053_NR_INST = CB050.CB050_NR_INST -- Teste

GO