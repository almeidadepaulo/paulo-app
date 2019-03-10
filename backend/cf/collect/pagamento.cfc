<cfcomponent rest="true" restPath="collect/pagamento">  
	<cfprocessingDirective pageencoding="utf-8">
	<cfset setEncoding("form","utf-8")> 

	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">
	
	<cffunction name="pagamentoRelatorio" access="remote" returntype="String" httpmethod="GET" restPath="/relatorio" output="true"> 

		<cfset checkAuthentication(state = ['pagamento'])>
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
					sql_view = "VW_CB209_PAGAMENTO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "banco":
					sql_view = "VW_CB209_PAGAMENTO_BANCO";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB209_NR_AGENC";
					sql_fields = sql_fields & ",CB209_NR_CONTA";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "carteira":
					sql_view = "VW_CB209_PAGAMENTO_CARTEIRA";					
                  	sql_fields = sql_fields & "CB250_NM_BANCO";
					sql_fields = sql_fields & ",CB256_DS_CART";
					sql_fields = sql_fields & ",CB209_ID_TIPOAC";  
                   	sql_fields = sql_fields & ",CB209_QT_TOTAL";
                   	sql_fields = sql_fields & ",CB209_QT_CONTRA";
                	sql_fields = sql_fields & ",CB209_VL_VALOR";										
				break;

				case "produto":
					sql_view = "VW_CB209_PAGAMENTO_PRODUTO";					
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
					
				AND CB209_ID_TIPOAC NOT IN(1, 2 , 10)

				<cfif IsDefined("url.CB209_ID_TIPOAC")>
					AND CB209_ID_TIPOAC = <cfqueryparam value = "#url.CB209_ID_TIPOAC#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>

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
				
				AND CB209_ID_TIPOAC NOT IN(1, 2 , 10)

				<cfif IsDefined("url.CB209_ID_TIPOAC")>
					AND CB209_ID_TIPOAC = <cfqueryparam value = "#url.CB209_ID_TIPOAC#" CFSQLType = "CF_SQL_NUMERIC">	
				</cfif>
				
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

	<cffunction name="pagamentoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['pagamento'])>
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
					AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#NumberFormat(url.CB210_NR_CPFCNPJ, "00000000000000")#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.CB201_NM_NMSAC") AND url.CB201_NM_NMSAC NEQ "">
					AND	CB201_NM_NMSAC LIKE <cfqueryparam value = "%#url.CB201_NM_NMSAC#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.CB210_NR_CONTRA") AND url.CB210_NR_CONTRA NEQ "">
					AND	CB210_NR_CONTRA = <cfqueryparam value = "#url.CB210_NR_CONTRA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  
				
				<cfif IsDefined("url.TIPO") AND url.TIPO EQ 1>                   
				   AND CB210_DT_VCTO > #LSDateFormat(now() , "yyyyMMdd")#
				<cfelseif IsDefined("url.TIPO") AND url.TIPO EQ 2>                   
				   AND CB210_DT_VCTO < #LSDateFormat(now() , "yyyyMMdd")#
				</cfif>

				<!--- 1 : PAGO | 2 : NÃO PAGO --->
				<cfif IsDefined("url.CB210_ID_SITPAG") AND url.CB210_ID_SITPAG NEQ "">
					AND	CB210_ID_SITPAG = <cfqueryparam value = "#url.CB210_ID_SITPAG#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.CB210_TP_BAIXA") AND url.CB210_TP_BAIXA NEQ "">
					AND	CB210_TP_BAIXA = <cfqueryparam value = "#url.CB210_TP_BAIXA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.CB210_DT_VCTO") AND url.CB210_DT_VCTO NEQ "">
					<cfset url.CB210_DT_VCTO = ISOToDateTime(url.CB210_DT_VCTO)>
					<cfset url.CB210_DT_VCTO = DateFormat(url.CB210_DT_VCTO , "YYYYMMDD")>
					AND	CB210_DT_VCTO = <cfqueryparam value = "#url.CB210_DT_VCTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
				
				<cfif IsDefined("url.fluxoVencimento")>
					<!--- MÊS --->
					AND	SUBSTRING(Cast(CB210_DT_VCTO as varchar), 5, 2) = <cfqueryparam value = "#NumberFormat(url.mes + 1 , '00')#" CFSQLType = "CF_SQL_NUMERIC">
					<!--- ANO --->
					AND	SUBSTRING(Cast(CB210_DT_VCTO as varchar), 1, 4) = <cfqueryparam value = "#url.ano#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB210_DT_MOVTO") AND url.CB210_DT_MOVTO NEQ "">
					<cfset url.CB210_DT_MOVTO = ISOToDateTime(url.CB210_DT_MOVTO)>					
					AND	Cast(CB210_DT_ATUSIS AS DATE) = <cfqueryparam value = "#url.CB210_DT_MOVTO#" CFSQLType = "CF_SQL_DATE">
				</cfif> 

				<cfif IsDefined("url.ORDEM")>
					<cfset now = lsDateformat(DateAdd("d", -1, now()), "YYYYMMDD")>					
					<cfswitch expression="#url.ORDEM#">
						<cfcase value="1">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -5, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND #now#
						</cfcase>

						<cfcase value="2">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -15, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -6, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="3">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -30, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -16, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="4">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -60, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -31, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="5">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -90, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -61, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="6">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -180, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -91, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="7">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -360, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -181, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="8">
							AND CB210_DT_VCTO <= CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -360, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfdefaultcase>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB210_NR_CPFCNPJ ASC) AS ROW
					,CB210_NR_OPERADOR
					,CB210_NR_CEDENTE
					,CB210_CD_COMPSC
					,CB210_NR_AGENC 
					,CB210_NR_CONTA
					,CB210_NR_NOSNUM
					,CB210_NR_PROTOC
      				,CB255_DS_PROD 
      				,CB201_NM_NMSAC  
					,CB210_NR_CONTRA 
      				,CB210_NR_CPFCNPJ
      				,CB210_VL_VALOR  	  
      				,CB210_DT_VCTO 					
					,CB210_ID_SITPAG
  	  				,CB210_ID_SITPAG_LABEL					
				FROM
					VW_CB210_PT
				WHERE
					1 = 1
				
			
				AND CB210_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
				<cfif IsDefined("url.CB210_NR_CPFCNPJ") AND url.CB210_NR_CPFCNPJ NEQ "">
					AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#NumberFormat(url.CB210_NR_CPFCNPJ, "00000000000000")#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				<cfif IsDefined("url.CB201_NM_NMSAC") AND url.CB201_NM_NMSAC NEQ "">
					AND	CB201_NM_NMSAC LIKE <cfqueryparam value = "%#url.CB201_NM_NMSAC#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
			
				<cfif IsDefined("url.CB210_NR_CONTRA") AND url.CB210_NR_CONTRA NEQ "">
					AND	CB210_NR_CONTRA = <cfqueryparam value = "#url.CB210_NR_CONTRA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>  

				<cfif IsDefined("url.TIPO") AND url.TIPO EQ 1>                   
				   AND CB210_DT_VCTO > #LSDateFormat(now() , "yyyyMMdd")#
				<cfelseif IsDefined("url.TIPO") AND url.TIPO EQ 2>                   
				   AND CB210_DT_VCTO < #LSDateFormat(now() , "yyyyMMdd")#
				</cfif>
				
				<!--- 1 : PAGO | 2 : NÃO PAGO --->
				<cfif IsDefined("url.CB210_ID_SITPAG") AND url.CB210_ID_SITPAG NEQ "">
					AND	CB210_ID_SITPAG = <cfqueryparam value = "#url.CB210_ID_SITPAG#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
			
				<cfif IsDefined("url.CB210_TP_BAIXA") AND url.CB210_TP_BAIXA NEQ "">
					AND	CB210_TP_BAIXA = <cfqueryparam value = "#url.CB210_TP_BAIXA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
				
				<cfif IsDefined("url.CB210_DT_VCTO") AND url.CB210_DT_VCTO NEQ "">					
					AND	CB210_DT_VCTO = <cfqueryparam value = "#url.CB210_DT_VCTO#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.fluxoVencimento")>
					<!--- MÊS --->
					AND	SUBSTRING(Cast(CB210_DT_VCTO as varchar), 5, 2) = <cfqueryparam value = "#NumberFormat(url.mes + 1 , '00')#" CFSQLType = "CF_SQL_NUMERIC">
					<!--- ANO --->
					AND	SUBSTRING(Cast(CB210_DT_VCTO as varchar), 1, 4) = <cfqueryparam value = "#url.ano#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>
			
				<cfif IsDefined("url.CB210_DT_MOVTO") AND url.CB210_DT_MOVTO NEQ "">					
					AND	Cast(CB210_DT_ATUSIS AS DATE) = <cfqueryparam value = "#url.CB210_DT_MOVTO#" CFSQLType = "CF_SQL_DATE">
				</cfif> 

				<cfif IsDefined("url.ORDEM")>
					<cfset now = lsDateformat(DateAdd("d", -1, now()), "YYYYMMDD")>					
					<cfswitch expression="#url.ORDEM#">
						<cfcase value="1">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -5, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND #now#
						</cfcase>

						<cfcase value="2">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -15, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -6, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="3">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -30, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -16, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="4">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -60, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -31, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="5">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -90, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -61, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="6">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -180, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -91, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="7">
							AND CB210_DT_VCTO BETWEEN CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -360, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112)) AND CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -181, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfcase value="8">
							AND CB210_DT_VCTO <= CONVERT(NUMERIC, CONVERT(VARCHAR, DATEADD(DD, -360, CONVERT(DATETIME, CONVERT(CHAR, #now#), 103)), 112))
						</cfcase>

						<cfdefaultcase>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
			
				ORDER BY
					CB210_NR_CPFCNPJ ASC	
                
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

		<!--- <cfreturn new lib.JsonSerializer().serialize(response)> --->
		<cfset serializer = new lib.JsonSerializer()>
		<cfreturn serializer.serialize(response)>		
    </cffunction>

	<cffunction name="pagamentoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB210_NR_OPERADOR}/{CB210_NR_CEDENTE}/{CB210_CD_COMPSC}/{CB210_NR_AGENC}/{CB210_NR_CONTA}/{CB210_NR_NOSNUM}/{CB210_NR_CPFCNPJ}/{CB210_NR_PROTOC}"> 

		<cfargument name="CB210_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_CONTA" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_NOSNUM" restargsource="Path" type="string"/>
		<cfargument name="CB210_NR_CPFCNPJ" restargsource="Path" type="string"/>
		<cfargument name="CB210_NR_PROTOC" restargsource="Path" type="string"/>
		
		<cfset checkAuthentication(state = ['pagamento'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>
		
		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 CB210_NR_OPERADOR
					,CB210_NR_CEDENTE
					,CB210_CD_COMPSC
					,CB210_NR_AGENC
					,CB210_NR_CONTA
					,CB210_NR_NOSNUM
					,CB210_NR_CPFCNPJ
					,CB210_NR_PROTOC
					,CB201_NM_NMSAC  
					,CB210_NR_CONTRA 					
					,CB210_VL_VALOR  
					,CB210_DT_VCTO   
					,CB210_ID_SITPAG
					,CB203_DT_EMISS
					,CB201_NR_CEP
					,CB201_NM_END
					,CB201_NR_END
					,CB201_DS_COMPL
					,CB201_NM_BAIRRO
					,CB201_SG_ESTADO
					,CB201_NM_CIDADE
				FROM
					VW_CB210_2VIA
				WHERE					
				    CB210_NR_OPERADOR = <cfqueryparam value = "#arguments.CB210_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_CEDENTE = <cfqueryparam value = "#arguments.CB210_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_CD_COMPSC = <cfqueryparam value = "#arguments.CB210_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_AGENC = <cfqueryparam value = "#arguments.CB210_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_CONTA = <cfqueryparam value = "#arguments.CB210_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_NOSNUM = <cfqueryparam value = "#arguments.CB210_NR_NOSNUM#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#arguments.CB210_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB210_NR_PROTOC = <cfqueryparam value = "#arguments.CB210_NR_PROTOC#" CFSQLType = "CF_SQL_CHAR">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfset serializer = new lib.JsonSerializer()>
		<cfreturn serializer.serialize(response)>		
    </cffunction>

	<cffunction name="pagamentoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB210_NR_OPERADOR}/{CB210_NR_CEDENTE}/{CB210_CD_COMPSC}/{CB210_NR_AGENC}/{CB210_NR_CONTA}/{CB210_NR_NOSNUM}/{CB210_NR_CPFCNPJ}/{CB210_NR_PROTOC}"> 
		
		<cfargument name="CB210_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_CEDENTE" restargsource="Path" type="numeric"/>		
		<cfargument name="CB210_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_CONTA" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_NOSNUM" restargsource="Path" type="string"/>
		<cfargument name="CB210_NR_CPFCNPJ" restargsource="Path" type="string"/>
		<cfargument name="CB210_NR_PROTOC" restargsource="Path" type="string"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['pagamento'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<!---
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB210
				SET   				    			    
				WHERE					
				    CB210_CD_COMPSC = <cfqueryparam value = "#arguments.CB210_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_AGENC = <cfqueryparam value = "#arguments.CB210_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_CONTA = <cfqueryparam value = "#arguments.CB210_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_NOSNUM = <cfqueryparam value = "#arguments.CB210_NR_NOSNUM#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#arguments.CB210_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB210_NR_PROTOC = <cfqueryparam value = "#arguments.CB210_NR_PROTOC#" CFSQLType = "CF_SQL_CHAR">
			</cfquery>
			--->

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

	
	<cffunction name="pagamentoPdf" access="remote" returnType="String" httpMethod="POST" restpath="/pdf">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['pagamento'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>		
		 	

			<!--- <cfset response["destination"] = pdf(arguments.body.items).destination> --->
            <cfset response["base64"] = pdf(arguments.body.items).base64>			
			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de pacote já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="pagamentoPdfEmail" access="remote" returnType="String" httpMethod="POST" restpath="/pdf-email">

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['pagamento'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>		
		 	
			
            <cfset response["destination"] = pdf(arguments.body.items, arguments.body.email).destination>			
			<cfset response["success"] = true>
			<cfset response["message"] = 'E-mail enviado com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de pacote já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>

	</cffunction>

	<cffunction name="pdf" access="private" returnType="Struct">
		<cfargument name="items" type="array" required="true">
		<cfargument name="email" type="string" required="false" default="">

		<cfset responsePdf = structNew()>

		<cfset guid = CreateUUID()>	
		<cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "../../../_server/collect/pagamento/" & guid>
		<cfif not directoryExists(destination)>
			<cfdirectory action="create" directory="#destination#" />		
		</cfif>

		<cfloop array="#arguments.items#" index="item">			
			<!--- Recuperar o PDF --->
			<cfquery name="qCB850" datasource="#application.datasource#">
				SELECT CB850_NR_PROTOC,CB850_IM_PDF
				FROM CB850
				WHERE 1=1
				AND	CB850_NR_PROTOC	= <cfqueryparam cfsqltype="cf_sql_char" value="#item.CB210_NR_PROTOC#">
			</cfquery>
							
			<cfset fileName	= "#TRIM(qCB850.CB850_NR_PROTOC)#_#item.CB210_DT_VCTO#">
			
			<cffile action="write"
					file="#destination#/#fileName#.pdf"
					output="#qCB850.CB850_IM_PDF#">
			
		</cfloop>

		<cfset guidMerge = "#lsDateformat(now(),'dd_mm_yyyy')#_#timeformat(now(),'HH_mm_ss')#">
		
		<cfset fileMerged = destination & "\Boleto_" & arguments.items[1].CB210_NR_CPFCNPJ & "_" & guidMerge & ".pdf">

		<!--- MERGE PDF --->
		<cfpdf action="merge" 
			destination="#fileMerged#" overwrite="yes"> 
			
			<cfloop array="#arguments.items#" index="item">
				<cfpdfparam source="#destination#/#fileName#.pdf"/> 
			</cfloop>				
		</cfpdf>

		<cfif arguments.email NEQ "">
			<cfquery name="qSMTP" datasource="#application.datasource#">
				SELECT TOP 1
					EM000_NM_SMTP,		<!--- Servidor SMTP --->
					EM000_NM_USRMAI,	<!--- Login --->		
					EM000_NR_SENMAI,	<!--- Senha --->
					EM000_NR_SMTPPO		<!--- Porta --->
				FROM 
					EM000
			</cfquery>	

			<cfset response["qSMTP"] = queryToArray(qSMTP)>

			<cfmail from="#qSMTP.EM000_NM_USRMAI#"
				type="html"
				to="#trim(arguments.email)#"
				subject="[PAN] Pagamentos"
		    	server="#qSMTP.EM000_NM_SMTP#"
		    	username="#qSMTP.EM000_NM_USRMAI#" 
				password="#qSMTP.EM000_NR_SENMAI#"
				port="#qSMTP.EM000_NR_SMTPPO#"		
				useTLS="true">

					<cfmailparam file="#fileMerged#">
				
				<cfoutput>								
					<p><b>Este é um e-mail automático, por favor não responda.</b></p>
					<br />
					<p>Prezado(a) Cliente</p>
					<p>Segue em anexo o demonstrativo de boleto</p>
				</cfoutput>	
			</cfmail>
		<cfelse>
			<cffile  
				action="readBinary"  
				file="#destination#\Boleto_#arguments.items[1].CB210_NR_CPFCNPJ#_#guidMerge#.pdf" 
				variable="binary">

			<cfset responsePdf["base64"] = toBase64(binary)>

			<cfdirectory  
				action="delete"  
				directory="#destination#"
				recurse="true">
		</cfif>				
				
		<cfset responsePdf["destination"] = destination>

		<cfreturn responsePdf>

	</cffunction>

</cfcomponent>