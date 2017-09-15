#INCLUDE "GFER050.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"	

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function relromaneio()
	
	Private cPerg := PadR("RELROMANEIO",Len(SX1->X1_GRUPO))
	
	//AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()	
Return

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()
	Local oReport
	Local oSection1
	Local oSection2
	Local oBreak
	
	oReport := TReport():New("RELROMANEIO","Romaneio de Carga - Avant","RELROMANEIO",{|oReport| PrintReport(oReport)},"Romaneio de Carga - Avant")
	oSection1 := TRSection():New(oReport,"RELROMANEIO",{"TRBGWN"})
	
	oSection1:SetPageBreak()
	
	TRCell():New(oSection1,"GWN_NRROM" ,"TRBGWN","Romaneio")
	TRCell():New(oSection1,"GWN_CDTRP","TRBGWN","Transp.")
	TRCell():New(oSection1,"GU3_NMEMIT","TRBGWN","Nome da Transportadora",,50)
	TRCell():New(oSection1,"GWN_DTSAI","TRBGWN","Dt Said/Entr",,,,{||Stod(TRBGWN->GWN_DTSAI)})
	TRCell():New(oSection1,"GWN_HRSAI","TRBGWN","Hr Said/Entr")
	TRCell():New(oSection1,"GUU_NMMTR","TRBGWN","Motorista",,25)
	TRCell():New(oSection1,"GWN_PLACAD","TRBGWN","Placa")
	//TRCell():New(oSection1,"GW8_VOLUME","TRBGWN","Cubagem Romaneio")
	//TRCell():New(oSection1,"GW8_PESOR","TRBGWN","Peso Romaneio")
	
	oSection2 := TRSection():New(oSection1,"Notas",{"TRBGWN"},/*{Array com as ordens do relatório}*/, .F., .F. )
		
	TRCell():New(oSection2,"SEQ" ,"TRBGWN","Sequência")
	TRCell():New(oSection2,"GW8_NRDC" ,"TRBGWN","Nota")
	TRCell():New(oSection2,"GW1_CDDEST" ,"TRBGWN","Destinatario")
	TRCell():New(oSection2,"A1_NOME" ,"TRBGWN","Nome do Cliente")
	TRCell():New(oSection2,"A1_EST" ,"TRBGWN","UF")
	TRCell():New(oSection2,"A1_MUN" ,"TRBGWN","Cidade")
	TRCell():New(oSection2,"GW8_VALOR" ,"TRBGWN","[Valor]")
	TRCell():New(oSection2,"GW8_VOLUME" ,"TRBGWN","Cubagem")
	TRCell():New(oSection2,"GWB_CDUNIT" ,"TRBGWN","Cod. Unitiz.")
	TRCell():New(oSection2,"F2_VOLUME1" ,"TRBGWN","Quantidade")
	
	//TRFunction():New(oSection1:Cell("GW8_VOLUME"),"Cubagem Romaneio","SUM"  ,,"Cubagem Romaneio",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
	//TRCell():New(oSection1,"GW8_VOLUME","TRBGWN","Cubagem Romaneio")
	
	//TRFunction():New(oSection1:Cell("GW8_PESOR"),"Peso Romaneio","SUM"  ,,"Peso Romaneio",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
	//TRCell():New(oSection1,"GW8_PESOR","TRBGWN","Peso Romaneio")
	
	 

Return oReport

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrintReport(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local _cSeq   := ""
	Local nTotVol := 0
	
	LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
	DbSelectArea("TRBGWN")
	DbGotop()
	Count To nRegua
	DbGotop()

	oReport:SetMeter(nRegua)
	
	_cSeq := TRBGWN->SEQ	
	
	While (!Eof()) .And. _cSeq == 1
	
		oSection1:Init()
		oSection1:PrintLine()
		oReport:SkipLine()
		oReport:SkipLine()
	
		While (!Eof())
			If oReport:Cancel()
				Exit
			EndIf

			oSection2:Init()
			oSection2:PrintLine()
			oReport:SkipLine()
			_cSeq := TRBGWN->SEQ
			nTotVol := nTotVol + TRBGWN->F2_VOLUME1			
			DbSkip()		
			oReport:IncMeter()
		End
	End
	
	oSection2:Finish()
	
	oReport:IncMeter()
	
	oSection1:Finish()
	
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	
	oReport:Say(oReport:Row(),10,"TOTAL DE NOTAS:   " + cValtoChar(_cSeq),,,,)
	oReport:SkipLine()
	oReport:Say(oReport:Row(),10,"TOTAL DE VOLUMES: " + cValtoChar(nTotVol),,,,)
	oReport:SkipLine()
	oReport:SkipLine()
	
	oReport:Say(oReport:Row(),10,"DECLARO TER RETIRADO NA DATA QUE CONSTA NESTE RELATÓRIO TODAS AS NOTAS ACIMA MENCIONADAS COM AS RESPECTIVAS QUANTIDADES DE VOLUMES EM PERFEITAS CONDIÇÕES DE TRANSPORTE",,,,)
	
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:SkipLine()
	
	oReport:Line(oReport:Row(),10,oReport:Row(),1420)
	oReport:Line(oReport:Row(),1720,oReport:Row(),3180)

	oReport:SkipLine()
	
	oReport:Say(oReport:Row(),600,"M O T O R I S T A",,,,)
	oReport:Say(oReport:Row(),2320,"C O N F E R E N T E",,,,)
	
	
	TRBGWN->(DbCloseArea())
Return

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraArqTRB()

	BeginSql alias "TRBGWN"

		SELECT ROW_NUMBER() OVER(ORDER BY GW8_NRDC) AS SEQ, GWN_NRROM, GWN_CDTRP, GU3_NMEMIT, GWN_DTSAI, GWN_HRSAI, ISNULL(GUU_NMMTR,'') AS GUU_NMMTR, GWN_PLACAD, SUM(GW8_VOLUME) AS GW8_VOLUME, 
		SUM(GW8_PESOR) AS GW8_PESOR, GW8_NRDC, GW1_CDDEST, A1_NOME, A1_EST, A1_MUN, SUM(GW8_VALOR) AS GW8_VALOR, SUM(GW8_VOLUME) AS GW8_VOLUME,
		GWB_CDUNIT, GWB_QTDE, F2_VOLUME1
		
		FROM %table:GWN% AS GWN
		LEFT JOIN %table:GW1% AS GW1 ON GWN_FILIAL = GW1_FILIAL AND GWN_NRROM = GW1_NRROM AND GW1.%notDel%
		INNER JOIN %table:SA1% AS SA1 ON GW1_CDDEST = A1_CGC AND SA1.%notDel%
		LEFT JOIN %table:GU3% AS GU3 ON (GWN.GWN_CDTRP = GU3_CDEMIT AND GU3.%notDel%)
		LEFT JOIN %table:GUU% AS GUU ON GWN_CDMTR = GUU_CDMTR AND GUU.%notDel%
		LEFT JOIN %table:GW8% AS GW8 ON GW8_FILIAL = GW1_FILIAL AND GW8_CDTPDC = GW1_CDTPDC AND GW8_EMISDC = GW1_EMISDC AND GW8_SERDC = GW1_SERDC AND GW8_NRDC = GW1_NRDC AND GW8.%notDel%
		INNER JOIN %table:GWB% AS GWB ON GW1_FILIAL = GWB_FILIAL AND GW1_NRDC = GWB_NRDC AND GW1_SERDC = GWB_SERDC AND GWB.%notDel%
		INNER JOIN %table:SF2% AS SF2 ON GW8_FILIAL = F2_FILIAL AND GW8_NRDC = F2_DOC AND GW8_SERDC = F2_SERIE AND SF2.%notDel%
		WHERE  GWN.%notDel% AND GWN_FILIAL = '010104' AND GWN_NRROM = '10000080'
		GROUP BY GWN_NRROM, GWN_CDTRP, GU3_NMEMIT, GWN_DTSAI, GWN_HRSAI, GUU_NMMTR, GWN_PLACAD, GW8_NRDC, GW1_CDDEST, A1_NOME, A1_EST, A1_MUN, GWB_CDUNIT, GWB_QTDE, GWN_NRROM, F2_VOLUME1
		ORDER BY GWN_NRROM, GW8_NRDC

	EndSql
	
Return()

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1(cPerg)
	Local aAreaAnt := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}
	
	aHelpPor := {"Romaneio ?"}
	PutSX1(cPerg,"01","Romaneio ?","","","mv_ch1","C",8,0,0,"G",""        ,"","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
	RestArea(aAreaAnt)      

Return Nil

		