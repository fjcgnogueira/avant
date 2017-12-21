#INCLUDE "Protheus.CH"

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MT410CPY � Autor � Fernando Nogueira  � Data � 21/11/2014 ���
������������������������������������������������������������������������͹��
���Descricao � Alteracao do acols e de variaveis da enchoice antes da    ���
���          � copia do Pedido de Vendas.                                ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/

User Function MT410CPY()

Local aAreaSA4   := SA4->(GetArea())
Local nPosTES    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
Local nPosCFOP   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"})
Local nPosENDPAD := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ENDPAD"})
Local nPosLote   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOTECTL"})
Local cTamTES    := Space(TamSx3("C6_TES")[1])
Local cTamCFOP   := Space(TamSx3("C6_CF")[1])
Local cTamLote   := Space(TamSx3("C6_LOTECTL")[1])
Local cENDPAD    := Posicione("SA4",1,xFilial("SA4")+M->C5_TRANSP,"A4_X_DOCA")  // Fernando Nogueira - Chamado 004344

// Fernando Nogueira - Chamado 001857
For J := 1 To Len(aCols)
	aCols[J,nPosTES]    := cTamTES
	aCols[J,nPosCFOP]   := cTamCFOP
	aCols[J,nPosENDPAD] := cENDPAD
	aCols[J,nPosLote]   := cTamLote
Next J

M->C5_VOLUME1 := 0
M->C5_PEDWEB  := 0

SA4->(RestArea(aAreaSA4))

Return
