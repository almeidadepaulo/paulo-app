

-- Configura Procedure
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- Apaga Procedure
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_CF_TOTAIS_MIGRACAO]') AND type in (N'P', N'PC'))
DROP PROCEDURE  [dbo].[SP_CF_TOTAIS_MIGRACAO]
GO

-- exec SP_CF_TOTAIS_MIGRACAO 1, 'TESTE_01'

CREATE PROCEDURE [dbo].[SP_CF_TOTAIS_MIGRACAO]
@NR_BANCO INT, @NOMEARQ VARCHAR(255)
WITH ENCRYPTION
AS
DECLARE @QT1 INT
DECLARE @TT1 DECIMAL(18,2)
DECLARE @P1  DECIMAL(18,2)
SET @P1 = 100.00

DECLARE @QT2 INT
DECLARE @TT2 DECIMAL(18,2)
DECLARE @P2  DECIMAL(18,2)

DECLARE @QT3 INT
DECLARE @TT3 DECIMAL(18,2)
DECLARE @P3  DECIMAL(18,2)



SELECT @QT1=COUNT(*), @TT1=SUM(VALOR)
FROM CF_001
WHERE NOMEARQ=@NOMEARQ AND NR_BANCO=@NR_BANCO
SET @QT1=ISNULL(@QT1,0)
SET @TT1=ISNULL(@TT1,0.00)

SELECT @QT2=COUNT(*), @TT2=SUM(VALOR)
FROM CF_001
WHERE NOMEARQ=@NOMEARQ AND NR_BANCO=@NR_BANCO AND (TPBAIXACFP=1 OR TPBAIXACFP=2)
SET @QT2=ISNULL(@QT2,0)
SET @TT2=ISNULL(@TT2,0.00)
IF( @QT1 > 0 )
BEGIN
  SET @P2 = (@QT2 * 100) / @QT1
END  

SELECT @QT3=COUNT(*), @TT3=SUM(VALOR)
FROM CF_001
WHERE NOMEARQ=@NOMEARQ AND NR_BANCO=@NR_BANCO AND TPBAIXACFP>2
SET @QT3=ISNULL(@QT3,0)
SET @TT3=ISNULL(@TT3,0.00)
IF( @QT1 > 0 )
BEGIN
  SET @P3 = (@QT3 * 100) / @QT1
END  





SELECT @QT1 qt1, @TT1 tt1, @P1 p1,
       @QT2 qt2, @TT2 tt2, @P2 p2,
       @QT3 qt3, @TT3 tt3, @P3 p3


GO

