-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG055_SEQ]'))
DROP VIEW [dbo].[VW_MG055_SEQ]
GO

-- Criar View da tela - SMS - Configurações -  Prioridade
CREATE VIEW [dbo].[VW_MG055_SEQ]
WITH ENCRYPTION
AS

SELECT
	MG055_NR_INST,
	MG055_CD_EMIEMP,
	MG055_CD_CODSMS,
	MG055_DS_CODSMS,
	MG055_ID_ATIVO,
	MG055_TP_CATEG,
	MG055_CD_OPESIS,
	MG055_DT_INCSIS,
	MG055_DT_ATUSIS,

	MG057_NR_INST,
	MG057_CD_EMIEMP,
	MG057_CD_CODSMS,
	-- ROW_NUMBER() OVER (Order by MG057_NR_SEQ) AS ROW_NUMBER
	MG057_NR_SEQ,
	ISNULL(MG057_NR_SEQ, ROW_NUMBER() OVER (ORDER BY MG057_NR_SEQ)) AS NR_SEQ,
	MG057_CD_OPESIS,
	MG057_DT_INCSIS,
	MG057_DT_ATUSIS
FROM
  MG055

LEFT OUTER JOIN MG057
ON  MG057_NR_INST = MG057_NR_INST
AND MG055_CD_EMIEMP = MG057_CD_EMIEMP
AND MG055_CD_CODSMS = MG057_CD_CODSMS

GO