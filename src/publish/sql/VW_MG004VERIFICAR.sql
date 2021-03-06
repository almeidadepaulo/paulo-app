 -- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG004]'))
DROP VIEW [dbo].VW_MG004
GO

-- Criar View da tela - SMS - Resumo de msg por CPF
CREATE VIEW [dbo].VW_MG004
WITH ENCRYPTION
AS

SELECT
  MG004_NR_INST  ,
  CB050_NM_INST  ,
  MG004_CD_EMIEMP,
  CB053_DS_EMIEMP,
  MG004_NR_BROKER,
  MG050_NM_BROKER,
  MG004_NR_CPF   ,
  MG004_DT_MOVTO ,
  SUM(MG004_TT_MENSO) MG004_TT_MENSO,
  SUM(MG004_TT_MENSN) MG004_TT_MENSN,
  (SUM(MG004_TT_MENSO) + SUM(MG004_TT_MENSN)) MG004_TT_MENS
FROM
  MG004,
  CB050,
  CB053,
  MG050
WHERE
/* MG004 -> MG050 */
    MG004_NR_INST   = CB050_NR_INST
/* MG004 -> MG053 */
AND MG004_NR_INST   = CB053_NR_INST
AND MG004_CD_EMIEMP = CB053_CD_EMIEMP
/* MG004 -> MG050 */
AND MG004_NR_INST   = MG050_NR_OPERADOR
AND MG004_NR_BROKER = MG050_NR_BROKER
GROUP BY 
  MG004_NR_INST  ,
  CB050_NM_INST  ,
  MG004_CD_EMIEMP,
  CB053_DS_EMIEMP,
  MG004_NR_BROKER,
  MG050_NM_BROKER,
  MG004_NR_CPF   ,
  MG004_DT_MOVTO 
GO