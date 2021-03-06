#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INTPEDIDO � Autor � Amedeo D. P. Filho � Data �  21/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa de Integracao de Pedidos.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local cCodPag   	:= SuperGetMv("MV_XPEDPAG",.F.,"149") //-- Parametro para informar condi��es de pagamento que bloqueiam a libera��o autom�tica -- Gustavo Viana -- 18/02/2013
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
Local lBlqFis		:= .F.
Local lBloqFin		:= .F.
Local nTotPed		:= 0
Local lHabWMS		:= &(Posicione("SX5",1,xFilial("SX5")+"ZA0001","X5_DESCRI"))
Local nLimWMS		:= Val(Posicione("SX5",1,xFilial("SX5")+"ZA0011","X5_DESCRI"))
Local aSldInd		:= {}  //Fernando Nogueira - Produtos com saldo indisponivel para atender a qtd do pedido
Local nSldDisp		:= 0

Private cTpOper		:= ""
Private lMsErroAuto	:= .F.
Private cCod      	:= ""
Private cLocal    	:= "01"
Private nQuant    	:= 0
Private nVendComis := 0
Private nProdComis := 0

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
	cMensagem	:= "Aten��o: Erro ao processar seu pedido; Informe T.I codigo:01-Pedido WEB j� cadastrado no Protheus Nro(s)"

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
			cMensagem	:= "Pedido: " + cPedidoW + " Est� com Status " + SZ3->Z3_STATUS + " Na tabela de Integra��o"
		Else
			DbSelectarea("SA1")
			SA1->(DbSetorder(3))
			If !SA1->(DbSeek(xFilial("SA1") + SZ3->Z3_CNPJ))

				lRetorno := .F.
				cMensagem := "CNPJ: " + SZ3->Z3_CNPJ + " do cliente, n�o cadastrado no cadastro de clientes do Protheus."

			Else

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
				If SZ3->Z3_PRODMKT = 'S'
					aAdd(aCabec,{"C5_X_BLQ","S",NIL})
				Endif
				
				// Chamado 005741 - Fernando Nogueira
				If !Empty(SZ3->Z3_AJUFISC)
					aAdd(aCabec,{"C5_X_STAJF" ,"R",NIL})
				Endif

				DbSelectarea("C09")
				C09->(DbSetorder(01))

				DbSelectarea("SA3")
				SA3->(DbSetorder(01))

				DbSelectarea("SZ4")
				SZ4->(DbSetorder(01))
				
				
				// Fernando Nogueira - Chamado 004919
				If SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND))
					nVendComis := SA3->A3_COMIS
				Endif

				If SA3->(dbSeek(xFilial("SA3")+SZ3->Z3_VEND)) .And. SA3->A3_TIPO = 'I'
					If SZ3->Z3_VEND <> SA1->A1_VEND
						aAdd(aCabec,{"C5_VEND1" ,SA1->A1_VEND ,NIL})
						aAdd(aCabec,{"C5_COMIS1",nVendComis   ,NIL})
						If SZ3->Z3_VEND <> SA1->A1_XVEND3
							aAdd(aCabec,{"C5_VEND2" ,SZ3->Z3_VEND ,NIL})
							aAdd(aCabec,{"C5_COMIS2",SA3->A3_COMIS,NIL})
						Endif
					ElseIf SZ3->Z3_VEND <> SA1->A1_XVEND3
						// Fernando Nogueira - Chamado 004958
						aAdd(aCabec,{"C5_VEND1" ,SZ3->Z3_VEND ,NIL})
						aAdd(aCabec,{"C5_COMIS1",SA3->A3_COMIS,NIL})
					Endif
				ElseIf SA3->(dbSeek(xFilial("SA3")+SZ3->Z3_VEND)) .And. SA3->A3_TIPO = 'F'
					aAdd(aCabec,{"C5_VEND1" ,SZ3->Z3_VEND ,NIL})
					aAdd(aCabec,{"C5_COMIS1",SA3->A3_COMIS,NIL})
				Endif

				If SZ4->(DbSeek(xFilial("SZ4") + cPedidoW))
					While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == xFilial("SZ4") .And. Padl(Alltrim(Str(SZ4->Z4_NUMPEDW)),TamSx3("Z4_NUMPEDW")[01]) == cPedidoW
						nTotPed += SZ4->Z4_QTDE * SZ4->Z4_PRLIQ
						SZ4->(DbSkip())
					End
				Endif
				
				SZ4->(dbGoTop())

				If SZ4->(DbSeek(xFilial("SZ4") + cPedidoW))
					While SZ4->(!Eof()) .And. SZ4->Z4_FILIAL == xFilial("SZ4") .And. Padl(Alltrim(Str(SZ4->Z4_NUMPEDW)),TamSx3("Z4_NUMPEDW")[01]) == cPedidoW
					
						nSldDisp := U_SaldoProd(SZ4->Z4_CODPROD,cArmazem)
						
						// Fernando Nogueira - Chamado 005743
						If SZ4->Z4_QTDE > nSldDisp .And. Empty(SZ4->Z4_PRESERV)
							aAdd(aSldInd,{SZ4->Z4_CODPROD,SZ4->Z4_DESCPRO})
						Endif

						aLinha := {}
						aAdd(aLinha,{"C6_FILIAL" ,SZ4->Z4_FILIAL ,NIL})
						aAdd(aLinha,{"C6_ITEM"   ,SZ4->Z4_ITEMPED,NIL})
						aAdd(aLinha,{"C6_PRODUTO",SZ4->Z4_CODPROD,NIL})
						aAdd(aLinha,{"C6_QTDVEN" ,SZ4->Z4_QTDE   ,NIL})
						aAdd(aLinha,{"C6_TPOPERW",SZ4->Z4_TPOPERW,NIL})
						aAdd(aLinha,{"C6_QTDLIB" ,SZ4->Z4_QTDE   ,NIL})

						SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_CODPROD))

						nPrcOri := SB1->B1_PRV1

						If SZ4->Z4_DESCRA > 0
							nPrcOri := nPrcOri * (1 - SZ4->Z4_DESCRA/100)
						Endif

						aAdd(aLinha,{"C6_PRCVEN" ,SZ4->Z4_PRLIQ  ,NIL})
						aAdd(aLinha,{"C6_X_VLORI",nPrcOri        ,NIL})
						aAdd(aLinha,{"C6_X_PLIST",SB1->B1_PRV1   ,NIL})
						aAdd(aLinha,{"C6_OPER"   ,cTpOper        ,NIL})
						aAdd(aLinha,{"C6_PEDCLI" ,SZ4->Z4_NUMPED ,NIL})
						aAdd(aLinha,{"C6_X_RAMO" ,SZ4->Z4_DESCRA ,NIL})
						aAdd(aLinha,{"C6_X_GERE" ,SZ4->Z4_DESCGE ,NIL})
						aAdd(aLinha,{"C6_X_ESPEC",SZ4->Z4_DESCESP,NIL})
						aAdd(aLinha,{"C6_DESCPRO",SZ4->Z4_PRODESC,NIL})
						aAdd(aLinha,{"C6_PRUNIT" ,SZ4->Z4_PRLIQ  ,NIL}) // Fernando Nogueira - Chamado 004749
						aAdd(aLinha,{"C6_LOCAL"  ,cArmazem       ,NIL})
						aAdd(aLinha,{"C6_RESERVA",SZ4->Z4_PRESERV,NIL}) // Fernando Nogueira - Chamado 005107
						
						If Empty(SZ4->Z4_PRESERV)  // Fernando Nogueira - Chamado 005282
							aAdd(aLinha,{"C6_LOTECTL",U_C0QUANT(SZ4->Z4_CODPROD,SZ4->Z4_QTDE),NIL})
						Endif
						
						// Fernando Nogueira - Verifica se vem comissao da web
						If (SZ4->Z4_PCCOMIS > 0 .Or. SZ4->Z4_INTCOMI > 0) .And. SA3->A3_TIPO = 'E'
							If Empty(SZ4->Z4_INTCOMI)   // Fernando Nogueira - Chamado 005147
								nProdComis := SZ4->Z4_PCCOMIS
							Else
								nProdComis := SZ4->Z4_INTCOMI
							Endif
							aAdd(aLinha,{"C6_COMIS1" ,nProdComis,NIL})
							aAdd(aLinha,{"C6_COMIS2" ,0         ,NIL})
							aAdd(aLinha,{"C6_COMIS3" ,0         ,NIL})
							aAdd(aLinha,{"C6_COMIS4" ,0         ,NIL})
							aAdd(aLinha,{"C6_COMIS5" ,0         ,NIL})
						Endif
						
						// Fernando Nogueira - Tira o servico de WMS do Pedido - Chamado 005057
						If !lHabWMS .And. nTotPed > nLimWMS
							aAdd(aLinha,{"C6_SERVIC" ,Space(TamSx3("C6_SERVIC")[1]) ,NIL})
							aAdd(aLinha,{"C6_ENDPAD" ,Space(TamSx3("C6_ENDPAD")[1]) ,NIL})
						Endif
						
						aAdd(aItens,aLinha)
						
		                // Chamado 004840 - Bloqueio Financeiro - Fernando Nogueira
						If !lBloqFin .And. AllTrim(SZ3->Z3_CODPGTO) $ cCodPag .And. cTpOper == '51'
							aAdd(aCabec,{"C5_X_BLFIN" ,"S",NIL})
							lBloqFin := .T.
						EndIf						

						lTesInt := .F.

						SB1->(dbSeek(xFilial("SB1")+SZ4->Z4_CODPROD))

						C09->(dbSeek(xFilial("C09")+SA1->A1_EST))
						
						// Fernando Nogueira - Chamado 004842
						If 	SA1->A1_X_BLFIS = '1' .Or. ;  
							SB1->B1_X_BLFIS = '1' .Or. ;  
							C09->C09_X_BLFI = '1' .Or. ;
							SA1->A1_X_BLFIS+SB1->B1_X_BLFIS = '22' .Or. ;
							SA1->A1_X_BLFIS+C09->C09_X_BLFI = '33' .Or. ;
							SB1->B1_X_BLFIS+C09->C09_X_BLFI = '32' .Or. ;
							(SA1->A1_X_BLFIS <= '4' .And. SB1->B1_X_BLFIS <= '4' .And. C09->C09_X_BLFI <= '4')
							
							lBlqFis := .T.
						Endif

						_aAreaSFM 	:= getArea("SFM")
						SFM->(dbSetOrder(02))

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
					If cTpOper == '54'
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
					If SA1->A1_TIPO $ 'FR' .Or. lBlqFis .Or. (!Empty(SA1->A1_X_DTRES) .And. SA1->A1_X_DTRES < dDataBase)
						aAdd(aCabec,{"C5_X_BLQFI" ,"S",NIL})
					Endif
					
					// Caso naum tenha nenhum produto com saldo indisponivel
					If Len(aSldInd) = 0
						MsExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)

						If lMsErroAuto
							lRetorno	:= .F.
							If Empty(cMensagem)
								cMensagem 	+= MostraErro(cPathLog, cFileLog)
							Endif
							RollBackSx8()
						Else
							cDocumen	:= "Pedido Nro.: " + SC5->C5_NUM + " Caro Representante. Seu pedido foi inclu�do com sucesso!"
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
					Else
						cMensagem += '<strong>Seu pedido n�o foi integrado devido a falta de estoque no(s) item(s) abaixo:</strong><br>'
						For _nK := 1 To Len(aSldInd)
							cMensagem += '<strong> Prod: </strong>'+aSldInd[_nK][1]+'<strong> - Descr: </strong>'+aSldInd[_nK][2]+'<br>'
						Next
						If cTpOper <> '54'
							cMensagem += '<br>'
							cMensagem += '<strong> O Pedido Web retornou para a tela de n�o enviados</strong><br>'
						Endif
						lRetorno	:= .F.
					Endif

					//Atualiza Status da SZ3
					RecLock("SZ3", .F.)
					If Len(aSldInd) = 0
						SZ3->Z3_STATUS	:= IIF(lRetorno,"3","4")
					Else
						SZ3->Z3_STATUS	:= "1"
					Endif
					// Status
					// 1 = Parado na Web (Nao enviado)
					// 2 = Pedido ainda nao Integrado com Estoque na Web
					// 3 = Integrado com Sucesso
					// 4 = Erro na Integracao
					// 5 = Pedido sem Saldo no Estoque (Parado na Web)
					// 6 = Pedido com Desconto Especial (Pendente Integracao)
					// 7 = Orcamento parado na tela do Gerente aguardando aprova��o
					// 8 = Orcamento aprovado
					// 9 = Orcamento nao aprovado
					// A = Nao possui cadastro cliente
					// C = Pedido com bonificacao parado para aprovacao do gerente regional
					// X = Pedidos que desconsidera o Saldo Web
					// P = Pedido em Processo de Integracao

					MsUnlock()

					/*If !lRetorno .And. Empty(aTesInt) // Fernando Nogueira - Chamado 004689
						U_DispPedErr(cMensagem,cPedWeb)
					EndIf*/

				Else

					lRetorno 	:= .F.
					cMensagem	:= "N�o encontrado �tens para o pedido: " + cPedidoW

				EndIf

			EndIf

		EndIf

	Else

		lRetorno := .F.
		cMensagem := "Pedido: " + cPedidoW + " N�o encontrado na tabela SZ3"

	EndIf

EndIf

Return lRetorno

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � DispPedErr� Autor � Fernando Nogueira  � Data  � 24/04/14 ���
������������������������������������������������������������������������Ĵ��
���Descricao � Dispara e-mail quando ocorre erro na integracao do Pedido ���
���          � via Web.                                                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
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
	_cCorpoM += '<title>Erro de Integra��o Pedido Web</title>'
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
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE ERRO DE INTEGRA��O PEDIDO WEB</strong></p>'
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
	U_MHDEnvMail(_cMailTo, "", "", "Pedido Web "+cPedWeb+" N�o Integrado ["+AllTrim(SM0->M0_CODFIL)+" / "+AllTrim(SM0->M0_FILIAL)+"]", _cCorpoM, "")
EndIf

Restarea(_aAreaSA1)
Restarea(_aAreaSZ3)
Restarea(_aAreaSZ4)
Restarea(_aAreaSA3)
RestArea(aArea)

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � DispTesInt� Autor � Fernando Nogueira  � Data  � 24/04/14 ���
������������������������������������������������������������������������Ĵ��
���Descricao � Dispara e-mail quando falta amarracao de Tes Inteligente  ���
���          � em Pedido colocado via Web.                               ���
���          � Chamado 000471                                            ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
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
	_cTipo := 'EXPORTA��O'
EndIf

SZ4->(DbSetOrder(1))

If SZ4->(dbSeek(SZ3->Z3_FILIAL+cPedWeb))
	_cCorpoM += '<html>'
	_cCorpoM += '<head>'
	_cCorpoM += '<title>Sem Amarra��o de Tes Inteligente</title>'
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
	_cCorpoM += '  <p align="center" class="style1"><strong>AVISO DE FALTA DE AMARRA��O DE TES INTELIGENTE</strong></p>'
	_cCorpoM += '  <p class="style1"><strong>Data: </strong>'+DtoC(Date())+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Hora: </strong>'+Substr(Time(),1,5)+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Filial : </strong>'+SM0->M0_FILIAL+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Pedido Web: </strong>'+cPedWeb+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Cliente/Loja: </strong>'+Posicione("SA1",3,xFilial("SA1")+SZ3->Z3_CNPJ,"A1_COD")+"/"+SA1->A1_LOJA+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Tipo do Cliente: </strong>'+_cTipo+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Estado do Cliente: </strong>'+SA1->A1_EST+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Grupo de Tributa��o do Cliente: </strong>'+SA1->A1_GRPTRIB+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Tipo de Opera��o: </strong>'+cTpOper+'</p>'
	_cCorpoM += '  <p class="style1"><strong>Produtos sem amarra��o: </strong> </p>'
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
