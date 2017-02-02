#INCLUDE "Protheus.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA410   º Autor ³ Fernando Nogueira  º Data ³  16/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada na validacao da confirmacao do Pedido de  º±±
±±º          ³ Vendas                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA410()

Local nPosTot    := aScan(aHeader,{|x|Trim(x[2])=="C6_VALOR"})
Local nPosProd   := aScan(aHeader,{|x|Trim(x[2])=="C6_PRODUTO"})
Local nPosCF     := aScan(aHeader,{|x|Trim(x[2])=="C6_CF"})
Local nPosPrc    := aScan(aHeader,{|x|Trim(x[2])=="C6_PRCVEN"})
Local nPosTot    := aScan(aHeader,{|x|Trim(x[2])=="C6_VALOR"})
Local nPosTes    := aScan(aHeader,{|x|Trim(x[2])=="C6_TES"})
Local cEOL       := Chr(13)+Chr(10)
Local lReturn    := .T.
Local aImpostos  := {}
Local cDuplic    := ''
Local nSomaTot   := 0
Local nVlrFrete  := 0
Local aAreaSA1   := SA1->(GetArea())
Local aAreaSB1   := SB1->(GetArea())
Local aAreaSF4   := SF4->(GetArea())
Local aAreaSX5   := SX5->(GetArea())
Local aAreaSA3   := SA3->(GetArea())
Local cEstFrete  := Posicione("SX5",1,xFilial("SX5")+"ZA"+"0002","X5_DESCRI")
Local cEstado    := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
Local cPessoa    := SA1->A1_PESSOA
Local cHabFrete  := SA1->A1_X_HBFRT
Local lFlag      := .F.
Local cCliente   := M->C5_CLIENTE
Local cLojaCli   := M->C5_LOJACLI
Local cVend      := M->C5_VEND1
Local nFrete     := M->C5_FRETE
Local nTotPed    := 0
Local nPrcVen    := 0
Local _nItens    := 0
Local nDescSuf   := 0
Local _cC5xTot   := PesqPict("SC5","C5_XTOTPED")
Local lBonif     := .F.

// Pedido Diferente de Dev.Compras e Beneficiamento
If !(M->C5_TIPO $ 'BD')
	If Inclui .Or. Altera
		For nI := 1 to Len(aCols)
			If !aCols[nI,Len(aHeader)+1]
				If nI == 1
					If Posicione("SB1",1,xFilial("SB1")+aCols[nI][nPosProd],"B1_UTLCOMS") == "N"
						lFlag := .T.
					Endif
				Else
					If Posicione("SB1",1,xFilial("SB1")+aCols[nI][nPosProd],"B1_UTLCOMS") <> Posicione("SB1",1,xFilial("SB1")+aCols[nI-1][nPosProd],"B1_UTLCOMS")
						MsgAlert('Existe conflito de produtos que geram comissão com produtos que não geram! Será necessário fazer pedidos separados.', 'Atenção')
						Return .F.
					Endif
				EndIf
				// Bonificacao (910) e Troca (949) nao entram na regra
				If !(Right(AllTrim(aCols[nI,nPosCF]),3) $ "910.949")
					nSomaTot += aCols[nI,nPosTot]
				Else
					// Verifica se o Pedido eh de Bonificacao ou Troca
					lBonif := .T.
				EndIf
			Endif
		Next nI

		If lFlag
			M->C5_VEND1  := Space(6)
			M->C5_VEND2  := Space(6)
			M->C5_COMIS1 := 0
			M->C5_COMIS2 := 0
		Endif

		If nSomaTot > 0 .And. nSomaTot < 1500 .And. cEstado $ cEstFrete .And. M->C5_TPFRETE == "C" .And. cPessoa <> "F" .And. cHabFrete == "S"
			nVlrFrete := Val(Substr(cEstFrete,At(cEstado,cEstFrete)+2,6))/100
		Endif

		// Definir o Valor do Frete
		If cHabFrete == "S"
			M->C5_FRETE := nVlrFrete
		Else
			M->C5_FRETE := 0
		Endif
	Endif

	If lReturn .And. (Inclui .Or. Altera)
		// Quantidade de itens do Pedido
		For _n := 1 To Len(aCols)
			If !aCols[_n][Len(aHeader)+1]
				_nItens++
			Endif
		Next _n

		// Faz uma varredura no aCols
		For _n := 1 to Len(aCols)
			nDescSuf  := 0

			// Caso a linha nao esteja deletada
			If !aCols[_n,Len(aHeader)+1]

				// Chamado 001447 - Fernando Nogueira
				If !Empty(cDuplic) .And. cDuplic <> Posicione('SF4',1,xFilial('SF4')+aCols[_n][nPosTes],'F4_DUPLIC')
					ApMsgAlert('Incompatibilidade de Geração de Duplicatas!'+cEOL+'Item que gera duplicata e item que não gera.')
					ConOut('Incompatibilidade de Geração de Duplicatas!'+cEOL+'Item que gera duplicata e item que não gera.')
					SA1->(RestArea(aAreaSA1))
					SB1->(RestArea(aAreaSB1))
					SF4->(Restarea(aAreaSF4))
					SX5->(Restarea(aAreaSX5))
					SA3->(Restarea(aAreaSA3))
					Return .F.
				EndIf
				cDuplic := Posicione('SF4',1,xFilial('SF4')+aCols[_n][nPosTes],'F4_DUPLIC')

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


					nPrcVen	:= aCols[_n][nPosTot]

					//Adiciona o Produto para Calculo dos Impostos
					nItem := 	MaFisAdd(	aCols[_n][nPosProd]		,;   	// 1-Codigo do Produto ( Obrigatorio )
											aCols[_n][nPosTes]		,;	   	// 2-Codigo do TES ( Opcional )
											1						,;	   	// 3-Quantidade ( Obrigatorio )
											aCols[_n][nPosPrc]		,;   	// 4-Preco Unitario ( Obrigatorio )
											0						,;  	// 5-Valor do Desconto ( Opcional )
											""						,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
											""						,;		// 7-Serie da NF Original ( Devolucao/Benef )
											0						,;		// 8-RecNo da NF Original no arq SD1/SD2
											nFrete/_nItens          ,;		// 9-Valor do Frete do Item ( Opcional )
											0						,;		// 10-Valor da Despesa do item ( Opcional )
											0						,;		// 11-Valor do Seguro do item ( Opcional )
											0						,;		// 12-Valor do Frete Autonomo ( Opcional )
											aCols[_n][nPosTot]		,;		// 13-Valor da Mercadoria ( Obrigatorio )
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
					If !lBonif
						nTotFrete   := MaFisRet(NIL, "NF_FRETE")
						If nTotFrete > 0
							nPrcVen += nTotFrete
						Endif
					Endif

					//Finaliza Funcao Fiscal
					MaFisEnd()

					nTotPed += nPrcVen

				EndIf
			Endif	
		Next _n

		// Bloqueia se o Pedido for de Bonificacao e o Valor do Pedido com Impostos for maior que o Credito do Vendedor
		If lBonif .And. nTotPed > Posicione("SA3",1,xFilial("SA3")+cVend,"A3_ACMMKT")
			MsgInfo('Valor com impostos do Pedido ('+AllTrim(Transform(nTotPed, _cC5xTot))+') maior que o saldo em crédito de marketing do vendedor ('+AllTrim(Transform(SA3->A3_ACMMKT, _cC5xTot))+') !', 'Atenção')
			lReturn := .F.
		Endif
	Endif
Endif

SA1->(RestArea(aAreaSA1))
SB1->(RestArea(aAreaSB1))
SF4->(Restarea(aAreaSF4))
SX5->(Restarea(aAreaSX5))
SA3->(Restarea(aAreaSA3))

Return lReturn
