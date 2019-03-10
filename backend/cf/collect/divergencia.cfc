<cfcomponent rest="true" restPath="collect/divergencia">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="divergenciaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['divergencia'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB057
                WHERE
                    1 = 1

				AND CB057_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB057_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB057_DT_MOVTO") AND url.CB057_DT_MOVTO NEQ "">
					AND	CB057_DT_MOVTO = <cfqueryparam value = "#url.CB057_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
			
				<cfif IsDefined("url.CB057_NR_BANCO") AND url.CB057_NR_BANCO NEQ "">
					AND	CB057_NR_BANCO = <cfqueryparam value = "#url.CB057_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
				
				<cfif IsDefined("url.CB057_NR_AGENC") AND url.CB057_NR_AGENC NEQ "">
					AND	CB057_NR_AGENC = <cfqueryparam value = "#url.CB057_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
			
				<cfif IsDefined("url.CB057_NR_CONTA") AND url.CB057_NR_CONTA NEQ "">
					AND	CB057_NR_CONTA = <cfqueryparam value = "#url.CB057_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
				
				<cfif IsDefined("url.CB057_NR_CONTRA") AND url.CB057_NR_CONTRA NEQ "">
					AND	CB057_NR_CONTRA LIKE <cfqueryparam value = "%#url.CB057_NR_CONTRA#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.CB057_NR_NOSNUM") AND url.CB057_NR_NOSNUM NEQ "">
					AND	CB057_NR_NOSNUM LIKE <cfqueryparam value = "%#url.CB057_NR_NOSNUM#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB057_DT_MOVTO ASC) AS ROW
					,CB057_NR_OPERADOR
					,CB057_NR_CEDENTE
					,CB057_DT_MOVTO
					,CB057_NR_BANCO
					,CB057_NR_AGENC
					,CB057_NR_CONTA
					,CB057_NR_CONTRA
					,CB057_NR_NOSNUM
					,CB057_VL_TITUORI
					,CB057_VL_TITUREC
					,CB057_VL_DEVORI
					,CB057_VL_DEVREC
					,CB057_VL_TARNCONT
					,CB057_VL_TARNCOBR
					,CB057_VL_TARATCONT
					,CB057_VL_TARATCOBR
				FROM
					CB057
				WHERE
					1 = 1

				AND CB057_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB057_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB057_DT_MOVTO") AND url.CB057_DT_MOVTO NEQ "">
					AND	CB057_DT_MOVTO = <cfqueryparam value = "#url.CB057_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
			
				<cfif IsDefined("url.CB057_NR_BANCO") AND url.CB057_NR_BANCO NEQ "">
					AND	CB057_NR_BANCO = <cfqueryparam value = "#url.CB057_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
				
				<cfif IsDefined("url.CB057_NR_AGENC") AND url.CB057_NR_AGENC NEQ "">
					AND	CB057_NR_AGENC = <cfqueryparam value = "#url.CB057_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
			
				<cfif IsDefined("url.CB057_NR_CONTA") AND url.CB057_NR_CONTA NEQ "">
					AND	CB057_NR_CONTA = <cfqueryparam value = "#url.CB057_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
				
				<cfif IsDefined("url.CB057_NR_CONTRA") AND url.CB057_NR_CONTRA NEQ "">
					AND	CB057_NR_CONTRA LIKE <cfqueryparam value = "%#url.CB057_NR_CONTRA#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.CB057_NR_NOSNUM") AND url.CB057_NR_NOSNUM NEQ "">
					AND	CB057_NR_NOSNUM LIKE <cfqueryparam value = "%#url.CB057_NR_NOSNUM#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
				
				ORDER BY
					CB057_DT_MOVTO ASC	
                
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