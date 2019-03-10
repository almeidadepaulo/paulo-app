<cfcomponent rest="true" restPath="collect/tarifa-bancaria">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="tarifaBancariaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['tarifa-bancaria'])>
		<cfset cedenteValidate()>
		        
		<cfset response = structNew()>

		<cfif IsDefined("url.produto")>
			<cfset url.produto = DeserializeJSON(url.produto)>
		</cfif>

		<cfif IsDefined("url.carteira")>
			<cfset url.carteira = DeserializeJSON(url.carteira)>
		</cfif>

		<cfif IsDefined("url.banco")>
			<cfset url.banco = DeserializeJSON(url.banco)>
		</cfif>

		<cfif IsDefined("url.agencia")>
			<cfset url.agencia = DeserializeJSON(url.agencia)>
		</cfif>

		<cfif IsDefined("url.conta")>
			<cfset url.conta = DeserializeJSON(url.conta)>
		</cfif>

		<cfif IsDefined("url.CB209_DT_MOVTO")>
			<cfset url.CB209_DT_MOVTO = DeserializeJSON(url.CB209_DT_MOVTO)>

			<cfset url.CB209_DT_MOVTO.startDate = ISOToDateTime(url.CB209_DT_MOVTO.startDate)>
			<cfset url.CB209_DT_MOVTO.startDate = DateFormat(url.CB209_DT_MOVTO.startDate , "YYYYMMDD")>

			<cfset url.CB209_DT_MOVTO.endDate = ISOToDateTime(url.CB209_DT_MOVTO.endDate)>
			<cfset url.CB209_DT_MOVTO.endDate = DateFormat(url.CB209_DT_MOVTO.endDate , "YYYYMMDD")>
		</cfif>

		<cfset response["params"] = url>

		<cftry>

			<cfstoredproc 
				datasource="#application.datasource#" 
				procedure="SP_CB209_TARIFA_BANCARIA" 
				result="sp_retorno" 
				returncode="false">

				<cfprocparam type="in" 
					dbvarname="@ENT_NR_VRS" 
					cfsqltype="CF_SQL_VARCHAR"
					value="1"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_NR_INST" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#header.cedente.GRUPO_ID#"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_CD_EMIEMP" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#header.cedente.CEDENTE_ID#"/>

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

				<cfif IsDefined("url.produto.id")>
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

				<cfif IsDefined("url.carteira.id")>
					<cfprocparam type="in" 
						dbvarname="@ENT_CD_CART" 
						cfsqltype="CF_SQL_NUMERIC"
						value="#url.carteira.id#"/>
				<cfelse>
					<cfprocparam type="in" 
						dbvarname="@ENT_CD_CART" 
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
					dbvarname="@ENT_DT_INI" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.CB209_DT_MOVTO.startDate#"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_DT_FIM" 
					cfsqltype="CF_SQL_NUMERIC"
					value="#url.CB209_DT_MOVTO.endDate#"/>

				<cfprocparam type="in" 
					dbvarname="@ENT_DT_MES" 
					cfsqltype="CF_SQL_NUMERIC"
					value="1"/>
	
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