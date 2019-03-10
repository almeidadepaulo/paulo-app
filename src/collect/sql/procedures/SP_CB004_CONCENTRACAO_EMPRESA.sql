IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB004_CONCENTRACAO_EMPRESA'))
  DROP PROCEDURE dbo.SP_CB004_CONCENTRACAO_EMPRESA
GO
CREATE PROCEDURE dbo.SP_CB004_CONCENTRACAO_EMPRESA
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Concentração por empresa                                     ::
  :: UTILIZ. POR: F03SF03D                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 16/06/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0303004                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 31/03/2010                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Concentração por empresa
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5)   ,       /* Número da instituição                   */
  @ENT_CD_EMIEMP NUMERIC(5,0) ,       /* Cod. Emissor/Empresa                    */
  @ENT_DT_INI    NUMERIC(8,0) ,       /* Dt. Movto. Ini.                         */
  @ENT_DT_FIM    NUMERIC(8,0)         /* Dt. Movto. Fim.                         */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0303004'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

SELECT
  CB004_NR_INST  ,
  CB004_CD_EMIEMP,
  CB053_DS_EMIEMP,
  CB004_DT_MOVTO ,
  CONVERT(VARCHAR, CONVERT(DATETIME, CONVERT(VARCHAR, CB004_DT_MOVTO)), 103) CB004_DT_MOVTO2,
  CB004_TT_IDENT ,
  CB004_TT_IDECON,
  CB004_TT_OBJETO,
  CB004_TT_OBJCON
FROM
  CB004,
  CB053
WHERE
    (@ENT_NR_INST   IS NULL OR CB004_NR_INST   = @ENT_NR_INST)
AND (@ENT_CD_EMIEMP IS NULL OR CB004_CD_EMIEMP = @ENT_CD_EMIEMP)
AND (@ENT_DT_INI IS NULL OR CB004_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)
/* CB003 - CB053 */
AND CB004_NR_INST   = CB053_NR_INST
AND CB004_CD_EMIEMP = CB053_CD_EMIEMP

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
    nenhum
-------------------------------------------------------------------------------*/
GO