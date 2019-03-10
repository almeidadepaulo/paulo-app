 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_EM002]'))
DROP VIEW [dbo].VW_EM002
GO

-- Criar View da tela - EMAIL - Pesquisa EMAIL
CREATE VIEW [dbo].VW_EM002
WITH ENCRYPTION
AS

SELECT
  EM002_NR_PROTOC,  
  EM002_NR_CPF   ,
  EM002_NR_INST  ,
  CB050_NM_INST  ,
  EM002_CD_EMIEMP,
  CB053_DS_EMIEMP,
  EM002_NR_BROKER,
  EM002_ID_ORIG,
  EM002_ID_SITUAC,
  EM002_ID_SITUAC_label = CASE EM002_ID_SITUAC
    WHEN 1 THEN 'Cadastrada'      
    WHEN 2 THEN 'Formatada'      
    WHEN 3 THEN 'Filtrada' 
    WHEN 4 THEN 'Enviada'
    WHEN 5 THEN 'Finalizada'
    WHEN 6 THEN 'Retida'
    WHEN 7 THEN 'Cancelada'
    WHEN 10 THEN 'Acumulada'
  END,
  EM002_CD_CODEMAIL,
  EM002_DS_EMAIL,
  EM002_NM_TEXTO ,
  EM002_NR_REMESS,
  EM002_DT_REMESS,
  EM002_HR_REMESS,
  EM002_ID_STATUS,
  EM002_ID_STATUS_label = CASE EM002_ID_STATUS
    WHEN 'OK' THEN 'Mensagem recebida, na fila para envio à operadora'
    WHEN 'OP' THEN 'Mensagem enviada à operadora'
    WHEN 'CL' THEN 'Celular confirmou o recebimento'
    WHEN 'ER' THEN 'Erro de processamento'
    WHEN 'E0' THEN 'Celular não pertence a nenhuma operadora'
    WHEN 'E4' THEN 'Mensagem rejeitada pela operadora antes de transmitir. (Número cancelado ou com restrições)'
    WHEN 'E6' THEN 'Mensagem expirada conforme informação da operadora (expirada após sequencia de tentativas)'
    WHEN 'E7' THEN 'Mensagem rejeitada por falta de crédito'
    WHEN 'B1' THEN 'Black List'
    WHEN 'MI' THEN 'Mensagem inativa'
    WHEN 'QR' THEN 'Quarentena'
    WHEN 'PC' THEN 'Percentual'
  END,
  EM002_NR_DDD   ,
  EM002_NR_TEL   ,
  Cast(EM002_NR_DDD AS VARCHAR) + Cast(EM002_NR_TEL AS VARCHAR) AS EM002_NR_DDD_TEL,
  EM002_TP_TEL  ,
  EM002_NM_ANEXO,
  EM002_ID_IMG  ,
  EM055_DS_CODEMAIL,
  CB850_IM_PDF
FROM
  EM002 WITH (NOLOCK)

INNER JOIN CB050 WITH (NOLOCK)
ON CB050_NR_INST    = EM002_NR_INST 

INNER JOIN CB053 WITH (NOLOCK)
ON CB053_NR_INST   = EM002_NR_INST 
AND  CB053_CD_EMIEMP = EM002_CD_EMIEMP

INNER JOIN EM055 WITH (NOLOCK)
ON EM055_NR_INST    = EM002_NR_INST
AND EM055_CD_EMIEMP  = EM002_CD_EMIEMP
AND EM055_CD_CODEMAIL  = EM002_CD_CODEMAIL

LEFT OUTER JOIN CB850
ON CB850_NR_PROTOC = EM002_ID_IMG

GO