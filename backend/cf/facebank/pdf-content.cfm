<style>
	table {
		width: 100%;	
		border-spacing: 0px;
		font-size: 11px;
	}
	p {
		font-size: 11px;
	}
	table td {
		border-spacing: 0px;
	    /*border-top: thin solid;*/
	    border-bottom: thin solid;
	    white-space: nowrap;
	}
	td .center{
		width: 100%;
		text-align: right;
	}
</style>

<cfset SetLocale("Portuguese (Brazilian)")>
<cfoutput>

<table class="table">
	<tr>
		<td colspan="4">
			<font size="3px"><b>CÉDULA DE CRÉDITO BANCÁRIO - CCB - PESSOA FÍSICA</b></font>
		</td>
		<td colspan="2" align="right">			
			<font size="3px"><b>Nº #response.operacao#</b></font>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<center><b>Via Negociável do Banco</b></center>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<b>I - Partes</b>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<b>1 - Credor</b>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			Nome
			<br><b>FACEBANK FINANCIAMENTOS S/A</b>
		</td>
		<td style="border-left: thin solid;" colspan="3">
			CNPJ
			<br><b>99.999.999/0009-99</b>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			Endereço - Sede
			<br><b>AVENIDA QUEIROZ FILHO, 1700 - TORRE A, CJ 504/504, VL LEOPOLDINA</b>
		</td>
		<td style="border-left: thin solid;" colspan="2">
			Cidade
			<br><b>SÃO PAULO</b>
		</td>
		<td style="border-left: thin solid;">
			UF
			<br><b>SP</b>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<b>2 - Emitente</b>
		</td>
		<tr>
			<td colspan="5">
				Nome
				<br><b>#uCase(body.cliente.nome)#</b>
			</td>
			<td style="border-left: thin solid;">
				<!--- Teste somente com pessoa física --->
				CPF			
				<br><b>#mid(body.cliente.cpf,1,3)#.#mid(body.cliente.cpf,4,3)#.#mid(body.cliente.cpf,7,3)#-#mid(body.cliente.cpf,10,2)#.</b>
			</td>		
		</tr>
		<tr>
			<td>
				Doc. Identificação
				<br><b>#mid(body.cliente.cpf,1,2)#.#mid(body.cliente.cpf,3,3)#.#mid(body.cliente.cpf,6,3)#-#mid(body.cliente.cpf,9,2)#</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Nacionalidade
				<br><b>BRASILEIRO</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Estado Civil
				<br><b>SOLTEIRO</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Função
				<br><b>PADEIRO</b>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				Endereço Residencial
				<br><b>#uCase(body.cliente.logradouro)#</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Número
				<br><b>#uCase(body.cliente.logradouroNumero)#</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Complemento
				<br>&nbsp;			
			</td>				
		</tr>
		<tr>
			<td>
				Bairro
				<br><b>#uCase(body.cliente.bairro)#</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Cidade
				<br><b>#uCase(body.cliente.municipio)#</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				UF
				<br><b>#uCase(body.cliente.uf)#</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				CEP
				<br><b>#mid(body.cliente.cep,1,6)#-#mid(body.cliente.cep,7,3)#</b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				E-MAIL
				<br><b>#lCase(body.cliente.email)#</b>
			</td>
			<td style="border-left: thin solid; width: 25%" colspan="2">
				Telefone Celular
				<br><b>(#mid(body.cliente.celular,1,2)#) #mid(body.cliente.celular,3,5)#-#mid(body.cliente.celular,8,4)#</b>
			</td>	
			<td style="border-left: thin solid; width: 25%" colspan="2">
				Telefone Residencial
				<br>&nbsp;
			</td>	
		</tr>
		<tr>
			<td colspan="6">
				<b>II - Descrição do Bem ou Relação Anexa</b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Marca
				<br><b>#uCase(qQuery.CB264_NM_FABRIC)#</b>
			</td>			
			<td style="border-left: thin solid;" colspan="2">
				Modelo
				<br><b>#uCase(qQuery.CB264_NM_MODEL)#</b>
			</td>			
			<td style="border-left: thin solid;" colspan="1">
				Versão
				<br>&nbsp;
			</td>	
			<td style="border-left: thin solid;" colspan="1">
				Ano do Modelo
				<br><b>2000</b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Ano de Fabricação
				<br><b>2016</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Chassi
				<br><b>#uCase(qQuery.CB264_NR_CHASSI)#</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Combustível
				<br><b>FLEX</b>
			</td>	
		</tr>
		<tr>
			<td colspan="2">
				Cor
				<br><b>PRATA</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Renavam
				<br><b>#uCase(qQuery.CB264_NR_RENAVAM)#</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Placa
				<br><b>#uCase(qQuery.CB264_NR_PLACA)#</b>
			</td>	
		</tr>
		<tr>
			<td colspan="6">
				<b>III - Descrição do Bem ou Relação Anexa</b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Valor do Bem
				<br><b>R$ 5.000,00</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Valor de Entrada
				<br><b>R$ 1.000,00</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Valor Liberado
				<br><b>R$ 4.000,00</b>
			</td>	
		</tr>
		<tr>
			<td colspan="2">
				Seguros
				<br><b>R$ 0,00</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Nº da Cotação
				<br><b>123456</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Valor Acessórios do Bem
				<br><b>R$ 0,00</b>
			</td>	
		</tr>
		<tr>
			<td colspan="2">
				Serviços
				<br><b>R$ 0,00</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Registro
				<br><b>R$ 0,00</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Valor da Tarifa de Cadastro
				<br><b>R$ 600,00</b>
			</td>	
		</tr>
		<tr>
			<td colspan="2">
				Valor Tarifa Avaliação
				<br><b>R$ 0,00</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Valor do IOF
				<br><b>R$ 200,00</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Valor Total Devido Contratação
				<br><b>R$ 4.800,00</b>
			</td>	
		</tr>
		<tr>
			<td colspan="6">
				<b>IV - Características do Pagamento</b>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Carência para 1º Vencimento
				<br><b>0</b>
			</td>
			<td style="border-left: thin solid;" colspan="2">
				Prazo da Operação
				<br><b>#qQuery.CB262_QT_PARC# MESES</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Valor da Parcela
				<br><b>#LSCurrencyFormat(qQuery.CB262_VL_PARC)#</b>
			</td>	
		</tr>
		<tr>
			<td colspan="1">
				Nº Parcela Intermediária
				<br><b>0</b>
			</td>
			<td style="border-left: thin solid;" colspan="3">
				Valor Parcela Intermediária
				<br><b>R$ 0,00</b>
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Quantidade de Parcelas
				<br><b>#qQuery.CB262_QT_PARC#</b>
			</td>	
		</tr>
		<tr>
			<td colspan="1">
				Praça de Pagamento
				<br><b>FLORESTA</b>
			</td>
			<td style="border-left: thin solid;" colspan="3">
				Periodicidade de Pagamento
				<br>&nbsp;
			</td>	
			<td style="border-left: thin solid;" colspan="2">
				Forma de Pagamento
				<p><b>Carnê ( X ) &nbsp;&nbsp;&nbsp;Débito Automático (&nbsp;&nbsp;&nbsp;)</b></p>
			</td>	
		</tr>		
</table>
<table>
	<tr>
		<td colspan="1">
			Banco
			<br><b>CAIXA ECONÔMICA FEDERAL</b>
		</td>
		<td style="border-left: thin solid;" colspan="1">
			Agência
			<br><b>#uCase(qQuery.CB262_NR_AGENC)#</b>
		</td>	
		<td style="border-left: thin solid;" colspan="1">
			Dígito
			<br><b>0</b>
		</td>	
		<td style="border-left: thin solid;" colspan="1">
			Conta Corrente
			<br><b>#uCase(qQuery.CB262_NR_CONTA)#</b>
		</td>
		<td style="border-left: thin solid;" colspan="1">
			Dígito
			<br><b>0</b>
		</td>
	</tr>	
</table>

<cfdocumentitem 
    type = "pagebreak" 
    evalAtPrint = "true">
</cfdocumentitem> 

<table class="table">
	<tr>
		<td colspan="5">
			<b>CÉDULA DE CRÉDITO BANCÁRIO - CCB - PESSOA FÍSICA</b>
		</td>
		<td>
			Nº 99999999
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<center><b>Via Negociável do Banco</b></center>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<b>
			<p>Exigível pela Quantia de: #LSCurrencyFormat(qQuery.CB262_VL_FINAM)#</p>
			<p>(#uCase(valorExtenso(qQuery.CB262_VL_FINAM))#)</p>
			</b>
		</td>
	</tr>
</table>
<br>
<p>
	Pagarei ao Facebank Financiamentos S.A., CNPJ 99.999.999/0009-99, doravante denominado Credor, ou a sua ordem, por esta Cédula de Crédito Bancário (CCB), a quantia acima, acrescida dos encargos adiante mencionados observadas as condições deste título, que eu declaro ter lido e concordado.									
</p>
<p>
A presente CCB corresponde ao financiamento para aquisição de bem(ns) de consumo, indicado(s) no (Quadro Resumo) desta CCB, tendo sido a quantia declarada acima liberada na conta corrente bancária do fornecedor;								</p>
<p>	
Todas as especificações apresentadas no Quadro Resumo, mesmo que não mencionadas na parte escrita desta CCB, constituem elementos objetivos que conferem existência válida à dívida, compreendendo o principal e todos os seus acessórios e, para assegurar o seu pagamento no vencimento, o próprio bem adquirido com o produto do financiamento está sendo conferido em garantia de alienação fiduciária.									
</p>
<p>
<b>Confidencialidade</b>
"Esse documento é um modelo criado pela <b>SEEAWAY</b> para uso exclusivo em demontrações dos produtos e serviços da Suite Smart Bank, e não possui valor algum.
</p>
<p>
Solicitamos que este, não seja divulgado a terceiros nem reproduzido, em parte ou em sua totalidade, incluindo seus anexos, por quaisquer meios, sem a autorização formal da <b>SEEAWAY</b>, visto que o conteúdo aqui contido é resultado da junção do capital intelectual do nosso grupo de colaboradores e sócios com a expertise corporativa compartilhada através de nossas plataformas de gestão do conhecimento."									
</p>

<br><br>

<table>

<font size="2px">
<b>Emitente</b>
<br><br>
<div>

______________________________________________________
<br>Nome: #uCase(body.cliente.nome)#
<br>CPF:

<br><br><br><br>
<b>Avalista</b>
<br><br>
______________________________________________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;______________________________________________________

<br>Nome:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nome:
<br>CPF:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CPF:

<br>
<center>
	<br>Central de Atendimento Seeaway: 11 3080-6970									
	<br>contato@seeaway.com.br  |  www.seeaway.com.br									
	<br>Obrigado pela oportunidade! Juntos, podemos fazer coisas incríveis!
</center>
</font>

</cfoutput>

<cffunction name="valorExtenso" access="private" returntype="String">
	<cfargument name="value" type="numeric" required="true">
	
	<cfset singular = ListToArray("centavo,real,mil,milhão,bilhão,trilhão,quatrilhão")>
	<cfset plural	= ListToArray("centavos,reais,mil,milhões,bilhões,trilhões,quatrilhões")>

	<cfset c	= ListToArray("!,cem,duzentos,trezentos,quatrocentos,quinhentos,seiscentos,setecentos,oitocentos,novecentos")>
	<cfset c[1] = "">
	<cfset d	= ListToArray("!,dez,vinte,trinta,quarenta,cinquenta,sessenta,setenta,oitenta,noventa")>
	<cfset d[1]	= "">
	<cfset d10	= ListToArray("dez,onze,doze,treze,quatorze,quinze,dezesseis,dezessete,dezoito,dezenove")>
	<cfset u	= ListToArray("!,um,dois,três,quatro,cinco,seis,sete,oito,nove")>
	<cfset u[1]	= "">

	<cfset z=0>
	<cfset valstr = NumberFormat(ARGUMENTS.value, ",0.00")>
	<cfset valstr = Replace(valstr, ",", ".", "ALL")>
	<cfset valarr = ListToArray(valstr, ".")>

	<cfset rt="">
	<cfset fim=ArrayLen(valarr) - IIF(valarr[ArrayLen(valarr)] GT 0, DE("0"), DE("1"))>
		
    <cfloop index="ct" from="1" to="#ArrayLen(valarr)#">
		<cfset valor=NumberFormat(valarr[ct], "000")>
		<cfset digitos=ArrayNew(1)>
		<cfset digitos[1]=Left(valor, 1)>
		<cfset digitos[2]=Mid(valor, 2, 1)>
		<cfset digitos[3]=Right(valor, 1)>
		<cfset rc=IIF(valor GT 100 AND valor LT 200, DE("cento"), "c[digitos[1]+1]")>
		<cfset rd=IIF(digitos[2] LT 2, DE(""), "d[digitos[2]+1]")>
		<cfif valor GT 0>
			<cfset ru=IIF(digitos[2] EQ 1, "d10[digitos[3]+1]", "u[digitos[3]+1]")>
		<cfelse>
			<cfset ru="">
		</cfif>
		
		<cfset r=rc>
			<cfif rc NEQ "" AND (rd NEQ "" OR ru NEQ "")>
				<cfset r=r & " e ">
			</cfif>
		<cfset r=r & rd>
		<cfif rd NEQ "" and ru NEQ "">
			<cfset r=r & " e ">
		</cfif>
		
		<cfset r=r & ru>
		<cfset t=ArrayLen(valarr)-ct>
        
		<cfif r NEQ "">
			<cfset r=r & " ">
				<cfif valor GT 1>
					<cfset r=r & plural[t+1]>
				<cfelse>
					<cfset r=r & singular[t+1]>
				</cfif>
		</cfif>

		<cfif valor EQ 0>
			<cfset z=z+1>
		<cfelseif z GT 0>
			<cfset z=z-1>
		</cfif> 
		
		<cfif t EQ 1 and z GT 0 and valarr[1] GT 0>
			<cfif z GT 1>
				<cfset r=r & " de ">
			</cfif>
			<cfset r=r & plural[t+1]>
		</cfif>

		<cfif r NEQ "">
			<cfif ct GT 1 AND ct LTE fim and valarr[1] GT 0 and z LT 1>
				<cfif ct LT fim>
					<cfset rt=rt & ", ">
				<cfelse>
					<cfset rt=rt & " e ">
				</cfif>
			<cfelse>
			<cfset rt=rt & " ">
		</cfif>
		<cfset rt=rt & r>
		</cfif>
	</cfloop>

	<cfreturn rt>
</cffunction>