#Include "Protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ MT450FIM()   บ Autor ณ Fernando Nogueira บ Data ณ 18/07/14 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada Executado apos liberacao total do Pedido  บฑฑ
ฑฑบ          ณ Vendas na An.credito Pedido                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT450FIM()

Local aArea    := GetArea()
Local cCliente := SC5->C5_CLIENTE
Local cLojaCli := SC5->C5_LOJACLI
Local _cFilial  := ""
Local _cPedido  := ""

// Pedido Diferente de Dev.Compras e Beneficiamento
If !(SC5->C5_TIPO $ 'BD')

	// Atualiza Total com impostos no cadastro de clientes
	SA1->(RecLock("SA1",.F.))
		SA1->A1_X_VLRTO := U_TotPedCred(cCliente,cLojaCli)
	SA1->(MsUnlock())
	
	SC9->(DBSetOrder(1))
	SC9->(DbGoTop())
	SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM+SC6->C6_ITEM))
		
	_cFilial  := xFilial("SC9")
	_cPedido  := SC5->C5_NUM	
	
	//Grava horario da liberacao do pedido	
	While (_cFilial == xFilial("SC9") .AND. _cPedido == SC9->C9_PEDIDO)
		SC9->(RecLock("SC9",.F.))
			SC9->C9_DTCRED := Date()
			SC9->C9_HRCRED := LEFT(time(),5)
		SC9->(MsUnlock())
		SC9->(DbSkip())
	End
Endif	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ  Retorna a situacao inicial       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aArea)

Return