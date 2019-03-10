<cfcomponent rest="true" restPath="publish/sms">  
    <cfprocessingDirective pageencoding="utf-8">
    <cfset setEncoding("form","utf-8")> 

	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

    <cffunction name="smsGet" access="remote" returnType="String" httpMethod="GET">
        <cfset checkAuthentication()>
        <cfreturn "Serviço de SMS - Sistema Publish">
    </cffunction>

	<cffunction name="smsPost" access="remote" returnType="String" httpMethod="POST">	
		<!---
		body:
		{			
			data: [{
				mensagem: {
					CPF: stringUtil.right(vm.filter.sacado.item.CB201_NR_CPFCNPJ, 11),
					Cartao: '',
					CodigoCampanha: 1,
					Conta: '',
					//DataAdesaoPacote: new Date(),
					//DataCancelamentoPacote: new Date(),
					DataEnvio: new Date(),
					DDD: vm.sms.celular.substr(0, 2),
					//DDI: 55,
					//Email: '',
					Logo: '',
					NumeroPacote: 0,
					Org: '',
					Telefone: vm.sms.celular.substr(2, 9),
					TipoCliente: 1,
					TipoDaCampanha: 1,
					/* 1 */
					/* 1: Titulo 2:Adicional */
					TipoTelefone: 2 /* 2 */
				},
				sms: {
					//AberturaConta: new Date(),
					//AniversarioAdicional: new Date(),
					//AniversarioTitular: new Date(),
					//CodigoBarras: '',
					CodigoSMS: 0,
					//CodigoMoeda: '',
					//CodigoPais: '',                    
					//DataHora: new Date(),
					//DiasAtraso: 0,
					//FinalCartao:0,
					//HoraRecebimento: new Date(),
					//LimiteDisponivel: 0 ,
					//LimiteTotalCartao: 0,
					//MelhorDia: '',
					//MotivoCancelamento: ''                
					Nome: '',
					//NomeEstabelecimento: '',
					//TotalAtraso: 0,
					//ValorAutorizado: 0,
					//ValorFatura:0,
					//ValorMinimo:0,
					//VencCms: new Date()
				}
			}]
		}
		--->	
		<cfargument name="body" type="String">

        <cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<!--- <cfset response["arguments"] = arguments>	--->
				      
		<cfloop from="1" to="#ArrayLen(body.data)#" index="i">

			<cfset body.data[i].mensagem.DataEnvio = now()>
			
			<!--- validate --->
			<cfset bodyErrors = {
				cartao: {
					label: 'mensagem.cartao[' & (i - 1)  & ']',
					type: 'string',
					defined: true						
				} , 
				CodigoCampanha: {
					label: 'mensagem.CodigoCampanha[' & (i - 1)  & ']',
					type: 'string',
					defined: true						
				} , 
				Conta: {
					label: 'mensagem.Conta[' & (i - 1)  & ']',
					type: 'string',
					defined: true						
				} , 
				CPF: {
					label: 'mensagem.CPF[' & (i - 1)  & ']',
					type: 'string',
					defined: true						
				} , 
				DataAdesaoPacote: {
					label: 'mensagem.DataAdesaoPacote[' & (i - 1)  & ']',
					type: 'date'						
				} , 
				DataCancelamentoPacote: {
					label: 'mensagem.DataCancelamentoPacote[' & (i - 1)  & ']',
					type: 'date'						
				} , 
				DataEnvio: {
					label: 'mensagem.DataEnvio[' & (i - 1)  & ']',
					type: 'date',
					required: true					
				} , 
				DDD: {
					label: 'mensagem.DDD[' & (i - 1)  & ']',
					type: 'numeric',
					required: true					
				} , 
				DDI: {
					label: 'mensagem.DDI[' & (i - 1)  & ']',
					type: 'numeric'				
				} , 
				Email: {
					label: 'mensagem.Email[' & (i - 1)  & ']',
					type: 'string'				
				} , 
				Logo: {
					label: 'mensagem.Logo[' & (i - 1)  & ']',
					type: 'string',
					defined: true			
				} , 
				NumeroPacote: {
					label: 'NumeroPacote.DDD[' & (i - 1)  & ']',
					type: 'numeric',
					required: true			
				} , 
				Org: {
					label: 'mensagem.Org[' & (i - 1)  & ']',
					type: 'string',
					defined: true			
				} , 
				Telefone: {
					label: 'mensagem.Telefone[' & (i - 1)  & ']',
					type: 'numeric',
					required: true			
				} , 
				TipoCliente: {
					label: 'mensagem.TipoCliente[' & (i - 1)  & ']',
					type: 'numeric',
					required: true			
				} , 
				TipoDaCampanha: {
					label: 'mensagem.TipoDaCampanha[' & (i - 1)  & ']',
					type: 'numeric',
					required: true			
				} , 
				TipoTelefone: {
					label: 'mensagem.TipoTelefone[' & (i - 1)  & ']',
					type: 'numeric',
					required: true			
				}
			}>

			<cfset validate(body.data[i].mensagem, bodyErrors)>

			<!--- validate --->
			<cfset bodyErrors = {
				AberturaConta: {
					label: 'sms.AberturaConta[' & (i - 1)  & ']',
					type: 'date'						
				} , 
				AniversarioAdicional: {
					label: 'sms.AniversarioAdicional[' & (i - 1)  & ']',
					type: 'date'						
				} , 
				AniversarioTitular: {
					label: 'sms.AniversarioTitular[' & (i - 1)  & ']',
					type: 'date'					
				} , 
				CodigoBarras: {
					label: 'sms.CodigoBarras[' & (i - 1)  & ']',
					type: 'string'						
				} , 
				CodigoSMS: {
					label: 'sms.CodigoSMS[' & (i - 1)  & ']',
					type: 'numeric',
					required: true
				} , 
				CodMoeda: {
					label: 'sms.CodMoeda[' & (i - 1)  & ']',
					type: 'string'						
				} , 
				CodPais: {
					label: 'sms.CodPais[' & (i - 1)  & ']',
					type: 'string'					
				} , 
				DataHora: {
					label: 'sms.DataHora[' & (i - 1)  & ']',
					type: 'date'					
				} , 
				DiasAtraso: {
					label: 'sms.DiasAtraso[' & (i - 1)  & ']',
					type: 'numeric'				
				} , 
				FinalCartao: {
					label: 'sms.FinalCartao[' & (i - 1)  & ']',
					type: 'numeric'				
				} , 
				HoraRecebimento: {
					label: 'sms.HoraRecebimento[' & (i - 1)  & ']',
					type: 'date'			
				} , 
				LimiteDisponivel: {
					label: 'sms.LimiteDisponivel[' & (i - 1)  & ']',
					type: 'numeric'		
				} , 
				LimiteTotalCartao: {
					label: 'sms.LimiteTotalCartao[' & (i - 1)  & ']',
					type: 'numeric'		
				} , 
				MelhorDia: {
					label: 'sms.MelhorDia[' & (i - 1)  & ']',
					type: 'string'			
				} , 
				MotivoCancelamento: {
					label: 'sms.MotivoCancelamento[' & (i - 1)  & ']',
					type: 'string'			
				} , 
				Nome: {
					label: 'sms.Nome[' & (i - 1)  & ']',
					type: 'string',
					defined: true			
				} , 
				NomeEstabelecimento: {
					label: 'sms.NomeEstabelecimento[' & (i - 1)  & ']',
					type: 'string'			
				} , 
				TotalAtraso: {
					label: 'sms.TotalAtraso[' & (i - 1)  & ']',
					type: 'numeric'			
				} , 
				ValorAutorizado: {
					label: 'sms.ValorAutorizado[' & (i - 1)  & ']',
					type: 'numeric'			
				} , 
				ValorFatura: {
					label: 'sms.ValorFatura[' & (i - 1)  & ']',
					type: 'numeric'			
				} , 
				ValorMinimo: {
					label: 'sms.ValorMinimo[' & (i - 1)  & ']',
					type: 'numeric'			
				} , 
				VencCms: {
					label: 'sms.VencCms[' & (i - 1)  & ']',
					type: 'date'			
				}
			}>

			<cfset validate(body.data[i].sms, bodyErrors)>

			<cftry>

				<cfset row = body.data[i]>
			
				<cfif not isDefined("row.mensagem.dataAdesaoPacote")>
					<cfset row.mensagem.dataAdesaoPacote = 0>
				<cfelse>
					<cfset row.mensagem.dataAdesaoPacote = lsDateTimeFormat(ISOToDateTime(row.mensagem.dataAdesaoPacote), 'yyyymmdd')>				
				</cfif>
				
				<cfif not isDefined("row.mensagem.dataCancelamentoPacote")>
					<cfset row.mensagem.dataCancelamentoPacote = 0>
				<cfelse>
					<cfset row.mensagem.dataCancelamentoPacote = lsDateTimeFormat(ISOToDateTime(row.mensagem.dataCancelamentoPacote), 'yyyymmdd')>				
				</cfif>
			
				<cfif not isDefined("row.mensagem.ddi")>
					<cfset row.mensagem.ddi = 55>
				</cfif>
				
				<cfif not isDefined("row.mensagem.email")>
					<cfset row.mensagem.email = "">
				</cfif>
				
				<cfif not isDefined("row.sms.valorMinimo")>
					<cfset row.sms.valorMinimo = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.valorFatura")>
					<cfset row.sms.valorFatura = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.vencCms")>
					<cfset row.sms.vencCms = 0>
				<cfelse>
					<cfset row.sms.vencCms = lsDateTimeFormat(ISOToDateTime(row.sms.vencCms), 'yyyymmdd')>			
				</cfif>
				
				<cfif not isDefined("row.sms.diasAtraso")>
					<cfset row.sms.diasAtraso = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.melhorDia")>
					<cfset row.sms.melhorDia = "">
				</cfif>
				
				<cfif not isDefined("row.sms.finalCartao")>
					<cfset row.sms.finalCartao = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.dataHora")>
					<cfset row.sms.dataHora = now()>
				<cfelse>
					<cfset row.sms.dataHora = dateAdd('h', GetTimeZoneInfo().utcHourOffset, ISOToDateTime(row.sms.dataHora))>
				</cfif>
				
				<cfif not isDefined("row.sms.valorAutorizado")>
					<cfset row.sms.valorAutorizado = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.limiteDisponivel")>
					<cfset row.sms.limiteDisponivel = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.limiteTotalCartao")>
					<cfset row.sms.limiteTotalCartao = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.horaRecebimento")>
					<cfset row.sms.horaRecebimento = lsDateTimeFormat(now(),'HHnnss')>
				<cfelse>                
					<cfset row.sms.horaRecebimento = lsDateTimeFormat(dateAdd('h', GetTimeZoneInfo().utcHourOffset, row.sms.horaRecebimento), 'HHnnss')>
				</cfif>
				
				<cfif not isDefined("row.sms.aniversarioTitular")>
					<cfset row.sms.aniversarioTitular = 0>
				<cfelse>
					<cfset row.sms.aniversarioTitular = lsDateTimeFormat(row.sms.aniversarioTitular, 'yyyymmdd')>				
				</cfif>
				
				<cfif not isDefined("row.sms.aniversarioAdicional")>
					<cfset row.sms.aniversarioAdicional = 0>
				<cfelse>
					<cfset row.sms.aniversarioAdicional = lsDateTimeFormat(row.sms.aniversarioAdicional, 'yyyymmdd')>				
				</cfif>
				
				<cfif not isDefined("row.sms.aberturaConta")>
					<cfset row.sms.aberturaConta = 0>
				<cfelse>
					<cfset row.sms.aberturaConta = lsDateTimeFormat(row.sms.aberturaConta, 'yyyymmdd')>				
				</cfif>
				
				<cfif not isDefined("row.sms.totalAtraso")>
					<cfset row.sms.totalAtraso = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.motivoCancelamento")>
					<cfset row.sms.motivoCancelamento = "">
				</cfif>
				
				<cfif not isDefined("row.sms.codigoBarras")>
					<cfset row.sms.codigoBarras = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.nomeEstabelecimento")>
					<cfset row.sms.nomeEstabelecimento = 0>
				</cfif>
				
				<cfif not isDefined("row.sms.conversaoDolarReal")>
					<cfset row.sms.conversaoDolarReal = "">
				</cfif>
				
				<cfif not isDefined("row.sms.valorTransacaoReal")>
					<cfset row.sms.valorTransacaoReal  = 0>
				</cfif>
				
				<cfif not isDefined("row.mensagem.org") OR trim(row.mensagem.org) EQ "">
					<cfset row.mensagem.org  = 0>
				</cfif>
				
				<cfif not isDefined("row.mensagem.logo") OR trim(row.mensagem.logo) EQ "">
					<cfset row.mensagem.logo  = 0>
				</cfif>

				<cfif not isDefined("row.sms.CodigoMoeda") OR trim(row.sms.CodigoMoeda) EQ "">
					<cfset row.sms.CodigoMoeda = ''>
				</cfif>

				<cfif not isDefined("row.sms.codigoPais") OR trim(row.sms.codigoPais) EQ "">
					<cfset row.sms.codigoPais = ''>
				</cfif>

				<!--- SMS Livre --->
				<cfif row.sms.CodigoSMS EQ 0>

					<cfset response["aaaa"] = 1>					

					<cfquery datasource	="#application.datasource#">
						INSERT INTO 
							dbo.MG002
						(							
							MG002_NR_CPF,
							MG002_NR_ORG,
							MG002_NR_LOGO,
							MG002_NR_CARTAO,
							MG002_TP_CLIENT,
							MG002_DT_GERAC,
							MG002_NR_INST,
							MG002_DT_RETO,
							MG002_HR_RETO,
							MG002_DT_RECEB,
							MG002_HR_RECEB,
							MG002_ID_SITUAC,
							MG002_CD_EMIEMP,
							MG002_NR_BROKER,
							MG002_CD_CODSMS,
							MG002_VL_FATURA,
							MG002_DT_VENCCM,
							MG002_NR_DIAATR,
							MG002_NR_FINCAT,
							MG002_DT_DTHORA,
							MG002_VL_MIN,
							MG002_VL_AUTZ,
							MG002_VL_LIMITE,
							MG002_VL_TOTCAT,
							MG002_DT_NIVER,
							MG002_DT_ABERTU,
							MG002_VL_ATRASO,
							MG002_TP_CANCEL,
							MG002_NM_NOME,
							MG002_NM_BARCOD,
							MG002_NM_ESTABE,
							MG002_NM_MELDIA,
							MG002_NM_TEXTO,
							MG002_NR_REMESS,
							MG002_DT_REMESS,
							MG002_HR_REMESS,
							MG002_ID_STATUS,
							MG002_TP_CATEG,
							MG002_ID_PRIOR,
							MG002_ID_ORIG,
							MG002_NR_DDD,
							MG002_NR_TEL,
							MG002_TP_TEL,
							MG002_NM_MOEDA,
							MG002_NM_PAIS,
							MG002_CD_OPESIS,
							MG002_DT_INCSIS,
							MG002_DT_ATUSIS
						) 
						VALUES (							
							<cfqueryparam value = "#row.mensagem.cpf#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.mensagem.org#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.mensagem.logo#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.mensagem.cartao#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.mensagem.TipoCliente#" CFSQLType = "CF_SQL_NUMERIC">,
							CONVERT(VARCHAR(8), GETDATE(), 112),
							1,
							NULL,
							NULL,
							CONVERT(VARCHAR(8), GETDATE(), 112),
							<cfqueryparam value = "#row.sms.horaRecebimento#" CFSQLType = "CF_SQL_NUMERIC">,
							10,
							1,
							1,
							<cfqueryparam value = "#row.sms.CodigoSMS#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.sms.ValorFatura#" CFSQLType = "CF_SQL_FLOAT">,
							<cfqueryparam value = "#row.sms.VencCms#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.sms.TotalAtraso#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.sms.finalCartao#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.sms.dataHora#" CFSQLType = "CF_SQL_TIMESTAMP">,
							<cfqueryparam value = "#row.sms.ValorMinimo#" CFSQLType = "CF_SQL_FLOAT">,
							<cfqueryparam value = "#row.sms.ValorAutorizado#" CFSQLType = "CF_SQL_FLOAT">,
							<cfqueryparam value = "#row.sms.LimiteDisponivel#" CFSQLType = "CF_SQL_FLOAT">,
							<cfqueryparam value = "#row.sms.limiteTotalCartao#" CFSQLType = "CF_SQL_FLOAT">,
							<cfqueryparam value = "#row.sms.AniversarioTitular#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.sms.AberturaConta#" CFSQLType = "CF_SQL_NUMERIC">,
							<cfqueryparam value = "#row.sms.TotalAtraso#" CFSQLType = "CF_SQL_FLOAT">,
							'',
							<cfqueryparam value = "#row.sms.Nome#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.sms.CodigoBarras#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.sms.NomeEstabelecimento#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.sms.MelhorDia#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#body.mensagem#" CFSQLType = "CF_SQL_VARCHAR">,
							NULL,
							CONVERT(VARCHAR(8), GETDATE(), 112),
							CONVERT(VARCHAR, SUBSTRING(REPLACE(CONVERT(VARCHAR, GETDATE(), 114), ':', ''), 1, 8)),
							'',
							0,
							0,
							2,
							<cfqueryparam value = "#row.mensagem.DDD#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.mensagem.Telefone#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.mensagem.TipoTelefone#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.sms.CodigoMoeda#" CFSQLType = "CF_SQL_VARCHAR">,
							<cfqueryparam value = "#row.sms.CodigoPais#" CFSQLType = "CF_SQL_VARCHAR">,
							-1,
							GETDATE(),
							GETDATE()
						);
					</cfquery>
					
				<cfelse>

					<cfstoredproc 	
						datasource	="#application.datasource#" 
						procedure	="SP_CB0350004" 
						returncode	="false">
									
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_VRS" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="1" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_ENVIO" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#lsDateTimeFormat(ISOToDateTime(row.mensagem.dataEnvio), 'yyyymmdd')#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_CD_CAMPAN" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.codigoCampanha#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_TP_CAMPAN" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="1" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_TP_CLIENT" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.tipoCliente#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_ADESAO" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#lsDateTimeFormat(ISOToDateTime(row.mensagem.dataAdesaoPacote), 'yyyymmdd')#" 
										/>				
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_CANCEL" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.dataCancelamentoPacote#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_PACOTE" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.numeroPacote#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_DDI" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.ddi#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_DDD" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.ddd#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_TEL" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.telefone#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_TP_TEL" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.tipoTelefone#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_ORG" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.org#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_LOGO" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.mensagem.logo#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_CONTA" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.mensagem.conta#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_CARTAO" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.mensagem.cartao#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_CPF" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.mensagem.cpf#" 
										/>	
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_EMAIL" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.mensagem.email#" 
										/>	
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_CD_CODSMS" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.codigoSms#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_VL_MIN" 
										cfsqltype	="CF_SQL_FLOAT"
										value		="#row.sms.valorMinimo#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_VL_FATURA" 
										cfsqltype	="CF_SQL_FLOAT"
										value		="#row.sms.valorFatura#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_VENCCM" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.vencCms#" 
										/>					
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_DIAATR" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.diasAtraso#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_MELDIA" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.sms.melhorDia#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NR_FINCAT" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.finalCartao#" 
										/>				
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_DTHORA" 
										cfsqltype	="CF_SQL_TIMESTAMP"
										value		="#row.sms.dataHora#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_VL_AUTZ" 
										cfsqltype	="CF_SQL_FLOAT"
										value		="#row.sms.valorAutorizado#" 
										/>
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_VL_LIMITE" 
										cfsqltype	="CF_SQL_FLOAT"
										value		="#row.sms.limiteDisponivel#" 
										/>	
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_VL_TOTCAT" 
										cfsqltype	="CF_SQL_FLOAT"
										value		="#row.sms.limiteTotalCartao#" 
										/>					
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_HR_RECB" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.horaRecebimento#"
										/>				
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_NIVERT" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.aniversarioTitular#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_NIVERA" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.aniversarioAdicional#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_DT_ABERTU" 
										cfsqltype	="CF_SQL_NUMERIC"
										value		="#row.sms.aberturaConta#" 
										/> 	
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_VL_ATRASO" 
										cfsqltype	="CF_SQL_FLOAT"
										value		="#row.sms.totalAtraso#" 
										/>	
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_TP_CANCEL" 
										cfsqltype	="CF_SQL_CHAR"
										value		="#row.sms.motivoCancelamento#" 
										/>				
							
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_NOME" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.sms.nome#" 
										/>
										
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_BARCOD" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.sms.codigoBarras#" 
										/>				
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_ESTABE" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.sms.nomeEstabelecimento#" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_MOEDA" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.sms.codigoMoeda#"
										maxlength   ="3" 
										/>
						
						<cfprocparam 	type		="in" 
										dbvarname	="@ENT_NM_PAIS" 
										cfsqltype	="CF_SQL_VARCHAR"
										value		="#row.sms.codigoPais#"
										maxlength   ="3" 
										/>
																								
						<cfprocresult name="query">
						
					</cfstoredproc>
				</cfif>

				<cfcatch>            		
					<cfset responseError(400, cfcatch.detail)>				
				</cfcatch>	
			</cftry>

            <!--- <cfset response["query"] = query> --->
        </cfloop>

		<cfset response["status"] = "ok">            

		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

</cfcomponent>