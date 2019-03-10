<cfcomponent rest="true" restPath="collect/sacado">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="sacadoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sacado'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB201_SACADO
                WHERE
                    1 = 1

				AND CB201_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB201_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB201_NR_CPFCNPJ") AND url.CB201_NR_CPFCNPJ NEQ "">
					AND	CB201_NR_CPFCNPJ LIKE <cfqueryparam value = "%#url.CB201_NR_CPFCNPJ#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB201_NM_NMSAC") AND url.CB201_NM_NMSAC NEQ "">
					AND	CB201_NM_NMSAC LIKE <cfqueryparam value = "%#url.CB201_NM_NMSAC#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  	

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB201_NR_CPFCNPJ ASC) AS ROW
					,CB201_NR_OPERADOR
					,CB201_NR_CEDENTE
					,CB201_NR_CPFCNPJ
					,CB201_NM_NMSAC
					,CB201_NR_DDD
					,CB201_NR_CEL
					,CB201_NM_EMAIL
				FROM
					VW_CB201_SACADO
				WHERE
					1 = 1

				AND CB201_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB201_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB201_NR_CPFCNPJ") AND url.CB201_NR_CPFCNPJ NEQ "">
					AND	CB201_NR_CPFCNPJ LIKE <cfqueryparam value = "%#url.CB201_NR_CPFCNPJ#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB201_NM_NMSAC") AND url.CB201_NM_NMSAC NEQ "">
					AND	CB201_NM_NMSAC LIKE <cfqueryparam value = "%#url.CB201_NM_NMSAC#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
				
				ORDER BY
					CB201_NR_CPFCNPJ ASC	
                
                <!--- Paginação --->
                OFFSET #URL.page * URL.limit - URL.limit# ROWS
                FETCH NEXT #URL.limit# ROWS ONLY;
            </cfquery>	
		
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>
</cfcomponent>