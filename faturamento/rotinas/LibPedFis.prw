#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ LibPedFis บ Autor ณ Fernando Nogueira บ Data ณ 05/07/2016 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Liberacao de Pedido de Vendas, Regra Avant                บฑฑ
ฑฑบ          ณ Chamado 003522                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                          บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function LibPedFis()

Local nVlrCred := 0
Local aPedidos := {}
Local cPedido  := SC5->C5_NUM
Local cCliente := SC5->C5_CLIENTE
Local cLoja    := SC5->C5_LOJACLI
Local lTodos   := .F.
Local lLibera  := .F.

If SC5->(AllTrim(C5_X_BLQFI)+AllTrim(C5_LIBEROK)) == 'SS'

	If PedBloq(cCliente,cLoja,cPedido) .AND. AllTrim(SC5->C5_X_BLQFI) == 'S'
		lTodos := MsgNoYes("Existem mais Pedidos desse cliente bloqueados no fiscal, liberar todos?")
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
				SA1->A1_X_CPGTO := U_CondPgtoPed(cCliente,cLojaCli)
			SA1->(MsUnlock())

		End Transaction

		If lTodos
			ApMsgInfo("Pedidos Liberados!")
		Else
			ApMsgInfo("Pedido "+cPedido+" Liberado!")
		Endif

	Endif

Else
	ApMsgInfo("Pedido "+cPedido+" Nใo Estแ com Bloqueio Fiscal!")
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ PedBloq   บ Autor ณ Fernando Nogueira บ Data ณ 18/11/2015 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se tem algum outro Pedido com Bloqueio para o    บฑฑ
ฑฑบ          ณ mesmo cliente                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PedBloq(cCliente,cLoja,cPedido)

Local cAliasSC5 := GetNextAlias()
Local lReturn   := .F.

BeginSql alias cAliasSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQFI = 'S' AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja% AND C5_NUM <> %exp:cPedido%

EndSql

(cAliasSC5)->(dbGoTop())

If (cAliasSC5)->(!Eof())
	lReturn := .T.
Endif
(cAliasSC5)->(dbCloseArea())

Return lReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ExecLib   บ Autor ณ Fernando Nogueira บ Data ณ 18/11/2015 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Executa liberacao do Pedido de Vendas                     บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ExecLib(cPedido)

Local cBlqCred := ""

SC5->(dbSetOrder(01))
SC5->(msSeek(xFilial("SC5")+cPedido))

SC5->(RecLock("SC5",.F.))
	SC5->C5_X_BLQFI := 'N'
SC5->(MsUnlock())

SC9->(dbSetOrder(01))
SC9->(msSeek(xFilial("SC9")+SC5->C5_NUM))

While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM

	SC6->(msSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))
	SC6->(RecLock("SC6",.F.))

	SC9->(RecLock("SC9",.F.))
	
		If SC5->C5_X_BLQ $ 'SC'
			SC9->C9_BLOQUEI := '01'
		Else
		
			SC9->C9_BLOQUEI := ''
	
			nVlrCred := SC9->C9_QTDLIB * SC9->C9_PRCVEN
	
			// Verifica se o credito esta liberado
			If MaAvalCred(SC9->C9_CLIENTE,SC9->C9_LOJA,nVlrCred,SC5->C5_MOEDA,.T.,@cBlqCred)
				SC9->C9_BLCRED := ''
				// Libera o estoque e gera DCF
				MaAvalSC9("SC9",5,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}})
			Endif

		Endif

	SC9->(MsUnlock())

	SC6->(MsUnlock())

	SC9->(dbSkip())
End

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ RelPed    บ Autor ณ Fernando Nogueira บ Data ณ 18/11/2015 บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Relacao de Pedidos a Liberar                              บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RelPed(cCliente,cLoja)

Local cAliasSC5 := GetNextAlias()
Local lReturn   := .F.
Local aPedidos  := {}

BeginSql alias cAliasSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQFI = 'S' AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasSC5)->(dbGoTop())

While (cAliasSC5)->(!Eof())
	Aadd(aPedidos, (cAliasSC5)->C5_NUM)
	(cAliasSC5)->(dbSkip())
End
(cAliasSC5)->(dbCloseArea())

Return aPedidos
