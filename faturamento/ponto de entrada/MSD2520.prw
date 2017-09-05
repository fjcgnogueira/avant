#INCLUDE "Protheus.ch"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � MSD2520  � Autor � Fernando Nogueira      � Data � 07/07/2014 ���
����������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado antes da Exclusao do Item da Nota  ���
���          � de Saida. Atualiza Saldo de Bonificao                         ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                              ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

User Function MSD2520()

nCredito := 0
nDebito  := 0

_aAreaSA3 := SA3->(getArea("SA3"))

SA3->(dbSeek(xFilial("SA3")+SD2->D2_X_VEND))

If AllTrim(SD2->D2_X_TPOPE) == 'VENDAS' .And. SD2->D2_X_CRVEN > 0
	nDebito := SD2->D2_X_CRVEN

	SA3->(RecLock("SA3",.F.))
		SA3->A3_ACMMKT -= nDebito
	SA3->(MsUnlock())
ElseIf AllTrim(SD2->D2_X_TPOPE) $ ('BONIFICACAO.REMESSA DOACAO') .And. SD2->D2_X_CRVEN > 0
	nCredito := SD2->D2_X_CRVEN

	SA3->(RecLock("SA3",.F.))
		SA3->A3_ACMMKT += nCredito
	SA3->(MsUnlock())
Endif

SA3->(Restarea(_aAreaSA3))

Return()
