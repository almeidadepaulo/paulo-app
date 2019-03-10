-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_perfil_cedente]'))
DROP VIEW [dbo].[vw_perfil_cedente]
GO

-- Cria View
CREATE VIEW [dbo].[vw_perfil_cedente]
--WITH ENCRYPTION
AS
  SELECT 
  
  
  perfil_cedente.per_id,
  perfil_cedente.grupo_id,
  perfil_cedente.grupo_id as ins_id,  
  perfil_cedente.cedente_id,

  CB050.CB050_NM_INST as ins_nome,
  CB050.CB050_NM_INST as grupo_nome,
  
  CB053.CB053_DS_EMIEMP as cedente_nome
  
  --CB053.CB053_DS_EMIEMR as ins_nome_resumido,
  
  --Cast(grupo_id as varchar)+' - '+CB053_DS_EMIEMP as ins_id_nome
 
        
FROM dbo.perfil_cedente AS perfil_cedente

INNER JOIN CB050 AS CB050
ON 	CB050.CB050_NR_INST 	= perfil_cedente.grupo_id

INNER JOIN CB053 AS CB053
ON 	CB053.CB053_NR_INST 	= perfil_cedente.grupo_id
AND CB053.CB053_CD_EMIEMP 	= perfil_cedente.cedente_id

GO


