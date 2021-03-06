-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB209_ENTRADA_BANCO]'))
DROP VIEW [dbo].[VW_CB209_ENTRADA_BANCO]
GO

-- Tela Carteira - Entrada por Conta
-- Cria View
CREATE VIEW [dbo].[VW_CB209_ENTRADA_BANCO]
WITH ENCRYPTION
AS
 SELECT 
 	CB209_NR_OPERADOR,
	CB209_NR_CEDENTE,
	CB209_CD_COMPSC,
	CB209_DT_MOVTO ,
	CB250_NM_BANCO ,
	CB209_NR_AGENC ,
	CB209_NR_CONTA ,
	SUM(CB209_VL_VALOR)		CB209_VL_VALOR ,
	SUM(CB209_QT_CONTRA)	CB209_QT_CONTRA,
	SUM(CB209_QT_TOTAL)		CB209_QT_TOTAL,

	-- CONTA
    CB260_NM_CEDENT
  


 FROM CB209 AS CB209

LEFT OUTER JOIN CB250 AS CB250  -- BANCO
ON     CB250_NR_OPERADOR = CB209_NR_OPERADOR
   AND CB250_NR_CEDENTE  = CB209_NR_CEDENTE
   AND CB250_CD_COMPSC	 = CB209_CD_COMPSC 

 LEFT OUTER JOIN CB251 AS CB251  -- AGENCIA
ON     CB251_NR_OPERADOR = CB209_NR_OPERADOR
   AND CB251_NR_CEDENTE  = CB209_NR_CEDENTE
   AND CB251_CD_COMPSC	 = CB209_CD_COMPSC 
   AND CB251_NR_AGENC	 = CB209_NR_AGENC   

 LEFT OUTER JOIN CB260 AS CB260  -- CONTA
 ON    CB260_NR_OPERADOR  = CB209_NR_OPERADOR
   AND CB260_NR_CEDENTE   = CB209_NR_CEDENTE
   AND CB260_CD_COMPSC	  = CB209_CD_COMPSC 
   AND CB260_NR_AGENC	  = CB209_NR_AGENC
   AND CB260_NR_CONTA	  = CB209_NR_CONTA

 WHERE  CB209_ID_TIPOAC  = 2 /* ENTRADAS */

 GROUP BY 
  CB209_NR_OPERADOR,
  CB209_NR_CEDENTE,
  CB209_DT_MOVTO ,
  CB209_CD_COMPSC,
  CB250_NM_BANCO ,
  CB209_NR_AGENC ,
  CB251_NM_AGENC ,
  CB209_NR_CONTA ,
  CB260_NM_CEDENT
	
GO

