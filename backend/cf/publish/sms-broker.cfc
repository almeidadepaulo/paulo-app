<cfcomponent rest="true" restPath="publish/sms/broker">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="brokerGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-broker'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_MG050
                WHERE
                    1 = 1

				AND MG050_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG050_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				
                <cfif IsDefined("url.MG050_NR_BROKER") AND url.MG050_NR_BROKER NEQ "">
					AND	MG050_NR_BROKER = <cfqueryparam value = "#url.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG050_NM_BROKER") AND url.MG050_NM_BROKER NEQ "">
					AND	MG050_NM_BROKER LIKE <cfqueryparam value = "%#url.MG050_NM_BROKER#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG050_NR_BROKER ASC) AS ROW
					,MG050_NR_OPERADOR
					,MG050_NR_CEDENTE
					,MG050_NR_BROKER
					,MG050_NM_BROKER
				FROM
					VW_MG050
				WHERE
					1 = 1

				AND MG050_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG050_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.MG050_NR_BROKER") AND url.MG050_NR_BROKER NEQ "">
					AND	MG050_NR_BROKER = <cfqueryparam value = "#url.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.MG050_NM_BROKER") AND url.MG050_NM_BROKER NEQ "">
					AND	MG050_NM_BROKER LIKE <cfqueryparam value = "%#url.MG050_NM_BROKER#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					MG050_NR_BROKER ASC	
                
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

	<cffunction name="brokerGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{MG050_NR_OPERADOR}/{MG050_NR_CEDENTE}/{MG050_NR_BROKER}"> 

		<cfargument name="MG050_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="MG050_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="MG050_NR_BROKER" restargsource="Path" type="numeric"/>
				
		<cfset checkAuthentication(state = ['sms-broker'])>			
		<cfset cedenteValidate()>			
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 MG050.MG050_NR_OPERADOR
					,MG050.MG050_NR_CEDENTE
					,MG050.MG050_NR_BROKER
					,MG050.MG050_NM_BROKER
					,MG050.MG050_ID_ATIVO

					,MG051.MG051_CD_TARIFA
    				,MG051.MG051_VL_CUSTO

					,MG052.MG052_NM_USER
    				,MG052.MG052_NM_SENHA
				FROM
					MG050 AS MG050

				LEFT OUTER JOIN MG051 AS MG051
				ON MG051.MG051_NR_OPERADOR = MG050.MG050_NR_OPERADOR
				AND MG051.MG051_NR_CEDENTE = MG050.MG050_NR_CEDENTE
				AND MG051.MG051_NR_BROKER = MG050.MG050_NR_BROKER
				AND MG051.MG051_CD_TARIFA = 1

				LEFT OUTER JOIN MG052 AS MG052
				ON MG052.MG052_NR_OPERADOR = MG050.MG050_NR_OPERADOR
				AND MG052.MG052_NR_CEDENTE = MG050.MG050_NR_CEDENTE
				AND MG052.MG052_NR_BROKER = MG050.MG050_NR_BROKER				

				WHERE
				    MG050_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG050_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG050_NR_BROKER = <cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

		<cfreturn new lib.JsonSerializer().serialize(response)>

    </cffunction>

	<cffunction name="brokerCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-broker'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- validate --->
			<cfset bodyErrors = {
				MG050_NR_BROKER: {
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				} ,
				MG050_NM_BROKER: {
					label: 'Nome',
					type: 'string',
					required: true,			
					maxLength: 60
				} , 
				MG050_ID_ATIVO: {
					label: 'Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 2
				} , 
				MG051_VL_CUSTO: {
					label: 'Tarifa',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 99999
				} ,
				MG052_NM_USER: {
					label: 'Usuário',
					type: 'string',
					required: true,			
					maxLength: 20
				} ,
				MG052_NM_SENHA: {
					label: 'Usuário',
					type: 'string',
					required: true,			
					maxLength: 20
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- create --->
			<cftransaction>
				<cfquery datasource="#application.datasource#" name="query">
					INSERT INTO 
						dbo.MG050
					(   
						MG050_NR_OPERADOR,
						MG050_NR_CEDENTE,
						MG050_NR_BROKER,
						MG050_NM_BROKER,
						MG050_NR_PORCEN,
						MG050_ID_ATIVO,
						MG050_CD_OPESIS,
						MG050_DT_INCSIS,
						MG050_DT_ATUSIS
					) 
						VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG050_NM_BROKER#" CFSQLType = "CF_SQL_VARCHAR">,
						<cfqueryparam value = "#arguments.body.MG050_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
						0,
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);
				</cfquery>

				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG051 
					WHERE 
						MG051_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND MG051_NR_BROKER = <cfqueryparam value = "#arguments.body.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
					AND MG051_CD_TARIFA = 1;

					INSERT INTO 
						dbo.MG051
					(
						MG051_NR_OPERADOR,
						MG051_NR_CEDENTE,
						MG051_NR_BROKER,
						MG051_CD_TARIFA,
						MG051_DT_VALID,
						MG051_DT_ENCERR,
						MG051_QT_INI,
						MG051_QT_FIM,
						MG051_VL_CUSTO,
						MG051_ID_ATIVO,
						MG051_CD_OPESIS,
						MG051_DT_INCSIS,
						MG051_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
						1,
						20000101,
						20991231,
						1,
						99999,
						<cfqueryparam value = "#arguments.body.MG051_VL_CUSTO#" CFSQLType = "CF_SQL_FLOAT">,
						1,
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);

					DELETE FROM 
						dbo.MG052
					WHERE 
						MG052_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG052_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG052_NR_BROKER = <cfqueryparam value = "#arguments.body.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">					

					INSERT INTO 
						dbo.MG052
					(
						MG052_NR_OPERADOR,
						MG052_NR_CEDENTE,
						MG052_NR_BROKER,
						MG052_NM_USER,				
						MG052_NM_SENHA,
						MG052_CD_OPESIS,
						MG052_DT_INCSIS,
						MG052_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG052_NM_USER#" CFSQLType = "CF_SQL_VARCHAR">,						
						<cfqueryparam value = "#arguments.body.MG052_NM_SENHA#" CFSQLType = "CF_SQL_VARCHAR">,
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
					<cfset responseError(400, "Código de broker já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="brokerUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{MG050_NR_OPERADOR}/{MG050_NR_CEDENTE}/{MG050_NR_BROKER}">
		
		<cfargument name="MG050_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="MG050_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="MG050_NR_BROKER" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-broker'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<cfset bodyErrors = {
				MG050_NR_BROKER: {
					label: 'Código',
					type: 'numeric',
					required: true,			
					max: 99999
				} ,
				MG050_NM_BROKER: {
					label: 'Nome',
					type: 'string',
					required: true,			
					maxLength: 60
				} , 
				MG050_ID_ATIVO: {
					label: 'Ativo',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 2
				} , 
				MG051_VL_CUSTO: {
					label: 'Tarifa',
					type: 'numeric',
					required: true,			
					min: 0,
					max: 99999
				} ,
				MG052_NM_USER: {
					label: 'Usuário',
					type: 'string',
					required: true,			
					maxLength: 20
				} ,
				MG052_NM_SENHA: {
					label: 'Usuário',
					type: 'string',
					required: true,			
					maxLength: 20
				}
			}>

			<cfset validate(arguments.body, bodyErrors)>

			<!--- update --->
			<cftransaction>							
				<cfquery datasource="#application.datasource#">
					UPDATE 
						dbo.MG050  
					SET 
						MG050_NR_BROKER = <cfqueryparam value = "#arguments.body.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
						MG050_NM_BROKER = <cfqueryparam value = "#arguments.body.MG050_NM_BROKER#" CFSQLType = "CF_SQL_VARCHAR">,
						MG050_ID_ATIVO = <cfqueryparam value = "#arguments.body.MG050_ID_ATIVO#" CFSQLType = "CF_SQL_VARCHAR">
					WHERE 
						MG050_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG050_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG050_NR_BROKER = <cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">		
				</cfquery>

				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG051
					WHERE 
						MG051_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND MG051_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG051_NR_BROKER = <cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">
					AND MG051_CD_TARIFA = 1;

					INSERT INTO 
						dbo.MG051
					(
						MG051_NR_OPERADOR,
						MG051_NR_CEDENTE,
						MG051_NR_BROKER,
						MG051_CD_TARIFA,
						MG051_DT_VALID,
						MG051_DT_ENCERR,
						MG051_QT_INI,
						MG051_QT_FIM,
						MG051_VL_CUSTO,
						MG051_ID_ATIVO,
						MG051_CD_OPESIS,
						MG051_DT_INCSIS,
						MG051_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
						1,
						20000101,
						20991231,
						1,
						99999,
						<cfqueryparam value = "#arguments.body.MG051_VL_CUSTO#" CFSQLType = "CF_SQL_FLOAT">,
						1,
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);

					DELETE FROM 
						dbo.MG052
					WHERE 
						MG052_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG052_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">	
					AND MG052_NR_BROKER = <cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">

					INSERT INTO 
						dbo.MG052
					(
						MG052_NR_OPERADOR,
						MG052_NR_CEDENTE,
						MG052_NR_BROKER,
						MG052_NM_USER,						
						MG052_NM_SENHA,
						MG052_CD_OPESIS,
						MG052_DT_INCSIS,
						MG052_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.MG052_NM_USER#" CFSQLType = "CF_SQL_VARCHAR">,						
						<cfqueryparam value = "#arguments.body.MG052_NM_SENHA#" CFSQLType = "CF_SQL_VARCHAR">,
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
					<cfset responseError(400, "Código de brokers já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="brokerRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['sms-broker'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.MG050 
					WHERE 
					    MG050_NR_OPERADOR = <cfqueryparam value = "#i.MG050_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">			
					AND MG050_NR_CEDENTE = <cfqueryparam value = "#i.MG050_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">	
					AND	MG050_NR_BROKER = <cfqueryparam value = "#i.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="brokerRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{MG050_NR_OPERADOR}/{MG050_NR_CEDENTE}/{MG050_NR_BROKER}"
		>
		
		<cfargument name="MG050_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="MG050_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="MG050_NR_BROKER" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['sms-broker'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.MG050 
				WHERE 
				    MG050_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">			
				AND MG050_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND	MG050_NR_BROKER = <cfqueryparam value = "#arguments.MG050_NR_BROKER#" CFSQLType = "CF_SQL_NUMERIC">				
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