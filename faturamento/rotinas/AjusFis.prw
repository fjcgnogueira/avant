#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � AjusFis   � Autor � Fernando Nogueira � Data � 23/04/2018 ���
������������������������������������������������������������������������͹��
���Descricao � Descricao do Ajuste Fiscal                                ���
���          � Chamado 003590                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function AjusFis()

Local cAjuste := ""
Local oMemo
Local oDlg
Local oFont
Local cPedidoW := PadL(cValToChar(SC5->C5_PEDWEB),TamSx3("Z3_NPEDWEB")[01])

dbSelectArea("SZ3")
dbSetOrder(01)
If dbSeek(xFilial("SZ3")+cPedidoW)

	cAjuste := SZ3->Z3_AJUFISC
	
	// Janela para digitacao do ajuste fiscal
	DEFINE MSDIALOG oDlg TITLE "Ajuste Fiscal" From 3,0 to 340,417 PIXEL
	@ 5,5 GET oMemo VAR cAjuste MEMO SIZE 200,145 OF oDlg PIXEL 
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,145 TYPE 1 ACTION (GravaAju(cAjuste),oDlg:End()) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTER

Else
	MsgInfo("Pedido Web "+cValToChar(SC5->C5_PEDWEB)+" n�o encontrado")
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GravaAju �Autor  � Fernando Nogueira  � Data � 23/04/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava ajuste Fiscal no Pedido Web                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaAju(cAjuste)

SZ3->(RecLock("SZ3",.F.))
	SZ3->Z3_AJUFISC := cAjuste
SZ3->(MsUnlock())

If Empty(cAjuste)
	MsgInfo("Ajuste Fiscal n�o informado")
Else
	MsgInfo("Ajuste Fiscal gravado")
Endif

Return
