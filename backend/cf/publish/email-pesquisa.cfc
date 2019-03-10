<cfcomponent rest="true" restPath="publish/email/pesquisa">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="pesquisaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-pesquisa'])>
        <cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_EM002
                WHERE
                    1 = 1

				AND EM002_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM002_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.EM002_NR_CPF") AND url.EM002_NR_CPF NEQ "">
					AND	EM002_NR_CPF = <cfqueryparam value = "#url.EM002_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.EM002_DT_REMESS") AND url.EM002_DT_REMESS NEQ "">
					AND	EM002_DT_REMESS = <cfqueryparam value = "#url.EM002_DT_REMESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM002_DT_REMESS ASC) AS ROW
					,EM002_NR_INST
					,EM002_CD_EMIEMP
					,EM002_NR_CPF
					,EM002_DT_REMESS
					,EM002_CD_CODEMAIL
					,EM055_DS_CODEMAIL
					,EM002_NR_DDD
					,EM002_NR_TEL
					,EM002_NR_DDD_TEL
					,EM002_NM_TEXTO
					,EM002_ID_SITUAC_LABEL
					,EM002_ID_STATUS_LABEL
					,EM002_NM_ANEXO
					,EM002_ID_IMG
				FROM
					VW_EM002
				WHERE
					1 = 1

				AND EM002_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM002_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.EM002_NR_CPF") AND url.EM002_NR_CPF NEQ "">
					AND	EM002_NR_CPF = <cfqueryparam value = "#url.EM002_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.EM002_DT_REMESS") AND url.EM002_DT_REMESS NEQ "">
					AND	EM002_DT_REMESS = <cfqueryparam value = "#url.EM002_DT_REMESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				ORDER BY
					EM002_DT_REMESS ASC	
                
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