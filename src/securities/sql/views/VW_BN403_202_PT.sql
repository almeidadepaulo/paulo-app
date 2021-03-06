-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_BN403_202_PT]'))
DROP VIEW [dbo].[VW_BN403_202_PT]
GO

-- Tela Posi��o de t�tulo
-- Cria View
CREATE VIEW [dbo].[VW_BN403_202_PT]
WITH ENCRYPTION
AS
 SELECT 
 
 --TOP 2 --[P/ TESTE]
 
 'BN403' AS MAIN_TABLE,

-- REGISTRO DE EMISSAO
  BN403.BN403_NR_INST,
  BN403.BN403_NR_GRUPO,
  BN403.BN403_NR_LOTE,
--  BN403.BN403_NR_CPFCNPJ,
  BN403.BN403_NR_CONTRA,
  BN403.BN403_ST_PAGTO,
  BN403.BN403_NR_BANCO,
  BN403.BN403_NR_AGENC,
  BN403.BN403_NR_CONTA,
  BN403.BN403_NR_NOSNUM,
  BN403.BN403_VL_VALOR,
  BN403.BN403_DT_VENCTO,
  BN403_TP_BAIXA =
	CASE 
  	   WHEN BN403.BN403_ST_PAGTO = 2 THEN 0 
       ELSE BN403.BN403_TP_BAIXA
	END,

-- EMISSOR  
  BN002.BN002_NR_INST,
  BN002.BN002_NR_CNPJ,
  BN002.BN002_NM_INST,
  BN002.BN002_NR_GRUPO,  
  cast(BN002.BN002_NR_INST as varchar)+' - '+BN002.BN002_NM_INST AS BN002_NR_NM_INST,
  
  
-- TITULO
--  CB203.CB203_CD_RFORM,

-- BAIXA
  BN400.BN400_DT_PAGTO,
  /*
  BN400.BN400_NR_OAGENC,
  BN400.BN400_NR_OBANCO,
  BN400.BN400_NR_OCONTA,
  BN400.BN400_NR_NOSNUM,
  BN400.BN400_NR_RBANCO,
  */


-- CONTRATO
  BN405.BN405_TP_CPFCNPJ,
  BN405.BN405_NR_CPFCNPJ,
  BN405.BN405_NR_CONTRA,
  -1 AS BN201_NR_REME,
  '' AS BN017_NR_NM_CNAE,
  '' AS BN201_NR_ATIVO,
  -1 AS BN202_NR_PARC,
  -1 AS BN202_TX_EVENTO,
  -1 AS BN202_VL_TEPARORI,
  -1 AS BN202_VL_TEPARATU,

-- LOTE - CONTRATO (DADOS DO CLIENTE)
  BKN010.BKN010_NM_CLIENT,
  BKN010.BKN010_NM_CIDADE,
  BKN010.BKN010_NM_LOGRAD,
  BKN010.BKN010_NR_CEP,
  BKN010.BKN010_NM_BAIRRO,
  BKN010.BKN010_SG_UF,
  BKN010.BKN010_DT_LIBERA,
/*
  BN150.BN150_NM_CLIENT,
  BN150.BN150_NM_CIDADE,
  BN150.BN150_NM_LOGRAD,
  BN150.BN150_NR_CEP,
  BN150.BN150_NM_BAIRRO,
  BN150.BN150_SG_UF,
  BN150.BN150_DT_LIBERA,
*/

-- PRODUTO
  BN004.BN004_NR_PROD,
  BN004.BN004_TP_PROD,
  BN004.BN004_NM_PROD,

  
-- BANCO
  BN007.BN007_NM_BANCO,
  BN007.BN007_NR_BANCO,


-- AGENCIA
  BN008.BN008_NM_AGENC,
  BN008.BN008_NR_AGENC


  FROM BN403 AS BN403
  

  LEFT JOIN BN002 AS BN002 -- INSTITUICAO
  ON  BN002.BN002_NR_INST 	= BN403.BN403_NR_INST
  AND BN002.BN002_NR_GRUPO  = BN403.BN403_NR_GRUPO

    
  LEFT JOIN BN405 AS BN405 -- CONTRATO - DADOS SACADO
  ON  BN405.BN405_NR_CONTRA  = BN403.BN403_NR_CONTRA
  AND BN405.BN405_NR_GRUPO   = BN403.BN403_NR_GRUPO
  AND BN405.BN405_NR_INST 	 = BN403.BN403_NR_INST
  
  LEFT JOIN BN004 AS BN004 -- PRODUTO
  ON BN004.BN004_NR_PROD = BN405.BN405_NR_PROD   
  
  /*
  LEFT JOIN BN150 AS BN150 -- LOTE - CONTRATO
  ON  	BN150.BN150_NR_CNPJ  	= BN002.BN002_NR_CNPJ
  AND  	BN150.BN150_TP_MOVTO 	= 'D'
  AND  	BN150.BN150_NR_LOTE  	= BN405.BN405_NR_LOTE
  AND  	BN150.BN150_NR_CONTRA 	= BN405.BN405_NR_CONTRA
  AND  	BN150.BN150_NR_ERRO   	= 0  
  */
   LEFT JOIN BKN010 AS BKN010 -- LOTE - CONTRATO
  ON  	BKN010.BKN010_NR_CPFCNPJ	= BN405.BN405_NR_CPFCNPJ  
  AND  	BKN010.BKN010_NR_LOTE  		= BN405.BN405_NR_LOTE
  AND  	BKN010.BKN010_NR_CONTRA		= BN405.BN405_NR_CONTRA
   

  LEFT  JOIN BN400 AS BN400 -- BAIXA
  ON  BN400.BN400_NR_OBANCO 		= BN403.BN403_NR_BANCO
  AND BN400.BN400_NR_NOSNUM 		= BN403.BN403_NR_NOSNUM
  AND BN400.BN400_NR_OAGENC 		= BN403.BN403_NR_AGENC
  AND BN400.BN400_NR_OCONTA 		= BN403.BN403_NR_CONTA

  LEFT JOIN BN007 AS BN007 -- BANCO
  ON  BN007.BN007_NR_BANCO 		= BN403.BN403_NR_BANCO


  LEFT JOIN BN008  AS BN008 -- AGENCIA
  ON  BN008.BN008_NR_AGENC 			= BN403.BN403_NR_AGENC
  AND BN008.BN008_NR_BANCO 			= BN403.BN403_NR_BANCO