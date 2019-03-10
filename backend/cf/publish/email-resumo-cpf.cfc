<cfcomponent rest="true" restPath="publish/email/resumo-cpf">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="resumoCpfGet" access="remote" returntype="String" httpmethod="GET"> 
				
		<cfset checkAuthentication(state = ['email-resumo-cpf'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_EM004
                WHERE
                    1 = 1

				AND EM004_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM004_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.EM004_NR_BROKER") AND url.EM004_NR_BROKER NEQ "">
					AND	EM004_NR_BROKER = <cfqueryparam value = "#url.EM004_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM004_NR_CPF") AND url.EM004_NR_CPF NEQ "">
					AND	EM004_NR_CPF = <cfqueryparam value = "#url.EM004_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.EM004_DT_MOVTO") AND url.EM004_DT_MOVTO NEQ "">
					AND	EM004_DT_MOVTO = <cfqueryparam value = "#url.EM004_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM004_NR_BROKER ASC) AS ROW
					,EM004_NR_INST
					,EM004_CD_EMIEMP
					,EM004_NR_BROKER
					,EM004_NR_CPF
					,EM004_DT_MOVTO
					,EM004_TT_MENSO
					,EM004_TT_MENSN
					,EM004_TT_MENS
				FROM
					VW_EM004
				WHERE
					1 = 1
	
				AND EM004_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM004_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.EM004_NR_BROKER") AND url.EM004_NR_BROKER NEQ "">
					AND	EM004_NR_BROKER = <cfqueryparam value = "#url.EM004_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM004_NR_CPF") AND url.EM004_NR_CPF NEQ "">
					AND	EM004_NR_CPF = <cfqueryparam value = "#url.EM004_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.EM004_DT_MOVTO") AND url.EM004_DT_MOVTO NEQ "">
					AND	EM004_DT_MOVTO = <cfqueryparam value = "#url.EM004_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				ORDER BY
					EM004_NR_BROKER ASC	
                
                <!--- Paginação --->
                OFFSET #URL.page * URL.limit - URL.limit# ROWS
                FETCH NEXT #URL.limit# ROWS ONLY;
            </cfquery>
		
			
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

</cfcomponent>