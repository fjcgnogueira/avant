#INCLUDE "Protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M461COR  º Autor ³ Amedeo D. P. Filho º Data ³ 24/07/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cores do C9 no Browse.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT.                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function M461COR
	Local aPadrao	:= PARAMIXB
	Local aLegNew	:= {}
	Local nX		:= 0
	
	//dbSelectArea("SDB")
    
	//LjMsgRun("Atualizando Legenda","Por Favor Aguarde...", { || U_ATUAC9COR() })
	
	Aadd(aLegNew, { '!Empty(SC9->C9_BLOQUEI)', "BR_PRETO" })
	Aadd(aLegNew, { 'Empty(SC9->C9_BLEST)   .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  " .And. SC9->C9_XCONF <> "S"' , "BR_LARANJA" })
	Aadd(aLegNew, { '(Empty(SC9->C9_BLEST)  .And. Empty(SC9->C9_BLCRED) .And. (SC9->C9_BLWMS$"01,02,03" .Or. (SC9->C9_BLWMS$"05,06,07" .And. SC9->C9_XCONF <> "S")))', "BR_LARANJA" })
	Aadd(aLegNew, { '(Empty(SC9->C9_BLEST)  .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"05,06,07,  ")', "ENABLE" })
	Aadd(aLegNew, { 'SC9->C9_BLEST=="10"    .And. SC9->C9_BLCRED=="10"  .And. SC9->C9_BLWMS$"05,06,07,  "'           , "DISABLE" })
	Aadd(aLegNew, { '!(Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED) .And. SC9->C9_BLWMS$"01,02,03,05,06,07,  ")' , "BR_AZUL" })
	
	//For nX := 1 To Len(aPadrao)
		//Aadd(aLegNew, { aPadrao[nX][01],aPadrao[nX][02] })
	//Next nX

	//Adiciona botao de Filtro na Rotina de Prep. DOC de Saida
	//Aadd(aRotina, { 'Filtro (Avant)'		,'U_FLTM461("1")', 0 , 9} )
	//Aadd(aRotina, { 'Limpa Filtro (Avant)'	,'U_FLTM461("2")', 0 , 9} )

Return aLegNew

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCTION FLTM461 - Faz Filtro na Tela de Doc. de Saida       	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*User Function FLTM461(cTipo)
	Local aFiltro	:= {"1 - Região do Cliente"}
	Local cFiltro	:= "Selecione Filtro"
	Local cGetFilt	:= Space( TamSx3("A1_REGIAO")[1] )
	Local aAreaC9	:= SC9->(GetArea())
	Local aAreaA1	:= SA1->(GetArea())
	Local cFiltSel	:= ""
	Local lFirst	:= .T.
	Local lExist	:= .F.
	Local nOpcao	:= 0
	
	Local oGetFilt
	Local oDlg

	Public __cFltSC9X

	//Limpa Filtro
	If cTipo == "2"
		If ValType(__cFltSC9X) == "C"
			SC9->( DbClearFilter() )
			SC9->(DbSetFilter({|| &__cFltSC9X}, __cFltSC9X))
			SC9->( DbGotop() )
		EndIf
		Return Nil
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Definições de filtro" FROM 000, 000 TO 130,230 PIXEL

		@ 006,005 Say "Opcao de Filtro" Size 050, 008 PIXEL OF oDlg

		@ 022,045 MsGet oGetFilt Var cGetFilt Size 020, 008 PIXEL OF oDlg Picture "@!"

		@ 005,050 ComboBox cFiltro Items aFiltro Size 065, 010 PIXEL OF oDlg

		DEFINE SBUTTON FROM 040, 030 TYPE 1 ENABLE OF oDlg Action( nOpcao := 1, oDlg:End() )
		DEFINE SBUTTON FROM 040, 060 TYPE 2 ENABLE OF oDlg Action( nOpcao := 2, oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpcao == 1
	
		//Salva Filtro Atual
		__cFltSC9X	:= SC9->(MsDbFilter())
		cFiltSel	:= __cFltSC9X
		
		If !Empty(cGetFilt)

			If Left(cFiltro,1) == "1"
				DbSelectarea("SC9")
				SC9->(DbGotop())
				While !SC9->(Eof())

					DbSelectarea("SA1")
					SA1->(DbSetorder(1))
					If SA1->(DbSeek(xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA))
						If SA1->A1_REGIAO == cGetFilt
							lExist := .T.
							If lFirst
								lFirst := .F.
								cFiltSel += " .AND. C9_CLIENTE $ '"+Alltrim(SA1->A1_COD)+" "
							Else
								If !SA1->A1_COD $ cFiltSel
									cFiltSel += " /"+SA1->A1_COD+" "
								EndIf
							EndIf
						EndIf
					EndIf
				
					SC9->(DbSkip())
				End
				
				If lExist
					cFiltSel += "' "
				
					//Executa Filtro no TRB
					SC9->(DbSetFilter({|| &cFiltSel}, cFiltSel))
                    SC9->(DbGotop())
                    
				Else
					MsgInfo("Nenhum registro localizado no filtro selecionado, filtro não será executado","Verifique")
				EndIf
				
			EndIf

		EndIf
	EndIf

	RestArea(aAreaC9)
	RestArea(aAreaA1)
	
Return Nil*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCTION ATUAC9COR - Atualiza Campo de Cor no SC9            	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*User Function ATUAC9COR()
	Local aAreaC9	:= SC9->(GetArea())
	Local cChave	:= ""
	
	DbSelectArea("SC9")
	SC9->(DbGotop())
	While !SC9->(Eof())

		If !Empty(SC9->C9_NFISCAL)
			SC9->(DbSkip())
			Loop
		EndIf
		
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
					RecLock("SC9",.F.)
						SC9->C9_XCONF	:= "N"
					MsUnlock()
				Else
					RecLock("SC9",.F.)
						SC9->C9_XCONF	:= "S"
					MsUnlock()
				EndIf
				
				SDB->(DbSkip())
			End
		EndIf
		
		SC9->(DbSkip())

	EndDo
	

	RestArea(aAreaC9)
	
Return Nil*/