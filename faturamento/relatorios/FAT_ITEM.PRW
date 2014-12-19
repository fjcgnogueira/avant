#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ FAT_ITEM()   บ Autor ณ Rogerio Machado   บ Data ณ 29/08/14 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Montagem de dados.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FAT_ITEM(aParam)
Local cMesRef := 0
Local cAnoRef := 0
Local cDtIni  := 0
Local cDtFim  := 0
Local cLog := "<html><body>"
Local cFim    := "</body></html>"
Local cAssunto := ""
Local cPara := ""
Local csDtIni := ""
Local csDtFim := ""
Local cDtDiario := ""
Local nTotQtd := 0
Local nTotVlr := 0
//Local _cD2Total   := PesqPict("SD2","D2_TOTAL")
Local _cD2Total   := "@E 999,999,999.99"
Local _cPctQtd    := "@E 999,999,999"
Local nTipo		:= 0
Local cRegional	:= ""
Local cParaMail	:= ""
Local cCopyMail	:= ""
Private cPerg := "FATITEM"
Private _cFilial    := ""

PREPARE ENVIRONMENT EMPRESA aParam[5] FILIAL aParam[6]
_cFilial := aParam[6]

nTipo      := aParam[1]
cRegional := aParam[2]
cParaMail := aParam[3]
cCopyMail := aParam[4]


//AjustaSX1(cPerg)
//Pergunte(cPerg,.F.)


Do Case
	Case cParaMail = "CO"
	//cParaMail := "reginaldo.damaso@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "ESP"
	//cParaMail := "abel.capella@avantled.com.br"
	Case cParaMail = "KEY"
	cParaMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "LE"
	//cParaMail := "felipe.filgueiras@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "MG"
	//cParaMail := "felipe.filgueiras@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "NE"
	//cParaMail := "adriano.souza@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "NO"
	//cParaMail := "miguel.alves@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "OEM"
	//cParaMail := "admilson.felix@avantled.com.br"
	Case cParaMail = "SPC"
	cParaMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "SPI"
	//cParaMail := "lucas.alves@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "SU"
	//cParaMail := "erivelto.borguesan@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "SUP"
	//cParaMail := "adilson.moser@avantled.com.br"
	cCopyMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "GERAL"
	cParaMail := "wesley.pazini@avantled.com.br"
	Case cParaMail = "TST"
	cParaMail := ""
	cCopyMail := "rogerio.machado@avantled.com.br"
EndCase

cMesRef := substr(Dtos(date()),5,2)
cAnoRef := substr(Dtos(date()),1,4)


dbSelectArea("ZZP")
dbSetOrder(2)
dbSeek(_cFilial+cAnoRef+cMesRef)

cDtIni := ZZP->ZZP_DATADE
cDtFim := ZZP->ZZP_DATATE

If nTipo == 1
	If ALLTRIM(cRegional) == "GERAL"
		BeginSql alias 'TRB'
			SELECT	
				SB1.B1_DESC,
				SUM(SD2.D2_QUANT) QTD,
				SUM(SD2.D2_TOTAL) Reais
			FROM %table:SD2% SD2
			INNER JOIN %table:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SF2.%notDel%
			INNER JOIN %table:SC5% SC5 ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.%notDel%
			INNER JOIN %table:SC6% SC6 ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_ITEMPV = SC6.C6_ITEM AND SC6.%notDel% 
			INNER JOIN %table:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.%notDel%
			INNER JOIN %table:SF4% SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_DUPLIC = 'S' AND SF4.%notDel%
			WHERE D2_FILIAL = %Exp:_cFilial% AND SD2.D2_EMISSAO BETWEEN %exp:DTOS(cDtIni)% AND %exp:DTOS(cDtFim)% AND SD2.D2_TIPO = 'N' AND SD2.%notDel%
			GROUP BY SB1.B1_DESC
			ORDER BY Reais DESC		
		EndSql
			
		cLog += "<p align='center' class='style1'><strong>FATURAMENTO POR ITEM ACUMULADO</strong></p>"
		cLog += "<p>  </p>"
		cLog += "<p <strong>Data de: </strong>" +DTOC(cDtIni)+ "</p>"
		cLog += "<p <strong>Data at้: </strong>" +DTOC(cDtFim)+ "</p>"
		cLog += "<p <strong>Filial: </strong> FILIAL SANTA CATARINA </p>"
		cLog += "<p <strong>Regional: </strong>" +ALLTRIM(cRegional)+ "</p>"
		
		cLog += '  <table width="1300" border="1" align="left"> '		
		cLog += "<tr>"
		cLog += '<td align="center" width="180"><span class="style3"><strong>Produto</strong></span></td>'	
		cLog += '<td align="center" width="20"><span class="style3"><strong>Quantidade</strong></span></td>'
		cLog += '<td align="center" width="20"><span class="style3"><strong>Valor R$</strong></span></td>'
		cLog += '</tr>'
				
		cAssunto := "Teste - Faturamento por Item Acumulado - Regional " +DTOC(cDtIni)+ "] at้ [" +DTOC(cDtFim)+ "]"
	Else
		BeginSql alias 'TRB'
			SELECT SF2.F2_REGIAO,	
				SB1.B1_DESC,
				SUM(SD2.D2_QUANT) QTD,
				SUM(SD2.D2_TOTAL) Reais
			FROM %table:SD2% SD2
			INNER JOIN %table:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SF2.%notDel%
			INNER JOIN %table:SC5% SC5 ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.%notDel%
			INNER JOIN %table:SC6% SC6 ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_ITEMPV = SC6.C6_ITEM AND SC6.%notDel% 
			INNER JOIN %table:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.%notDel%
			INNER JOIN %table:SF4% SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_DUPLIC = 'S' AND SF4.%notDel%
			WHERE D2_FILIAL = %Exp:_cFilial% AND SF2.F2_REGIAO = %exp:cRegional% AND SD2.D2_EMISSAO BETWEEN %exp:DTOS(cDtIni)% AND %exp:DTOS(cDtFim)% AND SD2.D2_TIPO = 'N' AND SD2.%notDel%
			GROUP BY SB1.B1_DESC, SF2.F2_REGIAO
			ORDER BY Reais DESC		
		EndSql
		
		cLog += "<p align='center' class='style1'><strong>FATURAMENTO POR ITEM ACUMULADO</strong></p>"
		cLog += "<p>  </p>"
		cLog += "<p <strong>Data de: </strong>" +DTOC(cDtIni)+ "</p>"
		cLog += "<p <strong>Data at้: </strong>" +DTOC(cDtFim)+ "</p>"
		cLog += "<p <strong>Filial: </strong> FILIAL SANTA CATARINA </p>"
		cLog += "<p <strong>Regional: </strong>" +ALLTRIM(cRegional)+ "</p>"
		
		cLog += '  <table width="1300" border="1" align="left"> '		
		cLog += "<tr>"
		cLog += '<td align="center" width="20"><span class="style3"><strong>Regiใo</strong></span></td>'
		cLog += '<td align="center" width="180"><span class="style3"><strong>Produto</strong></span></td>'	
		cLog += '<td align="center" width="20"><span class="style3"><strong>Quantidade</strong></span></td>'
		cLog += '<td align="center" width="20"><span class="style3"><strong>Valor R$</strong></span></td>'
		cLog += '</tr>'
				
		cAssunto := "Teste - Faturamento por Item Acumulado - Regional " +ALLTRIM(cRegional)+ " de [" +DTOC(cDtIni)+ "] at้ [" +DTOC(cDtFim)+ "]"
	EndIf
Else
	If nTipo == 2
		If ALLTRIM(cRegional) == "GERAL"
			cDtDiario := Dtos(date())
			BeginSql alias 'TRB'
				SELECT	
					SB1.B1_DESC,
					SUM(SD2.D2_QUANT) QTD,
					SUM(SD2.D2_TOTAL) Reais
				FROM %table:SD2% SD2
				INNER JOIN %table:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SF2.%notDel%
				INNER JOIN %table:SC5% SC5 ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.%notDel%
				INNER JOIN %table:SC6% SC6 ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_ITEMPV = SC6.C6_ITEM AND SC6.%notDel% 
				INNER JOIN %table:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.%notDel%
				INNER JOIN %table:SF4% SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_DUPLIC = 'S' AND SF4.%notDel%
				WHERE D2_FILIAL = %Exp:_cFilial% AND SD2.D2_EMISSAO BETWEEN %exp:cDtDiario% AND %exp:cDtDiario% AND SD2.D2_TIPO = 'N' AND SD2.%notDel%
				GROUP BY SB1.B1_DESC
				ORDER BY Reais DESC		
			EndSql
				
			cLog += "<p align='center' class='style1'><strong>FATURAMENTO POR ITEM DIมRIO</strong></p>"
			cLog += "<p>  </p>"
			cLog += "<p <strong>Data: </strong>" +DTOC(date())+ "</p>"
			cLog += "<p <strong>Filial: </strong> FILIAL SANTA CATARINA </p>"
			cLog += "<p <strong>Regional: </strong>" +ALLTRIM(cRegional)+ "</p>"
			
			cLog += '  <table width="1300" border="1" align="left"> '		
			cLog += "<tr>"
			cLog += '<td align="center" width="180"><span class="style3"><strong>Produto</strong></span></td>'	
			cLog += '<td align="center" width="20"><span class="style3"><strong>Quantidade</strong></span></td>'
			cLog += '<td align="center" width="20"><span class="style3"><strong>Valor R$</strong></span></td>'
			cLog += '</tr>'
					
			cAssunto := "Teste - Faturamento por Item Diแrio - Regional " +ALLTRIM(cRegional)+ " [" +DTOC(date())+  "]"
		Else
			cDtDiario := Dtos(date())
			BeginSql alias 'TRB'
				SELECT SF2.F2_REGIAO,	
					SB1.B1_DESC,
					SUM(SD2.D2_QUANT) QTD,
					SUM(SD2.D2_TOTAL) Reais
				FROM %table:SD2% SD2
				INNER JOIN %table:SF2% SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SF2.%notDel%
				INNER JOIN %table:SC5% SC5 ON SD2.D2_FILIAL = SC5.C5_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.%notDel%
				INNER JOIN %table:SC6% SC6 ON SD2.D2_FILIAL = SC6.C6_FILIAL AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D2_ITEMPV = SC6.C6_ITEM AND SC6.%notDel% 
				INNER JOIN %table:SB1% SB1 ON SD2.D2_COD = SB1.B1_COD AND SB1.%notDel%
				INNER JOIN %table:SF4% SF4 ON SD2.D2_FILIAL = SF4.F4_FILIAL AND SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_DUPLIC = 'S' AND SF4.%notDel%
				WHERE D2_FILIAL = %Exp:_cFilial% AND SF2.F2_REGIAO = %exp:cRegional% AND SD2.D2_EMISSAO BETWEEN %exp:cDtDiario% AND %exp:cDtDiario% AND SD2.D2_TIPO = 'N' AND SD2.%notDel%
				GROUP BY SB1.B1_DESC, SF2.F2_REGIAO
				ORDER BY Reais DESC		
			EndSql
			cLog += "<p align='center' class='style1'><strong>FATURAMENTO POR ITEM DIมRIO</strong></p>"
			cLog += "<p>  </p>"
			cLog += "<p <strong>Data: </strong>" +DTOC(date())+ "</p>"
			cLog += "<p <strong>Filial: </strong> FILIAL SANTA CATARINA </p>"
			cLog += "<p <strong>Regional: </strong>" +ALLTRIM(cRegional)+ "</p>"
			
			cLog += '  <table width="1300" border="1" align="left"> '		
			cLog += "<tr>"
			cLog += '<td align="center" width="20"><span class="style3"><strong>Regiใo</strong></span></td>'
			cLog += '<td align="center" width="180"><span class="style3"><strong>Produto</strong></span></td>'	
			cLog += '<td align="center" width="20"><span class="style3"><strong>Quantidade</strong></span></td>'
			cLog += '<td align="center" width="20"><span class="style3"><strong>Valor R$</strong></span></td>'
			cLog += '</tr>'
			
			cAssunto := "Teste - Faturamento por Item Diแrio - Regional " +ALLTRIM(cRegional)+ " ["  +DTOC(date())+ "]"
		EndIf
	EndIf
EndIf

	
TRB->(DbGoTop())

If ALLTRIM(cRegional) == "GERAL"
	While (!Eof('TRB'))
		cLog += "<tr>"		
		cLog += '<td width="180"><span class="style3">' +TRB->B1_DESC+ '</span></td>'+ '<td align="right" width="20"><span class="style3">' +Transform(TRB->QTD, _cPctQtd)+ '</span></td>'+ '<td align="right" width="20"><span class="style3">' +Transform(TRB->Reais, _cD2Total)+ '</span></td>'
		cLog += '</tr>'
		nTotQtd := (nTotQtd + TRB->QTD)
		nTotVlr := (nTotVlr + TRB->Reais)				
		DbSkip()			
	End
Else
	While (!Eof('TRB'))
		cLog += "<tr>"		
		cLog += '<td align="center" width="20"><span class="style3">' +TRB->F2_REGIAO+ '</span></td>' + '<td width="180"><span class="style3">' +TRB->B1_DESC+ '</span></td>'+ '<td align="right" width="20"><span class="style3">' +Transform(TRB->QTD, _cPctQtd)+ '</span></td>'+ '<td align="right" width="20"><span class="style3">' +Transform(TRB->Reais, _cD2Total)+ '</span></td>'
		cLog += '</tr>'
		nTotQtd := (nTotQtd + TRB->QTD)
		nTotVlr := (nTotVlr + TRB->Reais)				
		DbSkip()
	End
EndIf


If ALLTRIM(cRegional) == "GERAL"
	cLog += "<tr>"
	cLog += '<td align="center" width="20"><span class="style3"><strong>Total</strong></span></td>'
	cLog += '<td align="right" width="20"><span class="style3"><strong>'+Transform(nTotQtd, _cPctQtd)+'</strong></span></td>'
	cLog += '<td align="right" width="20"><span class="style3"><strong>'+Transform(nTotVlr, _cD2Total)+'</strong></span></td>'
	cLog += '</tr>'
	cLog += '</table>'
	cLog += cFim	
	cPara := cParaMail
	cPara += ";rogerio.machado@avantled.com.br;"
	cPara += cCopyMail
	U_MHDEnvMail(cPara, "", "", cAssunto, cLog, "")	
Else
	cLog += "<tr>"
	cLog += '<td colspan = "2" align="center" width="20"><span class="style3"><strong>Total</strong></span></td>'
	cLog += '<td align="right" width="20"><span class="style3"><strong>'+Transform(nTotQtd, _cPctQtd)+'</strong></span></td>'
	cLog += '<td align="right" width="20"><span class="style3"><strong>'+Transform(nTotVlr, _cD2Total)+'</strong></span></td>'
	cLog += '</tr>'
	cLog += '</table>'
	cLog += cFim	
	cPara := cParaMail
	cPara += ";rogerio.machado@avantled.com.br;"
	cPara += cCopyMail
	U_MHDEnvMail(cPara, "", "", cAssunto, cLog, "")
EndIf

RESET ENVIRONMENT
			
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บ Autor ณ Rogerio Machado    บ Data ณ 29/08/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()

	aHelpPor := {"Tipos:"," - Diario","- Acumulado (A partir do ultimo fechamento.)"}
	PutSX1(cPerg,"01","Tipo?","Tipo?","Tipo?","mv_ch1","C",9,0,0,"C","NaoVazio","","","","mv_par01","Acumulado","Acumulado","Acumulado","1","Diario","Diario","Diario","","","","","","","","","",aHelpPor,"","")
	
	aHelpPor := {"Escolha a Regional"}
	PutSX1(cPerg,"02","Regional?","Regional?","Regional?","mv_ch2","C",5,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,"","")

	aHelpPor := {"Enviar Para? Ap๓s o e-mail colocar um ; "}
	PutSX1(cPerg,"03","Enviar Para?","Enviar Para?","Enviar Para?","mv_ch3","C",50,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,"","")
	
	aHelpPor := {"Enviar Cc?  Ap๓s o e-mail colocar um ; "}
	PutSX1(cPerg,"04","Enviar Cc?","Enviar Cc?","Enviar Cc?","mv_ch4","C",50,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,"","")

	RestArea(aAreaAnt)      

Return Nil

