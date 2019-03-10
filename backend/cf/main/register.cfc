<cfcomponent rest="true" restPath="register">  	
	<cfinclude template="../util.cfm">

	<cffunction name="registerCreate" access="remote" returnType="String" httpMethod="POST">
		
		<cfset form.body = DeserializeJSON(form.body)>

		<cfset response = structNew()>		
		<cfset response["form"] = form>

		<cftry>
			<cfset guid = CreateUUID()>	
			<cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "/../../../_server/register/files" & guid>
			<cfset log = destination & '/log'>
			<cfset now = LSDateFormat(now(), 'YYYYMM') & '_' & LSTimeFormat(now(), 'HHmmss')>
			<cfif not directoryExists(destination)>
				<cfdirectory action="create" directory="#destination#" />		
			</cfif>
			<cfif not directoryExists(log)>
				<cfdirectory action="create" directory="#log#" />		
			</cfif>

			<cffile action="upload" 
				filefield="rg" 
				destination="#destination#" 
				nameconflict="overwrite"
				accept="*" />

			<cftransaction>

				<cfquery datasource="#application.datasource#" result="queryResult">
					INSERT INTO 
						dbo.CL001
					(
						CL001_NR_INST
						,CL001_TP_PESSOA
						,CL001_NR_CPFCNPJ
						,CL001_NM_CLIENT
						,CL001_NM_CLIENTR
						,CL001_NM_END
						,CL001_NR_END
						,CL001_DS_COMPL
						,CL001_NM_BAIRRO
						,CL001_NM_CIDADE
						,CL001_SG_ESTADO
						,CL001_CD_PAIS
						,CL001_NR_CEP
						,CL001_NR_CXPOST
						<cfif IsDefined("form.body.CL001_NR_TEL") AND IsNumeric(form.body.CL001_NR_TEL)>
							,CL001_NR_TEL
						</cfif>
						,CL001_NR_CEL
						,CL001_NR_FAX
						,CL001_NM_EMAIL
						,CL001_NM_URL
						,CL001_DT_ABERT
						,CL001_DT_ENCER
						,CL001_DS_OBSERV
						,CL001_CD_OPESIS
						,CL001_DT_INCSIS
						,CL001_DT_ATUSIS
					) 
					VALUES (						
						212 <!--- HARD-CODE --->
						,<cfqueryparam value = "#form.body.CL001_TP_PESSOA#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#form.body.CL001_NR_CPFCNPJ#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#form.body.CL001_NM_CLIENT#" CFSQLType = "CF_SQL_VARCHAR">
						<cfif form.body.CL001_TP_PESSOA EQ "F">
							<!--- PRIMEIRO NOME --->
							,<cfqueryparam value = "#ListToArray(form.body.CL001_NM_CLIENT, ' ')[1]#" CFSQLType = "CF_SQL_VARCHAR">
						<cfelse>
							,<cfqueryparam value = "#form.body.CL001_NM_CLIENTR#" CFSQLType = "CF_SQL_VARCHAR">
						</cfif>
						,<cfqueryparam value = "#form.body.CL001_NM_END#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#form.body.CL001_NR_END#" CFSQLType = "CF_SQL_NUMERIC">
						,<cfqueryparam value = "#form.body.CL001_NM_COMPL#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#form.body.CL001_NM_BAIRRO#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#form.body.CL001_NM_CIDADE#" CFSQLType = "CF_SQL_VARCHAR">
						,<cfqueryparam value = "#form.body.CL001_SG_ESTADO#" CFSQLType = "CF_SQL_VARCHAR">
						,1
						,<cfqueryparam value = "#form.body.CL001_NR_CEP#" CFSQLType = "CF_SQL_CHAR">						
						,''
						<cfif IsDefined("form.body.CL001_NR_TEL") AND IsNumeric(form.body.CL001_NR_TEL)>
							,<cfqueryparam value = "#form.body.CL001_NR_TEL#" CFSQLType = "CF_SQL_NUMERIC">
						</cfif>
						,<cfqueryparam value = "#form.body.CL001_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">
						,NULL
						,<cfqueryparam value = "#form.body.CL001_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">
						,''
						,<cfqueryparam value = "#LSDateFormat(now(), 'YYYYMMDD')#" CFSQLType = "CF_SQL_NUMERIC">
						,0
						,''
						,-1
						,GETDATE()
						,GETDATE()
					);
				</cfquery>

				<!--- DADOS COMPLEMENTARES --->
				<!---
				<cfif form.body.CL001_TP_PESSOA EQ "F">
					<cfquery datasource="#application.datasource#">

					</cfquery>
				<cfelse>
				
				</cfif>
				--->

				<!--- PROPOSTA --->
				<cfquery datasource="#application.datasource#">
					INSERT INTO 
						dbo.CL100
					(
						CL100_NR_INST
						,CL100_NR_CLIENT						
						,CL100_ID_SITUAC
						,CL100_ID_INTSTA
						,CL100_DT_PROP
						,CL100_DT_APROV
						,CL100_DT_CANCEL
						,CL100_CD_OPESIS
						,CL100_DT_INCSIS
						,CL100_DT_ATUSIS
					) 
					VALUES (
						212 <!--- HARD-CODE --->
						,<cfqueryparam value = "#queryResult.IDENTITYCOL#" CFSQLType = "CF_SQL_BIGINT">			
						,1
						,0
						,#LSDateFormat(now(), "YYYYMMDD")#
						,0
						,0
						,-1
						,GETDATE()
						,GETDATE()
					);
				</cfquery>

			</cftransaction>	

			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>			
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>
</cfcomponent>