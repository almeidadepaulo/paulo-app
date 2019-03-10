-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_MG805]'))
DROP VIEW [dbo].[VW_MG805]
GO

-- Cria View da tela SMS - Configurações -  Pacote x Cód. SMS
CREATE VIEW [dbo].[VW_MG805]
WITH ENCRYPTION
AS
SELECT
  MG805_NR_INST,
  MG805_CD_EMIEMP,
  MG805_NR_GERAC,
  MG805_NR_OPERAC,
  MG805_NM_ARQ,
  MG805_DT_PROC,
  MG805_HR_PROC,
  CASE 
    WHEN LEN(CONVERT(NUMERIC, MG805_HR_PROC)) = 4 THEN SUBSTRING(CONVERT(CHAR(4),MG805_HR_PROC),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),MG805_HR_PROC),3,2)
    WHEN LEN(CONVERT(NUMERIC, MG805_HR_PROC)) = 3 THEN '0'+SUBSTRING(CONVERT(CHAR(3),MG805_HR_PROC),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),MG805_HR_PROC),2,2)
    ELSE ''
  END MG805_HR_PROC_LABEL,  
  MG805_ID_STATUS,
  CASE 
    WHEN MG805_ID_STATUS = 0 THEN 'Erro no upload'
    WHEN MG805_ID_STATUS = 1 THEN 'Upload efetuado com sucesso'
    WHEN MG805_ID_STATUS = 2 THEN 'Erro no processamento'
    WHEN MG805_ID_STATUS = 3 THEN 'Arquivo processado com sucesso'
    WHEN MG805_ID_STATUS = 4 THEN 'Arquivo inválido ou fora de formato'
    WHEN MG805_ID_STATUS = 5 THEN 'Problemas na consistência do arquivo'
    WHEN MG805_ID_STATUS = 6 THEN 'Erro na chamada do processamento'
    ELSE ''
  END MG805_ID_STATUS_LABEL,
  MG805_ID_ERRO,
  MG805_CD_OPESIS,
  MG805_DT_INCSIS,
  MG805_DT_ATUSIS,
  CB050_NM_INST,
  CB053_DS_EMIEMP,

  usu_nome
FROM  
  MG805 AS MG805
-- GRUPO
INNER JOIN CB050
ON CB050_NR_INST = MG805_NR_INST
-- CEDENTE
INNER JOIN CB053
ON  CB053_NR_INST = MG805_NR_INST
AND CB053_CD_EMIEMP = MG805_CD_EMIEMP
-- USUÁRIO
INNER JOIN usuario
ON  usu_id = MG805_CD_OPESIS

GO 