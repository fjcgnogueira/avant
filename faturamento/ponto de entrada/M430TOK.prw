#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � M430TOK  � Autor � Fernando Nogueira  � Data � 23/08/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Antes da Altercao/Inclusao de Reserva    ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function M430TOK()

If Altera .And. !Empty(SC0->C0_SOLICIT) .And. AllTrim(SC0->C0_SOLICIT) <> AllTrim(cUserName) .And. aScan(PswRet(1)[1][10],'000000') == 0
	ApMsgInfo("Altera��o liberada somente para o mesmo usu�rio que fez a reserva: "+AllTrim(SC0->C0_SOLICIT))
	Return .F.
Endif

Return .T.
