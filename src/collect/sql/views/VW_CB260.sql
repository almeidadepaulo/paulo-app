-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB260]'))
DROP VIEW [dbo].[VW_CB260]
GO

-- Cria View
CREATE VIEW [dbo].[VW_CB260]
WITH ENCRYPTION
AS
 SELECT 
  CB260.CB260_NR_OPERADOR,
  CB260.CB260_NR_CEDENTE,
  CB260.CB260_CD_COMPSC,
  CB260.CB260_NR_AGENC,
  CB260.CB260_NR_CONTA,
  CB260.CB260_CD_CART,
  CB260.CB260_NR_DGCONT,

  CASE WHEN CB260_NR_DGCONT <> '' THEN
	Cast(CB260.CB260_NR_CONTA as varchar) +'-'+ Cast(CB260.CB260_NR_DGCONT as varchar)
  ELSE
	Cast(CB260_NR_CONTA as varchar)
  END CB260_NR_CONTA_DG,
  
  CB260.CB260_NR_DGAGCT,
  CB260.CB260_NM_CEDENT,
  CB260.CB260_NR_CPFCNPJ,
  CB260.CB260_TP_INSCRI,
  CB260.CB260_NM_END,
  CB260.CB260_NR_END,
  CB260.CB260_DS_COMPL,
  CB260.CB260_NM_BAIRRO,
  CB260.CB260_CD_CIDADE,
  CB260.CB260_NM_CIDADE,
  CB260.CB260_SG_ESTADO,
  CB260.CB260_CD_PAIS,
  /*CASE WHEN CB260.CB260_NR_CEP = '0' THEN '00.000-000'
  WHEN CB260.CB260_NR_CEP = '' THEN ''
	ELSE SUBSTRING(CB260.CB260_NR_CEP,1,2)+'.'+SUBSTRING(CB260.CB260_NR_CEP,3,3)+'-'+SUBSTRING(CB260.CB260_NR_CEP,7,3)
  END CB260_NR_CEP,*/
  CB260.CB260_NR_CEP,
  CB260.CB260_VL_LIQUID,
  CB260.CB260_VL_DEVOL,
  CB260.CB260_VL_ACREAT,
  CB260.CB260_VL_ENTRAD,
  CB260.CB260_ID_ENCCOB,
  CB260.CB260_ID_INDREP,
  CB260.CB260_PZ_REPUBL,
  CB260.CB260_NR_NOSNUM,
  CB260.CB260_ID_INDNSN,
  CB260.CB260_ID_INDEXC,
  CB260.CB260_ID_INTECC,
  CB260.CB260_PZ_BAIXA,
  CB260.CB260_CD_OPESIS,
  CB260.CB260_DT_INCSIS,
  CB260.CB260_DT_ATUSIS,

  -- CARTEIRA
  CB256.CB256_DS_CART,
  
  -- BANCO
  CB250.CB250_CD_COMPSC,
  CB250.CB250_NM_BANCO,
  
  -- AGENCIA
  VW_CB251.CB251_CD_COMPSC,
  VW_CB251.CB251_NR_AGENC,
  VW_CB251.CB251_NR_DGAGEN,
  VW_CB251.CB251_NM_AGENC,
  VW_CB251.CB251_NR_DG_AGENC,
  
  -- BAIRRO
  CB042.CB042_NM_BAIRR,
  
  -- CIDADE
  CB041.CB041_NM_LOCALI
  
  
  FROM CB260

	LEFT OUTER JOIN CB256 AS CB256
	ON  CB256_NR_OPERADOR = CB260_NR_OPERADOR
	AND CB256_NR_CEDENTE  = CB260_NR_CEDENTE
	AND CB256_CD_CART	 = CB260_CD_CART
  
	LEFT OUTER JOIN CB250 AS CB250  -- BANCO
	ON  CB250_NR_OPERADOR = CB260_NR_OPERADOR
	AND CB250_NR_CEDENTE  = CB260_NR_CEDENTE
	AND CB250_CD_COMPSC	 = CB260_CD_COMPSC 

	LEFT OUTER JOIN VW_CB251 AS VW_CB251  -- AGENCIA
	ON  CB251_NR_OPERADOR = CB260_NR_OPERADOR
	AND CB251_NR_CEDENTE  = CB260_NR_CEDENTE
	AND CB251_CD_COMPSC	 = CB260_CD_COMPSC 
	AND CB251_NR_AGENC	 = CB260_NR_AGENC 
  
	LEFT OUTER JOIN CB041 AS CB041  --CIDADE
	ON  CB260.CB260_CD_CIDADE = CB041.CB041_CD_LOCALI
	AND CB260.CB260_SG_ESTADO = CB041.CB041_CD_ESTBR
 
	LEFT OUTER JOIN CB042 AS CB042  --BAIRRO
	ON  CB042.CB042_CD_LOCALI = CB041.CB041_CD_LOCALI
	AND CB042.CB042_NM_BAIRR	= CB260.CB260_NM_BAIRRO
GO