#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ALTVOLNF º Autor ³ Amedeo D. P. Filho º Data ³  17/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Altera volumes da NF de Saida.                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AVANT.                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ALTVOLNF()
	Local oFont0 	:= TFont():New("Verdana",,020,,.T.,,,,,.F.,.F.)
	Local oFont1 	:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)
	Local nOpcX		:= 0
	
	Private cGetNF 	:= Space( TamSx3("F2_DOC")[1] )
	Private cGetSr 	:= Space( TamSx3("F2_SERIE")[1] )
	Private nGetVol	:= 0
	Private lWhenA	:= .T.
	Private lWhenB	:= .F.
	Private lAchou	:= .F.
	
	Private oGetNF
	Private oGetSr
	Private oGetVol
	
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "Informar Volume na NF de Saída" FROM 000, 000  TO 220, 320 COLORS 0, 16777215 PIXEL
	
		@ 007, 006 SAY oSay1 PROMPT "Informar Volume na NF de Saída" SIZE 150, 010 OF oDlg FONT oFont0 COLORS 0, 16777215 PIXEL

		@ 030, 017 SAY oSay2 PROMPT "Nota Fiscal : " 	SIZE 050, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 045, 017 SAY oSay3 PROMPT "Série : " 			SIZE 050, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 070, 017 SAY oSay4 PROMPT "Volumes : " 		SIZE 050, 010 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL

		@ 030, 075 MSGET oGetNF VAR cGetNF 	SIZE 060, 010 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL When lWhenA
		@ 045, 075 MSGET oGetSr VAR cGetSr 	SIZE 030, 010 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL When lWhenA

		@ 045, 110 BUTTON oButton PROMPT "Buscar" SIZE 025, 011 OF oDlg PIXEL Action (BuscaNF())

		@ 070, 075 MSGET oGetVol VAR nGetVol	SIZE 030, 010 OF oDlg COLORS 0, 16777215 FONT oFont1 PIXEL When lWhenB Picture( PesqPictQT("F2_VOLUME1") )

		DEFINE SBUTTON oSButton1 FROM 092, 045 TYPE 01 OF oDlg ENABLE Action( IF(lAchou, (nOpcX := 1,oDlg:End()), Alert("Nota fiscal não encontrada")) )
		DEFINE SBUTTON oSButton2 FROM 092, 092 TYPE 02 OF oDlg ENABLE Action( nOpcX := 2, oDlg:End() )
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpcX == 1
		If MsgYesNo("Confirma gravação do Volume na Nota Fiscal")
			RecLock("SF2",.F.)
				SF2->F2_VOLUME1	:= nGetVol
			MsUnlock()
		Endif
	EndIf

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Function BUSCANF - Busca a Nota Fiscal            	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function BUSCANF()

	If Empty(cGetNF)
		Alert("Campo da NF deve ser Preenchido")
		Return Nil
	EndIf
	
	DbSelectarea("SF2")
	SF2->(DbSetorder(1))
	If SF2->(DbSeek(xFilial("SF2") + cGetNF + cGetSr))
		lWhenB	:= .T.
		lWhenA	:= .F.
		lAchou	:= .T.
		nGetVol	:= SF2->F2_VOLUME1
		oGetNF:Refresh()
		oGetSr:Refresh()
		oGetVol:Refresh()
	Else
		Alert("Nota fiscal não encontrada")
		lWhenB	:= .F.
		lWhenA	:= .T.
		lAchou	:= .F.
		nGetVol	:= 0
		oGetNF:Refresh()
		oGetSr:Refresh()
		oGetVol:Refresh()
	EndIf

Return Nil