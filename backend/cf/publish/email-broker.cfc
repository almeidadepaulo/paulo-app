<cfcomponent rest="true" restPath="publish/email/broker">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="get" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-broker'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_EM050
                WHERE
                    1 = 1
				    AND EM050_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
                <cfif IsDefined("url.EM050_NR_BROKER") AND url.EM050_NR_BROKER NEQ "">
					AND	EM050_NR_BROKER = <cfqueryparam value = "#url.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM050_NM_BROKER") AND url.EM050_NM_BROKER NEQ "">
					AND	EM050_NM_BROKER LIKE <cfqueryparam value = "%#url.EM050_NM_BROKER#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM050_NR_BROKER ASC) AS ROW
					,EM050_NR_INST
					,EM050_NR_BROKER
					,EM050_NM_BROKER
				FROM
					VW_EM050
				WHERE
					1 = 1
				    AND EM050_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
				<cfif IsDefined("url.EM050_NR_BROKER") AND url.EM050_NR_BROKER NEQ "">
					AND	EM050_NR_BROKER = <cfqueryparam value = "#url.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM050_NM_BROKER") AND url.EM050_NM_BROKER NEQ "">
					AND	EM050_NM_BROKER LIKE <cfqueryparam value = "%#url.EM050_NM_BROKER#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					EM050_NR_BROKER ASC	
                
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
		restpath="/{EM050_NR_INST}/{EM050_NR_BROKER}"> 

		<cfargument name="EM050_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM050_NR_BROKER" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['email-broker'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 EM050_NR_INST
					,EM050_NR_BROKER
					,EM050_NM_BROKER
					,EM050_ID_ATIVO
				FROM
					EM050
				WHERE
				    EM050_NR_INST = <cfqueryparam value = "#arguments.EM050_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM050_NR_BROKER = <cfqueryparam value = "#arguments.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn new lib.JsonSerializer().serialize(response)>

    </cffunction>

	<cffunction name="brokerCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-broker'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				EM050_NR_BROKER: {
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				} ,
				EM050_NM_BROKER: {
					label: 'Nome',
					type: 'string',
					required: true,			
					maxLength: 60
				} , 
				EM050_ID_ATIVO: {
					label: 'Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 2
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.EM050
				(   
					EM050_NR_INST,
					EM050_NR_BROKER,
					EM050_NM_BROKER,
  					EM050_ID_ATIVO,
					EM050_CD_OPESIS,
					EM050_DT_INCSIS,
					EM050_DT_ATUSIS
				) 
					VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.EM050_NM_BROKER#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.EM050_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,					
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de broker já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="brokerUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{EM050_NR_INST}/{EM050_NR_BROKER}">
		
		<cfargument name="EM050_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM050_NR_BROKER" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-broker'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				EM050_NR_BROKER: {
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				} ,
				EM050_NM_BROKER: {
					label: 'Nome',
					type: 'string',
					required: true,			
					maxLength: 60
				} , 
				EM050_ID_ATIVO: {
					label: 'Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 2
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.EM050  
				SET 
					EM050_NR_BROKER = <cfqueryparam value = "#arguments.body.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
					EM050_NM_BROKER = <cfqueryparam value = "#arguments.body.EM050_NM_BROKER#" CFSQLType = "CF_SQL_VARCHAR">,
					EM050_ID_ATIVO = <cfqueryparam value = "#arguments.body.EM050_ID_ATIVO#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
					EM050_NR_INST = <cfqueryparam value = "#arguments.EM050_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">	
				AND EM050_NR_BROKER = <cfqueryparam value = "#arguments.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>
			

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de brokers já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="brokerRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-broker'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.EM050 
					WHERE 
					    EM050_NR_INST = <cfqueryparam value = "#i.EM050_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM050_NR_BROKER = <cfqueryparam value = "#i.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="brokerRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{EM050_NR_INST}/{EM050_NR_BROKER}"
		>
		
		<cfargument name="EM050_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM050_NR_BROKER" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['email-broker'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.EM050 
				WHERE 
				    EM050_NR_INST = <cfqueryparam value = "#arguments.EM050_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM050_NR_BROKER = <cfqueryparam value = "#arguments.EM050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">				
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