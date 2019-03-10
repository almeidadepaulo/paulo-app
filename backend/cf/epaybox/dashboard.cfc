<cfcomponent rest="true" restPath="/epaybox/dashboard">  
	<cfinclude template="../util.cfm">
	
	<cffunction name="boletoStatus" access="remote" returntype="String" httpmethod="GET" restPath="/boletoStatus"> 
        
		<cfset response = structNew()>
		
		<cfset response["url"] = session>

        <cfset operador = 903>
        <cfset cedente = 913>
        <cfset arguments.cpf = NumberFormat(session.cpf , "00000000000000")>

        <cfquery datasource="#application.datasource#" name="query">        
            DECLARE 
                @DT_ATUAL          NUMERIC(8),
                @CB210_VL_ABERTO   NUMERIC(16,2),
                @CB210_QT_ABERTO   NUMERIC(10)  ,
                @CB210_VL_PAGO     NUMERIC(16,2),
                @CB210_QT_PAGO     NUMERIC(10)  ,
                @CB210_VL_VCTO     NUMERIC(16,2),
                @CB210_QT_VCTO     NUMERIC(10)  


                /* BUSCA A DATA ATUAL */
                SELECT @DT_ATUAL = CONVERT(NUMERIC, CONVERT(VARCHAR, GETDATE(), 112))

                /* EM ABERTO */
                SELECT
                @CB210_QT_ABERTO = COUNT(*),
                @CB210_VL_ABERTO = ISNULL(SUM(CB210_VL_VALOR), 0) 
                FROM
                CB210
                WHERE
                    CB210_NR_OPERADOR = #operador#
                AND CB210_NR_CEDENTE = #cedente#
                AND CB210_NR_CPFCNPJ = <cfqueryPARAM value = "#arguments.cpf#" CFSQLType = 'CF_SQL_VARCHAR'>  
                AND CB210_ID_SITPAG = 2

                /* PAGO */
                SELECT
                @CB210_QT_PAGO = COUNT(*),
                @CB210_VL_PAGO = ISNULL(SUM(CB210_VL_VALOR), 0) 
                FROM
                CB210
                WHERE
                    CB210_NR_OPERADOR = #operador#
                AND CB210_NR_CEDENTE = #cedente#
                AND CB210_NR_CPFCNPJ = <cfqueryPARAM value = "#arguments.cpf#" CFSQLType = 'CF_SQL_VARCHAR'>  
                AND CB210_ID_SITPAG = 1

                /* VENCIDO */
                SELECT
                @CB210_QT_VCTO = COUNT(*),
                @CB210_VL_VCTO = ISNULL(SUM(CB210_VL_VALOR), 0) 
                FROM
                CB210
                WHERE
                    CB210_NR_OPERADOR = #operador#
                AND CB210_NR_CEDENTE = #cedente#
                AND CB210_NR_CPFCNPJ = <cfqueryPARAM value = "#arguments.cpf#" CFSQLType = 'CF_SQL_VARCHAR'>  
                AND CB210_ID_SITPAG = 2
                AND CB210_DT_VCTO < @DT_ATUAL

                --RESULT SET
                SELECT
                @CB210_VL_ABERTO CB210_VL_ABERTO,
                @CB210_QT_ABERTO CB210_QT_ABERTO,
                @CB210_VL_PAGO   CB210_VL_PAGO  , 
                @CB210_QT_PAGO   CB210_QT_PAGO  ,
                @CB210_VL_VCTO   CB210_VL_VCTO  ,
                @CB210_QT_VCTO   CB210_QT_VCTO
        </cfquery>

        <cfset response["query"] = queryToArray(query)[1]>

		<cfreturn new lib.JsonSerializer().serialize(response)>
    </cffunction>


</cfcomponent>
