-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

USE BN_FGC
GO

-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_UTF16_PARA_UTF8]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_UTF16_PARA_UTF8]
GO

-- Cria Procedure
CREATE PROCEDURE [dbo].[SP_UTF16_PARA_UTF8]
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : IMSTECH                                                      ::
  :: SISTEMA    : DPGE2                                                        ::
  :: MÓDULO     : Balancete diário                                             ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR:                                                              ::
  :: DATA       :                                              VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fábio Bernardo                                               ::
  :: DATA       : 10/04/2013                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  :                                                              ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Balancete diário
  -------------------------------------------------------------------------------*/
  @ENT_NR_ARQ    VARCHAR(1000)        /* ENTRADA DA VERSAO DO MODULO             */
  WITH ENCRYPTION
AS
/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/
--DECLARE @LOC_NR_RTCODE INTEGER
--EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0305017'
--IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF


DROP TABLE #XML
CREATE TABLE #XML ( LINHA VARCHAR(MAX))

BULK INSERT #XML FROM '\\192.168.10.30\pdf\xml\utf16.xml' WITH (DATAFILETYPE='native')
SELECT * FROM #XML
  

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

GO


