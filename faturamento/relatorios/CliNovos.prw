#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CliNovos()  º Autor ³ Rogerio Machado    º Data ³16/03/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Relacao de Clientes Novos                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CliNovos()

Private cPerg := PadR("CLINOVOS",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
Pergunte(cPerg,.T.)

oReport := ReportDef()
oReport:PrintDialog()	

Return

Static Function ReportDef()
Local oReport
Local oSection1

oReport := TReport():New("CLINOVOS","Clientes Novos - Avant","CLINOVOS",{|oReport| PrintReport(oReport)},"Clientes Novos - Avant")

oSection1 := TRSection():New(oReport,"Clientes Novos - Avant",{"TRB"})

TRCell():New(oSection1,"A1_REGIAO"    ,"TRB","REGIAO")
TRCell():New(oSection1,"A1_NOME"   ,"TRB","NOME")
TRCell():New(oSection1,"A1_LOJA"   ,"TRB","LOJA")
TRCell():New(oSection1,"A1_END" ,"TRB","END.")
TRCell():New(oSection1,"A1_BAIRRO" ,"TRB","BAIRRO")
TRCell():New(oSection1,"A1_MUN" ,"TRB","CIDADE")
TRCell():New(oSection1,"A1_CEP" ,"TRB","CEP")
TRCell():New(oSection1,"A1_EST" ,"TRB","UF")
TRCell():New(oSection1,"A1_EMAIL" ,"TRB","E-MAIL")
TRCell():New(oSection1,"A1_DDD" ,"TRB","DDD")
TRCell():New(oSection1,"A1_TEL" ,"TRB","TEL")
TRCell():New(oSection1,"A1_CONTATO" ,"TRB","CONTATO")
TRCell():New(oSection1,"A3_NOME" ,"TRB","REPRESENTANTE")
TRCell():New(oSection1,"A1_DTINCLU" ,"TRB","DT. INCLUSÃO",,,,{||Stod(TRB->A1_DTINCLU)})

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

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
	DbSkip()		
	oReport:IncMeter()
End

oSection1:Finish()

TRB->(DbCloseArea())

Return

Static Function GeraArqTRB()

	BeginSql alias 'TRB'

		SELECT A1_REGIAO,A1_NOME,A1_LOJA,A1_END,A1_BAIRRO,A1_MUN,A1_CEP,A1_EST,A1_EMAIL,A1_DDD,A1_TEL,A1_CONTATO,A3_NOME,A1_DTINCLU  
		FROM %table:SA1% SA1
		INNER JOIN %table:SA3% SA3 ON SA1.A1_VEND = SA3.A3_COD AND SA3.%notDel%
		WHERE SA1.%notDel% AND SA1.A1_DTINCLU BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		ORDER BY A1_DTINCLU

	EndSql
	
Return()

Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	
	aHelpPor := {"De data?"}
	PutSX1(cPerg,"01","De data?","De data?","De data?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,"","")
	aHelpPor := {"Até Data?"}
	PutSX1(cPerg,"02","Até Data?","Até Data?","Até Data?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,"","")
	
	RestArea(aAreaAnt)      

Return Nil