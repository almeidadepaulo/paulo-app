<cfcomponent rest="true" restPath="publish/sms/blacklist">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="blacklistGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-blacklist'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cfif IsDefined("url.MG065_NR_CPFCNPJ") AND url.MG065_NR_CPFCNPJ NEQ "">
			<cfset url.MG065_NR_CPFCNPJ = LSParseNumber(url.MG065_NR_CPFCNPJ)>
		</cfif>
		
		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	MG065
                WHERE
                    1 = 1
					AND MG065_NR_INST = 1
                <cfif IsDefined("url.MG065_NR_DDD") AND url.MG065_NR_DDD NEQ "">
					AND	MG065_NR_DDD = <cfqueryparam value = "#url.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG065_NR_CEL") AND url.MG065_NR_CEL NEQ "">
					AND	MG065_NR_CEL = <cfqueryparam value = "#url.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG065_NR_CPFCNPJ") AND url.MG065_NR_CPFCNPJ NEQ "">
					<cfset url.MG065_NR_CPFCNPJ = NumberFormat(url.MG065_NR_CPFCNPJ , "00000000000")>
					AND	MG065_NR_CPFCNPJ = <cfqueryparam value = "#url.MG065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG065_NR_CEL ASC) AS ROW
					,MG065_NR_INST
					,MG065_NR_DDD
					,MG065_NR_CEL
					,MG065_NR_CPFCNPJ
				FROM
					MG065
				WHERE
					1 = 1
					AND MG065_NR_INST = 1
				<cfif IsDefined("url.MG065_NR_DDD") AND url.MG065_NR_DDD NEQ "">
					AND	MG065_NR_DDD = <cfqueryparam value = "#url.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG065_NR_CEL") AND url.MG065_NR_CEL NEQ "">
					AND	MG065_NR_CEL = <cfqueryparam value = "#url.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  

				<cfif IsDefined("url.MG065_NR_CPFCNPJ") AND url.MG065_NR_CPFCNPJ NEQ "">
					AND	MG065_NR_CPFCNPJ = <cfqueryparam value = "#url.MG065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				ORDER BY
					MG065_NR_CEL ASC	
                
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

	<cffunction name="blacklistGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{MG065_NR_INST}/{MG065_NR_DDD}/{MG065_NR_CEL}"> 

		<cfargument name="MG065_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG065_NR_DDD" restargsource="Path" type="numeric"/>
		<cfargument name="MG065_NR_CEL" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['sms-blacklist'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 MG065_NR_INST
					,MG065_NR_DDD
					,MG065_NR_CEL
					,MG065_NR_CPFCNPJ
				FROM
					MG065
				WHERE
				    MG065_NR_INST = <cfqueryparam value = "#arguments.MG065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG065_NR_DDD = <cfqueryparam value = "#arguments.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG065_NR_CEL = <cfqueryparam value = "#arguments.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="blacklistCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-blacklist'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.MG065
				(   
					 MG065_NR_INST
					,MG065_NR_DDD
					,MG065_NR_CEL
					,MG065_NR_CPFCNPJ
					,MG065_ID_MOTIVO
					,MG065_CD_OPESIS
					,MG065_DT_INCSIS
					,MG065_DT_ATUSIS
				) 
					VALUES (
					1,	
					<cfqueryparam value = "#arguments.body.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.MG065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
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
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="blacklistUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{MG065_NR_INST}/{MG065_NR_DDD}/{MG065_NR_CEL}">
		
		<cfargument name="MG065_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG065_NR_DDD" restargsource="Path" type="numeric"/>
		<cfargument name="MG065_NR_CEL" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-blacklist'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.MG065  
				SET 
					MG065_NR_DDD = <cfqueryparam value = "#arguments.body.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">,
					MG065_NR_CEL = <cfqueryparam value = "#arguments.body.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">,
					MG065_NR_CPFCNPJ = <cfqueryparam value = "#arguments.body.MG065_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
				    MG065_NR_INST = <cfqueryparam value = "#arguments.MG065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG065_NR_DDD = <cfqueryparam value = "#arguments.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG065_NR_CEL = <cfqueryparam value = "#arguments.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
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

		<cfset checkAuthentication(state = ['sms-blacklist'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG065 
					WHERE 
				    MG065_NR_INST = <cfqueryparam value = "#i.MG065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG065_NR_DDD = <cfqueryparam value = "#i.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG065_NR_CEL = <cfqueryparam value = "#i.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
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
		restpath="/{MG065_NR_INST}/{MG065_NR_DDD}/{MG065_NR_CEL}"
		>
		
		<cfargument name="MG065_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG065_NR_DDD" restargsource="Path" type="numeric"/>
		<cfargument name="MG065_NR_CEL" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['sms-blacklist'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.MG065 
				WHERE 
				    MG065_NR_INST = <cfqueryparam value = "#arguments.MG065_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG065_NR_DDD = <cfqueryparam value = "#arguments.MG065_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG065_NR_CEL = <cfqueryparam value = "#arguments.MG065_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
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