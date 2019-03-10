IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB209_BALANCETE_DIARIO'))
  DROP PROCEDURE dbo.SP_CB209_BALANCETE_DIARIO
GO
CREATE PROCEDURE dbo.SP_CB209_BALANCETE_DIARIO
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobran�a                                             ::
  :: M�DULO     : Balancete di�rio                                             ::
  :: UTILIZ. POR: F03SF05R                                                     ::
  :: OBSERVA��O :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERA��O  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 29/05/2014                                   VERS�O SP:      ::
  :: ALTERA��O  : criada SP igual ao original SP_CB0305017                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 05/05/2011                                   VERS�O SP:    1 ::
  :: ALTERA��O  : Primeira vers�o                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRI��O DA FUNCIONALIDADE:

  Balancete di�rio
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5,0) ,       /* Nr. institui��o                         */
  @ENT_CD_EMIEMP NUMERIC(5,0) ,       /* Nr. emissor/empresa                     */
  @ENT_NR_PRODUT NUMERIC(5,0) ,       /* Nr. Produto                             */
  @ENT_CD_COMPSC NUMERIC(5,0) ,       /* Nr. Banco                               */
  @ENT_NR_AGENC  NUMERIC(5,0) ,       /* Ag�ncia                                 */
  @ENT_NR_CONTA  NUMERIC(12,0),       /* Nr. conta                               */
  @ENT_DT_INI    NUMERIC(8,0)         /* Dt. Movto. Ini.                         */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a vers�o do M�dulo � diferente da vers�o da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
--EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0305017'
--IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

CREATE TABLE #TB05017 (
  CB209_NR_PRODUT NUMERIC(5)   ,
  CB255_DS_PROD   VARCHAR(40)  ,
  CB209_DT_MOVTO  NUMERIC(8)   ,
  CB209_VL_VALOR1 NUMERIC(17,2),
  CB209_QT_TOTAL1 NUMERIC(9)   ,
  CB209_VL_VALOR2 NUMERIC(17,2),
  CB209_QT_TOTAL2 NUMERIC(9)   ,
  CB209_VL_VALOR3 NUMERIC(17,2),
  CB209_QT_TOTAL3 NUMERIC(9)   ,
  CB209_VL_VALOR4 NUMERIC(17,2),
  CB209_QT_TOTAL4 NUMERIC(9)   ,
  CB209_VL_VALOR5 NUMERIC(17,2),
  CB209_QT_TOTAL5 NUMERIC(9)
)  

/* SALDO ANTERIOR */
INSERT INTO #TB05017 (
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  CB209_VL_VALOR1,
  CB209_QT_TOTAL1
)
SELECT
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR),
  SUM(CB209_QT_TOTAL)
FROM
  CB209,
  CB255
WHERE
    (@ENT_NR_PRODUT IS NULL OR CB209_NR_PRODUT = @ENT_NR_PRODUT)
AND (@ENT_CD_COMPSC IS NULL OR CB209_CD_COMPSC = @ENT_CD_COMPSC)
AND (@ENT_NR_AGENC  IS NULL OR CB209_NR_AGENC  = @ENT_NR_AGENC )
AND (@ENT_NR_CONTA  IS NULL OR CB209_NR_CONTA  = @ENT_NR_CONTA )
AND (@ENT_DT_INI    IS NULL OR CB209_DT_MOVTO  = @ENT_DT_INI)  
/* CB209 -> CB255 */
AND CB209_NR_PRODUT = CB255_CD_PROD
AND CB209_ID_TIPOAC = 1 /* SALDO ANTERIOR */
GROUP BY 
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO
ORDER BY
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO 

/* ENTRADAS */
INSERT INTO #TB05017 (
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  CB209_VL_VALOR2,
  CB209_QT_TOTAL2
)
SELECT
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR),
  SUM(CB209_QT_TOTAL)
FROM
  CB209,
  CB255
WHERE
	(@ENT_CD_COMPSC IS NULL OR CB209_CD_COMPSC = @ENT_CD_COMPSC)
AND (@ENT_NR_AGENC  IS NULL OR CB209_NR_AGENC  = @ENT_NR_AGENC )
AND (@ENT_NR_CONTA  IS NULL OR CB209_NR_CONTA  = @ENT_NR_CONTA )
AND (@ENT_NR_PRODUT IS NULL OR CB209_NR_PRODUT = @ENT_NR_PRODUT)
AND (@ENT_DT_INI    IS NULL OR CB209_DT_MOVTO  = @ENT_DT_INI)  
/* CB209 -> CB255 */
AND CB209_NR_PRODUT = CB255_CD_PROD
AND CB209_ID_TIPOAC = 2 /* ENTRADAS */
GROUP BY 
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO
ORDER BY
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO 
  
/* LIQUIDADOS */
INSERT INTO #TB05017 (
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  CB209_VL_VALOR3,
  CB209_QT_TOTAL3
)
SELECT
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR),
  SUM(CB209_QT_TOTAL)
FROM
  CB209,
  CB255
WHERE
	(@ENT_CD_COMPSC IS NULL OR CB209_CD_COMPSC = @ENT_CD_COMPSC)
AND (@ENT_NR_AGENC  IS NULL OR CB209_NR_AGENC  = @ENT_NR_AGENC )
AND (@ENT_NR_CONTA  IS NULL OR CB209_NR_CONTA  = @ENT_NR_CONTA )
AND (@ENT_NR_PRODUT IS NULL OR CB209_NR_PRODUT = @ENT_NR_PRODUT)
AND (@ENT_DT_INI    IS NULL OR CB209_DT_MOVTO  = @ENT_DT_INI)  
/* CB209 -> CB255 */
AND CB209_NR_PRODUT = CB255_CD_PROD
AND CB209_ID_TIPOAC = 3 /* LIQUIDADOS */ 
GROUP BY 
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO
ORDER BY
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO 

/* BAIXADOS */  
INSERT INTO #TB05017 (
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  CB209_VL_VALOR4,
  CB209_QT_TOTAL4
)
SELECT
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR),
  SUM(CB209_QT_TOTAL)
FROM
  CB209,
  CB255
WHERE
	(@ENT_CD_COMPSC IS NULL OR CB209_CD_COMPSC = @ENT_CD_COMPSC)
AND (@ENT_NR_AGENC  IS NULL OR CB209_NR_AGENC  = @ENT_NR_AGENC )
AND (@ENT_NR_CONTA  IS NULL OR CB209_NR_CONTA  = @ENT_NR_CONTA )
AND (@ENT_NR_PRODUT IS NULL OR CB209_NR_PRODUT = @ENT_NR_PRODUT)
AND (@ENT_DT_INI    IS NULL OR CB209_DT_MOVTO  = @ENT_DT_INI)  
/* CB209 -> CB255 */
AND CB209_NR_PRODUT = CB255_CD_PROD
AND CB209_ID_TIPOAC = 4 /* BAIXADOS */
GROUP BY 
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO
ORDER BY
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO 

/* SALDO ATUAL */
INSERT INTO #TB05017 (
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  CB209_VL_VALOR5,
  CB209_QT_TOTAL5
)
SELECT
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR),
  SUM(CB209_QT_TOTAL)
FROM
  CB209,
  CB255
WHERE
	(@ENT_CD_COMPSC IS NULL OR CB209_CD_COMPSC = @ENT_CD_COMPSC)
AND (@ENT_NR_AGENC  IS NULL OR CB209_NR_AGENC  = @ENT_NR_AGENC )
AND (@ENT_NR_CONTA  IS NULL OR CB209_NR_CONTA  = @ENT_NR_CONTA )
AND (@ENT_NR_PRODUT IS NULL OR CB209_NR_PRODUT = @ENT_NR_PRODUT)
AND (@ENT_DT_INI    IS NULL OR CB209_DT_MOVTO  = @ENT_DT_INI)  
/* CB209 -> CB255 */
AND CB209_NR_PRODUT = CB255_CD_PROD

AND CB209_NR_PRODUT = CB255_CD_PROD
AND CB209_ID_TIPOAC = 10 /* SALDO ATUAL */
GROUP BY 
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO
ORDER BY
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO 
  
/* RESULT SET */ 
SELECT
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO ,
  SUM(CB209_VL_VALOR1) CB209_VL_VALOR1,
  SUM(CB209_QT_TOTAL1) CB209_QT_TOTAL1,
  SUM(CB209_VL_VALOR2) CB209_VL_VALOR2,
  SUM(CB209_QT_TOTAL2) CB209_QT_TOTAL2,
  SUM(CB209_VL_VALOR3) CB209_VL_VALOR3,
  SUM(CB209_QT_TOTAL3) CB209_QT_TOTAL3,
  SUM(CB209_VL_VALOR4) CB209_VL_VALOR4,
  SUM(CB209_QT_TOTAL4) CB209_QT_TOTAL4,
  SUM(CB209_VL_VALOR5) CB209_VL_VALOR5,
  SUM(CB209_QT_TOTAL5) CB209_QT_TOTAL5
FROM
  #TB05017
GROUP BY 
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO
ORDER BY
  CB209_NR_PRODUT,
  CB255_DS_PROD  ,
  CB209_DT_MOVTO   



SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:

  CB209_NR_PRODUT
  CB255_DS_PROD  
  CB209_DT_MOVTO
  CB209_VL_VALOR
  CB209_QT_TOTAL
-------------------------------------------------------------------------------*/
GO