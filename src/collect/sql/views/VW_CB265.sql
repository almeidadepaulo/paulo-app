-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB265]'))
DROP VIEW [dbo].[VW_CB265]
GO

-- Cria View
CREATE VIEW [dbo].[VW_CB265]
WITH ENCRYPTION
AS
 SELECT 
  
  CB265.CB265_CD_COMPSC,
  CB265.CB265_NR_AGENC,
  CB265.CB265_NR_CONTA,
  CB265.CB265_NR_SEQ,
  CB265.CB265_DS_TEXTO,
  CB265.CB265_CD_OPESIS,
  CB265.CB265_DT_INCSIS,
  CB265.CB265_DT_ATUSIS,
  
  -- BANCO
  CB250.CB250_CD_COMPSC,
  CB250.CB250_NM_BANCO,
  
  -- AGENCIA
  CB251.CB251_CD_COMPSC,
  CB251.CB251_NM_AGENC,
  
  -- CONTA
  CB260.CB260_CD_COMPSC,
  CB260.CB260_NR_AGENC,
  CB260.CB260_NM_CEDENT
  
  
  FROM CB265 AS CB265
  
LEFT OUTER JOIN CB250 AS CB250  -- BANCO
ON     CB250_NR_OPERADOR = CB265_NR_OPERADOR
   AND CB250_NR_CEDENTE  = CB265_NR_CEDENTE
   AND CB250_CD_COMPSC	 = CB265_CD_COMPSC 

 LEFT OUTER JOIN CB251 AS CB251  -- AGENCIA
ON     CB251_NR_OPERADOR = CB265_NR_OPERADOR
   AND CB251_NR_CEDENTE  = CB265_NR_CEDENTE
   AND CB251_CD_COMPSC	 = CB265_CD_COMPSC 
   AND CB251_NR_AGENC	 = CB265_NR_AGENC   

 LEFT OUTER JOIN CB260 AS CB260  -- CONTA
 ON    CB260_NR_OPERADOR  = CB265_NR_OPERADOR
   AND CB260_NR_CEDENTE   = CB265_NR_CEDENTE
   AND CB260_CD_COMPSC	  = CB265_CD_COMPSC 
   AND CB260_NR_AGENC	  = CB265_NR_AGENC
   AND CB260_NR_CONTA	  = CB265_NR_CONTA

GO