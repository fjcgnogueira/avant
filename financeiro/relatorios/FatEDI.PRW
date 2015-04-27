#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ FatEDI()    บ Autor ณ Fernando Nogueira  บ Data ณ27/04/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Relacao de Fretes EDI por Fatura                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑฬออออออออออฯอออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FatEDI()

Private cPerg := PadR("FATEDI",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
Pergunte(cPerg,.T.)

oReport := ReportDef()
oReport:PrintDialog()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef() บ Autor ณ Fernando Nogueira  บ Data ณ27/04/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oBreak

oReport := TReport():New("FATEDI","Faturas EDI - Avant","FATEDI",{|oReport| PrintReport(oReport)},"Faturas EDI - Avant")

oSection1 := TRSection():New(oReport,"Faturas EDI",{"TRB"})
oSection1:SetPageBreak()

TRCell():New(oSection1,"ZZ5_NUMDOC","TRB","Fatura"        ,PesqPict('ZZ5','ZZ5_NUMDOC'),TamSx3("ZZ5_NUMDOC")[1])
TRCell():New(oSection1,"A4_NOME"   ,"TRB","Transportadora",PesqPict('SA4','A4_NOME'),TamSx3("A4_NOME")[1])
TRCell():New(oSection1,"A4_CGC"    ,"TRB","CGC"           ,PesqPict('SA4','A4_CGC') ,TamSx3("A4_CGC")[1])

oBreak := TRBreak():New(oSection1, {|| TRB->ZZ5_NUMDOC,TRB->CTR}, {|| "S U B - T O T A L: " + Space(15) + "QUANT"})

oSection2 := TRSection():New(oSection1,"CTRดs",{"TRB"},/*{Array com as ordens do relat๓rio}*/, .F., .F. )

TRCell():New(oSection2,"CTR"       ,"TRB","CTR"         ,PesqPict('ZZ5','ZZ5_NUMCON'),TamSx3("ZZ5_NUMCON")[1])
TRCell():New(oSection2,"ZZ5_DTCONH","TRB","Data Conhec.",                            ,12                     ,,{||STOD(TRB->ZZ5_DTCONH)})
TRCell():New(oSection2,"PESOTRANSP","TRB","Peso Transp.",PesqPict('ZZ5','ZZ5_PESO')  ,TamSx3("ZZ5_PESO")[1])
TRCell():New(oSection2,"BASEICMS"  ,"TRB","Base ICMS"   ,PesqPict('ZZ5','ZZ5_BASICM'),TamSx3("ZZ5_BASICM")[1])
TRCell():New(oSection2,"ALIQICMS"  ,"TRB","%ICMS"       ,PesqPict('ZZ5','ZZ5_ICMS')  ,TamSx3("ZZ5_ICMS")[1])
TRCell():New(oSection2,"ZZ5_VLRFRE","TRB","Valor Frete" ,PesqPict('ZZ5','ZZ5_VLRFRE'),TamSx3("ZZ5_VLRFRE")[1])

TRFunction():New(oSection2:Cell("PESOTRANSP"),"","COUNT",oBreak,"Quant: ",'@E 99999',,.F.,.F.)
TRFunction():New(oSection2:Cell("ZZ5_VLRFRE"),"","SUM"  ,oBreak,"Valor: ",PesqPict('ZZ5','ZZ5_VLRFRE'),,.F.,.F.)
TRFunction():New(oSection2:Cell("ZZ5_VLRFRE"),"Total Frete","SUM",,/*Titulo*/,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection2)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PrintReport บ Autor ณ Fernando Nogueira  บ Data ณ27/04/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de tratamento das informacoes do Relatorio	   	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cNF       := ""

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
DbSelectArea('TRB')
DbGotop()
Count To nRegua
DbGotop()

oReport:SetMeter(nRegua)

While (!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:Init()
	
	oSection1:PrintLine()	
	cNF := TRB->ZZ5_NUMDOC	

	oSection2:Init()
	
	While (!Eof()) .And. TRB->ZZ5_NUMDOC == cNF
	
		oSection2:PrintLine()
		DbSkip()		
		oReport:IncMeter()
	End
	
	oSection2:Finish()
	
	oReport:IncMeter()
	
	oSection1:Finish()
End

TRB->(DbCloseArea())

oReport:SetTotalInLine(.F.)
oReport:SetTotalText("T O T A L ")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraArqTRBบAutor  ณ Fernando Nogueira  บ Data ณ 27/04/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraArqTRB()

Local cWhere  := "%%"

If MV_PAR07 == 1  // Gerou Documento de Cobranca
	cWhere := "%WHERE Z4_STATUS = 'G'%"
Endif

BeginSql alias 'TRB'

	SELECT * FROM
		(SELECT ZZ5_FILIAL, A2_NOME, F2_DOC NF, F2_VALBRUT VALNF, ZZ5_VLRFRE / F2_VALBRUT * 100 ALIQ, ZZ5_PESO PESOTRANSP, ZZ5_VLRFRE, ZZ5_BASICM BASEICMS,
				ZZ5_ICMS ALIQICMS, ZZ5_VALICM VLICMS, ZZ5_VALOR VALOR, ZZ5_NUMDOC, ZZ5_NUMCON CTR, ZZ4_STATUS, ZZ5_DTCONH, A4_NOME, A4_CGC,
				ISNULL(ZZ4_STATUS,'S') Z4_STATUS
		FROM %table:ZZ5% ZZ5 
			LEFT JOIN %table:SA2% SA2 ON ZZ5_CODFOR = A2_COD 
				AND ZZ5_LOJFOR = A2_LOJA 
				AND ZZ5_CGCTRS = A2_CGC 
				AND SA2.D_E_L_E_T_ = ' '
			LEFT JOIN %table:SF2% SF2 ON ZZ5_FILIAL = F2_FILIAL 
				AND SUBSTRING(ZZ5_NFSAID, 7, 5) = SUBSTRING(F2_DOC, 5, 5) 
				AND SF2.%notDel%
			LEFT JOIN %table:ZZ4% ZZ4 ON ZZ4_FILIAL = ZZ5_FILIAL 
				AND ZZ4_NUMDOC = ZZ5_NUMDOC 
				AND ZZ4_STATUS = 'G' 
				AND ZZ4.%notDel%
			LEFT JOIN %table:SA4% SA4 ON ZZ5_CODTRS = A4_COD 
				AND SA4.%notDel%
		WHERE ZZ5.%notDel%
			AND ZZ5_FILIAL = %xfilial:ZZ5%
			AND ZZ5_NUMDOC BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
			AND ZZ5_NUMDOC <> ' '
			AND ZZ5_DTCONH BETWEEN %Exp:DTOS(MV_PAR03)% AND %Exp:DTOS(MV_PAR04)%
			AND ZZ5_CODTRS BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%) STATUS
	%Exp:cWhere%
	ORDER BY ZZ5_NUMDOC,CTR

EndSql
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Fernando Nogueira  บ Data ณ 27/04/2015  บฑฑ
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
	
	aHelpPor := {"Fatura Inicial"}
	PutSX1(cPerg,"01","Da Fatura ?"         ,"","","mv_ch1","C",9,0,0,"G",""        ,"SF2","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Fatura Final"}
	PutSX1(cPerg,"02","Ate a Fatura ?"      ,"","","mv_ch2","C",9,0,0,"G",""        ,"SF2","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Inicial"}
	PutSX1(cPerg,"03","Data de ?"           ,"","","mv_ch3","D",8,0,0,"G","NaoVazio",""   ,"","","mv_par03","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"04","Data Ate ?"          ,"","","mv_ch4","D",8,0,0,"G","NaoVazio",""   ,"","","mv_par04","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Transportadora Inicial"}
	PutSX1(cPerg,"05","Da Transportadora ?" ,"","","mv_ch5","C",6,0,0,"G",""        ,"SA4","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Transportadora Final"}
	PutSX1(cPerg,"06","Ate Transportadora ?","","","mv_ch6","C",6,0,0,"G",""        ,"SA4","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Gerou Cobranca:","- Sim","- Nao"}
	PutSX1(cPerg,"07","Gerou Cobranca ?"    ,"","","mv_ch7","N",1,0,1,"C","NaoVazio",""   ,"","","mv_par07","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
	RestArea(aAreaAnt)

Return Nil