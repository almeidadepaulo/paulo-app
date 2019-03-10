USE BANKNET
GO
-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB209_CARTEIRA]'))
DROP VIEW [dbo].VW_CB209_CARTEIRA
GO

-- Tela Carteira - Carteira por Banco
-- Cria View
CREATE VIEW [dbo].VW_CB209_CARTEIRA
WITH ENCRYPTION
AS
 SELECT 
	CB209_NR_OPERADOR,
	CB209_NR_CEDENTE,
	CB209_DT_MOVTO ,
	SUM(CB209_VL_VALOR)		CB209_VL_VALOR ,
	SUM(CB209_QT_CONTRA)	CB209_QT_CONTRA,
	SUM(CB209_QT_TOTAL)		CB209_QT_TOTAL,
	CB209_CD_COMPSC,

	-- BANCO
	CB250_CD_COMPSC,
	CB250_NM_BANCO

 FROM CB209 AS CB209

LEFT OUTER JOIN CB250 AS CB250  -- BANCO
ON     CB250_NR_OPERADOR = CB209_NR_OPERADOR
   AND CB250_NR_CEDENTE  = CB209_NR_CEDENTE
   AND CB250_CD_COMPSC	 = CB209_CD_COMPSC

 WHERE  CB209_ID_TIPOAC = 10 /* SALDO ATUAL */

 GROUP BY 
  CB209_DT_MOVTO,
  CB209_NR_OPERADOR,
  CB209_NR_CEDENTE,
  CB209_CD_COMPSC,
  CB250_CD_COMPSC,
  CB250_NM_BANCO 
	
GO

