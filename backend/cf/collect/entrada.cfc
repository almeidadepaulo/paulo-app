<cfcomponent rest="true" restPath="collect/entrada">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="entradaRelatorio" access="remote" returntype="String" httpmethod="GET" restPath="/relatorio" output="true"> 

		<cfset checkAuthentication(state = ['entrada'])>
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
					sql_view = "VW_CB209_ENTRADA";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "banco":
					sql_view = "VW_CB209_ENTRADA_BANCO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB209_NR_AGENC";
					sql_fields = sql_fields & ",CB209_NR_CONTA";					  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "carteira":
					sql_view = "VW_CB209_ENTRADA_CARTEIRA";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";					  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "produto":
					sql_view = "VW_CB209_ENTRADA_PRODUTO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";	
					sql_fields = sql_fields & ",CB255_DS_PROD";										  
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

	<cffunction name="entradaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['2via'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB210_PT
                WHERE
                    1 = 1

				AND CB210_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB210_NR_CPFCNPJ") AND url.CB210_NR_CPFCNPJ NEQ "">
					AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#NumberFormat(url.CB210_NR_CPFCNPJ, '00000000000000')#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB210_NR_CONTRA") AND url.CB210_NR_CONTRA NEQ "">
					AND	CB210_NR_CONTRA = <cfqueryparam value = "#url.CB210_NR_CONTRA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.CB209_DT_MOVTO") AND url.CB209_DT_MOVTO NEQ "">
					<cfset url.CB209_DT_MOVTO = ISOToDateTime(url.CB209_DT_MOVTO)>					
					AND	Cast(CB210_DT_INCSIS AS DATE) = <cfqueryparam value = "#url.CB209_DT_MOVTO#" CFSQLType = "CF_SQL_DATE">
				</cfif> 

            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					 ROW_NUMBER() OVER(ORDER BY CB210_NR_CPFCNPJ ASC) AS ROW
					,CB210_NR_OPERADOR
					,CB210_NR_CEDENTE
					,CB210_NR_CPFCNPJ
					,CB210_NR_CONTRA
					,CB201_NM_NMSAC
					,CB255_DS_PROD
					,CB210_VL_VALOR
					,CB210_DT_VCTO
					,CB210_ID_SITPAG
				FROM
					VW_CB210_PT
				WHERE
					1 = 1

				AND CB210_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB210_NR_CPFCNPJ") AND url.CB210_NR_CPFCNPJ NEQ "">
					AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#NumberFormat(url.CB210_NR_CPFCNPJ, '00000000000000')#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB210_NR_CONTRA") AND url.CB210_NR_CONTRA NEQ "">
					AND	CB210_NR_CONTRA = <cfqueryparam value = "#url.CB210_NR_CONTRA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.CB209_DT_MOVTO") AND url.CB209_DT_MOVTO NEQ "">
					AND	Cast(CB210_DT_INCSIS AS DATE) = <cfqueryparam value = "#url.CB209_DT_MOVTO#" CFSQLType = "CF_SQL_DATE">
				</cfif>  

				
				ORDER BY
					CB201_NM_NMSAC ASC	
                
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

	<cffunction name="entradaCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			
			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de entrada já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>
</cfcomponent>