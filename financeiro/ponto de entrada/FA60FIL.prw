#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA60FIL  � Autor � Fernando Nogueira  � Data � 23/11/2017  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada no filtro de titulos a receber p/ bordero ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA60FIL()
Return "U_FiltroBordero()"

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � FiltroBordero � Autor � Fernando Nogueira � Data � 23/11/2017 ���
����������������������������������������������������������������������������͹��
���Desc.     � Regras para a filtragem                                       ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function FiltroBordero()

Local lReturn  := .T.

If SE1->E1_TIPO = 'NCC'        //Fernando Nogueira - Chamado 005463
	lReturn := .F.
ElseIf SE1->E1_X_TPPGT $ 'CD'  //Fernando Nogueira - Chamado 005660
	lReturn := .F.
ElseIf SE1->E1_X_TPPGT = '149' //Fernando Nogueira - Chamado 005512
	lReturn := .F.
Endif

Return lReturn

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � TitCliAberto  � Autor � Fernando Nogueira � Data � 16/03/2018 ���
����������������������������������������������������������������������������͹��
���Desc.     � Verifica se tem titulos do cliente em aberto                  ���
���          � Validacao campo A1_X_TPPGT - Chamado 005660                   ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function TitCliAberto()

Local cCliente  := M->A1_COD
Local cLoja     := M->A1_LOJA
Local cNome     := M->A1_NOME
Local cTpPgto   := M->A1_X_TPPGT
Local cAliasSE1 := GetNextAlias()

BeginSql alias cAliasSE1
	SELECT R_E_C_N_O_ SE1REC FROM %table:SE1% SE1
	WHERE SE1.%notDel%
		AND E1_FILIAL   = %xfilial:SE1%
		AND E1_SALDO > 0
		AND E1_TIPO     = 'NF'
		AND E1_CLIENTE  = %exp:cCliente%
		AND E1_LOJA     = %exp:cLoja%
		AND E1_X_TPPGT <> %exp:cTpPgto%
	ORDER BY SE1REC
EndSql

(cAliasSE1)->(dbGoTop())

If (cAliasSE1)->(!EoF())
	If MsgYesNo("O cliente "+cNome+" loja "+cLoja+" possui t�tulos em aberto com outro tipo de pagamento"+Chr(13)+Chr(10)+"Deseja alterar para o tipo informado?")
		While (cAliasSE1)->(!EoF())
			SE1->(dbGoto((cAliasSE1)->SE1REC))
			SE1->(RecLock("SE1",.F.))
				SE1->E1_X_TPPGT := cTpPgto
			SE1->(MsUnlock())
			(cAliasSE1)->(dbSkip())
		End
		MsgInfo("T�tulos alterados")		
	Endif
End

(cAliasSE1)->(DbCloseArea())

Return .T.
