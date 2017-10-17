#Include "Totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT260TOK  º Autor ³ Fernando Nogueira  º Data ³ 17/10/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Anterior a Transferencia                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant - Chamado 005338                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT260TOK()

Local aArea    := GetArea()
Local aAreaSB8 := SB8->(GetArea())
Local aAreaSBF := SBF->(GetArea())
Local lRet     := .T.
Local nB8Quant := 0
Local nB8Emp   := 0
Local nBFQuant := 0
Local nBFEmp   := 0

ConOut("Ponto de Entrada: MT260TOK")

If cCodOrig = cCodDest .And. cLocOrig = cLocDest
	nB8Quant := Posicione("SB8",02,xFilial("SB8")+cNumLote+cLoteDigi+cCodOrig+cLocOrig,"B8_SALDO") - SB8->B8_QACLASS
	nB8Emp   := SB8->B8_EMPENHO 
	If nB8Quant >= nQuant260 .And. (nB8Quant - nB8Emp) < nQuant260
		SB8->(RecLock("SB8",.F.))		
			If nB8Emp >= nQuant260
				SB8->B8_EMPENHO -= nQuant260
			Else
				SB8->B8_EMPENHO := 0
			Endif
		SBF->(MsUnlock())
	Endif

	nBFQuant := Posicione("SBF",01,xFilial("SBF")+cLocOrig+cLoclzOrig+cCodOrig+cNumSerie+cLoteDigi+cNumLote,"BF_QUANT")
	nBFEmp   := SBF->BF_EMPENHO 
	If nBFQuant >= nQuant260 .And. (nBFQuant - nBFEmp) < nQuant260
		SBF->(RecLock("SBF",.F.))		
			If nBFEmp >= nQuant260
				SBF->BF_EMPENHO -= nQuant260
			Else
				SBF->BF_EMPENHO := 0
			Endif
		SBF->(MsUnlock())
	Endif
Endif

SBF->(RestArea(aAreaSBF))
SB8->(RestArea(aAreaSB8))
RestArea(aArea)

Return lRet