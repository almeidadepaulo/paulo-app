IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB804_CONTROLE_REMESSA'))
  DROP PROCEDURE dbo.SP_CB804_CONTROLE_REMESSA
GO
CREATE PROCEDURE dbo.SP_CB804_CONTROLE_REMESSA

/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobran�a                                             ::
  :: M�DULO     : Consulta de remessa                                          ::
  :: UTILIZ. POR: F03SF05B                                                     ::
  :: OBSERVA��O :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERS�O SP:      ::
  :: ALTERA��O  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 30/05/2014                                   VERS�O SP:      ::
  :: ALTERA��O  : criada SP igual ao original SP_CB0305002                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 17/11/2010                                   VERS�O SP:    1 ::
  :: ALTERA��O  : Primeira vers�o                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRI��O DA FUNCIONALIDADE:

  Consulta de remessa
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_CD_COMPSC NUMERIC(5,0) ,       /* C�digo da compensa��o                   */
  @ENT_NR_AGENC  NUMERIC(5,0) ,       /* N�mero da ag�ncia                       */
  @ENT_NR_CONTA  NUMERIC(12)  ,       /* N�mero da conta                         */
  @ENT_CD_FORMU  VARCHAR(10)  ,       /* C�digo do formul�rio                    */
  @ENT_DT_INI    NUMERIC(8,0) ,       /* Dt. Movto. Ini.                         */
  @ENT_DT_FIM    NUMERIC(8,0)         /* Dt. Movto. Fim.                         */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a vers�o do M�dulo � diferente da vers�o da Stored Procedure */
/*--------------------------------------------------------------------------*/
DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0305002'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

SELECT 
  CB804_CD_COMPSC,
  CB804_NR_AGENC ,
  CB804_NR_CONTA ,
  CB804_CD_FORMU ,
  CB804_NR_SEQARQ,
  CB804_DT_GERAC ,
  CASE WHEN LEN(CONVERT(NUMERIC, CB804_HR_GERAC)) = 4  THEN SUBSTRING(CONVERT(CHAR(4),CB804_HR_GERAC),1,2)+':'+SUBSTRING(CONVERT(CHAR(4),CB804_HR_GERAC),3,2)
  WHEN LEN(CONVERT(NUMERIC, CB804_HR_GERAC)) = 3  THEN '0'+SUBSTRING(CONVERT(CHAR(3),CB804_HR_GERAC),1,1)+':'+SUBSTRING(CONVERT(CHAR(3),CB804_HR_GERAC),2,2) 
  ELSE '00:00'
  END CB804_HR_GERAC,
  
  --CONVERT(CHAR(10),CB804_HR_GERAC,108) CB804_HR_GERAC,
  --CB804_ID_SITUAC,

	  
  CB804_ID_SITUAC = CASE CB804_ID_SITUAC -- CHAMADO 111
					
		WHEN '1' THEN 'Aprovada'					                     
		WHEN 1 THEN 'Consistencia Efetuada'
		WHEN 2 THEN 'Movimento Formatado'
		WHEN 3 THEN 'Tabelas Titulo Carregadas'
		WHEN 4 THEN 'Tabelas CNAB carregadas'
		WHEN 5 THEN 'Gerado Texto para Boleto'
		WHEN 6 THEN 'Gerado Movimento Retorno'
		WHEN 7 THEN 'Gerado Movimento Moore'
							                     
		ELSE 'Indefinido'
					
  END ,

  CB804_TT_REGPRO,
  CB804_TT_REGREC
FROM
  CB804
WHERE
    (@ENT_CD_COMPSC IS NULL OR CB804_CD_COMPSC = @ENT_CD_COMPSC)
AND (@ENT_NR_AGENC  IS NULL OR CB804_NR_AGENC  = @ENT_NR_AGENC)
AND (@ENT_NR_CONTA  IS NULL OR CB804_NR_CONTA  = @ENT_NR_CONTA)
AND (@ENT_CD_FORMU  IS NULL OR CB804_CD_FORMU  = @ENT_CD_FORMU)
AND (@ENT_DT_INI    IS NULL OR CB804_DT_GERAC BETWEEN @ENT_DT_INI AND @ENT_DT_FIM)



SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
    nenhum
-------------------------------------------------------------------------------*/
GO