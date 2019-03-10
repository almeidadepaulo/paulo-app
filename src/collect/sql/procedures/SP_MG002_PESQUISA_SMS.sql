IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_MG002_PESQUISA_SMS'))
  DROP PROCEDURE dbo.SP_MG002_PESQUISA_SMS
GO
CREATE PROCEDURE dbo.SP_MG002_PESQUISA_SMS
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Pesquisa SMS                                                 ::
  :: UTILIZ. POR: F03SF21C                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 03/06/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0321003                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 06/02/2012                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Resumo de menssagem por cpf
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS     VARCHAR(4)   ,      /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST    NUMERIC(5,0) ,      /* Nr. instituição                         */
  @ENT_CD_EMIEMP  NUMERIC(5,0) ,      /* Nr. emissor/empresa                     */
  @ENT_NR_BROKER  NUMERIC(5,0) ,      /* Nr. broker                              */
  @ENT_NR_CPFCNPJ VARCHAR(11)  ,      /* CPF                                     */
  @ENT_DT_INI     NUMERIC(8,0) ,      /* Dt. Movto. Ini.                         */
  @ENT_DT_FIM     NUMERIC(8,0)        /* Dt. Movto. Fim.                         */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0321003'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

SELECT
  MG002_ID_SITUAC,
  MG002_CD_CODSMS,
  MG055_DS_CODSMS,
  MG002_NM_TEXTO ,
  MG002_NR_REMESS,
  MG002_DT_REMESS,
  MG002_HR_REMESS,
  MG002_ID_STATUS,
  MG002_NR_DDD   ,
  MG002_NR_TEL   ,
  MG002_TP_TEL   ,
  MG002_NR_CPF
FROM
  MG002,
  MG055
WHERE
    (@ENT_NR_INST    IS NULL OR MG002_NR_INST   = @ENT_NR_INST)
AND (@ENT_CD_EMIEMP  IS NULL OR MG002_CD_EMIEMP = @ENT_CD_EMIEMP)
AND (@ENT_NR_BROKER  IS NULL OR MG002_NR_BROKER = @ENT_NR_BROKER)
AND (@ENT_NR_CPFCNPJ IS NULL OR MG002_NR_CPF    = @ENT_NR_CPFCNPJ)
AND (@ENT_DT_INI     IS NULL OR MG002_DT_REMESS BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)    
/* MG002 -> MG055 */
AND MG055_NR_INST   = MG002_NR_INST
AND MG055_CD_EMIEMP = MG002_CD_EMIEMP
AND MG055_CD_CODSMS = MG002_CD_CODSMS
ORDER BY  MG002_DT_REMESS

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:


-------------------------------------------------------------------------------*/
GO