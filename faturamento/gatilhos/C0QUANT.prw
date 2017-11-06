#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C0QUANT()   � Autor � Fernando Nogueira  � Data �28/08/2017���
�������������������������������������������������������������������������͹��
���Descri��o � Gatilho do Campo C0_QUANT - Chamado 005197                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function C0QUANT(cProduto,nQuant)

Local aArea    := GetArea()
Local aAreaSB8 := SB8->(GetArea())
Local cLoteCTL := CriaVar("B8_LOTECTL")

Default nQuant   := &(Alltrim(ReadVar()))
Default cProduto := FwFldGet(Substring(Alltrim(ReadVar()),At(">",Alltrim(ReadVar()))+1,3)+"PRODUTO")

dbSelectArea("SB8")
dbSetOrder(01)
dbGoTop()
dbSeek(xFilial("SB8")+cProduto)

While SB8->(!EoF()) .And. SB8->B8_PRODUTO = cProduto
	If SB8->(B8_SALDO-B8_EMPENHO-B8_QACLASS) >= nQuant
		cLoteCTL := SB8->B8_LOTECTL
		Exit
	Endif
	SB8->(dbSkip())
End

SB8->(RestArea(aAreaSB8))
RestArea(aArea)

Return cLoteCTL
