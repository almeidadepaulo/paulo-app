
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB001_PESQUISA'))
  DROP PROCEDURE dbo.SP_CB001_PESQUISA
GO
CREATE PROCEDURE dbo.SP_CB001_PESQUISA
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Pesquisa                                                     ::
  :: UTILIZ. POR: F03SF05T                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Rodrigo Vieira                                               ::
  :: DATA       : 16/06/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0305020                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 10/05/2010                                   VERS�O SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Consulta pesquisa
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5)   ,       /* Número da instituição                   */
  @ENT_NR_IDENT1 VARCHAR(20)  ,       /* Identificador1                          */
  @ENT_TP_CHAVE  NUMERIC(3)           /* Tp. Chave                               */
/*
  @ENT_NR_IDENT2 VARCHAR(20)  ,       /* Identificador2                          */
  @ENT_NR_IDENT3 VARCHAR(20)          /* Identificador3                          */
*/
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB001_PESQUISA'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

/*=========================*/
/* DECLARA��O DE VARI�VEIS */
/*=========================*/
DECLARE
  @NR_CPFCNPJ      VARCHAR(14),
  @NR_QTDE         NUMERIC(5) 
  
CREATE TABLE #TB03001 (
  CB001_NR_PROTOC CHAR(30)   ,
  CB001_NR_IDENT1 VARCHAR(20),
  CB001_NR_IDENT2 VARCHAR(20),
  CB001_NR_IDENT3 VARCHAR(20),
  CB001_DT_REF    NUMERIC(8) ,
  CB001_CD_PUBLIC NUMERIC(5) ,
  CB060_DS_PUBLIC VARCHAR(40),
  CB060_TP_DOC    NUMERIC(3)
)  

IF @ENT_TP_CHAVE = 1 /* CPF/CNPJ */
BEGIN
  SELECT
    CB001_NR_PROTOC,
    CASE 
      WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 9  THEN '00' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
      WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 10 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
      WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 11 THEN CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
      WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 13 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
      ELSE CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
    END CB001_NR_IDENT1,
    CB001_NR_IDENT2,
    CB001_NR_IDENT3,
    CB001_DT_REF   ,
    CB001_CD_PUBLIC,
    CB060_DS_PUBLIC,
    CASE 
      WHEN CB060_TP_DOC = 1 THEN 'Desmonstrativo'
	  ELSE 'Cobrança'
    END CB060_TP_DOC
  FROM
    CB001,
    CB850,
    CB060
  WHERE
      (@ENT_NR_INST   IS NULL OR CB001_NR_INST   = @ENT_NR_INST)
  AND (@ENT_NR_IDENT1 IS NULL OR CONVERT(NUMERIC, CB001_NR_IDENT1) = @ENT_NR_IDENT1)
  /* CB001 -> CB850 */
  AND CB001_NR_PROTOC = CB850_NR_PROTOC
  /* CB001 -> CB060 */
  AND CB001_NR_INST   = CB060_NR_INST
  AND CB001_CD_EMIEMP = CB060_CD_EMIEMP
  AND CB001_CD_PUBLIC = CB060_CD_PUBLIC
  AND CB001_ID_SITUAC <> 90 /* n�o traz lote cancelado */
END
ELSE
  BEGIN
    /* FAZ A BUSCA DE CPF UTILIZANDO A CHAVE 2 E 3 */
    INSERT INTO #TB03001 (
      CB001_NR_PROTOC,
      CB001_NR_IDENT1,
      CB001_NR_IDENT2,
      CB001_NR_IDENT3,
      CB001_DT_REF   ,
      CB001_CD_PUBLIC,
      CB060_DS_PUBLIC,
      CB060_TP_DOC   
    )
    SELECT
      CB001_NR_PROTOC,
      CASE 
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 9  THEN '00' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 10 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 11 THEN CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 13 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        ELSE CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
      END CB001_NR_IDENT1,
      CB001_NR_IDENT2,
      CB001_NR_IDENT3,
      CB001_DT_REF   ,
      CB001_CD_PUBLIC,
      CB060_DS_PUBLIC,
      CB060_TP_DOC
    FROM
      CB001,
      CB850,
      CB060
    WHERE
        CB001_NR_INST   = @ENT_NR_INST
    AND CB001_TP_IDENT2 = @ENT_TP_CHAVE
    AND CB001_NR_IDENT2 = @ENT_NR_IDENT1 /* NOSSO NUMERO */
    /* CB001 -> CB850 */
    AND CB001_NR_PROTOC = CB850_NR_PROTOC
    /* CB001 -> CB060 */
    AND CB001_NR_INST   = CB060_NR_INST
    AND CB001_CD_EMIEMP = CB060_CD_EMIEMP
    AND CB001_CD_PUBLIC = CB060_CD_PUBLIC
    AND CB001_ID_SITUAC <> 90 /* n�o traz lote cancelado */
    UNION ALL
    SELECT
      CB001_NR_PROTOC,
      CASE 
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 9  THEN '00' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 10 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 11 THEN CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        WHEN LEN(CONVERT(NUMERIC, CB001_NR_IDENT1)) = 13 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
        ELSE CONVERT(VARCHAR, CONVERT(NUMERIC, CB001_NR_IDENT1))
      END CB001_NR_IDENT1,
      CB001_NR_IDENT2,
      CB001_NR_IDENT3,
      CB001_DT_REF   ,
      CB001_CD_PUBLIC,
      CB060_DS_PUBLIC,
      CB060_TP_DOC
    FROM
      CB001,
      CB850,
      CB060
    WHERE
        CB001_NR_INST   = @ENT_NR_INST
    AND CB001_TP_IDENT3 = @ENT_TP_CHAVE
    AND CB001_NR_IDENT3 = CONVERT(NUMERIC, @ENT_NR_IDENT1) /* CONTRATO */
    /* CB001 -> CB850 */
    AND CB001_NR_PROTOC = CB850_NR_PROTOC
    /* CB001 -> CB060 */
    AND CB001_NR_INST   = CB060_NR_INST
    AND CB001_CD_EMIEMP = CB060_CD_EMIEMP
    AND CB001_CD_PUBLIC = CB060_CD_PUBLIC
    AND CB001_ID_SITUAC <> 90 /* n�o traz lote cancelado */

    SELECT 
      *
    FROM
      #TB03001          

  END



SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
    nenhum
-------------------------------------------------------------------------------*/
GO