IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB002_POSICAO_PROCESSAMENTO'))
  DROP PROCEDURE dbo.SP_CB002_POSICAO_PROCESSAMENTO
GO
CREATE PROCEDURE dbo.SP_CB002_POSICAO_PROCESSAMENTO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Posição de processamento                                     ::
  :: UTILIZ. POR: F03SF03B                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 29/05/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0305017                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 31/03/2010                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Posição de processamento
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
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0303002'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

SELECT
  CB002_NR_INST  ,
  CB002_CD_EMIEMP,
  CB053_DS_EMIEMP,
  CB002_CD_PUBLIC,
  CB060_DS_PUBLIC,
  CB002_CD_REGIAO,
  CB070_DS_REGIAO,
  CB002_DT_MOVTO ,
  CB002_NR_PROTOC,
  CB002_TT_POST  ,
  CB002_TT_ARQUIV,
  CB002_TT_CUPOST,
  CB002_TT_CUPUBL
FROM
  CB002,
  CB053,
  CB060,
  CB070
WHERE
    (@ENT_NR_INST   IS NULL OR CB002_NR_INST   = @ENT_NR_INST)
AND (@ENT_CD_EMIEMP IS NULL OR CB002_CD_EMIEMP = @ENT_CD_EMIEMP)
AND (@ENT_CD_PUBLIC IS NULL OR CB002_CD_PUBLIC = @ENT_CD_PUBLIC)
AND (@ENT_CD_REGIAO IS NULL OR CB002_CD_REGIAO = @ENT_CD_REGIAO)
AND (@ENT_DT_INI IS NULL OR CB002_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)
/* CB002 - CB053 */
AND CB002_NR_INST   = CB053_NR_INST
AND CB002_CD_EMIEMP = CB053_CD_EMIEMP
/* CB002 - CB060 */
AND CB002_NR_INST   = CB060_NR_INST
AND CB002_CD_EMIEMP = CB060_CD_EMIEMP
AND CB002_CD_PUBLIC = CB060_CD_PUBLIC
/* CB002 - CB070 */
AND CB002_NR_INST   = CB070_NR_INST
AND CB002_CD_REGIAO = CB070_CD_REGIAO


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
    nenhum
-------------------------------------------------------------------------------*/
GO