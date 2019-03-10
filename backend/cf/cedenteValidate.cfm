<cfprocessingDirective pageencoding="utf-8">
<cfset setEncoding("form","utf-8")> 

<cffunction 
    name       ="cedenteValidate" 
    access     ="public" 
    returntype ="void" 
    output     ="false">
    
    <cftry>
        <cfif IsDefined("authHeader") and authHeader NEQ "">
            <cfset authString = ToString(BinaryDecode(ListLast(authHeader, " "),"Base64")) />

            <cfset body = SerializeJSON({username: GetToken(authString, 1, ":"),
                password: GetToken(authString, 2, ":"),
                setSession: false})>

            <cfinvoke component="main.login" 
                method="login" 
                body="#body#"
                returnVariable="response">

            <cfset response = DeserializeJSON(response)>
        
            <cfif not response.success>
                <cfset responseError(401)>
            <cfelse>
                <cfset perfilDeveloper = response.perfilDeveloper>
                <cfset cedenteList = response.cedenteList>
            </cfif>  

        <cfelseif not IsDefined("session.authenticated") OR not session.authenticated>
            <cfset responseError(401)>
        <cfelse>     
            <cfset perfilDeveloper = session.perfilDeveloper>
            <cfset cedenteList = session.cedenteList>
        </cfif>

        <cfset cedente = GetPageContext().getRequest().getHeader("Cedente")>

         <cfif not IsDefined("cedente") OR cedente EQ "null">        
            <cfset cedente = {CEDENTE_NOME: "Nome",
                GRUPO_ID: session.grupoId,
                PER_ID: session.perfilId,
                CEDENTE_ID: 0}>
        <cfelse>
            <cfset cedente = DeserializeJSON(GetPageContext().getRequest().getHeader("Cedente"))>
        </cfif>
                                
        <cfcatch>
            <cfset responseError(417, cfcatch.message)>
        </cfcatch>
    </cftry>

    <cfset cedente.GRUPO_ID = session.grupoId>
    <cfset header = {cedente: cedente}>

    <cfreturn />
    <cfif not perfilDeveloper AND not ListContains(cedenteList, cedente.CEDENTE_ID) AND cedente.CEDENTE_ID NEQ 0>
        <cfset responseError(401, "Cedente inválido para o usuário")>
    </cfif>
    
</cffunction>