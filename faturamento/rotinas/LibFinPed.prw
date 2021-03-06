#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � LibFinPed � Autor � Fernando Nogueira � Data � 24/04/2017 ���
������������������������������������������������������������������������͹��
���Descricao � Liberacao de Pedido de Vendas, Regra Avant Financeira     ���
���          � Chamado 004840                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function LibFinPed()

Local nVlrCred := 0
Local aPedidos := {}
Local cPedido  := SC5->C5_NUM
Local cCliente := SC5->C5_CLIENTE
Local cLoja    := SC5->C5_LOJACLI
Local lTodos   := .F.
Local lLibera  := .F.

If SC5->(AllTrim(C5_X_BLFIN)+AllTrim(C5_LIBEROK)) == 'SS'

	If PedBloq(cCliente,cLoja,cPedido) .AND. AllTrim(SC5->C5_X_BLFIN) == 'S'
		lTodos := MsgNoYes("Existem mais Pedidos desse cliente bloqueados no financeiro, liberar todos?")
		lLibera := lTodos
	Endif
	
	If !lLibera
		lLibera := MsgNoYes("Liberar o Pedido "+cPedido+" ?")
	Endif

	If lLibera

		Begin Transaction

			If lTodos
				aPedidos := RelPed(cCliente,cLoja)
	
				For _i := 1 to Len(aPedidos)
					ExecLib(aPedidos[_i])
				Next _i
			Else
				ExecLib(cPedido)
			Endif

			SC5->(dbSetOrder(01))
			SC5->(msSeek(xFilial("SC5")+cPedido))

			SA1->(dbSetOrder(01))
			SA1->(dbSeek(xFilial("SA1")+cCliente+cLoja))

			// Atualiza Total com impostos no cadastro de clientes
			SA1->(RecLock("SA1",.F.))
				SA1->A1_X_VLRTO := U_TotPedCred(cCliente,cLoja)
				SA1->A1_X_CPGTO := U_CondPgtoPed(cCliente,cLoja)
			SA1->(MsUnlock())

		End Transaction

		If lTodos
			ApMsgInfo("Pedidos Liberados do Financeiro!")
		Else
			ApMsgInfo("Pedido "+cPedido+" Liberado do Financeiro!")
		Endif

	Endif

Else
	ApMsgInfo("Pedido "+cPedido+" N�o Est� com Bloqueio Financeiro!")
Endif

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � PedBloq   � Autor � Fernando Nogueira � Data � 24/04/2017 ���
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
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQFI <> 'S' AND C5_X_BLFIN = 'S' AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja% AND C5_NUM <> %exp:cPedido%

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
���Programa  � ExecLib   � Autor � Fernando Nogueira � Data � 24/04/2017 ���
������������������������������������������������������������������������͹��
���Descricao � Executa liberacao do Pedido de Vendas                     ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function ExecLib(cPedido)

Local aRegSC6  := {}

SC5->(dbSetOrder(01))
SC5->(msSeek(xFilial("SC5")+cPedido))

SC5->(RecLock("SC5",.F.))
	SC5->C5_X_BLFIN := 'N'
SC5->(MsUnlock())

SC9->(dbSetOrder(01))
SC9->(msSeek(xFilial("SC9")+SC5->C5_NUM))

While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM

	SC9->(RecLock("SC9",.F.))
	
	If SC5->C5_X_BLQFI $ 'S'
		SC9->C9_BLOQUEI := '02'
	ElseIf SC5->C5_X_BLQ $ 'SC'
		SC9->C9_BLOQUEI := '01'
	Else
		SC9->C9_BLOQUEI := ''
	Endif

	SC9->(MsUnlock())

	SC9->(dbSkip())
End

If !(SC5->C5_X_BLQ $ 'SC' .Or. SC5->C5_X_BLQFI = 'S')
	SC6->(dbSetOrder(01))
	SC6->(msSeek(xFilial("SC6")+cPedido))
	
	While SC6->(!Eof()) .And. SC6->C6_NUM == cPedido
		aAdd(aRegSC6,SC6->(RecNo()))
		SC6->(dbSkip())
	End

	Begin Transaction
		MaAvalSC5("SC5",3,.F.,.F.,,,,,,cPedido,aRegSC6,.T.,.T.)
	End Transaction
	aRegSC6 := {}
Endif

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � RelPed    � Autor � Fernando Nogueira � Data � 24/04/2017 ���
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
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQFI <> 'S' AND C5_X_BLFIN = 'S' AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasSC5)->(dbGoTop())

While (cAliasSC5)->(!Eof())
	Aadd(aPedidos, (cAliasSC5)->C5_NUM)
	(cAliasSC5)->(dbSkip())
End
(cAliasSC5)->(dbCloseArea())

Return aPedidos
