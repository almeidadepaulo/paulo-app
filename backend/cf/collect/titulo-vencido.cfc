<cfcomponent rest="true" restPath="collect/titulo-vencido">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="tituloVencidoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['titulo-vencido'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>

		<cfset response["params"] = url>

		<cftry>

			<cfstoredproc 
				datasource="#application.datasource#" 
				procedure="SP_CB208_VENCIDO" 
				result="sp_retorno" 
				returncode="false">

				<cfprocparam type="in" 
					dbvarname="@ENT_NR_VRS" 
					cfsqltype="CF_SQL_VARCHAR"
					value="1"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_NR_INST" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#header.cedente.GRUPO_ID#" />

				<cfprocparam type="in" 
					dbvarname="@ENT_CD_EMIEMP" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#header.cedente.CEDENTE_ID#"/>

				<cfprocresult name="query">
			</cfstoredproc>

			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = query.recordCount>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

</cfcomponent>