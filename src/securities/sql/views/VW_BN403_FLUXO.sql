-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN403_FLUXO]'))
DROP VIEW [dbo].[VW_BN403_FLUXO]
GO

-- Tela Fluxo de Vencimento
-- Cria View
CREATE VIEW [dbo].[VW_BN403_FLUXO]
WITH ENCRYPTION
AS
 SELECT -- REGISTRO DE EMISSAO - TITULOS A VENCER
  BN403.BN403_NR_GRUPO,
  BN403.BN403_NR_INST,
  BN403.BN403_DT_VENCTO 		DT_VENCTO,
  COUNT (*)						QT_TITULO,
  SUM (BN403.BN403_VL_VALOR) 	TT_TITULO,
  SUM (0) 						QT_CAPTACAO,
  SUM (0) 						TT_CAPTACAO
  
  FROM 	BN403 AS BN403
  WHERE BN403.BN403_ST_PAGTO =2
  GROUP BY 
  BN403.BN403_NR_GRUPO,
  BN403.BN403_NR_INST,
  BN403.BN403_DT_VENCTO

 UNION

 SELECT -- CAPTACOES COM VALOR ATUALIZADOS
   BN410.BN410_NR_GRUPO,
   BN410.BN410_NR_INST,
   BN410.BN410_DT_VENCTO 	 	DT_VENCTO,
   SUM (0)	  					QT_TITULO,
   SUM (0) 						TT_TITULO,
   COUNT (*)					QT_CAPTACAO,
   SUM (BN410.BN410_VL_ATUAL) 	TT_CAPTACAO
   
   FROM 	BN410 AS BN410
   WHERE    BN410.BN410_ST_DPG2 = 'S'

   GROUP BY 
   BN410.BN410_NR_GRUPO,
   BN410.BN410_NR_INST,
   BN410.BN410_DT_VENCTO

 UNION
    
 SELECT -- CAPTACOES - AUTORIZACOES - APROVADAS
   BN406.BN406_NR_GRUPO,
   BN406.BN406_NR_INST,
   BN406.BN406_DT_VCTOIF		DT_VCTO,
   SUM (0)	  					QT_TITULO,
   SUM (0)  					TT_TITULO,
   COUNT (*)					QT_CAPTACAO,
   SUM (BN406.BN406_VL_FINEMI) 	TT_CAPTACAO
   
   FROM BN406 AS BN406
   WHERE BN406.BN406_ST_APROV  = 'A'
   GROUP BY 
   BN406.BN406_NR_GRUPO,
   BN406.BN406_NR_INST,
   BN406.BN406_DT_VCTOIF

UNION


SELECT -- CCB - TITULOS A VENCER
  BN202.BN202_NR_GRUPO,
  BN202.BN202_NR_INST,
  BN202.BN202_DT_VTEPAR 		DT_VENCTO,
  COUNT (*)						QT_TITULO,
  SUM (BN202.BN202_VL_TEPARATU)	TT_TITULO,
  SUM (0) 						QT_CAPTACAO,
  SUM (0) 						TT_CAPTACAO
  
  FROM 	VW_BN202 AS BN202
  WHERE BN202.BN202_ST_PARCELA IN('A','L','P','S')
  AND	BN202.BN201_ST_CONTRATO  IN ('L','P','S')
  GROUP BY 
  BN202.BN202_NR_GRUPO,
  BN202.BN202_NR_INST,
  BN202.BN202_DT_VTEPAR

GO


