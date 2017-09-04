#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TitVencerº Autor ³ Fernando Nogueira  º Data ³ 23/11/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ WorkFlow de Titulos a Vencer via Schedule                  º±±
±±º          ³ Chamado 004354                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TitVencer(aParam)

Local aTabelas  := {"SE1","SA1"}
Local cAliasSE1 := GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³aParam     |  [01]   |  [02]  |
//³           | Empresa | Filial |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)

// Titulos a serem enviados pelo work flow
BeginSql alias cAliasSE1

	SELECT E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VENCREA,E1_CLIENTE,E1_LOJA FROM %table:SE1% SE1
	INNER JOIN %table:SA1% SA1 ON E1_CLIENTE+E1_LOJA = A1_COD+A1_LOJA AND SA1.%notDel%
	WHERE SE1.%notDel%
		AND E1_FILIAL = %xfilial:SE1%
		AND E1_SALDO > 0
		AND E1_TIPO = 'NF'
		AND E1_VENCREA BETWEEN GETDATE() AND GETDATE()+7
		AND E1_X_WFAV <> 'S'
		AND A1_X_WFAV = 'S'
	ORDER BY E1_NUM,E1_PARCELA

EndSql

(cAliasSE1)->(dbGoTop())

// Faz o envio dos workflows
While (cAliasSE1)->(!EoF())
	EnvTit((cAliasSE1)->E1_PREFIXO,(cAliasSE1)->E1_NUM,(cAliasSE1)->E1_PARCELA,Stod((cAliasSE1)->E1_VENCREA),(cAliasSE1)->E1_CLIENTE,(cAliasSE1)->E1_LOJA)
	(cAliasSE1)->(dbSkip())
End

(cAliasSE1)->(DbCloseArea())

RpcClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnvTit   ºAutor  ³ Fernando Nogueira  º Data ³ 23/11/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia o Workflow com Titulos a Vencer do Cliente           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvTit(cPrefixo,cTitulo,cParc,dVencReal,cCliente,cLoja)

Local cArquivo  := "\MODELOS\COBRANCA_AV.HTM"
Local cPara     := Iif(!Empty(AllTrim(Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_X_MAILC"))),AllTrim(SA1->A1_X_MAILC),If(AllTrim(SA1->A1_EMAIL)='ISENTO',AllTrim(GetMv("ES_MAILCAV")),AllTrim(SA1->A1_EMAIL)))
Local cMailBCC  := AllTrim(GetMv("ES_MAILCAV"))
Local oProcess  := Nil
Local cMensTit  := ""
Local cData     := DtoC(dVencReal)
Local cDias     := cValtoChar(dVencReal-dDataBase)

oProcess := TWFProcess():New("TITAVENC","TITULO A VENCER")
oProcess:NewTask("Enviando Titulo com Parcela(s) a Vencer",cArquivo)
oHTML := oProcess:oHTML

If Empty(cParc)
	cMensTit := "de sua NF No "+cTitulo
Else
	cMensTit := "de sua NF No "+cTitulo+" parcela "+AllTrim(cParc)
Endif

oHtml:ValByName("cMensTit", cMensTit)
oHtml:ValByName("cData"   , cData)
oHtml:ValByName("cDias"   , cDias)

SE1->(dbSetOrder(01))

If SE1->(dbSeek(xFilial("SE1")+cPrefixo+cTitulo))
	While SE1->(!EoF()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) = xFilial("SE1")+cPrefixo+cTitulo

		aAdd((oHTML:ValByName("aR.cPar")), SE1->E1_PARCELA)
		aAdd((oHTML:ValByName("aR.cVnc")), DtoC(SE1->E1_VENCTO))
		aAdd((oHTML:ValByName("aR.cVnR")), DtoC(SE1->E1_VENCREA))
		aAdd((oHTML:ValByName("aR.cVlr")), Transform(SE1->E1_VALOR, PesqPict("SE1","E1_VALOR")))
		aAdd((oHTML:ValByName("aR.cSld")), Transform(SE1->E1_SALDO, PesqPict("SE1","E1_SALDO")))
		aAdd((oHTML:ValByName("aR.cSt" )), IF(SE1->E1_SALDO=SE1->E1_VALOR,"Aberto",IF(SE1->E1_SALDO=0,"Pago","Parcial")))

		SE1->(dbSkip())
	End
Endif

oProcess:cSubject := "[Titulo Avant No "+cTitulo+" com parcela(s) a vencer - "+DtoC(Date())+"] " + If(AllTrim(SA1->A1_EMAIL)='ISENTO'," - Email do Cliente Isento","")
oProcess:USerSiga := "000000"
oProcess:cTo      := cPara
oProcess:cBCC     := cMailBCC

oProcess:Start()
oProcess:Finish()

// Marca que o titulo que jah foi enviado via workflow
If SE1->(dbSeek(xFilial("SE1")+cPrefixo+cTitulo+cParc))
	SE1->(RecLock("SE1",.F.))
		SE1->E1_X_WFAV := "S"
	SE1->(MsUnlock())
Endif

Return
