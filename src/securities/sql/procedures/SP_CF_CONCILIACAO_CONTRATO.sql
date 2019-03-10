

-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CF_CONCILIACAO_CONTRATO]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_CF_CONCILIACAO_CONTRATO]
GO


-- EXEC SP_CF_CONCILIACAO_CPF 1, 'TESTE_01_PEDRO', '10/2012', '2013/10/24', 'BRUNO'
CREATE PROCEDURE [dbo].[SP_CF_CONCILIACAO_CONTRATO] 
@NR_BANCO INT, @NOMEARQ VARCHAR(250), @MES VARCHAR(7), @DATAPAG DATETIME, @USUARIO VARCHAR(250)

WITH ENCRYPTION
AS

SELECT NR_ENT FROM CF_001 WHERE NOMEARQ=@NOMEARQ GROUP BY NR_ENT
SELECT @@ROWCOUNT

IF( @@ROWCOUNT = 1 ) 
BEGIN

    DECLARE @NR_ENT INT
    SELECT TOP 1 @NR_ENT=NR_ENT FROM CF_001 WHERE NOMEARQ=@NOMEARQ

    EXEC SP_CF_PREPARA_MATRICULAS
    @NR_BANCO , @NOMEARQ , @NR_ENT 

	DECLARE @KNR_CONTRA VARCHAR(40)

	SELECT TOP 1 @NR_ENT=NR_ENT FROM CF_001 WHERE NOMEARQ=@NOMEARQ
	
	EXEC SP_CF_PREPARA_MATRICULAS @NR_BANCO, @NOMEARQ, @NR_ENT

	DECLARE @AUX VARCHAR(8)
	DECLARE @AUXD DATETIME

	DECLARE @IDATA INT
	DECLARE @FDATA INT

	SET @AUX=SUBSTRING(@MES,4,4) + SUBSTRING(@MES,1,2) + '01'
	SET @IDATA=CONVERT(INT,@AUX)  -- PRIMEIRO DIA DO MES @MES

	SET @AUXD = CONVERT( datetime, @AUX )
	SET @AUXD = DATEADD(mm,1,@AUXD)
	SELECT @AUX=CONVERT(CHAR(10),@AUXD,102)
	SET @AUX=REPLACE(@AUX,'/','')
	SET @AUX=REPLACE(@AUX,'-','')
	SET @AUX=REPLACE(@AUX,'.','')
	SET @AUX=SUBSTRING(@AUX,1,6)+'01'
	SET @FDATA=CONVERT(INT,@AUX)  -- PRIMEIRO DIA DO MES SEGUINTE A @MES


	-- CAMPOS DO ARQUIVO MIGRADO
	DECLARE @KCF_001_NR_CONTRA VARCHAR(40)
	DECLARE @KCF_001_NR_CNPJ NUMERIC(14,0)
	DECLARE @KCF_001_VALOR NUMERIC(18,2)
	DECLARE @KCF_001_NSEQ INT

	-- CAHAVE DA PARCELA
	DECLARE @KBKN011_NR_BANCO NUMERIC(8,0)
	DECLARE @KBKN011_NR_CESS NUMERIC(8,0)
	DECLARE @KBKN011_NR_CONTRA VARCHAR(40)
	DECLARE @KBKN011_DT_VENCTO NUMERIC(8,0)
	DECLARE @KBKN011_NR_SEQ NUMERIC(8,0)
	

	-- FLAG DE LOOP
	DECLARE @LFAZ BIT

	-- CRITICA 9 - CPFS N�O ENCONTRADOS NA TABELA DE CONTRATOS (BKN010)
	update CF_001
	SET CF_001.TPBAIXACFP=9,
		CF_001.OBS='N�o encontrado na tabela de CONTRATOS (BKN010)'
	WHERE 
	CF_001.NOMEARQ=@NOMEARQ AND
	CF_001.TPBAIXACFP=0 AND
	ISNULL(CF_001.NR_CONTRA,'') <> '' AND
	CF_001.NR_ENT = @NR_ENT AND
	NOT EXISTS
		(SELECT C.BKN010_NR_CONTRA 
		 FROM BKN010 C 
		 WHERE 
		 C.BKN010_NR_BANCO = @NR_BANCO AND
		 C.BKN010_NR_CONTRA = CF_001.NR_CONTRA )

	DECLARE NAVEGA_ CURSOR LOCAL FAST_FORWARD FOR
	select A.NSEQ, A.NR_CONTRA, A.VALOR  
	from CF_001 A
	WHERE A.NOMEARQ=@NOMEARQ AND @NR_BANCO=@NR_BANCO 
		  AND ISNULL(A.NR_CONTRA,'') <> ''
		  AND A.TPBAIXACFP=0
		  AND A.NR_ENT = @NR_ENT
	OPEN NAVEGA_
	FETCH NEXT FROM NAVEGA_
	INTO @KCF_001_NSEQ, @KCF_001_NR_CONTRA, @KCF_001_VALOR
	WHILE @@FETCH_STATUS = 0
	BEGIN
	  ---- SE ACHOU NA TABELA DE CONTRATOS, DEFINE O CONTRATO PELA PARCELA
	  SET @LFAZ = 1
	  DECLARE NAVEGA_1 CURSOR LOCAL FAST_FORWARD FOR
	  SELECT BKN010_NR_CESS, 
			 BKN010_NR_CONTRA
	  FROM BKN010
	  WHERE BKN010_NR_BANCO=@NR_BANCO AND
			BKN010_NR_CONTRA = @KCF_001_NR_CONTRA AND 
			BKN010_VL_PARC   = @KCF_001_VALOR AND
			BKN010_NR_ENT    = @NR_ENT
	  OPEN NAVEGA_1
	  FETCH NEXT FROM NAVEGA_1
	  INTO @KBKN011_NR_CESS , @KBKN011_NR_CONTRA
	  WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
	  BEGIN
	  
		IF NOT EXISTS
		(     
			SELECT BKN011_DT_VENCTO,
				   BKN011_NR_SEQ
			FROM BKN011
			WHERE BKN011_NR_BANCO = @NR_BANCO AND
				  BKN011_NR_CESS  = @KBKN011_NR_CESS AND
				  BKN011_NR_CONTRA = @KBKN011_NR_CONTRA AND
				  BKN011_NR_ENT = @NR_ENT
		)
		
		BEGIN
		  
			  -- CRITICA 10 - N�O ENCONTROU CONTRATO NAS PARCELAS (BKN011)
			  UPDATE CF_001
			  SET TPBAIXACFP=10,
				  NR_CESSP   = @KBKN011_NR_CESS,
				  NR_CONTRAP = @KBKN011_NR_CONTRA,
				  DATAATU    = GETDATE(),
				  USUARIO    = @USUARIO,
				  OBS        = 'N�O encontrou o CONTRATO/CESS�O na tabela de PARCELAS (BKN011)'
			  WHERE NSEQ = @KCF_001_NSEQ    
		END
	  
	  
		-- NAVEGA NAS PARCELAS EM ABERTO DENTRO DO VENCIMENTO ESPERADO
		IF( @LFAZ = 1 )
		BEGIN
			DECLARE NAVEGA_2 CURSOR LOCAL FAST_FORWARD FOR
			SELECT BKN011_DT_VENCTO,
				   BKN011_NR_SEQ
			FROM BKN011
			WHERE BKN011_NR_BANCO = @NR_BANCO AND
				  BKN011_NR_CESS  = @KBKN011_NR_CESS AND
				  BKN011_NR_CONTRA = @KBKN011_NR_CONTRA AND
				  BKN011_DT_VENCTO >= @IDATA AND BKN011_DT_VENCTO < @FDATA AND
				  BKN011_ST_PAGTO = 'N' AND
				  BKN011_VL_PARC = @KCF_001_VALOR AND
				  BKN011_NR_ENT = @NR_ENT
				  AND
				  NOT EXISTS
				  (SELECT * FROM CF_001 
				   WHERE 
				   BKN011.BKN011_NR_CESS = CF_001.NR_CESSP AND
				   BKN011.BKN011_NR_CONTRA = CF_001.NR_CONTRAP AND
				   BKN011.BKN011_DT_VENCTO = CF_001.DT_VENCTOP AND
				   BKN011.BKN011_NR_SEQ = CF_001.NR_SEQP)
				   
				  
			ORDER BY BKN011_DT_VENCTO      
			OPEN NAVEGA_2
			FETCH NEXT FROM NAVEGA_2
			INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
			BEGIN
			  -- BAIXA TIPO 2 - PRIMEIRO VENCIMENTO NO PERIODO ESPERADO EM ABERTO,
			  --                ENCONTRADO PELO CPF
			  UPDATE CF_001
			  SET VALOR_PAGO=@KCF_001_VALOR,
				  DATAPAGTO=@DATAPAG,
				  TPBAIXACFP=1,
				  NR_CESSP   = @KBKN011_NR_CESS,
				  NR_CONTRAP = @KBKN011_NR_CONTRA,
				  DT_VENCTOP = @KBKN011_DT_VENCTO,
				  NR_SEQP    = @KBKN011_NR_SEQ,
				  DATAATU    = GETDATE(),
				  USUARIO    = @USUARIO,
				  OBS        = 'BAIXADO pelo primeiro vencimento em aberto do PERIODO ESPERADO'
			  WHERE NSEQ = @KCF_001_NSEQ    
			  SET @LFAZ=0    
			  FETCH NEXT FROM NAVEGA_2
			  INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			END  
			CLOSE NAVEGA_2
			DEALLOCATE  NAVEGA_2
		END
	          

		-- NAVEGA NAS PARCELAS EM ABERTO FORA DO VENCIMENTO ESPERADO
		IF( @LFAZ = 1 )
		BEGIN      
			DECLARE NAVEGA_2 CURSOR LOCAL FAST_FORWARD FOR
			SELECT BKN011_DT_VENCTO,
				   BKN011_NR_SEQ
			FROM BKN011
			WHERE BKN011_NR_BANCO = @NR_BANCO AND
				  BKN011_NR_CESS  = @KBKN011_NR_CESS AND
				  BKN011_NR_CONTRA = @KBKN011_NR_CONTRA AND
				  BKN011_ST_PAGTO = 'N' AND
				  BKN011_VL_PARC = @KCF_001_VALOR AND
				  BKN011_NR_ENT = @NR_ENT
				  AND
				  NOT EXISTS
				  (SELECT * FROM CF_001 
				   WHERE 
				   BKN011.BKN011_NR_CESS = CF_001.NR_CESSP AND
				   BKN011.BKN011_NR_CONTRA = CF_001.NR_CONTRAP AND
				   BKN011.BKN011_DT_VENCTO = CF_001.DT_VENCTOP AND
				   BKN011.BKN011_NR_SEQ = CF_001.NR_SEQP)
			ORDER BY BKN011_DT_VENCTO      
			OPEN NAVEGA_2
			FETCH NEXT FROM NAVEGA_2
			INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
			BEGIN
			  -- BAIXA TIPO 3 - PRIMEIRO VENCIMENTO EM ABERTO ENCONTRADO PELO CPF
			  UPDATE CF_001
			  SET VALOR_PAGO=@KCF_001_VALOR,
				  DATAPAGTO=@DATAPAG,
				  TPBAIXACFP=2,
				  NR_CESSP   = @KBKN011_NR_CESS,
				  NR_CONTRAP = @KBKN011_NR_CONTRA,
				  DT_VENCTOP = @KBKN011_DT_VENCTO,
				  NR_SEQP    = @KBKN011_NR_SEQ,
				  DATAATU    = GETDATE(),
				  USUARIO    = @USUARIO,
				  OBS        = 'BAIXADO pelo primeiro vencimento em aberto encontrado'
			  WHERE NSEQ = @KCF_001_NSEQ    
			  SET @LFAZ=0    
			  FETCH NEXT FROM NAVEGA_2
			  INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			END  
			CLOSE NAVEGA_2
			DEALLOCATE  NAVEGA_2
		END                
		FETCH NEXT FROM NAVEGA_1
		INTO @KBKN011_NR_CESS , @KBKN011_NR_CONTRA
	  END  
	  CLOSE NAVEGA_1
	  DEALLOCATE  NAVEGA_1
	  
	  FETCH NEXT FROM NAVEGA_
	  INTO @KCF_001_NSEQ, @KCF_001_NR_CONTRA, @KCF_001_VALOR
	END
	CLOSE NAVEGA_
	DEALLOCATE  NAVEGA_

	     
	---- ENCONTRADO QUITADO COM O MESMO VALOR --------------------------------------------------------------------

	SET @LFAZ =1
	DECLARE NAVEGA_ CURSOR LOCAL FAST_FORWARD FOR
	select A.NSEQ, A.NR_CONTRA, A.VALOR  
	from CF_001 A
	WHERE A.NOMEARQ=@NOMEARQ AND @NR_BANCO=@NR_BANCO 
		  AND ISNULL(A.NR_CONTRA,'') <> ''
		  AND A.TPBAIXACFP=0
		  AND A.NR_ENT=@NR_ENT
	OPEN NAVEGA_
	FETCH NEXT FROM NAVEGA_
	INTO @KCF_001_NSEQ, @KCF_001_NR_CONTRA, @KCF_001_VALOR
	WHILE @@FETCH_STATUS = 0
	BEGIN
	  SET @LFAZ = 1
	  DECLARE NAVEGA_1 CURSOR LOCAL FAST_FORWARD FOR
	  SELECT BKN010_NR_CESS, 
			 BKN010_NR_CONTRA
	  FROM BKN010
	  WHERE BKN010_NR_BANCO=@NR_BANCO AND
			BKN010_NR_CONTRA  = @KCF_001_NR_CONTRA AND 
			BKN010_VL_PARC    = @KCF_001_VALOR AND
			BKN010_NR_ENT     = @NR_ENT
	  OPEN NAVEGA_1
	  FETCH NEXT FROM NAVEGA_1
	  INTO @KBKN011_NR_CESS , @KBKN011_NR_CONTRA
	  WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
	  BEGIN

		IF( @LFAZ = 1 )
		BEGIN      
			DECLARE NAVEGA_2 CURSOR LOCAL FAST_FORWARD FOR
			SELECT BKN011_DT_VENCTO,
				   BKN011_NR_SEQ
			FROM BKN011
			WHERE BKN011_NR_BANCO = @NR_BANCO AND
				  BKN011_NR_CESS  = @KBKN011_NR_CESS AND
				  BKN011_NR_CONTRA = @KBKN011_NR_CONTRA AND
				  BKN011_ST_PAGTO = 'S' AND
				  BKN011_VL_PARC = @KCF_001_VALOR AND
				  BKN011_NR_ENT  = @NR_ENT AND
				  NOT EXISTS
				  (SELECT * FROM BKN011 
					WHERE BKN011_NR_BANCO = @NR_BANCO AND
					BKN011_NR_CESS  = @KBKN011_NR_CESS AND
					BKN011_NR_CONTRA = @KBKN011_NR_CONTRA AND
					BKN011_NR_ENT = @NR_ENT AND
					BKN011_VL_PARC = @KCF_001_VALOR AND
					BKN011_ST_PAGTO = 'N')
			ORDER BY BKN011_DT_VENCTO DESC      
			OPEN NAVEGA_2
			FETCH NEXT FROM NAVEGA_2
			INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
			BEGIN
			  -- CRITICA 11 - ENCONTROU CONTRATO QUITADO
			  UPDATE CF_001
			  SET TPBAIXACFP=11,
				  NR_CESSP   = @KBKN011_NR_CESS,
				  NR_CONTRAP = @KBKN011_NR_CONTRA,
				  DT_VENCTOP = @KBKN011_DT_VENCTO, -- ULTIMO VENCIMENTO
				  DATAATU    = GETDATE(),
				  USUARIO    = @USUARIO,
				  OBS        = 'Encontrado com parcelas QUITADAS'
			  WHERE NSEQ = @KCF_001_NSEQ    
			  SET @LFAZ=0    
			  FETCH NEXT FROM NAVEGA_2
			  INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			END  
			CLOSE NAVEGA_2
			DEALLOCATE  NAVEGA_2
		END                
		FETCH NEXT FROM NAVEGA_1
		INTO @KBKN011_NR_CESS , @KBKN011_NR_CONTRA
	  END  
	  CLOSE NAVEGA_1
	  DEALLOCATE  NAVEGA_1
	  
	  FETCH NEXT FROM NAVEGA_
	  INTO @KCF_001_NSEQ, @KCF_001_NR_CONTRA, @KCF_001_VALOR
	END
	CLOSE NAVEGA_
	DEALLOCATE  NAVEGA_

	-- ENCONTRAR PELO VALOR APROXIMADO 
	DECLARE @KVALOR2 DECIMAL(18,2)
	DECLARE @DIF DECIMAL(18,2)
	DECLARE @GVALOR DECIMAL(18,2)
	DECLARE @GNR_CESS NUMERIC(8,0)
	DECLARE @GNR_CONTRA VARCHAR(40)


	SET @LFAZ =1
	DECLARE NAVEGA_ CURSOR LOCAL FAST_FORWARD FOR
	select A.NSEQ, A.NR_CONTRA, A.VALOR  
	from CF_001 A
	WHERE A.NOMEARQ=@NOMEARQ AND @NR_BANCO=@NR_BANCO 
		  AND ISNULL(A.NR_CONTRA,'') <> '' 
		  AND A.TPBAIXACFP=0
		  AND A.NR_ENT= @NR_ENT
	OPEN NAVEGA_
	FETCH NEXT FROM NAVEGA_
	INTO @KCF_001_NSEQ, @KCF_001_NR_CONTRA, @KCF_001_VALOR
	WHILE @@FETCH_STATUS = 0
	BEGIN
	  SET @GVALOR = @KCF_001_VALOR
	  SET @LFAZ = 1
	  DECLARE NAVEGA_1 CURSOR LOCAL FAST_FORWARD FOR
	  SELECT BKN010_NR_CESS, 
			 BKN010_NR_CONTRA,
			 BKN010_VL_PARC
	  FROM BKN010
	  WHERE BKN010_NR_BANCO=@NR_BANCO AND
			BKN010_NR_CONTRA = @KCF_001_NR_CONTRA AND
			BKN010_VL_PARC <> @KCF_001_VALOR    AND
			BKN010_NR_ENT = @NR_ENT
	  OPEN NAVEGA_1
	  FETCH NEXT FROM NAVEGA_1
	  INTO @KBKN011_NR_CESS , @KBKN011_NR_CONTRA, @KVALOR2
	  WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
	  BEGIN
	  
		IF( @KVALOR2 > @KCF_001_VALOR )
		BEGIN
		  SET @DIF = @KVALOR2 - @KCF_001_VALOR
		END
	    
		IF( @KVALOR2 < @KCF_001_VALOR )
		BEGIN
		  SET @DIF = @KCF_001_VALOR -  @KVALOR2
		END
	    
		SET @DIF=ABS(@DIF)
	    
		IF( @DIF < @GVALOR )
		BEGIN
		  SET @GVALOR     = @KVALOR2
		  SET @GNR_CESS   = @KBKN011_NR_CESS
		  SET @GNR_CONTRA = @KBKN011_NR_CONTRA
		END
	  
		FETCH NEXT FROM NAVEGA_1
		INTO @KBKN011_NR_CESS , @KBKN011_NR_CONTRA, @KVALOR2
	  END  
	  CLOSE NAVEGA_1
	  DEALLOCATE  NAVEGA_1
	  
	  
	  -- VALOR APROXIMADO DENTRO DO PERIODO ESPERADO
	  IF( @GVALOR <> @KCF_001_VALOR )
	  BEGIN
		SET @LFAZ=1
	    
	    
		DECLARE NAVEGA_1 CURSOR LOCAL FAST_FORWARD FOR
		SELECT BKN011.BKN011_DT_VENCTO,
			   BKN011.BKN011_NR_SEQ
		FROM BKN011
		WHERE BKN011.BKN011_NR_BANCO=@NR_BANCO AND
			  BKN011.BKN011_NR_CESS=@GNR_CESS AND
			  BKN011.BKN011_NR_CONTRA=@GNR_CONTRA AND
			  BKN011.BKN011_DT_VENCTO >= @IDATA AND BKN011.BKN011_DT_VENCTO < @FDATA AND
			  BKN011.BKN011_ST_PAGTO = 'N' AND
			  BKN011.BKN011_NR_ENT = @NR_ENT AND
			  BKN011_VL_PARC <> @KCF_001_VALOR 
			  
		ORDER BY BKN011.BKN011_DT_VENCTO
		OPEN NAVEGA_1
		FETCH NEXT FROM NAVEGA_1
		INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
		WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
		BEGIN
			  -- CRITICA 12 - ENCONTROU APROXIMADO EM ABERTO DENTRO DO MES ESPERADO
			  UPDATE CF_001
			  SET TPBAIXACFP=12,
				  NR_CESSP   = @GNR_CESS,
				  NR_CONTRAP = @GNR_CONTRA,
				  DT_VENCTOP = @KBKN011_DT_VENCTO,
				  DATAATU    = GETDATE(),
				  USUARIO    = @USUARIO,
				  VALOR_APROXIMADO = @GVALOR,
				  OBS        = 'VALOR APROXIMADO em aberto ABERTO dentro do PERIODO ESPERADO'
			  WHERE NSEQ = @KCF_001_NSEQ   
			  SET @LFAZ = 0 
		
		  FETCH NEXT FROM NAVEGA_1
		  INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
		END
		CLOSE NAVEGA_1
		DEALLOCATE  NAVEGA_1
	    
		-- APROXIMADO ABERTO FORA DO PERIODO    
		IF( @LFAZ = 1 )
		BEGIN
	    
			DECLARE NAVEGA_1 CURSOR LOCAL FAST_FORWARD FOR
			SELECT BKN011.BKN011_DT_VENCTO,
				   BKN011.BKN011_NR_SEQ
			FROM BKN011
			WHERE BKN011.BKN011_NR_BANCO=@NR_BANCO AND
				  BKN011.BKN011_NR_CESS=@GNR_CESS AND
				  BKN011.BKN011_NR_CONTRA=@GNR_CONTRA AND
				  BKN011.BKN011_ST_PAGTO = 'N' AND
				  BKN011_NR_ENT = @NR_ENT AND
				  BKN011_VL_PARC <> @KCF_001_VALOR 
			ORDER BY BKN011.BKN011_DT_VENCTO
			OPEN NAVEGA_1
			FETCH NEXT FROM NAVEGA_1
			INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
			BEGIN
				  -- CRITICA 13 - ENCONTROU APROXIMADO EM ABERTO FORA DO MES
				  UPDATE CF_001
				  SET TPBAIXACFP=13,
					  NR_CESSP   = @GNR_CESS,
					  NR_CONTRAP = @GNR_CONTRA,
					  DT_VENCTOP = @KBKN011_DT_VENCTO,
					  DATAATU    = GETDATE(),
					  USUARIO    = @USUARIO,
					  VALOR_APROXIMADO = @GVALOR,
					  OBS = 'VALOR APROXIMADO em ABERTO FORA do PERIODO ESPERADO'

				  WHERE NSEQ = @KCF_001_NSEQ   
				  SET @LFAZ = 0 
			
			  FETCH NEXT FROM NAVEGA_1
			  INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			END
			CLOSE NAVEGA_1
			DEALLOCATE  NAVEGA_1
		END
	    
	    
		-- APROXIMADO QUITADO
		IF( @LFAZ = 1 )
		BEGIN
			DECLARE NAVEGA_1 CURSOR LOCAL FAST_FORWARD FOR
			SELECT BKN011.BKN011_DT_VENCTO,
				   BKN011.BKN011_NR_SEQ
			FROM BKN011
			WHERE BKN011.BKN011_NR_BANCO=@NR_BANCO AND
				  BKN011.BKN011_NR_CESS=@GNR_CESS AND
				  BKN011.BKN011_NR_CONTRA=@GNR_CONTRA AND
				  BKN011_VL_PARC <> @KCF_001_VALOR AND
				  BKN011.BKN011_ST_PAGTO = 'S' AND
				  BKN011.BKN011_NR_ENT=@NR_ENT AND
				  NOT EXISTS
				  (SELECT * FROM BKN011 
					WHERE BKN011_NR_BANCO = @NR_BANCO AND
					BKN011_NR_CESS  = @GNR_CESS AND
					BKN011_NR_CONTRA = @GNR_CONTRA AND
					BKN011_VL_PARC <> @KCF_001_VALOR AND
					BKN011_ST_PAGTO = 'N')
			OPEN NAVEGA_1
			FETCH NEXT FROM NAVEGA_1
			INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			WHILE @@FETCH_STATUS = 0 AND @LFAZ = 1
			BEGIN
				  -- CRITICA 14 - ENCONTROU APROXIMADO QUITADO
				  UPDATE CF_001
				  SET TPBAIXACFP=14,
					  NR_CESSP   = @GNR_CESS,
					  NR_CONTRAP = @GNR_CONTRA,
					  DT_VENCTOP = @KBKN011_DT_VENCTO,
					  DATAATU    = GETDATE(),
					  USUARIO    = @USUARIO,
					  VALOR_APROXIMADO = @GVALOR,
					  OBS = 'VALOR APROXIMADO em QUITADO'
				  WHERE NSEQ = @KCF_001_NSEQ   
				  SET @LFAZ = 0 
			
			  FETCH NEXT FROM NAVEGA_1
			  INTO @KBKN011_DT_VENCTO , @KBKN011_NR_SEQ
			END
			CLOSE NAVEGA_1
			DEALLOCATE  NAVEGA_1
		END
	  END
	  
	  FETCH NEXT FROM NAVEGA_
	  INTO @KCF_001_NSEQ, @KCF_001_NR_CONTRA, @KCF_001_VALOR
	END
	CLOSE NAVEGA_
	DEALLOCATE  NAVEGA_

END

---------------
-- FIM DA CONCILACAO PELO CONTRATO

GO


