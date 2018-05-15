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
	Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
	Local nPosQuan 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local nPosPrc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
	Local nPosTot	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
	Local nPosCom	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_COMIS1"})
	Local nPosCF	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"})
	Local nPosLoc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
	Local lBonif	:= .F.

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
	Local nLimite   := SA1->A1_X_VLVEN

	Local aAreaAT	:= GetArea()
	Local aAreaC5	:= SC5->(GetArea())
	Local aAreaA1	:= SA1->(GetArea())
	
	Local _nPISCOF  := GetMV("MV_PISCOF")
	Local _nFrete   := 0                                                                                                                                                                                                                                                   
	Local _nComis   := 0
	Local _nICMS    := GetMV("MV_XICMS")
	Local _nDespesa := GetMV("MV_DESPESA")
	Local _aAreaSB2 := SB2->(GetArea())
	Local _nCusto   := 0
	Local _nMargem  := 0
	Local nPosICC   := 0
	Local nPosDIF   := 0
	Local nVlrICC   := 0
	Local nVlrDIF   := 0	
	Local _aAreaC09	 := C09->(GetArea())
	Local _cProduto := ""
	Local _cLocal   := ""

	// Pedido Diferente de Dev.Compras e Beneficiamento
	If !(M->C5_TIPO $ 'BD')

		If nOpc == 3 .Or. nOpc == 4

			// Fernando Nogueira - Quantidade de itens do Pedido
			For _nX := 1 To Len(aCols)
				If !aCols[_nX][Len(aHeader)+1]
					nSomaTot += aCols[_nX,nPosTot]
					
					 _cProduto := aCols[_nX][nPosProd]
					 _cLocal   := aCols[_nX][nPosLoc]
					
					SB2->(dbSetOrder(1))
					SB2->(dbGoTop())
					SB2->(dbSeek(xFilial("SB2")+_cProduto+_cLocal))
					
					_nCusto += SB2->B2_CM1 * aCols[_nX,nPosQuan]
					_nComis += aCols[_nX,nPosTot] * (aCols[_nX,nPosCom]/100)
		
					// Fernando Nogueira - Chamado 004231
					If !lBonif .And. (Right(AllTrim(aCols[_nX,nPosCF]),3) $ "910.949")
						lBonif := .T.
					Endif
					_nItens++
				Endif
			Next _nX

			// Fernando Nogueira - Chamado 002751
			If nSomaTot > 0 .And. nSomaTot < nLimite .And. cEstado $ cEstFrete .And. M->C5_TPFRETE == "C" .And. cPessoa <> "F" .And. nFrete == 0 .And. cHabFrete == "S" .And. !lBonif
				nFrete := Val(Substr(cEstFrete,At(cEstado,cEstFrete)+2,6))/100
			Endif

			M->C5_FRETE := nFrete

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
							
							nPosICC		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICC"})
							nPosDIF		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "DIF"})

							If nPosRet > 0
								nPrcVen	:= nPrcVen + aImpostos[nPosRet][05]
							EndIf

							If nPosIPI > 0
								nPrcVen	:= nPrcVen + aImpostos[nPosIPI][05]
							EndIf
							
							If nPosICC > 0
								nVlrICC	+= aImpostos[nPosICC][05]
							EndIf
							
							If nPosDIF > 0
								nVlrDIF	+= aImpostos[nPosDIF][05]
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
				/*If A410Recalc()
					Conout("Reprocesso do C5_CONDPAG ok! Pedido:" + M->C5_NUM )
				Else
					Conout("Erro no A410Recalc - Pedido: " + M->C5_NUM )
				EndIf*/
			Else
				Conout("Erro no MaVldTabPrc - Pedido: " + M->C5_NUM )
			EndIf
	    Else
	    	Conout("Condicao nao encontrada - Pedido: " + M->C5_NUM + " - Condicao: " + M->C5_CONDPAG )
	    EndIf

	Endif
	
	
//MARGEM PEDIDO	

		If M->C5_FRETE = 0
			C09->(dbSetOrder(1))
			C09->(dbGoTop())
			C09->(dbSeek(xFilial("C09")+cEstado))
	
			If cEstado == 'SP'
				_nFrete := nSomaTot * 0.028
			Else
				_nFrete := (nSomaTot * ((10 - C09->C09_PFRETE)/100))
			EndIf
		Else
			_nFrete := M->C5_FRETE
		EndIf
	
	_nMargem := (nSomaTot - ( _nCusto + (nSomaTot * _nPISCOF) + (nSomaTot * _nDespesa) + _nFrete + (nSomaTot * _nICMS) + _nComis + nVlrICC + nVlrDIF ) ) / nSomaTot
	
/*	Alert("Total: "+ cValToChar(nSomaTot) +Chr(13)+Chr(10)+ ;
		  "Custo: "+ cValToChar(_nCusto) +Chr(13)+Chr(10)+ ;
		  "PIS COFINS: "+ cValToChar(nSomaTot * _nPISCOF) +Chr(13)+Chr(10)+ ; 
		  "Despesa: "+ cValToChar(nSomaTot * _nDespesa) +Chr(13)+Chr(10)+ ;
		  "Frete: "+ cValToChar(_nFrete) +Chr(13)+Chr(10)+ ;
		  "ICMS: "+ cValToChar(nSomaTot * _nICMS) +Chr(13)+Chr(10)+ ; 
		  "Comis: "+ cValToChar(_nComis) +Chr(13)+Chr(10)+ ;
		  "DIFAL 1: "+ cValToChar(nVlrICC) +Chr(13)+Chr(10)+ ; 
		  "DIFAL 2: "+ cValToChar(nVlrDIF) )*/
	
	
	M->C5_XMARGEM := _nMargem*100
	

//MARGEM PEDIDO	

	RestArea(aAreaAT)
	RestArea(aAreaA1)
	RestArea(aAreaC5)
	SB2->(RestArea(_aAreaSB2))
	C09->(RestArea(_aAreaC09))
	
Return lRetorno
