-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN009]'))
DROP VIEW [dbo].[VW_BN009]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN009]
WITH ENCRYPTION
AS
  SELECT 
  
  BN009.BN009_NR_BANCO,
  BN009.BN009_NR_AGENC,
  BN009.BN009_NR_CONTA,
  BN009.BN009_NM_CONTA,
  BN009.BN009_NR_CPFCNPJ,
  BN009.BN009_TP_CPFCNPJ,
  BN009.BN009_NR_OPESIS,
  BN009.BN009_DT_INCSIS,
  BN009.BN009_DT_ATUSIS,
  
  Cast(BN009.BN009_NR_CONTA as varchar)  AS BN009_NR_CONTA_DG,

  
  BN007.BN007_NR_BANCO,
  BN007.BN007_NM_BANCO,
  
  BN008.BN008_NR_BANCO,
  BN008.BN008_NR_AGENC,
  BN008.BN008_NM_AGENC
  
  FROM BN009 as BN009
        
  INNER JOIN BN007 AS BN007 -- BANCO
  ON BN009.BN009_NR_BANCO = BN007.BN007_NR_BANCO 
    
  INNER JOIN BN008 AS BN008 -- AG�NCIA
  ON BN009.BN009_NR_BANCO = BN008.BN008_NR_BANCO
  AND BN009.BN009_NR_AGENC = BN008.BN008_NR_AGENC

GO

