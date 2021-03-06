-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BKN508]'))
DROP VIEW [dbo].[VW_BKN508]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BKN508]
WITH ENCRYPTION
AS
  SELECT 
  
  BKN508.BKN508_NR_BANCO,
  BKN508.BKN508_NR_CESS,
  BKN508.BKN508_NR_LANC,
 -- BKN508.BKN508_NR_CONT,
  BKN508.BKN508_VL_LANC,
  BKN508.BKN508_TP_SINAL,
  BKN508.BKN508_DT_MOVTO,
  BKN508.BKN508_NR_TPLANC,
  BKN508.BKN508_NM_COMPL,
  BKN508.BKN508_NR_OPESIS,
  BKN508.BKN508_DT_INCSIS,
  BKN508.BKN508_DT_ATUSIS,
  
  
  BKN002.BKN002_NR_BANCO,
  BKN002.BKN002_NR_CESS,
  BKN002.BKN002_NR_CNPJ,
  BKN002.BKN002_NM_CESS,
  BKN002.BKN002_NR_OPESIS,
  BKN002.BKN002_DT_INCSIS,
  BKN002.BKN002_DT_ATUSIS,
  
  BKN505.BKN505_NR_BANCO,
  BKN505.BKN505_NR_TPLANC,
  BKN505.BKN505_NM_TPLANC,
  BKN505.BKN505_TP_FINANC,
  BKN505.BKN505_TP_SINAL,
  BKN505.BKN505_NR_OPESIS,
  BKN505.BKN505_DT_INCSIS,
  BKN505.BKN505_DT_ATUSIS,
  
  BKN505.BKN505_NR_PROD
  
   
   FROM BKN508 AS BKN508
   
   INNER JOIN BKN002 AS BKN002
   ON  BKN508.BKN508_NR_BANCO = BKN002.BKN002_NR_BANCO
   AND BKN508.BKN508_NR_CESS  = BKN002.BKN002_NR_CESS
   
   LEFT OUTER JOIN BKN505 AS BKN505
   ON  BKN508.BKN508_NR_BANCO = BKN505.BKN505_NR_BANCO
   AND BKN508.BKN508_NR_TPLANC  = BKN505.BKN505_NR_TPLANC



GO


