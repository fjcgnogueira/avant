#include "PROTHEUS.CH"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ConcBaixas     บ Autor ณ Fernando Nogueira  บ Data ณ16/08/2016บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Concilia Baixas a Receber                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                         บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                              บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                                  บฑฑ
ฑฑศออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConcBaixas()

Local oReport

Private cPerg    := PadR("CONCBAIXA",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)

If Pergunte(cPerg,.T.)
	If mv_par03 == 1 .Or. mv_par03 == 3
		oReport := RepDef1()
		oReport:PrintDialog()
	ElseIf mv_par03 == 2 .Or. mv_par03 == 4
		oReport := RepDef2()
		oReport:PrintDialog()
	Else
		ApMsgInfo("Escolha um relat๓rio")
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ RepDef1()   บ Autor ณ Fernando Nogueira  บ Data ณ12/08/2016บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Def Nao contabilizou                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RepDef1()
Local oReport
Local oSection1
Local oBreak
Local _cTitulo := ""
Local _cTipo   := ""

Private aCtbDup   := {}

If mv_par04 == 1
	_cTipo = 'NF'
ElseIf mv_par04 == 2
	_cTipo = 'Cheque'
Else
	_cTipo = 'NCC'
Endif

If mv_par03 == 1
	_cTitulo := "Baixa "+_cTipo+" Nใo Contabilizada"
ElseIf mv_par03 == 3
	_cTitulo := "Baixa Desconto "+_cTipo+" Nใo Contabilizada"
Endif

oReport := TReport():New("CONCBAIXA",_cTitulo,"CONCBAIXA",{|oReport| PrintReport(oReport)},_cTitulo)
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"CONCBAIXA",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"E5_PREFIXO","TRB","Serie"       ,,TamSx3("E5_PREFIXO")[1])
TRCell():New(oSection1,"E5_NUMERO" ,"TRB","Numero"      ,,TamSx3("E5_NUMERO")[1])
TRCell():New(oSection1,"E5_PARCELA","TRB","Parc."       ,,TamSx3("E5_PARCELA")[1])
TRCell():New(oSection1,"E5_CLIFOR" ,"TRB","Cliente"     ,,TamSx3("E5_CLIFOR")[1])
TRCell():New(oSection1,"E5_LOJA"   ,"TRB","Lj"          ,,TamSx3("E5_LOJA")[1])
TRCell():New(oSection1,"E5_DATA"   ,"TRB","Data"        ,,12,,{||STOD(TRB->E5_DATA)})
TRCell():New(oSection1,"E5_DTDISPO","TRB","Disponib."   ,,12,,{||STOD(TRB->E5_DTDISPO)})
TRCell():New(oSection1,"E5_LA"     ,"TRB","Flg"         ,,TamSx3("E5_LA")[1])
TRCell():New(oSection1,"E5_TIPODOC","TRB","Tp Bx"       ,,TamSx3("E5_TIPODOC")[1])
TRCell():New(oSection1,"E5_MOTBX"  ,"TRB","Motivo"      ,,TamSx3("E5_MOTBX")[1])
TRCell():New(oSection1,"E5_VALOR"  ,"TRB","Valor"       ,PesqPict("SE5","E5_VALOR"),TamSx3("E5_VALOR")[1])
TRCell():New(oSection1,"E5_VLMULTA","TRB","Multa"       ,PesqPict("SE5","E5_VLMULTA"),TamSx3("E5_VLMULTA")[1])
TRCell():New(oSection1,"E5_VLJUROS","TRB","Juros"       ,PesqPict("SE5","E5_VLJUROS"),TamSx3("E5_VLJUROS")[1])
TRCell():New(oSection1,"E5_VLDESCO","TRB","Desc."       ,PesqPict("SE5","E5_VLDESCO"),TamSx3("E5_VLDESCO")[1])
TRCell():New(oSection1,"E5_BANCO"  ,"TRB","Banco"       ,,TamSx3("E5_BANCO")[1])
TRCell():New(oSection1,"E5_AGENCIA","TRB","Ag."         ,,TamSx3("E5_AGENCIA")[1])
TRCell():New(oSection1,"E5_CONTA"  ,"TRB","Conta"       ,,TamSx3("E5_CONTA")[1])
TRCell():New(oSection1,"E5_BENEF"  ,"TRB","Beneficiario",,TamSx3("E5_BENEF")[1])
TRCell():New(oSection1,"E5_HISTOR" ,"TRB","Historico"   ,,TamSx3("E5_HISTOR")[1])

TRFunction():New(oSection1:Cell("E5_NUMERO") ,"Quant. Itens","COUNT",,"Quant. Itens",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VALOR")  ,"Total Valor" ,"SUM",,"Total Valor",PesqPict("SE5","E5_VALOR")  ,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLMULTA"),"Total Multa" ,"SUM",,"Total Multa",PesqPict("SE5","E5_VLMULTA"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLJUROS"),"Total Juros" ,"SUM",,"Total Juros",PesqPict("SE5","E5_VLJUROS"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLDESCO"),"Total Desc." ,"SUM",,"Total Desc.",PesqPict("SE5","E5_VLDESCO"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ RepDef2()   บ Autor ณ Fernando Nogueira  บ Data ณ17/08/2016บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Def Valor Divergente                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RepDef2()
Local oReport
Local oSection1
Local oBreak
Local _cTitulo := ""
Local _cTipo   := ""

Private aCtbDup   := {}

If mv_par04 == 1
	_cTipo = 'NF'
ElseIf mv_par04 == 2
	_cTipo = 'Cheque'
Else
	_cTipo = 'NCC'
Endif

If mv_par03 == 2
	_cTitulo := "Valor da Baixa "+_cTipo+" Divergente do Contabil"
ElseIf mv_par03 == 4
	_cTitulo := "Valor da Baixa do Desconto "+_cTipo+" Divergente do Contabil"
Endif

oReport := TReport():New("CONCBAIXA",_cTitulo,"CONCBAIXA",{|oReport| PrintReport(oReport)},_cTitulo)
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"CONCBAIXA",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"E5_PREFIXO","TRB","Serie"       ,,TamSx3("E5_PREFIXO")[1])
TRCell():New(oSection1,"E5_NUMERO" ,"TRB","Numero"      ,,TamSx3("E5_NUMERO")[1])
TRCell():New(oSection1,"E5_PARCELA","TRB","Parc."       ,,TamSx3("E5_PARCELA")[1])
TRCell():New(oSection1,"E5_CLIFOR" ,"TRB","Cliente"     ,,TamSx3("E5_CLIFOR")[1])
TRCell():New(oSection1,"E5_LOJA"   ,"TRB","Lj"          ,,TamSx3("E5_LOJA")[1])
TRCell():New(oSection1,"E5_DATA"   ,"TRB","Data"        ,,12,,{||STOD(TRB->E5_DATA)})
TRCell():New(oSection1,"E5_DTDISPO","TRB","Disponib."   ,,12,,{||STOD(TRB->E5_DTDISPO)})
TRCell():New(oSection1,"E5_LA"     ,"TRB","Flg"         ,,TamSx3("E5_LA")[1])
TRCell():New(oSection1,"E5_TIPODOC","TRB","Tp Bx"       ,,TamSx3("E5_TIPODOC")[1])
TRCell():New(oSection1,"E5_MOTBX"  ,"TRB","Motivo"      ,,TamSx3("E5_MOTBX")[1])
TRCell():New(oSection1,"E5_VALOR"  ,"TRB","Valor"       ,PesqPict("SE5","E5_VALOR")  ,TamSx3("E5_VALOR")[1])
TRCell():New(oSection1,"E5_VLMULTA","TRB","Multa"       ,PesqPict("SE5","E5_VLMULTA"),TamSx3("E5_VLMULTA")[1])
TRCell():New(oSection1,"E5_VLJUROS","TRB","Juros"       ,PesqPict("SE5","E5_VLJUROS"),TamSx3("E5_VLJUROS")[1])
TRCell():New(oSection1,"E5_VLDESCO","TRB","Desc."       ,PesqPict("SE5","E5_VLDESCO"),TamSx3("E5_VLDESCO")[1])
TRCell():New(oSection1,"CT2_VALOR" ,"TRB","Valor Ctb."  ,PesqPict("CT2","CT2_VALOR") ,TamSx3("CT2_VALOR")[1])
TRCell():New(oSection1,"E5_BANCO"  ,"TRB","Banco"       ,,TamSx3("E5_BANCO")[1])
TRCell():New(oSection1,"E5_AGENCIA","TRB","Ag."         ,,TamSx3("E5_AGENCIA")[1])
TRCell():New(oSection1,"E5_CONTA"  ,"TRB","Conta"       ,,TamSx3("E5_CONTA")[1])
TRCell():New(oSection1,"E5_BENEF"  ,"TRB","Beneficiario",,TamSx3("E5_BENEF")[1])
TRCell():New(oSection1,"E5_HISTOR" ,"TRB","Historico"   ,,TamSx3("E5_HISTOR")[1])

TRFunction():New(oSection1:Cell("E5_NUMERO") ,"Quant. Itens","COUNT",,"Quant. Itens",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VALOR")  ,"Total Valor" ,"SUM",,"Total Valor",PesqPict("SE5","E5_VALOR")  ,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLMULTA"),"Total Multa" ,"SUM",,"Total Multa",PesqPict("SE5","E5_VLMULTA"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLJUROS"),"Total Juros" ,"SUM",,"Total Juros",PesqPict("SE5","E5_VLJUROS"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLDESCO"),"Total Desc." ,"SUM",,"Total Desc.",PesqPict("SE5","E5_VLDESCO"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CT2_VALOR") ,"Total Ctb."  ,"SUM",,"Total Ctb." ,PesqPict("CT2","CT2_VALOR") ,/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PrintReport บ Autor ณ Fernando Nogueira  บ Data ณ12/08/2016บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de tratamento das informacoes do Relatorio   	   	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

If mv_par03 == 1 .Or. mv_par03 == 3
	LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GerArqTRB1(),CursorArrow()})
ElseIf mv_par03 == 2 .Or. mv_par03 == 4
	LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GerArqTRB2(),CursorArrow()})
Endif

DbSelectArea('TRB')
DbGotop()
Count To nRegua
DbGotop()

oReport:SetMeter(nRegua)

oSection1:Init()

While (!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:PrintLine()	
	
	oReport:IncMeter()
	
	DbSkip()
End

oSection1:Finish()

TRB->(DbCloseArea())

oReport:SetTotalInLine(.F.)
oReport:SetTotalText("T O T A L ")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerArqTRB1บAutor  ณ Fernando Nogueira  บ Data ณ 12/08/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTRB Nao contabilizou                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerArqTRB1()

Local _cInner := '%%'
Local _cWhere := '%%'

If mv_par04 == 1
	_cTipo = "%'NF'%"
ElseIf mv_par04 == 2
	_cTipo = "%'CH'%"
Else
	_cTipo = "%'NCC'%"
Endif

If mv_par03 == 1
	_cInner := "%CV3_HIST NOT LIKE '%MULTA/JUROS%' AND CV3_HIST NOT LIKE '%MUL/JUR%' AND CV3_HIST NOT LIKE '%BAIXA JUROR%' AND CV3_HIST NOT LIKE '%BAIXA JUROS%' AND CV3_HIST NOT LIKE '%BX JUROS%' AND CV3_HIST NOT LIKE '%DESCONT %'%"
	_cWhere := '%AND E5_VALOR > 0%'
ElseIf mv_par03 == 3
	_cInner := "%CV3_HIST LIKE '%DESCONT %'%"
	_cWhere := '%AND E5_VLDESCO > 0%'
Endif

BeginSql alias 'TRB'

	SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_DATA,E5_DTDISPO,E5_LA,E5_TIPODOC,E5_MOTBX,E5_TIPO,E5_VALOR,E5_VLDESCO,E5_VLMULTA,E5_VLJUROS,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_BENEF,E5_HISTOR FROM %table:SE5% SE5
	LEFT JOIN %table:CV3% CV3 ON E5_FILIAL = CV3_FILIAL AND CV3_TABORI = 'SE5' AND SE5.R_E_C_N_O_ = CV3_RECORI AND CV3_VLR01 > 0 AND CV3_DTSEQ BETWEEN %Exp:DtoS(mv_par01-60)% AND %Exp:DtoS(mv_par02+60)% AND %Exp:_cInner% AND CV3.%notDel% AND CV3_RECDES IN (SELECT TMP.R_E_C_N_O_ FROM %table:CT2% TMP WHERE TMP.CT2_FILIAL = CV3_FILIAL AND TMP.R_E_C_N_O_ = CV3_RECDES AND TMP.%notDel%)
	LEFT JOIN %table:CT2% CT2 ON E5_FILIAL = CT2_FILIAL AND CT2.R_E_C_N_O_ = CV3_RECDES AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND CT2_CREDIT = '110503002' AND CT2_VALOR > 0 AND CT2.%notDel%
	WHERE SE5.%notDel%
		AND E5_FILIAL = %xfilial:SE5% 
		AND E5_DTDISPO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)%
		AND E5_RECPAG = 'R' 
		AND E5_TIPODOC NOT IN ('TR','DC','D2','JR','J2','MT','M2','DB','ES','CP') // Transf para Descontado/Desc/Juros/Multa/Desp Banc/Estorno Contas a Pagar/Compensacoes
		AND E5_SITUACA <> 'C' // Baixa nao cancelada
		AND E5_TIPO = %Exp:_cTipo%
		AND CT2.R_E_C_N_O_ IS NULL
		%Exp:_cWhere%
	ORDER BY SE5.R_E_C_N_O_

EndSql
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerArqTRB2บAutor  ณ Fernando Nogueira  บ Data ณ 17/08/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTRB Valor Divergente                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerArqTRB2()

Local _cInner := '%%'
Local _cWhere := '%%'

If mv_par04 == 1
	_cTipo = "%'NF'%"
ElseIf mv_par04 == 2
	_cTipo = "%'CH'%"
Else
	_cTipo = "%'NCC'%"
Endif

If mv_par03 == 2
	_cInner := "%CV3_HIST NOT LIKE '%MULTA/JUROS%' AND CV3_HIST NOT LIKE '%MUL/JUR%' AND CV3_HIST NOT LIKE '%BAIXA JUROR%' AND CV3_HIST NOT LIKE '%BAIXA JUROS%' AND CV3_HIST NOT LIKE '%BX JUROS%' AND CV3_HIST NOT LIKE '%DESCONT %'%"
	_cWhere := '%AND E5_VALOR > 0'
	_cWhere += ' AND ROUND(E5_VALOR-E5_VLJUROS-E5_VLMULTA,02) <> ROUND(CT2_VALOR,02)%'
ElseIf mv_par03 == 4
	_cInner := "%CV3_HIST LIKE '%DESCONT %'%"
	_cWhere := '%AND E5_VLDESCO > 0'
	_cWhere += ' AND ROUND(E5_VLDESCO,02) <> ROUND(CT2_VALOR,02)%'
Endif

BeginSql alias 'TRB'

	SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_DATA,E5_DTDISPO,E5_LA,E5_TIPODOC,E5_MOTBX,E5_TIPO,E5_VALOR,E5_VLDESCO,E5_VLMULTA,E5_VLJUROS,CT2_VALOR,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_BENEF,E5_HISTOR FROM %table:SE5% SE5
	INNER JOIN %table:CV3% CV3 ON E5_FILIAL = CV3_FILIAL AND CV3_TABORI = 'SE5' AND SE5.R_E_C_N_O_ = CV3_RECORI AND CV3_VLR01 > 0 AND CV3_DTSEQ BETWEEN %Exp:DtoS(mv_par01-60)% AND %Exp:DtoS(mv_par02+60)% AND %Exp:_cInner% AND CV3.%notDel% AND CV3_RECDES IN (SELECT TMP.R_E_C_N_O_ FROM %table:CT2% TMP WHERE TMP.CT2_FILIAL = CV3_FILIAL AND TMP.R_E_C_N_O_ = CV3_RECDES AND TMP.%notDel%)
	INNER JOIN %table:CT2% CT2 ON E5_FILIAL = CT2_FILIAL AND CT2.R_E_C_N_O_ = CV3_RECDES AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND CT2_CREDIT = '110503002' AND CT2_VALOR > 0 AND CT2.%notDel%
	WHERE SE5.%notDel%
		AND E5_FILIAL = %xfilial:SE5% 
		AND E5_DTDISPO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)%
		AND E5_RECPAG = 'R' 
		AND E5_TIPODOC NOT IN ('TR','DC','D2','JR','J2','MT','M2','DB','ES','CP') // Transf para Descontado/Desc/Juros/Multa/Desp Banc/Estorno Contas a Pagar/Compensacoes
		AND E5_TIPO = %Exp:_cTipo%
		AND E5_SITUACA <> 'C' // Baixa nao cancelada
		%Exp:_cWhere%
	ORDER BY SE5.R_E_C_N_O_

EndSql
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Fernando Nogueira  บ Data ณ 16/08/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria as perguntas do programa no dicionario de perguntas    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := {"Data Inicial"}
	PutSX1(cPerg,"01","Data de ?" ,"","","mv_ch1","D",8,0,0,"G","NaoVazio","","","","mv_par01","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"02","Data Ate ?","","","mv_ch2","D",8,0,0,"G","NaoVazio","","","","mv_par02","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Relat๓rio:","- Nao Contabilizou","- Valor Divergente","- Nao Contabilizou Desconto","- Valor Divergente Desconto"}
	PutSX1(cPerg,"03","Relat๓rio ?"    ,"","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Sem Contabil","Sem Contabil","Sem Contabil","","Vlr Divergente","Vlr Divergente","Vlr Divergente","Desc.Sem Cont.","Desc.Sem Cont.","Desc.Sem Cont.","Vlr Div Desc","Vlr Div Desc","Vlr Div Desc","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Tipo de Titulo:","- NF","- Cheque","- NCC"}
	PutSX1(cPerg,"04","Tipo ?"    ,"","","mv_ch4","N",1,0,1,"C","NaoVazio","","","","mv_par04","NF","NF","NF","","Cheque","Cheque","Cheque","NCC","NCC","NCC","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
		
	RestArea(aAreaAnt)

Return Nil