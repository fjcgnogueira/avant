#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PkListWMS() บ Autor ณ Fernando Nogueira  บ Data ณ04/04/2014บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Pick List por Pedido de Vendas Utilizando o WMS            บฑฑ
ฑฑบ          ณ Chamado 001112                                             บฑฑ
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
User Function PkListWMS()

Local oReport

Pergunte("PEDFATURAR",.F.)

oReport := ReportDef()
oReport:PrintDialog()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef() บ Autor ณ Fernando Nogueira  บ Data ณ16/12/2013บฑฑ
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
Local oSection2
Local oBreak

oReport := TReport():New("PICKLISTWMS","Pick List Pedidos WMS - Avant","PEDFATURAR",{|oReport| PrintReport(oReport)},"Pick List Pedidos WMS - Avant")

oSection1 := TRSection():New(oReport,"PickListWMS",{"TRB"})
oSection1:SetPageBreak()

TRCell():New(oSection1,"C5_NUM"    ,"TRB","Pedido")
TRCell():New(oSection1,"C5_CLIENTE","TRB","Cliente")
TRCell():New(oSection1,"C5_LOJACLI","TRB","Loja")
TRCell():New(oSection1,"C5_DESCCLI","TRB","Nome")
TRCell():New(oSection1,"C5_TRANSP" ,"TRB","Transp.")
TRCell():New(oSection1,"C5_NOMTRAN","TRB","Nome Transportadora")

TRFunction():New(oSection1:Cell("C5_NUM"),"Quant. Pedidos","COUNT",,/*Titulo*/,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)

oSection2 := TRSection():New(oSection1,"Produtos",{"TRB"},/*{Array com as ordens do relat๓rio}*/, .F., .F. )

TRCell():New(oSection2,"C5_NUM"    ,"TRB","")
TRCell():New(oSection2,"C9_PRODUTO","TRB","Produto",,15)
TRCell():New(oSection2,"B1_DESC"   ,"TRB",,,TamSx3("B1_DESC")[1])
TRCell():New(oSection2,"DB_QUANT"  ,"TRB","Quant.")
TRCell():New(oSection2,"B1_CODBAR" ,"TRB",,,15)
TRCell():New(oSection2,"B1_X_BAR2" ,"TRB",,,20)
TRCell():New(oSection2,"DB_LOCAL"  ,"TRB",,,TamSx3("DB_LOCAL")[1])
TRCell():New(oSection2,"DB_LOCALIZ","TRB",,,TamSx3("DB_LOCALIZ")[1])
TRCell():New(oSection2,"CHECK_LIST","TRB","Check",/*Picture*/,10,/*lPixel*/,/*CodeBlock*/)

oSection2:Cell("C5_NUM"):Hide()

TRFunction():New(oSection2:Cell("C9_PRODUTO"),"Quant. Itens","COUNT",,/*Titulo*/,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection2)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PrintReport บ Autor ณ Fernando Nogueira  บ Data ณ17/12/2013บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de tratamento das informacoes do Relatorio	   	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)
Local cPedido   := ""

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
	cPedido := TRB->C5_NUM	

	oSection2:Init()
	
	While (!Eof()) .And. TRB->C5_NUM == cPedido
	
		oSection2:PrintLine()
		oReport:SkipLine()
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
ฑฑบPrograma  ณGeraArqTRBบAutor  ณ Fernando Nogueira  บ Data ณ 17/12/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraArqTRB()

	Local cCampo := "%%"
	Local cWhere := "%%"
	Local cOrder := "%%"
	
	BeginSql alias 'TRB'
	
		SELECT C5_NUM,C9_PRODUTO,B1_DESC,B1_CODBAR,B1_X_BAR2,DB_LOCAL,DB_LOCALIZ,DB_QUANT,C5_CLIENTE,C5_LOJACLI,C5_DESCCLI,C5_TRANSP,C5_NOMTRAN,DB_IDOPERA,'|________|' CHECK_LIST
		FROM %table:SC5% SC5
		INNER JOIN %table:SC9% SC9 ON C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND SC9.%notDel% AND C9_BLEST = ' ' AND C9_BLCRED = ' ' AND C9_BLOQUEI = ' '
		INNER JOIN %table:SDB% SDB ON C5_FILIAL = DB_FILIAL AND C5_NUM = DB_DOC AND C9_ITEM = DB_SERIE AND DB_TIPO = 'E' AND DB_ESTORNO = ' ' AND DB_TM <> ' ' AND SDB.%notDel%
		INNER JOIN %table:SB1% SB1 ON C9_PRODUTO = B1_COD AND SB1.%notDel%
		WHERE C5_FILIAL = %xfilial:SC5% AND C5_LIBEROK <> ' ' AND C5_NOTA = ' ' AND C5_BLQ = ' ' AND SC5.%notDel%
			AND C5_NUM BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		GROUP BY C5_NUM,C9_ITEM,C9_PRODUTO,B1_DESC,DB_QUANT,B1_CODBAR,B1_X_BAR2,DB_LOCAL,DB_LOCALIZ,DB_QUANT,C5_CLIENTE,C5_LOJACLI,C5_DESCCLI,C5_TRANSP,C5_NOMTRAN,DB_IDOPERA
		ORDER BY C5_NUM,C9_ITEM,DB_QUANT

	EndSql
	
Return()