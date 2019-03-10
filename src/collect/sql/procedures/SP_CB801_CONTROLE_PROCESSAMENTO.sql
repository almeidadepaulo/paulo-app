IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB801_CONTROLE_PROCESSAMENTO'))
  DROP PROCEDURE dbo.SP_CB801_CONTROLE_PROCESSAMENTO
GO
CREATE PROCEDURE dbo.SP_CB801_CONTROLE_PROCESSAMENTO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobran�a                                             ::
  :: M�DULO     : Controle de processamento                                    ::
  :: UTILIZ. POR: F03SF03E                                                     ::
  :: OBSERVA��O :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERA��O  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 30/05/2014                                   VERS�O SP:      ::
  :: ALTERA��O  : criada SP igual ao original SP_CB0303005                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 31/03/2010                                   VERS�O SP:    1 ::
  :: ALTERA��O  : Primeira vers�o                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRI��O DA FUNCIONALIDADE:

  Controle de processamento
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5)   ,       /* Nr. inst.                               */
  @ENT_CD_EMIEMP NUMERIC(5)   ,       /* Cod. Emissor/Empresa                    */
  @ENT_CD_PUBLIC NUMERIC(5)   ,       /* Cod. Publica��o                         */
  @ENT_DT_INI    NUMERIC(8,0) ,       /* Dt. Movto. Ini.                         */
  @ENT_DT_FIM    NUMERIC(8,0)         /* Dt. Movto. Fim.                         */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a vers�o do M�dulo � diferente da vers�o da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0303005'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

SELECT
  CB801_NR_INST  ,
  CB050_NM_INST  ,
  CB801_CD_EMIEMP,
  CB053_DS_EMIEMP,
  CB801_CD_PUBLIC,
  CB060_DS_PUBLIC,
  CB801_NR_SELO  ,
  CB801_DT_MOVTO ,
  CB801_QT_REG   ,
  CB801_ID_SITUAC,
  CASE
  WHEN CB801_ID_SITUAC = '1' THEN 'Incluído'
  WHEN CB801_ID_SITUAC = '9' THEN 'Cancelado'
  ELSE 'Indefinido'
  END CB801_ID_SITUAC_L,
  
  CONVERT(CHAR(10),CB801_DT_INCSIS,108) CB801_DT_INCSIS
FROM
  CB801,
  CB050,
  CB053,
  CB060
WHERE
    (@ENT_NR_INST   IS NULL OR CB801_NR_INST   = @ENT_NR_INST)
AND (@ENT_CD_EMIEMP IS NULL OR CB801_CD_EMIEMP = @ENT_CD_EMIEMP)
AND (@ENT_CD_PUBLIC IS NULL OR CB801_CD_PUBLIC = @ENT_CD_PUBLIC)
AND (@ENT_DT_INI    IS NULL OR CB801_DT_MOVTO BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)
/* CB801 -> CB050 */
AND CB801_NR_INST = CB050_NR_INST
/* CB801 -> CB053 */
AND CB801_NR_INST   = CB053_NR_INST
AND CB801_CD_EMIEMP = CB053_CD_EMIEMP
/* CB801 -> CB060 */
AND CB801_NR_INST   = CB060_NR_INST
AND CB801_CD_EMIEMP = CB060_CD_EMIEMP
AND CB801_CD_PUBLIC = CB060_CD_PUBLIC

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
    nenhum
-------------------------------------------------------------------------------*/
GO