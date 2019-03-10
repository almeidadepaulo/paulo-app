<cfcomponent rest="true" restPath="publish/email/resumo">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="resumoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-resumo'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_EM003
                WHERE
                    1 = 1
			
				AND EM003_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM003_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
            
			    <cfif IsDefined("url.EM003_NR_BROKER") AND url.EM003_NR_BROKER NEQ "">
					AND	EM003_NR_BROKER = <cfqueryparam value = "#url.EM003_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM003_DT_MOVTO") AND url.EM003_DT_MOVTO NEQ "">
					AND	EM003_DT_MOVTO = <cfqueryparam value = "#url.EM003_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM003_NR_BROKER ASC) AS ROW
					,EM003_NR_INST
					,EM003_CD_EMIEMP
					,EM003_NR_BROKER
					,EM003_DT_MOVTO
					,EM003_TT_MENSO
					,EM003_TT_MENSN
					,EM003_TT_MENS
					,EM003_VL_VALOR
				FROM
					VW_EM003
				WHERE
					1 = 1
				
				AND EM003_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM003_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
                
				<cfif IsDefined("url.EM003_NR_BROKER") AND url.EM003_NR_BROKER NEQ "">
					AND	EM003_NR_BROKER = <cfqueryparam value = "#url.EM003_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM003_DT_MOVTO") AND url.EM003_DT_MOVTO NEQ "">
					AND	EM003_DT_MOVTO = <cfqueryparam value = "#url.EM003_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				ORDER BY
					EM003_NR_BROKER ASC	
                
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