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

User Function INADREP(aParam)

Local cAssunto   := ""
Local _cPara     := ""
Local _cCcopia   := "rogerio.machado@avantlux.com.br"
Local cMailBCC   := ""
Local oProcess  := Nil
Local cArquivo  := "\MODELOS\INADREP.html"
Local aTabelas  := {"SE1","SA1"}
Local cAlias1   := GetNextAlias()						// Pega o proximo Alias Disponivel
Local cLog     	 := ""
Local cDtcorte   := ""
Local cVend		 := ""
Local cRepres    := ""
Local nTotSaldo  := 0
Local _cMascara  := "@E 999,999,999.99"
Local nTeste := ""

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)


Prepare Environment EMPRESA '01' FILIAL '010104'


cDtcorte := Dtos(date()-3)

If Dow(stoD(cDtcorte)) = 1 //Domingo
	cDtcorte := Dtos(date()-5)
ElseIf Dow(stoD(cDtcorte)) = 7 //Sabado
	cDtcorte := Dtos(date()-4)
EndIf

ConOut("Data de corte: " +cDtcorte)


BeginSql alias cAlias1

	SELECT A3_COD AS VEND, A3_NOME AS Representante, A3_EMAIL AS Email, A1_NOME AS Cliente, 
	CASE 
		WHEN E1_FILIAL = '010104' THEN 'SANTA CATARINA - SC'
		WHEN E1_FILIAL = '010103' THEN 'SAO FRANCISCO - BA'
		WHEN E1_FILIAL = '010102' THEN 'PINHAIS'
		WHEN E1_FILIAL = '010101' THEN 'MATRIZ'
	ELSE E1_FILIAL 
	END AS Filial,
    E1_NUM AS Titulo, E1_PARCELA AS Parcela, E1_VENCREA AS Vencimento, E1_VALOR AS Valor, E1_SALDO AS Saldo, A1_CGC AS CNPJ FROM %table:SE1% SE1
	INNER JOIN %table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
	INNER JOIN %table:SA3% SA3 ON A1_VEND = A3_COD AND SA3.%notDel%
	WHERE SE1.%notDel%
	AND E1_SALDO > 0
	AND E1_TIPO IN ('NF')
	AND A3_MSBLQL = '2'
	AND E1_VENCREA <= %exp:cDtcorte%
	AND A3_COD = '000978'
	ORDER BY A3_COD, A1_NOME, E1_FILIAL, E1_NUM, E1_PARCELA

EndSql

ConOut("[INADREP] - Iniciando disparos aos RCs")

(cAlias1)->(DbGoTop())

While (cAlias1)->(!Eof())
	cVend     := (cAlias1)->VEND
	cRepres   := (cAlias1)->Representante
	cAssunto  := "INADIMPLENCIA - " + cRepres
	_cPara    := (cAlias1)->Email
	cTotSaldo := 0
	
	While cVend == (cAlias1)->VEND
		
		oProcess := TWFProcess():New("INADREP","INADREP")
		oProcess:NewTask("Enviando Relacao de Clientes Inadimplentes",cLog)
		oHTML := oProcess:oHTML
		
		aAdd((oHTML:ValByName("aR.cCli")), (cAlias1)->Cliente)
		aAdd((oHTML:ValByName("aR.cCNPJ")), (cAlias1)->CNPJ)
		aAdd((oHTML:ValByName("aR.cFili	")), (cAlias1)->Filial)
		aAdd((oHTML:ValByName("aR.cTit")), (cAlias1)->Titulo)
		aAdd((oHTML:ValByName("aR.cPar")), (cAlias1)->Parcela)
		aAdd((oHTML:ValByName("aR.cVenc")), (cAlias1)->Vencimento)
		aAdd((oHTML:ValByName("aR.cVlr")), (cAlias1)->Valor)
		aAdd((oHTML:ValByName("aR.cSld")), (cAlias1)->Saldo)
		
		nTotSaldo := nTotSaldo + (cAlias1)->Saldo
		
		(cAlias1)->(DbSkip())
		
	End
	
	aAdd((oHTML:ValByName("cTotal")), nTotSaldo)
	
	oProcess:cSubject := cAssunto

	oProcess:USerSiga := "000000"
	oProcess:cTo      := _cPara
	oProcess:cBCC     := _cCcopia

	oProcess:Start()
	oProcess:Finish()
	
	ConOut("[INADREP ENVIADO PARA]: "+ _cPara +", "+ _cCcopia)
End

ConOut("[FINALIZANDO INADREP]")

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
	Local _cCcopia   := "rogerio.machado@avantlux.com.br"
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
		SELECT A1_REGIAO AS Regional, A3_NOME AS Representante, A1_NOME AS Cliente, LTRIM(RTRIM(E1_NUM)) AS Titulo, LTRIM(RTRIM(E1_PARCELA)) AS Parcela, SUM(E1_SALDO) AS Saldo, E1_VENCREA AS Vencimento FROM %table:SE1% SE1
		INNER JOIN %table:SA1% AS SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
		INNER JOIN %table:SA3% AS SA3 ON A1_VEND = A3_COD AND SA3.%notDel%
		WHERE SE1.%notDel%
		AND E1_SALDO > 0
		AND E1_TIPO IN ('NF')
		AND E1_VENCREA <= %exp:cDtcorte%
		GROUP BY A1_REGIAO, A3_NOME, A1_NOME, E1_NUM, E1_PARCELA, E1_VENCREA
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
		cLog += "colspan='6' rowspan='1'><span"
		cLog += "style='font-weight: bold;'><strong>Inadimplência Regional - " + _cRegiao + "</strong></span></td>"
		cLog += "</tr>"
		cLog += "<tr>"
		cLog += "<td><p align='center' class='style1'><strong>Regional</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Representante</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Cliente</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Título/Parcela</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Saldo</strong></p></td>"
		cLog += "<td><p align='center' class='style1'><strong>Vencimento</strong></p></td>"
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
			cLog += "<td>" + CValToChar(StoD(TRD->Vencimento)) + "</td>"
			cLog += "</tr>"		
			DbSkip()
		End

		cLog += "<td  align='center' style='background-color: rgb(191, 225, 214);' colspan='6' rowspan='1'><strong>Total: " + Transform(cTotSaldo, _cMascara) + "</strong></td>"	
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
	
