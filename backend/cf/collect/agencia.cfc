<cfcomponent rest="true" restPath="collect/agencia">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cffunction name="agenciaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB251
                WHERE
                    1 = 1

				AND CB251_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- admin --->
				<cfif session.perfilTipo EQ 1>
					AND CB251_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<cfelse>
					AND (CB251_NR_CEDENTE = 0 OR CB251_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">)
				</cfif>

				<cfif IsDefined("url.CB251_CD_COMPSC") AND url.CB251_CD_COMPSC NEQ "">
					AND	CB251_CD_COMPSC = <cfqueryparam value = "#url.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB250_NM_BANCO") AND url.CB250_NM_BANCO NEQ "">
					AND	CB250_NM_BANCO LIKE <cfqueryparam value = "%#url.CB250_NM_BANCO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

                <cfif IsDefined("url.CB251_NR_AGENC") AND url.CB251_NR_AGENC NEQ "">
					AND	CB251_NR_AGENC = <cfqueryparam value = "#url.CB251_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB251_NM_AGENC") AND url.CB251_NM_AGENC NEQ "">
					AND	CB251_NM_AGENC LIKE <cfqueryparam value = "%#url.CB251_NM_AGENC#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB251_CD_COMPSC ASC) AS ROW					
					,CB251_NR_OPERADOR
					,CB251_NR_CEDENTE					
					,CB251_CD_COMPSC
					,CB251_NR_AGENC
					,CB251_NR_DGAGEN
                    ,CB251_NM_AGENC
					,CB251_NR_CNPJ
					,CB251_NR_CEP
					,CB251_NM_END
					,CB251_NR_END
					,CB251_DS_COMPL
					,CB251_NM_BAIRRO		
					,CB251_SG_ESTADO
					,CB251_NM_CIDADE

					,CB250_NM_BANCO
				FROM
					VW_CB251
				WHERE
					1 = 1

				AND CB251_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<!--- admin --->
				<cfif session.perfilTipo EQ 1>
					AND CB251_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<cfelse>
					AND (CB251_NR_CEDENTE = 0 OR CB251_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">)
				</cfif>

				<cfif IsDefined("url.CB251_CD_COMPSC") AND url.CB251_CD_COMPSC NEQ "">
					AND	CB251_CD_COMPSC = <cfqueryparam value = "#url.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB250_NM_BANCO") AND url.CB250_NM_BANCO NEQ "">
					AND	CB250_NM_BANCO LIKE <cfqueryparam value = "%#url.CB250_NM_BANCO#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

                <cfif IsDefined("url.CB251_NR_AGENC") AND url.CB251_NR_AGENC NEQ "">
					AND	CB251_NR_AGENC = <cfqueryparam value = "#url.CB251_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB251_NM_AGENC") AND url.CB251_NM_AGENC NEQ "">
					AND	CB251_NM_AGENC LIKE <cfqueryparam value = "%#url.CB251_NM_AGENC#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 

				ORDER BY
					CB251_CD_COMPSC ASC	
                
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

	<cffunction name="agenciaGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB251_NR_OPERADOR}/{CB251_NR_CEDENTE}/{CB251_CD_COMPSC}/{CB251_NR_AGENC}"> 

		<cfargument name="CB251_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_NR_AGENC" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					CB251_NR_OPERADOR
					,CB251_NR_CEDENTE					
					,CB251_CD_COMPSC
					,CB251_NR_AGENC
					,CB251_NR_DGAGEN
                    ,CB251_NM_AGENC
					,CB251_NR_CNPJ
					,CB251_NR_CEP
					,CB251_NM_END
					,CB251_NR_END
					,CB251_DS_COMPL
					,CB251_NM_BAIRRO		
					,CB251_SG_ESTADO
					,CB251_NM_CIDADE

					,CB251_CD_COMPSC
					,CB250_NM_BANCO
				FROM
					VW_CB251
				WHERE
				    CB251_NR_OPERADOR = <cfqueryparam value = "#arguments.CB251_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB251_NR_CEDENTE = <cfqueryparam value = "#arguments.CB251_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB251_CD_COMPSC = <cfqueryparam value = "#arguments.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.CB251_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="agenciaCreate" access="remote" returnType="String" httpMethod="POST">		
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
					dbo.CB251
				(   					
					CB251_NR_OPERADOR,
					CB251_NR_CEDENTE,
					CB251_CD_COMPSC,
					CB251_NR_AGENC,
					CB251_NR_DGAGEN,
					CB251_NM_AGENC,
					CB251_NR_CNPJ,
					CB251_NR_CEP,
					CB251_NM_END,
					CB251_NR_END,
					CB251_DS_COMPL,
					CB251_NM_BAIRRO,					
					CB251_SG_ESTADO,
					CB251_NM_CIDADE,
					CB251_CD_OPESIS,
					CB251_DT_INCSIS,
					CB251_DT_ATUSIS
				) 
				VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB251_NR_AGENC#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NR_DGAGEN#" CFSQLType = "CF_SQL_CHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NM_AGENC#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NR_CNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NR_CEP#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NM_END#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NR_END#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_DS_COMPL#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB251_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">,					
					<cfqueryparam value = "#arguments.body.CB251_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">,					
					<cfqueryparam value = "#arguments.body.CB251_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">,			
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
				<cfset responseError(400, cfcatch.detail)>
					<cfset responseError(400, "Código de agência já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="agenciaUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB251_NR_OPERADOR}/{CB251_NR_CEDENTE}/{CB251_CD_COMPSC}/{CB251_NR_AGENC}"> 
				
		<cfargument name="CB251_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_NR_AGENC" restargsource="Path" type="numeric"/>
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
					dbo.CB251  
				SET 
					CB251_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">,
					CB251_NR_AGENC = <cfqueryparam value = "#arguments.body.CB251_NR_AGENC#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_NR_DGAGEN = <cfqueryparam value = "#arguments.body.CB251_NR_DGAGEN#" CFSQLType = "CF_SQL_CHAR">,
					CB251_NM_AGENC = <cfqueryparam value = "#arguments.body.CB251_NM_AGENC#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_NR_CNPJ = <cfqueryparam value = "#arguments.body.CB251_NR_CNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_NR_CEP = <cfqueryparam value = "#arguments.body.CB251_NR_CEP#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_NM_END = <cfqueryparam value = "#arguments.body.CB251_NM_END#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_NR_END = <cfqueryparam value = "#arguments.body.CB251_NR_END#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_DS_COMPL = <cfqueryparam value = "#arguments.body.CB251_DS_COMPL#" CFSQLType = "CF_SQL_VARCHAR">,
					CB251_NM_BAIRRO = <cfqueryparam value = "#arguments.body.CB251_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">,					
					CB251_SG_ESTADO = <cfqueryparam value = "#arguments.body.CB251_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">,					
					CB251_NM_CIDADE = <cfqueryparam value = "#arguments.body.CB251_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
				    CB251_NR_OPERADOR = <cfqueryparam value = "#arguments.CB251_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB251_NR_CEDENTE = <cfqueryparam value = "#arguments.CB251_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB251_CD_COMPSC = <cfqueryparam value = "#arguments.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.CB251_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de agência já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="agenciaRemove" access="remote" returnType="String" httpMethod="DELETE">		
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
						dbo.CB251 
					WHERE 
						CB251_NR_OPERADOR = <cfqueryparam value = "#i.CB251_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB251_NR_CEDENTE = <cfqueryparam value = "#i.CB251_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
					AND	CB251_CD_COMPSC = <cfqueryparam value = "#i.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB251_NR_AGENC = <cfqueryparam value = "#i.CB251_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="agenciaRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB251_NR_OPERADOR}/{CB251_NR_CEDENTE}/{CB251_CD_COMPSC}/{CB251_NR_AGENC}"> 
				
		<cfargument name="CB251_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB251_NR_AGENC" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB251 
				WHERE 
				    CB251_NR_OPERADOR = <cfqueryparam value = "#arguments.CB251_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB251_NR_CEDENTE = <cfqueryparam value = "#arguments.CB251_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB251_CD_COMPSC = <cfqueryparam value = "#arguments.CB251_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.CB251_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
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