<cfcomponent rest="true" restPath="facebank/credito-simulacao">
	<cfinclude template="../util.cfm">

    <cffunction name="getCliente" access="remote" returnType="String" httpMethod="GET" restPath="/cliente">
    	
    	<cfset response = structNew()>
    	<cfquery datasource="seeaway_sql" name="qQuery">
			SELECT
				TOP 100
				CB262_NR_OPERADOR
				,CB262_NR_CEDENTE
				,CB262_TP_MOVTO
				,CB262_NR_LOTE
				,CB262_NR_CONTRA
				,CB262_QT_PARC
				,CB262_NR_CPFCNPJ
				,CB262_TP_CPFCNPJ			
				,CB262_NM_CLIENT
				,CB262_NR_CPFCNPJ
				,CB262_NM_LOGRAD
				,'100' AS CB262_NR_LOGRAD
				,CB262_NM_BAIRRO
				,CB262_NM_CIDADE
				,CB262_SG_UF
				,CB262_NR_CEP
				,CB262_NR_DDD
				,CB262_NR_TEL
				,CB262_NM_EMAIL
			FROM
				CB262
			WHERE
				CB262_NR_OPERADOR = 903
			AND CB262_NR_CEDENTE = 913
			AND CB262_TP_MOVTO = 'FACECRED'
		</cfquery>

		<cftry>
			
			<cfset response["query"] = QueryToArray(qQuery)>
			<cfset response["success"] = true>
						
			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["message"] = 'Erro ao se comunicar com o servidor'>
				<cfset response["cfcatch"] = cfcatch>
				<cfreturn SerializeJSON(response)>
			</cfcatch>
		</cftry>

    </cffunction>

    <cffunction name="updateCliente" access="remote" returnType="String" httpMethod="POST" restPath="/cliente">
        <cfargument name="body" type="String">
        
        <cfset body = DeserializeJSON(ARGUMENTS.body)>
	    <cfset now = now()>

		<cfset response = structNew()>
		<cfset response["ARGUMENTS"] = body>

		<cfset path = getDirectoryFromPath(getCurrentTemplatePath())>
		<cfset serverPath = path & "..\..\_server">
		
		<cftry>	
			<cfset body.cliente = deserializeJSON(body.cliente)>

			<cfset response["operacao"] = "9" & LSDateFormat(now, "YYMMDD") & LSTimeFormat(now, "HHmmss")>
			<cfset response["sleep"] = false>

			<cfset drive = "C:">
			<cfif not fileExists("C:\Smartbank\Facebank\PROCEDURES\FACEBANKBOLETO.bat")>
				<cfset drive = "D:">
			</cfif>
			
			<cfif fileExists("#drive#\Smartbank\Facebank\PROCEDURES\FACEBANKBOLETO.bat")>
				<cfexecute name = "C:\Windows\system32\cmd.exe"   
				    arguments = "/C #drive#\Smartbank\Facebank\PROCEDURES\FACEBANKBOLETO.bat #numberFormat(body.cliente.pk.CB262_NR_CONTRA, '000000000000')#"
					variable = "batResult"				    
				    timeout	= "60" />

				<cfset response["boleto-rc"] = "">
				<cfif isDefined('batResult') AND batResult NEQ "">
					<cfloop array="#listToArray(batResult,chr(10))#" index="i">					
						<cfif FindOneOf(i,"=")>							
							<cfset variaveisBat[listToArray(i,"=")[1]] = trim(listToArray(i,"=")[2])>						
						</cfif>					
					</cfloop>
					<cfset response["boleto-rc"] = variaveisBat.rc>					
				</cfif>
			<cfelse>
				<cfset sleepPath = path & "\sleep.bat">
				<cfset response["sleep"] = true>
				<cfset response["sleepPath"] = sleepPath>
				<!---
				<cfexecute name = "C:\Windows\system32\cmd.exe"   
				    arguments = "/C #sleepPath#"
					variable = "sleepResult"				    
				    timeout	= "70" />
				--->
				<cfset response["sleepResult"] = "sleepResult">
			</cfif>
			
			<cfquery datasource="seeaway_sql" result="rQuery">
				UPDATE 
					dbo.CB262  
				SET 
					CB262_NR_OPGENY = <cfqueryparam cfsqltype="cf_sql_varcahr" value="#response.operacao#">
					,CB262_NR_DDD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mid(body.cliente.celular,1,2)#">
					,CB262_NR_TEL = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mid(body.cliente.celular,3,len(body.cliente.celular))#">
					,CB262_NM_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.cliente.email#">
				WHERE
					CB262_NR_OPERADOR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_OPERADOR#">
				AND CB262_NR_CEDENTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_CEDENTE#">
				AND CB262_TP_MOVTO = <cfqueryparam cfsqltype="cf_sql_char" value="#body.cliente.pk.CB262_TP_MOVTO#">
				AND CB262_NR_LOTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_LOTE#">
				AND CB262_NR_CONTRA = <cfqueryparam cfsqltype="cf_sql_char" value="#body.cliente.pk.CB262_NR_CONTRA#">
				AND CB262_NR_CPFCNPJ = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_CPFCNPJ#">
			</cfquery>
			
			<cfquery datasource="seeaway_sql" name="qQuery">
				SELECT
					CB262_NR_OPERADOR
					,CB262_NR_CEDENTE
					,CB262_TP_MOVTO
					,CB262_NR_LOTE
					,CB262_NR_CONTRA
					,CB262_NR_CPFCNPJ
					,CB262_TP_CPFCNPJ
					,CB262_NM_CLIENT
					,CB262_NM_LOGRAD
					,CB262_NM_BAIRRO
					,CB262_NM_CIDADE
					,CB262_SG_UF
					,CB262_NR_CEP
					,CB262_NR_DDD
					,CB262_NR_TEL
					,CB262_NM_EMAIL
					,CB262_DT_NASC
					,CB262_QT_PARC
					,CB262_VL_PARC
					,CB262_NR_AGENC
					,CB262_NR_CONTA
					,CB262_VL_FINAM

					,CB264_NM_MODEL
					,CB264_NR_CHASSI
					,CB264_NR_RENAVAM
					,CB264_NR_PLACA
					,CB264_NM_FABRIC

				FROM
					CB262

				INNER JOIN CB264
				ON CB262_NR_OPERADOR = CB264_NR_OPERADOR
				AND CB262_NR_CEDENTE = CB264_NR_CEDENTE
				AND CB262_NR_CPFCNPJ = CB264_NR_CNPJ

				WHERE
					CB262_NR_OPERADOR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_OPERADOR#">
				AND CB262_NR_CEDENTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_CEDENTE#">
				AND CB262_TP_MOVTO = <cfqueryparam cfsqltype="cf_sql_char" value="#body.cliente.pk.CB262_TP_MOVTO#">
				AND CB262_NR_LOTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_LOTE#">
				AND CB262_NR_CONTRA = <cfqueryparam cfsqltype="cf_sql_char" value="#body.cliente.pk.CB262_NR_CONTRA#">
				AND CB262_NR_CPFCNPJ = <cfqueryparam cfsqltype="cf_sql_numeric" value="#body.cliente.pk.CB262_NR_CPFCNPJ#">

			</cfquery>
			
			<cfset response["pdfViewer"] = "facebank-credito-simulacao/">
			<cfset pathPdf = serverPath & "/facebank-credito-simulacao/" & LSDateFormat(dateAdd("d", -1, now), "YYMMDD")>
			<cfif directoryExists(pathPdf)>
				<cfdirectory action="delete" directory="#pathPdf#" recurse="true"/>		
			</cfif>
			<cfset pathPdf = serverPath & "/" & response.pdfViewer & LSDateFormat(now, "YYMMDD")>
			<cfif not directoryExists(pathPdf)>
				<cfdirectory action="create" directory="#pathPdf#" />		
			</cfif>

			<cfset response["pdfViewer"] = "facebank-credito-simulacao/" & LSDateFormat(now, "YYMMDD") & "/" & response["operacao"] & ".pdf">
			<cfset response["pathPdf"] = pathPdf & "/" & response["operacao"] & ".pdf">

			<cfdocument format="PDF" filename="#response.pathPdf#" overwrite="true">				
				<cfinclude template="pdf-content.cfm">				
				<!---
				<cfoutput>
					<center><h1><font color="##123456">CONTRATO XXXXXXXX-XXX</font></h1></center>
					<h2>#body.cliente.nome#</h2>

					<cfloop from="1" to="3" index="i">
						<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
						tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
						quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
						consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
						cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
						proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<p>	
					</cfloop>
				
					<p><center><b>#lsDateFormat(now(), "dddd, dd/mmmm/yyyy")#</b></center></p>
				</cfoutput>
				--->
			</cfdocument>
			
			<cffile action="readBinary" 
				file="#response.pathPdf#" 
				variable="binaryData">

			<cfset response["pdf"] = toBase64(binaryData)>
			
			<cfset response["contrato"] = qQuery.CB262_NR_CONTRA>
			<cfset response["parcelas"] = qQuery.CB262_QT_PARC>
			<cfset response["rQuery"] = rQuery>
			<cfset response["success"] = true>
						
			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["message"] = 'Erro ao se comunicar com o servidor'>
				<cfset response["cfcatch"] = cfcatch>
				<cfreturn SerializeJSON(response)>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="emailCliente" access="remote" returnType="String" httpMethod="POST" restPath="/clienteEmail">
        <cfargument name="body" type="String">
       
        <cfset body = DeserializeJSON(ARGUMENTS.body)>
	    <cfset now = now()>

	    <cfset response = structNew()>
		<cfset response["ARGUMENTS"] = body>

		<cftry>	

		    <cfset anexo = "Boleto.pdf">
			<cfset protocolo = "00100000002" & LSDateFormat(now(), "YYMMDD") & LSTimeFormat(now(), "HHmmss") & right(CreateUUID(), 7)>

			<!--- 
			Recuperar as últimas parcelas geradas.
			Está considerando as parcelas da CB210 e não CB263 a pedido de Paulo Almeida.
			--->
			<cfquery datasource="seeaway_sql" name="qBoleto">			
				SELECT
					TOP #body.parcelas#
					CB210_DT_VCTO
					,CB850_IM_PDF
				FROM
					CB210


				INNER JOIN CB850
				ON CB850_NR_PROTOC = CB210_NR_PROTOC

				WHERE
					CB210_NR_CONTRA = <cfqueryparam cfsqltype="cf_sql_char" value="#body.contrato#">
				AND CB210_DT_VCTO > #lsDateFormat(now(), "YYYYMMDD")#
				ORDER BY
					CB210_DT_INCSIS DESC				
			</cfquery>

			
			<cfquery datasource	="seeaway_sql">
				INSERT INTO 
				  dbo.CB850
				(
				  CB850_NR_PROTOC,
				  CB850_IM_PDF,
				  CB850_CD_OPESIS,
				  CB850_DT_INCSIS,
				  CB850_DT_ATUSIS
				) 
				VALUES (
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#protocolo#">,
				  <cfqueryparam cfsqltype="cf_sql_blob" value="#qBoleto.CB850_IM_PDF[qBoleto.recordCount]#">,
				  -1,
				  GETDATE(),
				  GETDATE()
				);
			</cfquery>

			<cfquery datasource	="seeaway_sql" name="qOperacao">
				SELECT
					CB262_NR_OPGENY
				FROM
					CB262
				WHERE
					CB262_NR_OPERADOR = 903
				AND CB262_NR_CEDENTE = 913
				AND CB262_NR_CONTRA = <cfqueryparam cfsqltype="cf_sql_char" value="#body.contrato#">
			</cfquery>

		    <cfstoredproc 	
				datasource	="seeaway_sql" 
				procedure	="SP_WS_EMAIL" 
				returncode	="false">
							
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_VRS" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="1" 
								/>

				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_INST" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="903" 
								/>

				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_CD_EMIEMP" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="913" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_ENVIO" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_CD_CAMPAN" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_CAMPAN" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_CLIENT" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_ADESAO" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>				
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_CANCEL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_PACOTE" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_DDI" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="55" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_DDD" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#body.DadosMensagem.DDD#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_TEL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#body.DadosMensagem.TELEFONE#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_TEL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="2" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_ORG" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_LOGO" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DS_EMAIL" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosMensagem.EMAIL#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_CARTAO" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_CPF" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosMensagem.CPF#" 
								/>	
													
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_CD_CODEMAIL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_MIN" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_FATURA" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_VENCCM" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>					
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_DIAATR" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_MELDIA" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_FINCAT" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>				
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_DTHORA" 
								cfsqltype	="CF_SQL_TIMESTAMP"
								value		="#now#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_AUTZ" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_LIMITE" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>	
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_TOTCAT" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>					
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_HR_RECB" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0"
								/>				
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_NIVERT" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_NIVERA" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_ABERTU" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/> 	
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_ATRASO" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>	
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_CANCEL" 
								cfsqltype	="CF_SQL_CHAR"
								value		="" 
								/>				
					
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_NOME" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosEmail.NOME#" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_BARCOD" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#qOperacao.CB262_NR_OPGENY#" 
								/>				
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_ESTABE" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_ID_IMG" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#protocolo#" 
								/>

				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_ANEXO" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#anexo#" 
								/>

				<cfprocresult name="qQuery">
				
			</cfstoredproc>
			
			<cfset response["success"] = true>
						
			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["message"] = 'Erro ao se comunicar com o servidor'>
				<cfset response["cfcatch"] = cfcatch>
				<cfreturn SerializeJSON(response)>
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getOperacao" access="remote" returnType="String" httpMethod="GET" restPath="/operacao">

	    <cfset response = structNew()>
		<cfset response["URL"] = URL>

		<cftry>

			<cfquery datasource="seeaway_sql" name="qQuery">
				SELECT
					TOP 1
					CB262_NM_CLIENT
					,CB262_NR_CPFCNPJ
					,CB262_NR_DDD
					,CB262_NR_TEL
					,CB262_NM_EMAIL

				FROM
					CB262

				WHERE
					CB262_NR_OPERADOR = <cfqueryparam cfsqltype="cf_sql_numeric" value="903">
				AND CB262_NR_CEDENTE = <cfqueryparam cfsqltype="cf_sql_numeric" value="913">
				AND CB262_NR_OPGENY = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.codigo#">				

			</cfquery>	

		    			
			<cfset response["success"] = true>			
			<cfset response["cliente"] = structNew()>
			<cfset response["cliente"]["nome"] = trim(qQuery.CB262_NM_CLIENT)>
			<cfset response["cliente"]["cpf"] = qQuery.CB262_NR_CPFCNPJ>
			<cfset response["cliente"]["ddd"] = qQuery.CB262_NR_DDD>
			<cfset response["cliente"]["celular"] = qQuery.CB262_NR_TEL>
			<cfset response["cliente"]["email"] = trim(qQuery.CB262_NM_EMAIL)>
			
						
			<cfreturn SerializeJSON(response["cliente"])>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["message"] = 'Erro ao se comunicar com o servidor'>
				<cfset response["cfcatch"] = cfcatch>
				<cfreturn SerializeJSON(response)>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="email" access="remote" returnType="String" httpMethod="POST" restPath="/sendEmail">
        <cfargument name="body" type="String">
       
        <cfset body = DeserializeJSON(ARGUMENTS.body)>
	    <cfset now = now()>

	    <cfset response = structNew()>
		<cfset response["ARGUMENTS"] = body>
		
		<cftry>	

			<cfset anexo = "">
			<cfset protocolo = "">

			<cfif isDefined("body.DadosMensagem.anexo.nome") AND body.DadosMensagem.anexo.nome NEQ "">
				<cfset anexo = body.DadosMensagem.anexo.nome>
				<cfset protocolo = "00100000002" & LSDateFormat(now(), "YYMMDD") & LSTimeFormat(now(), "HHmmss") & right(CreateUUID(), 7)>
				
				<cfset binaryData = toBinary(body.DadosMensagem.anexo.base64)>

				<cfquery datasource	="seeaway_sql">
					INSERT INTO 
					  dbo.CB850
					(
					  CB850_NR_PROTOC,
					  CB850_IM_PDF,
					  CB850_CD_OPESIS,
					  CB850_DT_INCSIS,
					  CB850_DT_ATUSIS
					) 
					VALUES (
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#protocolo#">,
					  <cfqueryparam cfsqltype="cf_sql_blob" value="#binaryData#">,
					  -1,
					  GETDATE(),
					  GETDATE()
					);
				</cfquery>
			</cfif>

		    <cfstoredproc 	
				datasource	="seeaway_sql" 
				procedure	="SP_WS_EMAIL" 
				returncode	="false">
							
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_VRS" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="1" 
								/>

				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_INST" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="903" 
								/>

				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_CD_EMIEMP" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="913" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_ENVIO" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_CD_CAMPAN" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_CAMPAN" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_CLIENT" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_ADESAO" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>				
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_CANCEL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_PACOTE" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_DDI" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="55" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_DDD" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#body.DadosMensagem.DDD#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_TEL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#body.DadosMensagem.TELEFONE#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_TEL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="2" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_ORG" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_LOGO" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="1" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DS_EMAIL" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosMensagem.Email#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_CARTAO" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_CPF" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosMensagem.CPF#" 
								/>	
													
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_CD_CODEMAIL" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#body.DadosEmail.CodigoEmail#" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_MIN" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_FATURA" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_VENCCM" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
								/>					
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_DIAATR" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_MELDIA" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NR_FINCAT" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>				
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_DTHORA" 
								cfsqltype	="CF_SQL_TIMESTAMP"
								value		="#now#" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_AUTZ" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_LIMITE" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>	
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_TOTCAT" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>					
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_HR_RECB" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0"
								/>				
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_NIVERT" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_NIVERA" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_DT_ABERTU" 
								cfsqltype	="CF_SQL_NUMERIC"
								value		="0" 
								/> 	
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_VL_ATRASO" 
								cfsqltype	="CF_SQL_FLOAT"
								value		="0" 
								/>	
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_TP_CANCEL" 
								cfsqltype	="CF_SQL_CHAR"
								value		="" 
								/>				
					
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_NOME" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosEmail.NOME#" 
								/>
								
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_BARCOD" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#body.DadosEmail.BarCode#" 
								/>				
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_ESTABE" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="" 
								/>
				
				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_ID_IMG" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#protocolo#" 
								/>

				<cfprocparam 	type		="in" 
								dbvarname	="@ENT_NM_ANEXO" 
								cfsqltype	="CF_SQL_VARCHAR"
								value		="#anexo#" 
								/>

				<cfprocresult name="qQuery">
				
			</cfstoredproc>
			
			<cfset response["success"] = true>
						
			<cfreturn SerializeJSON(response)>

			<cfcatch>			
				<cfset response["success"] = false>
				<cfset response["message"] = 'Erro ao se comunicar com o servidor'>
				<cfset response["cfcatch"] = cfcatch>
				<cfreturn SerializeJSON(response)>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="sms" access="remote" returnType="String" httpMethod="POST" restPath="/sendSms">
        <cfargument name="body" type="String">
       
        <cfset body = DeserializeJSON(ARGUMENTS.body)>
	    <cfset now = now()>

	    <cfset response = structNew()>
		<cfset response["ARGUMENTS"] = body>
		
		<cftry>	

			<cfstoredproc 	
					datasource	="seeaway_sql" 
					procedure	="SP_WS_SMS" 
					returncode	="false">
								
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_VRS" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="1" 
									/>

					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_INST" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="903" 
									/>

					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_CD_EMIEMP" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="913" 
									/>

					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_BROKER" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
												
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_ENVIO" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_CD_CAMPAN" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_TP_CAMPAN" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_TP_CLIENT" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_ADESAO" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
									/>				
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_CANCEL" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_PACOTE" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_DDI" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="55" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_DDD" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#body.DadosMensagem.DDD#" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_TEL" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#body.DadosMensagem.TELEFONE#" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_TP_TEL" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="2" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_ORG" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_LOGO" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="1" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_CONTA" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_CARTAO" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_CPF" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="#body.DadosMensagem.CPF#" 
									/>	
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_EMAIL" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="#body.DadosMensagem.Email#" 
									/>	
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_CD_CODSMS" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#body.DadosSms.CodigoSms#" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_VL_MIN" 
									cfsqltype	="CF_SQL_FLOAT"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_VL_FATURA" 
									cfsqltype	="CF_SQL_FLOAT"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_VENCCM" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="#lsDateTimeFormat(now, 'yyyymmdd')#" 
									/>					
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_DIAATR" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_MELDIA" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NR_FINCAT" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="0" 
									/>				
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_DTHORA" 
									cfsqltype	="CF_SQL_TIMESTAMP"
									value		="#now#" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_VL_AUTZ" 
									cfsqltype	="CF_SQL_FLOAT"
									value		="0" 
									/>
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_VL_LIMITE" 
									cfsqltype	="CF_SQL_FLOAT"
									value		="0" 
									/>	
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_VL_TOTCAT" 
									cfsqltype	="CF_SQL_FLOAT"
									value		="0" 
									/>					
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_HR_RECB" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="0"
									/>				
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_NIVERT" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_NIVERA" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="0" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_DT_ABERTU" 
									cfsqltype	="CF_SQL_NUMERIC"
									value		="0" 
									/> 	
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_VL_ATRASO" 
									cfsqltype	="CF_SQL_FLOAT"
									value		="0" 
									/>	
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_TP_CANCEL" 
									cfsqltype	="CF_SQL_CHAR"
									value		="" 
									/>				
						
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_NOME" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="#body.DadosSMS.NOME#" 
									/>
									
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_BARCOD" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="#trim(body.DadosSMS.BARCODE)#" 
									/>				
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_ESTABE" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_MOEDA" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="0"
									maxlength   ="3" 
									/>
					
					<cfprocparam 	type		="in" 
									dbvarname	="@ENT_NM_PAIS" 
									cfsqltype	="CF_SQL_VARCHAR"
									value		="0"
									maxlength   ="3" 
									/>
																							
				<cfprocresult name="qQuery">
					
			</cfstoredproc>
			
			<cfset response["success"] = true>
						
			<cfreturn SerializeJSON(response)>

			<cfcatch>
				<cfset response["success"] = false>
				<cfset response["message"] = 'Erro ao se comunicar com o servidor'>
				<cfset response["cfcatch"] = cfcatch>
				<cfreturn SerializeJSON(response)>
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>
