<cfcomponent rest="true" restPath="collect/fluxo-vencimento">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="fluxoVenciemtno" access="remote" returntype="String" httpmethod="GET" output="true"> 

		<cfset checkAuthentication(state = ['fluxo-vencimento'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()> 
		
		<cfif IsDefined("url.banco")>
			<cfset url.banco = DeserializeJSON(url.banco)>
		</cfif>		

		<cfif IsDefined("url.carteira") AND (url.visao EQ 'carteira' OR url.visao EQ 'produto')>
			<cfset url.carteira = DeserializeJSON(url.carteira)>
		</cfif>

		<cfif IsDefined("url.produto") AND url.visao EQ 'produto'>
			<cfset url.produto = DeserializeJSON(url.produto)>
		</cfif>

		<cfif IsDefined("url.CB208_DT_MOVTO")>
			<cfset url.CB208_DT_MOVTO = DeserializeJSON(url.CB208_DT_MOVTO)>
			<cfset url.CB208_DT_MOVTO.startDate = ISOToDateTime(url.CB208_DT_MOVTO.startDate)>
			<cfset url.CB208_DT_MOVTO.endDate = ISOToDateTime(url.CB208_DT_MOVTO.endDate)>
			<cfset url.CB208_DT_MOVTO.startDate = LSDateFormat(url.CB208_DT_MOVTO.startDate , "YYYYMMDD")>
			<cfset url.CB208_DT_MOVTO.endDate = LSDateFormat(url.CB208_DT_MOVTO.endDate , "YYYYMMDD")>
		</cfif>

		<cfset response["params"] = url>		

		<cfscript>
			var sql_view = "";
			var sql_fields = "";
			var sql_order = "CB208_DT_MOVTO DESC";
			var caixa = UCase(url.caixa);

			if(url.caixa EQ "MENSAL") {
				sql_order = "CB208_DT_ANO DESC, CB208_DT_MES DESC";
			}
			
			switch(url.visao){
				case "geral":
					sql_view = "VW_CB208_FLUXO_" & caixa;
                   	sql_fields = sql_fields & "CB208_QT_TOTAL";                   	
                	sql_fields = sql_fields & ",CB208_VL_TOTDIA";										
				break;

				case "banco":
					sql_view = "VW_CB208_FLUXO_" & caixa & "_BANCO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";					
                   	sql_fields = sql_fields & ",CB208_QT_TOTAL";                   	
                	sql_fields = sql_fields & ",CB208_VL_TOTDIA";										
				break;

				case "carteira":
					sql_view = "VW_CB208_FLUXO_" & caixa & "_CARTEIRA";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";					  
                   	sql_fields = sql_fields & ",CB208_QT_TOTAL";                   	
                	sql_fields = sql_fields & ",CB208_VL_TOTDIA";										
				break;

				case "produto":
					sql_view = "VW_CB208_FLUXO_" & caixa & "_PRODUTO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";	
					sql_fields = sql_fields & ",CB255_DS_PROD";										  
                   	sql_fields = sql_fields & ",CB208_QT_TOTAL";                   	
                	sql_fields = sql_fields & ",CB208_VL_TOTDIA";									
				break;
			
				default:
					//;
				break;
			}
			sql_order = sql_order & "," & sql_fields;

			if(url.caixa EQ "MENSAL") {
				sql_fields = sql_fields & ",CB208_DT_MES_ANO, CB208_DT_ANO, CB208_DT_MES";				
			} else {
				sql_fields = sql_fields & ",CB208_DT_MOVTO";
			}
		</cfscript>

		<cftry>
			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	#sql_view#
               	WHERE
					1 = 1

				AND CB208_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB208_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				
				<cfif IsDefined("url.banco.id")>
					AND CB208_CD_COMPSC = <cfqueryparam value = "#url.banco.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.agencia.id")>
					AND CB208_NR_AGENC = <cfqueryparam value = "#url.agencia.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.conta.id")>
					AND CB208_NR_CONTA = <cfqueryparam value = "#url.conta.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.carteira.id")>
					AND CB208_CD_CART = <cfqueryparam value = "#url.carteira.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.produto.id")>
					AND CB208_NR_PRODUT = <cfqueryparam value = "#url.produto.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif url.caixa EQ 'MENSAL'>
					<cfif IsDefined("url.ano") AND IsNumeric(url.ano)>
						AND CB208_DT_ANO = <cfqueryparam value = "#url.ano#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>
					
					<cfif IsDefined("url.mes") AND url.mes GT -1>
						AND CB208_DT_MES = <cfqueryparam value = "#url.mes + 1#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>
				<cfelse>
					AND CB208_DT_MOVTO BETWEEN <cfqueryparam value = "#url.CB208_DT_MOVTO.startDate#" CFSQLType = "CF_SQL_NUMERIC">
					AND <cfqueryparam value = "#url.CB208_DT_MOVTO.endDate#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                	#sql_fields#
				FROM
					#sql_view#
				WHERE
					1 = 1

				AND CB208_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB208_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				
				<cfif IsDefined("url.banco.id")>
					AND CB208_CD_COMPSC = <cfqueryparam value = "#url.banco.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.agencia.id")>
					AND CB208_NR_AGENC = <cfqueryparam value = "#url.agencia.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.conta.id")>
					AND CB208_NR_CONTA = <cfqueryparam value = "#url.conta.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.carteira.id")>
					AND CB208_CD_CART = <cfqueryparam value = "#url.carteira.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif IsDefined("url.produto.id")>
					AND CB208_NR_PRODUT = <cfqueryparam value = "#url.produto.id#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

				<cfif url.caixa EQ 'MENSAL'>
					<cfif IsDefined("url.ano") AND IsNumeric(url.ano)>
						AND CB208_DT_ANO = <cfqueryparam value = "#url.ano#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>
					
					<cfif IsDefined("url.mes") AND url.mes GT -1>
						AND CB208_DT_MES = <cfqueryparam value = "#url.mes + 1#" CFSQLType = "CF_SQL_NUMERIC">
					</cfif>
				<cfelse>
					AND CB208_DT_MOVTO BETWEEN <cfqueryparam value = "#url.CB208_DT_MOVTO.startDate#" CFSQLType = "CF_SQL_NUMERIC">
					AND <cfqueryparam value = "#url.CB208_DT_MOVTO.endDate#" CFSQLType = "CF_SQL_NUMERIC">
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
</cfcomponent>