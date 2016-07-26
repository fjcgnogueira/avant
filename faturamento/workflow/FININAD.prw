#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INADREP   ³ Autor ³ Rogerio Machado    ³ Data  ³ 22/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-mail de titulos vencidos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INADREP()

Local cLog     	 := ""
Local cFim       := "</body></html>"
Local cAssunto   := ""
Local _cPara     := ""
Local _cCcopia   := ""
Local cDtcorte   := ""
Local cVend		 := ""
Local cRepres    := ""
Local cTotSaldo  := 0
Local _cMascara  := "@E 999,999,999.99"
Local nTeste := ""


Prepare Environment EMPRESA '01' FILIAL '010104'

cDtcorte := Dtos(date()-3)

If Dow(stoD(cDtcorte)) = 1 //Domingo
	cDtcorte := Dtos(date()-5)
ElseIf Dow(stoD(cDtcorte)) = 7 //Sabado
	cDtcorte := Dtos(date()-4)
EndIf

ConOut("Data de corte: " +cDtcorte)


BeginSql alias 'TRC'

	SELECT A3_COD AS VEND, A3_NOME AS Representante, A3_EMAIL AS Email, A1_NOME AS Cliente, 
	CASE 
		WHEN E1_FILIAL = '010104' THEN 'SANTA CATARINA - SC'
		WHEN E1_FILIAL = '010103' THEN 'SÃO FRANCISCO - BA'
		WHEN E1_FILIAL = '010102' THEN 'PINHAIS'
		WHEN E1_FILIAL = '010101' THEN 'MATRIZ'
	ELSE E1_FILIAL 
	END AS Filial,
	 E1_NUM AS Titulo, E1_PARCELA AS Parcela, E1_VENCREA AS Vencimento, E1_SALDO AS Saldo, A1_CGC AS CNPJ FROM %table:SE1% SE1
	INNER JOIN %table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
	INNER JOIN %table:SA3% SA3 ON A1_VEND = A3_COD AND SA3.%notDel%
	WHERE SE1.%notDel%
	AND E1_SALDO > 0
	AND E1_TIPO IN ('NF')
	AND A3_MSBLQL = '2'
	AND E1_VENCREA <= %exp:cDtcorte%
	ORDER BY A3_COD, A3_NOME, A1_NOME, E1_FILIAL, E1_NUM, E1_PARCELA

EndSql

ConOut("Iniciado INADREP()")

TRC->(DbGoTop())

While TRC->(!Eof())
	cVend     := TRC->VEND
	cRepres   := TRC->Representante
	cTotSaldo := 0
	cAssunto  := ""
	_cPara     := ""
	cLog := ""
	cLog += "<html><body>"
	
	cLog += "<span style='color: rgb(1, 0, 0);'></span>"
	cLog += "Caro representante,
	cLog += "<br>"
	cLog += "<br>"
	cLog += "Abaixo segue sua carteira de inadimplentes. Pedimos a gentileza, de entrar em contato o mais breve possível com seus clientes, solicitando os comprovantes de pagamentos e encaminhando a Sede (Cobrança Avant) para efetivação das baixas e liberação do sistema para novos pedidos. "
	cLog += "<br>"
	cLog += "<br>"
	cLog += "Em caso de dúvidas, 0xx11 3355-2222 – marcelino.goncalves@avantlux.com.br - Financeiro / Setor Cobrança."
	cLog += "<br>"
	cLog += "<br>"
	cLog += "<strong>Atenção!! E-mail enviado automaticamente pelo sistema. Utilize os contatos acima para qualquer questionamento. </strong>"
	cLog += "<br>"
	cLog += "<br>"	
	cLog += "<table style='text-align: left; width: 100%;' border='1'"
 	cLog += "cellpadding='2' cellspacing='2'>"
	cLog += "<tbody>"
   	cLog += "<tr align='center'>"
	cLog += "<td style='background-color: rgb(191, 225, 214);'"
	cLog += "colspan='8' rowspan='1'><span"
	cLog += "style='font-weight: bold;'><strong>Relação de Títulos em Aberto</strong></span></td>"
	cLog += "</tr>"
	cLog += "</tbody>"
	cLog += "<span style='color: rgb(1, 0, 0);'>"
	cLog += "</span>"
  	cLog += "<tbody>"
   	cLog += "<tr align='center'>"
   	cLog += "<td style='background-color: rgb(191, 225, 214);'"
 	cLog += "colspan='8' rowspan='1'><span"
 	cLog += "style='font-weight: bold;'><strong>" + cRepres + "</strong></span></td>"
  	cLog += "</tr>"
    
	cLog += "<tr>"
	cLog += "<td><p align='center' class='style1'><strong>Cliente</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Filial</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Título</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Parcela</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Vencimento</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Saldo</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>CNPJ</strong></p></td>"
	cLog += "</tr>"
	While(!Eof('TRC')) .AND. cVend = TRC->VEND
			cLog += "<tr>"
			cLog += "<td>" + CValToChar(TRC->Cliente) + "</td>"
			cLog += "<td>" + CValToChar(TRC->Filial)  + "</td>"
			cLog += "<td>" + CValToChar(TRC->Titulo)  + "</td>"
			cLog += "<td>" + CValToChar(TRC->Parcela) + "</td>"
			cLog += "<td>" + CValToChar(StoD(TRC->Vencimento)) + "</td>"			
			cLog += "<td>" + Transform(TRC->Saldo, _cMascara)  + "</td>"
			cTotSaldo += TRC->Saldo
			cLog += "<td>" + CValToChar(TRC->CNPJ)    + "</td>"
			cLog += "</tr>"
			_cPara := TRC->Email
			//_cPara := " "
			_cCcopia := "rogerio.machado@avantlux.com.br"
			DbSkip()
	End
	cLog += "<td  align='center' style='background-color: rgb(191, 225, 214);' colspan='8' rowspan='1'><strong>Total: " + Transform(cTotSaldo, _cMascara) + "</strong></td>"	
	cLog += "</tbody>
	cLog += "</table>"
	cLog += "<br>"
	cLog += cFim
	cAssunto := "TÍTULOS EM ABERTO - " + cRepres
	U_MHDEnvMail(_cPara, _cCcopia, "", cAssunto, cLog, "")
	ConOut("Enviado para: "+ _cPara +"; "+ _cCcopia)
End

ConOut("Finalizado INADREP()")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INADNAC   ³ Autor ³ Rogerio Machado    ³ Data  ³ 22/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-mail de titulos vencidos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INADNAC()

	Local cLog     	 := ""
	Local cFim       := "</body></html>"
	Local cAssunto   := ""
	Local _cPara     := ""
	Local _cCcopia   := ""
	Local cDtcorte   := ""
	Local cVend		 := ""
	Local cRepres    := ""
	Local cTotSaldo  := 0
	Local _cMascara  := "@E 999,999,999.99"
	
	
	Prepare Environment EMPRESA '01' FILIAL '010104'

	cDtcorte := Dtos(date()-3)
	
	If Dow(stoD(cDtcorte)) = 1 //Domingo
		cDtcorte := Dtos(date()-5)
	ElseIf Dow(stoD(cDtcorte)) = 7 //Sabado
		cDtcorte := Dtos(date()-4)
	EndIf
	
	ConOut("Data de corte: " +cDtcorte)
	
	BeginSql alias 'TRB'
		SELECT A1_REGIAO AS Regional, SUM(E1_SALDO) AS Saldo FROM %table:SE1% SE1
		INNER JOIN SA1010 AS SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
		WHERE SE1.%notDel%
		AND E1_SALDO > 0
		AND E1_TIPO IN ('NF')
		AND E1_VENCREA <= %exp:cDtcorte%
		GROUP BY A1_REGIAO
		ORDER BY Saldo DESC
	EndSql



	TRB->(DbGoTop())

ConOut("Iniciado INADNAC()")

	cLog += "<html><body>"
	cLog += "<span style='color: rgb(1, 0, 0);'></span>"
	cLog += "<table style='text-align: left; width: 100%;' border='1'"
 	cLog += "cellpadding='2' cellspacing='2'>"
	cLog += "<tbody>"
   	cLog += "<tr align='center'>"
	cLog += "<td style='background-color: rgb(191, 225, 214);'"
	cLog += "colspan='2' rowspan='1'><span"
	cLog += "style='font-weight: bold;'><strong>Inadimplência Geral Por Regional</strong></span></td>"
	cLog += "</tr>"
	cLog += "<tr>"
	cLog += "<td><p align='center' class='style1'><strong>Regional</strong></p></td>"
	cLog += "<td><p align='center' class='style1'><strong>Saldo</strong></p></td>"
	cLog += "<tr>"
	
	While TRB->(!Eof())
		cLog += "<td>" + CValToChar(TRB->Regional) + "</td>"	
		cLog += "<td>" + Transform(TRB->Saldo, _cMascara)  + "</td>"
		cTotSaldo += TRB->Saldo
		cLog += "</tr>"		
		DbSkip()
	End

	cLog += "<td  align='center' style='background-color: rgb(191, 225, 214);' colspan='8' rowspan='1'><strong>Total: " + Transform(cTotSaldo, _cMascara) + "</strong></td>"	
	cLog += "</tbody>
	cLog += "</table>"
	cLog += cFim
	cAssunto := "INADIMPLÊNCIA GERAL POR REGIONAL"
	
	_cPara   := ALLTRIM(GETMV("ES_GERENAC"))
	_cCcopia   := "rogerio.machado@avantlux.com.br"
	//_cPara := "rogerio.machado@avantled.com.br"

	
	U_MHDEnvMail(_cPara, _cCcopia, "", cAssunto, cLog, "")
	ConOut("Enviado para: "+ _cPara +"; "+ _cCcopia)
	ConOut("Finalizado INADNAC()")
	

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INADGER   ³ Autor ³ Rogerio Machado    ³ Data  ³ 22/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Envia E-mail de titulos vencidos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function INADGER()

	Local cLog     	 := ""
	Local cFim       := "</body></html>"
	Local cAssunto   := ""
	Local _cPara     := ""
	Local _cCcopia   := ""
	Local cDtcorte   := ""
	Local _cRegiao	 := ""
	Local cRepres    := ""
	Local cTotSaldo  := 0
	Local _cMascara  := "@E 999,999,999.99"
	Local _cString   := AllTrim(GetMv("ES_GERENRE"))
	Local _cMailTo 	 := ""
	
	
	Prepare Environment EMPRESA '01' FILIAL '010104'

	cDtcorte := Dtos(date()-3)
	
	If Dow(stoD(cDtcorte)) = 1 //Domingo
		cDtcorte := Dtos(date()-5)
	ElseIf Dow(stoD(cDtcorte)) = 7 //Sabado
		cDtcorte := Dtos(date()-4)
	EndIf
	
	ConOut("Data de corte: " +cDtcorte)
	
	ConOut("Iniciado INADGER()")
	
	BeginSql alias 'TRD'
		SELECT A1_REGIAO AS Regional, A3_NOME AS Representante, A1_NOME AS Cliente, LTRIM(RTRIM(E1_NUM)) AS Titulo, LTRIM(RTRIM(E1_PARCELA)) AS Parcela, SUM(E1_SALDO) AS Saldo FROM %table:SE1% SE1
		INNER JOIN %table:SA1% AS SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
		INNER JOIN %table:SA3% AS SA3 ON A1_VEND = A3_COD AND SA3.%notDel%
		WHERE SE1.%notDel%
		AND E1_SALDO > 0
		AND E1_TIPO IN ('NF')
		AND E1_VENCREA <= %exp:cDtcorte%
		GROUP BY A1_REGIAO, A3_NOME, A1_NOME, E1_NUM, E1_PARCELA
		ORDER BY Regional, Representante, Cliente, Titulo, Parcela, Saldo DESC
	EndSql
	
	ConOut(GetLastQuery()[2])

	TRD->(DbGoTop())

	_cRegiao := TRD->Regional

	While TRD->(!Eof())
		cAssunto := ""
		_cPara := ""
		cLog := ""
		_cRegiao := TRD->Regional
		cTotSaldo := 0
		cLog += "<html><body>"
		cLog += "<span style='color: rgb(1, 0, 0);'></span>"
		cLog += "<table style='text-align: left; width: 100%;' border='1'"
	 	cLog += "cellpadding='2' cellspacing='2'>"
		cLog += "<tbody>"
	   	cLog += "<tr align='center'>"
		cLog += "<td style='background-color: rgb(191, 225, 214);'"
		cLog += "colspan='5' rowspan='1'><span"
		cLog += "style='font-weight: bold;'><strong>Inadimplência Regional - " + _cRegiao + "</strong></span></td>"
		cLog += "</tr>"
		cLog += "<tr>"
		cLog += "<td><p align='center' class='style1'><strong>Regional</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Representante</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Cliente</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Titulo/Parcela</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Saldo</strong></p></td>"
		cLog += "<tr>"
	
		While(!Eof('TRD')) .AND. _cRegiao = TRD->Regional
			cLog += "<td>" + CValToChar(TRD->Regional) + "</td>"
			cLog += "<td>" + CValToChar(TRD->Representante) + "</td>"
			cLog += "<td>" + CValToChar(TRD->Cliente) + "</td>"
			If TRD->Parcela <> ' '
				cLog += "<td>" + CValToChar(TRD->Titulo) +" - "+ CValToChar(TRD->Parcela)  + "</td>"
			Else
				cLog += "<td>" + CValToChar(TRD->Titulo) + "</td>"
			EndIf
			cLog += "<td>" + Transform(TRD->Saldo, _cMascara)  + "</td>"
			cTotSaldo += TRD->Saldo
			cLog += "</tr>"		
			DbSkip()
		End

		cLog += "<td  align='center' style='background-color: rgb(191, 225, 214);' colspan='5' rowspan='1'><strong>Total: " + Transform(cTotSaldo, _cMascara) + "</strong></td>"	
		cLog += "</tbody>
		cLog += "</table>"
		cLog += cFim
		_cPara := U_SepEmail(_cString,AllTrim(_cRegiao))
		//_cPara   := "rogerio.machado@avantlux.com.br"
		cAssunto := "INADIMPLÊNCIA REGIONAL - " + _cRegiao //+ " - " + AllTrim(_cMailTo)
		
		_cCcopia   := "rogerio.machado@avantlux.com.br"
		
		U_MHDEnvMail(_cPara, _cCcopia, "", cAssunto, cLog, "")
		ConOut("Enviado para: "+ _cPara +"; "+ _cCcopia)
	End

	ConOut("Enviado para: "+ _cPara +"; "+ _cCcopia)
	ConOut("Finalizado INADGER()")	

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SepEmail  ³ Autor ³ Rogerio Machado    ³ Data  ³ 22/12/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SepEmail(_cString,_cRegiao)

Local _cTarget   := _cRegiao + "@"
Local _nDe       := At(_cTarget,_cString)+Len(_cTarget)
Local _nAte      := 6
Local _cVendedor := Substr(_cString,_nDe,_nAte)
Local _cEmail    := Posicione("SA3",1,xFilial("SA3")+_cVendedor,"A3_EMAIL")

Return _cEmail



//RESET ENVIRONMENT
	
