#include "PROTHEUS.CH"
#include "TopConn.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � ConcBaixas     � Autor � Fernando Nogueira  � Data �16/08/2016���
����������������������������������������������������������������������������͹��
���Descri��o � Concilia Baixas a Receber                                     ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                         ���
����������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                              ���
����������������������������������������������������������������������������͹��
���              �  /  /  �                                                  ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function ConcBaixas()

Local oReport

Private cPerg    := PadR("CONCBAIXA",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)

If Pergunte(cPerg,.T.)
	If mv_par03 == 1
		oReport := RepDef1()
		oReport:PrintDialog()
	ElseIf mv_par03 == 2
		oReport := RepDef2()
		oReport:PrintDialog()
	Else
		ApMsgInfo("Escolha um relat�rio")
	Endif
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RepDef1()   � Autor � Fernando Nogueira  � Data �12/08/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RepDef1()
Local oReport
Local oSection1
Local oBreak

Private aCtbDup   := {}

oReport := TReport():New("CONCBAIXA","Baixa NF N�o Contabilizada","CONCBAIXA",{|oReport| PrintRep1(oReport)},"Baixa NF N�o Contabilizada")
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"CONCBAIXA",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"E5_PREFIXO","TRB","Serie"       ,,TamSx3("E5_PREFIXO")[1])
TRCell():New(oSection1,"E5_NUMERO" ,"TRB","Numero"      ,,TamSx3("E5_NUMERO")[1])
TRCell():New(oSection1,"E5_PARCELA","TRB","Parc."       ,,TamSx3("E5_PARCELA")[1])
TRCell():New(oSection1,"E5_CLIFOR" ,"TRB","Cliente"     ,,TamSx3("E5_CLIFOR")[1])
TRCell():New(oSection1,"E5_LOJA"   ,"TRB","Lj"          ,,TamSx3("E5_LOJA")[1])
TRCell():New(oSection1,"E5_DATA"   ,"TRB","Data"        ,,12,,{||STOD(TRB->E5_DATA)})
TRCell():New(oSection1,"E5_DTDISPO","TRB","Disponib."   ,,12,,{||STOD(TRB->E5_DTDISPO)})
TRCell():New(oSection1,"E5_LA"     ,"TRB","Flg"         ,,TamSx3("E5_LA")[1])
TRCell():New(oSection1,"E5_TIPODOC","TRB","Tp Bx"       ,,TamSx3("E5_TIPODOC")[1])
TRCell():New(oSection1,"E5_MOTBX"  ,"TRB","Motivo"      ,,TamSx3("E5_MOTBX")[1])
TRCell():New(oSection1,"E5_VALOR"  ,"TRB","Valor"       ,PesqPict("SE5","E5_VALOR"),TamSx3("E5_VALOR")[1])
TRCell():New(oSection1,"E5_VLMULTA","TRB","Multa"       ,PesqPict("SE5","E5_VLMULTA"),TamSx3("E5_VLMULTA")[1])
TRCell():New(oSection1,"E5_VLJUROS","TRB","Juros"       ,PesqPict("SE5","E5_VLJUROS"),TamSx3("E5_VLJUROS")[1])
TRCell():New(oSection1,"E5_VLDESCO","TRB","Desc."       ,PesqPict("SE5","E5_VLDESCO"),TamSx3("E5_VLDESCO")[1])
TRCell():New(oSection1,"E5_BANCO"  ,"TRB","Banco"       ,,TamSx3("E5_BANCO")[1])
TRCell():New(oSection1,"E5_AGENCIA","TRB","Ag."         ,,TamSx3("E5_AGENCIA")[1])
TRCell():New(oSection1,"E5_CONTA"  ,"TRB","Conta"       ,,TamSx3("E5_CONTA")[1])
TRCell():New(oSection1,"E5_BENEF"  ,"TRB","Beneficiario",,TamSx3("E5_BENEF")[1])
TRCell():New(oSection1,"E5_HISTOR" ,"TRB","Historico"   ,,TamSx3("E5_HISTOR")[1])

TRFunction():New(oSection1:Cell("E5_NUMERO") ,"Quant. Itens","COUNT",,"Quant. Itens",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VALOR")  ,"Total Valor" ,"SUM",,"Total Valor",PesqPict("SE5","E5_VALOR")  ,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLMULTA"),"Total Multa" ,"SUM",,"Total Multa",PesqPict("SE5","E5_VLMULTA"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLJUROS"),"Total Juros" ,"SUM",,"Total Juros",PesqPict("SE5","E5_VLJUROS"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLDESCO"),"Total Desc." ,"SUM",,"Total Desc.",PesqPict("SE5","E5_VLDESCO"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RepDef1()   � Autor � Fernando Nogueira  � Data �17/08/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RepDef2()
Local oReport
Local oSection1
Local oBreak

Private aCtbDup   := {}

oReport := TReport():New("CONCBAIXA","Valor da Baixa NF Divergente do Contabil","CONCBAIXA",{|oReport| PrintRep2(oReport)},"Valor da Baixa NF Divergente do Contabil")
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"CONCBAIXA",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"E5_PREFIXO","TRB","Serie"       ,,TamSx3("E5_PREFIXO")[1])
TRCell():New(oSection1,"E5_NUMERO" ,"TRB","Numero"      ,,TamSx3("E5_NUMERO")[1])
TRCell():New(oSection1,"E5_PARCELA","TRB","Parc."       ,,TamSx3("E5_PARCELA")[1])
TRCell():New(oSection1,"E5_CLIFOR" ,"TRB","Cliente"     ,,TamSx3("E5_CLIFOR")[1])
TRCell():New(oSection1,"E5_LOJA"   ,"TRB","Lj"          ,,TamSx3("E5_LOJA")[1])
TRCell():New(oSection1,"E5_DATA"   ,"TRB","Data"        ,,12,,{||STOD(TRB->E5_DATA)})
TRCell():New(oSection1,"E5_DTDISPO","TRB","Disponib."   ,,12,,{||STOD(TRB->E5_DTDISPO)})
TRCell():New(oSection1,"E5_LA"     ,"TRB","Flg"         ,,TamSx3("E5_LA")[1])
TRCell():New(oSection1,"E5_TIPODOC","TRB","Tp Bx"       ,,TamSx3("E5_TIPODOC")[1])
TRCell():New(oSection1,"E5_MOTBX"  ,"TRB","Motivo"      ,,TamSx3("E5_MOTBX")[1])
TRCell():New(oSection1,"E5_VALOR"  ,"TRB","Valor"       ,PesqPict("SE5","E5_VALOR")  ,TamSx3("E5_VALOR")[1])
TRCell():New(oSection1,"E5_VLMULTA","TRB","Multa"       ,PesqPict("SE5","E5_VLMULTA"),TamSx3("E5_VLMULTA")[1])
TRCell():New(oSection1,"E5_VLJUROS","TRB","Juros"       ,PesqPict("SE5","E5_VLJUROS"),TamSx3("E5_VLJUROS")[1])
TRCell():New(oSection1,"E5_VLDESCO","TRB","Desc."       ,PesqPict("SE5","E5_VLDESCO"),TamSx3("E5_VLDESCO")[1])
TRCell():New(oSection1,"CT2_VALOR" ,"TRB","Valor Ctb."  ,PesqPict("CT2","CT2_VALOR") ,TamSx3("CT2_VALOR")[1])
TRCell():New(oSection1,"E5_BANCO"  ,"TRB","Banco"       ,,TamSx3("E5_BANCO")[1])
TRCell():New(oSection1,"E5_AGENCIA","TRB","Ag."         ,,TamSx3("E5_AGENCIA")[1])
TRCell():New(oSection1,"E5_CONTA"  ,"TRB","Conta"       ,,TamSx3("E5_CONTA")[1])
TRCell():New(oSection1,"E5_BENEF"  ,"TRB","Beneficiario",,TamSx3("E5_BENEF")[1])
TRCell():New(oSection1,"E5_HISTOR" ,"TRB","Historico"   ,,TamSx3("E5_HISTOR")[1])

TRFunction():New(oSection1:Cell("E5_NUMERO") ,"Quant. Itens","COUNT",,"Quant. Itens",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VALOR")  ,"Total Valor" ,"SUM",,"Total Valor",PesqPict("SE5","E5_VALOR")  ,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLMULTA"),"Total Multa" ,"SUM",,"Total Multa",PesqPict("SE5","E5_VLMULTA"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLJUROS"),"Total Juros" ,"SUM",,"Total Juros",PesqPict("SE5","E5_VLJUROS"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("E5_VLDESCO"),"Total Desc." ,"SUM",,"Total Desc.",PesqPict("SE5","E5_VLDESCO"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CT2_VALOR") ,"Total Ctb."  ,"SUM",,"Total Ctb." ,PesqPict("CT2","CT2_VALOR") ,/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PrintRep1   � Autor � Fernando Nogueira  � Data �12/08/2016���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de tratamento das informacoes do Relatorio	   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function PrintRep1(oReport)

Local oSection1 := oReport:Section(1)

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GerArqTRB1(),CursorArrow()})
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PrintRep2   � Autor � Fernando Nogueira  � Data �17/08/2016���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de tratamento das informacoes do Relatorio	   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function PrintRep2(oReport)

Local oSection1 := oReport:Section(1)

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GerArqTRB2(),CursorArrow()})
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GerArqTRB1�Autor  � Fernando Nogueira  � Data � 12/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao Auxiliar                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerArqTRB1()

	BeginSql alias 'TRB'
	
		SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_DATA,E5_DTDISPO,E5_LA,E5_TIPODOC,E5_MOTBX,E5_TIPO,E5_VALOR,E5_VLDESCO,E5_VLMULTA,E5_VLJUROS,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_BENEF,E5_HISTOR FROM %table:SE5% SE5
		LEFT JOIN %table:CV3% CV3 ON E5_FILIAL = CV3_FILIAL AND CV3_TABORI = 'SE5' AND SE5.R_E_C_N_O_ = CV3_RECORI AND CV3_VLR01 > 0 AND CV3_DTSEQ BETWEEN %Exp:DtoS(mv_par01-60)% AND %Exp:DtoS(mv_par02+60)% AND CV3_HIST NOT LIKE '%MULTA/JUROS%' AND CV3_HIST NOT LIKE '%MUL/JUR%' AND CV3_HIST NOT LIKE '%BAIXA JUROR%' AND CV3_HIST NOT LIKE '%BAIXA JUROS%' AND CV3_HIST NOT LIKE '%BX JUROS%' AND CV3_HIST NOT LIKE '%DESCONT %' AND CV3.%notDel% AND CV3_RECDES IN (SELECT TMP.R_E_C_N_O_ FROM %table:CT2% TMP WHERE TMP.CT2_FILIAL = CV3_FILIAL AND TMP.R_E_C_N_O_ = CV3_RECDES AND TMP.%notDel%)
		LEFT JOIN %table:CT2% CT2 ON E5_FILIAL = CT2_FILIAL AND CT2.R_E_C_N_O_ = CV3_RECDES AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND CT2_CREDIT = '110503002' AND CT2_VALOR > 0 AND CT2.%notDel%
		WHERE SE5.%notDel%
			AND E5_FILIAL = %xfilial:SE5% 
			AND E5_DTDISPO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)%
			AND E5_RECPAG = 'R' 
			AND E5_VALOR > 0
			AND E5_TIPODOC NOT IN ('TR','DC','D2','JR','J2','MT','M2','DB','ES','CP') // Transf para Descontado/Desc/Juros/Multa/Desp Banc/Estorno Contas a Pagar/Compensacoes
			AND E5_SITUACA <> 'C' // Baixa nao cancelada
			AND E5_TIPO = 'NF'
			AND CT2.R_E_C_N_O_ IS NULL
		ORDER BY SE5.R_E_C_N_O_

	EndSql
	
	ConOut("teste")
	
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GerArqTRB2�Autor  � Fernando Nogueira  � Data � 17/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao Auxiliar                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerArqTRB2()

	BeginSql alias 'TRB'
	
		SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_CLIFOR,E5_LOJA,E5_DATA,E5_DTDISPO,E5_LA,E5_TIPODOC,E5_MOTBX,E5_TIPO,E5_VALOR,E5_VLDESCO,E5_VLMULTA,E5_VLJUROS,CT2_VALOR,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_BENEF,E5_HISTOR FROM %table:SE5% SE5
		INNER JOIN %table:CV3% CV3 ON E5_FILIAL = CV3_FILIAL AND CV3_TABORI = 'SE5' AND SE5.R_E_C_N_O_ = CV3_RECORI AND CV3_VLR01 > 0 AND CV3_DTSEQ BETWEEN %Exp:DtoS(mv_par01-60)% AND %Exp:DtoS(mv_par02+60)% AND CV3_HIST NOT LIKE '%MULTA/JUROS%' AND CV3_HIST NOT LIKE '%MUL/JUR%' AND CV3_HIST NOT LIKE '%BAIXA JUROR%' AND CV3_HIST NOT LIKE '%BAIXA JUROS%' AND CV3_HIST NOT LIKE '%BX JUROS%' AND CV3_HIST NOT LIKE '%DESCONT %' AND CV3.%notDel% AND CV3_RECDES IN (SELECT TMP.R_E_C_N_O_ FROM %table:CT2% TMP WHERE TMP.CT2_FILIAL = CV3_FILIAL AND TMP.R_E_C_N_O_ = CV3_RECDES AND TMP.%notDel%)
		INNER JOIN %table:CT2% CT2 ON E5_FILIAL = CT2_FILIAL AND CT2.R_E_C_N_O_ = CV3_RECDES AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND CT2_CREDIT = '110503002' AND CT2_VALOR > 0 AND CT2.%notDel%
		WHERE SE5.%notDel%
			AND E5_FILIAL = %xfilial:SE5% 
			AND E5_DTDISPO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)%
			AND E5_RECPAG = 'R' 
			AND E5_VALOR > 0
			AND E5_TIPODOC NOT IN ('TR','DC','D2','JR','J2','MT','M2','DB','ES','CP') // Transf para Descontado/Desc/Juros/Multa/Desp Banc/Estorno Contas a Pagar/Compensacoes
			AND E5_SITUACA <> 'C' // Baixa nao cancelada
			AND E5_TIPO = 'NF'
			AND ROUND(E5_VALOR-E5_VLJUROS-E5_VLMULTA,02) <> ROUND(ISNULL(CT2_VALOR,0),02)
		ORDER BY SE5.R_E_C_N_O_

	EndSql
	
	ConOut("teste")
	
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  � Fernando Nogueira  � Data � 16/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria as perguntas do programa no dicionario de perguntas    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := {"Data Inicial"}
	PutSX1(cPerg,"01","Data de ?" ,"","","mv_ch1","D",8,0,0,"G","NaoVazio","","","","mv_par01","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"02","Data Ate ?","","","mv_ch2","D",8,0,0,"G","NaoVazio","","","","mv_par02","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Relat�rio:","- Nao Contabilizou","- Valor Divergente"}
	PutSX1(cPerg,"03","Relat�rio ?"    ,"","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Sem Contabil","Sem Contabil","Sem Contabil","","Vlr Divergente","Vlr Divergente","Vlr Divergente","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

		
	RestArea(aAreaAnt)

Return Nil