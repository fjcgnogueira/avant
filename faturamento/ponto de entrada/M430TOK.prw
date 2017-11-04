#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"
#include "apvt100.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � M430TOK  � Autor � Fernando Nogueira  � Data � 23/08/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Antes da Alteracao/Inclusao de Reserva   ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function M430TOK()

//Local aAreaSC0  := SC0->(GetArea())

//SC0->(dbSetOrder(01))
//SC0->(dbGoTop())
//SC0->(dbSeek(xFilial("SC0")+cNum))

If Altera .And. !Empty(SC0->C0_SOLICIT) .And. AllTrim(SC0->C0_SOLICIT) <> AllTrim(cUserName) .And. aScan(PswRet(1)[1][10],'000000') == 0
	ApMsgInfo("Altera��o liberada somente para o mesmo usu�rio que fez a reserva: "+AllTrim(SC0->C0_SOLICIT))
	Return .F.
Endif

//SC0->(Restarea(aAreaSC0))

Return .T.
