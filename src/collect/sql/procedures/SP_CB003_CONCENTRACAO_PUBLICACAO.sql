IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB003_CONCENTRACAO_PUBLICACAO'))
  DROP PROCEDURE dbo.SP_CB003_CONCENTRACAO_PUBLICACAO
GO
CREATE PROCEDURE dbo.SP_CB003_CONCENTRACAO_PUBLICACAO
 /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Concentração por publicação                                  ::
  :: UTILIZ. POR: F03SF03C                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 16/06/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0303003                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 31/03/2010                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Concentração por publicação
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5)   ,       /* Número da instituição                   */
  @ENT_CD_EMIEMP NUMERIC(5,0) ,       /* Cod. Emissor/Empresa                    */
  @ENT_CD_PUBLIC NUMERIC(5,0) ,       /* Cod. Publicação                         */
  @ENT_CD_REGIAO NUMERIC(5,0) ,       /* Cod. Região                             */
  @ENT_DT_INI    NUMERIC(8,0) ,       /* Dt. Movto. Ini.                         */
  @ENT_DT_FIM    NUMERIC(8,0)         /* Dt. Movto. Fim.                         */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0303003'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

SELECT
  CB003_NR_INST  ,
  CB003_CD_EMIEMP,
  CB053_DS_EMIEMP,
  CB003_CD_PUBLIC,
  CB060_DS_PUBLIC,
  CB003_CD_REGIAO,
  CB070_DS_REGIAO,
  CB003_DT_MOVTO ,
  CONVERT(VARCHAR, CONVERT(DATETIME, CONVERT(VARCHAR, CB003_DT_MOVTO)), 103) CB003_DT_MOVTO2,
  CB003_TT_IDENT ,
  CB003_TT_IDECON,
  CB003_TT_OBJETO,
  CB003_TT_OBJCON
FROM
  CB003,
  CB053,
  CB060,
  CB070
WHERE
    (@ENT_NR_INST   IS NULL OR CB003_NR_INST   = @ENT_NR_INST)
AND (@ENT_CD_EMIEMP IS NULL OR CB003_CD_EMIEMP = @ENT_CD_EMIEMP)
AND (@ENT_CD_PUBLIC IS NULL OR CB003_CD_PUBLIC = @ENT_CD_PUBLIC)
AND (@ENT_CD_REGIAO IS NULL OR CB003_CD_REGIAO = @ENT_CD_REGIAO)
AND (@ENT_DT_INI IS NULL OR CB003_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)
/* CB003 - CB053 */
AND CB003_NR_INST   = CB053_NR_INST
AND CB003_CD_EMIEMP = CB053_CD_EMIEMP
/* CB003 - CB060 */
AND CB003_NR_INST   = CB060_NR_INST
AND CB003_CD_EMIEMP = CB060_CD_EMIEMP
AND CB003_CD_PUBLIC = CB060_CD_PUBLIC
/* CB003 - CB070 */
AND CB003_NR_INST   = CB070_NR_INST
AND CB003_CD_REGIAO = CB070_CD_REGIAO


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
    nenhum
-------------------------------------------------------------------------------*/
GO