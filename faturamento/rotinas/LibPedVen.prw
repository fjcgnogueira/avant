#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � LibPedVen � Autor � Fernando Nogueira � Data � 11/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Liberacao de Pedido de Vendas, Regra Avant                ���
���          � Chamado 001777                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function LibPedVen()

Local nVlrCred := 0
Local aPedidos := {}
Local cPedido  := SC5->C5_NUM
Local cCliente := SC5->C5_CLIENTE
Local cLoja    := SC5->C5_LOJACLI

If SC5->(AllTrim(C5_X_BLQFI)+AllTrim(C5_LIBEROK)) == 'SS'
	// Fernando Nogueira - Chamado 004116
	If MsgYesNo("Pedido "+SC5->C5_NUM+" Est� com Bloqueio Fiscal!"+Chr(13)+Chr(10)+"Liberar do Bloqueio Avant assim mesmo?")
		SC5->(RecLock("SC5",.F.))
			SC5->C5_X_BLQ := 'N'
		SC5->(MsUnlock())
		ApMsgInfo("Pedido "+cPedido+" Liberado do Bloqueio Avant!")
	Endif
ElseIf SC5->(AllTrim(C5_X_BLQ)+AllTrim(C5_LIBEROK)) $ ('CS.SS')

	If PedBloq(cCliente,cLoja,cPedido) .AND. AllTrim(SC5->C5_X_BLQ) == 'S'
		SC5->(RecLock("SC5",.F.))
			SC5->C5_X_BLQ := 'C'
		SC5->(MsUnlock())
		ApMsgInfo("Pedido "+cPedido+" Bloqueado por Cliente!")

	ElseIf PedBloq(cCliente,cLoja,cPedido) .AND. AllTrim(SC5->C5_X_BLQ) == 'C'
		ApMsgInfo("Pedido "+cPedido+" Bloqueado por Cliente!")

	ElseIf MsgNoYes("Liberar o Pedido "+cPedido+" ?")

		Begin Transaction

			If AllTrim(SC5->C5_X_BLQ) == 'S'
				SC5->(RecLock("SC5",.F.))
					SC5->C5_X_BLQ := 'C'
				SC5->(MsUnlock())
			Endif

			aPedidos := RelPed(cCliente,cLoja)

			For _i := 1 to Len(aPedidos)
				ExecLib(aPedidos[_i])
			Next _i

			SC5->(dbSetOrder(01))
			SC5->(msSeek(xFilial("SC5")+cPedido))

			SA1->(dbSetOrder(01))
			SA1->(dbSeek(xFilial("SA1")+cCliente+cLoja))

			// Atualiza Total com impostos no cadastro de clientes
			SA1->(RecLock("SA1",.F.))
				SA1->A1_X_VLRTO := U_TotPedCred(cCliente,cLoja)
				SA1->A1_X_CPGTO := U_CondPgtoPed(cCliente,cLojaCli)
			SA1->(MsUnlock())

		End Transaction

		ApMsgInfo("Pedido "+cPedido+" Liberado!")

	Endif

Else
	ApMsgInfo("Pedido "+SC5->C5_NUM+" N�o Est� com Bloqueio Avant!")
Endif

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � PedBloq   � Autor � Fernando Nogueira � Data � 18/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Verifica se tem algum outro Pedido com Bloqueio para o    ���
���          � mesmo cliente                                             ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function PedBloq(cCliente,cLoja,cPedido)

Local cAliasSC5 := GetNextAlias()
Local lReturn   := .F.

BeginSql alias cAliasSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQ = 'S' AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja% AND C5_NUM <> %exp:cPedido%

EndSql

(cAliasSC5)->(dbGoTop())

If (cAliasSC5)->(!Eof())
	lReturn := .T.
Endif
(cAliasSC5)->(dbCloseArea())

Return lReturn

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � ExecLib   � Autor � Fernando Nogueira � Data � 18/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Executa liberacao do Pedido de Vendas                     ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function ExecLib(cPedido)

Local cBlqCred := ""

SC5->(dbSetOrder(01))
SC5->(msSeek(xFilial("SC5")+cPedido))

SC5->(RecLock("SC5",.F.))
	SC5->C5_X_BLQ := 'N'
SC5->(MsUnlock())

SC9->(dbSetOrder(01))
SC9->(msSeek(xFilial("SC9")+SC5->C5_NUM))

While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM

	SC6->(msSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))
	SC6->(RecLock("SC6",.F.))

	SC9->(RecLock("SC9",.F.))
		SC9->C9_BLOQUEI := ''

		nVlrCred := SC9->C9_QTDLIB * SC9->C9_PRCVEN

		// Verifica se o credito esta liberado
		If MaAvalCred(SC9->C9_CLIENTE,SC9->C9_LOJA,nVlrCred,SC5->C5_MOEDA,.T.,@cBlqCred)
			SC9->C9_BLCRED := ''
			// Libera o estoque e gera DCF
			MaAvalSC9("SC9",5,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}})
		Endif


	SC9->(MsUnlock())

	SC6->(MsUnlock())

	SC9->(dbSkip())
End

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � RelPed    � Autor � Fernando Nogueira � Data � 18/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Relacao de Pedidos a Liberar                              ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function RelPed(cCliente,cLoja)

Local cAliasSC5 := GetNextAlias()
Local lReturn   := .F.
Local aPedidos  := {}

BeginSql alias cAliasSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQ = 'C' AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasSC5)->(dbGoTop())

While (cAliasSC5)->(!Eof())
	Aadd(aPedidos, (cAliasSC5)->C5_NUM)
	(cAliasSC5)->(dbSkip())
End
(cAliasSC5)->(dbCloseArea())

Return aPedidos
