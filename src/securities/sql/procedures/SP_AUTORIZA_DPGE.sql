-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_AUTORIZA_DPGE]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_AUTORIZA_DPGE]
GO

-- Cria Procedure
CREATE PROCEDURE [dbo].[SP_AUTORIZA_DPGE]
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : IMS                                                          ::
  :: SISTEMA    : DPG                                                          ::
  :: MÓDULO     : DPG                                                          ::
  :: UTILIZ. POR: dpge-ws                                                      ::
  :: OBSERVAÇÃO : Inclui, aprova e autoriza os DPGEs.                          ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Guilherme Cesarini                                           ::
  :: DATA       : 06/11/2012                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Alteração do valor presente para o exigído na aprovação dos  ::
  :: DPGEs. Adicionado o controle de emissão do DPGE1.                         :: 
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Guilherme Cesarini                                           ::
  :: DATA       : 24/08/2012                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:
  -------------------------------------------------------------------------------*/
  @ENT_NR_VRS       VARCHAR(4),        /* ENTRADA DA VERSAO DO MODULO            */
  @ENT_NR_CPFCNPJ   CHAR(14),          /* NÚMERO DO CPF/CNPJ                     */
  @ENT_NR_CONAVI    NUMERIC(16),       /* NÚMERO DE TRANSAÇÃO                    */
  @ENT_DT_MOVTO     NUMERIC(8),        /* DATA DE MOVIMENTO                      */
  @ENT_DT_ENVIO     NUMERIC(8),        /* DATA DE ENVIO                          */
  @ENT_HR_ENVIO     NUMERIC(4),        /* HORA DO ENVIO                          */
  @ENT_TP_INSTFI    CHAR(4),           /* TIPO DO INSTRUMENTO FINANCEIRO         */
  @ENT_CD_INSTFI    CHAR(11),          /* CÓD DO INSTRUM FINANCEIRO              */
  @ENT_DT_EMISIF    NUMERIC(8),        /* DATA EMISS�O DO INSTR FINANCEIRO       */
  @ENT_DT_VCTOIF    NUMERIC(8),        /* DATA VENCIMENTO DO INSTR. FINANCEIRO   */
  @ENT_QT_EMIT      NUMERIC(1),        /* QUANTIDADE EMITIDA                     */
  @ENT_VL_UNITEM    NUMERIC(18,6),     /* VALOR UNIT�RIO DE EMISS�O              */     
  @ENT_VL_FINEMI    NUMERIC(18,6),     /* VALOR FINANCIAMENO DE EMISS�O          */
  @RET_ID_STATUS    NUMERIC(5)   OUTPUT /* Variável de retorno (Sucesso = 0)    */

  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Modulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
--DECLARE @LOC_NR_RTCODE INTEGER
--EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0350006'
--IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

DECLARE
  @NR_INST      NUMERIC(5),        /* NR. INST.                             */
  @CD_EMIEMP    NUMERIC(5),        /* COD. EMISSOR/EMPRESA                  */
  @VL_DPG12     NUMERIC(17,2),     /* VALOR TOTAL DPGES 1 e 2               */
  @VL_TOTDPG    NUMERIC(17,2),     /* VALOR TOTAL DPGES 2                   */
  @VL_TOTLIM    NUMERIC(17,2),     /* VALOR TOTAL DO LIMITE                 */
  @VL_TOTGAR    NUMERIC(17,2),     /* VALOR TOTAL DO GARANTIA               */
  @DT_VCLIM     NUMERIC(8),        /* DATA DE VENCIMENTO DO LIMITE          */
  @ST_LIM       CHAR(1),           /* STATUS DO LIMITE                      */
  @NR_COUNT     NUMERIC(1),
  @ERRO         NUMERIC(2),

  /* VARI�VEIS PARA OBTEN��O DO ERRO OCORRIDO */
  @CD_ERROR     NUMERIC(9),
  @DS_ERROR     VARCHAR(255)
  
CREATE TABLE #TB0350006_MSG (
  TP_MSG   CHAR(1),        /* E = Erro; I = Informação; O = Ok; A = Aviso. */
  DS_MSG   VARCHAR(1000)    )


/* VERIFICA DUPLICIDADE DE REGISTRO E RETORNA ERRO*/
IF EXISTS (SELECT 1 FROM BN406 WITH (NOLOCK)
           WHERE BN406_NR_GRUPO = @NR_INST
             AND BN406_NR_INST = @CD_EMIEMP
             AND BN406_NR_CONAVI = @ENT_NR_CONAVI) 
BEGIN 
  SELECT @RET_ID_STATUS = -20
  INSERT INTO #TB0350006_MSG VALUES ('E', 'Transaçãoo já existente na base de dados ' + CONVERT(VARCHAR(255), @ENT_NR_CONAVI) + '.')
  SELECT * FROM #TB0350006_MSG
  RETURN @RET_ID_STATUS
END

/* BUSCA INSTITUI��O E EMISSOR EMPRESA */
SELECT
  @NR_INST = BN002_NR_GRUPO,
  @CD_EMIEMP = BN002_NR_INST
FROM
  BN002
WHERE
  BN002_NR_CNPJ = @ENT_NR_CPFCNPJ

SELECT @CD_ERROR = @@ERROR
IF @CD_ERROR <> 0
BEGIN
  SELECT @DS_ERROR = description FROM master..sysmessages WHERE error = @CD_ERROR
  SELECT @RET_ID_STATUS = -10
  INSERT INTO #TB0350006_MSG VALUES ('E', 'Erro ao buscar instituição, emissor e empresa.')
  INSERT INTO #TB0350006_MSG VALUES ('E', 'Erro: ' + CONVERT(VARCHAR, @CD_ERROR) + ' - ' + @DS_ERROR)
  SELECT * FROM #TB0350006_MSG
  RETURN @RET_ID_STATUS
END

SELECT @ERRO = 0
--CONSISTE INSTITIO��O EXISTENTE
IF @NR_INST IS NULL
  SELECT @ERRO = 1

--CONSISTE DATA DE MOVIMENTO DIFERENTE DO DIA
IF @ENT_DT_MOVTO <> (SELECT CONVERT(NUMERIC, CONVERT(VARCHAR, GETDATE(), 112)))
  SELECT @ERRO = 2

IF @ERRO <> 0
BEGIN 

  DELETE FROM BN406 
  WHERE BN406_NR_GRUPO = 0
    AND BN406_NR_INST = 0
    AND BN406_NR_CONAVI = @ENT_NR_CONAVI

  INSERT INTO BN406 (
    BN406_NR_GRUPO,
    BN406_NR_INST,
    BN406_NR_CPFCNPJ,
    BN406_NR_CONAVI,
    BN406_DT_MOVTO,
    BN406_DT_ENVIO,
    BN406_HR_ENVIO,
    BN406_TP_INSTFI,
    BN406_NR_INSTFI,
    BN406_DT_EMISIF,
    BN406_DT_VCTOIF,
    BN406_QT_EMIT,
    BN406_VL_UNITEM,
    BN406_VL_FINEMI,
    BN406_ST_RESP,
    BN406_ST_APROV,
    BN406_NM_MOTAUT,
    BN406_ST_CCC,
    BN406_NM_MOTCCC,
    BN406_NR_OPESIS,
    BN406_DT_INCSIS,
    BN406_DT_ATUSIS
  )
  VALUES (
    0,
    0,
    @ENT_NR_CPFCNPJ,
    @ENT_NR_CONAVI,
    @ENT_DT_MOVTO,
    @ENT_DT_ENVIO,
    @ENT_HR_ENVIO,
    @ENT_TP_INSTFI,
    @ENT_CD_INSTFI,
    @ENT_DT_EMISIF,
    @ENT_DT_VCTOIF,
    @ENT_QT_EMIT,
    @ENT_VL_UNITEM,
    @ENT_VL_FINEMI,
    '1',
    'N',
    CASE
      WHEN @ERRO = 1 THEN 'Instituição e Emissor/Empresa não encontrados para o CNPJ: ' + @ENT_NR_CPFCNPJ + '.'
      WHEN @ERRO = 2 THEN 'Data de movimento inválida, valor informado, diferente da data atual: ' + CONVERT(VARCHAR(10), @ENT_DT_MOVTO) + '.'
    END,
    NULL,
    NULL,
    990,
    GETDATE(),
    GETDATE()
  )
    SELECT @RET_ID_STATUS = -30
    RETURN @RET_ID_STATUS
END

BEGIN TRANSACTION

INSERT INTO BN406 (
  BN406_NR_GRUPO,
  BN406_NR_INST,
  BN406_NR_CPFCNPJ,
  BN406_NR_CONAVI,
  BN406_DT_MOVTO,
  BN406_DT_ENVIO,
  BN406_HR_ENVIO,
  BN406_TP_INSTFI,
  BN406_NR_INSTFI,
  BN406_DT_EMISIF,
  BN406_DT_VCTOIF,
  BN406_QT_EMIT,
  BN406_VL_UNITEM,
  BN406_VL_FINEMI,
  BN406_ST_RESP,
  BN406_ST_APROV,
  BN406_NM_MOTAUT,
  BN406_ST_CCC,
  BN406_NM_MOTCCC,
  BN406_NR_OPESIS,
  BN406_DT_INCSIS,
  BN406_DT_ATUSIS
)
VALUES (
  @NR_INST,
  @CD_EMIEMP,
  @ENT_NR_CPFCNPJ,
  @ENT_NR_CONAVI,
  @ENT_DT_MOVTO,
  @ENT_DT_ENVIO,
  @ENT_HR_ENVIO,
  @ENT_TP_INSTFI,
  @ENT_CD_INSTFI,
  @ENT_DT_EMISIF,
  @ENT_DT_VCTOIF,
  @ENT_QT_EMIT,
  @ENT_VL_UNITEM,
  @ENT_VL_FINEMI,
  '0',
  'P',
  '',
  NULL,
  NULL,
  990,
  GETDATE(),
  GETDATE()
)
-- BUSCA INFORMA��ES DE LIMITE
SELECT 
  @DT_VCLIM = BN407_DT_VCLIM,
  @ST_LIM = BN407_ST_LIM,
  @VL_TOTLIM = ISNULL(BN407_VL_LIMCON, 0),
  @NR_COUNT = 1
FROM 
  BN407 
WHERE 
    BN407_NR_GRUPO   = @NR_INST
AND BN407_NR_INST = @CD_EMIEMP

-- VERIFICA SE EXISTE LIMITE CADASTRADO
IF @NR_COUNT <> 1
BEGIN
  UPDATE
    BN406
  SET
    BN406_ST_RESP   = 1,
    BN406_ST_APROV  = 'N',
    BN406_NM_MOTAUT = 'Limite da instituição não cadastrado.',
    BN406_DT_ATUSIS = GETDATE()
  WHERE
        BN406_NR_GRUPO   = @NR_INST
    AND BN406_NR_INST = @CD_EMIEMP
    AND BN406_NR_CONAVI = @ENT_NR_CONAVI
  COMMIT TRANSACTION
  RETURN @RET_ID_STATUS
END

-- VERIFICA SE O LIMITE EST� ATIVO
IF (@ST_LIM <> 'A')
BEGIN
  UPDATE
    BN406
  SET
    BN406_ST_RESP   = 1,
    BN406_ST_APROV  = 'N',
    BN406_NM_MOTAUT = 'Limite da instituição não está ativo.',
    BN406_DT_ATUSIS = GETDATE()
  WHERE
        BN406_NR_GRUPO   = @NR_INST
    AND BN406_NR_INST = @CD_EMIEMP
    AND BN406_NR_CONAVI = @ENT_NR_CONAVI
  COMMIT TRANSACTION
  RETURN @RET_ID_STATUS
END

-- VERIFICA SE O LIMITE EST� VIGENTE
IF (@DT_VCLIM < (SELECT CONVERT(VARCHAR(8), GETDATE(), 112)))
BEGIN
  UPDATE
    BN406
  SET
    BN406_ST_RESP   = 1,
    BN406_ST_APROV  = 'N',
    BN406_NM_MOTAUT = 'Limite de instituição vencido.',
    BN406_DT_ATUSIS = GETDATE()
  WHERE
        BN406_NR_GRUPO   = @NR_INST
    AND BN406_NR_INST = @CD_EMIEMP
    AND BN406_NR_CONAVI = @ENT_NR_CONAVI
  COMMIT TRANSACTION
  RETURN @RET_ID_STATUS
END  

-- SOMA O MONTANTE DE DPGES2 APROVADOS E EFETIVADOS PARA A INSTITUI��O COM O ATUAL
SELECT @VL_TOTDPG = ISNULL((SELECT 
				           SUM(BN406_VL_FINEMI)
						  FROM
						    BN406
						  WHERE 
							  BN406_NR_GRUPO = @NR_INST
						  AND BN406_NR_INST = @CD_EMIEMP
						  AND BN406_ST_APROV in ('A') 
						   ),0) + 
				  ISNULL((SELECT 
				            SUM(BN410_VL_ATUAL) 
				          FROM 
				             BN410
				          WHERE
				      	      BN410_NR_GRUPO = @NR_INST
				          AND BN410_NR_INST = @CD_EMIEMP
				          AND BN410_ST_DPG2 = 'S'
				           ),0) +
                  @ENT_VL_FINEMI

-- CONSISTE TOTAL DE DPGES COM O TOTAL DE LIMITE DA IF
IF @VL_TOTDPG > @VL_TOTLIM
BEGIN
  UPDATE
    BN406
  SET
    BN406_ST_RESP   = 1,
    BN406_ST_APROV  = 'N',
    BN406_NM_MOTAUT = 'Limite de instituição indisponível.',
    BN406_DT_ATUSIS = GETDATE()
  WHERE
       BN406_NR_GRUPO   = @NR_INST
   AND BN406_NR_INST = @CD_EMIEMP
   AND BN406_NR_CONAVI = @ENT_NR_CONAVI
END
ELSE
BEGIN
  SELECT @VL_TOTGAR = ISNULL((SELECT 
                                SUM(BN401_TT_EXIG) 
                              FROM 
                                BN401
                              WHERE 
                                   BN401_NR_GRUPO = @NR_INST
			  		           AND BN401_NR_INST = @CD_EMIEMP
						       AND BN401_DT_MOVTO = (SELECT MAX(BN401_DT_MOVTO) FROM BN401
						      					     WHERE BN401_NR_GRUPO = @NR_INST
												       AND BN401_NR_INST = @CD_EMIEMP)
	                           ),0)
	                         
  IF @VL_TOTDPG > @VL_TOTGAR
  BEGIN
    UPDATE
	  BN406
    SET
      BN406_ST_RESP   = 1,
  	  BN406_ST_APROV  = 'N',
	  BN406_NM_MOTAUT = 'Garantia da instituição insuficiente.',
      BN406_DT_ATUSIS = GETDATE()
    WHERE
	    BN406_NR_GRUPO   = @NR_INST
    AND BN406_NR_INST = @CD_EMIEMP
    AND BN406_NR_CONAVI = @ENT_NR_CONAVI
  END
  ELSE   	  
  BEGIN
  -- VERIFICA SOMA DOS VALORES DO DPGE 1 E 2 N�O PODE ULTRAPASSAR 5 BI.
    SELECT @VL_DPG12 = ISNULL((SELECT 
                               SUM(BN406_VL_FINEMI)
	  		                   FROM
			                     BN406
			                   WHERE 
			                       BN406_NR_GRUPO = @NR_INST
			                   AND BN406_NR_INST = @CD_EMIEMP
			                   AND BN406_ST_APROV in ('A') 
			                  ),0) + 					
	                   ISNULL((SELECT 
	                             SUM(BN410_VL_ATUAL) 
			                   FROM 
					             BN410
					           WHERE
					               BN410_NR_GRUPO = @NR_INST
					           AND BN410_NR_INST = @CD_EMIEMP
					           ),0) +
				       @ENT_VL_FINEMI

    IF @VL_DPG12 > 5000000000.00
    BEGIN
      UPDATE
        BN406
      SET
        BN406_ST_RESP   = 1,
        BN406_ST_APROV  = 'N',
        BN406_NM_MOTAUT = 'Soma do DPGE sem garantia + saldo emitido de DPGE com garantia excede R$5 bi.',
	    BN406_DT_ATUSIS = GETDATE()
      WHERE
         BN406_NR_GRUPO   = @NR_INST
     AND BN406_NR_INST = @CD_EMIEMP
     AND BN406_NR_CONAVI = @ENT_NR_CONAVI
   END
   ELSE
   BEGIN
     UPDATE
	   BN406
     SET
       BN406_ST_RESP   = 1,
 	   BN406_ST_APROV  = 'A',
	   BN406_DT_ATUSIS = GETDATE()
    WHERE
  	    BN406_NR_GRUPO   = @NR_INST
    AND BN406_NR_INST = @CD_EMIEMP
    AND BN406_NR_CONAVI = @ENT_NR_CONAVI

    INSERT INTO BN411 (
      BN411_NR_GRUPO,
	  BN411_NR_INST,
	  BN411_DT_MOVTO,
	  BN411_NR_SEQ,
	  BN411_VL_MOVTO,
	  BN411_ST_APROV,
	  BN411_NR_INSTFI,
	  BN411_NR_OPESIS,
	  BN411_DT_INCSIS,
	  BN411_DT_ATUSIS )
    SELECT 
      BN406_NR_GRUPO,
      BN406_NR_INST,
      BN406_DT_MOVTO,
      '1',
      BN406_VL_FINEMI,
      BN406_ST_APROV,
      BN406_NR_INSTFI,
      BN406_NR_OPESIS,
      BN406_DT_INCSIS,
      BN406_DT_ATUSIS		         
    FROM 
      BN406
    WHERE 
      BN406_ST_APROV = 'A'
     AND BN406_NR_GRUPO   = @NR_INST
     AND BN406_NR_INST = @CD_EMIEMP
     AND BN406_NR_CONAVI = @ENT_NR_CONAVI
    END
  END
END                   


COMMIT TRANSACTION

SELECT * FROM #TB0350006_MSG
RETURN @RET_ID_STATUS
 
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:
-------------------------------------------------------------------------------*/

GO


