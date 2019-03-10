

-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_PDF]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_PDF]
GO


-- Cria Procedure
CREATE PROCEDURE [dbo].[SP_PDF]
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : carga de PDF de relatório                                    ::
  :: UTILIZ. POR:                                                              ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fábio Bernardo                                               ::
  :: DATA       : 21/05/2013                                   VERSÃO SP:    2 ::
  :: ALTERAÇÃO  : Separação de campos conforme o Oswaldo                       ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 03/09/2012                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:
 
  Procedure que carrega o arquivo PDF de relatório na base
  -------------------------------------------------------------------------------*/
  @ENT_NR_GRUPO  VARCHAR(8)  ,		  /* Grupo	         					 	 */
  @ENT_NR_CESS   VARCHAR(8)  ,		  /* Cessionáio 					 	     */
  @ENT_TP_REL    CHAR(7)     ,        /* Número do REL                           */
  @ENT_NM_PATH   VARCHAR(255)         /* Caminho do arq PDF                      */
  WITH ENCRYPTION
AS 
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
--DECLARE @LOC_NR_RTCODE INTEGER
--EXECUTE @LOC_NR_RTCODE = SP_PDF  @ENT_NR_VRS, '1', 'SP_PDF' --SP_CB0300008
--IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF

DECLARE
  @DT_ATUAL  NUMERIC(8,0),
  @HR_ATUAL  NUMERIC(4,0),
  @NM_ARQ    VARCHAR(27) 
  
SELECT @DT_ATUAL = CONVERT(VARCHAR(8), GETDATE(), 112)
SELECT @HR_ATUAL = CONVERT(VARCHAR, SUBSTRING(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''), 1, 4))

/* TIRA OS ESPAÇOS EM BRANCO */
SELECT @ENT_NM_PATH = LTRIM(RTRIM(@ENT_NM_PATH))
/* BUSCA O NOME DO ARQUIVO */
SELECT @NM_ARQ = SUBSTRING(@ENT_NM_PATH, LEN(@ENT_NM_PATH) - 26, 26)


/* INSERE A IMAGEM DE PAGAMENTO */
EXEC(
		'INSERT INTO BKN801 SELECT ' + 
		@ENT_NR_GRUPO   + ', ' + 
		@ENT_NR_CESS	+ ', ''' + 
		@ENT_TP_REL		+ ''', ' + 
		@DT_ATUAL		+ ', ' + 
		@HR_ATUAL		+ ' ,(SELECT * FROM OPENROWSET(BULK ' + 
		@ENT_NM_PATH	+ ', SINGLE_BLOB) AS PDF), ' +  '0, ' + 'GETDATE(), GETDATE()'
	)


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
/*-------------------------------------------------------------------------------
  RESULT SET:                     


-------------------------------------------------------------------------------*/

GO


