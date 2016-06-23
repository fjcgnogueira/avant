#include "PROTHEUS.CH"         
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FreteManual()  º Autor ³ Rogerio Machado    º Data ³17/09/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Relatorio de frete manual                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico AVANT.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³  /  /  ³                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FRETEMANUAL()

	Private cPerg := PadR("FRETEMANUAL",Len(SX1->X1_GRUPO))

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	
	//oReport:lParamPage     := .F.
 	//oReport:lParamReadOnly := .T.
	
	oReport := ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()
	Local oReport
	Local oSection1
	
	oReport := TReport():New("FRETEMANUAL","Relatório de Frete Manual","FRETEMANUAL",{|oReport| PrintReport(oReport)},"FRETEMANUAL")

	
	oSection1 := TRSection():New(oReport,"Relatório de Frete Manual",{"TRG"})
	
	TRCell():New(oSection1,"F8_FILIAL"    ,"TRG","Filial")
	TRCell():New(oSection1,"F8_NFORIG"    ,"TRG","Documento")
	TRCell():New(oSection1,"F8_SERORIG"   ,"TRG","Serie")
	TRCell():New(oSection1,"D1_BASEICM"   ,"TRG","Base ICMS")
	TRCell():New(oSection1,"D1_ICMSCOM" ,"TRG","Aliq.ICMS")
	TRCell():New(oSection1,"D1_VALICM" ,"TRG","Vlr.ICMS")
	TRCell():New(oSection1,"TOTAL" ,"TRG","Total")
	TRCell():New(oSection1,"D1_EMISSAO" ,"TRG","Dt.Emissão",,,,{||StoD(TRG->D1_EMISSAO)})
	
Return oReport

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	TRG->(DbCloseArea())
	
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
				
		SELECT F8_FILIAL, F8_NFORIG, F8_SERORIG, D1_BASEICM, D1_ICMSCOM, D1_VALICM, SUM(D1_TOTAL) AS TOTAL, D1_EMISSAO 
		FROM %table:SF8% AS SF8
		INNER JOIN %table:SD1% AS SD1 ON F8_FILIAL = SD1.D1_FILIAL AND F8_NFORIG = D1_DOC AND F8_SERORIG = D1_SERIE AND F8_FORNECE = D1_FORNECE AND SD1.%notDel%
		INNER JOIN %table:SA2% AS SA2 ON F8_FORNECE = A2_COD AND F8_LOJA = A2_LOJA AND SA2.%notDel%
		WHERE SF8.%notDel%
		AND F8_FILIAL = %exp:mv_par01%
		AND F8_NFORIG = %exp:mv_par02%
		AND A2_COD = %exp:mv_par03%
		GROUP BY F8_FILIAL, F8_NFORIG, F8_SERORIG, D1_BASEICM, D1_ICMSCOM, D1_VALICM, D1_EMISSAO
	
	EndSql

	
Return()


Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	
	
	Local aAreaAnt := GetArea()
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := {"Filial:"}
	PutSx1(cPerg,'01','Filial:','Filial:','Filial:','mv_ch1','C',06,0,0,'G',''        ,'XM0','','','mv_par01','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Título:"}
	PutSx1(cPerg,'02','Título:','Título:','Título:','mv_ch2','C',09,0,0,'G',''        ,'','','','mv_par02','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Transportadora:"}
	PutSx1(cPerg,'03','Transportadora:','Transportadora:','Transportadora:','mv_ch3','C',06,0,0,'G',''        ,'SA2','','','mv_par03','','','','','','','','','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)
	
	RestArea(aAreaAnt)      

Return Nil