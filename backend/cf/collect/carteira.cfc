<cfcomponent rest="true" restPath="collect/carteira">  
	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="carteiraRelatorio" access="remote" returntype="String" httpmethod="GET" restPath="/relatorio" output="true"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()> 
		
		<cfif IsDefined("url.banco")>
			<cfset url.banco = DeserializeJSON(url.banco)>
		</cfif>

		<cfif IsDefined("url.agencia") AND url.visao EQ 'banco'>
			<cfset url.agencia = DeserializeJSON(url.agencia)>
		</cfif>

		<cfif IsDefined("url.conta") AND url.visao EQ 'banco'>
			<cfset url.conta = DeserializeJSON(url.conta)>
		</cfif>

		<cfif IsDefined("url.carteira") AND (url.visao EQ 'carteira' OR url.visao EQ 'produto')>
			<cfset url.carteira = DeserializeJSON(url.carteira)>
		</cfif>

		<cfif IsDefined("url.produto") AND url.visao EQ 'produto'>
			<cfset url.produto = DeserializeJSON(url.produto)>
		</cfif>

		<cfif IsDefined("url.CB209_DT_MOVTO")>
			<cfset url.CB209_DT_MOVTO = DeserializeJSON(url.CB209_DT_MOVTO)>
			<cfset url.CB209_DT_MOVTO.startDate = ISOToDateTime(url.CB209_DT_MOVTO.startDate)>
			<cfset url.CB209_DT_MOVTO.endDate = ISOToDateTime(url.CB209_DT_MOVTO.endDate)>
			<cfset url.CB209_DT_MOVTO.startDate = LSDateFormat(url.CB209_DT_MOVTO.startDate , "YYYYMMDD")>
			<cfset url.CB209_DT_MOVTO.endDate = LSDateFormat(url.CB209_DT_MOVTO.endDate , "YYYYMMDD")>
		</cfif>

		<cfset response["params"] = url>		

		<cfscript>
			var sql_view = "";
			var sql_fields = "";
			var sql_order = "CB209_DT_MOVTO DESC";
			
			switch(url.visao){
				case "geral":
					sql_view = "VW_CB209_CARTEIRA";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "banco":
					sql_view = "VW_CB209_CARTEIRA_BANCO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB209_NR_AGENC";
					sql_fields = sql_fields & ",CB209_NR_CONTA";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "carteira":
					sql_view = "VW_CB209_CARTEIRA_CARTEIRA";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "produto":
					sql_view = "VW_CB209_CARTEIRA_PRODUTO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";	
					sql_fields = sql_fields & ",CB255_DS_PROD";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";									
				break;
			
				default:
					//;
				break;
			}
			sql_order = sql_order & "," & sql_fields;
			sql_fields = sql_fields & ",CB209_DT_MOVTO";			
		</cfscript>

		<cftry>
			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	#sql_view#
               	WHERE
					1 = 1

				AND CB209_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB209_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.banco.id")>
					AND CB209_CD_COMPSC = <cfqueryparam value = "#url.banco.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.agencia.id")>
					AND CB209_NR_AGENC = <cfqueryparam value = "#url.agencia.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.conta.id")>
					AND CB209_NR_CONTA = <cfqueryparam value = "#url.conta.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.carteira.id")>
					AND CB209_CD_CART = <cfqueryparam value = "#url.carteira.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.produto.id")>
					AND CB209_NR_PRODUT = <cfqueryparam value = "#url.produto.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.CB209_DT_MOVTO")>
					AND CB209_DT_MOVTO BETWEEN <cfqueryparam value = "#url.CB209_DT_MOVTO.startDate#" CFSQLType = "CF_SQL_NUMERIC">
					AND <cfqueryparam value = "#url.CB209_DT_MOVTO.endDate#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                	#sql_fields#
				FROM
					#sql_view#
				WHERE
					1 = 1

				AND CB209_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB209_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				
				<cfif IsDefined("url.banco.id")>
					AND CB209_CD_COMPSC = <cfqueryparam value = "#url.banco.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.agencia.id")>
					AND CB209_NR_AGENC = <cfqueryparam value = "#url.agencia.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.conta.id")>
					AND CB209_NR_CONTA = <cfqueryparam value = "#url.conta.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.carteira.id")>
					AND CB209_CD_CART = <cfqueryparam value = "#url.carteira.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.produto.id")>
					AND CB209_NR_PRODUT = <cfqueryparam value = "#url.produto.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.CB209_DT_MOVTO")>
					AND CB209_DT_MOVTO BETWEEN <cfqueryparam value = "#url.CB209_DT_MOVTO.startDate#" CFSQLType = "CF_SQL_NUMERIC">
					AND <cfqueryparam value = "#url.CB209_DT_MOVTO.endDate#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				ORDER BY
					#sql_order#
                
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
	
	<cffunction name="carteiraGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	CB256
                WHERE
                    1 = 1

				<cfif IsDefined("url.conta") && url.conta>
					AND CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = 0
					<!--- AND NOT EXISTS(SELECT 1 FROM CB260 WHERE CB260_CD_CART = CB256_CD_CART) --->
				<cfelse>	
					AND CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
						
					<cfif IsDefined("url.CB256_CD_CART") AND url.CB256_CD_CART NEQ "">
						AND	CB256_CD_CART = <cfqueryparam value = "#url.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>

					<cfif IsDefined("url.CB256_DS_CART") AND url.CB256_DS_CART NEQ "">
						AND	CB256_DS_CART LIKE <cfqueryparam value = "%#url.CB256_DS_CART#%" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 		
				</cfif>		
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB256_CD_CART ASC) AS ROW
					,CB256_NR_OPERADOR
					,CB256_NR_CEDENTE					
					,CB256_CD_CART
					,CB256_DS_CART
				FROM
					CB256
				WHERE
					1 = 1

				<cfif IsDefined("url.conta") && url.conta>
					AND CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = 0
					<!--- AND NOT EXISTS(SELECT 1 FROM CB260 WHERE CB260_CD_CART = CB256_CD_CART) --->
				<cfelse>	
					AND CB256_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
						
					<cfif IsDefined("url.CB256_CD_CART") AND url.CB256_CD_CART NEQ "">
						AND	CB256_CD_CART = <cfqueryparam value = "#url.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>

					<cfif IsDefined("url.CB256_DS_CART") AND url.CB256_DS_CART NEQ "">
						AND	CB256_DS_CART LIKE <cfqueryparam value = "%#url.CB256_DS_CART#%" CFSQLType = "CF_SQL_VARCHAR">
					</cfif> 		
				</cfif>		

				ORDER BY
					CB256_CD_CART ASC	
                
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

	<cffunction name="carteiraGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB256_NR_OPERADOR}/{CB256_NR_CEDENTE}/{CB256_CD_CART}"> 

		<cfargument name="CB256_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB256_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB256_CD_CART" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 CB256_NR_OPERADOR
					,CB256_NR_CEDENTE					
					,CB256_CD_CART
					,CB256_DS_CART
				FROM
					CB256
				WHERE
				    CB256_NR_OPERADOR = <cfqueryparam value = "#arguments.CB256_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB256_NR_CEDENTE = <cfqueryparam value = "#arguments.CB256_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB256_CD_CART = <cfqueryparam value = "#arguments.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="carteiraCreate" access="remote" returnType="String" httpMethod="POST">		
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
					dbo.CB256
				(   					
					CB256_NR_OPERADOR,
					CB256_NR_CEDENTE,					
					CB256_CD_CART,
					CB256_DS_CART,
					CB256_CD_OPESIS,
					CB256_DT_INCSIS,
					CB256_DT_ATUSIS
				) 
					VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
				    <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,						
					<cfqueryparam value = "#arguments.body.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfqueryparam value = "#arguments.body.CB256_DS_CART#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de carteira já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="carteiraUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB256_NR_OPERADOR}/{CB256_NR_CEDENTE}/{CB256_CD_CART}"> 
				
		<cfargument name="CB256_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB256_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB256_CD_CART" restargsource="Path" type="numeric"/>
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
					dbo.CB256  
				SET 
					CB256_CD_CART = <cfqueryparam value = "#arguments.body.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">,
					CB256_DS_CART = <cfqueryparam value = "#arguments.body.CB256_DS_CART#" CFSQLType = "CF_SQL_VARCHAR">
				WHERE 
				    CB256_NR_OPERADOR = <cfqueryparam value = "#arguments.CB256_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB256_NR_CEDENTE = <cfqueryparam value = "#arguments.CB256_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB256_CD_CART = <cfqueryparam value = "#arguments.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de carteiras já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="carteiraRemove" access="remote" returnType="String" httpMethod="DELETE">		
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
						dbo.CB256 
					WHERE 
				    	CB256_NR_OPERADOR = <cfqueryparam value = "#i.CB256_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_NR_CEDENTE = <cfqueryparam value = "#i.CB256_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
					AND CB256_CD_CART = <cfqueryparam value = "#i.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="carteiraRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB256_NR_OPERADOR}/{CB256_NR_CEDENTE}/{CB256_CD_CART}"> 
		
		<cfargument name="CB256_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB256_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB256_CD_CART" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB256 
				WHERE 
				    CB256_NR_OPERADOR = <cfqueryparam value = "#arguments.CB256_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB256_NR_CEDENTE = <cfqueryparam value = "#arguments.CB256_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB256_CD_CART = <cfqueryparam value = "#arguments.CB256_CD_CART#" CFSQLType = "CF_SQL_NUMERIC">				
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