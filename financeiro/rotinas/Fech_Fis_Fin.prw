#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณFech_Fis_Fin()บ Autor ณ Fernando Nogueira  บ Data ณ19/02/2015บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Determina Fechamento Fiscal e Financeiro                    บฑฑ
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
User Function Fech_Fis_Fin()                                      

Local cMensFin  := 'Data do Fechamento Fin: '
Local cMensFis  := 'Data do Fechamento Fis: '
Local cEOL		:= Chr(13)+Chr(10)
Local bConfirma := {||If(dFechFin<>GetMv("MV_DATAFIN"),PutMV("MV_DATAFIN",dFechFin),.T.),If(dFechFis<>GetMv("MV_DATAFIS"),PutMV("MV_DATAFIS",dFechFis),.T.),MsgInfo(cMensFin+DTOC(dFechFin)+cEOL+cMensFis+DTOC(dFechFis)),oDlgFech:End()}

Static oDlgFech
Static oButCancela
Static oButConfirma
Static dFechFin := GetMv("MV_DATAFIN")
Static dFechFis := GetMv("MV_DATAFIS")
Static oCheckBoxFech
Static oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Static oFont2 := TFont():New("Arial",,017,,.T.,,,,,.F.,.F.)
Static oGroup1
Static oSayFin

  DEFINE MSDIALOG oDlgFech TITLE "Fechamento Fin/Fis" FROM 000, 000  TO 260, 600 COLORS 0, 16777215 PIXEL

    @ 005, 005 GROUP oGroup1 TO 103, 295 PROMPT "Fechamento Financeiro e Fiscal" OF oDlgFech COLOR 0, 16777215 PIXEL
    @ 020, 010 SAY oSayFin PROMPT "Data do Fechamento Financeiro" SIZE 275, 014 OF oDlgFech FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 038, 010 MSGET dFechFin SIZE 050, 008 OF oDlgFech COLORS 0, 16777215 FONT oFont2 PIXEL
    @ 063, 010 SAY oSayFin PROMPT "Data do Fechamento Fiscal" SIZE 275, 014 OF oDlgFech FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 080, 010 MSGET dFechFis SIZE 050, 008 OF oDlgFech COLORS 0, 16777215 FONT oFont2 PIXEL
    @ 110, 200 BUTTON oButConfirma PROMPT "Confirma" SIZE 037, 012 ACTION(Eval(bConfirma)) OF oDlgFech FONT oFont2 PIXEL
    @ 110, 250 BUTTON oButCancela PROMPT "Cancela" SIZE 037, 012 ACTION(oDlgFech:End()) OF oDlgFech FONT oFont2 PIXEL
  ACTIVATE MSDIALOG oDlgFech CENTERED

Return