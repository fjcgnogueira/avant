#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PedSched � Autor � Fernando Nogueira  � Data � 23/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Integracao de Pedido de Vendas via Schedule                ���
���          � Chamado 003254                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PedSched(aParam)

Local aTabelas  := {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9","ZZI","ZIA","SZ3","SZ4"}
Local cAliasSZ3 := ""

SET CENTURY ON

	//������������������������������Ŀ
	//�aParam     |  [01]   |  [02]  |
	//�           | Empresa | Filial |
	//��������������������������������

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FAT", NIL, aTabelas)

// Fernando Nogueira - Chamado 005703
// Executa entre os horarios abaixo
If (Time() >= "06:20:00" .And. Time() < "06:30:00") .Or. (Time() >= "12:50:00" .And. Time() < "13:00:00")
	cAliasSZ3 := GetNextAlias()

	BeginSql alias cAliasSZ3
		SELECT R_E_C_N_O_ SZ3RECNO FROM %table:SZ3%
		WHERE %NotDel%
			AND Z3_FILIAL = %xfilial:SZ3%
			AND Z3_STATUS = 'P'
	EndSql

	While (cAliasSZ3)->(!EoF())

		SZ3->(dbGoTo((cAliasSZ3)->SZ3RECNO))

		SZ3->(RecLock("SZ3",.F.))
			SZ3->Z3_STATUS := '2'
		SZ3->(MsUnlock())

		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Pedido Web "+cValToChar(SZ3->Z3_NPEDWEB)+" voltou ao status '2'")

		(cAliasSZ3)->(dbSkip())
	End

	(cAliasSZ3)->(DbCloseArea())
Endif

// Nao executa entre os horarios abaixo
If !((Time() >= "06:00:00" .And. Time() < "06:20:00") .Or. (Time() >= "12:30:00" .And. Time() < "12:50:00"))
	U_xPedSched()
Else
	ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Execucao cancelada, horario de ajuste")
Endif

RpcClearEnv()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � xPedSched� Autor � Fernando Nogueira  � Data � 13/03/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Integracao de Pedido de Vendas                             ���
���          � Nao precisa chamar via schedule, para testes               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function xPedSched()

Local cMensagem  := ""
Local cDocumen   := ""
Local cNextAlias := GetNextAlias()
Local aPedWeb    := {}
Local _nXI       := 0
Local cPedWeb    := ""

SET CENTURY ON

// Pedidos aptos a integrar
BeginSql alias cNextAlias

	SELECT Z3_NPEDWEB,SZ3.R_E_C_N_O_ SZ3RECNO,Z3_CODTSAC FROM %table:SZ3% SZ3
	INNER JOIN %table:SZ4% SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.%notDel%
	WHERE SZ3.%notDel% AND Z3_FILIAL = %xfilial:SZ3% AND Z3_STATUS = '2'
	GROUP BY Z3_NPEDWEB,Z3_CODTSAC,SZ3.R_E_C_N_O_
	ORDER BY Z3_NPEDWEB,SZ3.R_E_C_N_O_

EndSql

dbSelectArea("SC5")
dbOrderNickName("PEDWEB")

// Define o Status P - Em processo de Integracao
// Fernando Nogueira - Chamado 004628
While (cNextAlias)->(!EoF())

	SZ3->(dbGoTo((cNextAlias)->SZ3RECNO))

	cPedWeb	:= PadR(cValToChar(SZ3->Z3_NPEDWEB),TamSx3("Z3_NPEDWEB")[01])

	// Fernando Nogueira - Chamado 005685
	If SC5->(dbSeek(xFilial("SC5")+cPedWeb))
		SZ3->(RecLock("SZ3",.F.))
			SZ3->Z3_STATUS := '3'
		SZ3->(MsUnlock())
		(cNextAlias)->(dbSkip())

		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Pedido Web "+cValToChar(SZ3->Z3_NPEDWEB)+" alterado para status 3")

		Loop
	Endif

	aAdd(aPedWeb, {(cNextAlias)->Z3_NPEDWEB,(cNextAlias)->SZ3RECNO,Left((cNextAlias)->Z3_CODTSAC,2)})

	SZ3->(RecLock("SZ3",.F.))
		SZ3->Z3_STATUS := 'P'
	SZ3->(MsUnlock())

	(cNextAlias)->(dbSkip())
End

// Faz a Integracao dos Pedidos de Vendas
For _nXI := 1 to Len(aPedWeb)

	cMensagem := ""
	cDocumen  := ""

	ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] Processando Pedido Web: "+AllTrim(cValToChar(aPedWeb[_nXI][01])))
	
	Begin Transaction

		U_INTPEDIDO(cEmpAnt, cFilAnt, AllTrim(cValToChar(aPedWeb[_nXI][01])), @cMensagem, @cDocumen, .F.)
		
	End Transaction

	If !Empty(cMensagem)
		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] "+cMensagem)
	Endif
	If !Empty(cDocumen)
		ConOut("["+DtoC(Date())+" "+Time()+"] [PedSched] "+cDocumen)
	Endif

	SZ3->(dbGoTo(aPedWeb[_nXI][02]))

	If SZ3->Z3_STATUS = '3'
		EnvInteg()
		// Fernando Nogueira - Chamado 005680
		If SC5->C5_CONDPAG = '149' .And. aPedWeb[_nXI][03] = '51'
			EnvPedAnt()
		Endif
	Else
		If !("Seu Pedido tem produto faltando regra fiscal" $ cMensagem) // Fernando Nogueira - Chamado 004689
			EnvNaoInt(aPedWeb[_nXI][01],cMensagem)
		Endif
	Endif

	Sleep(15000)

Next

// Caso tenha pulado algum Pedido com Status P, volta para o Status 2, que entra na proxima execucao
For _nXI := 1 to Len(aPedWeb)

	SZ3->(dbGoTo(aPedWeb[_nXI][02]))

	If SZ3->Z3_STATUS = 'P'
		SZ3->(RecLock("SZ3",.F.))
			SZ3->Z3_STATUS := '2'
		SZ3->(MsUnlock())
	Endif

Next

(cNextAlias)->(DbCloseArea())

If Empty(cDocumen) .And. Empty(cMensagem)
	ConOut("["+DtoC(Date())+" "+Time()+"] [xPedSched] Nenhum pedido a integrar")
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnvInteg �Autor  � Fernando Nogueira  � Data � 25/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia o Pedido Web Integrado por E-mail                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local cMsgInt   := "Seu Pedido Web N� "+cValtoChar(SC5->C5_PEDWEB)+" foi integrado com sucesso. "

If lMailCad
	cMsgInt   += "<br /> "
	cMsgInt   += "Setor de Cadastro de Clientes e Representantes:<br /> "
	cMsgInt   += "O representante "+SA3->A3_COD+" n�o recebeu esse e-mail.<br /> "
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

	aAdd((oHTML:ValByName("a.cI"))      , SC6->C6_ITEM)
	aAdd((oHTML:ValByName("a.cPrd"))    , SC6->C6_PRODUTO)
	aAdd((oHTML:ValByName("a.cDescPrd")), SC6->C6_DESCRI)
	aAdd((oHTML:ValByName("a.cQtd"))    , Transform(SC6->C6_QTDVEN, "@e 999,999,999"))
	aAdd((oHTML:ValByName("a.cVlr"))    , Transform(SC6->C6_PRCVEN, PesqPict("SC6","C6_VALOR")))
	aAdd((oHTML:ValByName("a.cTot"))    , Transform(SC6->C6_VALOR , PesqPict("SC6","C6_VALOR")))

	cTotQtd += SC6->C6_QTDVEN
	cTotal  += SC6->C6_VALOR

	SC6->(dbSkip())

End

oHtml:ValByName("cTotQtd", Transform(cTotQtd, "@e 999,999,999"))
oHtml:ValByName("cTotal" , Transform(cTotal , PesqPict("SC6","C6_VALOR")))
oHtml:ValByName("cTotImp", Transform(SC5->C5_XTOTPED , PesqPict("SC6","C6_VALOR")))

oProcess:cSubject := "[Pedido Web "+cValtoChar(SC5->C5_PEDWEB)+" Integrado - "+DtoC(Date())+"] "+"No Pedido Interno: " + SC5->C5_NUM
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnvNaoInt�Autor  � Fernando Nogueira  � Data � 25/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia o Pedido Web Nao Integrado por E-mail                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local cMsgInt   := "Seu Pedido Web N� "+cPedWeb+" n�o foi integrado. "

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
	cMsgInt   += "O representante "+(cPedTRB)->Z3_VEND+" n�o recebeu esse e-mail.<br /> "
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

	aAdd((oHTML:ValByName("a.cI"))      , (cPedTRB)->Z4_ITEMPED)
	aAdd((oHTML:ValByName("a.cPrd"))    , (cPedTRB)->Z4_CODPROD)
	aAdd((oHTML:ValByName("a.cDescPrd")), (cPedTRB)->Z4_DESCPRO)
	aAdd((oHTML:ValByName("a.cQtd"))    , Transform((cPedTRB)->Z4_QTDE, "@e 999,999,999"))
	aAdd((oHTML:ValByName("a.cVlr"))    , Transform((cPedTRB)->Z4_PRLIQ, PesqPict("SC6","C6_VALOR")))
	aAdd((oHTML:ValByName("a.cTot"))    , Transform((cPedTRB)->Z4_VLRTTIT, PesqPict("SC6","C6_VALOR")))

	cTotQtd += (cPedTRB)->Z4_QTDE
	cTotal  += (cPedTRB)->Z4_VLRTTIT

	(cPedTRB)->(dbSkip())

End

oHtml:ValByName("cTotQtd"  , Transform(cTotQtd, "@e 999,999,999"))
oHtml:ValByName("cTotal"   , Transform(cTotal , PesqPict("SC6","C6_VALOR")))
oHtml:ValByName("cMensagem", cMensagem)

oProcess:cSubject := "[Pedido Web "+cValtoChar(nPedWeb)+" Nao Integrado - "+DtoC(Date())+"] "
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

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � EnvPedAnt�Autor  � Fernando Nogueira  � Data � 13/03/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia Workflow com Pedido Antecipado ao Cliente            ���
���          � Chamado 005629                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EnvPedAnt()

Local cArquivo  := "\MODELOS\ANTECIPADO.HTM"
Local cMailCC   := AllTrim(GetMv("ES_MAILANT"))
Local cMailBCC  := AllTrim(GetMv("ES_EMAILTI"))
Local cSaudacao := ""
Local _oProcess := Nil
Local lEnd      := .F.
Local cTotQtd   := 0
Local cTotal    := 0
Local lWFTI     := &(Posicione("SX5",1,xFilial("SX5")+"ZA0004","X5_DESCRI"))
Local cPara     := Iif(!Empty(AllTrim(Posicione("SA1",1,xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_X_MAILC"))),AllTrim(SA1->A1_X_MAILC),If(AllTrim(SA1->A1_EMAIL)='ISENTO',AllTrim(GetMv("ES_MAILCAD")),AllTrim(SA1->A1_EMAIL)))

cMailCC += Iif(Empty(cPara),"",",")+AllTrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))
cMailCC += Iif(!Empty(SA3->A3_GEREN),Iif(Empty(cPara),"",",")+AllTrim(Posicione("SA3",1,xFilial("SA3")+SA3->A3_GEREN,"A3_EMAIL")),"")

oProcess := TWFProcess():New("ENVPEDINT","PEDIDO ANTECIPADO")
oProcess:NewTask("Enviando Pedido Antecipado",cArquivo)
oHTML := oProcess:oHTML

oHtml:ValByName("cPedido"    , SC5->C5_NUM)
oHtml:ValByName("cValor"     , Alltrim(Transform(SC5->C5_XTOTPED , PesqPict("SC6","C6_VALOR"))))
oHtml:ValByName("cVencimento", DtoC(DataValida(dDataBase+1,.T.)))

oProcess:cSubject := "[Pedido Antecipado Avant "+SC5->C5_NUM+" - Dados para Pagamento - Cliente "+AllTrim(SA1->A1_NOME)+" - "+DtoC(Date())+"]"
oProcess:USerSiga := "000000"
oProcess:cTo      := cPara
oProcess:cCC  	  := cMailCC
If lWFTI
	oProcess:cBCC := cMailBCC
Endif
oProcess:Start()
oProcess:Finish()
lEnviou := .T.

Return
