#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ AvaliaComissao บ Autor ณ Fernando Nogueira  บ Data ณ07/08/2014บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Avalia Diferencas de Base de Calculo das Comissoes            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                   	                         บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                              บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                                  บฑฑ
ฑฑศออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AvaliaComissao()

Local oReport

Private cPerg := PadR("AVALCOMIS",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDef() บ Autor ณ Fernando Nogueira  บ Data ณ07/08/2014บฑฑ
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

oReport := TReport():New("AVALCOMIS","Avalia Diferen็as na Comissใo","AVALCOMIS",{|oReport| PrintReport(oReport)},"Avalia Diferen็as na Comissใo")
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"AVALCOMIS",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"NUM"         ,"TRB","N๚mero"    ,                           ,TamSx3("E1_NUM")[1])
TRCell():New(oSection1,"PREFIXO"     ,"TRB","Prefixo"   ,                           ,TamSx3("E1_PREFIXO")[1])
TRCell():New(oSection1,"PARCELA"     ,"TRB","Parcela"   ,                           ,TamSx3("E1_PARCELA")[1])
TRCell():New(oSection1,"CODCLI"      ,"TRB","Cliente"   ,                           ,TamSx3("E1_CLIENTE")[1])
TRCell():New(oSection1,"LOJA"        ,"TRB","Loja."     ,                           ,TamSx3("E1_LOJA")[1])
TRCell():New(oSection1,"NOMECLI"     ,"TRB","Nome"      ,                           ,TamSx3("A1_NOME")[1])
TRCell():New(oSection1,"VEND"        ,"TRB","Vendedor"  ,                           ,TamSx3("A3_COD")[1])
TRCell():New(oSection1,"NOME"        ,"TRB","Nome"      ,                           ,TamSx3("A3_NOME")[1])
TRCell():New(oSection1,"BAIXA"       ,"TRB","Data Baixa",                           ,12,,{||STOD(TRB->BAIXA)})
TRCell():New(oSection1,"PORC"        ,"TRB","Porc."     ,PesqPict("SE1","E1_COMIS1"),TamSx3("E1_COMIS1")[1])
TRCell():New(oSection1,"VALOR_TIT"   ,"TRB","Vlr.Tit"   ,PesqPict("SE1","E1_VALOR") ,TamSx3("E1_VALOR")[1])
TRCell():New(oSection1,"BASE_TIT"    ,"TRB","Base Tit"  ,PesqPict("SE1","E1_VALOR") ,TamSx3("E1_VALOR")[1])
TRCell():New(oSection1,"BASE_COMIS"  ,"TRB","Base Comis",PesqPict("SE1","E1_VALOR") ,TamSx3("E1_VALOR")[1])
TRCell():New(oSection1,"ICMSRET"     ,"TRB","ICMS Ret"  ,PesqPict("SE1","E1_VALOR") ,TamSx3("E1_VALOR")[1])
TRCell():New(oSection1,"IPI"         ,"TRB","IPI"       ,PesqPict("SE1","E1_VALOR") ,TamSx3("E1_VALOR")[1])
TRCell():New(oSection1,"CALCULO_BASE","TRB","Base Calc.",PesqPict("SE1","E1_VALOR") ,TamSx3("E1_VALOR")[1])

TRFunction():New(oSection1:Cell("NUM"),"Quant. Itens","COUNT",,/*Titulo*/,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PrintReport บ Autor ณ Fernando Nogueira  บ Data ณ07/08/2014บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de tratamento das informacoes do Relatorio	   	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

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
	
	oReport:IncMeter()
	
	DbSkip()
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
ฑฑบPrograma  ณGeraArqTRBบAutor  ณ Fernando Nogueira  บ Data ณ 17/12/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao Auxiliar                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraArqTRB()

	BeginSql alias 'TRB'
	
		SELECT * FROM 
			(SELECT NUM,PREFIXO,PARCELA,CODCLI,LOJA,A1_NOME NOMECLI,E1_VEND1 VEND,A3_NOME NOME,E1_BAIXA BAIXA,PORC,E1_VALOR VALOR_TIT,E1_BASCOM1 BASE_TIT,
					BASE BASE_COMIS,CASE WHEN PARCELA IN (' ','1') THEN F2_ICMSRET ELSE 0 END ICMSRET,CASE WHEN PARCELA IN (' ','1') THEN F2_VALIPI ELSE 0 END IPI,
					CASE WHEN PARCELA IN (' ','1') THEN E1_VALOR-F2_ICMSRET-F2_VALIPI ELSE E1_VALOR END CALCULO_BASE FROM
				(SELECT SUM(E3_BASE) BASE,E3_VEND VEND,E3_NUM NUM,E3_PREFIXO PREFIXO, E3_PARCELA PARCELA,E3_CODCLI CODCLI,E3_LOJA LOJA,E3_PORC PORC,SUM(E3_COMIS) COMIS FROM
					(SELECT SUM(E3_BASE) BASE,E3_VEND VEND,E3_NUM NUM,E3_PREFIXO PREFIXO, E3_PARCELA PARCELA,E3_CODCLI CODCLI,E3_LOJA LOJA,E3_PORC PORC,SUM(E3_COMIS) COMIS FROM SE3010 SE3
					INNER JOIN %table:SE1% SE1 ON E1_FILIAL = %xfilial:SE1% AND E3_NUM = E1_NUM AND E3_PREFIXO = E1_PREFIXO AND E3_PARCELA = E1_PARCELA AND E1_TIPO <> 'CH' AND SE1.%notDel%
					WHERE SE3.%notDel% AND E3_EMISSAO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND E3_DATA = ' ' AND E1_BASCOM1 <> E3_BASE AND E1_BAIXA <> ' ' AND E1_SALDO = 0
					GROUP BY E3_VEND,E3_NUM,E3_PREFIXO,E3_PARCELA,E3_CODCLI,E3_LOJA,E3_PORC) COMISSAO
				INNER JOIN SE3010 SE3 ON NUM = E3_NUM AND PREFIXO = E3_PREFIXO AND PARCELA = E3_PARCELA AND SE3.%notDel%
				GROUP BY E3_VEND,E3_NUM,E3_PREFIXO,E3_PARCELA,E3_CODCLI,E3_LOJA,E3_PORC) COMISSAO_2
			INNER JOIN %table:SE1% SE1 ON E1_FILIAL = %xfilial:SE1% AND NUM = E1_NUM AND PREFIXO = E1_PREFIXO AND PARCELA = E1_PARCELA AND SE1.%notDel% AND E1_BAIXA <> ' '
			INNER JOIN %table:SF2% SF2 ON E1_FILIAL = F2_FILIAL AND E1_NUM = F2_DOC AND E1_PREFIXO = F2_SERIE AND E1_CLIENTE = F2_CLIENTE AND E1_LOJA = F2_LOJA AND SF2.%notDel%
			INNER JOIN %table:SA3% SA3 ON E1_VEND1 = A3_COD AND SA3.%notDel%
			INNER JOIN %table:SA1% SA1 ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.%notDel%
			WHERE (E1_BASCOM1+0.5 < BASE OR E1_BASCOM1-0.5 > BASE)) CALC_COMISSAO
		WHERE CALCULO_BASE <> BASE_COMIS
		ORDER BY BAIXA

	EndSql
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Fernando Nogueira  บ Data ณ 07/08/2014  บฑฑ
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
	PutSX1(cPerg,"01","Data de ?","","","mv_ch1","D",8,0,0,"G","NaoVazio","","","","mv_par01","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"02","Data Ate ?","","","mv_ch2","D",8,0,0,"G","NaoVazio","","","","mv_par02","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
		
	RestArea(aAreaAnt)

Return Nil