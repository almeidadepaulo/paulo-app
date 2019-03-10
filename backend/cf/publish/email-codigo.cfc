<cfcomponent rest="true" restPath="publish/email/codigo">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="get" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-codigo'])>
		<cfset cedenteValidate()>
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	EM055
                WHERE
                    1 = 1

				AND EM055_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM055_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.EM055_CD_CODEMAIL") AND url.EM055_CD_CODEMAIL NEQ "">
					AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#url.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
				
				<cfif IsDefined("url.EM055_DS_CODEMAIL") AND url.EM055_DS_CODEMAIL NEQ "">
					AND	EM055_DS_CODEMAIL LIKE <cfqueryparam value = "%#url.EM055_DS_CODEMAIL#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				AND EM055_CD_CODEMAIL <> 0
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM055_CD_CODEMAIL ASC) AS ROW
					,EM055_NR_INST
					,EM055_CD_EMIEMP
					,EM055_CD_CODEMAIL
					,EM055_DS_CODEMAIL
				FROM
					EM055
				WHERE
					1 = 1

				AND EM055_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM055_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">	

				<cfif IsDefined("url.EM055_CD_CODEMAIL") AND url.EM055_CD_CODEMAIL NEQ "">
					AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#url.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.EM055_DS_CODEMAIL") AND url.EM055_DS_CODEMAIL NEQ "">
					AND	EM055_DS_CODEMAIL LIKE <cfqueryparam value = "%#url.EM055_DS_CODEMAIL#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				AND EM055_CD_CODEMAIL <> 0

				ORDER BY
					EM055_CD_CODEMAIL ASC	
                
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

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{EM055_NR_INST}/{EM055_CD_EMIEMP}/{EM055_CD_CODEMAIL}"> 

		<cfargument name="EM055_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM055_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="EM055_CD_CODEMAIL" restargsource="Path" type="numeric"/>		
		
		<cfset checkAuthentication(state = ['email-codigo'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 EM055_NR_INST
					,EM055_CD_EMIEMP
					,EM055_CD_CODEMAIL
					,EM055_DS_CODEMAIL
					,EM055_ID_ATIVO
					,EM055_TP_CATEG
				FROM
					EM055
				WHERE
				    EM055_NR_INST = <cfqueryparam value = "#arguments.EM055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM055_CD_EMIEMP = <cfqueryparam value = "#arguments.EM055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>

			<cfquery datasource="#application.datasource#" name="queryPacotes">
				SELECT
					ROW_NUMBER() OVER(ORDER BY EM071_NR_SEQ ASC) AS ROW
					,EM070_NM_PACOTE
					,EM071_NR_PACOTE AS EM070_NR_PACOTE
				FROM
					VW_EM071
				WHERE
					EM071_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				ORDER BY
					EM071_NR_SEQ ASC	
			</cfquery>
			
			<cfset response["query"] = queryToArray(query)>
			<cfset response["queryPacotes"] = queryToArray(queryPacotes)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="codigoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-codigo'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				EM055_CD_CODSMS:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				EM055_DS_CODSMS:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 80
				},
				EM055_ID_ATIVO: {
					label: 'SMS Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 3
				},  
				EM055_TP_CATEG: {
					label: 'SMS Promocional',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 3
				}  
			}>

			<cfset validate(arguments.body, bodyErrors)>
		
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.EM055
				(   
					EM055_NR_INST,
					EM055_CD_EMIEMP,
					EM055_CD_CODEMAIL,
					EM055_DS_CODEMAIL,
					EM055_ID_ATIVO,
					EM055_TP_CATEG,
					EM055_CD_OPESIS,
					EM055_DT_INCSIS,
					EM055_DT_ATUSIS
				) 
					VALUES (
					1,
					1,	
					<cfqueryparam value = "#arguments.body.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.EM055_DS_CODEMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.EM055_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.EM055_TP_CATEG#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código SMS já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="codigoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{EM055_NR_INST}/{EM055_CD_EMIEMP}/{EM055_CD_CODEMAIL}">
		
		<cfargument name="EM055_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM055_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="EM055_CD_CODEMAIL" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-codigo'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				EM055_CD_CODSMS:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				EM055_DS_CODSMS:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 80
				},
				EM055_ID_ATIVO: {
					label: 'SMS Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 3
				},  
				EM055_TP_CATEG: {
					label: 'SMS Promocional',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 3
				}  
			}>

			<cfset validate(arguments.body, bodyErrors)>
			<!--- update --->
			<cftransaction>							
				<cfquery datasource="#application.datasource#">
					UPDATE 
						dbo.EM055  
					SET 
						EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.body.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">,
						EM055_DS_CODEMAIL = <cfqueryparam value = "#arguments.body.EM055_DS_CODEMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
						EM055_ID_ATIVO = <cfqueryparam value = "#arguments.body.EM055_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
						EM055_TP_CATEG = <cfqueryparam value = "#arguments.body.EM055_TP_CATEG#" CFSQLType = "CF_SQL_NUMERIC">
					WHERE 
						EM055_NR_INST = <cfqueryparam value = "#arguments.EM055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM055_CD_EMIEMP = <cfqueryparam value = "#arguments.EM055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>

				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.EM071 
					WHERE 
						EM071_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">;

					<cfloop array="#arguments.body.pacotes#" index="i">
						INSERT INTO 
							dbo.EM071
						(
							EM071_NR_PACOTE,
							EM071_CD_CODEMAIL,
							EM071_NR_SEQ,
							EM071_CD_OPESIS,
							EM071_DT_INCSIS,
							EM071_DT_ATUSIS
						) 
						VALUES (
							<cfqueryparam value = "#i.EM070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#arguments.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#i.ROW#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
							GETDATE(),
							GETDATE()
						);
					</cfloop>

				</cfquery>
			</cftransaction>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>				
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de codigos já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="codigoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-codigo'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.EM055 
					WHERE 
					    EM055_NR_INST = <cfqueryparam value = "#i.EM055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM055_CD_EMIEMP = <cfqueryparam value = "#i.EM055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#i.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="codigoRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{EM055_NR_INST}/{EM055_CD_EMIEMP}/{EM055_CD_CODEMAIL}"
		>
		
		<cfargument name="EM055_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM055_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="EM055_CD_CODEMAIL" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['email-codigo'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.EM055 
				WHERE 
				     EM055_NR_INST = <cfqueryparam value = "#arguments.EM055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM055_CD_EMIEMP = <cfqueryparam value = "#arguments.EM055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM055_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">						
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<!--- codigo-pacote --->
	<cffunction name="codigoPacote" access="remote" returntype="String" httpmethod="GET" restPath="/pacote/{EM071_CD_CODEMAIL}"> 
		<cfargument name="EM071_CD_CODEMAIL" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['email-codigo'])>
		<cfset cedenteValidate()>
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_EM071
                WHERE
                    1 = 1				
                AND EM071_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM071_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM071_CD_CODEMAIL ASC) AS ROW
					,EM071_NR_PACOTE
					,EM071_CD_CODEMAIL
					,EM071_NR_SEQ
				FROM
					VW_EM071
				WHERE
					1 = 1

				AND EM071_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM071_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">

				ORDER BY
					EM071_CD_CODEMAIL ASC	
                
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

</cfcomponent>