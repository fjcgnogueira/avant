#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VendasMkt() º Autor ³ Rogerio Machado    º Data ³07/05/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Relatorio de Vendas para o Marketing                       º±±
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

User Function VendasMkt()
	
	Private cPerg := PadR("VENDASMKT",Len(SX1->X1_GRUPO))
	
	AjustaSX1(cPerg)
	Pergunte(cPerg,.T.)
	
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection1
	//Local D2_PRCVEN  := PesqPict("SD2","D2_PRCVEN")
	//Local D2_VALIPI  := PesqPict("SD2","D2_VALIPI")
	//Local D2_ICMSRET := PesqPict("SD2","D2_ICMSRET")
	
	oReport := TReport():New("Vendas - Avant","Vendas - Avant","VENDASMKT",{|oReport| PrintReport(oReport)},"Vendas - Avant")
	oSection1 := TRSection():New(oReport,"VendasMkt",{"TRB"})
	
	

	TRCell():New(oSection1,"A1_NOME"    ,"TRB","Cliente")
	TRCell():New(oSection1,"F2_EMISSAO"    ,"TRB","Emissão",,,,{||StoD(TRB->F2_EMISSAO)})
	TRCell():New(oSection1,"B1_COD"    ,"TRB","Código")
	TRCell():New(oSection1,"B1_DESC"    ,"TRB","Descrição")
	TRCell():New(oSection1,"B1_X_DESCG"    ,"TRB","Grupo")
	TRCell():New(oSection1,"B1_DESFAMA"    ,"TRB","Família")
	TRCell():New(oSection1,"D2_QUANT"    ,"TRB","Quant.")
	TRCell():New(oSection1,"D2_TOTAL"    ,"TRB","Total")
	TRCell():New(oSection1,"D2_CF"    ,"TRB","CFOP")
	//TRCell():New(oSection1,"D2_PRCVEN" ,"TRB","TOTAL COM IMPOSTO",,,,{||TRB->D2_PRCVEN + TRB->D2_VALIPI + TRB->D2_ICMSRET})
	TRCell():New(oSection1,"F2_REGIAO"    ,"TRB","Região")
	TRCell():New(oSection1,"A3_NOME"    ,"TRB","Representante")
	
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
	Local _cDtIni := ""
	Local _cDtFim := ""
	
	_cDtIni := DtoS(MV_PAR01)
	_cDtFim := DtoS(MV_PAR02)
	

	BeginSql alias 'TRB'

		SELECT	SA1.A1_NOME,SF2.F2_EMISSAO,SB1.B1_COD,SB1.B1_DESC,SB1.B1_X_DESCG,SB1.B1_DESFAMA,SD2.D2_QUANT,SD2.D2_TOTAL,SD2.D2_CF,SF2.F2_REGIAO,SA3.A3_NOME
		FROM %table:SF2% SF2		
		
		INNER JOIN %table:SD2% SD2 ON
			SD2.D2_FILIAL = SF2.F2_FILIAL AND	SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.%notDel%
		INNER JOIN %table:SA1% SA1 ON
			SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.%notDel%
		INNER JOIN %table:SA3% SA3 ON
			SF2.F2_VEND1 = SA3.A3_COD AND SA3.%notDel%
		INNER JOIN %table:SB1% SB1 ON
			SB1.B1_COD = SD2.D2_COD AND SB1.%notDel%
		INNER JOIN %table:SF4% SF4 ON
			SD2.D2_FILIAL = SF4.F4_FILIAL AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.%notDel%
		WHERE SF2.%notDel% AND SF4.F4_DUPLIC = 'S' AND SF2.F2_EMISSAO >= %exp:_cDtIni% AND SF2.F2_EMISSAO <= %exp:_cDtFim% 
		ORDER BY SD2.D2_DOC

	EndSql
	
Return()


Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	
	aHelpPor := {"DATA INICIAL DE FECHAMENTO?"}
	PutSX1(cPerg,"01","DATA INICIAL DE FECHAMENTO?","DATA INICIAL DE FECHAMENTO?","DATA INICIAL DE FECHAMENTO?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,"","")

	aHelpPor := {"DATA FINAL DE FECHAMENTO?"}
	PutSX1(cPerg,"02","DATA FINAL DE FECHAMENTO?","DATA FINAL DE FECHAMENTO?","DATA FINAL DE FECHAMENTO?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,"","")
	
	RestArea(aAreaAnt)      

Return Nil