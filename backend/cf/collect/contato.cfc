<cfcomponent rest="true" restPath="collect/contato">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../cedenteValidate.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="contatoGet" access="remote" returntype="String" httpmethod="GET"> 

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>
			<cfquery datasource="#application.datasource#" name="queryCount">
                SELECT
                    COUNT(*) AS COUNT
                FROM
                   	VW_CB054
               WHERE
					1 = 1

				AND CB054_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB054_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB054_NR_INST") AND url.CB054_NR_INST NEQ "">
					AND	CB054_NR_INST = <cfqueryparam value = "#url.CB054_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB054_NM_CONTA") AND url.CB054_NM_CONTA NEQ "">
					AND	CB054_NM_CONTA LIKE <cfqueryparam value = "%#url.CB054_NM_CONTA#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
            </cfquery>

            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                    *
                FROM
                   	VW_CB054
               WHERE
					1 = 1

				AND CB054_NR_INST = <cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">
				AND CB054_CD_EMIEMP = <cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">

				<cfif IsDefined("url.CB054_NR_INST") AND url.CB054_NR_INST NEQ "">
					AND	CB054_NR_INST = <cfqueryparam value = "#url.CB054_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">
				</cfif>

				<cfif IsDefined("url.CB054_NM_CONTA") AND url.CB054_NM_CONTA NEQ "">
					AND	CB054_NM_CONTA LIKE <cfqueryparam value = "%#url.CB054_NM_CONTA#%" CFSQLType = "CF_SQL_VARCHAR">
				</cfif> 
				ORDER BY
					CB054_NM_CONTA ASC	
                
                <!--- Paginação --->
                OFFSET #URL.page * URL.limit - URL.limit# ROWS
                FETCH NEXT #URL.limit# ROWS ONLY;
            </cfquery>
		
			<cfset response["page"] = URL.page>	
			<cfset response["limit"] = URL.limit>	
			<cfset response["recordCount"] = queryCount.COUNT>
			<cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>

	<cffunction name="contaGetById" access="remote" returntype="String" httpmethod="GET" 
		restpath="/{CB054_NR_INST}/{CB054_CD_EMIEMP}/{CB054_NR_SEQ}"> 

		<cfargument name="CB054_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="CB054_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="CB054_NR_SEQ" restargsource="Path" type="numeric"/>		
		
		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="query">
                SELECT
                    *					
                FROM
                   	VW_CB054
               WHERE
				    CB054_NR_INST = <cfqueryparam value = "#arguments.CB054_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND CB054_CD_EMIEMP = <cfqueryparam value = "#arguments.CB054_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB054_NR_SEQ = <cfqueryparam value = "#arguments.CB054_NR_SEQ#" CFSQLType = "CF_SQL_NUMERIC">
            </cfquery>
			
			<cfset response["query"] = queryToArray(query)>

			<cfreturn new lib.JsonSerializer().serialize(response)>

			<cfcatch>
				<cfset responseError(400, cfcatch.detail)>
			</cfcatch>
		</cftry>

    </cffunction>

	<cffunction name="contatoCreate" access="remote" returnType="String" httpMethod="POST">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- create --->
			<cfquery datasource="#application.datasource#" name="query">
				INSERT INTO 
					dbo.CB054
				(
					CB054_NR_INST,
					CB054_CD_EMIEMP,					
					CB054_NM_CONTA,
					CB054_NM_CARGO,					
					CB054_NR_TEL,	
					<cfif isDefined("arguments.body.CB054_NR_CEL") AND IsNumeric(arguments.body.CB054_NR_CEL)>				
						CB054_NR_CEL,
					</cfif>
					CB054_NM_EMAIL,
					CB054_NR_OPESIS,
					CB054_DT_INCSIS,
					CB054_DT_ATUSIS
				) 
				VALUES (
					<cfqueryparam value = "#header.CEDENTE.GRUPO_ID#" CFSQLType = "CF_SQL_NUMERIC">,	
				  	<cfqueryparam value = "#header.CEDENTE.CEDENTE_ID#" CFSQLType = "CF_SQL_NUMERIC">,					
					<cfqueryparam value = "#arguments.body.CB054_NM_CONTA#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#arguments.body.CB054_NM_CARGO#" CFSQLType = "CF_SQL_VARCHAR">,					
					<cfqueryparam value = "#arguments.body.CB054_NR_TEL#" CFSQLType = "CF_SQL_NUMERIC">,
					<cfif isDefined("arguments.body.CB054_NR_CEL") AND IsNumeric(arguments.body.CB054_NR_CEL)>
						<cfqueryparam value = "#arguments.body.CB054_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">,					
					</cfif>
					<cfqueryparam value = "#arguments.body.CB054_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
					<cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					GETDATE(),
					GETDATE()
				);
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código do contato já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="contatoUpdate" access="remote" returnType="String" httpMethod="PUT" 
		restpath="/{CB054_NR_INST}/{CB054_CD_EMIEMP}/{CB054_NR_SEQ}">
		
		<cfargument name="CB054_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="CB054_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="CB054_NR_SEQ" restargsource="Path" type="numeric"/>
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- update --->
			<cfquery datasource="#application.datasource#">
				UPDATE 
					dbo.CB054
				SET   				    
					CB054_NM_CONTA = <cfqueryparam value = "#arguments.body.CB054_NM_CONTA#" CFSQLType = "CF_SQL_VARCHAR">,
					CB054_NM_CARGO = <cfqueryparam value = "#arguments.body.CB054_NM_CARGO#" CFSQLType = "CF_SQL_VARCHAR">,					
					CB054_NR_TEL = <cfqueryparam value = "#arguments.body.CB054_NR_TEL#" CFSQLType = "CF_SQL_NUMERIC">,					
					<cfif isDefined("arguments.body.CB054_NR_CEL") AND IsNumeric(arguments.body.CB054_NR_CEL)>
						CB054_NR_CEL = <cfqueryparam value = "#arguments.body.CB054_NR_CEL#" CFSQLType = "CF_SQL_NUMERIC">,
					</cfif>
					CB054_NM_EMAIL = <cfqueryparam value = "#arguments.body.CB054_NM_EMAIL#" CFSQLType = "CF_SQL_VARCHAR">,
					CB054_NR_OPESIS = <cfqueryparam value = "#session.userId#" CFSQLType = "CF_SQL_NUMERIC">,
					CB054_DT_ATUSIS = GETDATE()
				WHERE 
					CB054_NR_INST = <cfqueryparam value = "#arguments.CB054_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">	
				AND CB054_CD_EMIEMP = <cfqueryparam value = "#arguments.CB054_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">				
				AND CB054_NR_SEQ = <cfqueryparam value = "#arguments.CB054_NR_SEQ#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfif cfcatch.ErrorCode EQ "23000">
					<cfset responseError(400, "Código de contato já existe")>
				<cfelse>
					<cfset responseError(400, cfcatch.detail)>
				</cfif>				
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="contatoRemove" access="remote" returnType="String" httpMethod="DELETE">		
		<cfargument name="body" type="String">

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset body = DeserializeJSON(arguments.body)>
		
		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
	
		<cftry>
			<!--- remove --->
			<cfloop array="#arguments.body#" index="i">
				<cfquery datasource="#application.datasource#">
					DELETE FROM 
						dbo.CB054 
					WHERE 
					    CB054_NR_INST = <cfqueryparam value = "#i.CB054_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
					AND	CB054_CD_EMIEMP = <cfqueryparam value = "#i.CB054_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">				
					AND	CB054_NR_SEQ = <cfqueryparam value = "#i.CB054_NR_SEQ#" CFSQLType = "CF_SQL_NUMERIC">				
				</cfquery>
			</cfloop>	

			<cfset response["success"] = true>			

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>

	<cffunction name="contatoRemoveById" access="remote" returnType="String" httpMethod="DELETE"
		restpath="/{CB054_NR_INST}/{CB054_CD_EMIEMP}/{CB054_NR_SEQ}"
		>
		
		<cfargument name="CB054_NR_INST" restargsource="Path" type="numeric"/>
		<cfargument name="CB054_CD_EMIEMP" restargsource="Path" type="numeric"/>
		<cfargument name="CB054_NR_SEQ" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication()>
		<cfset cedenteValidate()>

		<cfset response = structNew()>
		<cfset response["arguments"] = arguments>
		
		<cftry>
			<!--- remove by id --->
			<cfquery datasource="#application.datasource#">
				DELETE FROM 
					dbo.CB054
				WHERE 
				    CB054_NR_INST = <cfqueryparam value = "#arguments.CB054_NR_INST#" CFSQLType = "CF_SQL_NUMERIC">			
				AND	CB054_CD_EMIEMP = <cfqueryparam value = "#arguments.CB054_CD_EMIEMP#" CFSQLType = "CF_SQL_NUMERIC">				
				AND	CB054_NR_SEQ = <cfqueryparam value = "#arguments.CB054_NR_SEQ#" CFSQLType = "CF_SQL_NUMERIC">				
			</cfquery>

			<cfset response["success"] = true>
			<cfset response["message"] = 'Ação realizada com sucesso!'>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>	
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
	</cffunction>
</cfcomponent>