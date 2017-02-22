#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INTPEDIDO º Autor ³ Amedeo D. P. Filho º Data ³  21/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de Integracao de Pedidos.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INTPEDIDO(cEmpInt, cFilInt, cPedWeb, cMensagem, cDocumen, lAutomatic)

Local aTabelas		:= {"SA1","SC5","SC6","SC9"}
Local cPathLog		:= SuperGetMV("AV_LOGWEB", Nil, "\LOGS\")
Local cFileLog		:= "MATA410.LOG"
Local cModulo		:= "FAT"
Local cAliasC5		:= GetNextAlias()
Local cPedidoW		:= PadL(Alltrim(cPedWeb),TamSx3("Z3_NPEDWEB")[01])
Local cFilial   	:= SZ3->Z3_FILIAL
Local lRetorno		:= .T.
Local cPedNew		:= ""
Local cArmazem		:= "01"
Local cTES   		:= "990"
Local dDtEmiss		:= CtoD("")
Local cCodPag   	:= SuperGetMv("MV_XPEDPAG",.F.,"149") //-- Parametro para informar condições de pagamento que bloqueiam a liberação automática -- Gustavo Viana -- 18/02/2013
Local aCabec 		:= {}
Local aItens 		:= {}
Local aLinha 		:= {}
Local lLibera   	:= .T.
Local aTesInt   	:= {}
Local cTesOper 		:= ""
Local nPrcOri		:= 0
Local nPosProd		:= 0
Local nPosQtdVen	:= 0
Local nPosPrcVen	:= 0
Local aTesSaida		:= {}
Local aImpostos		:= {}
Local nDescSuf   	:= 0
Local nTotBonif    	:= 0
Local _cSA3Cred 	:= PesqPict("SC6","C6_VALOR")
Local cEnter	    := '<br />'
Local lBlqNCM		:= .F.
Local lBlqFis		:= .F.
Local lBlqIcmRet	:= .F.

Private cTpOper		:= ""
Private lMsErroAuto	:= .F.
Private lLiberAut 	:= .T.      //-- Se campo C6_QTDLIB serah preenchido no processo de inclusao -- Gustavo Viana -- 18/02/2013
Private cCod      	:= ""
Private cLocal    	:= "01"
Private nQuant    	:= 0

Default lAutomatic	:= .F.
Default cMensagem  := ""

If lAutomatic
	RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmpInt, cFilInt, Nil, Nil, cModulo, Nil, aTabelas, Nil, Nil, Nil, Nil)
EndIf

//Verifica se Pedido WEB ja esta no SC5 (Pedido Protheus)
BeginSQL Alias cAliasC5
	SELECT	R_E_C_N_O_	AS RECC5
	FROM	%Table:SC5%
	WHERE	%NotDel%
	AND		C5_PEDWEB = %Exp:cPedidoW%
	AND 	C5_FILIAL = %Exp:xFilial("SC5")%
EndSQL

If !(cAliasC5)->(Eof())
	lRetorno 	:= .F.
	cMensagem	:= "Atenção: Erro ao processar seu pedido; Informe T.I codigo:01-Pedido WEB já cadastrado no Protheus Nro(s)"

	While !(cAliasC5)->(Eof())
		DbSelectarea("SC5")
		SC5->(DbGoto( (cAliasC5)->RECC5 ))
		cMensagem += " - " + SC5->C5_NUM
		(cAliasC5)->(DbSkip())
	Enddo
EndIf

(cAliasC5)->(DbCloseArea())

If lRetorno
	DbSelectarea("SA3")
	DbSelectarea("SZ3")
	SZ3->(DbSetorder(1))
	If SZ3->(DbSeek(xFilial("SZ3") + cPedidoW))
		If SZ3->Z3_STATUS <> "P"
			lRetorno 	:= .F.
			cMensagem	:= "Pedido: " + cPedidoW + " Está com Status " + SZ3->Z3_STATUS + " Na tabela de Integração"
		Else
			DbSelectarea("SA1")
			SA1->(DbSetorder(3))
			If !SA1->(DbSeek(xFilial("SA1") + SZ3->Z3_CNPJ))

				lRetorno := .F.
				cMensagem := "CNPJ: " + SZ3->Z3_CNPJ + " do cliente, não cadastrado no cadastro de clientes do Protheus."

			Else

				lLiberAut := .T. //-- Gustavo Viana -- Restricoes a liberacao automatica -- 18/02/2013
				cTpOper	 := Left(SZ3->Z3_CODTSAC,2)
				dDtEmiss := SZ3->Z3_EMISSAO
				cPedNew  := U_NUMPED()

				aAdd(aCabec,{"C5_FILIAL" ,SZ3->Z3_FILIAL ,NIL})
				aAdd(aCabec,{"C5_NUM"    ,cPedNew        ,NIL})
				aAdd(aCabec,{"C5_EMISSAO",dDtEmiss       ,NIL})
				aAdd(aCabec,{"C5_X_DTINT",dDataBase      ,NIL})  // Fernando Nogueira - Chamado 003950
				aAdd(aCabec,{"C5_TIPO"   ,"N"            ,NIL})
				aAdd(aCabec,{"C5_SEED"   ,SZ3->Z3_SEED   ,NIL})
				aAdd(aCabec,{"C5_CLIENTE",SA1->A1_COD    ,NIL})
				aAdd(aCabec,{"C5_LOJACLI",SA1->A1_LOJA   ,NIL})
				aAdd(aCabec,{"C5_TRANSP" ,SZ3->Z3_CODTRAN,NIL})
				aAdd(aCabec,{"C5_CONDPAG",SZ3->Z3_CODPGTO,NIL})
				aAdd(aCabec,{"C5_TPFRETE",SZ3->Z3_FREPAGO,NIL})
				aAdd(aCabec,{"C5_MENNOTA",SZ3->Z3_OBS    ,NIL})
				aAdd(aCabec,{"C5_PEDWEB" ,Val(cPedidoW)  ,NIL})
				aAdd(aCabec,{"C5_INTEGRA",SZ3->Z3_INTEGRA,NIL})
				aAdd(aCabec,{"C5_PEDCLI" ,SZ3->Z3_NPEDCLI,NIL})

				// Chamado 001777 - Bloqueio Avant - Fernando Nogueira
				If SZ3->Z3_PRODMKT <> 'N'
					aAdd(aCabec,{"C5_X_BLQ" ,"S",NIL})
				Endif

				//-- Gustavo Viana -- Restricoes a liberacao automatica -- 18/02/2013
				//-- Se tiver condicao de pagamento no parametro P.V. deverah ser analisado, ou seja, P.V. sem liberacao automatica
				//If AllTrim(SZ3->Z3_CODPGTO) $ cCodPag
				//	lLiberAut := .F.
				//EndIf

				DbSelectarea("SZ4")
				SZ4->(DbSetorder(1))

				If SZ4->(DbSeek(xFilial("SZ4") + cPedidoW))
					While SZ4->(!Eof()) .And. 	SZ4->Z4_FILIAL == xFilial("SZ4") .And.;
						   Padl(Alltrim(Str(SZ4->Z4_NUMPEDW)),TamSx3("Z4_NUMPEDW")[01]) == cPedidoW

						aLinha := {}
						aAdd(aLinha,{"C6_FILIAL" ,SZ4->Z4_FILIAL ,NIL})
						aAdd(aLinha,{"C6_ITEM"   ,SZ4->Z4_ITEMPED,NIL})
						aAdd(aLinha,{"C6_PRODUTO",SZ4->Z4_CODPROD,NIL})
						aAdd(aLinha,{"C6_QTDVEN" ,SZ4->Z4_QTDE   ,NIL})
						aAdd(aLinha,{"C6_TPOPERW",SZ4->Z4_TPOPERW,NIL})

					   	// Produtos de Marketing - Fernando Nogueira - Chamado 000796
					   	// Operacao Triangular
					   	//If lLiberAut .And. SZ3->Z3_PRODMKT == 'N'
							aAdd(aLinha,{"C6_QTDLIB",SZ4->Z4_QTDE,NIL})
						//Else
							//aAdd(aLinha,{"C6_QTDLIB",0           ,NIL})
						//EndIf

						SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_CODPROD))

						nPrcOri := SB1->B1_PRV1

						If SZ4->Z4_DESCRA > 0
							nPrcOri := nPrcOri * (1 - SZ4->Z4_DESCRA/100)
						Endif

						aAdd(aLinha,{"C6_PRCVEN" ,SZ4->Z4_PRLIQ  ,NIL})
						aAdd(aLinha,{"C6_X_VLORI",nPrcOri        ,NIL})
						aAdd(aLinha,{"C6_X_PLIST",SB1->B1_PRV1   ,NIL})
						aAdd(aLinha,{"C6_OPER"   ,cTpOper		 ,NIL})
						aAdd(aLinha,{"C6_PEDCLI" ,SZ4->Z4_NUMPED ,NIL})
						aAdd(aLinha,{"C6_X_RAMO" ,SZ4->Z4_DESCRA ,NIL})
						aAdd(aLinha,{"C6_X_GERE" ,SZ4->Z4_DESCGE ,NIL})
						aAdd(aLinha,{"C6_X_ESPEC",SZ4->Z4_DESCESP,NIL})
						aAdd(aLinha,{"C6_DESCPRO",SZ4->Z4_PRODESC,NIL})
						aAdd(aLinha,{"C6_LOCAL"  ,cArmazem       ,NIL})
						// Fernando Nogueira - Verifica se vem comissao da web
						If SZ4->Z4_PCCOMIS > 0
							aAdd(aLinha,{"C6_COMIS1" ,SZ4->Z4_PCCOMIS,NIL})
							aAdd(aLinha,{"C6_COMIS2" ,0              ,NIL})
							aAdd(aLinha,{"C6_COMIS3" ,0              ,NIL})
							aAdd(aLinha,{"C6_COMIS4" ,0              ,NIL})
							aAdd(aLinha,{"C6_COMIS5" ,0              ,NIL})
						Endif
						aAdd(aItens,aLinha)

						lTesInt := .F.

						SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_CODPROD))

						If AllTrim(SB1->B1_POSIPI) = '85395000'
							lBlqNCM := .T.
						Endif

						// Fernando Nogueira - Chamado 004664
						If (SA1->A1_EST = 'PB' .And. AllTrim(SB1->B1_GRTRIB) $ '032.033.034.035.036.037.038.039.044.536.600') .Or. ;
							(SA1->A1_EST = 'SE' .And. AllTrim(SB1->B1_GRTRIB) $ '032.033.034.035.036.037.038.039.044.536.600') .Or. ;
							(SA1->A1_EST = 'RN' .And. AllTrim(SB1->B1_GRTRIB) $ '032.033.034.035.036.037.038.039.044.536.600') .Or. ;
							(SA1->A1_EST = 'RS' .And. AllTrim(SB1->B1_GRTRIB) $ '032.033.034.035.036.037.038.039.044.082.536.600') .Or. ;
							(SA1->A1_EST = 'RO' .And. AllTrim(SB1->B1_GRTRIB) $ '032.033.034.035.036.037.038.039.044.536.600') .Or. ;
							SB1->B1_X_VLDFI = 'S'  //Fernando Nogueira - Chamado 004719
							lBlqFis := .T.
						Endif

						_aAreaSFM 	:= getArea("SFM")
						SFM->(dbSetOrder(2))

						cTesOper := MaTesInt(02, cTpOper, SA1->A1_COD, SA1->A1_LOJA, "C", SB1->B1_COD, NIL)

						// Verifica se nao tem amarracao de Tes Inteligente
						If Empty(cTesOper)
							aadd(aTesInt,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_GRTRIB,SB1->B1_IPI,SB1->B1_POSIPI})
						Endif

						aAdd(aTesSaida,cTesOper)

						SFM->(RestArea(_aAreaSFM))

						SZ4->(DbSkip())
					Enddo

					nPosQtdVen := aScan(aLinha,{|x|Trim(x[1])=="C6_QTDVEN"})
					nPosPrcVen := aScan(aLinha,{|x|Trim(x[1])=="C6_PRCVEN"})
					nPosProd   := aScan(aLinha,{|x|Trim(x[1])=="C6_PRODUTO"})

					// Verifica se o Pedido eh de Bonificacao - Chamado 002553 - Fernando Nogueira
					If cTpOper == '54' .Or. lBlqNCM
						// Faz uma varredura no aItens
						For _n := 1 to Len(aItens)
							nDescSuf  := 0

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

							nPrcVen	:= aItens[_n][nPosQtdVen][2] * aItens[_n][nPosPrcVen][2]

							//Adiciona o Produto para Calculo dos Impostos
							nItem := 	MaFisAdd(	aItens[_n][nPosProd][2]	,;   	// 1-Codigo do Produto ( Obrigatorio )
													aTesSaida[_n]			,;	   	// 2-Codigo do TES ( Opcional )
													1						,;	   	// 3-Quantidade ( Obrigatorio )
													aItens[_n][nPosPrcVen][2],;   	// 4-Preco Unitario ( Obrigatorio )
													0						,;  	// 5-Valor do Desconto ( Opcional )
													""						,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
													""						,;		// 7-Serie da NF Original ( Devolucao/Benef )
													0						,;		// 8-RecNo da NF Original no arq SD1/SD2
													0						,;		// 9-Valor do Frete do Item ( Opcional )
													0						,;		// 10-Valor da Despesa do item ( Opcional )
													0						,;		// 11-Valor do Seguro do item ( Opcional )
													0						,;		// 12-Valor do Frete Autonomo ( Opcional )
													nPrcVen					,; 		// 13-Valor da Mercadoria ( Obrigatorio )
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

									// Fernando Nogueira - Chamado 004646
									If SB1->(dbSeek(xFilial("SB1")+aItens[_n][nPosProd][2])) .And. AllTrim(SB1->B1_POSIPI) = '85395000' .And. aImpostos[nPosRet][05] = 0
										lBlqIcmRet := .T.
									Endif
								EndIf

								If nPosIPI > 0
									nPrcVen	:= nPrcVen + aImpostos[nPosIPI][05]
								EndIf

								If SA1->A1_CALCSUF = 'S'
									nDescSuf := MafisRet(,"IT_DESCZF")
									nPrcVen  := nPrcVen - nDescSuf
								Endif

							EndIf

							MaFisEnd()

							If cTpOper == '54'
								nTotBonif += nPrcVen
							Endif
						Next _n
					Endif

					If !Empty(aTesInt)
						cMensagem	+= "<b> Caro Representante. Seu Pedido tem produto faltando regra fiscal! Favor entrar em contato com o Depto Fiscal da Avant. </b>" + cEnter + cEnter
						U_DispTesInt(aTesInt,cPedWeb)
					Endif

					// Chamado 002553 - Fernando Nogueira
					If nTotBonif > 0 .And. nTotBonif > Posicione("SA3",1,xFilial("SA3")+SZ3->Z3_VEND,"A3_ACMMKT")
						cMensagem	+= "<b> Caro Representante. O Valor do seu Pedido de Bonificacao com Impostos ("+AllTrim(Transform(nTotBonif, _cSA3Cred))+") ultrapassou o seu Saldo de Credito de Marketing ("+AllTrim(Transform(SA3->A3_ACMMKT, _cSA3Cred))+"). </b>" + cEnter + cEnter
					Endif

					// Fernando Nogueira - Chamado 003522 - Bloqueio Fiscal
					// Fernando Nogueira - Chamado 003575
					// Fernando Nogueira - Chamado 004323
					If SA1->A1_TIPO $ 'FR' .Or. lBlqIcmRet .Or. lBlqFis .Or. (!Empty(SA1->A1_X_DTRES) .And. SA1->A1_X_DTRES < dDataBase)
						aAdd(aCabec,{"C5_X_BLQFI" ,"S",NIL})
					Endif

					MsExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)

					If lMsErroAuto
						lRetorno	:= .F.
						If Empty(cMensagem)
							cMensagem 	+= MostraErro(cPathLog, cFileLog)
						Endif
						RollBackSx8()
					Else
						cDocumen	:= "Pedido Nro.: " + SC5->C5_NUM + " Caro Representante. Seu pedido foi incluído com sucesso!"
						SZ4->(dbGoTop())
						If SZ4->(DbSeek(xFilial("SZ4") + cPedidoW))
							While SZ4->(!Eof()) .And. 	SZ4->Z4_FILIAL == xFilial("SZ4") .And. Padl(Alltrim(Str(SZ4->Z4_NUMPEDW)),TamSx3("Z4_NUMPEDW")[01]) == cPedidoW
								SZ4->(Reclock("SZ4",.F.))
									SZ4->Z4_RESERVA := " " // Tira reserva web
								SZ4->(MsUnlock())
								SZ4->(DbSkip())
							End
						Endif
					EndIf

					//Atualiza Status da SZ3
					RecLock("SZ3", .F.)
					SZ3->Z3_STATUS	:= IIF(lRetorno,"3","4")
					// Status
					// 1 = Parado na Web (Nao enviado)
					// 2 = Pedido ainda nao Integrado com Estoque na Web
					// 3 = Integrado com Sucesso
					// 4 = Erro na Integracao
					// 5 = Pedido sem Saldo no Estoque (Parado na Web)
					// 6 = Pedido com Desconto Especial
					// 7 = Pedido com Desconto Especial nao Aprovado pelo Gerente Nacional
					// 8 = Pedido Bonificado
					// 9 = Pedido com Bonificacao Parado na Tela do Gerente Nacional
					// A = Pedido de Venda com Desconto Especial Parado na Tela do Gerente Regional
					// B = Pedido de Venda com Desconto Especial Parado na Tela do Gerente Nacional
					// C = Pedido de Venda sem Desconto Especial Parado na Tela do Gerente Regional
					// D = Pedido de Venda sem Desconto Especial Parado na Tela do Gerente Nacional
					// E = Solicitacao de Bonificacao Parado na Tela do Gerente Regional
					// F = Solicitacao de Bonificacao Aprovada na Tela do Gerente Regional
					// P = Pedido em Processo de Integracao

					MsUnlock()

					If !lRetorno .And. Empty(aTesInt) // Fernando Nogueira - Chamado 004689
						U_DispPedErr(cMensagem,cPedWeb)
					EndIf

				Else

					lRetorno 	:= .F.
					cMensagem	:= "Não encontrado ítens para o pedido: " + cPedidoW

				EndIf

			EndIf

		EndIf

	Else

		lRetorno := .F.
		cMensagem := "Pedido: " + cPedidoW + " Não encontrado na tabela SZ3"

	EndIf

EndIf

Return lRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispPedErr³ Autor ³ Fernando Nogueira  ³ Data  ³ 24/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail quando ocorre erro na integracao do Pedido ³±±
±±³          ³ via Web.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DispPedErr(cMensagem,cPedWeb)

Local _cMailTo   := GetMv("ES_EMAILPW")
Local _cMailVend := ""
Local _cCorpoM   := ""
Local _cZ4Quant  := PesqPict("SZ4","Z4_QTDE")
Local _cZ4VPrVen := PesqPict("SZ4","Z4_PRVEN")
Local _cZ4VPrLiq := PesqPict("SZ4","Z4_PRLIQ")

aArea		:= GetArea()
_aAreaSZ3 	:= getArea("SZ3")
_aAreaSZ4 	:= getArea("SZ4")
_aAreaSA3 	:= getArea("SA3")
_aAreaSA1 	:= getArea("SA1")

_cMailVend := Posicione("SA3",1,xFilial("SA3")+SZ3->Z3_VEND,"A3_EMAIL")

If !Empty(_cMailVend)
	_cMailTo := _cMailTo + ";" + AllTrim(_cMailVend)
Endif

SZ4->(DbSetOrder(1))

If SZ4->(dbSeek(SZ3->Z3_FILIAL+cPedWeb))
	_cCorpoM += '<html>'
	_cCorpoM += '<head>'
	_cCorpoM += '<title>Erro de Integração Pedido Web</title>'
	_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cCorpoM += '<style type="text/css">'
	_cCorpoM += '<!--'
	_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
	_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
	_cCorpoM += '.style4 {color: #FF0000}'
	_cCorpoM += '-->'
	_cCorpoM += '</style>'
	_cCorpoM += '</head>'
	_cCorpoM += '<body>'
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE ERRO DE INTEGRAÇÃO PEDIDO WEB</strong></p>'
	_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Pedido Web: </strong>'+cPedWeb+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Cliente/Loja: </strong>'+Posicione("SA1",3,xFilial("SA1")+SZ3->Z3_CNPJ,"A1_COD")+"/"+SA1->A1_LOJA+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Mensagem: </strong>'+cMensagem+'</p>'
	_cCorpoM += '  <table width="1900" border="1" align="left"> '
	_cCorpoM += '    <tr>
	_cCorpoM += '      <td align="center" width="35"><span class="style3">Item</span></td>'
	_cCorpoM += '      <td align="center" width="80"><span class="style3">Produto</span></td>'
	_cCorpoM += '      <td align="center" width="250"><span class="style3">Descricao</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Quantidade</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Prc Venda</span></td>'
	_cCorpoM += '      <td align="center" width="70"><span class="style3">Prc Unit.</span></td>'
	_cCorpoM += '    </tr>'
	While SZ4->(!Eof()) .And. SZ4->Z4_NUMPEDW == SZ3->Z3_NPEDWEB

		_cCorpoM += '    <tr>'
		_cCorpoM += '     <td align="center"><span>'+SZ4->Z4_ITEMPED+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+SZ4->Z4_CODPROD+'</span></td>'
		_cCorpoM += '	   <td><span>'+SZ4->Z4_DESCPRO+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SZ4->Z4_QTDE , _cZ4Quant)+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SZ4->Z4_PRVEN, _cZ4VPrVen)+'</span></td>'
		_cCorpoM += '	   <td align="right"><span>'+Transform(SZ4->Z4_PRLIQ, _cZ4VPrLiq)+'</span></td>'
		_cCorpoM += '    </tr>'
		SZ4->(dbSkip())
	EndDo
	_cCorpoM += '  </table>'
	_cCorpoM += '</body>'
	_cCorpoM += '</html>'
	U_MHDEnvMail(_cMailTo, "", "", "Pedido Web "+cPedWeb+" Não Integrado ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]", _cCorpoM, "")
EndIf

Restarea(_aAreaSA1)
Restarea(_aAreaSZ3)
Restarea(_aAreaSZ4)
Restarea(_aAreaSA3)
RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ DispTesInt³ Autor ³ Fernando Nogueira  ³ Data  ³ 24/04/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Dispara e-mail quando falta amarracao de Tes Inteligente  ³±±
±±³          ³ em Pedido colocado via Web.                               ³±±
±±³          ³ Chamado 000471                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DispTesInt(aTesInt,cPedWeb)

Local _cMailTo  := GetMv("ES_MAILFIS")
Local _cMailCC  := GetMv("ES_EMAILTI")
Local _cCorpoM  := ""
Local _cTipo	  := SA1->A1_TIPO
Local _cB1IPI   := PesqPict("SB1","B1_IPI")
Local _cB1POIPI := PesqPict("SB1","B1_POSIPI")

aArea		:= GetArea()
_aAreaSA1 	:= getArea("SA1")
_aAreaSA3 	:= getArea("SA3")

_cMailVend := Posicione("SA3",1,xFilial("SA3")+SZ3->Z3_VEND,"A3_EMAIL")

// Fernando Nogueira - Chamado 004689
//If !Empty(_cMailVend)
//	_cMailTo := _cMailTo + ";" + AllTrim(_cMailVend)
//Endif

If _cTipo == 'S'
	_cTipo := 'REVENDEDOR'
ElseIf _cTipo == 'F'
	_cTipo := 'CONS. FINAL'
ElseIf _cTipo == 'L'
	_cTipo := 'PRODUTOR RURAL'
ElseIf _cTipo == 'R'
	_cTipo := 'IND/OBRA'
ElseIf _cTipo == 'X'
	_cTipo := 'EXPORTAÇÃO'
EndIf

SZ4->(DbSetOrder(1))

If SZ4->(dbSeek(SZ3->Z3_FILIAL+cPedWeb))
	_cCorpoM += '<html>'
	_cCorpoM += '<head>'
	_cCorpoM += '<title>Sem Amarração de Tes Inteligente</title>'
	_cCorpoM += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
	_cCorpoM += '<style type="text/css">'
	_cCorpoM += '<!--'
	_cCorpoM += '.style1 {font-family: Arial, Helvetica, sans-serif}'
	_cCorpoM += '.style3 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }'
	_cCorpoM += '.style4 {color: #FF0000}'
	_cCorpoM += '-->'
	_cCorpoM += '</style>'
	_cCorpoM += '</head>'
	_cCorpoM += '<body>'
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE FALTA DE AMARRAÇÃO DE TES INTELIGENTE</strong></p>'
	_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Pedido Web: </strong>'+cPedWeb+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Cliente/Loja: </strong>'+Posicione("SA1",3,xFilial("SA1")+SZ3->Z3_CNPJ,"A1_COD")+"/"+SA1->A1_LOJA+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Tipo do Cliente: </strong>'+_cTipo+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Estado do Cliente: </strong>'+SA1->A1_EST+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Grupo de Tributação do Cliente: </strong>'+SA1->A1_GRPTRIB+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Tipo de Operação: </strong>'+cTpOper+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Produtos sem amarração: </strong> </p>'
	_cCorpoM += '  <table width="960" border="1" align="left"> '
	_cCorpoM += '    <tr>
	_cCorpoM += '      <td align="center" width="80"><span class="style3">Produto</span></td>'
	_cCorpoM += '      <td align="center" width="200"><span class="style3">Descricao</span></td>'
	_cCorpoM += '      <td align="center" width="160"><span class="style3">Grp Trib</span></td>'
	_cCorpoM += '      <td align="center" width="160"><span class="style3">Aliq. IPI</span></td>'
	_cCorpoM += '      <td align="center" width="160"><span class="style3">POS IPI</span></td>'
	_cCorpoM += '    </tr>'
	For _nI := 1 To Len(aTesInt)
		_cCorpoM += '    <tr>'
		_cCorpoM += '	   <td align="center"><span>'+aTesInt[_nI,1]+'</span></td>'
		_cCorpoM += '	   <td><span>'+aTesInt[_nI,2]+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+aTesInt[_nI,3]+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+Transform(aTesInt[_nI,4], _cB1IPI)+'</span></td>'
		_cCorpoM += '	   <td align="center"><span>'+Transform(aTesInt[_nI,5], _cB1POIPI)+'</span></td>'
		_cCorpoM += '    </tr>'
		SZ4->(dbSkip())
	Next _nI
	_cCorpoM += '  </table>'
	_cCorpoM += '</body>'
	_cCorpoM += '</html>'
	U_MHDEnvMail(_cMailTo, _cMailCC, "", "Pedido Web "+cPedWeb+" com Produto(s) sem Amarracao de Tes Inteligente ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]", _cCorpoM, "")
EndIf

Restarea(_aAreaSA3)
Restarea(_aAreaSA1)
RestArea(aArea)

Return
