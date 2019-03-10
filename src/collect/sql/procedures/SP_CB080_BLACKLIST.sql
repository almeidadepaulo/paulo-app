IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB080_BLACKLIST'))
  DROP PROCEDURE dbo.SP_CB080_BLACKLIST
GO
CREATE PROCEDURE dbo.SP_CB080_BLACKLIST
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobran�a                                             ::
  :: M�DULO     : Consulta de blacklist                                        ::
  :: UTILIZ. POR: F03SF02Q                                                     ::
  :: OBSERVA��O :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERA��O  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 02/06/2014                                   VERS�O SP:      ::
  :: ALTERA��O  : criada SP igual ao original SP_CB0302031                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 06/12/2010                                   VERS�O SP:    1 ::
  :: ALTERA��O  : Primeira vers�o                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*-------------------------------------------------------------------------------
  DESCRI��O DA FUNCIONALIDADE:
 
  Consulta de blacklist.
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS     VARCHAR(4) ,   /* N�mero da vers�o da SP                       */ 
  @ENT_NR_INST    NUMERIC(5) ,   /* N�mero da institui��o                        */
  @ENT_NR_CHAVE   VARCHAR(20),   /* Nr. Chave                                    */
  @ENT_TP_CHAVE   NUMERIC(3)     /* Tp. Chave                                    */
  WITH ENCRYPTION
AS 
/*-----------------------------------------------------------------------------*/
/* Verifica se a vers�o do M�dulo � diferente da vers�o da Stored Procedure    */
/*-----------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0302031'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*-----------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

/*=========================*/
/* DECLARA��O DE VARI�VEIS */
/*=========================*/
DECLARE
  @NR_CPFCNPJ      VARCHAR(14),
  @NR_QTDE         NUMERIC(5) 
  
CREATE TABLE #TB02031 (
  CB080_NR_CPFCNPJ VARCHAR(14)
)  

IF @ENT_TP_CHAVE = 1 /* CPF/CNPJ */
BEGIN
  SELECT
    CB080_NR_INST   ,
    CASE 
      WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 9  THEN '00' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
      WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 10 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
      WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 11 THEN CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
      WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 13 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
      ELSE CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
    END CB080_NR_CPFCNPJ,
    CASE
  	WHEN CB080_NR_CEP = 0 THEN '00.000-000'
  	ELSE SUBSTRING(CONVERT(CHAR(8),CB080_NR_CEP),1,2)+'.'+SUBSTRING(CONVERT(CHAR(8),CB080_NR_CEP),3,3)+'-'+SUBSTRING(CONVERT(CHAR(8),CB080_NR_CEP),6,3)
  	END CB080_NR_CEP
  FROM
    CB080
  WHERE
      (@ENT_NR_INST   IS NULL OR CB080_NR_INST    = @ENT_NR_INST)
  AND (@ENT_NR_CHAVE  IS NULL OR CONVERT(NUMERIC, CB080_NR_CPFCNPJ) = @ENT_NR_CHAVE)
END
ELSE
  BEGIN
    /* FAZ A BUSCA DE CPF UTILIZANDO A CHAVE 2 E 3 */
    INSERT INTO #TB02031 (
  	  CB080_NR_CPFCNPJ
    )
    SELECT
  	  CONVERT(NUMERIC, CB001_NR_IDENT1)
    FROM
	  CB001
    WHERE
        CB001_NR_INST   = @ENT_NR_INST
    AND CB001_TP_IDENT2 = @ENT_TP_CHAVE
    AND CB001_NR_IDENT2 = CONVERT(NUMERIC, @ENT_NR_CHAVE)
    UNION ALL
    SELECT
  	  CONVERT(NUMERIC, CB001_NR_IDENT1)
    FROM
	  CB001
    WHERE
        CB001_NR_INST   = @ENT_NR_INST
    AND CB001_TP_IDENT3 = @ENT_TP_CHAVE
    AND CB001_NR_IDENT3 = CONVERT(NUMERIC, @ENT_NR_CHAVE)

    /* BUSCA QUANTIDADE DE REGISTRO QUE RETORNOU DA CONSULTA */
    SELECT 
      @NR_QTDE = COUNT(*)
    FROM
      #TB02031          

    /* VERIFICA SE ACHOU O CPF */
    IF @NR_QTDE > 0
    BEGIN
	  /* SELECIONA O CPF/CNPJ */
	  SELECT 
        @NR_CPFCNPJ = CB080_NR_CPFCNPJ
	  FROM
        #TB02031

      SELECT
       CB080_NR_INST   ,
       CASE 
         WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 9  THEN '00' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
         WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 10 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
         WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 11 THEN CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
         WHEN LEN(CONVERT(NUMERIC, CB080_NR_CPFCNPJ)) = 13 THEN '0' + CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
         ELSE CONVERT(VARCHAR, CONVERT(NUMERIC, CB080_NR_CPFCNPJ))
       END CB080_NR_CPFCNPJ,
       CASE 
          WHEN LEN(CB080_NR_CEP) = 7 THEN '0' + CONVERT(VARCHAR, CB080_NR_CEP)
          ELSE  CONVERT(VARCHAR, CB080_NR_CEP)
        END CB080_NR_CEP
      FROM
        CB080
      WHERE
          (@ENT_NR_INST IS NULL OR CB080_NR_INST    = @ENT_NR_INST)
      AND (@NR_CPFCNPJ  IS NULL OR CONVERT(NUMERIC, CB080_NR_CPFCNPJ) = @NR_CPFCNPJ)
    END
  END

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:                     



------------------------------------------------------------------------------*/
GO