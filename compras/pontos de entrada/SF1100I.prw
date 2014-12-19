#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SF1100I  บAutor  ณRodrigo Leite       บ Data ณ  30/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada para validar a inclusใo da Placa do Veiculoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SF1100I()

Local   oGet1
Local   oSay1
Local   oSButton1
Local   oSButton2
Local   aAreaSD1 := SD1->(GetArea())
Local   lTesEst := .F.
Local   cBusca  := ""
Private cGet1 := Space(TamSx3("F1_PLACA")[1])
Private lValid  := .F.
Static  oDlg

SD1->(DbSetOrder(1))
SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
cBusca := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

// Fernando Nogueira - Chamado 000418
While SD1->(!Eof()) .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cBusca .And. !lTesEst
	If Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ESTOQUE") == "S"
		lTesEst := .T.
	EndIf
	SD1->(dbSkip())
End

If Inclui .And. lTesEst .And. !IsBlind()

	If MSGYESNO("Deseja Informar a Placa do Veiculo?", "Placa do Veiculo")
	  
	 DEFINE MSDIALOG oDlg TITLE "Placa do Veiculo" FROM 000, 000  TO 200, 200 COLORS 0, 16777215 PIXEL
	
	    @ 000, 000 SAY oSay1 PROMPT "    Informe a Placa do Veiculo " SIZE 097, 020 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 036, 018 MSGET oGet1 VAR cGet1 PICTURE "@!" SIZE 056, 013 OF oDlg COLORS 0, 16777215 PIXEL
	
	    DEFINE SBUTTON oSButton1 FROM 080, 041 TYPE 01 OF oDlg ENABLE ACTION (VALIDATEL(lValid,cGet1))
	    DEFINE SBUTTON oSButton2 FROM 080, 068 TYPE 02 OF oDlg ENABLE ACTION (oDlg:End())
	
	  ACTIVATE MSDIALOG oDlg CENTERED
			
	EndIf


	If !Empty(cGet1)
   
		RecLock("SF1",.F.)
			SF1->F1_PLACA := cGet1
		MsUnlock()

	Endif

EndIf

SD1->(RestArea(aAreaSD1))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDATEL บAutor  ณMicrosiga           บ Data ณ  07/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDATEL(lValid,cGet1)

 If Empty(cGet1) 

   msgAlert("Informe a Placa do Veiculo") 
   
   Else   
   
  oDlg:End()
   
 Endif

Return()