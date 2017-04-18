#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA450I()    � Autor � Fernando Nogueira � Data � 19/07/14 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Executado apos liberacao do item do Pedido���
���          � de Vendas na An.credito Pedido                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA450I()

Local aArea    := GetArea()
Local cCliente := SC9->C9_CLIENTE
Local cLojaCli := SC9->C9_LOJA

// Atualiza Total com impostos no cadastro de clientes
SA1->(RecLock("SA1",.F.))
	SA1->A1_X_VLRTO := U_TotPedCred(cCliente,cLojaCli)
	SA1->A1_X_CPGTO := U_CondPgtoPed(cCliente,cLojaCli)
SA1->(MsUnlock())

SC9->(DBSetOrder(1))
SC9->(DbGoTop())
SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM+SC6->C6_ITEM))

//Grava horario da liberacao do item
SC9->(RecLock("SC9",.F.))
	SC9->C9_DTCRED := Date()
	SC9->C9_HRCRED := LEFT(time(),5)
SC9->(MsUnlock())

//�����������������������������������Ŀ
//�  Retorna a situacao inicial       �
//�������������������������������������
RestArea(aArea)

Return