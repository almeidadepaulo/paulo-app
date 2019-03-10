USE BANKNET
GO

-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN402_CARTEIRA_CARTEIRA]'))
DROP VIEW [dbo].[VW_BN402_CARTEIRA_CARTEIRA]
GO

-- Entrada por Carteira
-- Cria View
CREATE VIEW [dbo].[VW_BN402_CARTEIRA_CARTEIRA]
WITH ENCRYPTION
AS
 SELECT 
	BN402_NR_GRUPO,
	BN402_NR_INST,
	BN402_DT_MOVTO ,
	SUM(BN402_VL_VALOR)		BN402_VL_VALOR ,
	--SUM(CB209_QT_CONTRA)	CB209_QT_CONTRA,
	SUM(BN402_QT_TOTAL)		BN402_QT_TOTAL,
	BN402_NR_BANCO,
	BN402_TP_ACUM,

	-- BANCO
	BN007_NR_BANCO,
	BN007_NM_BANCO

	-- CARTEIRA
	--?CB256_CD_CART,
	--?CB256_DS_CART


 FROM BN402 AS BN402

 LEFT OUTER JOIN BN007 AS BN007  -- BANCO
 ON  BN007_NR_BANCO	=	BN402_NR_BANCO 

 --?LEFT OUTER JOIN CB256 AS CB256  -- CARTEIRA
 --?ON  CB256_CD_CART	=	CB209_CD_CART

 WHERE  BN402_TP_ACUM = 10 /* SALDO ATUAL */

 GROUP BY 
  BN402_DT_MOVTO,
  BN402_NR_GRUPO,
  BN402_NR_INST,
  BN402_NR_BANCO,
  BN402_TP_ACUM,
  BN007_NR_BANCO,
  BN007_NM_BANCO
  --?CB256_CD_CART,
  --?CB256_DS_CART
   
GO
