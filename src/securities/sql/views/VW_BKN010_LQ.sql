-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BKN010_LQ]'))
DROP VIEW [dbo].[VW_BKN010_LQ]
GO

-- Cria View
CREATE VIEW [dbo].[VW_BKN010_LQ]
WITH ENCRYPTION
AS

  SELECT --DISTINCT 
	 BKN010.BKN010_NR_BANCO
	,BKN010.BKN010_NR_CONTRA
    ,BKN010.BKN010_TP_CPFCNPJ
	,BKN010.BKN010_NR_CPFCNPJ
	,BKN010.BKN010_NM_CLIENT
	,BKN010.BKN010_DT_NASC
    ,BKN010.BKN010_VL_FINAM
    ,BKN010.BKN010_VL_PARC
    ,BKN010.BKN010_QT_PARC
    ,BKN010.BKN010_TX_FINAM
    --,BKN010.BKN010_NR_CESS
    --,BKN010.BKN010_NR_ENT
	
	,BKN018.BKN018_NR_BANCO
	,BKN018.BKN018_TP_MOVTO
	,BKN018.BKN018_NR_ORDEM
	,BKN018.BKN018_NR_CONTRA
	,BKN018.BKN018_DT_VENCTO
	,BKN018.BKN018_NR_SEQ
	,BKN018.BKN018_VL_ABAT
    ,BKN018.BKN018_TT_PARABE
    ,BKN018.BKN018_VL_ACRE
    ,BKN018.BKN018_VL_DESC
	
    ,BKN018.BKN018_TP_INAD
	,BKN018.BKN018_TP_LIQAUT	
	,BKN018.BKN018_QT_PARORI
	,BKN018.BKN018_VL_PARC
	,BKN018.BKN018_VL_DIVIDA
    
    ,(select TOP 1 BKN004_NR_ORDEM from BKN004 ORDER BY BKN004_DT_HOJE DESC) AS hasNow
    
    /* Entidade Bloqueadas: Contratos Suspensos */
    ,SUM(CASE 
	   WHEN BKN010_NR_ENT = 9 OR BKN010_NR_ENT = 16  OR BKN010_NR_ENT = 33 OR BKN010_NR_ENT = 46 
			OR (BKN010_NR_ENT BETWEEN 35 AND 43)
			THEN 1
	   ELSE 0
	 END) AS ENT_BLOQUEADO
     
	,SUM(CASE 
	   WHEN BKN010_NR_ENT = 9  OR BKN010_NR_ENT= 16  OR BKN010_NR_ENT=33 OR BKN010_NR_ENT = 46 
			OR (BKN010_NR_ENT BETWEEN 35 AND 43)
			THEN 0
	   ELSE 1
	 END) AS ENT_NAO_BLOQUEADO
    
     /* Cessionários Bloqueados: Contratos Suspensos */
	,SUM(CASE
	 WHEN BKN010_NR_CESS BETWEEN 4 AND 12 
		THEN 1
	 ELSE 0
	 END) AS CESS_BLOQUEADO
     
     ,SUM(CASE
	 WHEN BKN010_NR_CESS BETWEEN 4 AND 12 
		THEN 0
	 ELSE 1
	 END) AS CESS_NAO_BLOQUEADO

	
FROM BKN010 AS BKN010

      LEFT OUTER JOIN BKN018 AS BKN018	
      ON  BKN018.BKN018_NR_BANCO  = BKN010.BKN010_NR_BANCO
      AND BKN018.BKN018_NR_CONTRA = BKN010.BKN010_NR_CONTRA
      AND 
      (
        
      	(
      	BKN018.BKN018_NR_ORDEM = (select TOP 1 BKN004_NR_ORDEM from BKN004 ORDER BY BKN004_DT_HOJE DESC)
        AND  
        BKN018_NR_ORDEM <> 1          
        )
        
      	--OR
      	
      	--BKN018.BKN018_NR_ORDEM = (select TOP 1 BKN018_NR_ORDEM from BKN018 ORDER BY BKN018_DT_ATUSIS DESC)            
        
      )

GROUP BY
 BKN010.BKN010_NR_BANCO
,BKN010.BKN010_NR_CONTRA
,BKN010.BKN010_TP_CPFCNPJ
,BKN010.BKN010_NR_CPFCNPJ
,BKN010.BKN010_NM_CLIENT
,BKN010.BKN010_DT_NASC
,BKN010.BKN010_VL_FINAM
,BKN010.BKN010_VL_PARC
,BKN010.BKN010_QT_PARC
,BKN010.BKN010_TX_FINAM
--,BKN010.BKN010_NR_CESS
--,BKN010.BKN010_NR_ENT
	
,BKN018.BKN018_NR_BANCO
,BKN018.BKN018_TP_MOVTO
,BKN018.BKN018_NR_ORDEM
,BKN018.BKN018_NR_CONTRA
,BKN018.BKN018_DT_VENCTO
,BKN018.BKN018_NR_SEQ
,BKN018.BKN018_VL_ABAT
,BKN018.BKN018_TT_PARABE
,BKN018.BKN018_VL_ACRE
,BKN018.BKN018_VL_DESC
	
,BKN018.BKN018_TP_INAD
,BKN018.BKN018_TP_LIQAUT	
,BKN018.BKN018_QT_PARORI
,BKN018.BKN018_VL_PARC
,BKN018.BKN018_VL_DIVIDA
GO


