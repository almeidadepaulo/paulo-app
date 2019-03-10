<cfcomponent rest="true" restPath="publish/sms/parametro">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="parametroGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{MG000_NR_INST}"> 

		<cfargument name="MG000_NR_INST" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['sms-parametro-form'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    MG000_NR_INST
                    ,MG000_QT_DIAS
                    ,MG000_QT_MSG
                    ,MG000_PC_PROPOR
				FROM
					MG000
				WHERE
				    MG000_NR_INST = <cfqueryparam value = "#arguments.MG000_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>


	<cffunction name="parametroUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{MG000_NR_INST}">
		
		<cfargument name="MG000_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-parametro-form'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.MG000  
				SET 
					MG000_QT_DIAS = <cfqueryparam value = "#arguments.body.MG000_QT_DIAS#" CFSQLType = "CF_SQL_NUMERIC">,
					MG000_QT_MSG = <cfqueryparam value = "#arguments.body.MG000_QT_MSG#" CFSQLType = "CF_SQL_VARCHAR">,
                    MG000_PC_PROPOR = <cfqueryparam value = "#arguments.body.MG000_PC_PROPOR#" CFSQLType = "CF_SQL_FLOAT">
				WHERE 
					MG000_NR_INST = <cfqueryparam value = "#arguments.MG000_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">	
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de parametros já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

</cfcomponent>