<cfcomponent rest="true" restPath="publish/email/pacote">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="get" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-pacote','email-codigo'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	EM070
                WHERE
                    1 = 1
                <cfif IsDefined("url.EM070_NR_PACOTE") AND url.EM070_NR_PACOTE NEQ "">
					AND	EM070_NR_PACOTE = <cfqueryparam value = "#url.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM070_NM_PACOTE") AND url.EM070_NM_PACOTE NEQ "">
					AND	EM070_NM_PACOTE LIKE <cfqueryparam value = "%#url.EM070_NM_PACOTE#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.ignorePacotes") AND url.ignorePacotes NEQ "">
					AND EM070_NR_PACOTE NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ignorePacotes#" list="true">)
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM070_NR_PACOTE ASC) AS ROW
					,EM070_NR_INST
					,EM070_NR_PACOTE
					,EM070_NM_PACOTE
				FROM
					EM070
				WHERE
					1 = 1
				<cfif IsDefined("url.EM070_NR_PACOTE") AND url.EM070_NR_PACOTE NEQ "">
					AND	EM070_NR_PACOTE = <cfqueryparam value = "#url.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM070_NM_PACOTE") AND url.EM070_NM_PACOTE NEQ "">
					AND	EM070_NM_PACOTE LIKE <cfqueryparam value = "%#url.EM070_NM_PACOTE#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.ignorePacotes") AND url.ignorePacotes NEQ "">					
					AND EM070_NR_PACOTE NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ignorePacotes#" list="true">)
				</cfif>

				ORDER BY
					EM070_NR_PACOTE ASC	
                
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

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{EM070_NR_INST}/{EM070_NR_PACOTE}"> 

		<cfargument name="EM070_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM070_NR_PACOTE" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['email-pacote'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 EM070_NR_INST
					,EM070_NR_PACOTE
					,EM070_NM_PACOTE
				FROM
					EM070
				WHERE
				    EM070_NR_INST = <cfqueryparam value = "#arguments.EM070_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM070_NR_PACOTE = <cfqueryparam value = "#arguments.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">
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

		<cfset checkAuthentication(state = ['email-pacote'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				EM070_NR_PACOTE:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				EM070_NM_PACOTE:{
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
					dbo.EM070
				(   
					EM070_NR_INST,
					EM070_NR_PACOTE,
					EM070_NM_PACOTE,
					EM070_CD_OPESIS,
					EM070_DT_INCSIS,
					EM070_DT_ATUSIS
				) 
					VALUES (
					1,	
					<cfqueryparam value = "#arguments.body.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.EM070_NM_PACOTE#" CFSQLType = "CF_SQL_VARCHAR">,
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
		restpath="/{EM070_NR_INST}/{EM070_NR_PACOTE}">
		
		<cfargument name="EM070_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM070_NR_PACOTE" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-pacote'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				EM070_NR_PACOTE:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				EM070_NM_PACOTE:{
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
					dbo.EM070  
				SET 
					EM070_NR_PACOTE = <cfqueryparam value = "#arguments.body.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">,
					EM070_NM_PACOTE = <cfqueryparam value = "#arguments.body.EM070_NM_PACOTE#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
					EM070_NR_INST = <cfqueryparam value = "#arguments.EM070_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">	
				AND EM070_NR_PACOTE = <cfqueryparam value = "#arguments.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">				
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

		<cfset checkAuthentication(state = ['email-pacote'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.EM070 
					WHERE 
					    EM070_NR_INST = <cfqueryparam value = "#i.EM070_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM070_NR_PACOTE = <cfqueryparam value = "#i.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">				
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
		restpath="/{EM070_NR_INST}/{EM070_NR_PACOTE}"
		>
		
		<cfargument name="EM070_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM070_NR_PACOTE" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['email-pacote'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.EM070 
				WHERE 
				    EM070_NR_INST = <cfqueryparam value = "#arguments.EM070_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM070_NR_PACOTE = <cfqueryparam value = "#arguments.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">				
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