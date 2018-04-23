#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MT410ACE  � Autor � Fernando Nogueira � Data � 23/04/2018 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Anterior a manipulacao de Ped. de Vendas ���
���          � Chamado 003590                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MT410ACE()

Local lReturn  := .T.
Local nOpcao   := ParamIXB[1]
Local aArea    := GetArea()
Local cPedidoW := PadL(cValToChar(SC5->C5_PEDWEB),TamSx3("Z3_NPEDWEB")[01])

// Caso seja exclusao e tenha bloqueio fiscal
If nOpcao == 1 .And. SC5->C5_X_BLQFI == 'S'

	dbSelectArea("SZ3")
	dbSetOrder(01)
	If	dbSeek(xFilial("SZ3")+cPedidoW) .And. Empty(SZ3->Z3_AJUFISC)
		lReturn := MsgNoYes("Pedido com bloqueio fiscal sem informa��o de ajuste fiscal no Pedido Web."+Chr(13)+Chr(10)+"Continua com a exclus�o?")
	Endif
	
	RestArea(aArea)
Endif

Return lReturn
