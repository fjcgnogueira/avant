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
Local aAreaSDC := SDC->(GetArea())
Local lRet     := .T.
Local nB8Quant := 0
Local nB8Emp   := 0
Local nBFQuant := 0
Local nBFEmp   := 0
Local cChaveDC := ""

// Variaveis serao utilizadas no Ponto de Entrada MA260D3F
Public __nQtdB8Emp := 0  // Quantidade de Empenho do B8 Transferido
Public __nQtdBFEmp := 0  // Quantidade de Empenho do BF Transferido
Public __nB8RECNO  := 0  // Recno do SB8
Public __nBFRECNO  := 0  // Recno do SBF de Destino
Public __aDCRECNO  := {} // Array com o(s) Recno(s) do SDC

If cCodOrig = cCodDest .And. cLocOrig = cLocDest

	ConOut("Ponto de Entrada: MT260TOK")

	Begin Transaction
		nB8Quant := Posicione("SB8",02,xFilial("SB8")+cNumLote+cLoteDigi+cCodOrig+cLocOrig,"B8_SALDO") - SB8->B8_QACLASS
		nB8Emp   := SB8->B8_EMPENHO
		__nB8RECNO := SB8->(Recno())
		If nB8Quant >= nQuant260 .And. (nB8Quant - nB8Emp) < nQuant260
			If SB8->(RecLock("SB8",.F.))		
				If nB8Emp >= nQuant260
					__nQtdB8Emp     := nQuant260
					SB8->B8_EMPENHO -= nQuant260
				Else
					__nQtdB8Emp     := SB8->B8_EMPENHO
					SB8->B8_EMPENHO := 0
				Endif
				SB8->(MsUnlock())
			Endif
		Endif
		
		__nBFRECNO := Posicione("SBF",01,xFilial("SBF")+cLocDest+cLoclzDest+cCodDest+cNumSerie+cLoteDigi+cNumLote,"RECNO()")
		
		nBFQuant := Posicione("SBF",01,xFilial("SBF")+cLocOrig+cLoclzOrig+cCodOrig+cNumSerie+cLoteDigi+cNumLote,"BF_QUANT")
		nBFEmp   := SBF->BF_EMPENHO 
		If nBFQuant >= nQuant260 .And. (nBFQuant - nBFEmp) < nQuant260
			If SBF->(RecLock("SBF",.F.))		
				If nBFEmp >= nQuant260
					__nQtdBFEmp     := nQuant260
					SBF->BF_EMPENHO -= nQuant260
				Else
					__nQtdBFEmp     := SBF->BF_EMPENHO
					SBF->BF_EMPENHO := 0
				Endif
				SBF->(MsUnlock())
			Endif
		Endif
		
		dbSelectArea("SDC")
		dbGoTop()
		dbSetOrder(03)
		cChaveDC := xFilial("SDC")+cCodOrig+cLocOrig+cLoteDigi+cNumLote+cLoclzOrig+cNumSerie
		
		If SDC->(dbSeek(cChaveDC))
			While !Eof() .And. SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI) = cChaveDC
				Aadd(__aDCRECNO,SDC->(Recno()))
				SDC->(dbSkip())
			End
		Endif
	End Transaction
Endif

SDC->(RestArea(aAreaSDC))
SBF->(RestArea(aAreaSBF))
SB8->(RestArea(aAreaSB8))
RestArea(aArea)

Return lRet