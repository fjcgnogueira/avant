#include "protheus.ch"
#Include "rwmake.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATR0002  บAutor  ณRodrigo Leite       บ Data ณ  02/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio dos intens das Notas por Centro de Custo         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VENDASA1()

Local oReport
Private cPerg		:= "VENDASA1"

//MontaSx1()

Pergunte(cPerg,.F.)
	oReport:= ReportDef()
	oReport:nDevice := 1
	oReport:PrintDialog() 
Return

/////////////////////////////////////////////////////
// Fun็ใo que monta estrutura padrใo do relat๓rio  //
/////////////////////////////////////////////////////

Static Function ReportDef()
Local oReport
Local oSection



oReport := TReport():New(funName(),"Relatorio de Vendas.",cPerg,{|oReport| PrintReport(oReport)},;
"Este relat๓rio tem por objetivo imprimir as vendas de acordo com o periodo especificado.",,,,,,,)

oReport:cFontBody 	:= "Arial"
oReport:nFontBody 	:= 8
oReport:SetLineHeight(50)

oSection := TRSection():New(oReport,OemToAnsi("Intens de Entrada por Centro de Custo"),{"SF2"})



TRCell():New(oSection,"FILIAL","")
TRCell():New(oSection,"EMISSAO","")
TRCell():New(oSection,"DOC","")
TRCell():New(oSection,"CODIGO","")
//TRCell():New(oSection,"PRODUTO","")
TRCell():New(oSection,"DESCRICAO","")
TRCell():New(oSection,"GRUPO","")
TRCell():New(oSection,"FAMILIA","")
TRCell():New(oSection,"QUATIDADE","")
//TRCell():New(oSection,"VALOR TOTAL","")
//TRCell():New(oSection,"DATA","")


oSection:Cell("FILIAL"):SetSize(8)
oSection:Cell("FILIAL"):SetPicture("@!")
oSection:Cell("FILIAL"):SetTitle("FILIAL")

oSection:Cell("EMISSAO"):SetSize(10)
oSection:Cell("EMISSAO"):SetPicture("@!")
oSection:Cell("EMISSAO"):SetTitle("EMISSAO")

oSection:Cell("DOC"):SetSize(10)
oSection:Cell("DOC"):SetPicture("@!")
oSection:Cell("DOC"):SetTitle("DOC")

oSection:Cell("CODIGO"):SetSize(11)
oSection:Cell("CODIGO"):SetPicture("@!")
oSection:Cell("CODIGO"):SetTitle("CODIGO")


oSection:Cell("DESCRICAO"):SetSize(30)
oSection:Cell("DESCRICAO"):SetPicture("@!")
oSection:Cell("DESCRICAO"):SetTitle("DESCRICAO")

oSection:Cell("GRUPO"):SetSize(15)
oSection:Cell("GRUPO"):SetPicture("@!")
oSection:Cell("GRUPO"):SetTitle("GRUPO")


oSection:Cell("FAMILIA"):SetSize(15)
oSection:Cell("FAMILIA"):SetPicture("@!")
oSection:Cell("FAMILIA"):SetTitle("FAMILIA")


oSection:Cell("QUANTIDADE"):SetSize(6)
oSection:Cell("QUANTIDADE"):SetPicture("@E 999,999.9999")
oSection:Cell("QUANTIDADE"):SetTitle("QUANTIDADE")
/*
oSection:Cell("VALOR UNIT"):SetSize(14)
oSection:Cell("VALOR UNIT"):SetPicture("@E 999,999.9999")
oSection:Cell("VALOR UNIT"):SetTitle("VALOR UNIT")


oSection:Cell("VALOR TOTAL"):SetSize(14)
oSection:Cell("VALOR TOTAL"):SetPicture("@E 999,999.99")
oSection:Cell("VALOR TOTAL"):SetTitle("VALOR TOTAL")

oSection:Cell("DATA"):SetSize(10)
oSection:Cell("DATA"):SetTitle("EMISSAO")
*/




Return oReport
 
///////////////////////////////////////////
// Fun็ใo que monta o fluxo do relat๓rio //
/////////////////////////////////////////// 

Static Function PrintReport(oReport)

Local     oSection 	 := oReport:Section(1)
Local     aPercent   := {}
Private   cChave     := ""
Private   nTotQtd    := 0 
Private   nTotal     := 0
Private   nTotalUni  := 0 
Private   cPlaca     := ""
Private   nGTotQtd   := 0 
Private   nGTotal    := 0
Private   nGTotalUni := 0 
Private cDtaDe
Private cDataAte

cQry := " SELECT "
cQry += " SD2.D2_FILIAL, "
cQry += " SF2.F2_EMISSAO, "
cQry += " SD2.D2_DOC, "
cQry += " SB1.B1_COD, "
cQry += " SB1.B1_DESC, "
cQry += " SB1.B1_X_DESCG, "
cQry += " SB1.B1_DESFAMA, "
cQry += " SD2.D2_QUANT "
/*cQry += " SD2.D2_PRCVEN, "
cQry += " SD2.D2_TOTAL, "
cQry += " SD2.D2_VALIPI, "
cQry += " SD2.D2_ICMSRET, "
cQry += " SD2.D2_VALICM, "
cQry += " SD2.D2_TOTAL + SD2.D2_VALIPI + SD2.D2_ICMSRET AS [TOTAL COM IMPOSTO], "
cQry += " SA3.A3_REGIAO, "
cQry += " SA3.A3_NOME, "
cQry += " SA3.A3_XNSUPER, "
cQry += " SA3.A3_XNGEREN "
*/		
cQry += " FROM SF2010 AS SF2 "

cQry += " INNER JOIN SD2010 AS SD2 ON "
cQry += " SD2.D2_FILIAL = SF2.F2_FILIAL AND "
cQry += " SD2.D2_DOC = SF2.F2_DOC AND "
cQry += " SD2.D2_SERIE=SF2.F2_SERIE AND "
cQry += " SD2.D2_CLIENTE = SF2.F2_CLIENTE AND "
cQry += " SD2.D2_LOJA = SF2.F2_LOJA AND " 
cQry += " SF2.D_E_L_E_T_ <> '*' "
    
cQry += " INNER JOIN SA1010 AS SA1 ON "
cQry += " SA1.A1_COD = SF2.F2_CLIENTE AND "
cQry += " SA1.A1_LOJA = SF2.F2_LOJA AND "
cQry += " SA1.D_E_L_E_T_ <> '*' "
	
cQry += " INNER JOIN SA3010 AS SA3 ON "
cQry += " SF2.F2_VEND1 = SA3.A3_COD AND "
cQry += " SA3.D_E_L_E_T_ <> '*' "

cQry += " INNER JOIN SB1010 AS SB1 ON "
cQry += " SB1.B1_COD = SD2.D2_COD AND "
cQry += " SB1.D_E_L_E_T_ <> '*' "

cQry += " INNER JOIN SF4010 AS SF4 ON "
cQry += " SD2.D2_FILIAL = SF4.F4_FILIAL AND "
cQry += " SD2.D2_TES = SF4.F4_CODIGO AND "
cQry += " SF4.D_E_L_E_T_ <> '*' "

cQry += " WHERE SD2.D2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SF4.F4_DUPLIC = 'S' AND "
cQry += " SF2.F2_EMISSAO BETWEEN '"+cDataDe+"' AND '"+cDataAte+"' AND SA3.A3_REGIAO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "

cQry += " ORDER BY SD2.D2_DOC "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)  


dbSelectArea("TMP")
TMP->(dbgotop())

cDataDe := CVALTOCHAR(DTOS(MV_PAR03))
cDataAte := CVALTOCHAR(DTOS(MV_PAR04))

oReport:SetMeter(RecCount())
  
oSection:Init()

		oSection:Cell("FILIAL"):SetValue(TMP->F2_FILIAL)  // Insere o valor na celula
		oSection:Cell("FILIAL"):Show()				
		oSection:Cell("EMISSAO"):hide()		
  		oSection:Cell("DOC"):SetValue(TMP->F2_DOC)  // Insere o valor na celula
  		oSection:Cell("DOC"):Show()
		oSection:Cell("COD"):hide()  		
		oSection:Cell("DESCRICAO"):hide()
		oSection:Cell("GRUPO"):hide()
 		oSection:Cell("FAMILIA"):hide()
 		oSection:Cell("QUANT"):hide()
 		oSection:Cell("QUANTIDADE"):hide()
// 		oSection:Cell("VALOR TOTAL"):hide()
//		oSection:Cell("DATA"):hide()
		
		
		oReport:Thinline()		
		oSection:PrintLine()							


		oSection:Cell("FILIAL"):hide()				
		oSection:Cell("EMISSAO"):hide()
  		oSection:Cell("DOC"):hide()
  		oSection:Cell("COD"):hide()  		
		oSection:Cell("DESCRICAO"):hide()
		oSection:Cell("GRUPO"):hide()
 		oSection:Cell("FAMILIAL"):hide()
 		oSection:Cell("QUANTIDADE"):hide()
//		oSection:Cell("VALOR UNIT"):hide()
//		oSection:Cell("VALOR TOTAL"):hide()
//		oSection:Cell("DATA"):hide()   

		
		oReport:Thinline()		
		oSection:PrintLine()							


While TMP->(!Eof()) 
		
	
	If cPlaca != TMP->F1_PLACA   //totais
		
		oSection:Cell("NOTA"):hide()
		oSection:Cell("SERIE"):SetValue("TOTAL -->")
		oSection:Cell("SERIE"):Show()
		oSection:Cell("FORNECE"):hide()
		oSection:Cell("LOJA"):hide()  		
		oSection:Cell("PRODUTO"):hide()
		oSection:Cell("CODBAR"):hide()	
		oSection:Cell("DESCRI PROD"):hide()
		oSection:Cell("QUANT"):SetValue(nTotQtd)
		oSection:Cell("QUANT"):Show()		
		oSection:Cell("VALOR UNIT"):SetValue(nTotalUni)
		oSection:Cell("VALOR UNIT"):Show()
		oSection:Cell("VALOR TOTAL"):SetValue(nTotal)
		oSection:Cell("VALOR TOTAL"):Show()
		oSection:Cell("DATA"):hide()
		
		oSection:PrintLine()
                
       	oSection:Cell("NOTA"):hide()				
		oSection:Cell("SERIE"):hide()
  		oSection:Cell("FORNECE"):hide()
  		oSection:Cell("LOJA"):hide()  		
		oSection:Cell("PRODUTO"):hide()
		oSection:Cell("CODBAR"):hide()
 		oSection:Cell("DESCRI PROD"):hide()
 		oSection:Cell("QUANT"):hide()
 		oSection:Cell("VALOR UNIT"):hide()
 		oSection:Cell("VALOR TOTAL"):hide()
		oSection:Cell("DATA"):hide()   

		
   		oReport:Thinline()		
		oSection:PrintLine()							


		oSection:Cell("NOTA"):SetValue("PLACA")  // Insere o valor na celula
		oSection:Cell("NOTA"):Show()				
		oSection:Cell("SERIE"):hide()
  		oSection:Cell("FORNECE"):SetValue(TMP->F1_PLACA)  // Insere o valor na celula
  		oSection:Cell("FORNECE"):Show()
  		oSection:Cell("LOJA"):hide()  		
		oSection:Cell("PRODUTO"):hide()
		oSection:Cell("CODBAR"):hide()
 		oSection:Cell("DESCRI PROD"):hide()
 		oSection:Cell("QUANT"):hide()
 		oSection:Cell("VALOR UNIT"):hide()
 		oSection:Cell("VALOR TOTAL"):hide()
		oSection:Cell("DATA"):hide()

		
		oReport:Thinline()		
		oSection:PrintLine()							


		nTotQtd    := 0 
		nTotalUni  := 0 
		nTotal     := 0 
    	cPlaca     := TMP->F1_PLACA
	EndIf
	

	
		If oReport:Cancel()
			Exit
		EndIf
	
		oSection:Cell("NOTA"):SetValue(TMP->D1_DOC)
		oSection:Cell("NOTA"):Show()
		oSection:Cell("SERIE"):SetValue(TMP->D1_SERIE)
		oSection:Cell("SERIE"):Show()  
   		oSection:Cell("FORNECE"):SetValue(TMP->D1_FORNECE)
		oSection:Cell("FORNECE"):Show()                   
   		oSection:Cell("LOJA"):SetValue(TMP->D1_LOJA)		
   		oSection:Cell("LOJA"):Show()                   
 		oSection:Cell("PRODUTO"):SetValue(TMP->D1_COD)
 		oSection:Cell("PRODUTO"):Show()
		oSection:Cell("CODBAR"):SetValue(Posicione("SB1",1,xFilial("SB1")+TMP->D1_COD,"B1_CODBAR"))
		oSection:Cell("CODBAR"):Show()
 		oSection:Cell("DESCRI PROD"):SetValue(Posicione("SB1",1,xFilial("SB1")+TMP->D1_COD,"B1_DESC"))
		oSection:Cell("DESCRI PROD"):Show()
		oSection:Cell("QUANT"):SetValue(TMP->D1_QUANT)
		oSection:Cell("QUANT"):Show()
		oSection:Cell("VALOR UNIT"):SetValue(TMP->D1_VUNIT)
		oSection:Cell("VALOR UNIT"):Show()
		oSection:Cell("VALOR TOTAL"):SetValue(TMP->D1_TOTAL)
		oSection:Cell("VALOR TOTAL"):Show()		
		oSection:Cell("DATA"):SetValue(TMP->EMISS)
		oSection:Cell("DATA"):Show()		
	
			
		nTotQtd     += TMP->D1_QUANT 
		nTotalUni   += TMP->D1_VUNIT 
		nTotal      += TMP->D1_TOTAL 
    	nGTotQtd    += TMP->D1_QUANT  
		nGTotalUni  += TMP->D1_VUNIT  
		nGTotal     += TMP->D1_TOTAL  
    							                                 
		
		oSection:PrintLine()
		oReport:IncMeter()

    TMP->(DBSKIP())
Enddo     


		
		oSection:Cell("NOTA"):hide()
		oSection:Cell("SERIE"):SetValue("TOTAL -->")
		oSection:Cell("SERIE"):Show()
		oSection:Cell("FORNECE"):hide()
		oSection:Cell("LOJA"):hide()
		oSection:Cell("PRODUTO"):hide()
		oSection:Cell("CODBAR"):hide()	
		oSection:Cell("DESCRI PROD"):hide()
		oSection:Cell("QUANT"):SetValue(nTotQtd)
		oSection:Cell("QUANT"):Show()		
		oSection:Cell("VALOR UNIT"):SetValue(nTotalUni)
		oSection:Cell("VALOR UNIT"):Show()
		oSection:Cell("VALOR TOTAL"):SetValue(nTotal)
		oSection:Cell("VALOR TOTAL"):Show()
		oSection:Cell("DATA"):hide()



       	oSection:Cell("NOTA"):hide()				
		oSection:Cell("SERIE"):hide()
  		oSection:Cell("FORNECE"):hide()
  		oSection:Cell("LOJA"):hide()  		
		oSection:Cell("PRODUTO"):hide()
		oSection:Cell("CODBAR"):hide()
 		oSection:Cell("DESCRI PROD"):hide()
 		oSection:Cell("QUANT"):hide()
 		oSection:Cell("VALOR UNIT"):hide()
 		oSection:Cell("VALOR TOTAL"):hide()
		oSection:Cell("DATA"):hide()   

		
   		oReport:Thinline()		
		oSection:PrintLine()							


	
		oSection:Cell("NOTA"):hide()
		oSection:Cell("SERIE"):SetValue("TOTAIS-->")
		oSection:Cell("SERIE"):Show() 
		oSection:Cell("FORNECE"):hide()
		oSection:Cell("LOJA"):hide()
		oSection:Cell("PRODUTO"):hide()
		oSection:Cell("CODBAR"):hide()
		oSection:Cell("DESCRI PROD"):hide()
		oSection:Cell("QUANT"):SetValue(nGTotQtd)
		oSection:Cell("QUANT"):Show()		
		oSection:Cell("VALOR UNIT"):SetValue(nGTotalUni)
		oSection:Cell("VALOR UNIT"):Show()
		oSection:Cell("VALOR TOTAL"):SetValue(nGTotal)
		oSection:Cell("VALOR TOTAL"):Show()
		oSection:Cell("DATA"):hide()   


oReport:Thinline()		
oSection:PrintLine()

oSection:Finish() 

TMP->(DbCloseArea())        


Return
                                                                                               
/////////////////////////////////
// Monta SX1 (Perguntas)       //
/////////////////////////////////      

Static Function MontaSX1()

Local aHelpP := {}

aHelpP	:= {}
aAdd(aHelpP, "Informe a data Inicial") 
aAdd(aHelpP, "Desejada")                                                                           // Consulta Padrao 
PutSx1(cPerg, '01', 'Data de  ?' , 'Data de  ?' , 'Data de  ?' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par01', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)  

aHelpP	:= {}
aAdd(aHelpP, "Informe a data Final ")
aAdd(aHelpP, "Desejada")
PutSx1(cPerg, '02', 'Ate a Data ?', 'Ate a Data ? ', 'Ate a Data ?', 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par02', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)


aHelpP	:= {}
aAdd(aHelpP, "Informe a Nota")
aAdd(aHelpP, "inicial a ser procurado")
PutSx1(cPerg, '03', 'Nota de ?', 'Nota de ? ', 'Nota de ?', 'mv_ch3', 'C', 10, 0, 0, 'G', '', 'CBW', '', '', 'mv_par03', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)


aHelpP	:= {}
aAdd(aHelpP, "Informe Nota")
aAdd(aHelpP, "Final a ser procurado")
PutSx1(cPerg, '04', 'Nota Ate ?', 'Nota Ate ? ', 'Nota Ate ?', 'mv_ch4', 'C', 10, 0, 0, 'G', '', 'CBW', '', '', 'mv_par04', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)


aHelpP	:= {}
aAdd(aHelpP, "Informe o Produto Inicial ")
aAdd(aHelpP, "ser procurado")
PutSx1(cPerg, '05', 'Produto de ?', 'Produto de ? ', 'Produto de ?', 'mv_ch5', 'C', 10, 0, 0, 'G', '', 'SB1', '', '', 'mv_par05', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)


aHelpP	:= {}
aAdd(aHelpP, "Informe o Produto Final a ")
aAdd(aHelpP, "ser procurado")
PutSx1(cPerg, '06', 'Produto Ate ?', 'Produto Ate ? ', 'Produto Ate ?', 'mv_ch6', 'C', 10, 0, 0, 'G', '', 'SB1', '', '', 'mv_par06', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)



aHelpP	:= {}
aAdd(aHelpP, "Informe se o relatorio  ")
aAdd(aHelpP, "ira listar apenas notas nใo conferidas")
PutSx1(cPerg, '07', 'Somente notas a Conferir ?', 'Somente notas a Conferir ? ', 'Somente notas a Conferir ?', 'mv_ch7', 'N', 10, 0, 0, 'C', '', '', '', '', 'mv_par07', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', aHelpP, aHelpP, aHelpP)


Return            