#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  Disp_Fat() � Autor � Fernando Nogueira  � Data �28/02/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Dispara Relatorio de Faturamento por e-mail.               ���
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
User Function Disp_Fat()

Local aParam := {}
Local _cTipo
Local _lReturn := .T.

Private cPerg    := PadR("DISPFAT",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
If Pergunte(cPerg,.T.)

	If MV_PAR03 == 1
		_cTipo := "DIARIO"
	ElseIf MV_PAR03 == 2
		_cTipo := "ACUMULADO"
	Endif

	//������������������������������������������������������������������������������������������������Ŀ
	//�aParam     |  [01]  | [02]  |  [03]   |   [04]   |  [05]  |  [06] |  [07]    |  [08]   |  [09]  |
	//�           | Regiao | Grupo | Data De | Data Ate | E-mail |   CC  | Schedule | Empresa | Filial |
	//��������������������������������������������������������������������������������������������������

	aadd(aParam, MV_PAR01)                             	// aParam{1]
	aadd(aParam, MV_PAR02)                             	// aParam{2]
	aadd(aParam, If(MV_PAR03 == 3,MV_PAR04,_cTipo))	// aParam{3]
	aadd(aParam, If(MV_PAR03 == 3,MV_PAR05,""))       	// aParam{4]
	aadd(aParam, MV_PAR06)                            	// aParam{5]
	aadd(aParam, MV_PAR07)                            	// aParam{6]
	aadd(aParam, .F.)                                 	// aParam{7]

	_lReturn := U_Fat_Diario(aParam)

	If _lReturn
		MsgInfo("E-mail enviado com sucesso!")
	Else
		MsgInfo("Erro ao enviar e-mail, favor entrar em contato com o Depto de TI.")
	Endif

Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  � Fernando Nogueira  � Data � 23/12/2013  ���
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

	aHelpPor := {"Definir Regiao","Espec�ficas: DIRETORIA, GERAL","Obs: em branco dispara todas,","menos as espec�ficas"}
	PutSX1(cPerg,"01","Regiao ?"   ,"","","mv_ch1","C",10,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Definir o Grupo","Obs: definindo grupo, o relat�rio agrupa","por produto, em branco, por grupo"}
	PutSX1(cPerg,"02","Grupo ?","","","mv_ch2","C",4,0,0,"G","","SBM","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Tipos:","- Diario","- Acumulado (A partir do ultimo fech.)","- Personalizado (Par�metros abaixo)"}
	PutSX1(cPerg,"03","Tipo ?"   ,"","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Diario","Diario","Diario","","Acumulado","Acumulado","Acumulado","Personalizado","Personalizado","Personalizado","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Inicial"}
	PutSX1(cPerg,"04","Data de ?","","","mv_ch4","D",8,0,0,"G","NaoVazio","","","","mv_par04","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"05","Data Ate ?","","","mv_ch5","D",8,0,0,"G","NaoVazio","","","","mv_par05","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Conta de e-mail"}
	PutSX1(cPerg,"06","E-mail ?","","","mv_ch6","C",40,0,0,"G","NaoVazio","","","","mv_par06","","","","workflow@avantlux.com.br","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Conta de e-mail que vai receber c�pia"}
	PutSX1(cPerg,"07","E-mail CC ?","","","mv_ch7","C",40,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

	RestArea(aAreaAnt)

Return Nil
