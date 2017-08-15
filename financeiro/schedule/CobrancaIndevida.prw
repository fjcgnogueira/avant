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

/*
RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)
*/

oProcess := TWFProcess():New("COBINDEVIDA","COBINDEVIDA")
oProcess:NewTask("Enviando Notificação de Cobrança Indevida",cArquivo)
oHTML := oProcess:oHTML


//Prepare Environment EMPRESA '01' FILIAL '010104'

BeginSql alias 'TRF'

	SELECT RTRIM(A1_EMAIL) AS A1_EMAIL FROM %table:SA1% SA1 
	WHERE SA1.%notDel% AND A1_EMAIL LIKE '%@%'

EndSql

ConOut("[CobIndevida] - Disparando e-mails")

DbSelectArea('TRF')
TRF->(DbGoTop())

While TRF->(!Eof())

	_cPara     := TRF->A1_EMAIL
	cAssunto := "Avant - Comunicado importante sobre 'BOLETOS FALSOS'"
	
	oProcess:cSubject := "Avant - Comunicado importante sobre 'Cobranca'"

	oProcess:USerSiga := "000000"
	oProcess:cTo      := _cPara

	oProcess:Start()
	oProcess:Finish()

	ConOut("Enviado para: "+ _cPara)
	TRF->(DbSkip())
End

ConOut("[CobIndevida] - Finalizado")

TRF->(dbCloseArea())

Return


//RESET ENVIRONMENT
	
