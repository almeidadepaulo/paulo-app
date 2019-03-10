-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CARGA_RESERVA032]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_CARGA_RESERVA032]
GO

-- Cria Procedure
CREATE PROCEDURE [dbo].[SP_CARGA_RESERVA032]
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : IMSTECH														::
  :: SISTEMA    : CF															::
  :: MÓDULO     : Carga de Reservas     										::
  :: OBSERVAÇÃO :	IMPORTA XML E CARREGA TABELAS								::
  ::				BN217,BN218,BN219											::
  ::----------------------------------------------------------------------------::
  :: PROGRAMADOR: Fábio Bernardo												::
  :: DATA       : 24/12/2013													::
  :: ALTERAÇÃO  : Transformado Script em Procedure				VERSÃO SP:   1	::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*------------------------------------------------------------------------------
  DADOS DE ENTRADA
  ------------------------------------------------------------------------------*/
	@ENT_NM_ARQUIVO		VARCHAR(100)	-- Nome do arquivo a Importar
  WITH ENCRYPTION
AS
BEGIN TRY -- TRATAMENTO DE ERRO

DECLARE
		 @DT_ATUAL					DATETIME		= GETDATE()  -- DATA ATUAL 
		,@NM_PROG					VARCHAR(200)	= 'SP_CARGA_RESERVA032' -- NOME DO PROGRAMA PARA O LOG
		,@NM_CAMINHO				VARCHAR(200)	= '\\192.168.10.31\pdf\xml\' -- CAMINHO DO ARQUIVO
		,@NM_COMPLETO				VARCHAR(200)	
		
		
SET @NM_COMPLETO = @NM_CAMINHO + @ENT_NM_ARQUIVO		
		


-- APAGA DADOS DAS TABELAS ANTES DE INSERIR
DELETE FROM BN221 WHERE BN221_NM_ARQ = @ENT_NM_ARQUIVO


--RAISERROR('Nome Incorreto',11,1)  


-- LE XML
DROP TABLE XMLwithOpenXML
CREATE TABLE XMLwithOpenXML
(
	Id				INT IDENTITY PRIMARY KEY,
	XMLData			XML,
	LoadedDateTime	DATETIME
)





DECLARE @SQL NVARCHAR(4000); --= 'BULK INSERT #TXT1 FROM ''' + @ENT_NM_ARQUIVO + ''' WITH ( FIELDTERMINATOR ='';'', FIRSTROW = 2 )';


SET @SQL = 'INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK '''+@NM_COMPLETO+''', SINGLE_BLOB) AS x;
'
EXEC(@SQL);
-- SELECT TOP 100 * FROM XMLwithOpenXML


DECLARE @XML AS XML, @hDoc AS INT
SELECT @XML = XMLData FROM XMLwithOpenXML
EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

-- GERRA BN221  $221 $BN221
INSERT INTO BN221 (
   BN221_NM_ARQ
  ,BN221_NR_CNPJBA
  ,BN221_NR_RESC3
  ,BN221_NR_CESC3
  ,BN221_TP_EVENC3
  ,BN221_TP_DIVERG
  ,BN221_NR_OPESIS
  ,BN221_DT_INCSIS
  ,BN221_DT_ATUSIS
)
SELECT  
   BN221_NM_ARQ=@ENT_NM_ARQUIVO
  ,BN221_NR_CNPJBA
  ,BN221_NR_RESC3
  ,BN221_NR_CESC3
  ,BN221_TP_EVENC3
  ,BN221_TP_DIVERG
  ,BN219_NR_OPESIS=0
  ,BN221_DT_INCSIS=GETDATE()
  ,BN221_DT_ATUSIS=GETDATE()
FROM OPENXML(@hDoc, '/ACCCDOC/SISARQ/ACCC032/Grupo_ACCC032_SitCess') -- TESTE COMPLETO
WITH 
(
   BN221_NR_CNPJBA     [char]    (  8)		'IdentdPartAdmdo'
  ,BN221_NR_RESC3      [char]    ( 21)      'NURes'
  ,BN221_NR_CESC3      [char]    ( 21)      'NUCess'
  ,BN221_TP_EVENC3     [numeric] (  3, 0)   'SitEvt'
  ,BN221_TP_DIVERG     [numeric] (  3, 0)   'TpDivgte'
)



-- VERIFICA SE ESTA PROCESSANDO
IF NOT EXISTS	(SELECT TOP 1 * FROM BN221  WHERE BN221_NM_ARQ = @ENT_NM_ARQUIVO )
BEGIN
	SELECT  COD_ERRO=1,DESCRICAO_ERRO='Arquivo com Problemas'
	RETURN
END








SELECT  COD_ERRO=0,DESCRICAO_ERRO='SEM ERROS'



END TRY -- TRATAMENTO DE ERRO
BEGIN CATCH
	SELECT  COD_ERRO=ERROR_NUMBER(),DESCRICAO_ERRO='Linha '+CONVERT(VARCHAR(30),ERROR_LINE())+': '+ERROR_MESSAGE()
		
	RETURN 
END CATCH

-- RODAR ATE AQUI

	
/* TESTE

INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK '\\192.168.10.31\pdf\xml\ACCC031_00954288_20131223_00002.xml', SINGLE_BLOB) AS x;
--FROM OPENROWSET(BULK '\\192.168.10.31\pdf\xml\teste2.xml', SINGLE_BLOB) AS x;
SELECT TOP 100 * FROM XMLwithOpenXML




	
	
*/

