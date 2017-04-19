#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ MT100LOK บ Autor ณ Fernando Nogueira   บ Data ณ 21/10/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para Validacao de Linha na Nota de Entradaบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT100LOK()

Local cLog := ""

// Derrubar usuario que estiver fazendo devolucao no servico errado
If !IsBlind() .And. oApp:nPort <> 1483 .And. cTipo == "D"

	cLog += Replicate( "-", 128 ) + CRLF
	cLog += Replicate( " ", 128 ) + CRLF
	cLog += "LOG DA ENTRADA DE DEVOLUCAO" + CRLF
	cLog += Replicate( " ", 128 ) + CRLF
	cLog += Replicate( "-", 128 ) + CRLF
	cLog += CRLF
	cLog += " Dados Ambiente" + CRLF
	cLog += " --------------------"  + CRLF
	cLog += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
	cLog += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
	cLog += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
	cLog += " DataBase...........: " + DtoC( dDataBase )  + CRLF
	cLog += " Data / Hora อnicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
	cLog += " Environment........: " + GetEnvServer()  + CRLF
	cLog += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
	cLog += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
	cLog += " Versใo.............: " + GetVersao(.T.)  + CRLF
	cLog += " Usuแrio TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
	cLog += " Computer Name......: " + GetComputerName() + CRLF

	ConOut(cLog)

	//Final('Entrada de Nota de Devolu็ใo Somente na Comunica็ใo "entrada"')
Endif

Return .T.
