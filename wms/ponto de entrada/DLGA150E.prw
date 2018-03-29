#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DLGA150E � Autor � Fernando Nogueira  � Data � 27/05/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada antes da Execucao do Servico              ���
���          � Chamado 001473                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DLGA150E()

Local _aArea    := GetArea()
Local aAreaSDB  := SDB->(GetArea())
Local _cDoc     := AllTrim(ParamIXB[3])
Local _cSerie   := AllTrim(ParamIXB[4])
Local cMens1    := ""
Local cMens2    := ""
Local cAliasSC6 := GetNextAlias()
Local cAliasSC9 := GetNextAlias()
Local cAliasDCF := GetNextAlias()

SET CENTURY ON

Public __cRecHum := ""

SDB->(dbSetOrder(6))

// Fernando Nogueira - Verifica se ja tem servico para esse documento
If SDB->(dbSeek(xFilial('SDB')+DCF->DCF_DOCTO))
	While SDB->(DB_FILIAL+DB_DOC) == xFilial('SDB')+DCF->DCF_DOCTO
		If SDB->(DB_TAREFA+DB_TIPO) == '002E' .And. Empty(SDB->DB_ESTORNO) .And. !Empty(SDB->DB_RECHUM)
			__cRecHum := SDB->DB_RECHUM
			Exit
		Endif
		SDB->(dbSkip())
	End
Endif

// Fernando Nogueira - Chamado 005682 (Liberacao Duplicada)
BeginSQL Alias cAliasSC6
	SELECT PEDIDO, ITEM, SUM(C6_QTDEMP) C6_QTDEMP, SUM(C9_QTDLIB) C9_QTDLIB FROM
		(SELECT C6_NUM PEDIDO,C6_ITEM ITEM,C6_QTDEMP,0 C9_QTDLIB FROM %Table:SC6% SC6
		WHERE  SC6.%NotDel% AND C6_FILIAL = %Exp:xFilial("SC6")% AND C6_NUM = %Exp:_cDoc%
		UNION ALL
		SELECT C9_PEDIDO PEDIDO,C9_ITEM ITEM,0 C6_QTDEMP,SUM(C9_QTDLIB) C9_QTDLIB FROM %Table:SC9% SC9
		WHERE  SC9.%NotDel% AND C9_FILIAL = %Exp:xFilial("SC9")% AND C9_PEDIDO = %Exp:_cDoc%
		GROUP BY C9_PEDIDO,C9_ITEM,C9_NUMSEQ HAVING COUNT(*) > 1) PEDIDOS
	GROUP BY PEDIDO,ITEM HAVING SUM(C9_QTDLIB) > SUM(C6_QTDEMP)
	ORDER BY PEDIDO,ITEM
EndSQL

(cAliasSC6)->(dbGoTop())

If !(cAliasSC6)->(Eof())
	ConOut("["+DtoC(Date())+" "+Time()+"] [DLGA150E] O Pedido "+_cDoc+" possui liberacao em duplicidade")
	Return .F.
EndIf

(cAliasSC6)->(DbCloseArea())

// Fernando Nogueira - Verifica se tem item nao liberado no Pedido de Vendas
// Fernando Nogueira - Chamado 004777 (Condicao Faturamento Parcial)
BeginSQL Alias cAliasSC9
	SELECT C6_ITEM ITEMC6 FROM %Table:SC6% SC6
	INNER JOIN %Table:SA1% SA1 ON C6_CLI+C6_LOJA = A1_COD+A1_LOJA AND SA1.%NotDel%
	LEFT  JOIN %Table:SC9% SC9 ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND SC9.%NotDel%
	WHERE SC6.%NotDel%
		AND C6_FILIAL = %Exp:xFilial("SC6")%
		AND	C6_NUM = %Exp:_cDoc%
		AND A1_X_FATPA <> 'S'
		AND C9_PEDIDO IS NULL
	ORDER BY ITEMC6
EndSQL

(cAliasSC9)->(dbGoTop())

If !(cAliasSC9)->(Eof())
	cMens1 := "["+DtoC(Date())+" "+Time()+"] [DLGA150E] O(s) Item(ns) abaixo do Pedido "+_cDoc+" est�o em aberto no Pedido de Vendas:"+CHR(13)+CHR(10)

	While !(cAliasSC9)->(Eof())
		If Empty(cMens2)
			cMens2 := (cAliasSC9)->ITEMC6
		Else
			cMens2 += " - " + (cAliasSC9)->ITEMC6
		Endif
		(cAliasSC9)->(dbSkip())
	Enddo

	ConOut(cMens1+cMens2)
	Return .F.
EndIf

(cAliasSC9)->(DbCloseArea())

// Fernando Nogueira - Verifica se tem item do Pedido que nao gerou execucao
// Fernando Nogueira - Chamado 004777 (Condicao Faturamento Parcial)
BeginSQL Alias cAliasDCF
	SELECT	C6_ITEM ITEMC6 FROM %Table:SC6% SC6
	INNER JOIN %Table:SA1% SA1 ON C6_CLI+C6_LOJA = A1_COD+A1_LOJA AND SA1.%NotDel%
	LEFT  JOIN %Table:DCF% DCF ON C6_FILIAL = DCF_FILIAL AND C6_NUM = DCF_DOCTO AND C6_ITEM = DCF_SERIE AND DCF.%NotDel%
	WHERE SC6.%NotDel%
		AND	C6_FILIAL = %Exp:xFilial("SC6")%
		AND	C6_NUM = %Exp:_cDoc%
		AND	A1_X_FATPA <> 'S'
		AND DCF_DOCTO IS NULL
	ORDER BY ITEMC6
EndSQL

(cAliasDCF)->(dbGoTop())

If !(cAliasDCF)->(Eof())
	cMens1 := "["+DtoC(Date())+" "+Time()+"] [DLGA150E] O(s) Item(ns) abaixo do Pedido "+_cDoc+" n�o geraram execu��o de servi�o:"+CHR(13)+CHR(10)

	While !(cAliasDCF)->(Eof())
		If Empty(cMens2)
			cMens2 := (cAliasDCF)->ITEMC6
		Else
			cMens2 += " - " + (cAliasDCF)->ITEMC6
		Endif
		(cAliasDCF)->(dbSkip())
	Enddo

	ConOut(cMens1+cMens2)
	Return .F.
EndIf

(cAliasDCF)->(DbCloseArea())

SDB->(RestArea(aAreaSDB))
RestArea(_aArea)

Return .T.
