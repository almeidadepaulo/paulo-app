<cfcomponent rest="true" restPath="publish/sms/mensagem">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cffunction name="mensagemGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-mensagem'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_MG061
                WHERE
                    1 = 1
				
				AND MG061_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG061_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG061_CD_CODSMS") AND url.MG061_CD_CODSMS NEQ "">
					AND	MG061_CD_CODSMS = <cfqueryparam value = "#url.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG055_DS_CODSMS") AND url.MG055_DS_CODSMS NEQ "">
					AND	MG055_DS_CODSMS LIKE <cfqueryparam value = "%#url.MG055_DS_CODSMS#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG061_DS_TEXTO") AND url.MG061_DS_TEXTO NEQ "">
					AND	MG061_DS_TEXTO LIKE <cfqueryparam value = "%#url.MG061_DS_TEXTO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG061_CD_CODSMS ASC) AS ROW
					,MG061_NR_INST
					,MG061_CD_EMIEMP
					,MG061_CD_CODSMS
					,MG061_DS_TEXTO
					,MG061_QT_CARACT
					,MG061_ID_ATIVO
					,MG061_ID_STATUS

					,MG055_DS_CODSMS
				FROM
					VW_MG061
				WHERE
					1 = 1

				AND MG061_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG061_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.MG061_CD_CODSMS") AND url.MG061_CD_CODSMS NEQ "">
					AND	MG061_CD_CODSMS = <cfqueryparam value = "#url.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG055_DS_CODSMS") AND url.MG055_DS_CODSMS NEQ "">
					AND	MG055_DS_CODSMS LIKE <cfqueryparam value = "%#url.MG055_DS_CODSMS#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG061_DS_TEXTO") AND url.MG061_DS_TEXTO NEQ "">
					AND	MG061_DS_TEXTO LIKE <cfqueryparam value = "%#url.MG061_DS_TEXTO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					MG061_CD_CODSMS ASC	
                
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

	<cffunction name="mensagemGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{MG061_NR_INST}/{MG061_CD_EMIEMP}/{MG061_CD_CODSMS}"> 

		<cfargument name="MG061_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG061_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="MG061_CD_CODSMS" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['sms-mensagem'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 MG061_NR_INST
					,MG061_CD_EMIEMP
					,MG061_CD_CODSMS
					,MG061_DS_TEXTO
					,MG061_QT_CARACT
					,MG061_ID_ATIVO
					,MG061_ID_STATUS

					,MG055_DS_CODSMS	
				FROM
					VW_MG061
				WHERE
				    MG061_NR_INST = <cfqueryparam value = "#arguments.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG061_CD_EMIEMP = <cfqueryparam value = "#arguments.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG061_CD_CODSMS = <cfqueryparam value = "#arguments.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="mensagemCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-mensagem'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG061_CD_CODSMS:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				MG061_DS_TEXTO:{
					label: 'Mensagem',
					type: 'string',
					required: true,
					maxLength: 140
				},
				MG061_ID_ATIVO:{
					label: 'Ativo',
					type: 'numeric'
				},
				MG061_ID_STATUS:{
					label: 'Mensagem aprovada',
					type: 'numeric'
				},				
				MG061_QT_CARACT:{
					label: 'Quantidade de caracteres',
					type: 'numeric',
					required: true,
					max: 140
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- create --->
			<cftransaction>
				<cfquery datasource="#application.datasource#">
					DELETE FROM
						dbo.MG055
					WHERE 
						MG055_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG055_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG055_CD_CODSMS = <cfqueryparam value = "#arguments.body.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">

					INSERT INTO 
						dbo.MG055
					(
						MG055_NR_INST,
						MG055_CD_EMIEMP,
						MG055_CD_CODSMS,
						MG055_DS_CODSMS,
						MG055_ID_ATIVO,
						MG055_TP_CATEG,
						MG055_CD_OPESIS,
						MG055_DT_INCSIS,
						MG055_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG055_DS_CODSMS#" CFSQLType = "CF_SQL_VARCHAR">,
						1,
						0,
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);
				</cfquery>


				<cfquery datasource="#application.datasource#" name="query">
					INSERT INTO 
						dbo.MG061
					(   
						MG061_NR_INST
						,MG061_CD_EMIEMP
						,MG061_CD_CODSMS
						,MG061_DS_TEXTO
						,MG061_QT_CARACT					
						,MG061_ID_ATIVO
						,MG061_ID_STATUS					
						,MG061_CD_OPESIS
						,MG061_DT_INCSIS
						,MG061_DT_ATUSIS
					) 
						VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG061_DS_TEXTO#" CFSQLType = "CF_SQL_VARCHAR">,
						<cfqueryparam value = "#arguments.body.MG061_QT_CARACT#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfif session.smsAprovador EQ 1>
							<cfqueryparam value = "#arguments.body.MG061_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#arguments.body.MG061_ID_STATUS#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfelse>
							2,
							0,
						</cfif>
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);
				</cfquery>

			</cftransaction>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
				<cfset responseError(400, cfcatch.detail)>
					<cfset responseError(400, "Código de mensagem já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="mensagemUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{MG061_NR_INST}/{MG061_CD_EMIEMP}/{MG061_CD_CODSMS}">
		
		<cfargument name="MG061_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG061_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="MG061_CD_CODSMS" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-mensagem'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG061_CD_CODSMS:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				MG061_DS_TEXTO:{
					label: 'Mensagem',
					type: 'string',
					required: true,
					maxLength: 140
				},
				MG061_ID_ATIVO:{
					label: 'Ativo',
					type: 'numeric'
				},
				MG061_ID_STATUS:{
					label: 'Mensagem aprovada',
					type: 'numeric'
				},				
				MG061_QT_CARACT:{
					label: 'Quantidade de caracteres',
					type: 'numeric',
					required: true,
					max: 140
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- update --->
			<cftransaction>
				<cfquery datasource="#application.datasource#">
					UPDATE 
						dbo.MG055  
					SET 										
						MG055_CD_CODSMS = <cfqueryparam value = "#arguments.body.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
						,MG055_DS_CODSMS = <cfqueryparam value = "#arguments.body.MG055_DS_CODSMS#" CFSQLType = "CF_SQL_VARCHAR">						
					WHERE 
						MG055_NR_INST = <cfqueryparam value = "#arguments.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	MG055_CD_EMIEMP = <cfqueryparam value = "#arguments.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG055_CD_CODSMS = <cfqueryparam value = "#arguments.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>

				<cfquery datasource="#application.datasource#">
					UPDATE 
						dbo.MG061  
					SET 
						MG061_CD_CODSMS = <cfqueryparam value = "#arguments.body.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">,
						MG061_DS_TEXTO = <cfqueryparam value = "#arguments.body.MG061_DS_TEXTO#" CFSQLType = "CF_SQL_VARCHAR">,
						<cfif session.smsAprovador EQ 1>
							MG061_ID_ATIVO = <cfqueryparam value = "#arguments.body.MG061_ID_ATIVO#" CFSQLType = "CF_SQL_VARCHAR">,
							MG061_ID_STATUS = <cfqueryparam value = "#arguments.body.MG061_ID_STATUS#" CFSQLType = "CF_SQL_VARCHAR">,
						</cfif>
						MG061_QT_CARACT = <cfqueryparam value = "#arguments.body.MG061_QT_CARACT#" CFSQLType = "CF_SQL_VARCHAR">
					WHERE 
						MG061_NR_INST = <cfqueryparam value = "#arguments.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	MG061_CD_EMIEMP = <cfqueryparam value = "#arguments.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG061_CD_CODSMS = <cfqueryparam value = "#arguments.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			<cftransaction>
			

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de mensagems já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="mensagemRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-mensagem'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG055 					
					WHERE 
						MG055_NR_INST = <cfqueryparam value = "#i.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	MG055_CD_EMIEMP = <cfqueryparam value = "#i.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG055_CD_CODSMS = <cfqueryparam value = "#i.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
					;

					DELETE FROM 
						dbo.MG061 
					WHERE 
						MG061_NR_INST = <cfqueryparam value = "#i.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	MG061_CD_EMIEMP = <cfqueryparam value = "#i.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG061_CD_CODSMS = <cfqueryparam value = "#i.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="mensagemRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{MG061_NR_INST}/{MG061_CD_EMIEMP}/{MG061_CD_CODSMS}"
		>
		
		<cfargument name="MG061_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG061_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="MG061_CD_CODSMS" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['sms-mensagem'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.MG055 					
				WHERE 
					MG055_NR_INST = <cfqueryparam value = "#arguments.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG055_CD_EMIEMP = <cfqueryparam value = "#arguments.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG055_CD_CODSMS = <cfqueryparam value = "#arguments.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				;

				DELETE FROM 
					dbo.MG061 
				WHERE 
				    MG061_NR_INST = <cfqueryparam value = "#arguments.MG061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG061_CD_EMIEMP = <cfqueryparam value = "#arguments.MG061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG061_CD_CODSMS = <cfqueryparam value = "#arguments.MG061_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
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