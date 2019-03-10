<cfcomponent rest="true" restPath="publish/email/blacklist">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="get" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-blacklist'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	EM065
                WHERE
                    1 = 1
					AND EM065_NR_INST = 1
                <cfif IsDefined("url.EM065_DS_EMAIL") AND url.EM065_DS_EMAIL NEQ "">
					AND	EM065_DS_EMAIL = <cfqueryparam value = "#url.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.EM065_NR_CPFCNPJ") AND url.EM065_NR_CPFCNPJ NEQ "">
					<cfset url.EM065_NR_CPFCNPJ = NumberFormat(url.EM065_NR_CPFCNPJ , "00000000000")>
					AND	EM065_NR_CPFCNPJ = <cfqueryparam value = "#url.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM065_DS_EMAIL ASC) AS ROW
					,EM065_NR_INST
					,EM065_DS_EMAIL
					,EM065_NR_CPFCNPJ
					,EM065_ID_MOTIVO
				FROM
					EM065
				WHERE
					1 = 1
					AND EM065_NR_INST = 1
                <cfif IsDefined("url.EM065_DS_EMAIL") AND url.EM065_DS_EMAIL NEQ "">
					AND	EM065_DS_EMAIL = <cfqueryparam value = "#url.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.EM065_NR_CPFCNPJ") AND url.EM065_NR_CPFCNPJ NEQ "">
					AND	EM065_NR_CPFCNPJ = <cfqueryparam value = "#url.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				ORDER BY
					EM065_DS_EMAIL ASC	
                
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
		restpath="/{EM065_NR_INST}/{EM065_DS_EMAIL}/{EM065_NR_CPFCNPJ}"> 

		<cfargument name="EM065_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM065_DS_EMAIL" restargsource="Path" type="string"/>
		<cfargument name="EM065_NR_CPFCNPJ" restargsource="Path" type="string"/>
		
		<cfset checkAuthentication(state = ['email-blacklist'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 EM065_NR_INST
					,EM065_DS_EMAIL
					,EM065_NR_CPFCNPJ
					,EM065_ID_MOTIVO
				FROM
					EM065
				WHERE
				    EM065_NR_INST = <cfqueryparam value = "#arguments.EM065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM065_DS_EMAIL = <cfqueryparam value = "#arguments.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
				AND	EM065_NR_CPFCNPJ = <cfqueryparam value = "#arguments.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="blacklistCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-blacklist'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.EM065
				(   
					 EM065_NR_INST
					,EM065_DS_EMAIL
					,EM065_NR_CPFCNPJ
					,EM065_ID_MOTIVO
					,EM065_CD_OPESIS
					,EM065_DT_INCSIS
					,EM065_DT_ATUSIS
				) 
					VALUES (
					1,	
					<cfqueryparam value = "#arguments.body.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
					0,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de blacklist já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="blacklistUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{EM065_NR_INST}/{EM065_DS_EMAIL}/{EM065_NR_CPFCNPJ}">
		
		<cfargument name="EM065_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM065_DS_EMAIL" restargsource="Path" type="string"/>
		<cfargument name="EM065_NR_CPFCNPJ" restargsource="Path" type="string"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-blacklist'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.EM065  
				SET 
					EM065_DS_EMAIL = <cfqueryparam value = "#arguments.body.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
					EM065_NR_CPFCNPJ = <cfqueryparam value = "#arguments.body.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
				    EM065_NR_INST = <cfqueryparam value = "#arguments.EM065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM065_DS_EMAIL = <cfqueryparam value = "#arguments.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
				AND	EM065_NR_CPFCNPJ = <cfqueryparam value = "#arguments.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de blacklists já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="blacklistRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-blacklist'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.EM065 
					WHERE 
				    EM065_NR_INST = <cfqueryparam value = "#i.EM065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM065_DS_EMAIL = <cfqueryparam value = "#i.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
				AND	EM065_NR_CPFCNPJ = <cfqueryparam value = "#i.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="blacklistRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{EM065_NR_INST}/{EM065_DS_EMAIL}/{EM065_NR_CPFCNPJ}">
		>
		
		<cfargument name="EM065_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM065_DS_EMAIL" restargsource="Path" type="string"/>
		<cfargument name="EM065_NR_CPFCNPJ" restargsource="Path" type="string"/>

		<cfset checkAuthentication(state = ['email-blacklist'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.EM065 
				WHERE 
				    EM065_NR_INST = <cfqueryparam value = "#arguments.EM065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM065_DS_EMAIL = <cfqueryparam value = "#arguments.EM065_DS_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">				
				AND	EM065_NR_CPFCNPJ = <cfqueryparam value = "#arguments.EM065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
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