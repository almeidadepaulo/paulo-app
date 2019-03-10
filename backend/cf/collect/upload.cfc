<cfcomponent rest="true" restPath="collect/upload">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="fake" access="remote" returntype="String" httpmethod="POST"> 

		<cfset checkAuthentication(state = ['updownload'])>
		<!--- <cfset cedenteValidate()> --->
        
		<cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "/../../../_server/collect/upload">
		<cfset log = destination & '/log'>
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