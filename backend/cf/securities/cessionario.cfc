<cfcomponent rest="true" restPath="securities/cessionario">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="cessionarioGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['cessionario'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB058
                WHERE
                    1 = 1
                <cfif IsDefined("url.CB058_CD_CESS") AND url.CB058_CD_CESS NEQ "">
					AND	CB058_CD_CESS = <cfqueryparam value = "#url.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB058_DS_CESS") AND url.CB058_DS_CESS NEQ "">
					AND	CB058_DS_CESS LIKE <cfqueryparam value = "%#url.CB058_DS_CESS#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				
				<cfif IsDefined("url.CB058_NR_CPFCNPJ") AND url.CB058_NR_CPFCNPJ NEQ "">
					AND	CB058_NR_CPFCNPJ = <cfqueryparam value = "#url.CB058_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB058_NR_CEDENTE ASC) AS ROW
					,CB058_NR_OPERADOR
					,CB058_NR_CEDENTE
					,CB058_CD_CESS
					,CB058_DS_CESS
					,CB058_NR_CPFCNPJ
				FROM
					CB058
				WHERE
					1 = 1
                <cfif IsDefined("url.CB058_CD_CESS") AND url.CB058_CD_CESS NEQ "">
					AND	CB058_CD_CESS = <cfqueryparam value = "#url.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB058_DS_CESS") AND url.CB058_DS_CESS NEQ "">
					AND	CB058_DS_CESS LIKE <cfqueryparam value = "%#url.CB058_DS_CESS#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				
				<cfif IsDefined("url.CB058_NR_CPFCNPJ") AND url.CB058_NR_CPFCNPJ NEQ "">
					AND	CB058_NR_CPFCNPJ = <cfqueryparam value = "#url.CB058_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 


				ORDER BY
					CB058_NR_CEDENTE ASC	
                
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

	<cffunction name="cessionarioGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB058_NR_OPERADOR}/{CB058_NR_CEDENTE}/{CB058_CD_CESS}"> 

		<cfargument name="CB058_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB058_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB058_CD_CESS" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['cessionario'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 CB058_NR_OPERADOR
					,CB058_NR_CEDENTE
					,CB058_CD_CESS
					,CB058_DS_CESS
					,CB058_NR_CPFCNPJ
					,CB058_DS_EMIEMR
					,CB058_DS_NMARQ
					,CB058_NM_EMAIL
					,CB058_NM_EMAIL2
					,CB058_NR_DDD
					,CB058_NR_TEL 
					,CB058_NR_DDDC
					,CB058_NR_CEL
					,CB058_NM_END
					,CB058_NR_END 
					,CB058_NM_COMPL
					,CB058_NM_BAIRRO
					,CB058_NM_CIDADE
					,CB058_NM_ESTADO
					,CB058_NR_CEP
				FROM
					CB058
				WHERE
				    CB058_NR_OPERADOR = <cfqueryparam value = "#arguments.CB058_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB058_NR_CEDENTE = <cfqueryparam value = "#arguments.CB058_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB058_CD_CESS = <cfqueryparam value = "#arguments.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="cessionarioCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['cessionario'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- validate --->
			
			<!--- create --->			
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB058
				(   
						 CB058_NR_OPERADOR
						,CB058_NR_CEDENTE
						,CB058_CD_CESS
						,CB058_DS_CESS
						,CB058_NR_CPFCNPJ
						,CB058_DS_EMIEMR
						,CB058_DS_NMARQ
						,CB058_NM_EMAIL
						,CB058_NM_EMAIL2
						,CB058_NR_DDD
						,CB058_NR_TEL 
						<cfif IsDefined("arguments.body.CB058_NR_CEL") AND trim(arguments.body.CB058_NR_CEL) NEQ "">
							,CB058_NR_DDDC
							,CB058_NR_CEL
						</cfif>
						,CB058_NM_END
						,CB058_NR_END 
						,CB058_NM_COMPL
						,CB058_NM_BAIRRO
						,CB058_NM_CIDADE
						,CB058_NM_ESTADO
						,CB058_NR_CEP
						,CB058_CD_OPESIS
						,CB058_DT_INCSIS
						,CB058_DT_ATUSIS
					) 
					VALUES (
						 <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">	
						,<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#arguments.body.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#arguments.body.CB058_DS_CESS#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_DS_EMIEMR#" CFSQLType = "CF_SQL_VARCHAR">
						,''
						,<cfqueryparam value = "#arguments.body.CB058_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NM_EMAIL2#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#mid(arguments.body.CB058_NR_TEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#mid(arguments.body.CB058_NR_TEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">
						<cfif IsDefined("arguments.body.CB058_NR_CEL") AND trim(arguments.body.CB058_NR_CEL) NEQ "">
							,<cfqueryparam value = "#mid(arguments.body.CB058_NR_CEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
							,<cfqueryparam value = "#mid(arguments.body.CB058_NR_CEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">
						</cfif>
						,<cfqueryparam value = "#arguments.body.CB058_NM_END#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NR_END#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#arguments.body.CB058_NM_COMPL#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NM_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB058_NR_CEP#" CFSQLType = "CF_SQL_CHAR">
						,<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">
						,GETDATE()
						,GETDATE()
					);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código do cessionario já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="cessionarioUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB058_NR_OPERADOR}/{CB058_NR_CEDENTE}/{CB058_CD_CESS}"> 
		
		<cfargument name="CB058_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB058_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB058_CD_CESS" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['cessionario'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->

			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB058  
				SET 
					CB058_CD_CESS = <cfqueryparam value = "#arguments.body.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
					,CB058_DS_CESS = <cfqueryparam value = "#arguments.body.CB058_DS_CESS#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NR_CPFCNPJ = <cfqueryparam value = "#arguments.body.CB058_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_DS_EMIEMR = <cfqueryparam value = "#arguments.body.CB058_DS_EMIEMR#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NM_EMAIL = <cfqueryparam value = "#arguments.body.CB058_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">				
					,CB058_NM_EMAIL2 = <cfqueryparam value = "#arguments.body.CB058_NM_EMAIL2#" CFSQLType = "CF_SQL_VARCHAR">				
					,CB058_NR_DDD = <cfqueryparam value = "#mid(arguments.body.CB058_NR_TEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
					,CB058_NR_TEL = <cfqueryparam value = "#mid(arguments.body.CB058_NR_TEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">

					<cfif IsDefined("arguments.body.CB058_NR_CEL") AND trim(arguments.body.CB058_NR_CEL) NEQ "">
						,CB058_NR_DDDC = <cfqueryparam value = "#mid(arguments.body.CB058_NR_CEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
						,CB058_NR_CEL = <cfqueryparam value = "#mid(arguments.body.CB058_NR_CEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>

					,CB058_DS_NMARQ = ''
					,CB058_NM_END = <cfqueryparam value = "#arguments.body.CB058_NM_END#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NR_END = <cfqueryparam value = "#arguments.body.CB058_NR_END#" CFSQLType = "CF_SQL_NUMERIC">
					,CB058_NM_COMPL = <cfqueryparam value = "#arguments.body.CB058_NM_COMPL#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NM_BAIRRO = <cfqueryparam value = "#arguments.body.CB058_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NM_CIDADE = <cfqueryparam value = "#arguments.body.CB058_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NM_ESTADO = <cfqueryparam value = "#arguments.body.CB058_NM_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">
					,CB058_NR_CEP = <cfqueryparam value = "#arguments.body.CB058_NR_CEP#" CFSQLType = "CF_SQL_CHAR">
				WHERE 
					CB058_NR_OPERADOR = <cfqueryparam value = "#arguments.CB058_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">	
				AND CB058_NR_CEDENTE = <cfqueryparam value = "#arguments.CB058_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB058_CD_CESS = <cfqueryparam value = "#arguments.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código do cessionario já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="cessionarioRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['cessionario'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB058 
					WHERE 
					    CB058_NR_OPERADOR = <cfqueryparam value = "#i.CB058_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	CB058_NR_CEDENTE = <cfqueryparam value = "#i.CB058_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				    AND	CB058_CD_CESS = <cfqueryparam value = "#i.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="cessionarioRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB058_NR_OPERADOR}/{CB058_NR_CEDENTE}/{CB058_CD_CESS}"> 
		>
		
		<cfargument name="CB058_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB058_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB058_CD_CESS" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['cessionario'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB058 
				WHERE 
				        CB058_NR_OPERADOR = <cfqueryparam value = "#arguments.CB058_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				    AND	CB058_NR_CEDENTE = <cfqueryparam value = "#arguments.CB058_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				    AND	CB058_CD_CESS = <cfqueryparam value = "#arguments.CB058_CD_CESS#" CFSQLType = "CF_SQL_NUMERIC">
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