<cfcomponent rest="true" restPath="publish/dashboard">  
	<cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="mes" access="remote" returntype="String" httpmethod="GET" restPath="/mes"> 

		<cfset checkAuthentication(state = ['dashboard'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>

			<cfquery datasource="#application.datasource#" name="querySms">
                SELECT
                    SUM(MG004_TT_MENSO) AS QTD
                    ,SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 1, 4) * 1 AS ANO
                    ,SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 5, 2) * 1 AS MES
                FROM 
                    MG004
                WHERE 
                    MG004_DT_MOVTO > 0
                AND SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 1, 4) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ano#">
                GROUP BY
                    SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 1, 4)
                    ,SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 5, 2)
                ORDER BY
                    SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 1, 4)
                    ,SUBSTRING(Cast(MG004_DT_MOVTO as varchar), 5, 2)
            </cfquery>

            <cfquery datasource="#application.datasource#" name="queryEmail">
                SELECT
                    SUM(EM004_TT_MENSO) AS QTD
                    ,SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 1, 4) * 1 AS ANO
                    ,SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 5, 2) * 1 AS MES
                FROM 
                    EM004
                WHERE 
                    EM004_DT_MOVTO > 0
                AND SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 1, 4) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ano#">
                GROUP BY
                    SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 1, 4)
                    ,SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 5, 2)
                ORDER BY
                    SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 1, 4)
                    ,SUBSTRING(Cast(EM004_DT_MOVTO as varchar), 5, 2)
            </cfquery>
		
			<cfset response["querySms"] = queryToArray(querySms)>
			<cfset response["queryEmail"] = queryToArray(queryEmail)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>


    <cffunction name="dia" access="remote" returntype="String" httpmethod="GET" restPath="/dia"> 

		<cfset checkAuthentication(state = ['dashboard'])>
        
		<cfset response = structNew()>
		
		<cfset response["params"] = url>

		<cftry>
            <cfif not IsDefined("url.date")>
                 <cfset url.date = 0>
            <cfelse>
                <cfset url.date = dateFormat(ISOToDateTime(url.date), "YYYYMMDD")>
            </cfif>

			<cfquery datasource="#application.datasource#" name="querySms">
                SELECT
                    TOP 1 <!--- NÃO ESTÁ CONSIDERANDO FILTRO POR EMPRESA POR SE TRATAR DE FAKE --->
                    MG004_TT_MENSO AS QTD
                    ,MG004_DT_MOVTO AS DATA
                FROM 
                    MG004
                WHERE 
                    MG004_DT_MOVTO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.date#">
                GROUP BY
                    MG004_TT_MENSO
                    ,MG004_DT_MOVTO
            </cfquery>

            <cfquery datasource="#application.datasource#" name="queryEmail">
                 SELECT
                    TOP 1 <!--- NÃO ESTÁ CONSIDERANDO FILTRO POR EMPRESA POR SE TRATAR DE FAKE --->
                    EM004_TT_MENSO AS QTD
                    ,EM004_DT_MOVTO AS DATA
                FROM 
                    EM004
                WHERE 
                    EM004_DT_MOVTO = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.date#">
                GROUP BY
                    EM004_TT_MENSO
                    ,EM004_DT_MOVTO
            </cfquery>
		
			<cfset response["querySms"] = queryToArray(querySms)>
			<cfset response["queryEmail"] = queryToArray(queryEmail)>

			<cfcatch>
				<cfset responseError(400, cfcatch.message)>
			</cfcatch>
		</cftry>
		
		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>
</cfcomponent>