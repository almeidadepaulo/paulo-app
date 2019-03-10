<cfcomponent rest="true" restPath="/nuxeo">  

    <cfprocessingDirective pageencoding="utf-8">
    <cfset setEncoding("form","utf-8")> 
    
    <cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

    <cffunction name="token" access="remote" returnType="String" httpMethod="GET" restPath="/token">

        <cfset response = structNew()>

        <cftry>
            <!---
                <cfhttp
                    method="POST"
                    url="http://genesysadm-homol.seeaway.com.br/nuxeo/api/v1/automation/login"
                    username="corban"
                    password="123"
                    result="objGet">

                    <cfhttpparam
                        type="url"
                        name="method"
                        value="Test"
                        />

                </cfhttp>

                <cfdump
                    var="#objGet#"
                    label="CFHttp Response"
                    /> 
            --->

            <cfhttp
                method="GET"
                url="http://genesysadm-homol.seeaway.com.br/nuxeo/authentication/token?applicationName=a&deviceId=#now().getTime()#&deviceDescription=a&permission=rw"
                username="corban"
                password="123"
                result="httpResult">

                <cfhttpparam
                    type="url"
                    name="method"
                    value="Test"
                    />

            </cfhttp>

            <cfset response["token"] = httpResult.Filecontent>
			
			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

</cfcomponent>