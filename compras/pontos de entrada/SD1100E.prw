#INCLUDE "Protheus.ch"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � SD1100E  � Autor � Fernando Nogueira      � Data � 09/07/2014 ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado antes da Exclusao do Item da Nota  ���
���          � de Entrada. Atualiza Saldo de Bonificao                       ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                              ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

User Function SD1100E()

nCredito := 0
nDebito  := 0

_aAreaSA3 := SA3->(getArea("SA3"))

If SA3->(dbSeek(xFilial("SA3")+SD1->D1_X_VEND))

	If AllTrim(SD1->D1_X_TPOPE) == 'DVVENDAS' .And. SD1->D1_X_DBVEN > 0
		nCredito := SD1->D1_X_DBVEN

		SA3->(RecLock("SA3",.F.))
			SA3->A3_ACMMKT += nCredito
		SA3->(MsUnlock())
	ElseIf AllTrim(SD1->D1_X_TPOPE) $ ('DVBONIFICACAO.DVDOACAO') .And. SD1->D1_X_DBVEN > 0
		nDebito := SD1->D1_X_DBVEN

		SA3->(RecLock("SA3",.F.))
			SA3->A3_ACMMKT -= nDebito
		SA3->(MsUnlock())
	Endif

Endif

SA3->(Restarea(_aAreaSA3))

Return()
