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
	Local aAreaSB5  := SB5->(GetArea())
	Local lContinua := .T.

	Private cProduto := PARAMIXB[3]
	Private nMultip  := 1
	Private cAlert   := ""

	Public ___cPassou

	ConOut("Ponto de Entrada : DV070QTD")

	aRetorno	 := Array(02)
	aRetorno[01] := lRetorno
	aRetorno[02] := nQtde

	If nQtde == 0 .And. Type("__aProdAtu") <> "U" .And. VTLastKey() <> 27

		nPos    := aSCan(__aProdAtu,{|x|x[1] == cProduto})
		nQtdSys := __aProdAtu[nPos][03]
		nQtdAtu := __aProdAtu[nPos][04]

		If VTLastKey() <> 27 .And. lContinua

			While .T.
				VtClear()

				_cLeitura := Space(15)

				@ 01,00 VTSay "Leitura:"
				@ 02,00 VTGet _cLeitura Valid(If(VldCodBar(AllTrim(_cLeitura)),.T.,Eval({||_cLeitura := Space(15),.F.})))
				@ 03,00 VTSay "Quant.: "+StrZero(nQtdSys-nQtdAtu-nQtdLida,5)+"/"+StrZero(nQtdSys,5)

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

				If SDB->(RecLock("SDB",.F.))
					SDB->DB_QTDLID := nQtdAtu
					SDB->(MsUnLock())
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
	SB5->(RestArea(aAreaSB5))

Return aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldCodBar() º Autor ³ Fernando Nogueira  º Data ³07/08/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida o Codigo de Barras e Define a Quantidade da Leitura º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldCodBar(cCodBar)

Local _lReturn    := .T.
Local _cCodBarras := ""

If SB1->(dbSeek(xFilial("SB1")+AllTrim(cProduto)))
	_cCodBarras := AllTrim(SB1->B1_X_BARI)+"."+AllTrim(SB1->B1_X_BAR2)+"."+AllTrim(SB1->B1_X_BARI2)+"."+AllTrim(SB1->B1_X_BARE2)

	If cCodBar == AllTrim(SB1->B1_CODBAR)
		nMultip   := 1
	ElseIf cCodBar $ _cCodBarras
		If SB5->(dbSeek(xFilial("SB5")+AllTrim(cProduto)))
			nMultip := SB5->(FieldGet(FieldPos("B5_EAN14"+Left(cCodBar,1))))
			If nMultip == 0
				vtAlert("O Multiplicador " + Left(cProduto,1) + " do produto " + AllTrim(cProduto) + " estah zerado!","AVISO",.T.,4000)
				lContinua := .F.
			Endif
		Else
			nMultip   := 0
			vtAlert("Produto sem Complemento!","AVISO",.T.,4000)
			lContinua := .F.
		Endif
	Else
		nMultip   := 0
		vtAlert("Código Inválido!","AVISO",.T.,4000)
		lContinua := .F.
	Endif
Else
	nMultip   := 0
	vtAlert("Produto Inválido!","AVISO",.T.,4000)
	lContinua := .F.
Endif

Return _lReturn
