#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ESP430   ºAutor  ³ Guilherme Santos   º Data ³  27/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao dos Titulos COB acionado no Final da Geracao da NF º±±
±±º          ³ de Saida.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ESP430(cSerie, cNFSaida, cMensagem)
	Local aArea		:= GetArea()
	Local aAreaSF2	:= GetArea()
	Local aAreaSE1	:= GetArea()
	Local cPrefixo	:= SuperGetMV("ET_TSTPREF", NIL, "COB")
	Local cTipo		:= SuperGetMV("ET_TSTTIPO", NIL, "FT ")
	Local cNatureza	:= SuperGetMV("ET_TSTNATU", NIL, "001       ")
	Local cTipoNFS	:= SuperGetMV("ET_TSTTPNF", NIL, "N|C|I|P")
	Local cCliente	:= ""
	Local cLojaCli	:= ""
	Local cTitulo	:= ""
	Local cVendedor	:= "" 
	Local cPedido	:= ""
	Local cCNPJCli	:= ""
	Local cQuery	:= ""
	Local nVlrTit	:= 0
	Local oTitRec	:= uTitReceber():New()
	Local lParc1	:= .F.
	Local dVencto	:= dDataBase + SuperGetMV("ET_TSTVENC", NIL, 30)
	Local nNewVenc	:= SuperGetMV("ET_QTDIASV", NIL, 0)
	Local lGeraCob	:= SuperGetMV("ET_TSTGERA", NIL, .F.)

	Local lRetorno		:= .F.	//Amedeo (Inicializa Retorno Como Falso, Caso Gere o Titulo Retorna Verdadeiro)
	
	If lGeraCob
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamentos e Validacoes para a Gravacao do Titulo a Receber.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SF2")
		DbSetOrder(1)		//F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
		
		If SF2->(DbSeek(xFilial("SF2") + cNFSaida + cSerie))
			cCliente	:= SF2->F2_CLIENTE
			cLojaCli	:= SF2->F2_LOJA
			cTitulo		:= SF2->F2_DOC
			cVendedor	:= SF2->F2_VEND1
			cPedido     := SC5->C5_NUM
			
			If SF2->F2_TIPO $ cTipoNFS
				DbSelectArea("SA1")
				DbSetOrder(1)
		
				If SA1->(DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))
					cCNPJCli	:= SA1->A1_CGC
					lParc1		:= If(SA1->(FieldPos("A1_X_DTCOB")) > 0, SA1->A1_X_DTCOB == "S", .F.)

					If lParc1
						DbSelectArea("SE1")
						DbSetOrder(1)	//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
						
						If SE1->(DbSeek(xFilial("SE1") + cSerie + cNFSaida))
							dVencto := SE1->E1_VENCTO
						EndIf
					EndIf

					// Caso seja a Filial 02 ou 03
					If cFilAnt == "02" .OR. cFilAnt == "03"
						nNewVenc := SuperGetMV("ET_QTDIASV", NIL, 0)

						// Caso parametro exista e seja maior que ZERO DIAS
						If nNewVenc > 0
							dVencto := dVencto + nNewVenc
						EndIf
					EndIf
				EndIf
		
				cQuery += "SELECT SUM(SD2.D2_ICMSRET) ICMSRET" + CRLF
				
				cQuery += "FROM	" + RetSqlName("SF2") + " SF2" + CRLF
				cQuery += ",	" + RetSqlName("SD2") + " SD2" + CRLF
				cQuery += ",	" + RetSqlName("SF4") + " SF4" + CRLF
				cQuery += ",	" + RetSqlName("SC5") + " SC5" + CRLF
				
				cQuery += "WHERE	SF2.F2_FILIAL = '" + xFilial("SF2") + "'" + CRLF
				cQuery += "AND		SD2.D2_FILIAL = '" + xFilial("SD2") + "'" + CRLF
				cQuery += "AND		SF4.F4_FILIAL = '" + xFilial("SF4") + "'" + CRLF
				cQuery += "AND		SC5.C5_FILIAL = '" + xFilial("SC5") + "'" + CRLF
				
				cQuery += "AND		SF2.F2_DOC = '" + SF2->F2_DOC + "'" + CRLF
				cQuery += "AND		SF2.F2_SERIE = '" + SF2->F2_SERIE + "'" + CRLF
				cQuery += "AND		SF4.F4_INCSOL = 'N'" + CRLF		//Somente Subst. Trib. nao Incluida no Total da NF
				cQuery += "AND		SF4.F4_DUPLIC = 'S'" + CRLF		//Somente quando Gera Duplicata
				cQuery += "AND		SC5.C5_X_SITUA = 'N'" + CRLF	//Somente Tabela 01
				cQuery += "AND		SF4.F4_CF <> '5405'" + CRLF		//Nao Inclui Subst. Trib. Recolhida na Entrada do Produto
				
				cQuery += "AND		SF2.F2_SERIE = SD2.D2_SERIE" + CRLF
				cQuery += "AND		SF2.F2_DOC = SD2.D2_DOC" + CRLF
				cQuery += "AND		SF2.F2_CLIENTE = SD2.D2_CLIENTE" + CRLF
				cQuery += "AND		SF2.F2_LOJA = SD2.D2_LOJA" + CRLF
				cQuery += "AND		SD2.D2_TES = SF4.F4_CODIGO" + CRLF
				cQuery += "AND		SD2.D2_PEDIDO = SC5.C5_NUM" + CRLF
				
				cQuery += "AND		SD2.D2_BRICMS > 0" + CRLF
				cQuery += "AND		SD2.D2_ICMSRET > 0" + CRLF
				
				cQuery += "AND		SF2.D_E_L_E_T_ = ''" + CRLF
				cQuery += "AND		SD2.D_E_L_E_T_ = ''" + CRLF
				cQuery += "AND		SF4.D_E_L_E_T_ = ''" + CRLF
				cQuery += "AND		SC5.D_E_L_E_T_ = ''" + CRLF
				
				cQuery := ChangeQuery(cQuery)
				
				If Select("TRB") > 0
					TRB->(DbCloseArea())
				EndIf
		
				DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), "TRB", .T., .T.)
		
				While !TRB->(Eof())
					nVlrTit += TRB->ICMSRET
					TRB->(DbSkip())
				End
		
				If Select("TRB") > 0
					TRB->(DbCloseArea())
				EndIf
			Else
				cMensagem := " - Tipo de Nota Diferente de " + cTipoNFS
			EndIf
		Else
			cMensagem := " - Nota de Saída não Localizada"
		EndIf
	
		If nVlrTit > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Campos do Titulo.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oTitRec:AddValues("E1_PREFIXO"	, cPrefixo)
			oTitRec:AddValues("E1_NUM"		, cTitulo)
			oTitRec:AddValues("E1_PARCELA"	, Space(TamSX3("E1_PARCELA")[01]))
			oTitRec:AddValues("E1_TIPO"		, cTipo)
			oTitRec:AddValues("E1_NATUREZ"	, cNatureza)
			oTitRec:AddValues("E1_CLIENTE"	, cCliente)
			oTitRec:AddValues("E1_LOJA"		, cLojaCli)
			oTitRec:AddValues("E1_EMISSAO"	, dDataBase)
			oTitRec:AddValues("E1_VENCTO"	, dVencto)
			oTitRec:AddValues("E1_VALOR"	, nVlrTit)
			oTitRec:AddValues("E1_HIST"		, "NF " + cTitulo)
			oTitRec:AddValues("E1_VEND1"	, cVendedor)
			oTitRec:AddValues("E1_COMIS1"	, 0)		//Zerar a Comissão pois este Titulo não pagara Comissão
			oTitRec:AddValues("E1_FLUXO"	, "S")		//Entra no Fluxo de Caixa? S/N
			oTitRec:AddValues("E1_CNPJ"		, cCNPJCli)
			oTitRec:AddValues("E1_PEDIDO"	, cPedido)

			If !oTitRec:Gravacao(3)
				Aviso("Aviso", "Erro durante a Inclusão do Titulo COB: " + CRLF + oTitRec:GetMensagem(), {"Abandona"})
				cMensagem := " - Erro apresentado na Tela"
			Else
				lRetorno := .T.
			EndIf
		Else
			cMensagem := " - Valor Retido está zerado"
		EndIf
	EndIf

	RestArea(aAreaSE1)
	RestArea(aAreaSF2)
	RestArea(aArea)

Return lRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ E430ExNF ºAutor  ³ Guilherme Santos   º Data ³  30/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se o Titulo COB pode ser excluido para Liberar a  º±±
±±º          ³ exclusao da NF de Saida.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function E430ExNF(cNFSaida)
	Local aArea		:= GetArea()
	Local aAreaSF2	:= GetArea()
	Local aAreaSE1	:= GetArea()
	Local cPrefixo	:= SuperGetMV("ET_TSTPREF", NIL, "COB")
	Local cTipo		:= SuperGetMV("ET_TSTTIPO", NIL, "FT ")
	Local cBotao	:= "Abandona"
	Local cTitulo	:= "Aviso"
	Local cMsgBaixa	:= "Esta NF não pode ser excluída, pois possui um Titulo a Receber referente a Cobrança de Subst. Tributária já Baixado. Providencie o Estorno dessa Baixa com a Cobrança."
	Local cMsgData	:= "Esta NF não pode ser excluída, pois possui um Titulo a Receber referente a Cobrança de Subst. Tributária que não pode ser Excluído. Providencie a Exclusão manual deste Título com a Cobrança."
	Local cMsgCart	:= "Esta NF não pode ser excluída, pois possui um Titulo a Receber referente a Cobrança de Subst. Tributária que não está em Carteira. Verifique com a Cobrança."
	Local lRetorno	:= .T.
	Local lGeraCob	:= SuperGetMV("ET_TSTGERA", NIL, .F.)

	If lGeraCob
		DbSelectArea("SE1")
		DbSetOrder(1)		//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
		
		If SE1->(DbSeek(xFilial("SE1") + cPrefixo + cNFSaida + Space(TamSX3("E1_PARCELA")[01]) + cTipo))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o titulo foi baixado total ou parcialmente      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SE1->E1_BAIXA) .OR. (SE1->E1_VALOR != SE1->E1_SALDO)
				Aviso(cTitulo, cMsgBaixa, {cBotao})
				lRetorno := .F.
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se data do movimento nao e menor que data limite de ³
			//³ movimentacao no financeiro.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !DtMovFin()
				Aviso(cTitulo, cMsgData, {cBotao})
				lRetorno := .F.
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o titulo est  em carteira, pois os que nao      ³
			//³ estiverem, nao serao deletados.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SE1->E1_SITUACA != "0"
				Aviso(cTitulo, cMsgCart, {cBotao})
				lRetorno := .F.
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSE1)
	RestArea(aAreaSF2)
	RestArea(aArea)
Return lRetorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ E430ExTi ºAutor  ³ Guilherme Santos   º Data ³  30/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclusao do Titulo COB apos a Exclusao da NF de Saida.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Avant                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function E430ExTi(cNFSaida)
	Local aArea		:= GetArea()
	Local aAreaSF2	:= GetArea()
	Local aAreaSE1	:= GetArea()
	Local cPrefixo	:= SuperGetMV("ET_TSTPREF", NIL, "COB")
	Local cTipo		:= SuperGetMV("ET_TSTTIPO", NIL, "FT ")
	Local cNatureza	:= SuperGetMV("ET_TSTNATU", NIL, "001       ")
	Local lRetorno	:= .T.
	Local oTitRec	:= uTitReceber():New()
	Local lGeraCob	:= SuperGetMV("ET_TSTGERA", NIL, .F.)

	If lGeraCob
		DbSelectArea("SE1")
		DbSetOrder(1)		//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
		
		If SE1->(DbSeek(xFilial("SE1") + cPrefixo + cNFSaida + Space(TamSX3("E1_PARCELA")[01]) + cTipo))
			oTitRec:AddValues("E1_PREFIXO", cPrefixo)
			oTitRec:AddValues("E1_NUM", cNFSaida)
			oTitRec:AddValues("E1_PARCELA", Space(TamSX3("E1_PARCELA")[01]))
			oTitRec:AddValues("E1_TIPO", cTipo)
			oTitRec:AddValues("E1_CLIENTE", SE1->E1_CLIENTE)
			oTitRec:AddValues("E1_LOJA", SE1->E1_LOJA)
			oTitRec:AddValues("E1_EMISSAO", SE1->E1_EMISSAO)
			oTitRec:AddValues("E1_VALOR", SE1->E1_VALOR)
			oTitRec:AddValues("E1_CNPJ", SE1->E1_CNPJ)
	
			If !oTitRec:Gravacao(5)
				Aviso("Aviso", "Erro durante a Exclusão do Titulo COB: " + CRLF + oTitRec:GetMensagem(), {"Abandona"})
				lRetorno := .F.
			EndIf
		EndIf
	EndIf

	RestArea(aAreaSE1)
	RestArea(aAreaSF2)
	RestArea(aArea)
Return lRetorno
