<cfcomponent rest="true" restPath="/login">  

    <cfprocessingDirective pageencoding="utf-8">
    <cfset setEncoding("form","utf-8")> 
    
    <cfinclude template="../security.cfm">
	<cfinclude template="../util.cfm">

	<cffunction name="login" access="remote" returnType="String" httpMethod="POST">
		<cfargument name="body" type="String">

		<cfset body = DeserializeJSON(ARGUMENTS.body)>

        <cfset response = structNew()>
		<cfset response["ARGUMENTS"] = body>    

        <cfif not IsDefined("body.setSession")>
            <cfset body.setSession = true>
        </cfif>    

        <cftry>
            <cfquery datasource="#application.datasource#" name="query">
                SELECT 
                *
                ,'' as perfil_cedente
                ,'' as perfil_cedente_query
                FROM 
                    dbo.vw_usuario
                WHERE
                    (usu_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.username#">
                    OR usu_cpf = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.username#">
                    )
                AND (usu_senha = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(body.password, "SHA-512")#">
                OR usu_ativo IN (0,2))
            </cfquery>	
            
            <cfif query.recordCount EQ 1>
                <cfset query.usu_senha = '*'>
                                
                <cfif query.usu_ativo EQ 0>
                    <cfset response["success"] = false>
                    <cfset response["message"] = 'Este usuário está inativo'>
                    <cfreturn SerializeJSON(response)>	
                <cfelseif query.usu_ativo EQ 2>
                    <cfset response["success"] = false>
                    <cfset response["message"] = 'Este usuário está bloqueado'>
                    <cfreturn SerializeJSON(response)>	
                <cfelseif query.usu_recuperarSenha EQ 1>
                    <cfif dateDiff("h", query.usu_recuperarSenhaData, now()) GT 24>
                        <cfset response["success"] = false>
                        <cfset response["message"] = 'A senha temporária expirou!\nVocê pode gerar outra clicando no link "Esqueci minha senha"'>					
                        <cfreturn SerializeJSON(response)>
                    </cfif>
                <cfelseif query.usu_senhaExpira GT 0 AND query.usu_senhaData NEQ "" AND dateDiff("d", query.usu_senhaData, now()) GT query.usu_senhaExpira>									
                    <cfset response["message"] = 'Sua senha expirou'>
                    <cfquery datasource="#application.datasource#">
                        UPDATE
                            dbo.usuario
                        SET
                            usu_mudarSenha = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                        WHERE
                            usu_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#query.usu_id#">
                    </cfquery>

                    <cfset query.usu_mudarSenha = 1>				
                </cfif>		
            <cfelse>			
                <cfquery datasource="#application.datasource#" name="qLogin">
                    SELECT
                        usu_id
                        ,usu_tentativasLogin
                        ,ISNULL(usu_countTentativasLogin,0) AS usu_countTentativasLogin
                    FROM
                        dbo.usuario
                    WHERE 
                        usu_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.username#">
                </cfquery>

                <cfif qLogin.usu_tentativasLogin GT 0>							
                    <cfquery datasource="#application.datasource#">				
                        UPDATE 
                            dbo.usuario 
                        SET 
                            <cfif qLogin.usu_countTentativasLogin GT qLogin.usu_tentativasLogin>
                                usu_countTentativasLogin = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                                ,usu_ativo = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                            <cfelse>
                                usu_countTentativasLogin = <cfqueryparam cfsqltype="cf_sql_integer" value="#qLogin.usu_countTentativasLogin+1#">
                            </cfif>
                            
                        WHERE 
                            usu_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#qLogin.usu_id#">
                    </cfquery>
                </cfif>

                <cfset response["success"] = false>
                <cfset response["message"] = 'Usuário e/ou senha incorreto(s)'>	

                <cfreturn SerializeJSON(response)>
            </cfif>

            <cfif query.usu_senhaData EQ "">
                <cfquery datasource="#application.datasource#">
                    UPDATE
                        dbo.usuario
                    SET
                        usu_senhaData = GETDATE()
                    WHERE
                        usu_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#query.usu_id#">
                </cfquery>
            </cfif>

            <cfquery datasource="#application.datasource#">
                UPDATE
                    dbo.usuario
                SET
                    usu_countTentativasLogin = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    ,usu_ultimoAcesso = GETDATE()
                WHERE
                    usu_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#query.usu_id#">
            </cfquery>

            <!--- perfil_cedente - Start --->            
            <cfquery datasource="#application.datasource#" name="qPerfilCedente">
                SELECT
                    grupo_id                    
                    ,cedente_id                    
                FROM
                    dbo.perfil_cedente
                <!--- <cfif query.per_developer NEQ 1> --->
                    WHERE
                        grupo_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#query.grupo_id#">
                    AND	per_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#query.per_id#">
                <!--- </cfif> --->
                ORDER BY
                    cedente_id
            </cfquery>		
            <cfset perfil_cedente = arrayNew(1)>
            <cfloop query="qPerfilCedente">
                <cfset arrayAppend(perfil_cedente, qPerfilCedente.cedente_id)>
            </cfloop>		
            <cfset query.perfil_cedente = arrayToList(perfil_cedente)>
            <cfset query.perfil_cedente_query = QueryToArray(qPerfilCedente)>	
            <!--- perfil_cedente - End --->

             <!--- acesso - Start --->
             <cfquery datasource="#application.datasource#" name="qAcesso">
                SELECT
                    menu.men_state
                FROM
                    acesso AS acesso

                INNER JOIN menu AS menu
                ON menu.men_id = acesso.men_id

                WHERE
                    per_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#query.per_id#">
            </cfquery>
            <cfset acesso = arrayNew(1)>
            <cfloop query="qAcesso">
                <cfset arrayAppend(acesso, qAcesso.men_state)>
            </cfloop>	
             <!--- acesso - End --->

            <cfif query.usu_mudarSenha EQ 1>
                <cfset response["passwordChange"] = true>
            <cfelseif body.setSession>
                <cflock timeout="20" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">		
                    <cfset session.grupoId = query.grupo_id>
                    <cfset session.perfilId = query.per_id>
                    <cfset session.perfilDeveloper = query.per_developer>
                    <!--- se o perfil for developer, ele também é administrador --->
                    <cfif query.per_developer>
                        <cfset session.perfilAdmin = 1>
                    <cfelse>
                        <cfset session.perfilAdmin = query.per_master>
                    </cfif>                    
                    <cfset session.userId = query.usu_id>
                    <cfset session.userName = body.username>
                    <cfset session.perfilTipo = query.per_tipo>
                    <!--- <cfset session.password = hash(body.password, "SHA-512")> --->
                    <cfset session.authenticated = true>                
                    <cfset session.nome = query.usu_nome>
                    <cfset session.cpf = query.usu_cpf>
                    <cfset session.smsAprovador = query.usu_sms_aprovador>
                    <cfset session.cedenteList = query.perfil_cedente>
                    <cfset session.acesso = arrayToList(acesso)>
                </cflock>
            <cfelse>
                <cfset response["cedenteList"] = query.perfil_cedente>
                <cfset response["perfilDeveloper"] = query.per_developer>   
            </cfif>
                
            <cfset response["success"] = true>
            <cfset response["session"] = SESSION>            
                        
            <cfreturn SerializeJSON(response)>

            <cfcatch>
                <cfset response["success"] = false>
                <cfset response["message"] = 'Erro ao se comunicar com o servidor'>
                <cfset response["cfcatch"] = cfcatch>
                <cfreturn SerializeJSON(response)>
            </cfcatch>
        </cftry>
	</cffunction>
    
    <cffunction name = "authenticated" access ="remote" returntype ="String" httpMethod="GET">

        <cfset response = structNew()>

        <cfif StructKeyExists(session, "authenticated") AND session.authenticated>	
            <cfset response["authenticated"] = true>
            <cfset response["session"] = session>
        <cfelse>    
            <cfset response["authenticated"] = false>
        </cfif>
         
        <cfreturn SerializeJSON(response)>
    </cffunction>


    <cffunction name="redefine" access="remote" returnType="String" httpMethod="POST" restPath="/redefine">
        <cfargument name="body" type="String">

		<cfset body = DeserializeJSON(ARGUMENTS.body)>

        <cfset response = structNew()>

        <cftry>
            <cfquery datasource="#application.datasource#" name="query">
                SELECT
                    usu_id
                FROM
                    dbo.usuario	 
                WHERE
                    usu_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.username#">
                AND usu_senha = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(body.passwordOld, "SHA-512")#">
            </cfquery>
           
            <cfquery datasource="#application.datasource#" name="qQuery" result="queryResult">
                UPDATE
                    dbo.usuario	 
                SET
                    usu_senha = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(body.passwordNew, "SHA-512")#">	  
                    ,usu_mudarSenha = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    ,usu_recuperarSenha = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                    ,usu_senhaData = GETDATE()
                WHERE
                    usu_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#query.usu_id#">
            </cfquery>	
                                             
            <cfset body = SerializeJSON({username: body.username,
                password: body.passwordNew,
                setSession: true})>

                <cfinvoke method="login" 
                    body="#body#"
                    returnVariable="login">

            <cfreturn login>

            <cfcatch>
                <cfset response["success"] = false>
                <cfset response["message"] = 'Erro ao se comunicar com o servidor'>
                <cfset response["cfcatch"] = cfcatch>                
            </cfcatch>

        </cftry>

        <cfreturn SerializeJSON(response)>

    </cffunction>

    <cffunction name="recover" access="remote" returnType="String" httpMethod="POST" restPath="/recover">
        <cfargument name="body" type="String">

		<cfset body = DeserializeJSON(ARGUMENTS.body)>

        <cfset response = structNew()>

        <cftry>
            <cfquery datasource="#application.datasource#" name="qQuery" result="queryResult">
                SELECT 
                    *
                FROM 
                    dbo.usuario
                WHERE
                    usu_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.username#">
                AND (usu_email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#body.email#">
                OR usu_ativo IN (0,2)) -- Usuário inativo, bloqueado)
            </cfquery>	

            <cfif qQuery.recordCount EQ 1>

                <cfif qQuery.usu_ativo NEQ 1>
                    <cfset response["success"] = false>

                    <cfswitch expression="#qQuery.usu_ativo#">
                        <cfcase value="0">
                            <cfset response["message"] = 'Este usuário está inativo'>			
                        </cfcase>
                        <cfcase value="2">
                            <cfset response["message"] = 'Este usuário está bloqueado'>			
                        </cfcase>
                        <cfdefaultcase>
                            <cfset response["message"] = ''>			
                        </cfdefaultcase>
                    </cfswitch>

                    <cfreturn SerializeJSON(response)>					
                </cfif>

                <cfset newPassword = randPassword()>

                <cfquery datasource="#application.datasource#">
                    UPDATE 
                        dbo.usuario  
                    SET 
                        usu_senha 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(variables.newPassword, "SHA-512")#">,
                        usu_recuperarSenha = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
                        usu_recuperarSenhaData = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        usu_mudarSenha = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                    WHERE 
                        usu_id = <cfqueryparam cfsqltype="cf_sql_bigint" value="#qQuery.usu_id#">;
                </cfquery>

                <cfquery name="qSMTP" datasource="#application.datasource#">
                    SELECT TOP 1
                        EM000_NM_SMTP,		<!--- Servidor SMTP --->
                        EM000_NM_USRMAI,	<!--- Login --->		
                        EM000_NR_SENMAI,	<!--- Senha --->
                        EM000_NR_SMTPPO		<!--- Porta --->
                    FROM 
                        EM000
                </cfquery>	
                
                <cfmail from="#qSMTP.EM000_NM_USRMAI#"
                        type="html"
                        to="#body.email#"					
                        subject="[PUBLISH] Recuperação de Senha"
                        server="#qSMTP.EM000_NM_SMTP#"
                        username="#qSMTP.EM000_NM_USRMAI#" 
                        password="#qSMTP.EM000_NR_SENMAI#"
                        port="#qSMTP.EM000_NR_SMTPPO#"
                        useTLS="true"		
                        >

                    <strong>Este é um e-mail automático, por favor não responda.</strong>	
                    <br /><br />
                    Prezado(a) #qQuery.usu_nome#,
                    <br /><br />
                    Foi realizada uma solicitação de recuperação de senha para o login #qQuery.usu_login#.
                    <br /><br />
                    Por favor acesse o sistema utilizando a senha temporária que está disponibilizada ao <strong>final deste e-mail</strong>.
                    <br /><br />
                    Ao acessar o sistema com a senha temporária, será solicitado o registro de uma nova senha.
                    <br /><br />
                    Obs: A senha temporária é válida por 24 Horas.
                    <br /><br />												
                    <br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
                    <br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
                    <br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
                    <br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
                    <cfoutput>
                        #variables.newPassword#
                    </cfoutput>	

                </cfmail>		

                <cfset response["success"] = true>	
                <cfset response["message"] = ''>
                <!--- <cfset response["newPassword"] = newPassword> --->			
            <cfelse>
                <cfset response["success"] = false>	
                <cfset response["message"] = 'Usuário e/ou e-mail incorreto(s)'>
            </cfif>
                    
            <cfset response["qQuery"] = QueryToArray(qQuery)>
                        
            <cfreturn SerializeJSON(response)>

            <cfcatch>
                <cfset response["success"] = false>
                <cfset response["message"] = 'Erro ao se comunicar com o servidor'>
                <cfset response["cfcatch"] = cfcatch>
                <cfreturn SerializeJSON(response)>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="logout" access="remote" returntype="String" httpMethod="POST" restPath="/logout">
        
        <cfset StructClear(session)>
        <cfset response = structNew()>
        <cfset response["sessionClear"] = true>

        <cfreturn SerializeJSON(response)>
    </cffunction>
</cfcomponent>