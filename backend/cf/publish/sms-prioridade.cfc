<cfcomponent rest="true" restPath="publish/sms/prioridade">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="prioridadeGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-prioridade'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>
            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					MG055_NR_INST
					,MG055_CD_EMIEMP
					,MG055_CD_CODSMS
					,MG055_DS_CODSMS
					,MG057_NR_SEQ
					,NR_SEQ
					FROM
						VW_MG055_SEQ
					WHERE <!--- Condição para testes (Até aposentar a tabela MG056: programas Cobol) --->
						MG055_NR_INST = 1
					AND MG055_CD_EMIEMP = 1
					ORDER BY
						NR_SEQ
						,MG057_NR_SEQ DESC
            </cfquery>

			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<cffunction name="prioridadeCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-prioridade'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<cfquery datasource="#application.datasource#" name="query">
				DELETE FROM
					MG057
				WHERE
					MG057_NR_INST = 1
				AND MG057_CD_EMIEMP = 1

				<cfloop array="#arguments.body.codSms#" index="i">
					INSERT INTO 
						dbo.MG057
					(
						MG057_NR_INST,
						MG057_CD_EMIEMP,
						MG057_CD_CODSMS,
						MG057_NR_SEQ,
						MG057_CD_OPESIS,
						MG057_DT_INCSIS,
						MG057_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="1">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#i.MG055_CD_CODSMS#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#i.MG057_NR_SEQ#">,
						<cfqueryparam cfsqltype="cf_sql_bigint" value="#session.userId#">,
						GETDATE(),
						GETDATE()
					);	
				</cfloop>
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Prioridades atualizadas com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de prioridade já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>
</cfcomponent>