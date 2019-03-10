-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN100]'))
DROP VIEW [dbo].[VW_BN100]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BN100]
WITH ENCRYPTION
AS
  SELECT 
	BN100.BN100_NR_CNPJ
	,BN100.BN100_TP_MOVTO
	,BN100.BN100_NR_LOTE
	,BN100.BN100_QT_CONRE
	,BN100.BN100_QT_GARRE
	,BN100.BN100_QT_PARRE
	,BN100.BN100_TT_PARRE
	,BN100.BN100_QT_CONLI
	,BN100.BN100_QT_GARLI
	,BN100.BN100_QT_PARLI
	,BN100.BN100_TT_PARLI
	,BN100.BN100_QT_CONDEV
	,BN100.BN100_QT_GARDEV
	,BN100.BN100_QT_PARDEV
	,BN100.BN100_TT_PARDEV
	,BN100.BN100_TT_PRES
	,BN100.BN100_TT_EXIG
	,BN100.BN100_ST_RETBCO
	,BN100.BN100_ST_RETCCC
	,BN100.BN100_QT_CONCCC
	,BN100.BN100_QT_GARCCC
	,BN100.BN100_QT_PARCCC
	,BN100.BN100_DT_GRAV
	,BN100.BN100_HR_GRAV
	,BN100.BN100_NR_GRUPO
	,BN100.BN100_NR_INST
	,BN100.BN100_ST_LOTE
	,BN100.BN100_ST_ACAO
	,BN100.BN100_ST_PROC
	,BN100.BN100_DT_BASE
	,BN100.BN100_NR_OPESIS
	,BN100.BN100_DT_INCSIS
	,BN100.BN100_DT_ATUSIS

	,VW_BN001.BN001_NM_GRUPO
	,VW_BN001.BN001_NR_NM_GRUPO

	,BN002.BN002_NR_INST
	,BN002.BN002_NM_INST
  
	-- REGRA PARA TIPO DO LOTE
	,(SELECT
	
		COUNT(*)
	
		 FROM BN150 AS BN150
		 
		 INNER JOIN BN004 AS BN004
		 ON BN004.BN004_NR_PROD = BN150.BN150_NR_PROD
		 
		 WHERE 1=1
		 AND BN150_NR_LOTE		= BN100.BN100_NR_LOTE
		  AND BN150_TP_MOVTO	= BN100.BN100_TP_MOVTO
		 AND BN150_NR_CNPJ		=  BN100.BN100_NR_CNPJ
		 
		 
		 AND BN004_TP_PROD = 'C'  
	) AS CONSIGNADO_COUNT
	  
	,(SELECT
		
			COUNT(*)
		
		 FROM BN150 AS BN150
		 
		 INNER JOIN BN004 AS BN004
		 ON BN004.BN004_NR_PROD = BN150.BN150_NR_PROD
		 
		 WHERE 1=1
		 AND BN150_NR_LOTE		= BN100.BN100_NR_LOTE
		  AND BN150_TP_MOVTO	= BN100.BN100_TP_MOVTO
		 AND BN150_NR_CNPJ		=  BN100.BN100_NR_CNPJ
		 
		 
		 AND BN004_TP_PROD = 'V'  
	) AS VEICULO_COUNT
		
	,(SELECT
		
			COUNT(*)
		
		 FROM BN150 AS BN150
		 
		 INNER JOIN BN004 AS BN004
		 ON BN004.BN004_NR_PROD = BN150.BN150_NR_PROD
		 
		 WHERE 1=1
		 AND BN150_NR_LOTE		= BN100.BN100_NR_LOTE
		  AND BN150_TP_MOVTO	= BN100.BN100_TP_MOVTO
		 AND BN150_NR_CNPJ		=  BN100.BN100_NR_CNPJ
		 
		 
		 AND BN004_TP_PROD = 'P'  
	) AS CP_COUNT

	/*
	,(SELECT
		
			COUNT(*)
		
		 FROM BN150 AS BN150
		 
		 INNER JOIN BN004 AS BN004
		 ON BN004.BN004_NR_PROD = BN150.BN150_NR_PROD
		 
		 WHERE 1=1
		 AND BN150_NR_LOTE		= BN100.BN100_NR_LOTE
		  AND BN150_TP_MOVTO	= BN100.BN100_TP_MOVTO
		 AND BN150_NR_CNPJ		=  BN100.BN100_NR_CNPJ
		 
		 
		 AND BN004_TP_PROD = 'B'  
	) AS CCB_COUNT
	*/
		
	
	,(SELECT
		
			COUNT(*)
		
		 FROM BN201 AS BN201
		 
		 INNER JOIN BN004 AS BN004
		 ON BN004.BN004_NR_PROD = BN201.BN201_NR_PROD
		 
		 WHERE 1=1
		 AND BN201_NR_LOTE		= BN100.BN100_NR_LOTE		 
		 --AND BN201_NR_CNPJ		=  BN100.BN100_NR_CNPJ
		 --AND BN201_ST_CONTRATO  IN ('L','C','N')
		 
		 AND BN004_TP_PROD = 'B'  
	) AS CCB_COUNT
  
  FROM BN100 AS BN100
  
  INNER JOIN VW_BN001 AS VW_BN001
  ON BN100.BN100_NR_GRUPO = VW_BN001.BN001_NR_GRUPO
  
  INNER JOIN BN002 AS BN002
  ON BN100.BN100_NR_INST = BN002.BN002_NR_INST

GO


SELECT * FROM VW_BN100
WHERE BN100_NR_LOTE = 1