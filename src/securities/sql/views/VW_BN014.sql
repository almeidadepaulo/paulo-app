-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN014]'))
DROP VIEW [dbo].[VW_BN014]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN014]
WITH ENCRYPTION
AS
  SELECT 
  BN014.BN014_NR_GRUPO,
  BN014.BN014_NR_INST,
  BN014.BN014_NR_SEQ,
  BN014.BN014_NM_CONTA,
  BN014.BN014_NM_CARGO,
  BN014.BN014_NR_DDDTEL,
  BN014.BN014_NR_TEL,
  BN014.BN014_NR_DDDCEL,
  BN014.BN014_NR_CEL,
  BN014.BN014_NM_EMAIL,  
  BN014.BN014_NR_OPESIS,
  BN014.BN014_DT_INCSIS,
  BN014.BN014_DT_ATUSIS,
  
  CAST(BN014.BN014_NR_DDDTEL AS VARCHAR)+CAST(BN014.BN014_NR_TEL AS VARCHAR) AS BN014_NR_DDD_TEL,
  CAST(BN014.BN014_NR_DDDCEL AS VARCHAR)+CAST(BN014.BN014_NR_CEL AS VARCHAR) AS BN014_NR_DDD_CEL
    
  
  FROM BN014 AS BN014

GO


