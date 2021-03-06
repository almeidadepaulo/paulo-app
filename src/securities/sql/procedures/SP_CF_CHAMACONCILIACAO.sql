

-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CF_CHAMACONCILIACAO]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_CF_CHAMACONCILIACAO]
GO


CREATE PROCEDURE [dbo].[SP_CF_CHAMACONCILIACAO]
@NR_BANCO INT, @NOMEARQ VARCHAR(250), @MES VARCHAR(7), @DATAPAG DATETIME, @USUARIO VARCHAR(250)

WITH ENCRYPTION
AS

-- CONCILIA PELO CONTRATO
EXEC SP_CF_CONCILIACAO_CONTRATO
     @NR_BANCO , 
     @NOMEARQ, 
     @MES, 
     @DATAPAG,
     @USUARIO

-- CONCILIA PELO CPF
EXEC SP_CF_CONCILIACAO_CONTRATO
     @NR_BANCO , 
     @NOMEARQ, 
     @MES, 
     @DATAPAG,
     @USUARIO

GO


