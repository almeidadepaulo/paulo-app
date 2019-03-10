<cfcomponent rest="true" restPath="main/protocolo">  
	<cfinclude template="../security.cfm">
    <cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="getBlob" access="remote" returntype="String" httpmethod="GET" restpath="/{id}"> 

		<cfargument name="id" restargsource="Path" type="string"/>		
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    CB850_IM_PDF
                FROM
                    CB850
                WHERE
                    CB850_NR_PROTOC = <cfqueryparam cfsqltype="cf_sql_char" value="#ARGUMENTS.id#">
            </cfquery>
			
			<cfset response["base64"] = toBase64(query.CB850_IM_PDF)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>

    </cffunction>
	
</cfcomponent>