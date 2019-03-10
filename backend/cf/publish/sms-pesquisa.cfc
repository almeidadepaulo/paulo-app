<cfcomponent rest="true" restPath="publish/sms/pesquisa">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">
	<cfimport  taglib="../lib/tags/poi/" prefix="poi" />

	<cffunction name="pesquisaGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication(state = ['sms-pesquisa'])>
        <cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_MG002
                WHERE
                    1 = 1

				AND MG002_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG002_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG002_NR_CPF") AND url.MG002_NR_CPF NEQ "">
					AND	MG002_NR_CPF = <cfqueryparam value = "#url.MG002_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG002_DT_REMESS") AND url.MG002_DT_REMESS NEQ "">
					<cfset url.MG002_DT_REMESS = ISOToDateTime(url.MG002_DT_REMESS)>
					<cfset url.MG002_DT_REMESS = DateFormat(url.MG002_DT_REMESS, "YYYYMMDD")>
					AND	MG002_DT_REMESS = <cfqueryparam value = "#url.MG002_DT_REMESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_SITUAC") AND isNumeric(url.MG002_ID_SITUAC)>
					AND	MG002_ID_SITUAC = <cfqueryparam value = "#url.MG002_ID_SITUAC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_SITUAC") AND isNumeric(url.MG002_ID_SITUAC)>
					AND	MG002_ID_SITUAC = <cfqueryparam value = "#url.MG002_ID_SITUAC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_STATUS") AND url.MG002_ID_STATUS NEQ "">
					AND	MG002_ID_STATUS = <cfqueryparam value = "#url.MG002_ID_STATUS#" CFSQLType = "CF_SQL_CHAR">
				</cfif> 

				<cfif IsDefined("url.MG002_NR_DDD") AND isNumeric(url.MG002_NR_DDD)>
					AND	MG002_NR_DDD = <cfqueryparam value = "#url.MG002_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_NR_TEL") AND isNumeric(url.MG002_NR_TEL)>
					AND	MG002_NR_TEL = <cfqueryparam value = "#url.MG002_NR_TEL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
				
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
					ROW_NUMBER() OVER(ORDER BY MG002_NR_PROTOC DESC) AS ROW
					,MG002_NR_INST
					,MG002_CD_EMIEMP
					,MG002_NR_CPF
					,MG002_DT_REMESS
					,MG002_CD_CODSMS
					,MG055_DS_CODSMS
					,MG002_NR_DDD
					,MG002_NR_TEL
					,MG002_NR_DDD_TEL
					,MG002_NM_TEXTO
					,MG002_ID_SITUAC
					,MG002_ID_SITUAC_LABEL
					,MG002_ID_STATUS
					,MG002_ID_STATUS_LABEL
				FROM
					VW_MG002
				WHERE
					1 = 1

				AND MG002_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG002_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG002_NR_CPF") AND url.MG002_NR_CPF NEQ "">
					AND	MG002_NR_CPF = <cfqueryparam value = "#url.MG002_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG002_DT_REMESS") AND url.MG002_DT_REMESS NEQ "">					
					AND	MG002_DT_REMESS = <cfqueryparam value = "#url.MG002_DT_REMESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_SITUAC") AND isNumeric(url.MG002_ID_SITUAC)>
					AND	MG002_ID_SITUAC = <cfqueryparam value = "#url.MG002_ID_SITUAC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_SITUAC") AND isNumeric(url.MG002_ID_SITUAC)>
					AND	MG002_ID_SITUAC = <cfqueryparam value = "#url.MG002_ID_SITUAC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_STATUS") AND url.MG002_ID_STATUS NEQ "">
					AND	MG002_ID_STATUS = <cfqueryparam value = "#url.MG002_ID_STATUS#" CFSQLType = "CF_SQL_CHAR">
				</cfif> 

				<cfif IsDefined("url.MG002_NR_DDD") AND isNumeric(url.MG002_NR_DDD)>
					AND	MG002_NR_DDD = <cfqueryparam value = "#url.MG002_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_NR_TEL") AND isNumeric(url.MG002_NR_TEL)>
					AND	MG002_NR_TEL = <cfqueryparam value = "#url.MG002_NR_TEL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 
				
				ORDER BY
					MG002_NR_PROTOC DESC
                
                <!--- Paginação --->
                OFFSET #URL.page * URL.limit - URL.limit# ROWS
                FETCH NEXT #URL.limit# ROWS ONLY;
            </cfquery>
		
			
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<cffunction name="export" access="remote" returntype="String" httpmethod="GET" restPath="/export"> 

		<cfset checkAuthentication(state = ['sms-pesquisa'])>
        <cfset cedenteValidate()>

		<cfset response = structNew()>
		
		<cfset response["params"] = url>
		<cfset response["start"] = now()>

		<cftry>		
			<cfsetting requesttimeout="300">

			<cfset destination = getDirectoryFromPath(getCurrentTemplatePath()) & "\..\..\..\_server\publish\sms-pesquisa\export">
			<cfset log = destination & '\log'>
			<cfset now = LSDateFormat(now(), 'YYYYMM') & '_' & LSTimeFormat(now(), 'HHmmss')>
			<cfif not directoryExists(destination)>
				<cfdirectory action="create" directory="#destination#" />		
			</cfif>
			<cfif not directoryExists(log)>
				<cfdirectory action="create" directory="#log#" />		
			</cfif>

			<cfset guid = CreateUUID()>	
			<cfset fileName = "sms_pesquisa_#guid#.csv">
			<cfset fileNameXls = "sms_pesquisa_#guid#.xlsx">
			<cfset rowsWrite = 1000>

			<cfquery datasource="#application.datasource#" name="query">
				SELECT
					<!--- TOP 100000 --->
					MG002_DT_REMESS
					,MG002_NR_CPF
					,MG055_DS_CODSMS
					,MG002_NR_DDD
					,MG002_NR_TEL
					,MG002_NM_TEXTO
					,MG002_ID_SITUAC_LABEL
					,MG002_ID_STATUS_LABEL
				FROM
					VW_MG002
				WHERE
					1 = 1
				AND MG002_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND MG002_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

                <cfif IsDefined("url.MG002_NR_CPF") AND url.MG002_NR_CPF NEQ "">
					AND	MG002_NR_CPF = <cfqueryparam value = "#url.MG002_NR_CPF#" CFSQLType = "CF_SQL_VARCHAR">
				</cfif>

				<cfif IsDefined("url.MG002_DT_REMESS") AND url.MG002_DT_REMESS NEQ "">
					<cfset url.MG002_DT_REMESS = ISOToDateTime(url.MG002_DT_REMESS)>
					<cfset url.MG002_DT_REMESS = DateFormat(url.MG002_DT_REMESS, "YYYYMMDD")>
					AND	MG002_DT_REMESS = <cfqueryparam value = "#url.MG002_DT_REMESS#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_SITUAC") AND isNumeric(url.MG002_ID_SITUAC)>
					AND	MG002_ID_SITUAC = <cfqueryparam value = "#url.MG002_ID_SITUAC#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_ID_STATUS") AND url.MG002_ID_STATUS NEQ "">
					AND	MG002_ID_STATUS = <cfqueryparam value = "#url.MG002_ID_STATUS#" CFSQLType = "CF_SQL_CHAR">
				</cfif> 

				<cfif IsDefined("url.MG002_NR_DDD") AND isNumeric(url.MG002_NR_DDD)>
					AND	MG002_NR_DDD = <cfqueryparam value = "#url.MG002_NR_DDD#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				<cfif IsDefined("url.MG002_NR_TEL") AND isNumeric(url.MG002_NR_TEL)>
					AND	MG002_NR_TEL = <cfqueryparam value = "#url.MG002_NR_TEL#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif> 

				ORDER BY
					MG002_NR_PROTOC DESC	
            </cfquery>

			<!--- CSV - START --->
			<cfscript>
				// primeira linha
				var rowFile = "Data;";
				rowFile = rowFile & "CPF;";
			 	rowFile = rowFile & "Tipo SMS;";
				rowFile = rowFile & "Telefone;";
				rowFile = rowFile & "Mensagem;";
				rowFile = rowFile & "Status (Publish);";
				rowFile = rowFile & "Status (Broker)";
				//rowFile = rowFile & Chr( 13 ) & Chr( 10 );
			</cfscript>

			<cffile action="write"					
					file="#destination#/#fileName#"
					output="#rowFile#" 
					/>
			
			<!---
				Create a string buffer to hold our output. By writing to
				a string buffer rather than doing CFFile actions for every
				loop iteration we are going to increase our speed greatly.
				Writing to the file system is one of the most costly actions
				you can take in programming. Try to minimize it when
				possible (within reason).
			--->
			<cfset sbOutput = CreateObject(
				"java",
				"java.lang.StringBuffer"
				).Init() />
			
			<cfset count = 0>
			<cfset rowFile = "">
			<cfloop query="query">	
				<cfset count = count + 1>

				<cfscript>
				    rowFile = "";
					rowFile = rowFile
						& mid(query.MG002_DT_REMESS, 7, 2) & "/"
						& mid(query.MG002_DT_REMESS, 5, 2) & "/"
						& mid(query.MG002_DT_REMESS, 1, 4) & ";"; // data

					rowFile = rowFile 
						& mid(query.MG002_NR_CPF, 1 ,3) & "."
						& mid(query.MG002_NR_CPF, 4 ,3) & "."
						& mid(query.MG002_NR_CPF, 7 ,3) & "-"
						& mid(query.MG002_NR_CPF, 10 ,2) & ";"; // cpf

					rowFile = rowFile & query.MG055_DS_CODSMS & ";"; // tipo
					rowFile = rowFile & query.MG002_NR_DDD & MG002_NR_TEL & ";"; // telefone
					rowFile = rowFile & query.MG002_ID_SITUAC_LABEL & ";"; // status (publish)
					rowFile = rowFile & query.MG002_ID_STATUS_LABEL & ";"; // status (broker)	
					rowFile = rowFile & Chr( 13 ) & Chr( 10 );				
				</cfscript>

				<!---
					Instead of outputing the mid-header row to a file,
					let's add it to our string buffer.
				--->
				<cfset sbOutput.Append(
					rowFile
					) />
				
				<cfif count EQ rowsWrite>
					<cfset count = 0>
					<cffile
						action="append"
						file="#destination#/#fileName#"
						output="#sbOutput.ToString()#"
						addNewLine="false"
						/>

					<cfset sbOutput.delete(0, sbOutput.length()) />
					
				</cfif>
			</cfloop>

			<cfif count GT 0>
				<cffile
					action="append"
					file="#destination#/#fileName#"
					output="#sbOutput.ToString()#"
					addNewLine="false"
					/>
			</cfif>
			<!--- CSV - END --->

			<cfset fileZip = "#destination#/#replace(fileName, '.csv', '')#.zip">
			<cfzip source="#destination#/#fileName#"
				action="zip" 
				file="#fileZip#">
			
			<cffile  
				action="readBinary"  
				file="#fileZip#"
				variable="binary">

			<cfset response["base64"] = toBase64(binary)>

			<cffile
				action="delete"
				file="#destination#/#fileName#">
			
			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfset response["end"] = now()>
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<!--- POI XLSX - START --->
	<!---
	<cfloop query="query">	
	
		<cfset query.MG002_DT_REMESS = mid(query.MG002_DT_REMESS, 7, 2) & "/"
			& mid(query.MG002_DT_REMESS, 5, 2) & "/"
			& mid(query.MG002_DT_REMESS, 1, 4)>							

		<cfset query.MG002_NR_CPF = "39145592845">
		<cfset query.MG002_NR_CPF = mid(query.MG002_NR_CPF, 1 ,3) & "."
			& mid(query.MG002_NR_CPF, 4 ,3) & "."
			& mid(query.MG002_NR_CPF, 7 ,3) & "-"
			& mid(query.MG002_NR_CPF, 10 ,2)>
	</cfloop>
	--->

	<!---
	<!--- Create an instance of the POIUtility.cfc. --->
	<cfset objPOI = new lib.POIUtility() />

	<!--- 
		Create a sheet object for this query. This will 
		return a structure with the following keys:
		- Query
		- ColumnList
		- ColumnNames
		- SheetName
	--->
	<cfset objSheet = objPOI.GetNewSheetStruct() />
	
	<!--- Set the query into the sheet. --->
	<cfset objSheet.Query = query />
	
	<!--- 
		Define the order of the columns (and which 
		columns to include).
	--->
	<cfset objSheet.ColumnList = "MG002_DT_REMESS,MG002_NR_CPF,MG055_DS_CODSMS,MG002_NR_DDD,MG002_NR_TEL,MG002_NM_TEXTO,MG002_ID_SITUAC_LABEL,MG002_ID_STATUS_LABEL" />

	<!--- 
		We want to include a header Row in our outputted excel 
		workbook. Therefore, provide header values in the SAME
		order as the column list above.
	--->
	<cfset objSheet.ColumnNames = "Data,CPF,Tipo SMS,DDD,Telefone,Mensagem,Status (Publish),Status (Broker)" />
		
	<!--- Set the sheet name. --->
	<cfset objSheet.SheetName = "SMS" />
		
	<!--- 
		Now, let's write the sheet to a workbook on the file
		sysetm (this will create a NEW file). When doing so, we
		have the option to pass either a single sheet object (as
		we are donig in this example, or an array of sheet 
		objects). We can also define header and row CSS.
	--->
	<cfset objPOI.WriteExcel(
		FilePath = destination & "/" & fileNameXls,
		Sheets = objSheet,
		HeaderCSS = "border-bottom: 2px solid dark_green ;",
		RowCSS = "border-bottom: 1px dotted gray ;"
		) />
	--->
	<!--- POI XLSX - END --->

</cfcomponent>