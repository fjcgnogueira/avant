#include "PROTHEUS.CH"         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RELNCC()    º Autor ³ Rogerio Machado    º Data ³17/09/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Relacao de NCC's em aberto                                 º±±
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

User Function RELNCC()

	Private cPerg := PadR("RELNCC",Len(SX1->X1_GRUPO))

	AjustaSX1(cPerg)
	Pergunte(cPerg,.T.)
	
	oReport := ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()
	Local oReport
	Local oSection1
	
	oReport := TReport():New("RELNCC","NCCs em aberto","RELNCC",{|oReport| PrintReport(oReport)},"NCCs em aberto")

	
	oSection1 := TRSection():New(oReport,"NCCs em aberto",{"TRG"})
	
	TRCell():New(oSection1,"E1_FILIAL"    ,"TRG","Filial")
	TRCell():New(oSection1,"E1_NUM"   ,"TRG","Titulo")
	TRCell():New(oSection1,"E1_PARCELA"   ,"TRG","Parcela")
	TRCell():New(oSection1,"E1_TIPO" ,"TRG","Tipo")
	TRCell():New(oSection1,"E1_CLIENTE" ,"TRG","Cod. Cliente")
	TRCell():New(oSection1,"E1_LOJA" ,"TRG","Loja")
	TRCell():New(oSection1,"A1_NOME" ,"TRG","Cliente")
	TRCell():New(oSection1,"E1_EMISSAO" ,"TRG","Emissão")
	TRCell():New(oSection1,"E1_VALOR" ,"TRG","Valor")
	TRCell():New(oSection1,"E1_SALDO" ,"TRG","Saldo")
	TRCell():New(oSection1,"F3_OBSERV" ,"TRG","Observações",,,,{||Stod(TRG->E1_EMISSAO)})

Return oReport

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRG(),CursorArrow()})
	
	DbSelectArea('TRG')
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
	
	TRG->(DbCloseArea())

Return


Static Function GeraArqTRG()
	
	BeginSql alias 'TRG'

		SELECT E1_FILIAL, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, A1_NOME, E1_EMISSAO, E1_VALOR, E1_SALDO, F3_OBSERV 
		FROM %table:SE1% SE1 
		INNER JOIN %table:SA1% SA1 ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.%notDel%
		INNER JOIN %table:SF3% SF3 ON E1_FILIAL = F3_FILIAL AND E1_SERIE = F3_SERIE AND E1_NUM = F3_NFISCAL AND SF3.%notDel%
		WHERE SE1.%notDel% AND E1_SALDO > '0' AND E1_TIPO = 'NCC'
		ORDER BY A1_NOME, E1_EMISSAO
	
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
