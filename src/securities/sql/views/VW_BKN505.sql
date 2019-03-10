-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BKN505]'))
DROP VIEW [dbo].[VW_BKN505]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BKN505]
WITH ENCRYPTION
AS

  SELECT 
  
  BKN505.BKN505_NR_BANCO,
  BKN505.BKN505_NR_TPLANC,
  BKN505.BKN505_NM_TPLANC,
  BKN505.BKN505_NR_PROD,
  BKN505.BKN505_TP_SINAL,
  BKN505.BKN505_NR_OPESIS,
  BKN505.BKN505_DT_INCSIS,
  BKN505.BKN505_DT_ATUSIS,
  BKN505.BKN505_TP_FINANC,
  
  BKN005.BKN005_NR_PROD,
  BKN005.BKN005_NM_PROD

  FROM BKN505 AS BKN505
    
  LEFT OUTER JOIN BKN005 AS BKN005
  ON BKN005.BKN005_NR_PROD = BKN505.BKN505_NR_PROD

GO


