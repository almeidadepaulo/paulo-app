<cfcomponent rest="true" restPath="usuario">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="usuario" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset checkAuthentication(state = ['perfil-usuario'])>
		<cfset cedenteValidate()>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<!--- 
				Tipos de perfil:
				0: Desenvolvedor
				1: Administrador
				2: Backoffice
				3: Cedente
			--->
			<cfif session.perfilTipo EQ 2 OR session.perfilTipo EQ 3>
				<cfquery datasource="#application.datasource#" name="queryPerfilCedente">
					SELECT						
						per_id
					FROM
						perfil_cedente
					WHERE
						grupo_id = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND cedente_id = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

					ORDER BY
						per_id DESC
				</cfquery>

				<cfset perfilArray = arrayNew(1)>
				<cfloop query="queryPerfilCedente">
					<cfset arrayAppend(perfilArray, queryPerfilCedente.per_id)>
				</cfloop>

				<cfset perfilList = ArrayToList(perfilArray)>	
			</cfif>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
					COUNT(*) AS COUNT
				FROM
					vw_usuario
				WHERE
				1 = 1
				<cfif IsDefined("url.nome") AND url.nome NEQ "">
					AND usu_nome LIKE <cfqueryparam value = "%#url.nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>     
				<cfif IsDefined("url.login") AND url.login NEQ "">
					AND usu_login = <cfqueryparam value = "#url.login#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif IsDefined("url.cpf") AND url.cpf NEQ "">
					AND usu_cpf = <cfqueryparam value = "#url.cpf#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif not session.perfilDeveloper>
					AND (per_developer <> 1 OR per_developer is null)

					<!--- 
						Tipos de perfil:
						0: Desenvolvedor
						1: Administrador
						2: Backoffice
						3: Cedente
					 --->
					<cfif session.perfilTipo EQ 1>
						AND per_tipo = 2
					<cfelseif session.perfilTipo EQ 2>
						AND per_tipo = 3
					<cfelse>
						AND per_tipo = 3
					</cfif>

					<cfif IsDefined("perfilList") AND perfilList NEQ "">						
						AND per_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#perfilList#" list="true">)
					</cfif>
				</cfif>				
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					usu_id
					,usu_nome
					,usu_login
					,usu_cpf
					,per_nome
					,usu_ativo_label
					,usu_ultimoAcesso
				FROM
					vw_usuario
				WHERE
					1 = 1
				<cfif IsDefined("url.nome") AND url.nome NEQ "">
					AND usu_nome LIKE <cfqueryparam value = "%#url.nome#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>     
				<cfif IsDefined("url.login") AND url.login NEQ "">
					AND usu_login = <cfqueryparam value = "#url.login#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif IsDefined("url.cpf") AND url.cpf NEQ "">
					AND usu_cpf = <cfqueryparam value = "#url.cpf#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				<cfif not session.perfilDeveloper>
					AND (per_developer <> 1 OR per_developer is null)

					<!--- 
						Tipos de perfil:
						0: Desenvolvedor
						1: Administrador
						2: Backoffice
						3: Cedente
					 --->
					<cfif session.perfilTipo EQ 1>
						AND per_tipo = 2
					<cfelseif session.perfilTipo EQ 2>
						AND per_tipo IN (3)
					<cfelse>
						AND per_tipo = 3
					</cfif>

					<cfif IsDefined("perfilList") AND perfilList NEQ "">						
						AND per_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#perfilList#" list="true">)
					</cfif>
				</cfif>

				ORDER BY
					usu_nome ASC
                
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
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['perfil-usuario'])>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    usu_id
                    ,usu_nome
                    ,usu_login
                    ,usu_cpf
                    ,usu_email
                    ,per_id
                    ,per_nome
                    ,usu_ativo
                    ,usu_ativo_label
                    ,usu_mudarSenha
                    ,usu_ultimoAcesso
					,usu_sms_aprovador
                FROM
                    vw_usuario
                WHERE
                    usu_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn SerializeJSON(response)>
    </cffunction>
	
	<cffunction name="usuarioCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>
		<cfset cedenteValidate()>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>						
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.usuario
				(                   
					usu_ativo,
					per_id,
					usu_login,
					usu_senha,
					usu_nome,
					usu_email,
					usu_cpf,                    
					usu_senhaExpira,
					usu_mudarSenha,
					usu_tentativasLogin,
					usu_countTentativasLogin,
					usu_sms_aprovador                
				) 
				VALUES (
					<cfqueryparam value = "#body.statusSelected#" CFSQLType = "CF_SQL_TINYINT">,
					<cfif session.perfilTipo EQ 1>
						3,
					<cfelse>
						(SELECT
							per_id 
						FROM
							perfil_cedente 
						WHERE 
							grupo_id = <cfqueryparam value = "#session.grupoId#" CFSQLType = "CF_SQL_BIGINT">
						AND cedente_id = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
						),
					</cfif>
					<cfqueryparam value = "#body.login#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#hash(body.senha, 'SHA-512')#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#body.nome#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#body.email#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#body.cpf#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">,
					<cfqueryparam value = "#body.senhaModificar#" CFSQLType = "CF_SQL_BIT">,
					<cfqueryparam value = "999" CFSQLType = "CF_SQL_INTEGER">,
					<cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">,
					<cfqueryparam value = "#body.usu_sms_aprovador#" CFSQLType = "CF_SQL_BIT">
				); 
					
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Usuário criado com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="usuarioUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{id}">
		
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.usuario  
				SET 
					usu_ativo = <cfqueryparam value = "#body.statusSelected#" CFSQLType = "CF_SQL_TINYINT">,
					per_id = <cfqueryparam value = "#body.perfil.id#" CFSQLType = "CF_SQL_BIGINT">,
					usu_login = <cfqueryparam value = "#body.login#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfif body.senhaChange>
						usu_senha = <cfqueryparam value = "#hash(body.senha, 'SHA-512')#" CFSQLType = "CF_SQL_VARCHAR">,
					</cfif>
					usu_nome = <cfqueryparam value = "#body.nome#" CFSQLType = "CF_SQL_VARCHAR">,
					usu_email = <cfqueryparam value = "#body.email#" CFSQLType = "CF_SQL_VARCHAR">,
					usu_cpf = <cfqueryparam value = "#body.cpf#" CFSQLType = "CF_SQL_VARCHAR">,
					usu_senhaExpira = <cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">,
					usu_mudarSenha = <cfqueryparam value = "#body.senhaModificar#" CFSQLType = "CF_SQL_BIT">,
					usu_tentativasLogin = <cfqueryparam value = "999" CFSQLType = "CF_SQL_INTEGER">,
					usu_countTentativasLogin = <cfqueryparam value = "0" CFSQLType = "CF_SQL_INTEGER">,
					usu_sms_aprovador = <cfqueryparam value = "#body.usu_sms_aprovador#" CFSQLType = "CF_SQL_BIT">
				WHERE 
					usu_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_NUMERIC">  				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Usuário atualizado com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="usuarioRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
                        dbo.usuario 
                    WHERE 
                        usu_id = <cfqueryparam value = "#i.usu_id#" CFSQLType = "CF_SQL_BIGINT">					
				</cfquery>
			</cfloop>			

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="usuarioRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{id}"
		>
		
		<cfargument name="id" restargsource="Path" type="numeric"/>		

		<cfset checkAuthentication(state = ['perfil-usuario'])>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
                    dbo.usuario 
                WHERE 
                    usu_id = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_BIGINT">    
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Usuário removido com sucesso!'>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

	<cffunction name="jsTreeCedente" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{usuario}/{operador}"> 

		<cfargument name="usuario" restargsource="Path" type="numeric"/>
		<cfargument name="operador" restargsource="Path" type="numeric"/>		
        
		<cfset checkAuthentication(state = ['perfil-usuario'])>
		
		<!--- <cfif not session.perfilAdmin>
			<cfset responseError(403, "Permissão negada")>
		</cfif> --->

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="qCedente">
				SELECT
					CB053.CB053_CD_EMIEMP
					,CB053.CB053_DS_EMIEMP
											
					,(SELECT 
							COUNT(1) 
						FROM 
							dbo.usuario_cedente AS usuario_check 
						WHERE 
							usuario_check.cedente_id = CB053.CB053_CD_EMIEMP
						AND usuario_check.per_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.usuario#">
						AND grupo_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.operador#">
					) AS cedente_check    
				FROM
					dbo.CB053 AS CB053

				<!--- Cedentes específicos --->
				<!---
					LEFT OUTER JOIN dbo.usuario_cedente AS  usuario_cedente
					ON CB053.CB053_CD_EMIEMP = usuario_cedente.cedente_id
					AND CB053.CB053_NR_INST = usuario_cedente.grupo_id

					WHERE CB053_CD_EMIEMP IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.usuario_cedente#" list="true">)					
					AND grupo_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.operador#">
				--->
				<!--- Todos os cedentes --->
					WHERE CB053_NR_INST = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.operador#">
				
				ORDER BY
					CB053_DS_EMIEMP
			</cfquery>
			
			<cfscript>			
				var jstree = structNew();
				var plugins = arrayNew(1);
				var data = arrayNew(1);
				var dataObj = structNew();

				arrayAppend(plugins, "wholerow");
				arrayAppend(plugins, "checkbox");

				for(item in qCedente) {
					dataObj = structNew();
					dataObj["id"] = item.CB053_CD_EMIEMP;
					dataObj["text"] = item.CB053_DS_EMIEMP;
					dataObj["state"]["selected"] = item.CEDENTE_CHECK;
					arrayAppend(data, dataObj);
				}
				/*
				dataObj["text"] = "Teste";
				dataObj["children"] = [{"text": "Teste selected"},{"state":{"selected": true}}];

				arrayAppend(data, dataObj);			
				*/
			
				jstree["plugins"] = plugins;
				jstree["core"]["themes"] = {"name": "proton", "responsive": true};
				jstree["core"]["data"] = data;
			</cfscript>		
			
			<cfset response["qCedente"] = QueryToArray(qCedente)>
			<cfset response["jstree"] = jstree>
			<cfset response["success"] = true>
			
			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["catch"] = cfcatch>	
			</cfcatch>	
		
		</cftry>

		<cfreturn SerializeJSON(response)>
    </cffunction>

</cfcomponent>