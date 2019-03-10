<cfcomponent rest="true" restPath="collect/banco">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="bancoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB250
                WHERE
                    1 = 1

				AND CB250_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- admin --->
				<cfif session.perfilTipo EQ 1>
					AND CB250_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<cfelse>
					AND CB250_NR_CEDENTE = 0
				</cfif>
					
                <cfif IsDefined("url.CB250_CD_COMPSC") AND url.CB250_CD_COMPSC NEQ "">
					AND	CB250_CD_COMPSC = <cfqueryparam value = "#url.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB250_NM_BANCO") AND url.CB250_NM_BANCO NEQ "">
					AND	CB250_NM_BANCO LIKE <cfqueryparam value = "%#url.CB250_NM_BANCO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 				
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB250_CD_COMPSC ASC) AS ROW
					,CB250_NR_OPERADOR
					,CB250_NR_CEDENTE					
					,CB250_CD_COMPSC
					,CB250_NM_BANCO
				FROM
					CB250
				WHERE
					1 = 1

				AND CB250_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- admin --->
				<cfif session.perfilTipo EQ 1>
					AND CB250_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<cfelse>
					AND CB250_NR_CEDENTE = 0
				</cfif>
					
				<cfif IsDefined("url.CB250_CD_COMPSC") AND url.CB250_CD_COMPSC NEQ "">
					AND	CB250_CD_COMPSC = <cfqueryparam value = "#url.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB250_NM_BANCO") AND url.CB250_NM_BANCO NEQ "">
					AND	CB250_NM_BANCO LIKE <cfqueryparam value = "%#url.CB250_NM_BANCO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					CB250_CD_COMPSC ASC	
                
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

	<cffunction name="bancoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB250_NR_OPERADOR}/{CB250_NR_CEDENTE}/{CB250_CD_COMPSC}"> 

		<cfargument name="CB250_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB250_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB250_CD_COMPSC" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					CB250_NR_OPERADOR,
					CB250_NR_CEDENTE,					
					CB250_CD_COMPSC,
					CB250_NM_BANCO,
					CB250_NR_CNPJ,
					CB250_NR_CEP,
					CB250_NM_END,
					CB250_NR_END,
					CB250_DS_COMPL,
					CB250_NM_BAIRRO,
					CB250_SG_ESTADO,
					CB250_NM_CIDADE,
					CB250_NR_NOSNUM
				FROM
					CB250
				WHERE
				    CB250_NR_OPERADOR = <cfqueryparam value = "#arguments.CB250_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB250_NR_CEDENTE = <cfqueryparam value = "#arguments.CB250_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB250_CD_COMPSC = <cfqueryparam value = "#arguments.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="bancoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB250
				(   
					CB250_NR_OPERADOR,
					CB250_NR_CEDENTE,					
					CB250_CD_COMPSC,
					CB250_NM_BANCO,
					CB250_NR_CNPJ,
					CB250_NR_CEP,
					CB250_NM_END,
					CB250_NR_END,
					CB250_DS_COMPL,
					CB250_NM_BAIRRO,
					CB250_CD_CIDADE,
					CB250_SG_ESTADO,
					CB250_CD_PAIS,
					CB250_NM_CIDADE,
					CB250_NR_NOSNUM,
					CB250_CD_OPESIS,
					CB250_DT_INCSIS,
					CB250_DT_ATUSIS
				) 
					VALUES (					
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB250_NM_BANCO#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_NR_CNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_NR_CEP#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_NM_END#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_NR_END#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_DS_COMPL#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">,
					0,
					<cfqueryparam value = "#arguments.body.CB250_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">,
					0,
					<cfqueryparam value = "#arguments.body.CB250_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB250_NR_NOSNUM#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">				
					<cfset responseError(400, "Código de banco já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="bancoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB250_NR_OPERADOR}/{CB250_NR_CEDENTE}/{CB250_CD_COMPSC}"> 
				
		<cfargument name="CB250_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB250_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB250_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB250  
				SET 
					CB250_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">,
					CB250_NM_BANCO = <cfqueryparam value = "#arguments.body.CB250_NM_BANCO#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NR_CNPJ = <cfqueryparam value = "#arguments.body.CB250_NR_CNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NR_CEP = <cfqueryparam value = "#arguments.body.CB250_NR_CEP#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NM_END = <cfqueryparam value = "#arguments.body.CB250_NM_END#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NR_END = <cfqueryparam value = "#arguments.body.CB250_NR_END#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_DS_COMPL = <cfqueryparam value = "#arguments.body.CB250_DS_COMPL#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NM_BAIRRO = <cfqueryparam value = "#arguments.body.CB250_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_SG_ESTADO = <cfqueryparam value = "#arguments.body.CB250_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NM_CIDADE = <cfqueryparam value = "#arguments.body.CB250_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">,
					CB250_NR_NOSNUM = <cfqueryparam value = "#arguments.body.CB250_NR_NOSNUM#" CFSQLType = "CF_SQL_NUMERIC">,
					CB250_CD_OPESIS = <cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">
				WHERE 
				    CB250_NR_OPERADOR = <cfqueryparam value = "#arguments.CB250_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- AND CB250_NR_CEDENTE = <cfqueryparam value = "#arguments.CB250_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC"> --->
				AND	CB250_CD_COMPSC = <cfqueryparam value = "#arguments.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de banco já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="bancoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB250 
					WHERE 
				    	CB250_NR_OPERADOR = <cfqueryparam value = "#i.CB250_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					<!--- AND CB250_NR_CEDENTE = <cfqueryparam value = "#i.CB250_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC"> --->
					AND CB250_CD_COMPSC = <cfqueryparam value = "#i.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="bancoRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB250_NR_OPERADOR}/{CB250_NR_CEDENTE}/{CB250_CD_COMPSC}"> 
				
		<cfargument name="CB250_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB250_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB250_CD_COMPSC" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB250 
				WHERE 
				    	CB250_NR_OPERADOR = <cfqueryparam value = "#arguments.CB250_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					<!--- AND CB250_NR_CEDENTE = <cfqueryparam value = "#arguments.CB250_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC"> --->
				    AND CB250_CD_COMPSC = <cfqueryparam value = "#arguments.CB250_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">				
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