#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ALTVOLU  � Autor � Fernando Nogueira  � Data � 02/06/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Alteracao de Volume do Pedido Via Coletor.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ALTVOLU()

	Local   aAreaSC9 := SC9->(GetArea())
	Local   aAreaSDB := SDB->(GetArea())

	Private nVolumes := 0
	Private nVolAtu	 := SC5->C5_VOLUME1

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
					// Fernando Nogueira - Chamado 005674
					If SDB->DB_STATUS == '1'
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

			SC9->(dbSkip())
		End

	Else
		VtAlert("Registro Bloqueado","Aviso",.T.,4000,3)
	Endif

	SC9->(RestArea(aAreaSC9))
	SDB->(RestArea(aAreaSDB))

Return Nil
