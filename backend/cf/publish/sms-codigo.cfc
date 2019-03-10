<cfcomponent rest="true" restPath="publish/sms/codigo">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="codigoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-codigo'])>
		<cfset cedenteValidate()>
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	MG055
                WHERE
                    1 = 1

				AND MG055_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG055_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG055_CD_CODSMS") AND url.MG055_CD_CODSMS NEQ "">
					AND	MG055_CD_CODSMS = <cfqueryparam value = "#url.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
				<cfif IsDefined("url.MG055_DS_CODSMS") AND url.MG055_DS_CODSMS NEQ "">
					AND	MG055_DS_CODSMS LIKE <cfqueryparam value = "%#url.MG055_DS_CODSMS#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG055_CD_CODSMS ASC) AS ROW
					,MG055_NR_INST
					,MG055_CD_EMIEMP
					,MG055_CD_CODSMS
					,MG055_DS_CODSMS
				FROM
					MG055
				WHERE
					1 = 1

				AND MG055_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG055_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">	

				<cfif IsDefined("url.MG055_CD_CODSMS") AND url.MG055_CD_CODSMS NEQ "">
					AND	MG055_CD_CODSMS = <cfqueryparam value = "#url.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
				<cfif IsDefined("url.MG055_DS_CODSMS") AND url.MG055_DS_CODSMS NEQ "">
					AND	MG055_DS_CODSMS LIKE <cfqueryparam value = "%#url.MG055_DS_CODSMS#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				ORDER BY
					MG055_CD_CODSMS ASC	
                
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

	<cffunction name="CodigoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{MG055_NR_INST}/{MG055_CD_EMIEMP}/{MG055_CD_CODSMS}"> 

		<cfargument name="MG055_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG055_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="MG055_CD_CODSMS" restargsource="Path" type="numeric"/>		
		
		<cfset checkAuthentication(state = ['sms-codigo'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>
		
		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 MG055_NR_INST
					,MG055_CD_EMIEMP
					,MG055_CD_CODSMS
					,MG055_DS_CODSMS
					,MG055_ID_ATIVO
					,MG055_TP_CATEG
				FROM
					MG055
				WHERE
				    MG055_NR_INST = <cfqueryparam value = "#arguments.MG055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG055_CD_EMIEMP = <cfqueryparam value = "#arguments.MG055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG055_CD_CODSMS = <cfqueryparam value = "#arguments.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>

			<cfquery datasource="#application.datasource#" name="queryPacotes">
				SELECT
					ROW_NUMBER() OVER(ORDER BY MG071_NR_SEQ ASC) AS ROW
					,MG070_NM_PACOTE
					,MG071_NR_PACOTE AS MG070_NR_PACOTE
				FROM
					VW_MG071
				WHERE
					MG071_CD_CODSMS = <cfqueryparam value = "#arguments.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				ORDER BY
					MG071_NR_SEQ ASC	
			</cfquery>
			
			<cfset response["query"] = queryToArray(query)>
			<cfset response["queryPacotes"] = queryToArray(queryPacotes)>
			
			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="codigoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-codigo'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG055_CD_CODSMS:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				MG055_DS_CODSMS:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 40
				},
				MG055_ID_ATIVO: {
					label: 'SMS Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 3
				},  
				MG055_TP_CATEG: {
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
					1,
					1,	
					<cfqueryparam value = "#arguments.body.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.MG055_DS_CODSMS#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.MG055_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.MG055_TP_CATEG#" CFSQLType = "CF_SQL_NUMERIC">,
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
		restpath="/{MG055_NR_INST}/{MG055_CD_EMIEMP}/{MG055_CD_CODSMS}">
		
		<cfargument name="MG055_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG055_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="MG055_CD_CODSMS" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-codigo'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG055_CD_CODSMS:{
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				},
				MG055_DS_CODSMS:{
					label: 'Nome',
					type: 'string',
					required: true,
					maxLength: 40
				},
				MG055_ID_ATIVO: {
					label: 'SMS Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 3
				},  
				MG055_TP_CATEG: {
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
						dbo.MG055  
					SET 
						MG055_CD_CODSMS = <cfqueryparam value = "#arguments.body.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">,
						MG055_DS_CODSMS = <cfqueryparam value = "#arguments.body.MG055_DS_CODSMS#" CFSQLType = "CF_SQL_VARCHAR">,
						MG055_ID_ATIVO = <cfqueryparam value = "#arguments.body.MG055_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
						MG055_TP_CATEG = <cfqueryparam value = "#arguments.body.MG055_TP_CATEG#" CFSQLType = "CF_SQL_NUMERIC">
					WHERE 
						MG055_NR_INST = <cfqueryparam value = "#arguments.MG055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	MG055_CD_EMIEMP = <cfqueryparam value = "#arguments.MG055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	MG055_CD_CODSMS = <cfqueryparam value = "#arguments.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>

				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG071 
					WHERE 
						MG071_CD_CODSMS = <cfqueryparam value = "#arguments.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">;

					<cfloop array="#arguments.body.pacotes#" index="i">
						INSERT INTO 
							dbo.MG071
						(
							MG071_NR_PACOTE,
							MG071_CD_CODSMS,
							MG071_NR_SEQ,
							MG071_CD_OPESIS,
							MG071_DT_INCSIS,
							MG071_DT_ATUSIS
						) 
						VALUES (
							<cfqueryparam value = "#i.MG070_NR_PACOTE#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#arguments.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">,
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

		<cfset checkAuthentication(state = ['sms-codigo'])>

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
					    MG055_NR_INST = <cfqueryparam value = "#i.MG055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG055_CD_EMIEMP = <cfqueryparam value = "#i.MG055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG055_CD_CODSMS = <cfqueryparam value = "#i.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">				
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
		restpath="/{MG055_NR_INST}/{MG055_CD_EMIEMP}/{MG055_CD_CODSMS}"
		>
		
		<cfargument name="MG055_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="MG055_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="MG055_CD_CODSMS" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['sms-codigo'])>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.MG055 
				WHERE 
				     MG055_NR_INST = <cfqueryparam value = "#arguments.MG055_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	MG055_CD_EMIEMP = <cfqueryparam value = "#arguments.MG055_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG055_CD_CODSMS = <cfqueryparam value = "#arguments.MG055_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">						
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
	<cffunction name="codigoPacote" access="remote" returntype="String" httpmethod="GET" restPath="/pacote/{MG071_CD_CODSMS}"> 
		<cfargument name="MG071_CD_CODSMS" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['sms-codigo'])>
		<cfset cedenteValidate()>
		
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_MG071
                WHERE
                    1 = 1				
                AND MG071_CD_CODSMS = <cfqueryparam value = "#arguments.MG071_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG071_CD_CODSMS ASC) AS ROW
					,MG071_NR_PACOTE
					,MG071_CD_CODSMS
					,MG071_NR_SEQ
				FROM
					VW_MG071
				WHERE
					1 = 1

				AND MG071_CD_CODSMS = <cfqueryparam value = "#arguments.MG071_CD_CODSMS#" CFSQLType = "CF_SQL_NUMERIC">

				ORDER BY
					MG071_CD_CODSMS ASC	
                
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