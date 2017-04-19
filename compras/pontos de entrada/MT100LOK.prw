#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100LOK � Autor � Fernando Nogueira   � Data � 21/10/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para Validacao de Linha na Nota de Entrada���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	cLog += " Data / Hora �nicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
	cLog += " Environment........: " + GetEnvServer()  + CRLF
	cLog += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
	cLog += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
	cLog += " Vers�o.............: " + GetVersao(.T.)  + CRLF
	cLog += " Usu�rio TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
	cLog += " Computer Name......: " + GetComputerName() + CRLF

	ConOut(cLog)

	//Final('Entrada de Nota de Devolu��o Somente na Comunica��o "entrada"')
Endif

Return .T.
