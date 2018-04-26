#INCLUDE "PROTHEUS.CH"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA410DEL º Autor ³ Fernando Nogueira  º Data ³ 01/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Executado Antes de Deletar o SC5         º±±
±±º          ³ Chamado 003947                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MA410DEL()

Local aArea     := GetArea()
Local cArquivo  := "\MODELOS\PED_VOLTOU.HTM"
Local cMailCad  := AllTrim(GetMv("ES_MAILCAD"))
Local cMailCC   := ""
Local cMailBCC  := AllTrim(GetMv("ES_EMAILTI"))
Local cSaudacao := ""
Local _oProcess := Nil
Local lEnd      := .F.
Local nTotQtd   := 0
Local nTotal    := 0
Local nPedWeb   := SC5->C5_PEDWEB
Local cPedWeb   := cValtoChar(nPedWeb)
Local cPedidoW  := PadL(cPedWeb,TamSx3("Z3_NPEDWEB")[01])
Local cPedTRB   := GetNextAlias()
Local lWFTI     := &(Posicione("SX5",1,xFilial("SX5")+"ZA0004","X5_DESCRI"))
Local cPara     := ""
Local cMsgInt   := "Seu Pedido Web Nº "+cPedWeb+" voltou para a tela de não enviados. "
Local cUpdSZ3   := ""
Local _nResult  := 0
Local cUpdSZ4   := ""
Local _nResult1 := 0

dbSelectArea("SZ3")
dbSetOrder(01)
If dbSeek(xFilial("SZ3")+cPedidoW) .And. MsgYesNo("Deseja que esse Pedido volte para a Web?")

	// Fernando Nogueira - Chamado Chamado 003590
	If !Empty(SZ3->Z3_AJUFISC)
		cArquivo  := "\MODELOS\PED_VOLTOU_FIS.HTM"
	Endif

	// Volta Pedido Web para Nao Enviados
	While SZ3->(!EoF()) .And. SZ3->Z3_NPEDWEB = nPedWeb
		SZ3->(RecLock("SZ3",.F.))
			SZ3->Z3_STATUS := '1'
		SZ3->(MsUnlock())
		SZ3->(dbSkip())
	End

	dbSelectArea("SZ4")
	dbSetOrder(01)
	If dbSeek(xFilial("SZ4")+cPedidoW)
		While SZ4->(!EoF()) .And. SZ4->Z4_NUMPEDW = nPedWeb
			SZ4->(RecLock("SZ4",.F.))
				SZ4->Z4_RESERVA := 'S'
			SZ4->(MsUnlock())
			SZ4->(dbSkip())
		End
	Endif

	If Time() > "18:00:00"
		cSaudacao := "Boa Noite"
	ElseIf Time() > "12:00:00"
		cSaudacao := "Boa Tarde"
	Else
		cSaudacao := "Bom Dia"
	Endif

	BeginSql alias cPedTRB
		SELECT Z3_NPEDWEB,Z3_DSCTSAC,Z3_EMISSAO,Z3_DSCPGTO,Z3_REGIAO,Z3_RAZASOC,Z3_VEND,Z3_OBS,Z4_ITEMPED,Z4_CODPROD,Z4_DESCPRO,Z4_QTDE,Z4_PRLIQ,Z4_VLRTTIT,SZ3.R_E_C_N_O_ SZ3REC FROM %table:SZ3% SZ3
		INNER JOIN %table:SZ4% SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.%notDel%
		WHERE SZ3.%notDel% AND Z3_FILIAL = %xfilial:SZ3% AND Z3_NPEDWEB = %Exp:nPedWeb%
		ORDER BY Z3_FILIAL,Z3_NPEDWEB,Z4_ITEMPED
	EndSql

	(cPedTRB)->(dbGoTop())

	cPara := AllTrim(Posicione("SA3",1,xFilial("SA3")+(cPedTRB)->Z3_VEND,"A3_EMAIL"))

	If Empty(cPara)
		cPara := cMailCad

		cMsgInt   += "<br /> "
		cMsgInt   += "Setor de Cadastro de Clientes e Representantes:<br /> "
		cMsgInt   += "O representante "+(cPedTRB)->Z3_VEND+" não recebeu esse e-mail.<br /> "
		cMsgInt   += "Acertar o cadastro do representante e repassar o e-mail para ele. "
	Endif

	PswOrder(2)
	PswSeek(AllTrim(cUserName),.T.)
	cMailCC := AllTrim(PswRet()[1][14])

	oProcess := TWFProcess():New("PEDVOLTOU","PEDIDO WEB VOLTOU")
	oProcess:NewTask("Enviando Pedido Web",cArquivo)
	oHTML := oProcess:oHTML

	SZ3->(dbGoTo((cPedTRB)->SZ3REC))
	
	oHtml:ValByName("cSaudacao", cSaudacao)
	oHtml:ValByName("cMsgInt"  , cMsgInt)
	If !Empty(SZ3->Z3_AJUFISC)
		oHtml:ValByName("cMensFis" , SZ3->Z3_AJUFISC)
	Endif
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

		nTotQtd += (cPedTRB)->Z4_QTDE
		nTotal  += (cPedTRB)->Z4_VLRTTIT

		(cPedTRB)->(dbSkip())

	End

	oHtml:ValByName("cTotQtd"  , Transform(nTotQtd, "@e 999,999,999"))
	oHtml:ValByName("cTotal"   , Transform(nTotal , PesqPict("SC6","C6_VALOR")))

	If !Empty(SZ3->Z3_AJUFISC)
		oProcess:cSubject := "[Pedido Web "+cValtoChar(nPedWeb)+" Voltou para a Tela de Nao Enviados - Ajuste Fiscal Necessario - "+DtoC(Date())+"] "
		// Fernando Nogueira - Chamado 005741
		If !(cMailCad $ cPara)
			If Empty(cMailCC)
				cMailCC := cMailCad
			Else
				cMailCC += "," + cMailCad
			Endif
		Endif
	Else
		oProcess:cSubject := "[Pedido Web "+cValtoChar(nPedWeb)+" Voltou para a Tela de Nao Enviados - "+DtoC(Date())+"] "
	Endif
	oProcess:USerSiga := "000000"
	oProcess:cTo      := cPara
	oProcess:cCC      := cMailCC
	If lWFTI
		oProcess:cBCC := cMailBCC
	Endif

	oProcess:Start()
	oProcess:Finish()

	(cPedTRB)->(DbCloseArea())
Endif

RestArea(aArea)

Return
