<cfcomponent rest="true" restPath="teste">  

    <!--- http://localhost:8500/rest/seeaway-app/teste --->
    <cffunction name="teste" access="remote" returntype="String" httpmethod="GET"> 

        <cfset response = StructNew()>
        <cfset response["teste"] = "teste">

        <cfif isDefined("url.erro")>
            <cfthrow errorcode="400"                 
                    detail="Exception occurred while executing the request"
                    message="Database exception"
                    type="Application">
        </cfif>
        
       <cfreturn SerializeJSON(response)>

    </cffunction>
        
</cfcomponent>