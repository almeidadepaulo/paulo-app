-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN402_B]'))
DROP VIEW [dbo].[VW_BN402_B]
GO

-- Tela Carteira - Entrada por Banco
-- Cria View
CREATE VIEW [dbo].[VW_BN402_B]
WITH ENCRYPTION
AS
 SELECT 
	BN402_NR_GRUPO,
	BN402_NR_INST,
	BN402_DT_MOVTO ,
	SUM(BN402_VL_VALOR)  BN402_VL_VALOR ,
	SUM(BN402_QT_TOTAL)  BN402_QT_TOTAL,
	BN402_NR_BANCO,

	-- BANCO
	BN007.BN007_NM_BANCO

 FROM BN402 AS BN402

 LEFT OUTER JOIN BN004
 ON BN004.BN004_NR_PROD = BN402.BN402_NR_PROD


 LEFT OUTER JOIN BN007 AS BN007  -- BANCO
 ON  (BN007.BN007_NR_BANCO 	=  BN402.BN402_NR_BANCO AND BN004.BN004_TP_PROD <> 'B')

 WHERE  BN402_TP_ACUM  = 2 /* ENTRADAS */

 GROUP BY 
	BN402_NR_GRUPO,
	BN402_NR_INST,
	BN402_NR_BANCO,
	BN402_DT_MOVTO,
	BN007_NM_BANCO
	
GO

