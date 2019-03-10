<cfcomponent rest="true" restPath="collect/tarifas">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="get" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['tarifas'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB059
                WHERE
                    1 = 1

				AND CB059_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB059_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.CB059_NR_BANCO") AND url.CB059_NR_BANCO NEQ "">
					AND	CB059_NR_BANCO = <cfqueryparam value = "#url.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
					
                <cfif IsDefined("url.CB059_CD_TARIFA") AND url.CB059_CD_TARIFA NEQ "">
					AND	CB059_CD_TARIFA = <cfqueryparam value = "#url.CB059_CD_TARIFA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB059_DS_TARIFA") AND url.CB059_DS_TARIFA NEQ "">
					AND	CB059_DS_TARIFA LIKE <cfqueryparam value = "%#url.CB059_DS_TARIFA#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB059_CD_TARIFA ASC) AS ROW
					,CB059_NR_OPERADOR
					,CB059_NR_CEDENTE
					,CB059_NR_BANCO
					,CB059_CD_TARIFA
					,CB059_DS_TARIFA
					,CB059_VL_TARBASE
					,CB059_NM_UNICOBR
					,CB059_NM_IDEXTRA
				FROM
					CB059
				WHERE
					1 = 1

				AND CB059_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB059_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
                <cfif IsDefined("url.CB059_NR_BANCO") AND url.CB059_NR_BANCO NEQ "">
					AND	CB059_NR_BANCO = <cfqueryparam value = "#url.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
				
				<cfif IsDefined("url.CB059_CD_TARIFA") AND url.CB059_CD_TARIFA NEQ "">
					AND	CB059_CD_TARIFA = <cfqueryparam value = "#url.CB059_CD_TARIFA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB059_DS_TARIFA") AND url.CB059_DS_TARIFA NEQ "">
					AND	CB059_DS_TARIFA LIKE <cfqueryparam value = "%#url.CB059_DS_TARIFA#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					CB059_CD_TARIFA ASC	
                
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
		restpath="/{CB059_NR_OPERADOR}/{CB059_NR_CEDENTE}/{CB059_NR_BANCO}/{CB059_CD_TARIFA}"> 

		<cfargument name="CB059_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_NR_BANCO" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_CD_TARIFA" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['tarifas'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					CB059_NR_OPERADOR
					,CB059_NR_CEDENTE
					,CB059_NR_BANCO
					,CB059_CD_TARIFA
					,CB059_DS_TARIFA
					,CB059_VL_TARBASE
					,CB059_NM_UNICOBR
					,CB059_NM_IDEXTRA
					,CB250_NM_BANCO
				FROM
					CB059
				INNER JOIN CB250
				ON CB250_NR_OPERADOR = CB059_NR_OPERADOR
				AND CB059_NR_CEDENTE = CB059_NR_CEDENTE
				AND CB250_CD_COMPSC = CB059_NR_BANCO
				WHERE
				    CB059_NR_OPERADOR = <cfqueryparam value = "#arguments.CB059_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB059_NR_CEDENTE = <cfqueryparam value = "#arguments.CB059_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_NR_BANCO = <cfqueryparam value = "#arguments.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_CD_TARIFA = <cfqueryparam value = "#arguments.CB059_CD_TARIFA#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

		<cfreturn new lib.JsonSerializer().serialize(response)>

    </cffunction>

	<cffunction name="tarifaCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['tarifas'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				CB059_NR_BANCO: {
					label: 'Banco',
					type: 'numeric',
					required: true,			
					max: 999
				} ,
				CB059_DS_TARIFA: {
					label: 'Nome',
					type: 'string',
					required: true,			
					maxLength: 60
				} , 
				CB059_VL_TARBASE: {
					label: 'Tarifa',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 99999
				} ,
				CB059_NM_UNICOBR: {
					label: 'Unidade',
					type: 'string',
					required: true,			
					maxLength: 40
				} ,
				CB059_NM_IDEXTRA: {
					label: 'Extrato',
					type: 'string',
					required: true,			
					maxLength: 60
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB059
				(   
					CB059_NR_OPERADOR
					,CB059_NR_CEDENTE
					,CB059_NR_BANCO					
					,CB059_DS_TARIFA
					,CB059_VL_TARBASE
					,CB059_NM_UNICOBR
					,CB059_NM_IDEXTRA
					,CB059_CD_OPESIS
					,CB059_DT_INCSIS
					,CB059_DT_ATUSIS
				) 
					VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
				    <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,						
					<cfqueryparam value = "#arguments.body.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">,					
					<cfqueryparam value = "#arguments.body.CB059_DS_TARIFA#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB059_VL_TARBASE#" CFSQLType = "CF_SQL_FLOAT">,
					<cfqueryparam value = "#arguments.body.CB059_NM_UNICOBR#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB059_NM_IDEXTRA#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de tarifa já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="tarifaUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB059_NR_OPERADOR}/{CB059_NR_CEDENTE}/{CB059_NR_BANCO}/{CB059_CD_TARIFA}"> 
		
		<cfargument name="CB059_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_NR_BANCO" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_CD_TARIFA" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['tarifas'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				CB059_NR_BANCO: {
					label: 'Banco',
					type: 'numeric',
					required: true,			
					max: 999
				} ,
				CB059_DS_TARIFA: {
					label: 'Nome',
					type: 'string',
					required: true,			
					maxLength: 60
				} , 
				CB059_VL_TARBASE: {
					label: 'Tarifa',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 99999
				} ,
				CB059_NM_UNICOBR: {
					label: 'Unidade',
					type: 'string',
					required: true,			
					maxLength: 40
				} ,
				CB059_NM_IDEXTRA: {
					label: 'Extrato',
					type: 'string',
					required: true,			
					maxLength: 60
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB059  
				SET 
					CB059_NR_BANCO = <cfqueryparam value = "#arguments.body.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">,
					CB059_DS_TARIFA = <cfqueryparam value = "#arguments.body.CB059_DS_TARIFA#" CFSQLType = "CF_SQL_VARCHAR">,
					CB059_VL_TARBASE = <cfqueryparam value = "#arguments.body.CB059_VL_TARBASE#" CFSQLType = "CF_SQL_FLOAT">,
					CB059_NM_UNICOBR = <cfqueryparam value = "#arguments.body.CB059_NM_UNICOBR#" CFSQLType = "CF_SQL_VARCHAR">,
					CB059_NM_IDEXTRA = <cfqueryparam value = "#arguments.body.CB059_NM_UNICOBR#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
				    CB059_NR_OPERADOR = <cfqueryparam value = "#arguments.CB059_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB059_NR_CEDENTE = <cfqueryparam value = "#arguments.CB059_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_NR_BANCO = <cfqueryparam value = "#arguments.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_CD_TARIFA = <cfqueryparam value = "#arguments.CB059_CD_TARIFA#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>
			

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de tarifa já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="tarifaRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['tarifas'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB059 
					WHERE 
				    CB059_NR_OPERADOR = <cfqueryparam value = "#i.CB059_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB059_NR_CEDENTE = <cfqueryparam value = "#i.CB059_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_NR_BANCO = <cfqueryparam value = "#i.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_CD_TARIFA = <cfqueryparam value = "#i.CB059_CD_TARIFA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="tarifaRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB059_NR_OPERADOR}/{CB059_NR_CEDENTE}/{CB059_NR_BANCO}/{CB059_CD_TARIFA}"> 
		
		<cfargument name="CB059_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_NR_BANCO" restargsource="Path" type="numeric"/>
		<cfargument name="CB059_CD_TARIFA" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['tarifas'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB059 
				WHERE 
				    CB059_NR_OPERADOR = <cfqueryparam value = "#arguments.CB059_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB059_NR_CEDENTE = <cfqueryparam value = "#arguments.CB059_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_NR_BANCO = <cfqueryparam value = "#arguments.CB059_NR_BANCO#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB059_CD_TARIFA = <cfqueryparam value = "#arguments.CB059_CD_TARIFA#" CFSQLType = "CF_SQL_NUMERIC">
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