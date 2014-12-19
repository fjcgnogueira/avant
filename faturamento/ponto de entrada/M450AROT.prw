#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M450AROT º Autor ³ Amedeo D. P. Filho º Data ³  24/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ P.E. para adicionar botao na tela de analise de credito    º±±
±±º          ³ cliente.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M450AROT()
	Local aRotina	:= {}

	Aadd(aRotina, { 'Filtro (Avant)'		,'U_FLTM450("1")', 0 , 2} )
	Aadd(aRotina, { 'Limpa Filtro (Avant)'	,'U_FLTM450("2")', 0 , 3} )

Return aRotina

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FLTM450  º Autor ³ Amedeo D. P. Filho º Data ³  24/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela com Filtro na Rotina de Analise de Credito Cliente    º±±
±±º          ³ ExpC1 - 1 = Monta o Filtro                                 º±±
±±º          ³ ExpC1 - 2 = Limpra Filtro                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ M450AROT                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FLTM450(cTipo)
	
	Local aFiltro	:= {"1 - Nome do Cliente","2 - Nome Fantasia","3 - CNPJ do Cliente"}
	Local cFiltro	:= "Selecione Filtro"
	Local cFiltSel	:= ""
	Local cGetFilt	:= Space(40)
	Local nOpcao	:= 0
	
	Local oGetFilt

	Static oDlg
	
	//Limpa Filtro
	If cTipo == "2"
		TRB->( DbClearFilter() )
		TRB->( DbGotop() )
		Return Nil
	EndIf
	
	DEFINE MSDIALOG oDlg TITLE "Definições de filtro" FROM 000, 000 TO 130,420 PIXEL

		@ 006,005 Say "Opcao de Filtro" Size 050, 008 PIXEL OF oDlg

		@ 020,005 MsGet oGetFilt Var cGetFilt Size 200, 008 PIXEL OF oDlg Picture "@!"

		@ 005,050 ComboBox cFiltro Items aFiltro Size 065, 010 PIXEL OF oDlg

		DEFINE SBUTTON FROM 040, 075 TYPE 1 ENABLE OF oDlg Action( nOpcao := 1, oDlg:End() )
		DEFINE SBUTTON FROM 040, 105 TYPE 2 ENABLE OF oDlg Action( nOpcao := 2, oDlg:End() )

	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpcao == 1
		If !Empty(cGetFilt)

			If Left(cFiltro,1) == "1"
				cFiltSel += '('+'"'+AllTrim(cGetFilt)+'"'+' $ TRB->A1_NOME)'

			ElseIf Left(cFiltro,1) == "2"
				cFiltSel += '('+'"'+AllTrim(cGetFilt)+'"'+' $ TRB->A1_NREDUZ)'

			ElseIf Left(cFiltro,1) == "3"
				DbSelectarea("SA1")
				SA1->(DbSetorder(3))
				If SA1->(DbSeek(xFilial("SA1") + Alltrim(cGetFilt)))
					cFiltSel := " TRB->A1_COD == '"+SA1->A1_COD+"' .And. TRB->A1_LOJA == '"+SA1->A1_LOJA+"' "
				Else
					MsgAlert("CPF/CNPJ: " + Alltrim(cGetFilt) + " Não econtrado no cadastro de clientes","Verifique")
					Return Nil
				EndIf
			
			EndIf

			//Executa Filtro no TRB
			TRB->(DbSetFilter({|| &cFiltSel}, cFiltSel))
			
		EndIf
	EndIf

Return Nil