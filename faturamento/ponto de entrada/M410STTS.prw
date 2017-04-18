#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410STTS()   � Autor � Fernando Nogueira � Data � 23/01/14 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Executado apos todas as alteracoes no     ���
���          � Pedido de Vendas terem sido feitas.                        ���
���          � Chamado 000565                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410STTS()

Local aArea    := GetArea()
Local aAreaSC9 := SC9->(GetArea())
Local _xRecno
Local cCliente := M->C5_CLIENTE
Local cLojaCli := M->C5_LOJACLI

// Pedido Diferente de Dev.Compras e Beneficiamento
If !(M->C5_TIPO $ 'BD')

	SC9->(DbSetOrder(1))
	
	If SC9->(dbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
		While SC9->(!Eof()) .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == SC5->C5_FILIAL+SC5->C5_NUM
			_xRecno := SC9->(Recno())
			SC9->(RecLock("SC9",.F.))
			SC9->C9_SEQLIB := StrZero(_xRecno,8)
			SC9->(MsUnLock())	
			SC9->(dbSkip())
		End
	EndIf
	
	// Atualiza Total com impostos no cadastro de clientes
	SA1->(RecLock("SA1",.F.))
		SA1->A1_X_VLRTO := U_TotPedCred(cCliente,cLojaCli)
		SA1->A1_X_CPGTO := U_CondPgtoPed(cCliente,cLojaCli)
	SA1->(MsUnlock())
	
	//�����������������������������������Ŀ
	//�  Retorna a situacao inicial       �
	//�������������������������������������
	SC9->(RestArea(aAreaSC9))
	RestArea(aArea)
	
Endif

Return