<cfcomponent rest="true" restPath="publish/sms/resumo-cpf">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="resumoCpf" access="remote" returntype="String" httpmethod="GET"> 
				
		<cfset checkAuthentication(state = ['sms-resumo-cpf'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_MG004
                WHERE
                    1 = 1

				AND MG004_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG004_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG004_NR_BROKER") AND url.MG004_NR_BROKER NEQ "">
					AND	MG004_NR_BROKER = <cfqueryparam value = "#url.MG004_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG004_NR_CPF") AND url.MG004_NR_CPF NEQ "">
					AND	MG004_NR_CPF = <cfqueryparam value = "#url.MG004_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.MG004_DT_MOVTO") AND url.MG004_DT_MOVTO NEQ "">
					<cfset url.MG004_DT_MOVTO = ISOToDateTime(url.MG004_DT_MOVTO)>
					<cfset url.MG004_DT_MOVTO = DateFormat(url.MG004_DT_MOVTO , "YYYYMMDD")>
					AND	MG004_DT_MOVTO = <cfqueryparam value = "#url.MG004_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG004_NR_BROKER ASC) AS ROW
					,MG004_NR_INST
					,MG004_CD_EMIEMP
					,MG004_NR_BROKER
					,MG004_NR_CPF
					,MG004_DT_MOVTO
					,MG004_TT_MENSO
					,MG004_TT_MENSN
					,MG004_TT_MENS
				FROM
					VW_MG004
				WHERE
					1 = 1
	
				AND MG004_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG004_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG004_NR_BROKER") AND url.MG004_NR_BROKER NEQ "">
					AND	MG004_NR_BROKER = <cfqueryparam value = "#url.MG004_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG004_NR_CPF") AND url.MG004_NR_CPF NEQ "">
					AND	MG004_NR_CPF = <cfqueryparam value = "#url.MG004_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.MG004_DT_MOVTO") AND url.MG004_DT_MOVTO NEQ "">
					AND	MG004_DT_MOVTO = <cfqueryparam value = "#url.MG004_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				ORDER BY
					MG004_NR_BROKER ASC	
                
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