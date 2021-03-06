-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB209_DT]'))
DROP VIEW [dbo].[VW_CB209_DT]
GO

-- Tela Carteira - Entrada por Data de Movimento
-- Cria View
CREATE VIEW [dbo].[VW_CB209_DT]
WITH ENCRYPTION
AS
 SELECT 
  CB209_NR_OPERADOR,
  CB209_NR_CEDENTE,
  CB053_DS_EMIEMP,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR)  CB209_VL_VALOR ,
  SUM(CB209_QT_CONTRA) CB209_QT_CONTRA,
  SUM(CB209_QT_TOTAL)  CB209_QT_TOTAL
FROM CB209
LEFT JOIN CB053
ON  CB053_NR_INST	= CB209_NR_OPERADOR   
AND CB209_NR_CEDENTE = CB053_CD_EMIEMP
  WHERE CB209_ID_TIPOAC		= 2 /* ENTRADAS */
GROUP BY 
  CB209_DT_MOVTO ,
  CB209_NR_OPERADOR,
  CB209_NR_CEDENTE,
  CB053_DS_EMIEMP

 
GO

