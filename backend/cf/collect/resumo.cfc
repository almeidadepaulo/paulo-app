<cfcomponent rest="true" restPath="collect/resumo">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="tarifaBancariaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['resumo'])>
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

		<cfif IsDefined("url.CB214_DT_MOVTO")>
			<cfset url.CB214_DT_MOVTO = DeserializeJSON(url.CB214_DT_MOVTO)>

			<cfset url.CB214_DT_MOVTO.startDate = ISOToDateTime(url.CB214_DT_MOVTO.startDate)>
			<cfset url.CB214_DT_MOVTO.startDate = DateFormat(url.CB214_DT_MOVTO.startDate , "YYYYMMDD")>

			<cfset url.CB214_DT_MOVTO.endDate = ISOToDateTime(url.CB214_DT_MOVTO.endDate)>
			<cfset url.CB214_DT_MOVTO.endDate = DateFormat(url.CB214_DT_MOVTO.endDate , "YYYYMMDD")>
		</cfif>

		<cfset response["params"] = url>

		<cftry>

			<cfstoredproc 
				datasource="#application.datasource#" 
				procedure="SP_CB214_RESUMO_FINANCEIRO" 
				result="sp_retorno" 
				returncode="false">

				<cfprocparam type="in" 
					dbvarname="@ENT_NR_VRS" 
					cfsqltype="CF_SQL_VARCHAR"
					value="1"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_NR_INST" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#header.CEDENTE.GRUPO_ID#"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_CD_EMIEMP" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#header.CEDENTE.CEDENTE_ID#"/>

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
				
				<cfif IsDefined("url.agencia.id")>
					<cfprocparam type="in" 
						dbvarname="@ENT_NR_AGENC" 
						cfsqltype="CF_SQL_NUMERIC"
						value="#url.agencia.id#" />
				<cfelse>
					<cfprocparam type="in" 
						dbvarname="@ENT_NR_AGENC" 
						cfsqltype="CF_SQL_NUMERIC"					 
						null="true"/>
				</cfif>

				<cfif IsDefined("url.conta.id")>
					<cfprocparam type="in" 
						dbvarname="@ENT_NR_CONTA" 
						cfsqltype="CF_SQL_NUMERIC"
						value="#url.conta.id#" />
				<cfelse>
					<cfprocparam type="in" 
						dbvarname="@ENT_NR_CONTA" 
						cfsqltype="CF_SQL_NUMERIC"					 
						null="true"/>
				</cfif>
				
				<cfprocparam type="in" 
					dbvarname="@ENT_DT_MOVINI" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.CB214_DT_MOVTO.startDate#"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_DT_MOVFIM" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.CB214_DT_MOVTO.endDate#"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_DT_CREINI" 
					cfsqltype="CF_SQL_NUMERIC"
					null="true"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_DT_CREFIM" 
					cfsqltype="CF_SQL_NUMERIC"
					null="true"/>
	
				<cfprocresult name="query">
			</cfstoredproc>

			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = query.recordCount>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>	
</cfcomponent>