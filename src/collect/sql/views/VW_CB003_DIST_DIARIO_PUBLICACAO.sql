-- Configura View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_CB003_DIST_DIARIO_PUBLICACAO]'))
DROP VIEW [dbo].[VW_CB003_DIST_DIARIO_PUBLICACAO]
GO

-- PUBLISH - Publicações -  Distribuição por publicação diária 
-- Cria View
CREATE VIEW [dbo].[VW_CB003_DIST_DIARIO_PUBLICACAO]
WITH ENCRYPTION
AS

SELECT
  CB003_NR_INST,
  CB003_CD_EMIEMP,
  CB053_DS_EMIEMP,
  CB003_CD_PUBLIC,
  CB060_DS_PUBLIC,
  CB003_DT_MOVTO,
  SUM(CB003_TT_OBJETO) CB003_TT_OBJETO,
  SUM(CB003_TT_CONTRA) CB003_TT_CONTRA,
  SUM(CB003_TT_CUSPUB)  CB003_TT_CUSPUB,
  SUM(CB003_TT_CUSCAP) CB003_TT_CUSCAP,
  SUM(CB003_TT_CUSINS)  CB003_TT_CUSINS,
  SUM(CB003_TT_CUSPOS) CB003_TT_CUSPOS,
  SUM((CB003_TT_CUSPUB) + (CB003_TT_CUSPOS) + (CB003_TT_CUSCAP) + (CB003_TT_CUSINS)) CB003_VL_TOT
FROM
  CB003,
  CB060,
  CB053
WHERE
--    (@ENT_NR_INST   IS NULL OR CB003_NR_INST   = @ENT_NR_INST)
--AND (@ENT_CD_EMIEMP IS NULL OR CB003_CD_EMIEMP = @ENT_CD_EMIEMP)
--AND (@ENT_DT_INI IS NULL OR CB003_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)  
/* CB003 -> CB060 */
CB003_NR_INST   = CB060_NR_INST
AND CB003_CD_EMIEMP = CB060_CD_EMIEMP
AND CB003_CD_PUBLIC = CB060_CD_PUBLIC
/* CB003 -> CB053 */
AND CB003_NR_INST   = CB053_NR_INST
AND CB003_CD_EMIEMP = CB053_CD_EMIEMP
GROUP BY 
  CB003_NR_INST,
  CB003_CD_EMIEMP,
  CB053_DS_EMIEMP,
  CB003_CD_PUBLIC,
  CB060_DS_PUBLIC,
  CB003_DT_MOVTO
/*
ORDER BY
  CB003_DT_MOVTO,
  CB003_CD_PUBLIC
*/

	
GO

