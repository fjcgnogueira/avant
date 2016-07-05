#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M450TMAN º Autor ³ Fernando Nogueira  º Data ³ 19/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Para Liberacao Manual da Analise de      º±±
±±º          ³ Credito por Cliente                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M450TMAN()
Return CliLib(SA1->A1_COD,SA1->A1_LOJA)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CliLib    º Autor ³ Fernando Nogueira º Data ³ 19/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se o Cliente esta liberado                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CliLib(cCliente,cLoja)

Local cAliasFIS := GetNextAlias()
Local cAliasSC5 := GetNextAlias()
Local lReturn   := .T.

BeginSql alias cAliasFIS

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQFI IN ('S') AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasFIS)->(dbGoTop())

If (cAliasFIS)->(!Eof())
	If MsgNoYes("Cliente tem Pedido com Bloqueio Fiscal"+Chr(13)+Chr(10)+"Voltar Pedido(s) para o Faturamento?")
		Begin Transaction
			VoltaFat(cCliente,cLoja,"FI")
		End Transaction
		Ma450Refr()
	Endif
	lReturn := .F.
Endif

(cAliasFIS)->(dbCloseArea())

BeginSql alias cAliasSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQ IN ('S','C') AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasSC5)->(dbGoTop())

If lReturn .And. (cAliasSC5)->(!Eof())
	If MsgNoYes("Cliente tem Pedido com Bloqueio de Faturamento"+Chr(13)+Chr(10)+"Voltar Pedido(s) para o Faturamento?")
		Begin Transaction
			VoltaFat(cCliente,cLoja,"AV")
		End Transaction
		Ma450Refr()
	Endif
	lReturn := .F.
Endif

(cAliasSC5)->(dbCloseArea())

Return lReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VoltaFat  º Autor ³ Fernando Nogueira º Data ³ 26/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Volta os Pedidos para o Faturamento no Status "C"         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VoltaFat(cCliente,cLoja,cTipo)

Local cVoltaSC5 := GetNextAlias()
Local aAreaSC5  := SC5->(GetArea())
Local aAreaSC9  := SC9->(GetArea())
Local cWhere 	:= "%%"

If cTipo == "FI"
	cWhere := "% AND (C5_X_BLQFI = 'N' OR C5_X_BLQFI = ' ') %"
ElseIf cTipo == "AV"
	cWhere := "% AND (C5_X_BLQ = 'N' OR C5_X_BLQ = ' ') %"
Endif

BeginSql alias cVoltaSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	INNER JOIN %table:SC9% SC9 ON C5_FILIAL+C5_NUM+C5_CLIENTE+C5_LOJACLI = C9_FILIAL+C9_PEDIDO+C9_CLIENTE+C9_LOJA AND SC9.%notDel%
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5%
		%Exp:cWhere%
		AND C9_BLCRED <> ' '
		AND C9_BLCRED <> '10'
		AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	GROUP BY C5_NUM
	ORDER BY C5_NUM

EndSql

(cVoltaSC5)->(dbGoTop())

SC5->(dbSetOrder(01))
SC9->(dbSetOrder(01))

While (cVoltaSC5)->(!Eof())

	SC5->(dbGoTop())
	SC5->(dbSeek(xFilial("SC5")+(cVoltaSC5)->C5_NUM))

	SC9->(dbGoTop())
	SC9->(dbSeek(xFilial("SC9")+(cVoltaSC5)->C5_NUM))

	SC5->(RecLock("SC5",.F.))
		If cTipo == "FI"
			SC5->C5_X_BLQFI := 'S'
		ElseIf cTipo == "AV"
			SC5->C5_X_BLQ := 'C'
		Endif
	SC5->(MsUnlock())

	While SC9->(!Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial("SC9")+(cVoltaSC5)->C5_NUM

		SC9->(RecLock("SC9",.F.))
			If cTipo == "FI"
				SC9->C9_BLOQUEI := '02'
			ElseIf cTipo == "AV"
				SC9->C9_BLOQUEI := '01'
			Endif
		SC9->(MsUnlock())

		SC9->(dbSkip())
	End

	(cVoltaSC5)->(dbSkip())
End

(cVoltaSC5)->(dbCloseArea())

RestArea(aAreaSC5)

Return
