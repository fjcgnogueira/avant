#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA60FIL  � Autor � Fernando Nogueira  � Data � 23/11/2017  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada no filtro de titulos a receber p/ bordero ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA60FIL()
Return "U_FiltroBordero()"

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � FiltroBordero � Autor � Fernando Nogueira � Data � 23/11/2017 ���
����������������������������������������������������������������������������͹��
���Desc.     � Regras para a filtragem                                       ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function FiltroBordero()

Local lReturn  := .T.
Local aArea    := GetArea()
Local aAreaSD2 := SD2->(GetArea())
Local aAreaSC5 := SC5->(GetArea())

dbSelectArea("SD2")
dbSetOrder(03)
dbGoTop()

// Fernando Nogueira - Chamado 005463
If SE1->E1_TIPO = 'NCC'
	lReturn := .F.
ElseIf dbSeek(xFilial("SD2")+SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA)
	
	dbSelectArea("SC5")
	dbSetOrder(01)
	dbGoTop()
	
	If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
		// Fernando Nogueira - Chamado 005512
		If SC5->C5_CONDPAG = '149'
			lReturn := .F.
		Endif
	Endif
Endif

SC5->(RestArea(aAreaSC5))
SD2->(RestArea(aAreaSD2))
RestArea(aArea)

Return lReturn