<!--- code starts --->
<cftry>
<cfset restInitApplication(getDirectoryFromPath(getCurrentTemplatePath()),"facebank")>
<cfcatch type="any">
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>
successfull!
<!--- code ends --->