 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG002]'))
DROP VIEW [dbo].VW_MG002
GO

-- Criar View da tela - SMS - Pesquisa SMS
CREATE VIEW [dbo].VW_MG002
WITH ENCRYPTION
AS

SELECT
  MG002_NR_PROTOC,
  MG002_NR_CPF   ,
  MG002_NR_INST  ,
  CB050_NM_INST  ,
  MG002_CD_EMIEMP,
  CB053_DS_EMIEMP,
  MG002_NR_BROKER,
  MG002_ID_SITUAC,
  MG002_ID_SITUAC_label = CASE MG002_ID_SITUAC
    WHEN 1 THEN 'Cadastrada'      
    WHEN 2 THEN 'Formatada'      
    WHEN 3 THEN 'Filtrada' 
    WHEN 4 THEN 'Enviada'
    WHEN 5 THEN 'Finalizada'
    WHEN 6 THEN 'Retida'
    WHEN 7 THEN 'Cancelada'
    WHEN 10 THEN 'Acumulada'
  END,
  MG002_CD_CODSMS,
  MG055_DS_CODSMS,
  MG002_NM_TEXTO ,
  MG002_NR_REMESS,
  MG002_DT_REMESS,
  MG002_HR_REMESS,
  MG002_ID_STATUS,
  MG002_ID_STATUS_label = CASE MG002_ID_STATUS
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
  MG002_NR_DDD   ,
  MG002_NR_TEL   ,
  Cast(MG002_NR_DDD AS VARCHAR) + Cast(MG002_NR_TEL AS VARCHAR) AS MG002_NR_DDD_TEL,
  MG002_TP_TEL   
FROM
  MG002 WITH (NOLOCK), 
  MG055 WITH (NOLOCK),
  CB050 WITH (NOLOCK),
  CB053 WITH (NOLOCK)
WHERE
/* MG002 -> CB050 */
    CB050_NR_INST    = MG002_NR_INST 
/* MG002 -> CB053 */  
AND  CB053_NR_INST   = MG002_NR_INST 
AND  CB053_CD_EMIEMP = MG002_CD_EMIEMP
/* MG002 -> MG055 */
AND MG055_NR_INST    = MG002_NR_INST
AND MG055_CD_EMIEMP  = MG002_CD_EMIEMP
AND MG055_CD_CODSMS  = MG002_CD_CODSMS
GO