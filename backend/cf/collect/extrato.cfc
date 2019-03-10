<cfcomponent rest="true" restPath="collect/extrato">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="extrato" access="remote" returntype="String" httpmethod="GET" output="true"> 

		<cfset checkAuthentication(state = ['extrato'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()> 
		
		<cfif IsDefined("url.banco")>
			<cfset url.banco = DeserializeJSON(url.banco)>
		</cfif>		

		<cfif IsDefined("url.agencia")>
			<cfset url.agencia = DeserializeJSON(url.agencia)>
		</cfif>	

		<cfif IsDefined("url.conta")>
			<cfset url.conta = DeserializeJSON(url.conta)>
		</cfif>	
	
		<cfif IsDefined("url.produto")>
			<cfset url.produto = DeserializeJSON(url.produto)>
		</cfif>


		<cfset response["params"] = url>		

		<cftry>

			<cfset data = url.ano & NumberFormat(url.mes + 1, "00") & "01">
			<cfset response["data"] = data>

			<cfquery name="qQuerySaldoAnterior" datasource="#application.datasource#">
				SELECT   
					SUM(
					CASE CB306_ID_SINAL
						WHEN  'C' THEN CB306_VL_LANC
						ELSE  CB306_VL_LANC*-1
					END
					)
				AS SALDOANTERIOR
				
				FROM  VW_CB306
				WHERE 
					<!---CB306_NR_OPERADOR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.operador#">
				AND CB306_NR_CEDENTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cedente#">    
				AND --->CB306_DT_LANC < <cfqueryparam cfsqltype="cf_sql_numeric" value="#data#">   

				<cfif isDefined("url.conta.id")>
					AND CB306_CD_COMPSC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.banco.id#">
					AND CB306_NR_AGENC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.agencia.id#">
					AND CB306_NR_CONTA = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.conta.id#">
				</cfif> 
					
				GROUP BY					
					<cfif isDefined("url.conta.id")>	
						CB306_CD_COMPSC
						,CB306_NR_AGENC
						,CB306_NR_CONTA
						,CB250_NM_BANCO
						,CB251_NR_DG_AGENC
						,CB260_NR_CONTA_DG
					</cfif>
			</cfquery>
						
			<cfset qQueryExtrato = QueryNew("CB306_DT_LANC, CB307_NM_TPLANC, CB306_DS_LANC, CB306_VL_LANC, CB306_ID_SINAL, debito, credito, saldo")>
			
			<cfset tempSinal = "">
			<cfif qQuerySaldoAnterior.SALDOANTERIOR GT 0>
				<cfset tempSinal = "C">
			<cfelseif qQuerySaldoAnterior.SALDOANTERIOR LT 0>
				<cfset tempSinal = "D">
			</cfif>
			
			<!--- Set the values of the cells in the query --->
			<!--- <cfset temp = QuerySetCell(myQuery, "", "SALDO ANTERIOR", tempSinal,qQuery.SALDOANTERIOR)> --->
			
			<!--- Make one row in the query --->
			<cfset newRow = QueryAddRow(qQueryExtrato, 1)>
			<cfscript>
				temp  = QuerySetCell(qQueryExtrato, "CB307_NM_TPLANC", "SALDO ANTERIOR", 1);
				temp  = QuerySetCell(qQueryExtrato, "credito", "null", 1);
				temp  = QuerySetCell(qQueryExtrato, "debito", "null", 1);
				temp  = QuerySetCell(qQueryExtrato, "saldo", qQuerySaldoAnterior.SALDOANTERIOR, 1);   
			</cfscript>

						
			<!--- Lançamentos a partir da data filtrada --->
			<cfquery name="qQueryLancamentos" datasource="#application.datasource#">
				SELECT 
					CB306_ID_SINAL, <!--- C=Crédito | D=Débito --->
					CB306_DT_LANC, <!--- data --->								
					CB307_NM_TPLANC,<!--- evento --->
					SUM(CB306_VL_LANC) AS CB306_VL_LANC, <!--- valor --->
					CB306_DS_LANC
				FROM 
					dbo.VW_CB306
				
				WHERE <!--- CB306_NR_OPERADOR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.operador#">
				AND CB306_NR_CEDENTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cedente#">
				AND ---> CB306_DT_LANC > <cfqueryparam cfsqltype="cf_sql_numeric" value="#data#">

				<cfif isDefined("url.conta.id")>
					AND CB306_CD_COMPSC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.banco.id#">
					AND CB306_NR_AGENC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.agencia.id#">
					AND CB306_NR_CONTA = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.conta.id#">
				</cfif>

				GROUP BY
					CB306_ID_SINAL
					,CB306_DT_LANC		
					,CB307_NM_TPLANC			
					,CB306_DS_LANC
					<cfif isDefined("url.conta.id")>	
						,CB306_CD_COMPSC
						,CB306_NR_AGENC
						,CB306_NR_CONTA
						,CB250_NM_BANCO
						,CB251_NR_DG_AGENC
						,CB260_NR_CONTA_DG
					</cfif>

				ORDER BY 
					<cfif isDefined("url.conta.id")>	
						CB250_NM_BANCO
						,CB251_NR_DG_AGENC
						,CB260_NR_CONTA_DG,
					</cfif>
					CB306_DT_LANC		
			</cfquery>
				
			<cfif qQueryLancamentos.recordCount GT 0>
				<cfset newRow = QueryAddRow(qQueryExtrato, qQueryLancamentos.recordCount)>
			</cfif>
			
			<cfif qQuerySaldoAnterior.recordCount EQ 0>   
				<cfset saldo  = 0><!--- Armazenar saldo --->
			<cfelse>
				<cfset saldo  = qQuerySaldoAnterior.SALDOANTERIOR><!--- Armazenar saldo --->
			</cfif>

			<cfset mes   = MID(qQueryLancamentos.CB306_DT_LANC,5,4)> <!--- Armazena o mes do lançamento --->
			
			<cfloop query="qQueryLancamentos">
			
				<cfscript>
					rowExtrato = qQueryLancamentos.currentRow+1;// Linha atual da qQueryExtrato
						
					temp = QuerySetCell(qQueryExtrato, "CB306_DT_LANC", qQueryLancamentos.CB306_DT_LANC, rowExtrato);
					temp = QuerySetCell(qQueryExtrato, "CB307_NM_TPLANC", qQueryLancamentos.CB307_NM_TPLANC, rowExtrato);				
					temp = QuerySetCell(qQueryExtrato, "CB306_DS_LANC", qQueryLancamentos.CB306_DS_LANC, rowExtrato);				
									
					if(mes NEQ MID(qQueryLancamentos.CB306_DT_LANC,5,4)) // Ultima linha do mês
					{
						mes = MID(qQueryLancamentos.CB306_DT_LANC,5,4);
						temp = QuerySetCell(qQueryExtrato, "saldo", saldo,rowExtrato-1); 
					}
					else if(qQueryLancamentos.currentRow NEQ 1)
					{     
						temp = QuerySetCell(qQueryExtrato, "saldo", saldo,rowExtrato-1); // Desconsiderar saldo
					}
					else
					{
						temp = QuerySetCell(qQueryExtrato, "saldo", saldo,rowExtrato-1); // Desconsiderar saldo
					}
					
					temp  = QuerySetCell(qQueryExtrato, "CB306_ID_SINAL", qQueryLancamentos.CB306_ID_SINAL,rowExtrato);
					temp  = QuerySetCell(qQueryExtrato, "CB306_VL_LANC", qQueryLancamentos.CB306_VL_LANC,rowExtrato);
					
					if(qQueryLancamentos.CB306_ID_SINAL EQ "C") // Crédito
					{
						temp  = QuerySetCell(qQueryExtrato, "credito", qQueryLancamentos.CB306_VL_LANC,rowExtrato);
						temp  = QuerySetCell(qQueryExtrato, "debito", "null",rowExtrato);
						
						saldo  = saldo + qQueryLancamentos.CB306_VL_LANC;  // Soma saldo                    
					}
					else // Débito
					{					
						temp  = QuerySetCell(qQueryExtrato, "credito", "null",rowExtrato);
						temp  = QuerySetCell(qQueryExtrato, "debito", qQueryLancamentos.CB306_VL_LANC,rowExtrato);
						
						saldo  = saldo - qQueryLancamentos.CB306_VL_LANC; // Subtrai saldo                   
					} 
					
				</cfscript>
			
			</cfloop>

			
			<cfscript>			    
				rowExtrato = QueryAddRow(qQueryExtrato, 1);// Linha atual da qQueryExtrato
				temp  = QuerySetCell(qQueryExtrato, "CB306_DT_LANC", lsDateformat(now(),"YYYYMMDD"), rowExtrato);
				temp  = QuerySetCell(qQueryExtrato, "CB307_NM_TPLANC", "SALDO ATUAL", rowExtrato);
				temp  = QuerySetCell(qQueryExtrato, "credito", "null", rowExtrato);
				temp  = QuerySetCell(qQueryExtrato, "debito", "null", rowExtrato);
				temp = QuerySetCell(qQueryExtrato, "saldo", saldo, rowExtrato);

				if(rowExtrato - 1 GT 1) {
					temp = QuerySetCell(qQueryExtrato, "saldo", "null", rowExtrato - 1);
				}
			</cfscript>

			<!--- Atualizar saldo na última linha --->
			<cfscript>   
				emp = QuerySetCell(qQueryExtrato, "saldo", saldo,qQueryExtrato.recordCount);
			</cfscript>

			<cfset response["query"] = queryToArray(qQueryExtrato)>
		
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>
			
			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>
</cfcomponent>