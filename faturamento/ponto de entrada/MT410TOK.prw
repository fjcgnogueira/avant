#Include "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT410TOK ³ Autor ³ Amedeo D. P. Filho    ³ Data ³ 25/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ponto de Entrada - Atualiza Valor total do pedido com      ³±±
±±³          ³ Impostos.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Utilizacao³ AVANT                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT410TOK()
	Local lRetorno 	:= .T.
	Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local nPosTes  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
	Local nPosQuan 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
	Local nPosTot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
	Local nOpc    	:= PARAMIXB[1]
	Local cCliente	:= M->C5_CLIENTE
	Local cLojaCli	:= M->C5_LOJACLI
	Local nFrete	:= M->C5_FRETE
	Local cEstFrete	:= Posicione("SX5",1,xFilial("SX5")+"ZA"+"0002","X5_DESCRI")
	Local cEstado 	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
	Local cHabFrete	:= SA1->A1_X_HBFRT
	Local cPessoa	:= SA1->A1_PESSOA
	Local nSomaTot	:= 0
	Local aImpostos	:= {}
	Local nValIPI	:= 0
	Local nValSol	:= 0
	Local nPrcVen	:= 0
	Local nTotPed	:= 0
	Local nX		:= 0
	Local nDescSuf 	:= 0
	Local _nItens 	:= 0
	Local nTeste 	:= 0

	Local aAreaAT	:= GetArea()
	Local aAreaC5	:= SC5->(GetArea())
	Local aAreaA1	:= SA1->(GetArea())

	If nOpc == 3 .Or. nOpc == 4

		// Fernando Nogueira - Quantidade de itens do Pedido
		For _nX := 1 To Len(aCols)
			If !aCols[_nX][Len(aHeader)+1]
				nSomaTot += aCols[_nX,nPosTot]
				_nItens++
			Endif
		Next _nX

		// Fernando Nogueira - Chamado 002751
		If nSomaTot > 0 .And. nSomaTot < 1500 .And. cEstado $ cEstFrete .And. M->C5_TPFRETE == "C" .And. cPessoa <> "F" .And. nFrete == 0 .And. cHabFrete == "S"
			nFrete := Val(Substr(cEstFrete,At(cEstado,cEstFrete)+2,6))/100
		Endif

		For nX := 1 To Len(aCols)
			If !aCols[nX][Len(aHeader)+1]

				DbSelectarea("SA1")
				SA1->(DbSetorder(1))
				If SA1->(DbSeek(xFilial("SA1") + cCliente + cLojaCli))

					MaFisIni(	SA1->A1_COD		,;		// 01-Codigo Cliente
								SA1->A1_LOJA	,;		// 02-Loja do Cliente
								"C"				,;		// 03-C:Cliente , F:Fornecedor
								"N"				,;		// 04-Tipo da NF
								SA1->A1_TIPO	,;		// 05-Tipo do Cliente
								Nil				,;		// 06-Relacao de Impostos que suportados no arquivo
								Nil				,;		// 07-Tipo de complemento
								Nil				,;		// 08-Permite Incluir Impostos no Rodape .T./.F.
								"SB1"			,;		// 09-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
								"MATA461"		,;		// 10-Nome da rotina que esta utilizando a funcao
								Nil				,;		// 11-Tipo de documento
								Nil				,;		// 12-Especie do documento
								Nil				,;		// 13-Codigo e Loja do Prospect
								SA1->A1_GRPTRIB,;		// 14-Grupo Cliente
								Nil				,;		// 15-Recolhe ISS
								Nil				,;		// 16-Codigo do cliente de entrega na nota fiscal de saida
								Nil				,;		// 17-Loja do cliente de entrega na nota fiscal de saida
								Nil				)		// 18-Informacoes do transportador [01]-UF,[02]-TPTRANS


					nPrcVen	:= aCols[nX][nPosTot]

					//Adiciona o Produto para Calculo dos Impostos
					nItem := 	MaFisAdd(	aCols[nX][nPosProd]		,;   	// 1-Codigo do Produto ( Obrigatorio )
											aCols[nX][nPosTes]		,;	   	// 2-Codigo do TES ( Opcional )
											1						,;	   	// 3-Quantidade ( Obrigatorio )
											aCols[nX][nPosPrc]		,;   	// 4-Preco Unitario ( Obrigatorio )
											0						,;  	// 5-Valor do Desconto ( Opcional )
											""						,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
											""						,;		// 7-Serie da NF Original ( Devolucao/Benef )
											0						,;		// 8-RecNo da NF Original no arq SD1/SD2
											nFrete*(aCols[nX][nPosTot]/nSomaTot),;	// 9-Valor do Frete do Item ( Opcional )
											0						,;		// 10-Valor da Despesa do item ( Opcional )
											0						,;		// 11-Valor do Seguro do item ( Opcional )
											0						,;		// 12-Valor do Frete Autonomo ( Opcional )
											aCols[nX][nPosTot]		,;		// 13-Valor da Mercadoria ( Obrigatorio )
											0						,;		// 14-Valor da Embalagem ( Opiconal )
											NIL						,;		// 15-RecNo do SB1
											NIL						,;		// 16-RecNo do SF4
											NIL						)

					aImpostos	:= MafisRet(NIL, "NF_IMPOSTOS")
					If Len(aImpostos) > 0
						nPosRet		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICR"})
						nPosIPI		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "IPI"})

						If nPosRet > 0
							nPrcVen	:= nPrcVen + aImpostos[nPosRet][05]
						EndIf

						If nPosIPI > 0
							nPrcVen	:= nPrcVen + aImpostos[nPosIPI][05]
						EndIf

						If SA1->A1_CALCSUF = 'S'
							nDescSuf := MafisRet(,"IT_DESCZF")
							nPrcVen  := nPrcVen - nDescSuf
						Endif

					EndIf

					// Fernando Nogueira - Somar o valor do Frete no Calculo dos Impostos
					nTotFrete   := MaFisRet(NIL, "NF_FRETE")
					If nTotFrete > 0
						nPrcVen += nTotFrete
					Endif

					//Finaliza Funcao Fiscal
					MaFisEnd()

					nTotPed += nPrcVen

				EndIf

			EndIf

		Next nX

		//Coloca o preco pra ser gravado
		If nTotPed > 0
			M->C5_XTOTPED := nTotPed
		EndIf

	EndIf

	// Mauro - 17/09/12 - Revalidacoes da condicao de pagamento
	DbSelectArea("SE4")
	DbSetOrder(1)
	If SE4->(DbSeek(xFilial("SE4") + M->C5_CONDPAG ) )
		If MaVldTabPrc(M->C5_TABELA,M->C5_CONDPAG,,M->C5_EMISSAO)
			If A410Recalc()
				Conout("Reprocesso do C5_CONDPAG ok! Pedido:" + M->C5_NUM )
			Else
				Conout("Erro no A410Recalc - Pedido: " + M->C5_NUM )
			EndIf
		Else
			Conout("Erro no MaVldTabPrc - Pedido: " + M->C5_NUM )
		EndIf
    Else
    	Conout("Condicao nao encontrada - Pedido: " + M->C5_NUM + " - Condicao: " + M->C5_CONDPAG )
    EndIf

	RestArea(aAreaAT)
	RestArea(aAreaA1)
	RestArea(aAreaC5)

Return lRetorno
