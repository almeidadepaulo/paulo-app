-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN402_C]'))
DROP VIEW [dbo].[VW_BN402_C]
GO

-- Tela Carteira - Entrada por Conta
-- Cria View
CREATE VIEW [dbo].[VW_BN402_C]
WITH ENCRYPTION
AS
 SELECT 
	BN402_NR_GRUPO,
	BN402_NR_INST,
	BN402_DT_MOVTO,
    BN402_NR_BANCO,
    BN402_NR_AGENC,
    BN402_NR_CONTA,	
    BN009.BN009_NM_CONTA,
    Cast(BN402_NR_CONTA as varchar)+' - '+BN009.BN009_NM_CONTA AS BN_NR_NM_CONTA,
	SUM(BN402_VL_VALOR)  BN402_VL_VALOR ,
	SUM(BN402_QT_TOTAL)  BN402_QT_TOTAL

	-- BANCO
	--BN007_NM_BANCO,
	
	-- AGENCIA
	--BN008_NM_AGENC,

	-- CONTA
	--BN009_NM_CONTA

 FROM BN402 AS BN402

/*
 LEFT OUTER JOIN BN007 AS BN007  -- BANCO
 ON  BN007.BN007_NR_BANCO 	=  BN402.BN402_NR_BANCO
   
 INNER JOIN BN008 AS BN008		-- AG�NCIA
 ON  BN008.BN008_NR_BANCO = BN402.BN402_NR_BANCO
 AND BN008.BN008_NR_AGENC = BN402.BN402_NR_AGENC

 INNER JOIN BN009 AS BN009		-- CONTA
 ON  BN009.BN009_NR_BANCO = BN402.BN402_NR_BANCO
 AND BN009.BN009_NR_AGENC = BN402.BN402_NR_AGENC
 AND BN009.BN009_NR_CONTA = BN402.BN402_NR_CONTA
*/
 LEFT OUTER JOIN BN009 AS BN009	-- CONTA
 ON  BN009.BN009_NR_BANCO = BN402.BN402_NR_BANCO
 AND BN009.BN009_NR_AGENC = BN402.BN402_NR_AGENC
 AND BN009.BN009_NR_CONTA = BN402.BN402_NR_CONTA

 WHERE  BN402_TP_ACUM  = 2 /* ENTRADAS */

 GROUP BY 
	BN402_NR_GRUPO,
	BN402_NR_INST,
    BN402_NR_BANCO,
    BN402_NR_AGENC,
    BN402_NR_CONTA,
    BN009_NM_CONTA,
	BN402_DT_MOVTO
	--BN007_NM_BANCO,
	--BN008_NM_AGENC,
	--BN009_NM_CONTA
	
GO

