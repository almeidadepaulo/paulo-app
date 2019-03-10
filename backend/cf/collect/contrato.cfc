<cfcomponent rest="true" restPath="collect/contrato">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="contratoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['contrato'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB213
                WHERE
                    1 = 1

				AND CB213_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB213_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
                <cfif IsDefined("url.CB213_NR_CONTRA") AND url.CB213_NR_CONTRA NEQ "">
					AND	CB213_NR_CONTRA = <cfqueryparam value = "#url.CB213_NR_CONTRA#" CFSQLType = "CF_SQL_CHAR">
				</cfif>

				<cfif IsDefined("url.CB213_NR_CPFCNPJ") AND url.CB213_NR_CPFCNPJ NEQ "">
					AND	CB213_NR_CPFCNPJ LIKE <cfqueryparam value = "%#url.CB213_NR_CPFCNPJ#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY CB213_NR_CONTRA ASC) AS ROW
					,CB213_NR_OPERADOR
					,CB213_NR_CEDENTE
					,CB213_NR_CONTRA
					,CB213_NR_CPFCNPJ
					,CB213_NM_CLIENT
					,CB255_DS_PRODR
					,CB213_DT_LIBERA
					,CB213_VL_TAXA
					,CB213_DT_NASC
					,CB213_NR_DDD1
					,CB213_NR_FONE1
					,CB213_CD_CEP
					,CB213_DS_LOGRAD
					,CB213_DS_BAIRRO
					,CB213_NM_CIDADE
					,CB213_SG_UF
				FROM
					VW_CB213
				WHERE
					1 = 1

				AND CB213_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB213_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
					
				<cfif IsDefined("url.CB213_NR_CONTRA") AND url.CB213_NR_CONTRA NEQ "">
					AND	CB213_NR_CONTRA = <cfqueryparam value = "#url.CB213_NR_CONTRA#" CFSQLType = "CF_SQL_CHAR">
				</cfif>

				<cfif IsDefined("url.CB213_NR_CPFCNPJ") AND url.CB213_NR_CPFCNPJ NEQ "">
					AND	CB213_NR_CPFCNPJ LIKE <cfqueryparam value = "%#url.CB213_NR_CPFCNPJ#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB213_NM_CLIENT") AND url.CB213_NM_CLIENT NEQ "">
					AND	CB213_NM_CLIENT LIKE <cfqueryparam value = "%#url.CB213_NM_CLIENT#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
				ORDER BY
					CB213_NR_CONTRA ASC	
                
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

	<cffunction name="contratoGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB213_NR_OPERADOR}/{CB213_NR_CEDENTE}/{CB213_NR_CONTRA}/{CB213_NR_CPFCNPJ}"> 

		<cfargument name="CB213_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB213_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB213_NR_CONTRA" restargsource="Path" type="string"/>
		<cfargument name="CB213_NR_CPFCNPJ" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['contrato'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 CB213_NR_OPERADOR
					,CB213_NR_CEDENTE
					,CB213_NR_CONTRA
					,CB213_NR_CPFCNPJ
					,CB213_NM_CLIENT
					,CB255_DS_PRODR
					,CB213_DT_LIBERA
					,CB213_VL_TAXA
					,CB213_DT_NASC
					,CB213_NR_DDD1
					,CB213_NR_FONE1
					,CB213_CD_CEP
					,CB213_DS_LOGRAD
					,CB213_DS_BAIRRO
					,CB213_NM_CIDADE
					,CB213_SG_UF
				FROM
					VW_CB213 
				WHERE
				    CB213_NR_OPERADOR = <cfqueryparam value = "#arguments.CB213_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB213_NR_CEDENTE = <cfqueryparam value = "#arguments.CB213_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB213_NR_CONTRA = <cfqueryparam value = "#arguments.CB213_NR_CONTRA#" CFSQLType = "CF_SQL_CHAR">
				AND	CB213_NR_CPFCNPJ = <cfqueryparam value = "#arguments.CB213_NR_CPFCNPJ#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn new lib.JsonSerializer().serialize(response)>

    </cffunction>
</cfcomponent>