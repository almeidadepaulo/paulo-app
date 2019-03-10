-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN402_ENTRADA_BANCO]'))
DROP VIEW [dbo].[VW_BN402_ENTRADA_BANCO]
GO

-- Tela Carteira - Entrada por Banco
-- Cria View
CREATE VIEW [dbo].[VW_BN402_ENTRADA_BANCO]
WITH ENCRYPTION
AS
 SELECT 
 	BN402_NR_GRUPO,
	BN402_NR_INST,
	BN402_NR_BANCO,
	BN402_DT_MOVTO ,
	BN007_NM_BANCO ,
	BN008_NR_AGENC ,
	BN009_NR_CONTA ,
	SUM(BN402_VL_VALOR)		BN402_VL_VALOR ,
	--SUM(CB209_QT_CONTRA)	CB209_QT_CONTRA,
	SUM(BN402_QT_TOTAL)		BN402_QT_TOTAL,

	-- CONTA
    BN009_NM_CONTA,
  
	-- CESSIONÁRIO
	BN001_NM_GRUPO 


 FROM BN402 AS BN402

 LEFT OUTER JOIN BN001
 ON BN001_NR_GRUPO = BN402_NR_GRUPO -- CESSIONÁRIO

 LEFT OUTER JOIN BN007 AS BN007  -- BANCO
 ON  BN007_NR_BANCO	= BN402_NR_BANCO 

 LEFT OUTER JOIN BN008 AS BN008  -- AGENCIA
 ON	 BN008_NR_BANCO	= BN402_NR_BANCO 
 AND BN008_NR_AGENC	= BN008_NR_AGENC   

 LEFT OUTER JOIN BN009 AS BN009  -- CONTA
 ON  BN009_NR_BANCO	= BN402_NR_BANCO 
 AND BN009_NR_AGENC	= BN402_NR_AGENC
 AND BN009_NR_CONTA	= BN402_NR_CONTA

 WHERE  BN402_TP_ACUM  = 2 /* ENTRADAS */

 GROUP BY 
  BN402_NR_GRUPO,
  BN402_NR_INST,
  BN402_DT_MOVTO,
  BN402_NR_BANCO,
  BN007_NM_BANCO,
  BN008_NR_AGENC,
  BN008_NM_AGENC,
  BN009_NR_CONTA,
  BN009_NM_CONTA,

   -- CESSIONÁRIO
  BN001_NM_GRUPO 
	
GO

