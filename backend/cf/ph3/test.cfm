<!--- REST --->

<cfset data = structNew()>
<cfset data["UserName"] = "christian.ribas">
<cfset data["Password"] = "Ph0@2017">

<cfdump var="#SerializeJSON(data)#">

<cfhttp url="http://wsrest.databusca.com.br/DataRest.svc/Login" 
    method="post"
    result="response">

    <cfhttpparam type="header" name="Content-Type" value="application/json">
    <cfhttpparam type="body" value="#SerializeJSON(data)#">

</cfhttp>

<cfdump var="#response#">

<cfif response.Responseheader.Status_Code EQ "200">
    <cfdump var="#DeserializeJSON(response.Filecontent)#">
</cfif>


<cfabort>

<!--- ws --->
<cfset args = StructNew()> 
<cfset args.user = {UserName: "christian.ribas", Password: "Ph0@2017"}> 

<cfinvoke   webservice="https://ws.databusca.com.br/DataHistory.svc?wsdl"
            method="Login"
            argumentCollection="#args#"            
            returnvariable="response"
            />

<cfdump var="#args#" label="args">
<br/><br/> Login ph3: <cfdump var="#response.getToken()#" label="Login">

<cfset args = StructNew()> 
<cfset args = {token: response.getToken(), document: "39145592845"}> 

<cfdump var="#args#" label="args">
<cfinvoke   webservice="https://ws.databusca.com.br/DataHistory.svc?wsdl"
            method="GetCollectionScore"
            argumentCollection="#args#"            
            returnvariable="response2"
            >

    <cfinvokeargument name="token" value="#response.getToken()#">
    <cfinvokeargument name="document" value="39145592845">
</cfinvoke>
<br/><br/> GetPersonData ph3: <cfdump var="#response2#" label="GetPersonData">

<cfabort>

<!---
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:ph3a="http://schemas.datacontract.org/2004/07/PH3A.Viper.Web.PortalService.Models">
    <soapenv:Header/>
    <soapenv:Body>
        <tem:Login>
            <!--Optional:-->
            <tem:user>
                <!--Optional:-->
                <!--Optional:-->
                <ph3a:DomainId>1</ph3a:DomainId>
                <ph3a:Password>Ph0@2017</ph3a:Password>
                <!--Optional:-->
                <ph3a:UserName>christian.ribas</ph3a:UserName>
            </tem:user>
        </tem:Login>
    </soapenv:Body>
</soapenv:Envelope>
--->