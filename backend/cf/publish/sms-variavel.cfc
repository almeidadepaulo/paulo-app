<cfcomponent rest="true" restPath="publish/sms/variavel">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="variavelGet" access="remote" returntype="String" httpmethod="GET"> 
	
		<!--- <cfthrow errorcode="655"		         
		         detail="Exception occurred while executing the request"
		         message="Database exception"
		         type="Application"> --->

		<cfset checkAuthentication(state = ['sms-variavel'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	MG060
                WHERE
                    1 = 1
				
				AND MG060_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- AND MG060_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> --->
				AND MG060_CD_EMIEMP = 0

                <cfif IsDefined("url.MG060_CD_VAR") AND url.MG060_CD_VAR NEQ "">
					AND	MG060_CD_VAR = <cfqueryparam value = "#url.MG060_CD_VAR#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG060_DS_VAR") AND url.MG060_DS_VAR NEQ "">
					AND	MG060_DS_VAR LIKE <cfqueryparam value = "%#url.MG060_DS_VAR#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG060_CD_VAR ASC) AS ROW
					,MG060_NR_INST
					,MG060_CD_EMIEMP
					,MG060_CD_VAR
					,MG060_DS_VAR
					,MG060_QT_CARAC
					,MG060_ID_ATIVO
				FROM
					MG060
				WHERE
					1 = 1
				
				AND MG060_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- AND MG060_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> --->
				AND MG060_CD_EMIEMP = 0

				<cfif IsDefined("url.MG060_CD_VAR") AND url.MG060_CD_VAR NEQ "">
					AND	MG060_CD_VAR = <cfqueryparam value = "#url.MG060_CD_VAR#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG060_DS_VAR") AND url.MG060_DS_VAR NEQ "">
					AND	MG060_DS_VAR LIKE <cfqueryparam value = "%#url.MG060_DS_VAR#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					MG060_CD_VAR ASC	
                
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