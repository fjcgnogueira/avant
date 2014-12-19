#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DV070QTD º Autor ³ Fernando Nogueira  º Data ³ 08/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na digitacao da Quantidade de Conferencia º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DV070QTD()

	Local aRetorno	:= {}
	Local lRetorno  := PARAMIXB[1]
	Local nQtde     := PARAMIXB[2]
	Local cProduto	:= PARAMIXB[3]
	Local _cLeitura := Space(15)
	Local _cProd    := ""
	Local nPos		:= 0
	Local nQtdSys   := 0
	Local nQtdAtu   := 0
	Local aTela 	:= VTSave()
	Local aTela2    := {}
	Local nQtdLida  := 0
	Local nItem     := 1
	Local aUNI      := {}
	Local aAreaSB1  := SB1->(GetArea())
	Local nMultip   := 1
	Local lContinua := .T.
	
	Public ___cPassou
	
	ConOut("Ponto de Entrada : DV070QTD")

	aRetorno	 := Array(02)
	aRetorno[01] := lRetorno
	aRetorno[02] := nQtde
	
	If nQtde == 0 .And. Type("__aProdAtu") <> "U" .And. VTLastKey() <> 27
	
		nPos    := aSCan(__aProdAtu,{|x|x[1] == cProduto})
		nQtdSys := __aProdAtu[nPos][03]
		nQtdAtu := __aProdAtu[nPos][04]
	
		aAdd(aUNI,{"Unidade"})
		aAdd(aUNI,{"Caixa Int."})
		aAdd(aUNI,{"Caixa Ext."})
	
		VtClear()
		
		DLVTCabec()
		DLVTRodaPe("Unidade p/confer?",.F.)
		nItem := VTaBrowse(0,0,VTMaxRow()-3,VTMaxCol(),{"Unidade"},aUNI,{VTMaxCol()},,nItem)
		
		If nItem == 1
			_cLeitura := Space(15)
			_cProd    := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_CODBAR")
			nMultip   := 1
		Else
			_cLeitura := Space(15)
			If nItem == 2 
				_cProd := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_X_BARI")
			ElseIf nItem == 3
				_cProd := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_X_BAR2")
			Endif
			nMultip := SB5->(FieldGet(FieldPos("B5_EAN14"+Left(_cProd,1))))
			If nMultip == 0
				VtClear()
				VTALERT("O Multiplicador " + Left(_cProd,1) + " do produto " + AllTrim(cProduto) + " estah zerado!","AVISO",.T.,4000)
				lContinua := .F.
			Endif
		Endif
		
		If VTLastKey() <> 27 .And. lContinua
		
			While .T. 
				VtClear()
				
				_cLeitura := Space(15)
				
				@ 01,00 VTSay "Leitura:"		
				@ 02,00 VTGet _cLeitura Valid(If(AllTrim(_cLeitura) == AllTrim(_cProd),.T.,Eval({||VTALERT("Codigo Invalido!","AVISO",.T.,4000),_cLeitura := Space(15),.F.})))
				@ 03,00 VTSay "Quant.: "+StrZero(nQtdSys-nQtdAtu-nQtdLida,4)+"/"+StrZero(nQtdSys,4)
				
				VTRead
				
				If VTLastKey() == 27
					Exit
				EndIf
				
				nQtdLida += nMultip
					
			Enddo
			
			aRetorno[02] := nQtdLida
			
		Endif
		
		VTRestore(,,,,aTela)		

	ElseIf VTLastKey() <> 27
	
		aArea		:= GetArea()
		_aAreaSC9 	:= GetArea("SC9")
	
		If Empty(___cPassou)
			___cPassou := "Passou"
		Else
			___cPassou := ""
			Return aRetorno
		Endif
	
		If Type("__aProdAtu") <> "U"
	
			//-- Formato do vetor __aProdAtu
			//-- [01] = Produto
			//-- [02] = Lote
			//-- [03] = Quantidade registrada pelo sistema
			//-- [04] = Quantidade informada pelo operador
			//-- [05] = Vetor unidimensional contendo os registros do arquivo SDB
			//-- [06] = Finalizou a Conferencia
			nPos := aSCan(__aProdAtu,{|x|x[1] == cProduto})
					
			If ValType(__aProdAtu[nPos][03]) == "N" .And. ValType(__aProdAtu[nPos][04]) == "N" .And. !__aProdAtu[nPos][06]
				nQtdSys := __aProdAtu[nPos][03]
				nQtdAtu := __aProdAtu[nPos][04]+nQtde
				If SAH->AH_UNIMED == 'CX'
					nQtdSys := __aProdAtu[nPos][03] / SB1->B1_CONV
					nQtdAtu := __aProdAtu[nPos][04] / SB1->B1_CONV + nQtde 
				Endif
	
				dbSelectArea("SC9")
				dbSetOrder(9)
				dbSeek(xFilial("SC9")+SDB->DB_IDDCF)			
				If nQtdSys == nQtdAtu
					VTALERT("Conferencia Finalizada para o Produto " + cProduto,"AVISO",.T.,4000)
					__aProdAtu[nPos][06] := .T.
	
					While !Eof() .And. SC9->C9_IDDCF == SDB->DB_IDDCF .And. SC9->C9_XCONF <> 'S'
						SC9->(RecLock("SC9",.F.))
						SC9->C9_XCONF := "S"
						SC9->(MsUnLock())
						SC9->(dbSkip())
					End
	
				Else
					While !Eof() .And. SC9->C9_IDDCF == SDB->DB_IDDCF .And. SC9->C9_XCONF <> 'N'
						SC9->(RecLock("SC9",.F.))
						SC9->C9_XCONF := "N"
						SC9->(MsUnLock())
						SC9->(dbSkip())
					End
					VTALERT(AllTrim(cProduto)+": Falta "+StrZero(nQtdSys-nQtdAtu,4)+"/"+StrZero(nQtdSys,4),"AVISO",.T.,4000)
				EndIf
			EndIf
		EndIf
		
		SC9->(DBCLOSEAREA())
		
		Restarea(_aAreaSC9)
		RestArea(aArea)
		
	Endif
	
	SB1->(RestArea(aAreaSB1))
	
Return aRetorno