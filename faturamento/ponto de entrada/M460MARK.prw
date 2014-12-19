#INCLUDE "Protheus.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  º Autor ³ Amedeo D.P. Filho  º Data ³  15/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada na Validacao dos Itens marcados para      º±±
±±º          ³ Faturamento, caso produto for KIT, movimenta os itens da	  º±±
±±º          ³ Estrutura.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vetor                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M460MARK()
	Local lRetorno	:= .T.
	Local aAreaC9	:= SC9->(GetArea())
	Local aAreaDB	:= SDB->(GetArea())
	Local aAreaAT	:= GetArea()

	Local aParam   	:= PARAMIXB
	Local cMarca  	:= aParam[1]
	Local lInverte 	:= aParam[2]
	Local cIndice	:= ""
	Local cArquivo	:= ""
	Local cCondicao	:= ""
	Local cFiltro	:= ""
	
	Local cMens1	:= ""
	Local cMens2	:= ""
	Local cDocto	:= ""
	Local cChave	:= ""
	Local aArrayTr	:= {}
	Local aRecSC9	:= {}
	Local cCampo    := "%%"
	
	Local cAliasSC6   := GetNextAlias()
	Local cAliasSC6_2 := GetNextAlias()
	Local cAliasSC9   := GetNextAlias()

	//Faz Filtro nos Pedidos a Faturar
	Dbselectarea("SC9")
	AliaSC9  := Alias()
	IndeSC9  := IndexOrd()
	cFiltro	 := MsDbFilter()
	
	cIndice	 := IndexKey()
	cArquivo := CriaTrab( Nil, .F. )

	If lInverte
		cCondicao := " C9_OK <> '" + cMarca + "' "
		cCampo    := "% C9_OK = '" + cMarca + "' %"
	Else
		cCondicao := " C9_OK == '" + cMarca + "' "
		cCampo    := "% C9_OK <> '" + cMarca + "' %"
	EndIf
	cCondicao += " .And. C9_NFISCAL == '" + Space( Len(C9_NFISCAL) ) + "' "
	cCondicao += " .And. C9_BLEST == '" + Space( Len(C9_BLEST) ) + "' .And. C9_BLCRED == '" + Space( Len(C9_BLCRED) ) + "' "
	cCondicao += " .And. (C9_XCONF == '" + Space( Len(C9_XCONF) ) + "' .Or. C9_XCONF == 'S') "
	
    IndRegua( "SC9", cArquivo, cIndice,, cCondicao, OemToAnsi("Selecionando Registros...") )

	nIndex := RetIndex("SC9")
	#IFNDEF TOP
		dbSetIndex(cArquivo + OrdBagExt())
	#ENDIF

	DbSelectArea("SC9")
	DbSetOrder(nIndex + 1)
	SC9->(DbGotop())
	While !SC9->(Eof()) .And. lRetorno
	
		// Fernando Nogueira - Verifica se tem item nao liberado no Pedido de Vendas
		BeginSQL Alias cAliasSC6
			SELECT * FROM
			(SELECT	C6_ITEM ITEMC6,ISNULL(C9_ITEM,'00') ITEMC9 FROM %Table:SC6% SC6
			LEFT JOIN %Table:SC9% SC9 ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND SC9.%NotDel%
			WHERE	SC6.%NotDel%
			AND 	C6_FILIAL = %Exp:xFilial("SC6")%
			AND		C6_NUM = %Exp:SC9->C9_PEDIDO%
			GROUP BY C6_ITEM,C9_ITEM) ITENSC6
			WHERE ITEMC9 = '00'
			ORDER BY ITEMC6
		EndSQL

		(cAliasSC6)->(dbGoTop())
	
		If !(cAliasSC6)->(Eof())
			cMens1   := "O(s) Item(ns) abaixo do Pedido "+AllTrim(SC9->C9_PEDIDO)+" estão em aberto no Pedido de Vendas:"+CHR(13)+CHR(10)
			
			While !(cAliasSC6)->(Eof())
				If Empty(cMens2)
					cMens2 := (cAliasSC6)->ITEMC6
				Else
					cMens2 += " - " + (cAliasSC6)->ITEMC6
				Endif
				(cAliasSC6)->(dbSkip())
			Enddo
			
			ApMsgAlert(cMens1+cMens2)
			lRetorno := .F.
			Exit
		EndIf
		
		(cAliasSC6)->(DbCloseArea())


		// Fernando Nogueira - Verifica se a quantidade liberada eh menor que a quantidade do Pedido
		BeginSQL Alias cAliasSC6_2
			SELECT	C6_ITEM ITEMC6 FROM %Table:SC6% SC6
			INNER JOIN %Table:SC9% SC9 ON C6_FILIAL = C9_FILIAL AND C6_NUM = C9_PEDIDO AND C6_ITEM = C9_ITEM AND SC9.%NotDel%
			WHERE	SC6.%NotDel%
			AND 	C6_FILIAL = %Exp:xFilial("SC6")%
			AND		C6_NUM    = %Exp:SC9->C9_PEDIDO%
			AND     C6_QTDEMP < C6_QTDVEN
		EndSQL

		(cAliasSC6_2)->(dbGoTop())
	
		If !(cAliasSC6_2)->(Eof())
			cMens1   := "O(s) Item(ns) abaixo do Pedido "+AllTrim(SC9->C9_PEDIDO)+" possuem a quantidade liberada menor que a quantidade do Pedido:"+CHR(13)+CHR(10)
			
			While !(cAliasSC6_2)->(Eof())
				If Empty(cMens2)
					cMens2 := (cAliasSC6_2)->ITEMC6
				Else
					cMens2 += " - " + (cAliasSC6_2)->ITEMC6
				Endif
				(cAliasSC6_2)->(dbSkip())
			Enddo
			
			ApMsgAlert(cMens1+cMens2)
			lRetorno := .F.
			Exit
		EndIf
		
		(cAliasSC6_2)->(DbCloseArea())


		// Fernando Nogueira - Verifica se tem item Pendente de Liberacao no Pedido de Vendas ou Nao Marcado
		BeginSQL Alias cAliasSC9
			SELECT	C9_ITEM	AS ITEMC9
			FROM	%Table:SC9%
			WHERE	%NotDel%
			AND 	C9_FILIAL = %Exp:xFilial("SC9")%
			AND		C9_PEDIDO = %Exp:SC9->C9_PEDIDO%
			AND     (%Exp:cCampo% OR C9_BLCRED <> ' ' OR C9_BLEST <> ' ' OR C9_BLWMS NOT IN ('05','06','07',' ') OR (C9_BLWMS IN ('05','06','07') AND C9_XCONF <> 'S'))
			GROUP BY C9_ITEM
			ORDER BY C9_ITEM
		EndSQL

		(cAliasSC9)->(dbGoTop())
	
		If !(cAliasSC9)->(Eof())
			cMens1   := "O(s) Item(ns) abaixo do Pedido "+AllTrim(SC9->C9_PEDIDO)+" estão Pendente(s) para Liberação, ou não foi(ram) marcado(s):"+CHR(13)+CHR(10)
			
			While !(cAliasSC9)->(Eof())
				If Empty(cMens2)
					cMens2 := (cAliasSC9)->ITEMC9
				Else
					cMens2 += " - " + (cAliasSC9)->ITEMC9
				Endif
				(cAliasSC9)->(dbSkip())
			Enddo
			
			ApMsgAlert(cMens1+cMens2)
			lRetorno := .F.
			Exit
		EndIf
		
		(cAliasSC9)->(DbCloseArea())
		
	
		cChave := PadR(SC9->C9_PEDIDO, TamSx3("DB_DOC")[1]) + PadR(SC9->C9_ITEM, TamSx3("DB_SERIE")[1]) + SC9->C9_CLIENTE + SC9->C9_LOJA + "001" + "003"
		
		DbSelectarea("SDB")
		SDB->(DbSetorder(6)) //DB_FILIAL+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA+DB_SERIVC+DB_TAREFA
		If SDB->(DbSeek(xFilial("SDB") + cChave))
			While !SDB->(Eof()) .And. 	SDB->DB_FILIAL == xFilial("SDB") .And.;
										SDB->DB_DOC + SDB->DB_SERIE + SDB->DB_CLIFOR + SDB->DB_LOJA + SDB->DB_SERVIC + SDB->DB_TAREFA == cChave
				
				If SDB->DB_ESTORNO == "S"
					SDB->(DbSkip())
					Loop
				EndIf
				
				If SDB->DB_STATUS <> "1"
					lRetorno := .F.
					Alert("O Ítem: " + SC9->C9_ITEM + " do pedido: " + SC9->C9_PEDIDO + " Ainda está pendente para Conferência, Não pode ser Faturado!!!")
					Exit
				EndIf
				
				SDB->(DbSkip())
			End
		EndIf
		
		ConOut("Ponto de Entrada M460MARK: "+SC9->C9_PEDIDO+" "+SC9->C9_ITEM+" "+SC9->C9_SEQUEN)
		
		SC9->(DbSkip())

	EndDo

	//Restaura os Filtros
	nIndex := RetIndex("SC9")
	SC9->(DbSetFilter({|| &cFiltro}, cFiltro))

	Dbselectarea(AliaSC9)
	Dbsetorder(IndeSC9)

	RestArea(aAreaAT)
	RestArea(aAreaC9)
	RestArea(aAreaDB)

Return lRetorno