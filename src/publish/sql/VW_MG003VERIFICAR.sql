 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG003]'))
DROP VIEW [dbo].VW_MG003
GO

-- Criar View da tela - SMS - Resumo de msg
CREATE VIEW [dbo].VW_MG003
WITH ENCRYPTION
AS

SELECT
  MG003_NR_INST  ,
  CB050_NM_INST  ,
  MG003_CD_EMIEMP,
  CB053_DS_EMIEMP,
  MG003_NR_BROKER,
  MG050_NM_BROKER,
  MG003_DT_MOVTO ,
  SUM(MG003_TT_MENSO) MG003_TT_MENSO,
  SUM(MG003_TT_MENSN) MG003_TT_MENSN,
  (SUM(MG003_TT_MENSO) + SUM(MG003_TT_MENSN)) MG003_TT_MENS,
  (SUM(MG003_TT_MENSO) + SUM(MG003_TT_MENSN)) * SUM(MG051_VL_CUSTO) MG003_VL_VALOR
FROM
  MG003,
  CB050,
  CB053,
  MG050,
  MG051
WHERE
/* MG003 -> MG050 */
    MG003_NR_INST   = CB050_NR_INST
/* MG003 -> MG053 */
AND MG003_NR_INST   = CB053_NR_INST
AND MG003_CD_EMIEMP = CB053_CD_EMIEMP
/* MG003 -> MG050 */
AND MG003_NR_INST   = MG051_NR_OPERADOR
AND MG003_NR_BROKER = MG050_NR_BROKER
/* MG003 -> MG051 */
AND MG003_NR_INST   = MG051_NR_OPERADOR
AND MG003_NR_BROKER = MG051_NR_BROKER
AND MG051_ID_ATIVO  = 1 /* ATIVO */
GROUP BY 
  MG003_NR_INST  ,
  CB050_NM_INST  ,
  MG003_CD_EMIEMP,
  CB053_DS_EMIEMP,
  MG003_NR_BROKER,
  MG050_NM_BROKER,
  MG003_DT_MOVTO 

GO