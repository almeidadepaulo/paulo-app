<cfcomponent rest="true" restPath="collect/balancete">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="balanceteGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>

		<cfif IsDefined("url.produto")>
			<cfset url.produto = DeserializeJSON(url.produto)>
		</cfif>

		<cfif IsDefined("url.banco")>
			<cfset url.banco = DeserializeJSON(url.banco)>
		</cfif>

		<cfset response["params"] = url>

		<cftry>

			<cfstoredproc 
			datasource="#application.datasource#" 
			procedure="SP_CB209_BALANCETE_DIARIO" 
			result="sp_retorno" 
			returncode="false">

			<cfprocparam type="in" 
			dbvarname="@ENT_NR_VRS" 
			cfsqltype="CF_SQL_VARCHAR"
				value="1" 
			/>

			<cfprocparam type="in" 
				dbvarname="@ENT_NR_INST" 
				cfsqltype="CF_SQL_NUMERIC"
				value="#header.CEDENTE.GRUPO_ID#" 
			/>

			<cfprocparam type="in" 
				dbvarname="@ENT_CD_EMIEMP" 
				cfsqltype="CF_SQL_NUMERIC"
				value="#header.CEDENTE.CEDENTE_ID#" 
			/>

			<cfif IsDefined("url.produto")>
				<cfprocparam type="in" 
					dbvarname="@ENT_NR_PRODUT" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.produto.id#"/>
			<cfelse>
				<cfprocparam type="in" 
					dbvarname="@ENT_NR_PRODUT" 
					cfsqltype="CF_SQL_NUMERIC"					 
					null="true"/>
			</cfif>

			<cfif IsDefined("url.banco.id")>
				<cfprocparam type="in" 
					dbvarname="@ENT_CD_COMPSC" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.banco.id#" />
			<cfelse>
				<cfprocparam type="in" 
					dbvarname="@ENT_CD_COMPSC" 
					cfsqltype="CF_SQL_NUMERIC"					 
					null="true"/>
			</cfif>

			<cfif IsDefined("url.CB209_NR_AGENC") AND url.CB209_NR_AGENC NEQ "">
				<cfprocparam type="in" 
					dbvarname="@ENT_NR_AGENC" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.CB209_NR_AGENC#" />
			<cfelse>
				<cfprocparam type="in" 
					dbvarname="@ENT_NR_AGENC" 
					cfsqltype="CF_SQL_NUMERIC"					 
					null="true"/>
			</cfif>

			<cfif IsDefined("url.CB209_NR_CONTA") AND url.CB209_NR_CONTA NEQ "">
				<cfprocparam type="in" 
					dbvarname="@ENT_NR_CONTA" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.CB209_NR_CONTA#" />
			<cfelse>
				<cfprocparam type="in" 
					dbvarname="@ENT_NR_CONTA" 
					cfsqltype="CF_SQL_NUMERIC"					 
					null="true"/>
			</cfif>
			
			<cfset url.CB209_DT_MOVTO = ISOToDateTime(url.CB209_DT_MOVTO)>
			<cfset url.CB209_DT_MOVTO = DateFormat(url.CB209_DT_MOVTO , "YYYYMMDD")>
			<cfprocparam type="in" 
				dbvarname="@ENT_DT_INI" 
				cfsqltype="CF_SQL_NUMERIC"
				value="#url.CB209_DT_MOVTO#" 
			/>
			

			<cfprocresult name="query">
			</cfstoredproc>

			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = query.recordCount>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<cffunction name="balanceteGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB255_DS_PROD}/{CB209_CD_COMPSC}/{CB209_NR_AGENC}/{CB209_NR_CONTA}/{CB209_DT_MOVTO}"> 

		<cfargument name="CB255_DS_PROD" restargsource="Path" type="string"/>
		<cfargument name="CB209_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB209_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB209_NR_CONTA" restargsource="Path" type="numeric"/>
		<cfargument name="CB209_DT_MOVTO" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
      				 CB209_DT_MOVTO
					,CB255_DS_PROD 
      				,CB209_QT_TOTAL1  
					,CB209_VL_VALOR1 
      				,CB209_QT_TOTAL2
      				,CB209_VL_VALOR2  	  
      				,CB209_QT_TOTAL3 
					,CB209_VL_VALOR3
  	  				,CB209_QT_TOTAL4
					,CB209_VL_VALOR4
					,CB209_QT_TOTAL5
					,CB209_VL_VALOR5	 
				FROM
					SP_CB209_BALANCETE_DIARIO 
				WHERE
				    CB255_DS_PROD = <cfqueryparam value = "#arguments.CB255_DS_PROD#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB209_CD_COMPSC = <cfqueryparam value = "#arguments.CB209_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB209_NR_AGENC = <cfqueryparam value = "#arguments.CB209_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB209_NR_CONTA = <cfqueryparam value = "#arguments.CB209_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB209_DT_MOVTO = <cfqueryparam value = "#arguments.CB209_DT_MOVTO#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn new lib.JsonSerializer().serialize(response)>

    </cffunction>
	
</cfcomponent>