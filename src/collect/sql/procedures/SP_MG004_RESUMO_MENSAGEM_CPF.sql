IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_MG004_RESUMO_MENSAGEM_CPF'))
  DROP PROCEDURE dbo.SP_MG004_RESUMO_MENSAGEM_CPF
GO
CREATE PROCEDURE dbo.SP_MG004_RESUMO_MENSAGEM_CPF
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Resumo de menssagem por cpf                                  ::
  :: UTILIZ. POR: F03SF21B                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 02/06/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0321002                     ::
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
  @ENT_DT_FIM     NUMERIC(8,0) ,      /* Dt. Movto. Fim.                         */
  @ENT_DT_MES     NUMERIC(6)          /* Mês de referencia                       */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0321002'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

IF @ENT_DT_MES = 1
BEGIN
  /* RESULT SET */ 
  SELECT
    MG004_NR_CPF   ,
    MG004_DT_MOVTO ,
    SUM(MG004_TT_MENSO) MG004_TT_MENSO,
    SUM(MG004_TT_MENSN) MG004_TT_MENSN,
    (SUM(MG004_TT_MENSO) + SUM(MG004_TT_MENSN)) MG004_TT_MENS
  FROM
    MG004
  WHERE
      (@ENT_NR_INST    IS NULL OR MG004_NR_INST   = @ENT_NR_INST)
  AND (@ENT_CD_EMIEMP  IS NULL OR MG004_CD_EMIEMP = @ENT_CD_EMIEMP)
  AND (@ENT_NR_BROKER  IS NULL OR MG004_NR_BROKER = @ENT_NR_BROKER)
  AND (@ENT_NR_CPFCNPJ IS NULL OR MG004_NR_CPF    = @ENT_NR_CPFCNPJ)
  AND (@ENT_DT_INI     IS NULL OR MG004_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)    
  GROUP BY 
    MG004_NR_CPF  ,
    MG004_DT_MOVTO
  ORDER BY
    MG004_NR_CPF  ,
    MG004_DT_MOVTO 
END
ELSE
  BEGIN
    /* RESULT SET */ 
    SELECT
      MG004_NR_CPF,
      FLOOR(MG004_DT_MOVTO / 100) MG004_DT_MOVTO2,
	    SUBSTRING(CONVERT(VARCHAR, FLOOR(MG004_DT_MOVTO / 100)), 5, 2) MG004_DT_MES,
      FLOOR(MG004_DT_MOVTO / 10000) MG004_DT_ANO,
      SUM(MG004_TT_MENSO) MG004_TT_MENSO,
      SUM(MG004_TT_MENSN) MG004_TT_MENSN,
      (SUM(MG004_TT_MENSO) + SUM(MG004_TT_MENSN)) MG004_TT_MENS
    FROM
      MG004
    WHERE
        (@ENT_NR_INST    IS NULL OR MG004_NR_INST   = @ENT_NR_INST)
    AND (@ENT_CD_EMIEMP  IS NULL OR MG004_CD_EMIEMP = @ENT_CD_EMIEMP)
    AND (@ENT_NR_BROKER  IS NULL OR MG004_NR_BROKER = @ENT_NR_BROKER)
    AND (@ENT_NR_CPFCNPJ IS NULL OR MG004_NR_CPF    = @ENT_NR_CPFCNPJ)
    AND (@ENT_DT_MES     IS NULL OR FLOOR(MG004_DT_MOVTO / 100) = @ENT_DT_MES)    
    GROUP BY 
      MG004_NR_CPF,
      FLOOR(MG004_DT_MOVTO / 100),
      SUBSTRING(CONVERT(VARCHAR, FLOOR(MG004_DT_MOVTO / 100)), 5, 2),
      FLOOR(MG004_DT_MOVTO / 10000)
    ORDER BY
      MG004_NR_CPF,
      FLOOR(MG004_DT_MOVTO / 100),
      SUBSTRING(CONVERT(VARCHAR, FLOOR(MG004_DT_MOVTO / 100)), 5, 2),
      FLOOR(MG004_DT_MOVTO / 10000)
  END


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:


-------------------------------------------------------------------------------*/
GO