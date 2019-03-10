use BANKNET

-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB262]'))
DROP VIEW [dbo].[VW_CB262]
GO

-- Criar View
CREATE VIEW [dbo].[VW_CB262]
WITH ENCRYPTION
AS

SELECT
  CB262_NR_OPERADOR,
  CB262_NR_CEDENTE,
  CB262_NR_CONTRA,
  CB262_NR_CPFCNPJ,
  CB262_DT_LIBERA,
  CB262_CD_PRODUTO,
  CB262_TX_FINAM,
  CB262_VL_FINAM,
  CB262_QT_PARC,
  CB262_VL_PARC,
  CB262_NR_DDD,
  CB262_NR_TEL,
  CB262_NM_EMAIL,
  0 AS CB262_TX_MORA,
  0 AS CB262_TX_MULTA,
  0 AS CB262_TX_JUROS,
  0 AS CB262_TP_FLMORA,
  0 AS CB262_TP_FLMULTA,
  0 AS CB262_TP_FLJUROS,
  0 AS CB262_NR_DIAATR,
  CB262_NM_LOGRAD AS CB262_DS_LOGRAD,
  CB262_NM_LOGRAD,
  100 AS CB262_NR_LOGRAD,
  '' AS CB262_DS_COMLGR,
  CB262_NM_BAIRRO AS CB262_DS_BAIRRO,
  CB262_NM_BAIRRO,
  CB262_NM_CIDADE,
  CB262_SG_UF,
  CB262_NR_CEP AS CB262_CD_CEP,
  CB262_NR_CEP,
  0 AS CB262_TP_END,
  0 AS CB262_ID_ERREND,
  0 AS CB262_ID_REMISS,
  CB262_NM_CLIENT,
  CB262_NR_DDD AS CB262_NR_DDD1,
  CB262_NR_TEL AS CB262_NR_FONE1,
  0 AS CB262_NR_DDD2,
  0 AS CB262_NR_FONE2,
  --CONVERT(VARCHAR(3), CB262_NR_DDD1) + '-' + CONVERT(VARCHAR(9), CB262_NR_FONE1) CB262_NR_DDFONE1,
  --CONVERT(VARCHAR(3), CB262_NR_DDD2) + '-' + CONVERT(VARCHAR(9), CB262_NR_FONE2) CB262_NR_DDFONE2,
  CONVERT(VARCHAR(3), CB262_NR_DDD) + '-' + CONVERT(VARCHAR(9), CB262_NR_TEL) CB262_NR_DDFONE1,
  CONVERT(VARCHAR(3), CB262_NR_DDD) + '-' + CONVERT(VARCHAR(9), CB262_NR_TEL) CB262_NR_DDFONE2,
  CB262_DT_NASC,
  0 AS CB262_NR_REGION,
  0 AS CB262_ID_ENVGRF,
  0 AS CB262_DT_ENVGRF,
  0 AS CB262_ID_RTNGRF,
  0 AS CB262_DT_RTNGRF,
  0 AS CB262_ID_RTNCOR,
  0 AS CB262_DT_RTNCOR,
  0 AS CB262_ID_MTVDEV,
  /*CASE 
    WHEN CB262_ID_MTVDEV = 1 THEN 'Mudou-se'
    WHEN CB262_ID_MTVDEV = 2 THEN 'Endereço insuficiente'
    WHEN CB262_ID_MTVDEV = 3 THEN 'Não existe o numero indicado'
    WHEN CB262_ID_MTVDEV = 4 THEN 'Falecido'
    WHEN CB262_ID_MTVDEV = 5 THEN 'Desconhecido'
    WHEN CB262_ID_MTVDEV = 6 THEN 'Recusado'
    WHEN CB262_ID_MTVDEV = 7 THEN 'Ausente'
    WHEN CB262_ID_MTVDEV = 8 THEN 'Não procurado'
    WHEN CB262_ID_MTVDEV = 9 THEN 'Outros'
    WHEN CB262_ID_MTVDEV = 100 THEN 'Cep invalido'
    WHEN CB262_ID_MTVDEV = 101 THEN 'CEP x Estado inválido'
    WHEN CB262_ID_MTVDEV = 102 THEN 'Dados do endereço faltante'
    ELSE 'Indefinido'
  END CB262_ID_MTVDEV_label,*/
  '' AS CB262_ID_MTVDEV_label,
  0 AS CB262_QT_SEGVIA,
  0 AS CB262_DT_SOLUC,
  0 AS CB262_CD_OPESIS,
  CB262_DT_INCSIS,
  CB262_DT_ATUSIS,

  CB255_DS_PROD,
  CB255_DS_PRODR
FROM
  CB262

LEFT OUTER JOIN CB255
ON  CB255_NR_OPERADOR = CB262_NR_OPERADOR
AND CB255_NR_CEDENTE  = CB262_NR_CEDENTE
--AND CB255_CD_PROD     = CB262_CD_PRODUT
AND CB255_CD_PROD     = CB262_CD_PRODUTO

/*LEFT OUTER JOIN BKN005
ON BKN005_NR_PROD = CB262_CD_PRODUT*/
UNION ALL -- FACEBANK

SELECT
  CB213_NR_OPERADOR,
  CB213_NR_CEDENTE,
  CB213_NR_CONTRA,
  CB213_NR_CPFCNPJ,
  CB213_DT_LIBERA,
  CB213_CD_PRODUT,
  CB213_VL_TAXA,
  0,
  0,
  0,
  CB213_NR_DDD1,
  CB213_NR_FONE1,
  '',
  CB213_TX_MORA,
  CB213_TX_MULTA,
  CB213_TX_JUROS,
  CB213_TP_FLMORA,
  CB213_TP_FLMULTA,
  CB213_TP_FLJUROS,
  CB213_NR_DIAATR,
  CB213_DS_LOGRAD,
  CB213_DS_LOGRAD,
  CB213_NR_LOGRAD,
  CB213_DS_COMLGR,
  CB213_DS_BAIRRO,
  CB213_DS_BAIRRO,
  CB213_NM_CIDADE,
  CB213_SG_UF,
  CB213_CD_CEP,
  CB213_CD_CEP,
  CB213_TP_END,
  CB213_ID_ERREND,
  CB213_ID_REMISS,
  CB213_NM_CLIENT,
  CB213_NR_DDD1,
  CB213_NR_FONE1,
  CB213_NR_DDD2,
  CB213_NR_FONE2,
  --CONVERT(VARCHAR(3), CB213_NR_DDD1) + '-' + CONVERT(VARCHAR(9), CB213_NR_FONE1) CB213_NR_DDFONE1,
  --CONVERT(VARCHAR(3), CB213_NR_DDD2) + '-' + CONVERT(VARCHAR(9), CB213_NR_FONE2) CB213_NR_DDFONE2,
  CONVERT(VARCHAR(3), CB213_NR_DDD1) + '-' + CONVERT(VARCHAR(9), CB213_NR_FONE1),
  CONVERT(VARCHAR(3), CB213_NR_DDD2) + '-' + CONVERT(VARCHAR(9), CB213_NR_FONE2),
  CB213_DT_NASC,
  CB213_NR_REGION,
  CB213_ID_ENVGRF,
  CB213_DT_ENVGRF,
  CB213_ID_RTNGRF,
  CB213_DT_RTNGRF,
  CB213_ID_RTNCOR,
  CB213_DT_RTNCOR,
  CB213_ID_MTVDEV,
  /*CASE 
    WHEN CB213_ID_MTVDEV = 1 THEN 'Mudou-se'
    WHEN CB213_ID_MTVDEV = 2 THEN 'Endereço insuficiente'
    WHEN CB213_ID_MTVDEV = 3 THEN 'Não existe o numero indicado'
    WHEN CB213_ID_MTVDEV = 4 THEN 'Falecido'
    WHEN CB213_ID_MTVDEV = 5 THEN 'Desconhecido'
    WHEN CB213_ID_MTVDEV = 6 THEN 'Recusado'
    WHEN CB213_ID_MTVDEV = 7 THEN 'Ausente'
    WHEN CB213_ID_MTVDEV = 8 THEN 'Não procurado'
    WHEN CB213_ID_MTVDEV = 9 THEN 'Outros'
    WHEN CB213_ID_MTVDEV = 100 THEN 'Cep invalido'
    WHEN CB213_ID_MTVDEV = 101 THEN 'CEP x Estado inválido'
    WHEN CB213_ID_MTVDEV = 102 THEN 'Dados do endereço faltante'
    ELSE 'Indefinido'
  END CB213_ID_MTVDEV_label,*/
  '',
  CB213_QT_SEGVIA,
  CB213_DT_SOLUC,
  CB213_CD_OPESIS,
  CB213_DT_INCSIS,
  CB213_DT_ATUSIS,

  CB255_DS_PRODR,
  CB255_DS_PRODR

FROM
  CB213

LEFT OUTER JOIN CB255
ON  CB255_NR_OPERADOR = CB213_NR_OPERADOR
AND CB255_NR_CEDENTE  = CB213_NR_CEDENTE
AND CB255_CD_PROD     = CB213_CD_PRODUT