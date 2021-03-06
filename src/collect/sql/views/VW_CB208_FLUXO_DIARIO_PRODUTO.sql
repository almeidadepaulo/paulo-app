-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB208_FLUXO_DIARIO_PRODUTO]'))
DROP VIEW [dbo].[VW_CB208_FLUXO_DIARIO_PRODUTO]
GO

-- Tela Carteira - Fluxo diario por Produto
-- Cria View
CREATE VIEW [dbo].[VW_CB208_FLUXO_DIARIO_PRODUTO]
WITH ENCRYPTION
AS
 SELECT 
	CB208_NR_OPERADOR,
	CB208_NR_CEDENTE,
	CB208_NR_PRODUT,
	CB208_DT_MOVTO ,
	SUM(CB208_VL_TOTDIA) CB208_VL_TOTDIA,
	SUM(CB208_VL_CATPRO) CB208_VL_CATPRO,
	SUM(CB208_VL_CATCED) CB208_VL_CATCED,
	SUM(CB208_QT_TOTAL) CB208_QT_TOTAL,

	-- BANCO	
	CB250_NM_BANCO,

	-- CARTEIRA	
	CB256_DS_CART,
	
	-- PRODUTO
	CB255_DS_PROD

 FROM CB208 AS CB208

LEFT OUTER JOIN CB250 AS CB250  -- BANCO
ON     CB250_NR_OPERADOR = CB208_NR_OPERADOR
   AND CB250_NR_CEDENTE  = CB208_NR_CEDENTE
   AND CB250_CD_COMPSC	 = CB208_CD_COMPSC 
  

 LEFT JOIN CB256 AS CB256  -- CARTEIRA
 ON     CB256_NR_OPERADOR = CB208_NR_OPERADOR
    AND CB256_NR_CEDENTE  = CB208_NR_CEDENTE
    AND CB256_CD_CART     = CB208_CD_CART 

 LEFT JOIN CB255 AS CB255  -- PRODUTO
 ON     CB255_NR_OPERADOR = CB208_NR_OPERADOR
    AND CB255_NR_CEDENTE  = CB208_NR_CEDENTE
    AND CB255_CD_PROD     = CB208_NR_PRODUT 

 GROUP BY 
	CB208_NR_OPERADOR,
	CB208_NR_CEDENTE,
	CB250_NM_BANCO,
	CB256_DS_CART,
	CB208_NR_PRODUT,
	CB255_DS_PROD,
	CB208_DT_MOVTO
	
GO

