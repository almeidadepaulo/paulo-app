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
<cftry>
	<!--- Configurações SMTP --->
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

		
		<cfdump var="#URL#" label="URL">
		<cfdump var="#file#" label="file">

	</cfmail>

    <cfreturn>

	<cffile action="upload" 
		filefield="file" 
		destination="#destination#" 
		nameconflict="overwrite"
		accept="*" />
		<!--- accept="application/x-zip-compressed, application/zip, multipart/x-zip, application/x-rar-compressed, application/rar, multipart/rar" --->

	<!--- Armazenar que o upload do arquivo foi executado com sucesso --->
	<cfset fileUpload = true>
		
	<!---
	<cfif file.SERVERFILEEXT EQ 'rar' OR file.SERVERFILEEXT EQ 'zip' OR file.SERVERFILEEXT EQ '7z'>
		<cfzip action="unzip" file="#destination#\#file.SERVERFILE#" destination="#destination#" />
	</cfif>
	--->
	<!---
	<cfdocument filename="#destination#\upload-debug_#now#.pdf" format="PDF"> 	
		<cfdump var="#SESSION#" label="SESSION">
	   	<cfdump var="#URL#" label="URL">
	   	<cfdump var="#FORM#" label="FORM">
		<cfdump var="#file#" label="file">		
		<cfoutput>
			#destination#\#file.SERVERFILE#
		</cfoutput>
	</cfdocument>
 	--->
		
	<!--- Insert log de upload (sucesso) --->
	<cfset responseLog = setLog(id = 0, status = 1, erro = -1)>

	<cfcatch>
		<cfdocument filename="#destination#\upload-error_#now#.pdf" format="PDF"> 	
		    <cfdump var="#FORM#" label="FORM">
		    destination: <cfdump var="#destination#">
		    <cfdump var="#cfcatch#" label="cfcatch">
		</cfdocument>
		<!---
		<cfmail from="#variables.cfg_smtp_username#"
			type="html"
			to="weslei.freitas@seeaway.com.br"					
			subject="upload ok"
	    	server="#variables.cfg_smtp_server#"
	    	username="#variables.cfg_smtp_username#" 
			password="#variables.cfg_smtp_password#"
			port="#variables.cfg_smtp_port#"		
			>

			<cfdump var="#URL#">
			<cfdump var="#cfcatch#">

		</cfmail>
		--->
	</cfcatch>
</cftry>

<!---
<cfif fileUpload>
	<cffile action="delete"	file="#destination#\#file.SERVERFILE#" />
</cfif>
--->

<cffunction name="setLog" access="private" returntype="Any">
	<cfargument name="id" type="numeric" required="true">
	<cfargument name="status" type="numeric" required="true">
	<cfargument name="erro" type="numeric" required="true" hint="-1 = sem erro">	

	<cfset result = structNew()>

	<cfreturn result>

	<cfif ARGUMENTS.id EQ 0>
		<cfquery datasource="#FORM.DSN#" result="rQuery">
			INSERT INTO 
				dbo.MG805
			(
				MG805_NR_INST,
  				MG805_CD_EMIEMP,
  				MG805_NR_OPERAC,
				MG805_NM_ARQ,
				MG805_DT_PROC,
				MG805_HR_PROC,
				MG805_ID_STATUS,
				MG805_ID_ERRO,
				MG805_CD_OPESIS,
				MG805_DT_INCSIS,
				MG805_DT_ATUSIS
			) 
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.grupo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.cedente#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.operacao#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FLOWFILENAME#">,				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LSDateFormat(now(), 'YYYYMMDD')#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LSTimeFormat(now(), 'HHmm')#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.status#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.erro#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#SESSION.userId#">,
				GETDATE(),
				GETDATE()
			);
		</cfquery>

		<cfset result["id"] = rQuery.IDENTITYCOL>
	<cfelse>
		<cfquery datasource="#FORM.DSN#" result="rQuery">
			UPDATE 
				dbo.MG805 
			SET			
				MG805_DT_PROC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSDateFormat(now(), 'YYYYMMDD')#">,
				MG805_HR_PROC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LSTimeFormat(now(), 'HHmm')#">,
				MG805_ID_STATUS = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.status#">,
				MG805_ID_ERRO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.erro#">,
				MG805_DT_ATUSIS = GETDATE()			
			WHERE
				MG805_NR_GERAC = <cfqueryparam cfsqltype="cf_sql_bigint" value="#ARGUMENTS.id#">		
		</cfquery>	
	</cfif>

	<cfreturn result>

</cffunction>