<cfcomponent rest="true" restPath="/epaybox/agenda">  
	<cfinclude template="../util.cfm">
	
	<cffunction name="vencimento" access="remote" returntype="String" httpmethod="GET" restpath="/range"> 
                
		<cfset response = structNew()>
		
		<cfset response["url"] = url>

        <cfset arguments.cpf = NumberFormat(session.cpf , "00000000000000")>

		<cfset url.dateFrom = ISOToDateTime(url.dateFrom)>
		<cfset url.dateTo = ISOToDateTime(url.dateTo)>

		<cfset url.dateFrom = LSDateFormat(url.dateFrom , "YYYYMMDD")>
		<cfset url.dateTo = LSDateFormat(url.dateTo , "YYYYMMDD")>

		<cfquery datasource="#application.datasource#" name="query">
			SELECT
				COUNT(1) AS COUNT
				,SUM(CB210_VL_VALOR) AS CB210_VL_VALOR
				,CB210_DT_VCTO
			FROM
				CB210

            INNER JOIN CB255
            ON CB255.CB255_NR_OPERADOR = CB210.CB210_NR_OPERADOR
            AND CB255.CB255_NR_CEDENTE = CB210.CB210_NR_CEDENTE
            AND CB255.CB255_CD_PROD =  CB210.CB210_NR_PRODUT

			WHERE
				CB210_NR_CPFCNPJ = <cfqueryPARAM value = "#arguments.cpf#" CFSQLType = 'CF_SQL_VARCHAR'>  
            AND CB210_DT_VCTO BETWEEN <cfqueryPARAM value = "#url.dateFrom#" CFSQLType = 'CF_SQL_NUMERIC'>
			AND <cfqueryPARAM value = "#url.dateTo#" CFSQLType = 'CF_SQL_NUMERIC'>

			GROUP BY
				CB210_DT_VCTO
        </cfquery>
				
		<cfset response["query"] = queryToArray(query)>

		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

</cfcomponent>
