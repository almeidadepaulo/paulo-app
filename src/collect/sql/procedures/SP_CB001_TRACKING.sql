IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB001_TRACKING'))
  DROP PROCEDURE dbo.SP_CB001_TRACKING
GO
CREATE PROCEDURE dbo.SP_CB001_TRACKING
 /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobran�a                                             ::
  :: M�DULO     : Consulta de traking                                          ::
  :: UTILIZ. POR: F03SF03H                                                     ::
  :: OBSERVA��O :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERA��O  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 02/06/2014                                   VERS�O SP:      ::
  :: ALTERA��O  : criada SP igual ao original SP_CB0303010                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 13/10/2010                                   VERS�O SP:    1 ::
  :: ALTERA��O  : Primeira vers�o                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRI��O DA FUNCIONALIDADE:

  Consulta de traking
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5)   ,       /* N�mero da institui��o                   */
  @ENT_CD_EMIEMP NUMERIC(5,0) ,       /* Cod. Emissor/Empresa                    */
  @ENT_CD_PUBLIC NUMERIC(5,0) ,       /* Cod. Publica��o                         */
  @ENT_NR_IDENT1 VARCHAR(20)  ,       /* Identificador1                          */
  @ENT_TP_CHAVE  NUMERIC(3)           /* Tp. Chave                               */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a vers�o do M�dulo � diferente da vers�o da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0303010'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

/*=========================*/
/* DECLARA��O DE VARI�VEIS */
/*=========================*/
DECLARE
  @NR_CPFCNPJ      VARCHAR(14)

CREATE TABLE #TB03010 (
  CB001_NR_INST    NUMERIC(5,0),
  CB050_NM_INST    VARCHAR(60) ,
  CB001_CD_EMIEMP  NUMERIC(5,0),
  CB053_DS_EMIEMP  VARCHAR(40) ,
  CB001_CD_PUBLIC  NUMERIC(5,0),
  CB060_DS_PUBLIC  VARCHAR(40) ,
  CB001_ID_SITUAC  NUMERIC(3)  ,
  CB001_DT_MOVTO   NUMERIC(8)  ,
  CB001_HR_MOVTO   NUMERIC(4)  ,
  CB001_DT_REF     NUMERIC(8)  ,
  CB001_DT_PUBLIC  NUMERIC(8)  ,
  CB001_HR_PUBLIC  NUMERIC(4)  ,
  CB001_DT_FORMAT  NUMERIC(8)  ,
  CB001_HR_FORMAT  NUMERIC(4)  ,
  CB001_DT_ARQUIV  NUMERIC(8)  ,
  CB001_HR_ARQUIV  NUMERIC(4)  ,
  CB001_DT_POST    NUMERIC(8)  ,
  CB001_HR_POST    NUMERIC(4)
)  
  
IF @ENT_TP_CHAVE = 1 /* CPF/CNPJ */
BEGIN
  SELECT
    CB001_NR_INST  ,
    CB050_NM_INST  ,
    CB001_CD_EMIEMP,
    CB053_DS_EMIEMP,
    CB001_CD_PUBLIC,
    CB060_DS_PUBLIC,
    CB001_ID_SITUAC,
    CB001_DT_MOVTO ,
    CASE WHEN LEN(CONVERT(NUMERIC, CB001_HR_MOVTO)) = 4 THEN SUBSTRING(CONVERT(CHAR(4),CB001_HR_MOVTO),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),CB001_HR_MOVTO),3,2)
      WHEN LEN(CONVERT(NUMERIC, CB001_HR_MOVTO)) = 3 THEN '0'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_MOVTO),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_MOVTO),2,2)
	  ELSE '00:00'
	  END CB001_HR_MOVTO ,
    CB001_DT_REF   ,
    CB001_DT_PUBLIC,
    CASE WHEN LEN(CONVERT(NUMERIC, CB001_HR_PUBLIC)) = 4 THEN SUBSTRING(CONVERT(CHAR(4),CB001_HR_PUBLIC),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),CB001_HR_PUBLIC),3,2)
      WHEN LEN(CONVERT(NUMERIC, CB001_HR_PUBLIC)) = 3 THEN '0'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_PUBLIC),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_PUBLIC),2,2)
	  ELSE '00:00'
	  END CB001_HR_PUBLIC,
    CB001_DT_FORMAT,
    CASE WHEN LEN(CONVERT(NUMERIC, CB001_HR_FORMAT)) = 4 THEN SUBSTRING(CONVERT(CHAR(4),CB001_HR_FORMAT),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),CB001_HR_FORMAT),3,2)
      WHEN LEN(CONVERT(NUMERIC, CB001_HR_FORMAT)) = 3 THEN '0'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_FORMAT),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_FORMAT),2,2)
	  ELSE '00:00'
	  END CB001_HR_FORMAT,
    CB001_DT_ARQUIV,
    CASE WHEN LEN(CONVERT(NUMERIC, CB001_HR_ARQUIV)) = 4 THEN SUBSTRING(CONVERT(CHAR(4),CB001_HR_ARQUIV),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),CB001_HR_ARQUIV),3,2)
      WHEN LEN(CONVERT(NUMERIC, CB001_HR_ARQUIV)) = 3 THEN '0'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_ARQUIV),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_ARQUIV),2,2)
	  ELSE '00:00'
	  END CB001_HR_ARQUIV,
    CB001_DT_POST  ,
    CASE WHEN LEN(CONVERT(NUMERIC, CB001_HR_POST)) = 4 THEN SUBSTRING(CONVERT(CHAR(4),CB001_HR_POST),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),CB001_HR_POST),3,2)
      WHEN LEN(CONVERT(NUMERIC, CB001_HR_POST)) = 3 THEN '0'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_POST),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),CB001_HR_POST),2,2)
	  ELSE '00:00'
	  END CB001_HR_POST
  FROM
    CB001,
    CB050,
    CB053,
    CB060
  WHERE
      (@ENT_NR_INST   IS NULL OR CB001_NR_INST   = @ENT_NR_INST)
  AND (@ENT_CD_EMIEMP IS NULL OR CB001_CD_EMIEMP = @ENT_CD_EMIEMP)
  AND (@ENT_CD_PUBLIC IS NULL OR CB001_CD_PUBLIC = @ENT_CD_PUBLIC)
  AND (@ENT_NR_IDENT1 IS NULL OR CONVERT(NUMERIC, CB001_NR_IDENT1) = @ENT_NR_IDENT1)
  /* CB001 -> CB053 */
  AND CB001_NR_INST   = CB050_NR_INST
  /* CB001 -> CB053 */
  AND CB001_NR_INST   = CB053_NR_INST
  AND CB001_CD_EMIEMP = CB053_CD_EMIEMP 
  /* CB001 -> CB060 */
  AND CB001_NR_INST   = CB060_NR_INST
  AND CB001_CD_EMIEMP = CB060_CD_EMIEMP
  AND CB001_CD_PUBLIC = CB060_CD_PUBLIC
END
ELSE
  BEGIN
    /* FAZ A BUSCA DE CPF UTILIZANDO A CHAVE 2 E 3 */
    INSERT INTO #TB03010 (
      CB001_NR_INST  ,
      CB050_NM_INST  ,
      CB001_CD_EMIEMP,
      CB053_DS_EMIEMP,
      CB001_CD_PUBLIC,
      CB060_DS_PUBLIC,
      CB001_ID_SITUAC,
      CB001_DT_MOVTO ,
      CB001_HR_MOVTO ,
      CB001_DT_REF   ,
      CB001_DT_PUBLIC,
      CB001_HR_PUBLIC,
      CB001_DT_FORMAT,
      CB001_HR_FORMAT,
      CB001_DT_ARQUIV,
      CB001_HR_ARQUIV,
      CB001_DT_POST  ,
      CB001_HR_POST  
    )
    SELECT
      CB001_NR_INST  ,
      CB050_NM_INST  ,
      CB001_CD_EMIEMP,
      CB053_DS_EMIEMP,
      CB001_CD_PUBLIC,
      CB060_DS_PUBLIC,
      CB001_ID_SITUAC,
      CB001_DT_MOVTO ,
      CB001_HR_MOVTO ,
      CB001_DT_REF   ,
      CB001_DT_PUBLIC,
      CB001_HR_PUBLIC,
      CB001_DT_FORMAT,
      CB001_HR_FORMAT,
      CB001_DT_ARQUIV,
      CB001_HR_ARQUIV,
      CB001_DT_POST  ,
      CB001_HR_POST
    FROM
      CB001,
      CB050,
      CB053,
      CB060
    WHERE
        (@ENT_NR_INST   IS NULL OR CB001_NR_INST = @ENT_NR_INST)
    AND (@ENT_CD_EMIEMP IS NULL OR CB001_CD_EMIEMP = @ENT_CD_EMIEMP)
    AND (@ENT_CD_PUBLIC IS NULL OR CB001_CD_PUBLIC = @ENT_CD_PUBLIC)
    AND CB001_TP_IDENT2 = @ENT_TP_CHAVE
    AND CB001_NR_IDENT2 = @ENT_NR_IDENT1
    /* CB001 -> CB053 */
    AND CB001_NR_INST   = CB050_NR_INST
    /* CB001 -> CB053 */
    AND CB001_NR_INST   = CB053_NR_INST
    AND CB001_CD_EMIEMP = CB053_CD_EMIEMP
    /* CB001 -> CB060 */
    AND CB001_NR_INST   = CB060_NR_INST
    AND CB001_CD_EMIEMP = CB060_CD_EMIEMP
    AND CB001_CD_PUBLIC = CB060_CD_PUBLIC
    UNION ALL
    SELECT
      CB001_NR_INST  ,
      CB050_NM_INST  ,
      CB001_CD_EMIEMP,
      CB053_DS_EMIEMP,
      CB001_CD_PUBLIC,
      CB060_DS_PUBLIC,
      CB001_ID_SITUAC,
      CB001_DT_MOVTO ,
      CB001_HR_MOVTO,
      CB001_DT_REF   ,
      CB001_DT_PUBLIC,
      CB001_HR_PUBLIC,
      CB001_DT_FORMAT,
      CB001_HR_FORMAT,
      CB001_DT_ARQUIV,
      CB001_HR_ARQUIV,
      CB001_DT_POST  ,
      CB001_HR_POST
    FROM
      CB001,
      CB050,
      CB053,
      CB060
    WHERE
        (@ENT_NR_INST   IS NULL OR CB001_NR_INST = @ENT_NR_INST)
    AND (@ENT_CD_EMIEMP IS NULL OR CB001_CD_EMIEMP = @ENT_CD_EMIEMP)
    AND (@ENT_CD_PUBLIC IS NULL OR CB001_CD_PUBLIC = @ENT_CD_PUBLIC)
    AND CB001_TP_IDENT3 = @ENT_TP_CHAVE
    AND CB001_NR_IDENT3 = @ENT_NR_IDENT1
    /* CB001 -> CB053 */
    AND CB001_NR_INST   = CB050_NR_INST
    /* CB001 -> CB053 */
    AND CB001_NR_INST   = CB053_NR_INST
    AND CB001_CD_EMIEMP = CB053_CD_EMIEMP
    /* CB001 -> CB060 */
    AND CB001_NR_INST   = CB060_NR_INST
    AND CB001_CD_EMIEMP = CB060_CD_EMIEMP
    AND CB001_CD_PUBLIC = CB060_CD_PUBLIC
    
    SELECT 
      *
    FROM
      #TB03010    
  END


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:

  CB001_NR_INST  
  CB050_NM_INST  
  CB001_CD_EMIEMP
  CB053_DS_EMIEMP
  CB001_CD_PUBLIC
  CB060_DS_PUBLIC
  CB001_ID_SITUAC
  CB001_DT_MOVTO 
  CB001_HR_MOVTO 
  CB001_DT_PUBLIC
  CB001_HR_PUBLIC
  CB001_DT_FORMAT
  CB001_HR_FORMAT
  CB001_DT_ARQUIV
  CB001_HR_ARQUIV
  CB001_DT_POST
  CB001_HR_POST
-------------------------------------------------------------------------------*/
GO