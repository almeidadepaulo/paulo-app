-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BKN001]'))
DROP VIEW [dbo].[VW_BKN001]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BKN001]
WITH ENCRYPTION
AS

  SELECT 
  
  BKN001.BKN001_NR_BANCO,
  BKN001.BKN001_NR_CNPJ,
  BKN001.BKN001_NM_BANCO,
  BKN001.BKN001_NR_OPESIS,
  BKN001.BKN001_DT_INCSIS,
  BKN001.BKN001_DT_ATUSIS,
  
   Cast(BKN001.BKN001_NR_BANCO as varchar)+' - '+BKN001.BKN001_NM_BANCO AS BKN001_NR_NM_BANCO
   
   FROM BKN001 AS BKN001

GO


