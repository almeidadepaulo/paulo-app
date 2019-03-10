<cfcomponent output="false">


	<cffunction name="teste" access="remote" returntype="String">
        <cfargument name="nome" type="string" required="false" default="">          
        <cfargument name="numero" type="numeric" required="true">          
    
        <cfreturn "ok #arguments.nome# - #arguments.numero#">
		
	</cffunction>


</cfcomponent>	