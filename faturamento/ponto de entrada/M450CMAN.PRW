#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � M450CMAN � Autor � Fernando Nogueira  � Data � 25/04/2017 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Para Liberacao Manual da Analise de      ���
���          � Credito por Cliente na confirmacao                        ���
���          � Chamado 004840                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function M450CMAN()

Local nOpcao := ParamIXB[1]

If nOpcao == 0
	Return .T.
Endif

Return CliLib(SA1->A1_COD,SA1->A1_LOJA)

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � CliLib    � Autor � Fernando Nogueira � Data � 25/04/2017 ���
������������������������������������������������������������������������͹��
���Descricao � Verifica se o Cliente esta liberado                       ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function CliLib(cCliente,cLoja)

Local cAliasFIN := GetNextAlias()
Local lReturn   := .T.

// Chamado 004840 - Fernando Nogueira
BeginSql alias cAliasFIN

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLFIN IN ('S') AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasFIN)->(dbGoTop())

If (cAliasFIN)->(!Eof())
	ApMsgInfo("Cliente tem Pedido com Bloqueio Financeiro")
	lReturn := .F.
Endif

(cAliasFIN)->(dbCloseArea())

Return lReturn