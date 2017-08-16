#INCLUDE "PROTHEUS.CH"           
#INCLUDE "Totvs.ch"
#INCLUDE "FILEIO.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "AP5MAIL.CH"


/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa  � Cobindevida  � Autor � Rogerio Machado    � Data  � 14/06/17 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Alerta de boletos fraudados                                   ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
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
Local cTabela   := "%EXCEL...TABELA%"


BeginSql alias cAliasSA1

	SELECT A1_EMAIL FROM %Exp:cTabela%
	ORDER BY A1_EMAIL

EndSql

ConOut("[CobIndevida] - Disparando e-mails")

(cAliasSA1)->(DbGoTop())

While (cAliasSA1)->(!Eof())

	oProcess := TWFProcess():New("COBINDEVIDA","COBINDEVIDA")
	oProcess:NewTask("Enviando Notifica��o de Cobran�a Indevida",cArquivo)
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

