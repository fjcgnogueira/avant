#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ UFBDST()     บ Autor ณ Fernando Nogueira  บ Data ณ27/12/2017บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Determina os Estados que calculam base dupla de ST          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                                           บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                            บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                                บฑฑ
ฑฑศออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UFBDST()                                      

Local cMens		:= 'Estados para a base dupla do ST: '
Local cEOL		:= Chr(13)+Chr(10)
Local bConfirma	:= {||If(AllTrim(cEstados)<>AllTrim(GetMv("MV_UFBDST")),PutMV("MV_UFBDST",cEstados),),MsgInfo(cMens+AllTrim(cEstados)),oDlgBDST:End()}

Static oDlgBDST
Static oButCancela
Static oButConfirma
Static cEstados := Padr(GetMv("MV_UFBDST"),80)
Static oCheckBoxFech
Static oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Static oFont2 := TFont():New("Arial",,017,,.T.,,,,,.F.,.F.)
Static oGroup1
Static oSayFin

  DEFINE MSDIALOG oDlgBDST TITLE "Estados com Base Dupla Difal ST" FROM 000, 000  TO 260, 600 COLORS 0, 16777215 PIXEL

    @ 005, 005 GROUP oGroup1 TO 103, 295 PROMPT "Estados com Base Dupla Difal ST" OF oDlgBDST COLOR 0, 16777215 PIXEL
    @ 020, 010 SAY oSayFin PROMPT "Informe os Estados com Base Dupla Difal ST" SIZE 275, 014 OF oDlgBDST FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 038, 010 SAY oSayFin PROMPT "Ex: SP|MG|MT" SIZE 275, 014 OF oDlgBDST FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 063, 010 MSGET cEstados SIZE 280, 008 OF oDlgBDST COLORS 0, 16777215 FONT oFont2 PIXEL
    @ 110, 200 BUTTON oButConfirma PROMPT "Confirma" SIZE 037, 012 ACTION(Eval(bConfirma)) OF oDlgBDST FONT oFont2 PIXEL
    @ 110, 250 BUTTON oButCancela PROMPT "Cancela" SIZE 037, 012 ACTION(oDlgBDST:End()) OF oDlgBDST FONT oFont2 PIXEL
  ACTIVATE MSDIALOG oDlgBDST CENTERED

Return