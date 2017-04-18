#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT450FIM()   � Autor � Fernando Nogueira � Data � 18/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Executado apos liberacao total do Pedido  ���
���          � Vendas na An.credito Pedido                                ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		SA1->A1_X_CPGTO := U_CondPgtoPed(cCliente,cLojaCli)
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

//�����������������������������������Ŀ
//�  Retorna a situacao inicial       �
//�������������������������������������
RestArea(aArea)

Return