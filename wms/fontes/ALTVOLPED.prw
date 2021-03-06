#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ALTVOLPED� Autor � Fernando Nogueira  � Data � 01/03/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Alteracao de Volume do Pedido Via Coletor.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ALTVOLPED()

	Local   aAreaSC9 := SC9->(GetArea())
	Local   aAreaSDB := SDB->(GetArea())

	Private nVolumes := 0
	Private nVolAtu	  := 0
	Private cPedido  := Space(06)
	
	VtClear()
	
	@ 01,00 VTSay "Numero do Pedido"
	@ 02,00 VTGet cPedido Valid(Validped(cPedido))
	
	VTRead
	
	If VTLastKey() == 27
		Return Nil
	EndIf
	
	VtClear()
	
	@ 01,00 VTSay "Pedido :" + SC5->C5_NUM		
	@ 02,00 VTSay "Qtd Volumes Atual"
	@ 03,00 VTGet nVolAtu When .F.
	@ 04,00 VTSay "Qtd Volumes Novo"
	@ 05,00 VTGet nVolumes Valid(nVolumes > 0)
	
	VTRead
	
	If VTLastKey() == 27
		Return Nil
	EndIf
	
	If SC5->(RecLock("SC5",.F.))
		If SC5->C5_VOLUME1 == nVolumes
			VtAlert("A quantidade de volumes eh igual, nao foi preciso alterar","Aviso",.T.,4000,3)
		Else
			SC5->C5_VOLUME1	:= nVolumes
			VtAlert("Qtd de Volumes do Pedido "+SC5->C5_NUM+" Alterada","Aviso",.T.,4000,3)
		Endif
		SC5->(MsUnlock())
	Else
		VtAlert("Registro Bloqueado","Aviso",.T.,4000,3)
	Endif
	
	SC9->(RestArea(aAreaSC9))
	SDB->(RestArea(aAreaSDB))

Return Nil

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � ValidPed  � Autor � Fernando Nogueira  � Data  � 03/06/2014 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Valida Pedido de Vendas                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function Validped(cPedido)
	Local lRetorno := .T.

	DbSelectarea("SC5")
	SC5->(DbSetorder(1))
	If !SC5->(DbSeek(xFilial("SC5") + cPedido))
		VtAlert("Pedido: " + cPedido + "Nao Encontrado","Aviso",.T.,4000,3)
		lRetorno := .F.
	Else
		nVolAtu := SC5->C5_VOLUME1
	EndIf
	
Return lRetorno