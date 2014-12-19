#include "TOTVS.CH"
#include "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ MHDEnvMail() บ Autor ณ Fernando Nogueira บ Data ณ 04/02/14 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDesc.     ณ Conecta ao servidor de e-mail e envia o e-mail             บฑฑ
ฑฑบ          ณ Com suporte a SSL                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Avant                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
User Function MHDEnvMail(cPara,cCC,cBCC,cAssunto,cCorpo,cAttach)

Local oServer   := Nil
Local oMessage  := Nil
Local nErr      := 0
Local cPopAddr  := AllTrim(GETMV("ES_MHDSPO"))	// Endereco do servidor POP3
Local cSMTPAddr := AllTrim(GETMV("MV_RELSERV"))	// Endereco do servidor SMTP
Local cPOPPort  := Val(GETMV("ES_MHDPPO"))		// Porta do servidor POP
Local cSMTPPort := Val(GETMV("ES_MHDPSM"))		// Porta do servidor SMTP
Local cUser     := AllTrim(GetMV("MV_RELACNT"))	// Usuario que ira realizar a autenticacao
Local cPass     := AllTrim(GETMV("MV_RELAPSW"))	// Senha do usuario
Local nSMTPTime := 60							// Timeout SMTP
Local cDe		:= AllTrim(GETMV("MV_RELFROM"))	// Conta de envio
Local lSSL 		:= GETMV("ES_USESSL")
Local lTLS 		:= GETMV("ES_USETLS")

// Instancia um novo TMailManager
oServer := tMailManager():New()

// Usa SSL na conexao
oServer:setUseSSL(lSSL)
oServer:SetUseTLS(lTLS)

// Inicializa
oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)

// Define o Timeout SMTP
If oServer:SetSMTPTimeout(nSMTPTime) != 0
	Alert("[ERROR]Falha ao definir timeout")
	Return .F.
EndIf

// Conecta ao servidor
nErr := oServer:smtpConnect()
If nErr <> 0
	Alert("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	Return .F.
EndIf

// Realiza autenticacao no servidor
nErr := oServer:smtpAuth(cUser, cPass)
If nErr <> 0
	Alert("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	Return .F.
EndIf

// Cria uma nova mensagem (TMailMessage)
oMessage := tMailMessage():new()
oMessage:clear()
oMessage:cFrom 		:= cDe 
oMessage:cTo 		:= cPara
oMessage:cCC 		:= cCC
oMessage:cBCC  		:= cBCC
oMessage:cSubject	:= cAssunto
oMessage:cBody 		:= cCorpo

// Envia a mensagem
nErr := oMessage:Send(oServer)
If nErr <> 0
	Alert("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	Return .F.
EndIf

// Disconecta do Servidor
oServer:smtpDisconnect()

Return .T.