USE BANKNET
GO

-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB209_PAGAMENTO_CARTEIRA]'))
DROP VIEW [dbo].VW_CB209_PAGAMENTO_CARTEIRA
GO

-- Tela Carteira - Entrada por Banco
-- Cria View
CREATE VIEW [dbo].VW_CB209_PAGAMENTO_CARTEIRA
WITH ENCRYPTION
AS
 SELECT 
	CB209_NR_OPERADOR,
	CB209_NR_CEDENTE,
	CB209_DT_MOVTO ,
	SUM(CB209_VL_VALOR)		CB209_VL_VALOR ,
	SUM(CB209_QT_TOTAL)		CB209_QT_TOTAL,
	SUM(CB209_VL_ACRE)		CB209_VL_ACRE,
	(SUM(CB209_VL_DESC) + SUM(CB209_VL_ABATI)) CB209_VL_DESC,
	(SUM(CB209_VL_VALOR) + SUM(CB209_VL_ACRE) - (SUM(CB209_VL_DESC) + SUM(CB209_VL_ABATI))) CB209_VL_TOTAL,
	CB209_CD_COMPSC,
	CB209_ID_TIPOAC,

	-- CARTEIRA
	CB256_CD_CART,
	CB256_DS_CART,
	-- BANCO
	CB250_CD_COMPSC,
	CB250_NM_BANCO

 FROM CB209 AS CB209

LEFT OUTER JOIN CB250 AS CB250  -- BANCO
ON     CB250_NR_OPERADOR = CB209_NR_OPERADOR
   AND CB250_NR_CEDENTE  = CB209_NR_CEDENTE
   AND CB250_CD_COMPSC	 = CB209_CD_COMPSC

  LEFT OUTER JOIN CB256 AS CB256  -- CARTEIRA
ON     CB256_NR_OPERADOR = CB209_NR_OPERADOR
   AND CB256_NR_CEDENTE  = CB209_NR_CEDENTE
   AND CB256_CD_CART     = CB209_CD_CART
 
 GROUP BY 
  CB209_DT_MOVTO,
  CB209_NR_OPERADOR,
  CB209_NR_CEDENTE,
  CB209_CD_COMPSC,
  CB209_ID_TIPOAC,
  CB256_CD_CART,
  CB256_DS_CART,
  CB250_CD_COMPSC,
  CB250_NM_BANCO 
	
GO

