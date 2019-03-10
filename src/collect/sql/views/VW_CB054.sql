-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB054]'))
DROP VIEW [dbo].[VW_CB054]
GO

-- Cria View
CREATE VIEW [dbo].[VW_CB054]
WITH ENCRYPTION
AS
  SELECT 
  CB054.CB054_NR_INST,
  CB054.CB054_CD_EMIEMP,
  CB054.CB054_NR_SEQ,
  CB054.CB054_NM_CONTA,
  CB054.CB054_NM_CARGO,
  CB054.CB054_NR_DDDTEL,
  CB054.CB054_NR_TEL,
  CB054.CB054_NR_DDDCEL,
  CB054.CB054_NR_CEL,
  CB054.CB054_NM_EMAIL,  
  CB054.CB054_NR_OPESIS,
  CB054.CB054_DT_INCSIS,
  CB054.CB054_DT_ATUSIS,
  
  CAST(CB054.CB054_NR_DDDTEL AS VARCHAR)+CAST(CB054.CB054_NR_TEL AS VARCHAR) AS CB054_NR_DDD_TEL,
  CAST(CB054.CB054_NR_DDDCEL AS VARCHAR)+CAST(CB054.CB054_NR_CEL AS VARCHAR) AS CB054_NR_DDD_CEL
    
  
  FROM CB054 AS CB054

GO


