#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F060ACT  º Autor ³ Fernando Nogueira  º Data ³ 18/05/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada apos transferencia de titulo no contas a  º±±
±±º          ³ receber, antes da contabilizacao                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F060ACT()

Local aParam   := ParamIXB[1] // {M->E1_SITUACA,cPort060,cAgen060,cConta060,lDesc,cCliente,cTitulo,cSituAnt,cContrato,cPortador}
Local aAreaSE1 := SE1->(GetArea())
Local cPrefixo := SE1->E1_PREFIXO
Local cTitulo  := SE1->E1_NUM
Local cPortNov := Left(aParam[02],03)
Local cPortAtu := Left(aParam[10],03)

// No caso de tirar o portador e deixar em branco
If !Empty(cPortAtu) .And. Empty(cPortNov)

	Begin Transaction
	
	// Envia Workflow para o cliente na transferencia de titulo
	If Empty(SE1->E1_X_WFTRF)
		If MsgNoYes("Deseja enviar Worflow de Cancelamento de Cobrança para o Cliente?")
			EnvTit(cPrefixo,cTitulo)
		Else
		
			SE1->(dbSetOrder(01))
	
			If SE1->(dbSeek(xFilial("SE1")+cPrefixo+cTitulo))
				While SE1->(!EoF()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) = xFilial("SE1")+cPrefixo+cTitulo 
					SE1->(RecLock("SE1",.F.))
						SE1->E1_X_WFTRF := "N"
					SE1->(MsUnlock())
					
					SE1->(dbSkip())
				End
			Endif
		Endif
	Endif
	
	End Transaction
	
	SE1->(RestArea(aAreaSE1))
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnvTit   ºAutor  ³ Fernando Nogueira  º Data ³ 18/05/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia o Workflow com o Titulo para o Cliente               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvTit(cPrefixo,cTitulo)

Local cArquivo  := "\MODELOS\CANC_COBRANCA.HTM"
Local cPara     := Iif(!Empty(AllTrim(Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_X_MAILC"))),AllTrim(SA1->A1_X_MAILC),AllTrim(SA1->A1_EMAIL))
Local cMailBCC  := AllTrim(GetMv("ES_MAILCAV"))+";"+AllTrim(GetMv("ES_EMAILTI"))
Local oProcess  := Nil

oProcess := TWFProcess():New("CANCCOB","CANCELAMENTO DE COBRANCA")
oProcess:NewTask("Enviando Cancelamento de Cobranca de Titulo",cArquivo)
oHTML := oProcess:oHTML

oHtml:ValByName("cNF"     , cTitulo)
oHtml:ValByName("cEmissao", DtoC(SE1->E1_EMISSAO))

SE1->(dbSetOrder(01))

If SE1->(dbSeek(xFilial("SE1")+cPrefixo+cTitulo))
	While SE1->(!EoF()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) = xFilial("SE1")+cPrefixo+cTitulo 
	
		aAdd((oHTML:ValByName("aR.cPar")), SE1->E1_PARCELA)
		aAdd((oHTML:ValByName("aR.cVnc")), DtoC(SE1->E1_VENCTO))
		aAdd((oHTML:ValByName("aR.cVnR")), DtoC(SE1->E1_VENCREA))
		aAdd((oHTML:ValByName("aR.cVlr")), Transform(SE1->E1_VALOR, PesqPict("SE1","E1_VALOR")))
		
		SE1->(RecLock("SE1",.F.))
			SE1->E1_X_WFTRF := "S"
		SE1->(MsUnlock())	
		
		SE1->(dbSkip())
	End
Endif

oProcess:cSubject := "[Cancelamento da NF "+cTitulo+" e Boleto(s) Correspondente(s) - "+DtoC(Date())+"] "
oProcess:USerSiga := "000000"
oProcess:cTo      := cPara
oProcess:cBCC     := cMailBCC

oProcess:Start()
oProcess:Finish()

ApMsgInfo("WorkFlow enviado!")

Return