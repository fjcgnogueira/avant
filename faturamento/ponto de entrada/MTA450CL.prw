#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA450CL()   � Autor � Fernando Nogueira � Data � 19/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Executado apos liberacao de Credito do    ���
���          � Cliente na An.credito Cliente                              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA450CL()
Local _cFilial  := ""
Local _cPedido  := ""


// Atualiza Total com impostos no cadastro de clientes
SA1->(RecLock("SA1",.F.))
	SA1->A1_X_VLRTO := 0
	SA1->A1_X_CPGTO := Space(TamSx3("A1_X_CPGTO")[1])
SA1->(MsUnlock())


SC9->(DBSetOrder(1))
SC9->(DbGoTop())
SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM+SC6->C6_ITEM))

_cFilial  := xFilial("SC9")
_cPedido  := SC5->C5_NUM	

//Grava horario da liberacao dos pedidos
	While (_cFilial == xFilial("SC9") .AND. _cPedido == SC9->C9_PEDIDO)
		SC9->(RecLock("SC9",.F.))
			SC9->C9_DTCRED := Date()
			SC9->C9_HRCRED := LEFT(time(),5)
		SC9->(MsUnlock())
		SC9->(DbSkip())
	End
	


Return