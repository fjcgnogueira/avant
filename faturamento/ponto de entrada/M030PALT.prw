#INCLUDE "Protheus.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030PALT � Autor � Rogerio Machado    � Data �  12/08/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada alteracao no cadastro de clientes.        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M030PALT()

Local cPara    := SA1->A1_EMAIL
Local cBCC     := "rogerio.machado@avantlux.com.br; tecnologia@avantlux.com.br"
Local cAssunto := "Bem-vindo � Avant"

	cLog := "<html><body>"
	cLog += "<img src='http://avantled.com.br/BI/Bem%20Vindo.png'/>
	cLog += "</body></html>"

	If 	SA1->A1_X_WFLOW = " " .AND. SA1->A1_MSBLQL = "2"
		U_MHDEnvMail(cPara, "", cBCC, cAssunto, cLog, "")
		SA1->(RecLock("SA1",.F.))
		SA1->A1_X_WFLOW := "S"
		SA1->(MsUnlock())
	EndIf

Return
