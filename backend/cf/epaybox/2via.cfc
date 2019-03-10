<cfcomponent rest="true" restPath="/epaybox/2via">  
	<cfinclude template="../util.cfm">
	
	<cffunction name="segundaViaGet" access="remote" returntype="String" httpmethod="GET"> 
        
		<cfset response = structNew()>
		
		<cfset response["URL"] = URL>

		<cfset rows = 100>
		<cfset arguments.cpf = NumberFormat(session.cpf , "00000000000000")>

		<cfquery datasource="#application.datasource#" name="queryCount">
			SELECT
				COUNT(*) AS COUNT
			FROM
				VW_CB210_2VIA
			WHERE
				CB210_NR_CPFCNPJ =  <cfqueryPARAM value = "#arguments.cpf#" CFSQLType = 'CF_SQL_VARCHAR'>  
        </cfquery>

		<cfquery datasource="#application.datasource#" name="query">
			SELECT
				CB210_CD_COMPSC
				,CB210_NR_AGENC
				,CB210_NR_CONTA
				,CB210_NR_NOSNUM
				,'_' + CB210_NR_PROTOC AS CB210_NR_PROTOC
				,CB201_NM_NMSAC
				,CB210_NR_CONTRA
				,RIGHT(CB210_NR_CPFCNPJ, 11) AS CB210_NR_CPFCNPJ
				,CB210_VL_VALOR
				,CB210_DT_VCTO
				,CB210_DT_VCTO_DD
				,CB210_ID_SITPAG_LABEL
			FROM
				VW_CB210_2VIA
			WHERE
				CB210_NR_CPFCNPJ = <cfqueryPARAM value = "#arguments.cpf#" CFSQLType = 'CF_SQL_VARCHAR'>  
			ORDER BY
				CB210_DT_VCTO DESC
			
			<!--- Paginação --->
			OFFSET #URL.rowFrom# ROWS
			FETCH NEXT 100 ROWS ONLY;
        </cfquery>
		
		<cfset response["rowFrom"] = URL.rowFrom>		
		<cfset response["recordCount"] = queryCount.COUNT>
		<cfset response["query"] = queryToArray(query)>

		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<cffunction name="boleto" access="remote" returnType="String" httpMethod="POST" restPath="/boleto">
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(ARGUMENTS.body)>
		
		<cfset response = structNew()>
		<cfset response["ARGUMENTS"] = body>
		<cfset response["message"] = ''>

		<cfquery datasource="#application.datasource#" name="qQuery">
			SELECT
				CB850_IM_PDF
			FROM
				CB850
			WHERE
				CB850_NR_PROTOC = <cfqueryparam cfsqltype="cf_sql_char" value="#replace(body.protocolo, "_", "")#">
		</cfquery>

		<cfset response["base64"] = toBase64(qQuery.CB850_IM_PDF)>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

</cfcomponent>
