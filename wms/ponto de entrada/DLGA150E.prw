#INCLUDE "PROTHEUS.CH"
#INCLUDE 'APVT100.CH'
#INCLUDE 'INKEY.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DLGA150E º Autor ³ Fernando Nogueira  º Data ³ 27/05/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada antes da Execucao do Servico              º±±
±±º          ³ Chamado 001473                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DLGA150E()

Local _aArea    := GetArea()
Local aAreaSDB  := SDB->(GetArea())
Local _cDoc     := AllTrim(ParamIXB[3])
Local _cSerie   := AllTrim(ParamIXB[4])
Local cMens1    := ""
Local cMens2    := ""
Local cAliasSC9 := GetNextAlias()
Local cAliasDCF := GetNextAlias()

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

// Fernando Nogueira - Verifica se tem item nao liberado no Pedido de Vendas
BeginSQL Alias cAliasSC9
	SELECT * FROM
	(SELECT	C6_ITEM ITEMC6,ISNULL(C9_ITEM,'00') ITEMC9 FROM %Table:SC6% SC6
	LEFT JOIN %Table:SC9% SC9 ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND SC9.%NotDel%
	WHERE	SC6.%NotDel%
	AND 	C6_FILIAL = %Exp:xFilial("SC6")%
	AND		C6_NUM = %Exp:_cDoc%
	GROUP BY C6_ITEM,C9_ITEM) ITENSC6
	WHERE ITEMC9 = '00'
	ORDER BY ITEMC6
EndSQL

(cAliasSC9)->(dbGoTop())

If !(cAliasSC9)->(Eof())
	cMens1   := "O(s) Item(ns) abaixo do Pedido "+_cDoc+" estão em aberto no Pedido de Vendas:"+CHR(13)+CHR(10)
	
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
BeginSQL Alias cAliasDCF
	SELECT * FROM
	(SELECT	C6_ITEM ITEMC6,ISNULL(DCF_SERIE,'00') ITEMDCF FROM %Table:SC6% SC6
	LEFT JOIN %Table:DCF% DCF ON C6_FILIAL = DCF_FILIAL AND C6_NUM = DCF_DOCTO AND C6_ITEM = DCF_SERIE AND DCF.%NotDel%
	WHERE	SC6.%NotDel%
	AND 	C6_FILIAL = %Exp:xFilial("SC6")%
	AND		C6_NUM = %Exp:_cDoc%
	GROUP BY C6_ITEM,DCF_SERIE) ITENSC6
	WHERE ITEMDCF = '00'
	ORDER BY ITEMC6
EndSQL

(cAliasDCF)->(dbGoTop())

If !(cAliasDCF)->(Eof())
	cMens1   := "O(s) Item(ns) abaixo do Pedido "+_cDoc+" não geraram execução de serviço:"+CHR(13)+CHR(10)
	
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

RestArea(_aArea)

Return .T.