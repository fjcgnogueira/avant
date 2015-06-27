#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ALTVOLU  º Autor ³ Fernando Nogueira  º Data ³ 02/06/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de Volume do Pedido Via Coletor.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ALTVOLU()

	Local   aAreaSC9  := SC9->(GetArea())
	Local   aAreaSC6  := SC6->(GetArea())
	Local   aAreaSE4  := SE4->(GetArea())
	Local   aAreaSB1  := SB1->(GetArea())
	Local   aAreaSB2  := SB2->(GetArea())
	Local   aAreaSF4  := SF4->(GetArea())
	Local   aAreaSDB  := SDB->(GetArea())
	Local   cTes      := ""
	Local   cGeraNF   := Space(01)
	Local   cNota     := ""
	Local   cSerie    := "1  "
	Local   cContinue := Space(01)
	Local   cCondPag  := SC5->C5_CONDPAG
	Local   lGeraNota := .T.

	Private nVolumes := 0
	Private nVolAtu	  := SC5->C5_VOLUME1
	Private aPVlNFs  := {}
	
	VtClear()
	
	@ 01,00 VTSay "Pedido :" + SC5->C5_NUM		
	@ 02,00 VTSay "Qtd Volumes Atual"
	@ 03,00 VTGet nVolAtu When .F.
	@ 04,00 VTSay "Qtd Volumes Novo"
	@ 05,00 VTGet nVolumes Valid(nVolumes > 0)
	
	VTRead
	
	If SC5->(RecLock("SC5",.F.))
		SC5->C5_VOLUME1	:= nVolumes
		SC5->(MsUnlock())
		VtAlert("Qtd de Volumes do Pedido "+SC5->C5_NUM+" Alterada","Aviso",.T.,4000,3)
		
		// Posiciona na Liberacao de Pedidos
		SC9->(dbSelectArea("SC9"))
		SC9->(dbSetOrder(01))
		SC9->(dbGoTop())
		SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))
		
		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
		
			// Define Ordem do Servico e Posiciona no Servico de Conferencia
			SDB->(dbSelectArea("SDB"))
			SDB->(dbSetOrder(06))
			SDB->(dbGoTop())
			SDB->(dbSeek(xFilial("SDB")+PADR(SC9->C9_PEDIDO,9)+PADR(SC9->C9_ITEM,3)+SC9->C9_CLIENTE+SC9->C9_LOJA+"001"+"003"))
			
			While SDB->(!Eof()) .And. PADR(SC9->C9_PEDIDO,9)+PADR(SC9->C9_ITEM,3)+SC9->C9_CLIENTE+SC9->C9_LOJA+"001"+"003" == SDB->DB_DOC+SDB->DB_SERIE+SDB->DB_CLIFOR+SDB->DB_LOJA+SDB->DB_SERVIC+SDB->DB_TAREFA

				If SDB->DB_ESTORNO <> 'S' 
					If SDB->DB_QUANT == SDB->DB_QTDLID
						If SC9->C9_XCONF <> "S" 
							If SC9->(RecLock("SC9",.F.))
								SC9->C9_XCONF := "S"
								SC9->(MsUnlock())
							Else
								VtAlert("Registro de Liberacao Bloqueado","Aviso",.T.,4000,3)
							Endif
						Endif
					Else
						If SC9->C9_XCONF <> "N" 
							If SC9->(RecLock("SC9",.F.))
								SC9->C9_XCONF := "N"
								SC9->(MsUnlock())
							Else
								VtAlert("Registro de Liberacao Bloqueado","Aviso",.T.,4000,3)
							Endif
						Endif
					Endif			
				Endif 
			
				SDB->(dbSkip())
			End
			
			// Alimenta o array para geracao da nota fiscal, conforme liberacoes do Pedido - Fernando Nogueira 27/06/2015
			If Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST) .And. SC9->C9_XCONF == "S" .And. SC9->C9_BLWMS >= "05"
				
				cTes := Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,"C6_TES")
				aadd(aPvlNfs,{	SC9->C9_PEDIDO,;
								SC9->C9_ITEM,;
								SC9->C9_SEQUEN,;
								SC9->C9_QTDLIB,;
								SC9->C9_PRCVEN,;
								SC9->C9_PRODUTO,;
								Posicione("SF4",1,xFilial("SF4")+cTes,"F4_ISS")=="S",;
								SC9->(RecNo()),;
								SC5->(Recno()),;
								SC6->(Recno(Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,""))),;
								SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+cCondPag,""))),;
								SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
								SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL,""))),;
								SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+cTes,"")))})
			Else
				lGeraNota := .F.
			Endif
							
			SC9->(dbSkip())
		End
		
		// Geracao da Nota Fiscal - Fernando Nogueira 27/06/2015
		If Len(aPvlNfs) > 0 .And. lGeraNota
		
			VtClear()
			
			@ 01,00 VTSay "Pedido :" + SC5->C5_NUM		
			@ 02,00 VTSay "Gerar NF? (S/N)"
			@ 03,00 VTGet cGeraNF Valid(If(cGeraNF $ ("SN"),.T.,Eval({||VtAlert("Somente S/N","Aviso",.T.,4000,3),.F.})))
			
			VTRead
			
			If cGeraNF == "S"
			
				cNota := MaPvlNfs(aPVlNFs,cSerie,.F.,.F.,.T.,.F.,.F.,1,1,.T.,.F.,,,)
								
				/*/
				ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³Parametros³ExpA1: Array com os itens a serem gerados                                                 ³
				³          ³ExpC2: Serie da Nota Fiscal                                                               ³
				³          ³ExpL3: Mostra Lct.Contabil                                                                ³
				³          ³ExpL4: Aglutina Lct.Contabil                                                              ³
				³          ³ExpL5: Contabiliza On-Line                                                                ³
				³          ³ExpL6: Contabiliza Custo On-Line                                                          ³
				³          ³ExpL7: Reajuste de preco na nota fiscal                                                   ³
				³          ³ExpN8: Tipo de Acrescimo Financeiro                                                       ³
				³          ³ExpN9: Tipo de Arredondamento                                                             ³
				³          ³ExpLA: Atualiza Amarracao Cliente x Produto                                               ³
				³          ³ExplB: Cupom Fiscal                                                                       ³
				³          ³ExpCC: Numero do Embarque de Exportacao                                                   ³
				³          ³ExpBD: Code block para complemento de atualizacao dos titulos financeiros.                ³
				³          ³ExpBE: Code block para complemento de atualizacao dos dados apos a geracao da nota fiscal.³
				³          ³ExpBF: Code Block de atualizacao do pedido de venda antes da geracao da nota fiscal       ³
				ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				/*/
				
				If Empty(cNota)
					VtAlert("Nota nao gerada.","Aviso",.T.,4000,3)
				Else
					VtClear()
					
					@ 01,00 VTSay "Gerada a Nota "+cNota
					@ 02,00 VTSay "Tecle Enter para Continuar"
					@ 03,00 VTGet cContinue
					
					VTRead
				Endif

			Endif
		
		Else		
			VtAlert("Pedido: " + SC5->C5_NUM + " com iten(s) bloqueado(s)","Aviso",.T.,4000,3)
		Endif
		
	Else
		VtAlert("Registro Bloqueado","Aviso",.T.,4000,3)
	Endif
	
	SC6->(RestArea(aAreaSC6))
	SE4->(RestArea(aAreaSE4))
	SB1->(RestArea(aAreaSB1))
	SB2->(RestArea(aAreaSB2))
	SF4->(RestArea(aAreaSF4))
	SC9->(RestArea(aAreaSC9))
	SDB->(RestArea(aAreaSDB))

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ValidPed  ³ Autor ³ Fernando Nogueira  ³ Data  ³ 03/06/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida Pedido de Vendas                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Validped(nVolAtu)
	Local lRetorno := .T.

	DbSelectarea("SC5")
	SC5->(DbSetorder(1))
	If !SC5->(DbSeek(xFilial("SC5") + cPedido))
		VtAlert("Pedido: " + cPedido + "Não Encontrado","Aviso",.T.,4000,3)
		lRetorno := .F.
	Else
		nVolAtu := SC5->C5_VOLUME1
	EndIf
	
Return lRetorno