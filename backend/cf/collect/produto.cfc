<cfcomponent rest="true" restPath="collect/produto">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="produtoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['produto'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB255
                WHERE
                    1 = 1

				AND CB255_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
                <cfif IsDefined("url.CB255_CD_PROD") AND url.CB255_CD_PROD NEQ "">
					AND	CB255_CD_PROD = <cfqueryparam value = "#url.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB255_DS_PROD") AND url.CB255_DS_PROD NEQ "">
					AND	CB255_DS_PROD LIKE <cfqueryparam value = "%#url.CB255_DS_PROD#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 				
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB255_CD_PROD ASC) AS ROW					
					,CB255_NR_OPERADOR
					,CB255_NR_CEDENTE
					,CB255_CD_PROD
					,CB255_DS_PROD
				FROM
					CB255
				WHERE
					1 = 1

				AND CB255_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
				<cfif IsDefined("url.CB255_CD_PROD") AND url.CB255_CD_PROD NEQ "">
					AND	CB255_CD_PROD = <cfqueryparam value = "#url.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB255_DS_PROD") AND url.CB255_DS_PROD NEQ "">
					AND	CB255_DS_PROD LIKE <cfqueryparam value = "%#url.CB255_DS_PROD#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.ignorePacotes") AND url.ignorePacotes NEQ "">					
					AND CB255_CD_PROD NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.ignorePacotes#" list="true">)
				</cfif>

				ORDER BY
					CB255_CD_PROD ASC	
                
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

	<cffunction name="produtoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB255_NR_OPERADOR}/{CB255_NR_CEDENTE}/{CB255_CD_PROD}"> 

		<cfargument name="CB255_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB255_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB255_CD_PROD" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['produto'])>
		<cfset cedenteValidate()>		

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 CB255_CD_PROD
					,CB255_DS_PROD
				FROM
					CB255
				WHERE
				    CB255_NR_OPERADOR = <cfqueryparam value = "#arguments.CB255_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_NR_CEDENTE = <cfqueryparam value = "#arguments.CB255_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_CD_PROD = <cfqueryparam value = "#arguments.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="produtoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['produto'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB255
				( 
				    CB255_NR_OPERADOR,
				    CB255_NR_CEDENTE,	 
					CB255_CD_PROD,
					CB255_DS_PROD,
					CB255_CD_OPESIS,
					CB255_DT_INCSIS,
					CB255_DT_ATUSIS
				) 
					VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
				    <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,						
					<cfqueryparam value = "#arguments.body.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB255_DS_PROD#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de produto já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="produtoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB255_NR_OPERADOR}/{CB255_NR_CEDENTE}/{CB255_CD_PROD}"> 
				
		<cfargument name="CB255_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB255_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB255_CD_PROD" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['produto'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB255  
				SET 
					CB255_CD_PROD = <cfqueryparam value = "#arguments.body.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">,
					CB255_DS_PROD = <cfqueryparam value = "#arguments.body.CB255_DS_PROD#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
					CB255_NR_OPERADOR = <cfqueryparam value = "#arguments.CB255_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_NR_CEDENTE = <cfqueryparam value = "#arguments.CB255_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB255_CD_PROD = <cfqueryparam value = "#arguments.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de produtos já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="produtoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['produto'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB255 
					WHERE 
				        CB255_NR_OPERADOR = <cfqueryparam value = "#i.CB255_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB255_NR_CEDENTE = <cfqueryparam value = "#i.CB255_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB255_CD_PROD = <cfqueryparam value = "#i.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="produtoRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB255_NR_OPERADOR}/{CB255_NR_CEDENTE}/{CB255_CD_PROD}"> 
				
		<cfargument name="CB255_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB255_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB255_CD_PROD" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['produto'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB255 
				WHERE
					CB255_NR_OPERADOR = <cfqueryparam value = "#arguments.CB255_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_NR_CEDENTE = <cfqueryparam value = "#arguments.CB255_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB255_CD_PROD = <cfqueryparam value = "#arguments.CB255_CD_PROD#" CFSQLType = "CF_SQL_NUMERIC">				
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