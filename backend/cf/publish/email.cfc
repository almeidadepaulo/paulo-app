<cfcomponent rest="true" restPath="publish/email">  
    <cfprocessingDirective pageencoding="utf-8">
    <cfset setEncoding("form","utf-8")> 

	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

    <cffunction name="emailGet" access="remote" returnType="String" httpMethod="GET">
        <cfset checkAuthentication()>
        <cfreturn "Serviço de E-mail - Sistema Publish">
    </cffunction>

	<cffunction name="emailPost" access="remote" returnType="String" httpMethod="POST">			
		<cfargument name="body" type="String">

        <cfset checkAuthentication()>

		<cfset body = DeserializeJSON(arguments.body)>

         <cfset response["arguments"] = arguments>

        <cfquery datasource="#application.datasource#" name="qSMTP">
			SELECT 						
				TOP 1					
				EM000_NM_SMTP
				,EM000_NM_USRMAI
				,EM000_NR_SENMAI
				,EM000_NR_SMTPPO
			FROM 
				dbo.EM000
		</cfquery>

        <cfset response["smtp"] = queryToArray(qSMTP)>

        <cfmail from="#qSMTP.EM000_NM_USRMAI#"
				type="html"
				to="#arguments.body.data[1].mensagem.Email#"
				subject="Teste"
		    	server="#qSMTP.EM000_NM_SMTP#"
		    	username="#qSMTP.EM000_NM_USRMAI#" 
				password="#qSMTP.EM000_NR_SENMAI#"
				port="#qSMTP.EM000_NR_SMTPPO#"		
				useTLS="true"					
				>
				<cfoutput>								
                    #arguments.body.mensagem#
				</cfoutput>	
			</cfmail>
				
		<cfset response["status"] = "ok">            

		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

</cfcomponent>