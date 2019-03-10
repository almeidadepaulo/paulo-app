<cfcomponent rest="true" restPath="publish/sms/resumo">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="resumo" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-resumo'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_MG003
                WHERE
                    1 = 1
			
				AND MG003_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG003_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
            
			    <cfif IsDefined("url.MG003_NR_BROKER") AND url.MG003_NR_BROKER NEQ "">
					AND	MG003_NR_BROKER = <cfqueryparam value = "#url.MG003_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG003_DT_MOVTO") AND url.MG003_DT_MOVTO NEQ "">
					<cfset url.MG003_DT_MOVTO = ISOToDateTime(url.MG003_DT_MOVTO)>
					<cfset url.MG003_DT_MOVTO = DateFormat(url.MG003_DT_MOVTO , "YYYYMMDD")>
					AND	MG003_DT_MOVTO = <cfqueryparam value = "#url.MG003_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG003_NR_BROKER ASC) AS ROW
					,MG003_NR_INST
					,MG003_CD_EMIEMP
					,MG003_NR_BROKER
					,MG003_DT_MOVTO
					,MG003_TT_MENSO
					,MG003_TT_MENSN
					,MG003_TT_MENS
					,MG003_VL_VALOR
				FROM
					VW_MG003
				WHERE
					1 = 1

				AND MG003_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG003_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG003_NR_BROKER") AND url.MG003_NR_BROKER NEQ "">
					AND	MG003_NR_BROKER = <cfqueryparam value = "#url.MG003_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG003_DT_MOVTO") AND url.MG003_DT_MOVTO NEQ "">
					AND	MG003_DT_MOVTO = <cfqueryparam value = "#url.MG003_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				ORDER BY
					MG003_NR_BROKER ASC	
                
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