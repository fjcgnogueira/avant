#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BOLETOFRAUDE  ³ Autor ³ Rogerio Machado    ³ Data  ³ 14/06/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Alerta de boletos fraudados                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BOLETOFRAUDE()

Local cLog     	 := ""
Local cAssunto   := ""
Local _cPara     := ""
Local cMailBCC   := ""
Local oProcess  := Nil
Local cArquivo  := "\MODELOS\BoletoFraude.html"

oProcess := TWFProcess():New("BOLETOFRAUDE","INADIMPLENCIA")
oProcess:NewTask("Enviando Relação de Clientes Inadimplentes",cArquivo)
oHTML := oProcess:oHTML


//Prepare Environment EMPRESA '01' FILIAL '010104'

BeginSql alias 'TRF'

	SELECT RTRIM(A1_EMAIL) AS A1_EMAIL FROM %table:SA1% SA1 
	WHERE SA1.%notDel% AND A1_COD = '020538'

EndSql

ConOut("[BoletoFraude] - Disparando e-mails")

DbSelectArea('TRF')
TRF->(DbGoTop())

While TRF->(!Eof())
	ConOut("teste 1")
	_cPara     := TRF->A1_EMAIL
	cAssunto := "Avant - Comunicado importante sobre 'BOLETOS FALSOS'"
	
	oProcess:cSubject := "Avant - Comunicado importante sobre 'BOLETOS FALSOS'"
	ConOut("teste 2")
	oProcess:USerSiga := "000000"
	oProcess:cTo      := _cPara
	oProcess:cBCC     := cMailBCC
	ConOut("teste 3")
	oProcess:Start()
	oProcess:Finish()
	ConOut("teste 4")
	//U_MHDEnvMail(_cPara, "", "", cAssunto, cLog, "")
	//ConOut("Enviado para: "+ _cPara +","+ cMailBCC)
	TRF->(DbSkip())
End

ConOut("[BoletoFraude] - Finalizado")

Return


//RESET ENVIRONMENT
	
