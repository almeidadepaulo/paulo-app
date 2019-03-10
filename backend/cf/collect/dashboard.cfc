<cfcomponent rest="true" restPath="collect/dashboard">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="mes" access="remote" returntype="String" httpmethod="GET" restPath="/entrada"> 

		<cfset checkAuthentication(state = ['dashboard'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

            <!---
			<cfquery datasource="#application.datasource#" name="queryEntrada">
                SELECT
                    SUM(CB209_VL_VALOR) AS VALOR
                    ,SUM(CB209_QT_TOTAL) AS QUATIDADE
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 1, 4) * 1 AS ANO
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 5, 2) * 1 AS MES
                FROM
                    CB209
                WHERE
                    CB209_NR_OPERADOR = 800
                AND CB209_NR_CEDENTE = 8002
                
                <!--- 
                    2 : Entrada 
                    3 : Pagos
                    4 : Baixados
                --->
                AND CB209_ID_TIPOAC = 2

                GROUP BY
                    SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 1, 4) * 1
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 5, 2) * 1

                ORDER BY
                    SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 1, 4) * 1
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 5, 2) * 1
            </cfquery>
            

            <cfquery datasource="#application.datasource#" name="queryTituloCarteira">
                SELECT
                    SUM(CB209_VL_VALOR) AS VALOR
                    ,SUM(CB209_QT_TOTAL) AS QUATIDADE
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 1, 4) * 1 AS ANO
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 5, 2) * 1 AS MES
                    
                    ,CB256_DS_CART AS CARTEIRA
                FROM
                    CB209

                INNER JOIN CB256 AS CB256
                ON CB256.CB256_NR_OPERADOR = CB209_NR_OPERADOR
                AND CB256.CB256_NR_CEDENTE = 0
                AND CB256.CB256_CD_CART = CB209_CD_CART

                WHERE
                    CB209_NR_OPERADOR = 212
                AND CB209_NR_CEDENTE = 2121
                AND CB209_ID_TIPOAC = 2 /* ENTRADAS */

                GROUP BY
                    SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 1, 4) * 1
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 5, 2) * 1
                    ,CB256_DS_CART

                ORDER BY
                    SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 1, 4) * 1
                    ,SUBSTRING(Cast(CB209_DT_MOVTO as varchar), 5, 2) * 1
                    ,CB256_DS_CART
            </cfquery>
            --->

            <!--- FAKE --->
            <cfset queryEntrada = QueryNew("VALOR, QUANTIDADE, ANO, MES", "Double, Integer, Integer, Integer")>
            <cfset newRow = QueryAddRow(queryEntrada, 12)>

            <cfset queryPago = QueryNew("VALOR, QUANTIDADE, ANO, MES", "Double, Integer, Integer, Integer")>
            <cfset newRow = QueryAddRow(queryPago, 12)>

            <cfset queryBaixa = QueryNew("VALOR, QUANTIDADE, ANO, MES", "Double, Integer, Integer, Integer")>
            <cfset newRow = QueryAddRow(queryBaixa, 12)>

            <cfloop from="1" to="12" index="i"> 

                <cfset valor =  RandRange(400000000, 500000000, "SHA1PRNG") / 100 >
                <cfset quantidade = RandRange(350000, 380000, "SHA1PRNG")>

                <cfset temp = QuerySetCell(queryEntrada, "VALOR", valor, i)> 
                <cfset temp = QuerySetCell(queryEntrada, "QUANTIDADE", quantidade, i)> 
                <cfset temp = QuerySetCell(queryEntrada, "ANO", url.ano, i)> 
                <cfset temp = QuerySetCell(queryEntrada, "MES", i, i)>

                <cfif url.ano GTE year(now()) AND i GT month(now()) OR url.ano GT year(now())>
                    <cfset valorPago = 0>
                    <cfset quantidadePago = 0>
                <cfelse>
                    <cfset valorPago =  RandRange(380000000, 390000000, "SHA1PRNG") / 100 >
                    <cfset quantidadePago = RandRange(330000, 340000, "SHA1PRNG")>
                </cfif>
                
                <cfset temp = QuerySetCell(queryPago, "VALOR", valorPago, i)> 
                <cfset temp = QuerySetCell(queryPago, "QUANTIDADE", quantidadePago, i)> 
                <cfset temp = QuerySetCell(queryPago, "ANO", url.ano, i)> 
                <cfset temp = QuerySetCell(queryPago, "MES", i, i)>

               <cfif url.ano GTE year(now()) AND i GT month(now()) OR url.ano GT year(now())>
                    <cfset valorBaixa = 0>
                    <cfset quantidadeBaixa = 0>
                <cfelse>
                    <cfset valorBaixa = valor - valorPago>
                    <cfset quantidadeBaixa = quantidade - quantidadePago>
                </cfif>

                <cfset temp = QuerySetCell(queryBaixa, "VALOR", valorBaixa, i)> 
                <cfset temp = QuerySetCell(queryEntrada, "QUANTIDADE", quantidade, i)> 
                <cfset temp = QuerySetCell(queryBaixa, "QUANTIDADE", quantidadeBaixa, i)> 
                <cfset temp = QuerySetCell(queryBaixa, "ANO", url.ano, i)> 
                <cfset temp = QuerySetCell(queryBaixa, "MES", i, i)>

            </cfloop>

            <cfquery datasource="#application.datasource#" name="queryTituloCarteira">
                SELECT
                    CB256_DS_CART AS CARTEIRA
                    ,0 AS QUANTIDADE
                    ,0.10 AS VALOR
                FROM
                    CB256
                WHERE
                    CB256_NR_OPERADOR = 212
                AND CB256_NR_CEDENTE = 0
            </cfquery>

            <cfset tituloCarteiraQuantidade = 0>
            <cfset tituloCarteiraValor = 0>
            
            <cfloop query="queryTituloCarteira">
                <cfset queryTituloCarteira.QUANTIDADE = RandRange(400000, 550000 * RandRange(1, 4 , "SHA1PRNG"), "SHA1PRNG")>
                <cfset queryTituloCarteira.VALOR = RandRange(400000000, 450000000 * RandRange(1, 4 , "SHA1PRNG"), "SHA1PRNG") / 9>                                

                <cfset tituloCarteiraQuantidade = tituloCarteiraQuantidade + queryTituloCarteira.QUANTIDADE>
                <cfset tituloCarteiraValor = tituloCarteiraValor + queryTituloCarteira.VALOR>
            </cfloop>

            <!--- /FAKE --->

            <cfset response["queryEntrada"] = queryEntrada>
            <cfset response["queryPago"] = queryPago>
            <cfset response["queryBaixa"] = queryBaixa>    

            <cfset response["tag"] = RandRange(5000000, 7000000, "SHA1PRNG")>           

             <cfset response["queryTituloCarteira"] = queryTituloCarteira>
             <cfset response["tituloCarteiraQuantidade"] = tituloCarteiraQuantidade>
             <cfset response["tituloCarteiraValor"] = tituloCarteiraValor>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>
</cfcomponent>