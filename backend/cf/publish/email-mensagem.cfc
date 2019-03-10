<cfcomponent rest="true" restPath="publish/email/mensagem">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="get" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['email-mensagem'])>
        <cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_EM061
                WHERE
                    1 = 1
				AND EM061_NR_INST = 1
				AND EM061_CD_EMIEMP = 1 
                <cfif IsDefined("url.EM061_CD_CODEMAIL") AND url.EM061_CD_CODEMAIL NEQ "">
					AND	EM061_CD_CODEMAIL = <cfqueryparam value = "#url.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM061_DS_TEXTO") AND url.EM061_DS_TEXTO NEQ "">
					AND	EM061_DS_TEXTO = <cfqueryparam value = "#url.EM061_DS_TEXTO#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY EM061_CD_CODEMAIL ASC) AS ROW
					,EM061_NR_INST
					,EM061_CD_EMIEMP
					,EM061_CD_CODEMAIL
					,EM061_DS_TEXTO
					,EM061_ID_ATIVO
					,EM061_ID_STATUS

					,EM055_DS_CODEMAIL
				FROM
					VW_EM061
				WHERE
					1 = 1
				AND EM061_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND EM061_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">
				<cfif IsDefined("url.EM061_CD_CODEMAIL") AND url.EM061_CD_CODEMAIL NEQ "">
					AND	EM061_CD_CODEMAIL = <cfqueryparam value = "#url.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.EM061_DS_TEXTO") AND url.EM061_DS_TEXTO NEQ "">
					AND	EM061_DS_TEXTO = <cfqueryparam value = "#url.EM061_DS_TEXTO#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>  

				ORDER BY
					EM061_CD_CODEMAIL ASC	
                
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
		restpath="/{EM061_NR_INST}/{EM061_CD_EMIEMP}/{EM061_CD_CODEMAIL}"> 

		<cfargument name="EM061_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM061_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="EM061_CD_CODEMAIL" restargsource="Path" type="numeric"/>
		
		<cfset checkAuthentication(state = ['email-mensagem'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
					 EM061_NR_INST
					,EM061_CD_EMIEMP
					,EM061_CD_CODEMAIL
					,EM061_DS_TEXTO
					,EM061_ID_ATIVO
					,EM061_ID_STATUS

					,EM055_DS_CODEMAIL	
				FROM
					VW_EM061
				WHERE
				    EM061_NR_INST = <cfqueryparam value = "#arguments.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM061_CD_EMIEMP = <cfqueryparam value = "#arguments.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	EM061_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="mensagemCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-mensagem'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>
			<!--- create --->
			<cftransaction>							
				<cfquery datasource="#application.datasource#">
					INSERT INTO 
						dbo.EM055
					(
						EM055_NR_INST,
						EM055_CD_EMIEMP,
						EM055_CD_CODEMAIL,
						EM055_DS_CODEMAIL,
						EM055_ID_ATIVO,
						EM055_TP_CATEG,
						EM055_CD_OPESIS,
						EM055_DT_INCSIS,
						EM055_DT_ATUSIS
					) 
					VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.EM055_DS_CODEMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
						1,
						0,
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);
				</cfquery>

				<cfquery datasource="#application.datasource#" name="query">
					INSERT INTO 
						dbo.EM061
					(   
						EM061_NR_INST
						,EM061_CD_EMIEMP
						,EM061_CD_CODEMAIL
						,EM061_DS_TEXTO
						,EM061_ID_ATIVO
						,EM061_ID_STATUS
						,EM061_CD_OPESIS
						,EM061_DT_INCSIS
						,EM061_DT_ATUSIS
					) 
						VALUES (
						<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.EM061_DS_TEXTO#" CFSQLType = "CF_SQL_VARCHAR">,
						<cfqueryparam value = "#arguments.body.EM061_ID_ATIVO#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#arguments.body.EM061_ID_STATUS#" CFSQLType = "CF_SQL_NUMERIC">,
						<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
						GETDATE(),
						GETDATE()
					);
				</cfquery>
			</cftransaction>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, cfcatch.detail)>
					<cfset responseError(400, "Código de mensagem já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="mensagemUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{EM061_NR_INST}/{EM061_CD_EMIEMP}/{EM061_CD_CODEMAIL}">
		
		<cfargument name="EM061_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM061_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="EM061_CD_CODEMAIL" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-mensagem'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cftransaction>
				<cfquery datasource="#application.datasource#">
					UPDATE 
						dbo.EM055  
					SET 										
						EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.body.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
						,EM055_DS_CODEMAIL = <cfqueryparam value = "#arguments.body.EM055_DS_CODEMAIL#" CFSQLType = "CF_SQL_VARCHAR">						
					WHERE 
						EM055_NR_INST = <cfqueryparam value = "#arguments.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM055_CD_EMIEMP = <cfqueryparam value = "#arguments.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>

				<cfquery datasource="#application.datasource#">
					UPDATE 
						dbo.EM061  
					SET 
						EM061_CD_CODEMAIL = <cfqueryparam value = "#arguments.body.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">,
						EM061_DS_TEXTO = <cfqueryparam value = "#arguments.body.EM061_DS_TEXTO#" CFSQLType = "CF_SQL_VARCHAR">,
						EM061_ID_ATIVO = <cfqueryparam value = "#arguments.body.EM061_ID_ATIVO#" CFSQLType = "CF_SQL_VARCHAR">
					WHERE 
						EM061_NR_INST = <cfqueryparam value = "#arguments.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM061_CD_EMIEMP = <cfqueryparam value = "#arguments.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	EM061_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cftransaction>
			
			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de mensagems já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.message)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="mensagemRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['email-mensagem'])>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.EM055 					
					WHERE 
						EM055_NR_INST = <cfqueryparam value = "#i.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM055_CD_EMIEMP = <cfqueryparam value = "#i.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#i.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
					;

					DELETE FROM 
						dbo.EM061 
					WHERE 
						EM061_NR_INST = <cfqueryparam value = "#i.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	EM061_CD_EMIEMP = <cfqueryparam value = "#i.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
					AND	EM061_CD_CODEMAIL = <cfqueryparam value = "#i.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="mensagemRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{EM061_NR_INST}/{EM061_CD_EMIEMP}/{EM061_CD_CODEMAIL}"
		>
		
		<cfargument name="EM061_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="EM061_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="EM061_CD_CODEMAIL" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication(state = ['email-mensagem'])>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.EM055 					
				WHERE 
					EM055_NR_INST = <cfqueryparam value = "#arguments.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM055_CD_EMIEMP = <cfqueryparam value = "#arguments.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	EM055_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
				;

				DELETE FROM 
					dbo.EM061 
				WHERE 
				    EM061_NR_INST = <cfqueryparam value = "#arguments.EM061_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	EM061_CD_EMIEMP = <cfqueryparam value = "#arguments.EM061_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">
				AND	EM061_CD_CODEMAIL = <cfqueryparam value = "#arguments.EM061_CD_CODEMAIL#" CFSQLType = "CF_SQL_NUMERIC">
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="upload" access="remote" returntype="String" httpmethod="POST" restPath="/upload"> 
        
		<cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "\..\..\..\_server\publish\sms-mensagem\upload">
		<cfset log = destination & '\log'>
		<cfset now = LSDateFormat(now(), 'YYYYMM') & '_' & LSTimeFormat(now(), 'HHmmss')>
		<cfif not directoryExists(destination)>
			<cfdirectory action="create" directory="#destination#" />		
		</cfif>
		<cfif not directoryExists(log)>
			<cfdirectory action="create" directory="#log#" />		
		</cfif>
		
        <!---
		<cfset cfg_smtp_server 		= "smtp.seeaway.com.br">
		<cfset cfg_smtp_username 	= "no-reply@seeaway.com.br">
		<cfset cfg_smtp_password 	= "@KOS00IMSTech">
		<cfset cfg_smtp_port 		= 587>	

		<cfmail from="#variables.cfg_smtp_username#"
			type="html"
			to="weslei.freitas@seeaway.com.br"					
			subject="upload ok"
	    	server="#variables.cfg_smtp_server#"
	    	username="#variables.cfg_smtp_username#" 
			password="#variables.cfg_smtp_password#"
			port="#variables.cfg_smtp_port#"		
			>

		
			<cfdump var="#destination#" label="destination">
			<cfdump var="#file#" label="file">

		</cfmail>
        --->
        <!--- 
        Chunking
        http://www.bennadel.com/blog/2585-chunking-file-uploads-with-plupload-and-coldfusion.htm

        <cfset destination = #expandPath('..\..\..\_server\upload')#>
        <cfset log = destination & '\log'>
        <cfset now = LSDateFormat(now(), 'YYYYMM') & '_' & LSTimeFormat(now(), 'HHmmss')>
        <cfif not directoryExists(destination)>
            <cfdirectory action="create" directory="#destination#" />		
        </cfif>
        <cfif not directoryExists(log)>
            <cfdirectory action="create" directory="#log#" />		
        </cfif>
        --->
		<cffile action="upload" 
			filefield="file" 
			destination="#destination#" 
			nameconflict="overwrite"
			accept="*" />

		<cfreturn >
    </cffunction>

</cfcomponent>