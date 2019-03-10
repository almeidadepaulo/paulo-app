<cfcomponent rest="true" restPath="ph3a">  
	<cfinclude template="../security.cfm">		
	<cfinclude template="../util.cfm">

    <!--- http://databusca.com.br/login --->

	<cffunction name="getPersonData" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication(state = ['perfil-usuario'])>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>

		<cftry>

            <!--- LOGIN --->
            <cfset data = structNew()>
            <cfset data["UserName"] = "christian.ribas">
            <cfset data["Password"] = "Ph0@2017">

            <cfdump var="#SerializeJSON(data)#">

            <cfhttp url="http://wsrest.databusca.com.br/DataRest.svc/Login" 
                method="post"
                result="result">

                <cfhttpparam type="header" name="Content-Type" value="application/json">
                <cfhttpparam type="body" value="#SerializeJSON(data)#">

            </cfhttp>

            <cfset login = DeserializeJSON(result.Filecontent)>

            <!--- CONSULTA --->
            <cfset data = structNew()>
            <cfset data["Token"] = login.Token>
            <cfset data["Document"] = arguments.body.cpf>

            <cfhttp url="http://wsrest.databusca.com.br/DataRest.svc/GetPersonData" 
                method="post"
                result="result">

                <cfhttpparam type="header" name="Content-Type" value="application/json">
                <cfhttpparam type="body" value="#SerializeJSON(data)#">

            </cfhttp>

            <cfset response["ph3a"] = DeserializeJSON(result.Filecontent)>
			<cfset response["success"] = true>
			<cfset response["message"] = ''>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>			
			</cfcatch>	
		</cftry>
		
		<cfreturn SerializeJSON(response)>
	</cffunction>

</cfcomponent>