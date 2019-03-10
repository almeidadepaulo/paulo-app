IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_MG003_RESUMO_MENSAGEM'))
  DROP PROCEDURE dbo.SP_MG003_RESUMO_MENSAGEM
GO
CREATE PROCEDURE dbo.SP_MG003_RESUMO_MENSAGEM
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Resumo de menssagem                                          ::
  :: UTILIZ. POR: F03SF21A                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 02/06/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0321001                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 06/02/2012                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Resumo de menssagem
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5,0) ,       /* Nr. instituição                         */
  @ENT_CD_EMIEMP NUMERIC(5,0) ,       /* Nr. emissor/empresa                     */
  @ENT_NR_BROKER NUMERIC(5,0) ,       /* Nr. broker                              */
  @ENT_DT_INI    NUMERIC(8,0) ,       /* Dt. Movto. Ini.                         */
  @ENT_DT_FIM    NUMERIC(8,0) ,       /* Dt. Movto. Fim.                         */
  @ENT_DT_MES    NUMERIC(6)           /* Mês de referencia                       */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0321001'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

IF @ENT_DT_MES = 1
BEGIN
  /* RESULT SET */ 
  SELECT
    MG003_DT_MOVTO ,
    SUM(MG003_TT_MENSO) MG003_TT_MENSO,
    SUM(MG003_TT_MENSN) MG003_TT_MENSN,
    (SUM(MG003_TT_MENSO) + SUM(MG003_TT_MENSN)) MG003_TT_MENS,
    (SUM(MG003_TT_MENSO) + SUM(MG003_TT_MENSN)) * SUM(MG051_VL_CUSTO) MG003_VL_VALOR
  FROM
    MG003,
    MG051
  WHERE
      (@ENT_NR_INST   IS NULL OR MG003_NR_INST   = @ENT_NR_INST)
  AND (@ENT_CD_EMIEMP IS NULL OR MG003_CD_EMIEMP = @ENT_CD_EMIEMP)
  AND (@ENT_NR_BROKER IS NULL OR MG003_NR_BROKER = @ENT_NR_BROKER)
  AND (@ENT_DT_INI    IS NULL OR MG003_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)    
  /* MG003 -> MG051 */
  AND MG003_NR_INST   = MG051_NR_INST
  AND MG003_NR_BROKER = MG051_NR_BROKER
  AND MG051_ID_ATIVO = 1 /* ATIVO */
  GROUP BY 
    MG003_DT_MOVTO
  ORDER BY
    MG003_DT_MOVTO 
END
ELSE
  BEGIN
    /* RESULT SET */ 
    SELECT
      FLOOR(MG003_DT_MOVTO / 100) MG003_DT_MOVTO2,
	    SUBSTRING(CONVERT(VARCHAR, FLOOR(MG003_DT_MOVTO / 100)), 5, 2) MG003_DT_MES,
      FLOOR(MG003_DT_MOVTO / 10000) MG003_DT_ANO,
      SUM(MG003_TT_MENSO) MG003_TT_MENSO,
      SUM(MG003_TT_MENSN) MG003_TT_MENSN,
      (SUM(MG003_TT_MENSO) + SUM(MG003_TT_MENSN)) MG003_TT_MENS,
      (SUM(MG003_TT_MENSO) + SUM(MG003_TT_MENSN)) * SUM(MG051_VL_CUSTO) MG003_VL_VALOR
    FROM
      MG003,
      MG051
    WHERE
        (@ENT_NR_INST   IS NULL OR MG003_NR_INST   = @ENT_NR_INST)
    AND (@ENT_CD_EMIEMP IS NULL OR MG003_CD_EMIEMP = @ENT_CD_EMIEMP)
    AND (@ENT_NR_BROKER IS NULL OR MG003_NR_BROKER = @ENT_NR_BROKER)
    AND (@ENT_DT_MES    IS NULL OR FLOOR(MG003_DT_MOVTO / 100) = @ENT_DT_MES)    
    /* MG003 -> MG051 */
    AND MG003_NR_INST   = MG051_NR_INST
    AND MG003_NR_BROKER = MG051_NR_BROKER
    AND MG051_ID_ATIVO = 1 /* ATIVO */      
    GROUP BY 
      FLOOR(MG003_DT_MOVTO / 100),
      SUBSTRING(CONVERT(VARCHAR, FLOOR(MG003_DT_MOVTO / 100)), 5, 2),
      FLOOR(MG003_DT_MOVTO / 10000)
    ORDER BY
      FLOOR(MG003_DT_MOVTO / 100),
      SUBSTRING(CONVERT(VARCHAR, FLOOR(MG003_DT_MOVTO / 100)), 5, 2),
      FLOOR(MG003_DT_MOVTO / 10000)
  END


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:


-------------------------------------------------------------------------------*/
GO