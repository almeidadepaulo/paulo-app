-- Configurar View
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apagar view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_perfil]'))
DROP VIEW [dbo].[vw_perfil]
GO

-- Criar View
CREATE VIEW [dbo].[vw_perfil]
WITH ENCRYPTION
AS
    SELECT
    
    perfil.per_id,
    perfil.per_master,
    perfil.per_ativo,
    per_ativo_label = CASE per_ativo
        WHEN 1 THEN 'Ativo'
        ELSE 'Inativo'
    END,
    perfil.per_nome,
    perfil.per_developer,
    perfil.per_resetarSenha,
    perfil.grupo_id,
    perfil.grupo_id as company,
    perfil.per_restrito,
    perfil.per_tipo,

    CB050.CB050_NR_INST, 
    CB050.CB050_NM_INST,
    CB050.CB050_NR_NM_INST,

    CB050.CB050_NR_INST as perfil_CD_GRUPO,
    CB050.CB050_NM_INST as perfil_NM_GRUPO

    FROM perfil AS perfil

    INNER JOIN VW_CB050 AS CB050
    ON perfil.grupo_id = CB050.CB050_NR_INST

GO