#include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ Disp_Canal()บ Autor ณ Fernando Nogueira  บ Data ณ18/06/2015บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescrio ณ Dispara Relatorio de Canal por e-mail.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico AVANT.                                          บฑฑ
ฑฑฬออออออออออฯอออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista Resp.ณ  Data  ณ Manutencao Efetuada                           บฑฑ
ฑฑฬออออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ  /  /  ณ                                               บฑฑ
ฑฑศออออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Disp_Canal()

Local aParam := {}
Local _cTipo
Local _lReturn := .T.

Private cPerg    := PadR("DISPCANAL",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
If Pergunte(cPerg,.T.)
		
	If MV_PAR03 == 1
		_cTipo := "DIARIO"
	ElseIf MV_PAR03 == 2
		_cTipo := "ACUMULADO"
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณaParam     |  [01]  | [02]  |  [03]   |   [04]   |  [05]  |  [06] |  [07]    |  [08]   |  [09]  |
	//ณ           | Canal  | Grupo | Data De | Data Ate | E-mail |   CC  | Schedule | Empresa | Filial |
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aadd(aParam, MV_PAR01)                             	// aParam{1]
	aadd(aParam, MV_PAR02)                             	// aParam{2]
	aadd(aParam, If(MV_PAR03 == 3,MV_PAR04,_cTipo))	    // aParam{3]
	aadd(aParam, If(MV_PAR03 == 3,MV_PAR05,""))       	// aParam{4]
	aadd(aParam, MV_PAR06)                            	// aParam{5]
	aadd(aParam, MV_PAR07)                            	// aParam{6]
	aadd(aParam, .F.)                                 	// aParam{7]
	
	_lReturn := U_Fat_Canal(aParam)
	
	If _lReturn
		MsgInfo("E-mail enviado com sucesso!")
	Else
		MsgInfo("Erro ao enviar e-mail, favor entrar em contato com o Depto de TI.")
	Endif
	
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณ Fernando Nogueira  บ Data ณ 18/06/2015  บฑฑ
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

	aHelpPor := {"Definir Canal","Especํfico: GERAL","Obs: em branco dispara todas,","menos o especํfico"}
	PutSX1(cPerg,"01","Canal ?","","","mv_ch1","C",06,0,0,"G","","CN","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Definir o Grupo","Obs: definindo grupo, o relat๓rio agrupa","por produto, em branco, por grupo"}
	PutSX1(cPerg,"02","Grupo ?","","","mv_ch2","C",04,0,0,"G","","SBM","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Tipos:","- Diario","- Acumulado (A partir do ultimo fech.)","- Personalizado (Parโmetros abaixo)"}
	PutSX1(cPerg,"03","Tipo ?"   ,"","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Diario","Diario","Diario","","Acumulado","Acumulado","Acumulado","Personalizado","Personalizado","Personalizado","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Inicial"}
	PutSX1(cPerg,"04","Data de ?","","","mv_ch4","D",8,0,0,"G","NaoVazio","","","","mv_par04","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"05","Data Ate ?","","","mv_ch5","D",8,0,0,"G","NaoVazio","","","","mv_par05","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Conta de e-mail"}
	PutSX1(cPerg,"06","E-mail ?","","","mv_ch6","C",40,0,0,"G","NaoVazio","","","","mv_par06","","","","workflow@avantled.com.br","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Conta de e-mail que vai receber c๓pia"}
	PutSX1(cPerg,"07","E-mail CC ?","","","mv_ch7","C",40,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
		
	RestArea(aAreaAnt)

Return Nil