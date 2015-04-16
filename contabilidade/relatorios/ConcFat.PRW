#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ  ConcFat()  บ Autor ณ Fernando Nogueira  บ Data ณ06/04/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Conciliacao do Faturamento                                 บฑฑ
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
User Function ConcFat()

Private cPerg := PadR("CONCFAT",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
Pergunte(cPerg,.T.)

oReport := ReportDef()
oReport:PrintDialog()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef() บ Autor ณ Fernando Nogueira  บ Data ณ23/12/2013บฑฑ
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

Private cPctD2Total := PesqPict('SD2','D2_TOTAL')

oReport := TReport():New("CONCFAT","Concilia็ใo Faturamento - Avant","CONCFAT",{|oReport| PrintReport(oReport)},"Concilia็ใo Faturamento - Avant")

oSection1 := TRSection():New(oReport,"PickList",{"TRB"})

If MV_PAR03 == 4
	TRCell():New(oSection1,"CFOP"   ,"TRB","CFOP")
	TRCell():New(oSection1,"CREDITO","TRB","Conta Credito")
	TRCell():New(oSection1,"VALBRUT","TRB","Valor Bruto"   ,PesqPict('SD2','D2_VALBRUT'),TamSx3("D2_VALBRUT")[1])
	TRCell():New(oSection1,"VALCONT","TRB","Valor Contabil",PesqPict('CT2','CT2_VALOR') ,TamSx3("CT2_VALOR")[1])
	TRFunction():New(oSection1:Cell("CFOP"),"Quant. Itens","COUNT",,/*Titulo*/,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
Else
	TRCell():New(oSection1,"NOTA_SAIDA","TRB","Nota de Saํda")	
	TRFunction():New(oSection1:Cell("NOTA_SAIDA"),"Quant. NFดs","COUNT",,/*Titulo*/,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
Endif

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PrintReport บ Autor ณ Fernando Nogueira  บ Data ณ23/12/2013บฑฑ
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

oSection1:Init()

While (!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
		
	oSection1:PrintLine()
	
	DbSkip()
	
	oReport:IncMeter()

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
ฑฑบPrograma  ณGeraArqTRBบAutor  ณ Fernando Nogueira  บ Data ณ 06/04/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraArqTRB()

If MV_PAR03 == 1

	BeginSql alias 'TRB'
	
		SELECT DISTINCT SUBSTRING(CT2_KEY,7,9) NOTA_SAIDA FROM 
			(SELECT ISNULL(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM,'SEM') SD2_KEY, CT2_KEY FROM %table:CT2% CT2
				LEFT JOIN %table:SD2% SD2
					ON CT2_KEY = D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
						AND SD2.%notDel% 
						AND D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
				WHERE CT2.%notDel%
					AND CT2_FILIAL = %xfilial:CT2%
					AND CT2_DATA BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
					AND CT2_LP = '610'
			) NULOS
		WHERE SD2_KEY = 'SEM'
		ORDER BY SUBSTRING(CT2_KEY,7,9)

	EndSql
	
ElseIf MV_PAR03 == 2

	BeginSql alias 'TRB'
	
		SELECT D2_DOC NOTA_SAIDA FROM
		(SELECT CT2_KEY,CT2_ORIGEM,D2_DOC, COUNT(*) QUANT FROM %table:CT2% CT2
			INNER JOIN %table:SD2% SD2 ON CT2_KEY = D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM 
				AND SD2.%notDel%
				AND D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
			WHERE CT2.%notDel%
				AND CT2_FILIAL = %xfilial:CT2%
				AND CT2_DATA BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
				AND CT2_LP = '610'
				AND CT2_VALOR > 0
			GROUP BY CT2_KEY,CT2_ORIGEM,D2_DOC) DUPLICADOS
		WHERE QUANT > 1

	EndSql
	
ElseIf MV_PAR03 == 3

	BeginSql alias 'TRB'
	
		SELECT DISTINCT SUBSTRING(SD2_KEY,7,9) NOTA_SAIDA FROM 
		(SELECT D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM SD2_KEY, ISNULL(CT2_KEY,'SEM') CT2_KEY FROM %table:SD2% SD2
			LEFT JOIN %table:CT2% CT2 ON D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM = CT2_KEY 
				AND CT2.%notDel%
				AND CT2_DATA BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
				AND CT2_LP = '610' 
			WHERE SD2.%notDel%
				AND D2_FILIAL = %xfilial:SD2%
				AND D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%) NULOS
		WHERE CT2_KEY = 'SEM'
		ORDER BY SUBSTRING(SD2_KEY,7,9)

	EndSql

ElseIf MV_PAR03 == 4

	BeginSql alias 'TRB'
	
		SELECT CFOP,CREDITO,SUM(VALBRUT) VALBRUT,SUM(VALCONT) VALCONT FROM 
		(SELECT ISNULL(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM,'SEM') SD2_KEY, 
				ISNULL(CT2_KEY,'SEM') CT2_KEY,ISNULL(D2_CF,'SEM') CFOP,
				ISNULL(D2_VALBRUT,0) VALBRUT,ISNULL(CT2_VALOR,0) VALCONT,
				CT2_HIST,ISNULL(LEFT(CT2_CREDIT,%exp:MV_PAR04%),'SEM') CREDITO 
			FROM %table:SD2% SD2
			FULL OUTER JOIN %table:CT2% CT2 ON D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM = CT2_KEY 
				AND CT2.%notDel%
				AND CT2_DATA BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
				AND CT2_LP = '610'
				AND CT2_VALOR > 0
			WHERE SD2.%notDel% 
				AND D2_FILIAL = %xfilial:SD2% 
				AND D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%) COMPARACAO
		GROUP BY CFOP,CREDITO
		ORDER BY CFOP,CREDITO

	EndSql

Endif
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Fernando Nogueira  บ Data ณ 06/04/2015  บฑฑ
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
	PutSX1(cPerg,"01","Da Data ?"   ,"","","mv_ch1","D",8,0,0,"G","NaoVazio","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"02","Ate a Data ?","","","mv_ch2","D",8,0,0,"G","NaoVazio","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Tipos:","- Notas Canceladas","- Lan็amento Duplicado","- Nใo Contabilizou","- Comparativo"}
	PutSX1(cPerg,"03","Tipo ?"      ,"","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Canceladas","Canceladas","Canceladas","","Duplicado","Duplicado","Duplicado","Nใo.Cont.","Nใo.Cont.","Nใo.Cont.","Comparativo","Comparativo","Comparativo","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Quantidade de caracteres para quebra da","Conta Contแbil no Comparativo"}
	PutSx1(cPerg,"04","Quantidade?" ,"","","mv_ch4","N",4,0,0,"G","","","",""        ,"mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	RestArea(aAreaAnt)

Return Nil