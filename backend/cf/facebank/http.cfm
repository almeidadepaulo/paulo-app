<cfdump var="#CGI#" label="CGI" expand="false">
<cfhttp 
	url="http://#CGI.HTTP_HOST#/rest/facebank/credito-simulacao/cliente" 
	method="get" 
	result="res">
	<cfhttpparam type="body" value="postExample">
</cfhttp>

<cfdump var="#res#">