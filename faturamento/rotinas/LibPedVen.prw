#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LibPedVen º Autor ³ Fernando Nogueira º Data ³ 11/11/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Liberacao de Pedido de Vendas, Regra Avant                º±±
±±º          ³ Chamado 001777                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LibPedVen()

Local nVlrCred := 0
Local cBlqCred := ""

If SC5->(AllTrim(C5_X_BLQ)+AllTrim(C5_LIBEROK)) == 'SS'

	If MsgNoYes("Liberar o Pedido "+SC5->C5_NUM+" ?")
	
		Begin Transaction
		
			SC5->(RecLock("SC5",.F.))
				SC5->C5_X_BLQ := 'N'
			SC5->(MsUnlock())
			
			SC9->(dbSetOrder(01))
			SC9->(msSeek(xFilial("SC9")+SC5->C5_NUM))
			
			While SC9->(!Eof()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
			
				SC6->(msSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))
				SC6->(RecLock("SC6",.F.))
			
				SC9->(RecLock("SC9",.F.))
					SC9->C9_BLOQUEI := ''
				
					nVlrCred := SC9->C9_QTDLIB * SC9->C9_PRCVEN
					
					// Verifica se o credito esta liberado
					If MaAvalCred(SC9->C9_CLIENTE,SC9->C9_LOJA,nVlrCred,SC5->C5_MOEDA,.T.,@cBlqCred)
						SC9->C9_BLCRED := ''
						// Libera o estoque e gera DCF
						MaAvalSC9("SC9",5,{{ "","","","",SC9->C9_QTDLIB,SC9->C9_QTDLIB2,Ctod(""),"","","",SC9->C9_LOCAL}})
					Endif
					
				
				SC9->(MsUnlock())
				
				SC6->(MsUnlock())
			
				SC9->(dbSkip())
			End
		
		End Transaction
		
		ApMsgInfo("Pedido "+SC5->C5_NUM+" Liberado!")
		
	Endif

Else
	ApMsgInfo("Pedido "+SC5->C5_NUM+" Não Está com Bloqueio Avant!")
Endif

Return