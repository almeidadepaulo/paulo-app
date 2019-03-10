<cfcomponent rest="true" restPath="cedente">  
	<cfinclude template="../security.cfm">		
	<cfinclude template="../util.cfm">

	<cffunction name="cedente" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<!---<cfset cedenteValidate()>--->
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<!--- BACKOFFICE --->
			<cfif session.perfilTipo EQ 2>
				<cfquery datasource="#application.datasource#" name="queryCount">
					SELECT
						COUNT(*) AS COUNT
					FROM
						CB053
					WHERE
						1 = 1

					AND CB053_NR_INST = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB053_CD_EMIEMP <> 0

					<cfif IsDefined("url.CB053_CD_EMIEMP") AND url.CB053_CD_EMIEMP NEQ "">
						AND	CB053_CD_EMIEMP = <cfqueryparam value = "#url.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					<cfif IsDefined("url.cedente_id") AND url.cedente_id NEQ "">
						AND	CB053_CD_EMIEMP = <cfqueryparam value = "#url.cedente_id#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					<cfif IsDefined("url.CB053_DS_EMIEMP") AND url.CB053_DS_EMIEMP NEQ "">
						AND	CB053_DS_EMIEMP LIKE <cfqueryparam value = "%#url.CB053_DS_EMIEMP#%" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					<cfif IsDefined("url.cedente_nome") AND url.cedente_nome NEQ "">
						AND	CB053_DS_EMIEMP LIKE <cfqueryparam value = "%#url.cedente_nome#%" CFSQLType = "CF_SQL_VARCHAR">
					</cfif>
					
					<cfif IsDefined("url.CB053_NR_CPFCNPJ") AND url.CB053_NR_CPFCNPJ NEQ "">
						AND	CB053_NR_CPFCNPJ = <cfqueryparam value = "#url.CB053_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 
					
				</cfquery>

				<cfquery datasource="#application.datasource#" name="query">
					SELECT
						ROW_NUMBER() OVER(ORDER BY CB053_DS_EMIEMP ASC) AS ROW
						,CB053_NR_INST
						,CB053_NR_INST AS GRUPO_ID
						,CB053_DS_EMIEMP
						,CB053_CD_EMIEMP
						,CB053_DS_EMIEMP AS CEDENTE_NOME
						,CB053_CD_EMIEMP AS CEDENTE_ID
						,CB053_NR_CPFCNPJ
					FROM
						CB053
					WHERE 
						1 = 1
					AND CB053_NR_INST = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB053_CD_EMIEMP <> 0

					<cfif IsDefined("url.CB053_CD_EMIEMP") AND url.CB053_CD_EMIEMP NEQ "">
						AND	CB053_CD_EMIEMP = <cfqueryparam value = "#url.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					<cfif IsDefined("url.cedente_id") AND url.cedente_id NEQ "">
						AND	CB053_CD_EMIEMP = <cfqueryparam value = "#url.cedente_id#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					<cfif IsDefined("url.CB053_DS_EMIEMP") AND url.CB053_DS_EMIEMP NEQ "">
						AND	CB053_DS_EMIEMP LIKE <cfqueryparam value = "%#url.CB053_DS_EMIEMP#%" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					<cfif IsDefined("url.cedente_nome") AND url.cedente_nome NEQ "">
						AND	CB053_DS_EMIEMP LIKE <cfqueryparam value = "%#url.cedente_nome#%" CFSQLType = "CF_SQL_VARCHAR">
					</cfif>

					<cfif IsDefined("url.CB053_NR_CPFCNPJ") AND url.CB053_NR_CPFCNPJ NEQ "">
						AND	CB053_NR_CPFCNPJ = <cfqueryparam value = "#url.CB053_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 

					ORDER BY
						CB053_CD_EMIEMP ASC	
					
					<!--- Paginação --->
					OFFSET #URL.page * URL.limit - URL.limit# ROWS
					FETCH NEXT #URL.limit# ROWS ONLY;
				</cfquery>
			<cfelse>
				<cfquery datasource="#application.datasource#" name="queryCount">
					SELECT
						COUNT(*) AS COUNT
					FROM
						dbo.perfil_cedente AS perfil_cedente
								
					INNER JOIN CB053 AS CB053
					ON CB053.CB053_NR_INST = perfil_cedente.grupo_id
					AND CB053.CB053_CD_EMIEMP = perfil_cedente.cedente_id

					WHERE
						cedente_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cedentelist#" list="true">)
					AND per_id = <cfqueryparam value = "#session.perfilId#" CFSQLType = "CF_SQL_NUMERIC">
					AND grupo_id = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>

				<cfquery datasource="#application.datasource#" name="query">
					SELECT
						per_id
						,grupo_id
						,cedente_id					
						,grupo_id AS CB053_NR_INST						

						,CB053.CB053_DS_EMIEMP
						,cedente_id AS CB053_CD_EMIEMP
						,CB053_DS_EMIEMP AS CEDENTE_NOME						
						,CB053.CB053_NR_CPFCNPJ
					FROM
						dbo.perfil_cedente AS perfil_cedente
								
					INNER JOIN CB053 AS CB053
					ON CB053.CB053_NR_INST = perfil_cedente.grupo_id
					AND CB053.CB053_CD_EMIEMP = perfil_cedente.cedente_id

					WHERE
						cedente_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cedentelist#" list="true">)
					AND per_id = <cfqueryparam value = "#session.perfilId#" CFSQLType = "CF_SQL_NUMERIC">
					AND grupo_id = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_NUMERIC">

					ORDER BY
						cedente_id ASC	
					
					<!--- Paginação --->
					OFFSET #URL.page * URL.limit - URL.limit# ROWS
					FETCH NEXT #URL.limit# ROWS ONLY;
				</cfquery>
			</cfif>
		
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="cedenteAdmin" access="remote" returntype="String" httpmethod="GET" restPath="/admin"> 

		<cfset checkAuthentication(state = ['perfil-usuario'])>
		<!---<cfset cedenteValidate()>--->

		<cfif not session.perfilAdmin>
			<cfset responseError(403)>   
		</cfif>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB053
                WHERE
					1 = 1

				<!--- AND CB053_NR_INST = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_NUMERIC"> --->

				<cfif IsDefined("url.CB053_CD_EMIEMP") AND url.CB053_CD_EMIEMP NEQ "">
					AND	CB053_CD_EMIEMP = <cfqueryparam value = "#url.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.CB053_DS_EMIEMP") AND url.CB053_DS_EMIEMP NEQ "">
					AND	CB053_DS_EMIEMP LIKE <cfqueryparam value = "%#url.CB053_DS_EMIEMP#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.CB053_NR_CPFCNPJ") AND url.CB053_NR_CPFCNPJ NEQ "">
					AND	CB053_NR_CPFCNPJ = <cfqueryparam value = "#url.CB053_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB053_DS_EMIEMP ASC) AS ROW
					,CB053_NR_INST
					,CB053_DS_EMIEMP
					,CB053_CD_EMIEMP
					,CB053_NR_CPFCNPJ
                FROM
                   CB053
                WHERE 
					1 = 1

				<!--- AND CB053_NR_INST = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_NUMERIC"> --->

				<cfif IsDefined("url.CB053_CD_EMIEMP") AND url.CB053_CD_EMIEMP NEQ "">
					AND	CB053_CD_EMIEMP = <cfqueryparam value = "#url.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.CB053_DS_EMIEMP") AND url.CB053_DS_EMIEMP NEQ "">
					AND	CB053_DS_EMIEMP LIKE <cfqueryparam value = "%#url.CB053_DS_EMIEMP#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				<cfif IsDefined("url.CB053_NR_CPFCNPJ") AND url.CB053_NR_CPFCNPJ NEQ "">
					AND	CB053_NR_CPFCNPJ = <cfqueryparam value = "#url.CB053_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				ORDER BY
					CB053_DS_EMIEMP ASC	
                
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
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB053_NR_INST}/{CB053_CD_EMIEMP}"> 

		<cfargument name="CB053_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="CB053_CD_EMIEMP" restargsource="Path" type="numeric"/>		
		
		<cfset checkAuthentication(state = ['perfil-usuario'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					CB053_NR_INST
					,CB053_CD_EMIEMP
					,CB053_DS_EMIEMP
					,CB053_NR_CPFCNPJ
					,CB053_DS_EMIEMR
					,CB053_DS_NMARQ
					,CB053_NM_END
					,CB053_NR_END
					,CB053_NM_COMPL
					,CB053_NM_BAIRRO
					,CB053_NM_CIDADE
					,CB053_NM_ESTADO
					,CB053_NR_CEP
					,CB053_NR_DDD
					,CB053_NR_TEL
					,CB053_NR_DDDC
					,CB053_NR_CEL
					,CB053_NM_EMAIL
					,CB053_NM_EMAIL2
					,CB053_NR_DDD
					,CB053_NR_DDDC
					,CB053_NR_TEL
					,CB053_NR_CEL					
				FROM
					CB053
				WHERE
				    CB053_NR_INST = <cfqueryparam value = "#arguments.CB053_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB053_CD_EMIEMP = <cfqueryparam value = "#arguments.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">				
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="cedenteCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<cftransaction>						
				<!--- create --->

				<!--- CRIAR PERFIL PARA CEDENTE --->
				<cfquery datasource="#application.datasource#" result="queryResult">
					INSERT INTO 
						dbo.perfil
					(						
						per_master,
						per_ativo,
						per_nome,
						per_developer,
						per_resetarSenha,
						grupo_id,
						per_restrito,
						per_tipo
					) 
					VALUES (						
						0,
						1,
						<cfqueryparam value = "#arguments.body.CB053_DS_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">,
						0,
						0,
						<cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_BIGINT">,
						0,
						3
					);
				</cfquery>

				<cfquery datasource="#application.datasource#" name="query">

					DECLARE @CEDENTE_ID NUMERIC(8)

					SET @CEDENTE_ID = (SELECT '#session.grupoId#' + CAST((SELECT COUNT(*) FROM CB053 WHERE CB053_NR_INST = #session.grupoId#) AS VARCHAR))

					INSERT INTO 
						dbo.CB053
					(
						CB053_NR_INST
						,CB053_CD_EMIEMP
						,CB053_DS_EMIEMP
						,CB053_NR_CPFCNPJ
						,CB053_DS_EMIEMR
						,CB053_DS_NMARQ
						,CB053_NM_EMAIL
						,CB053_NM_EMAIL2
						,CB053_NR_DDD
						,CB053_NR_TEL 
						<cfif IsDefined("arguments.body.CB053_NR_CEL") AND trim(arguments.body.CB053_NR_CEL) NEQ "">
							,CB053_NR_DDDC
							,CB053_NR_CEL
						</cfif>
						,CB053_NM_END
						,CB053_NR_END 
						,CB053_NM_COMPL
						,CB053_NM_BAIRRO
						,CB053_NM_CIDADE
						,CB053_NM_ESTADO
						,CB053_NR_CEP
						,CB053_CD_OPESIS
						,CB053_DT_INCSIS
						,CB053_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_BIGINT">
						,@CEDENTE_ID
						,<cfqueryparam value = "#arguments.body.CB053_DS_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_DS_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
						,''
						,<cfqueryparam value = "#arguments.body.CB053_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NM_EMAIL2#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#mid(arguments.body.CB053_NR_TEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#mid(arguments.body.CB053_NR_TEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">
						<cfif IsDefined("arguments.body.CB053_NR_CEL") AND trim(arguments.body.CB053_NR_CEL) NEQ "">
							,<cfqueryparam value = "#mid(arguments.body.CB053_NR_CEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
							,<cfqueryparam value = "#mid(arguments.body.CB053_NR_CEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">
						</cfif>
						,<cfqueryparam value = "#arguments.body.CB053_NM_END#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NR_END#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#arguments.body.CB053_NM_COMPL#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NM_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#arguments.body.CB053_NR_CEP#" CFSQLType = "CF_SQL_CHAR">
						,<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">
						,GETDATE()
						,GETDATE()
					);

					<!--- CRIAR ACESSO DE CEDENTE PARA PERFIL --->
					INSERT INTO 
						dbo.perfil_cedente
					(
						per_id,
						grupo_id,
						cedente_id
					) 
					VALUES (
						<cfqueryparam value = "#queryResult.IDENTITYCOL#" CFSQLType = "CF_SQL_BIGINT">,
						<cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_BIGINT">,
						@CEDENTE_ID
					);
				</cfquery>							
			</cftransaction>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Cedente cadastrado com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">								
					<cfset responseError(400, "Código de cedente já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="cedenteUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB053_NR_INST}/{CB053_CD_EMIEMP}">
		
		<cfargument name="CB053_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="CB053_CD_EMIEMP" restargsource="Path" type="numeric"/>

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB053  
				SET 
					CB053_CD_EMIEMP = <cfqueryparam value = "#arguments.body.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					,CB053_DS_EMIEMP = <cfqueryparam value = "#arguments.body.CB053_DS_EMIEMP#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NR_CPFCNPJ = <cfqueryparam value = "#arguments.body.CB053_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_DS_EMIEMR = <cfqueryparam value = "#arguments.body.CB053_DS_EMIEMR#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NM_EMAIL = <cfqueryparam value = "#arguments.body.CB053_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">				
					,CB053_NM_EMAIL2 = <cfqueryparam value = "#arguments.body.CB053_NM_EMAIL2#" CFSQLType = "CF_SQL_VARCHAR">				
					,CB053_NR_DDD = <cfqueryparam value = "#mid(arguments.body.CB053_NR_TEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
					,CB053_NR_TEL = <cfqueryparam value = "#mid(arguments.body.CB053_NR_TEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">

					<cfif IsDefined("arguments.body.CB053_NR_CEL") AND trim(arguments.body.CB053_NR_CEL) NEQ "">
						,CB053_NR_DDDC = <cfqueryparam value = "#mid(arguments.body.CB053_NR_CEL,1 ,2)#" CFSQLType = "CF_SQL_NUMERIC">
						,CB053_NR_CEL = <cfqueryparam value = "#mid(arguments.body.CB053_NR_CEL,3 ,10)#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>

					,CB053_DS_NMARQ = ''
					,CB053_NM_END = <cfqueryparam value = "#arguments.body.CB053_NM_END#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NR_END = <cfqueryparam value = "#arguments.body.CB053_NR_END#" CFSQLType = "CF_SQL_NUMERIC">
					,CB053_NM_COMPL = <cfqueryparam value = "#arguments.body.CB053_NM_COMPL#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NM_BAIRRO = <cfqueryparam value = "#arguments.body.CB053_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NM_CIDADE = <cfqueryparam value = "#arguments.body.CB053_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NM_ESTADO = <cfqueryparam value = "#arguments.body.CB053_NM_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">
					,CB053_NR_CEP = <cfqueryparam value = "#arguments.body.CB053_NR_CEP#" CFSQLType = "CF_SQL_CHAR">
				WHERE 
				    CB053_NR_INST = <cfqueryparam value = "#arguments.CB053_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">							
				AND	CB053_CD_EMIEMP = <cfqueryparam value = "#arguments.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Cedente atualizado sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de cedentes já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="cedenteRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB053 
					WHERE 
						CB053_NR_INST = <cfqueryparam value = "#i.CB053_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">							
					AND	CB053_CD_EMIEMP = <cfqueryparam value = "#i.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="cedenteRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB053_NR_INST}/{CB053_CD_EMIEMP}">
		>
		
		<cfargument name="CB053_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="CB053_CD_EMIEMP" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['perfil-usuario'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB053 
				WHERE 
				    CB053_NR_INST = <cfqueryparam value = "#arguments.CB053_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">							
				AND	CB053_CD_EMIEMP = <cfqueryparam value = "#arguments.CB053_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>
</cfcomponent>