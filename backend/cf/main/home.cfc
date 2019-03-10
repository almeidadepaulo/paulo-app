<cfcomponent rest="true" restPath="home">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="home" access="remote" returntype="String" httpmethod="GET" restpath="/menu"> 

		<cfset checkAuthentication()>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

            <cfset response["session"] = session>

            <!--- <cfif session.perfilDeveloper> --->
                <cfquery datasource="#application.datasource#" name="query">
                    SELECT
                        menu.men_id
                        ,menu.men_idPai
                        ,menu.men_nome
                        ,menu.men_descricao
                        ,menu.men_state
                        ,menu.men_ordem
                        ,menu.pro_id
                    FROM
                        dbo.menu AS menu
                    WHERE
                        pro_id = <cfqueryparam value = "#url.projectId#" CFSQLType = "CF_SQL_INTEGER">
                    AND men_idPai = 0

                    ORDER BY
                        menu.men_ordem
                </cfquery>
            <!---
            <cfelse>
                <cfquery datasource="#application.datasource#" name="query">
                    SELECT
                        acesso.per_id
                        ,acesso.men_id

                        ,menu.men_id
                        ,menu.men_idPai
                        ,menu.men_nome
                        ,menu.men_descricao
                        ,menu.men_state
                        ,menu.men_ordem
                        ,menu.pro_id
                    FROM
                        dbo.acesso AS acesso

                    INNER JOIN dbo.menu AS menu
                    ON menu.men_id = acesso.men_id

                    WHERE                        
                        pro_id = <cfqueryparam value = "#url.projectId#" CFSQLType = "CF_SQL_INTEGER">
                    AND per_id = <cfqueryparam value = "#session.perfilId#" CFSQLType = "CF_SQL_BIGINT">
                    AND men_idPai = 0

                    ORDER BY
                        menu.men_ordem
                </cfquery>
            </cfif>
            --->

            <cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>

    <cffunction name="getChildren" access="remote" returntype="String" httpmethod="GET" 
		restpath="menu/{id}/menu"> 

        <cfargument name="id" restargsource="Path" type="numeric"/>

		<cfset checkAuthentication()>
        
		<cfset response = structNew()>
		
        <cfset response["arguments"] = arguments>
		<cfset response["params"] = url>

		<cftry>

            <cfset response["session"] = session>

            <!--- <cfif session.perfilDeveloper> --->
                <cfquery datasource="#application.datasource#" name="query">
                    SELECT
                        menu.men_id
                        ,menu.men_idPai
                        ,menu.men_nome
                        ,menu.men_descricao
                        ,menu.men_state
                        ,menu.men_ordem
                        ,menu.pro_id
                        ,menu.men_zone
                    FROM
                        dbo.menu AS menu
                    WHERE
                        pro_id = <cfqueryparam value = "#url.projectId#" CFSQLType = "CF_SQL_INTEGER">
                    AND men_idPai = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_INTEGER">
                    AND men_ativo = 1

                    <cfif not session.perfilDeveloper>
                        <cfif session.perfilTipo eq 1>
                            AND men_admin = 1
                        <cfelseif session.perfilTipo eq 2>
                            AND men_backoffice = 1
                        <cfelse>
                            AND men_cedente = 1
                        </cfif>   
                    </cfif> 
                    
                    ORDER BY
                        menu.men_ordem
                </cfquery>
            
            <!--- 
            <cfelse>
                <cfquery datasource="#application.datasource#" name="query">
                    SELECT
                        acesso.per_id
                        ,acesso.men_id

                        ,menu.men_id
                        ,menu.men_idPai
                        ,menu.men_nome
                        ,menu.men_descricao
                        ,menu.men_state
                        ,menu.men_ordem
                        ,menu.pro_id
                        ,menu.men_zone
                    FROM
                        dbo.acesso AS acesso

                    INNER JOIN dbo.menu AS menu
                    ON menu.men_id = acesso.men_id

                    WHERE                        
                        pro_id = <cfqueryparam value = "#url.projectId#" CFSQLType = "CF_SQL_INTEGER">
                    AND per_id = <cfqueryparam value = "#session.perfilId#" CFSQLType = "CF_SQL_BIGINT">
                    AND men_idPai = <cfqueryparam value = "#arguments.id#" CFSQLType = "CF_SQL_INTEGER">
                    AND men_ativo = 1

                    ORDER BY
                        menu.men_ordem
                </cfquery>
            </cfif>
            --->

            <cfset response["query"] = queryToArray(query)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn SerializeJSON(response)>
    </cffunction>
</cfcomponent>