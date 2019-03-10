<cfcomponent rest="true" restPath="publish/email/variavel">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="variavelGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-variavel'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	EM060
                WHERE
                    1 = 1
				
				AND EM060_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- AND EM060_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> --->
				AND EM060_CD_EMIEMP = 0

                <cfif IsDefined("url.EM060_CD_VAR") AND url.EM060_CD_VAR NEQ "">
					AND	EM060_CD_VAR = <cfqueryparam value = "#url.EM060_CD_VAR#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.EM060_DS_VAR") AND url.EM060_DS_VAR NEQ "">
					AND	EM060_DS_VAR LIKE <cfqueryparam value = "%#url.EM060_DS_VAR#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM060_CD_VAR ASC) AS ROW
					,EM060_NR_INST
					,EM060_CD_EMIEMP
					,EM060_CD_VAR
					,EM060_DS_VAR
					,EM060_QT_CARAC
					,EM060_ID_ATIVO
				FROM
					EM060
				WHERE
					1 = 1
				
				AND EM060_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- AND EM060_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> --->
				AND EM060_CD_EMIEMP = 0

				<cfif IsDefined("url.EM060_CD_VAR") AND url.EM060_CD_VAR NEQ "">
					AND	EM060_CD_VAR = <cfqueryparam value = "#url.EM060_CD_VAR#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.EM060_DS_VAR") AND url.EM060_DS_VAR NEQ "">
					AND	EM060_DS_VAR LIKE <cfqueryparam value = "%#url.EM060_DS_VAR#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					EM060_CD_VAR ASC	
                
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