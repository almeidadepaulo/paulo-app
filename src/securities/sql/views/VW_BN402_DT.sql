-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN402_DT]'))
DROP VIEW [dbo].[VW_BN402_DT]
GO

-- Tela Carteira - Entrada por Data de Movimento
-- Cria View
CREATE VIEW [dbo].[VW_BN402_DT]
WITH ENCRYPTION
AS
 SELECT 
  BN402_NR_GRUPO,
  BN402_NR_INST,
  BN402_DT_MOVTO ,
  SUM(BN402_VL_VALOR)  BN402_VL_VALOR ,
  SUM(BN402_QT_TOTAL)  BN402_QT_TOTAL
  FROM BN402 AS BN402
  
  WHERE  BN402_TP_ACUM  = 2 /* ENTRADAS */
  
GROUP BY 
  BN402_NR_GRUPO,
  BN402_NR_INST,
  BN402_DT_MOVTO 
 
GO

