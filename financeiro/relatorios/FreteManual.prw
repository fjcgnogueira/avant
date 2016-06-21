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
		AND F8_NFORIG = '000000246' 
		AND A2_COD = '002223'
		GROUP BY F8_FILIAL, F8_NFORIG, F8_SERORIG, D1_BASEICM, D1_ICMSCOM, D1_VALICM, D1_EMISSAO
	
	EndSql

	
Return()


Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	
	RestArea(aAreaAnt)      

Return Nil