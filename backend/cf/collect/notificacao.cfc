<cfcomponent rest="true" restPath="collect/notificacao">  
	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="notificacaoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['notificacao'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>
			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB261
               WHERE
					1 = 1

					AND	CB261_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND	CB261_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                    *
                FROM
                   	VW_CB261
               WHERE
					1 = 1

					AND	CB261_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND	CB261_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				ORDER BY
					CB261_NR_OPERADOR ASC	
                
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

	<cffunction name="notificacaoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB261_NR_OPERADOR}/{CB261_NR_CEDENTE}/{CB261_CD_COMPSC}/{CB261_NR_AGENC}/{CB261_NR_CONTA}/{CB261_CD_PUBLIC}/{CB261_CD_MSG}"> 

		<cfargument name="CB261_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB261_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB261_CD_COMPSC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_NR_AGENC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_NR_CONTA" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_CD_PUBLIC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_CD_MSG" restargsource="Path" type="numeric"/>		
		
		<cfset checkAuthentication(state = ['notificacao'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    *					
                FROM
                   	VW_CB261
               WHERE
				    CB261_NR_OPERADOR = <cfqueryparam value = "#arguments.CB261_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND CB261_NR_CEDENTE = <cfqueryparam value = "#arguments.CB261_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB261_CD_COMPSC = <cfqueryparam value = "#arguments.CB261_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_AGENC = <cfqueryparam value = "#arguments.CB261_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_CONTA = <cfqueryparam value = "#arguments.CB261_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_PUBLIC = <cfqueryparam value = "#arguments.CB261_CD_PUBLIC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_MSG = <cfqueryparam value = "#arguments.CB261_CD_MSG#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="notificacaoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['notificacao'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB261
				(   
                   	 CB261_NR_OPERADOR 
  				    ,CB261_NR_CEDENTE 
  				    ,CB261_CD_COMPSC 
  				    ,CB261_NR_AGENC 
  				    ,CB261_NR_CONTA 
  					,CB261_CD_PUBLIC 
  					,CB261_CD_MSG 
  					,CB261_ID_STATUS 
  					,CB261_NM_REGRA 
  					,CB261_TP_OPERADOR 					
  					,CB261_NR_DIAS 					
  					,CB261_TP_ACAO
  					,CB261_ID_ANEXO 
  					,CB261_CD_OPESIS 
  					,CB261_DT_INCSIS 
  					,CB261_DT_ATUSIS 
				) 
				  VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB261_CD_PUBLIC#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB261_CD_MSG#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB261_ID_STATUS#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB261_NM_REGRA#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "=" CFSQLType = "CF_SQL_VARCHAR">,
					<cfif IsDefined("arguments.body.CB261_NR_DIAS")>
						<cfqueryparam value = "#arguments.body.CB261_NR_DIAS#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam value = "#arguments.body.CB261_TP_ACAO#" CFSQLType = "CF_SQL_NUMERIC">,	
					<cfqueryparam value = "#arguments.body.CB261_ID_ANEXO#" CFSQLType = "CF_SQL_NUMERIC">,			  
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de notificacao já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="notificacaoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB261_NR_OPERADOR}/{CB261_NR_CEDENTE}/{CB261_CD_COMPSC}/{CB261_NR_AGENC}/{CB261_NR_CONTA}/{CB261_CD_PUBLIC}/{CB261_CD_MSG}"> 
		
		<cfargument name="CB261_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB261_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB261_CD_COMPSC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_NR_AGENC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_NR_CONTA" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_CD_PUBLIC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_CD_MSG" restargsource="Path" type="numeric"/>		

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['notificacao'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB261
				SET 
				  CB261_CD_COMPSC = <cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_NR_AGENC = <cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_NR_CONTA = <cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_CD_PUBLIC = <cfqueryparam value = "#arguments.body.CB261_CD_PUBLIC#" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_CD_MSG = <cfqueryparam value = "#arguments.body.CB261_CD_MSG#" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_ID_STATUS = <cfqueryparam value = "#arguments.body.CB261_ID_STATUS#" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_NM_REGRA = <cfqueryparam value = "#arguments.body.CB261_NM_REGRA#" CFSQLType = "CF_SQL_VARCHAR">,
				  CB261_TP_OPERADOR = <cfqueryparam value = "#arguments.body.CB261_TP_OPERADOR#" CFSQLType = "CF_SQL_VARCHAR">,
				  CB261_NR_DIAS = <cfqueryparam value = "#arguments.body.CB261_NR_DIAS#" CFSQLType = "CF_SQL_NUMERIC">,
				  CB261_TP_ACAO = <cfqueryparam value = "#arguments.body.CB261_TP_ACAO#" CFSQLType = "CF_SQL_NUMERIC">,	
				  CB261_ID_ANEXO = <cfqueryparam value = "#arguments.body.CB261_ID_ANEXO#" CFSQLType = "CF_SQL_NUMERIC">
				WHERE 
				    CB261_NR_OPERADOR = <cfqueryparam value = "#arguments.CB261_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND CB261_NR_CEDENTE = <cfqueryparam value = "#arguments.CB261_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB261_CD_COMPSC = <cfqueryparam value = "#arguments.CB261_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_AGENC = <cfqueryparam value = "#arguments.CB261_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_CONTA = <cfqueryparam value = "#arguments.CB261_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_PUBLIC = <cfqueryparam value = "#arguments.CB261_CD_PUBLIC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_MSG = <cfqueryparam value = "#arguments.CB261_CD_MSG#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de notificacao já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="notificacaoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['notificacao'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB261 
					WHERE 
				    CB261_NR_OPERADOR = <cfqueryparam value = "#i.CB261_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND CB261_NR_CEDENTE = <cfqueryparam value = "#i.CB261_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB261_CD_COMPSC = <cfqueryparam value = "#i.CB261_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_AGENC = <cfqueryparam value = "#i.CB261_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_CONTA = <cfqueryparam value = "#i.CB261_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_PUBLIC = <cfqueryparam value = "#i.CB261_CD_PUBLIC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_MSG = <cfqueryparam value = "#i.CB261_CD_MSG#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			
			<cfset response["message"] = 'Notificação removida com sucesso!'>
			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="notificacaoRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB261_NR_OPERADOR}/{CB261_NR_CEDENTE}/{CB261_CD_COMPSC}/{CB261_NR_AGENC}/{CB261_NR_CONTA}/{CB261_CD_PUBLIC}/{CB261_CD_MSG}"> 
		
		<cfargument name="CB261_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB261_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB261_CD_COMPSC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_NR_AGENC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_NR_CONTA" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_CD_PUBLIC" restargsource="Path" type="numeric"/>		
		<cfargument name="CB261_CD_MSG" restargsource="Path" type="numeric"/>		

		<cfset checkAuthentication(state = ['notificacao'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB261
				WHERE 
				    CB261_NR_OPERADOR = <cfqueryparam value = "#arguments.CB261_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
				AND CB261_NR_CEDENTE = <cfqueryparam value = "#arguments.CB261_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB261_CD_COMPSC = <cfqueryparam value = "#arguments.CB261_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_AGENC = <cfqueryparam value = "#arguments.CB261_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_NR_CONTA = <cfqueryparam value = "#arguments.CB261_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_PUBLIC = <cfqueryparam value = "#arguments.CB261_CD_PUBLIC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB261_CD_MSG = <cfqueryparam value = "#arguments.CB261_CD_MSG#" CFSQLType = "CF_SQL_NUMERIC">
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