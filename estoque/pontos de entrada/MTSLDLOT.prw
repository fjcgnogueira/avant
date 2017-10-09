#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTSLDLOT � Autor � Fernando Nogueira  � Data � 09/10/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. para alterar o endereco solicitado para empenho       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
���          � Chamado 005291                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTSLDLOT()

Local cProduto  := ParamIXB[1]
Local cLocal    := ParamIXB[2]
Local cLoteCtl  := ParamIXB[3]
Local cNumLote  := ParamIXB[4]
Local cLocaliz  := ParamIXB[5]
Local cNumSerie := ParamIXB[6]
Local nEmpenho  := ParamIXB[7]
Local aArea     := GetArea()
Local aAreaSBF  := SBF->(GetArea())
Local lRetorno  := .T.
Local cEstFis   := ""
Local nSldSB2   := SB2->(B2_QATU-B2_QEMP-B2_QACLASS-B2_RESERVA)
Local nSldSBF   := 0
Local nSldEnd   := 0

ConOut("Ponto de Entrada: MTSLDLOT")

// Somente no caso de reserva manual
If !Empty(cLocaliz) .And. AllTrim(FunName()) $ ("MATA430")
	cEstFis := Posicione("SBF",01,xFilial("SBF")+cLocal+cLocaliz+cProduto+cNumSerie+cLoteCtl+cNumLote,"BF_ESTFIS")
	
	// Em caso de estrutura Picking
	If cEstFis = "000001"
		nSldSBF := SBF->(BF_QUANT-BF_EMPENHO)
		nSldEnd := nSldSB2 - nSldSBF
		// Se tiver saldo suficiente outros enderecos, nao pega do Picking
		If nSldEnd >= nEmpenho
			lRetorno := .F.
		Endif
	Endif

Endif

SBF->(RestArea(aAreaSBF))
RestArea(aArea)

Return lRetorno