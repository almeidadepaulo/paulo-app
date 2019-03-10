IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id('dbo.SP_CB214_RESUMO_FINANCEIRO'))
  DROP PROCEDURE dbo.SP_CB214_RESUMO_FINANCEIRO
GO
CREATE PROCEDURE dbo.SP_CB214_RESUMO_FINANCEIRO
  
/*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: EMPRESA    : Publish                                                      ::
  :: SISTEMA    : Publish cobrança                                             ::
  :: MÓDULO     : Resumo financeiro                                            ::
  :: UTILIZ. POR: F03SF05V                                                     ::
  :: OBSERVAÇÃO :                                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Fabio Bernardo                                               ::
  :: DATA       : 29/05/2014                                   VERSÃO SP:      ::
  :: ALTERAÇÃO  : criada SP igual ao original SP_CB0305022                     ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Felipe Cesarini                                              ::
  :: DATA       : 18/10/2011                                   VERSÃO SP:    1 ::
  :: ALTERAÇÃO  : Primeira versão                                              ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Silvana Wessler                                              ::
  :: DATA       : 03/01/2014                                   VERSÃO SP:    2 ::
  :: ALTERAÇÃO  : Substituição da tabela cb214 pela cb 206 e cb804             ::
  ::---------------------------------------------------------------------------::
  :: PROGRAMADOR: Rafael Pereira da Silva                                      ::
  :: DATA       : 23/01/2014                                   VERSÃO SP:    3 ::
  :: ALTERAÇÃO  : Inclusão dos valores rejeitados CB212                        ::
  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  
  /*-------------------------------------------------------------------------------
  DESCRIÇÃO DA FUNCIONALIDADE:

  Resumo financeiro
  -------------------------------------------------------------------------------*/
  
  @ENT_NR_VRS    VARCHAR(4)   ,       /* ENTRADA DA VERSAO DO MODULO             */
  @ENT_NR_INST   NUMERIC(5,0) ,       /* Nr. instituição                         */
  @ENT_CD_COMPSC NUMERIC(5,0) ,       /* Código da compensação                   */
  @ENT_NR_AGENC  NUMERIC(5,0) ,       /* Número da agência                       */
  @ENT_NR_CONTA  NUMERIC(12)  ,       /* Número da conta                         */
  @ENT_CD_EMIEMP NUMERIC(5,0) ,       /* Nr. emissor/empresa                     */
  @ENT_DT_MOVINI NUMERIC(8,0) ,       /* Dt. Movto inicial                       */
  @ENT_DT_MOVFIM NUMERIC(8,0) ,       /* Dt. Movto final                         */
  @ENT_DT_CREINI NUMERIC(8,0) ,       /* Dt. Crédito inicial                     */
  @ENT_DT_CREFIM NUMERIC(8,0)         /* Dt. Crédito fim                         */
    
  WITH ENCRYPTION
AS

/*--------------------------------------------------------------------------*/
/* Verifica se a versão do Módulo é diferente da versão da Stored Procedure */
/*--------------------------------------------------------------------------*/

DECLARE @LOC_NR_RTCODE INTEGER
EXECUTE @LOC_NR_RTCODE = SP_CD0100002 @ENT_NR_VRS, '1', 'SP_CB0305022'
IF @LOC_NR_RTCODE = 99999 RETURN 99999
/*--------------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS OFF



CREATE TABLE #TB05022 (
   CB214_DT_MOVTO	  NUMERIC(8)			-- DATA DE MOVIMENTO
  ,CB214_DT_CRED      NUMERIC(8)			-- DATA DE CRÉDITO
  ,CB214_VL_PAGREJ	  NUMERIC(17,2)			-- VALOR PAGO REJEITADO
  ,CB214_VL_VALOR1    NUMERIC(17,2)			-- VALOR PAGO BAIXADO
) 


CREATE TABLE #TB05022_AUX (
   CB804_DT_GERAC   NUMERIC(8)				-- DATA DE MOVIMENTO
  ,CB206_DT_CRED    NUMERIC(8)				-- DATA DE CRÉDITO
  ,CB212_VL_REJ     NUMERIC(17,2)			-- VALOR PAGO REJEITADO
  ,CB206_VL_PAGO    NUMERIC(17,2)			-- VALOR PAGO BAIXADO
) 

/* ------------------------------------------------------------------------------------------
   SE A BUSCA FOR POR DATA DE MOVIMENTO, SELECIONA NA TABELA DE REMESSAS PROCESSADAS (cb804), 
   AS SEQUENCIAS DE ARQUIVO GRAVADAS PARA A DATA 
   ------------------------------------------------------------------------------------------ */

  IF (@ENT_DT_CREINI IS NULL)
   
	BEGIN
	/* ------------------- SELECIONA OS REGISTROS NA CB804 ----------------------*/
	
		SELECT	DISTINCT
			 CB804_CD_COMPSC 
			,CB804_NR_AGENC
			,CB804_NR_CONTA
			,CB804_NR_SEQARQ
			,CB804_DT_GERAC
		
			INTO
				#TEMP_DT_MOVIM
				
		FROM	
			CB804
			
		WHERE	1=1
			AND CB804_DT_GERAC BETWEEN @ENT_DT_MOVINI AND @ENT_DT_MOVFIM
			AND (@ENT_CD_COMPSC IS NULL OR CB804_CD_COMPSC = @ENT_CD_COMPSC)
			AND (@ENT_NR_AGENC  IS NULL OR CB804_NR_AGENC  = @ENT_NR_AGENC)
			AND (@ENT_NR_CONTA  IS NULL OR CB804_NR_CONTA  = @ENT_NR_CONTA)
			AND CB804_CD_FORMU = 'COLLECT-PG'

			/* -------------- BUSCA OS VALORES PAGOS BAIXADOS CORREPONDENTES NA CB206 -------*/ 

		INSERT INTO
			#TB05022_AUX
			
				SELECT  
					 CB804_DT_GERAC
					,CB206_DT_CRED
					,0
					,CB206_VL_PAGO
		
				FROM
  					CB206 INNER JOIN #TEMP_DT_MOVIM
		
				ON
					CB206_CD_COMPSC = CB804_CD_COMPSC
					AND CB206_NR_AGENC  = CB804_NR_AGENC
					AND CB206_NR_CONTA  = CB804_NR_CONTA
					AND CB206_NR_REMESS = CB804_NR_SEQARQ
	
				WHERE 1=1
					AND CB206_CD_FORMU  = 'COLLECT-PG'

			/* -------------- BUSCA OS VALORES PAGOS REJEITADOS CORREPONDENTES NA CB212 -------*/ 		

		INSERT INTO
			#TB05022_AUX
			
				SELECT  
					 CB804_DT_GERAC
					,CB212_DT_CRED
					,CB212_VL_PAGO
					, 0
		
				FROM
  					CB212 INNER JOIN #TEMP_DT_MOVIM
		
				ON
					CB212_CD_COMPSC = CB804_CD_COMPSC
					AND CB212_NR_AGENC  = CB804_NR_AGENC
					AND CB212_NR_CONTA  = CB804_NR_CONTA
					AND CB212_NR_REMESS = CB804_NR_SEQARQ
					
				WHERE 1=1
					AND CB212_CD_FORMU  = 'COLLECT-PG'
				
	END  

/* ------------------------------------------------------------------------------------------
   SE A BUSCA FOR POR DATA DE CRÉDITO, SELECIONA NA TABELA DE PAGAMENTO (CB206) AS DATAS DE 
   CRÉDITO SOLICITADOS, BUSCANDO O NÚMERO DO PROCESSAMENTO, E COM ESTE, BUSCA NA TABELA DE
   REMESSAS PROCESSADAS (cb804), AS DATAS DE PROCESSAMENTO 
   ------------------------------------------------------------------------------------------ */   

   ELSE
   
	BEGIN
	/* ------------------- SELECIONA OS REGISTROS NA CB206 -----------------------*/
	
		SELECT  
			 CB206_NR_REMESS
			,CB206_DT_CRED
			,CB206_VL_PAGO
			,CB206_NR_AGENC
			,CB206_NR_CONTA
			,CB206_CD_COMPSC 
	
			INTO
				#TEMP_DT_CREDITO
				
		FROM
  			CB206
	
		WHERE 1=1
			AND (@ENT_CD_COMPSC IS NULL OR CB206_CD_COMPSC = @ENT_CD_COMPSC)
			AND (@ENT_NR_AGENC  IS NULL OR CB206_NR_AGENC  = @ENT_NR_AGENC)
			AND (@ENT_NR_CONTA  IS NULL OR CB206_NR_CONTA  = @ENT_NR_CONTA)
			AND (@ENT_DT_CREINI IS NULL OR CB206_DT_CRED  BETWEEN @ENT_DT_CREINI AND @ENT_DT_CREFIM)  
			AND  CB206_CD_FORMU = 'COLLECT-PG'
		

	/* -------------- BUSCA AS DATAS DE MOVIMENTO CORREPONDENTES NA CB804 -------*/  
	
		SELECT  DISTINCT
			 CB804_CD_COMPSC 
			,CB804_NR_AGENC	
			,CB804_NR_CONTA	
			,CB804_NR_SEQARQ 
			,CB804_DT_GERAC
			
			INTO	
				#TEMP_CB804
				
		FROM
  			CB804 INNER JOIN #TEMP_DT_CREDITO
	
		ON	
		    CB206_CD_COMPSC = CB804_CD_COMPSC
		AND CB206_NR_AGENC  = CB804_NR_AGENC
		AND CB206_NR_CONTA  = CB804_NR_CONTA
		AND CB206_NR_REMESS = CB804_NR_SEQARQ
		
		WHERE	
			CB804_CD_FORMU  = 'COLLECT-PG'

		
		INSERT INTO
			#TB05022_AUX
			
				SELECT  
					 CB804_DT_GERAC 
					,CB206_DT_CRED
					,0
					,CB206_VL_PAGO
				
				FROM
  					#TEMP_CB804 INNER JOIN #TEMP_DT_CREDITO
				
				ON	
					CB206_CD_COMPSC = CB804_CD_COMPSC
					AND CB206_NR_AGENC  = CB804_NR_AGENC
					AND CB206_NR_CONTA  = CB804_NR_CONTA
					AND CB206_NR_REMESS = CB804_NR_SEQARQ
		
		
		/* ------------------- SELECIONA OS REGISTROS NA CB212 -----------------------*/
					
		INSERT INTO
			#TB05022_AUX
				
				SELECT  
					 CB804_DT_GERAC 
					,CB212_DT_CRED
					,CB212_VL_PAGO
					,0
				
				FROM
  					#TEMP_CB804 INNER JOIN CB212
		
				ON	
					CB212_CD_COMPSC = CB804_CD_COMPSC
					AND CB212_NR_AGENC  = CB804_NR_AGENC
					AND CB212_NR_CONTA  = CB804_NR_CONTA
					AND CB212_NR_REMESS = CB804_NR_SEQARQ
					AND CB212_DT_CRED  BETWEEN @ENT_DT_CREINI AND @ENT_DT_CREFIM
				
		
     END	
     
/* ------------------------------------------------------------------------------------------
              SOMA OS PAGAMENTOS AGRUPANDO POR DATA DE CRÉDITO E DATA DE MOVIMENTO
   ------------------------------------------------------------------------------------------ */   

		INSERT INTO	
			#TB05022
				
				SELECT  
					 CB804_DT_GERAC
					,CB206_DT_CRED
					,SUM(CB212_VL_REJ)
					,SUM(CB206_VL_PAGO)
					
				FROM
  					#TB05022_AUX
			
				GROUP BY 
  					 CB804_DT_GERAC 
  					,CB206_DT_CRED  


/* ------------------------------------------------------------------------------------------
              AJUSTA O RESULT SET PARA ORGANIZAÇÃO DOS DADOS NA TELA
   ------------------------------------------------------------------------------------------ */   

		IF ((@ENT_DT_MOVINI IS NOT NULL) 
			OR (@ENT_DT_MOVINI IS NOT NULL AND @ENT_DT_CREINI IS NOT NULL))
				
				SELECT
  					 CB214_DT_MOVTO
  					,CB214_DT_CRED
  					,CB214_VL_PAGREJ
  					,CB214_VL_VALOR1
	
				FROM
  					#TB05022
	
				ORDER BY
  					 CB214_DT_MOVTO
  					,CB214_DT_CRED  
  		
		ELSE
	
				SELECT
					 CB214_DT_CRED
					,CB214_DT_MOVTO
					,CB214_VL_PAGREJ
					,CB214_VL_VALOR1
				
				FROM
					#TB05022
	
				ORDER BY
					 CB214_DT_CRED  
					,CB214_DT_MOVTO 
		
  
	SET QUOTED_IDENTIFIER OFF
	SET ANSI_NULLS ON
	
/*-------------------------------------------------------------------------------
  RESULT SET:
  CB214_DT_MOVTO	(CB804)
  CB214_DT_CRED		(CB206 / CB212)
  CB214_VL_PAGREJ	(CB212)
  CB214_VL_VALOR1	(CB206 / CB212)
-------------------------------------------------------------------------------*/
GO  