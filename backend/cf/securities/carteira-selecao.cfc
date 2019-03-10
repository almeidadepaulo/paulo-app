<cfcomponent rest="true" restPath="securities/carteira-selecao">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="carteiraSelecaoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['carteira-selecao'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cfif isDefined("url.banco")>

		<cfelse>
			<cfset url.banco = {id: 0}>
		</cfif>

		<cfif isDefined("url.cedente")>

		<cfelse>
			<cfset url.cedente = {id: 0}>
		</cfif>

		<cftry>

			<cfquery datasource="#application.datasource#" name="qCessionarioValido">
			
				SELECT 
					TOP 1 BKN045_CD_PERCESS 
				FROM 
					BKN045  WITH (NOLOCK)
				WHERE 
					BKN045_CD_PERCESS <> 0
				AND BKN045_NR_BANCO = <cfqueryparam value = "#url.banco.id#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN045_NR_CEDE = <cfqueryparam value = "#url.cedente.id#" CFSQLType = "CF_SQL_NUMERIC">
				AND BKN045_NR_MKCESS = 0
				<!--- AND BKN045_NR_OPESIS = -1 --->
			
			</cfquery>

			<cfif qCessionarioValido.recordCount EQ 0>
				<cfset cessionarioValido = 0>
			<cfelse>
				<cfset cessionarioValido = qCessionarioValido.BKN045_CD_PERCESS>
			</cfif>

			<!--- Visão Cessionário --->
			<cfif url.visao EQ "cessionario">
				
				<!--- Recupera soma dos contratos por cessionário --->
				<cfquery datasource="#application.datasource#" name="qCessionarioSum">
				
					SELECT
					    <!---BKN045_CD_PERCESS --->
					    SUM(BKN045_VL_FUTURO)   AS SUM_VN
					    ,SUM(BKN045_VL_PRESENTE) AS SUM_VP
					    ,COUNT(BKN045_NR_CONTRA) AS COUNT_CONTRA
					    ,SUM(BKN045_QT_PARC) 	 AS SUM_PARC
					    ,SUM(BKN045_TX_MEDPON)   AS BKN045_TX_MEDPON
					    ,SUM(BKN045_QT_PARC)/COUNT(BKN045_NR_CONTRA)  AS BKN045_NR_PZMEDIO
						
						,BKN045_NR_BANCO
						,BKN045_NR_CEDE
						,BKN045_CD_PROD
						,BN004_NM_PROD
					
						,BN001_NR_GRUPO
						,BN001_NM_GRUPO
					    <!---*--->
					FROM 
					    VW_BKN045 WITH(NOLOCK)
					WHERE
						1=1
					
					<cfif isDefined("url.cessionario.id")>
						AND BN001_NR_GRUPO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cessionario.id#">
					</cfif>	
					<cfif isDefined("url.produto.id")>
						AND BKN045_CD_PROD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.produto.id#">
					</cfif>	
					AND BN001_NR_GRUPO IS NOT NULL
					<!--- AND	BKN045_NR_OPESIS = -1 --->
					AND BKN045_NR_MKCESS = 0
					AND BKN045_NR_BANCO  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.banco.id#">
					AND BKN045_NR_CEDE	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cedente.id#">
					
					GROUP BY
						BKN045_NR_BANCO
						,BKN045_NR_CEDE
						,BKN045_CD_PROD
						,BN004_NM_PROD
					
					    ,BN001_NR_GRUPO
						,BN001_NM_GRUPO
					ORDER BY
						BN001_NM_GRUPO
						,BN004_NM_PROD
				
				</cfquery>
			
			<cfelse><!--- Visão Geral --->
			
				<cfquery datasource="#application.datasource#" name="qCessionarioSum">
					
					SELECT
					    <!--- BKN045_CD_PERCESS --->
					    SUM(BKN045_VL_FUTURO)   AS SUM_VN
					    ,SUM(BKN045_VL_PRESENTE) AS SUM_VP
					    ,COUNT(BKN045_NR_CONTRA) AS COUNT_CONTRA
					    ,SUM(BKN045_QT_PARC) 	 AS SUM_PARC
					    ,SUM(BKN045_TX_MEDPON)   AS BKN045_TX_MEDPON
					    ,SUM(BKN045_QT_PARC)/COUNT(BKN045_NR_CONTRA)  AS BKN045_NR_PZMEDIO
						
						,BKN045_NR_BANCO
						,#url.cedente.id# AS BKN045_NR_CEDE
						,BKN045_CD_PROD
						,BN004_NM_PROD
					    <!--- * ---> 
					FROM 
					    VW_BKN045 WITH(NOLOCK)
					WHERE
						1=1
					AND BKN045_CD_PERCESS IN (0, #variables.cessionarioValido#)
					<cfif isDefined("url.produto.id")>
						AND BKN045_CD_PROD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.produto.id#">
					</cfif>
					<!--- AND	BKN045_NR_OPESIS = -1 --->
					AND BKN045_NR_MKCESS = 0
					AND BKN045_NR_BANCO  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.banco.id#">
					AND BKN045_NR_CEDE	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cedente.id#">
					GROUP BY
						BKN045_NR_BANCO
						,BKN045_CD_PROD
						,BN004_NM_PROD
					ORDER BY
						BN004_NM_PROD
											
				</cfquery>
			
			</cfif>

			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<!--- <cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)> --->

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>
	
</cfcomponent>