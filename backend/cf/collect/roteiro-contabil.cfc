<cfcomponent rest="true" restPath="collect/roteiro-contabil">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="roteiroContabilGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	BKN509
                WHERE
                    1 = 1

				AND BKN509_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN509_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
                <cfif IsDefined("url.BKN509_CD_ROTCT") AND url.BKN509_CD_ROTCT NEQ "">
					AND	BKN509_CD_ROTCT = <cfqueryparam value = "#url.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.BKN509_NM_EVENTO") AND url.BKN509_NM_EVENTO NEQ "">
					AND	BKN509_NM_EVENTO LIKE <cfqueryparam value = "%#url.BKN509_NM_EVENTO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY BKN509_CD_ROTCT ASC) AS ROW
					,BKN509_NR_OPERADOR
					,BKN509_NR_CEDENTE 
					,BKN509_CD_ROTCT
					,BKN509_NM_EVENTO
					,BKN509_NR_CRED1
					,BKN509_NR_DEBT1
					,BKN509_NR_CRED2
					,BKN509_NR_DEBT2
					,BKN509_ST_REVER				
				FROM
					BKN509
				WHERE
					1 = 1

				AND BKN509_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN509_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
				<cfif IsDefined("url.BKN509_CD_ROTCT") AND url.BKN509_CD_ROTCT NEQ "">
					AND	BKN509_CD_ROTCT = <cfqueryparam value = "#url.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.BKN509_NM_EVENTO") AND url.BKN509_NM_EVENTO NEQ "">
					AND	BKN509_NM_EVENTO LIKE <cfqueryparam value = "%#url.BKN509_NM_EVENTO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  


				ORDER BY
					BKN509_CD_ROTCT ASC	
                
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

	
	<cffunction name="roteiroContabilGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{BKN509_NR_OPERADOR}/{BKN509_NR_CEDENTE}/{BKN509_CD_ROTCT}"> 

		<cfargument name="BKN509_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="BKN509_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="BKN509_CD_ROTCT" restargsource="Path" type="string"/>
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 BKN509_NR_OPERADOR
					,BKN509_NR_CEDENTE 
					,BKN509_CD_ROTCT
					,BKN509_NM_EVENTO
					,BKN509_NR_CRED1
					,BKN509_NR_DEBT1
					,BKN509_NR_CRED2
					,BKN509_NR_DEBT2
					,BKN509_ST_REVER				
				FROM
					BKN509
				WHERE
				    BKN509_NR_OPERADOR = <cfqueryparam value = "#arguments.BKN509_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN509_NR_CEDENTE = <cfqueryparam value = "#arguments.BKN509_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	BKN509_CD_ROTCT = <cfqueryparam value = "#arguments.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="roteiroContabilCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				BKN509_CD_ROTCT:{
					label: 'Código',
					type: '	string',
					required: true			
				},
				BKN509_NM_EVENTO:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 240
				},

				BKN509_NR_CRED1:{
					label: 'Conta Crédito 1',
					type: 'string',
					required: true,
					maxLength: 15
				},

				BKN509_NR_DEBT1:{
					label: 'Conta Débito 1',
					type: 'string',
					required: true,
					maxLength: 15
				},

				BKN509_NR_CRED2:{
					label: 'Conta Crédito 2',
					type: 'string',
					required: false,
					maxLength: 15
				},

				BKN509_NR_DEBT2:{
					label: 'Conta Débito 2',
					type: 'string',
					required: false,
					maxLength: 15
				},

				BKN509_ST_REVER:{
					label: 'Reversão',
					type: 'string',
					required: false,
					maxLength: 1
				}
				
			}>

			<cfset validate(arguments.body, bodyErrors)>
			
			<!--- create --->			
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.BKN509
				(   
					BKN509_NR_OPERADOR,
					BKN509_NR_CEDENTE,
					BKN509_CD_ROTCT,
					BKN509_NM_EVENTO,
					BKN509_NR_CRED1,
					BKN509_NR_DEBT1,
					BKN509_NR_CRED2,
					BKN509_NR_DEBT2,
					BKN509_ST_REVER,
					BKN509_NR_OPESIS,
					BKN509_DT_INCSIS,
					BKN509_DT_ATUSIS
				) 
					VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
				    <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,						
					<cfqueryparam value = "#arguments.body.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.BKN509_NM_EVENTO#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.BKN509_NR_CRED1#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.BKN509_NR_DEBT1#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.BKN509_NR_CRED2#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.BKN509_NR_DEBT2#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.BKN509_ST_REVER#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de roteiro contabil já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="roteiroContabilUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{BKN509_NR_OPERADOR}/{BKN509_NR_CEDENTE}/{BKN509_CD_ROTCT}"> 

		<cfargument name="BKN509_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="BKN509_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="BKN509_CD_ROTCT" restargsource="Path" type="string"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				BKN509_CD_ROTCT:{
					label: 'Código',
					type: '	string',
					required: true			
				},
				BKN509_NM_EVENTO:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 240
				},

				BKN509_NR_CRED1:{
					label: 'Conta Crédito 1',
					type: 'string',
					required: true,
					maxLength: 15
				},

				BKN509_NR_DEBT1:{
					label: 'Conta Débito 1',
					type: 'string',
					required: true,
					maxLength: 15
				},

				BKN509_NR_CRED2:{
					label: 'Conta Crédito 2',
					type: 'string',
					required: false,
					maxLength: 15
				},

				BKN509_NR_DEBT2:{
					label: 'Conta Débito 2',
					type: 'string',
					required: false,
					maxLength: 15
				},

				BKN509_ST_REVER:{
					label: 'Reversão',
					type: 'string',
					required: false,
					maxLength: 1
				}
				
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.BKN509  
				SET 
					BKN509_CD_ROTCT = <cfqueryparam value = "#arguments.body.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">,
					BKN509_NM_EVENTO = <cfqueryparam value = "#arguments.body.BKN509_NM_EVENTO#" CFSQLType = "CF_SQL_VARCHAR">,
					BKN509_NR_CRED1 = <cfqueryparam value = "#arguments.body.BKN509_NR_CRED1#" CFSQLType = "CF_SQL_VARCHAR">,
					BKN509_NR_DEBT1 = <cfqueryparam value = "#arguments.body.BKN509_NR_DEBT1#" CFSQLType = "CF_SQL_VARCHAR">,
					BKN509_ST_REVER = <cfqueryparam value = "#arguments.body.BKN509_ST_REVER#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
				    BKN509_NR_OPERADOR = <cfqueryparam value = "#arguments.BKN509_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN509_NR_CEDENTE = <cfqueryparam value = "#arguments.BKN509_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN509_CD_ROTCT = <cfqueryparam value = "#arguments.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de roteiroContabils já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="roteiroContabilRemove" access="remote" returnType="String" httpMethod="DELETE">		
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
						dbo.BKN509 
					WHERE 
				    	BKN509_NR_OPERADOR = <cfqueryparam value = "#i.BKN509_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					AND BKN509_NR_CEDENTE = <cfqueryparam value = "#i.BKN509_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
					AND	BKN509_CD_ROTCT = <cfqueryparam value = "#i.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="roteiroContabilRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{BKN509_NR_OPERADOR}/{BKN509_NR_CEDENTE}/{BKN509_CD_ROTCT}"> 

		<cfargument name="BKN509_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="BKN509_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="BKN509_CD_ROTCT" restargsource="Path" type="string"/>

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.BKN509 
				WHERE 
				    	BKN509_NR_OPERADOR = <cfqueryparam value = "#arguments.BKN509_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					AND BKN509_NR_CEDENTE = <cfqueryparam value = "#arguments.BKN509_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
					AND	BKN509_CD_ROTCT = <cfqueryparam value = "#arguments.BKN509_CD_ROTCT#" CFSQLType = "CF_SQL_VARCHAR">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>
	-->

</cfcomponent>