#INCLUDE "Protheus.CH"
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � SaldoProd    � Autor � Fernando Nogueira  � Data � 18/12/2015 ���
����������������������������������������������������������������������������͹��
���Descricao � Retorna o Saldo Disponivel do Produto                         ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                              ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function SaldoProd(cProd,cLocal)

Local aAreaSB1 := SB1->(GetArea())
Local aAreaSB2 := SB2->(GetArea())
Local nSaldo   := 0

Default cLocal := "01"

SB1->(dbSelectArea("SB1"))
SB1->(dbSetOrder(01))
If !SB1->(dbSeek(xFilial("SB1")+cProd))
	Alert("Produto n�o existe!")
	Return 0
Endif

SB2->(dbSelectArea("SB2"))
SB2->(dbSetOrder(01))
If !SB2->(dbSeek(xFilial("SB2")+SB1->B1_COD+cLocal))
	Alert("N�o tem saldo criado para esse produto!")
	Return 0
Endif

nSaldo := SaldoSb2()

SB1->(RestArea(aAreaSB1))
SB2->(RestArea(aAreaSB2))

Return nSaldo
