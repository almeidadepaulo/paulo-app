<cfcomponent rest="true" restPath="publish/sms/pacote">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="pacoteGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-pacote','sms-codigo'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	MG070
                WHERE
                    1 = 1
                <cfif IsDefined("url.MG070_NR_PACOTE") AND url.MG070_NR_PACOTE NEQ "">
					AND	MG070_NR_PACOTE = <cfqueryparam value = "#url.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG070_NM_PACOTE") AND url.MG070_NM_PACOTE NEQ "">
					AND	MG070_NM_PACOTE LIKE <cfqueryparam value = "%#url.MG070_NM_PACOTE#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.ignorePacotes") AND url.ignorePacotes NEQ "">
					AND MG070_NR_PACOTE NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ignorePacotes#" list="true">)
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG070_NR_PACOTE ASC) AS ROW
					,MG070_NR_OPERADOR
					,MG070_NR_PACOTE
					,MG070_NM_PACOTE
				FROM
					MG070
				WHERE
					1 = 1
				<cfif IsDefined("url.MG070_NR_PACOTE") AND url.MG070_NR_PACOTE NEQ "">
					AND	MG070_NR_PACOTE = <cfqueryparam value = "#url.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG070_NM_PACOTE") AND url.MG070_NM_PACOTE NEQ "">
					AND	MG070_NM_PACOTE LIKE <cfqueryparam value = "%#url.MG070_NM_PACOTE#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.ignorePacotes") AND url.ignorePacotes NEQ "">					
					AND MG070_NR_PACOTE NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ignorePacotes#" list="true">)
				</cfif>

				ORDER BY
					MG070_NR_PACOTE ASC	
                
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

	<cffunction name="pacoteGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{MG070_NR_OPERADOR}/{MG070_NR_PACOTE}"> 

		<cfargument name="MG070_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="MG070_NR_PACOTE" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['sms-pacote'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 MG070_NR_OPERADOR
					,MG070_NR_PACOTE
					,MG070_NM_PACOTE
				FROM
					MG070
				WHERE
				    MG070_NR_OPERADOR = <cfqueryparam value = "#arguments.MG070_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG070_NR_PACOTE = <cfqueryparam value = "#arguments.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="pacoteCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-pacote'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG070_NR_PACOTE:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				MG070_NM_PACOTE:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 60
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>
			
			<!--- create --->			
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.MG070
				(   
					MG070_NR_OPERADOR,
					MG070_NR_PACOTE,
					MG070_NM_PACOTE,
					MG070_CD_OPESIS,
					MG070_DT_INCSIS,
					MG070_DT_ATUSIS
				) 
					VALUES (
					1,	
					<cfqueryparam value = "#arguments.body.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.MG070_NM_PACOTE#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de pacote já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="pacoteUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{MG070_NR_OPERADOR}/{MG070_NR_PACOTE}">
		
		<cfargument name="MG070_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="MG070_NR_PACOTE" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-pacote'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG070_NR_PACOTE:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				MG070_NM_PACOTE:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 60
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.MG070  
				SET 
					MG070_NR_PACOTE = <cfqueryparam value = "#arguments.body.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">,
					MG070_NM_PACOTE = <cfqueryparam value = "#arguments.body.MG070_NM_PACOTE#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
					MG070_NR_OPERADOR = <cfqueryparam value = "#arguments.MG070_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">	
				AND MG070_NR_PACOTE = <cfqueryparam value = "#arguments.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de pacotes já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="pacoteRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-pacote'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG070 
					WHERE 
					    MG070_NR_OPERADOR = <cfqueryparam value = "#i.MG070_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	MG070_NR_PACOTE = <cfqueryparam value = "#i.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="pacoteRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{MG070_NR_OPERADOR}/{MG070_NR_PACOTE}"
		>
		
		<cfargument name="MG070_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="MG070_NR_PACOTE" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['sms-pacote'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.MG070 
				WHERE 
				    MG070_NR_OPERADOR = <cfqueryparam value = "#arguments.MG070_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG070_NR_PACOTE = <cfqueryparam value = "#arguments.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

</cfcomponent>