-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN007]'))
DROP VIEW [dbo].[VW_BN007]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN007]
WITH ENCRYPTION
AS
  SELECT 
  
  BN007.BN007_NR_BANCO,
  BN007.BN007_NM_BANCO,
  BN007.BN007_NR_OPESIS,
  BN007.BN007_DT_INCSIS,
  BN007.BN007_DT_ATUSIS,
  
  Cast(BN007.BN007_NR_BANCO as varchar) +' - '+ BN007.BN007_NM_BANCO AS BN007_NR_NM_BANCO
  
  FROM BN007 AS BN007

GO


