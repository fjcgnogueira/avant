#INCLUDE "Protheus.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410LIOK º Autor ³ Fernando Nogueira  º Data ³  28/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada na validacao de linha do Pedido de Vendas.º±±
±±º          ³ Chamado 000022.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M410LIOK()

Local cEOL       := Chr(13)+Chr(10)
Local lReturn    := .T.
Local nPosQtdVen := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDVEN"})
Local nPosQtdLib := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDLIB"})
Local nPosLocal  := aScan(aHeader,{|x|Trim(x[2])=="C6_LOCAL"})
Local nPosOper   := aScan(aHeader,{|x|Trim(x[2])=="C6_OPER"})
Local nPosProd   := aScan(aHeader,{|x|Trim(x[2])=="C6_PRODUTO"})
Local nPosTes    := aScan(aHeader,{|x|Trim(x[2])=="C6_TES"})
Local nPosServic := aScan(aHeader,{|x|Trim(x[2])=="C6_SERVIC"})
Local nPosEndPad := aScan(aHeader,{|x|Trim(x[2])=="C6_ENDPAD"})
Local nPosPrc    := aScan(aHeader,{|x|Trim(x[2])=="C6_PRCVEN"})
Local nPosTot    := aScan(aHeader,{|x|Trim(x[2])=="C6_VALOR"})
Local nPosCF     := aScan(aHeader,{|x|Trim(x[2])=="C6_CF"})
Local cDuplic    := ''
Local nTotPed    := 0
Local aImpostos  := {}
Local aAreaSA1   := SA1->(GetArea())
Local aAreaSF4   := SF4->(GetArea())
Local aAreaSA3   := SA3->(GetArea())
Local cCliente   := M->C5_CLIENTE
Local cLojaCli   := M->C5_LOJACLI
Local cVend      := M->C5_VEND1
Local nFrete     := M->C5_FRETE
Local nPrcVen    := 0
Local _nItens    := 0
Local nDescSuf   := 0
Local _cC5xTot   := PesqPict("SC5","C5_XTOTPED")
Local lBonif     := .F.
Local lEstoque   := .F.

If aCols[n][nPosQtdLib] > 0 .And. aCols[n][nPosQtdVen] > aCols[n][nPosQtdLib]
	MsgInfo('Não é permitido liberação parcial!', 'Atenção')
	lReturn := .F.
ElseIf AllTrim(aRotina[3][2]) <> 'A410Copia' .And. Inclui .And. Empty(aCols[n][nPosOper]) .And. !aCols[n][Len(aHeader)+1]
	MsgInfo('Obrigatório o preenchimento do Tipo de Operação!', 'Atenção')
	lReturn := .F.
ElseIf Empty(M->C5_CLIENTE)
	MsgInfo('Necessário definir o Cliente antes de Incluir uma Linha!', 'Atenção')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf Empty(M->C5_TRANSP)
	MsgInfo('Necessário definir a Transportadora antes de Incluir uma Linha!', 'Atenção')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf !Empty(aCols[n][nPosServic]) .And. Empty(aCols[n][nPosEndPad]) //Fernando Nogueira - Chamado 002385
	MsgInfo('Necessário definir o End. Destino!', 'Atenção')
	lReturn := .F.
Endif


If lReturn .And. n <> 1 .AND. !aCols[n,Len(aHeader)+1]
	If Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosProd],"B1_UTLCOMS") <> Posicione("SB1",1,xFilial("SB1")+aCols[n-1][nPosProd],"B1_UTLCOMS")
		MsgAlert('Existe conflito de produtos que geram comissão com produtos que não geram! Será necessário fazer pedidos separados.', 'Atenção')
		lReturn := .F.
	Endif
Endif

If lReturn
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
		
			// Verifica se o Pedido eh de Bonificacao
			If !lBonif .And. Right(AllTrim(aCols[_n][nPosCF]),3) == '910'
				lBonif := .T.
			Endif

			// Verifica se a Tes Controla Estoque
			If Posicione('SF4',1,xFilial('SF4')+aCols[_n][nPosTes],'F4_ESTOQUE') == "S"
				lEstoque := .T.
			Endif

			// Chamado 001447 - Fernando Nogueira
			If !Empty(cDuplic) .And. cDuplic <> Posicione('SF4',1,xFilial('SF4')+aCols[_n][nPosTes],'F4_DUPLIC')
				ApMsgAlert('Incompatibilidade de Geração de Duplicatas!'+cEOL+'Item que gera duplicata e item que não gera.')
				ConOut('Incompatibilidade de Geração de Duplicatas!'+cEOL+'Item que gera duplicata e item que não gera.')
				SA1->(Restarea(aAreaSA1))
				SF4->(Restarea(aAreaSF4))
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
							"MATA410"		,;		// 10-Nome da rotina que esta utilizando a funcao
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
				nTotFrete   := MaFisRet(NIL, "NF_FRETE")
				If nTotFrete > 0
					nPrcVen += nTotFrete
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

//If AllTrim(SM0->M0_CODFIL) == "010104" .And. aScan(PswRet(1)[1][10],'000057') == 0 .And. aCols[n][nPosLocal] <> '01'
//	MsgInfo('Estoque diferente de "01" somente é permitido aos usuários de logística!', 'Atenção')
//	lReturn := .F.
//Endif

// Verifica se a quantidade liberada eh maior que o saldo disponivel em estoque na inclusao do Pedido de Vendas
If lReturn .And. Inclui .And. lEstoque .And. aCols[n][nPosQtdLib] > U_SaldoProd(aCols[n][nPosProd])
	MsgInfo('Quantidade liberada do produto '+AllTrim(aCols[n][nPosProd])+' maior que o saldo disponível em estoque!', 'Atenção')
	lReturn := .F.
Endif

SA1->(Restarea(aAreaSA1))
SF4->(Restarea(aAreaSF4))
SA3->(Restarea(aAreaSA3))

/*If (aCols[n][nPosOper]$"6,51,06") .And. !IsBlind()
	lReturn := .T.
Else
	MsgInfo('Não é permitido usar esse Tipo de Operação!', 'Atenção')
	lReturn := .F.
EndIf*/
		
Return lReturn