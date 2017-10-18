#Include "Totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA260D3F  º Autor ³ Fernando Nogueira  º Data ³ 17/10/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada Apos a Transferencia                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant - Chamado 005338                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA260D3F()

Local lContinua := ParamIXB[1]
Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea())
Local aAreaSB8  := SB8->(GetArea())
Local aAreaSBF  := SBF->(GetArea())
Local aAreaSDC  := SDC->(GetArea())
Local _nQtdEmp  := 0
Local _cOrigem  := 0
Local _cProduto := 0
Local _cLocal   := 0
Local _cLoteCtl := 0
Local _cNumLote := 0
Local _cNumSeri := 0
Local _cOP      := 0
Local _cTRT     := 0
Local _cPedido  := 0
Local _cItem    := 0
Local _cSeq     := 0
Local _cIDDCF   := 0
Local cChaveDC  := ""
Local lAjuste   := .F.

If lContinua .And. IsMemVar("__nQtdB8Emp") .And. __nQtdB8Emp > 0
	Begin Transaction
		SB8->(dbGoTo(__nB8RECNO))
		If SB8->(RecLock("SB8",.F.))		
			SB8->B8_EMPENHO += __nQtdB8Emp
			SB8->(MsUnlock())
		Endif
	
		SBF->(dbGoTo(__nBFRECNO))
		If SBF->(RecLock("SBF",.F.))		
			SBF->BF_EMPENHO += __nQtdBFEmp
			SBF->(MsUnlock())
		Endif
		
		_nQtdEmp := __nQtdBFEmp
		
		// Ajustar os empenhos da DC
		While _nQtdEmp > 0
		
			// Controle de ajuste de DC
			lAjuste := .F.
			
			// Verifica se tem algum DC com endereco de origem com a mesma quantidade
			If _nQtdEmp > 0
				For _nI := 1 To Len(__aDCRECNO)
					SDC->(dbGoTo(__aDCRECNO[_nI]))
					If _nQtdEmp = SDC->DC_QUANT .And. SDC->DC_LOCALIZ <> SBF->BF_LOCALIZ
						If SDC->(RecLock("SDC",.F.))
							SDC->DC_LOCALIZ := SBF->BF_LOCALIZ
							SDC->(MsUnlock())
							_nQtdEmp := 0
							Exit
						Endif
					Endif		 		 
				Next _nI
			Endif
	
			If _nQtdEmp > 0
				For _nJ := 1 To Len(__aDCRECNO)
					SDC->(dbGoTo(__aDCRECNO[_nJ]))
					
					// Se o DC ainda nao foi ajustado vai pegar de um DC com endereco de origem com quantidade maior
					If _nQtdEmp > 0 .And. _nQtdEmp < SDC->DC_QUANT
						If SDC->(RecLock("SDC",.F.))
							SDC->DC_QUANT   -= _nQtdEmp
							SDC->DC_QTSEGUM -= _nQtdEmp/Posicione("SB1",01,xFilial("SB1")+SDC->DC_PRODUTO,"B1_CONV")
							SDC->(MsUnlock())
							_cOrigem  := SDC->DC_ORIGEM
							_cProduto := SDC->DC_PRODUTO
							_cLocal   := SDC->DC_LOCAL
							_cLoteCtl := SDC->DC_LOTECTL
							_cNumLote := SDC->DC_NUMLOTE
							_cNumSeri := SDC->DC_NUMSERI
							_cOP      := SDC->DC_OP
							_cTRT     := SDC->DC_TRT
							_cPedido  := SDC->DC_PEDIDO
							_cItem    := SDC->DC_ITEM
							_cSeq     := SDC->DC_SEQ
							_cIDDCF   := SDC->DC_IDDCF
						Endif
						
						// O empenho serah adicionado a algum DC com endereco de destino que jah tenha esse endereco
						dbSelectArea("SDC")
						dbGoTop()
						dbSetOrder(03)
						cChaveDC := xFilial("SDC")+_cProduto+_cLocal+_cLoteCtl+_cNumLote+SBF->BF_LOCALIZ+_cNumSeri
	
						If SDC->(dbSeek(cChaveDC))
							If SDC->(RecLock("SDC",.F.))
								SDC->DC_QUANT   += _nQtdEmp
								SDC->DC_QTSEGUM += _nQtdEmp/Posicione("SB1",01,xFilial("SB1")+_cProduto,"B1_CONV")
								SDC->DC_QTDORIG += _nQtdEmp
								SDC->(MsUnlock())
								_nQtdEmp := 0
							Endif							
						Endif
						
						// Caso naum tenha nenhum DC com o endereco de destino, irah criar um novo DC
						If _nQtdEmp > 0
							dbSelectArea("SDC")
							Reclock("SDC",.T.)
							Replace DC_FILIAL   With xFilial()
							Replace DC_ORIGEM   With _cOrigem
							Replace DC_PRODUTO  With _cProduto
							Replace DC_LOCAL    With _cLocal
							Replace DC_LOTECTL  With _cLoteCtl
							Replace DC_NUMLOTE  With _cNumLote
							Replace DC_LOCALIZ  With SBF->BF_LOCALIZ
							Replace DC_NUMSERI  With _cNumSeri
							Replace DC_QTDORIG  With _nQtdEmp
							Replace DC_QUANT    With _nQtdEmp
							Replace DC_QTSEGUM  With _nQtdEmp/Posicione("SB1",01,xFilial("SB1")+_cProduto,"B1_CONV")
							Replace DC_OP       With _cOP
							Replace DC_TRT      With _cTRT
							Replace DC_PEDIDO   With _cPedido
							Replace DC_ITEM     With _cItem
							Replace DC_SEQ      With _cSeq
							Replace DC_IDDCF    With _cIDDCF
							MsUnlock()
							_nQtdEmp := 0
						Endif
					ElseIf _nQtdEmp <= 0
						Exit
					Endif
				Next _nJ
			Endif
						
			// Se o DC ainda nao foi ajustado vai pegar de um endereco com quantidade menor
			If _nQtdEmp > 0
				For _nK := 1 To Len(__aDCRECNO)
					SDC->(dbGoTo(__aDCRECNO[_nK]))
					If _nQtdEmp > SDC->DC_QUANT .And. SDC->DC_LOCALIZ <> SBF->BF_LOCALIZ
						If SDC->(RecLock("SDC",.F.))
							SDC->DC_LOCALIZ := SBF->BF_LOCALIZ
							SDC->(MsUnlock())
							_nQtdEmp -= SDC->DC_QUANT
							lAjuste := .T.
							Exit
						Endif
					Endif		 		 
				Next _nK
			Endif
			
			// Se naum encontrou nenhum DC para ajustar
			If _nQtdEmp > 0 .And. !lAjuste
	
				SDC->(dbGoTo(__aDCRECNO[01]))
				_cOrigem  := SDC->DC_ORIGEM
				_cProduto := SDC->DC_PRODUTO
				_cLocal   := SDC->DC_LOCAL
				_cLoteCtl := SDC->DC_LOTECTL
				_cNumLote := SDC->DC_NUMLOTE
				_cNumSeri := SDC->DC_NUMSERI
				_cOP      := SDC->DC_OP
				_cTRT     := SDC->DC_TRT
				_cPedido  := SDC->DC_PEDIDO
				_cItem    := SDC->DC_ITEM
				_cSeq     := SDC->DC_SEQ
				_cIDDCF   := SDC->DC_IDDCF
						
				// O empenho serah adicionado a algum DC com endereco de destino que jah tenha esse endereco
				dbSelectArea("SDC")
				dbGoTop()
				dbSetOrder(03)
				cChaveDC := xFilial("SDC")+_cProduto+_cLocal+_cLoteCtl+_cNumLote+SBF->BF_LOCALIZ+_cNumSeri
	
				If SDC->(dbSeek(cChaveDC))
					If SDC->(RecLock("SDC",.F.))
						SDC->DC_QUANT   += _nQtdEmp
						SDC->DC_QTSEGUM += _nQtdEmp/Posicione("SB1",01,xFilial("SB1")+_cProduto,"B1_CONV")
						SDC->DC_QTDORIG += _nQtdEmp
						SDC->(MsUnlock())
						_nQtdEmp := 0
					Endif							
				Endif
	
				// Caso naum tenha nenhum DC com o endereco de destino, irah criar um novo DC
				If _nQtdEmp > 0
					dbSelectArea("SDC")
					Reclock("SDC",.T.)
					Replace DC_FILIAL   With xFilial()
					Replace DC_ORIGEM   With _cOrigem
					Replace DC_PRODUTO  With _cProduto
					Replace DC_LOCAL    With _cLocal
					Replace DC_LOTECTL  With _cLoteCtl
					Replace DC_NUMLOTE  With _cNumLote
					Replace DC_LOCALIZ  With SBF->BF_LOCALIZ
					Replace DC_NUMSERI  With _cNumSeri
					Replace DC_QTDORIG  With _nQtdEmp
					Replace DC_QUANT    With _nQtdEmp
					Replace DC_QTSEGUM  With _nQtdEmp/Posicione("SB1",01,xFilial("SB1")+_cProduto,"B1_CONV")
					Replace DC_OP       With _cOP
					Replace DC_TRT      With _cTRT
					Replace DC_PEDIDO   With _cPedido
					Replace DC_ITEM     With _cItem
					Replace DC_SEQ      With _cSeq
					Replace DC_IDDCF    With _cIDDCF
					MsUnlock()
					_nQtdEmp := 0
				Endif
			Endif
		End
	End Transaction
Endif

SDC->(RestArea(aAreaSDC))
SBF->(RestArea(aAreaSBF))
SB8->(RestArea(aAreaSB8))
SB1->(RestArea(aAreaSB1))
RestArea(aArea)

Return