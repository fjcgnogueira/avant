#INCLUDE "PROTHEUS.CH"           
#INCLUDE "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedSched º Autor ³ Fernando Nogueira  º Data ³ 23/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Integracao de Pedido de Vendas via Schedule                º±±
±±º          ³ Chamado 003254                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PedSched(aParam)

Local aTabelas   := {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9","ZZI","ZIA","SZ3","SZ4"}
Local cMensagem  := ""
Local cDocumen   := ""
Local cNextAlias := GetNextAlias()
Local aPedWeb    := {}

Private aPVlNFs  := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³aParam     |  [01]   |  [02]  |
	//³           | Empresa | Filial |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FAT", NIL, aTabelas)

BeginSql alias cNextAlias

	SELECT Z3_NPEDWEB,SZ3.R_E_C_N_O_ SZ3RECNO FROM %table:SZ3% SZ3
	INNER JOIN %table:SZ4% SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.%notDel%
	WHERE SZ3.%notDel% AND Z3_FILIAL = %xfilial:SZ3% AND Z3_STATUS = '2'
	GROUP BY Z3_NPEDWEB,SZ3.R_E_C_N_O_
	ORDER BY Z3_NPEDWEB,SZ3.R_E_C_N_O_

EndSql

// Define o Status P - Em processo de Integracao
// Fernando Nogueira - Chamado 004628
While (cNextAlias)->(!EoF())

	aAdd(aPedWeb, (cNextAlias)->Z3_NPEDWEB)

	SZ3->(dbGoTo((cNextAlias)->SZ3RECNO))
	
	SZ3->(RecLock("SZ3",.F.))
		SZ3->Z3_STATUS := 'P'
	SZ3->(MsUnlock())
	
	(cNextAlias)->(dbSkip())
End

// Faz a Integracao dos Pedidos de Vendas
For nI := 1 to Len(aPedWeb)

	cMensagem := ""
	cDocumen  := ""
	
	ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Processando Pedido Web: "+AllTrim(cValToChar(aPedWeb[nI])))

	U_INTPEDIDO(aParam[1], aParam[2], AllTrim(cValToChar(aPedWeb[nI])), @cMensagem, @cDocumen, .F.)
	
	If !Empty(cMensagem)
		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] "+cMensagem)
	Endif
	If !Empty(cDocumen)
		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] "+cDocumen)
	Endif
	
	SZ3->(dbGoTo((cNextAlias)->SZ3RECNO))
	
	If SZ3->Z3_STATUS = '3'
		EnvInteg()
	Else
		EnvNaoInt(aPedWeb[nI],cMensagem)
	Endif
	
	Sleep(15000)
	
Next

(cNextAlias)->(DbCloseArea())

If Empty(cDocumen) .And. Empty(cMensagem)
	ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Nenhum pedido a integrar")
Endif

RpcClearEnv()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnvInteg ºAutor  ³ Fernando Nogueira  º Data ³ 25/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia o Pedido Web Integrado por E-mail                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvInteg()

Local cArquivo  := "\MODELOS\PED_INTEGRADO.HTM"
Local cMailCC   := AllTrim(GetMv("ES_MAILCAD"))
Local cMailBCC  := AllTrim(GetMv("ES_EMAILTI"))
Local cSaudacao := ""
Local _oProcess := Nil
Local lEnd      := .F.
Local cTotQtd   := 0
Local cTotal    := 0
Local lWFTI     := &(Posicione("SX5",1,xFilial("SX5")+"ZA0004","X5_DESCRI"))
Local cPara     := AllTrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))
Local lMailCad  := Empty(cPara)
Local cMsgInt   := "Seu Pedido Web Nº "+cValtoChar(SC5->C5_PEDWEB)+" foi integrado com sucesso. "

If lMailCad
	cMsgInt   += "<br /> "
	cMsgInt   += "Setor de Cadastro de Clientes e Representantes:<br /> "
	cMsgInt   += "O representante "+SA3->A3_COD+" não recebeu esse e-mail.<br /> "
	cMsgInt   += "Acertar o cadastro do representante e repassar o e-mail para ele. "	
Endif

If Time() > "18:00:00"
	cSaudacao := "Boa Noite"
ElseIf Time() > "12:00:00"
	cSaudacao := "Boa Tarde"
Else
	cSaudacao := "Bom Dia"
Endif

oProcess := TWFProcess():New("PEDINT","PEDIDO INTEGRADO")
oProcess:NewTask("Enviando Pedido",cArquivo)
oHTML := oProcess:oHTML

SC6->(dbSetOrder(01))
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

oHtml:ValByName("cSaudacao", cSaudacao)
oHtml:ValByName("cMsgInt"  , cMsgInt)
oHtml:ValByName("cPedido"  , cValtoChar(SC5->C5_NUM))
oHtml:ValByName("cEmissao" , DtoC(SC5->C5_EMISSAO))
oHtml:ValByName("cTpOper"  , AllTrim(SC6->C6_TPOPERW))
oHtml:ValByName("cCondPag" , AllTrim(SC5->C5_XDESCP))
oHtml:ValByName("cRegiao"  , AllTrim(SC5->C5_REGIAO))
oHtml:ValByName("cDescCli" , AllTrim(SC5->C5_DESCCLI))
oHtml:ValByName("cNomTran" , AllTrim(SC5->C5_NOMTRAN))
oHtml:ValByName("cObs"     , AllTrim(SC5->C5_MENNOTA))

While SC6->(!EoF()) .And. SC6->C6_NUM == SC5->C5_NUM

	aAdd((oHTML:ValByName("aR.cI"))      , SC6->C6_ITEM)
	aAdd((oHTML:ValByName("aR.cPrd"))    , SC6->C6_PRODUTO)
	aAdd((oHTML:ValByName("aR.cDescPrd")), SC6->C6_DESCRI)
	aAdd((oHTML:ValByName("aR.cQtd"))    , Transform(SC6->C6_QTDVEN, "@e 999,999,999"))
	aAdd((oHTML:ValByName("aR.cVlr"))    , Transform(SC6->C6_PRCVEN, PesqPict("SC6","C6_VALOR")))
	aAdd((oHTML:ValByName("aR.cTot"))    , Transform(SC6->C6_VALOR , PesqPict("SC6","C6_VALOR")))
	
	cTotQtd += SC6->C6_QTDVEN
	cTotal  += SC6->C6_VALOR

	SC6->(dbSkip())
		
End

oHtml:ValByName("cTotQtd", Transform(cTotQtd, "@e 999,999,999"))
oHtml:ValByName("cTotal" , Transform(cTotal , PesqPict("SC6","C6_VALOR")))
oHtml:ValByName("cTotImp", Transform(SC5->C5_XTOTPED , PesqPict("SC6","C6_VALOR")))

oProcess:cSubject := "[Pedido Web "+cValtoChar(SC5->C5_PEDWEB)+" Integrado - "+DtoC(Date())+"] "+"Nº Pedido Interno: " + SC5->C5_NUM
oProcess:USerSiga := "000000"
oProcess:cTo      := cPara
If lMailCad
	oProcess:cCC  := cMailCC
Endif
If lWFTI
	oProcess:cBCC := cMailBCC
Endif
oProcess:Start()
oProcess:Finish()
lEnviou := .T.

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EnvNaoIntºAutor  ³ Fernando Nogueira  º Data ³ 25/08/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia o Pedido Web Nao Integrado por E-mail                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EnvNaoInt(nPedWeb,cMensagem)

Local cArquivo  := "\MODELOS\PED_NAOINT.HTM"
Local cMailCC   := AllTrim(GetMv("ES_MAILCAD"))
Local cMailBCC  := AllTrim(GetMv("ES_EMAILTI"))
Local cSaudacao := ""
Local _oProcess := Nil
Local lEnd      := .F.
Local cTotQtd   := 0
Local cTotal    := 0
Local cPedWeb   := cValtoChar(nPedWeb)
Local cPedTRB   := GetNextAlias()
Local lWFTI     := &(Posicione("SX5",1,xFilial("SX5")+"ZA0004","X5_DESCRI"))
Local cPara     := ""
Local lMailCad  := ""
Local cMsgInt   := "Seu Pedido Web Nº "+cPedWeb+" não foi integrado. "

If Time() > "18:00:00"
	cSaudacao := "Boa Noite"
ElseIf Time() > "12:00:00"
	cSaudacao := "Boa Tarde"
Else
	cSaudacao := "Bom Dia"
Endif

BeginSql alias cPedTRB

	SELECT Z3_NPEDWEB,Z3_DSCTSAC,Z3_EMISSAO,Z3_DSCPGTO,Z3_REGIAO,Z3_RAZASOC,Z3_VEND,Z3_OBS,Z4_ITEMPED,Z4_CODPROD,Z4_DESCPRO,Z4_QTDE,Z4_PRLIQ,Z4_VLRTTIT FROM %table:SZ3% SZ3
	INNER JOIN %table:SZ4% SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.%notDel%
	WHERE SZ3.%notDel% AND Z3_FILIAL = %xfilial:SZ3% AND Z3_NPEDWEB = %Exp:nPedWeb%
	ORDER BY Z3_FILIAL,Z3_NPEDWEB,Z4_ITEMPED

EndSql

(cPedTRB)->(dbGoTop())

cPara     := AllTrim(Posicione("SA3",1,xFilial("SA3")+(cPedTRB)->Z3_VEND,"A3_EMAIL"))
lMailCad  := Empty(cPara)

If lMailCad
	cMsgInt   += "<br /> "
	cMsgInt   += "Setor de Cadastro de Clientes e Representantes:<br /> "
	cMsgInt   += "O representante "+(cPedTRB)->Z3_VEND+" não recebeu esse e-mail.<br /> "
	cMsgInt   += "Acertar o cadastro do representante e repassar o e-mail para ele. "	
Endif

oProcess := TWFProcess():New("PEDNAOINT","PEDIDO NAO INTEGRADO")
oProcess:NewTask("Enviando Pedido Web",cArquivo)
oHTML := oProcess:oHTML

oHtml:ValByName("cSaudacao", cSaudacao)
oHtml:ValByName("cMsgInt"  , cMsgInt)
oHtml:ValByName("cEmissao" , DtoC(StoD((cPedTRB)->Z3_EMISSAO)))
oHtml:ValByName("cTpOper"  , AllTrim((cPedTRB)->Z3_DSCTSAC))
oHtml:ValByName("cCondPag" , AllTrim((cPedTRB)->Z3_DSCPGTO))
oHtml:ValByName("cRegiao"  , AllTrim((cPedTRB)->Z3_REGIAO))
oHtml:ValByName("cDescCli" , AllTrim((cPedTRB)->Z3_RAZASOC))
oHtml:ValByName("cObs"     , AllTrim((cPedTRB)->Z3_OBS))

While (cPedTRB)->(!EoF())

	aAdd((oHTML:ValByName("aR.cI"))      , (cPedTRB)->Z4_ITEMPED)
	aAdd((oHTML:ValByName("aR.cPrd"))    , (cPedTRB)->Z4_CODPROD)
	aAdd((oHTML:ValByName("aR.cDescPrd")), (cPedTRB)->Z4_DESCPRO)
	aAdd((oHTML:ValByName("aR.cQtd"))    , Transform((cPedTRB)->Z4_QTDE, "@e 999,999,999"))
	aAdd((oHTML:ValByName("aR.cVlr"))    , Transform((cPedTRB)->Z4_PRLIQ, PesqPict("SC6","C6_VALOR")))
	aAdd((oHTML:ValByName("aR.cTot"))    , Transform((cPedTRB)->Z4_VLRTTIT, PesqPict("SC6","C6_VALOR")))
	
	cTotQtd += (cPedTRB)->Z4_QTDE
	cTotal  += (cPedTRB)->Z4_VLRTTIT

	(cPedTRB)->(dbSkip())
		
End

oHtml:ValByName("cTotQtd"  , Transform(cTotQtd, "@e 999,999,999"))
oHtml:ValByName("cTotal"   , Transform(cTotal , PesqPict("SC6","C6_VALOR")))
oHtml:ValByName("cMensagem", cMensagem)

oProcess:cSubject := "[Pedido Web "+cValtoChar(nPedWeb)+" Não Integrado - "+DtoC(Date())+"] "
oProcess:USerSiga := "000000"
oProcess:cTo      := cPara
If lMailCad
	oProcess:cCC  := cMailCC
Endif
If lWFTI
	oProcess:cBCC := cMailBCC
Endif

oProcess:Start()
oProcess:Finish()

(cPedTRB)->(DbCloseArea())

Return
