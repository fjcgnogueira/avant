#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RELNCC()    � Autor � Rogerio Machado    � Data �17/09/2015���
�������������������������������������������������������������������������͹��
���Descri��o � Relacao de NCC's em aberto                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                          ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RELNCC()

	Private cPerg := PadR("RELNCC",Len(SX1->X1_GRUPO))

	AjustaSX1(cPerg)
	Pergunte(cPerg,.F.)
	
	oReport := ReportDef()
	oReport:PrintDialog()

Return


Static Function ReportDef()
	Local oReport
	Local oSection1
	
	oReport := TReport():New("RELNCC","NCC's em aberto","RELNCC",{|oReport| PrintReport(oReport)},"NCC's em aberto")
	
	oSection1 := TRSection():New(oReport,"NCC's em aberto",{"TRZ"})
	
	TRCell():New(oSection1,"E1_FILIAL"    ,"TRZ","Filial")
	TRCell():New(oSection1,"E1_NUM"   ,"TRZ","Titulo")
	TRCell():New(oSection1,"E1_PARCELA"   ,"TRZ","Parcela")
	TRCell():New(oSection1,"E1_TIPO" ,"TRZ","Tipo")
	TRCell():New(oSection1,"E1_CLIENTE" ,"TRZ","Cod. Cliente")
	TRCell():New(oSection1,"E1_LOJA" ,"TRZ","Loja")
	TRCell():New(oSection1,"A1_NOME" ,"TRZ","Cliente")
	TRCell():New(oSection1,"E1_EMISSAO" ,"TRZ","Emiss�o")
	TRCell():New(oSection1,"E1_VALOR" ,"TRZ","Valor")
	TRCell():New(oSection1,"E1_SALDO" ,"TRZ","Saldo")
	TRCell():New(oSection1,"F3_OBSERV" ,"TRZ","Observa��es",,,,{||Stod(TRZ->E1_EMISSAO)})

Return oReport

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
	
	DbSelectArea('TRZ')
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
	
	TRZ->(DbCloseArea())

Return


Static Function GeraArqTRB()
	
	BeginSql alias 'TRZ'

		SELECT E1_FILIAL, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, A1_NOME, E1_EMISSAO, E1_VALOR, E1_SALDO, F3_OBSERV 
		FROM %table:SE1% SE1 
		INNER JOIN %table:SA1% SA1 ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND SA1.%notDel%
		INNER JOIN %table:SF3% SF3 ON E1_FILIAL = F3_FILIAL AND E1_SERIE = F3_SERIE AND E1_NUM = F3_NFISCAL AND SF3.%notDel%
		WHERE SE1.%notDel% AND E1_SALDO > '0' AND E1_TIPO = 'NCC'
	
	EndSql

	
	
	
Return()


Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	
	aHelpPor := {"De data?"}
	PutSX1(cPerg,"01","De data?","De data?","De data?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,"","")
	aHelpPor := {"At� Data?"}
	PutSX1(cPerg,"02","At� Data?","At� Data?","At� Data?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,"","")
	
	RestArea(aAreaAnt)      

Return Nil