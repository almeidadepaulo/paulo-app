<cfcomponent rest="true" restPath="collect/conta">  
	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="contaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>
			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB260
               WHERE
					1 = 1

				AND CB260_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB260_CD_COMPSC") AND url.CB260_CD_COMPSC NEQ "">
					AND	CB260_CD_COMPSC = <cfqueryparam value = "#url.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB260_NR_AGENC") AND url.CB260_CD_COMPSC NEQ "">
					AND	CB260_NR_AGENC = <cfqueryparam value = "#url.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
				
                <cfif IsDefined("url.CB260_NR_CONTA") AND url.CB260_NR_CONTA NEQ "">
					AND	CB260_NR_CONTA = <cfqueryparam value = "#url.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB260_NM_CEDENT") AND url.CB260_NM_CEDENT NEQ "">
					AND	CB260_NM_CEDENT LIKE <cfqueryparam value = "%#url.CB260_NM_CEDENT#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                    *
                FROM
                   	VW_CB260
               WHERE
					1 = 1

				AND CB260_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB260_CD_COMPSC") AND url.CB260_CD_COMPSC NEQ "">
					AND	CB260_CD_COMPSC = <cfqueryparam value = "#url.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB260_NR_AGENC") AND url.CB260_CD_COMPSC NEQ "">
					AND	CB260_NR_AGENC = <cfqueryparam value = "#url.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

                <cfif IsDefined("url.CB260_NR_CONTA") AND url.CB260_NR_CONTA NEQ "">
					AND	CB260_NR_CONTA = <cfqueryparam value = "#url.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB260_NM_CEDENT") AND url.CB260_NM_CEDENT NEQ "">
					AND	CB260_NM_CEDENT LIKE <cfqueryparam value = "%#url.CB260_NM_CEDENT#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				ORDER BY
					CB260_NR_CONTA ASC	
                
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

	<cffunction name="contaGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB260_NR_OPERADOR}/{CB260_NR_CEDENTE}/{CB260_CD_COMPSC}/{CB260_NR_AGENC}/{CB260_NR_CONTA}/{CB260_CD_CART}"> 

		<cfargument name="CB260_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_CONTA" restargsource="Path" type="numeric"/>	
		<cfargument name="CB260_CD_CART" restargsource="Path" type="numeric"/>	
		
		<cfset checkAuthentication(state = ['conta'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    *					
                FROM
                   	VW_CB260
               WHERE
				    CB260_NR_OPERADOR = <cfqueryparam value = "#arguments.CB260_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_NR_CEDENTE = <cfqueryparam value = "#arguments.CB260_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_CD_COMPSC = <cfqueryparam value = "#arguments.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">			
				AND CB260_NR_AGENC = <cfqueryparam value = "#arguments.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB260_NR_CONTA = <cfqueryparam value = "#arguments.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_CD_CART = <cfqueryparam value = "#arguments.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">				
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="contaCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['conta'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				IF NOT EXISTS 
					(SELECT 
						1 
					FROM
						CB256
					WHERE 
						CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB256_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB256_CD_CART = <cfqueryparam value = "#arguments.body.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">) 
				BEGIN
					INSERT INTO 
						dbo.CB256
					(
						CB256_NR_OPERADOR,
						CB256_NR_CEDENTE,
						CB256_CD_CART,
						CB256_DS_CART,
						CB256_DS_RESU,
						CB256_CD_OPESIS,
						CB256_DT_INCSIS,
						CB256_DT_ATUSIS
					) 
					SELECT
						CB256_NR_OPERADOR,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						CB256_CD_CART,
						CB256_DS_CART,
						CB256_DS_RESU,
						CB256_CD_OPESIS,
						CB256_DT_INCSIS,
						CB256_DT_ATUSIS
					FROM
						CB256
					WHERE
						CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = 0
					AND CB256_CD_CART = <cfqueryparam value = "#arguments.body.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">;
				END

				IF NOT EXISTS 
					(SELECT 
						1 
					FROM
						CB250 
					WHERE 
						CB250_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">  
					AND CB250_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB250_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">) 
				BEGIN
					INSERT INTO 
						dbo.CB250
					(
						CB250_NR_OPERADOR,
						CB250_NR_CEDENTE,
						CB250_CD_COMPSC,
						CB250_NM_BANCO,
						CB250_NR_CNPJ,
						CB250_NM_END,
						CB250_NR_END,
						CB250_DS_COMPL,
						CB250_NM_BAIRRO,
						CB250_CD_CIDADE,
						CB250_NM_CIDADE,
						CB250_SG_ESTADO,
						CB250_CD_PAIS,
						CB250_NR_CEP,
						CB250_NR_NOSNUM,
						CB250_CD_OPESIS,
						CB250_DT_INCSIS,
						CB250_DT_ATUSIS
					) 
					SELECT
						CB250_NR_OPERADOR,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						CB250_CD_COMPSC,
						CB250_NM_BANCO,
						CB250_NR_CNPJ,
						CB250_NM_END,
						CB250_NR_END,
						CB250_DS_COMPL,
						CB250_NM_BAIRRO,
						CB250_CD_CIDADE,
						CB250_NM_CIDADE,
						CB250_SG_ESTADO,
						CB250_CD_PAIS,
						CB250_NR_CEP,
						CB250_NR_NOSNUM,
						CB250_CD_OPESIS,
						CB250_DT_INCSIS,
						CB250_DT_ATUSIS
					FROM
						CB250
					WHERE
						CB250_NR_OPERADOR = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB250_NR_CEDENTE = 0
					AND CB250_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				END

				IF NOT EXISTS 
					(SELECT 
						1 
					FROM
						CB251
					WHERE 
						CB251_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB251_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB251_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">					
					AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.body.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">) 
				BEGIN
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
						CB251_NM_END,
						CB251_NR_END,
						CB251_DS_COMPL,
						CB251_NM_BAIRRO,
						CB251_CD_CIDADE,
						CB251_NM_CIDADE,
						CB251_SG_ESTADO,
						CB251_CD_PAIS,
						CB251_NR_CEP,
						CB251_CD_OPESIS,
						CB251_DT_INCSIS,
						CB251_DT_ATUSIS
					) 
					SELECT
						CB251_NR_OPERADOR,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						CB251_CD_COMPSC,
						CB251_NR_AGENC,
						CB251_NR_DGAGEN,
						CB251_NM_AGENC,
						CB251_NR_CNPJ,
						CB251_NM_END,
						CB251_NR_END,
						CB251_DS_COMPL,
						CB251_NM_BAIRRO,
						CB251_CD_CIDADE,
						CB251_NM_CIDADE,
						CB251_SG_ESTADO,
						CB251_CD_PAIS,
						CB251_NR_CEP,
						CB251_CD_OPESIS,
						CB251_DT_INCSIS,
						CB251_DT_ATUSIS
					FROM
						CB251
					WHERE
						CB251_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB251_NR_CEDENTE = 0
					AND CB251_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">					
					AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.body.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">;
				END
			</cfquery>

			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB260
				(  
				  CB260_NR_OPERADOR,
				  CB260_NR_CEDENTE,	 
                  CB260_CD_COMPSC ,
                  CB260_NR_AGENC  ,
                  CB260_NR_CONTA  ,
				  CB260_CD_CART	  ,
                  CB260_NR_DGCONT ,
                  CB260_NR_DGAGCT ,
                  CB260_NM_CEDENT ,
                  CB260_NR_CPFCNPJ,
                  CB260_TP_INSCRI ,
                  CB260_NM_END    ,
                  CB260_NR_END    ,
                  CB260_DS_COMPL  ,
                  CB260_NM_BAIRRO ,                  
                  CB260_NM_CIDADE ,
                  CB260_SG_ESTADO ,
                  CB260_CD_PAIS   ,
                  CB260_NR_CEP    ,
                  CB260_VL_LIQUID ,
                  CB260_VL_DEVOL  ,
                  CB260_VL_ACREAT ,
                  CB260_VL_ENTRAD ,
                  CB260_ID_ENCCOB ,
                  CB260_ID_INDREP ,
                  CB260_PZ_REPUBL ,
                  CB260_NR_NOSNUM , 
                  CB260_ID_INDNSN ,
                  CB260_ID_INDEXC ,
                  CB260_PZ_BAIXA  ,
				  CB260_ID_INTECC ,
                  CB260_CD_OPESIS , 
                  CB260_DT_INCSIS ,
                  CB260_DT_ATUSIS
				) 
				  VALUES (
				  <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
				  <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "#arguments.body.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "#arguments.body.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "#arguments.body.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">,			  
				  <cfqueryparam value = "#arguments.body.CB260_NR_DGCONT#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_NR_DGAGCT#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_NM_CEDENT#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "J" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_NM_END#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_NR_END#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_DS_COMPL#" CFSQLType = "CF_SQL_VARCHAR">,	
				  <cfqueryparam value = "#arguments.body.CB260_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">,  
				  <cfqueryparam value = "#arguments.body.CB260_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "1" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "#arguments.body.CB260_NR_CEP#" CFSQLType = "CF_SQL_VARCHAR">,
				  <cfqueryparam value = "#arguments.body.CB260_VL_LIQUID#" CFSQLType = "CF_SQL_FLOAT">,
				  <cfqueryparam value = "#arguments.body.CB260_VL_DEVOL#" CFSQLType = "CF_SQL_FLOAT">,
				  <cfqueryparam value = "#arguments.body.CB260_VL_ACREAT#" CFSQLType = "CF_SQL_FLOAT">,
				  <cfqueryparam value = "#arguments.body.CB260_VL_ENTRAD#" CFSQLType = "CF_SQL_FLOAT">,
				  <cfqueryparam value = "2" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "2" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "0" CFSQLType = "CF_SQL_NUMERIC">,
				  0,
				  <cfqueryparam value = "2" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "2" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "31" CFSQLType = "CF_SQL_NUMERIC">,
				  <cfqueryparam value = "#arguments.body.CB260_ID_INTECC#" CFSQLType = "CF_SQL_NUMERIC">,
                  <cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
				  GETDATE(),
				  GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">					
					<cfset responseError(400, "Código de conta já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="contaUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB260_NR_OPERADOR}/{CB260_NR_CEDENTE}/{CB260_CD_COMPSC}/{CB260_NR_AGENC}/{CB260_NR_CONTA}/{CB260_CD_CART}">
		
		<cfargument name="CB260_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_CONTA" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_CD_CART" restargsource="Path" type="numeric"/>

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['conta'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#" name="query">
				IF NOT EXISTS 
					(SELECT 
						1 
					FROM
						CB256
					WHERE 
						CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB256_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB256_CD_CART = <cfqueryparam value = "#arguments.body.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">) 
				BEGIN
					INSERT INTO 
						dbo.CB256
					(
						CB256_NR_OPERADOR,
						CB256_NR_CEDENTE,
						CB256_CD_CART,
						CB256_DS_CART,
						CB256_DS_RESU,
						CB256_CD_OPESIS,
						CB256_DT_INCSIS,
						CB256_DT_ATUSIS
					) 
					SELECT
						CB256_NR_OPERADOR,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						CB256_CD_CART,
						CB256_DS_CART,
						CB256_DS_RESU,
						CB256_CD_OPESIS,
						CB256_DT_INCSIS,
						CB256_DT_ATUSIS
					FROM
						CB256
					WHERE
						CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = 0
					AND CB256_CD_CART = <cfqueryparam value = "#arguments.body.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">;
				END

				IF NOT EXISTS 
					(SELECT 
						1 
					FROM
						CB250 
					WHERE 
						CB250_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">  
					AND CB250_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB250_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">) 
				BEGIN
					INSERT INTO 
						dbo.CB250
					(
						CB250_NR_OPERADOR,
						CB250_NR_CEDENTE,
						CB250_CD_COMPSC,
						CB250_NM_BANCO,
						CB250_NR_CNPJ,
						CB250_NM_END,
						CB250_NR_END,
						CB250_DS_COMPL,
						CB250_NM_BAIRRO,
						CB250_CD_CIDADE,
						CB250_NM_CIDADE,
						CB250_SG_ESTADO,
						CB250_CD_PAIS,
						CB250_NR_CEP,
						CB250_NR_NOSNUM,
						CB250_CD_OPESIS,
						CB250_DT_INCSIS,
						CB250_DT_ATUSIS
					) 
					SELECT
						CB250_NR_OPERADOR,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						CB250_CD_COMPSC,
						CB250_NM_BANCO,
						CB250_NR_CNPJ,
						CB250_NM_END,
						CB250_NR_END,
						CB250_DS_COMPL,
						CB250_NM_BAIRRO,
						CB250_CD_CIDADE,
						CB250_NM_CIDADE,
						CB250_SG_ESTADO,
						CB250_CD_PAIS,
						CB250_NR_CEP,
						CB250_NR_NOSNUM,
						CB250_CD_OPESIS,
						CB250_DT_INCSIS,
						CB250_DT_ATUSIS
					FROM
						CB250
					WHERE
						CB250_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB250_NR_CEDENTE = 0
					AND CB250_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				END

				IF NOT EXISTS 
					(SELECT 
						1 
					FROM
						CB251
					WHERE 
						CB251_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB251_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC"> 
					AND CB251_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">					
					AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.body.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">) 
				BEGIN
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
						CB251_NM_END,
						CB251_NR_END,
						CB251_DS_COMPL,
						CB251_NM_BAIRRO,
						CB251_CD_CIDADE,
						CB251_NM_CIDADE,
						CB251_SG_ESTADO,
						CB251_CD_PAIS,
						CB251_NR_CEP,
						CB251_CD_OPESIS,
						CB251_DT_INCSIS,
						CB251_DT_ATUSIS
					) 
					SELECT
						CB251_NR_OPERADOR,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						CB251_CD_COMPSC,
						CB251_NR_AGENC,
						CB251_NR_DGAGEN,
						CB251_NM_AGENC,
						CB251_NR_CNPJ,
						CB251_NM_END,
						CB251_NR_END,
						CB251_DS_COMPL,
						CB251_NM_BAIRRO,
						CB251_CD_CIDADE,
						CB251_NM_CIDADE,
						CB251_SG_ESTADO,
						CB251_CD_PAIS,
						CB251_NR_CEP,
						CB251_CD_OPESIS,
						CB251_DT_INCSIS,
						CB251_DT_ATUSIS
					FROM
						CB251
					WHERE
						CB251_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB251_NR_CEDENTE = 0
					AND CB251_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">					
					AND CB251_NR_AGENC = <cfqueryparam value = "#arguments.body.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">;
				END
			</cfquery>

			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB260
				SET 
					CB260_CD_COMPSC = <cfqueryparam value = "#arguments.body.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">,
					CB260_NR_AGENC = <cfqueryparam value = "#arguments.body.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">,
					CB260_NR_CONTA = <cfqueryparam value = "#arguments.body.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">,
					CB260_CD_CART = <cfqueryparam value = "#arguments.body.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">,
  				    CB260_NR_DGCONT = <cfqueryparam value = "#arguments.body.CB260_NR_DGCONT#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_NR_DGAGCT = <cfqueryparam value = "#arguments.body.CB260_NR_DGAGCT#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_NM_CEDENT = <cfqueryparam value = "#arguments.body.CB260_NM_CEDENT#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_NR_CPFCNPJ = <cfqueryparam value = "#arguments.body.CB260_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_TP_INSCRI = <cfqueryparam value = "#arguments.body.CB260_TP_INSCRI#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_NM_END = <cfqueryparam value = "#arguments.body.CB260_NM_END#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_NR_END = <cfqueryparam value = "#arguments.body.CB260_NR_END#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_DS_COMPL = <cfqueryparam value = "#arguments.body.CB260_DS_COMPL#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_NM_CIDADE = <cfqueryparam value = "#arguments.body.CB260_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_SG_ESTADO = <cfqueryparam value = "#arguments.body.CB260_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_CD_PAIS = <cfqueryparam value = "#arguments.body.CB260_CD_PAIS#" CFSQLType = "CF_SQL_NUMERIC">,
				    CB260_NR_CEP = <cfqueryparam value = "#arguments.body.CB260_NR_CEP#" CFSQLType = "CF_SQL_VARCHAR">,
				    CB260_VL_LIQUID = <cfqueryparam value = "#arguments.body.CB260_VL_LIQUID#" CFSQLType = "CF_SQL_FLOAT">,
				    CB260_VL_DEVOL = <cfqueryparam value = "#arguments.body.CB260_VL_DEVOL#" CFSQLType = "CF_SQL_FLOAT">,
				    CB260_VL_ACREAT = <cfqueryparam value = "#arguments.body.CB260_VL_ACREAT#" CFSQLType = "CF_SQL_FLOAT">,
				    CB260_VL_ENTRAD = <cfqueryparam value = "#arguments.body.CB260_VL_ENTRAD#" CFSQLType = "CF_SQL_FLOAT">,				    				    
				    <!--- CB260_NR_NOSNUM = <cfqueryparam value = "#arguments.body.CB260_NR_NOSNUM#" CFSQLType = "CF_SQL_NUMERIC"> --->
					CB260_ID_INTECC = <cfqueryparam value = "#arguments.body.CB260_ID_INTECC#" CFSQLType = "CF_SQL_NUMERIC">
				WHERE 
				    CB260_NR_OPERADOR = <cfqueryparam value = "#arguments.CB260_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_NR_CEDENTE = <cfqueryparam value = "#arguments.CB260_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB260_CD_COMPSC = <cfqueryparam value = "#arguments.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">	
				AND CB260_NR_AGENC = <cfqueryparam value = "#arguments.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">				
				AND CB260_NR_CONTA = <cfqueryparam value = "#arguments.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">				
				AND CB260_CD_CART = <cfqueryparam value = "#arguments.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de conta já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="contaRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['conta'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB260 
					WHERE 
				        CB260_NR_OPERADOR = <cfqueryparam value = "#i.CB260_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				    AND CB260_NR_CEDENTE = <cfqueryparam value = "#i.CB260_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB260_CD_COMPSC = <cfqueryparam value = "#i.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	CB260_NR_AGENC = <cfqueryparam value = "#i.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">				
					AND	CB260_NR_CONTA = <cfqueryparam value = "#i.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">				
					AND	CB260_CD_CART = <cfqueryparam value = "#i.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">									
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="contaRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB260_NR_OPERADOR}/{CB260_NR_CEDENTE}/{CB260_CD_COMPSC}/{CB260_NR_AGENC}/{CB260_NR_CONTA}/{CB260_CD_CART}"
		>
		
		<cfargument name="CB260_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_NR_CONTA" restargsource="Path" type="numeric"/>
		<cfargument name="CB260_CD_CART" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['conta'])>
		<cfset cedenteValidate()>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB260
				WHERE 
				    CB260_NR_OPERADOR = <cfqueryparam value = "#arguments.CB260_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_NR_CEDENTE = <cfqueryparam value = "#arguments.CB260_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB260_CD_COMPSC = <cfqueryparam value = "#arguments.CB260_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB260_NR_AGENC = <cfqueryparam value = "#arguments.CB260_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">				
				AND	CB260_NR_CONTA = <cfqueryparam value = "#arguments.CB260_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">				
				AND CB260_CD_CART = <cfqueryparam value = "#arguments.CB260_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">				
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