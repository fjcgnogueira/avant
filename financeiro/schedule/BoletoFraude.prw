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

User Function BOLETOFRAUDE(aParam)

Local cLog     	 := ""
Local cAssunto   := ""
Local _cPara     := ""
Local cMailBCC   := ""
Local oProcess  := Nil
Local cArquivo  := "\MODELOS\BoletoFraude.html"
Local aTabelas  := {"SE1","SA1"}
Local cAlias1   := GetNextAlias()						// Pega o proximo Alias Disponivel

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(aParam[1], aParam[2], NIL, NIL, "FIN", NIL, aTabelas)


Prepare Environment EMPRESA '01' FILIAL '010104'

BeginSql alias cAlias1

	SELECT RTRIM(A1_EMAIL) AS A1_EMAIL FROM %table:SA1% SA1 
	WHERE SA1.%notDel% AND A1_EMAIL NOT IN ('ISENTO',' ')
	AND A1_ULTCOM >= '20160101' AND LEFT(A1_EMAIL,1) > '9'
	ORDER BY 1

EndSql

ConOut("[BoletoFraude] - Disparando e-mails")

DbSelectArea(cAlias1)
(cAlias1)->(DbGoTop())

While (cAlias1)->(!Eof())

	oProcess := TWFProcess():New("BOLETOFRAUDE","INADIMPLENCIA")
	oProcess:NewTask("Aviso de boletos fraudados",cArquivo)
	oHTML := oProcess:oHTML

	_cPara     := (cAlias1)->A1_EMAIL
	cAssunto := "Avant - Comunicado importante sobre 'BOLETOS FALSOS'"
	
	oProcess:cSubject := "Avant - Comunicado importante sobre 'BOLETOS FALSOS'"

	oProcess:USerSiga := "000000"
	oProcess:cTo      := _cPara
	oProcess:cBCC     := cMailBCC

	oProcess:Start()
	oProcess:Finish()

	ConOut("Enviado para: "+ alltrim(_cPara) +","+ alltrim(cMailBCC))
	(cAlias1)->(DbSkip())
	
End

ConOut("[BoletoFraude] - Finalizado")

(cAlias1)->(dbCloseArea())

Return


//RESET ENVIRONMENT
	
