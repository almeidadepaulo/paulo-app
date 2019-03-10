<cfcomponent rest="true" restPath="collect/2via">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="segundaViaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['2via'])>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB210_2VIA
                WHERE
                    1 = 1

				AND CB210_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB210_NR_CPFCNPJ") AND url.CB210_NR_CPFCNPJ NEQ "">
					AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#NumberFormat(url.CB210_NR_CPFCNPJ, '00000000000000')#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB210_NR_CONTRA") AND url.CB210_NR_CONTRA NEQ "">
					AND	CB210_NR_CONTRA = <cfqueryparam value = "#url.CB210_NR_CONTRA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.CB210_DT_VCTO") AND url.CB210_DT_VCTO NEQ "">
					<cfset url.CB210_DT_VCTO = ISOToDateTime(url.CB210_DT_VCTO)>
					<cfset url.CB210_DT_VCTO = DateFormat(url.CB210_DT_VCTO , "YYYYMMDD")>
					AND	CB210_DT_VCTO = <cfqueryparam value = "#url.CB210_DT_VCTO#" CFSQLType = "CF_SQL_NUMERIC">
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
					,CB210_NR_DIAATR
					,CB210_ID_SITPAG
  	  				,CB210_ID_SITPAG_LABEL
					,CB201_NM_EMAIL 

				FROM
					VW_CB210_2VIA
				WHERE
					1 = 1

				AND CB210_NR_OPERADOR = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_CEDENTE = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB210_NR_CPFCNPJ") AND url.CB210_NR_CPFCNPJ NEQ "">
					AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#NumberFormat(url.CB210_NR_CPFCNPJ, '00000000000000')#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  
			
				<cfif IsDefined("url.CB210_NR_CONTRA") AND url.CB210_NR_CONTRA NEQ "">
					AND	CB210_NR_CONTRA = <cfqueryparam value = "#url.CB210_NR_CONTRA#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.CB210_DT_VCTO") AND url.CB210_DT_VCTO NEQ "">
					AND	CB210_DT_VCTO = <cfqueryparam value = "#url.CB210_DT_VCTO#" CFSQLType = "CF_SQL_NUMERIC">
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
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<cffunction name="getById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB210_NR_OPERADOR}/{CB210_NR_CEDENTE}/{CB210_CD_COMPSC}/{CB210_NR_AGENC}/{CB210_NR_CONTA}/{CB210_NR_NOSNUM}/{CB210_NR_CPFCNPJ}/{CB210_NR_PROTOC}"> 

		<cfargument name="CB210_NR_OPERADOR" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_CEDENTE" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_CD_COMPSC" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_AGENC" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_CONTA" restargsource="Path" type="numeric"/>
		<cfargument name="CB210_NR_NOSNUM" restargsource="Path" type="string"/>
		<cfargument name="CB210_NR_CPFCNPJ" restargsource="Path" type="string"/>
		<cfargument name="CB210_NR_PROTOC" restargsource="Path" type="string"/>
		
		<cfset checkAuthentication(state = ['2via'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 CB210_NR_OPERADOR
				    ,CB210_NR_CEDENTE
					,CB210_NR_CONTRA 
      				,CB210_NR_CPFCNPJ
      				,CB210_DT_VCTO   
      				,CB210_VL_VALOR  	  
  	  				,CB210_ID_SITPAG 
      				,CB203_DT_EMISS  
	  				,CB203_DT_VCTOT  
	  				,CB203_VL_TITULO 
	  				,CB203_VL_JURMOR 
	  				,VL_TOTAL 
      				,CB201_NM_NMSAC  
      				,CB201_NM_END    
      				,CB201_NR_END    
      				,CB201_DS_COMPL  
      				,CB201_NM_BAIRRO 
      				,CB201_NM_CIDADE 
      				,CB201_SG_ESTADO 
      				,CB201_NR_CEP    
      				,CB201_NR_DDD    
      				,CB201_NR_TEL    
      				,CB201_NR_CEL    
      				,CB201_NM_EMAIL  
      				,CB255_DS_PROD 
					,CB210_NR_DIAATR
					,CB210_ID_SITPAG
					,CB210_ID_SITPAG_LABEL    
				FROM
					VW_CB210_2VIA 
				WHERE
				    CB210_NR_OPERADOR = <cfqueryparam value = "#arguments.CB210_NR_OPERADOR#" CFSQLType = "CF_SQL_NUMERIC">
				AND	CB210_NR_CEDENTE = <cfqueryparam value = "#arguments.CB210_NR_CEDENTE#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_CD_COMPSC = <cfqueryparam value = "#arguments.CB210_CD_COMPSC#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_AGENC = <cfqueryparam value = "#arguments.CB210_NR_AGENC#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_CONTA = <cfqueryparam value = "#arguments.CB210_NR_CONTA#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB210_NR_NOSNUM = <cfqueryparam value = "#arguments.CB210_NR_NOSNUM#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB210_NR_CPFCNPJ = <cfqueryparam value = "#arguments.CB210_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
				AND	CB210_NR_PROTOC = <cfqueryparam value = "#arguments.CB210_NR_PROTOC#" CFSQLType = "CF_SQL_VARCHAR">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

		<cfreturn new lib.JsonSerializer().serialize(response)>

    </cffunction>

	<cffunction name="segundaViaPdf" access="remote" returnType="String" httpMethod="POST" restpath="/pdf">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['segundaVia'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>		
		 	

			<!--- <cfset response["destination"] = pdf(arguments.body.items).destination> --->
			<cfset response["message"] = "">
            <cfset response["base64"] = pdf(arguments.body.items).base64>			
			<cfset response["success"] = true>			

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

	<cffunction name="segundaViaPdfEmail" access="remote" returnType="String" httpMethod="POST" restpath="/pdf-email">

		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['segundaVia'])>
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
		<cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "../../../_server/collect/segundaVia/" & guid>
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
				subject="[PAN] segundaVias"
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
		<cfset responsePdf["message"] = 'E-mail enviado com sucesso!'>

		<cfreturn responsePdf>

	</cffunction>	
</cfcomponent>