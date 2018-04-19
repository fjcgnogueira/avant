#INCLUDE "PROTHEUS.CH"
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MA410DEL � Autor � Fernando Nogueira  � Data � 01/09/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Executado Antes de Deletar o SC5         ���
���          � Chamado 003947                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MA410DEL()

Local cArquivo  := "\MODELOS\PED_VOLTOU.HTM"
Local cMailCad  := AllTrim(GetMv("ES_MAILCAD"))
Local cMailCC   := ""
Local cMailBCC  := AllTrim(GetMv("ES_EMAILTI"))
Local cSaudacao := ""
Local _oProcess := Nil
Local lEnd      := .F.
Local cTotQtd   := 0
Local cTotal    := 0
Local nPedWeb   := SC5->C5_PEDWEB
Local cPedWeb   := cValtoChar(nPedWeb)
Local cPedTRB   := GetNextAlias()
Local lWFTI     := &(Posicione("SX5",1,xFilial("SX5")+"ZA0004","X5_DESCRI"))
Local cPara     := ""
Local cMsgInt   := "Seu Pedido Web N� "+cPedWeb+" voltou para a tela de n�o enviados. "
Local cUpdSZ3   := ""
Local _nResult  := 0
Local cUpdSZ4   := ""
Local _nResult1 := 0

If nPedWeb > 0 .And. MsgYesNo("Deseja que esse Pedido volte para a Web?")

	cUpdSZ3 := "UPDATE "+RetSqlName("SZ3")+" SET Z3_STATUS = '1' FROM "+RetSqlName("SZ3")+" SZ3"
	cUpdSZ3 += " INNER JOIN "+RetSqlName("SZ4")+" SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.D_E_L_E_T_ = ' '"
	cUpdSZ3 += " WHERE SZ3.D_E_L_E_T_ = ' ' AND Z3_FILIAL = "+xFilial("SZ3")+" AND Z3_NPEDWEB = "+cPedWeb
	_nResult := TcSqlExec(cUpdSZ3)

	cUpdSZ4 := "UPDATE "+RetSqlName("SZ4")+" SET Z4_RESERVA = 'S' FROM "+RetSqlName("SZ3")+" SZ3"
	cUpdSZ4 += " INNER JOIN "+RetSqlName("SZ4")+" SZ4 ON Z3_FILIAL = Z4_FILIAL AND Z3_NPEDWEB = Z4_NUMPEDW AND SZ4.D_E_L_E_T_ = ' '"
	cUpdSZ4 += " WHERE SZ3.D_E_L_E_T_ = ' ' AND Z3_FILIAL = "+xFilial("SZ3")+" AND Z3_NPEDWEB = "+cPedWeb
	_nResult1 := TcSqlExec(cUpdSZ4)


	If _nResult < 0 .AND. _nResult1 < 0
		ApMsgInfo('N�o foi poss�vel voltar o Pedido Web, Informar o Depto de TI')
	Else

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

		cPara := AllTrim(Posicione("SA3",1,xFilial("SA3")+(cPedTRB)->Z3_VEND,"A3_EMAIL"))

		If Empty(cPara)
			cPara := cMailCad

			cMsgInt   += "<br /> "
			cMsgInt   += "Setor de Cadastro de Clientes e Representantes:<br /> "
			cMsgInt   += "O representante "+(cPedTRB)->Z3_VEND+" n�o recebeu esse e-mail.<br /> "
			cMsgInt   += "Acertar o cadastro do representante e repassar o e-mail para ele. "
		Endif

		PswOrder(2)
		PswSeek(AllTrim(cUserName),.T.)
		cMailCC := AllTrim(PswRet()[1][14])

		oProcess := TWFProcess():New("PEDVOLTOU","PEDIDO WEB VOLTOU")
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

		oProcess:cSubject := "[Pedido Web "+cValtoChar(nPedWeb)+" Voltou para a Tela de Nao Enviados - "+DtoC(Date())+"] "
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

Endif

Return
