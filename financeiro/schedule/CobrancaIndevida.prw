#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Cobindevida  ³ Autor ³ Rogerio Machado    ³ Data  ³ 14/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alerta de boletos fraudados                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CobIndevida()

Local cLog     	 := ""
Local cAssunto   := ""
Local _cPara     := ""
Local cMailBCC   := ""
Local oProcess  := Nil
Local cArquivo  := "\MODELOS\CobrancaIndevida.html"
Local aTabelas  := {"SA1"}
Local cAliasSA1 := GetNextAlias()

BeginSql alias cAliasSA1

	SELECT RTRIM(A1_EMAIL) AS A1_EMAIL FROM %table:SA1% SA1 
	WHERE SA1.%notDel% AND A1_EMAIL LIKE '%@%'

EndSql

ConOut("[CobIndevida] - Disparando e-mails")

(cAliasSA1)->(DbGoTop())

While (cAliasSA1)->(!Eof())

	oProcess := TWFProcess():New("COBINDEVIDA","COBINDEVIDA")
	oProcess:NewTask("Enviando Notificação de Cobrança Indevida",cArquivo)
	oHTML := oProcess:oHTML

	_cPara     := (cAliasSA1)->A1_EMAIL
	cAssunto := "Avant - Comunicado importante sobre 'BOLETOS FALSOS'"
	
	oProcess:cSubject := "Avant - Comunicado importante sobre 'Cobranca'"

	oProcess:USerSiga := "000000"
	oProcess:cTo      := _cPara

	oProcess:Start()
	oProcess:Finish()

	ConOut("Enviado para: "+ _cPara)
	(cAliasSA1)->(DbSkip())
End

ConOut("[CobIndevida] - Finalizado")

(cAliasSA1)->(dbCloseArea())

Return
	